## Process this file with automake to produce Makefile.in

check_PROGRAMS	= \
	test-version		\
	test-options		\
	test-rex-alloc		\
	test-matching

AM_CPPFLAGS	= -I$(top_srcdir)/src
LDADD		= ../src/libcre2.la
TESTS		= $(check_PROGRAMS)

#EXTRA_DIST	= test-utils.h

### end of file
