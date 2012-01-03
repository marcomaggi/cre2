## Process this file with automake to produce Makefile.in

cre2_CURRENT	= @cre2_VERSION_INTERFACE_CURRENT@
cre2_REVISION	= @cre2_VERSION_INTERFACE_REVISION@
cre2_AGE	= @cre2_VERSION_INTERFACE_AGE@

include_HEADERS	= cre2.h

lib_LTLIBRARIES		= libcre2.la
libcre2_la_LDFLAGS	= -version-info $(cre2_CURRENT):$(cre2_REVISION):$(cre2_AGE)
libcre2_la_SOURCES	= cre2.cpp

### end of file
