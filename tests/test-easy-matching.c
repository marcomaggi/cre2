/*
  Part of: CRE2
  Contents: test for easy matching
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
  const char *	pattern;
  const char *	text;

/* ------------------------------------------------------------------ */
/* single match */

  pattern = "ciao";
  text    = "ciao";
  {
    cre2_substring_t	match;
    int			nmatch = 1;
    cre2_easy_match(pattern, strlen(pattern),
		    text,    strlen(text),
		    &match, nmatch);
    printf("match: ");
    fwrite(match.data, match.length, 1, stdout);
    printf("\n");
  }

/* ------------------------------------------------------------------ */
/* wrong pattern */

  pattern = "ci(ao";
  text    = "ciao";
  {
    cre2_substring_t	match;
    int			nmatch = 1;
    int			retval;
    retval = cre2_easy_match(pattern, strlen(pattern),
			     text,    strlen(text),
			     &match, nmatch);
    if (2 != retval)
      goto error;
  }

/* ------------------------------------------------------------------ */
/* two groups */

  pattern = "(ciao) (hello)";
  text    = "ciao hello";
  {
    int			nmatch = 3;
    cre2_substring_t	match[nmatch];
    cre2_easy_match(pattern, strlen(pattern),
		    text,    strlen(text),
		    match, nmatch);
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

/* ------------------------------------------------------------------ */

  exit(EXIT_SUCCESS);
 error:
  exit(EXIT_FAILURE);
}

/* end of file */
