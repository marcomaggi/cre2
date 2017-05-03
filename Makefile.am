## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= INSTALL configure.sh prepare.sh
dist_doc_DATA		= README COPYING LICENSE.re2 RELEASE-NOTES
AM_CFLAGS		= -I$(srcdir)/src -Wall

## --------------------------------------------------------------------

EXTRA_DIST		+= meta/scripts/cre2.pc.in
pkgconfigdir		= $(libdir)/pkgconfig
nodist_pkgconfig_DATA	= meta/scripts/cre2.pc

## --------------------------------------------------------------------

cre2_CURRENT		= @cre2_VERSION_INTERFACE_CURRENT@
cre2_REVISION		= @cre2_VERSION_INTERFACE_REVISION@
cre2_AGE		= @cre2_VERSION_INTERFACE_AGE@

include_HEADERS		= src/cre2.h

lib_LTLIBRARIES		= libcre2.la
libcre2_la_CFLAGS	= $(RE2_CFLAGS)
libcre2_la_CXXFLAGS	= $(RE2_CFLAGS)
libcre2_la_LDFLAGS	= -version-info $(cre2_CURRENT):$(cre2_REVISION):$(cre2_AGE) $(RE2_LIBS)
libcre2_la_SOURCES	= src/cre2.cpp

## --------------------------------------------------------------------

AM_MAKEINFOFLAGS	= --no-split

info_TEXINFOS		= doc/cre2.texi
doc_cre2_TEXINFOS	= doc/fdl-1.3.texi

## --------------------------------------------------------------------

CRE2_COMMON_TEST_SOURCES		= tests/cre2-test.h
tests_test_version_SOURCES		= tests/test-version.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_options_SOURCES		= tests/test-options.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_rex_alloc_SOURCES		= tests/test-rex-alloc.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_matching_SOURCES		= tests/test-matching.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_easy_matching_SOURCES	= tests/test-easy-matching.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_full_match_SOURCES		= tests/test-full-match.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_partial_match_SOURCES	= tests/test-partial-match.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_consume_match_SOURCES	= tests/test-consume-match.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_find_and_consume_match_SOURCES = tests/test-find-and-consume-match.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_replace_SOURCES		= tests/test-replace.c $(CRE2_COMMON_TEST_SOURCES)
tests_test_misc_SOURCES			= tests/test-misc.c $(CRE2_COMMON_TEST_SOURCES)

check_PROGRAMS		= \
	tests/test-version			\
	tests/test-options			\
	tests/test-rex-alloc			\
	tests/test-matching			\
	tests/test-easy-matching		\
	tests/test-full-match			\
	tests/test-partial-match		\
	tests/test-consume-match		\
	tests/test-find-and-consume-match	\
	tests/test-replace			\
	tests/test-set				\
	tests/test-misc

AM_CPPFLAGS		= -I$(top_srcdir)/src
LDADD			= libcre2.la
TESTS			= $(check_PROGRAMS)

installcheck-local: $(check_PROGRAMS)
	for f in $(check_PROGRAMS); do $$f; done

#page
#### Coverity support
#
# We can visit the project site at:
#
#    <https://scan.coverity.com/projects/marcomaggi-cre2>
#
# Remember to  put in  the PATH  the directory  in which  the Coverity
# tools are installed; for example:
#
#    $ export PATH=/opt/coverity/8.7.0/cov-analysis-linux64-8.7.0/bin:$PATH
#
# The tool  will use  a temporary directory  "$(builddir)/cov-int"; we
# must *not* change this pathname.
#
# To generate and submit a report we must do:
#
#    $ make clean
#    $ make coverity-scan
#    $ make coverity-archive
#    $ make coverity-upload
#
# after "make  coverity-scan" we should  check that the last  lines of
# the file "cov-int/build-log.txt" report a successful build:
#
#    $ tail cov-int/build-log.txt
#
# NOTE If  your Linux kernel  is at version 4.8  or above you  have to
# first issue the command:
#
#    $ sudo /sbin/sysctl vsyscall=emulate
#
# to make the Coverity tools work.
#

CRE2_COVERITY_TOKEN_FILE = /home/unsafe-users/marco-devel/.coverity-cre2-token

.PHONY: coverity-scan coverity-archive coverity-upload

coverity-scan:
	cov-build --dir cov-int make -j 4

coverity-archive:
	tar caf cre2.xz cov-int

coverity-upload:
	curl --form token=$$(<$(CRE2_COVERITY_TOKEN_FILE)) \
	     --form email='marco.maggi-ipsu@poste.it' \
	     --form file='@cre2.xz' \
	     --form version="$(VERSION)" \
	     --form description="A build description" \
	     'https://scan.coverity.com/builds?project=marcomaggi%2Fcre2'

#page
#### Static analysis with Clang's Static Analyzer
#
# See the documentation for the command line tool at:
#
#    <http://clang-analyzer.llvm.org/scan-build.html>
#
# To run the tool we must do:
#
#    $ make clean
#    $ make clang-static-analysis
#
# The  program  "scan-build"  works  by  overriding  the  CC  and  CXX
# environment variables.  Automake defines CXX as:
#
#    CXX = g++ -std=c++11
#
# so we override CXXFLAGS to include the language specification.
#

.PHONY: clang-static-analysis

clang-static-analysis:
	scan-build make CXXFLAGS='-std=c++11'

### end of file
