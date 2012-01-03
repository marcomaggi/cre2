/*
  Part of: CRE2
  Contents: test for rex allocation
  Date: Mon Jan  2, 2012

  Abstract

	Test file for regular expressions allocation.

  Copyright (C) 2012 Marco Maggi <marco.maggi-ipsu@poste.it>

  See the COPYING file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cre2.h>

int
main (int argc, const char *const argv[])
{
  cre2 *		rex;
  cre2_options *	opt;
  opt = cre2_opt_new();
  cre2_opt_posix_syntax(opt, 1);
  rex = cre2_new("ciao", 4, opt);
  {
    cre2_string_t	S;
    printf("pattern: %s\n", cre2_pattern(rex));
    printf("error code: %d\n", cre2_error_code(rex));
    printf("error string: \"%s\"\n", cre2_error_string(rex));
    printf("number of capturing groups: %d\n", cre2_num_capturing_groups(rex));
    printf("program size: %d\n", cre2_program_size(rex));
    cre2_error_arg(rex, &S);
    printf("error arg: len=%d, data=\"%s\"\n", S.length, S.data);
    if (cre2_error_code(rex))
      goto error;
    if (cre2_num_capturing_groups(rex))
      goto error;
    if (! cre2_ok(rex))
      goto error;
    if (0 != strlen(cre2_error_string(rex)))
      goto error;
    if (0 != S.length)
      goto error;
  }
  cre2_delete(rex);
  cre2_opt_delete(opt);

/* ------------------------------------------------------------------ */

  opt = cre2_opt_new();
  cre2_opt_posix_syntax(opt, 1);
  rex = cre2_new("ci(ao)", 6, opt);
  {
    printf("error code: %d\n", cre2_error_code(rex));
    printf("number of capturing groups: %d\n", cre2_num_capturing_groups(rex));
    printf("program size: %d\n", cre2_program_size(rex));
    if (cre2_error_code(rex))
      goto error;
    if (1 != cre2_num_capturing_groups(rex))
      goto error;
  }
  cre2_delete(rex);
  cre2_opt_delete(opt);

/* ------------------------------------------------------------------ */

  opt = cre2_opt_new();
  rex = cre2_new("ci(ao", 5, opt);
  {
    int			code = cre2_error_code(rex);
    const char *	msg  = cre2_error_string(rex);
    cre2_string_t	S;
    cre2_error_arg(rex, &S);
    printf("pattern: %s\n", cre2_pattern(rex));
    printf("error: code=%d, msg=\"%s\"\n", code, msg);
    printf("error arg: len=%d, data=\"%s\"\n", S.length, S.data);
  }
  cre2_delete(rex);
  cre2_opt_delete(opt);

  exit(EXIT_SUCCESS);

 error:
  exit(EXIT_FAILURE);
}

/* end of file */
