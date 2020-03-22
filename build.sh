#!/bin/bash
set -e
set -x

NUM_CORES=$(nproc)

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
    make -j $(( $NUM_CORES )) glslang.js
    popd
    mkdir -p dist/$type
    cp glslang.d.ts dist/$type/

    cp build/$type/glslang/OSDependent/Web/glslang.js dist/$type/
    gzip -9 -k -f dist/$type/glslang.js
    brotli     -f dist/$type/glslang.js
    if [ -e build/$type/glslang/OSDependent/Web/glslang.wasm ] ; then
        cp build/$type/glslang/OSDependent/Web/glslang.wasm dist/$type/
        gzip -9 -k -f dist/$type/glslang.wasm
        brotli     -f dist/$type/glslang.wasm
    fi
}

update_grammar() {
    pushd glslang/glslang
    ./updateGrammar "$@"
    popd
}
reset_grammar() {
    git -C glslang checkout glslang/MachineIndependent/glslang_tab.cpp{,.h}
    git -C glslang checkout glslang/MachineIndependent/glslang.y
}

configs=$@
if [ $# -eq 0 ]; then
    echo "Building all configs by default"
    configs="\
        web-min-nocompute\
        web-devel-nocompute\
        web-devel\
        web-devel-onefile\
        node-devel\
        " 
fi

update_grammar web
if [[ " $configs " =~ .*\ (web-min-nocompute)\ .* ]]; then
    echo Building ${BASH_REMATCH[1]}
    build web-min-nocompute\
        -DENABLE_GLSLANG_JS=ON\
        -DENABLE_GLSLANG_WEBMIN=ON\
        -DENABLE_GLSLANG_WEBMIN_DEVEL=OFF
fi

if [[ " $configs " =~ .*\ (web-devel-nocompute)\ .* ]]; then
    echo Building ${BASH_REMATCH[1]}
    build web-devel-nocompute\
        -DENABLE_GLSLANG_JS=ON\
        -DENABLE_GLSLANG_WEBMIN=ON\
        -DENABLE_GLSLANG_WEBMIN_DEVEL=ON
fi

update_grammar
if [[ " $configs " =~ .*\ (web-devel)\ .* ]]; then
    echo Building ${BASH_REMATCH[1]}
    build web-devel\
        -DENABLE_GLSLANG_JS=ON\
        -DENABLE_GLSLANG_WEBMIN=OFF
fi

if [[ " $configs " =~ .*\ (web-devel-onefile)\ .* ]]; then
    echo Building ${BASH_REMATCH[1]}
    build web-devel-onefile\
        -DENABLE_GLSLANG_JS=ON\
        -DENABLE_GLSLANG_WEBMIN=OFF\
        -DENABLE_EMSCRIPTEN_SINGLE_FILE=ON
fi

if [[ " $configs " =~ .*\ (node-devel)\ .* ]]; then
    echo Building ${BASH_REMATCH[1]}
    build node-devel\
        -DENABLE_GLSLANG_JS=ON\
        -DENABLE_GLSLANG_WEBMIN=OFF\
        -DENABLE_EMSCRIPTEN_ENVIRONMENT_NODE=ON
fi

reset_grammar

wc -c dist/*/*
