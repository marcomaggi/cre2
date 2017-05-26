#!/bin/bash
#
# Installation script to run from the Travis CI config file before
# attempting a build.
#
# Install re2 0.3.4 under the  directory "/tmp/mine".  We assume the
# script is run from the top directory of the build tree.

PROGNAME=install-re2.sh
VERSION=0.3.4
STEM="re2-${VERSION}"
ARCHIVE="${STEM}.tar.gz"
SOURCE_URI="https://github.com/marcomaggi/re2/archive/v${VERSION}.tar.gz"
LOCAL_ARCHIVE="/tmp/${ARCHIVE}"
TOP_SRCDIR="/tmp/${STEM}"

# We  expect  CRE2_REQUESTED_CXX to  be  set  in  the environment  if  a
# specific compiler is requested.
SELECTED_CXX="$CRE2_REQUESTED_CXX"
if   test -n "$CRE2_REQUESTED_CXX" -a -x "$CRE2_REQUESTED_CXX"
then SELECTED_CXX="$CRE2_REQUESTED_CXX"
elif test -x /usr/bin/g++-7; then SELECTED_CXX=/usr/bin/g++-7
elif test -x /usr/bin/g++-6; then SELECTED_CXX=/usr/bin/g++-6
elif test -x /usr/bin/g++-5; then SELECTED_CXX=/usr/bin/g++-5
else
    printf '%s: required C++ compiler not present (CRE2_REQUESTED_CXX=%s)\n' "$PROGNAME" "$CRE2_REQUESTED_CXX" >&2
    exit 1
fi

printf '%s: selected CXX=%s\n' "$PROGNAME" "$SELECTED_CXX" >&2
if ! "$SELECTED_CXX" --version
then
    printf '%s: error showing CXX compiler version %s\n' "$PROGNAME" "${ARCHIVE}" >&2
    exit 1
fi

test -d /tmp/mine || {
    if ! mkdir /tmp/mine
    then
	printf '%s: error creating directory for dependency package building and installation\n' "$PROGNAME" >&2
	exit 1
    fi
}

echo "wget \"$SOURCE_URI\" -O \"$LOCAL_ARCHIVE\"" >&2
if ! wget "$SOURCE_URI" -O "$LOCAL_ARCHIVE"
then
    printf '%s: error downloading %s\n' "$PROGNAME" "${ARCHIVE}" >&2
    exit 1
fi

cd /tmp

echo "tar -xzf \"$LOCAL_ARCHIVE\"" >&2
if ! tar -xzf "$LOCAL_ARCHIVE"
then
    printf '%s: error unpacking %s\n' "$PROGNAME" "$LOCAL_ARCHIVE" >&2
    exit 1
fi

if ! cd "$TOP_SRCDIR"
then
    printf '%s: error changing directory to %s\n' "$PROGNAME" "${TOP_SRCDIR}" >&2
    exit 1
fi

echo "sh autogen.sh" >&2
if [[ "$TRAVIS_OS_NAME" == "osx" ]]
then
    if ! LIBTOOLIZE=glibtoolize sh autogen.sh
    then
	printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
	exit 1
    fi
else
    if ! sh autogen.sh
    then
	printf '%s: error configuring %s\n' "$PROGNAME" "${STEM}" >&2
	exit 1
    fi
fi

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
