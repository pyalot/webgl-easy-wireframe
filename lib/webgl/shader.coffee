current = null

return class Shader
    constructor: (@gl, source) ->
        @program    = @gl.createProgram()
        @vs         = @gl.createShader gl.VERTEX_SHADER
        @fs         = @gl.createShader gl.FRAGMENT_SHADER

        @gl.attachShader @program, @vs
        @gl.attachShader @program, @fs

        @link source

    preprocess: (source) ->
        lines = source.split '\n'
        shaders = {'global': '', 'fragment': '', 'vertex': ''}
        type = 'global'
        for line, i in lines
            match = line.match /^(\w+):$/
            if match
                type = match[1]
            else
                shaders[type] += '#line ' + i + '\n' + line + '\n'

        directives = [
            'precision highp int;',
            'precision highp float;',
            'precision highp vec2;',
            'precision highp vec3;',
            'precision highp vec4;',
        ].join('\n') + '\n'

        shaders.fragment = directives + shaders.global + shaders.fragment
        shaders.vertex = directives + shaders.global + shaders.vertex
        return shaders

    link: (source) ->
        shaders = @preprocess source
        @compile @vs, shaders.vertex
        @compile @fs, shaders.fragment
        @gl.linkProgram @program

        if not @gl.getProgramParameter @program, @gl.LINK_STATUS
            throw "Shader Link Error: #{@gl.getProgramInfoLog(@program)}"

        @attrib_cache = {}
        @uniform_cache = {}
            
    compile: (shader, source) ->
        @gl.shaderSource shader, source
        @gl.compileShader shader

        if not @gl.getShaderParameter shader, @gl.COMPILE_STATUS
            throw "Shader Compile Error: #{@gl.getShaderInfoLog(shader)}"
        return

    attribLoc: (name) ->
        location = @attrib_cache[name]
        if location is undefined
            location = @attrib_cache[name] = @gl.getAttribLocation @program, name
        @gl.enableVertexAttribArray location if location >= 0
        return location

    use: ->
        @gl.useProgram @program
        return @

    loc: (name) ->
        location = @uniform_cache[name]
        if location is undefined
            location = @uniform_cache[name] = @gl.getUniformLocation @program, name
        return location

    i: (name, value) ->
        loc = @loc name
        @gl.uniform1i loc, value if loc
        return @

    f: (name, value) ->
        loc = @loc name
        @gl.uniform1f loc, value if loc
        return @
    
    val2: (name, a, b) ->
        loc = @loc name
        @gl.uniform2f loc, a, b if loc
        return @
    
    val3: (name, a, b, c) ->
        loc = @loc name
        @gl.uniform3f loc, a, b, c if loc
        return @
    
    vec3: (name, value) ->
        loc = @loc name
        @gl.uniform3fv loc, value if loc
        return @

    val4: (name, a, b, c, d) ->
        loc = @loc name
        @gl.uniform4f loc, a, b, c, d if loc
        return @
    
    vec4: (name, a, b, c, e) ->
        loc = @loc name
        @gl.uniform2f loc, a, b, c, e if loc
        return @

    mat4: (name, value) ->
        loc = @loc name
        if loc
            if value instanceof Mat4
                @gl.uniformMatrix4fv loc, @gl.FALSE, value.data
            else
                @gl.uniformMatrix4fv loc, @gl.FALSE, value
        return @

    mat3: (name, value) ->
        loc = @loc name
        @gl.uniformMatrix3fv loc, @gl.FALSE, value.data if loc
        return @

    draw: (drawable) ->
        drawable
            .setPointersForShader(@)
            .draw()
            .disableAttribs(@)
        return @
