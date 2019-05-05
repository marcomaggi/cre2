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

  exit(EXIT_SUCCESS);

 error:
  exit(EXIT_FAILURE);
}

/* end of file */
