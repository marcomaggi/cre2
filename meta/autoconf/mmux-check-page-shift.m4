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
AC_DEFUN([MMUX_CHECK_PAGE_SHIFT],
  [AC_CACHE_CHECK([page shift bit count],
     [mmux_cv_page_shift],
     [AC_RUN_IFELSE([AC_LANG_SOURCE([
        int main (void)
        {
           int count=0;
	   int roller=$1 - 1;
           FILE *f = fopen ("conftest.val", "w");
           while (roller) {
             ++count;
	     roller >>= 1;
           }
           fprintf(f, "%d", count);
           return ferror (f) || fclose (f) != 0;
        }])],
        [AS_VAR_SET([mmux_cv_page_shift],[`cat conftest.val`])],
        [AS_VAR_SET([mmux_cv_page_shift],[12])],
        dnl This is to allow cross-compilation.
        [AS_VAR_SET([mmux_cv_page_shift],[12])])
      rm -f conftest.val],
      [AS_VAR_SET([mmux_cv_page_shift],[12])])

  AC_SUBST([MMUX_PAGE_SHIFT],[$mmux_cv_page_shift])
  AC_DEFINE_UNQUOTED([MMUX_PAGE_SHIFT],[$mmux_cv_page_shift],[Page shift bit count.])])

### end of file
# Local Variables:
# mode: autoconf
# End:
