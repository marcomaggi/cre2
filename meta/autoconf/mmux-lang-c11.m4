## mmux-lang-c11.m4 --
#
# Define the appropriate  flags to use the C11  standard language.  Such
# flags are appended to the current definition of the variable "CC".
#
# This macro is meant to be used as:
#
#       AC_LANG([C])
#       MMUX_LANG_C11
#
# If the variable "GCC" is set to "yes": select additional warning flags
# to  be handed  to the  C  compiler.  Such  flags are  appended to  the
# variable MMUX_CFLAGS, which is also configured as substitution (and so
# it becomes a  Makefile variable).  We should use such  variable to the
# compile commands as follows, in "Makefile.am":
#
#   AM_CFLAGS = $(MMUX_CFLAGS)
#

AC_DEFUN([MMUX_LANG_C11],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AC_REQUIRE([AX_IS_RELEASE])

  AC_PROG_CC_C99
  AX_CHECK_COMPILE_FLAG([-std=c11],
    [AX_APPEND_FLAG([-std=c11], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -std=c11])],
    [-pedantic])

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CFLAGS])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation], [MMUX_CFLAGS], [-Werror])])])
  ])

### end of file
# Local Variables:
# mode: autoconf
# End:
