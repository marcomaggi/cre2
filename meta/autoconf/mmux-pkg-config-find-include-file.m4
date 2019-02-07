## mmux-pkg-config-find-include-file.m4 --
#
# Retrieve  the full  pathname  of a  packge header  file  and define  a
# substitution for it.  To be used, for example, for TAGS generation.
#
# Arguments:
#
# $1 - The module name.
# $2 - The header file name.
#
# Example:
#
#    MMUX_PKG_CONFIG_FIND_INCLUDE_FILE([ccexceptions],[ccexceptions.h])
#
# will declare the substitution "CCEXCEPTIONS_HEADER" to the result of:
#
#    $(pkg-config ccexceptions --variable=includedir)/ccexceptions.h)
#

AC_DEFUN([MMUX_PKG_CONFIG_FIND_INCLUDE_FILE],
  [AC_CACHE_CHECK([include file for pkg-config module $1: $2],
     [mmux_cv_$1_[]AS_TR_CPP($2)[]include_file],
     [AS_IF([MMUX_PKG_CONFIG_MODULE_INCLUDEDIR=$(pkg-config $1 --variable=includedir)],
            [AS_VAR_SET([mmux_cv_$1_[]AS_TR_CPP($2)[]include_file],[$MMUX_PKG_CONFIG_MODULE_INCLUDEDIR/$2])],
            [AS_VAR_SET([mmux_cv_$1_[]AS_TR_CPP($2)[]include_file])])])
   AC_SUBST(AS_TR_CPP([$1_HEADER]), [$mmux_cv_$1_[]AS_TR_CPP($2)[]include_file])
   AS_VAR_APPEND([MMUX_DEPENDENCIES_INCLUDES]," $mmux_cv_$1_[]AS_TR_CPP($2)[]include_file")])

### end of file
# Local Variables:
# mode: autoconf
# End:
