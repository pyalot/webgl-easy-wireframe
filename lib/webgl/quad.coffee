return class Quad extends require('drawable')
    attribs: ['position']

    constructor: (@gl) ->
        super()
        @size = 6

        vertices = [
            -1, -1,  1, -1,  1, 1,
            -1, -1,  1, 1,  -1, 1,
        ]

        @uploadList vertices

    setPointersForShader: (shader) ->
        @gl.bindBuffer @gl.ARRAY_BUFFER, @buffer
        @setPointer shader, 'position', 2

        return @
