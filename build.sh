#!/bin/sh
set -e
set -x

build() {
    type=$1
    shift
    args=$@
    mkdir -p build/$type
    pushd build/$type
    echo $args
    emconfigure cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_EMSCRIPTEN_SINGLE_FILE=OFF \
        -DENABLE_HLSL=OFF \
        -DBUILD_TESTING=OFF \
        -DENABLE_OPT=OFF \
        -DINSTALL_GTEST=OFF \
        $args \
        ../../glslang
    make glslang.js
    popd
    mkdir -p dist/$type
    cp build/$type/glslang/OSDependent/Web/glslang.{js,wasm} dist/$type/
    gzip -9 -k -f dist/$type/glslang.{js,wasm}
    brotli     -f dist/$type/glslang.{js,wasm}
}

update_grammar() {
    pushd glslang/glslang
    ./updateGrammar "$@"
    popd
}

update_grammar web
build web-min-nocompute   -DENABLE_GLSLANG_WEB=ON -DENABLE_GLSLANG_WEB_DEVEL=OFF
build web-devel-nocompute -DENABLE_GLSLANG_WEB=ON -DENABLE_GLSLANG_WEB_DEVEL=ON
update_grammar
build web-devel           -DENABLE_GLSLANG_WEB=OFF
build node-devel          -DENABLE_GLSLANG_WEB=OFF -DENABLE_EMSCRIPTEN_ENVIRONMENT_NODE=ON

wc -c dist/*/*
