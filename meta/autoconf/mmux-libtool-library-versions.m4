## mmux-libtool-library-versions.m4 --
#
# Set version numbers for libraries built with GNU Libtool.
#
#   MM_LIBTOOL_LIBRARY_VERSIONS(stem,current,revision,age)
#
AC_DEFUN([MMUX_LIBTOOL_LIBRARY_VERSIONS],
  [$1_VERSION_INTERFACE_CURRENT=$2
   $1_VERSION_INTERFACE_REVISION=$3
   $1_VERSION_INTERFACE_AGE=$4
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_CURRENT],
     [$$1_VERSION_INTERFACE_CURRENT],
     [current interface number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_REVISION],
     [$$1_VERSION_INTERFACE_REVISION],
     [current interface implementation number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_AGE],
     [$$1_VERSION_INTERFACE_AGE],
     [current interface age number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_STRING],
     ["$$1_VERSION_INTERFACE_CURRENT.$$1_VERSION_INTERFACE_REVISION"],
     [library interface version])
   AC_SUBST([$1_VERSION_INTERFACE_CURRENT])
   AC_SUBST([$1_VERSION_INTERFACE_REVISION])
   AC_SUBST([$1_VERSION_INTERFACE_AGE])])

### end of file
# Local Variables:
# mode: autoconf
# End:
