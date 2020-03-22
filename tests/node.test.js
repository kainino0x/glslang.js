const glslangModule = require("../dist/node-devel/glslang.js");

const glslang = glslangModule();

const glslEmpty450 = `#version 450
void main() {}`;

describe("empty shader compile", () => {
  it("compiles as vertex shader", () => {
    const code = glslang.compileGLSL(glslEmpty450, "vertex");
    expect(code.byteLength).toBeGreaterThan(0);
  });
});
