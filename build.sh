#!/bin/sh
set -e
set -x

# Web build

mkdir -p build-web

pushd build-web
emconfigure cmake -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_AMD_EXTENSIONS=OFF \
    -DENABLE_NV_EXTENSIONS=OFF \
    -DENABLE_HLSL=OFF \
    -DENABLE_EMSCRIPTEN_SINGLE_FILE=OFF \
    ../glslang
ninja glslang.js
popd

mkdir -p web
cp build-web/glslang/glslang.{js,wasm} web/

# Node build

mkdir -p build-node

pushd build-node
emconfigure cmake -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_AMD_EXTENSIONS=OFF \
    -DENABLE_NV_EXTENSIONS=OFF \
    -DENABLE_HLSL=OFF \
    -DENABLE_EMSCRIPTEN_SINGLE_FILE=OFF \
    -DEMSCRIPTEN_ENVIRONMENT_NODE=ON \
    ../glslang
ninja glslang.js
popd

mkdir -p dist
cp build-node/glslang/glslang.{js,wasm} dist/
