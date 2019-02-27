### mmux-check-re2.m4 --
#
# MMUX_CHECK_RE2
#
AC_DEFUN([MMUX_CHECK_RE2],[
  AC_REQUIRE([AX_PTHREAD])

  AC_LANG_PUSH([C++])
  AC_CHECK_HEADERS([re2/re2.h],,[AC_MSG_ERROR([test for re2 header failed])])
  AC_LANG_POP([C++])

  AC_CACHE_CHECK([for re2 library],
    [mmux_cv_re2_libs],
    [AC_LANG_PUSH([C++])
     AS_VAR_COPY([my_cre2_saved_cxxflags],[CXXFLAGS])
     AS_VAR_COPY([my_cre2_saved_ldflags],[LDFLAGS])
     AS_VAR_APPEND([CXXFLAGS],[" ${PTHREAD_CFLAGS}"])
     AS_VAR_APPEND([LDFLAGS], [" ${PTHREAD_LIBS} -L${libdir} -lre2"])
     AC_LINK_IFELSE([AC_LANG_PROGRAM([
#include <re2/re2.h>
#include <assert.h>
       ],[
RE2::Options opt;
opt.set_never_nl(true);
{
  RE2 re("ab[cd]+ef", opt);
  assert(re.ok());
  assert(RE2::FullMatch("abcddcef", re));
  assert(RE2::PartialMatch("abcddcef123", re));
}
       ])],
       [AS_VAR_SET([mmux_cv_re2_libs],["-L${libdir} -lre2"])],
       [AC_MSG_ERROR([test for re2 library failed])])
       AS_VAR_COPY([LDFLAGS],[my_cre2_saved_ldflags])
       AS_VAR_COPY([CXXFLAGS],[my_cre2_saved_cxxflags])
       AC_LANG_POP([C++])])
   AC_SUBST([RE2_LIBS],[$mmux_cv_re2_libs])
])

### end of file
# Local Variables:
# mode: autoconf
# End:
