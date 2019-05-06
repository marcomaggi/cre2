/*
  Part of: CRE2
  Contents: test for rex allocation
  Date: Sun May  5, 2019

  Abstract

	Test file for named capture group iteration.

  Copyright (C) 2019 Will Speak <lithiumflame@gmail.com>

  See the COPYING file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cre2.h>
#include "cre2-test.h"

#define CRE2_ENABLE_DEBUGGING	1

int
main (void)
{
  {
    cre2_regexp_t *	rex;
    cre2_named_groups_iter_t * it;
    bool ret; const char * name; int pos;

    rex = cre2_new("ciao", 4, NULL);
    if (!rex)
      goto error;
    it = cre2_named_groups_iter_new(rex);
    if (!it)
      goto error;
    ret = cre2_named_groups_iter_next(it, &name, &pos);
    if (ret)
      goto error;
    if (name != NULL)
      goto error;
    if (pos != -1)
      goto error;

    cre2_delete(rex);
  }
  /* ------------------------------------------------------------------ */
  {
    cre2_regexp_t *	rex;
    cre2_named_groups_iter_t * it;
    bool ret; const char * name; int pos;
    const char pat[] = "((.)(?P<dot>.))";

    rex = cre2_new(pat, sizeof(pat), NULL);
    if (!rex)
      goto error;
    it = cre2_named_groups_iter_new(rex);
    if (!it)
      goto error;

    ret = cre2_named_groups_iter_next(it, &name, &pos);
    if (!ret)
      goto error;
    if (pos != 3)
      goto error;
    if (strcmp(name, "dot") != 0)
      goto error;

    ret = cre2_named_groups_iter_next(it, &name, &pos);
    if (ret)
      goto error;
    if (name != NULL)
      goto error;
    if (pos != -1)
      goto error;

    cre2_delete(rex);
  }
  /* ------------------------------------------------------------------ */
  {
    cre2_regexp_t *	rex;
    cre2_named_groups_iter_t * it;
    bool ret; const char * name; int pos;
    const char* names[5] = { 0 };
    const char pat[] = "(unnamed_cap): (?P<year>\\d{4})-(?P<month>\\d{2})(-)(?P<day>\\d{2})";

    rex = cre2_new(pat, sizeof(pat), NULL);
    if (!rex)
      goto error;
    it = cre2_named_groups_iter_new(rex);
    if (!it)
      goto error;

    ret = cre2_named_groups_iter_next(it, &name, &pos);
    PRINTF("first group: %d, %s\n", pos, name);
    if (!ret)
      goto error;
    if (pos < 0 || pos > 5)
      goto error;
    names[pos - 1] = name;
    ret = cre2_named_groups_iter_next(it, &name, &pos);
    PRINTF("second group: %d, %s\n", pos, name);
    if (!ret)
      goto error;
    if (pos < 0 || pos > 5)
      goto error;
    names[pos - 1] = name;
    ret = cre2_named_groups_iter_next(it, &name, &pos);
    PRINTF("third group: %d, %s\n", pos, name);
    if (!ret)
      goto error;
    if (pos < 0 || pos > 5)
      goto error;
    names[pos - 1] = name;

    ret = cre2_named_groups_iter_next(it, &name, &pos);
    if (ret)
      goto error;
    if (name != NULL)
      goto error;
    if (pos != -1)
      goto error;

    if (strcmp(names[1], "year") != 0)
      goto error;
    if (strcmp(names[2], "month") != 0)
      goto error;
    if (strcmp(names[4], "day") != 0)
      goto error;

    cre2_delete(rex);
  }

  /* ------------------------------------------------------------------ */
  /* This is an example for the documentation. */
  {
    const char rex_pattern[] = "January:[[:blank:]]+(?P<january>[[:digit:]]+)\n\
February:[[:blank:]]+(?P<january>[[:digit:]]+)\n\
March:[[:blank:]]+(?P<march>[[:digit:]]+)\n\
April:[[:blank:]]+(?P<april>[[:digit:]]+)\n\
May:[[:blank:]]+(?P<may>[[:digit:]]+)\n\
June:[[:blank:]]+(?P<june>[[:digit:]]+)\n\
July:[[:blank:]]+(?P<july>[[:digit:]]+)\n\
August:[[:blank:]]+(?P<august>[[:digit:]]+)\n\
September:[[:blank:]]+(?P<september>[[:digit:]]+)\n\
October:[[:blank:]]+(?P<october>[[:digit:]]+)\n\
November:[[:blank:]]+(?P<november>[[:digit:]]+)\n\
December:[[:blank:]]+(?P<december>[[:digit:]]+)\n";

    const char *   text     = "\
January: 8\n\
February: 3\n\
March: 3\n\
April: 4\n\
May: 9\n\
June: 4\n\
July: 7\n\
August: 5\n\
September: 9\n\
October: 2\n\
November: 1\n\
December: 6\n";
    int            text_len = strlen(text);

    int		   rv;
    int            nmatch = 20;
    cre2_string_t  match[nmatch];

    cre2_regexp_t  * rex = cre2_new(rex_pattern, strlen(rex_pattern), NULL);
    if (!rex) {
      fprintf(stderr, "error building rex\n");
      goto done;
    }
    if (cre2_error_code(rex)) {
      fprintf(stderr, "error building rex\n");
      goto done;
    }

    rv = cre2_match(rex, text, text_len, 0, text_len, CRE2_ANCHOR_BOTH, match, nmatch);
    if (! rv) {
      fprintf(stderr, "no match\n");
      goto done;
    }

    {
      cre2_named_groups_iter_t	* iter = cre2_named_groups_iter_new(rex);

      if (!iter) {
	fprintf(stderr, "error building iterator\n");
	goto internal_done;
      }

      {
	char const *name;
	int	 index;

	while (cre2_named_groups_iter_next(iter, &name, &index)) {
	  printf("group: %d, %s\n", index, name);
	}
      }

    internal_done:

      if (iter) {
	cre2_named_groups_iter_delete(iter);
      }
    }

  done:
    if (rex) {
      cre2_delete(rex);
    }
  }

  exit(EXIT_SUCCESS);

 error:
  exit(EXIT_FAILURE);
}

/* end of file */
