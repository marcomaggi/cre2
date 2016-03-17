/*
  Part of: CRE2
  Contents: test for Set
  Date: Thu Mar 3, 2016

  Abstract

	Test file for set of regular expressions matching.

  See the COPYING file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cre2.h>

#define FATAL(format, args...) \
        fprintf(stderr, "\e[01;31m[ERR] \e[00m\e[00;31m" format "\e[00m\n", ##args);\
        goto error

int
main (int argc, const char *const argv[])
{
/* ------------------------------------------------------------------ */
/* definition of patterns match */

  const char * const pattern0 = "hello";
  const char * const pattern1 = "world";
  const char * const pattern2 = "po.*ar";
  const char * const pattern3 = "(invalid";
  char *text;
  int index;

  // create set
  cre2_options_t *opt = cre2_opt_new();
  cre2_set *set = cre2_set_new(opt, CRE2_UNANCHORED);
  if (set == NULL) {
    FATAL("Error creating the cre2_set");
  }

  // Add patterns
  index = cre2_set_add_simple(set, pattern0);
  if (index != 0) {
    FATAL("Failed adding pattern %i to set. cre2_set_add_simple returned %i", 0, index);
  }
  index = cre2_set_add_simple(set, pattern1);
  if (index != 1) {
    FATAL("Failed adding pattern %i to set. cre2_set_add_simple returned %i", 1, index);
  }
  index = cre2_set_add_simple(set, pattern2);
  if (index != 2) {
    FATAL("Failed adding pattern %i to set. cre2_set_add_simple returned %i", 2, index);
  }

  // Try to add invalid pattern
  char error[100];
  index = cre2_set_add(set, pattern3, strlen(pattern3), error, 100);
  if (index != -1) {
    FATAL("Error: successfully added an invalid pattern3 to set.");
  }
  printf(error);

  // Compile regex set
  if (!cre2_set_compile(set)) {
    FATAL("Failed to compile regex set.");
  }

  int match[3];
  int count;

  // Test first match
  text = "hello world!";
  count = cre2_set_match(set, text, strlen(text), match, 3);
  if (count != 2 || match[0] != 0 || match[1] != 1) {
    FATAL("Failed to match: %s", text);
  }

  // Test second match
  text = "blabla hello polar bear!";
  count = cre2_set_match(set, text, strlen(text), match, 3);
  if (count != 2 || match[0] != 0 || match[1] != 2) {
    FATAL("Failed to match: %s", text);
  }

  // Test third match
  text = "this should not match anything";
  count = cre2_set_match(set, text, strlen(text), match, 3);
  if (count != 0) {
    FATAL("Failed to match: %s", text);
  }

/* ------------------------------------------------------------------ */

  cre2_set_delete(set);
  exit(EXIT_SUCCESS);
 error:
  exit(EXIT_FAILURE);
}

/* end of file */
