declare type ShaderType = 'vertex' | 'fragment' | 'compute';

declare interface ResultZeroCopy {
    readonly data: Uint32Array;
    free(): void;
}

declare interface Glslang {
    compileGLSLZeroCopy(glsl: string, shader_type: ShaderType, gen_debug: boolean): ResultZeroCopy;
    compileGLSL(glsl: string, shader_type: ShaderType, gen_debug: boolean): Uint32Array;
}

declare interface GlslangModule {
    then(f: (m: Glslang) => void): void;
}

export function glslangModule(): GlslangModule;
