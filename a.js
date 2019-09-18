const glslangModule = require('.');

glslangModule().then(glslang => {
    console.log(glslang.compileGLSL(`#version 310 es
        void main() {}`, 'fragment', false));
});
