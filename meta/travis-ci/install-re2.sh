#!/bin/bash
#
# Installation  script  to  run  from  the  Travis  config  file  before
# attempting a build.
#
# Install re2 under the directory "/usr/local".  We assume the script is
# run from the top directory of the build tree.

PROGNAME="${0##*/}"
VERSION=2019.1.2
STEM="re2-${VERSION}"
ARCHIVE="${STEM}.tar.gz"
SOURCE_URI="https://github.com/marcomaggi/re2/archive/v${VERSION}.tar.gz"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"
prefix=/usr/local

### ------------------------------------------------------------------------

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

function script_verbose () {
    local TEMPLATE="${1:?missing template argument to '$FUNCNAME'}"
    shift
    {
	printf '%s: command: ' "$PROGNAME"
	printf "$TEMPLATE" "$@"
	printf '\n'
    } >&2
}

### ------------------------------------------------------------------------

script_verbose 'wget "%s" -O "%s"' "$SOURCE_URI" "$LOCAL_ARCHIVE"
if ! wget "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
then script_error 'error downloading %s' "$ARCHIVE"
fi

cd /tmp

script_verbose 'tar --extract --gzip --file="%s"' "$LOCAL_ARCHIVE"
if ! tar --extract --gzip --file="$LOCAL_ARCHIVE"
then script_error 'error unpacking %s' "$LOCAL_ARCHIVE"
fi

cd "$TOP_SRCDIR"

script_verbose 'sh autogen.sh'
if test "$TRAVIS_OS_NAME" = 'osx'
then export LIBTOOLIZE=glibtoolize
fi
if ! sh autogen.sh
then script_error 'error generating configuration %s' "$STEM"
fi

script_verbose './configure --prefix=/tmp/mine --enable-maintainer-mode --enable-shared --disable-static'
if ! ./configure --prefix="$prefix" --enable-maintainer-mode --enable-shared --disable-static
then script_error 'error configuring %s' "$STEM"
fi

script_verbose 'make -j2 all'
if ! make -j2 all
then script_error 'error building all %s' "$STEM"
fi

script_verbose '(umask 0; sudo make install)'
if ! (umask 0; sudo make install)
then script_error 'error installing %s' "$STEM"
fi

exit 0

### end of file
