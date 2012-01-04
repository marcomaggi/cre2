# configure.sh --
#
# Run this to configure.

set -xe

prefix=/usr/local

../configure \
    --config-cache                              \
    --cache-file=../config.cache                \
    --disable-static --enable-shared            \
    --prefix="${prefix}"                        \
    CFLAGS='-Wall -O3 -march=i686 -mtune=i686'  \
    CXXFLAGS='-Wall -O3 -march=i686 -mtune=i686'\
    "$@"

#--enable-maintainer-mode

### end of file
