# libglib.m4 serial 5
dnl Copyright (C) 2006-2007, 2019 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_DEFUN([gl_LIBGLIB],
[
  AC_REQUIRE([PKG_PROG_PKG_CONFIG])
  AC_MSG_CHECKING([whether included glib is requested])
  AC_ARG_WITH([included-glib],
    [  --with-included-glib    use the glib2 included here],
    [gl_cv_libglib_force_included=$withval],
    [gl_cv_libglib_force_included=no])
  AC_MSG_RESULT([$gl_cv_libglib_force_included])

  gl_cv_libglib_use_included="$gl_cv_libglib_force_included"
  LIBGLIB=
  LTLIBGLIB=
  INCGLIB=
  if test "$gl_cv_libglib_use_included" != yes; then
    PKG_CHECK_MODULES([GLIB], [glib-2.0])
    LIBGLIB="$GLIB_LIBS"
    LTLIBGLIB="$GLIB_LIBS"
    INCGLIB="$GLIB_CFLAGS"
  fi
  AC_SUBST([LIBGLIB])
  AC_SUBST([LTLIBGLIB])
  AC_SUBST([INCGLIB])
  AC_MSG_CHECKING([whether to use the included glib])
  AC_MSG_RESULT([$gl_cv_libglib_use_included])

  if test "$gl_cv_libglib_use_included" = yes; then
    LIBGLIB_H=
    LIBGLIB_H="$LIBGLIB_H glib.h"
    LIBGLIB_H="$LIBGLIB_H glibconfig.h"
    LIBGLIB_H="$LIBGLIB_H glib/ghash.h"
    LIBGLIB_H="$LIBGLIB_H glib/glist.h"
    LIBGLIB_H="$LIBGLIB_H glib/gmacros.h"
    LIBGLIB_H="$LIBGLIB_H glib/gprimes.h"
    LIBGLIB_H="$LIBGLIB_H glib/gprintfint.h"
    LIBGLIB_H="$LIBGLIB_H glib/gstrfuncs.h"
    LIBGLIB_H="$LIBGLIB_H glib/gstring.h"
    LIBGLIB_H="$LIBGLIB_H glib/gtypes.h"
    AC_REQUIRE([AC_GNU_SOURCE])
    AC_CHECK_HEADERS([unistd.h])
    dnl Don't bother checking for pthread.h and other multithread facilities.
  else
    LIBGLIB_H=
  fi
  AC_SUBST([LIBGLIB_H])

  AM_CONDITIONAL([INCLUDED_LIBGLIB],
    [test "$gl_cv_libglib_use_included" = yes])
])
