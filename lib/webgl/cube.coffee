return class Cube extends require('drawable')
    attribs: ['position', 'normal', 'barycentric']

    constructor: (@gl, s=1) ->
        super()
        @size = 6 * 6
        vertices = [
            -s, -s, -s,  0,  0, -1, 1,0,0,
            -s,  s, -s,  0,  0, -1, 0,1,0,
             s,  s, -s,  0,  0, -1, 0,0,1,
             s, -s, -s,  0,  0, -1, 1,0,0,
            -s, -s, -s,  0,  0, -1, 0,1,0,
             s,  s, -s,  0,  0, -1, 0,0,1,
                                   
             s,  s,  s,  0,  0,  1, 1,0,0,
            -s,  s,  s,  0,  0,  1, 0,1,0,
            -s, -s,  s,  0,  0,  1, 0,0,1,
             s,  s,  s,  0,  0,  1, 1,0,0,
            -s, -s,  s,  0,  0,  1, 0,1,0,
             s, -s,  s,  0,  0,  1, 0,0,1,
                                   
            -s,  s, -s,  0,  1,  0, 1,0,0,
            -s,  s,  s,  0,  1,  0, 0,1,0,
             s,  s,  s,  0,  1,  0, 0,0,1,
             s,  s, -s,  0,  1,  0, 1,0,0,
            -s,  s, -s,  0,  1,  0, 0,1,0,
             s,  s,  s,  0,  1,  0, 0,0,1,
                                   
             s, -s,  s,  0, -1,  0, 1,0,0,
            -s, -s,  s,  0, -1,  0, 0,1,0,
            -s, -s, -s,  0, -1,  0, 0,0,1,
             s, -s,  s,  0, -1,  0, 1,0,0,
            -s, -s, -s,  0, -1,  0, 0,1,0,
             s, -s, -s,  0, -1,  0, 0,0,1,
                                   
            -s, -s, -s, -1,  0,  0, 1,0,0,
            -s, -s,  s, -1,  0,  0, 0,1,0,
            -s,  s,  s, -1,  0,  0, 0,0,1,
            -s,  s, -s, -1,  0,  0, 1,0,0,
            -s, -s, -s, -1,  0,  0, 0,1,0,
            -s,  s,  s, -1,  0,  0, 0,0,1,
                                   
             s,  s,  s,  1,  0,  0, 1,0,0,
             s, -s,  s,  1,  0,  0, 0,1,0,
             s, -s, -s,  1,  0,  0, 0,0,1,
             s,  s,  s,  1,  0,  0, 1,0,0,
             s, -s, -s,  1,  0,  0, 0,1,0,
             s,  s, -s,  1,  0,  0, 0,0,1,
        ]

        @uploadList vertices

    setPointersForShader: (shader) ->
        @gl.bindBuffer @gl.ARRAY_BUFFER, @buffer
        @setPointer shader, 'position', 3, 0, 9
        @setPointer shader, 'normal', 3, 3, 9
        @setPointer shader, 'barycentric', 3, 6, 9

        return @
