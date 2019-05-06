## mmux-check-target-os.m4 --
#
# Inspect the value  of the variable "target_os"  and defines variables,
# substitutions and Automake conditionals according to it.
#
# The  following variables,  substitutions and  preprocessor macros  are
# defined:
#
# MMUX_ON_LINUX: set to 1 on a GNU+Linux system, otherwise set to 0.
#
# MMUX_ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
# MMUX_ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
# MMUX_ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#
# The following automake conditionals are defined:
#
# ON_LINUX: set to 1 on a GNU+Linux system, otherwise set to 0.
#
# ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
# ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
# ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#

AC_DEFUN([MMUX_CHECK_TARGET_OS],
  [AS_VAR_SET([MMUX_ON_LINUX], [0])
   AS_VAR_SET([MMUX_ON_BSD],   [0])
   AS_VAR_SET([MMUX_ON_CYGWIN],[0])
   AS_VAR_SET([MMUX_ON_DARWIN],[0])

   AS_CASE("$target_os",
     [*linux*],
     [AS_VAR_SET([MMUX_ON_LINUX],[1])
      AC_MSG_NOTICE([detected OS: linux])],
     [*bsd*],
     [AS_VAR_SET([MMUX_ON_BSD],[1])
      AC_MSG_NOTICE([detected OS: BSD])],
     [*cygwin*],
     [AS_VAR_SET([MMUX_ON_CYGWIN],[1])
      AC_MSG_NOTICE([detected OS: CYGWIN])],
     [*darwin*],
     [AS_VAR_SET([MMUX_ON_DARWIN],[1])
      AC_MSG_NOTICE([detected OS: DARWIN])])

   AM_CONDITIONAL([ON_LINUX], [test "x$MMUX_ON_LINUX"  = x1])
   AM_CONDITIONAL([ON_BSD],   [test "x$MMUX_ON_BSD"    = x1])
   AM_CONDITIONAL([ON_CYGWIN],[test "x$MMUX_ON_CYGWIN" = x1])
   AM_CONDITIONAL([ON_DARWIN],[test "x$MMUX_ON_DARWIN" = x1])

   AC_SUBST([MMUX_ON_LINUX], [$MMUX_ON_LINUX])
   AC_SUBST([MMUX_ON_BSD],   [$MMUX_ON_BSD])
   AC_SUBST([MMUX_ON_CYGWIN],[$MMUX_ON_CYGWIN])
   AC_SUBST([MMUX_ON_DARWIN],[$MMUX_ON_DARWIN])

   AC_DEFINE_UNQUOTED([MMUX_ON_LINUX], [$MMUX_ON_LINUX],  [True if the underlying platform is GNU+Linux])
   AC_DEFINE_UNQUOTED([MMUX_ON_BSD],   [$MMUX_ON_BSD],    [True if the underlying platform is BSD])
   AC_DEFINE_UNQUOTED([MMUX_ON_CYGWIN],[$MMUX_ON_CYGWIN], [True if the underlying platform is Cygwin])
   AC_DEFINE_UNQUOTED([MMUX_ON_DARWIN],[$MMUX_ON_DARWIN], [True if the underlying platform is Darwin])
   ])

### end of file
# Local Variables:
# mode: autoconf
# End:
