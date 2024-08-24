# Makefile --
#
# We can set "MBFLPP_FLAGS" on the command line of "make":
#
#    $ make MBFLPP_FLAGS="..."
#

RM	= /bin/rm --force --verbose

.PHONY: all clean

all: pod1

clean: clean-script


#### script

MBFL_TARGETS		= build-re2.bash
MBFL_SOURCES		= build-re2.bash.m4

MBFL_LINKER_LIBRARY	= /share/mbfl/libmbfl-linker.bash
MBFLPP			= mbflpp.bash
MBFLPP_ENV		=
AM_MBFLPP_FLAGS		= --add-bash --define=__LIBMBFL_LINKER__=$(MBFL_LINKER_LIBRARY)
MBFLPP_COMPILE		= $(MBFLPP_ENV) $(MBFLPP) $(AM_MBFLPP_FLAGS) $(MBFL_FLAGS)

.PHONY: script clean-script

script: $(MBFL_TARGETS)

clean-script:
	$(RM) $(MBFL_TARGETS)

%.bash : %.bash.m4
	$(MBFLPP_COMPILE) --output=$@ $<


#### stuff for POD1

POD1_PACKAGE_ABSEIL	= abseil-cpp-20240722.0.tar.gz
POD1_PACKAGE_GOOGLETEST	= googletest-1.15.2.tar.gz
POD1_PACKAGE_RE2	= re2-2024-07-02.tar.gz

POD1_INSTALLDIR		= /opt/re2/2024-07-02
POD1_SHARED_INSTALLDIR	= $(POD1_INSTALLDIR)/shared
POD1_STATIC_INSTALLDIR	= $(POD1_INSTALLDIR)/static

.PHONY: pod1
.PHONY: pod1-shared pod1-shared-abseil pod1-shared-googletest pod1-shared-re2
.PHONY: pod1-static pod1-static-abseil pod1-static-googletest pod1-static-re2

pod1: pod1-shared pod1-static

# Watch out for the order of the prerequisites: it is left-to-right!
pod1-shared: script pod1-shared-abseil pod1-shared-googletest pod1-shared-re2
pod1-static: script pod1-static-abseil pod1-static-googletest pod1-static-re2

## ------------------------------------------------------------------------

pod1-shared-abseil: script
	bash ./build-re2.bash build abseil				\
		--builddir=POD1						\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=./POD1/$(POD1_PACKAGE_ABSEIL)

pod1-shared-googletest: script
	bash ./build-re2.bash build googletest				\
		--builddir=POD1						\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=./POD1/$(POD1_PACKAGE_GOOGLETEST)

pod1-shared-re2: script pod1-shared-abseil pod1-shared-googletest
	bash ./build-re2.bash build re2					\
		--builddir=POD1						\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=./POD1/$(POD1_PACKAGE_RE2)

### end of file
