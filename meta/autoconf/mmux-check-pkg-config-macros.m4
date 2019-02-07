### mmux-check-pkg-config-macros.m4 --
#
# Test  if the  macro  PKG_CHECK_MODULES is  defined at  macro-expansion
# time.  This test  works only if the file  "configure.ac" also contains
# an actual expansion of PKG_CHECK_MODULES.
#
AC_DEFUN([MMUX_CHECK_PKG_CONFIG_MACROS],
  [AC_MSG_CHECKING([availability of pkg-config m4 macros])
   AS_IF([test m4_ifdef([PKG_CHECK_MODULES],[yes],[no]) == yes],
     [AC_MSG_RESULT([yes])],
     [AC_MSG_RESULT([no])
      AC_MSG_ERROR([pkg-config is required.  See pkg-config.freedesktop.org])])])

### end of file
# Local Variables:
# mode: autoconf
# End:
