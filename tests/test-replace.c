/*
  Part of: CRE2
  Contents: test for replace
  Date: Wed Jan  4, 2012

  Abstract

	Test file for replacing.

  Copyright (C) 2012 Marco Maggi <marco.maggi-ipsu@poste.it>

  See the COPYING file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cre2.h>

#if 0
#  define PRINTF		printf
#  define FWRITE		fwrite
#else
#  define PRINTF(MSG, ...)	/* empty string */
#  define FWRITE(BUF, ...)	/* empty string */
#endif

int
main (int argc, const char *const argv[])
{
  { /* replace all the buffer using the full match */
    cre2_regexp_t *	rex;
    const char *	pattern	= "ciao hello salut";
    const char *	text	= "ciao hello salut";
    const char *	replace	= "pre \\0 post";
    cre2_string_t	target	= {
      .data   = text,
      .length = strlen(text)
    };
    cre2_string_t	rewrite	= {
      .data   = replace,
      .length = strlen(replace)
    };
    int			result;
    rex = cre2_new(pattern, strlen(pattern), NULL);
    {
      result = cre2_replace_re(rex, &target, &rewrite);
      if (1 != result)
	goto error;
      if (0 != strncmp("pre ciao hello salut post", target.data, target.length))
	goto error;
      if ('\0' != target.data[target.length])
	goto error;
      PRINTF("rewritten to: ");
      FWRITE(target.data, target.length, 1, stdout);
      PRINTF("\n");
    }
    cre2_delete(rex);
    free((void *)target.data);
  }
  { /* replace substring with fixed string */
    cre2_regexp_t *	rex;
    const char *	pattern	= "hello";
    const char *	text	= "ciao hello salut";
    const char *	replace	= "ohaio";
    cre2_string_t	target	= {
      .data   = text,
      .length = strlen(text)
    };
    cre2_string_t	rewrite	= {
      .data   = replace,
      .length = strlen(replace)
    };
    int			result;
    rex = cre2_new(pattern, strlen(pattern), NULL);
    {
      result = cre2_replace_re(rex, &target, &rewrite);
      if (1 != result)
	goto error;
      if (0 != strncmp("ciao ohaio salut", target.data, target.length))
	goto error;
      if ('\0' != target.data[target.length])
	goto error;
      PRINTF("rewritten to: ");
      FWRITE(target.data, target.length, 1, stdout);
      PRINTF("\n");
    }
    cre2_delete(rex);
    free((void *)target.data);
  }

  /* ------------------------------------------------------------------ */

  exit(EXIT_SUCCESS);
 error:
  exit(EXIT_FAILURE);
}

/* end of file */
