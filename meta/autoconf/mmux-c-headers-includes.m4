## mmux-c-headers-includes.m4 --
#
# Define macros  that expand into  C preprocessor directives  to include
# the most common C language header  files.  We can use the expansion of
# the macros as "INCLUDES" argument to other macros.
#

AC_DEFUN([MMUX_INCLUDE_UNISTD_H],[
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_ARPA_INET_H],[
#ifdef HAVE_ARPA_INET_H
#  include <arpa/inet.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_DIRENT_H],[
#ifdef HAVE_DIRENT_H
#  include <dirent.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_ERRNO_H],[
#ifdef HAVE_ERRNO_H
#  include <errno.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_FCNTL_H],[
#ifdef HAVE_FCNTL_H
#  include <fcntl.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_GRP_H],[
#ifdef HAVE_GRP_H
#  include <grp.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_LIMITS_H],[
#ifdef HAVE_LIMITS_H
#  include <limits.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_LINUX_FS_H],[
#ifdef HAVE_LINUX_FS_H
#  include <linux/fs.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_NETINET_IN_H],[
#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_NETDB_H],[
#ifdef HAVE_NETDB_H
#  include <netdb.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_PWD_H],[
#ifdef HAVE_PWD_H
#  include <pwd.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SIGNAL_H],[
#ifdef HAVE_SIGNAL_H
#  include <signal.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_SELECT_H],[
#ifdef HAVE_SYS_SELECT_H
#  include <sys/select.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_SOCKET_H],[
#ifdef HAVE_SYS_SOCKET_H
#  include <sys/socket.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_SYSCALL_H],[
#ifdef HAVE_SYS_SYSCALL_H
#  include <sys/syscall.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_UN_H],[
#ifdef HAVE_SYS_UN_H
#  include <sys/un.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_STDDEF_H],[
#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_STDIO_H],[
#include <stdio.h>
])

AC_DEFUN([MMUX_INCLUDE_STDLIB_H],[
#ifdef HAVE_STDLIB_H
#  include <stdlib.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_AUXV_H],[
#ifdef HAVE_SYS_AUXV_H
#  include <sys/auxv.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_TYPES_H],[
#ifdef HAVE_SYS_TYPES_H
#  include <sys/types.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_MMAN_H],[
#ifdef HAVE_SYS_MMAN_H
#  include <sys/mman.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_UIO_H],[
#ifdef HAVE_SYS_UIO_H
#  include <sys/uio.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_RESOURCE_H],[
#ifdef HAVE_SYS_RESOURCE_H
#  include <sys/resource.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_STAT_H],[
#ifdef HAVE_SYS_STAT_H
#  include <sys/stat.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_SYS_TIME_H],[
#ifdef HAVE_SYS_TIME_H
#  include <sys/time.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_TIME_H],[
#ifdef HAVE_TIME_H
#  include <time.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_UNISTD_H],[
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif
])

AC_DEFUN([MMUX_INCLUDE_WAIT_H],[
#ifdef HAVE_WAIT_H
#  include <wait.h>
#endif
])

### end of file
# Local Variables:
# mode: autoconf
# End:
