schedule = require 'schedule'
loading = require 'loading'
camera = require 'camera'
Cube = require 'webgl/cube'

$('*').each ->
    $(@)
        .attr('unselectable', 'on')
        .css
           '-moz-user-select':'none',
           '-webkit-user-select':'none',
           'user-select':'none',
           '-ms-user-select':'none'
    @onselectstart = -> false

class Model extends require('webgl/drawable')
    attribs: ['position']

    constructor: (@gl, data) ->
        super()
        @size = data.byteLength/(3*4)
        buffer = new Float32Array(@size*3*2)
        buffer.set new Float32Array(data), 0

        for i in [@size*3...@size*2*3] by 9
            buffer[i+0] = 1; buffer[i+1] = 0; ; buffer[i+2] = 0
            buffer[i+3] = 0; buffer[i+4] = 1; ; buffer[i+5] = 0
            buffer[i+6] = 0; buffer[i+7] = 0; ; buffer[i+8] = 1

        @upload buffer

    setPointersForShader: (shader) ->
        @gl.bindBuffer @gl.ARRAY_BUFFER, @buffer
        @setPointer shader, 'position', 3, 0, 3
        @setPointer shader, 'barycentric', 3, @size*3, 3

        return @

exports.Application = class
    constructor: (@canvas) ->
        loading.hide()
        @camera = new camera.Orbit(near: 0.001, far: 100)
        @transparent = get 'transparent.shader'
        @overlay = get 'overlay.shader'
        @geom = new Model gl, get('bunny.mesh')
        $(window).resize @resize
        @resize()
        schedule.run @update
        gl.enable gl.DEPTH_TEST

        container = $('<div></div>')
            .css('margin', 10)
            .appendTo('#ui')
       
        $('<span>Transparent</span>')
            .appendTo(container)
        input = $('<input type="checkbox">')
            .appendTo(container)
            .change =>
                if input[0].checked
                    @show_transparent = true
                else
                    @show_transparent = false

    resize: =>
        @width = @canvas.width()
        @height = @canvas.height()

        @canvas[0].width = @width
        @canvas[0].height = @height
        gl.viewport 0, 0, @width, @height
        @camera.aspect @width, @height

    update: =>
        @step()
        if @show_transparent
            @drawTransparent()
        else
            @drawOverlay()
        
    step: ->
        @camera.update()

    drawOverlay: ->
        gl.disable gl.SAMPLE_ALPHA_TO_COVERAGE
        gl.disable gl.BLEND
        @overlay.use()
            .mat4('proj', @camera.proj)
            .mat4('view', @camera.view)
            .draw(@geom)

    drawTransparent: ->
        gl.enable gl.SAMPLE_ALPHA_TO_COVERAGE
        gl.enable gl.BLEND
        gl.blendFunc gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA
        @transparent.use()
            .mat4('proj', @camera.proj)
            .mat4('view', @camera.view)
            .draw(@geom)

