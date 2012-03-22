#ifndef CONFIG_H
#define CONFIG_H

#cmakedefine ENABLE_NLS      1
#cmakedefine GETTEXT_PACKAGE "@GETTEXT_PACKAGE@"
#cmakedefine LOCALE_DIR      "@LOCALE_DIR@"
#cmakedefine HAVE_GETTEXT    1

#cmakedefine HAVE_DLFCN_H    1
#cmakedefine HAVE_FCNTL_H    1

#cmakedefine HAVE_LIBASOUND  1
#cmakedefine HAVE_0_9_X_ALSA 1
#cmakedefine HAVE_1_X_X_ALSA 1

#cmakedefine HAVE_MMAP         1
#cmakedefine HAVE_GETTIMEOFDAY 1
#cmakedefine HAVE_POW          1
#cmakedefine HAVE_SQRT         1
#cmakedefine HAVE_FLOOR        1

#cmakedefine HAVE_UNISTD_H     1
#cmakedefine HAVE_XF86VMODE    1

#cmakedefine STDC_HEADERS      1

#ifndef __cplusplus
#cmakedefine HAVE_C_INLINE
#cmakedefine HAVE_C_CONST
#cmakedefine inline @INLINE@
#ifndef HAVE_C_CONST
#  define const
#endif
#endif

#endif // CONFIG_H
