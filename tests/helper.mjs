const glslEmpty310es = `#version 310 es
void main() {}`;
const glslEmpty450 = `#version 450
void main() {}`;
const glslTextureSampler = `#version 310 es
layout(set = 0, binding = 0) uniform texture2D t;
layout(set = 0, binding = 1) uniform mediump sampler s;
void main() {}`;

export const testCases = [
    ['fragment', glslEmpty310es    ], ['vertex',   glslEmpty310es    ], ['compute',  glslEmpty310es    ],
    ['fragment', glslEmpty450      ], ['vertex',   glslEmpty450      ], ['compute',  glslEmpty450      ],
    ['fragment', glslTextureSampler], ['vertex',   glslTextureSampler], ['compute',  glslTextureSampler],
];

export function runTest(glslang, type, glslcode) {
    try {
        {
            const code = glslang.compileGLSL(glslcode, type, false);
            const result = glslang.compileGLSLZeroCopy(glslcode, type, false);
            console.log(code.length, result.data.toString());
            result.free();
        }
        {
            const code = glslang.compileGLSL(glslcode, type, true);
            const result = glslang.compileGLSLZeroCopy(glslcode, type, true);
            console.log(code.length, result.data.toString());
            result.free();
        }
    } catch (ex) {
        console.error(ex);
    }
}
