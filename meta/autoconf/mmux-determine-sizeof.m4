dnl mmux-determine-sizeof.m4 --
dnl
dnl MMUX_DETERMINE_SIZEOF(STEM, TYPE, INCLUDES)
dnl
dnl Determine the size  in bytes of the C language  type TYPE, using the
dnl header files selected by the directives in INCLUDES.
dnl
dnl Define the  variable  variable "MMUX_SIZEOF_$STEM"  and the  cached
dnl variable "mmux_cv_sizeof_$STEM" to the number of bytes.
dnl
dnl Define the  preprocessor macro "MMUX_SIZEOF_$STEM" to  the number of
dnl bytes.
dnl
dnl Example, to determine the size of "size_t":
dnl
dnl   MMUX_DETERMINE_SIZEOF([SIZE_T],[size_t],[
dnl   #ifdef HAVE_STDDEF_H
dnl   #  include <stddef.h>
dnl   #endif
dnl   ])
dnl
dnl Arguments:
dnl
dnl $1 - A stem used to build variable names.
dnl $2 - The C language type of which we want to determine the size.
dnl $3 - The preprocessor include directives we need to include the required headers.
dnl
AC_DEFUN([MMUX_DETERMINE_SIZEOF],
  [AS_VAR_SET([MMUX_SIZEOF_$1],[0])
   AC_CACHE_CHECK([the size of '$2'],
     [mmux_cv_sizeof_$1],
     [AC_COMPUTE_INT([mmux_cv_sizeof_$1],
        [sizeof($2)],
        [$3],
        [mmux_cv_sizeof_$1=0])])
    AS_VAR_SET([MMUX_SIZEOF_$1],["$mmux_cv_sizeof_$1"])
    AC_DEFINE_UNQUOTED([MMUX_SIZEOF_$1],[$MMUX_SIZEOF_[]$1],[the size of '$2'])])

dnl end of file
dnl Local Variables:
dnl mode: autoconf
dnl End:
