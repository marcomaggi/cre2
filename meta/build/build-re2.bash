#!/bin/bash
#! Part of: CRE2
#! Contents: script template
#! Date: Aug 23, 2024
#!
#! Abstract
#!
#!	Build script to help installing "re2" and all its dependency packages.
#!
#! Copyright (c) 2024 Marco Maggi <mrc.mgg@gmail.com>
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
\t${script_PROGNAME} build benchmark
\t${script_PROGNAME} build re2"
declare -r COMPLETIONS_SCRIPT_NAMESPACE='p-build-re2'
#!# libmbfl-linker.bash.m4 --
#!#
#!# Part of: Marco's BASH Functions Library
#!# Contents: linker library
#!# Date: Jun 11, 2023
#!#
#!# Abstract
#!#
#!#	This library must be  standalone: it must not require any of the  functions in the core MBFL
#!#	libraries or any other libraries.
#!#
#!# Copyright (c) 2023, 2024 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#!# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#!# License, or (at your option) any later version.
#!#
#!# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#!# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#!# Lesser General Public License for more details.
#!#
#!# You should have received a copy of the  GNU Lesser General Public License along with this library;
#!# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#!# 02111-1307 USA.
#!#
function mbfl_module_init_linker () {
declare -gar MBFL_LINKER_DEFAULT_LIBRARY_PATH=('/usr/local/share/mbfl' '/usr/share/mbfl' '/share/mbfl')
declare -ga  MBFL_LINKER_LIBRARY_PATH=()
declare -a SPLITFIELD
declare -i SPLITCOUNT mbfl_I
if { test ${#MBFL_LIBRARY_PATH} -ne 0; }
then
mbfl_linker_split_search_path "$MBFL_LIBRARY_PATH" ':'
for ((mbfl_I=0; mbfl_I < SPLITCOUNT; ++mbfl_I))
do MBFL_LINKER_LIBRARY_PATH[$mbfl_I]="${SPLITFIELD[$mbfl_I]}"
done
fi
}
declare -gA MBFL_LINKER_FOUND_LIBRARIES=()
declare -gA MBFL_LINKER_LOADED_LIBRARIES=()
function mbfl_linker_find_library_by_stem () {
declare  mbfl_STEM=${1:?"missing MBFL library stem parameter to '$FUNCNAME'"}
if   test -n "${MBFL_LINKER_LOADED_LIBRARIES["$mbfl_STEM"]}"
then
return 1
elif test -n "${MBFL_LINKER_FOUND_LIBRARIES["$mbfl_STEM"]}"
then
return 0
else
declare mbfl_FOUND_LIBRARY_PATHNAME=
if mbfl_linker_search_by_stem_var mbfl_FOUND_LIBRARY_PATHNAME "$mbfl_STEM"
then
MBFL_LINKER_FOUND_LIBRARIES["$mbfl_STEM"]="$mbfl_FOUND_LIBRARY_PATHNAME"
return 0
else
printf 'libmbfl-linker: required MBFL library not found in search path: "%s"\n' "$mbfl_STEM"
exit_because_error_loading_library
fi
fi
}
function exit_because_error_loading_library () { exit 100; }
function mbfl_linker_search_by_stem_var () {
declare mbfl_a_variable_mbfl_RV=${1:?"missing result variable parameter to '$FUNCNAME'"}; declare -n mbfl_RV=$mbfl_a_variable_mbfl_RV 
declare  mbfl_STEM=${2:?"missing MBFL library stem parameter to '$FUNCNAME'"}
if   mbfl_linker_search_by_stem_in_search_path_var $mbfl_a_variable_mbfl_RV "$mbfl_STEM" MBFL_LINKER_LIBRARY_PATH
then return 0
elif mbfl_linker_search_by_stem_in_search_path_var $mbfl_a_variable_mbfl_RV "$mbfl_STEM" MBFL_LINKER_DEFAULT_LIBRARY_PATH
then return 0
else return 1
fi
}
function mbfl_linker_search_by_stem_in_search_path_var () {
declare mbfl_a_variable_mbfl_RV=${1:?"missing result variable parameter to '$FUNCNAME'"}; declare -n mbfl_RV=$mbfl_a_variable_mbfl_RV 
declare  mbfl_STEM=${2:?"missing MBFL library stem parameter to '$FUNCNAME'"}
declare mbfl_a_variable_mbfl_SEARCH_PATH=${3:?"missing MBFL library search path index array parameter to '$FUNCNAME'"}; declare -n mbfl_SEARCH_PATH=$mbfl_a_variable_mbfl_SEARCH_PATH 
declare -i mbfl_I mbfl_DIM=${#mbfl_SEARCH_PATH[@]}
declare mbfl_LIBRARY_PATHNAME
for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
do
printf -v mbfl_LIBRARY_PATHNAME '%s/libmbfl-%s.bash' "${mbfl_SEARCH_PATH[$mbfl_I]}" "$mbfl_STEM"
if { test '/' '!=' ${mbfl_LIBRARY_PATHNAME:0:1}; }
then printf -v mbfl_LIBRARY_PATHNAME '%s/%s' "$PWD" "$mbfl_LIBRARY_PATHNAME"
fi
if test -f "$mbfl_LIBRARY_PATHNAME"
then
if test -r "$mbfl_LIBRARY_PATHNAME"
then
mbfl_RV="$mbfl_LIBRARY_PATHNAME"
if test -n "$MBFL_LINKER_DEBUG" -a "$MBFL_LINKER_DEBUG" = 'true'
then printf 'libmbfl-linker.bash: found library: "%s"\n' "$mbfl_RV" >&2
fi
return 0
else
printf 'libmbfl-linker.bash: library file not readable: "%s"\n' "$mbfl_LIBRARY_PATHNAME" >&2
fi
fi
done
return 1
}
function mbfl_linker_split_search_path () {
declare  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
declare  SEPARATOR=${2:?"missing separator parameter to '$FUNCNAME'"}
declare -i i j k=0 first=0
SPLITFIELD=()
SPLITCOUNT=0
for ((i=0; i < ${#STRING}; ++i))
do
if (( (i + ${#SEPARATOR}) > ${#STRING}))
then break
elif mbfl_linker_string_equal_substring "$STRING" $i "$SEPARATOR"
then
SPLITFIELD[$k]=${STRING:$first:$((i - first))}
let ++k
let i+=${#SEPARATOR}-1
let first=i+1
fi
done
SPLITFIELD[$k]=${STRING:$first}
let ++k
SPLITCOUNT=$k
return 0
}
function mbfl_linker_string_equal_substring () {
declare  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
declare  POSITION=${2:?"missing position parameter to '$FUNCNAME'"}
declare  PATTERN=${3:?"missing pattern parameter to '$FUNCNAME'"}
local i
if (( (POSITION + ${#PATTERN}) > ${#STRING} ))
then return 1
fi
for ((i=0; i < ${#PATTERN}; ++i))
do
if test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}"
then return 1
fi
done
return 0
}
mbfl_module_init_linker
#!# end of file
if mbfl_linker_find_library_by_stem 'core'
then
MBFL_LINKER_LOADED_LIBRARIES[core]=true
source "${MBFL_LINKER_FOUND_LIBRARIES[core]}" || exit 100
fi
if mbfl_linker_find_library_by_stem 'arch'
then
MBFL_LINKER_LOADED_LIBRARIES[arch]=true
source "${MBFL_LINKER_FOUND_LIBRARIES[arch]}" || exit 100
fi
mbfl_program_enable_sudo
mbfl_file_enable_owner_and_group
mbfl_file_enable_permissions
mbfl_file_enable_tar
mbfl_declare_program cmake
mbfl_declare_program make
mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit
mbfl_declare_option BUILDDIR		''		''		builddir	witharg	      'The build directory.'
mbfl_declare_option INSTALL_PREFIX	''		''		install-prefix	witharg	      'The install directory prefix.'
mbfl_declare_option ABSEIL_TARBALL	''		''		abseil-tarball	witharg	      'Path to abseil tarball.'
mbfl_declare_action_set BUILD
mbfl_declare_action BUILD	BUILD_ABSEIL		NONE	abseil		'Build abseil.'
mbfl_declare_action BUILD	BUILD_GOOGLETEST	NONE	googletest	'Build GoogleTest.'
mbfl_declare_action BUILD	BUILD_BENCHMARK		NONE	benchmark	'Build Google Benchmark.'
mbfl_declare_action BUILD	BUILD_RE2		NONE	re2		'Build re2.'
mbfl_declare_action_set HELP
mbfl_declare_action HELP	HELP_USAGE	NONE		usage		'Print the help screen and exit.'
mbfl_declare_action HELP	HELP_PRINT_COMPLETIONS_SCRIPT NONE print-completions-script 'Print the completions script for this program.'
mbfl_declare_action_set MAIN
mbfl_declare_action MAIN	BUILD		BUILD		build		'Build packages.'
mbfl_declare_action MAIN	HELP		HELP		help		'Help the user of this script.'
function main () {
mbfl_actions_fake_action_set MAIN
mbfl_main_print_usage_screen_brief
}
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
function script_before_parsing_options_BUILD_ABSEIL () {
script_USAGE="usage: ${script_PROGNAME} build abseil [options]"
script_DESCRIPTION='Build the package "abseil".'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build abseil"
}
function script_action_BUILD_ABSEIL () {
declare -r ABSEIL_BUILDDIR="$script_option_BUILDDIR"
declare -r ABSEIL_TARBALL="$script_option_ABSEIL_TARBALL"
declare -r ABSEIL_INSTALL_PREFIX="$script_option_INSTALL_PREFIX"
declare mbfl_a_variable_ABSEIL_ABS_BUILDDIR;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_ABS_BUILDDIR ABSEIL_ABS_BUILDDIR;   declare  $mbfl_a_variable_ABSEIL_ABS_BUILDDIR;   declare -n ABSEIL_ABS_BUILDDIR=$mbfl_a_variable_ABSEIL_ABS_BUILDDIR;   ABSEIL_ABS_BUILDDIR=
declare mbfl_a_variable_ABSEIL_ABS_INSTALL_PREFIX;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_ABS_INSTALL_PREFIX ABSEIL_ABS_INSTALL_PREFIX;   declare  $mbfl_a_variable_ABSEIL_ABS_INSTALL_PREFIX;   declare -n ABSEIL_ABS_INSTALL_PREFIX=$mbfl_a_variable_ABSEIL_ABS_INSTALL_PREFIX;   ABSEIL_ABS_INSTALL_PREFIX=
declare mbfl_a_variable_ABSEIL_ABS_TARBALL;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_ABS_TARBALL ABSEIL_ABS_TARBALL;   declare  $mbfl_a_variable_ABSEIL_ABS_TARBALL;   declare -n ABSEIL_ABS_TARBALL=$mbfl_a_variable_ABSEIL_ABS_TARBALL;   ABSEIL_ABS_TARBALL=
declare mbfl_a_variable_ABSEIL_TAILNAME;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_TAILNAME ABSEIL_TAILNAME;   declare  $mbfl_a_variable_ABSEIL_TAILNAME;   declare -n ABSEIL_TAILNAME=$mbfl_a_variable_ABSEIL_TAILNAME;   ABSEIL_TAILNAME=
declare mbfl_a_variable_ABSEIL_VERSION;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_VERSION ABSEIL_VERSION;   declare  $mbfl_a_variable_ABSEIL_VERSION;   declare -n ABSEIL_VERSION=$mbfl_a_variable_ABSEIL_VERSION;   ABSEIL_VERSION=
declare mbfl_a_variable_ABSEIL_ABS_TOP_SRCDIR;   mbfl_variable_alloc mbfl_a_variable_ABSEIL_ABS_TOP_SRCDIR ABSEIL_ABS_TOP_SRCDIR;   declare  $mbfl_a_variable_ABSEIL_ABS_TOP_SRCDIR;   declare -n ABSEIL_ABS_TOP_SRCDIR=$mbfl_a_variable_ABSEIL_ABS_TOP_SRCDIR;   ABSEIL_ABS_TOP_SRCDIR=
{
mbfl_message_verbose_printf 'validating package build directory: "%s"\n' "$ABSEIL_BUILDDIR"
if ! mbfl_directory_is_writable "$ABSEIL_BUILDDIR" print_error
then exit_failure
fi
if ! mbfl_directory_is_executable "$ABSEIL_BUILDDIR" print_error
then exit_failure
fi
if ! mbfl_file_realpath_var $mbfl_a_variable_ABSEIL_ABS_BUILDDIR  "$ABSEIL_BUILDDIR"
then
mbfl_message_error_printf 'normalising package builddir: "%s"'  "$ABSEIL_BUILDDIR"
exit_failure
fi
mbfl_message_verbose_printf 'package build directory: "%s"\n' "$ABSEIL_ABS_BUILDDIR"
}
{
mbfl_message_verbose_printf 'validating package install prefix: "%s"\n' "$ABSEIL_INSTALL_PREFIX"
if ! mbfl_file_is_directory "$ABSEIL_INSTALL_PREFIX" print_error
then exit_failure
fi
if ! mbfl_file_realpath_var $mbfl_a_variable_ABSEIL_ABS_INSTALL_PREFIX  "$ABSEIL_INSTALL_PREFIX"
then
mbfl_message_error_printf 'normalising package install prefix: "%s"'  "$ABSEIL_INSTALL_PREFIX"
exit_failure
fi
mbfl_message_verbose_printf 'package install prefix: "%s"\n' "$ABSEIL_INSTALL_PREFIX"
}
{
mbfl_message_verbose_printf 'validating package tarball pathname: "%s"\n' "$ABSEIL_TARBALL"
if ! mbfl_file_is_readable "$ABSEIL_TARBALL" print_error
then exit_failure
fi
if ! mbfl_file_realpath_var $mbfl_a_variable_ABSEIL_ABS_TARBALL  "$ABSEIL_TARBALL"
then
mbfl_message_error_printf 'normalising package pathname: "%s"'  "$ABSEIL_TARBALL"
exit_failure
fi
mbfl_message_verbose_printf 'package tarball pathname: "%s"\n' "$ABSEIL_ABS_TARBALL"
}
{
declare -r TAILNAME_REX='abseil-cpp-([0-9]+\.[0-9]+).tar.gz'
mbfl_file_tail_var $mbfl_a_variable_ABSEIL_TAILNAME  "$ABSEIL_ABS_TARBALL"
if [[ "$ABSEIL_TAILNAME" =~ $TAILNAME_REX ]]
then ABSEIL_VERSION=${BASH_REMATCH[1]}
else
mbfl_message_error_printf 'cannot extract version number from tarball tailname: "%s"'  "$ABSEIL_TAILNAME"
exit_failure
fi
mbfl_message_verbose_printf 'package version specification: "%s"\n' "$ABSEIL_VERSION"
}
{
mbfl_message_verbose_printf 'unpacking the archive\n'
declare TAR_FLAGS='--gunzip'
if mbfl_option_verbose_program
then TAR_FLAGS+=' --verbose'
fi
if ! mbfl_tar_extract_from_file "$ABSEIL_ABS_BUILDDIR" "$ABSEIL_ABS_TARBALL" $TAR_FLAGS
then
mbfl_message_error_printf 'unpacking abseil'
exit_failure
fi
}
{
printf -v ABSEIL_ABS_TOP_SRCDIR '%s/abseil-cpp-%s' "$ABSEIL_ABS_BUILDDIR" "$ABSEIL_VERSION"
mbfl_message_verbose_printf 'validating package top source directory: "%s"\n' "$ABSEIL_ABS_TOP_SRCDIR"
if ! mbfl_directory_is_writable "$ABSEIL_ABS_TOP_SRCDIR" print_error
then exit_failure
fi
if ! mbfl_directory_is_executable "$ABSEIL_ABS_TOP_SRCDIR" print_error
then exit_failure
fi
mbfl_message_verbose_printf 'package top source directory: "%s"\n' "$ABSEIL_ABS_TOP_SRCDIR"
}
mbfl_location_enter
{
mbfl_location_handler_change_directory "$ABSEIL_ABS_TOP_SRCDIR"
# Add lines to "CMakeLists.txt".
#printf -v ABSEIL_CONFIG_LINE 'set(CMAKE_INSTALL_PREFIX "%s")' QQ(ABSEIL_INSTALLDIR)
mbfl_message_verbose_printf 'configuring the package\n'
if ! program_cmake . --install-prefix "$ABSEIL_ABS_INSTALL_PREFIX"
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
if ! (umask 0; mbfl_program_declare_sudo_user 'root'; program_make install)
then
mbfl_message_error_printf 'running make'
exit_failure
fi
}
mbfl_location_leave
{
declare ABSEIL_INSTALL_MANIFEST
declare mbfl_a_variable_USERNAME;   mbfl_variable_alloc mbfl_a_variable_USERNAME USERNAME;   declare  $mbfl_a_variable_USERNAME;   declare -n USERNAME=$mbfl_a_variable_USERNAME;   USERNAME=
printf -v ABSEIL_INSTALL_MANIFEST '%s/install_manifest.txt' "$ABSEIL_ABS_TOP_SRCDIR"
if mbfl_file_is_file "$ABSEIL_INSTALL_MANIFEST"
then
if ! mbfl_system_whoami_var $mbfl_a_variable_USERNAME 
then
mbfl_message_error_printf 'cannot determine the username using "whoami"'
exit_failure
fi
mbfl_message_verbose_printf 'changing to "%s" owner of: "%s"\n' "$USERNAME" "$ABSEIL_INSTALL_MANIFEST"
mbfl_program_declare_sudo_user 'root'
if ! mbfl_exec_chown "$USERNAME" "$ABSEIL_INSTALL_MANIFEST"
then
mbfl_message_error_printf 'cannot change the owner of: "%s"' "$ABSEIL_INSTALL_MANIFEST"
exit_failure
fi
fi
mbfl_message_verbose_printf 'removing the source directory: "%s"\n' "$ABSEIL_ABS_TOP_SRCDIR"
if ! mbfl_file_remove "$ABSEIL_ABS_TOP_SRCDIR"
then
mbfl_message_error_printf 'removing the source directory: "%s"\n' "$ABSEIL_ABS_TOP_SRCDIR"
exit_failure
fi
}
mbfl_message_verbose_printf 'done\n'
}
function script_before_parsing_options_BUILD_GOOGLETEST () {
script_USAGE="usage: ${script_PROGNAME} build googletest [options]"
script_DESCRIPTION='Build the package "googletest".'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build googletest"
}
function script_action_BUILD_GOOGLETEST () {
false
}
function script_before_parsing_options_BUILD_RE2 () {
script_USAGE="usage: ${script_PROGNAME} build re2 [options]"
script_DESCRIPTION='Build the package "re2".'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} build re2"
}
function script_action_BUILD_RE2 () {
false
}
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
function script_check_mbfl_semantic_version () {
declare mbfl_a_variable_REQUIRED_MBFL_VERSION;   mbfl_variable_alloc mbfl_a_variable_REQUIRED_MBFL_VERSION REQUIRED_MBFL_VERSION;   declare  $mbfl_a_variable_REQUIRED_MBFL_VERSION;   declare -n REQUIRED_MBFL_VERSION=$mbfl_a_variable_REQUIRED_MBFL_VERSION;   REQUIRED_MBFL_VERSION=v3.0.0-devel.4
declare mbfl_a_variable_RV;   mbfl_variable_alloc mbfl_a_variable_RV RV;   declare  $mbfl_a_variable_RV;   declare -n RV=$mbfl_a_variable_RV;   RV=
mbfl_message_debug_printf 'library version "%s", version required by the script "%s"' \
"$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
if mbfl_semver_compare_var $mbfl_a_variable_RV "$mbfl_SEMANTIC_VERSION" "$REQUIRED_MBFL_VERSION"
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
function program_make () {
declare mbfl_a_variable_PROGRAM;   mbfl_variable_alloc mbfl_a_variable_PROGRAM PROGRAM;   declare  $mbfl_a_variable_PROGRAM;   declare -n PROGRAM=$mbfl_a_variable_PROGRAM;   PROGRAM=
mbfl_program_found_var $mbfl_a_variable_PROGRAM make || exit $?
mbfl_program_exec "$PROGRAM"  "$@"
}
function program_cmake () {
declare mbfl_a_variable_PROGRAM;   mbfl_variable_alloc mbfl_a_variable_PROGRAM PROGRAM;   declare  $mbfl_a_variable_PROGRAM;   declare -n PROGRAM=$mbfl_a_variable_PROGRAM;   PROGRAM=
mbfl_program_found_var $mbfl_a_variable_PROGRAM cmake || exit $?
mbfl_program_exec "$PROGRAM"  "$@"
}
mbfl_main
#!# end of file
