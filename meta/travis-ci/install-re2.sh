#!/bin/bash
#
# Installation script to run from the Travis config file before
# attempting a build.
#
# Install re2 0.3.2 under the  directory "/tmp/mine".  We assume the
# script is run from the top directory of the build tree.

PROGNAME=install-re2.sh
STEM=re2-0.3.2
ARCHIVE="${STEM}.tar.xz"
SOURCE_URI="https://bitbucket.org/marcomaggi/re2/downloads/${ARCHIVE}"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"

if ! test -x /usr/bin/g++-5
then
    printf '%s: required g++ compiler not present\n' "$PROGNAME" >&2
    exit 1
fi

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

if ! ./configure --prefix=/tmp/mine CXX=/usr/bin/g++-5
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

if ! make
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

if ! make install
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

exit 0

# Local Variables:
# mode: sh
# End:
