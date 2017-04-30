#!/bin/bash
#
# Installation script to run from the Travis config file before
# attempting a build.
#
# Install pkg-config 0.29.2 under  the directory "/tmp/mine".  We assume
# the script is run from the top directory of the build tree.

PROGNAME=install-pkg-config.sh
STEM=pkg-config-0.29.2
ARCHIVE="${STEM}.tar.gz"
SOURCE_URI="http://pkg-config.freedesktop.org/releases/${ARCHIVE}"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"

test -d /tmp/mine || mkdir --mode=0755 /tmp/mine

# Download the release archive under "/tmp"
if ! wget --no-check-certificate "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
then
    printf '%s: error downloading %s\n' "$PROGNAME" "${ARCHIVE}" >&2
    exit 1
fi

cd /tmp

if ! tar -xzf "$LOCAL_ARCHIVE"
then
    printf '%s: error unpacking %s\n' "$PROGNAME" "$LOCAL_ARCHIVE" >&2
    exit 1
fi

cd "$TOP_SRCDIR"

if ! ./configure --prefix=/tmp/mine
then
    printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
    exit 1
fi

if ! make -j2 all
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
