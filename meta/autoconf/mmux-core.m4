## mmux-core.m4 --
#
# Basic definitions for MMUX packages.
#
# LICENSE
#
#   Copyright (c) 2018, 2019 Marco Maggi <marco.maggi-ipsu@poste.it>
#
#   Copying and distribution of this file, with or without modification,
#   are permitted in  any medium without royalty  provided the copyright
#   notice and this  notice are preserved.  This file  is offered as-is,
#   without any warranty.
#


# SYNOPSIS
#
#   MMUX_PKG_VERSIONS([MAJOR_VERSION], [MINOR_VERSION], [PATCH_LEVEL],
#                     [PRERELEASE_TAG], [BUILD_METADATA])
#
# DESCRIPTION
#
#   Define  the  appropriate  m4  macros used  to  set  various  package
#   semantic  version  components.   For   the  definition  of  semantic
#   versioning see:
#
#                         <http://semver.org/>
#
#   This macro is meant to be used right before AC_INIT as:
#
#      MMUX_PKG_VERSIONS([MAJOR_VERSION], [MINOR_VERSION], [PATCH_LEVEL],
#                        [PRERELEASE_TAG], [BUILD_METADATA])
#      AC_INIT(..., MMUX_PACKAGE_VERSION, ...)
#
#   the arguments  PRERELEASE_TAG and BUILD_METADATA are  optional.  For
#   example:
#
#      MMUX_PKG_VERSIONS([0],[1],[0],[devel.0],[x86_64])
#
#   The value of PRERELEASE_TAG must be a string like "devel.0", without
#   a leading  dash.  The value  of BUILD_METADATA_TAG must be  a string
#   like "x86_64", without a leading plus.
#
#   This macro defines the following m4 macros:
#
#     MMUX_PACKAGE_MAJOR_VERSION: the major version number.
#
#     MMUX_PACKAGE_MINOR_VERSION: the minor version number.
#
#     MMUX_PACKAGE_PATCH_LEVEL: the patch level number.
#
#     MMUX_PACKAGE_PRERELEASE_TAG:   the   prerelease  tag   string   as
#     specified by semantic versioning.
#
#     MMUX_PACKAGE_BUILD_METADATA:   the   build  metadata   string   as
#     specified by semantic versioning.
#
#     MMUX_PACKAGE_VERSION: the  package version  string as  required by
#     AC_INIT;  it includes  neither the  prerelease tag  nor the  build
#     metadata.
#
#     MMUX_PACKAGE_SEMANTIC_VERSION: the  full semantic  version string,
#     with a leading "v".
#
#     MMUX_PACKAGE_PKG_CONFIG_VERSION: the version number  to use in the
#     module file for "pkg-config".
#
m4_define([MMUX_PKG_VERSIONS],[
  m4_define([MMUX_PACKAGE_MAJOR_VERSION],  [$1])
  m4_define([MMUX_PACKAGE_MINOR_VERSION],  [$2])
  m4_define([MMUX_PACKAGE_PATCH_LEVEL],    [$3])
  m4_define([MMUX_PACKAGE_PRERELEASE_TAG], [$4])
  m4_define([MMUX_PACKAGE_BUILD_METADATA], [$5])

  # If  a prerelease  tag  argument is  present:  define the  associated
  # component  for the  PACKAGE_VERSION variable;  otherwise define  the
  # component to the empty string.
  #
  # Note: "m4_ifval" is an Autoconf  macro, see the documentation in the
  # node "Programming in M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG],
    m4_ifval(MMUX_PACKAGE_PRERELEASE_TAG,[-]MMUX_PACKAGE_PRERELEASE_TAG))

  # If  a build  metadata  argument is  present:  define the  associated
  # component for the PACKAGE_VERSION variable;  otherwise define  the
  # component to the empty string.
  #
  # Note: "m4_ifval" is an Autoconf  macro, see the documentation in the
  # node "Programming in M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA],
    m4_ifval(MMUX_PACKAGE_BUILD_METADATA,[+]MMUX_PACKAGE_BUILD_METADATA))

  # Result variables.
  m4_define([MMUX_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG)
  m4_define([MMUX_PACKAGE_SEMANTIC_VERSION],[v]MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG[]MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA)
  m4_define([MMUX_PACKAGE_PKG_CONFIG_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL)
])


# SYNOPSIS
#
#   MMUX_INIT
#
# DESCRIPTION
#
#   Initialisation code for MMUX macros.
#
AC_DEFUN([MMUX_INIT],[
  AC_MSG_NOTICE([package major version:]  MMUX_PACKAGE_MAJOR_VERSION)
  AC_MSG_NOTICE([package minor version:]  MMUX_PACKAGE_MINOR_VERSION)
  AC_MSG_NOTICE([package patch level:]    MMUX_PACKAGE_PATCH_LEVEL)
  AC_MSG_NOTICE([package prerelease tag:] MMUX_PACKAGE_PRERELEASE_TAG)
  AC_MSG_NOTICE([package build metadata:] MMUX_PACKAGE_BUILD_METADATA)
  AC_MSG_NOTICE([package version:] MMUX_PACKAGE_VERSION)
  AC_MSG_NOTICE([package semantic version:] MMUX_PACKAGE_SEMANTIC_VERSION)
  AC_MSG_NOTICE([package pkg-config module version:] MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This is used to generate TAGS files for the C language.
  AS_VAR_SET([MMUX_DEPENDENCIES_INCLUDES])
])


# SYNOPSIS
#
#   MMUX_OUTPUT
#
# DESCRIPTION
#
#   Define what  is needed to  end the MMUX package  preparations.  This
#   macro is meant to be used right before AC_output, as follows:
#
#     MMUX_OUTPUT
#     AC_OUTPUT
#
#   This macro defines the following substitutions:
#
#     MMUX_PKG_CONFIG_VERSION:  the version  string  to be  used in  the
#     module for pkg-config.
#
#     SLACKWARE_PACKAGE_VERSION:  the version  string  to  be used  when
#     building a Slackware package file.
#
AC_DEFUN([MMUX_OUTPUT],[
  AC_SUBST([MMUX_PKG_MAJOR_VERSION],MMUX_PACKAGE_MAJOR_VERSION)
  AC_SUBST([MMUX_PKG_MINOR_VERSION],MMUX_PACKAGE_MINOR_VERSION)
  AC_SUBST([MMUX_PKG_PATCH_LEVEL],MMUX_PACKAGE_PATCH_LEVEL)
  AC_SUBST([MMUX_PKG_PRERELEASE_TAG],MMUX_PACKAGE_PRERELEASE_TAG)
  AC_SUBST([MMUX_PKG_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)
  AC_SUBST([MMUX_PKG_VERSION],MMUX_PACKAGE_VERSION)
  AC_SUBST([MMUX_PKG_SEMANTIC_VERSION],MMUX_PACKAGE_SEMANTIC_VERSION)

  # This is the version stored in the pkg-config data file.
  AC_SUBST([MMUX_PKG_CONFIG_VERSION],MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This  is the  version number  to be  used when  generating Slackware
  # packages.
  AC_SUBST([SLACKWARE_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_PRERELEASE_TAG)

  # This  is  the build  metadata  string  to  be used  when  generating
  # Slackware  packages.   It  should  be  something  like  "noarch"  or
  # "x84_64".
  AC_SUBST([SLACKWARE_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)

  # This is used to generate TAGS files for the C language.
  AC_SUBST([MMUX_DEPENDENCIES_INCLUDES])
])

### end of file
# Local Variables:
# mode: autoconf
# End:
