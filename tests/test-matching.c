/*
  Part of: CRE2
  Contents: test for matching
  Date: Mon Jan  2, 2012

  Abstract

	Test file for regular expressions matching.

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
  const char *		pattern;

/* ------------------------------------------------------------------ */
/* single match */

  pattern = "ciao";
  opt     = cre2_opt_new();
  cre2_opt_posix_syntax(opt, 1);
  rex = cre2_new(pattern, strlen(pattern), opt);
  {
    if (!cre2_ok(rex))
      goto error;
    cre2_substring_t	match;
    int			nmatch = 1;
    int			e;
    const char *	text = "ciao";
    int			text_len = strlen(text);

    e = cre2_match(rex, text, text_len, 0, text_len, CRE2_UNANCHORED, &match, nmatch);
    printf("match: retval=%d, ");
    fwrite(match.data, match.length, 1, stdout);
    printf("\n");
  }
  cre2_delete(rex);
  cre2_opt_delete(opt);

/* ------------------------------------------------------------------ */
/* two groups */

  pattern = "(ciao) (hello)";
  opt = cre2_opt_new();
  cre2_opt_posix_syntax(opt, 1);
  rex = cre2_new(pattern, strlen(pattern), opt);
  {
    if (!cre2_ok(rex))
      goto error;
    int			nmatch = 3;
    cre2_substring_t	match[nmatch];
    int			e;
    const char *	text = "ciao hello";
    int			text_len = strlen(text);

    e = cre2_match(rex, text, text_len, 0, text_len, CRE2_UNANCHORED, match, nmatch);
    printf("full match: ");
    fwrite(match[0].data, match[0].length, 1, stdout);
    printf("\n");
    printf("first group: ");
    fwrite(match[1].data, match[1].length, 1, stdout);
    printf("\n");
    printf("second group: ");
    fwrite(match[2].data, match[2].length, 1, stdout);
    printf("\n");
  }
  cre2_delete(rex);
  cre2_opt_delete(opt);

/* ------------------------------------------------------------------ */

  exit(EXIT_SUCCESS);
 error:
  exit(EXIT_FAILURE);
}

/* end of file */
