# libcroco.m4 serial 2 (gettext-0.17)
dnl Copyright (C) 2006, 2015-2016 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_DEFUN([gl_LIBCROCO],
[
  AC_REQUIRE([PKG_PROG_PKG_CONFIG])
  dnl libcroco depends on libglib.
  AC_REQUIRE([gl_LIBGLIB])

  AC_MSG_CHECKING([whether included libcroco is requested])
  AC_ARG_WITH([included-libcroco],
    [  --with-included-libcroco  use the libcroco included here],
    [gl_cv_libcroco_force_included=$withval],
    [gl_cv_libcroco_force_included=no])
  AC_MSG_RESULT([$gl_cv_libcroco_force_included])

  gl_cv_libcroco_use_included="$gl_cv_libcroco_force_included"
  LIBCROCO=
  LTLIBCROCO=
  INCCROCO=
  if test "$gl_cv_libcroco_use_included" != yes; then
    PKG_CHECK_MODULES([CROCO], [libcroco-0.6])
    LIBCROCO=$CROCO_LIBS
    LTLIBCROCO=$CROCO_LIBS
    INCCROCO=$CROCO_CFLAGS
  fi
  AC_SUBST([LIBCROCO])
  AC_SUBST([LTLIBCROCO])
  AC_SUBST([INCCROCO])
  AC_MSG_CHECKING([whether to use the included libcroco])
  AC_MSG_RESULT([$gl_cv_libcroco_use_included])

  AM_CONDITIONAL([INCLUDED_LIBCROCO],
    [test "$gl_cv_libcroco_use_included" = yes])
])
