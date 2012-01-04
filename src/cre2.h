/*
  Header  file  for  CRE2, a  C  language  wrapper  for RE2:  a  regular
  expressions library by Google.

  Copyright (c) 2012 Marco Maggi <marco.maggi-ipsu@poste.it>
  Copyright (c) 2011 Keegan McAllister
  All rights reserved.

  For the license notice see the COPYING file.
*/

#ifdef __cplusplus
extern "C" {
#endif

#ifndef cre2_decl
#  define cre2_decl	extern
#endif

cre2_decl const char *	cre2_version_string (void);
cre2_decl int		cre2_version_interface_current	(void);
cre2_decl int		cre2_version_interface_revision	(void);
cre2_decl int		cre2_version_interface_age	(void);

typedef void cre2_options_t;

typedef enum cre2_encoding_t {
  CRE2_UNKNOWN	= 0,	/* should never happen */
  CRE2_UTF8	= 1,
  CRE2_Latin1	= 2
} cre2_encoding_t;

cre2_decl cre2_options_t *cre2_opt_new		(void);
cre2_decl void		  cre2_opt_delete	(cre2_options_t *opt);

cre2_decl void cre2_opt_set_posix_syntax	(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_longest_match	(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_log_errors		(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_literal		(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_never_nl		(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_case_sensitive	(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_perl_classes	(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_word_boundary	(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_one_line		(cre2_options_t *opt, int flag);
cre2_decl void cre2_opt_set_max_mem		(cre2_options_t *opt, int m);
cre2_decl void cre2_opt_set_encoding		(cre2_options_t *opt, cre2_encoding_t enc);

cre2_decl int cre2_opt_posix_syntax		(cre2_options_t *opt);
cre2_decl int cre2_opt_longest_match		(cre2_options_t *opt);
cre2_decl int cre2_opt_log_errors		(cre2_options_t *opt);
cre2_decl int cre2_opt_literal			(cre2_options_t *opt);
cre2_decl int cre2_opt_never_nl			(cre2_options_t *opt);
cre2_decl int cre2_opt_case_sensitive		(cre2_options_t *opt);
cre2_decl int cre2_opt_perl_classes		(cre2_options_t *opt);
cre2_decl int cre2_opt_word_boundary		(cre2_options_t *opt);
cre2_decl int cre2_opt_one_line			(cre2_options_t *opt);
cre2_decl int cre2_opt_max_mem			(cre2_options_t *opt);
cre2_decl cre2_encoding_t cre2_opt_encoding	(cre2_options_t *opt);

typedef struct cre2_string_t {
  const char *	data;
  int		length;
} cre2_string_t;

typedef struct cre2_range_t {
  long	start;	/* inclusive start index for bytevector */
  long	past;	/* exclusive end index for bytevector */
} cre2_range_t;

typedef void	cre2_regexp_t;

/* construction and destruction */
cre2_decl cre2_regexp_t *  cre2_new	(const char *pattern, int pattern_len,
				 const cre2_options_t *opt);
cre2_decl void    cre2_delete	(cre2_regexp_t *re);

/* regular expression inspection */
cre2_decl const char * cre2_pattern	(const cre2_regexp_t *re);
cre2_decl int cre2_error_code		(const cre2_regexp_t *re);
cre2_decl int cre2_num_capturing_groups	(const cre2_regexp_t *re);
cre2_decl int cre2_program_size		(const cre2_regexp_t *re);

/* invalidated by further re use */
cre2_decl const char *cre2_error_string(const cre2_regexp_t *re);
cre2_decl void cre2_error_arg(const cre2_regexp_t *re, cre2_string_t * arg);

typedef enum cre2_anchor_t {
  CRE2_UNANCHORED   = 1,
  CRE2_ANCHOR_START = 2,
  CRE2_ANCHOR_BOTH  = 3
} cre2_anchor_t;

/* matching with precompiled regular expressions objects */
cre2_decl int cre2_match	(const cre2_regexp_t * re,
				 const char * text, int textlen,
				 int startpos, int endpos, cre2_anchor_t anchor,
				 cre2_string_t * match, int nmatch);

cre2_decl int cre2_easy_match	(const char * pattern, int pattern_len,
				 const char * text, int text_len,
				 cre2_string_t * match, int nmatch);

cre2_decl void cre2_strings_to_ranges (const char * text, cre2_range_t * ranges,
				       cre2_string_t * strings, int nmatch);

/* matching without precompiled regular expressions objects */
typedef int cre2_match_stringz_fun_t (const char * pattern, const cre2_string_t * text,
				      cre2_string_t * match, int nmatch);

typedef int cre2_match_stringz2_fun_t (const char * pattern, cre2_string_t * text,
				       cre2_string_t * match, int nmatch);

typedef int cre2_match_rex_fun_t (cre2_regexp_t * rex, const cre2_string_t * text,
				  cre2_string_t * match, int nmatch);

typedef int cre2_match_rex2_fun_t (cre2_regexp_t * rex, cre2_string_t * text,
				   cre2_string_t * match, int nmatch);

cre2_decl cre2_match_stringz_fun_t	cre2_full_match;
cre2_decl cre2_match_stringz_fun_t	cre2_partial_match;
cre2_decl cre2_match_stringz2_fun_t	cre2_consume;
cre2_decl cre2_match_stringz2_fun_t	cre2_find_and_consume;

cre2_decl cre2_match_rex_fun_t		cre2_full_match_re;
cre2_decl cre2_match_rex_fun_t		cre2_partial_match_re;
cre2_decl cre2_match_rex2_fun_t		cre2_consume_re;
cre2_decl cre2_match_rex2_fun_t		cre2_find_and_consume_re;

#ifdef __cplusplus
} // extern "C"
#endif

/* end of file */
