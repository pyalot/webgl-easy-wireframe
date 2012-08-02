framebufferBinding = null

exports.Framebuffer = class Framebuffer
    constructor: (@gl) ->
        @buffer = @gl.createFramebuffer()

    bind: ->
        if framebufferBinding isnt @
            @gl.bindFramebuffer @gl.FRAMEBUFFER, @buffer
            framebufferBinding = @

        return @

    unbind: ->
        if framebufferBinding isnt null
            @gl.bindFramebuffer @gl.FRAMEBUFFER, null
            framebufferBinding = null

        return @

    check: ->
        result = @gl.checkFramebufferStatus @gl.FRAMEBUFFER
        switch result
            when @gl.FRAMEBUFFER_UNSUPPORTED
                throw 'Framebuffer is unsupported'
            when @gl.FRAMEBUFFER_INCOMPLETE_ATTACHMENT
                throw 'Framebuffer incomplete attachment'
            when @gl.FRAMEBUFFER_INCOMPLETE_DIMENSIONS
                throw 'Framebuffer incomplete dimensions'
            when @gl.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT
                throw 'Framebuffer incomplete missing attachment'
        return @

    color: (texture) ->
        @gl.framebufferTexture2D @gl.FRAMEBUFFER, @gl.COLOR_ATTACHMENT0, texture.target, texture.handle, 0
        @check()
        return @
        
    depth: (buffer) ->
        @gl.framebufferRenderbuffer @gl.FRAMEBUFFER, @gl.DEPTH_ATTACHMENT, @gl.RENDERBUFFER, buffer.id
        @check()
        return @

    destroy: ->
        @gl.deleteFramebuffer @buffer

class Renderbuffer
    constructor: (@gl) ->
        @id = @gl.createRenderbuffer()

    setSize: (width, height) ->
        @gl.bindRenderbuffer @gl.RENDERBUFFER, @id
        @gl.renderbufferStorage @gl.RENDERBUFFER, @gl[@format], width, height
        @gl.bindRenderbuffer @gl.RENDERBUFFER, null
        return @

exports.Depthbuffer = class extends Renderbuffer
    format: 'DEPTH_COMPONENT16'
