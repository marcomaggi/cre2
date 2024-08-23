# Makefile --
#
# We can set "MBFLPP_FLAGS" on the command line of "make":
#
#    $ make MBFLPP_FLAGS="..."
#

# The directory in which all the tarballs are located.
PACKAGES_ARCHIVES_DIR	= ~/var/build/lib/

# The directory under which all the tarballs will be unpacked and built.
PACKAGES_ROOT_BUILDDIR	= ~/var/build/lib/

# The installation prefix of all the packages.
PACKAGES_INSTALL_PREFIX	= /opt/re2/

## ------------------------------------------------------------------------

ABSEIL_VERSION			?= 20240722.0
ABSEIL_STEM			?= abseil-cpp
ABSEIL_TARBALL_FILENAME		?= $(ABSEIL_STEM)-$(ABSEIL_VERSION).tar.gz
ABSEIL_TARBALL_ABSNAME		?= $(PACKAGES_ARCHIVES_DIR)/$(ABSEIL_TARBALL_FILENAME)
ABSEIL_TOP_SRCDIR		?= $(PACKAGES_ROOT_BUILDDIR)/$(ABSEIL_STEM)-$(ABSEIL_VERSION)

## ------------------------------------------------------------------------

GOOGLETEST_VERSION		= 1.15.2
GOOGLETEST_STEM			= googletest
GOOGLETEST_TARBALL_FILENAME	= $(GOOGLETEST_STEM)-$(GOOGLETEST_VERSION).tar.gz
GOOGLETEST_TARBALL_ABSNAME	= $(PACKAGES_ARCHIVES_DIR)/$(GOOGLETEST_TARBALL_FILENAME)
GOOGLETEST_TOP_SRCDIR		= $(PACKAGES_ROOT_BUILDDIR)/$(GOOGLETEST_STEM)-$(GOOGLETEST_VERSION)

## ------------------------------------------------------------------------

BENCHMARK_VERSION		= 1.9.0
BENCHMARK_STEM			= benchmark
BENCHMARK_TARBALL_FILENAME	= $(BENCHMARK_STEM)-$(BENCHMARK_VERSION).tar.gz
BENCHMARK_TARBALL_ABSNAME	= $(PACKAGES_ARCHIVES_DIR)/$(BENCHMARK_TARBALL_FILENAME)
BENCHMARK_TOP_SRCDIR		= $(PACKAGES_ROOT_BUILDDIR)/$(BENCHMARK_STEM)-$(BENCHMARK_VERSION)

## ------------------------------------------------------------------------

RE2_VERSION			= 2024-07-02
RE2_STEM			= re2
RE2_TARBALL_FILENAME		= $(RE2_STEM)-$(RE2_VERSION).tar.gz
RE2_TARBALL_ABSNAME		= $(PACKAGES_ARCHIVES_DIR)/$(RE2_TARBALL_FILENAME)
RE2_TOP_SRCDIR			= $(PACKAGES_ROOT_BUILDDIR)/$(RE2_STEM)-$(RE2_VERSION)

## ------------------------------------------------------------------------

MBFL_TARGETS		= build-re2.bash
MBFL_SOURCES		= build-re2.bash.m4

MBFL_LINKER_LIBRARY	= /share/mbfl/libmbfl-linker.bash
MBFLPP			= mbflpp.bash
MBFLPP_ENV		=
AM_MBFLPP_FLAGS		= --add-bash --define=__LIBMBFL_LINKER__=$(MBFL_LINKER_LIBRARY)
MBFLPP_COMPILE		= $(MBFLPP_ENV) $(MBFLPP) $(AM_MBFLPP_FLAGS) $(MBFL_FLAGS)

## ------------------------------------------------------------------------

RM	= /bin/rm --force --verbose

.PHONY: all clean

all: $(MBFL_TARGETS)

clean:
	$(RM) $(MBFL_TARGETS)

%.bash : %.bash.m4
	$(MBFLPP_COMPILE) --output=$@ $<

## ------------------------------------------------------------------------

.PHONY: pod1

pod1:
	bash ./build-re2.bash build abseil				\
		--builddir=POD1						\
		--install-prefix=/opt/re2/2024-07-02			\
		--abseil-tarball=POD1/abseil-cpp-20240722.0.tar.gz


### end of file
