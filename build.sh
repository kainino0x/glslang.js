#!/bin/sh
set -e
set -x

pushd glslang
rm -rf build/
mkdir build
cd build
emconfigure cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_AMD_EXTENSIONS=OFF -DENABLE_NV_EXTENSIONS=OFF -DENABLE_HLSL=OFF -DENABLE_EMSCRIPTEN_SINGLE_FILE=OFF ..
ninja glslang.js
popd

mkdir -p dist
cp glslang/build/glslang/glslang.{js,wasm} dist/
