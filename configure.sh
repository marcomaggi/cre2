#!/bin/sh
# configure.sh --
#

set -ex

prefix=${prefix:=/opt/re2/2024-07-02/shared}
export PKG_CONFIG_PATH=${prefix}/lib64/pkgconfig:${PKG_CONFIG_PATH}
if test -d /lib64
then libdir=${prefix}/lib64
else libdir=${prefix}/lib
fi

CC='/usr/bin/gcc'
CXX='/usr/bin/g++'

../configure \
    --config-cache				\
    --cache-file=./config.cache			\
    --enable-maintainer-mode                    \
    --disable-static --enable-shared            \
    --prefix="$prefix"				\
    --libdir="$libdir"				\
    CC=$CC					\
    CXX=$CXX					\
    CFLAGS='-O3'				\
    CXXFLAGS='-O3'				\
    "$@"

### end of file
