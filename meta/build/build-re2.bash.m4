#! Part of: CRE2
#! Contents: script template
#! Date: Aug 23, 2024
#!
#! Abstract
#!
#!	Build script to help installing "re2" and all its dependency packages.
#!
#! Copyright (c) 2024, 2026 Marco Maggi <mrc.mgg@gmail.com>
#!
#! The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
#! and its documentation  for any purpose, provided  that existing copyright notices  are retained in
#! all copies and that this notice is  included verbatim in any distributions.  No written agreement,
#! license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
#! software may  be copyrighted by their  authors and need  not follow the licensing  terms described
#! here, provided that the new terms are clearly indicated  on the first page of each file where they
#! apply.
#!
#! IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
#! INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
#! OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
#! DAMAGE.
#!
#! THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
#! THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#! THIS SOFTWARE IS PROVIDED ON AN "AS IS"  BASIS, AND THE AUTHOR AND DISTRIBUTORS HAVE NO OBLIGATION
#! TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#!


#### MBFL's related options and variables

declare -r script_PROGNAME=build-re2.bash
declare -r script_VERSION=1.0
declare -r script_COPYRIGHT_YEARS='2024'
declare -r script_AUTHOR='Marco Maggi'
declare -r script_LICENSE=liberal

script_USAGE="usage: ${script_PROGNAME} [action] [options]"
script_DESCRIPTION='Build re2 itself and its dependencies.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build abseil
\t${script_PROGNAME} build googletest
\t${script_PROGNAME} build re2"

declare -r COMPLETIONS_SCRIPT_NAMESPACE='p-build-re2'


#### library loading

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(arch)

MBFL_DEFINE_QQ_MACRO
MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS


#### declare external programs usage

mbfl_program_enable_sudo
mbfl_file_enable_owner_and_group
mbfl_file_enable_permissions
mbfl_file_enable_tar

mbfl_declare_program cmake
mbfl_declare_program make


#### declare exit codes

# mbfl_declare_exit_code 2 second_error
# mbfl_declare_exit_code 3 third_error
# mbfl_declare_exit_code 4 fourth_error
# mbfl_declare_exit_code 8 eighth_error


#### configure global behaviour

mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit


#@@@ command line options

#                   keyword		default-value	brief-option	long-option	has-argument  description
mbfl_declare_option BUILDDIR		''		''		builddir	witharg	      'The build directory.'
mbfl_declare_option INSTALL_PREFIX	''		''		install-prefix	witharg	      'The install directory prefix.'
mbfl_declare_option TARBALL		''		''		tarball		witharg	      'Path to tarball.'
mbfl_declare_option ENABLE_STATIC	no		''		enable-static	noarg	      'Build statis libraries.'


#### declaration of script actions tree

mbfl_declare_action_set BUILD
#                   action-set	keyword			subset	identifier	description
mbfl_declare_action BUILD	BUILD_ABSEIL		NONE	abseil		'Build abseil.'
mbfl_declare_action BUILD	BUILD_GOOGLETEST	NONE	googletest	'Build GoogleTest.'
mbfl_declare_action BUILD	BUILD_RE2		NONE	re2		'Build re2.'
mbfl_declare_action BUILD	BUILD_CRE2		NONE	cre2		'Build cre2.'

## --------------------------------------------------------------------

mbfl_declare_action_set HELP
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action HELP	HELP_USAGE	NONE		usage		'Print the help screen and exit.'
mbfl_declare_action HELP	HELP_PRINT_COMPLETIONS_SCRIPT NONE print-completions-script 'Print the completions script for this program.'

### --------------------------------------------------------------------

mbfl_declare_action_set MAIN
#                   action-set	keyword		subset		identifier	description
mbfl_declare_action MAIN	BUILD		BUILD		build		'Build packages.'
mbfl_declare_action MAIN	HELP		HELP		help		'Help the user of this script.'


#### script action functions: main
#
# This is the default  main function.  It is invoked whenever the script  is executed without action
# arguments.
#

function main () {
    mbfl_actions_fake_action_set MAIN
    mbfl_main_print_usage_screen_brief
}


#### build actions

function script_before_parsing_options_BUILD () {
    script_USAGE="usage: ${script_PROGNAME} build [action] [options]"
    script_DESCRIPTION='Build the packages.'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build"
}
function script_action_BUILD () {
    mbfl_main_print_usage_screen_brief
}


#### build the prerequisite project: abseil

function script_before_parsing_options_BUILD_ABSEIL () {
    script_USAGE="usage: ${script_PROGNAME} build abseil [options]"
    script_DESCRIPTION='Build the package "abseil".'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build abseil"
}
function script_action_BUILD_ABSEIL () {
    # Gather values from the command line options.
    declare -r ABSEIL_BUILDDIR=QQ(script_option_BUILDDIR)
    declare -r ABSEIL_TARBALL=QQ(script_option_TARBALL)
    declare -r ABSEIL_INSTALL_PREFIX=QQ(script_option_INSTALL_PREFIX)
    declare -r ABSEIL_BUILD_STATIC_LIBRARIES=QQ(script_option_ENABLE_STATIC)

    mbfl_declare_varref(ABSEIL_ABS_BUILDDIR)
    mbfl_declare_varref(ABSEIL_ABS_INSTALL_PREFIX)
    mbfl_declare_varref(ABSEIL_ABS_TARBALL)
    mbfl_declare_varref(ABSEIL_TAILNAME)
    mbfl_declare_varref(ABSEIL_VERSION)
    mbfl_declare_varref(ABSEIL_ABS_TOP_SRCDIR)

    # Validate and normalise the directory in which we unpack the archive and build the package.
    {
	mbfl_message_verbose_printf 'validating package build directory: "%s"\n' QQ(ABSEIL_BUILDDIR)

	if ! mbfl_directory_is_writable QQ(ABSEIL_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(ABSEIL_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(ABSEIL_ABS_BUILDDIR) QQ(ABSEIL_BUILDDIR)
	then
	    mbfl_message_error_printf 'normalising package builddir: "%s"'  QQ(ABSEIL_BUILDDIR)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package build directory: "%s"\n' QQ(ABSEIL_ABS_BUILDDIR)
    }

    # Validate and normalise the directory prefix under which we will install the package.
    {
	mbfl_message_verbose_printf 'validating package install prefix: "%s"\n' QQ(ABSEIL_INSTALL_PREFIX)

	if ! mbfl_file_is_directory QQ(ABSEIL_INSTALL_PREFIX) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(ABSEIL_ABS_INSTALL_PREFIX) QQ(ABSEIL_INSTALL_PREFIX)
	then
	    mbfl_message_error_printf 'normalising package install prefix: "%s"'  QQ(ABSEIL_INSTALL_PREFIX)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package install prefix: "%s"\n' QQ(ABSEIL_INSTALL_PREFIX)
    }

    # Validate and normalise the tarball pathname.
    {
	mbfl_message_verbose_printf 'validating package tarball pathname: "%s"\n' QQ(ABSEIL_TARBALL)

	if ! mbfl_file_is_readable QQ(ABSEIL_TARBALL) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(ABSEIL_ABS_TARBALL) QQ(ABSEIL_TARBALL)
	then
	    mbfl_message_error_printf 'normalising package pathname: "%s"'  QQ(ABSEIL_TARBALL)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package tarball pathname: "%s"\n' QQ(ABSEIL_ABS_TARBALL)
    }

    # Extract the version number from the tarball filename.
    {
	declare -r TAILNAME_REX='abseil-cpp-([0-9]+\.[0-9]+).tar.gz'

	mbfl_file_tail_var _(ABSEIL_TAILNAME) QQ(ABSEIL_ABS_TARBALL)

	if [[ QQ(ABSEIL_TAILNAME) =~ $TAILNAME_REX ]]
	then ABSEIL_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	else
	    mbfl_message_error_printf 'cannot extract version number from tarball tailname: "%s"'  QQ(ABSEIL_TAILNAME)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package version specification: "%s"\n' QQ(ABSEIL_VERSION)
    }

    # Unpack the tarball in the build directory.
    {
	mbfl_message_verbose_printf 'unpacking the archive\n'
	declare TAR_FLAGS='--gunzip'

	if mbfl_option_verbose_program
	then TAR_FLAGS+=' --verbose'
	fi

	if ! mbfl_tar_extract_from_file QQ(ABSEIL_ABS_BUILDDIR) QQ(ABSEIL_ABS_TARBALL) $TAR_FLAGS
	then
	    mbfl_message_error_printf 'unpacking abseil'
	    exit_failure
	fi
    }

    # After unpacking: validate the top source directory of the unpacked archive.
    {
	printf -v ABSEIL_ABS_TOP_SRCDIR '%s/abseil-cpp-%s' QQ(ABSEIL_ABS_BUILDDIR) QQ(ABSEIL_VERSION)
	mbfl_message_verbose_printf 'validating package top source directory: "%s"\n' QQ(ABSEIL_ABS_TOP_SRCDIR)

	if ! mbfl_directory_is_writable QQ(ABSEIL_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(ABSEIL_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi

	mbfl_message_verbose_printf 'package top source directory: "%s"\n' QQ(ABSEIL_ABS_TOP_SRCDIR)
    }

    # Configure, build and install the package.
    mbfl_location_enter
    {
	mbfl_location_handler_change_directory QQ(ABSEIL_ABS_TOP_SRCDIR)
	mbfl_message_verbose_printf 'configuring the package\n'

	# I could not compile this correctly, so I  stole the cmake flags from the SlackBuilds build
	# script.  (Aug 24, 2024; Marco Maggi)
	#
	# Adding "-DABSL_PROPAGATE_CXX_STD=ON" is  suggested by the package  configuration itself in
	# version 20240722.0, so I did it.  (Aug 24, 2024; Marco Maggi)
	#
	if ! {
		if mbfl_string_is_yes QQ(ABSEIL_BUILD_STATIC_LIBRARIES)
		then program_cmake . \
				   --install-prefix QQ(ABSEIL_ABS_INSTALL_PREFIX) \
				   -DBUILD_SHARED_LIBS=OFF -DCMAKE_CXX_FLAGS:STRING='-DNDEBUG' \
				   -DCMAKE_BUILD_TYPE=RelWithDebInfo \
				   -DCMAKE_CXX_STANDARD=17 \
				   -DCMAKE_BUILD_TYPE=Release \
				   -DABSL_PROPAGATE_CXX_STD=ON
		else program_cmake . \
				   --install-prefix QQ(ABSEIL_ABS_INSTALL_PREFIX) \
				   -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS:STRING='-DNDEBUG -fPIC' \
				   -DCMAKE_BUILD_TYPE=RelWithDebInfo \
				   -DCMAKE_CXX_STANDARD=17 \
				   -DCMAKE_BUILD_TYPE=Release \
				   -DABSL_PROPAGATE_CXX_STD=ON
		fi
	    }
	then
	    mbfl_message_error_printf 'running cmake'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'building the package\n'
	if ! program_make
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'installing the package\n'
	if ! (umask 0; program_make install)
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi
    }
    mbfl_location_leave

    # Remove the unpacked source directory.
    {
	declare ABSEIL_INSTALL_MANIFEST
	mbfl_declare_varref(USERNAME)

	printf -v ABSEIL_INSTALL_MANIFEST '%s/install_manifest.txt' QQ(ABSEIL_ABS_TOP_SRCDIR)
	if mbfl_file_is_file QQ(ABSEIL_INSTALL_MANIFEST)
	then
	    if ! mbfl_system_whoami_var _(USERNAME)
	    then
		mbfl_message_error_printf 'cannot determine the username using "whoami"'
		exit_failure
	    fi

	    mbfl_message_verbose_printf 'changing to "%s" owner of: "%s"\n' QQ(USERNAME) QQ(ABSEIL_INSTALL_MANIFEST)

	    if ! mbfl_exec_chown QQ(USERNAME) QQ(ABSEIL_INSTALL_MANIFEST)
	    then
		mbfl_message_error_printf 'cannot change the owner of: "%s"' QQ(ABSEIL_INSTALL_MANIFEST)
		exit_failure
	    fi
	fi

	mbfl_message_verbose_printf 'removing the source directory: "%s"\n' QQ(ABSEIL_ABS_TOP_SRCDIR)
	if ! mbfl_file_remove QQ(ABSEIL_ABS_TOP_SRCDIR)
	then
	    mbfl_message_error_printf 'removing the source directory: "%s"\n' QQ(ABSEIL_ABS_TOP_SRCDIR)
	    exit_failure
	fi
    }

    mbfl_message_verbose_printf 'done\n'
}


#### build the prerequisite project: googletest

function script_before_parsing_options_BUILD_GOOGLETEST () {
    script_USAGE="usage: ${script_PROGNAME} build googletest [options]"
    script_DESCRIPTION='Build the package "googletest".'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build googletest"
}
function script_action_BUILD_GOOGLETEST () {
    # Gather values from the command line options.
    declare -r GOOGLETEST_BUILDDIR=QQ(script_option_BUILDDIR)
    declare -r GOOGLETEST_TARBALL=QQ(script_option_TARBALL)
    declare -r GOOGLETEST_INSTALL_PREFIX=QQ(script_option_INSTALL_PREFIX)
    declare -r GOOGLETEST_BUILD_STATIC_LIBRARIES=QQ(script_option_ENABLE_STATIC)

    mbfl_declare_varref(GOOGLETEST_ABS_BUILDDIR)
    mbfl_declare_varref(GOOGLETEST_ABS_INSTALL_PREFIX)
    mbfl_declare_varref(GOOGLETEST_ABS_TARBALL)
    mbfl_declare_varref(GOOGLETEST_TAILNAME)
    mbfl_declare_varref(GOOGLETEST_VERSION)
    mbfl_declare_varref(GOOGLETEST_ABS_TOP_SRCDIR)

    # Validate and normalise the directory in which we unpack the archive and build the package.
    {
	mbfl_message_verbose_printf 'validating package build directory: "%s"\n' QQ(GOOGLETEST_BUILDDIR)

	if ! mbfl_directory_is_writable QQ(GOOGLETEST_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(GOOGLETEST_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(GOOGLETEST_ABS_BUILDDIR) QQ(GOOGLETEST_BUILDDIR)
	then
	    mbfl_message_error_printf 'normalising package builddir: "%s"'  QQ(GOOGLETEST_BUILDDIR)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package build directory: "%s"\n' QQ(GOOGLETEST_ABS_BUILDDIR)
    }

    # Validate and normalise the directory prefix under which we will install the package.
    {
	mbfl_message_verbose_printf 'validating package install prefix: "%s"\n' QQ(GOOGLETEST_INSTALL_PREFIX)

	if ! mbfl_file_is_directory QQ(GOOGLETEST_INSTALL_PREFIX) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(GOOGLETEST_ABS_INSTALL_PREFIX) QQ(GOOGLETEST_INSTALL_PREFIX)
	then
	    mbfl_message_error_printf 'normalising package install prefix: "%s"'  QQ(GOOGLETEST_INSTALL_PREFIX)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package install prefix: "%s"\n' QQ(GOOGLETEST_INSTALL_PREFIX)
    }

    # Validate and normalise the tarball pathname.
    {
	mbfl_message_verbose_printf 'validating package tarball pathname: "%s"\n' QQ(GOOGLETEST_TARBALL)

	if ! mbfl_file_is_readable QQ(GOOGLETEST_TARBALL) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(GOOGLETEST_ABS_TARBALL) QQ(GOOGLETEST_TARBALL)
	then
	    mbfl_message_error_printf 'normalising package pathname: "%s"'  QQ(GOOGLETEST_TARBALL)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package tarball pathname: "%s"\n' QQ(GOOGLETEST_ABS_TARBALL)
    }

    # Extract the version number from the tarball filename.
    {
	declare -r TAILNAME_REX='googletest-([0-9]+\.[0-9]+\.[0-9]+).tar.gz'

	mbfl_file_tail_var _(GOOGLETEST_TAILNAME) QQ(GOOGLETEST_ABS_TARBALL)

	if [[ QQ(GOOGLETEST_TAILNAME) =~ $TAILNAME_REX ]]
	then GOOGLETEST_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	else
	    mbfl_message_error_printf 'cannot extract version number from tarball tailname: "%s"'  QQ(GOOGLETEST_TAILNAME)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package version specification: "%s"\n' QQ(GOOGLETEST_VERSION)
    }

    # Unpack the tarball in the build directory.
    {
	mbfl_message_verbose_printf 'unpacking the archive\n'
	declare TAR_FLAGS='--gunzip'

	if mbfl_option_verbose_program
	then TAR_FLAGS+=' --verbose'
	fi

	if ! mbfl_tar_extract_from_file QQ(GOOGLETEST_ABS_BUILDDIR) QQ(GOOGLETEST_ABS_TARBALL) $TAR_FLAGS
	then
	    mbfl_message_error_printf 'unpacking googletest'
	    exit_failure
	fi
    }

    # After unpacking: validate the top source directory of the unpacked archive.
    {
	printf -v GOOGLETEST_ABS_TOP_SRCDIR '%s/googletest-%s' QQ(GOOGLETEST_ABS_BUILDDIR) QQ(GOOGLETEST_VERSION)
	mbfl_message_verbose_printf 'validating package top source directory: "%s"\n' QQ(GOOGLETEST_ABS_TOP_SRCDIR)

	if ! mbfl_directory_is_writable QQ(GOOGLETEST_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(GOOGLETEST_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi

	mbfl_message_verbose_printf 'package top source directory: "%s"\n' QQ(GOOGLETEST_ABS_TOP_SRCDIR)
    }

    mbfl_location_enter
    {
	mbfl_location_handler_change_directory QQ(GOOGLETEST_ABS_TOP_SRCDIR)

	mbfl_message_verbose_printf 'configuring the package\n'
	if ! {
		if mbfl_string_is_yes QQ(GOOGLETEST_BUILD_STATIC_LIBRARIES)
		then program_cmake .							\
				   --install-prefix QQ(GOOGLETEST_ABS_INSTALL_PREFIX)	\
				   -DBUILD_SHARED_LIBS=OFF				\
				   -DCMAKE_CXX_FLAGS:STRING="-DNDEBUG"
		else program_cmake .							\
				   --install-prefix QQ(GOOGLETEST_ABS_INSTALL_PREFIX)	\
				   -DBUILD_SHARED_LIBS=ON				\
				   -DCMAKE_CXX_FLAGS:STRING="-fPIC -DNDEBUG"
		fi
	    }
	then
	    mbfl_message_error_printf 'running cmake'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'building the package\n'
	if ! program_make
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'installing the package\n'
	if ! (umask 0; program_make install)
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi
    }
    mbfl_location_leave

    # Remove the unpacked source directory.
    {
	declare GOOGLETEST_INSTALL_MANIFEST
	mbfl_declare_varref(USERNAME)

	printf -v GOOGLETEST_INSTALL_MANIFEST '%s/install_manifest.txt' QQ(GOOGLETEST_ABS_TOP_SRCDIR)
	if mbfl_file_is_file QQ(GOOGLETEST_INSTALL_MANIFEST)
	then
	    if ! mbfl_system_whoami_var _(USERNAME)
	    then
		mbfl_message_error_printf 'cannot determine the username using "whoami"'
		exit_failure
	    fi

	    mbfl_message_verbose_printf 'changing to "%s" owner of: "%s"\n' QQ(USERNAME) QQ(GOOGLETEST_INSTALL_MANIFEST)

	    if ! mbfl_exec_chown QQ(USERNAME) QQ(GOOGLETEST_INSTALL_MANIFEST)
	    then
		mbfl_message_error_printf 'cannot change the owner of: "%s"' QQ(GOOGLETEST_INSTALL_MANIFEST)
		exit_failure
	    fi
	fi

	mbfl_message_verbose_printf 'removing the source directory: "%s"\n' QQ(GOOGLETEST_ABS_TOP_SRCDIR)
	if ! mbfl_file_remove QQ(GOOGLETEST_ABS_TOP_SRCDIR)
	then
	    mbfl_message_error_printf 'removing the source directory: "%s"\n' QQ(GOOGLETEST_ABS_TOP_SRCDIR)
	    exit_failure
	fi
    }

    mbfl_message_verbose_printf 'done\n'
}


#### build the project: re2

function script_before_parsing_options_BUILD_RE2 () {
    script_USAGE="usage: ${script_PROGNAME} build re2 [options]"
    script_DESCRIPTION='Build the package "re2".'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build re2"
}
function script_action_BUILD_RE2 () {
    # Gather values from the command line options.
    declare -r RE2_BUILDDIR=QQ(script_option_BUILDDIR)
    declare -r RE2_TARBALL=QQ(script_option_TARBALL)
    declare -r RE2_INSTALL_PREFIX=QQ(script_option_INSTALL_PREFIX)
    declare -r RE2_BUILD_STATIC_LIBRARIES=QQ(script_option_ENABLE_STATIC)

    mbfl_declare_varref(RE2_ABS_BUILDDIR)
    mbfl_declare_varref(RE2_ABS_INSTALL_PREFIX)
    mbfl_declare_varref(RE2_ABS_TARBALL)
    mbfl_declare_varref(RE2_TAILNAME)
    mbfl_declare_varref(RE2_VERSION)
    mbfl_declare_varref(RE2_ABS_TOP_SRCDIR)

    # Validate and normalise the directory in which we unpack the archive and build the package.
    {
	mbfl_message_verbose_printf 'validating package build directory: "%s"\n' QQ(RE2_BUILDDIR)

	if ! mbfl_directory_is_writable QQ(RE2_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(RE2_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(RE2_ABS_BUILDDIR) QQ(RE2_BUILDDIR)
	then
	    mbfl_message_error_printf 'normalising package builddir: "%s"'  QQ(RE2_BUILDDIR)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package build directory: "%s"\n' QQ(RE2_ABS_BUILDDIR)
    }

    # Validate and normalise the directory prefix under which we will install the package.
    {
	mbfl_message_verbose_printf 'validating package install prefix: "%s"\n' QQ(RE2_INSTALL_PREFIX)

	if ! mbfl_file_is_directory QQ(RE2_INSTALL_PREFIX) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(RE2_ABS_INSTALL_PREFIX) QQ(RE2_INSTALL_PREFIX)
	then
	    mbfl_message_error_printf 'normalising package install prefix: "%s"'  QQ(RE2_INSTALL_PREFIX)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package install prefix: "%s"\n' QQ(RE2_INSTALL_PREFIX)
    }

    # Validate and normalise the tarball pathname.
    {
	mbfl_message_verbose_printf 'validating package tarball pathname: "%s"\n' QQ(RE2_TARBALL)

	if ! mbfl_file_is_readable QQ(RE2_TARBALL) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(RE2_ABS_TARBALL) QQ(RE2_TARBALL)
	then
	    mbfl_message_error_printf 'normalising package pathname: "%s"'  QQ(RE2_TARBALL)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package tarball pathname: "%s"\n' QQ(RE2_ABS_TARBALL)
    }

    # Extract the version number from the tarball filename.
    {
	declare -r TAILNAME_REX='re2-([0-9]+[0-9]+[0-9]+[0-9]+\-[0-9]+[0-9]+\-[0-9]+[0-9]+).tar.gz'

	mbfl_file_tail_var _(RE2_TAILNAME) QQ(RE2_ABS_TARBALL)

	if [[ QQ(RE2_TAILNAME) =~ $TAILNAME_REX ]]
	then RE2_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	else
	    mbfl_message_error_printf 'cannot extract version number from tarball tailname: "%s"'  QQ(RE2_TAILNAME)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package version specification: "%s"\n' QQ(RE2_VERSION)
    }

    # Unpack the tarball in the build directory.
    {
	mbfl_message_verbose_printf 'unpacking the archive\n'
	declare TAR_FLAGS='--gunzip'

	if mbfl_option_verbose_program
	then TAR_FLAGS+=' --verbose'
	fi

	if ! mbfl_tar_extract_from_file QQ(RE2_ABS_BUILDDIR) QQ(RE2_ABS_TARBALL) $TAR_FLAGS
	then
	    mbfl_message_error_printf 'unpacking re2'
	    exit_failure
	fi
    }

    # After unpacking: validate the top source directory of the unpacked archive.
    {
	printf -v RE2_ABS_TOP_SRCDIR '%s/re2-%s' QQ(RE2_ABS_BUILDDIR) QQ(RE2_VERSION)
	mbfl_message_verbose_printf 'validating package top source directory: "%s"\n' QQ(RE2_ABS_TOP_SRCDIR)

	if ! mbfl_directory_is_writable QQ(RE2_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(RE2_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi

	mbfl_message_verbose_printf 'package top source directory: "%s"\n' QQ(RE2_ABS_TOP_SRCDIR)
    }

    mbfl_location_enter
    {
	mbfl_location_handler_change_directory QQ(RE2_ABS_TOP_SRCDIR)

	mbfl_message_verbose_printf 'configuring the package\n'
	if ! {
		if mbfl_string_is_yes QQ(RE2_BUILD_STATIC_LIBRARIES)
		then program_cmake .						\
				   --install-prefix QQ(RE2_ABS_INSTALL_PREFIX)	\
				   -DBUILD_SHARED_LIBS=OFF			\
				   -DCMAKE_CXX_FLAGS:STRING="-DNDEBUG"
		else program_cmake .						\
				   --install-prefix QQ(RE2_ABS_INSTALL_PREFIX)	\
				   -DBUILD_SHARED_LIBS=ON			\
				   -DCMAKE_CXX_FLAGS:STRING="-fPIC -DNDEBUG"
		fi
	    }
	then
	    mbfl_message_error_printf 'running cmake'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'building the package\n'
	if ! program_make
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'installing the package\n'
	if ! (umask 0; program_make install)
	then
	    mbfl_message_error_printf 'running make install'
	    exit_failure
	fi
    }
    mbfl_location_leave

    # Remove the unpacked source directory.
    {
	declare RE2_INSTALL_MANIFEST
	mbfl_declare_varref(USERNAME)

	printf -v RE2_INSTALL_MANIFEST '%s/install_manifest.txt' QQ(RE2_ABS_TOP_SRCDIR)
	if mbfl_file_is_file QQ(RE2_INSTALL_MANIFEST)
	then
	    if ! mbfl_system_whoami_var _(USERNAME)
	    then
		mbfl_message_error_printf 'cannot determine the username using "whoami"'
		exit_failure
	    fi

	    mbfl_message_verbose_printf 'changing to "%s" owner of: "%s"\n' QQ(USERNAME) QQ(RE2_INSTALL_MANIFEST)

	    if ! mbfl_exec_chown QQ(USERNAME) QQ(RE2_INSTALL_MANIFEST)
	    then
		mbfl_message_error_printf 'cannot change the owner of: "%s"' QQ(RE2_INSTALL_MANIFEST)
		exit_failure
	    fi
	fi

	mbfl_message_verbose_printf 'removing the source directory: "%s"\n' QQ(RE2_ABS_TOP_SRCDIR)
	if ! mbfl_file_remove QQ(RE2_ABS_TOP_SRCDIR)
	then
	    mbfl_message_error_printf 'removing the source directory: "%s"\n' QQ(RE2_ABS_TOP_SRCDIR)
	    exit_failure
	fi
    }

    mbfl_message_verbose_printf 'done\n'
}


#### build the prerequisite project: cre2

function script_before_parsing_options_BUILD_CRE2 () {
    script_USAGE="usage: ${script_PROGNAME} build cre2 [options]"
    script_DESCRIPTION='Build the package "cre2".'
    script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build cre2"
}
function script_action_BUILD_CRE2 () {
    # Gather values from the command line options.
    declare -r CRE2_BUILDDIR=QQ(script_option_BUILDDIR)
    declare -r CRE2_TARBALL=QQ(script_option_TARBALL)
    declare -r CRE2_INSTALL_PREFIX=QQ(script_option_INSTALL_PREFIX)
    declare -r CRE2_BUILD_STATIC_LIBRARIES=QQ(script_option_ENABLE_STATIC)

    mbfl_declare_varref(CRE2_ABS_BUILDDIR)
    mbfl_declare_varref(CRE2_ABS_INSTALL_PREFIX)
    mbfl_declare_varref(CRE2_ABS_TARBALL)
    mbfl_declare_varref(CRE2_TAILNAME)
    mbfl_declare_varref(CRE2_VERSION)
    mbfl_declare_varref(CRE2_ABS_TOP_SRCDIR)

    # Validate and normalise the directory in which we unpack the archive and build the package.
    {
	mbfl_message_verbose_printf 'validating package build directory: "%s"\n' QQ(CRE2_BUILDDIR)

	if ! mbfl_directory_is_writable QQ(CRE2_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(CRE2_BUILDDIR) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(CRE2_ABS_BUILDDIR) QQ(CRE2_BUILDDIR)
	then
	    mbfl_message_error_printf 'normalising package builddir: "%s"'  QQ(CRE2_BUILDDIR)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package build directory: "%s"\n' QQ(CRE2_ABS_BUILDDIR)
    }

    # Validate and normalise the directory prefix under which we will install the package.
    {
	mbfl_message_verbose_printf 'validating package install prefix: "%s"\n' QQ(CRE2_INSTALL_PREFIX)

	if ! mbfl_file_is_directory QQ(CRE2_INSTALL_PREFIX) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(CRE2_ABS_INSTALL_PREFIX) QQ(CRE2_INSTALL_PREFIX)
	then
	    mbfl_message_error_printf 'normalising package install prefix: "%s"'  QQ(CRE2_INSTALL_PREFIX)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package install prefix: "%s"\n' QQ(CRE2_INSTALL_PREFIX)
    }

    # Validate and normalise the tarball pathname.
    {
	mbfl_message_verbose_printf 'validating package tarball pathname: "%s"\n' QQ(CRE2_TARBALL)

	if ! mbfl_file_is_readable QQ(CRE2_TARBALL) print_error
	then exit_failure
	fi
	if ! mbfl_file_realpath_var _(CRE2_ABS_TARBALL) QQ(CRE2_TARBALL)
	then
	    mbfl_message_error_printf 'normalising package pathname: "%s"'  QQ(CRE2_TARBALL)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package tarball pathname: "%s"\n' QQ(CRE2_ABS_TARBALL)
    }

    # Extract the version number from the tarball filename.
    {
	# This regex has to match file names like:
	#
	#	cre2-0.4.0-devel.2.tar.gz
	#	cre2-0.4.0.tar.gz
	#
	declare -r TAILNAME_REX='cre2-([0-9]+\.[0-9]+\.[0-9]+([a-z0-9\.\-]+)?).tar.gz'

	mbfl_file_tail_var _(CRE2_TAILNAME) QQ(CRE2_ABS_TARBALL)

	if [[ QQ(CRE2_TAILNAME) =~ $TAILNAME_REX ]]
	then CRE2_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	else
	    mbfl_message_error_printf 'cannot extract version number from tarball tailname: "%s"'  QQ(CRE2_TAILNAME)
	    exit_failure
	fi

	mbfl_message_verbose_printf 'package version specification: "%s"\n' QQ(CRE2_VERSION)
    }

    # Unpack the tarball in the build directory.
    {
	mbfl_message_verbose_printf 'unpacking the archive\n'
	declare TAR_FLAGS='--gunzip'

	if mbfl_option_verbose_program
	then TAR_FLAGS+=' --verbose'
	fi

	if ! mbfl_tar_extract_from_file QQ(CRE2_ABS_BUILDDIR) QQ(CRE2_ABS_TARBALL) $TAR_FLAGS
	then
	    mbfl_message_error_printf 'unpacking cre2'
	    exit_failure
	fi
    }

    # After unpacking: validate the top source directory of the unpacked archive.
    {
	printf -v CRE2_ABS_TOP_SRCDIR '%s/cre2-%s' QQ(CRE2_ABS_BUILDDIR) QQ(CRE2_VERSION)
	mbfl_message_verbose_printf 'validating package top source directory: "%s"\n' QQ(CRE2_ABS_TOP_SRCDIR)

	if ! mbfl_directory_is_writable QQ(CRE2_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi
	if ! mbfl_directory_is_executable QQ(CRE2_ABS_TOP_SRCDIR) print_error
	then exit_failure
	fi

	mbfl_message_verbose_printf 'package top source directory: "%s"\n' QQ(CRE2_ABS_TOP_SRCDIR)
    }

    mbfl_location_enter
    {
	mbfl_location_handler_change_directory QQ(CRE2_ABS_TOP_SRCDIR)

	mbfl_message_verbose_printf 'configuring the package\n'
	if ! {
		export PKG_CONFIG_PATH="${CRE2_ABS_INSTALL_PREFIX}/lib64/pkgconfig:${PKG_CONFIG_PATH}"

		if mbfl_string_is_yes QQ(CRE2_BUILD_STATIC_LIBRARIES)
		then ./configure \
			 --disable-static --enable-shared       \
			 --prefix=QQ(CRE2_ABS_INSTALL_PREFIX)	\
			 CFLAGS='-O3'				\
			 CXXFLAGS='-O3'
		else ./configure \
			 --enable-static --disable-shared       \
			 --prefix=QQ(CRE2_ABS_INSTALL_PREFIX)	\
			 CFLAGS='-O3'				\
			 CXXFLAGS='-O3'
		fi
	    }
	then
	    mbfl_message_error_printf 'running cmake'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'building the package\n'
	if ! program_make -j7
	then
	    mbfl_message_error_printf 'running make'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'running test suite\n'
	if ! (umask 0; program_make check)
	then
	    mbfl_message_error_printf 'running make check'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'installing the package\n'
	if ! (umask 0; program_make install)
	then
	    mbfl_message_error_printf 'running make install'
	    exit_failure
	fi

	mbfl_message_verbose_printf 'running test suite against installed libraries\n'
	if ! (umask 0; program_make installcheck)
	then
	    mbfl_message_error_printf 'running make installcheck'
	    exit_failure
	fi
    }
    mbfl_location_leave

    # Remove the unpacked source directory.
    {
	mbfl_message_verbose_printf 'removing the source directory: "%s"\n' QQ(CRE2_ABS_TOP_SRCDIR)
	if ! mbfl_file_remove QQ(CRE2_ABS_TOP_SRCDIR)
	then
	    mbfl_message_error_printf 'removing the source directory: "%s"\n' QQ(CRE2_ABS_TOP_SRCDIR)
	    exit_failure
	fi
    }

    mbfl_message_verbose_printf 'done\n'
}


#### script action functions: second level, action root "help"

function script_before_parsing_options_HELP_USAGE () {
    script_USAGE="usage: ${script_PROGNAME} help usage [options]"
    script_DESCRIPTION='Print the usage screen and exit.'
}
function script_action_HELP_USAGE () {
    if mbfl_wrong_num_args 0 $ARGC
    then
	# By faking the selection of  the MAIN action: we cause "mbfl_main_print_usage_screen_brief"
	# to print the main usage screen.
	mbfl_actions_fake_action_set MAIN
	mbfl_main_print_usage_screen_brief
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}

## --------------------------------------------------------------------

function script_before_parsing_options_HELP_PRINT_COMPLETIONS_SCRIPT () {
    script_PRINT_COMPLETIONS="usage: ${script_PROGNAME} help print-completions-script [options]"
    script_DESCRIPTION='Print the command-line completions script and exit.'
}
function script_action_HELP_PRINT_COMPLETIONS_SCRIPT () {
    if mbfl_wrong_num_args 0 $ARGC
    then mbfl_actions_completion_print_script "$COMPLETIONS_SCRIPT_NAMESPACE" "$script_PROGNAME"
    else
	mbfl_main_print_usage_screen_brief
	exit_because_wrong_num_args
    fi
}


#### required MBFL's version

function script_check_mbfl_semantic_version () {
    mbfl_declare_varref(REQUIRED_MBFL_VERSION, v3.0.0-devel.4)
    mbfl_declare_varref(RV)

    mbfl_message_debug_printf 'library version "%s", version required by the script "%s"' \
			      "$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
    if mbfl_semver_compare_var mbfl_datavar(RV) "$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
    then
	if (( RV >= 0 ))
	then return 0
	else
	    mbfl_message_error_printf \
		'hard-coded MBFL library version "%s" is lesser than the minimum version required by the script "%s"' \
		"$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
	    exit_because_invalid_mbfl_version
	fi
    else
	mbfl_message_error_printf 'invalid required semantic version for MBFL: "%s"' "$REQUIRED_MBFL_VERSION"
	exit_because_invalid_mbfl_version
    fi
}


#### interfaces to external programs

MBFL_DEFINE_PROGRAM_EXECUTOR([[[make]]],[[[make]]])
MBFL_DEFINE_PROGRAM_EXECUTOR([[[cmake]]],[[[cmake]]])


#### let's go

#mbfl_set_option_debug
mbfl_main

#!# end of file
# Local Variables:
# mode: sh
# End:
