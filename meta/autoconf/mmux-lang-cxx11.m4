## mmux-lang-cxx11.m4 --
#
# Define the appropriate flags to use the C++11 standard language.  Such
# flags are appended to the current definition of the variable "CXX".
#
# This macro is meant to be used as:
#
#   AC_LANG([C++])
#   AC_PROG_CXX
#   MMUX_LANG_CXX11
#   AC_PROG_CXX_C_O
#
# If the variable "GCC" is set to "yes": select additional warning flags
# to be  handed to  the C++  compiler.  Such flags  are appended  to the
# variable MMUX_CXXFLAGS, which is  also configured as substitution (and
# so it  becomes a Makefile variable).   We should use such  variable to
# the compile commands as follows, in "Makefile.am":
#
#   AM_CXXFLAGS = $(MMUX_CXXFLAGS)
#

AC_DEFUN([MMUX_LANG_CXX11],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AX_REQUIRE_DEFINED([AX_CXX_COMPILE_STDCXX_11])
  AC_REQUIRE([AX_IS_RELEASE])

  AX_CXX_COMPILE_STDCXX_11(noext,mandatory)

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CXXFLAGS])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CXXFLAGS], [-Werror])
     AX_APPEND_COMPILE_FLAGS([-Wno-unused-parameter -Wno-missing-field-initializers], [MMUX_CXXFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CXXFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CXXFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation], [MMUX_CXXFLAGS], [-Werror])])])

  ])

### end of file
# Local Variables:
# mode: autoconf
# End:
