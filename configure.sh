#!/bin/bash
# configure.sh --
#
# Run this to configure.

set -xe

prefix=/usr/local
if test -d /lib64
then libdir=${prefix}/lib64
else libdir=${prefix}/lib
fi

../configure \
    --config-cache                              \
    --cache-file=../config.cache                \
    --enable-maintainer-mode                    \
    --disable-static --enable-shared            \
    --prefix="${prefix}"                        \
    --libdir="${libdir}"			\
    CFLAGS='-pedantic -O3 -Wextra'		\
    CXXFLAGS='-pedantic -O3 -Wextra'		\
    LDFLAGS="-L${libdir}"			\
    "$@"

### end of file
