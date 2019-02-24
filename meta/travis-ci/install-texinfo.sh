#!/bin/bash
#
# Installation  script  to  run  from  the  Travis  config  file  before
# attempting a build.
#
# Install GNU Texinfo  under the directory "/usr/local".   We assume the
# script is run from the top directory of the build tree.

PROGNAME="${0##*/}"
STEM=texinfo-6.6
ARCHIVE="${STEM}.tar.gz"
SOURCE_URI="http://marcomaggi.github.io/binaries/${ARCHIVE}"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"
prefix=/usr/local

function script_error () {
    local TEMPLATE="${1:?missing template argument to '$FUNCNAME'}"
    shift
    {
	printf '%s: ' "$PROGNAME"
	printf "$TEMPLATE" "$@"
	printf '\n'
    } >&2
    exit 1
}

if ! wget "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
then script_error 'error downloading %s' "$ARCHIVE"
fi

cd /tmp

if ! tar --extract --gzip --file="$LOCAL_ARCHIVE"
then script_error 'error unpacking %s' "$LOCAL_ARCHIVE"
fi

cd "$TOP_SRCDIR"

if ! ./configure --prefix="$prefix"
then script_error 'error configuring %s' "$STEM"
fi

if ! make -j2 all
then script_error 'error building all %s' "$STEM"
fi

if ! (umask 0; sudo make install)
then script_error 'error installing %s' "$STEM"
fi

exit 0

### end of file
