dnl This macro was taken on Oct  5, 2017 from:
dnl
dnl   <https://stackoverflow.com/questions/7067385/find-the-gcc-version>
dnl
dnl and modified a bit.

dnl AX_GCC_VERSION
dnl
dnl Takes  no arguments.  If the  shell variable "GCC" is  set to "yes",
dnl this macro defines:
dnl
dnl - the cached shell variable "ax_cv_gcc_version";
dnl
dnl - the shell variable "GCC_VERSION";
dnl
dnl - the substitution for the symbol "GCC_VERSION";
dnl
dnl the value  of such variables and substitution is  the version number
dnl of "gcc".
dnl
AC_DEFUN([AX_GCC_VERSION],
  [AS_VAR_SET(GCC_VERSION,[$ax_cv_gcc_version])
   AS_IF([test "x$GCC" = "xyes"],
     [AC_CACHE_CHECK([GCC version number],[ax_cv_gcc_version],
        [AS_VAR_SET(ax_cv_gcc_version,["`$CC -dumpversion`"])
         AS_IF([test "x$ax_cv_gcc_version" = "x"],
           [AS_VAR_SET(ax_cv_gcc_version)])
         AS_VAR_SET(GCC_VERSION,[$ax_cv_gcc_version])])])
   AC_SUBST([GCC_VERSION])])

dnl end of file
dnl Local Variables:
dnl mode: autoconf
dnl End:
