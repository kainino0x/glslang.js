#!/bin/sh
set -e
set -x

rm -rf build-web/ build-node/
mkdir build-web build-node

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

mkdir -p web dist
cp build-web/glslang/glslang.{js,wasm} web/
cp build-node/glslang/glslang.{js,wasm} dist/
