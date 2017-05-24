#!/bin/bash
#
# Installation script to run from the Travis config file before
# attempting a build.
#
# Install re2 0.3.3 under the  directory "/tmp/mine".  We assume the
# script is run from the top directory of the build tree.

PROGNAME=install-re2.sh
STEM=re2-0.3.3
ARCHIVE="${STEM}.tar.xz"
SOURCE_URI="https://bitbucket.org/marcomaggi/re2/downloads/${ARCHIVE}"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"

SELECTED_CXX=
if test -x /usr/bin/g++-5
then SELECTED_CXX=/usr/bin/gcc++-5
elif test -x /usr/bin/g++-6
then SELECTED_CXX=/usr/bin/gcc++-6
elif test -x /usr/bin/g++-7
then SELECTED_CXX=/usr/bin/gcc++-7
else
    printf '%s: required g++ compiler not present\n' "$PROGNAME" >&2
    exit 1
fi

printf '%s: selected CXX=%s\n' "$PROGNAME" "$SELECTED_CXX" >&2
"$SELECTED_CXX" --version

test -d /tmp/mine || mkdir --mode=0755 /tmp/mine

if ! wget "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
then
    printf '%s: error downloading %s\n' "$PROGNAME" "${ARCHIVE}" >&2
    exit 1
fi

cd /tmp

if ! tar -xJf "$LOCAL_ARCHIVE"
then
    printf '%s: error unpacking %s\n' "$PROGNAME" "$LOCAL_ARCHIVE" >&2
    exit 1
fi

cd "$TOP_SRCDIR"

echo "./configure --prefix=/tmp/mine CXX=\"$SELECTED_CXX\"" >&2
if ! ./configure --prefix=/tmp/mine CXX="$SELECTED_CXX"
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

echo "make -j2 all" >&2
if ! make -j2 all
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

echo "make install" >&2
if ! make install
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

exit 0

# Local Variables:
# mode: sh
# End:
