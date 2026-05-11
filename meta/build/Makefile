# Makefile --
#
# We can set "MBFLPP_FLAGS" on the command line of "make":
#
#    $ make MBFLPP_FLAGS="..."
#

ARCHIVESDIR	= /home/unsafe-users/marco-admin/src/lib/re2/POD1

SUDO		= /usr/bin/sudo
RM		= /bin/rm --force --verbose --recursive
CP		= /bin/cp --verbose --interactive

INSTALL		= /bin/install
INSTALL_DIR	= $(INSTALL) --mode=0750 --directory
INSTALL_FILE	= $(INSTALL) --mode=0640

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

CRE2_BUILDDIR		= $(PWD)/../../\=build.master/
POD1_ROOTDIR		= $(PWD)/POD1/
POD1_INSTALLDIR		= $(POD1_ROOTDIR)/build
POD1_SHARED_INSTALLDIR	= $(POD1_INSTALLDIR)/shared
POD1_STATIC_INSTALLDIR	= $(POD1_INSTALLDIR)/static

POD1_ABSEIL		= abseil-cpp-20240722.0.tar.gz
POD1_GOOGLETEST		= googletest-1.15.2.tar.gz
POD1_RE2		= re2-2024-07-02.tar.gz
POD1_CRE2		= $(notdir $(wildcard $(CRE2_BUILDDIR)/cre2-*.tar.gz))

.PHONY: pod1 pod1-clean
.PHONY: pod1-shared-installdir pod1-shared-uninstall
.PHONY: pod1-static-installdir pod1-static-uninstall
.PHONY: pod1-shared pod1-shared-abseil pod1-shared-googletest pod1-shared-re2 pod1-shared-cre2
.PHONY: pod1-static pod1-static-abseil pod1-static-googletest pod1-static-re2

pod1: pod1-archives pod1-shared pod1-static

pod1-clean:
	$(RM) $(POD1_ROOTDIR)

# Watch out for the order of the prerequisites: it is left-to-right!
pod1-shared: script pod1-archives pod1-shared-abseil pod1-shared-googletest pod1-shared-re2 pod1-shared-cre2
pod1-static: script pod1-archives pod1-static-abseil pod1-static-googletest pod1-static-re2 pod1-static-cre2

pod1-archives:
	test -d $(POD1_ROOTDIR)			   || $(INSTALL_DIR) $(POD1_ROOTDIR)
	test -d $(POD1_INSTALLDIR)		   || $(INSTALL_DIR) $(POD1_INSTALLDIR)
	test -d $(POD1_SHARED_INSTALLDIR)	   || $(INSTALL_DIR) $(POD1_SHARED_INSTALLDIR)
	test -d $(POD1_STATIC_INSTALLDIR)	   || $(INSTALL_DIR) $(POD1_STATIC_INSTALLDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_ABSEIL)     || $(INSTALL_FILE) $(ARCHIVESDIR)/$(POD1_ABSEIL)     $(POD1_ROOTDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_GOOGLETEST) || $(INSTALL_FILE) $(ARCHIVESDIR)/$(POD1_GOOGLETEST) $(POD1_ROOTDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_RE2)        || $(INSTALL_FILE) $(ARCHIVESDIR)/$(POD1_RE2)        $(POD1_ROOTDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_CRE2)       || $(INSTALL_FILE) $(CRE2_BUILDDIR)/$(POD1_CRE2)     $(POD1_ROOTDIR)

## ------------------------------------------------------------------------

pod1-shared-uninstall:
	$(SUDO) $(RM) $(POD1_SHARED_INSTALLDIR)

pod1-shared-abseil: script
	bash ./build-re2.bash build abseil				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_ABSEIL)

pod1-shared-googletest: script
	bash ./build-re2.bash build googletest				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_GOOGLETEST)

pod1-shared-re2: script pod1-shared-abseil pod1-shared-googletest
	bash ./build-re2.bash build re2					\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_RE2)

pod1-shared-cre2: script pod1-shared-abseil pod1-shared-googletest
	bash ./build-re2.bash build cre2				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_SHARED_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_CRE2)

## ------------------------------------------------------------------------

pod1-static-uninstall:
	$(SUDO) $(RM) $(POD1_STATIC_INSTALLDIR)

pod1-static-abseil: script
	bash ./build-re2.bash build abseil				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_STATIC_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_ABSEIL)		\
		--enable-static

pod1-static-googletest: script
	bash ./build-re2.bash build googletest				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_STATIC_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_GOOGLETEST)		\
		--enable-static

pod1-static-re2: script pod1-static-abseil pod1-static-googletest
	bash ./build-re2.bash build re2					\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_STATIC_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_RE2)			\
		--enable-static

pod1-static-cre2: script pod1-static-abseil pod1-static-googletest
	bash ./build-re2.bash build cre2				\
		--builddir=$(POD1_ROOTDIR)				\
		--install-prefix=$(POD1_STATIC_INSTALLDIR)		\
		--tarball=$(POD1_ROOTDIR)/$(POD1_CRE2)			\
		--enable-static

### end of file
