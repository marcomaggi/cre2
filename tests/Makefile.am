## Process this file with automake to produce Makefile.in

check_PROGRAMS	= \
	test-version			\
	test-options			\
	test-rex-alloc			\
	test-matching			\
	test-easy-matching		\
	test-full-match			\
	test-partial-match		\
	test-consume-match		\
	test-find-and-consume-match	\
	test-replace			\
	test-misc

AM_CPPFLAGS	= -I$(top_srcdir)/src
LDADD		= ../src/libcre2.la
TESTS		= $(check_PROGRAMS)

### end of file
