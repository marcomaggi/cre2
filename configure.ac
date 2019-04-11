dnl @configure_input@
dnl

AC_PREREQ([2.68])
AC_INIT([CRE2],[0.3.6],[marco.maggi-ipsu@poste.it],
  [cre2],[http://github.com/marcomaggi/cre2/])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_MACRO_DIR([meta/autotools])
AC_CONFIG_AUX_DIR([meta/autotools])
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([1.14 foreign subdir-objects dist-xz no-dist-gzip -Wall])
AM_MAINTAINER_MODE

AM_PROG_AR
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P

LT_PREREQ([2.4])
LT_INIT

AC_PROG_CC_C99
AC_PROG_CC_C_O

AC_LANG([C++])
AC_PROG_CXX
AC_PROG_CXX_C_O

AX_CXX_COMPILE_STDCXX_11(noext,mandatory)

# This  defines RE2_LIBS  and  RE2_CFLAGS.  We  do  not specify  version
# requirements  for the  "re2"  pkg-config module  because the  original
# "re2.pc" file from Google does not specify any version number.  (Marco
# Maggi; Apr 30, 2017)
PKG_CHECK_MODULES([RE2],[re2])

dnl AC_CHECK_LIB([re2],[main],,[AC_MSG_FAILURE([test for RE2 library failed])])
dnl AC_CHECK_HEADERS([re2/re2.h],,[AC_MSG_ERROR([test for RE2 header failed])])

cre2_VERSION_INTERFACE_CURRENT=0
cre2_VERSION_INTERFACE_REVISION=0
cre2_VERSION_INTERFACE_AGE=0
AC_DEFINE_UNQUOTED([cre2_VERSION_INTERFACE_CURRENT],
  [$cre2_VERSION_INTERFACE_CURRENT],
  [current interface number])
AC_DEFINE_UNQUOTED([cre2_VERSION_INTERFACE_REVISION],
  [$cre2_VERSION_INTERFACE_REVISION],
  [current interface implementation number])
AC_DEFINE_UNQUOTED([cre2_VERSION_INTERFACE_AGE],
  [$cre2_VERSION_INTERFACE_AGE],
  [current interface age number])
AC_DEFINE_UNQUOTED([cre2_VERSION_INTERFACE_STRING],
  ["$cre2_VERSION_INTERFACE_CURRENT.$cre2_VERSION_INTERFACE_REVISION"],
  [library interface version])
AC_SUBST([cre2_VERSION_INTERFACE_CURRENT])
AC_SUBST([cre2_VERSION_INTERFACE_REVISION])
AC_SUBST([cre2_VERSION_INTERFACE_AGE])

dnl This is the version stored in the pkg-config data file.
AC_SUBST([CRE2_PKG_CONFIG_VERSION],[0.3.6])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile]
   [meta/scripts/cre2.pc])
AC_OUTPUT

dnl end of file
