varying vec3 vBC;

vertex:
    attribute vec3 position, barycentric;
    uniform mat4 proj, view;
    void main(){
        vBC = barycentric;
        gl_Position = proj * view * vec4(position, 1.0);
    }

fragment:
    #extension GL_OES_standard_derivatives : enable
    float edgeFactor(){
        vec3 d = fwidth(vBC);
        vec3 a3 = smoothstep(vec3(0.0), d*0.95, vBC);
        return min(min(a3.x, a3.y), a3.z);
    }

    void main(){
        gl_FragColor.rgb = mix(vec3(0.0), vec3(0.5), edgeFactor());
        gl_FragColor.a = 1.0;
    }
