# autogen.sh --
#
# Run this in the top source directory to rebuild the infrastructure.

set -xe

test -d m4 || mkdir m4
autoreconf --force --install
# --verbose

# aclocal
# autoheader
# automake --foreign --add-missing
# autoconf

### end of file
