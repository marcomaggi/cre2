### mmux-check-page-shift.m4 --
#
# MMUX_CHECK_PAGE_SHIFT($PAGESIZE)
#
# Determine the number of bits to  right-shift a pointer value to obtain
# the index of  the page (of size  $PAGESIZE) it is in.   Defaults to 12
# which is the  value for a page  size of 4096 bytes.   The test assumes
# that the page size is an exact power of 2.
#
# Set  to  the  value:  the cached  variable  "mmux_cv_page_shift";  the
# substitution   symbol   "MMUX_PAGE_SHIFT";  the   preprocessor   macro
# "MMUX_PAGE_SHIFT".
#
# Arguments:
#
# $1 -  The page size  in bytes.  This  value must have  been determined
#      with some other test.
#
AC_DEFUN([MMUX_CHECK_RE2],[
  AC_REQUIRE([AX_PTHREAD])

  AC_LANG_PUSH([C++])
  AC_CHECK_HEADERS([re2/re2.h],,[AC_MSG_ERROR([test for re2 header failed])])
  AC_LANG_POP([C++])

  AC_CACHE_CHECK([for library re2],
    [mmux_cv_re2_libs],
    [AC_LANG_PUSH([C++])
     AS_VAR_COPY([my_cre2_saved_ldflags],[LDFLAGS])
     AS_VAR_COPY([my_cre2_saved_cxxflags],[CXXFLAGS])
     AS_VAR_APPEND([CXXFLAGS],[" ${PTHREAD_CFLAGS}"])
     AS_VAR_APPEND([LDFLAGS],[" -lre2 ${PTHREAD_LIBS}"])
     AC_LINK_IFELSE([AC_LANG_PROGRAM([
#include <re2/re2.h>
       ],
       [re2::StringPiece pattern_re2("", 0);])],
       [AS_VAR_SET([mmux_cv_re2_libs],[-lre2])],
       [AC_MSG_ERROR([test for RE2 library failed])])
       AS_VAR_COPY([LDFLAGS],[my_cre2_saved_ldflags])
       AS_VAR_COPY([CXXFLAGS],[my_cre2_saved_cxxflags])
       AC_LANG_POP([C++])])
   AC_SUBST([RE2_LIBS],[$mmux_cv_re2_libs])
])

### end of file
# Local Variables:
# mode: autoconf
# End:
