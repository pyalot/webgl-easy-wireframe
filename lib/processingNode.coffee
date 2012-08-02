{Framebuffer} = require 'webgl/framebuffer'
Quad = require 'webgl/quad'

return class ProcessingNode
    constructor: (@gl) ->
        @fbo = new Framebuffer @gl
        @quad = new Quad @gl
        @sources = []
        @params = []

    program: (program) ->
        @_program = program
        return @

    addSource: (name, texture) ->
        @sources.push
            name: name,
            texture: texture
        return @

    target: (texture) ->
        @width = texture.width
        @height = texture.width
        @fbo.bind().color(texture).unbind()
        return @

    setUniform: (call, name, value) ->
        for obj in @params
            if obj.name == name
                obj.value = value
                obj.call = call
                return @

        @params.push
            name: name
            value: value
            call: call
        return @

    compute: ->
        viewport = @gl.getParameter @gl.VIEWPORT
        @gl.disable @gl.DEPTH_TEST
        @gl.depthMask false
        @gl.disable @gl.CULL_FACE
        @gl.viewport 0, 0, @width, @height

        @fbo.bind()
        @_program
            .use()
            .val2('viewport', @width, @height)

        for obj, i in @sources
            obj.texture.bind(i)
            @_program.i(obj.name, i)

        for param in @params
            @_program[param.call](param.name, param.value)

        @_program.draw(@quad)
        @fbo.unbind()
        @gl.viewport.apply @gl, viewport
        return @
