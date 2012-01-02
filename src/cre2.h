/*
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


typedef void cre2_options;

typedef enum cre2_encoding_t {
  CRE2_UTF8   = 1,
  CRE2_Latin1 = 2
} cre2_encoding_t;

cre2_decl cre2_options *cre2_opt_new	(void);
cre2_decl void		cre2_opt_delete	(cre2_options *opt);

cre2_decl void cre2_opt_posix_syntax	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_longest_match	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_log_errors	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_literal		(cre2_options *opt, int flag);
cre2_decl void cre2_opt_never_nl	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_case_sensitive	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_perl_classes	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_word_boundary	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_one_line	(cre2_options *opt, int flag);
cre2_decl void cre2_opt_encoding	(cre2_options *opt, cre2_encoding_t enc);
cre2_decl void cre2_opt_max_mem		(cre2_options *opt, int m);

struct cre2_substring {
  const char *	data;
  int		length;
};
typedef struct cre2_substring	cre2_substring_t;

typedef void cre2;

/* construction and destruction */
cre2_decl cre2 *  cre2_new	(const char *pattern, int pattern_len,
				 const cre2_options *opt);
cre2_decl void    cre2_delete	(cre2 *re);

/* regular expression inspection */
cre2_decl int cre2_ok (cre2 *re);
cre2_decl const char * cre2_pattern	(const cre2 *re);
cre2_decl int cre2_error_code		(const cre2 *re);
cre2_decl int cre2_num_capturing_groups	(const cre2 *re);
cre2_decl int cre2_program_size		(const cre2 *re);

/* invalidated by further re use */
cre2_decl const char *cre2_error_string(const cre2 *re);
cre2_decl void cre2_error_arg(const cre2 *re, cre2_substring_t * arg);

/* matching with precompiled regular expressions objects */
typedef enum cre2_anchor_t {
  CRE2_UNANCHORED   = 1,
  CRE2_ANCHOR_START = 2,
  CRE2_ANCHOR_BOTH  = 3
} cre2_anchor_t;

cre2_decl int cre2_match	(const cre2 * re,
				 const char * text, int textlen,
				 int startpos, int endpos, cre2_anchor_t anchor,
				 cre2_substring_t * match, int nmatch);

cre2_decl int cre2_easy_match	(const char * pattern, int pattern_len,
				 const char * text, int text_len,
				 cre2_substring_t *match, int nmatch);

#ifdef __cplusplus
} // extern "C"
#endif

/* end of file */
