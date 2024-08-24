# cre2

## Introduction

The CRE2 distribution is a C language wrapper for the RE2 library, which
is implemented in C++.  RE2 is a fast, safe, thread-friendly alternative
to  backtracking regular  expression engines  like those  used in  PCRE,
Perl, and Python.

  This  distribution  makes use  of  the  GNU  Autotools; it  relies  on
`pkg-config`  to  find the  installed  re2  library  The last  time  the
maintainer updated  this paragraph,  he had tested  this package  with a
checkout of re2 on Apr 11, 2017.


## License

Copyright (c) 2012, 2013, 2015-2017, 2019, 2024 Marco Maggi <mrc.mgg@gmail.com><br/>
Copyright (c) 2011 Keegan McAllister<br/>
All rights reserved.

Redistribution  and use  in source  and  binary forms,  with or  without
modification, are  permitted provided that the  following conditions are
met:

1.  Redistributions  of source  code  must  retain the  above  copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions  in binary  form must  reproduce the  above copyright
   notice, this list  of conditions and the following  disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the author  nor the names of his contributors may
   be used  to endorse  or promote products  derived from  this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS
IS'' AND ANY  EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED
TO,  THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS  FOR  A
PARTICULAR PURPOSE  ARE DISCLAIMED.   IN NO EVENT  SHALL THE  AUTHORS OR
CONTRIBUTORS BE  LIABLE FOR  ANY DIRECT, INDIRECT,  INCIDENTAL, SPECIAL,
EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES  (INCLUDING, BUT  NOT LIMITED  TO,
PROCUREMENT  OF SUBSTITUTE  GOODS OR  SERVICES;  LOSS OF  USE, DATA,  OR
PROFITS; OR BUSINESS  INTERRUPTION) HOWEVER CAUSED AND ON  ANY THEORY OF
LIABILITY,  WHETHER IN  CONTRACT, STRICT  LIABILITY, OR  TORT (INCLUDING
NEGLIGENCE  OR OTHERWISE)  ARISING IN  ANY WAY  OUT OF  THE USE  OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## Install

To install from a proper release tarball, do this:

```
$ cd cre2-0.1.0
$ mkdir build
$ cd build
$ ../configure
$ make
$ make check
$ make install
```

to inspect the available configuration options:

```
$ ../configure --help
```

The Makefile is designed to allow parallel builds, so we can do:

```
$ make -j4 all && make -j4 check
```

which,  on  a  4-core  CPU,   should  speed  up  building  and  checking
significantly.

The Makefile supports the DESTDIR  environment variable to install files
in a temporary location, example: to see what will happen:

```
$ make -n install DESTDIR=/tmp/cre2
```

to really do it:

```
$ make install DESTDIR=/tmp/cre2
```

After the  installation it is  possible to verify the  installed library
against the test suite with:

```
$ make installcheck
```

From a repository checkout or snapshot  (the ones from the Github site):
we  must install  the GNU  Autotools  (GNU Automake,  GNU Autoconf,  GNU
Libtool), then  we must first run  the script "autogen.sh" from  the top
source directory, to generate the needed files:

```
$ cd cre2
$ sh autogen.sh

```

notice  that  `autogen.sh`  will   run  the  programs  `autoreconf`  and
`libtoolize`; the  latter is  selected through the  environment variable
`LIBTOOLIZE`,  whose  value  can  be  customised;  for  example  to  run
`glibtoolize` rather than `libtoolize` we do:

```
$ LIBTOOLIZE=glibtoolize sh autogen.sh
```

After this  the procedure  is the same  as the one  for building  from a
proper release tarball, but we have to enable maintainer mode:

```
$ ../configure --enable-maintainer-mode [options]
$ make
$ make check
$ make install
```

## Usage

Read the documentation.


## Credits

RE2 is  a Google project.  CRE2  is based on code  by Keegan McAllister.
This distribution was assembled by Marco Maggi.

  Matthew  Hall (https://github.com/megahall)  contributed miscellaneous
fixes.

  Maksym  Melnychok (https://github.com/keymone)  contributed a  fix for
wrong usage of variable-length arrays.

  afiaux    (https://github.com/afiaux)   contributed    the   RE2:Set()
interface.

  Guillaume Mass�  (https://github.com/MasseGuillaume) contributed fixes
and the implementation of `cre2_find_named_capturing_groups()`.

  Will    Speak    (https://github.com/iwillspeak)    contributed    the
implementation of the named capturing groups iterator.

## Bugs, vulnerabilities and contributions

Bug  and vulnerability  reports are  appreciated, all  the vulnerability
reports are public; register them at  the Issue Tracker at the project's
Github site.  For contributions and patches please use the Pull Requests
feature at the project's Github site.

## Installing re2 and its dependencies

This may be a challenge, depending on how much of a cmake connoisseur we
are.

In general, we have to remember that:  if we install both the shared and
the static libraries:  when compiling with common  command line options,
the static libraries will take precedence.   This package is meant to be
used  with  shared  libraries,  but  it should  work  fine  with  static
libraries, too.

Let's suppose  we want to install  all the packages under  the directory
"/opt/re2/2024-07-02"; on  a Unix system,  we will  need to put  in some
profile configuration file something like:

```
RE2_PREFIX=/opt/re2/2024-07-02
RE2_LIBDIR=${RE2_PREFIX}/lib64
export LD_LIBRARY_PATH=${RE2_LIBDIR}:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=${RE2_LIBDIR}/pkgconfig:$PKG_CONFIG_PATH
```

as a first attempt: no other search path should be upgraded, let's leave
to the packages to find include files and everything else.

When  configuring,  building  and installing  the  prerequisite  package
`abseil` we should follow the instructions  in its README file; but here
is a hint to configure the package to build shared libraries:

```
$ cmake .  \
    --install-prefix "$RE2_PREFIX"      \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo   \
    -DCMAKE_CXX_FLAGS:STRING="-fPIC"    \
    -DCMAKE_CXX_STANDARD=17             \
    -DBUILD_SHARED_LIBS=ON              \
    -DCMAKE_BUILD_TYPE=Release          \
    -DABSL_PROPAGATE_CXX_STD=ON
```

When  configuring,  building  and installing  the  prerequisite  package
`googletest` we should  follow the instructions in its  README file; but
here is a hint to configure the package to build shared libraries:

```
$ cmake .  \
    --install-prefix "$RE2_PREFIX"      \
    -DBUILD_SHARED_LIBS=ON              \
    -DCMAKE_CXX_FLAGS:STRING="-fPIC"
```

  When configuring, building and installing  the package `re2` itself we
should follow the instructions in its README file; but here is a hint to
configure the package to build shared libraries:

```
$ cmake .  \
    --install-prefix "$RE2_PREFIX"      \
    -DBUILD_SHARED_LIBS=ON              \
    -DCMAKE_CXX_FLAGS:STRING="-fPIC"    \
    -DCMAKE_BUILD_TYPE=Release
```

## Resources

The latest release of this package can be downloaded from:

[https://bitbucket.org/marcomaggi/cre2/downloads](https://bitbucket.org/marcomaggi/cre2/downloads)

development takes place at:

[http://github.com/marcomaggi/cre2/](http://github.com/marcomaggi/cre2/)

and as backup at:

[https://bitbucket.org/marcomaggi/cre2/](https://bitbucket.org/marcomaggi/cre2/)

the documentation is available online:

[http://marcomaggi.github.io/docs/cre2.html](http://marcomaggi.github.io/docs/cre2.html)

the GNU Project software can be found here:

[http://www.gnu.org/](http://www.gnu.org/)

