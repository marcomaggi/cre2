# @configure_input@
#

AC_PREREQ([2.68])
MMUX_PKG_VERSIONS([0],[3],[6],[devel.0])
AC_INIT([CRE2],[MMUX_PACKAGE_VERSION],[marco.maggi-ipsu@poste.it],
  [cre2],[http://github.com/marcomaggi/cre2/])
MMUX_INIT
MMUX_LIBTOOL_LIBRARY_VERSIONS([cre2],0,0,0)
AC_REVISION([1.0])
AC_COPYRIGHT([This license is meant to be the "BSD-3-Clause".

Copyright (c) 2012, 2013, 2015, 2016, 2017, 2019 Marco Maggi <marco.maggi-ipsu@poste.it>
Copyright (c) 2011 Keegan McAllister
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of  source code must retain the above  copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions  in binary  form must reproduce  the above  copyright notice,
   this list  of conditions  and the following  disclaimer in  the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the author nor  the names of his contributors may be used
   to endorse  or promote products  derived from this software  without specific
   prior written permission.

THIS SOFTWARE  IS PROVIDED BY THE  COPYRIGHT HOLDERS AND CONTRIBUTORS  ``AS IS''
AND  ANY EXPRESS  OR  IMPLIED WARRANTIES,  INCLUDING, BUT  NOT  LIMITED TO,  THE
IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A  PARTICULAR PURPOSE ARE
DISCLAIMED.  IN  NO EVENT SHALL  THE AUTHORS OR  CONTRIBUTORS BE LIABLE  FOR ANY
DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES
(INCLUDING, BUT  NOT LIMITED  TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES;
LOSS OF USE,  DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER CAUSED AND ON
ANY  THEORY  OF  LIABILITY,  WHETHER  IN CONTRACT,  STRICT  LIABILITY,  OR  TORT
(INCLUDING NEGLIGENCE OR  OTHERWISE) ARISING IN ANY  WAY OUT OF THE  USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_MACRO_DIR([meta/autotools])
AC_CONFIG_AUX_DIR([meta/autotools])
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([foreign subdir-objects])
AM_MAINTAINER_MODE

AM_PROG_AR
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P

LT_PREREQ([2.4])
LT_INIT


#### basic system inspection

MMUX_CHECK_TARGET_OS
AX_IS_RELEASE([git-directory])

AC_LANG([C])
MMUX_LANG_C99
AC_PROG_CC_C_O

AC_LANG([C++])
AC_PROG_CXX
MMUX_LANG_CXX11
AC_PROG_CXX_C_O


#### external libraries

# This macro is available since  "pkg-config" version 0.27, which is not
# available everywhere.  In some future we will uncomment this and start
# using it.  (Marco Maggi; Feb 19, 2019)
#
# PKG_INSTALLDIR

AX_PTHREAD
MMUX_CHECK_RE2

AC_CACHE_SAVE


#### finish

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile]
   [meta/scripts/cre2.pc])
MMUX_OUTPUT
AC_OUTPUT

### end of file
