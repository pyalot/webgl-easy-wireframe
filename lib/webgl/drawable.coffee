return class Drawable
    float_size = Float32Array.BYTES_PER_ELEMENT

    constructor: () ->
        @first = 0
        @size = 0
        @buffer = @gl.createBuffer()
        @mode = @gl.TRIANGLES

    setPointer: (shader, name, size=3, start=0, stride=0) ->
        location = shader.attribLoc name
        if location >= 0
            @gl.vertexAttribPointer location, size, @gl.FLOAT, false, stride*float_size, start*float_size
        return @
    
    draw: (shader) ->
        if shader then @setPointersForShader shader
        @gl.drawArrays @mode, @first, @size
        if shader then @disableAttribs shader
        return @

    disableAttribs: (shader) ->
        for name in @attribs
            location = shader.attribLoc name
            if location >= 0 then @gl.disableVertexAttribArray location
        return @

    uploadList: (list) ->
        data = new Float32Array list
        @upload data
      
    upload: (data) ->
        @gl.bindBuffer @gl.ARRAY_BUFFER, @buffer
        @gl.bufferData @gl.ARRAY_BUFFER, data, @gl.STATIC_DRAW
        @gl.bindBuffer @gl.ARRAY_BUFFER, null
