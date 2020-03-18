ARG EMSDK_VERSION
FROM trzeci/emscripten:sdk-tag-${EMSDK_VERSION}-64bit

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    bison \
    && rm -rf /var/lib/apt/lists/*

# build brotli (version in apt is too old)
RUN git clone --depth 1 https://github.com/google/brotli.git --branch master --single-branch \
    && cd brotli \
    && mkdir out && cd out \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. \
    && cmake --build . --config Release --target install \
    && cd ../.. && rm -rf brotli
