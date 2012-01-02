/*
  Copyright (c) 2012 Marco Maggi <marco.maggi-ipsu@poste.it>
  Copyright (c) 2011 Keegan McAllister
  All rights reserved.

  For the license notice see the COPYING file.
*/

#include <re2/re2.h>
#include "cre2.h"


/** --------------------------------------------------------------------
 ** Options objects.
 ** ----------------------------------------------------------------- */

/* Cast   the   pointer   argument   "opt"   to  a   pointer   of   type
   "RE2::Options*". */
#define TO_OPT(opt) (reinterpret_cast<RE2::Options *>(opt))

cre2_options *
cre2_opt_new(void)
/* Allocate and return a new options object. */
{
  return reinterpret_cast<void*>(new RE2::Options());
}
void
cre2_opt_delete (cre2_options *opt)
/* Finalise an options object. */
{
  delete TO_OPT(opt);
}

/* Set or unset option flags in an options object. */
#define OPT_BOOL(name)  \
void cre2_opt_##name(cre2_options *opt, int flag) {  \
    TO_OPT(opt)->set_##name(bool(flag));             \
}
OPT_BOOL(posix_syntax)
OPT_BOOL(longest_match)
OPT_BOOL(log_errors)
OPT_BOOL(literal)
OPT_BOOL(never_nl)
OPT_BOOL(case_sensitive)
OPT_BOOL(perl_classes)
OPT_BOOL(word_boundary)
OPT_BOOL(one_line)
#undef OPT_BOOL

void
cre2_opt_encoding (cre2_options *opt, cre2_encoding_t enc)
/* Select the encoding in an options object. */
{
  switch (enc) {
  case CRE2_UTF8:
    TO_OPT(opt)->set_encoding(RE2::Options::EncodingUTF8);
    break;
  case CRE2_Latin1:
    TO_OPT(opt)->set_encoding(RE2::Options::EncodingLatin1);
    break;
  }
}
void
cre2_opt_max_mem (cre2_options *opt, int m)
/* Configure the maximum amount of memory in an options object. */
{
  TO_OPT(opt)->set_max_mem(m);
}


/** --------------------------------------------------------------------
 ** Regular expressions objects.
 ** ----------------------------------------------------------------- */

#define TO_RE2(re)       (reinterpret_cast<RE2 *>(re))
#define TO_CONST_RE2(re) (reinterpret_cast<const RE2 *>(re))

cre2 *
cre2_new (const char *pattern, int pattern_len, const cre2_options *opt)
{
  re2::StringPiece pattern_re2(pattern, pattern_len);
  return reinterpret_cast<void*>(new RE2(pattern_re2, *reinterpret_cast<const RE2::Options *>(opt)));
}
void
cre2_delete(cre2 *re)
{
  delete TO_RE2(re);
}
int
cre2_ok (cre2 *re)
{
  return TO_RE2(re)->ok();
}

int
cre2_error_code (const cre2 *re)
{
  return int(TO_CONST_RE2(re)->error_code());
}
const char *
cre2_error_string (const cre2 *re)
{
  return TO_CONST_RE2(re)->error().c_str();
}
void
cre2_error_arg (const cre2 *re, cre2_string_t *arg)
{
  const std::string &argstr = TO_CONST_RE2(re)->error_arg();
  arg->data   = argstr.data();
  arg->length = argstr.length();
}
int
cre2_num_capturing_groups (const cre2 *re)
{
  return TO_CONST_RE2(re)->NumberOfCapturingGroups();
}
int
cre2_program_size (const cre2 *re)
{
  return TO_CONST_RE2(re)->ProgramSize();
}
int
cre2_match (const cre2 *re , const char *text,
	    int textlen, int startpos, int endpos, cre2_anchor_t anchor,
	    cre2_string_t *match, int nmatch)
{
  re2::StringPiece text_re2(text, textlen);
  // FIXME: exceptions?
  re2::StringPiece *match_re2 = new re2::StringPiece[nmatch];
  RE2::Anchor anchor_re2 = RE2::UNANCHORED;
  switch (anchor) {
  case CRE2_ANCHOR_START:
    anchor_re2 = RE2::ANCHOR_START; break;
  case CRE2_ANCHOR_BOTH:
    anchor_re2 = RE2::ANCHOR_BOTH;  break;
  }
  bool ret = TO_CONST_RE2(re)->Match(text_re2, startpos, endpos, anchor_re2, match_re2, nmatch);
  if (ret) {
    for (int i=0; i<nmatch; i++) {
      match[i].data   = match_re2[i].data();
      match[i].length = match_re2[i].length();
    }
  }
  delete [] match_re2;
  return int(ret);
}

/* end of file */
