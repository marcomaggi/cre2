#!/bin/bash
#
# Installation  script to  run from  the  Travis CI  config file  before
# attempting a build.
#
# Install GNU Automake under the directory "/usr/local".  We assume the
# script is run from the top directory of the build tree.

PROGNAME=${0##*/}
PACKAGE_NAME=automake
REQUIRED_PACKAGE_VERSION=1.16.1
STEM=${PACKAGE_NAME}-${REQUIRED_PACKAGE_VERSION}
VERSION_EXECUTABLE=$PACKAGE_NAME
ARCHIVE=${STEM}.tar.gz
SOURCE_URI=http://marcomaggi.github.io/binaries/${ARCHIVE}
LOCAL_ARCHIVE=/tmp/${ARCHIVE}
TOP_SRCDIR=/tmp/${STEM}
prefix=/usr/local

function main () {
    # We install the new package only if it is not already installed.
    if type -p "$VERSION_EXECUTABLE"
    then
	if "$VERSION_EXECUTABLE" --version | fgrep "$REQUIRED_PACKAGE_VERSION"
	then exit 0
	fi
    fi

    if ! wget --no-check-certificate "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
    then script_error 'error downloading %s' "$ARCHIVE"
    fi

    cd /tmp

    if ! tar --extract --gzip --file="$LOCAL_ARCHIVE"
    then script_error 'error unpacking %s' "$LOCAL_ARCHIVE"
    fi

    cd "$TOP_SRCDIR"

    if ! ./configure --prefix="$prefix" --with-internal-glib
    then script_error 'error configuring %s' "$STEM"
    fi

    if ! make -j2 all
    then script_error 'error building all %s' "$STEM"
    fi

    if ! (umask 0; sudo make install)
    then script_error 'error installing %s' "$STEM"
    fi

    exit 0
}

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

main "$@"

### end of file
