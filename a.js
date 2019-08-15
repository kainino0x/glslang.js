const glslangModule = require('./dist/glslang.js');

glslangModule().then(glslang => {
    console.log(glslang.compileGLSL(`#version 310 es
        void main() {}`, 'vertex', false));
});
