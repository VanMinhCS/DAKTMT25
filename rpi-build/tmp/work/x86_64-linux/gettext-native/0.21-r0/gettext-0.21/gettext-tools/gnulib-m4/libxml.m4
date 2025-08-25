# libxml.m4 serial 9
dnl Copyright (C) 2006, 2008, 2011, 2013, 2016, 2019 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

dnl gl_LIBXML
dnl   gives the user the option to decide whether to use the included or
dnl   an external libxml.
dnl gl_LIBXML(FORCE-INCLUDED)
dnl   forces the use of the included or an external libxml.
AC_DEFUN([gl_LIBXML],
[
  AC_REQUIRE([PKG_PROG_PKG_CONFIG])
  AC_REQUIRE([AM_ICONV_LINK])

  ifelse([$1], , [
    AC_MSG_CHECKING([whether included libxml is requested])
    AC_ARG_WITH([included-libxml],
      [  --with-included-libxml  use the libxml2 included here],
      [gl_cv_libxml_force_included=$withval],
      [gl_cv_libxml_force_included=no])
    AC_MSG_RESULT([$gl_cv_libxml_force_included])
  ], [gl_cv_libxml_force_included=$1])

  gl_cv_libxml_use_included="$gl_cv_libxml_force_included"
  LIBXML=
  LTLIBXML=
  INCXML=
  ifelse([$1], [yes], , [
    if test "$gl_cv_libxml_use_included" != yes; then
      PKG_CHECK_MODULES([XML], [libxml-2.0])
      LIBXML=$XML_LIBS
      LTLIBXML=$XML_LIBS
      INCXML=$XML_CFLAGS
    fi
  ])
  AC_SUBST([LIBXML])
  AC_SUBST([LTLIBXML])
  AC_SUBST([INCXML])
  AC_MSG_CHECKING([whether to use the included libxml])
  AC_MSG_RESULT([$gl_cv_libxml_use_included])

  if test "$gl_cv_libxml_use_included" = yes; then
    LIBXML_H=
    LIBXML_H="$LIBXML_H libxml/DOCBparser.h"
    LIBXML_H="$LIBXML_H libxml/HTMLparser.h"
    LIBXML_H="$LIBXML_H libxml/HTMLtree.h"
    LIBXML_H="$LIBXML_H libxml/SAX2.h"
    LIBXML_H="$LIBXML_H libxml/SAX.h"
    LIBXML_H="$LIBXML_H libxml/c14n.h"
    LIBXML_H="$LIBXML_H libxml/catalog.h"
    LIBXML_H="$LIBXML_H libxml/chvalid.h"
    LIBXML_H="$LIBXML_H libxml/debugXML.h"
    LIBXML_H="$LIBXML_H libxml/dict.h"
    LIBXML_H="$LIBXML_H libxml/encoding.h"
    LIBXML_H="$LIBXML_H libxml/entities.h"
    LIBXML_H="$LIBXML_H libxml/globals.h"
    LIBXML_H="$LIBXML_H libxml/hash.h"
    LIBXML_H="$LIBXML_H libxml/list.h"
    LIBXML_H="$LIBXML_H libxml/nanoftp.h"
    LIBXML_H="$LIBXML_H libxml/nanohttp.h"
    LIBXML_H="$LIBXML_H libxml/parser.h"
    LIBXML_H="$LIBXML_H libxml/parserInternals.h"
    LIBXML_H="$LIBXML_H libxml/pattern.h"
    LIBXML_H="$LIBXML_H libxml/relaxng.h"
    LIBXML_H="$LIBXML_H libxml/schemasInternals.h"
    LIBXML_H="$LIBXML_H libxml/schematron.h"
    LIBXML_H="$LIBXML_H libxml/threads.h"
    LIBXML_H="$LIBXML_H libxml/tree.h"
    LIBXML_H="$LIBXML_H libxml/uri.h"
    LIBXML_H="$LIBXML_H libxml/valid.h"
    LIBXML_H="$LIBXML_H libxml/xinclude.h"
    LIBXML_H="$LIBXML_H libxml/xlink.h"
    LIBXML_H="$LIBXML_H libxml/xmlIO.h"
    LIBXML_H="$LIBXML_H libxml/xmlautomata.h"
    LIBXML_H="$LIBXML_H libxml/xmlerror.h"
    LIBXML_H="$LIBXML_H libxml/xmlexports.h"
    LIBXML_H="$LIBXML_H libxml/xmlmemory.h"
    LIBXML_H="$LIBXML_H libxml/xmlmodule.h"
    LIBXML_H="$LIBXML_H libxml/xmlreader.h"
    LIBXML_H="$LIBXML_H libxml/xmlregexp.h"
    LIBXML_H="$LIBXML_H libxml/xmlsave.h"
    LIBXML_H="$LIBXML_H libxml/xmlschemas.h"
    LIBXML_H="$LIBXML_H libxml/xmlschemastypes.h"
    LIBXML_H="$LIBXML_H libxml/xmlstring.h"
    LIBXML_H="$LIBXML_H libxml/xmlunicode.h"
    LIBXML_H="$LIBXML_H libxml/xmlversion.h"
    LIBXML_H="$LIBXML_H libxml/xmlwriter.h"
    LIBXML_H="$LIBXML_H libxml/xpath.h"
    LIBXML_H="$LIBXML_H libxml/xpathInternals.h"
    LIBXML_H="$LIBXML_H libxml/xpointer.h"
    AC_CHECK_HEADERS([arpa/inet.h ctype.h dlfcn.h dl.h errno.h \
                      fcntl.h float.h limits.h malloc.h math.h netdb.h \
                      netinet/in.h signal.h stdlib.h string.h \
                      strings.h sys/select.h sys/socket.h sys/stat.h \
                      sys/time.h sys/types.h time.h unistd.h])
    AC_CHECK_HEADERS([arpa/nameser.h], [], [], [
      #if HAVE_SYS_TYPES_H
      # include <sys/types.h>
      #endif
    ])
    AC_CHECK_HEADERS([resolv.h], [], [], [
      #if HAVE_SYS_TYPES_H
      # include <sys/types.h>
      #endif
      #if HAVE_NETINET_IN_H
      # include <netinet/in.h>
      #endif 
      #if HAVE_ARPA_NAMESER_H 
      # include <arpa/nameser.h>
      #endif
    ])
    AC_CHECK_FUNCS([getaddrinfo localtime stat strftime])
    dnl This relies on the va_copy replacement from the stdarg module.
    AC_DEFINE([VA_COPY], [va_copy],
      [Define to a working va_copy macro or replacement.])
    dnl Don't bother checking for pthread.h and other multithread facilities.
    dnl Don't bother checking for zlib.h and how to link with libz.
  else
    LIBXML_H=
  fi
  AC_SUBST([LIBXML_H])

  AM_CONDITIONAL([INCLUDED_LIBXML],
    [test "$gl_cv_libxml_use_included" = yes])
])
