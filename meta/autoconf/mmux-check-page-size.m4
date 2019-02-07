### mm-check-page-size.m4 --
#
# Inspect the  system for the page  size.  Set to the  value: the cached
# variable     "mmux_cv_page_size";      the     substitution     symbol
# "MMUX_PAGE_SIZE"; the preprocessor macro "MMUX_PAGE_SIZE".
#
AC_DEFUN([MMUX_CHECK_PAGE_SIZE],
  [AC_CHECK_HEADERS([unistd.h])
   AC_CACHE_CHECK([page size],
     [mmux_cv_page_size],
     [AC_COMPUTE_INT([mmux_cv_page_size],[sysconf(_SC_PAGE_SIZE)],[
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif
     ],[AS_VAR_SET([mmux_cv_page_size],[4096])])])

  AC_SUBST([MMUX_PAGE_SIZE],[$mmux_cv_page_size])
  AC_DEFINE_UNQUOTED([MMUX_PAGE_SIZE],[$mmux_cv_page_size],[Page size bit count.])])

### end of file
# Local Variables:
# mode: autoconf
# End:
