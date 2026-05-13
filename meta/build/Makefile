# Makefile --
#
# We can set "MBFLPP_FLAGS" on the command line of "make":
#
#    $ make MBFLPP_FLAGS="..."
#

SUDO		= /usr/bin/sudo
RM		= /bin/rm --force --verbose --recursive
CP		= /bin/cp --verbose --interactive

INSTALL		= /bin/install
INSTALL_DIR	= $(INSTALL) --mode=0750 --directory
INSTALL_FILE	= $(INSTALL) --mode=0640

CRE2_BUILDDIR	= $(PWD)/../../\=build.master/

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

POD1_ARCHIVES		= /home/unsafe-users/marco-admin/src/lib/re2/
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
	test -f $(POD1_ROOTDIR)/$(POD1_ABSEIL)     || $(INSTALL_FILE) $(POD1_ARCHIVES)/$(POD1_ABSEIL)     $(POD1_ROOTDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_GOOGLETEST) || $(INSTALL_FILE) $(POD1_ARCHIVES)/$(POD1_GOOGLETEST) $(POD1_ROOTDIR)
	test -f $(POD1_ROOTDIR)/$(POD1_RE2)        || $(INSTALL_FILE) $(POD1_ARCHIVES)/$(POD1_RE2)        $(POD1_ROOTDIR)
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


#### stuff for POD2

POD2_ARCHIVES		= /home/unsafe-users/marco-admin/src/lib/re2/
POD2_ROOTDIR		= $(PWD)/POD2/
POD2_INSTALLDIR		= $(POD2_ROOTDIR)/build
POD2_SHARED_INSTALLDIR	= $(POD2_INSTALLDIR)/shared
POD2_STATIC_INSTALLDIR	= $(POD2_INSTALLDIR)/static

POD2_ABSEIL		= abseil-cpp-20260107.1.tar.gz
POD2_GOOGLETEST		= googletest-1.17.0.tar.gz
POD2_RE2		= re2-2025-11-05.tar.gz
POD2_CRE2		= $(notdir $(wildcard $(CRE2_BUILDDIR)/cre2-*.tar.gz))

.PHONY: pod2 pod2-clean
.PHONY: pod2-shared-installdir pod2-shared-uninstall
.PHONY: pod2-static-installdir pod2-static-uninstall
.PHONY: pod2-shared pod2-shared-abseil pod2-shared-googletest pod2-shared-re2 pod2-shared-cre2
.PHONY: pod2-static pod2-static-abseil pod2-static-googletest pod2-static-re2

pod2: pod2-archives pod2-shared pod2-static

pod2-clean:
	$(RM) $(POD2_ROOTDIR)

# Watch out for the order of the prerequisites: it is left-to-right!
pod2-shared: script pod2-archives pod2-shared-abseil pod2-shared-googletest pod2-shared-re2 pod2-shared-cre2
pod2-static: script pod2-archives pod2-static-abseil pod2-static-googletest pod2-static-re2 pod2-static-cre2

pod2-archives:
	test -d $(POD2_ROOTDIR)			   || $(INSTALL_DIR) $(POD2_ROOTDIR)
	test -d $(POD2_INSTALLDIR)		   || $(INSTALL_DIR) $(POD2_INSTALLDIR)
	test -d $(POD2_SHARED_INSTALLDIR)	   || $(INSTALL_DIR) $(POD2_SHARED_INSTALLDIR)
	test -d $(POD2_STATIC_INSTALLDIR)	   || $(INSTALL_DIR) $(POD2_STATIC_INSTALLDIR)
	test -f $(POD2_ROOTDIR)/$(POD2_ABSEIL)     || $(INSTALL_FILE) $(POD2_ARCHIVES)/$(POD2_ABSEIL)     $(POD2_ROOTDIR)
	test -f $(POD2_ROOTDIR)/$(POD2_GOOGLETEST) || $(INSTALL_FILE) $(POD2_ARCHIVES)/$(POD2_GOOGLETEST) $(POD2_ROOTDIR)
	test -f $(POD2_ROOTDIR)/$(POD2_RE2)        || $(INSTALL_FILE) $(POD2_ARCHIVES)/$(POD2_RE2)        $(POD2_ROOTDIR)
	test -f $(POD2_ROOTDIR)/$(POD2_CRE2)       || $(INSTALL_FILE) $(CRE2_BUILDDIR)/$(POD2_CRE2)     $(POD2_ROOTDIR)

## ------------------------------------------------------------------------

pod2-shared-uninstall:
	$(SUDO) $(RM) $(POD2_SHARED_INSTALLDIR)

pod2-shared-abseil: script
	bash ./build-re2.bash build abseil				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_SHARED_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_ABSEIL)

pod2-shared-googletest: script
	bash ./build-re2.bash build googletest				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_SHARED_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_GOOGLETEST)

pod2-shared-re2: script pod2-shared-abseil pod2-shared-googletest
	bash ./build-re2.bash build re2					\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_SHARED_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_RE2)

pod2-shared-cre2: script pod2-shared-abseil pod2-shared-googletest
	bash ./build-re2.bash build cre2				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_SHARED_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_CRE2)

## ------------------------------------------------------------------------

pod2-static-uninstall:
	$(SUDO) $(RM) $(POD2_STATIC_INSTALLDIR)

pod2-static-abseil: script
	bash ./build-re2.bash build abseil				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_STATIC_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_ABSEIL)		\
		--enable-static

pod2-static-googletest: script
	bash ./build-re2.bash build googletest				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_STATIC_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_GOOGLETEST)		\
		--enable-static

pod2-static-re2: script pod2-static-abseil pod2-static-googletest
	bash ./build-re2.bash build re2					\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_STATIC_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_RE2)			\
		--enable-static

pod2-static-cre2: script pod2-static-abseil pod2-static-googletest
	bash ./build-re2.bash build cre2				\
		--builddir=$(POD2_ROOTDIR)				\
		--install-prefix=$(POD2_STATIC_INSTALLDIR)		\
		--tarball=$(POD2_ROOTDIR)/$(POD2_CRE2)			\
		--enable-static

### end of file
