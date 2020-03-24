//import glslangModule from "../dist/node-devel/glslang";
const glslangModule = require("../dist/node-devel/glslang");

const glslang = glslangModule();

const glslEmpty310es = `#version 310 es
void main() {}`;
const glslEmpty450 = `#version 450
void main() {}`;
const glslTextureSampler = `#version 310 es
layout(set = 0, binding = 0) uniform texture2D t;
layout(set = 0, binding = 1) uniform mediump sampler s;
void main() {}`;

function runTest(type, glslcode) {
  it("compiles for spirv 1.3 nodebug", () => {
    const code = glslang.compileGLSL(glslcode, type, false, "1.3");
    expect(code.byteLength).toBeGreaterThan(0);
    const result = glslang.compileGLSLZeroCopy(glslcode, type, false, "1.3");
    try {
      expect(result.data.byteLength).toBeGreaterThan(0);
    } finally {
      result.free();
    }
  });

  it("compiles for spirv 1.3 debug", () => {
    const code = glslang.compileGLSL(glslcode, type, true, "1.3");
    expect(code.byteLength).toBeGreaterThan(0);
    const result = glslang.compileGLSLZeroCopy(glslcode, type, true, "1.3");
    try {
      expect(result.data.byteLength).toBeGreaterThan(0);
    } finally {
      result.free();
    }
  });

  it("compiles for spirv 1.0 nodebug", () => {
    const code = glslang.compileGLSL(glslcode, type, false, "1.0");
    expect(code.byteLength).toBeGreaterThan(0);
    const result = glslang.compileGLSLZeroCopy(glslcode, type, false, "1.0");
    try {
      expect(result.data.byteLength).toBeGreaterThan(0);
    } finally {
      result.free();
    }
  });

  it("compiles with defaults", () => {
    const code = glslang.compileGLSL(glslcode, type);
    expect(code.byteLength).toBeGreaterThan(0);
    const result = glslang.compileGLSLZeroCopy(glslcode, type);
    try {
      expect(result.data.byteLength).toBeGreaterThan(0);
    } finally {
      result.free();
    }
  });
}

describe("empty shader compile", () => {
  describe("compiles glsl 450", () => {
    const shaderCode = glslEmpty450;
    describe("compiles vertex shader", () => {
      runTest("vertex", shaderCode);
    });
  });

  describe("compiles glsl 310es", () => {
    const shaderCode = glslEmpty310es;
    describe("compiles vertex shader", () => {
      runTest("vertex", shaderCode);
    });
  });

  describe("compiles glsl 310es with texture sampler", () => {
    const shaderCode = glslTextureSampler;
    describe("compiles vertex shader", () => {
      runTest("vertex", shaderCode);
    });
  });
});
