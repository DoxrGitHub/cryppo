#!/bin/bash
CURDIR=$(pwd)
mkdir build
cd build
apt-get install gcc-4.8 g++-4.8 -y
export CC=gcc-4.8
export CXX=g++-4.8
cmake  -DUSE_LIBCURL_FROM="${CURL_INSTALL_DIRS}/lib/libcurl.a" -G "Ninja" ..
export LD_LIBRARY_PATH=$CURL_INSTALL_DIRS/libs/:$LD_LIBRARY_PATH
ninja -j8
cd ${CURDIR}
rm -rf curl.tar.bz2 curl-$CURL_VERSION/