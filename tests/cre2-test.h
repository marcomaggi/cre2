/*
  Part of: CRE2
  Contents: helpers for test files
  Date: Mon Feb 15, 2016

  Abstract

	Helpers for test files.

  Copyright (C) 2016 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/

#ifndef CRE2_TEST_H
#define CRE2_TEST_H 1

#if (defined CRE2_ENABLE_DEBUGGING)
#  define PRINTF(...)		{ printf(__VA_ARGS__);         fflush(stdout); }
#  define FWRITE(...)		{ fwrite(__VA_ARGS__, stdout); fflush(stdout); }
#else
#  define PRINTF(...)		if (0) { printf(__VA_ARGS__); }; /* do nothing */
#  define FWRITE(...)		if (0) { fwrite(__VA_ARGS__, stdout); }; /* do nothing */
#endif

#endif /* CRE2_TEST_H */

/* end of file */
