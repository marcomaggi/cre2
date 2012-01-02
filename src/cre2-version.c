/*
  Part of: CRE2
  Contents: version functions
  Date: Mon Jan  2, 2012

  Abstract

	Interface version functions.

  Copyright (C) 2012 Marco Maggi <marco.maggi-ipsu@poste.it>

  See the COPYING file.
*/


#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif
#include <cre2.h>


const char *
cre2_version_string (void)
{
  return cre2_VERSION_INTERFACE_STRING;
}
int
cre2_version_interface_current (void)
{
  return cre2_VERSION_INTERFACE_CURRENT;
}
int
cre2_version_interface_revision (void)
{
  return cre2_VERSION_INTERFACE_REVISION;
}
int
cre2_version_interface_age (void)
{
  return cre2_VERSION_INTERFACE_AGE;
}

/* end of file */
