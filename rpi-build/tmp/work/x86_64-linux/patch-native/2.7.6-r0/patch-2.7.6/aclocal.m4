# generated automatically by aclocal 1.16.5 -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_CONFIG_MACRO_DIRS], [m4_defun([_AM_CONFIG_MACRO_DIRS], [])m4_defun([AC_CONFIG_MACRO_DIRS], [_AM_CONFIG_MACRO_DIRS($@)])])
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
m4_if(m4_defn([AC_AUTOCONF_VERSION]), [2.71],,
[m4_warning([this file was generated for autoconf 2.71.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically 'autoreconf'.])])

# po.m4 serial 31 (gettext-0.20.2)
dnl Copyright (C) 1995-2014, 2016, 2018-2020 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.
dnl
dnl This file can be used in projects which are not available under
dnl the GNU General Public License or the GNU Lesser General Public
dnl License but which still want to provide support for the GNU gettext
dnl functionality.
dnl Please note that the actual code of the GNU gettext library is covered
dnl by the GNU Lesser General Public License, and the rest of the GNU
dnl gettext package is covered by the GNU General Public License.
dnl They are *not* in the public domain.

dnl Authors:
dnl   Ulrich Drepper <drepper@cygnus.com>, 1995-2000.
dnl   Bruno Haible <haible@clisp.cons.org>, 2000-2003.

AC_PREREQ([2.60])

dnl Checks for all prerequisites of the po subdirectory.
AC_DEFUN([AM_PO_SUBDIRS],
[
  AC_REQUIRE([AC_PROG_MAKE_SET])dnl
  AC_REQUIRE([AC_PROG_INSTALL])dnl
  AC_REQUIRE([AC_PROG_MKDIR_P])dnl
  AC_REQUIRE([AC_PROG_SED])dnl
  AC_REQUIRE([AM_NLS])dnl

  dnl Release version of the gettext macros. This is used to ensure that
  dnl the gettext macros and po/Makefile.in.in are in sync.
  AC_SUBST([GETTEXT_MACRO_VERSION], [0.20])

  dnl Perform the following tests also if --disable-nls has been given,
  dnl because they are needed for "make dist" to work.

  dnl Search for GNU msgfmt in the PATH.
  dnl The first test excludes Solaris msgfmt and early GNU msgfmt versions.
  dnl The second test excludes FreeBSD msgfmt.
  AM_PATH_PROG_WITH_TEST(MSGFMT, msgfmt,
    [$ac_dir/$ac_word --statistics /dev/null >&]AS_MESSAGE_LOG_FD[ 2>&1 &&
     (if $ac_dir/$ac_word --statistics /dev/null 2>&1 >/dev/null | grep usage >/dev/null; then exit 1; else exit 0; fi)],
    :)
  AC_PATH_PROG([GMSGFMT], [gmsgfmt], [$MSGFMT])

  dnl Test whether it is GNU msgfmt >= 0.15.
changequote(,)dnl
  case `$GMSGFMT --version | sed 1q | sed -e 's,^[^0-9]*,,'` in
    '' | 0.[0-9] | 0.[0-9].* | 0.1[0-4] | 0.1[0-4].*) GMSGFMT_015=: ;;
    *) GMSGFMT_015=$GMSGFMT ;;
  esac
changequote([,])dnl
  AC_SUBST([GMSGFMT_015])

  dnl Search for GNU xgettext 0.12 or newer in the PATH.
  dnl The first test excludes Solaris xgettext and early GNU xgettext versions.
  dnl The second test excludes FreeBSD xgettext.
  AM_PATH_PROG_WITH_TEST(XGETTEXT, xgettext,
    [$ac_dir/$ac_word --omit-header --copyright-holder= --msgid-bugs-address= /dev/null >&]AS_MESSAGE_LOG_FD[ 2>&1 &&
     (if $ac_dir/$ac_word --omit-header --copyright-holder= --msgid-bugs-address= /dev/null 2>&1 >/dev/null | grep usage >/dev/null; then exit 1; else exit 0; fi)],
    :)
  dnl Remove leftover from FreeBSD xgettext call.
  rm -f messages.po

  dnl Test whether it is GNU xgettext >= 0.15.
changequote(,)dnl
  case `$XGETTEXT --version | sed 1q | sed -e 's,^[^0-9]*,,'` in
    '' | 0.[0-9] | 0.[0-9].* | 0.1[0-4] | 0.1[0-4].*) XGETTEXT_015=: ;;
    *) XGETTEXT_015=$XGETTEXT ;;
  esac
changequote([,])dnl
  AC_SUBST([XGETTEXT_015])

  dnl Search for GNU msgmerge 0.11 or newer in the PATH.
  AM_PATH_PROG_WITH_TEST(MSGMERGE, msgmerge,
    [$ac_dir/$ac_word --update -q /dev/null /dev/null >&]AS_MESSAGE_LOG_FD[ 2>&1], :)

  dnl Test whether it is GNU msgmerge >= 0.20.
  if LC_ALL=C $MSGMERGE --help | grep ' --for-msgfmt ' >/dev/null; then
    MSGMERGE_FOR_MSGFMT_OPTION='--for-msgfmt'
  else
    dnl Test whether it is GNU msgmerge >= 0.12.
    if LC_ALL=C $MSGMERGE --help | grep ' --no-fuzzy-matching ' >/dev/null; then
      MSGMERGE_FOR_MSGFMT_OPTION='--no-fuzzy-matching --no-location --quiet'
    else
      dnl With these old versions, $(MSGMERGE) $(MSGMERGE_FOR_MSGFMT_OPTION) is
      dnl slow. But this is not a big problem, as such old gettext versions are
      dnl hardly in use any more.
      MSGMERGE_FOR_MSGFMT_OPTION='--no-location --quiet'
    fi
  fi
  AC_SUBST([MSGMERGE_FOR_MSGFMT_OPTION])

  dnl Support for AM_XGETTEXT_OPTION.
  test -n "${XGETTEXT_EXTRA_OPTIONS+set}" || XGETTEXT_EXTRA_OPTIONS=
  AC_SUBST([XGETTEXT_EXTRA_OPTIONS])

  AC_CONFIG_COMMANDS([po-directories], [[
    for ac_file in $CONFIG_FILES; do
      # Support "outfile[:infile[:infile...]]"
      case "$ac_file" in
        *:*) ac_file=`echo "$ac_file"|sed 's%:.*%%'` ;;
      esac
      # PO directories have a Makefile.in generated from Makefile.in.in.
      case "$ac_file" in */Makefile.in)
        # Adjust a relative srcdir.
        ac_dir=`echo "$ac_file"|sed 's%/[^/][^/]*$%%'`
        ac_dir_suffix=/`echo "$ac_dir"|sed 's%^\./%%'`
        ac_dots=`echo "$ac_dir_suffix"|sed 's%/[^/]*%../%g'`
        # In autoconf-2.13 it is called $ac_given_srcdir.
        # In autoconf-2.50 it is called $srcdir.
        test -n "$ac_given_srcdir" || ac_given_srcdir="$srcdir"
        case "$ac_given_srcdir" in
          .)  top_srcdir=`echo $ac_dots|sed 's%/$%%'` ;;
          /*) top_srcdir="$ac_given_srcdir" ;;
          *)  top_srcdir="$ac_dots$ac_given_srcdir" ;;
        esac
        # Treat a directory as a PO directory if and only if it has a
        # POTFILES.in file. This allows packages to have multiple PO
        # directories under different names or in different locations.
        if test -f "$ac_given_srcdir/$ac_dir/POTFILES.in"; then
          rm -f "$ac_dir/POTFILES"
          test -n "$as_me" && echo "$as_me: creating $ac_dir/POTFILES" || echo "creating $ac_dir/POTFILES"
          gt_tab=`printf '\t'`
          cat "$ac_given_srcdir/$ac_dir/POTFILES.in" | sed -e "/^#/d" -e "/^[ ${gt_tab}]*\$/d" -e "s,.*,     $top_srcdir/& \\\\," | sed -e "\$s/\(.*\) \\\\/\1/" > "$ac_dir/POTFILES"
          POMAKEFILEDEPS="POTFILES.in"
          # ALL_LINGUAS, POFILES, UPDATEPOFILES, DUMMYPOFILES, GMOFILES depend
          # on $ac_dir but don't depend on user-specified configuration
          # parameters.
          if test -f "$ac_given_srcdir/$ac_dir/LINGUAS"; then
            # The LINGUAS file contains the set of available languages.
            if test -n "$OBSOLETE_ALL_LINGUAS"; then
              test -n "$as_me" && echo "$as_me: setting ALL_LINGUAS in configure.in is obsolete" || echo "setting ALL_LINGUAS in configure.in is obsolete"
            fi
            ALL_LINGUAS=`sed -e "/^#/d" -e "s/#.*//" "$ac_given_srcdir/$ac_dir/LINGUAS"`
            POMAKEFILEDEPS="$POMAKEFILEDEPS LINGUAS"
          else
            # The set of available languages was given in configure.in.
            ALL_LINGUAS=$OBSOLETE_ALL_LINGUAS
          fi
          # Compute POFILES
          # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(lang).po)
          # Compute UPDATEPOFILES
          # as      $(foreach lang, $(ALL_LINGUAS), $(lang).po-update)
          # Compute DUMMYPOFILES
          # as      $(foreach lang, $(ALL_LINGUAS), $(lang).nop)
          # Compute GMOFILES
          # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(lang).gmo)
          case "$ac_given_srcdir" in
            .) srcdirpre= ;;
            *) srcdirpre='$(srcdir)/' ;;
          esac
          POFILES=
          UPDATEPOFILES=
          DUMMYPOFILES=
          GMOFILES=
          for lang in $ALL_LINGUAS; do
            POFILES="$POFILES $srcdirpre$lang.po"
            UPDATEPOFILES="$UPDATEPOFILES $lang.po-update"
            DUMMYPOFILES="$DUMMYPOFILES $lang.nop"
            GMOFILES="$GMOFILES $srcdirpre$lang.gmo"
          done
          # CATALOGS depends on both $ac_dir and the user's LINGUAS
          # environment variable.
          INST_LINGUAS=
          if test -n "$ALL_LINGUAS"; then
            for presentlang in $ALL_LINGUAS; do
              useit=no
              if test "%UNSET%" != "$LINGUAS"; then
                desiredlanguages="$LINGUAS"
              else
                desiredlanguages="$ALL_LINGUAS"
              fi
              for desiredlang in $desiredlanguages; do
                # Use the presentlang catalog if desiredlang is
                #   a. equal to presentlang, or
                #   b. a variant of presentlang (because in this case,
                #      presentlang can be used as a fallback for messages
                #      which are not translated in the desiredlang catalog).
                case "$desiredlang" in
                  "$presentlang"*) useit=yes;;
                esac
              done
              if test $useit = yes; then
                INST_LINGUAS="$INST_LINGUAS $presentlang"
              fi
            done
          fi
          CATALOGS=
          if test -n "$INST_LINGUAS"; then
            for lang in $INST_LINGUAS; do
              CATALOGS="$CATALOGS $lang.gmo"
            done
          fi
          test -n "$as_me" && echo "$as_me: creating $ac_dir/Makefile" || echo "creating $ac_dir/Makefile"
          sed -e "/^POTFILES =/r $ac_dir/POTFILES" -e "/^# Makevars/r $ac_given_srcdir/$ac_dir/Makevars" -e "s|@POFILES@|$POFILES|g" -e "s|@UPDATEPOFILES@|$UPDATEPOFILES|g" -e "s|@DUMMYPOFILES@|$DUMMYPOFILES|g" -e "s|@GMOFILES@|$GMOFILES|g" -e "s|@CATALOGS@|$CATALOGS|g" -e "s|@POMAKEFILEDEPS@|$POMAKEFILEDEPS|g" "$ac_dir/Makefile.in" > "$ac_dir/Makefile"
          for f in "$ac_given_srcdir/$ac_dir"/Rules-*; do
            if test -f "$f"; then
              case "$f" in
                *.orig | *.bak | *~) ;;
                *) cat "$f" >> "$ac_dir/Makefile" ;;
              esac
            fi
          done
        fi
        ;;
      esac
    done]],
   [# Capture the value of obsolete ALL_LINGUAS because we need it to compute
    # POFILES, UPDATEPOFILES, DUMMYPOFILES, GMOFILES, CATALOGS.
    OBSOLETE_ALL_LINGUAS="$ALL_LINGUAS"
    # Capture the value of LINGUAS because we need it to compute CATALOGS.
    LINGUAS="${LINGUAS-%UNSET%}"
   ])
])

dnl Postprocesses a Makefile in a directory containing PO files.
AC_DEFUN([AM_POSTPROCESS_PO_MAKEFILE],
[
  # When this code is run, in config.status, two variables have already been
  # set:
  # - OBSOLETE_ALL_LINGUAS is the value of LINGUAS set in configure.in,
  # - LINGUAS is the value of the environment variable LINGUAS at configure
  #   time.

changequote(,)dnl
  # Adjust a relative srcdir.
  ac_dir=`echo "$ac_file"|sed 's%/[^/][^/]*$%%'`
  ac_dir_suffix=/`echo "$ac_dir"|sed 's%^\./%%'`
  ac_dots=`echo "$ac_dir_suffix"|sed 's%/[^/]*%../%g'`
  # In autoconf-2.13 it is called $ac_given_srcdir.
  # In autoconf-2.50 it is called $srcdir.
  test -n "$ac_given_srcdir" || ac_given_srcdir="$srcdir"
  case "$ac_given_srcdir" in
    .)  top_srcdir=`echo $ac_dots|sed 's%/$%%'` ;;
    /*) top_srcdir="$ac_given_srcdir" ;;
    *)  top_srcdir="$ac_dots$ac_given_srcdir" ;;
  esac

  # Find a way to echo strings without interpreting backslash.
  if test "X`(echo '\t') 2>/dev/null`" = 'X\t'; then
    gt_echo='echo'
  else
    if test "X`(printf '%s\n' '\t') 2>/dev/null`" = 'X\t'; then
      gt_echo='printf %s\n'
    else
      echo_func () {
        cat <<EOT
$*
EOT
      }
      gt_echo='echo_func'
    fi
  fi

  # A sed script that extracts the value of VARIABLE from a Makefile.
  tab=`printf '\t'`
  sed_x_variable='
# Test if the hold space is empty.
x
s/P/P/
x
ta
# Yes it was empty. Look if we have the expected variable definition.
/^['"${tab}"' ]*VARIABLE['"${tab}"' ]*=/{
  # Seen the first line of the variable definition.
  s/^['"${tab}"' ]*VARIABLE['"${tab}"' ]*=//
  ba
}
bd
:a
# Here we are processing a line from the variable definition.
# Remove comment, more precisely replace it with a space.
s/#.*$/ /
# See if the line ends in a backslash.
tb
:b
s/\\$//
# Print the line, without the trailing backslash.
p
tc
# There was no trailing backslash. The end of the variable definition is
# reached. Clear the hold space.
s/^.*$//
x
bd
:c
# A trailing backslash means that the variable definition continues in the
# next line. Put a nonempty string into the hold space to indicate this.
s/^.*$/P/
x
:d
'
changequote([,])dnl

  # Set POTFILES to the value of the Makefile variable POTFILES.
  sed_x_POTFILES=`$gt_echo "$sed_x_variable" | sed -e '/^ *#/d' -e 's/VARIABLE/POTFILES/g'`
  POTFILES=`sed -n -e "$sed_x_POTFILES" < "$ac_file"`
  # Compute POTFILES_DEPS as
  #   $(foreach file, $(POTFILES), $(top_srcdir)/$(file))
  POTFILES_DEPS=
  for file in $POTFILES; do
    POTFILES_DEPS="$POTFILES_DEPS "'$(top_srcdir)/'"$file"
  done
  POMAKEFILEDEPS=""

  if test -n "$OBSOLETE_ALL_LINGUAS"; then
    test -n "$as_me" && echo "$as_me: setting ALL_LINGUAS in configure.in is obsolete" || echo "setting ALL_LINGUAS in configure.in is obsolete"
  fi
  if test -f "$ac_given_srcdir/$ac_dir/LINGUAS"; then
    # The LINGUAS file contains the set of available languages.
    ALL_LINGUAS=`sed -e "/^#/d" -e "s/#.*//" "$ac_given_srcdir/$ac_dir/LINGUAS"`
    POMAKEFILEDEPS="$POMAKEFILEDEPS LINGUAS"
  else
    # Set ALL_LINGUAS to the value of the Makefile variable LINGUAS.
    sed_x_LINGUAS=`$gt_echo "$sed_x_variable" | sed -e '/^ *#/d' -e 's/VARIABLE/LINGUAS/g'`
    ALL_LINGUAS=`sed -n -e "$sed_x_LINGUAS" < "$ac_file"`
  fi
  # Compute POFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(lang).po)
  # Compute UPDATEPOFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(lang).po-update)
  # Compute DUMMYPOFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(lang).nop)
  # Compute GMOFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(lang).gmo)
  # Compute PROPERTIESFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(DOMAIN)_$(lang).properties)
  # Compute CLASSFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(DOMAIN)_$(lang).class)
  # Compute QMFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(lang).qm)
  # Compute MSGFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(frob $(lang)).msg)
  # Compute RESOURCESDLLFILES
  # as      $(foreach lang, $(ALL_LINGUAS), $(srcdir)/$(frob $(lang))/$(DOMAIN).resources.dll)
  case "$ac_given_srcdir" in
    .) srcdirpre= ;;
    *) srcdirpre='$(srcdir)/' ;;
  esac
  POFILES=
  UPDATEPOFILES=
  DUMMYPOFILES=
  GMOFILES=
  PROPERTIESFILES=
  CLASSFILES=
  QMFILES=
  MSGFILES=
  RESOURCESDLLFILES=
  for lang in $ALL_LINGUAS; do
    POFILES="$POFILES $srcdirpre$lang.po"
    UPDATEPOFILES="$UPDATEPOFILES $lang.po-update"
    DUMMYPOFILES="$DUMMYPOFILES $lang.nop"
    GMOFILES="$GMOFILES $srcdirpre$lang.gmo"
    PROPERTIESFILES="$PROPERTIESFILES \$(srcdir)/\$(DOMAIN)_$lang.properties"
    CLASSFILES="$CLASSFILES \$(srcdir)/\$(DOMAIN)_$lang.class"
    QMFILES="$QMFILES $srcdirpre$lang.qm"
    frobbedlang=`echo $lang | sed -e 's/\..*$//' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
    MSGFILES="$MSGFILES $srcdirpre$frobbedlang.msg"
    frobbedlang=`echo $lang | sed -e 's/_/-/g' -e 's/^sr-CS/sr-SP/' -e 's/@latin$/-Latn/' -e 's/@cyrillic$/-Cyrl/' -e 's/^sr-SP$/sr-SP-Latn/' -e 's/^uz-UZ$/uz-UZ-Latn/'`
    RESOURCESDLLFILES="$RESOURCESDLLFILES $srcdirpre$frobbedlang/\$(DOMAIN).resources.dll"
  done
  # CATALOGS depends on both $ac_dir and the user's LINGUAS
  # environment variable.
  INST_LINGUAS=
  if test -n "$ALL_LINGUAS"; then
    for presentlang in $ALL_LINGUAS; do
      useit=no
      if test "%UNSET%" != "$LINGUAS"; then
        desiredlanguages="$LINGUAS"
      else
        desiredlanguages="$ALL_LINGUAS"
      fi
      for desiredlang in $desiredlanguages; do
        # Use the presentlang catalog if desiredlang is
        #   a. equal to presentlang, or
        #   b. a variant of presentlang (because in this case,
        #      presentlang can be used as a fallback for messages
        #      which are not translated in the desiredlang catalog).
        case "$desiredlang" in
          "$presentlang"*) useit=yes;;
        esac
      done
      if test $useit = yes; then
        INST_LINGUAS="$INST_LINGUAS $presentlang"
      fi
    done
  fi
  CATALOGS=
  JAVACATALOGS=
  QTCATALOGS=
  TCLCATALOGS=
  CSHARPCATALOGS=
  if test -n "$INST_LINGUAS"; then
    for lang in $INST_LINGUAS; do
      CATALOGS="$CATALOGS $lang.gmo"
      JAVACATALOGS="$JAVACATALOGS \$(DOMAIN)_$lang.properties"
      QTCATALOGS="$QTCATALOGS $lang.qm"
      frobbedlang=`echo $lang | sed -e 's/\..*$//' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
      TCLCATALOGS="$TCLCATALOGS $frobbedlang.msg"
      frobbedlang=`echo $lang | sed -e 's/_/-/g' -e 's/^sr-CS/sr-SP/' -e 's/@latin$/-Latn/' -e 's/@cyrillic$/-Cyrl/' -e 's/^sr-SP$/sr-SP-Latn/' -e 's/^uz-UZ$/uz-UZ-Latn/'`
      CSHARPCATALOGS="$CSHARPCATALOGS $frobbedlang/\$(DOMAIN).resources.dll"
    done
  fi

  sed -e "s|@POTFILES_DEPS@|$POTFILES_DEPS|g" -e "s|@POFILES@|$POFILES|g" -e "s|@UPDATEPOFILES@|$UPDATEPOFILES|g" -e "s|@DUMMYPOFILES@|$DUMMYPOFILES|g" -e "s|@GMOFILES@|$GMOFILES|g" -e "s|@PROPERTIESFILES@|$PROPERTIESFILES|g" -e "s|@CLASSFILES@|$CLASSFILES|g" -e "s|@QMFILES@|$QMFILES|g" -e "s|@MSGFILES@|$MSGFILES|g" -e "s|@RESOURCESDLLFILES@|$RESOURCESDLLFILES|g" -e "s|@CATALOGS@|$CATALOGS|g" -e "s|@JAVACATALOGS@|$JAVACATALOGS|g" -e "s|@QTCATALOGS@|$QTCATALOGS|g" -e "s|@TCLCATALOGS@|$TCLCATALOGS|g" -e "s|@CSHARPCATALOGS@|$CSHARPCATALOGS|g" -e 's,^#distdir:,distdir:,' < "$ac_file" > "$ac_file.tmp"
  tab=`printf '\t'`
  if grep -l '@TCLCATALOGS@' "$ac_file" > /dev/null; then
    # Add dependencies that cannot be formulated as a simple suffix rule.
    for lang in $ALL_LINGUAS; do
      frobbedlang=`echo $lang | sed -e 's/\..*$//' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
      cat >> "$ac_file.tmp" <<EOF
$frobbedlang.msg: $lang.po
${tab}@echo "\$(MSGFMT) -c --tcl -d \$(srcdir) -l $lang $srcdirpre$lang.po"; \
${tab}\$(MSGFMT) -c --tcl -d "\$(srcdir)" -l $lang $srcdirpre$lang.po || { rm -f "\$(srcdir)/$frobbedlang.msg"; exit 1; }
EOF
    done
  fi
  if grep -l '@CSHARPCATALOGS@' "$ac_file" > /dev/null; then
    # Add dependencies that cannot be formulated as a simple suffix rule.
    for lang in $ALL_LINGUAS; do
      frobbedlang=`echo $lang | sed -e 's/_/-/g' -e 's/^sr-CS/sr-SP/' -e 's/@latin$/-Latn/' -e 's/@cyrillic$/-Cyrl/' -e 's/^sr-SP$/sr-SP-Latn/' -e 's/^uz-UZ$/uz-UZ-Latn/'`
      cat >> "$ac_file.tmp" <<EOF
$frobbedlang/\$(DOMAIN).resources.dll: $lang.po
${tab}@echo "\$(MSGFMT) -c --csharp -d \$(srcdir) -l $lang $srcdirpre$lang.po -r \$(DOMAIN)"; \
${tab}\$(MSGFMT) -c --csharp -d "\$(srcdir)" -l $lang $srcdirpre$lang.po -r "\$(DOMAIN)" || { rm -f "\$(srcdir)/$frobbedlang.msg"; exit 1; }
EOF
    done
  fi
  if test -n "$POMAKEFILEDEPS"; then
    cat >> "$ac_file.tmp" <<EOF
Makefile: $POMAKEFILEDEPS
EOF
  fi
  mv "$ac_file.tmp" "$ac_file"
])

dnl Initializes the accumulator used by AM_XGETTEXT_OPTION.
AC_DEFUN([AM_XGETTEXT_OPTION_INIT],
[
  XGETTEXT_EXTRA_OPTIONS=
])

dnl Registers an option to be passed to xgettext in the po subdirectory.
AC_DEFUN([AM_XGETTEXT_OPTION],
[
  AC_REQUIRE([AM_XGETTEXT_OPTION_INIT])
  XGETTEXT_EXTRA_OPTIONS="$XGETTEXT_EXTRA_OPTIONS $1"
])

# Copyright (C) 2002-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
# (This private macro should not be called outside this file.)
AC_DEFUN([AM_AUTOMAKE_VERSION],
[am__api_version='1.16'
dnl Some users find AM_AUTOMAKE_VERSION and mistake it for a way to
dnl require some minimum version.  Point them to the right macro.
m4_if([$1], [1.16.5], [],
      [AC_FATAL([Do not call $0, use AM_INIT_AUTOMAKE([$1]).])])dnl
])

# _AM_AUTOCONF_VERSION(VERSION)
# -----------------------------
# aclocal traces this macro to find the Autoconf version.
# This is a private macro too.  Using m4_define simplifies
# the logic in aclocal, which can simply ignore this definition.
m4_define([_AM_AUTOCONF_VERSION], [])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION and AM_AUTOMAKE_VERSION so they can be traced.
# This function is AC_REQUIREd by AM_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
[AM_AUTOMAKE_VERSION([1.16.5])dnl
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
_AM_AUTOCONF_VERSION(m4_defn([AC_AUTOCONF_VERSION]))])

# Copyright (C) 2011-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_AR([ACT-IF-FAIL])
# -------------------------
# Try to determine the archiver interface, and trigger the ar-lib wrapper
# if it is needed.  If the detection of archiver interface fails, run
# ACT-IF-FAIL (default is to abort configure with a proper error message).
AC_DEFUN([AM_PROG_AR],
[AC_BEFORE([$0], [LT_INIT])dnl
AC_BEFORE([$0], [AC_PROG_LIBTOOL])dnl
AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([ar-lib])dnl
AC_CHECK_TOOLS([AR], [ar lib "link -lib"], [false])
: ${AR=ar}

AC_CACHE_CHECK([the archiver ($AR) interface], [am_cv_ar_interface],
  [AC_LANG_PUSH([C])
   am_cv_ar_interface=ar
   AC_COMPILE_IFELSE([AC_LANG_SOURCE([[int some_variable = 0;]])],
     [am_ar_try='$AR cru libconftest.a conftest.$ac_objext >&AS_MESSAGE_LOG_FD'
      AC_TRY_EVAL([am_ar_try])
      if test "$ac_status" -eq 0; then
        am_cv_ar_interface=ar
      else
        am_ar_try='$AR -NOLOGO -OUT:conftest.lib conftest.$ac_objext >&AS_MESSAGE_LOG_FD'
        AC_TRY_EVAL([am_ar_try])
        if test "$ac_status" -eq 0; then
          am_cv_ar_interface=lib
        else
          am_cv_ar_interface=unknown
        fi
      fi
      rm -f conftest.lib libconftest.a
     ])
   AC_LANG_POP([C])])

case $am_cv_ar_interface in
ar)
  ;;
lib)
  # Microsoft lib, so override with the ar-lib wrapper script.
  # FIXME: It is wrong to rewrite AR.
  # But if we don't then we get into trouble of one sort or another.
  # A longer-term fix would be to have automake use am__AR in this case,
  # and then we could set am__AR="$am_aux_dir/ar-lib \$(AR)" or something
  # similar.
  AR="$am_aux_dir/ar-lib $AR"
  ;;
unknown)
  m4_default([$1],
             [AC_MSG_ERROR([could not determine $AR interface])])
  ;;
esac
AC_SUBST([AR])dnl
])

# AM_AUX_DIR_EXPAND                                         -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to '$srcdir/foo'.  In other projects, it is set to
# '$srcdir', '$srcdir/..', or '$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is '.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

AC_DEFUN([AM_AUX_DIR_EXPAND],
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
# Expand $ac_aux_dir to an absolute path.
am_aux_dir=`cd "$ac_aux_dir" && pwd`
])

# AM_CONDITIONAL                                            -*- Autoconf -*-

# Copyright (C) 1997-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[AC_PREREQ([2.52])dnl
 m4_if([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
       [$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])dnl
AC_SUBST([$1_FALSE])dnl
_AM_SUBST_NOTMAKE([$1_TRUE])dnl
_AM_SUBST_NOTMAKE([$1_FALSE])dnl
m4_define([_AM_COND_VALUE_$1], [$2])dnl
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([[conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.]])
fi])])

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.


# There are a few dirty hacks below to avoid letting 'AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...


# _AM_DEPENDENCIES(NAME)
# ----------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX", "OBJC", "OBJCXX", "UPC", or "GJC".
# We try a few techniques and use that to set a single cache variable.
#
# We don't AC_REQUIRE the corresponding AC_PROG_CC since the latter was
# modified to invoke _AM_DEPENDENCIES(CC); we would have a circular
# dependency, and given that the user is not expected to run this macro,
# just rely on AC_PROG_CC.
AC_DEFUN([_AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
AC_REQUIRE([AM_MAKE_INCLUDE])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl

m4_if([$1], [CC],   [depcc="$CC"   am_compiler_list=],
      [$1], [CXX],  [depcc="$CXX"  am_compiler_list=],
      [$1], [OBJC], [depcc="$OBJC" am_compiler_list='gcc3 gcc'],
      [$1], [OBJCXX], [depcc="$OBJCXX" am_compiler_list='gcc3 gcc'],
      [$1], [UPC],  [depcc="$UPC"  am_compiler_list=],
      [$1], [GCJ],  [depcc="$GCJ"  am_compiler_list='gcc3 gcc'],
                    [depcc="$$1"   am_compiler_list=])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named 'D' -- because '-MD' means "put the output
  # in D".
  rm -rf conftest.dir
  mkdir conftest.dir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" conftest.dir
  cd conftest.dir
  # We will build objects and dependencies in a subdirectory because
  # it helps to detect inapplicable dependency modes.  For instance
  # both Tru64's cc and ICC support -MD to output dependencies as a
  # side effect of compilation, but ICC will put the dependencies in
  # the current directory while Tru64 will put them in the object
  # directory.
  mkdir sub

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list=`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`
  fi
  am__universal=false
  m4_case([$1], [CC],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac],
    [CXX],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac])

  for depmode in $am_compiler_list; do
    # Setup a source with many dependencies, because some compilers
    # like to wrap large dependency lists on column 80 (with \), and
    # we should not choose a depcomp mode which is confused by this.
    #
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    : > sub/conftest.c
    for i in 1 2 3 4 5 6; do
      echo '#include "conftst'$i'.h"' >> sub/conftest.c
      # Using ": > sub/conftst$i.h" creates only sub/conftst1.h with
      # Solaris 10 /bin/sh.
      echo '/* dummy */' > sub/conftst$i.h
    done
    echo "${am__include} ${am__quote}sub/conftest.Po${am__quote}" > confmf

    # We check with '-c' and '-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle '-M -o', and we need to detect this.  Also, some Intel
    # versions had trouble with output in subdirs.
    am__obj=sub/conftest.${OBJEXT-o}
    am__minus_obj="-o $am__obj"
    case $depmode in
    gcc)
      # This depmode causes a compiler race in universal mode.
      test "$am__universal" = false || continue
      ;;
    nosideeffect)
      # After this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested.
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    msvc7 | msvc7msys | msvisualcpp | msvcmsys)
      # This compiler won't grok '-c -o', but also, the minuso test has
      # not run yet.  These depmodes are late enough in the game, and
      # so weak that their functioning should not be impacted.
      am__obj=conftest.${OBJEXT-o}
      am__minus_obj=
      ;;
    none) break ;;
    esac
    if depmode=$depmode \
       source=sub/conftest.c object=$am__obj \
       depfile=sub/conftest.Po tmpdepfile=sub/conftest.TPo \
       $SHELL ./depcomp $depcc -c $am__minus_obj sub/conftest.c \
         >/dev/null 2>conftest.err &&
       grep sub/conftst1.h sub/conftest.Po > /dev/null 2>&1 &&
       grep sub/conftst6.h sub/conftest.Po > /dev/null 2>&1 &&
       grep $am__obj sub/conftest.Po > /dev/null 2>&1 &&
       ${MAKE-make} -s -f confmf > /dev/null 2>&1; then
      # icc doesn't choke on unknown options, it will just issue warnings
      # or remarks (even with -Werror).  So we grep stderr for any message
      # that says an option was ignored or not supported.
      # When given -MP, icc 7.0 and 7.1 complain thusly:
      #   icc: Command line warning: ignoring option '-M'; no argument required
      # The diagnosis changed in icc 8.0:
      #   icc: Command line remark: option '-MP' not supported
      if (grep 'ignoring option' conftest.err ||
          grep 'not supported' conftest.err) >/dev/null 2>&1; then :; else
        am_cv_$1_dependencies_compiler_type=$depmode
        break
      fi
    fi
  done

  cd ..
  rm -rf conftest.dir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
AC_SUBST([$1DEPMODE], [depmode=$am_cv_$1_dependencies_compiler_type])
AM_CONDITIONAL([am__fastdep$1], [
  test "x$enable_dependency_tracking" != xno \
  && test "$am_cv_$1_dependencies_compiler_type" = gcc3])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in _AM_DEPENDENCIES.
AC_DEFUN([AM_SET_DEPDIR],
[AC_REQUIRE([AM_SET_LEADING_DOT])dnl
AC_SUBST([DEPDIR], ["${am__leading_dot}deps"])dnl
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE([dependency-tracking], [dnl
AS_HELP_STRING(
  [--enable-dependency-tracking],
  [do not reject slow dependency extractors])
AS_HELP_STRING(
  [--disable-dependency-tracking],
  [speeds up one-time build])])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
  am__nodep='_no'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
AC_SUBST([AMDEPBACKSLASH])dnl
_AM_SUBST_NOTMAKE([AMDEPBACKSLASH])dnl
AC_SUBST([am__nodep])dnl
_AM_SUBST_NOTMAKE([am__nodep])dnl
])

# Generate code to set up dependency tracking.              -*- Autoconf -*-

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_OUTPUT_DEPENDENCY_COMMANDS
# ------------------------------
AC_DEFUN([_AM_OUTPUT_DEPENDENCY_COMMANDS],
[{
  # Older Autoconf quotes --file arguments for eval, but not when files
  # are listed without --file.  Let's play safe and only enable the eval
  # if we detect the quoting.
  # TODO: see whether this extra hack can be removed once we start
  # requiring Autoconf 2.70 or later.
  AS_CASE([$CONFIG_FILES],
          [*\'*], [eval set x "$CONFIG_FILES"],
          [*], [set x $CONFIG_FILES])
  shift
  # Used to flag and report bootstrapping failures.
  am_rc=0
  for am_mf
  do
    # Strip MF so we end up with the name of the file.
    am_mf=`AS_ECHO(["$am_mf"]) | sed -e 's/:.*$//'`
    # Check whether this is an Automake generated Makefile which includes
    # dependency-tracking related rules and includes.
    # Grep'ing the whole file directly is not great: AIX grep has a line
    # limit of 2048, but all sed's we know have understand at least 4000.
    sed -n 's,^am--depfiles:.*,X,p' "$am_mf" | grep X >/dev/null 2>&1 \
      || continue
    am_dirpart=`AS_DIRNAME(["$am_mf"])`
    am_filepart=`AS_BASENAME(["$am_mf"])`
    AM_RUN_LOG([cd "$am_dirpart" \
      && sed -e '/# am--include-marker/d' "$am_filepart" \
        | $MAKE -f - am--depfiles]) || am_rc=$?
  done
  if test $am_rc -ne 0; then
    AC_MSG_FAILURE([Something went wrong bootstrapping makefile fragments
    for automatic dependency tracking.  If GNU make was not used, consider
    re-running the configure script with MAKE="gmake" (or whatever is
    necessary).  You can also try re-running configure with the
    '--disable-dependency-tracking' option to at least be able to build
    the package (albeit without support for automatic dependency tracking).])
  fi
  AS_UNSET([am_dirpart])
  AS_UNSET([am_filepart])
  AS_UNSET([am_mf])
  AS_UNSET([am_rc])
  rm -f conftest-deps.mk
}
])# _AM_OUTPUT_DEPENDENCY_COMMANDS


# AM_OUTPUT_DEPENDENCY_COMMANDS
# -----------------------------
# This macro should only be invoked once -- use via AC_REQUIRE.
#
# This code is only required when automatic dependency tracking is enabled.
# This creates each '.Po' and '.Plo' makefile fragment that we'll need in
# order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],
[AC_CONFIG_COMMANDS([depfiles],
     [test x"$AMDEP_TRUE" != x"" || _AM_OUTPUT_DEPENDENCY_COMMANDS],
     [AMDEP_TRUE="$AMDEP_TRUE" MAKE="${MAKE-make}"])])

# Do all the work for Automake.                             -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This macro actually does too much.  Some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

dnl Redefine AC_PROG_CC to automatically invoke _AM_PROG_CC_C_O.
m4_define([AC_PROG_CC],
m4_defn([AC_PROG_CC])
[_AM_PROG_CC_C_O
])

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_PREREQ([2.65])dnl
m4_ifdef([_$0_ALREADY_INIT],
  [m4_fatal([$0 expanded multiple times
]m4_defn([_$0_ALREADY_INIT]))],
  [m4_define([_$0_ALREADY_INIT], m4_expansion_stack)])dnl
dnl Autoconf wants to disallow AM_ names.  We explicitly allow
dnl the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl
AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
AC_REQUIRE([AC_PROG_INSTALL])dnl
if test "`cd $srcdir && pwd`" != "`pwd`"; then
  # Use -I$(srcdir) only when $(srcdir) != ., so that make's output
  # is not polluted with repeated "-I."
  AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
  # test to see if srcdir already configured
  if test -f $srcdir/config.status; then
    AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
  fi
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[AC_DIAGNOSE([obsolete],
             [$0: two- and three-arguments forms are deprecated.])
m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
dnl Diagnose old-style AC_INIT with new-style AM_AUTOMAKE_INIT.
m4_if(
  m4_ifset([AC_PACKAGE_NAME], [ok]):m4_ifset([AC_PACKAGE_VERSION], [ok]),
  [ok:ok],,
  [m4_fatal([AC_INIT should be called with package and version arguments])])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED([PACKAGE], ["$PACKAGE"], [Name of package])
 AC_DEFINE_UNQUOTED([VERSION], ["$VERSION"], [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG([ACLOCAL], [aclocal-${am__api_version}])
AM_MISSING_PROG([AUTOCONF], [autoconf])
AM_MISSING_PROG([AUTOMAKE], [automake-${am__api_version}])
AM_MISSING_PROG([AUTOHEADER], [autoheader])
AM_MISSING_PROG([MAKEINFO], [makeinfo])
AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
AC_REQUIRE([AM_PROG_INSTALL_STRIP])dnl
AC_REQUIRE([AC_PROG_MKDIR_P])dnl
# For better backward compatibility.  To be removed once Automake 1.9.x
# dies out for good.  For more background, see:
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00001.html>
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00014.html>
AC_SUBST([mkdir_p], ['$(MKDIR_P)'])
# We need awk for the "check" target (and possibly the TAP driver).  The
# system "awk" is bad on some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl
_AM_IF_OPTION([tar-ustar], [_AM_PROG_TAR([ustar])],
	      [_AM_IF_OPTION([tar-pax], [_AM_PROG_TAR([pax])],
			     [_AM_PROG_TAR([v7])])])
_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
		  [_AM_DEPENDENCIES([CC])],
		  [m4_define([AC_PROG_CC],
			     m4_defn([AC_PROG_CC])[_AM_DEPENDENCIES([CC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
		  [_AM_DEPENDENCIES([CXX])],
		  [m4_define([AC_PROG_CXX],
			     m4_defn([AC_PROG_CXX])[_AM_DEPENDENCIES([CXX])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJC],
		  [_AM_DEPENDENCIES([OBJC])],
		  [m4_define([AC_PROG_OBJC],
			     m4_defn([AC_PROG_OBJC])[_AM_DEPENDENCIES([OBJC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJCXX],
		  [_AM_DEPENDENCIES([OBJCXX])],
		  [m4_define([AC_PROG_OBJCXX],
			     m4_defn([AC_PROG_OBJCXX])[_AM_DEPENDENCIES([OBJCXX])])])dnl
])
# Variables for tags utilities; see am/tags.am
if test -z "$CTAGS"; then
  CTAGS=ctags
fi
AC_SUBST([CTAGS])
if test -z "$ETAGS"; then
  ETAGS=etags
fi
AC_SUBST([ETAGS])
if test -z "$CSCOPE"; then
  CSCOPE=cscope
fi
AC_SUBST([CSCOPE])

AC_REQUIRE([AM_SILENT_RULES])dnl
dnl The testsuite driver may need to know about EXEEXT, so add the
dnl 'am__EXEEXT' conditional if _AM_COMPILER_EXEEXT was seen.  This
dnl macro is hooked onto _AC_COMPILER_EXEEXT early, see below.
AC_CONFIG_COMMANDS_PRE(dnl
[m4_provide_if([_AM_COMPILER_EXEEXT],
  [AM_CONDITIONAL([am__EXEEXT], [test -n "$EXEEXT"])])])dnl

# POSIX will say in a future version that running "rm -f" with no argument
# is OK; and we want to be able to make that assumption in our Makefile
# recipes.  So use an aggressive probe to check that the usage we want is
# actually supported "in the wild" to an acceptable degree.
# See automake bug#10828.
# To make any issue more visible, cause the running configure to be aborted
# by default if the 'rm' program in use doesn't match our expectations; the
# user can still override this though.
if rm -f && rm -fr && rm -rf; then : OK; else
  cat >&2 <<'END'
Oops!

Your 'rm' program seems unable to run without file operands specified
on the command line, even when the '-f' option is present.  This is contrary
to the behaviour of most rm programs out there, and not conforming with
the upcoming POSIX standard: <http://austingroupbugs.net/view.php?id=542>

Please tell bug-automake@gnu.org about your system, including the value
of your $PATH and any error possibly output before this message.  This
can help us improve future automake versions.

END
  if test x"$ACCEPT_INFERIOR_RM_PROGRAM" = x"yes"; then
    echo 'Configuration will proceed anyway, since you have set the' >&2
    echo 'ACCEPT_INFERIOR_RM_PROGRAM variable to "yes"' >&2
    echo >&2
  else
    cat >&2 <<'END'
Aborting the configuration process, to ensure you take notice of the issue.

You can download and install GNU coreutils to get an 'rm' implementation
that behaves properly: <https://www.gnu.org/software/coreutils/>.

If you want to complete the configuration process using your problematic
'rm' anyway, export the environment variable ACCEPT_INFERIOR_RM_PROGRAM
to "yes", and re-run configure.

END
    AC_MSG_ERROR([Your 'rm' program is bad, sorry.])
  fi
fi
dnl The trailing newline in this macro's definition is deliberate, for
dnl backward compatibility and to allow trailing 'dnl'-style comments
dnl after the AM_INIT_AUTOMAKE invocation. See automake bug#16841.
])

dnl Hook into '_AC_COMPILER_EXEEXT' early to learn its expansion.  Do not
dnl add the conditional right here, as _AC_COMPILER_EXEEXT may be further
dnl mangled by Autoconf and run in a shell conditional statement.
m4_define([_AC_COMPILER_EXEEXT],
m4_defn([_AC_COMPILER_EXEEXT])[m4_provide([_AM_COMPILER_EXEEXT])])

# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_arg=$1
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $_am_arg | $_am_arg:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $_am_arg" >`AS_DIRNAME(["$_am_arg"])`/stamp-h[]$_am_stamp_count])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.
AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
if test x"${install_sh+set}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    install_sh="\${SHELL} '$am_aux_dir/install-sh'" ;;
  *)
    install_sh="\${SHELL} $am_aux_dir/install-sh"
  esac
fi
AC_SUBST([install_sh])])

# Copyright (C) 2003-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# Check to see how 'make' treats includes.	            -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_MAKE_INCLUDE()
# -----------------
# Check whether make has an 'include' directive that can support all
# the idioms we need for our automatic dependency tracking code.
AC_DEFUN([AM_MAKE_INCLUDE],
[AC_MSG_CHECKING([whether ${MAKE-make} supports the include directive])
cat > confinc.mk << 'END'
am__doit:
	@echo this is the am__doit target >confinc.out
.PHONY: am__doit
END
am__include="#"
am__quote=
# BSD make does it like this.
echo '.include "confinc.mk" # ignored' > confmf.BSD
# Other make implementations (GNU, Solaris 10, AIX) do it like this.
echo 'include confinc.mk # ignored' > confmf.GNU
_am_result=no
for s in GNU BSD; do
  AM_RUN_LOG([${MAKE-make} -f confmf.$s && cat confinc.out])
  AS_CASE([$?:`cat confinc.out 2>/dev/null`],
      ['0:this is the am__doit target'],
      [AS_CASE([$s],
          [BSD], [am__include='.include' am__quote='"'],
          [am__include='include' am__quote=''])])
  if test "$am__include" != "#"; then
    _am_result="yes ($s style)"
    break
  fi
done
rm -f confinc.* confmf.*
AC_MSG_RESULT([${_am_result}])
AC_SUBST([am__include])])
AC_SUBST([am__quote])])

# Fake the existence of programs that GNU maintainers use.  -*- Autoconf -*-

# Copyright (C) 1997-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])

# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it is modern enough.
# If it is, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([missing])dnl
if test x"${MISSING+set}" != xset; then
  MISSING="\${SHELL} '$am_aux_dir/missing'"
fi
# Use eval to expand $SHELL
if eval "$MISSING --is-lightweight"; then
  am_missing_run="$MISSING "
else
  am_missing_run=
  AC_MSG_WARN(['missing' script is too old or missing])
fi
])

# Helper functions for option handling.                     -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# --------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), [1])])

# _AM_SET_OPTIONS(OPTIONS)
# ------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[m4_foreach_w([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_PROG_CC_C_O
# ---------------
# Like AC_PROG_CC_C_O, but changed for automake.  We rewrite AC_PROG_CC
# to automatically call this.
AC_DEFUN([_AM_PROG_CC_C_O],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([compile])dnl
AC_LANG_PUSH([C])dnl
AC_CACHE_CHECK(
  [whether $CC understands -c and -o together],
  [am_cv_prog_cc_c_o],
  [AC_LANG_CONFTEST([AC_LANG_PROGRAM([])])
  # Make sure it works both with $CC and with simple cc.
  # Following AC_PROG_CC_C_O, we do the test twice because some
  # compilers refuse to overwrite an existing .o file with -o,
  # though they will create one.
  am_cv_prog_cc_c_o=yes
  for am_i in 1 2; do
    if AM_RUN_LOG([$CC -c conftest.$ac_ext -o conftest2.$ac_objext]) \
         && test -f conftest2.$ac_objext; then
      : OK
    else
      am_cv_prog_cc_c_o=no
      break
    fi
  done
  rm -f core conftest*
  unset am_i])
if test "$am_cv_prog_cc_c_o" != yes; then
   # Losing compiler, so override with the script.
   # FIXME: It is wrong to rewrite CC.
   # But if we don't then we get into trouble of one sort or another.
   # A longer-term fix would be to have automake use am__CC in this case,
   # and then we could set am__CC="\$(top_srcdir)/compile \$(CC)"
   CC="$am_aux_dir/compile $CC"
fi
AC_LANG_POP([C])])

# For backward compatibility.
AC_DEFUN_ONCE([AM_PROG_CC_C_O], [AC_REQUIRE([AC_PROG_CC])])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_RUN_LOG(COMMAND)
# -------------------
# Run COMMAND, save the exit status in ac_status, and log it.
# (This has been adapted from Autoconf's _AC_RUN_LOG macro.)
AC_DEFUN([AM_RUN_LOG],
[{ echo "$as_me:$LINENO: $1" >&AS_MESSAGE_LOG_FD
   ($1) >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&AS_MESSAGE_LOG_FD
   (exit $ac_status); }])

# Check to make sure that the build environment is sane.    -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Reject unsafe characters in $srcdir or the absolute working directory
# name.  Accept space and tab only in the latter.
am_lf='
'
case `pwd` in
  *[[\\\"\#\$\&\'\`$am_lf]]*)
    AC_MSG_ERROR([unsafe absolute working directory name]);;
esac
case $srcdir in
  *[[\\\"\#\$\&\'\`$am_lf\ \	]]*)
    AC_MSG_ERROR([unsafe srcdir value: '$srcdir']);;
esac

AC_MSG_RESULT([yes])
])

# Copyright (C) 2009-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SILENT_RULES([DEFAULT])
# --------------------------
# Enable less verbose build rules; with the default set to DEFAULT
# ("yes" being less verbose, "no" or empty being verbose).
AC_DEFUN([AM_SILENT_RULES],
[AC_ARG_ENABLE([silent-rules], [dnl
AS_HELP_STRING(
  [--enable-silent-rules],
  [less verbose build output (undo: "make V=1")])
AS_HELP_STRING(
  [--disable-silent-rules],
  [verbose build output (undo: "make V=0")])dnl
])
case $enable_silent_rules in @%:@ (((
  yes) AM_DEFAULT_VERBOSITY=0;;
   no) AM_DEFAULT_VERBOSITY=1;;
    *) AM_DEFAULT_VERBOSITY=m4_if([$1], [yes], [0], [1]);;
esac
dnl
dnl A few 'make' implementations (e.g., NonStop OS and NextStep)
dnl do not support nested variable expansions.
dnl See automake bug#9928 and bug#10237.
am_make=${MAKE-make}
AC_CACHE_CHECK([whether $am_make supports nested variables],
   [am_cv_make_support_nested_variables],
   [if AS_ECHO([['TRUE=$(BAR$(V))
BAR0=false
BAR1=true
V=1
am__doit:
	@$(TRUE)
.PHONY: am__doit']]) | $am_make -f - >/dev/null 2>&1; then
  am_cv_make_support_nested_variables=yes
else
  am_cv_make_support_nested_variables=no
fi])
if test $am_cv_make_support_nested_variables = yes; then
  dnl Using '$V' instead of '$(V)' breaks IRIX make.
  AM_V='$(V)'
  AM_DEFAULT_V='$(AM_DEFAULT_VERBOSITY)'
else
  AM_V=$AM_DEFAULT_VERBOSITY
  AM_DEFAULT_V=$AM_DEFAULT_VERBOSITY
fi
AC_SUBST([AM_V])dnl
AM_SUBST_NOTMAKE([AM_V])dnl
AC_SUBST([AM_DEFAULT_V])dnl
AM_SUBST_NOTMAKE([AM_DEFAULT_V])dnl
AC_SUBST([AM_DEFAULT_VERBOSITY])dnl
AM_BACKSLASH='\'
AC_SUBST([AM_BACKSLASH])dnl
_AM_SUBST_NOTMAKE([AM_BACKSLASH])dnl
])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_STRIP
# ---------------------
# One issue with vendor 'install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in "make install-strip", and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using 'strip' when the user
# run "make install-strip".  However 'strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the 'STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be 'maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# Copyright (C) 2006-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Prevent Automake from outputting VARIABLE = @VARIABLE@ in Makefile.in.
# This macro is traced by Automake.
AC_DEFUN([_AM_SUBST_NOTMAKE])

# AM_SUBST_NOTMAKE(VARIABLE)
# --------------------------
# Public sister of _AM_SUBST_NOTMAKE.
AC_DEFUN([AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE($@)])

# Check how to create a tarball.                            -*- Autoconf -*-

# Copyright (C) 2004-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of 'v7', 'ustar', or 'pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
#
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.  Yes, it's still used
# in the wild :-(  We should find a proper way to deprecate it ...
AC_SUBST([AMTAR], ['$${TAR-tar}'])

# We'll loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'

m4_if([$1], [v7],
  [am__tar='$${TAR-tar} chof - "$$tardir"' am__untar='$${TAR-tar} xf -'],

  [m4_case([$1],
    [ustar],
     [# The POSIX 1988 'ustar' format is defined with fixed-size fields.
      # There is notably a 21 bits limit for the UID and the GID.  In fact,
      # the 'pax' utility can hang on bigger UID/GID (see automake bug#8343
      # and bug#13588).
      am_max_uid=2097151 # 2^21 - 1
      am_max_gid=$am_max_uid
      # The $UID and $GID variables are not portable, so we need to resort
      # to the POSIX-mandated id(1) utility.  Errors in the 'id' calls
      # below are definitely unexpected, so allow the users to see them
      # (that is, avoid stderr redirection).
      am_uid=`id -u || echo unknown`
      am_gid=`id -g || echo unknown`
      AC_MSG_CHECKING([whether UID '$am_uid' is supported by ustar format])
      if test $am_uid -le $am_max_uid; then
         AC_MSG_RESULT([yes])
      else
         AC_MSG_RESULT([no])
         _am_tools=none
      fi
      AC_MSG_CHECKING([whether GID '$am_gid' is supported by ustar format])
      if test $am_gid -le $am_max_gid; then
         AC_MSG_RESULT([yes])
      else
        AC_MSG_RESULT([no])
        _am_tools=none
      fi],

  [pax],
    [],

  [m4_fatal([Unknown tar format])])

  AC_MSG_CHECKING([how to create a $1 tar archive])

  # Go ahead even if we have the value already cached.  We do so because we
  # need to set the values for the 'am__tar' and 'am__untar' variables.
  _am_tools=${am_cv_prog_tar_$1-$_am_tools}

  for _am_tool in $_am_tools; do
    case $_am_tool in
    gnutar)
      for _am_tar in tar gnutar gtar; do
        AM_RUN_LOG([$_am_tar --version]) && break
      done
      am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
      am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
      am__untar="$_am_tar -xf -"
      ;;
    plaintar)
      # Must skip GNU tar: if it does not support --format= it doesn't create
      # ustar tarball either.
      (tar --version) >/dev/null 2>&1 && continue
      am__tar='tar chf - "$$tardir"'
      am__tar_='tar chf - "$tardir"'
      am__untar='tar xf -'
      ;;
    pax)
      am__tar='pax -L -x $1 -w "$$tardir"'
      am__tar_='pax -L -x $1 -w "$tardir"'
      am__untar='pax -r'
      ;;
    cpio)
      am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
      am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
      am__untar='cpio -i -H $1 -d'
      ;;
    none)
      am__tar=false
      am__tar_=false
      am__untar=false
      ;;
    esac

    # If the value was cached, stop now.  We just wanted to have am__tar
    # and am__untar set.
    test -n "${am_cv_prog_tar_$1}" && break

    # tar/untar a dummy directory, and stop if the command works.
    rm -rf conftest.dir
    mkdir conftest.dir
    echo GrepMe > conftest.dir/file
    AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
    rm -rf conftest.dir
    if test -s conftest.tar; then
      AM_RUN_LOG([$am__untar <conftest.tar])
      AM_RUN_LOG([cat conftest.dir/file])
      grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
    fi
  done
  rm -rf conftest.dir

  AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
  AC_MSG_RESULT([$am_cv_prog_tar_$1])])

AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR

# 00gnulib.m4 serial 3
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl This file must be named something that sorts before all other
dnl gnulib-provided .m4 files.  It is needed until such time as we can
dnl assume Autoconf 2.64, with its improved AC_DEFUN_ONCE and
dnl m4_divert semantics.

# Until autoconf 2.63, handling of the diversion stack required m4_init
# to be called first; but this does not happen with aclocal.  Wrapping
# the entire execution in another layer of the diversion stack fixes this.
# Worse, prior to autoconf 2.62, m4_wrap depended on the underlying m4
# for whether it was FIFO or LIFO; in order to properly balance with
# m4_init, we need to undo our push just before anything wrapped within
# the m4_init body.  The way to ensure this is to wrap both sides of
# m4_init with a one-shot macro that does the pop at the right time.
m4_ifndef([_m4_divert_diversion],
[m4_divert_push([KILL])
m4_define([gl_divert_fixup], [m4_divert_pop()m4_define([$0])])
m4_define([m4_init],
  [gl_divert_fixup()]m4_defn([m4_init])[gl_divert_fixup()])])


# AC_DEFUN_ONCE([NAME], VALUE)
# ----------------------------
# Define NAME to expand to VALUE on the first use (whether by direct
# expansion, or by AC_REQUIRE), and to nothing on all subsequent uses.
# Avoid bugs in AC_REQUIRE in Autoconf 2.63 and earlier.  This
# definition is slower than the version in Autoconf 2.64, because it
# can only use interfaces that existed since 2.59; but it achieves the
# same effect.  Quoting is necessary to avoid confusing Automake.
m4_version_prereq([2.63.263], [],
[m4_define([AC][_DEFUN_ONCE],
  [AC][_DEFUN([$1],
    [AC_REQUIRE([_gl_DEFUN_ONCE([$1])],
      [m4_indir([_gl_DEFUN_ONCE([$1])])])])]dnl
[AC][_DEFUN([_gl_DEFUN_ONCE([$1])], [$2])])])

# gl_00GNULIB
# -----------
# Witness macro that this file has been included.  Needed to force
# Automake to include this file prior to all other gnulib .m4 files.
AC_DEFUN([gl_00GNULIB])

# absolute-header.m4 serial 16
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Derek Price.

# gl_ABSOLUTE_HEADER(HEADER1 HEADER2 ...)
# ---------------------------------------
# Find the absolute name of a header file, testing first if the header exists.
# If the header were sys/inttypes.h, this macro would define
# ABSOLUTE_SYS_INTTYPES_H to the '""' quoted absolute name of sys/inttypes.h
# in config.h
# (e.g. '#define ABSOLUTE_SYS_INTTYPES_H "///usr/include/sys/inttypes.h"').
# The three "///" are to pacify Sun C 5.8, which otherwise would say
# "warning: #include of /usr/include/... may be non-portable".
# Use '""', not '<>', so that the /// cannot be confused with a C99 comment.
# Note: This macro assumes that the header file is not empty after
# preprocessing, i.e. it does not only define preprocessor macros but also
# provides some type/enum definitions or function/variable declarations.
AC_DEFUN([gl_ABSOLUTE_HEADER],
[AC_REQUIRE([AC_CANONICAL_HOST])
AC_LANG_PREPROC_REQUIRE()dnl
dnl FIXME: gl_absolute_header and ac_header_exists must be used unquoted
dnl until we can assume autoconf 2.64 or newer.
m4_foreach_w([gl_HEADER_NAME], [$1],
  [AS_VAR_PUSHDEF([gl_absolute_header],
                  [gl_cv_absolute_]m4_defn([gl_HEADER_NAME]))dnl
  AC_CACHE_CHECK([absolute name of <]m4_defn([gl_HEADER_NAME])[>],
    m4_defn([gl_absolute_header]),
    [AS_VAR_PUSHDEF([ac_header_exists],
                    [ac_cv_header_]m4_defn([gl_HEADER_NAME]))dnl
    AC_CHECK_HEADERS_ONCE(m4_defn([gl_HEADER_NAME]))dnl
    if test AS_VAR_GET(ac_header_exists) = yes; then
      gl_ABSOLUTE_HEADER_ONE(m4_defn([gl_HEADER_NAME]))
    fi
    AS_VAR_POPDEF([ac_header_exists])dnl
    ])dnl
  AC_DEFINE_UNQUOTED(AS_TR_CPP([ABSOLUTE_]m4_defn([gl_HEADER_NAME])),
                     ["AS_VAR_GET(gl_absolute_header)"],
                     [Define this to an absolute name of <]m4_defn([gl_HEADER_NAME])[>.])
  AS_VAR_POPDEF([gl_absolute_header])dnl
])dnl
])# gl_ABSOLUTE_HEADER

# gl_ABSOLUTE_HEADER_ONE(HEADER)
# ------------------------------
# Like gl_ABSOLUTE_HEADER, except that:
#   - it assumes that the header exists,
#   - it uses the current CPPFLAGS,
#   - it does not cache the result,
#   - it is silent.
AC_DEFUN([gl_ABSOLUTE_HEADER_ONE],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_LANG_CONFTEST([AC_LANG_SOURCE([[#include <]]m4_dquote([$1])[[>]])])
  dnl AIX "xlc -E" and "cc -E" omit #line directives for header files
  dnl that contain only a #include of other header files and no
  dnl non-comment tokens of their own. This leads to a failure to
  dnl detect the absolute name of <dirent.h>, <signal.h>, <poll.h>
  dnl and others. The workaround is to force preservation of comments
  dnl through option -C. This ensures all necessary #line directives
  dnl are present. GCC supports option -C as well.
  case "$host_os" in
    aix*) gl_absname_cpp="$ac_cpp -C" ;;
    *)    gl_absname_cpp="$ac_cpp" ;;
  esac
changequote(,)
  case "$host_os" in
    mingw*)
      dnl For the sake of native Windows compilers (excluding gcc),
      dnl treat backslash as a directory separator, like /.
      dnl Actually, these compilers use a double-backslash as
      dnl directory separator, inside the
      dnl   # line "filename"
      dnl directives.
      gl_dirsep_regex='[/\\]'
      ;;
    *)
      gl_dirsep_regex='\/'
      ;;
  esac
  dnl A sed expression that turns a string into a basic regular
  dnl expression, for use within "/.../".
  gl_make_literal_regex_sed='s,[]$^\\.*/[],\\&,g'
  gl_header_literal_regex=`echo '$1' \
                           | sed -e "$gl_make_literal_regex_sed"`
  gl_absolute_header_sed="/${gl_dirsep_regex}${gl_header_literal_regex}/"'{
      s/.*"\(.*'"${gl_dirsep_regex}${gl_header_literal_regex}"'\)".*/\1/
      s|^/[^/]|//&|
      p
      q
    }'
changequote([,])
  dnl eval is necessary to expand gl_absname_cpp.
  dnl Ultrix and Pyramid sh refuse to redirect output of eval,
  dnl so use subshell.
  AS_VAR_SET([gl_cv_absolute_]AS_TR_SH([[$1]]),
[`(eval "$gl_absname_cpp conftest.$ac_ext") 2>&AS_MESSAGE_LOG_FD |
  sed -n "$gl_absolute_header_sed"`])
])

# alloca.m4 serial 14
dnl Copyright (C) 2002-2004, 2006-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_ALLOCA],
[
  AC_REQUIRE([AC_FUNC_ALLOCA])
  if test $ac_cv_func_alloca_works = no; then
    gl_PREREQ_ALLOCA
  fi

  # Define an additional variable used in the Makefile substitution.
  if test $ac_cv_working_alloca_h = yes; then
    AC_CACHE_CHECK([for alloca as a compiler built-in], [gl_cv_rpl_alloca], [
      AC_EGREP_CPP([Need own alloca], [
#if defined __GNUC__ || defined _AIX || defined _MSC_VER
        Need own alloca
#endif
        ], [gl_cv_rpl_alloca=yes], [gl_cv_rpl_alloca=no])
    ])
    if test $gl_cv_rpl_alloca = yes; then
      dnl OK, alloca can be implemented through a compiler built-in.
      AC_DEFINE([HAVE_ALLOCA], [1],
        [Define to 1 if you have 'alloca' after including <alloca.h>,
         a header that may be supplied by this distribution.])
      ALLOCA_H=alloca.h
    else
      dnl alloca exists as a library function, i.e. it is slow and probably
      dnl a memory leak. Don't define HAVE_ALLOCA in this case.
      ALLOCA_H=
    fi
  else
    ALLOCA_H=alloca.h
  fi
  AC_SUBST([ALLOCA_H])
  AM_CONDITIONAL([GL_GENERATE_ALLOCA_H], [test -n "$ALLOCA_H"])
])

# Prerequisites of lib/alloca.c.
# STACK_DIRECTION is already handled by AC_FUNC_ALLOCA.
AC_DEFUN([gl_PREREQ_ALLOCA], [:])

# This works around a bug in autoconf <= 2.68.
# See <https://lists.gnu.org/r/bug-gnulib/2011-06/msg00277.html>.

m4_version_prereq([2.69], [] ,[

# This is taken from the following Autoconf patch:
# https://git.savannah.gnu.org/gitweb/?p=autoconf.git;a=commitdiff;h=6cd9f12520b0d6f76d3230d7565feba1ecf29497

# _AC_LIBOBJ_ALLOCA
# -----------------
# Set up the LIBOBJ replacement of 'alloca'.  Well, not exactly
# AC_LIBOBJ since we actually set the output variable 'ALLOCA'.
# Nevertheless, for Automake, AC_LIBSOURCES it.
m4_define([_AC_LIBOBJ_ALLOCA],
[# The SVR3 libPW and SVR4 libucb both contain incompatible functions
# that cause trouble.  Some versions do not even contain alloca or
# contain a buggy version.  If you still want to use their alloca,
# use ar to extract alloca.o from them instead of compiling alloca.c.
AC_LIBSOURCES(alloca.c)
AC_SUBST([ALLOCA], [\${LIBOBJDIR}alloca.$ac_objext])dnl
AC_DEFINE(C_ALLOCA, 1, [Define to 1 if using 'alloca.c'.])

AC_CACHE_CHECK(whether 'alloca.c' needs Cray hooks, ac_cv_os_cray,
[AC_EGREP_CPP(webecray,
[#if defined CRAY && ! defined CRAY2
webecray
#else
wenotbecray
#endif
], ac_cv_os_cray=yes, ac_cv_os_cray=no)])
if test $ac_cv_os_cray = yes; then
  for ac_func in _getb67 GETB67 getb67; do
    AC_CHECK_FUNC($ac_func,
                  [AC_DEFINE_UNQUOTED(CRAY_STACKSEG_END, $ac_func,
                                      [Define to one of '_getb67', 'GETB67',
                                       'getb67' for Cray-2 and Cray-YMP
                                       systems. This function is required for
                                       'alloca.c' support on those systems.])
    break])
  done
fi

AC_CACHE_CHECK([stack direction for C alloca],
               [ac_cv_c_stack_direction],
[AC_RUN_IFELSE([AC_LANG_SOURCE(
[AC_INCLUDES_DEFAULT
int
find_stack_direction (int *addr, int depth)
{
  int dir, dummy = 0;
  if (! addr)
    addr = &dummy;
  *addr = addr < &dummy ? 1 : addr == &dummy ? 0 : -1;
  dir = depth ? find_stack_direction (addr, depth - 1) : 0;
  return dir + dummy;
}

int
main (int argc, char **argv)
{
  return find_stack_direction (0, argc + !argv + 20) < 0;
}])],
               [ac_cv_c_stack_direction=1],
               [ac_cv_c_stack_direction=-1],
               [ac_cv_c_stack_direction=0])])
AH_VERBATIM([STACK_DIRECTION],
[/* If using the C implementation of alloca, define if you know the
   direction of stack growth for your system; otherwise it will be
   automatically deduced at runtime.
        STACK_DIRECTION > 0 => grows toward higher addresses
        STACK_DIRECTION < 0 => grows toward lower addresses
        STACK_DIRECTION = 0 => direction of growth unknown */
@%:@undef STACK_DIRECTION])dnl
AC_DEFINE_UNQUOTED(STACK_DIRECTION, $ac_cv_c_stack_direction)
])# _AC_LIBOBJ_ALLOCA
])

# backupfile.m4 serial 14
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Prerequisites of lib/backupfile.c.
AC_DEFUN([gl_BACKUPFILE],
[
  AC_REQUIRE([gl_CHECK_TYPE_STRUCT_DIRENT_D_INO])
  AC_REQUIRE([AC_SYS_LONG_FILE_NAMES])
  AC_CHECK_FUNCS_ONCE([pathconf])
])

# serial 7

# Copyright (C) 2002, 2005, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_BISON],
[
  # parse-datetime.y works with bison only.
  : ${YACC='bison -y'}
dnl
dnl Declaring YACC & YFLAGS precious will not be necessary after GNULIB
dnl requires an Autoconf greater than 2.59c, but it will probably still be
dnl useful to override the description of YACC in the --help output, re
dnl parse-datetime.y assuming 'bison -y'.
  AC_ARG_VAR([YACC],
[The "Yet Another C Compiler" implementation to use.  Defaults to 'bison -y'.
Values other than 'bison -y' will most likely break on most systems.])dnl
  AC_ARG_VAR([YFLAGS],
[YFLAGS contains the list arguments that will be passed by default to Bison.
This script will default YFLAGS to the empty string to avoid a default value of
'-d' given by some make applications.])dnl
])

# canonicalize.m4 serial 29

dnl Copyright (C) 2003-2007, 2009-2018 Free Software Foundation, Inc.

dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Provides canonicalize_file_name and canonicalize_filename_mode, but does
# not provide or fix realpath.
AC_DEFUN([gl_FUNC_CANONICALIZE_FILENAME_MODE],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([canonicalize_file_name])
  AC_REQUIRE([gl_DOUBLE_SLASH_ROOT])
  AC_REQUIRE([gl_FUNC_REALPATH_WORKS])
  if test $ac_cv_func_canonicalize_file_name = no; then
    HAVE_CANONICALIZE_FILE_NAME=0
  else
    case "$gl_cv_func_realpath_works" in
      *yes) ;;
      *)    REPLACE_CANONICALIZE_FILE_NAME=1 ;;
    esac
  fi
])

# Provides canonicalize_file_name and realpath.
AC_DEFUN([gl_CANONICALIZE_LGPL],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  AC_REQUIRE([gl_CANONICALIZE_LGPL_SEPARATE])
  if test $ac_cv_func_canonicalize_file_name = no; then
    HAVE_CANONICALIZE_FILE_NAME=0
    if test $ac_cv_func_realpath = no; then
      HAVE_REALPATH=0
    else
      case "$gl_cv_func_realpath_works" in
	*yes) ;;
	*)    REPLACE_REALPATH=1 ;;
      esac
    fi
  else
    case "$gl_cv_func_realpath_works" in
      *yes)
        ;;
      *)
        REPLACE_CANONICALIZE_FILE_NAME=1
        REPLACE_REALPATH=1
        ;;
    esac
  fi
])

# Like gl_CANONICALIZE_LGPL, except prepare for separate compilation
# (no REPLACE_CANONICALIZE_FILE_NAME, no REPLACE_REALPATH, no AC_LIBOBJ).
AC_DEFUN([gl_CANONICALIZE_LGPL_SEPARATE],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([canonicalize_file_name getcwd readlink])
  AC_REQUIRE([gl_DOUBLE_SLASH_ROOT])
  AC_REQUIRE([gl_FUNC_REALPATH_WORKS])
  AC_CHECK_HEADERS_ONCE([sys/param.h])
])

# Check whether realpath works.  Assume that if a platform has both
# realpath and canonicalize_file_name, but the former is broken, then
# so is the latter.
AC_DEFUN([gl_FUNC_REALPATH_WORKS],
[
  AC_CHECK_FUNCS_ONCE([realpath])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether realpath works], [gl_cv_func_realpath_works], [
    touch conftest.a
    mkdir conftest.d
    AC_RUN_IFELSE([
      AC_LANG_PROGRAM([[
        ]GL_NOCRASH[
        #include <stdlib.h>
        #include <string.h>
      ]], [[
        int result = 0;
        {
          char *name = realpath ("conftest.a", NULL);
          if (!(name && *name == '/'))
            result |= 1;
          free (name);
        }
        {
          char *name = realpath ("conftest.b/../conftest.a", NULL);
          if (name != NULL)
            result |= 2;
          free (name);
        }
        {
          char *name = realpath ("conftest.a/", NULL);
          if (name != NULL)
            result |= 4;
          free (name);
        }
        {
          char *name1 = realpath (".", NULL);
          char *name2 = realpath ("conftest.d//./..", NULL);
          if (! name1 || ! name2 || strcmp (name1, name2))
            result |= 8;
          free (name1);
          free (name2);
        }
        return result;
      ]])
     ],
     [gl_cv_func_realpath_works=yes],
     [gl_cv_func_realpath_works=no],
     [case "$host_os" in
                       # Guess yes on glibc systems.
        *-gnu* | gnu*) gl_cv_func_realpath_works="guessing yes" ;;
                       # Guess no on native Windows.
        mingw*)        gl_cv_func_realpath_works="guessing no" ;;
                       # If we don't know, assume the worst.
        *)             gl_cv_func_realpath_works="guessing no" ;;
      esac
     ])
    rm -rf conftest.a conftest.d
  ])
  case "$gl_cv_func_realpath_works" in
    *yes)
      AC_DEFINE([FUNC_REALPATH_WORKS], [1], [Define to 1 if realpath()
        can malloc memory, always gives an absolute path, and handles
        trailing slash correctly.])
      ;;
  esac
])

#serial 16

# Use Gnulib's robust chdir function.
# It can handle arbitrarily long directory names, which means
# that when it is given the name of an existing directory, it
# never fails with ENAMETOOLONG.
# Arrange to compile chdir-long.c only on systems that define PATH_MAX.

dnl Copyright (C) 2004-2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

AC_DEFUN([gl_FUNC_CHDIR_LONG],
[
  AC_REQUIRE([gl_PATHMAX_SNIPPET_PREREQ])
  AC_CACHE_CHECK([whether this system has an arbitrary file name length limit],
    [gl_cv_have_arbitrary_file_name_length_limit],
    [AC_EGREP_CPP([have_arbitrary_file_name_length_limit],
                  gl_PATHMAX_SNIPPET[
#ifdef PATH_MAX
have_arbitrary_file_name_length_limit
#endif],
    [gl_cv_have_arbitrary_file_name_length_limit=yes],
    [gl_cv_have_arbitrary_file_name_length_limit=no])])
])

AC_DEFUN([gl_PREREQ_CHDIR_LONG], [:])

# serial 29
# Determine whether we need the chown wrapper.

dnl Copyright (C) 1997-2001, 2003-2005, 2007, 2009-2018 Free Software
dnl Foundation, Inc.

dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# chown should accept arguments of -1 for uid and gid, and it should
# dereference symlinks.  If it doesn't, arrange to use the replacement
# function.

# From Jim Meyering.

# This is taken from the following Autoconf patch:
# https://git.savannah.gnu.org/gitweb/?p=autoconf.git;a=commitdiff;h=7fbb553727ed7e0e689a17594b58559ecf3ea6e9
AC_DEFUN([AC_FUNC_CHOWN],
[
  AC_REQUIRE([AC_TYPE_UID_T])dnl
  AC_REQUIRE([AC_CANONICAL_HOST])dnl for cross-compiles
  AC_CHECK_HEADERS([unistd.h])
  AC_CACHE_CHECK([for working chown],
    [ac_cv_func_chown_works],
    [AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [AC_INCLUDES_DEFAULT
           [#include <fcntl.h>
          ]],
          [[
            char *f = "conftest.chown";
            struct stat before, after;

            if (creat (f, 0600) < 0)
              return 1;
            if (stat (f, &before) < 0)
              return 1;
            if (chown (f, (uid_t) -1, (gid_t) -1) == -1)
              return 1;
            if (stat (f, &after) < 0)
              return 1;
            return ! (before.st_uid == after.st_uid && before.st_gid == after.st_gid);
          ]])
       ],
       [ac_cv_func_chown_works=yes],
       [ac_cv_func_chown_works=no],
       [case "$host_os" in # ((
                         # Guess yes on glibc systems.
          *-gnu* | gnu*) ac_cv_func_chown_works="guessing yes" ;;
                         # Guess no on native Windows.
          mingw*)        ac_cv_func_chown_works="guessing no" ;;
                         # If we don't know, assume the worst.
          *)             ac_cv_func_chown_works="guessing no" ;;
        esac
       ])
     rm -f conftest.chown
    ])
  case "$ac_cv_func_chown_works" in
    *yes)
      AC_DEFINE([HAVE_CHOWN], [1],
        [Define to 1 if your system has a working `chown' function.])
      ;;
  esac
])# AC_FUNC_CHOWN

AC_DEFUN_ONCE([gl_FUNC_CHOWN],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_TYPE_UID_T])
  AC_REQUIRE([AC_FUNC_CHOWN])
  AC_REQUIRE([gl_FUNC_CHOWN_FOLLOWS_SYMLINK])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_FUNCS_ONCE([chown fchown])

  dnl mingw lacks chown altogether.
  if test $ac_cv_func_chown = no; then
    HAVE_CHOWN=0
  else
    dnl Some old systems treated chown like lchown.
    if test $gl_cv_func_chown_follows_symlink = no; then
      REPLACE_CHOWN=1
    fi

    dnl Some old systems tried to use uid/gid -1 literally.
    case "$ac_cv_func_chown_works" in
      *no)
        AC_DEFINE([CHOWN_FAILS_TO_HONOR_ID_OF_NEGATIVE_ONE], [1],
          [Define if chown is not POSIX compliant regarding IDs of -1.])
        REPLACE_CHOWN=1
        ;;
    esac

    dnl Solaris 9 ignores trailing slash.
    dnl FreeBSD 7.2 mishandles trailing slash on symlinks.
    dnl Likewise for AIX 7.1.
    AC_CACHE_CHECK([whether chown honors trailing slash],
      [gl_cv_func_chown_slash_works],
      [touch conftest.file && rm -f conftest.link
       AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
]], [[    if (symlink ("conftest.file", "conftest.link")) return 1;
          if (chown ("conftest.link/", getuid (), getgid ()) == 0) return 2;
        ]])],
        [gl_cv_func_chown_slash_works=yes],
        [gl_cv_func_chown_slash_works=no],
        [case "$host_os" in
                   # Guess yes on glibc systems.
           *-gnu*) gl_cv_func_chown_slash_works="guessing yes" ;;
                   # If we don't know, assume the worst.
           *)      gl_cv_func_chown_slash_works="guessing no" ;;
         esac
        ])
      rm -f conftest.link conftest.file])
    case "$gl_cv_func_chown_slash_works" in
      *yes) ;;
      *)
        AC_DEFINE([CHOWN_TRAILING_SLASH_BUG], [1],
          [Define to 1 if chown mishandles trailing slash.])
        REPLACE_CHOWN=1
        ;;
    esac

    dnl OpenBSD fails to update ctime if ownership does not change.
    AC_CACHE_CHECK([whether chown always updates ctime],
      [gl_cv_func_chown_ctime_works],
      [AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
]], [[    struct stat st1, st2;
          if (close (creat ("conftest.file", 0600))) return 1;
          if (stat ("conftest.file", &st1)) return 2;
          sleep (1);
          if (chown ("conftest.file", st1.st_uid, st1.st_gid)) return 3;
          if (stat ("conftest.file", &st2)) return 4;
          if (st2.st_ctime <= st1.st_ctime) return 5;
        ]])],
        [gl_cv_func_chown_ctime_works=yes],
        [gl_cv_func_chown_ctime_works=no],
        [case "$host_os" in
                   # Guess yes on glibc systems.
           *-gnu*) gl_cv_func_chown_ctime_works="guessing yes" ;;
                   # If we don't know, assume the worst.
           *)      gl_cv_func_chown_ctime_works="guessing no" ;;
         esac
        ])
      rm -f conftest.file])
    case "$gl_cv_func_chown_ctime_works" in
      *yes) ;;
      *)
        AC_DEFINE([CHOWN_CHANGE_TIME_BUG], [1], [Define to 1 if chown fails
          to change ctime when at least one argument was not -1.])
        REPLACE_CHOWN=1
        ;;
    esac
  fi
])

# Determine whether chown follows symlinks (it should).
AC_DEFUN_ONCE([gl_FUNC_CHOWN_FOLLOWS_SYMLINK],
[
  AC_CACHE_CHECK(
    [whether chown dereferences symlinks],
    [gl_cv_func_chown_follows_symlink],
    [
      AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

        int
        main ()
        {
          int result = 0;
          char const *dangling_symlink = "conftest.dangle";

          unlink (dangling_symlink);
          if (symlink ("conftest.no-such", dangling_symlink))
            abort ();

          /* Exit successfully on a conforming system,
             i.e., where chown must fail with ENOENT.  */
          if (chown (dangling_symlink, getuid (), getgid ()) == 0)
            result |= 1;
          if (errno != ENOENT)
            result |= 2;
          return result;
        }
        ]])],
        [gl_cv_func_chown_follows_symlink=yes],
        [gl_cv_func_chown_follows_symlink=no],
        [gl_cv_func_chown_follows_symlink=yes]
      )
    ]
  )

  if test $gl_cv_func_chown_follows_symlink = no; then
    AC_DEFINE([CHOWN_MODIFIES_SYMLINK], [1],
      [Define if chown modifies symlinks.])
  fi
])

# clock_time.m4 serial 10
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Check for clock_gettime and clock_settime, and set LIB_CLOCK_GETTIME.
# For a program named, say foo, you should add a line like the following
# in the corresponding Makefile.am file:
# foo_LDADD = $(LDADD) $(LIB_CLOCK_GETTIME)

AC_DEFUN([gl_CLOCK_TIME],
[
  dnl Persuade glibc and Solaris <time.h> to declare these functions.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  # Solaris 2.5.1 needs -lposix4 to get the clock_gettime function.
  # Solaris 7 prefers the library name -lrt to the obsolescent name -lposix4.

  # Save and restore LIBS so e.g., -lrt, isn't added to it.  Otherwise, *all*
  # programs in the package would end up linked with that potentially-shared
  # library, inducing unnecessary run-time overhead.
  LIB_CLOCK_GETTIME=
  AC_SUBST([LIB_CLOCK_GETTIME])
  gl_saved_libs=$LIBS
    AC_SEARCH_LIBS([clock_gettime], [rt posix4],
                   [test "$ac_cv_search_clock_gettime" = "none required" ||
                    LIB_CLOCK_GETTIME=$ac_cv_search_clock_gettime])
    AC_CHECK_FUNCS([clock_gettime clock_settime])
  LIBS=$gl_saved_libs
])

# close.m4 serial 9
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_CLOSE],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  m4_ifdef([gl_MSVC_INVAL], [
    AC_REQUIRE([gl_MSVC_INVAL])
    if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
      REPLACE_CLOSE=1
    fi
  ])
  m4_ifdef([gl_PREREQ_SYS_H_WINSOCK2], [
    gl_PREREQ_SYS_H_WINSOCK2
    if test $UNISTD_H_HAVE_WINSOCK2_H = 1; then
      dnl Even if the 'socket' module is not used here, another part of the
      dnl application may use it and pass file descriptors that refer to
      dnl sockets to the close() function. So enable the support for sockets.
      REPLACE_CLOSE=1
    fi
  ])
  dnl Replace close() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    if test $REPLACE_CLOSE = 0; then
      gl_TEST_FCHDIR
      if test $HAVE_FCHDIR = 0; then
        REPLACE_CLOSE=1
      fi
    fi
  ])
])

# closedir.m4 serial 6
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_CLOSEDIR],
[
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_CHECK_FUNCS([closedir])
  if test $ac_cv_func_closedir = no; then
    HAVE_CLOSEDIR=0
  fi
  dnl Replace closedir() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    gl_TEST_FCHDIR
    if test $HAVE_FCHDIR = 0; then
      if test $HAVE_CLOSEDIR = 1; then
        REPLACE_CLOSEDIR=1
      fi
    fi
  ])
  dnl Replace closedir() for supporting the gnulib-defined dirfd() function.
  case $host_os,$HAVE_CLOSEDIR in
    os2*,1)
      REPLACE_CLOSEDIR=1;;
  esac
])

# codeset.m4 serial 5 (gettext-0.18.2)
dnl Copyright (C) 2000-2002, 2006, 2008-2014, 2016 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_DEFUN([AM_LANGINFO_CODESET],
[
  AC_CACHE_CHECK([for nl_langinfo and CODESET], [am_cv_langinfo_codeset],
    [AC_LINK_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <langinfo.h>]],
          [[char* cs = nl_langinfo(CODESET); return !cs;]])],
       [am_cv_langinfo_codeset=yes],
       [am_cv_langinfo_codeset=no])
    ])
  if test $am_cv_langinfo_codeset = yes; then
    AC_DEFINE([HAVE_LANGINFO_CODESET], [1],
      [Define if you have <langinfo.h> and nl_langinfo(CODESET).])
  fi
])

# configmake.m4 serial 2
dnl Copyright (C) 2010-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# gl_CONFIGMAKE_PREP
# ------------------
# Guarantee all of the standard directory variables, even when used with
# autoconf 2.59 (datarootdir wasn't supported until 2.59c, and runstatedir
# in 2.70) or automake 1.9.6 (pkglibexecdir wasn't supported until 1.10b,
# and runstatedir in 1.14.1).
AC_DEFUN([gl_CONFIGMAKE_PREP],
[
  dnl Technically, datadir should default to datarootdir.  But if
  dnl autoconf is too old to provide datarootdir, then reversing the
  dnl definition is a reasonable compromise.  Only AC_SUBST a variable
  dnl if it was not already defined earlier by autoconf.
  if test "x$datarootdir" = x; then
    AC_SUBST([datarootdir], ['${datadir}'])
  fi
  dnl Copy the approach used in autoconf 2.60.
  if test "x$docdir" = x; then
    AC_SUBST([docdir], [m4_ifset([AC_PACKAGE_TARNAME],
      ['${datarootdir}/doc/${PACKAGE_TARNAME}'],
      ['${datarootdir}/doc/${PACKAGE}'])])
  fi
  dnl The remaining variables missing from autoconf 2.59 are easier.
  if test "x$htmldir" = x; then
    AC_SUBST([htmldir], ['${docdir}'])
  fi
  if test "x$dvidir" = x; then
    AC_SUBST([dvidir], ['${docdir}'])
  fi
  if test "x$pdfdir" = x; then
    AC_SUBST([pdfdir], ['${docdir}'])
  fi
  if test "x$psdir" = x; then
    AC_SUBST([psdir], ['${docdir}'])
  fi
  if test "x$lispdir" = x; then
    AC_SUBST([lispdir], ['${datarootdir}/emacs/site-lisp'])
  fi
  if test "x$localedir" = x; then
    AC_SUBST([localedir], ['${datarootdir}/locale'])
  fi
  dnl Added in autoconf 2.70
  if test "x$runstatedir" = x; then
    AC_SUBST([runstatedir], ['${localstatedir}/run'])
  fi

  dnl Automake 1.9.6 only lacks pkglibexecdir; and since 1.11 merely
  dnl provides it without AC_SUBST, this blind use of AC_SUBST is safe.
  AC_SUBST([pkglibexecdir], ['${libexecdir}/${PACKAGE}'])
])

# serial 18

dnl From Jim Meyering.
dnl
dnl Check whether struct dirent has a member named d_ino.
dnl

# Copyright (C) 1997, 1999-2001, 2003-2004, 2006-2007, 2009-2018 Free Software
# Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_CHECK_TYPE_STRUCT_DIRENT_D_INO],
  [AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
   AC_CACHE_CHECK([for d_ino member in directory struct],
                  [gl_cv_struct_dirent_d_ino],
     [AC_RUN_IFELSE(
        [AC_LANG_PROGRAM(
           [[#include <sys/types.h>
             #include <sys/stat.h>
             #include <dirent.h>
           ]],
           [[DIR *dp = opendir (".");
             struct dirent *e;
             struct stat st;
             if (! dp)
               return 1;
             e = readdir (dp);
             if (! e)
               { closedir (dp); return 2; }
             if (lstat (e->d_name, &st) != 0)
               { closedir (dp); return 3; }
             if (e->d_ino != st.st_ino)
               { closedir (dp); return 4; }
             closedir (dp);
             return 0;
           ]])],
           [gl_cv_struct_dirent_d_ino=yes],
           [gl_cv_struct_dirent_d_ino=no],
           [case "$host_os" in
                           # Guess yes on glibc systems with Linux kernel.
              linux*-gnu*) gl_cv_struct_dirent_d_ino="guessing yes" ;;
                           # Guess no on native Windows.
              mingw*)      gl_cv_struct_dirent_d_ino="guessing no" ;;
                           # If we don't know, assume the worst.
              *)           gl_cv_struct_dirent_d_ino="guessing no" ;;
            esac
           ])])
   case "$gl_cv_struct_dirent_d_ino" in
     *yes)
       AC_DEFINE([D_INO_IN_DIRENT], [1],
         [Define if struct dirent has a member d_ino that actually works.])
       ;;
   esac
  ]
)

#serial 2
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_DIRENT_SAFER],
[
  AC_CHECK_FUNCS_ONCE([fdopendir])
])

# dirent_h.m4 serial 16
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Bruno Haible.

AC_DEFUN([gl_DIRENT_H],
[
  dnl Use AC_REQUIRE here, so that the default behavior below is expanded
  dnl once only, before all statements that occur in other macros.
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])

  dnl <dirent.h> is always overridden, because of GNULIB_POSIXCHECK.
  gl_CHECK_NEXT_HEADERS([dirent.h])
  if test $ac_cv_header_dirent_h = yes; then
    HAVE_DIRENT_H=1
  else
    HAVE_DIRENT_H=0
  fi
  AC_SUBST([HAVE_DIRENT_H])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[#include <dirent.h>
    ]], [alphasort closedir dirfd fdopendir opendir readdir rewinddir scandir])
])

AC_DEFUN([gl_DIRENT_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_DIRENT_H_DEFAULTS],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS]) dnl for REPLACE_FCHDIR
  GNULIB_OPENDIR=0;     AC_SUBST([GNULIB_OPENDIR])
  GNULIB_READDIR=0;     AC_SUBST([GNULIB_READDIR])
  GNULIB_REWINDDIR=0;   AC_SUBST([GNULIB_REWINDDIR])
  GNULIB_CLOSEDIR=0;    AC_SUBST([GNULIB_CLOSEDIR])
  GNULIB_DIRFD=0;       AC_SUBST([GNULIB_DIRFD])
  GNULIB_FDOPENDIR=0;   AC_SUBST([GNULIB_FDOPENDIR])
  GNULIB_SCANDIR=0;     AC_SUBST([GNULIB_SCANDIR])
  GNULIB_ALPHASORT=0;   AC_SUBST([GNULIB_ALPHASORT])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_OPENDIR=1;       AC_SUBST([HAVE_OPENDIR])
  HAVE_READDIR=1;       AC_SUBST([HAVE_READDIR])
  HAVE_REWINDDIR=1;     AC_SUBST([HAVE_REWINDDIR])
  HAVE_CLOSEDIR=1;      AC_SUBST([HAVE_CLOSEDIR])
  HAVE_DECL_DIRFD=1;    AC_SUBST([HAVE_DECL_DIRFD])
  HAVE_DECL_FDOPENDIR=1;AC_SUBST([HAVE_DECL_FDOPENDIR])
  HAVE_FDOPENDIR=1;     AC_SUBST([HAVE_FDOPENDIR])
  HAVE_SCANDIR=1;       AC_SUBST([HAVE_SCANDIR])
  HAVE_ALPHASORT=1;     AC_SUBST([HAVE_ALPHASORT])
  REPLACE_OPENDIR=0;    AC_SUBST([REPLACE_OPENDIR])
  REPLACE_CLOSEDIR=0;   AC_SUBST([REPLACE_CLOSEDIR])
  REPLACE_DIRFD=0;      AC_SUBST([REPLACE_DIRFD])
  REPLACE_FDOPENDIR=0;  AC_SUBST([REPLACE_FDOPENDIR])
])

# serial 26   -*- Autoconf -*-

dnl Find out how to get the file descriptor associated with an open DIR*.

# Copyright (C) 2001-2006, 2008-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering

AC_DEFUN([gl_FUNC_DIRFD],
[
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  dnl Persuade glibc <dirent.h> to declare dirfd().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_CHECK_FUNCS([dirfd])
  AC_CHECK_DECLS([dirfd], , ,
    [[#include <sys/types.h>
      #include <dirent.h>]])
  if test $ac_cv_have_decl_dirfd = no; then
    HAVE_DECL_DIRFD=0
  fi

  AC_CACHE_CHECK([whether dirfd is a macro],
    [gl_cv_func_dirfd_macro],
    [AC_EGREP_CPP([dirent_header_defines_dirfd], [
#include <sys/types.h>
#include <dirent.h>
#ifdef dirfd
 dirent_header_defines_dirfd
#endif],
       [gl_cv_func_dirfd_macro=yes],
       [gl_cv_func_dirfd_macro=no])])

  # Use the replacement if we have no function or macro with that name,
  # or if OS/2 kLIBC whose dirfd() does not work.
  # Replace only if the system declares dirfd already.
  case $ac_cv_func_dirfd,$gl_cv_func_dirfd_macro,$host_os,$ac_cv_have_decl_dirfd in
    no,no,*,yes | *,*,os2*,yes)
      REPLACE_DIRFD=1
      AC_DEFINE([REPLACE_DIRFD], [1],
        [Define to 1 if gnulib's dirfd() replacement is used.]);;
  esac
])

dnl Prerequisites of lib/dirfd.c.
AC_DEFUN([gl_PREREQ_DIRFD],
[
  AC_CACHE_CHECK([how to get the file descriptor associated with an open DIR*],
                 [gl_cv_sys_dir_fd_member_name],
    [
      dirfd_save_CFLAGS=$CFLAGS
      for ac_expr in d_fd dd_fd; do

        CFLAGS="$CFLAGS -DDIR_FD_MEMBER_NAME=$ac_expr"
        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
           #include <sys/types.h>
           #include <dirent.h>]],
          [[DIR *dir_p = opendir("."); (void) dir_p->DIR_FD_MEMBER_NAME;]])],
          [dir_fd_found=yes]
        )
        CFLAGS=$dirfd_save_CFLAGS
        test "$dir_fd_found" = yes && break
      done
      test "$dir_fd_found" = yes || ac_expr=no_such_member

      gl_cv_sys_dir_fd_member_name=$ac_expr
    ]
  )
  if test $gl_cv_sys_dir_fd_member_name != no_such_member; then
    AC_DEFINE_UNQUOTED([DIR_FD_MEMBER_NAME],
      [$gl_cv_sys_dir_fd_member_name],
      [the name of the file descriptor member of DIR])
  fi
  AH_VERBATIM([DIR_TO_FD],
              [#ifdef DIR_FD_MEMBER_NAME
# define DIR_TO_FD(Dir_p) ((Dir_p)->DIR_FD_MEMBER_NAME)
#else
# define DIR_TO_FD(Dir_p) -1
#endif
])
])

#serial 10   -*- autoconf -*-
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_DIRNAME],
[
  AC_REQUIRE([gl_DIRNAME_LGPL])
])

AC_DEFUN([gl_DIRNAME_LGPL],
[
  dnl Prerequisites of lib/dirname.h.
  AC_REQUIRE([gl_DOUBLE_SLASH_ROOT])

  dnl No prerequisites of lib/basename-lgpl.c, lib/dirname-lgpl.c,
  dnl lib/stripslash.c.
])

# double-slash-root.m4 serial 4   -*- Autoconf -*-
dnl Copyright (C) 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_DOUBLE_SLASH_ROOT],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CACHE_CHECK([whether // is distinct from /], [gl_cv_double_slash_root],
    [ if test x"$cross_compiling" = xyes ; then
        # When cross-compiling, there is no way to tell whether // is special
        # short of a list of hosts.  However, the only known hosts to date
        # that have a distinct // are Apollo DomainOS (too old to port to),
        # Cygwin, and z/OS.  If anyone knows of another system for which // has
        # special semantics and is distinct from /, please report it to
        # <bug-gnulib@gnu.org>.
        case $host in
          *-cygwin | i370-ibm-openedition)
            gl_cv_double_slash_root=yes ;;
          *)
            # Be optimistic and assume that / and // are the same when we
            # don't know.
            gl_cv_double_slash_root='unknown, assuming no' ;;
        esac
      else
        set x `ls -di / // 2>/dev/null`
        if test "$[2]" = "$[4]" && wc //dev/null >/dev/null 2>&1; then
          gl_cv_double_slash_root=no
        else
          gl_cv_double_slash_root=yes
        fi
      fi])
  if test "$gl_cv_double_slash_root" = yes; then
    AC_DEFINE([DOUBLE_SLASH_IS_DISTINCT_ROOT], [1],
      [Define to 1 if // is a file system root distinct from /.])
  fi
])

#serial 25
dnl Copyright (C) 2002, 2005, 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_DUP2],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  m4_ifdef([gl_FUNC_DUP2_OBSOLETE], [
    AC_CHECK_FUNCS_ONCE([dup2])
    if test $ac_cv_func_dup2 = no; then
      HAVE_DUP2=0
    fi
  ], [
    AC_DEFINE([HAVE_DUP2], [1], [Define to 1 if you have the 'dup2' function.])
  ])
  if test $HAVE_DUP2 = 1; then
    AC_CACHE_CHECK([whether dup2 works], [gl_cv_func_dup2_works],
      [AC_RUN_IFELSE([
         AC_LANG_PROGRAM(
           [[#include <errno.h>
             #include <fcntl.h>
             #include <limits.h>
             #include <sys/resource.h>
             #include <unistd.h>
             #ifndef RLIM_SAVED_CUR
             # define RLIM_SAVED_CUR RLIM_INFINITY
             #endif
             #ifndef RLIM_SAVED_MAX
             # define RLIM_SAVED_MAX RLIM_INFINITY
             #endif
           ]],
           [[int result = 0;
             int bad_fd = INT_MAX;
             struct rlimit rlim;
             if (getrlimit (RLIMIT_NOFILE, &rlim) == 0
                 && 0 <= rlim.rlim_cur && rlim.rlim_cur <= INT_MAX
                 && rlim.rlim_cur != RLIM_INFINITY
                 && rlim.rlim_cur != RLIM_SAVED_MAX
                 && rlim.rlim_cur != RLIM_SAVED_CUR)
               bad_fd = rlim.rlim_cur;
             #ifdef FD_CLOEXEC
               if (fcntl (1, F_SETFD, FD_CLOEXEC) == -1)
                 result |= 1;
             #endif
             if (dup2 (1, 1) != 1)
               result |= 2;
             #ifdef FD_CLOEXEC
               if (fcntl (1, F_GETFD) != FD_CLOEXEC)
                 result |= 4;
             #endif
             close (0);
             if (dup2 (0, 0) != -1)
               result |= 8;
             /* Many gnulib modules require POSIX conformance of EBADF.  */
             if (dup2 (2, bad_fd) == -1 && errno != EBADF)
               result |= 16;
             /* Flush out some cygwin core dumps.  */
             if (dup2 (2, -1) != -1 || errno != EBADF)
               result |= 32;
             dup2 (2, 255);
             dup2 (2, 256);
             /* On OS/2 kLIBC, dup2() does not work on a directory fd.  */
             {
               int fd = open (".", O_RDONLY);
               if (fd == -1)
                 result |= 64;
               else if (dup2 (fd, fd + 1) == -1)
                 result |= 128;

               close (fd);
             }
             return result;]])
        ],
        [gl_cv_func_dup2_works=yes], [gl_cv_func_dup2_works=no],
        [case "$host_os" in
           mingw*) # on this platform, dup2 always returns 0 for success
             gl_cv_func_dup2_works="guessing no" ;;
           cygwin*) # on cygwin 1.5.x, dup2(1,1) returns 0
             gl_cv_func_dup2_works="guessing no" ;;
           aix* | freebsd*)
                   # on AIX 7.1 and FreeBSD 6.1, dup2 (1,toobig) gives EMFILE,
                   # not EBADF.
             gl_cv_func_dup2_works="guessing no" ;;
           haiku*) # on Haiku alpha 2, dup2(1, 1) resets FD_CLOEXEC.
             gl_cv_func_dup2_works="guessing no" ;;
           *-android*) # implemented using dup3(), which fails if oldfd == newfd
             gl_cv_func_dup2_works="guessing no" ;;
           os2*) # on OS/2 kLIBC, dup2() does not work on a directory fd.
             gl_cv_func_dup2_works="guessing no" ;;
           *) gl_cv_func_dup2_works="guessing yes" ;;
         esac])
      ])
    case "$gl_cv_func_dup2_works" in
      *yes) ;;
      *)
        REPLACE_DUP2=1
        AC_CHECK_FUNCS([setdtablesize])
        ;;
    esac
  fi
  dnl Replace dup2() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    gl_TEST_FCHDIR
    if test $HAVE_FCHDIR = 0; then
      if test $HAVE_DUP2 = 1; then
        REPLACE_DUP2=1
      fi
    fi
  ])
])

# Prerequisites of lib/dup2.c.
AC_DEFUN([gl_PREREQ_DUP2], [])

# eealloc.m4 serial 3
dnl Copyright (C) 2003, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_EEALLOC],
[
  AC_REQUIRE([gl_EEMALLOC])
  AC_REQUIRE([gl_EEREALLOC])
])

AC_DEFUN([gl_EEMALLOC],
[
  _AC_FUNC_MALLOC_IF(
    [gl_cv_func_malloc_0_nonnull=1],
    [gl_cv_func_malloc_0_nonnull=0])
  AC_DEFINE_UNQUOTED([MALLOC_0_IS_NONNULL], [$gl_cv_func_malloc_0_nonnull],
    [If malloc(0) is != NULL, define this to 1.  Otherwise define this
     to 0.])
])

AC_DEFUN([gl_EEREALLOC],
[
  _AC_FUNC_REALLOC_IF(
    [gl_cv_func_realloc_0_nonnull=1],
    [gl_cv_func_realloc_0_nonnull=0])
  AC_DEFINE_UNQUOTED([REALLOC_0_IS_NONNULL], [$gl_cv_func_realloc_0_nonnull],
    [If realloc(NULL,0) is != NULL, define this to 1.  Otherwise define this
     to 0.])
])

# environ.m4 serial 6
dnl Copyright (C) 2001-2004, 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN_ONCE([gl_ENVIRON],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  dnl Persuade glibc <unistd.h> to declare environ.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  AC_CHECK_HEADERS_ONCE([unistd.h])
  gt_CHECK_VAR_DECL(
    [#if HAVE_UNISTD_H
     #include <unistd.h>
     #endif
     /* mingw, BeOS, Haiku declare environ in <stdlib.h>, not in <unistd.h>.  */
     #include <stdlib.h>
    ],
    [environ])
  if test $gt_cv_var_environ_declaration != yes; then
    HAVE_DECL_ENVIRON=0
  fi
])

# Check if a variable is properly declared.
# gt_CHECK_VAR_DECL(includes,variable)
AC_DEFUN([gt_CHECK_VAR_DECL],
[
  define([gt_cv_var], [gt_cv_var_]$2[_declaration])
  AC_MSG_CHECKING([if $2 is properly declared])
  AC_CACHE_VAL([gt_cv_var], [
    AC_COMPILE_IFELSE(
      [AC_LANG_PROGRAM(
         [[$1
           extern struct { int foo; } $2;]],
         [[$2.foo = 1;]])],
      [gt_cv_var=no],
      [gt_cv_var=yes])])
  AC_MSG_RESULT([$gt_cv_var])
  if test $gt_cv_var = yes; then
    AC_DEFINE([HAVE_]m4_translit($2, [a-z], [A-Z])[_DECL], 1,
              [Define if you have the declaration of $2.])
  fi
  undefine([gt_cv_var])
])

# errno_h.m4 serial 12
dnl Copyright (C) 2004, 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN_ONCE([gl_HEADER_ERRNO_H],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_CACHE_CHECK([for complete errno.h], [gl_cv_header_errno_h_complete], [
    AC_EGREP_CPP([booboo],[
#include <errno.h>
#if !defined ETXTBSY
booboo
#endif
#if !defined ENOMSG
booboo
#endif
#if !defined EIDRM
booboo
#endif
#if !defined ENOLINK
booboo
#endif
#if !defined EPROTO
booboo
#endif
#if !defined EMULTIHOP
booboo
#endif
#if !defined EBADMSG
booboo
#endif
#if !defined EOVERFLOW
booboo
#endif
#if !defined ENOTSUP
booboo
#endif
#if !defined ENETRESET
booboo
#endif
#if !defined ECONNABORTED
booboo
#endif
#if !defined ESTALE
booboo
#endif
#if !defined EDQUOT
booboo
#endif
#if !defined ECANCELED
booboo
#endif
#if !defined EOWNERDEAD
booboo
#endif
#if !defined ENOTRECOVERABLE
booboo
#endif
#if !defined EILSEQ
booboo
#endif
      ],
      [gl_cv_header_errno_h_complete=no],
      [gl_cv_header_errno_h_complete=yes])
  ])
  if test $gl_cv_header_errno_h_complete = yes; then
    ERRNO_H=''
  else
    gl_NEXT_HEADERS([errno.h])
    ERRNO_H='errno.h'
  fi
  AC_SUBST([ERRNO_H])
  AM_CONDITIONAL([GL_GENERATE_ERRNO_H], [test -n "$ERRNO_H"])
  gl_REPLACE_ERRNO_VALUE([EMULTIHOP])
  gl_REPLACE_ERRNO_VALUE([ENOLINK])
  gl_REPLACE_ERRNO_VALUE([EOVERFLOW])
])

# Assuming $1 = EOVERFLOW.
# The EOVERFLOW errno value ought to be defined in <errno.h>, according to
# POSIX.  But some systems (like OpenBSD 4.0 or AIX 3) don't define it, and
# some systems (like OSF/1) define it when _XOPEN_SOURCE_EXTENDED is defined.
# Check for the value of EOVERFLOW.
# Set the variables EOVERFLOW_HIDDEN and EOVERFLOW_VALUE.
AC_DEFUN([gl_REPLACE_ERRNO_VALUE],
[
  if test -n "$ERRNO_H"; then
    AC_CACHE_CHECK([for ]$1[ value], [gl_cv_header_errno_h_]$1, [
      AC_EGREP_CPP([yes],[
#include <errno.h>
#ifdef ]$1[
yes
#endif
      ],
      [gl_cv_header_errno_h_]$1[=yes],
      [gl_cv_header_errno_h_]$1[=no])
      if test $gl_cv_header_errno_h_]$1[ = no; then
        AC_EGREP_CPP([yes],[
#define _XOPEN_SOURCE_EXTENDED 1
#include <errno.h>
#ifdef ]$1[
yes
#endif
          ], [gl_cv_header_errno_h_]$1[=hidden])
        if test $gl_cv_header_errno_h_]$1[ = hidden; then
          dnl The macro exists but is hidden.
          dnl Define it to the same value.
          AC_COMPUTE_INT([gl_cv_header_errno_h_]$1, $1, [
#define _XOPEN_SOURCE_EXTENDED 1
#include <errno.h>
/* The following two lines are a workaround against an autoconf-2.52 bug.  */
#include <stdio.h>
#include <stdlib.h>
])
        fi
      fi
    ])
    case $gl_cv_header_errno_h_]$1[ in
      yes | no)
        ]$1[_HIDDEN=0; ]$1[_VALUE=
        ;;
      *)
        ]$1[_HIDDEN=1; ]$1[_VALUE="$gl_cv_header_errno_h_]$1["
        ;;
    esac
    AC_SUBST($1[_HIDDEN])
    AC_SUBST($1[_VALUE])
  fi
])

dnl Autoconf >= 2.61 has AC_COMPUTE_INT built-in.
dnl Remove this when we can assume autoconf >= 2.61.
m4_ifdef([AC_COMPUTE_INT], [], [
  AC_DEFUN([AC_COMPUTE_INT], [_AC_COMPUTE_INT([$2],[$1],[$3],[$4])])
])

#serial 14

# Copyright (C) 1996-1998, 2001-2004, 2009-2018 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_ERROR],
[
  dnl We don't use AC_FUNC_ERROR_AT_LINE any more, because it is no longer
  dnl maintained in Autoconf and because it invokes AC_LIBOBJ.
  AC_CACHE_CHECK([for error_at_line], [ac_cv_lib_error_at_line],
    [AC_LINK_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <error.h>]],
          [[error_at_line (0, 0, "", 0, "an error occurred");]])],
       [ac_cv_lib_error_at_line=yes],
       [ac_cv_lib_error_at_line=no])])
])

# Prerequisites of lib/error.c.
AC_DEFUN([gl_PREREQ_ERROR],
[
  AC_REQUIRE([AC_FUNC_STRERROR_R])
  :
])

# euidaccess.m4 serial 15
dnl Copyright (C) 2002-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_NONREENTRANT_EUIDACCESS],
[
  AC_REQUIRE([gl_FUNC_EUIDACCESS])
  AC_CHECK_DECLS([setregid])
  AC_DEFINE([PREFER_NONREENTRANT_EUIDACCESS], [1],
    [Define this if you prefer euidaccess to return the correct result
     even if this would make it nonreentrant.  Define this only if your
     entire application is safe even if the uid or gid might temporarily
     change.  If your application uses signal handlers or threads it
     is probably not safe.])
])

AC_DEFUN([gl_FUNC_EUIDACCESS],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])

  dnl Persuade glibc <unistd.h> to declare euidaccess().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_CHECK_FUNCS([euidaccess])
  if test $ac_cv_func_euidaccess = no; then
    HAVE_EUIDACCESS=0
  fi
])

# Prerequisites of lib/euidaccess.c.
AC_DEFUN([gl_PREREQ_EUIDACCESS], [
  dnl Prefer POSIX faccessat over non-standard euidaccess.
  AC_CHECK_FUNCS_ONCE([faccessat])
  dnl Try various other non-standard fallbacks.
  AC_CHECK_HEADERS([libgen.h])
  AC_FUNC_GETGROUPS

  # Solaris 9 and 10 need -lgen to get the eaccess function.
  # Save and restore LIBS so -lgen isn't added to it.  Otherwise, *all*
  # programs in the package would end up linked with that potentially-shared
  # library, inducing unnecessary run-time overhead.
  LIB_EACCESS=
  AC_SUBST([LIB_EACCESS])
  gl_saved_libs=$LIBS
    AC_SEARCH_LIBS([eaccess], [gen],
                   [test "$ac_cv_search_eaccess" = "none required" ||
                    LIB_EACCESS=$ac_cv_search_eaccess])
    AC_CHECK_FUNCS([eaccess])
  LIBS=$gl_saved_libs
])

# exponentd.m4 serial 3
dnl Copyright (C) 2007-2008, 2010-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.
AC_DEFUN([gl_DOUBLE_EXPONENT_LOCATION],
[
  AC_CACHE_CHECK([where to find the exponent in a 'double'],
    [gl_cv_cc_double_expbit0],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <float.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#define NWORDS \
  ((sizeof (double) + sizeof (unsigned int) - 1) / sizeof (unsigned int))
typedef union { double value; unsigned int word[NWORDS]; } memory_double;
static unsigned int ored_words[NWORDS];
static unsigned int anded_words[NWORDS];
static void add_to_ored_words (double x)
{
  memory_double m;
  size_t i;
  /* Clear it first, in case sizeof (double) < sizeof (memory_double).  */
  memset (&m, 0, sizeof (memory_double));
  m.value = x;
  for (i = 0; i < NWORDS; i++)
    {
      ored_words[i] |= m.word[i];
      anded_words[i] &= m.word[i];
    }
}
int main ()
{
  size_t j;
  FILE *fp = fopen ("conftest.out", "w");
  if (fp == NULL)
    return 1;
  for (j = 0; j < NWORDS; j++)
    anded_words[j] = ~ (unsigned int) 0;
  add_to_ored_words (0.25);
  add_to_ored_words (0.5);
  add_to_ored_words (1.0);
  add_to_ored_words (2.0);
  add_to_ored_words (4.0);
  /* Remove bits that are common (e.g. if representation of the first mantissa
     bit is explicit).  */
  for (j = 0; j < NWORDS; j++)
    ored_words[j] &= ~anded_words[j];
  /* Now find the nonzero word.  */
  for (j = 0; j < NWORDS; j++)
    if (ored_words[j] != 0)
      break;
  if (j < NWORDS)
    {
      size_t i;
      for (i = j + 1; i < NWORDS; i++)
        if (ored_words[i] != 0)
          {
            fprintf (fp, "unknown");
            return (fclose (fp) != 0);
          }
      for (i = 0; ; i++)
        if ((ored_words[j] >> i) & 1)
          {
            fprintf (fp, "word %d bit %d", (int) j, (int) i);
            return (fclose (fp) != 0);
          }
    }
  fprintf (fp, "unknown");
  return (fclose (fp) != 0);
}
        ]])],
        [gl_cv_cc_double_expbit0=`cat conftest.out`],
        [gl_cv_cc_double_expbit0="unknown"],
        [
          dnl On ARM, there are two 'double' floating-point formats, used by
          dnl different sets of instructions: The older FPA instructions assume
          dnl that they are stored in big-endian word order, while the words
          dnl (like integer types) are stored in little-endian byte order.
          dnl The newer VFP instructions assume little-endian order
          dnl consistently.
          AC_EGREP_CPP([mixed_endianness], [
#if defined arm || defined __arm || defined __arm__
  mixed_endianness
#endif
            ],
            [gl_cv_cc_double_expbit0="unknown"],
            [
              pushdef([AC_MSG_CHECKING],[:])dnl
              pushdef([AC_MSG_RESULT],[:])dnl
              pushdef([AC_MSG_RESULT_UNQUOTED],[:])dnl
              AC_C_BIGENDIAN(
                [gl_cv_cc_double_expbit0="word 0 bit 20"],
                [gl_cv_cc_double_expbit0="word 1 bit 20"],
                [gl_cv_cc_double_expbit0="unknown"])
              popdef([AC_MSG_RESULT_UNQUOTED])dnl
              popdef([AC_MSG_RESULT])dnl
              popdef([AC_MSG_CHECKING])dnl
            ])
        ])
      rm -f conftest.out
    ])
  case "$gl_cv_cc_double_expbit0" in
    word*bit*)
      word=`echo "$gl_cv_cc_double_expbit0" | sed -e 's/word //' -e 's/ bit.*//'`
      bit=`echo "$gl_cv_cc_double_expbit0" | sed -e 's/word.*bit //'`
      AC_DEFINE_UNQUOTED([DBL_EXPBIT0_WORD], [$word],
        [Define as the word index where to find the exponent of 'double'.])
      AC_DEFINE_UNQUOTED([DBL_EXPBIT0_BIT], [$bit],
        [Define as the bit index in the word where to find bit 0 of the exponent of 'double'.])
      ;;
  esac
])

# serial 18  -*- Autoconf -*-
# Enable extensions on systems that normally disable them.

# Copyright (C) 2003, 2006-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This definition of AC_USE_SYSTEM_EXTENSIONS is stolen from git
# Autoconf.  Perhaps we can remove this once we can assume Autoconf
# 2.70 or later everywhere, but since Autoconf mutates rapidly
# enough in this area it's likely we'll need to redefine
# AC_USE_SYSTEM_EXTENSIONS for quite some time.

# If autoconf reports a warning
#     warning: AC_COMPILE_IFELSE was called before AC_USE_SYSTEM_EXTENSIONS
# or  warning: AC_RUN_IFELSE was called before AC_USE_SYSTEM_EXTENSIONS
# the fix is
#   1) to ensure that AC_USE_SYSTEM_EXTENSIONS is never directly invoked
#      but always AC_REQUIREd,
#   2) to ensure that for each occurrence of
#        AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])
#      or
#        AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
#      the corresponding gnulib module description has 'extensions' among
#      its dependencies. This will ensure that the gl_USE_SYSTEM_EXTENSIONS
#      invocation occurs in gl_EARLY, not in gl_INIT.

# AC_USE_SYSTEM_EXTENSIONS
# ------------------------
# Enable extensions on systems that normally disable them,
# typically due to standards-conformance issues.
#
# Remember that #undef in AH_VERBATIM gets replaced with #define by
# AC_DEFINE.  The goal here is to define all known feature-enabling
# macros, then, if reports of conflicts are made, disable macros that
# cause problems on some platforms (such as __EXTENSIONS__).
AC_DEFUN_ONCE([AC_USE_SYSTEM_EXTENSIONS],
[AC_BEFORE([$0], [AC_COMPILE_IFELSE])dnl
AC_BEFORE([$0], [AC_RUN_IFELSE])dnl

  AC_CHECK_HEADER([minix/config.h], [MINIX=yes], [MINIX=])
  if test "$MINIX" = yes; then
    AC_DEFINE([_POSIX_SOURCE], [1],
      [Define to 1 if you need to in order for 'stat' and other
       things to work.])
    AC_DEFINE([_POSIX_1_SOURCE], [2],
      [Define to 2 if the system does not provide POSIX.1 features
       except with this defined.])
    AC_DEFINE([_MINIX], [1],
      [Define to 1 if on MINIX.])
    AC_DEFINE([_NETBSD_SOURCE], [1],
      [Define to 1 to make NetBSD features available.  MINIX 3 needs this.])
  fi

dnl Use a different key than __EXTENSIONS__, as that name broke existing
dnl configure.ac when using autoheader 2.62.
  AH_VERBATIM([USE_SYSTEM_EXTENSIONS],
[/* Enable extensions on AIX 3, Interix.  */
#ifndef _ALL_SOURCE
# undef _ALL_SOURCE
#endif
/* Enable general extensions on macOS.  */
#ifndef _DARWIN_C_SOURCE
# undef _DARWIN_C_SOURCE
#endif
/* Enable GNU extensions on systems that have them.  */
#ifndef _GNU_SOURCE
# undef _GNU_SOURCE
#endif
/* Enable NetBSD extensions on NetBSD.  */
#ifndef _NETBSD_SOURCE
# undef _NETBSD_SOURCE
#endif
/* Enable OpenBSD extensions on NetBSD.  */
#ifndef _OPENBSD_SOURCE
# undef _OPENBSD_SOURCE
#endif
/* Enable threading extensions on Solaris.  */
#ifndef _POSIX_PTHREAD_SEMANTICS
# undef _POSIX_PTHREAD_SEMANTICS
#endif
/* Enable extensions specified by ISO/IEC TS 18661-5:2014.  */
#ifndef __STDC_WANT_IEC_60559_ATTRIBS_EXT__
# undef __STDC_WANT_IEC_60559_ATTRIBS_EXT__
#endif
/* Enable extensions specified by ISO/IEC TS 18661-1:2014.  */
#ifndef __STDC_WANT_IEC_60559_BFP_EXT__
# undef __STDC_WANT_IEC_60559_BFP_EXT__
#endif
/* Enable extensions specified by ISO/IEC TS 18661-2:2015.  */
#ifndef __STDC_WANT_IEC_60559_DFP_EXT__
# undef __STDC_WANT_IEC_60559_DFP_EXT__
#endif
/* Enable extensions specified by ISO/IEC TS 18661-4:2015.  */
#ifndef __STDC_WANT_IEC_60559_FUNCS_EXT__
# undef __STDC_WANT_IEC_60559_FUNCS_EXT__
#endif
/* Enable extensions specified by ISO/IEC TS 18661-3:2015.  */
#ifndef __STDC_WANT_IEC_60559_TYPES_EXT__
# undef __STDC_WANT_IEC_60559_TYPES_EXT__
#endif
/* Enable extensions specified by ISO/IEC TR 24731-2:2010.  */
#ifndef __STDC_WANT_LIB_EXT2__
# undef __STDC_WANT_LIB_EXT2__
#endif
/* Enable extensions specified by ISO/IEC 24747:2009.  */
#ifndef __STDC_WANT_MATH_SPEC_FUNCS__
# undef __STDC_WANT_MATH_SPEC_FUNCS__
#endif
/* Enable extensions on HP NonStop.  */
#ifndef _TANDEM_SOURCE
# undef _TANDEM_SOURCE
#endif
/* Enable X/Open extensions if necessary.  HP-UX 11.11 defines
   mbstate_t only if _XOPEN_SOURCE is defined to 500, regardless of
   whether compiling with -Ae or -D_HPUX_SOURCE=1.  */
#ifndef _XOPEN_SOURCE
# undef _XOPEN_SOURCE
#endif
/* Enable X/Open compliant socket functions that do not require linking
   with -lxnet on HP-UX 11.11.  */
#ifndef _HPUX_ALT_XOPEN_SOCKET_API
# undef _HPUX_ALT_XOPEN_SOCKET_API
#endif
/* Enable general extensions on Solaris.  */
#ifndef __EXTENSIONS__
# undef __EXTENSIONS__
#endif
])
  AC_CACHE_CHECK([whether it is safe to define __EXTENSIONS__],
    [ac_cv_safe_to_define___extensions__],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM([[
#         define __EXTENSIONS__ 1
          ]AC_INCLUDES_DEFAULT])],
       [ac_cv_safe_to_define___extensions__=yes],
       [ac_cv_safe_to_define___extensions__=no])])
  test $ac_cv_safe_to_define___extensions__ = yes &&
    AC_DEFINE([__EXTENSIONS__])
  AC_DEFINE([_ALL_SOURCE])
  AC_DEFINE([_DARWIN_C_SOURCE])
  AC_DEFINE([_GNU_SOURCE])
  AC_DEFINE([_NETBSD_SOURCE])
  AC_DEFINE([_OPENBSD_SOURCE])
  AC_DEFINE([_POSIX_PTHREAD_SEMANTICS])
  AC_DEFINE([__STDC_WANT_IEC_60559_ATTRIBS_EXT__])
  AC_DEFINE([__STDC_WANT_IEC_60559_BFP_EXT__])
  AC_DEFINE([__STDC_WANT_IEC_60559_DFP_EXT__])
  AC_DEFINE([__STDC_WANT_IEC_60559_FUNCS_EXT__])
  AC_DEFINE([__STDC_WANT_IEC_60559_TYPES_EXT__])
  AC_DEFINE([__STDC_WANT_LIB_EXT2__])
  AC_DEFINE([__STDC_WANT_MATH_SPEC_FUNCS__])
  AC_DEFINE([_TANDEM_SOURCE])
  AC_CACHE_CHECK([whether _XOPEN_SOURCE should be defined],
    [ac_cv_should_define__xopen_source],
    [ac_cv_should_define__xopen_source=no
     AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM([[
          #include <wchar.h>
          mbstate_t x;]])],
       [],
       [AC_COMPILE_IFELSE(
          [AC_LANG_PROGRAM([[
             #define _XOPEN_SOURCE 500
             #include <wchar.h>
             mbstate_t x;]])],
          [ac_cv_should_define__xopen_source=yes])])])
  test $ac_cv_should_define__xopen_source = yes &&
    AC_DEFINE([_XOPEN_SOURCE], [500])
  AC_DEFINE([_HPUX_ALT_XOPEN_SOCKET_API])
])# AC_USE_SYSTEM_EXTENSIONS

# gl_USE_SYSTEM_EXTENSIONS
# ------------------------
# Enable extensions on systems that normally disable them,
# typically due to standards-conformance issues.
AC_DEFUN_ONCE([gl_USE_SYSTEM_EXTENSIONS],
[
  dnl Require this macro before AC_USE_SYSTEM_EXTENSIONS.
  dnl gnulib does not need it. But if it gets required by third-party macros
  dnl after AC_USE_SYSTEM_EXTENSIONS is required, autoconf 2.62..2.63 emit a
  dnl warning: "AC_COMPILE_IFELSE was called before AC_USE_SYSTEM_EXTENSIONS".
  dnl Note: We can do this only for one of the macros AC_AIX, AC_GNU_SOURCE,
  dnl AC_MINIX. If people still use AC_AIX or AC_MINIX, they are out of luck.
  AC_REQUIRE([AC_GNU_SOURCE])

  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])
])

dnl 'extern inline' a la ISO C99.

dnl Copyright 2012-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_EXTERN_INLINE],
[
  AH_VERBATIM([extern_inline],
[/* Please see the Gnulib manual for how to use these macros.

   Suppress extern inline with HP-UX cc, as it appears to be broken; see
   <https://lists.gnu.org/r/bug-texinfo/2013-02/msg00030.html>.

   Suppress extern inline with Sun C in standards-conformance mode, as it
   mishandles inline functions that call each other.  E.g., for 'inline void f
   (void) { } inline void g (void) { f (); }', c99 incorrectly complains
   'reference to static identifier "f" in extern inline function'.
   This bug was observed with Sun C 5.12 SunOS_i386 2011/11/16.

   Suppress extern inline (with or without __attribute__ ((__gnu_inline__)))
   on configurations that mistakenly use 'static inline' to implement
   functions or macros in standard C headers like <ctype.h>.  For example,
   if isdigit is mistakenly implemented via a static inline function,
   a program containing an extern inline function that calls isdigit
   may not work since the C standard prohibits extern inline functions
   from calling static functions.  This bug is known to occur on:

     OS X 10.8 and earlier; see:
     https://lists.gnu.org/r/bug-gnulib/2012-12/msg00023.html

     DragonFly; see
     http://muscles.dragonflybsd.org/bulk/bleeding-edge-potential/latest-per-pkg/ah-tty-0.3.12.log

     FreeBSD; see:
     https://lists.gnu.org/r/bug-gnulib/2014-07/msg00104.html

   OS X 10.9 has a macro __header_inline indicating the bug is fixed for C and
   for clang but remains for g++; see <https://trac.macports.org/ticket/41033>.
   Assume DragonFly and FreeBSD will be similar.  */
#if (((defined __APPLE__ && defined __MACH__) \
      || defined __DragonFly__ || defined __FreeBSD__) \
     && (defined __header_inline \
         ? (defined __cplusplus && defined __GNUC_STDC_INLINE__ \
            && ! defined __clang__) \
         : ((! defined _DONT_USE_CTYPE_INLINE_ \
             && (defined __GNUC__ || defined __cplusplus)) \
            || (defined _FORTIFY_SOURCE && 0 < _FORTIFY_SOURCE \
                && defined __GNUC__ && ! defined __cplusplus))))
# define _GL_EXTERN_INLINE_STDHEADER_BUG
#endif
#if ((__GNUC__ \
      ? defined __GNUC_STDC_INLINE__ && __GNUC_STDC_INLINE__ \
      : (199901L <= __STDC_VERSION__ \
         && !defined __HP_cc \
         && !defined __PGI \
         && !(defined __SUNPRO_C && __STDC__))) \
     && !defined _GL_EXTERN_INLINE_STDHEADER_BUG)
# define _GL_INLINE inline
# define _GL_EXTERN_INLINE extern inline
# define _GL_EXTERN_INLINE_IN_USE
#elif (2 < __GNUC__ + (7 <= __GNUC_MINOR__) && !defined __STRICT_ANSI__ \
       && !defined _GL_EXTERN_INLINE_STDHEADER_BUG)
# if defined __GNUC_GNU_INLINE__ && __GNUC_GNU_INLINE__
   /* __gnu_inline__ suppresses a GCC 4.2 diagnostic.  */
#  define _GL_INLINE extern inline __attribute__ ((__gnu_inline__))
# else
#  define _GL_INLINE extern inline
# endif
# define _GL_EXTERN_INLINE extern
# define _GL_EXTERN_INLINE_IN_USE
#else
# define _GL_INLINE static _GL_UNUSED
# define _GL_EXTERN_INLINE static _GL_UNUSED
#endif

/* In GCC 4.6 (inclusive) to 5.1 (exclusive),
   suppress bogus "no previous prototype for 'FOO'"
   and "no previous declaration for 'FOO'" diagnostics,
   when FOO is an inline function in the header; see
   <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54113> and
   <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63877>.  */
#if __GNUC__ == 4 && 6 <= __GNUC_MINOR__
# if defined __GNUC_STDC_INLINE__ && __GNUC_STDC_INLINE__
#  define _GL_INLINE_HEADER_CONST_PRAGMA
# else
#  define _GL_INLINE_HEADER_CONST_PRAGMA \
     _Pragma ("GCC diagnostic ignored \"-Wsuggest-attribute=const\"")
# endif
# define _GL_INLINE_HEADER_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wmissing-prototypes\"") \
    _Pragma ("GCC diagnostic ignored \"-Wmissing-declarations\"") \
    _GL_INLINE_HEADER_CONST_PRAGMA
# define _GL_INLINE_HEADER_END \
    _Pragma ("GCC diagnostic pop")
#else
# define _GL_INLINE_HEADER_BEGIN
# define _GL_INLINE_HEADER_END
#endif])
])

# serial 8
# See if we need to provide faccessat replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_FACCESSAT],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK])

  dnl Persuade glibc <unistd.h> to declare faccessat().
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  AC_CHECK_FUNCS_ONCE([faccessat])
  if test $ac_cv_func_faccessat = no; then
    HAVE_FACCESSAT=0
  else
    case "$gl_cv_func_lstat_dereferences_slashed_symlink" in
      *yes) ;;
      *)    REPLACE_FACCESSAT=1 ;;
    esac
  fi
])

# Prerequisites of lib/faccessat.c.
AC_DEFUN([gl_PREREQ_FACCESSAT],
[
  AC_CHECK_FUNCS([access])
])

# fchdir.m4 serial 23
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_FCHDIR],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_CHECK_DECLS_ONCE([fchdir])
  if test $ac_cv_have_decl_fchdir = no; then
    HAVE_DECL_FCHDIR=0
  fi

  AC_REQUIRE([gl_TEST_FCHDIR])
  if test $HAVE_FCHDIR = 0; then
    AC_LIBOBJ([fchdir])
    gl_PREREQ_FCHDIR
    AC_DEFINE([REPLACE_FCHDIR], [1],
      [Define to 1 if gnulib's fchdir() replacement is used.])
    dnl We must also replace anything that can manipulate a directory fd,
    dnl to keep our bookkeeping up-to-date.  We don't have to replace
    dnl fstatat, since no platform has fstatat but lacks fchdir.
    AC_CACHE_CHECK([whether open can visit directories],
      [gl_cv_func_open_directory_works],
      [AC_RUN_IFELSE([AC_LANG_PROGRAM([[#include <fcntl.h>
]], [return open(".", O_RDONLY) < 0;])],
        [gl_cv_func_open_directory_works=yes],
        [gl_cv_func_open_directory_works=no],
        [case "$host_os" in
                          # Guess yes on glibc systems.
           *-gnu* | gnu*) gl_cv_func_open_directory_works="guessing yes" ;;
                          # Guess no on native Windows.
           mingw*)        gl_cv_func_open_directory_works="guessing no" ;;
                          # If we don't know, assume the worst.
           *)             gl_cv_func_open_directory_works="guessing no" ;;
         esac
        ])])
    case "$gl_cv_func_open_directory_works" in
      *yes) ;;
      *)
        AC_DEFINE([REPLACE_OPEN_DIRECTORY], [1], [Define to 1 if open() should
work around the inability to open a directory.])
        ;;
    esac
  fi
])

# Determine whether to use the overrides in lib/fchdir.c.
AC_DEFUN([gl_TEST_FCHDIR],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([fchdir])
  if test $ac_cv_func_fchdir = no; then
    HAVE_FCHDIR=0
  fi
])

# Prerequisites of lib/fchdir.c.
AC_DEFUN([gl_PREREQ_FCHDIR], [:])

# fchmodat.m4 serial 1
dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

AC_DEFUN([gl_FUNC_FCHMODAT],
[
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([fchmodat lchmod])
  if test $ac_cv_func_fchmodat != yes; then
    HAVE_FCHMODAT=0
  fi
])

# fchownat.m4 serial 2
dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

# If we have the fchownat function, and it has the bug (in glibc-2.4)
# that it dereferences symlinks even with AT_SYMLINK_NOFOLLOW, then
# use the replacement function.
# Also if the fchownat function, like chown, has the trailing slash bug,
# use the replacement function.
# Also use the replacement function if fchownat is simply not available.
AC_DEFUN([gl_FUNC_FCHOWNAT],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_FUNC_CHOWN])
  AC_CHECK_FUNC([fchownat],
    [gl_FUNC_FCHOWNAT_DEREF_BUG(
       [REPLACE_FCHOWNAT=1
        AC_DEFINE([FCHOWNAT_NOFOLLOW_BUG], [1],
                  [Define to 1 if your platform has fchownat, but it cannot
                   perform lchown tasks.])
       ])
     gl_FUNC_FCHOWNAT_EMPTY_FILENAME_BUG(
       [REPLACE_FCHOWNAT=1
        AC_DEFINE([FCHOWNAT_EMPTY_FILENAME_BUG], [1],
                  [Define to 1 if your platform has fchownat, but it does
                   not reject an empty file name.])
       ])
     if test $REPLACE_CHOWN = 1; then
       REPLACE_FCHOWNAT=1
     fi],
    [HAVE_FCHOWNAT=0])
])

# gl_FUNC_FCHOWNAT_DEREF_BUG([ACTION-IF-BUGGY[, ACTION-IF-NOT_BUGGY]])
AC_DEFUN([gl_FUNC_FCHOWNAT_DEREF_BUG],
[
  dnl Persuade glibc's <unistd.h> to declare fchownat().
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  AC_CACHE_CHECK([whether fchownat works with AT_SYMLINK_NOFOLLOW],
    [gl_cv_func_fchownat_nofollow_works],
    [
     gl_dangle=conftest.dangle
     # Remove any remnants of a previous test.
     rm -f $gl_dangle
     # Arrange for deletion of the temporary file this test creates.
     ac_clean_files="$ac_clean_files $gl_dangle"
     ln -s conftest.no-such $gl_dangle
     AC_RUN_IFELSE(
       [AC_LANG_SOURCE(
          [[
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
int
main ()
{
  return (fchownat (AT_FDCWD, "$gl_dangle", -1, getgid (),
                    AT_SYMLINK_NOFOLLOW) != 0
          && errno == ENOENT);
}
          ]])],
       [gl_cv_func_fchownat_nofollow_works=yes],
       [gl_cv_func_fchownat_nofollow_works=no],
       [gl_cv_func_fchownat_nofollow_works=no])
  ])
  AS_IF([test $gl_cv_func_fchownat_nofollow_works = no], [$1], [$2])
])

# gl_FUNC_FCHOWNAT_EMPTY_FILENAME_BUG([ACTION-IF-BUGGY[, ACTION-IF-NOT_BUGGY]])
AC_DEFUN([gl_FUNC_FCHOWNAT_EMPTY_FILENAME_BUG],
[
  dnl Persuade glibc's <unistd.h> to declare fchownat().
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  AC_CACHE_CHECK([whether fchownat works with an empty file name],
    [gl_cv_func_fchownat_empty_filename_works],
    [AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <unistd.h>
            #include <fcntl.h>
          ]],
          [[int fd;
            int ret;
            if (mkdir ("conftestdir", 0700) < 0)
              return 2;
            fd = open ("conftestdir", O_RDONLY);
            if (fd < 0)
              return 3;
            ret = fchownat (fd, "", -1, -1, 0);
            close (fd);
            rmdir ("conftestdir");
            return ret == 0;
          ]])],
       [gl_cv_func_fchownat_empty_filename_works=yes],
       [gl_cv_func_fchownat_empty_filename_works=no],
       [gl_cv_func_fchownat_empty_filename_works="guessing no"])
    ])
  AS_IF([test "$gl_cv_func_fchownat_empty_filename_works" != yes], [$1], [$2])
])

# fcntl-o.m4 serial 5
dnl Copyright (C) 2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Paul Eggert.

# Test whether the flags O_NOATIME and O_NOFOLLOW actually work.
# Define HAVE_WORKING_O_NOATIME to 1 if O_NOATIME works, or to 0 otherwise.
# Define HAVE_WORKING_O_NOFOLLOW to 1 if O_NOFOLLOW works, or to 0 otherwise.
AC_DEFUN([gl_FCNTL_O_FLAGS],
[
  dnl Persuade glibc <fcntl.h> to define O_NOATIME and O_NOFOLLOW.
  dnl AC_USE_SYSTEM_EXTENSIONS was introduced in autoconf 2.60 and obsoletes
  dnl AC_GNU_SOURCE.
  m4_ifdef([AC_USE_SYSTEM_EXTENSIONS],
    [AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])],
    [AC_REQUIRE([AC_GNU_SOURCE])])

  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_HEADERS_ONCE([unistd.h])
  AC_CHECK_FUNCS_ONCE([symlink])
  AC_CACHE_CHECK([for working fcntl.h], [gl_cv_header_working_fcntl_h],
    [AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <sys/types.h>
           #include <sys/stat.h>
           #if HAVE_UNISTD_H
           # include <unistd.h>
           #else /* on Windows with MSVC */
           # include <io.h>
           # include <stdlib.h>
           # defined sleep(n) _sleep ((n) * 1000)
           #endif
           #include <fcntl.h>
           #ifndef O_NOATIME
            #define O_NOATIME 0
           #endif
           #ifndef O_NOFOLLOW
            #define O_NOFOLLOW 0
           #endif
           static int const constants[] =
            {
              O_CREAT, O_EXCL, O_NOCTTY, O_TRUNC, O_APPEND,
              O_NONBLOCK, O_SYNC, O_ACCMODE, O_RDONLY, O_RDWR, O_WRONLY
            };
          ]],
          [[
            int result = !constants;
            #if HAVE_SYMLINK
            {
              static char const sym[] = "conftest.sym";
              if (symlink ("/dev/null", sym) != 0)
                result |= 2;
              else
                {
                  int fd = open (sym, O_WRONLY | O_NOFOLLOW | O_CREAT, 0);
                  if (fd >= 0)
                    {
                      close (fd);
                      result |= 4;
                    }
                }
              if (unlink (sym) != 0 || symlink (".", sym) != 0)
                result |= 2;
              else
                {
                  int fd = open (sym, O_RDONLY | O_NOFOLLOW);
                  if (fd >= 0)
                    {
                      close (fd);
                      result |= 4;
                    }
                }
              unlink (sym);
            }
            #endif
            {
              static char const file[] = "confdefs.h";
              int fd = open (file, O_RDONLY | O_NOATIME);
              if (fd < 0)
                result |= 8;
              else
                {
                  struct stat st0;
                  if (fstat (fd, &st0) != 0)
                    result |= 16;
                  else
                    {
                      char c;
                      sleep (1);
                      if (read (fd, &c, 1) != 1)
                        result |= 24;
                      else
                        {
                          if (close (fd) != 0)
                            result |= 32;
                          else
                            {
                              struct stat st1;
                              if (stat (file, &st1) != 0)
                                result |= 40;
                              else
                                if (st0.st_atime != st1.st_atime)
                                  result |= 64;
                            }
                        }
                    }
                }
            }
            return result;]])],
       [gl_cv_header_working_fcntl_h=yes],
       [case $? in #(
        4) gl_cv_header_working_fcntl_h='no (bad O_NOFOLLOW)';; #(
        64) gl_cv_header_working_fcntl_h='no (bad O_NOATIME)';; #(
        68) gl_cv_header_working_fcntl_h='no (bad O_NOATIME, O_NOFOLLOW)';; #(
         *) gl_cv_header_working_fcntl_h='no';;
        esac],
       [case "$host_os" in
                  # Guess 'no' on native Windows.
          mingw*) gl_cv_header_working_fcntl_h='no' ;;
          *)      gl_cv_header_working_fcntl_h=cross-compiling ;;
        esac
       ])
    ])

  case $gl_cv_header_working_fcntl_h in #(
  *O_NOATIME* | no | cross-compiling) ac_val=0;; #(
  *) ac_val=1;;
  esac
  AC_DEFINE_UNQUOTED([HAVE_WORKING_O_NOATIME], [$ac_val],
    [Define to 1 if O_NOATIME works.])

  case $gl_cv_header_working_fcntl_h in #(
  *O_NOFOLLOW* | no | cross-compiling) ac_val=0;; #(
  *) ac_val=1;;
  esac
  AC_DEFINE_UNQUOTED([HAVE_WORKING_O_NOFOLLOW], [$ac_val],
    [Define to 1 if O_NOFOLLOW works.])
])

# fcntl.m4 serial 9
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# For now, this module ensures that fcntl()
# - supports F_DUPFD correctly
# - supports or emulates F_DUPFD_CLOEXEC
# - supports F_GETFD
# Still to be ported to mingw:
# - F_SETFD
# - F_GETFL, F_SETFL
# - F_GETOWN, F_SETOWN
# - F_GETLK, F_SETLK, F_SETLKW
AC_DEFUN([gl_FUNC_FCNTL],
[
  dnl Persuade glibc to expose F_DUPFD_CLOEXEC.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_FCNTL_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([fcntl])
  if test $ac_cv_func_fcntl = no; then
    gl_REPLACE_FCNTL
  else
    dnl cygwin 1.5.x F_DUPFD has wrong errno, and allows negative target
    dnl haiku alpha 2 F_DUPFD has wrong errno
    AC_CACHE_CHECK([whether fcntl handles F_DUPFD correctly],
      [gl_cv_func_fcntl_f_dupfd_works],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
            [[#include <errno.h>
              #include <fcntl.h>
              #include <limits.h>
              #include <sys/resource.h>
              #include <unistd.h>
              #ifndef RLIM_SAVED_CUR
              # define RLIM_SAVED_CUR RLIM_INFINITY
              #endif
              #ifndef RLIM_SAVED_MAX
              # define RLIM_SAVED_MAX RLIM_INFINITY
              #endif
            ]],
            [[int result = 0;
              int bad_fd = INT_MAX;
              struct rlimit rlim;
              if (getrlimit (RLIMIT_NOFILE, &rlim) == 0
                  && 0 <= rlim.rlim_cur && rlim.rlim_cur <= INT_MAX
                  && rlim.rlim_cur != RLIM_INFINITY
                  && rlim.rlim_cur != RLIM_SAVED_MAX
                  && rlim.rlim_cur != RLIM_SAVED_CUR)
                bad_fd = rlim.rlim_cur;
              if (fcntl (0, F_DUPFD, -1) != -1) result |= 1;
              if (errno != EINVAL) result |= 2;
              if (fcntl (0, F_DUPFD, bad_fd) != -1) result |= 4;
              if (errno != EINVAL) result |= 8;
              /* On OS/2 kLIBC, F_DUPFD does not work on a directory fd */
              {
                int fd;
                fd = open (".", O_RDONLY);
                if (fd == -1)
                  result |= 16;
                else if (fcntl (fd, F_DUPFD, STDERR_FILENO + 1) == -1)
                  result |= 32;

                close (fd);
              }
              return result;]])],
         [gl_cv_func_fcntl_f_dupfd_works=yes],
         [gl_cv_func_fcntl_f_dupfd_works=no],
         [case $host_os in
            aix* | cygwin* | haiku*)
               gl_cv_func_fcntl_f_dupfd_works="guessing no" ;;
            *) gl_cv_func_fcntl_f_dupfd_works="guessing yes" ;;
          esac])])
    case $gl_cv_func_fcntl_f_dupfd_works in
      *yes) ;;
      *) gl_REPLACE_FCNTL
        AC_DEFINE([FCNTL_DUPFD_BUGGY], [1], [Define this to 1 if F_DUPFD
          behavior does not match POSIX]) ;;
    esac

    dnl Many systems lack F_DUPFD_CLOEXEC
    AC_CACHE_CHECK([whether fcntl understands F_DUPFD_CLOEXEC],
      [gl_cv_func_fcntl_f_dupfd_cloexec],
      [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
#include <fcntl.h>
#ifndef F_DUPFD_CLOEXEC
choke me
#endif
         ]])],
         [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
#ifdef __linux__
/* The Linux kernel only added F_DUPFD_CLOEXEC in 2.6.24, so we always replace
   it to support the semantics on older kernels that failed with EINVAL.  */
choke me
#endif
           ]])],
           [gl_cv_func_fcntl_f_dupfd_cloexec=yes],
           [gl_cv_func_fcntl_f_dupfd_cloexec="needs runtime check"])],
         [gl_cv_func_fcntl_f_dupfd_cloexec=no])])
    if test "$gl_cv_func_fcntl_f_dupfd_cloexec" != yes; then
      gl_REPLACE_FCNTL
      dnl No witness macro needed for this bug.
    fi
  fi
  dnl Replace fcntl() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    gl_TEST_FCHDIR
    if test $HAVE_FCHDIR = 0; then
      gl_REPLACE_FCNTL
    fi
  ])
])

AC_DEFUN([gl_REPLACE_FCNTL],
[
  AC_REQUIRE([gl_FCNTL_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([fcntl])
  if test $ac_cv_func_fcntl = no; then
    HAVE_FCNTL=0
  else
    REPLACE_FCNTL=1
  fi
])

# serial 15
# Configure fcntl.h.
dnl Copyright (C) 2006-2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Paul Eggert.

AC_DEFUN([gl_FCNTL_H],
[
  AC_REQUIRE([gl_FCNTL_H_DEFAULTS])
  AC_REQUIRE([gl_FCNTL_O_FLAGS])
  gl_NEXT_HEADERS([fcntl.h])

  dnl Ensure the type pid_t gets defined.
  AC_REQUIRE([AC_TYPE_PID_T])

  dnl Ensure the type mode_t gets defined.
  AC_REQUIRE([AC_TYPE_MODE_T])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use, if it is not common
  dnl enough to be declared everywhere.
  gl_WARN_ON_USE_PREPARE([[#include <fcntl.h>
    ]], [fcntl openat])
])

AC_DEFUN([gl_FCNTL_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_FCNTL_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_FCNTL_H_DEFAULTS],
[
  GNULIB_FCNTL=0;        AC_SUBST([GNULIB_FCNTL])
  GNULIB_NONBLOCKING=0;  AC_SUBST([GNULIB_NONBLOCKING])
  GNULIB_OPEN=0;         AC_SUBST([GNULIB_OPEN])
  GNULIB_OPENAT=0;       AC_SUBST([GNULIB_OPENAT])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_FCNTL=1;          AC_SUBST([HAVE_FCNTL])
  HAVE_OPENAT=1;         AC_SUBST([HAVE_OPENAT])
  REPLACE_FCNTL=0;       AC_SUBST([REPLACE_FCNTL])
  REPLACE_OPEN=0;        AC_SUBST([REPLACE_OPEN])
  REPLACE_OPENAT=0;      AC_SUBST([REPLACE_OPENAT])
])

# filenamecat.m4 serial 11
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FILE_NAME_CONCAT],
[
  AC_REQUIRE([gl_FILE_NAME_CONCAT_LGPL])
])

AC_DEFUN([gl_FILE_NAME_CONCAT_LGPL],
[
  dnl Prerequisites of lib/filenamecat-lgpl.c.
  AC_CHECK_FUNCS_ONCE([mempcpy])
])

# serial 5
# Check for flexible array member support.

# Copyright (C) 2006, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Written by Paul Eggert.

AC_DEFUN([AC_C_FLEXIBLE_ARRAY_MEMBER],
[
  AC_CACHE_CHECK([for flexible array member],
    ac_cv_c_flexmember,
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <stdlib.h>
            #include <stdio.h>
            #include <stddef.h>
            struct m { struct m *next, **list; char name[]; };
            struct s { struct s *p; struct m *m; int n; double d[]; };]],
          [[int m = getchar ();
            size_t nbytes = offsetof (struct s, d) + m * sizeof (double);
            nbytes += sizeof (struct s) - 1;
            nbytes -= nbytes % sizeof (struct s);
            struct s *p = malloc (nbytes);
            p->p = p;
            p->m = NULL;
            p->d[0] = 0.0;
            return p->d != (double *) NULL;]])],
       [ac_cv_c_flexmember=yes],
       [ac_cv_c_flexmember=no])])
  if test $ac_cv_c_flexmember = yes; then
    AC_DEFINE([FLEXIBLE_ARRAY_MEMBER], [],
      [Define to nothing if C supports flexible array members, and to
       1 if it does not.  That way, with a declaration like 'struct s
       { int n; double d@<:@FLEXIBLE_ARRAY_MEMBER@:>@; };', the struct hack
       can be used with pre-C99 compilers.
       When computing the size of such an object, don't use 'sizeof (struct s)'
       as it overestimates the size.  Use 'offsetof (struct s, d)' instead.
       Don't use 'offsetof (struct s, d@<:@0@:>@)', as this doesn't work with
       MSVC and with C++ compilers.])
  else
    AC_DEFINE([FLEXIBLE_ARRAY_MEMBER], [1])
  fi
])

# float_h.m4 serial 12
dnl Copyright (C) 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FLOAT_H],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST])
  FLOAT_H=
  REPLACE_FLOAT_LDBL=0
  case "$host_os" in
    aix* | beos* | openbsd* | mirbsd* | irix*)
      FLOAT_H=float.h
      ;;
    freebsd* | dragonfly*)
      case "$host_cpu" in
changequote(,)dnl
        i[34567]86 )
changequote([,])dnl
          FLOAT_H=float.h
          ;;
        x86_64 )
          # On x86_64 systems, the C compiler may still be generating
          # 32-bit code.
          AC_COMPILE_IFELSE(
            [AC_LANG_SOURCE(
               [[#if defined __LP64__ || defined __x86_64__ || defined __amd64__
                  int ok;
                 #else
                  error fail
                 #endif
               ]])],
            [],
            [FLOAT_H=float.h])
          ;;
      esac
      ;;
    linux*)
      case "$host_cpu" in
        powerpc*)
          FLOAT_H=float.h
          ;;
      esac
      ;;
  esac
  case "$host_os" in
    aix* | freebsd* | dragonfly* | linux*)
      if test -n "$FLOAT_H"; then
        REPLACE_FLOAT_LDBL=1
      fi
      ;;
  esac

  dnl Test against glibc-2.7 Linux/SPARC64 bug.
  REPLACE_ITOLD=0
  AC_CACHE_CHECK([whether conversion from 'int' to 'long double' works],
    [gl_cv_func_itold_works],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
int i = -1;
volatile long double ld;
int main ()
{
  ld += i * 1.0L;
  if (ld > 0)
    return 1;
  return 0;
}]])],
        [gl_cv_func_itold_works=yes],
        [gl_cv_func_itold_works=no],
        [case "$host" in
           sparc*-*-linux*)
             AC_COMPILE_IFELSE(
               [AC_LANG_SOURCE(
                 [[#if defined __LP64__ || defined __arch64__
                    int ok;
                   #else
                    error fail
                   #endif
                 ]])],
               [gl_cv_func_itold_works="guessing no"],
               [gl_cv_func_itold_works="guessing yes"])
             ;;
                   # Guess yes on native Windows.
           mingw*) gl_cv_func_itold_works="guessing yes" ;;
           *)      gl_cv_func_itold_works="guessing yes" ;;
         esac
        ])
    ])
  case "$gl_cv_func_itold_works" in
    *no)
      REPLACE_ITOLD=1
      dnl We add the workaround to <float.h> but also to <math.h>,
      dnl to increase the chances that the fix function gets pulled in.
      FLOAT_H=float.h
      ;;
  esac

  if test -n "$FLOAT_H"; then
    gl_NEXT_HEADERS([float.h])
  fi
  AC_SUBST([FLOAT_H])
  AM_CONDITIONAL([GL_GENERATE_FLOAT_H], [test -n "$FLOAT_H"])
  AC_SUBST([REPLACE_ITOLD])
])

# fstat.m4 serial 6
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_FSTAT],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])

  case "$host_os" in
    mingw* | solaris*)
      dnl On MinGW, the original stat() returns st_atime, st_mtime,
      dnl st_ctime values that are affected by the time zone.
      dnl Solaris stat can return a negative tv_nsec.
      REPLACE_FSTAT=1
      ;;
  esac

  dnl Replace fstat() for supporting the gnulib-defined open() on directories.
  m4_ifdef([gl_FUNC_FCHDIR], [
    gl_TEST_FCHDIR
    if test $HAVE_FCHDIR = 0; then
      case "$gl_cv_func_open_directory_works" in
        *yes) ;;
        *)
          REPLACE_FSTAT=1
          ;;
      esac
    fi
  ])
])

# Prerequisites of lib/fstat.c and lib/stat-w32.c.
AC_DEFUN([gl_PREREQ_FSTAT], [
  AC_REQUIRE([gl_HEADER_SYS_STAT_H])
  :
])

# fstatat.m4 serial 4
dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

# If we have the fstatat function, and it has the bug (in AIX 7.1)
# that it does not fill in st_size correctly, use the replacement function.
AC_DEFUN([gl_FUNC_FSTATAT],
[
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([fstatat])

  if test $ac_cv_func_fstatat = no; then
    HAVE_FSTATAT=0
  else
    dnl Test for an AIX 7.1 bug; see
    dnl <https://lists.gnu.org/r/bug-tar/2011-09/msg00015.html>.
    AC_CACHE_CHECK([whether fstatat (..., 0) works],
      [gl_cv_func_fstatat_zero_flag],
      [AC_RUN_IFELSE(
         [AC_LANG_SOURCE(
            [[
              #include <fcntl.h>
              #include <sys/stat.h>
              int
              main (void)
              {
                struct stat a;
                return fstatat (AT_FDCWD, ".", &a, 0) != 0;
              }
            ]])],
         [gl_cv_func_fstatat_zero_flag=yes],
         [gl_cv_func_fstatat_zero_flag=no],
         [case "$host_os" in
            aix*) gl_cv_func_fstatat_zero_flag="guessing no";;
            *)    gl_cv_func_fstatat_zero_flag="guessing yes";;
          esac
         ])
      ])

    case $gl_cv_func_fstatat_zero_flag+$gl_cv_func_lstat_dereferences_slashed_symlink in
    *yes+*yes) ;;
    *) REPLACE_FSTATAT=1 ;;
    esac

    case $host_os in
      solaris*)
        REPLACE_FSTATAT=1 ;;
    esac

    case $REPLACE_FSTATAT,$gl_cv_func_fstatat_zero_flag in
      1,*yes)
         AC_DEFINE([HAVE_WORKING_FSTATAT_ZERO_FLAG], [1],
           [Define to 1 if fstatat (..., 0) works.
            For example, it does not work in AIX 7.1.])
         ;;
    esac
  fi
])

# getcwd.m4 - check for working getcwd that is compatible with glibc

# Copyright (C) 2001, 2003-2007, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Written by Paul Eggert.
# serial 15

AC_DEFUN([gl_FUNC_GETCWD_NULL],
  [
   AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
   AC_CHECK_HEADERS_ONCE([unistd.h])
   AC_CACHE_CHECK([whether getcwd (NULL, 0) allocates memory for result],
     [gl_cv_func_getcwd_null],
     [AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#	 include <stdlib.h>
#        if HAVE_UNISTD_H
#         include <unistd.h>
#        else /* on Windows with MSVC */
#         include <direct.h>
#        endif
#        ifndef getcwd
         char *getcwd ();
#        endif
]], [[
#if (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
/* mingw cwd does not start with '/', but getcwd does allocate.
   However, mingw fails to honor non-zero size.  */
#else
           if (chdir ("/") != 0)
             return 1;
           else
             {
               char *f = getcwd (NULL, 0);
               if (! f)
                 return 2;
               if (f[0] != '/')
                 { free (f); return 3; }
               if (f[1] != '\0')
                 { free (f); return 4; }
               free (f);
               return 0;
             }
#endif
         ]])],
        [gl_cv_func_getcwd_null=yes],
        [gl_cv_func_getcwd_null=no],
        [[case "$host_os" in
                           # Guess yes on glibc systems.
            *-gnu* | gnu*) gl_cv_func_getcwd_null="guessing yes";;
                           # Guess yes on Cygwin.
            cygwin*)       gl_cv_func_getcwd_null="guessing yes";;
                           # If we don't know, assume the worst.
            *)             gl_cv_func_getcwd_null="guessing no";;
          esac
        ]])])
])

AC_DEFUN([gl_FUNC_GETCWD_SIGNATURE],
[
  AC_CACHE_CHECK([for getcwd with POSIX signature],
    [gl_cv_func_getcwd_posix_signature],
    [AC_COMPILE_IFELSE(
      [AC_LANG_PROGRAM(
         [[#include <unistd.h>]],
         [[extern
           #ifdef __cplusplus
           "C"
           #endif
           char *getcwd (char *, size_t);
         ]])
      ],
      [gl_cv_func_getcwd_posix_signature=yes],
      [gl_cv_func_getcwd_posix_signature=no])
   ])
])

dnl Guarantee that getcwd will malloc with a NULL first argument.  Assumes
dnl that either the system getcwd is robust, or that calling code is okay
dnl with spurious failures when run from a directory with an absolute name
dnl larger than 4k bytes.
dnl
dnl Assumes that getcwd exists; if you are worried about obsolete
dnl platforms that lacked getcwd(), then you need to use the GPL module.
AC_DEFUN([gl_FUNC_GETCWD_LGPL],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_GETCWD_NULL])
  AC_REQUIRE([gl_FUNC_GETCWD_SIGNATURE])

  case $gl_cv_func_getcwd_null,$gl_cv_func_getcwd_posix_signature in
  *yes,yes) ;;
  *)
    dnl Minimal replacement lib/getcwd-lgpl.c.
    REPLACE_GETCWD=1
    ;;
  esac
])

dnl Check for all known getcwd bugs; useful for a program likely to be
dnl executed from an arbitrary location.
AC_DEFUN([gl_FUNC_GETCWD],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_GETCWD_NULL])
  AC_REQUIRE([gl_FUNC_GETCWD_SIGNATURE])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  gl_abort_bug=no
  case "$host_os" in
    mingw*)
      gl_cv_func_getcwd_path_max=yes
      ;;
    *)
      gl_FUNC_GETCWD_PATH_MAX
      case "$gl_cv_func_getcwd_null" in
        *yes)
          gl_FUNC_GETCWD_ABORT_BUG([gl_abort_bug=yes])
          ;;
      esac
      ;;
  esac
  dnl Define HAVE_MINIMALLY_WORKING_GETCWD and HAVE_PARTLY_WORKING_GETCWD
  dnl if appropriate.
  case "$gl_cv_func_getcwd_path_max" in
    "no"|"no, it has the AIX bug") ;;
    *)
      AC_DEFINE([HAVE_MINIMALLY_WORKING_GETCWD], [1],
        [Define to 1 if getcwd minimally works, that is, its result can be
         trusted when it succeeds.])
      ;;
  esac
  case "$gl_cv_func_getcwd_path_max" in
    "no, but it is partly working")
      AC_DEFINE([HAVE_PARTLY_WORKING_GETCWD], [1],
        [Define to 1 if getcwd works, except it sometimes fails when it
         shouldn't, setting errno to ERANGE, ENAMETOOLONG, or ENOENT.])
      ;;
    "yes, but with shorter paths")
      AC_DEFINE([HAVE_GETCWD_SHORTER], [1],
        [Define to 1 if getcwd works, but with shorter paths
         than is generally tested with the replacement.])
      ;;
  esac

  if { case "$gl_cv_func_getcwd_null" in *yes) false;; *) true;; esac; } \
     || test $gl_cv_func_getcwd_posix_signature != yes \
     || { case "$gl_cv_func_getcwd_path_max" in *yes*) false;; *) true;; esac; } \
     || test $gl_abort_bug = yes; then
    REPLACE_GETCWD=1
  fi
])

# Prerequisites of lib/getcwd.c, when full replacement is in effect.
AC_DEFUN([gl_PREREQ_GETCWD],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_CHECK_TYPE_STRUCT_DIRENT_D_INO])
  :
])

# getdtablesize.m4 serial 7
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_GETDTABLESIZE],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([getdtablesize])
  AC_CHECK_DECLS_ONCE([getdtablesize])
  if test $ac_cv_func_getdtablesize = yes &&
     test $ac_cv_have_decl_getdtablesize = yes; then
    AC_CACHE_CHECK([whether getdtablesize works],
      [gl_cv_func_getdtablesize_works],
      [dnl There are two concepts: the "maximum possible file descriptor value + 1"
       dnl and the "maximum number of open file descriptors in a process".
       dnl Per SUSv2 and POSIX, getdtablesize() should return the first one.
       dnl On most platforms, the first and the second concept are the same.
       dnl On OpenVMS, however, they are different and getdtablesize() returns
       dnl the second one; thus the test below fails. But we don't care
       dnl because there's no good way to write a replacement getdtablesize().
       case "$host_os" in
         vms*) gl_cv_func_getdtablesize_works="no (limitation)" ;;
         *)
           dnl Cygwin 1.7.25 automatically increases the RLIMIT_NOFILE soft
           dnl limit up to an unchangeable hard limit; all other platforms
           dnl correctly require setrlimit before getdtablesize() can report
           dnl a larger value.
           AC_RUN_IFELSE([
             AC_LANG_PROGRAM([[#include <unistd.h>]],
               [int size = getdtablesize();
                if (dup2 (0, getdtablesize()) != -1)
                  return 1;
                if (size != getdtablesize())
                  return 2;
               ])],
             [gl_cv_func_getdtablesize_works=yes],
             [gl_cv_func_getdtablesize_works=no],
             [case "$host_os" in
                cygwin*) # on cygwin 1.5.25, getdtablesize() automatically grows
                  gl_cv_func_getdtablesize_works="guessing no" ;;
                *) gl_cv_func_getdtablesize_works="guessing yes" ;;
              esac
             ])
           ;;
       esac
      ])
    case "$gl_cv_func_getdtablesize_works" in
      *yes | "no (limitation)") ;;
      *) REPLACE_GETDTABLESIZE=1 ;;
    esac
  else
    HAVE_GETDTABLESIZE=0
  fi
])

# Prerequisites of lib/getdtablesize.c.
AC_DEFUN([gl_PREREQ_GETDTABLESIZE], [:])

# serial 20

dnl From Jim Meyering.
dnl A wrapper around AC_FUNC_GETGROUPS.

# Copyright (C) 1996-1997, 1999-2004, 2008-2018 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

m4_version_prereq([2.70], [] ,[

# This is taken from the following Autoconf patch:
# https://git.savannah.gnu.org/gitweb/?p=autoconf.git;a=commitdiff;h=7fbb553727ed7e0e689a17594b58559ecf3ea6e9
AC_DEFUN([AC_FUNC_GETGROUPS],
[
  AC_REQUIRE([AC_TYPE_GETGROUPS])dnl
  AC_REQUIRE([AC_TYPE_SIZE_T])dnl
  AC_REQUIRE([AC_CANONICAL_HOST])dnl for cross-compiles
  AC_CHECK_FUNC([getgroups])

  # If we don't yet have getgroups, see if it's in -lbsd.
  # This is reported to be necessary on an ITOS 3000WS running SEIUX 3.1.
  ac_save_LIBS=$LIBS
  if test $ac_cv_func_getgroups = no; then
    AC_CHECK_LIB(bsd, getgroups, [GETGROUPS_LIB=-lbsd])
  fi

  # Run the program to test the functionality of the system-supplied
  # getgroups function only if there is such a function.
  if test $ac_cv_func_getgroups = yes; then
    AC_CACHE_CHECK([for working getgroups], [ac_cv_func_getgroups_works],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
            [AC_INCLUDES_DEFAULT],
            [[/* On Ultrix 4.3, getgroups (0, 0) always fails.  */
              return getgroups (0, 0) == -1;]])
         ],
         [ac_cv_func_getgroups_works=yes],
         [ac_cv_func_getgroups_works=no],
         [case "$host_os" in # ((
                           # Guess yes on glibc systems.
            *-gnu* | gnu*) ac_cv_func_getgroups_works="guessing yes" ;;
                           # If we don't know, assume the worst.
            *)             ac_cv_func_getgroups_works="guessing no" ;;
          esac
         ])
      ])
  else
    ac_cv_func_getgroups_works=no
  fi
  case "$ac_cv_func_getgroups_works" in
    *yes)
      AC_DEFINE([HAVE_GETGROUPS], [1],
        [Define to 1 if your system has a working `getgroups' function.])
      ;;
  esac
  LIBS=$ac_save_LIBS
])# AC_FUNC_GETGROUPS

])

AC_DEFUN([gl_FUNC_GETGROUPS],
[
  AC_REQUIRE([AC_TYPE_GETGROUPS])
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_FUNC_GETGROUPS
  if test $ac_cv_func_getgroups != yes; then
    HAVE_GETGROUPS=0
  else
    if test "$ac_cv_type_getgroups" != gid_t \
       || { case "$ac_cv_func_getgroups_works" in
              *yes) false;;
              *) true;;
            esac
          }; then
      REPLACE_GETGROUPS=1
      AC_DEFINE([GETGROUPS_ZERO_BUG], [1], [Define this to 1 if
        getgroups(0,NULL) does not return the number of groups.])
    else
      dnl Detect FreeBSD bug; POSIX requires getgroups(-1,ptr) to fail.
      AC_CACHE_CHECK([whether getgroups handles negative values],
        [gl_cv_func_getgroups_works],
        [AC_RUN_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT],
          [[int size = getgroups (0, 0);
            gid_t *list = malloc (size * sizeof *list);
            int result = getgroups (-1, list) != -1;
            free (list);
            return result;]])],
          [gl_cv_func_getgroups_works=yes],
          [gl_cv_func_getgroups_works=no],
          [case "$host_os" in
                            # Guess yes on glibc systems.
             *-gnu* | gnu*) gl_cv_func_getgroups_works="guessing yes" ;;
                            # If we don't know, assume the worst.
             *)             gl_cv_func_getgroups_works="guessing no" ;;
           esac
          ])])
      case "$gl_cv_func_getgroups_works" in
        *yes) ;;
        *) REPLACE_GETGROUPS=1 ;;
      esac
    fi
  fi
  test -n "$GETGROUPS_LIB" && LIBS="$GETGROUPS_LIB $LIBS"
])

# getopt.m4 serial 46
dnl Copyright (C) 2002-2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Request a POSIX compliant getopt function.
AC_DEFUN([gl_FUNC_GETOPT_POSIX],
[
  m4_divert_text([DEFAULTS], [gl_getopt_required=POSIX])
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_GETOPT_CHECK_HEADERS])
  dnl Other modules can request the gnulib implementation of the getopt
  dnl functions unconditionally, by defining gl_REPLACE_GETOPT_ALWAYS.
  dnl argp.m4 does this.
  m4_ifdef([gl_REPLACE_GETOPT_ALWAYS], [
    REPLACE_GETOPT=1
  ], [
    REPLACE_GETOPT=0
    if test -n "$gl_replace_getopt"; then
      REPLACE_GETOPT=1
    fi
  ])
  if test $REPLACE_GETOPT = 1; then
    dnl Arrange for getopt.h to be created.
    gl_GETOPT_SUBSTITUTE_HEADER
  fi
])

# Request a POSIX compliant getopt function with GNU extensions (such as
# options with optional arguments) and the functions getopt_long,
# getopt_long_only.
AC_DEFUN([gl_FUNC_GETOPT_GNU],
[
  dnl Set the variable gl_getopt_required, so that all invocations of
  dnl gl_GETOPT_CHECK_HEADERS in the scope of the current configure file
  dnl will check for getopt with GNU extensions.
  dnl This means that if one gnulib-tool invocation requests getopt-posix
  dnl and another gnulib-tool invocation requests getopt-gnu, it is as if
  dnl both had requested getopt-gnu.
  m4_divert_text([INIT_PREPARE], [gl_getopt_required=GNU])

  dnl No need to invoke gl_FUNC_GETOPT_POSIX here; this is automatically
  dnl done through the module dependency getopt-gnu -> getopt-posix.
])

# Determine whether to replace the entire getopt facility.
AC_DEFUN([gl_GETOPT_CHECK_HEADERS],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([AC_PROG_AWK]) dnl for awk that supports ENVIRON

  dnl Persuade Solaris <unistd.h> to declare optarg, optind, opterr, optopt.
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  gl_CHECK_NEXT_HEADERS([getopt.h])
  if test $ac_cv_header_getopt_h = yes; then
    HAVE_GETOPT_H=1
  else
    HAVE_GETOPT_H=0
  fi
  AC_SUBST([HAVE_GETOPT_H])

  gl_replace_getopt=

  dnl Test whether <getopt.h> is available.
  if test -z "$gl_replace_getopt" && test $gl_getopt_required = GNU; then
    AC_CHECK_HEADERS([getopt.h], [], [gl_replace_getopt=yes])
  fi

  dnl Test whether the function getopt_long is available.
  if test -z "$gl_replace_getopt" && test $gl_getopt_required = GNU; then
    AC_CHECK_FUNCS([getopt_long_only], [], [gl_replace_getopt=yes])
  fi

  dnl POSIX 2008 does not specify leading '+' behavior, but see
  dnl http://austingroupbugs.net/view.php?id=191 for a recommendation on
  dnl the next version of POSIX.  For now, we only guarantee leading '+'
  dnl behavior with getopt-gnu.
  if test -z "$gl_replace_getopt"; then
    AC_CACHE_CHECK([whether getopt is POSIX compatible],
      [gl_cv_func_getopt_posix],
      [
        dnl Merging these three different test programs into a single one
        dnl would require a reset mechanism. On BSD systems, it can be done
        dnl through 'optreset'; on some others (glibc), it can be done by
        dnl setting 'optind' to 0; on others again (HP-UX, IRIX, OSF/1,
        dnl Solaris 9, musl libc), there is no such mechanism.
        if test $cross_compiling = no; then
          dnl Sanity check. Succeeds everywhere (except on MSVC,
          dnl which lacks <unistd.h> and getopt() entirely).
          AC_RUN_IFELSE(
            [AC_LANG_SOURCE([[
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int
main ()
{
  static char program[] = "program";
  static char a[] = "-a";
  static char foo[] = "foo";
  static char bar[] = "bar";
  char *argv[] = { program, a, foo, bar, NULL };
  int c;

  c = getopt (4, argv, "ab");
  if (!(c == 'a'))
    return 1;
  c = getopt (4, argv, "ab");
  if (!(c == -1))
    return 2;
  if (!(optind == 2))
    return 3;
  return 0;
}
]])],
            [gl_cv_func_getopt_posix=maybe],
            [gl_cv_func_getopt_posix=no])
          if test $gl_cv_func_getopt_posix = maybe; then
            dnl Sanity check with '+'. Succeeds everywhere (except on MSVC,
            dnl which lacks <unistd.h> and getopt() entirely).
            AC_RUN_IFELSE(
              [AC_LANG_SOURCE([[
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int
main ()
{
  static char program[] = "program";
  static char donald[] = "donald";
  static char p[] = "-p";
  static char billy[] = "billy";
  static char duck[] = "duck";
  static char a[] = "-a";
  static char bar[] = "bar";
  char *argv[] = { program, donald, p, billy, duck, a, bar, NULL };
  int c;

  c = getopt (7, argv, "+abp:q:");
  if (!(c == -1))
    return 4;
  if (!(strcmp (argv[0], "program") == 0))
    return 5;
  if (!(strcmp (argv[1], "donald") == 0))
    return 6;
  if (!(strcmp (argv[2], "-p") == 0))
    return 7;
  if (!(strcmp (argv[3], "billy") == 0))
    return 8;
  if (!(strcmp (argv[4], "duck") == 0))
    return 9;
  if (!(strcmp (argv[5], "-a") == 0))
    return 10;
  if (!(strcmp (argv[6], "bar") == 0))
    return 11;
  if (!(optind == 1))
    return 12;
  return 0;
}
]])],
              [gl_cv_func_getopt_posix=maybe],
              [gl_cv_func_getopt_posix=no])
          fi
          if test $gl_cv_func_getopt_posix = maybe; then
            dnl Detect Mac OS X 10.5, AIX 7.1, mingw bug.
            AC_RUN_IFELSE(
              [AC_LANG_SOURCE([[
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int
main ()
{
  static char program[] = "program";
  static char ab[] = "-ab";
  char *argv[3] = { program, ab, NULL };
  if (getopt (2, argv, "ab:") != 'a')
    return 13;
  if (getopt (2, argv, "ab:") != '?')
    return 14;
  if (optopt != 'b')
    return 15;
  if (optind != 2)
    return 16;
  return 0;
}
]])],
              [gl_cv_func_getopt_posix=yes],
              [gl_cv_func_getopt_posix=no])
          fi
        else
          case "$host_os" in
            darwin* | aix* | mingw*) gl_cv_func_getopt_posix="guessing no";;
            *)                       gl_cv_func_getopt_posix="guessing yes";;
          esac
        fi
      ])
    case "$gl_cv_func_getopt_posix" in
      *no) gl_replace_getopt=yes ;;
    esac
  fi

  if test -z "$gl_replace_getopt" && test $gl_getopt_required = GNU; then
    AC_CACHE_CHECK([for working GNU getopt function], [gl_cv_func_getopt_gnu],
      [# Even with POSIXLY_CORRECT, the GNU extension of leading '-' in the
       # optstring is necessary for programs like m4 that have POSIX-mandated
       # semantics for supporting options interspersed with files.
       # Also, since getopt_long is a GNU extension, we require optind=0.
       # Bash ties 'set -o posix' to a non-exported POSIXLY_CORRECT;
       # so take care to revert to the correct (non-)export state.
dnl GNU Coding Standards currently allow awk but not env; besides, env
dnl is ambiguous with environment values that contain newlines.
       gl_awk_probe='BEGIN { if ("POSIXLY_CORRECT" in ENVIRON) print "x" }'
       case ${POSIXLY_CORRECT+x}`$AWK "$gl_awk_probe" </dev/null` in
         xx) gl_had_POSIXLY_CORRECT=exported ;;
         x)  gl_had_POSIXLY_CORRECT=yes      ;;
         *)  gl_had_POSIXLY_CORRECT=         ;;
       esac
       POSIXLY_CORRECT=1
       export POSIXLY_CORRECT
       AC_RUN_IFELSE(
        [AC_LANG_PROGRAM([[#include <getopt.h>
                           #include <stddef.h>
                           #include <string.h>
           ]GL_NOCRASH[
           ]], [[
             int result = 0;

             nocrash_init();

             /* This code succeeds on glibc 2.8, OpenBSD 4.0, Cygwin, mingw,
                and fails on Mac OS X 10.5, AIX 5.2, HP-UX 11, IRIX 6.5,
                OSF/1 5.1, Solaris 10.  */
             {
               static char conftest[] = "conftest";
               static char plus[] = "-+";
               char *argv[3] = { conftest, plus, NULL };
               opterr = 0;
               if (getopt (2, argv, "+a") != '?')
                 result |= 1;
             }
             /* This code succeeds on glibc 2.8, mingw,
                and fails on Mac OS X 10.5, OpenBSD 4.0, AIX 5.2, HP-UX 11,
                IRIX 6.5, OSF/1 5.1, Solaris 10, Cygwin 1.5.x.  */
             {
               static char program[] = "program";
               static char p[] = "-p";
               static char foo[] = "foo";
               static char bar[] = "bar";
               char *argv[] = { program, p, foo, bar, NULL };

               optind = 1;
               if (getopt (4, argv, "p::") != 'p')
                 result |= 2;
               else if (optarg != NULL)
                 result |= 4;
               else if (getopt (4, argv, "p::") != -1)
                 result |= 6;
               else if (optind != 2)
                 result |= 8;
             }
             /* This code succeeds on glibc 2.8 and fails on Cygwin 1.7.0.  */
             {
               static char program[] = "program";
               static char foo[] = "foo";
               static char p[] = "-p";
               char *argv[] = { program, foo, p, NULL };
               optind = 0;
               if (getopt (3, argv, "-p") != 1)
                 result |= 16;
               else if (getopt (3, argv, "-p") != 'p')
                 result |= 16;
             }
             /* This code fails on glibc 2.11.  */
             {
               static char program[] = "program";
               static char b[] = "-b";
               static char a[] = "-a";
               char *argv[] = { program, b, a, NULL };
               optind = opterr = 0;
               if (getopt (3, argv, "+:a:b") != 'b')
                 result |= 32;
               else if (getopt (3, argv, "+:a:b") != ':')
                 result |= 32;
             }
             /* This code dumps core on glibc 2.14.  */
             {
               static char program[] = "program";
               static char w[] = "-W";
               static char dummy[] = "dummy";
               char *argv[] = { program, w, dummy, NULL };
               optind = opterr = 1;
               if (getopt (3, argv, "W;") != 'W')
                 result |= 64;
             }
             return result;
           ]])],
        [gl_cv_func_getopt_gnu=yes],
        [gl_cv_func_getopt_gnu=no],
        [dnl Cross compiling. Assume the worst, even on glibc platforms.
         gl_cv_func_getopt_gnu="guessing no"
        ])
       case $gl_had_POSIXLY_CORRECT in
         exported) ;;
         yes) AS_UNSET([POSIXLY_CORRECT]); POSIXLY_CORRECT=1 ;;
         *) AS_UNSET([POSIXLY_CORRECT]) ;;
       esac
      ])
    if test "$gl_cv_func_getopt_gnu" != yes; then
      gl_replace_getopt=yes
    else
      AC_CACHE_CHECK([for working GNU getopt_long function],
        [gl_cv_func_getopt_long_gnu],
        [AC_RUN_IFELSE(
           [AC_LANG_PROGRAM(
              [[#include <getopt.h>
                #include <stddef.h>
                #include <string.h>
              ]],
              [[static const struct option long_options[] =
                  {
                    { "xtremely-",no_argument,       NULL, 1003 },
                    { "xtra",     no_argument,       NULL, 1001 },
                    { "xtreme",   no_argument,       NULL, 1002 },
                    { "xtremely", no_argument,       NULL, 1003 },
                    { NULL,       0,                 NULL, 0 }
                  };
                /* This code fails on OpenBSD 5.0.  */
                {
                  static char program[] = "program";
                  static char xtremel[] = "--xtremel";
                  char *argv[] = { program, xtremel, NULL };
                  int option_index;
                  optind = 1; opterr = 0;
                  if (getopt_long (2, argv, "", long_options, &option_index) != 1003)
                    return 1;
                }
                return 0;
              ]])],
           [gl_cv_func_getopt_long_gnu=yes],
           [gl_cv_func_getopt_long_gnu=no],
           [dnl Cross compiling. Guess no on OpenBSD, yes otherwise.
            case "$host_os" in
              openbsd*) gl_cv_func_getopt_long_gnu="guessing no";;
              *)        gl_cv_func_getopt_long_gnu="guessing yes";;
            esac
           ])
        ])
      case "$gl_cv_func_getopt_long_gnu" in
        *yes) ;;
        *) gl_replace_getopt=yes ;;
      esac
    fi
  fi
])

AC_DEFUN([gl_GETOPT_SUBSTITUTE_HEADER],
[
  AC_CHECK_HEADERS_ONCE([sys/cdefs.h])
  if test $ac_cv_header_sys_cdefs_h = yes; then
    HAVE_SYS_CDEFS_H=1
  else
    HAVE_SYS_CDEFS_H=0
  fi
  AC_SUBST([HAVE_SYS_CDEFS_H])

  AC_DEFINE([__GETOPT_PREFIX], [[rpl_]],
    [Define to rpl_ if the getopt replacement functions and variables
     should be used.])
  GETOPT_H=getopt.h
  GETOPT_CDEFS_H=getopt-cdefs.h
  AC_SUBST([GETOPT_H])
  AC_SUBST([GETOPT_CDEFS_H])
])

# getprogname.m4 - check for getprogname or replacements for it

# Copyright (C) 2016-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 4

AC_DEFUN([gl_FUNC_GETPROGNAME],
[
  AC_CHECK_FUNCS_ONCE([getprogname getexecname])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  ac_found=0
  AC_CHECK_DECLS([program_invocation_name], [ac_found=1], [],
    [#include <errno.h>])
  AC_CHECK_DECLS([program_invocation_short_name], [ac_found=1], [],
    [#include <errno.h>])
  AC_CHECK_DECLS([__argv], [ac_found=1], [], [#include <stdlib.h>])

  # Incur the cost of this test only if none of the above worked.
  if test $ac_found = 0; then
    # On OpenBSD 5.1, using the global __progname variable appears to be
    # the only way to implement getprogname.
    AC_CACHE_CHECK([whether __progname is defined in default libraries],
      [gl_cv_var___progname],
      [
        gl_cv_var___progname=
        AC_LINK_IFELSE(
          [AC_LANG_PROGRAM(
            [[extern char *__progname;]],
            [[return *__progname;]]
          )],
          [gl_cv_var___progname=yes]
        )
      ]
    )
    if test "$gl_cv_var___progname" = yes; then
      AC_DEFINE([HAVE_VAR___PROGNAME], 1,
        [Define if you have a global __progname variable])
    fi
  fi
])

# gettime.m4 serial 8
dnl Copyright (C) 2002, 2004-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_GETTIME],
[
  dnl Prerequisites of lib/gettime.c.
  AC_REQUIRE([gl_CLOCK_TIME])
  AC_REQUIRE([gl_TIMESPEC])
  AC_CHECK_FUNCS_ONCE([gettimeofday nanotime])
])

# serial 25

# Copyright (C) 2001-2003, 2005, 2007, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering.

AC_DEFUN([gl_FUNC_GETTIMEOFDAY],
[
  AC_REQUIRE([gl_HEADER_SYS_TIME_H_DEFAULTS])
  AC_REQUIRE([AC_C_RESTRICT])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_HEADER_SYS_TIME_H])
  AC_CHECK_FUNCS_ONCE([gettimeofday])

  gl_gettimeofday_timezone=void
  if test $ac_cv_func_gettimeofday != yes; then
    HAVE_GETTIMEOFDAY=0
  else
    gl_FUNC_GETTIMEOFDAY_CLOBBER
    AC_CACHE_CHECK([for gettimeofday with POSIX signature],
      [gl_cv_func_gettimeofday_posix_signature],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
            [[#include <sys/time.h>
              struct timeval c;
              int gettimeofday (struct timeval *restrict, void *restrict);
            ]],
            [[/* glibc uses struct timezone * rather than the POSIX void *
                 if _GNU_SOURCE is defined.  However, since the only portable
                 use of gettimeofday uses NULL as the second parameter, and
                 since the glibc definition is actually more typesafe, it is
                 not worth wrapping this to get a compliant signature.  */
              int (*f) (struct timeval *restrict, void *restrict)
                = gettimeofday;
              int x = f (&c, 0);
              return !(x | c.tv_sec | c.tv_usec);
            ]])],
          [gl_cv_func_gettimeofday_posix_signature=yes],
          [AC_COMPILE_IFELSE(
            [AC_LANG_PROGRAM(
              [[#include <sys/time.h>
int gettimeofday (struct timeval *restrict, struct timezone *restrict);
              ]])],
            [gl_cv_func_gettimeofday_posix_signature=almost],
            [gl_cv_func_gettimeofday_posix_signature=no])])])
    if test $gl_cv_func_gettimeofday_posix_signature = almost; then
      gl_gettimeofday_timezone='struct timezone'
    elif test $gl_cv_func_gettimeofday_posix_signature != yes; then
      REPLACE_GETTIMEOFDAY=1
    fi
    dnl If we override 'struct timeval', we also have to override gettimeofday.
    if test $REPLACE_STRUCT_TIMEVAL = 1; then
      REPLACE_GETTIMEOFDAY=1
    fi
    dnl On mingw, the original gettimeofday has only a precision of 15.6
    dnl milliseconds. So override it.
    case "$host_os" in
      mingw*) REPLACE_GETTIMEOFDAY=1 ;;
    esac
  fi
  AC_DEFINE_UNQUOTED([GETTIMEOFDAY_TIMEZONE], [$gl_gettimeofday_timezone],
    [Define this to 'void' or 'struct timezone' to match the system's
     declaration of the second argument to gettimeofday.])
])


dnl See if gettimeofday clobbers the static buffer that localtime uses
dnl for its return value.  The gettimeofday function from Mac OS X 10.0.4
dnl (i.e., Darwin 1.3.7) has this problem.
dnl
dnl If it does, then arrange to use gettimeofday and localtime only via
dnl the wrapper functions that work around the problem.

AC_DEFUN([gl_FUNC_GETTIMEOFDAY_CLOBBER],
[
 AC_REQUIRE([gl_HEADER_SYS_TIME_H])
 AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
 AC_REQUIRE([gl_LOCALTIME_BUFFER_DEFAULTS])

 AC_CACHE_CHECK([whether gettimeofday clobbers localtime buffer],
  [gl_cv_func_gettimeofday_clobber],
  [AC_RUN_IFELSE(
     [AC_LANG_PROGRAM(
        [[#include <string.h>
          #include <sys/time.h>
          #include <time.h>
          #include <stdlib.h>
        ]],
        [[
          time_t t = 0;
          struct tm *lt;
          struct tm saved_lt;
          struct timeval tv;
          lt = localtime (&t);
          saved_lt = *lt;
          gettimeofday (&tv, NULL);
          return memcmp (lt, &saved_lt, sizeof (struct tm)) != 0;
        ]])],
     [gl_cv_func_gettimeofday_clobber=no],
     [gl_cv_func_gettimeofday_clobber=yes],
     [# When cross-compiling:
      case "$host_os" in
                       # Guess all is fine on glibc systems.
        *-gnu* | gnu*) gl_cv_func_gettimeofday_clobber="guessing no" ;;
                       # Guess no on native Windows.
        mingw*)        gl_cv_func_gettimeofday_clobber="guessing no" ;;
                       # If we don't know, assume the worst.
        *)             gl_cv_func_gettimeofday_clobber="guessing yes" ;;
      esac
     ])])

 case "$gl_cv_func_gettimeofday_clobber" in
   *yes)
     REPLACE_GETTIMEOFDAY=1
     AC_DEFINE([GETTIMEOFDAY_CLOBBERS_LOCALTIME], [1],
       [Define if gettimeofday clobbers the localtime buffer.])
     gl_LOCALTIME_BUFFER_NEEDED
     ;;
 esac
])

# Prerequisites of lib/gettimeofday.c.
AC_DEFUN([gl_PREREQ_GETTIMEOFDAY], [:])

# glibc21.m4 serial 5
dnl Copyright (C) 2000-2002, 2004, 2008, 2010-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Test for the GNU C Library, version 2.1 or newer, or uClibc.
# From Bruno Haible.

AC_DEFUN([gl_GLIBC21],
  [
    AC_CACHE_CHECK([whether we are using the GNU C Library >= 2.1 or uClibc],
      [ac_cv_gnu_library_2_1],
      [AC_EGREP_CPP([Lucky],
        [
#include <features.h>
#ifdef __GNU_LIBRARY__
 #if (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 1) || (__GLIBC__ > 2)
  Lucky GNU user
 #endif
#endif
#ifdef __UCLIBC__
 Lucky user
#endif
        ],
        [ac_cv_gnu_library_2_1=yes],
        [ac_cv_gnu_library_2_1=no])
      ]
    )
    AC_SUBST([GLIBC21])
    GLIBC21="$ac_cv_gnu_library_2_1"
  ]
)

# gnulib-common.m4 serial 38
dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# gl_COMMON
# is expanded unconditionally through gnulib-tool magic.
AC_DEFUN([gl_COMMON], [
  dnl Use AC_REQUIRE here, so that the code is expanded once only.
  AC_REQUIRE([gl_00GNULIB])
  AC_REQUIRE([gl_COMMON_BODY])
])
AC_DEFUN([gl_COMMON_BODY], [
  AH_VERBATIM([_Noreturn],
[/* The _Noreturn keyword of C11.  */
#if ! (defined _Noreturn \
       || (defined __STDC_VERSION__ && 201112 <= __STDC_VERSION__))
# if (3 <= __GNUC__ || (__GNUC__ == 2 && 8 <= __GNUC_MINOR__) \
      || 0x5110 <= __SUNPRO_C)
#  define _Noreturn __attribute__ ((__noreturn__))
# elif defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn
# endif
#endif
])
  AH_VERBATIM([isoc99_inline],
[/* Work around a bug in Apple GCC 4.0.1 build 5465: In C99 mode, it supports
   the ISO C 99 semantics of 'extern inline' (unlike the GNU C semantics of
   earlier versions), but does not display it by setting __GNUC_STDC_INLINE__.
   __APPLE__ && __MACH__ test for Mac OS X.
   __APPLE_CC__ tests for the Apple compiler and its version.
   __STDC_VERSION__ tests for the C99 mode.  */
#if defined __APPLE__ && defined __MACH__ && __APPLE_CC__ >= 5465 && !defined __cplusplus && __STDC_VERSION__ >= 199901L && !defined __GNUC_STDC_INLINE__
# define __GNUC_STDC_INLINE__ 1
#endif])
  AH_VERBATIM([unused_parameter],
[/* Define as a marker that can be attached to declarations that might not
    be used.  This helps to reduce warnings, such as from
    GCC -Wunused-parameter.  */
#if __GNUC__ >= 3 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 7)
# define _GL_UNUSED __attribute__ ((__unused__))
#else
# define _GL_UNUSED
#endif
/* The name _UNUSED_PARAMETER_ is an earlier spelling, although the name
   is a misnomer outside of parameter lists.  */
#define _UNUSED_PARAMETER_ _GL_UNUSED

/* gcc supports the "unused" attribute on possibly unused labels, and
   g++ has since version 4.5.  Note to support C++ as well as C,
   _GL_UNUSED_LABEL should be used with a trailing ;  */
#if !defined __cplusplus || __GNUC__ > 4 \
    || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
# define _GL_UNUSED_LABEL _GL_UNUSED
#else
# define _GL_UNUSED_LABEL
#endif

/* The __pure__ attribute was added in gcc 2.96.  */
#if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 96)
# define _GL_ATTRIBUTE_PURE __attribute__ ((__pure__))
#else
# define _GL_ATTRIBUTE_PURE /* empty */
#endif

/* The __const__ attribute was added in gcc 2.95.  */
#if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 95)
# define _GL_ATTRIBUTE_CONST __attribute__ ((__const__))
#else
# define _GL_ATTRIBUTE_CONST /* empty */
#endif
])
  dnl Preparation for running test programs:
  dnl Tell glibc to write diagnostics from -D_FORTIFY_SOURCE=2 to stderr, not
  dnl to /dev/tty, so they can be redirected to log files.  Such diagnostics
  dnl arise e.g., in the macros gl_PRINTF_DIRECTIVE_N, gl_SNPRINTF_DIRECTIVE_N.
  LIBC_FATAL_STDERR_=1
  export LIBC_FATAL_STDERR_
])

# gl_MODULE_INDICATOR_CONDITION
# expands to a C preprocessor expression that evaluates to 1 or 0, depending
# whether a gnulib module that has been requested shall be considered present
# or not.
m4_define([gl_MODULE_INDICATOR_CONDITION], [1])

# gl_MODULE_INDICATOR_SET_VARIABLE([modulename])
# sets the shell variable that indicates the presence of the given module to
# a C preprocessor expression that will evaluate to 1.
AC_DEFUN([gl_MODULE_INDICATOR_SET_VARIABLE],
[
  gl_MODULE_INDICATOR_SET_VARIABLE_AUX(
    [GNULIB_[]m4_translit([[$1]],
                          [abcdefghijklmnopqrstuvwxyz./-],
                          [ABCDEFGHIJKLMNOPQRSTUVWXYZ___])],
    [gl_MODULE_INDICATOR_CONDITION])
])

# gl_MODULE_INDICATOR_SET_VARIABLE_AUX([variable])
# modifies the shell variable to include the gl_MODULE_INDICATOR_CONDITION.
# The shell variable's value is a C preprocessor expression that evaluates
# to 0 or 1.
AC_DEFUN([gl_MODULE_INDICATOR_SET_VARIABLE_AUX],
[
  m4_if(m4_defn([gl_MODULE_INDICATOR_CONDITION]), [1],
    [
     dnl Simplify the expression VALUE || 1 to 1.
     $1=1
    ],
    [gl_MODULE_INDICATOR_SET_VARIABLE_AUX_OR([$1],
                                             [gl_MODULE_INDICATOR_CONDITION])])
])

# gl_MODULE_INDICATOR_SET_VARIABLE_AUX_OR([variable], [condition])
# modifies the shell variable to include the given condition.  The shell
# variable's value is a C preprocessor expression that evaluates to 0 or 1.
AC_DEFUN([gl_MODULE_INDICATOR_SET_VARIABLE_AUX_OR],
[
  dnl Simplify the expression 1 || CONDITION to 1.
  if test "$[]$1" != 1; then
    dnl Simplify the expression 0 || CONDITION to CONDITION.
    if test "$[]$1" = 0; then
      $1=$2
    else
      $1="($[]$1 || $2)"
    fi
  fi
])

# gl_MODULE_INDICATOR([modulename])
# defines a C macro indicating the presence of the given module
# in a location where it can be used.
#                                             |  Value  |   Value   |
#                                             | in lib/ | in tests/ |
# --------------------------------------------+---------+-----------+
# Module present among main modules:          |    1    |     1     |
# --------------------------------------------+---------+-----------+
# Module present among tests-related modules: |    0    |     1     |
# --------------------------------------------+---------+-----------+
# Module not present at all:                  |    0    |     0     |
# --------------------------------------------+---------+-----------+
AC_DEFUN([gl_MODULE_INDICATOR],
[
  AC_DEFINE_UNQUOTED([GNULIB_]m4_translit([[$1]],
      [abcdefghijklmnopqrstuvwxyz./-],
      [ABCDEFGHIJKLMNOPQRSTUVWXYZ___]),
    [gl_MODULE_INDICATOR_CONDITION],
    [Define to a C preprocessor expression that evaluates to 1 or 0,
     depending whether the gnulib module $1 shall be considered present.])
])

# gl_MODULE_INDICATOR_FOR_TESTS([modulename])
# defines a C macro indicating the presence of the given module
# in lib or tests. This is useful to determine whether the module
# should be tested.
#                                             |  Value  |   Value   |
#                                             | in lib/ | in tests/ |
# --------------------------------------------+---------+-----------+
# Module present among main modules:          |    1    |     1     |
# --------------------------------------------+---------+-----------+
# Module present among tests-related modules: |    1    |     1     |
# --------------------------------------------+---------+-----------+
# Module not present at all:                  |    0    |     0     |
# --------------------------------------------+---------+-----------+
AC_DEFUN([gl_MODULE_INDICATOR_FOR_TESTS],
[
  AC_DEFINE([GNULIB_TEST_]m4_translit([[$1]],
      [abcdefghijklmnopqrstuvwxyz./-],
      [ABCDEFGHIJKLMNOPQRSTUVWXYZ___]), [1],
    [Define to 1 when the gnulib module $1 should be tested.])
])

# gl_ASSERT_NO_GNULIB_POSIXCHECK
# asserts that there will never be a need to #define GNULIB_POSIXCHECK.
# and thereby enables an optimization of configure and config.h.
# Used by Emacs.
AC_DEFUN([gl_ASSERT_NO_GNULIB_POSIXCHECK],
[
  dnl Override gl_WARN_ON_USE_PREPARE.
  dnl But hide this definition from 'aclocal'.
  AC_DEFUN([gl_W][ARN_ON_USE_PREPARE], [])
])

# gl_ASSERT_NO_GNULIB_TESTS
# asserts that there will be no gnulib tests in the scope of the configure.ac
# and thereby enables an optimization of config.h.
# Used by Emacs.
AC_DEFUN([gl_ASSERT_NO_GNULIB_TESTS],
[
  dnl Override gl_MODULE_INDICATOR_FOR_TESTS.
  AC_DEFUN([gl_MODULE_INDICATOR_FOR_TESTS], [])
])

# Test whether <features.h> exists.
# Set HAVE_FEATURES_H.
AC_DEFUN([gl_FEATURES_H],
[
  AC_CHECK_HEADERS_ONCE([features.h])
  if test $ac_cv_header_features_h = yes; then
    HAVE_FEATURES_H=1
  else
    HAVE_FEATURES_H=0
  fi
  AC_SUBST([HAVE_FEATURES_H])
])

# m4_foreach_w
# is a backport of autoconf-2.59c's m4_foreach_w.
# Remove this macro when we can assume autoconf >= 2.60.
m4_ifndef([m4_foreach_w],
  [m4_define([m4_foreach_w],
    [m4_foreach([$1], m4_split(m4_normalize([$2]), [ ]), [$3])])])

# AS_VAR_IF(VAR, VALUE, [IF-MATCH], [IF-NOT-MATCH])
# ----------------------------------------------------
# Backport of autoconf-2.63b's macro.
# Remove this macro when we can assume autoconf >= 2.64.
m4_ifndef([AS_VAR_IF],
[m4_define([AS_VAR_IF],
[AS_IF([test x"AS_VAR_GET([$1])" = x""$2], [$3], [$4])])])

# gl_PROG_CC_C99
# Modifies the value of the shell variable CC in an attempt to make $CC
# understand ISO C99 source code.
# This is like AC_PROG_CC_C99, except that
# - AC_PROG_CC_C99 did not exist in Autoconf versions < 2.60,
# - AC_PROG_CC_C99 does not mix well with AC_PROG_CC_STDC
#   <https://lists.gnu.org/r/bug-gnulib/2011-09/msg00367.html>,
#   but many more packages use AC_PROG_CC_STDC than AC_PROG_CC_C99
#   <https://lists.gnu.org/r/bug-gnulib/2011-09/msg00441.html>.
# Remaining problems:
# - When AC_PROG_CC_STDC is invoked twice, it adds the C99 enabling options
#   to CC twice
#   <https://lists.gnu.org/r/bug-gnulib/2011-09/msg00431.html>.
# - AC_PROG_CC_STDC is likely to change now that C11 is an ISO standard.
AC_DEFUN([gl_PROG_CC_C99],
[
  dnl Change that version number to the minimum Autoconf version that supports
  dnl mixing AC_PROG_CC_C99 calls with AC_PROG_CC_STDC calls.
  m4_version_prereq([9.0],
    [AC_REQUIRE([AC_PROG_CC_C99])],
    [AC_REQUIRE([AC_PROG_CC_STDC])])
])

# gl_PROG_AR_RANLIB
# Determines the values for AR, ARFLAGS, RANLIB that fit with the compiler.
# The user can set the variables AR, ARFLAGS, RANLIB if he wants to override
# the values.
AC_DEFUN([gl_PROG_AR_RANLIB],
[
  dnl Minix 3 comes with two toolchains: The Amsterdam Compiler Kit compiler
  dnl as "cc", and GCC as "gcc". They have different object file formats and
  dnl library formats. In particular, the GNU binutils programs ar and ranlib
  dnl produce libraries that work only with gcc, not with cc.
  AC_REQUIRE([AC_PROG_CC])
  dnl The '][' hides this use from 'aclocal'.
  AC_BEFORE([$0], [A][M_PROG_AR])
  AC_CACHE_CHECK([for Minix Amsterdam compiler], [gl_cv_c_amsterdam_compiler],
    [
      AC_EGREP_CPP([Amsterdam],
        [
#ifdef __ACK__
Amsterdam
#endif
        ],
        [gl_cv_c_amsterdam_compiler=yes],
        [gl_cv_c_amsterdam_compiler=no])
    ])

  dnl Don't compete with AM_PROG_AR's decision about AR/ARFLAGS if we are not
  dnl building with __ACK__.
  if test $gl_cv_c_amsterdam_compiler = yes; then
    if test -z "$AR"; then
      AR='cc -c.a'
    fi
    if test -z "$ARFLAGS"; then
      ARFLAGS='-o'
    fi
  else
    dnl AM_PROG_AR was added in automake v1.11.2.  AM_PROG_AR does not AC_SUBST
    dnl ARFLAGS variable (it is filed into Makefile.in directly by automake
    dnl script on-demand, if not specified by ./configure of course).
    dnl Don't AC_REQUIRE the AM_PROG_AR otherwise the code for __ACK__ above
    dnl will be ignored.  Also, pay attention to call AM_PROG_AR in else block
    dnl because AM_PROG_AR is written so it could re-set AR variable even for
    dnl __ACK__.  It may seem like its easier to avoid calling the macro here,
    dnl but we need to AC_SUBST both AR/ARFLAGS (thus those must have some good
    dnl default value and automake should usually know them).
    dnl
    dnl The '][' hides this use from 'aclocal'.
    m4_ifdef([A][M_PROG_AR], [A][M_PROG_AR], [:])
  fi

  dnl In case the code above has not helped with setting AR/ARFLAGS, use
  dnl Automake-documented default values for AR and ARFLAGS, but prefer
  dnl ${host}-ar over ar (useful for cross-compiling).
  AC_CHECK_TOOL([AR], [ar], [ar])
  if test -z "$ARFLAGS"; then
    ARFLAGS='cr'
  fi

  AC_SUBST([AR])
  AC_SUBST([ARFLAGS])
  if test -z "$RANLIB"; then
    if test $gl_cv_c_amsterdam_compiler = yes; then
      RANLIB=':'
    else
      dnl Use the ranlib program if it is available.
      AC_PROG_RANLIB
    fi
  fi
  AC_SUBST([RANLIB])
])

# AC_PROG_MKDIR_P
# is a backport of autoconf-2.60's AC_PROG_MKDIR_P, with a fix
# for interoperability with automake-1.9.6 from autoconf-2.62.
# Remove this macro when we can assume autoconf >= 2.62 or
# autoconf >= 2.60 && automake >= 1.10.
# AC_AUTOCONF_VERSION was introduced in 2.62, so use that as the witness.
m4_ifndef([AC_AUTOCONF_VERSION],[
m4_ifdef([AC_PROG_MKDIR_P], [
  dnl For automake-1.9.6 && autoconf < 2.62: Ensure MKDIR_P is AC_SUBSTed.
  m4_define([AC_PROG_MKDIR_P],
    m4_defn([AC_PROG_MKDIR_P])[
    AC_SUBST([MKDIR_P])])], [
  dnl For autoconf < 2.60: Backport of AC_PROG_MKDIR_P.
  AC_DEFUN_ONCE([AC_PROG_MKDIR_P],
    [AC_REQUIRE([AM_PROG_MKDIR_P])dnl defined by automake
     MKDIR_P='$(mkdir_p)'
     AC_SUBST([MKDIR_P])])])
])

# AC_C_RESTRICT
# This definition is copied from post-2.69 Autoconf and overrides the
# AC_C_RESTRICT macro from autoconf 2.60..2.69.  It can be removed
# once autoconf >= 2.70 can be assumed.  It's painful to check version
# numbers, and in practice this macro is more up-to-date than Autoconf
# is, so override Autoconf unconditionally.
AC_DEFUN([AC_C_RESTRICT],
[AC_CACHE_CHECK([for C/C++ restrict keyword], [ac_cv_c_restrict],
  [ac_cv_c_restrict=no
   # The order here caters to the fact that C++ does not require restrict.
   for ac_kw in __restrict __restrict__ _Restrict restrict; do
     AC_COMPILE_IFELSE(
      [AC_LANG_PROGRAM(
	 [[typedef int *int_ptr;
	   int foo (int_ptr $ac_kw ip) { return ip[0]; }
	   int bar (int [$ac_kw]); /* Catch GCC bug 14050.  */
	   int bar (int ip[$ac_kw]) { return ip[0]; }
	 ]],
	 [[int s[1];
	   int *$ac_kw t = s;
	   t[0] = 0;
	   return foo (t) + bar (t);
	 ]])],
      [ac_cv_c_restrict=$ac_kw])
     test "$ac_cv_c_restrict" != no && break
   done
  ])
 AH_VERBATIM([restrict],
[/* Define to the equivalent of the C99 'restrict' keyword, or to
   nothing if this is not supported.  Do not define if restrict is
   supported directly.  */
#undef restrict
/* Work around a bug in Sun C++: it does not support _Restrict or
   __restrict__, even though the corresponding Sun C compiler ends up with
   "#define restrict _Restrict" or "#define restrict __restrict__" in the
   previous line.  Perhaps some future version of Sun C++ will work with
   restrict; if so, hopefully it defines __RESTRICT like Sun C does.  */
#if defined __SUNPRO_CC && !defined __RESTRICT
# define _Restrict
# define __restrict__
#endif])
 case $ac_cv_c_restrict in
   restrict) ;;
   no) AC_DEFINE([restrict], []) ;;
   *)  AC_DEFINE_UNQUOTED([restrict], [$ac_cv_c_restrict]) ;;
 esac
])# AC_C_RESTRICT

# gl_BIGENDIAN
# is like AC_C_BIGENDIAN, except that it can be AC_REQUIREd.
# Note that AC_REQUIRE([AC_C_BIGENDIAN]) does not work reliably because some
# macros invoke AC_C_BIGENDIAN with arguments.
AC_DEFUN([gl_BIGENDIAN],
[
  AC_C_BIGENDIAN
])

# gl_CACHE_VAL_SILENT(cache-id, command-to-set-it)
# is like AC_CACHE_VAL(cache-id, command-to-set-it), except that it does not
# output a spurious "(cached)" mark in the midst of other configure output.
# This macro should be used instead of AC_CACHE_VAL when it is not surrounded
# by an AC_MSG_CHECKING/AC_MSG_RESULT pair.
AC_DEFUN([gl_CACHE_VAL_SILENT],
[
  saved_as_echo_n="$as_echo_n"
  as_echo_n=':'
  AC_CACHE_VAL([$1], [$2])
  as_echo_n="$saved_as_echo_n"
])

# AS_VAR_COPY was added in autoconf 2.63b
m4_define_default([AS_VAR_COPY],
[AS_LITERAL_IF([$1[]$2], [$1=$$2], [eval $1=\$$2])])

# AC_PROG_SED was added in autoconf 2.59b
m4_ifndef([AC_PROG_SED],
[AC_DEFUN([AC_PROG_SED],
[AC_CACHE_CHECK([for a sed that does not truncate output], ac_cv_path_SED,
    [dnl ac_script should not contain more than 99 commands (for HP-UX sed),
     dnl but more than about 7000 bytes, to catch a limit in Solaris 8 /usr/ucb/sed.
     ac_script=s/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb/
     for ac_i in 1 2 3 4 5 6 7; do
       ac_script="$ac_script$as_nl$ac_script"
     done
     echo "$ac_script" 2>/dev/null | sed 99q >conftest.sed
     AS_UNSET([ac_script])
     if test -z "$SED"; then
       ac_path_SED_found=false
       _AS_PATH_WALK([], [
         for ac_prog in sed gsed; do
           for ac_exec_ext in '' $ac_executable_extensions; do
             ac_path_SED="$as_dir/$ac_prog$ac_exec_ext"
             AS_EXECUTABLE_P(["$ac_path_SED"]) || continue
             case `"$ac_path_SED" --version 2>&1` in
               *GNU*) ac_cv_path_SED=$ac_path_SED ac_path_SED_found=:;;
               *)
                 ac_count=0
                 _AS_ECHO_N([0123456789]) >conftest.in
                 while :
                 do
                   cat conftest.in conftest.in >conftest.tmp
                   mv conftest.tmp conftest.in
                   cp conftest.in conftest.nl
                   echo >> conftest.nl
                   "$ac_path_SED" -f conftest.sed <conftest.nl >conftest.out 2>/dev/null || break
                   diff conftest.out conftest.nl >/dev/null 2>&1 || break
                   ac_count=`expr $ac_count + 1`
                   if test $ac_count -gt ${ac_path_SED_max-0}; then
                     # Best so far, but keep looking for better
                     ac_cv_path_SED=$ac_path_SED
                     ac_path_SED_max=$ac_count
                   fi
                   test $ac_count -gt 10 && break
                 done
                 rm -f conftest.in conftest.tmp conftest.nl conftest.out;;
             esac
             $ac_path_SED_found && break 3
           done
         done])
       if test -z "$ac_cv_path_SED"; then
         AC_ERROR([no acceptable sed could be found in \$PATH])
       fi
     else
       ac_cv_path_SED=$SED
     fi
    ])
 SED="$ac_cv_path_SED"
 AC_SUBST([SED])dnl
 rm -f conftest.sed
])
])

# DO NOT EDIT! GENERATED AUTOMATICALLY!
# Copyright (C) 2002-2018 Free Software Foundation, Inc.
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.
#
# As a special exception to the GNU General Public License,
# this file may be distributed as part of a program that
# contains a configuration script generated by Autoconf, under
# the same distribution terms as the rest of that program.
#
# Generated by gnulib-tool.
#
# This file represents the compiled summary of the specification in
# gnulib-cache.m4. It lists the computed macro invocations that need
# to be invoked from configure.ac.
# In projects that use version control, this file can be treated like
# other built files.


# This macro should be invoked from ./configure.ac, in the section
# "Checks for programs", right after AC_PROG_CC, and certainly before
# any checks for libraries, header files, types and library functions.
AC_DEFUN([gl_EARLY],
[
  m4_pattern_forbid([^gl_[A-Z]])dnl the gnulib macro namespace
  m4_pattern_allow([^gl_ES$])dnl a valid locale name
  m4_pattern_allow([^gl_LIBOBJS$])dnl a variable
  m4_pattern_allow([^gl_LTLIBOBJS$])dnl a variable

  # Pre-early section.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_PROG_AR_RANLIB])

  # Code from module absolute-header:
  # Code from module alloca-opt:
  # Code from module argmatch:
  # Code from module assure:
  # Code from module at-internal:
  # Code from module backupfile:
  # Code from module bitrotate:
  # Code from module c-ctype:
  # Code from module c-strcase:
  # Code from module c-strcaseeq:
  # Code from module canonicalize-lgpl:
  # Code from module chdir:
  # Code from module chdir-long:
  # Code from module chown:
  # Code from module clock-time:
  # Code from module cloexec:
  # Code from module close:
  # Code from module closedir:
  # Code from module configmake:
  # Code from module d-ino:
  # Code from module diffseq:
  # Code from module dirent:
  # Code from module dirent-safer:
  # Code from module dirfd:
  # Code from module dirname:
  # Code from module dirname-lgpl:
  # Code from module dosname:
  # Code from module double-slash-root:
  # Code from module dup2:
  # Code from module environ:
  # Code from module errno:
  # Code from module error:
  # Code from module euidaccess:
  # Code from module exitfail:
  # Code from module extensions:
  # Code from module extern-inline:
  # Code from module faccessat:
  # Code from module fchdir:
  # Code from module fchmodat:
  # Code from module fchownat:
  # Code from module fcntl:
  # Code from module fcntl-h:
  # Code from module fd-hook:
  # Code from module fd-safer-flag:
  # Code from module filename:
  # Code from module filenamecat-lgpl:
  # Code from module flexmember:
  # Code from module float:
  # Code from module fstat:
  # Code from module fstatat:
  # Code from module full-write:
  # Code from module getcwd-lgpl:
  # Code from module getdate:
  # Code from module getdtablesize:
  # Code from module getgroups:
  # Code from module getopt-gnu:
  # Code from module getopt-posix:
  # Code from module getprogname:
  # Code from module gettext-h:
  # Code from module gettime:
  # Code from module gettimeofday:
  # Code from module git-version-gen:
  # Code from module gitlog-to-changelog:
  # Code from module gnumakefile:
  # Code from module gnupload:
  # Code from module group-member:
  # Code from module hard-locale:
  # Code from module hash:
  # Code from module ignore-value:
  # Code from module include_next:
  # Code from module intprops:
  # Code from module inttypes:
  # Code from module inttypes-incomplete:
  # Code from module largefile:
  AC_REQUIRE([AC_SYS_LARGEFILE])
  # Code from module lchown:
  # Code from module limits-h:
  # Code from module linked-list:
  # Code from module list:
  # Code from module localcharset:
  # Code from module localtime-buffer:
  # Code from module lstat:
  # Code from module maintainer-makefile:
  # Code from module malloc:
  # Code from module malloc-gnu:
  # Code from module malloc-posix:
  # Code from module malloca:
  # Code from module manywarnings:
  # Code from module mbrtowc:
  # Code from module mbsinit:
  # Code from module memchr:
  # Code from module mempcpy:
  # Code from module memrchr:
  # Code from module minmax:
  # Code from module mkdir:
  # Code from module mkdirat:
  # Code from module mktime:
  # Code from module mktime-internal:
  # Code from module msvc-inval:
  # Code from module msvc-nothrow:
  # Code from module multiarch:
  # Code from module nocrash:
  # Code from module nstrftime:
  # Code from module open:
  # Code from module openat:
  # Code from module openat-die:
  # Code from module openat-h:
  # Code from module opendir:
  # Code from module parse-datetime:
  # Code from module pathmax:
  # Code from module progname:
  # Code from module quote:
  # Code from module quotearg:
  # Code from module quotearg-simple:
  # Code from module raise:
  # Code from module readdir:
  # Code from module readlink:
  # Code from module readlinkat:
  # Code from module realloc:
  # Code from module realloc-gnu:
  # Code from module realloc-posix:
  # Code from module rename:
  # Code from module renameat:
  # Code from module renameat2:
  # Code from module rmdir:
  # Code from module root-uid:
  # Code from module safe-write:
  # Code from module same-inode:
  # Code from module save-cwd:
  # Code from module setenv:
  # Code from module signal:
  # Code from module signal-h:
  # Code from module size_max:
  # Code from module snippet/_Noreturn:
  # Code from module snippet/arg-nonnull:
  # Code from module snippet/c++defs:
  # Code from module snippet/warn-on-use:
  # Code from module ssize_t:
  # Code from module stat:
  # Code from module stat-time:
  # Code from module statat:
  # Code from module stdarg:
  dnl Some compilers (e.g., AIX 5.3 cc) need to be in c99 mode
  dnl for the builtin va_copy to work.  With Autoconf 2.60 or later,
  dnl gl_PROG_CC_C99 arranges for this.  With older Autoconf gl_PROG_CC_C99
  dnl shouldn't hurt, though installers are on their own to set c99 mode.
  gl_PROG_CC_C99
  # Code from module stdbool:
  # Code from module stddef:
  # Code from module stdint:
  # Code from module stdio:
  # Code from module stdlib:
  # Code from module strdup-posix:
  # Code from module streq:
  # Code from module strerror:
  # Code from module strerror-override:
  # Code from module string:
  # Code from module strndup:
  # Code from module strnlen:
  # Code from module symlink:
  # Code from module symlinkat:
  # Code from module sys_stat:
  # Code from module sys_time:
  # Code from module sys_types:
  # Code from module tempname:
  # Code from module time:
  # Code from module time_r:
  # Code from module time_rz:
  # Code from module timegm:
  # Code from module timespec:
  # Code from module tzset:
  # Code from module unistd:
  # Code from module unistd-safer:
  # Code from module unlink:
  # Code from module unlinkat:
  # Code from module unsetenv:
  # Code from module update-copyright:
  # Code from module useless-if-before-free:
  # Code from module utime:
  # Code from module utime-h:
  # Code from module utimens:
  # Code from module utimensat:
  # Code from module vasnprintf:
  # Code from module vasprintf:
  # Code from module vc-list-files:
  # Code from module verify:
  # Code from module verror:
  # Code from module warnings:
  # Code from module wchar:
  # Code from module wctype-h:
  # Code from module write:
  # Code from module xalloc:
  # Code from module xalloc-die:
  # Code from module xalloc-oversized:
  # Code from module xlist:
  # Code from module xmemdup0:
  # Code from module xsize:
  # Code from module xstrndup:
  # Code from module xvasprintf:
])

# This macro should be invoked from ./configure.ac, in the section
# "Check for header files, types and library functions".
AC_DEFUN([gl_INIT],
[
  AM_CONDITIONAL([GL_COND_LIBTOOL], [false])
  gl_cond_libtool=false
  gl_libdeps=
  gl_ltlibdeps=
  gl_m4_base='m4'
  m4_pushdef([AC_LIBOBJ], m4_defn([gl_LIBOBJ]))
  m4_pushdef([AC_REPLACE_FUNCS], m4_defn([gl_REPLACE_FUNCS]))
  m4_pushdef([AC_LIBSOURCES], m4_defn([gl_LIBSOURCES]))
  m4_pushdef([gl_LIBSOURCES_LIST], [])
  m4_pushdef([gl_LIBSOURCES_DIR], [])
  gl_COMMON
  gl_source_base='lib'
  gl_FUNC_ALLOCA
  AC_LIBOBJ([openat-proc])
  gl_BACKUPFILE
  gl_CANONICALIZE_LGPL
  if test $HAVE_CANONICALIZE_FILE_NAME = 0 || test $REPLACE_CANONICALIZE_FILE_NAME = 1; then
    AC_LIBOBJ([canonicalize-lgpl])
  fi
  gl_MODULE_INDICATOR([canonicalize-lgpl])
  gl_STDLIB_MODULE_INDICATOR([canonicalize_file_name])
  gl_STDLIB_MODULE_INDICATOR([realpath])
  gl_UNISTD_MODULE_INDICATOR([chdir])
  gl_FUNC_CHDIR_LONG
  if test $gl_cv_have_arbitrary_file_name_length_limit = yes; then
    AC_LIBOBJ([chdir-long])
    gl_PREREQ_CHDIR_LONG
  fi
  gl_FUNC_CHOWN
  if test $HAVE_CHOWN = 0 || test $REPLACE_CHOWN = 1; then
    AC_LIBOBJ([chown])
  fi
  if test $REPLACE_CHOWN = 1 && test $ac_cv_func_fchown = no; then
    AC_LIBOBJ([fchown-stub])
  fi
  gl_UNISTD_MODULE_INDICATOR([chown])
  gl_CLOCK_TIME
  gl_MODULE_INDICATOR_FOR_TESTS([cloexec])
  gl_FUNC_CLOSE
  if test $REPLACE_CLOSE = 1; then
    AC_LIBOBJ([close])
  fi
  gl_UNISTD_MODULE_INDICATOR([close])
  gl_FUNC_CLOSEDIR
  if test $HAVE_CLOSEDIR = 0 || test $REPLACE_CLOSEDIR = 1; then
    AC_LIBOBJ([closedir])
  fi
  gl_DIRENT_MODULE_INDICATOR([closedir])
  gl_CONFIGMAKE_PREP
  gl_CHECK_TYPE_STRUCT_DIRENT_D_INO
  gl_DIRENT_H
  gl_DIRENT_SAFER
  gl_MODULE_INDICATOR([dirent-safer])
  gl_FUNC_DIRFD
  if test $ac_cv_func_dirfd = no && test $gl_cv_func_dirfd_macro = no \
     || test $REPLACE_DIRFD = 1; then
    AC_LIBOBJ([dirfd])
    gl_PREREQ_DIRFD
  fi
  gl_DIRENT_MODULE_INDICATOR([dirfd])
  gl_DIRNAME
  gl_MODULE_INDICATOR([dirname])
  gl_DIRNAME_LGPL
  gl_DOUBLE_SLASH_ROOT
  gl_FUNC_DUP2
  if test $HAVE_DUP2 = 0 || test $REPLACE_DUP2 = 1; then
    AC_LIBOBJ([dup2])
    gl_PREREQ_DUP2
  fi
  gl_UNISTD_MODULE_INDICATOR([dup2])
  gl_ENVIRON
  gl_UNISTD_MODULE_INDICATOR([environ])
  gl_HEADER_ERRNO_H
  gl_ERROR
  if test $ac_cv_lib_error_at_line = no; then
    AC_LIBOBJ([error])
    gl_PREREQ_ERROR
  fi
  m4_ifdef([AM_XGETTEXT_OPTION],
    [AM_][XGETTEXT_OPTION([--flag=error:3:c-format])
     AM_][XGETTEXT_OPTION([--flag=error_at_line:5:c-format])])
  gl_FUNC_EUIDACCESS
  if test $HAVE_EUIDACCESS = 0; then
    AC_LIBOBJ([euidaccess])
    gl_PREREQ_EUIDACCESS
  fi
  gl_UNISTD_MODULE_INDICATOR([euidaccess])
  AC_REQUIRE([gl_EXTERN_INLINE])
  gl_FUNC_FACCESSAT
  if test $HAVE_FACCESSAT = 0 || test $REPLACE_FACCESSAT = 1; then
    AC_LIBOBJ([faccessat])
    gl_PREREQ_FACCESSAT
  fi
  gl_MODULE_INDICATOR([faccessat])
  gl_UNISTD_MODULE_INDICATOR([faccessat])
  gl_FUNC_FCHDIR
  gl_UNISTD_MODULE_INDICATOR([fchdir])
  gl_FUNC_FCHMODAT
  if test $HAVE_FCHMODAT = 0; then
    AC_LIBOBJ([fchmodat])
  fi
  gl_MODULE_INDICATOR([fchmodat]) dnl for lib/openat.h
  gl_SYS_STAT_MODULE_INDICATOR([fchmodat])
  gl_FUNC_FCHOWNAT
  if test $HAVE_FCHOWNAT = 0 || test $REPLACE_FCHOWNAT = 1; then
    AC_LIBOBJ([fchownat])
  fi
  gl_MODULE_INDICATOR([fchownat]) dnl for lib/openat.h
  gl_UNISTD_MODULE_INDICATOR([fchownat])
  gl_FUNC_FCNTL
  if test $HAVE_FCNTL = 0 || test $REPLACE_FCNTL = 1; then
    AC_LIBOBJ([fcntl])
  fi
  gl_FCNTL_MODULE_INDICATOR([fcntl])
  gl_FCNTL_H
  gl_MODULE_INDICATOR([fd-safer-flag])
  gl_FILE_NAME_CONCAT_LGPL
  AC_C_FLEXIBLE_ARRAY_MEMBER
  gl_FLOAT_H
  if test $REPLACE_FLOAT_LDBL = 1; then
    AC_LIBOBJ([float])
  fi
  if test $REPLACE_ITOLD = 1; then
    AC_LIBOBJ([itold])
  fi
  gl_FUNC_FSTAT
  if test $REPLACE_FSTAT = 1; then
    AC_LIBOBJ([fstat])
    case "$host_os" in
      mingw*)
        AC_LIBOBJ([stat-w32])
        ;;
    esac
    gl_PREREQ_FSTAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([fstat])
  gl_FUNC_FSTATAT
  if test $HAVE_FSTATAT = 0 || test $REPLACE_FSTATAT = 1; then
    AC_LIBOBJ([fstatat])
  fi
  gl_SYS_STAT_MODULE_INDICATOR([fstatat])
  gl_FUNC_GETCWD_LGPL
  if test $REPLACE_GETCWD = 1; then
    AC_LIBOBJ([getcwd-lgpl])
  fi
  gl_UNISTD_MODULE_INDICATOR([getcwd])
  gl_FUNC_GETDTABLESIZE
  if test $HAVE_GETDTABLESIZE = 0 || test $REPLACE_GETDTABLESIZE = 1; then
    AC_LIBOBJ([getdtablesize])
    gl_PREREQ_GETDTABLESIZE
  fi
  gl_UNISTD_MODULE_INDICATOR([getdtablesize])
  gl_FUNC_GETGROUPS
  if test $HAVE_GETGROUPS = 0 || test $REPLACE_GETGROUPS = 1; then
    AC_LIBOBJ([getgroups])
  fi
  gl_UNISTD_MODULE_INDICATOR([getgroups])
  gl_FUNC_GETOPT_GNU
  dnl Because of the way gl_FUNC_GETOPT_GNU is implemented (the gl_getopt_required
  dnl mechanism), there is no need to do any AC_LIBOBJ or AC_SUBST here; they are
  dnl done in the getopt-posix module.
  gl_FUNC_GETOPT_POSIX
  if test $REPLACE_GETOPT = 1; then
    AC_LIBOBJ([getopt])
    AC_LIBOBJ([getopt1])
    dnl Arrange for unistd.h to include getopt.h.
    GNULIB_GL_UNISTD_H_GETOPT=1
  fi
  AC_SUBST([GNULIB_GL_UNISTD_H_GETOPT])
  gl_FUNC_GETPROGNAME
  AC_SUBST([LIBINTL])
  AC_SUBST([LTLIBINTL])
  gl_GETTIME
  gl_FUNC_GETTIMEOFDAY
  if test $HAVE_GETTIMEOFDAY = 0 || test $REPLACE_GETTIMEOFDAY = 1; then
    AC_LIBOBJ([gettimeofday])
    gl_PREREQ_GETTIMEOFDAY
  fi
  gl_SYS_TIME_MODULE_INDICATOR([gettimeofday])
  # Autoconf 2.61a.99 and earlier don't support linking a file only
  # in VPATH builds.  But since GNUmakefile is for maintainer use
  # only, it does not matter if we skip the link with older autoconf.
  # Automake 1.10.1 and earlier try to remove GNUmakefile in non-VPATH
  # builds, so use a shell variable to bypass this.
  GNUmakefile=GNUmakefile
  m4_if(m4_version_compare([2.61a.100],
          m4_defn([m4_PACKAGE_VERSION])), [1], [],
        [AC_CONFIG_LINKS([$GNUmakefile:$GNUmakefile], [],
          [GNUmakefile=$GNUmakefile])])
  gl_FUNC_GROUP_MEMBER
  if test $HAVE_GROUP_MEMBER = 0; then
    AC_LIBOBJ([group-member])
    gl_PREREQ_GROUP_MEMBER
  fi
  gl_UNISTD_MODULE_INDICATOR([group-member])
  gl_HARD_LOCALE
  gl_INTTYPES_H
  gl_INTTYPES_INCOMPLETE
  AC_REQUIRE([gl_LARGEFILE])
  gl_FUNC_LCHOWN
  if test $HAVE_LCHOWN = 0 || test $REPLACE_LCHOWN = 1; then
    AC_LIBOBJ([lchown])
  fi
  gl_UNISTD_MODULE_INDICATOR([lchown])
  gl_LIMITS_H
  gl_LOCALCHARSET
  LOCALCHARSET_TESTS_ENVIRONMENT="CHARSETALIASDIR=\"\$(abs_top_builddir)/$gl_source_base\""
  AC_SUBST([LOCALCHARSET_TESTS_ENVIRONMENT])
  AC_REQUIRE([gl_LOCALTIME_BUFFER_DEFAULTS])
  AC_LIBOBJ([localtime-buffer])
  gl_FUNC_LSTAT
  if test $REPLACE_LSTAT = 1; then
    AC_LIBOBJ([lstat])
    gl_PREREQ_LSTAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([lstat])
  AC_CONFIG_COMMANDS_PRE([m4_ifdef([AH_HEADER],
    [AC_SUBST([CONFIG_INCLUDE], m4_defn([AH_HEADER]))])])
  AC_REQUIRE([AC_PROG_SED])
  gl_FUNC_MALLOC_GNU
  if test $REPLACE_MALLOC = 1; then
    AC_LIBOBJ([malloc])
  fi
  gl_MODULE_INDICATOR([malloc-gnu])
  gl_FUNC_MALLOC_POSIX
  if test $REPLACE_MALLOC = 1; then
    AC_LIBOBJ([malloc])
  fi
  gl_STDLIB_MODULE_INDICATOR([malloc-posix])
  gl_MALLOCA
  gl_FUNC_MBRTOWC
  if test $HAVE_MBRTOWC = 0 || test $REPLACE_MBRTOWC = 1; then
    AC_LIBOBJ([mbrtowc])
    gl_PREREQ_MBRTOWC
  fi
  gl_WCHAR_MODULE_INDICATOR([mbrtowc])
  gl_FUNC_MBSINIT
  if test $HAVE_MBSINIT = 0 || test $REPLACE_MBSINIT = 1; then
    AC_LIBOBJ([mbsinit])
    gl_PREREQ_MBSINIT
  fi
  gl_WCHAR_MODULE_INDICATOR([mbsinit])
  gl_FUNC_MEMCHR
  if test $HAVE_MEMCHR = 0 || test $REPLACE_MEMCHR = 1; then
    AC_LIBOBJ([memchr])
    gl_PREREQ_MEMCHR
  fi
  gl_STRING_MODULE_INDICATOR([memchr])
  gl_FUNC_MEMPCPY
  if test $HAVE_MEMPCPY = 0; then
    AC_LIBOBJ([mempcpy])
    gl_PREREQ_MEMPCPY
  fi
  gl_STRING_MODULE_INDICATOR([mempcpy])
  gl_FUNC_MEMRCHR
  if test $ac_cv_func_memrchr = no; then
    AC_LIBOBJ([memrchr])
    gl_PREREQ_MEMRCHR
  fi
  gl_STRING_MODULE_INDICATOR([memrchr])
  gl_MINMAX
  gl_FUNC_MKDIR
  if test $REPLACE_MKDIR = 1; then
    AC_LIBOBJ([mkdir])
  fi
  gl_FUNC_MKDIRAT
  if test $HAVE_MKDIRAT = 0; then
    AC_LIBOBJ([mkdirat])
    gl_PREREQ_MKDIRAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([mkdirat])
  gl_FUNC_MKTIME
  if test $REPLACE_MKTIME = 1; then
    AC_LIBOBJ([mktime])
    gl_PREREQ_MKTIME
  fi
  gl_TIME_MODULE_INDICATOR([mktime])
  gl_FUNC_MKTIME_INTERNAL
  if test $WANT_MKTIME_INTERNAL = 1; then
    AC_LIBOBJ([mktime])
    gl_PREREQ_MKTIME
  fi
  AC_REQUIRE([gl_MSVC_INVAL])
  if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
    AC_LIBOBJ([msvc-inval])
  fi
  AC_REQUIRE([gl_MSVC_NOTHROW])
  if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
    AC_LIBOBJ([msvc-nothrow])
  fi
  gl_MODULE_INDICATOR([msvc-nothrow])
  gl_MULTIARCH
  gl_FUNC_GNU_STRFTIME
  gl_FUNC_OPEN
  if test $REPLACE_OPEN = 1; then
    AC_LIBOBJ([open])
    gl_PREREQ_OPEN
  fi
  gl_FCNTL_MODULE_INDICATOR([open])
  gl_FUNC_OPENAT
  if test $HAVE_OPENAT = 0 || test $REPLACE_OPENAT = 1; then
    AC_LIBOBJ([openat])
    gl_PREREQ_OPENAT
  fi
  gl_MODULE_INDICATOR([openat]) dnl for lib/getcwd.c
  gl_FCNTL_MODULE_INDICATOR([openat])
  gl_FUNC_OPENDIR
  if test $HAVE_OPENDIR = 0 || test $REPLACE_OPENDIR = 1; then
    AC_LIBOBJ([opendir])
  fi
  gl_DIRENT_MODULE_INDICATOR([opendir])
  gl_PARSE_DATETIME
  gl_PATHMAX
  AC_CHECK_DECLS([program_invocation_name], [], [], [#include <errno.h>])
  AC_CHECK_DECLS([program_invocation_short_name], [], [], [#include <errno.h>])
  gl_QUOTE
  gl_QUOTEARG
  gl_FUNC_RAISE
  if test $HAVE_RAISE = 0 || test $REPLACE_RAISE = 1; then
    AC_LIBOBJ([raise])
    gl_PREREQ_RAISE
  fi
  gl_SIGNAL_MODULE_INDICATOR([raise])
  gl_FUNC_READDIR
  if test $HAVE_READDIR = 0; then
    AC_LIBOBJ([readdir])
  fi
  gl_DIRENT_MODULE_INDICATOR([readdir])
  gl_FUNC_READLINK
  if test $HAVE_READLINK = 0 || test $REPLACE_READLINK = 1; then
    AC_LIBOBJ([readlink])
    gl_PREREQ_READLINK
  fi
  gl_UNISTD_MODULE_INDICATOR([readlink])
  gl_FUNC_READLINKAT
  if test $HAVE_READLINKAT = 0 || test $REPLACE_READLINKAT = 1; then
    AC_LIBOBJ([readlinkat])
  fi
  gl_UNISTD_MODULE_INDICATOR([readlinkat])
  gl_FUNC_REALLOC_GNU
  if test $REPLACE_REALLOC = 1; then
    AC_LIBOBJ([realloc])
  fi
  gl_MODULE_INDICATOR([realloc-gnu])
  gl_FUNC_REALLOC_POSIX
  if test $REPLACE_REALLOC = 1; then
    AC_LIBOBJ([realloc])
  fi
  gl_STDLIB_MODULE_INDICATOR([realloc-posix])
  gl_FUNC_RENAME
  if test $REPLACE_RENAME = 1; then
    AC_LIBOBJ([rename])
  fi
  gl_STDIO_MODULE_INDICATOR([rename])
  gl_FUNC_RENAMEAT
  if test $HAVE_RENAMEAT = 0 || test $REPLACE_RENAMEAT = 1; then
    AC_LIBOBJ([renameat])
  fi
  if test $HAVE_RENAMEAT = 0; then
    AC_LIBOBJ([at-func2])
  fi
  gl_STDIO_MODULE_INDICATOR([renameat])
  gl_FUNC_RENAMEAT
  if test $HAVE_RENAMEAT = 0; then
    AC_LIBOBJ([at-func2])
  fi
  gl_FUNC_RMDIR
  if test $REPLACE_RMDIR = 1; then
    AC_LIBOBJ([rmdir])
  fi
  gl_UNISTD_MODULE_INDICATOR([rmdir])
  gl_PREREQ_SAFE_WRITE
  gl_SAVE_CWD
  gl_FUNC_SETENV
  if test $HAVE_SETENV = 0 || test $REPLACE_SETENV = 1; then
    AC_LIBOBJ([setenv])
  fi
  gl_STDLIB_MODULE_INDICATOR([setenv])
  gl_SIGNAL_H
  gl_SIZE_MAX
  gt_TYPE_SSIZE_T
  gl_FUNC_STAT
  if test $REPLACE_STAT = 1; then
    AC_LIBOBJ([stat])
    case "$host_os" in
      mingw*)
        AC_LIBOBJ([stat-w32])
        ;;
    esac
    gl_PREREQ_STAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([stat])
  gl_STAT_TIME
  gl_STAT_BIRTHTIME
  gl_MODULE_INDICATOR([statat]) dnl for lib/openat.h
  gl_STDARG_H
  AM_STDBOOL_H
  gl_STDDEF_H
  gl_STDINT_H
  gl_STDIO_H
  gl_STDLIB_H
  gl_FUNC_STRDUP_POSIX
  if test $ac_cv_func_strdup = no || test $REPLACE_STRDUP = 1; then
    AC_LIBOBJ([strdup])
    gl_PREREQ_STRDUP
  fi
  gl_STRING_MODULE_INDICATOR([strdup])
  gl_FUNC_STRERROR
  if test $REPLACE_STRERROR = 1; then
    AC_LIBOBJ([strerror])
  fi
  gl_MODULE_INDICATOR([strerror])
  gl_STRING_MODULE_INDICATOR([strerror])
  AC_REQUIRE([gl_HEADER_ERRNO_H])
  AC_REQUIRE([gl_FUNC_STRERROR_0])
  if test -n "$ERRNO_H" || test $REPLACE_STRERROR_0 = 1; then
    AC_LIBOBJ([strerror-override])
    gl_PREREQ_SYS_H_WINSOCK2
  fi
  gl_HEADER_STRING_H
  gl_FUNC_STRNDUP
  if test $HAVE_STRNDUP = 0 || test $REPLACE_STRNDUP = 1; then
    AC_LIBOBJ([strndup])
  fi
  gl_STRING_MODULE_INDICATOR([strndup])
  gl_FUNC_STRNLEN
  if test $HAVE_DECL_STRNLEN = 0 || test $REPLACE_STRNLEN = 1; then
    AC_LIBOBJ([strnlen])
    gl_PREREQ_STRNLEN
  fi
  gl_STRING_MODULE_INDICATOR([strnlen])
  gl_FUNC_SYMLINK
  if test $HAVE_SYMLINK = 0 || test $REPLACE_SYMLINK = 1; then
    AC_LIBOBJ([symlink])
  fi
  gl_UNISTD_MODULE_INDICATOR([symlink])
  gl_FUNC_SYMLINKAT
  if test $HAVE_SYMLINKAT = 0 || test $REPLACE_SYMLINKAT = 1; then
    AC_LIBOBJ([symlinkat])
  fi
  gl_UNISTD_MODULE_INDICATOR([symlinkat])
  gl_HEADER_SYS_STAT_H
  AC_PROG_MKDIR_P
  gl_HEADER_SYS_TIME_H
  AC_PROG_MKDIR_P
  gl_SYS_TYPES_H
  AC_PROG_MKDIR_P
  gl_FUNC_GEN_TEMPNAME
  gl_HEADER_TIME_H
  gl_TIME_R
  if test $HAVE_LOCALTIME_R = 0 || test $REPLACE_LOCALTIME_R = 1; then
    AC_LIBOBJ([time_r])
    gl_PREREQ_TIME_R
  fi
  gl_TIME_MODULE_INDICATOR([time_r])
  gl_TIME_RZ
  if test $HAVE_TIMEZONE_T = 0; then
    AC_LIBOBJ([time_rz])
  fi
  gl_TIME_MODULE_INDICATOR([time_rz])
  gl_FUNC_TIMEGM
  if test $HAVE_TIMEGM = 0 || test $REPLACE_TIMEGM = 1; then
    AC_LIBOBJ([timegm])
    gl_PREREQ_TIMEGM
  fi
  gl_TIME_MODULE_INDICATOR([timegm])
  gl_TIMESPEC
  gl_FUNC_TZSET
  if test $HAVE_TZSET = 0 || test $REPLACE_TZSET = 1; then
    AC_LIBOBJ([tzset])
  fi
  gl_TIME_MODULE_INDICATOR([tzset])
  gl_UNISTD_H
  gl_UNISTD_SAFER
  gl_FUNC_UNLINK
  if test $REPLACE_UNLINK = 1; then
    AC_LIBOBJ([unlink])
  fi
  gl_UNISTD_MODULE_INDICATOR([unlink])
  gl_FUNC_UNLINKAT
  if test $HAVE_UNLINKAT = 0 || test $REPLACE_UNLINKAT = 1; then
    AC_LIBOBJ([unlinkat])
  fi
  gl_UNISTD_MODULE_INDICATOR([unlinkat])
  gl_FUNC_UNSETENV
  if test $HAVE_UNSETENV = 0 || test $REPLACE_UNSETENV = 1; then
    AC_LIBOBJ([unsetenv])
    gl_PREREQ_UNSETENV
  fi
  gl_STDLIB_MODULE_INDICATOR([unsetenv])
  gl_FUNC_UTIME
  if test $HAVE_UTIME = 0 || test $REPLACE_UTIME = 1; then
    AC_LIBOBJ([utime])
    gl_PREREQ_UTIME
  fi
  gl_UTIME_MODULE_INDICATOR([utime])
  gl_UTIME_H
  gl_UTIMENS
  gl_FUNC_UTIMENSAT
  if test $HAVE_UTIMENSAT = 0 || test $REPLACE_UTIMENSAT = 1; then
    AC_LIBOBJ([utimensat])
  fi
  gl_SYS_STAT_MODULE_INDICATOR([utimensat])
  gl_FUNC_VASNPRINTF
  gl_FUNC_VASPRINTF
  gl_STDIO_MODULE_INDICATOR([vasprintf])
  m4_ifdef([AM_XGETTEXT_OPTION],
    [AM_][XGETTEXT_OPTION([--flag=asprintf:2:c-format])
     AM_][XGETTEXT_OPTION([--flag=vasprintf:2:c-format])])
  m4_ifdef([AM_XGETTEXT_OPTION],
    [AM_][XGETTEXT_OPTION([--flag=verror:3:c-format])
     AM_][XGETTEXT_OPTION([--flag=verror_at_line:5:c-format])])
  gl_WCHAR_H
  gl_WCTYPE_H
  gl_FUNC_WRITE
  if test $REPLACE_WRITE = 1; then
    AC_LIBOBJ([write])
    gl_PREREQ_WRITE
  fi
  gl_UNISTD_MODULE_INDICATOR([write])
  gl_XALLOC
  AC_LIBOBJ([xmemdup0])
  gl_XSIZE
  gl_XSTRNDUP
  gl_XVASPRINTF
  m4_ifdef([AM_XGETTEXT_OPTION],
    [AM_][XGETTEXT_OPTION([--flag=xasprintf:1:c-format])])
  # End of code from modules
  m4_ifval(gl_LIBSOURCES_LIST, [
    m4_syscmd([test ! -d ]m4_defn([gl_LIBSOURCES_DIR])[ ||
      for gl_file in ]gl_LIBSOURCES_LIST[ ; do
        if test ! -r ]m4_defn([gl_LIBSOURCES_DIR])[/$gl_file ; then
          echo "missing file ]m4_defn([gl_LIBSOURCES_DIR])[/$gl_file" >&2
          exit 1
        fi
      done])dnl
      m4_if(m4_sysval, [0], [],
        [AC_FATAL([expected source file, required through AC_LIBSOURCES, not found])])
  ])
  m4_popdef([gl_LIBSOURCES_DIR])
  m4_popdef([gl_LIBSOURCES_LIST])
  m4_popdef([AC_LIBSOURCES])
  m4_popdef([AC_REPLACE_FUNCS])
  m4_popdef([AC_LIBOBJ])
  AC_CONFIG_COMMANDS_PRE([
    gl_libobjs=
    gl_ltlibobjs=
    if test -n "$gl_LIBOBJS"; then
      # Remove the extension.
      sed_drop_objext='s/\.o$//;s/\.obj$//'
      for i in `for i in $gl_LIBOBJS; do echo "$i"; done | sed -e "$sed_drop_objext" | sort | uniq`; do
        gl_libobjs="$gl_libobjs $i.$ac_objext"
        gl_ltlibobjs="$gl_ltlibobjs $i.lo"
      done
    fi
    AC_SUBST([gl_LIBOBJS], [$gl_libobjs])
    AC_SUBST([gl_LTLIBOBJS], [$gl_ltlibobjs])
  ])
  gltests_libdeps=
  gltests_ltlibdeps=
  m4_pushdef([AC_LIBOBJ], m4_defn([gltests_LIBOBJ]))
  m4_pushdef([AC_REPLACE_FUNCS], m4_defn([gltests_REPLACE_FUNCS]))
  m4_pushdef([AC_LIBSOURCES], m4_defn([gltests_LIBSOURCES]))
  m4_pushdef([gltests_LIBSOURCES_LIST], [])
  m4_pushdef([gltests_LIBSOURCES_DIR], [])
  gl_COMMON
  gl_source_base='tests'
changequote(,)dnl
  gltests_WITNESS=IN_`echo "${PACKAGE-$PACKAGE_TARNAME}" | LC_ALL=C tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ | LC_ALL=C sed -e 's/[^A-Z0-9_]/_/g'`_GNULIB_TESTS
changequote([, ])dnl
  AC_SUBST([gltests_WITNESS])
  gl_module_indicator_condition=$gltests_WITNESS
  m4_pushdef([gl_MODULE_INDICATOR_CONDITION], [$gl_module_indicator_condition])
  m4_popdef([gl_MODULE_INDICATOR_CONDITION])
  m4_ifval(gltests_LIBSOURCES_LIST, [
    m4_syscmd([test ! -d ]m4_defn([gltests_LIBSOURCES_DIR])[ ||
      for gl_file in ]gltests_LIBSOURCES_LIST[ ; do
        if test ! -r ]m4_defn([gltests_LIBSOURCES_DIR])[/$gl_file ; then
          echo "missing file ]m4_defn([gltests_LIBSOURCES_DIR])[/$gl_file" >&2
          exit 1
        fi
      done])dnl
      m4_if(m4_sysval, [0], [],
        [AC_FATAL([expected source file, required through AC_LIBSOURCES, not found])])
  ])
  m4_popdef([gltests_LIBSOURCES_DIR])
  m4_popdef([gltests_LIBSOURCES_LIST])
  m4_popdef([AC_LIBSOURCES])
  m4_popdef([AC_REPLACE_FUNCS])
  m4_popdef([AC_LIBOBJ])
  AC_CONFIG_COMMANDS_PRE([
    gltests_libobjs=
    gltests_ltlibobjs=
    if test -n "$gltests_LIBOBJS"; then
      # Remove the extension.
      sed_drop_objext='s/\.o$//;s/\.obj$//'
      for i in `for i in $gltests_LIBOBJS; do echo "$i"; done | sed -e "$sed_drop_objext" | sort | uniq`; do
        gltests_libobjs="$gltests_libobjs $i.$ac_objext"
        gltests_ltlibobjs="$gltests_ltlibobjs $i.lo"
      done
    fi
    AC_SUBST([gltests_LIBOBJS], [$gltests_libobjs])
    AC_SUBST([gltests_LTLIBOBJS], [$gltests_ltlibobjs])
  ])
  LIBPATCH_LIBDEPS="$gl_libdeps"
  AC_SUBST([LIBPATCH_LIBDEPS])
  LIBPATCH_LTLIBDEPS="$gl_ltlibdeps"
  AC_SUBST([LIBPATCH_LTLIBDEPS])
])

# Like AC_LIBOBJ, except that the module name goes
# into gl_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gl_LIBOBJ], [
  AS_LITERAL_IF([$1], [gl_LIBSOURCES([$1.c])])dnl
  gl_LIBOBJS="$gl_LIBOBJS $1.$ac_objext"
])

# Like AC_REPLACE_FUNCS, except that the module name goes
# into gl_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gl_REPLACE_FUNCS], [
  m4_foreach_w([gl_NAME], [$1], [AC_LIBSOURCES(gl_NAME[.c])])dnl
  AC_CHECK_FUNCS([$1], , [gl_LIBOBJ($ac_func)])
])

# Like AC_LIBSOURCES, except the directory where the source file is
# expected is derived from the gnulib-tool parameterization,
# and alloca is special cased (for the alloca-opt module).
# We could also entirely rely on EXTRA_lib..._SOURCES.
AC_DEFUN([gl_LIBSOURCES], [
  m4_foreach([_gl_NAME], [$1], [
    m4_if(_gl_NAME, [alloca.c], [], [
      m4_define([gl_LIBSOURCES_DIR], [lib])
      m4_append([gl_LIBSOURCES_LIST], _gl_NAME, [ ])
    ])
  ])
])

# Like AC_LIBOBJ, except that the module name goes
# into gltests_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gltests_LIBOBJ], [
  AS_LITERAL_IF([$1], [gltests_LIBSOURCES([$1.c])])dnl
  gltests_LIBOBJS="$gltests_LIBOBJS $1.$ac_objext"
])

# Like AC_REPLACE_FUNCS, except that the module name goes
# into gltests_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gltests_REPLACE_FUNCS], [
  m4_foreach_w([gl_NAME], [$1], [AC_LIBSOURCES(gl_NAME[.c])])dnl
  AC_CHECK_FUNCS([$1], , [gltests_LIBOBJ($ac_func)])
])

# Like AC_LIBSOURCES, except the directory where the source file is
# expected is derived from the gnulib-tool parameterization,
# and alloca is special cased (for the alloca-opt module).
# We could also entirely rely on EXTRA_lib..._SOURCES.
AC_DEFUN([gltests_LIBSOURCES], [
  m4_foreach([_gl_NAME], [$1], [
    m4_if(_gl_NAME, [alloca.c], [], [
      m4_define([gltests_LIBSOURCES_DIR], [tests])
      m4_append([gltests_LIBSOURCES_LIST], _gl_NAME, [ ])
    ])
  ])
])

# This macro records the list of files which have been installed by
# gnulib-tool and may be removed by future gnulib-tool invocations.
AC_DEFUN([gl_FILE_LIST], [
  build-aux/git-version-gen
  build-aux/gitlog-to-changelog
  build-aux/gnupload
  build-aux/update-copyright
  build-aux/useless-if-before-free
  build-aux/vc-list-files
  doc/getdate.texi
  doc/parse-datetime.texi
  lib/_Noreturn.h
  lib/alloca.in.h
  lib/arg-nonnull.h
  lib/argmatch.c
  lib/argmatch.h
  lib/asnprintf.c
  lib/asprintf.c
  lib/assure.h
  lib/at-func.c
  lib/at-func2.c
  lib/backup-find.c
  lib/backup-internal.h
  lib/backupfile.c
  lib/backupfile.h
  lib/basename-lgpl.c
  lib/basename.c
  lib/bitrotate.c
  lib/bitrotate.h
  lib/c++defs.h
  lib/c-ctype.c
  lib/c-ctype.h
  lib/c-strcase.h
  lib/c-strcasecmp.c
  lib/c-strcaseeq.h
  lib/c-strncasecmp.c
  lib/canonicalize-lgpl.c
  lib/chdir-long.c
  lib/chdir-long.h
  lib/chmodat.c
  lib/chown.c
  lib/chownat.c
  lib/cloexec.c
  lib/cloexec.h
  lib/close.c
  lib/closedir.c
  lib/config.charset
  lib/diffseq.h
  lib/dirent--.h
  lib/dirent-private.h
  lib/dirent-safer.h
  lib/dirent.in.h
  lib/dirfd.c
  lib/dirname-lgpl.c
  lib/dirname.c
  lib/dirname.h
  lib/dosname.h
  lib/dup-safer-flag.c
  lib/dup-safer.c
  lib/dup2.c
  lib/errno.in.h
  lib/error.c
  lib/error.h
  lib/euidaccess.c
  lib/exitfail.c
  lib/exitfail.h
  lib/faccessat.c
  lib/fchdir.c
  lib/fchmodat.c
  lib/fchown-stub.c
  lib/fchownat.c
  lib/fcntl.c
  lib/fcntl.in.h
  lib/fd-hook.c
  lib/fd-hook.h
  lib/fd-safer-flag.c
  lib/fd-safer.c
  lib/filename.h
  lib/filenamecat-lgpl.c
  lib/filenamecat.h
  lib/flexmember.h
  lib/float+.h
  lib/float.c
  lib/float.in.h
  lib/fstat.c
  lib/fstatat.c
  lib/full-write.c
  lib/full-write.h
  lib/getcwd-lgpl.c
  lib/getdate.h
  lib/getdtablesize.c
  lib/getgroups.c
  lib/getopt-cdefs.in.h
  lib/getopt-core.h
  lib/getopt-ext.h
  lib/getopt-pfx-core.h
  lib/getopt-pfx-ext.h
  lib/getopt.c
  lib/getopt.in.h
  lib/getopt1.c
  lib/getopt_int.h
  lib/getprogname.c
  lib/getprogname.h
  lib/gettext.h
  lib/gettime.c
  lib/gettimeofday.c
  lib/gl_anylinked_list1.h
  lib/gl_anylinked_list2.h
  lib/gl_linked_list.c
  lib/gl_linked_list.h
  lib/gl_list.c
  lib/gl_list.h
  lib/gl_xlist.c
  lib/gl_xlist.h
  lib/group-member.c
  lib/hard-locale.c
  lib/hard-locale.h
  lib/hash.c
  lib/hash.h
  lib/ignore-value.h
  lib/intprops.h
  lib/inttypes.in.h
  lib/itold.c
  lib/lchown.c
  lib/limits.in.h
  lib/localcharset.c
  lib/localcharset.h
  lib/localtime-buffer.c
  lib/localtime-buffer.h
  lib/lstat.c
  lib/malloc.c
  lib/malloca.c
  lib/malloca.h
  lib/mbrtowc.c
  lib/mbsinit.c
  lib/memchr.c
  lib/memchr.valgrind
  lib/mempcpy.c
  lib/memrchr.c
  lib/minmax.h
  lib/mkdir.c
  lib/mkdirat.c
  lib/mktime-internal.h
  lib/mktime.c
  lib/msvc-inval.c
  lib/msvc-inval.h
  lib/msvc-nothrow.c
  lib/msvc-nothrow.h
  lib/nstrftime.c
  lib/open.c
  lib/openat-die.c
  lib/openat-priv.h
  lib/openat-proc.c
  lib/openat.c
  lib/openat.h
  lib/opendir-safer.c
  lib/opendir.c
  lib/parse-datetime.h
  lib/parse-datetime.y
  lib/pathmax.h
  lib/pipe-safer.c
  lib/printf-args.c
  lib/printf-args.h
  lib/printf-parse.c
  lib/printf-parse.h
  lib/progname.c
  lib/progname.h
  lib/quote.h
  lib/quotearg.c
  lib/quotearg.h
  lib/raise.c
  lib/readdir.c
  lib/readlink.c
  lib/readlinkat.c
  lib/realloc.c
  lib/ref-add.sin
  lib/ref-del.sin
  lib/rename.c
  lib/renameat.c
  lib/renameat2.c
  lib/renameat2.h
  lib/rmdir.c
  lib/root-uid.h
  lib/safe-read.c
  lib/safe-write.c
  lib/safe-write.h
  lib/same-inode.h
  lib/save-cwd.c
  lib/save-cwd.h
  lib/setenv.c
  lib/signal.in.h
  lib/size_max.h
  lib/stat-time.c
  lib/stat-time.h
  lib/stat-w32.c
  lib/stat-w32.h
  lib/stat.c
  lib/statat.c
  lib/stdarg.in.h
  lib/stdbool.in.h
  lib/stddef.in.h
  lib/stdint.in.h
  lib/stdio.in.h
  lib/stdlib.in.h
  lib/strdup.c
  lib/streq.h
  lib/strerror-override.c
  lib/strerror-override.h
  lib/strerror.c
  lib/strftime.h
  lib/string.in.h
  lib/stripslash.c
  lib/strndup.c
  lib/strnlen.c
  lib/symlink.c
  lib/symlinkat.c
  lib/sys_stat.in.h
  lib/sys_time.in.h
  lib/sys_types.in.h
  lib/tempname.c
  lib/tempname.h
  lib/time-internal.h
  lib/time.in.h
  lib/time_r.c
  lib/time_rz.c
  lib/timegm.c
  lib/timespec.c
  lib/timespec.h
  lib/tzset.c
  lib/unistd--.h
  lib/unistd-safer.h
  lib/unistd.c
  lib/unistd.in.h
  lib/unlink.c
  lib/unlinkat.c
  lib/unsetenv.c
  lib/utime.c
  lib/utime.in.h
  lib/utimens.c
  lib/utimens.h
  lib/utimensat.c
  lib/vasnprintf.c
  lib/vasnprintf.h
  lib/vasprintf.c
  lib/verify.h
  lib/verror.c
  lib/verror.h
  lib/warn-on-use.h
  lib/wchar.in.h
  lib/wctype-h.c
  lib/wctype.in.h
  lib/write.c
  lib/xalloc-die.c
  lib/xalloc-oversized.h
  lib/xalloc.h
  lib/xasprintf.c
  lib/xmalloc.c
  lib/xmemdup0.c
  lib/xmemdup0.h
  lib/xsize.c
  lib/xsize.h
  lib/xstrndup.c
  lib/xstrndup.h
  lib/xvasprintf.c
  lib/xvasprintf.h
  m4/00gnulib.m4
  m4/absolute-header.m4
  m4/alloca.m4
  m4/backupfile.m4
  m4/bison.m4
  m4/canonicalize.m4
  m4/chdir-long.m4
  m4/chown.m4
  m4/clock_time.m4
  m4/close.m4
  m4/closedir.m4
  m4/codeset.m4
  m4/configmake.m4
  m4/d-ino.m4
  m4/dirent-safer.m4
  m4/dirent_h.m4
  m4/dirfd.m4
  m4/dirname.m4
  m4/double-slash-root.m4
  m4/dup2.m4
  m4/eealloc.m4
  m4/environ.m4
  m4/errno_h.m4
  m4/error.m4
  m4/euidaccess.m4
  m4/exponentd.m4
  m4/extensions.m4
  m4/extern-inline.m4
  m4/faccessat.m4
  m4/fchdir.m4
  m4/fchmodat.m4
  m4/fchownat.m4
  m4/fcntl-o.m4
  m4/fcntl.m4
  m4/fcntl_h.m4
  m4/filenamecat.m4
  m4/flexmember.m4
  m4/float_h.m4
  m4/fstat.m4
  m4/fstatat.m4
  m4/getcwd.m4
  m4/getdtablesize.m4
  m4/getgroups.m4
  m4/getopt.m4
  m4/getprogname.m4
  m4/gettime.m4
  m4/gettimeofday.m4
  m4/glibc21.m4
  m4/gnulib-common.m4
  m4/group-member.m4
  m4/hard-locale.m4
  m4/include_next.m4
  m4/intmax_t.m4
  m4/inttypes-pri.m4
  m4/inttypes.m4
  m4/inttypes_h.m4
  m4/largefile.m4
  m4/lchown.m4
  m4/limits-h.m4
  m4/localcharset.m4
  m4/locale-fr.m4
  m4/locale-ja.m4
  m4/locale-zh.m4
  m4/localtime-buffer.m4
  m4/longlong.m4
  m4/lstat.m4
  m4/malloc.m4
  m4/malloca.m4
  m4/manywarnings-c++.m4
  m4/manywarnings.m4
  m4/math_h.m4
  m4/mbrtowc.m4
  m4/mbsinit.m4
  m4/mbstate_t.m4
  m4/memchr.m4
  m4/mempcpy.m4
  m4/memrchr.m4
  m4/minmax.m4
  m4/mkdir.m4
  m4/mkdirat.m4
  m4/mktime.m4
  m4/mmap-anon.m4
  m4/mode_t.m4
  m4/msvc-inval.m4
  m4/msvc-nothrow.m4
  m4/multiarch.m4
  m4/nocrash.m4
  m4/nstrftime.m4
  m4/off_t.m4
  m4/open-cloexec.m4
  m4/open.m4
  m4/openat.m4
  m4/opendir.m4
  m4/parse-datetime.m4
  m4/pathmax.m4
  m4/printf.m4
  m4/quote.m4
  m4/quotearg.m4
  m4/raise.m4
  m4/readdir.m4
  m4/readlink.m4
  m4/readlinkat.m4
  m4/realloc.m4
  m4/rename.m4
  m4/renameat.m4
  m4/rmdir.m4
  m4/safe-read.m4
  m4/safe-write.m4
  m4/save-cwd.m4
  m4/setenv.m4
  m4/signal_h.m4
  m4/size_max.m4
  m4/ssize_t.m4
  m4/stat-time.m4
  m4/stat.m4
  m4/stdarg.m4
  m4/stdbool.m4
  m4/stddef_h.m4
  m4/stdint.m4
  m4/stdint_h.m4
  m4/stdio_h.m4
  m4/stdlib_h.m4
  m4/strdup.m4
  m4/strerror.m4
  m4/string_h.m4
  m4/strndup.m4
  m4/strnlen.m4
  m4/symlink.m4
  m4/symlinkat.m4
  m4/sys_socket_h.m4
  m4/sys_stat_h.m4
  m4/sys_time_h.m4
  m4/sys_types_h.m4
  m4/tempname.m4
  m4/time_h.m4
  m4/time_r.m4
  m4/time_rz.m4
  m4/timegm.m4
  m4/timespec.m4
  m4/tm_gmtoff.m4
  m4/tzset.m4
  m4/unistd-safer.m4
  m4/unistd_h.m4
  m4/unlink.m4
  m4/unlinkat.m4
  m4/utime.m4
  m4/utime_h.m4
  m4/utimens.m4
  m4/utimensat.m4
  m4/utimes.m4
  m4/vasnprintf.m4
  m4/vasprintf.m4
  m4/warn-on-use.m4
  m4/warnings.m4
  m4/wchar_h.m4
  m4/wchar_t.m4
  m4/wctype_h.m4
  m4/wint_t.m4
  m4/write.m4
  m4/xalloc.m4
  m4/xsize.m4
  m4/xstrndup.m4
  m4/xvasprintf.m4
  top/GNUmakefile
  top/maint.mk
])

# serial 14

# Copyright (C) 1999-2001, 2003-2007, 2009-2018 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl Written by Jim Meyering

AC_DEFUN([gl_FUNC_GROUP_MEMBER],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])

  dnl Persuade glibc <unistd.h> to declare group_member().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  dnl Do this replacement check manually because I want the hyphen
  dnl (not the underscore) in the filename.
  AC_CHECK_FUNC([group_member], , [
    HAVE_GROUP_MEMBER=0
  ])
])

# Prerequisites of lib/group-member.c.
AC_DEFUN([gl_PREREQ_GROUP_MEMBER],
[
  AC_REQUIRE([AC_FUNC_GETGROUPS])
])

# hard-locale.m4 serial 8
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl No prerequisites of lib/hard-locale.c.
AC_DEFUN([gl_HARD_LOCALE],
[
  :
])

# include_next.m4 serial 24
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert and Derek Price.

dnl Sets INCLUDE_NEXT, INCLUDE_NEXT_AS_FIRST_DIRECTIVE, PRAGMA_SYSTEM_HEADER,
dnl and PRAGMA_COLUMNS.
dnl
dnl INCLUDE_NEXT expands to 'include_next' if the compiler supports it, or to
dnl 'include' otherwise.
dnl
dnl INCLUDE_NEXT_AS_FIRST_DIRECTIVE expands to 'include_next' if the compiler
dnl supports it in the special case that it is the first include directive in
dnl the given file, or to 'include' otherwise.
dnl
dnl PRAGMA_SYSTEM_HEADER can be used in files that contain #include_next,
dnl so as to avoid GCC warnings when the gcc option -pedantic is used.
dnl '#pragma GCC system_header' has the same effect as if the file was found
dnl through the include search path specified with '-isystem' options (as
dnl opposed to the search path specified with '-I' options). Namely, gcc
dnl does not warn about some things, and on some systems (Solaris and Interix)
dnl __STDC__ evaluates to 0 instead of to 1. The latter is an undesired side
dnl effect; we are therefore careful to use 'defined __STDC__' or '1' instead
dnl of plain '__STDC__'.
dnl
dnl PRAGMA_COLUMNS can be used in files that override system header files, so
dnl as to avoid compilation errors on HP NonStop systems when the gnulib file
dnl is included by a system header file that does a "#pragma COLUMNS 80" (which
dnl has the effect of truncating the lines of that file and all files that it
dnl includes to 80 columns) and the gnulib file has lines longer than 80
dnl columns.

AC_DEFUN([gl_INCLUDE_NEXT],
[
  AC_LANG_PREPROC_REQUIRE()
  AC_CACHE_CHECK([whether the preprocessor supports include_next],
    [gl_cv_have_include_next],
    [rm -rf conftestd1a conftestd1b conftestd2
     mkdir conftestd1a conftestd1b conftestd2
     dnl IBM C 9.0, 10.1 (original versions, prior to the 2009-01 updates) on
     dnl AIX 6.1 support include_next when used as first preprocessor directive
     dnl in a file, but not when preceded by another include directive. Check
     dnl for this bug by including <stdio.h>.
     dnl Additionally, with this same compiler, include_next is a no-op when
     dnl used in a header file that was included by specifying its absolute
     dnl file name. Despite these two bugs, include_next is used in the
     dnl compiler's <math.h>. By virtue of the second bug, we need to use
     dnl include_next as well in this case.
     cat <<EOF > conftestd1a/conftest.h
#define DEFINED_IN_CONFTESTD1
#include_next <conftest.h>
#ifdef DEFINED_IN_CONFTESTD2
int foo;
#else
#error "include_next doesn't work"
#endif
EOF
     cat <<EOF > conftestd1b/conftest.h
#define DEFINED_IN_CONFTESTD1
#include <stdio.h>
#include_next <conftest.h>
#ifdef DEFINED_IN_CONFTESTD2
int foo;
#else
#error "include_next doesn't work"
#endif
EOF
     cat <<EOF > conftestd2/conftest.h
#ifndef DEFINED_IN_CONFTESTD1
#error "include_next test doesn't work"
#endif
#define DEFINED_IN_CONFTESTD2
EOF
     gl_save_CPPFLAGS="$CPPFLAGS"
     CPPFLAGS="$gl_save_CPPFLAGS -Iconftestd1b -Iconftestd2"
dnl We intentionally avoid using AC_LANG_SOURCE here.
     AC_COMPILE_IFELSE([AC_LANG_DEFINES_PROVIDED[#include <conftest.h>]],
       [gl_cv_have_include_next=yes],
       [CPPFLAGS="$gl_save_CPPFLAGS -Iconftestd1a -Iconftestd2"
        AC_COMPILE_IFELSE([AC_LANG_DEFINES_PROVIDED[#include <conftest.h>]],
          [gl_cv_have_include_next=buggy],
          [gl_cv_have_include_next=no])
       ])
     CPPFLAGS="$gl_save_CPPFLAGS"
     rm -rf conftestd1a conftestd1b conftestd2
    ])
  PRAGMA_SYSTEM_HEADER=
  if test $gl_cv_have_include_next = yes; then
    INCLUDE_NEXT=include_next
    INCLUDE_NEXT_AS_FIRST_DIRECTIVE=include_next
    if test -n "$GCC"; then
      PRAGMA_SYSTEM_HEADER='#pragma GCC system_header'
    fi
  else
    if test $gl_cv_have_include_next = buggy; then
      INCLUDE_NEXT=include
      INCLUDE_NEXT_AS_FIRST_DIRECTIVE=include_next
    else
      INCLUDE_NEXT=include
      INCLUDE_NEXT_AS_FIRST_DIRECTIVE=include
    fi
  fi
  AC_SUBST([INCLUDE_NEXT])
  AC_SUBST([INCLUDE_NEXT_AS_FIRST_DIRECTIVE])
  AC_SUBST([PRAGMA_SYSTEM_HEADER])
  AC_CACHE_CHECK([whether system header files limit the line length],
    [gl_cv_pragma_columns],
    [dnl HP NonStop systems, which define __TANDEM, have this misfeature.
     AC_EGREP_CPP([choke me],
       [
#ifdef __TANDEM
choke me
#endif
       ],
       [gl_cv_pragma_columns=yes],
       [gl_cv_pragma_columns=no])
    ])
  if test $gl_cv_pragma_columns = yes; then
    PRAGMA_COLUMNS="#pragma COLUMNS 10000"
  else
    PRAGMA_COLUMNS=
  fi
  AC_SUBST([PRAGMA_COLUMNS])
])

# gl_CHECK_NEXT_HEADERS(HEADER1 HEADER2 ...)
# ------------------------------------------
# For each arg foo.h, if #include_next works, define NEXT_FOO_H to be
# '<foo.h>'; otherwise define it to be
# '"///usr/include/foo.h"', or whatever other absolute file name is suitable.
# Also, if #include_next works as first preprocessing directive in a file,
# define NEXT_AS_FIRST_DIRECTIVE_FOO_H to be '<foo.h>'; otherwise define it to
# be
# '"///usr/include/foo.h"', or whatever other absolute file name is suitable.
# That way, a header file with the following line:
#       #@INCLUDE_NEXT@ @NEXT_FOO_H@
# or
#       #@INCLUDE_NEXT_AS_FIRST_DIRECTIVE@ @NEXT_AS_FIRST_DIRECTIVE_FOO_H@
# behaves (after sed substitution) as if it contained
#       #include_next <foo.h>
# even if the compiler does not support include_next.
# The three "///" are to pacify Sun C 5.8, which otherwise would say
# "warning: #include of /usr/include/... may be non-portable".
# Use '""', not '<>', so that the /// cannot be confused with a C99 comment.
# Note: This macro assumes that the header file is not empty after
# preprocessing, i.e. it does not only define preprocessor macros but also
# provides some type/enum definitions or function/variable declarations.
#
# This macro also checks whether each header exists, by invoking
# AC_CHECK_HEADERS_ONCE or AC_CHECK_HEADERS on each argument.
AC_DEFUN([gl_CHECK_NEXT_HEADERS],
[
  gl_NEXT_HEADERS_INTERNAL([$1], [check])
])

# gl_NEXT_HEADERS(HEADER1 HEADER2 ...)
# ------------------------------------
# Like gl_CHECK_NEXT_HEADERS, except do not check whether the headers exist.
# This is suitable for headers like <stddef.h> that are standardized by C89
# and therefore can be assumed to exist.
AC_DEFUN([gl_NEXT_HEADERS],
[
  gl_NEXT_HEADERS_INTERNAL([$1], [assume])
])

# The guts of gl_CHECK_NEXT_HEADERS and gl_NEXT_HEADERS.
AC_DEFUN([gl_NEXT_HEADERS_INTERNAL],
[
  AC_REQUIRE([gl_INCLUDE_NEXT])
  AC_REQUIRE([AC_CANONICAL_HOST])

  m4_if([$2], [check],
    [AC_CHECK_HEADERS_ONCE([$1])
    ])

dnl FIXME: gl_next_header and gl_header_exists must be used unquoted
dnl until we can assume autoconf 2.64 or newer.
  m4_foreach_w([gl_HEADER_NAME], [$1],
    [AS_VAR_PUSHDEF([gl_next_header],
                    [gl_cv_next_]m4_defn([gl_HEADER_NAME]))
     if test $gl_cv_have_include_next = yes; then
       AS_VAR_SET(gl_next_header, ['<'gl_HEADER_NAME'>'])
     else
       AC_CACHE_CHECK(
         [absolute name of <]m4_defn([gl_HEADER_NAME])[>],
         m4_defn([gl_next_header]),
         [m4_if([$2], [check],
            [AS_VAR_PUSHDEF([gl_header_exists],
                            [ac_cv_header_]m4_defn([gl_HEADER_NAME]))
             if test AS_VAR_GET(gl_header_exists) = yes; then
             AS_VAR_POPDEF([gl_header_exists])
            ])
           gl_ABSOLUTE_HEADER_ONE(gl_HEADER_NAME)
           AS_VAR_COPY([gl_header], [gl_cv_absolute_]AS_TR_SH(gl_HEADER_NAME))
           AS_VAR_SET(gl_next_header, ['"'$gl_header'"'])
          m4_if([$2], [check],
            [else
               AS_VAR_SET(gl_next_header, ['<'gl_HEADER_NAME'>'])
             fi
            ])
         ])
     fi
     AC_SUBST(
       AS_TR_CPP([NEXT_]m4_defn([gl_HEADER_NAME])),
       [AS_VAR_GET(gl_next_header)])
     if test $gl_cv_have_include_next = yes || test $gl_cv_have_include_next = buggy; then
       # INCLUDE_NEXT_AS_FIRST_DIRECTIVE='include_next'
       gl_next_as_first_directive='<'gl_HEADER_NAME'>'
     else
       # INCLUDE_NEXT_AS_FIRST_DIRECTIVE='include'
       gl_next_as_first_directive=AS_VAR_GET(gl_next_header)
     fi
     AC_SUBST(
       AS_TR_CPP([NEXT_AS_FIRST_DIRECTIVE_]m4_defn([gl_HEADER_NAME])),
       [$gl_next_as_first_directive])
     AS_VAR_POPDEF([gl_next_header])])
])

# Autoconf 2.68 added warnings for our use of AC_COMPILE_IFELSE;
# this fallback is safe for all earlier autoconf versions.
m4_define_default([AC_LANG_DEFINES_PROVIDED])

# intmax_t.m4 serial 8
dnl Copyright (C) 1997-2004, 2006-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

AC_PREREQ([2.53])

# Define intmax_t to 'long' or 'long long'
# if it is not already defined in <stdint.h> or <inttypes.h>.

AC_DEFUN([gl_AC_TYPE_INTMAX_T],
[
  dnl For simplicity, we assume that a header file defines 'intmax_t' if and
  dnl only if it defines 'uintmax_t'.
  AC_REQUIRE([gl_AC_HEADER_INTTYPES_H])
  AC_REQUIRE([gl_AC_HEADER_STDINT_H])
  if test $gl_cv_header_inttypes_h = no && test $gl_cv_header_stdint_h = no; then
    AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
    test $ac_cv_type_long_long_int = yes \
      && ac_type='long long' \
      || ac_type='long'
    AC_DEFINE_UNQUOTED([intmax_t], [$ac_type],
     [Define to long or long long if <inttypes.h> and <stdint.h> don't define.])
  else
    AC_DEFINE([HAVE_INTMAX_T], [1],
      [Define if you have the 'intmax_t' type in <stdint.h> or <inttypes.h>.])
  fi
])

dnl An alternative would be to explicitly test for 'intmax_t'.

AC_DEFUN([gt_AC_TYPE_INTMAX_T],
[
  AC_REQUIRE([gl_AC_HEADER_INTTYPES_H])
  AC_REQUIRE([gl_AC_HEADER_STDINT_H])
  AC_CACHE_CHECK([for intmax_t], [gt_cv_c_intmax_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[
#include <stddef.h>
#include <stdlib.h>
#if HAVE_STDINT_H_WITH_UINTMAX
#include <stdint.h>
#endif
#if HAVE_INTTYPES_H_WITH_UINTMAX
#include <inttypes.h>
#endif
          ]],
          [[intmax_t x = -1; return !x;]])],
       [gt_cv_c_intmax_t=yes],
       [gt_cv_c_intmax_t=no])])
  if test $gt_cv_c_intmax_t = yes; then
    AC_DEFINE([HAVE_INTMAX_T], [1],
      [Define if you have the 'intmax_t' type in <stdint.h> or <inttypes.h>.])
  else
    AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
    test $ac_cv_type_long_long_int = yes \
      && ac_type='long long' \
      || ac_type='long'
    AC_DEFINE_UNQUOTED([intmax_t], [$ac_type],
     [Define to long or long long if <stdint.h> and <inttypes.h> don't define.])
  fi
])

# inttypes-pri.m4 serial 7 (gettext-0.18.2)
dnl Copyright (C) 1997-2002, 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_PREREQ([2.53])

# Define PRI_MACROS_BROKEN if <inttypes.h> exists and defines the PRI*
# macros to non-string values.  This is the case on AIX 4.3.3.

AC_DEFUN([gt_INTTYPES_PRI],
[
  AC_CHECK_HEADERS([inttypes.h])
  if test $ac_cv_header_inttypes_h = yes; then
    AC_CACHE_CHECK([whether the inttypes.h PRIxNN macros are broken],
      [gt_cv_inttypes_pri_broken],
      [
        AC_COMPILE_IFELSE(
          [AC_LANG_PROGRAM(
             [[
#include <inttypes.h>
#ifdef PRId32
char *p = PRId32;
#endif
             ]],
             [[]])],
          [gt_cv_inttypes_pri_broken=no],
          [gt_cv_inttypes_pri_broken=yes])
      ])
  fi
  if test "$gt_cv_inttypes_pri_broken" = yes; then
    AC_DEFINE_UNQUOTED([PRI_MACROS_BROKEN], [1],
      [Define if <inttypes.h> exists and defines unusable PRI* macros.])
    PRI_MACROS_BROKEN=1
  else
    PRI_MACROS_BROKEN=0
  fi
  AC_SUBST([PRI_MACROS_BROKEN])
])

# inttypes.m4 serial 26
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Derek Price, Bruno Haible.
dnl Test whether <inttypes.h> is supported or must be substituted.

AC_DEFUN([gl_INTTYPES_H],
[
  AC_REQUIRE([gl_INTTYPES_INCOMPLETE])
  gl_INTTYPES_PRI_SCN
])

AC_DEFUN_ONCE([gl_INTTYPES_INCOMPLETE],
[
  AC_REQUIRE([gl_STDINT_H])
  AC_CHECK_HEADERS_ONCE([inttypes.h])

  dnl Override <inttypes.h> always, so that the portability warnings work.
  AC_REQUIRE([gl_INTTYPES_H_DEFAULTS])
  gl_CHECK_NEXT_HEADERS([inttypes.h])

  AC_REQUIRE([gl_MULTIARCH])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[#include <inttypes.h>
    ]], [imaxabs imaxdiv strtoimax strtoumax])
])

# Ensure that the PRI* and SCN* macros are defined appropriately.
AC_DEFUN([gl_INTTYPES_PRI_SCN],
[
  AC_REQUIRE([gt_INTTYPES_PRI])

  PRIPTR_PREFIX=
  if test -n "$STDINT_H"; then
    dnl Using the gnulib <stdint.h>. It always defines intptr_t to 'long'.
    PRIPTR_PREFIX='"l"'
  else
    dnl Using the system's <stdint.h>.
    for glpfx in '' l ll I64; do
      case $glpfx in
        '')  gltype1='int';;
        l)   gltype1='long int';;
        ll)  gltype1='long long int';;
        I64) gltype1='__int64';;
      esac
      AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM([[#include <stdint.h>
           extern intptr_t foo;
           extern $gltype1 foo;]])],
        [PRIPTR_PREFIX='"'$glpfx'"'])
      test -n "$PRIPTR_PREFIX" && break
    done
  fi
  AC_SUBST([PRIPTR_PREFIX])

  gl_INTTYPES_CHECK_LONG_LONG_INT_CONDITION(
    [INT32_MAX_LT_INTMAX_MAX],
    [defined INT32_MAX && defined INTMAX_MAX],
    [INT32_MAX < INTMAX_MAX],
    [sizeof (int) < sizeof (long long int)])
  if test $APPLE_UNIVERSAL_BUILD = 0; then
    gl_INTTYPES_CHECK_LONG_LONG_INT_CONDITION(
      [INT64_MAX_EQ_LONG_MAX],
      [defined INT64_MAX],
      [INT64_MAX == LONG_MAX],
      [sizeof (long long int) == sizeof (long int)])
  else
    INT64_MAX_EQ_LONG_MAX=-1
  fi
  gl_INTTYPES_CHECK_LONG_LONG_INT_CONDITION(
    [UINT32_MAX_LT_UINTMAX_MAX],
    [defined UINT32_MAX && defined UINTMAX_MAX],
    [UINT32_MAX < UINTMAX_MAX],
    [sizeof (unsigned int) < sizeof (unsigned long long int)])
  if test $APPLE_UNIVERSAL_BUILD = 0; then
    gl_INTTYPES_CHECK_LONG_LONG_INT_CONDITION(
      [UINT64_MAX_EQ_ULONG_MAX],
      [defined UINT64_MAX],
      [UINT64_MAX == ULONG_MAX],
      [sizeof (unsigned long long int) == sizeof (unsigned long int)])
  else
    UINT64_MAX_EQ_ULONG_MAX=-1
  fi
])

# Define the symbol $1 to be 1 if the condition is true, 0 otherwise.
# If $2 is true, the condition is $3; otherwise if long long int is supported
# approximate the condition with $4; otherwise, assume the condition is false.
# The condition should work on all C99 platforms; the approximations should be
# good enough to work on all practical pre-C99 platforms.
# $2 is evaluated by the C preprocessor, $3 and $4 as compile-time constants.
AC_DEFUN([gl_INTTYPES_CHECK_LONG_LONG_INT_CONDITION],
[
  AC_CACHE_CHECK([whether $3],
    [gl_cv_test_$1],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[/* Work also in C++ mode.  */
            #define __STDC_LIMIT_MACROS 1

            /* Work if build is not clean.  */
            #define _GL_JUST_INCLUDE_SYSTEM_STDINT_H

            #include <limits.h>
            #if HAVE_STDINT_H
             #include <stdint.h>
            #endif

            #if $2
             #define CONDITION ($3)
            #elif HAVE_LONG_LONG_INT
             #define CONDITION ($4)
            #else
             #define CONDITION 0
            #endif
            int test[CONDITION ? 1 : -1];]])],
       [gl_cv_test_$1=yes],
       [gl_cv_test_$1=no])])
  if test $gl_cv_test_$1 = yes; then
    $1=1;
  else
    $1=0;
  fi
  AC_SUBST([$1])
])

AC_DEFUN([gl_INTTYPES_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_INTTYPES_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
])

AC_DEFUN([gl_INTTYPES_H_DEFAULTS],
[
  GNULIB_IMAXABS=0;      AC_SUBST([GNULIB_IMAXABS])
  GNULIB_IMAXDIV=0;      AC_SUBST([GNULIB_IMAXDIV])
  GNULIB_STRTOIMAX=0;    AC_SUBST([GNULIB_STRTOIMAX])
  GNULIB_STRTOUMAX=0;    AC_SUBST([GNULIB_STRTOUMAX])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_DECL_IMAXABS=1;   AC_SUBST([HAVE_DECL_IMAXABS])
  HAVE_DECL_IMAXDIV=1;   AC_SUBST([HAVE_DECL_IMAXDIV])
  HAVE_DECL_STRTOIMAX=1; AC_SUBST([HAVE_DECL_STRTOIMAX])
  HAVE_DECL_STRTOUMAX=1; AC_SUBST([HAVE_DECL_STRTOUMAX])
  REPLACE_STRTOIMAX=0;   AC_SUBST([REPLACE_STRTOIMAX])
  REPLACE_STRTOUMAX=0;   AC_SUBST([REPLACE_STRTOUMAX])
  INT32_MAX_LT_INTMAX_MAX=1;  AC_SUBST([INT32_MAX_LT_INTMAX_MAX])
  INT64_MAX_EQ_LONG_MAX='defined _LP64';  AC_SUBST([INT64_MAX_EQ_LONG_MAX])
  PRI_MACROS_BROKEN=0;   AC_SUBST([PRI_MACROS_BROKEN])
  PRIPTR_PREFIX=__PRIPTR_PREFIX;  AC_SUBST([PRIPTR_PREFIX])
  UINT32_MAX_LT_UINTMAX_MAX=1;  AC_SUBST([UINT32_MAX_LT_UINTMAX_MAX])
  UINT64_MAX_EQ_ULONG_MAX='defined _LP64';  AC_SUBST([UINT64_MAX_EQ_ULONG_MAX])
])

# inttypes_h.m4 serial 10
dnl Copyright (C) 1997-2004, 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

# Define HAVE_INTTYPES_H_WITH_UINTMAX if <inttypes.h> exists,
# doesn't clash with <sys/types.h>, and declares uintmax_t.

AC_DEFUN([gl_AC_HEADER_INTTYPES_H],
[
  AC_CACHE_CHECK([for inttypes.h], [gl_cv_header_inttypes_h],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[
#include <sys/types.h>
#include <inttypes.h>
          ]],
          [[uintmax_t i = (uintmax_t) -1; return !i;]])],
       [gl_cv_header_inttypes_h=yes],
       [gl_cv_header_inttypes_h=no])])
  if test $gl_cv_header_inttypes_h = yes; then
    AC_DEFINE_UNQUOTED([HAVE_INTTYPES_H_WITH_UINTMAX], [1],
      [Define if <inttypes.h> exists, doesn't clash with <sys/types.h>,
       and declares uintmax_t. ])
  fi
])

# Enable large files on systems where this is not the default.

# Copyright 1992-1996, 1998-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# The following implementation works around a problem in autoconf <= 2.69;
# AC_SYS_LARGEFILE does not configure for large inodes on Mac OS X 10.5,
# or configures them incorrectly in some cases.
m4_version_prereq([2.70], [] ,[

# _AC_SYS_LARGEFILE_TEST_INCLUDES
# -------------------------------
m4_define([_AC_SYS_LARGEFILE_TEST_INCLUDES],
[@%:@include <sys/types.h>
 /* Check that off_t can represent 2**63 - 1 correctly.
    We can't simply define LARGE_OFF_T to be 9223372036854775807,
    since some C++ compilers masquerading as C compilers
    incorrectly reject 9223372036854775807.  */
@%:@define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
  int off_t_is_large[[(LARGE_OFF_T % 2147483629 == 721
                       && LARGE_OFF_T % 2147483647 == 1)
                      ? 1 : -1]];[]dnl
])


# _AC_SYS_LARGEFILE_MACRO_VALUE(C-MACRO, VALUE,
#                               CACHE-VAR,
#                               DESCRIPTION,
#                               PROLOGUE, [FUNCTION-BODY])
# --------------------------------------------------------
m4_define([_AC_SYS_LARGEFILE_MACRO_VALUE],
[AC_CACHE_CHECK([for $1 value needed for large files], [$3],
[while :; do
  m4_ifval([$6], [AC_LINK_IFELSE], [AC_COMPILE_IFELSE])(
    [AC_LANG_PROGRAM([$5], [$6])],
    [$3=no; break])
  m4_ifval([$6], [AC_LINK_IFELSE], [AC_COMPILE_IFELSE])(
    [AC_LANG_PROGRAM([@%:@define $1 $2
$5], [$6])],
    [$3=$2; break])
  $3=unknown
  break
done])
case $$3 in #(
  no | unknown) ;;
  *) AC_DEFINE_UNQUOTED([$1], [$$3], [$4]);;
esac
rm -rf conftest*[]dnl
])# _AC_SYS_LARGEFILE_MACRO_VALUE


# AC_SYS_LARGEFILE
# ----------------
# By default, many hosts won't let programs access large files;
# one must use special compiler options to get large-file access to work.
# For more details about this brain damage please see:
# http://www.unix-systems.org/version2/whatsnew/lfs20mar.html
AC_DEFUN([AC_SYS_LARGEFILE],
[AC_ARG_ENABLE(largefile,
               [  --disable-largefile     omit support for large files])
if test "$enable_largefile" != no; then

  AC_CACHE_CHECK([for special C compiler options needed for large files],
    ac_cv_sys_largefile_CC,
    [ac_cv_sys_largefile_CC=no
     if test "$GCC" != yes; then
       ac_save_CC=$CC
       while :; do
         # IRIX 6.2 and later do not support large files by default,
         # so use the C compiler's -n32 option if that helps.
         AC_LANG_CONFTEST([AC_LANG_PROGRAM([_AC_SYS_LARGEFILE_TEST_INCLUDES])])
         AC_COMPILE_IFELSE([], [break])
         CC="$CC -n32"
         AC_COMPILE_IFELSE([], [ac_cv_sys_largefile_CC=' -n32'; break])
         break
       done
       CC=$ac_save_CC
       rm -f conftest.$ac_ext
    fi])
  if test "$ac_cv_sys_largefile_CC" != no; then
    CC=$CC$ac_cv_sys_largefile_CC
  fi

  _AC_SYS_LARGEFILE_MACRO_VALUE(_FILE_OFFSET_BITS, 64,
    ac_cv_sys_file_offset_bits,
    [Number of bits in a file offset, on hosts where this is settable.],
    [_AC_SYS_LARGEFILE_TEST_INCLUDES])
  if test $ac_cv_sys_file_offset_bits = unknown; then
    _AC_SYS_LARGEFILE_MACRO_VALUE(_LARGE_FILES, 1,
      ac_cv_sys_large_files,
      [Define for large files, on AIX-style hosts.],
      [_AC_SYS_LARGEFILE_TEST_INCLUDES])
  fi

  AC_DEFINE([_DARWIN_USE_64_BIT_INODE], [1],
    [Enable large inode numbers on Mac OS X 10.5.])
fi
])# AC_SYS_LARGEFILE
])# m4_version_prereq 2.70

# Enable large files on systems where this is implemented by Gnulib, not by the
# system headers.
# Set the variables WINDOWS_64_BIT_OFF_T, WINDOWS_64_BIT_ST_SIZE if Gnulib
# overrides ensure that off_t or 'struct size.st_size' are 64-bit, respectively.
AC_DEFUN([gl_LARGEFILE],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  case "$host_os" in
    mingw*)
      dnl Native Windows.
      dnl mingw64 defines off_t to a 64-bit type already, if
      dnl _FILE_OFFSET_BITS=64, which is ensured by AC_SYS_LARGEFILE.
      AC_CACHE_CHECK([for 64-bit off_t], [gl_cv_type_off_t_64],
        [AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM(
              [[#include <sys/types.h>
                int verify_off_t_size[sizeof (off_t) >= 8 ? 1 : -1];
              ]],
              [[]])],
           [gl_cv_type_off_t_64=yes], [gl_cv_type_off_t_64=no])
        ])
      if test $gl_cv_type_off_t_64 = no; then
        WINDOWS_64_BIT_OFF_T=1
      else
        WINDOWS_64_BIT_OFF_T=0
      fi
      dnl Some mingw versions define, if _FILE_OFFSET_BITS=64, 'struct stat'
      dnl to 'struct _stat32i64' or 'struct _stat64' (depending on
      dnl _USE_32BIT_TIME_T), which has a 32-bit st_size member.
      AC_CACHE_CHECK([for 64-bit st_size], [gl_cv_member_st_size_64],
        [AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM(
              [[#include <sys/types.h>
                struct stat buf;
                int verify_st_size_size[sizeof (buf.st_size) >= 8 ? 1 : -1];
              ]],
              [[]])],
           [gl_cv_member_st_size_64=yes], [gl_cv_member_st_size_64=no])
        ])
      if test $gl_cv_member_st_size_64 = no; then
        WINDOWS_64_BIT_ST_SIZE=1
      else
        WINDOWS_64_BIT_ST_SIZE=0
      fi
      ;;
    *)
      dnl Nothing to do on gnulib's side.
      dnl A 64-bit off_t is
      dnl   - already the default on Mac OS X, FreeBSD, NetBSD, OpenBSD, IRIX,
      dnl     OSF/1, Cygwin,
      dnl   - enabled by _FILE_OFFSET_BITS=64 (ensured by AC_SYS_LARGEFILE) on
      dnl     glibc, HP-UX, Solaris,
      dnl   - enabled by _LARGE_FILES=1 (ensured by AC_SYS_LARGEFILE) on AIX,
      dnl   - impossible to achieve on Minix 3.1.8.
      WINDOWS_64_BIT_OFF_T=0
      WINDOWS_64_BIT_ST_SIZE=0
      ;;
  esac
])

# serial 17
# Determine whether we need the lchown wrapper.

dnl Copyright (C) 1998, 2001, 2003-2007, 2009-2018 Free Software Foundation,
dnl Inc.

dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering.
dnl Provide lchown on systems that lack it, and work around bugs
dnl on systems that have it.

AC_DEFUN([gl_FUNC_LCHOWN],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_CHOWN])
  AC_CHECK_FUNCS_ONCE([lchmod])
  AC_CHECK_FUNCS([lchown])
  if test $ac_cv_func_lchown = no; then
    HAVE_LCHOWN=0
  else
    dnl Trailing slash and ctime bugs in chown also occur in lchown.
    case "$gl_cv_func_chown_slash_works" in
      *yes) ;;
      *)
        REPLACE_LCHOWN=1
        ;;
    esac
    case "$gl_cv_func_chown_ctime_works" in
      *yes) ;;
      *)
        REPLACE_LCHOWN=1
        ;;
    esac
  fi
])

dnl Check whether limits.h has needed features.

dnl Copyright 2016-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

AC_DEFUN_ONCE([gl_LIMITS_H],
[
  gl_CHECK_NEXT_HEADERS([limits.h])

  AC_CACHE_CHECK([whether limits.h has ULLONG_WIDTH etc.],
    [gl_cv_header_limits_width],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM([[#ifndef __STDC_WANT_IEC_60559_BFP_EXT__
                           #define __STDC_WANT_IEC_60559_BFP_EXT__ 1
                          #endif
                          #include <limits.h>
                          int ullw = ULLONG_WIDTH;]])],
       [gl_cv_header_limits_width=yes],
       [gl_cv_header_limits_width=no])])
  if test "$gl_cv_header_limits_width" = yes; then
    LIMITS_H=
  else
    LIMITS_H=limits.h
  fi
  AC_SUBST([LIMITS_H])
  AM_CONDITIONAL([GL_GENERATE_LIMITS_H], [test -n "$LIMITS_H"])
])

# localcharset.m4 serial 7
dnl Copyright (C) 2002, 2004, 2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_LOCALCHARSET],
[
  dnl Prerequisites of lib/localcharset.c.
  AC_REQUIRE([AM_LANGINFO_CODESET])
  AC_REQUIRE([gl_FCNTL_O_FLAGS])
  AC_CHECK_DECLS_ONCE([getc_unlocked])

  dnl Prerequisites of the lib/Makefile.am snippet.
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_GLIBC21])
])

# locale-fr.m4 serial 18
dnl Copyright (C) 2003, 2005-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

dnl Determine the name of a french locale with traditional encoding.
AC_DEFUN([gt_LOCALE_FR],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AM_LANGINFO_CODESET])
  AC_CACHE_CHECK([for a traditional french locale], [gt_cv_locale_fr], [
    AC_LANG_CONFTEST([AC_LANG_SOURCE([
changequote(,)dnl
#include <locale.h>
#include <time.h>
#if HAVE_LANGINFO_CODESET
# include <langinfo.h>
#endif
#include <stdlib.h>
#include <string.h>
struct tm t;
char buf[16];
int main () {
  /* On BeOS and Haiku, locales are not implemented in libc.  Rather, libintl
     imitates locale dependent behaviour by looking at the environment
     variables, and all locales use the UTF-8 encoding.  */
#if defined __BEOS__ || defined __HAIKU__
  return 1;
#else
  /* Check whether the given locale name is recognized by the system.  */
# if (defined _WIN32 || defined __WIN32__) && !defined __CYGWIN__
  /* On native Windows, setlocale(category, "") looks at the system settings,
     not at the environment variables.  Also, when an encoding suffix such
     as ".65001" or ".54936" is specified, it succeeds but sets the LC_CTYPE
     category of the locale to "C".  */
  if (setlocale (LC_ALL, getenv ("LC_ALL")) == NULL
      || strcmp (setlocale (LC_CTYPE, NULL), "C") == 0)
    return 1;
# else
  if (setlocale (LC_ALL, "") == NULL) return 1;
# endif
  /* Check whether nl_langinfo(CODESET) is nonempty and not "ASCII" or "646".
     On Mac OS X 10.3.5 (Darwin 7.5) in the fr_FR locale, nl_langinfo(CODESET)
     is empty, and the behaviour of Tcl 8.4 in this locale is not useful.
     On OpenBSD 4.0, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "646". In this situation,
     some unit tests fail.
     On MirBSD 10, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "UTF-8".  */
# if HAVE_LANGINFO_CODESET
  {
    const char *cs = nl_langinfo (CODESET);
    if (cs[0] == '\0' || strcmp (cs, "ASCII") == 0 || strcmp (cs, "646") == 0
        || strcmp (cs, "UTF-8") == 0)
      return 1;
  }
# endif
# ifdef __CYGWIN__
  /* On Cygwin, avoid locale names without encoding suffix, because the
     locale_charset() function relies on the encoding suffix.  Note that
     LC_ALL is set on the command line.  */
  if (strchr (getenv ("LC_ALL"), '.') == NULL) return 1;
# endif
  /* Check whether in the abbreviation of the second month, the second
     character (should be U+00E9: LATIN SMALL LETTER E WITH ACUTE) is only
     one byte long. This excludes the UTF-8 encoding.  */
  t.tm_year = 1975 - 1900; t.tm_mon = 2 - 1; t.tm_mday = 4;
  if (strftime (buf, sizeof (buf), "%b", &t) < 3 || buf[2] != 'v') return 1;
# if !defined __BIONIC__ /* Bionic libc's 'struct lconv' is just a dummy.  */
  /* Check whether the decimal separator is a comma.
     On NetBSD 3.0 in the fr_FR.ISO8859-1 locale, localeconv()->decimal_point
     are nl_langinfo(RADIXCHAR) are both ".".  */
  if (localeconv () ->decimal_point[0] != ',') return 1;
# endif
  return 0;
#endif
}
changequote([,])dnl
      ])])
    if AC_TRY_EVAL([ac_link]) && test -s conftest$ac_exeext; then
      case "$host_os" in
        # Handle native Windows specially, because there setlocale() interprets
        # "ar" as "Arabic" or "Arabic_Saudi Arabia.1256",
        # "fr" or "fra" as "French" or "French_France.1252",
        # "ge"(!) or "deu"(!) as "German" or "German_Germany.1252",
        # "ja" as "Japanese" or "Japanese_Japan.932",
        # and similar.
        mingw*)
          # Test for the native Windows locale name.
          if (LC_ALL=French_France.1252 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_fr=French_France.1252
          else
            # None found.
            gt_cv_locale_fr=none
          fi
          ;;
        *)
          # Setting LC_ALL is not enough. Need to set LC_TIME to empty, because
          # otherwise on Mac OS X 10.3.5 the LC_TIME=C from the beginning of the
          # configure script would override the LC_ALL setting. Likewise for
          # LC_CTYPE, which is also set at the beginning of the configure script.
          # Test for the usual locale name.
          if (LC_ALL=fr_FR LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_fr=fr_FR
          else
            # Test for the locale name with explicit encoding suffix.
            if (LC_ALL=fr_FR.ISO-8859-1 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
              gt_cv_locale_fr=fr_FR.ISO-8859-1
            else
              # Test for the AIX, OSF/1, FreeBSD, NetBSD, OpenBSD locale name.
              if (LC_ALL=fr_FR.ISO8859-1 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                gt_cv_locale_fr=fr_FR.ISO8859-1
              else
                # Test for the HP-UX locale name.
                if (LC_ALL=fr_FR.iso88591 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                  gt_cv_locale_fr=fr_FR.iso88591
                else
                  # Test for the Solaris 7 locale name.
                  if (LC_ALL=fr LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                    gt_cv_locale_fr=fr
                  else
                    # None found.
                    gt_cv_locale_fr=none
                  fi
                fi
              fi
            fi
          fi
          ;;
      esac
    fi
    rm -fr conftest*
  ])
  LOCALE_FR=$gt_cv_locale_fr
  AC_SUBST([LOCALE_FR])
])

dnl Determine the name of a french locale with UTF-8 encoding.
AC_DEFUN([gt_LOCALE_FR_UTF8],
[
  AC_REQUIRE([AM_LANGINFO_CODESET])
  AC_CACHE_CHECK([for a french Unicode locale], [gt_cv_locale_fr_utf8], [
    AC_LANG_CONFTEST([AC_LANG_SOURCE([
changequote(,)dnl
#include <locale.h>
#include <time.h>
#if HAVE_LANGINFO_CODESET
# include <langinfo.h>
#endif
#include <stdlib.h>
#include <string.h>
struct tm t;
char buf[16];
int main () {
  /* On BeOS and Haiku, locales are not implemented in libc.  Rather, libintl
     imitates locale dependent behaviour by looking at the environment
     variables, and all locales use the UTF-8 encoding.  */
#if !(defined __BEOS__ || defined __HAIKU__)
  /* Check whether the given locale name is recognized by the system.  */
# if (defined _WIN32 || defined __WIN32__) && !defined __CYGWIN__
  /* On native Windows, setlocale(category, "") looks at the system settings,
     not at the environment variables.  Also, when an encoding suffix such
     as ".65001" or ".54936" is specified, it succeeds but sets the LC_CTYPE
     category of the locale to "C".  */
  if (setlocale (LC_ALL, getenv ("LC_ALL")) == NULL
      || strcmp (setlocale (LC_CTYPE, NULL), "C") == 0)
    return 1;
# else
  if (setlocale (LC_ALL, "") == NULL) return 1;
# endif
  /* Check whether nl_langinfo(CODESET) is nonempty and not "ASCII" or "646".
     On Mac OS X 10.3.5 (Darwin 7.5) in the fr_FR locale, nl_langinfo(CODESET)
     is empty, and the behaviour of Tcl 8.4 in this locale is not useful.
     On OpenBSD 4.0, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "646". In this situation,
     some unit tests fail.  */
# if HAVE_LANGINFO_CODESET
  {
    const char *cs = nl_langinfo (CODESET);
    if (cs[0] == '\0' || strcmp (cs, "ASCII") == 0 || strcmp (cs, "646") == 0)
      return 1;
  }
# endif
# ifdef __CYGWIN__
  /* On Cygwin, avoid locale names without encoding suffix, because the
     locale_charset() function relies on the encoding suffix.  Note that
     LC_ALL is set on the command line.  */
  if (strchr (getenv ("LC_ALL"), '.') == NULL) return 1;
# endif
  /* Check whether in the abbreviation of the second month, the second
     character (should be U+00E9: LATIN SMALL LETTER E WITH ACUTE) is
     two bytes long, with UTF-8 encoding.  */
  t.tm_year = 1975 - 1900; t.tm_mon = 2 - 1; t.tm_mday = 4;
  if (strftime (buf, sizeof (buf), "%b", &t) < 4
      || buf[1] != (char) 0xc3 || buf[2] != (char) 0xa9 || buf[3] != 'v')
    return 1;
#endif
#if !defined __BIONIC__ /* Bionic libc's 'struct lconv' is just a dummy.  */
  /* Check whether the decimal separator is a comma.
     On NetBSD 3.0 in the fr_FR.ISO8859-1 locale, localeconv()->decimal_point
     are nl_langinfo(RADIXCHAR) are both ".".  */
  if (localeconv () ->decimal_point[0] != ',') return 1;
#endif
  return 0;
}
changequote([,])dnl
      ])])
    if AC_TRY_EVAL([ac_link]) && test -s conftest$ac_exeext; then
      case "$host_os" in
        # Handle native Windows specially, because there setlocale() interprets
        # "ar" as "Arabic" or "Arabic_Saudi Arabia.1256",
        # "fr" or "fra" as "French" or "French_France.1252",
        # "ge"(!) or "deu"(!) as "German" or "German_Germany.1252",
        # "ja" as "Japanese" or "Japanese_Japan.932",
        # and similar.
        mingw*)
          # Test for the hypothetical native Windows locale name.
          if (LC_ALL=French_France.65001 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_fr_utf8=French_France.65001
          else
            # None found.
            gt_cv_locale_fr_utf8=none
          fi
          ;;
        *)
          # Setting LC_ALL is not enough. Need to set LC_TIME to empty, because
          # otherwise on Mac OS X 10.3.5 the LC_TIME=C from the beginning of the
          # configure script would override the LC_ALL setting. Likewise for
          # LC_CTYPE, which is also set at the beginning of the configure script.
          # Test for the usual locale name.
          if (LC_ALL=fr_FR LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_fr_utf8=fr_FR
          else
            # Test for the locale name with explicit encoding suffix.
            if (LC_ALL=fr_FR.UTF-8 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
              gt_cv_locale_fr_utf8=fr_FR.UTF-8
            else
              # Test for the Solaris 7 locale name.
              if (LC_ALL=fr.UTF-8 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                gt_cv_locale_fr_utf8=fr.UTF-8
              else
                # None found.
                gt_cv_locale_fr_utf8=none
              fi
            fi
          fi
          ;;
      esac
    fi
    rm -fr conftest*
  ])
  LOCALE_FR_UTF8=$gt_cv_locale_fr_utf8
  AC_SUBST([LOCALE_FR_UTF8])
])

# locale-ja.m4 serial 13
dnl Copyright (C) 2003, 2005-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

dnl Determine the name of a japanese locale with EUC-JP encoding.
AC_DEFUN([gt_LOCALE_JA],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AM_LANGINFO_CODESET])
  AC_CACHE_CHECK([for a traditional japanese locale], [gt_cv_locale_ja], [
    AC_LANG_CONFTEST([AC_LANG_SOURCE([
changequote(,)dnl
#include <locale.h>
#include <time.h>
#if HAVE_LANGINFO_CODESET
# include <langinfo.h>
#endif
#include <stdlib.h>
#include <string.h>
struct tm t;
char buf[16];
int main ()
{
  /* On BeOS and Haiku, locales are not implemented in libc.  Rather, libintl
     imitates locale dependent behaviour by looking at the environment
     variables, and all locales use the UTF-8 encoding.  */
#if defined __BEOS__ || defined __HAIKU__
  return 1;
#else
  /* Check whether the given locale name is recognized by the system.  */
# if (defined _WIN32 || defined __WIN32__) && !defined __CYGWIN__
  /* On native Windows, setlocale(category, "") looks at the system settings,
     not at the environment variables.  Also, when an encoding suffix such
     as ".65001" or ".54936" is specified, it succeeds but sets the LC_CTYPE
     category of the locale to "C".  */
  if (setlocale (LC_ALL, getenv ("LC_ALL")) == NULL
      || strcmp (setlocale (LC_CTYPE, NULL), "C") == 0)
    return 1;
# else
  if (setlocale (LC_ALL, "") == NULL) return 1;
# endif
  /* Check whether nl_langinfo(CODESET) is nonempty and not "ASCII" or "646".
     On Mac OS X 10.3.5 (Darwin 7.5) in the fr_FR locale, nl_langinfo(CODESET)
     is empty, and the behaviour of Tcl 8.4 in this locale is not useful.
     On OpenBSD 4.0, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "646". In this situation,
     some unit tests fail.
     On MirBSD 10, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "UTF-8".  */
# if HAVE_LANGINFO_CODESET
  {
    const char *cs = nl_langinfo (CODESET);
    if (cs[0] == '\0' || strcmp (cs, "ASCII") == 0 || strcmp (cs, "646") == 0
        || strcmp (cs, "UTF-8") == 0)
      return 1;
  }
# endif
# ifdef __CYGWIN__
  /* On Cygwin, avoid locale names without encoding suffix, because the
     locale_charset() function relies on the encoding suffix.  Note that
     LC_ALL is set on the command line.  */
  if (strchr (getenv ("LC_ALL"), '.') == NULL) return 1;
# endif
  /* Check whether MB_CUR_MAX is > 1.  This excludes the dysfunctional locales
     on Cygwin 1.5.x.  */
  if (MB_CUR_MAX == 1)
    return 1;
  /* Check whether in a month name, no byte in the range 0x80..0x9F occurs.
     This excludes the UTF-8 encoding (except on MirBSD).  */
  {
    const char *p;
    t.tm_year = 1975 - 1900; t.tm_mon = 2 - 1; t.tm_mday = 4;
    if (strftime (buf, sizeof (buf), "%B", &t) < 2) return 1;
    for (p = buf; *p != '\0'; p++)
      if ((unsigned char) *p >= 0x80 && (unsigned char) *p < 0xa0)
        return 1;
  }
  return 0;
#endif
}
changequote([,])dnl
      ])])
    if AC_TRY_EVAL([ac_link]) && test -s conftest$ac_exeext; then
      case "$host_os" in
        # Handle native Windows specially, because there setlocale() interprets
        # "ar" as "Arabic" or "Arabic_Saudi Arabia.1256",
        # "fr" or "fra" as "French" or "French_France.1252",
        # "ge"(!) or "deu"(!) as "German" or "German_Germany.1252",
        # "ja" as "Japanese" or "Japanese_Japan.932",
        # and similar.
        mingw*)
          # Note that on native Windows, the Japanese locale is
          # Japanese_Japan.932, and CP932 is very different from EUC-JP, so we
          # cannot use it here.
          gt_cv_locale_ja=none
          ;;
        *)
          # Setting LC_ALL is not enough. Need to set LC_TIME to empty, because
          # otherwise on Mac OS X 10.3.5 the LC_TIME=C from the beginning of the
          # configure script would override the LC_ALL setting. Likewise for
          # LC_CTYPE, which is also set at the beginning of the configure script.
          # Test for the AIX locale name.
          if (LC_ALL=ja_JP LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_ja=ja_JP
          else
            # Test for the locale name with explicit encoding suffix.
            if (LC_ALL=ja_JP.EUC-JP LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
              gt_cv_locale_ja=ja_JP.EUC-JP
            else
              # Test for the HP-UX, OSF/1, NetBSD locale name.
              if (LC_ALL=ja_JP.eucJP LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                gt_cv_locale_ja=ja_JP.eucJP
              else
                # Test for the IRIX, FreeBSD locale name.
                if (LC_ALL=ja_JP.EUC LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                  gt_cv_locale_ja=ja_JP.EUC
                else
                  # Test for the Solaris 7 locale name.
                  if (LC_ALL=ja LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
                    gt_cv_locale_ja=ja
                  else
                    # Special test for NetBSD 1.6.
                    if test -f /usr/share/locale/ja_JP.eucJP/LC_CTYPE; then
                      gt_cv_locale_ja=ja_JP.eucJP
                    else
                      # None found.
                      gt_cv_locale_ja=none
                    fi
                  fi
                fi
              fi
            fi
          fi
          ;;
      esac
    fi
    rm -fr conftest*
  ])
  LOCALE_JA=$gt_cv_locale_ja
  AC_SUBST([LOCALE_JA])
])

# locale-zh.m4 serial 13
dnl Copyright (C) 2003, 2005-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

dnl Determine the name of a chinese locale with GB18030 encoding.
AC_DEFUN([gt_LOCALE_ZH_CN],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AM_LANGINFO_CODESET])
  AC_CACHE_CHECK([for a transitional chinese locale], [gt_cv_locale_zh_CN], [
    AC_LANG_CONFTEST([AC_LANG_SOURCE([
changequote(,)dnl
#include <locale.h>
#include <stdlib.h>
#include <time.h>
#if HAVE_LANGINFO_CODESET
# include <langinfo.h>
#endif
#include <stdlib.h>
#include <string.h>
struct tm t;
char buf[16];
int main ()
{
  /* On BeOS and Haiku, locales are not implemented in libc.  Rather, libintl
     imitates locale dependent behaviour by looking at the environment
     variables, and all locales use the UTF-8 encoding.  */
#if defined __BEOS__ || defined __HAIKU__
  return 1;
#else
  /* Check whether the given locale name is recognized by the system.  */
# if (defined _WIN32 || defined __WIN32__) && !defined __CYGWIN__
  /* On native Windows, setlocale(category, "") looks at the system settings,
     not at the environment variables.  Also, when an encoding suffix such
     as ".65001" or ".54936" is specified, it succeeds but sets the LC_CTYPE
     category of the locale to "C".  */
  if (setlocale (LC_ALL, getenv ("LC_ALL")) == NULL
      || strcmp (setlocale (LC_CTYPE, NULL), "C") == 0)
    return 1;
# else
  if (setlocale (LC_ALL, "") == NULL) return 1;
# endif
  /* Check whether nl_langinfo(CODESET) is nonempty and not "ASCII" or "646".
     On Mac OS X 10.3.5 (Darwin 7.5) in the fr_FR locale, nl_langinfo(CODESET)
     is empty, and the behaviour of Tcl 8.4 in this locale is not useful.
     On OpenBSD 4.0, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "646". In this situation,
     some unit tests fail.
     On MirBSD 10, when an unsupported locale is specified, setlocale()
     succeeds but then nl_langinfo(CODESET) is "UTF-8".  */
# if HAVE_LANGINFO_CODESET
  {
    const char *cs = nl_langinfo (CODESET);
    if (cs[0] == '\0' || strcmp (cs, "ASCII") == 0 || strcmp (cs, "646") == 0
        || strcmp (cs, "UTF-8") == 0)
      return 1;
  }
# endif
# ifdef __CYGWIN__
  /* On Cygwin, avoid locale names without encoding suffix, because the
     locale_charset() function relies on the encoding suffix.  Note that
     LC_ALL is set on the command line.  */
  if (strchr (getenv ("LC_ALL"), '.') == NULL) return 1;
# endif
  /* Check whether in a month name, no byte in the range 0x80..0x9F occurs.
     This excludes the UTF-8 encoding (except on MirBSD).  */
  {
    const char *p;
    t.tm_year = 1975 - 1900; t.tm_mon = 2 - 1; t.tm_mday = 4;
    if (strftime (buf, sizeof (buf), "%B", &t) < 2) return 1;
    for (p = buf; *p != '\0'; p++)
      if ((unsigned char) *p >= 0x80 && (unsigned char) *p < 0xa0)
        return 1;
  }
  /* Check whether a typical GB18030 multibyte sequence is recognized as a
     single wide character.  This excludes the GB2312 and GBK encodings.  */
  if (mblen ("\203\062\332\066", 5) != 4)
    return 1;
  return 0;
#endif
}
changequote([,])dnl
      ])])
    if AC_TRY_EVAL([ac_link]) && test -s conftest$ac_exeext; then
      case "$host_os" in
        # Handle native Windows specially, because there setlocale() interprets
        # "ar" as "Arabic" or "Arabic_Saudi Arabia.1256",
        # "fr" or "fra" as "French" or "French_France.1252",
        # "ge"(!) or "deu"(!) as "German" or "German_Germany.1252",
        # "ja" as "Japanese" or "Japanese_Japan.932",
        # and similar.
        mingw*)
          # Test for the hypothetical native Windows locale name.
          if (LC_ALL=Chinese_China.54936 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_zh_CN=Chinese_China.54936
          else
            # None found.
            gt_cv_locale_zh_CN=none
          fi
          ;;
        solaris2.8)
          # On Solaris 8, the locales zh_CN.GB18030, zh_CN.GBK, zh.GBK are
          # broken. One witness is the test case in gl_MBRTOWC_SANITYCHECK.
          # Another witness is that "LC_ALL=zh_CN.GB18030 bash -c true" dumps core.
          gt_cv_locale_zh_CN=none
          ;;
        *)
          # Setting LC_ALL is not enough. Need to set LC_TIME to empty, because
          # otherwise on Mac OS X 10.3.5 the LC_TIME=C from the beginning of the
          # configure script would override the LC_ALL setting. Likewise for
          # LC_CTYPE, which is also set at the beginning of the configure script.
          # Test for the locale name without encoding suffix.
          if (LC_ALL=zh_CN LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
            gt_cv_locale_zh_CN=zh_CN
          else
            # Test for the locale name with explicit encoding suffix.
            if (LC_ALL=zh_CN.GB18030 LC_TIME= LC_CTYPE= ./conftest; exit) 2>/dev/null; then
              gt_cv_locale_zh_CN=zh_CN.GB18030
            else
              # None found.
              gt_cv_locale_zh_CN=none
            fi
          fi
          ;;
      esac
    else
      # If there was a link error, due to mblen(), the system is so old that
      # it certainly doesn't have a chinese locale.
      gt_cv_locale_zh_CN=none
    fi
    rm -fr conftest*
  ])
  LOCALE_ZH_CN=$gt_cv_locale_zh_CN
  AC_SUBST([LOCALE_ZH_CN])
])

# localtime-buffer.m4 serial 1
dnl Copyright (C) 2017-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_LOCALTIME_BUFFER_DEFAULTS],
[
  NEED_LOCALTIME_BUFFER=0
])

dnl Macro invoked from other modules, to signal that the compilation of
dnl module 'localtime-buffer' is needed.
AC_DEFUN([gl_LOCALTIME_BUFFER_NEEDED],
[
  AC_REQUIRE([gl_LOCALTIME_BUFFER_DEFAULTS])
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  NEED_LOCALTIME_BUFFER=1
  REPLACE_GMTIME=1
  REPLACE_LOCALTIME=1
])

# longlong.m4 serial 17
dnl Copyright (C) 1999-2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

# Define HAVE_LONG_LONG_INT if 'long long int' works.
# This fixes a bug in Autoconf 2.61, and can be faster
# than what's in Autoconf 2.62 through 2.68.

# Note: If the type 'long long int' exists but is only 32 bits large
# (as on some very old compilers), HAVE_LONG_LONG_INT will not be
# defined. In this case you can treat 'long long int' like 'long int'.

AC_DEFUN([AC_TYPE_LONG_LONG_INT],
[
  AC_REQUIRE([AC_TYPE_UNSIGNED_LONG_LONG_INT])
  AC_CACHE_CHECK([for long long int], [ac_cv_type_long_long_int],
     [ac_cv_type_long_long_int=yes
      if test "x${ac_cv_prog_cc_c99-no}" = xno; then
        ac_cv_type_long_long_int=$ac_cv_type_unsigned_long_long_int
        if test $ac_cv_type_long_long_int = yes; then
          dnl Catch a bug in Tandem NonStop Kernel (OSS) cc -O circa 2004.
          dnl If cross compiling, assume the bug is not important, since
          dnl nobody cross compiles for this platform as far as we know.
          AC_RUN_IFELSE(
            [AC_LANG_PROGRAM(
               [[@%:@include <limits.h>
                 @%:@ifndef LLONG_MAX
                 @%:@ define HALF \
                          (1LL << (sizeof (long long int) * CHAR_BIT - 2))
                 @%:@ define LLONG_MAX (HALF - 1 + HALF)
                 @%:@endif]],
               [[long long int n = 1;
                 int i;
                 for (i = 0; ; i++)
                   {
                     long long int m = n << i;
                     if (m >> i != n)
                       return 1;
                     if (LLONG_MAX / 2 < m)
                       break;
                   }
                 return 0;]])],
            [],
            [ac_cv_type_long_long_int=no],
            [:])
        fi
      fi])
  if test $ac_cv_type_long_long_int = yes; then
    AC_DEFINE([HAVE_LONG_LONG_INT], [1],
      [Define to 1 if the system has the type 'long long int'.])
  fi
])

# Define HAVE_UNSIGNED_LONG_LONG_INT if 'unsigned long long int' works.
# This fixes a bug in Autoconf 2.61, and can be faster
# than what's in Autoconf 2.62 through 2.68.

# Note: If the type 'unsigned long long int' exists but is only 32 bits
# large (as on some very old compilers), AC_TYPE_UNSIGNED_LONG_LONG_INT
# will not be defined. In this case you can treat 'unsigned long long int'
# like 'unsigned long int'.

AC_DEFUN([AC_TYPE_UNSIGNED_LONG_LONG_INT],
[
  AC_CACHE_CHECK([for unsigned long long int],
    [ac_cv_type_unsigned_long_long_int],
    [ac_cv_type_unsigned_long_long_int=yes
     if test "x${ac_cv_prog_cc_c99-no}" = xno; then
       AC_LINK_IFELSE(
         [_AC_TYPE_LONG_LONG_SNIPPET],
         [],
         [ac_cv_type_unsigned_long_long_int=no])
     fi])
  if test $ac_cv_type_unsigned_long_long_int = yes; then
    AC_DEFINE([HAVE_UNSIGNED_LONG_LONG_INT], [1],
      [Define to 1 if the system has the type 'unsigned long long int'.])
  fi
])

# Expands to a C program that can be used to test for simultaneous support
# of 'long long' and 'unsigned long long'. We don't want to say that
# 'long long' is available if 'unsigned long long' is not, or vice versa,
# because too many programs rely on the symmetry between signed and unsigned
# integer types (excluding 'bool').
AC_DEFUN([_AC_TYPE_LONG_LONG_SNIPPET],
[
  AC_LANG_PROGRAM(
    [[/* For now, do not test the preprocessor; as of 2007 there are too many
         implementations with broken preprocessors.  Perhaps this can
         be revisited in 2012.  In the meantime, code should not expect
         #if to work with literals wider than 32 bits.  */
      /* Test literals.  */
      long long int ll = 9223372036854775807ll;
      long long int nll = -9223372036854775807LL;
      unsigned long long int ull = 18446744073709551615ULL;
      /* Test constant expressions.   */
      typedef int a[((-9223372036854775807LL < 0 && 0 < 9223372036854775807ll)
                     ? 1 : -1)];
      typedef int b[(18446744073709551615ULL <= (unsigned long long int) -1
                     ? 1 : -1)];
      int i = 63;]],
    [[/* Test availability of runtime routines for shift and division.  */
      long long int llmax = 9223372036854775807ll;
      unsigned long long int ullmax = 18446744073709551615ull;
      return ((ll << 63) | (ll >> 63) | (ll < i) | (ll > i)
              | (llmax / ll) | (llmax % ll)
              | (ull << 63) | (ull >> 63) | (ull << i) | (ull >> i)
              | (ullmax / ull) | (ullmax % ull));]])
])

# serial 31

# Copyright (C) 1997-2001, 2003-2018 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering.

AC_DEFUN([gl_FUNC_LSTAT],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  dnl If lstat does not exist, the replacement <sys/stat.h> does
  dnl "#define lstat stat", and lstat.c is a no-op.
  AC_CHECK_FUNCS_ONCE([lstat])
  if test $ac_cv_func_lstat = yes; then
    AC_REQUIRE([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK])
    case $host_os,$gl_cv_func_lstat_dereferences_slashed_symlink in
      solaris* | *no)
        REPLACE_LSTAT=1
        ;;
    esac
  else
    HAVE_LSTAT=0
  fi
])

# Prerequisites of lib/lstat.c.
AC_DEFUN([gl_PREREQ_LSTAT], [:])

AC_DEFUN([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK],
[
  dnl We don't use AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK any more, because it
  dnl is no longer maintained in Autoconf and because it invokes AC_LIBOBJ.
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether lstat correctly handles trailing slash],
    [gl_cv_func_lstat_dereferences_slashed_symlink],
    [rm -f conftest.sym conftest.file
     echo >conftest.file
     AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [AC_INCLUDES_DEFAULT],
          [[struct stat sbuf;
            if (symlink ("conftest.file", "conftest.sym") != 0)
              return 1;
            /* Linux will dereference the symlink and fail, as required by
               POSIX.  That is better in the sense that it means we will not
               have to compile and use the lstat wrapper.  */
            return lstat ("conftest.sym/", &sbuf) == 0;
          ]])],
       [gl_cv_func_lstat_dereferences_slashed_symlink=yes],
       [gl_cv_func_lstat_dereferences_slashed_symlink=no],
       [case "$host_os" in
          *-gnu* | gnu*)
            # Guess yes on glibc systems.
            gl_cv_func_lstat_dereferences_slashed_symlink="guessing yes" ;;
          mingw*)
            # Guess no on native Windows.
            gl_cv_func_lstat_dereferences_slashed_symlink="guessing no" ;;
          *)
            # If we don't know, assume the worst.
            gl_cv_func_lstat_dereferences_slashed_symlink="guessing no" ;;
        esac
       ])
     rm -f conftest.sym conftest.file
    ])
  case "$gl_cv_func_lstat_dereferences_slashed_symlink" in
    *yes)
      AC_DEFINE_UNQUOTED([LSTAT_FOLLOWS_SLASHED_SYMLINK], [1],
        [Define to 1 if 'lstat' dereferences a symlink specified
         with a trailing slash.])
      ;;
  esac
])

# malloc.m4 serial 16
dnl Copyright (C) 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

m4_version_prereq([2.70], [] ,[

# This is adapted with modifications from upstream Autoconf here:
# https://git.savannah.gnu.org/cgit/autoconf.git/commit/?id=04be2b7a29d65d9a08e64e8e56e594c91749598c
AC_DEFUN([_AC_FUNC_MALLOC_IF],
[
  AC_REQUIRE([AC_HEADER_STDC])dnl
  AC_REQUIRE([AC_CANONICAL_HOST])dnl for cross-compiles
  AC_CHECK_HEADERS([stdlib.h])
  AC_CACHE_CHECK([for GNU libc compatible malloc],
    [ac_cv_func_malloc_0_nonnull],
    [AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [[#if defined STDC_HEADERS || defined HAVE_STDLIB_H
            # include <stdlib.h>
            #else
            char *malloc ();
            #endif
          ]],
          [[char *p = malloc (0);
            int result = !p;
            free (p);
            return result;]])
       ],
       [ac_cv_func_malloc_0_nonnull=yes],
       [ac_cv_func_malloc_0_nonnull=no],
       [case "$host_os" in
          # Guess yes on platforms where we know the result.
          *-gnu* | gnu* | freebsd* | netbsd* | openbsd* \
          | hpux* | solaris* | cygwin* | mingw*)
            ac_cv_func_malloc_0_nonnull=yes ;;
          # If we don't know, assume the worst.
          *) ac_cv_func_malloc_0_nonnull=no ;;
        esac
       ])
    ])
  AS_IF([test $ac_cv_func_malloc_0_nonnull = yes], [$1], [$2])
])# _AC_FUNC_MALLOC_IF

])

# gl_FUNC_MALLOC_GNU
# ------------------
# Test whether 'malloc (0)' is handled like in GNU libc, and replace malloc if
# it is not.
AC_DEFUN([gl_FUNC_MALLOC_GNU],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  dnl _AC_FUNC_MALLOC_IF is defined in Autoconf.
  _AC_FUNC_MALLOC_IF(
    [AC_DEFINE([HAVE_MALLOC_GNU], [1],
               [Define to 1 if your system has a GNU libc compatible 'malloc'
                function, and to 0 otherwise.])],
    [AC_DEFINE([HAVE_MALLOC_GNU], [0])
     REPLACE_MALLOC=1
    ])
])

# gl_FUNC_MALLOC_POSIX
# --------------------
# Test whether 'malloc' is POSIX compliant (sets errno to ENOMEM when it
# fails), and replace malloc if it is not.
AC_DEFUN([gl_FUNC_MALLOC_POSIX],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  AC_REQUIRE([gl_CHECK_MALLOC_POSIX])
  if test $gl_cv_func_malloc_posix = yes; then
    AC_DEFINE([HAVE_MALLOC_POSIX], [1],
      [Define if the 'malloc' function is POSIX compliant.])
  else
    REPLACE_MALLOC=1
  fi
])

# Test whether malloc, realloc, calloc are POSIX compliant,
# Set gl_cv_func_malloc_posix to yes or no accordingly.
AC_DEFUN([gl_CHECK_MALLOC_POSIX],
[
  AC_CACHE_CHECK([whether malloc, realloc, calloc are POSIX compliant],
    [gl_cv_func_malloc_posix],
    [
      dnl It is too dangerous to try to allocate a large amount of memory:
      dnl some systems go to their knees when you do that. So assume that
      dnl all Unix implementations of the function are POSIX compliant.
      AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM(
           [[]],
           [[#if (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
             choke me
             #endif
            ]])],
        [gl_cv_func_malloc_posix=yes],
        [gl_cv_func_malloc_posix=no])
    ])
])

# malloca.m4 serial 1
dnl Copyright (C) 2003-2004, 2006-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_MALLOCA],
[
  dnl Use the autoconf tests for alloca(), but not the AC_SUBSTed variables
  dnl @ALLOCA@ and @LTALLOCA@.
  dnl gl_FUNC_ALLOCA   dnl Already brought in by the module dependencies.
  AC_REQUIRE([gl_EEMALLOC])
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
])

# manywarnings.m4 serial 13
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Simon Josefsson

# gl_MANYWARN_COMPLEMENT(OUTVAR, LISTVAR, REMOVEVAR)
# --------------------------------------------------
# Copy LISTVAR to OUTVAR except for the entries in REMOVEVAR.
# Elements separated by whitespace.  In set logic terms, the function
# does OUTVAR = LISTVAR \ REMOVEVAR.
AC_DEFUN([gl_MANYWARN_COMPLEMENT],
[
  gl_warn_set=
  set x $2; shift
  for gl_warn_item
  do
    case " $3 " in
      *" $gl_warn_item "*)
        ;;
      *)
        gl_warn_set="$gl_warn_set $gl_warn_item"
        ;;
    esac
  done
  $1=$gl_warn_set
])

# gl_MANYWARN_ALL_GCC(VARIABLE)
# -----------------------------
# Add all documented GCC warning parameters to variable VARIABLE.
# Note that you need to test them using gl_WARN_ADD if you want to
# make sure your gcc understands it.
#
# The effects of this macro depend on the current language (_AC_LANG).
AC_DEFUN([gl_MANYWARN_ALL_GCC],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])

# Specialization for _AC_LANG = C.
# Use of m4_defun rather than AC_DEFUN works around a bug in autoconf < 2.63b.
m4_defun([gl_MANYWARN_ALL_GCC(C)],
[
  AC_LANG_PUSH([C])

  dnl First, check for some issues that only occur when combining multiple
  dnl gcc warning categories.
  AC_REQUIRE([AC_PROG_CC])
  if test -n "$GCC"; then

    dnl Check if -W -Werror -Wno-missing-field-initializers is supported
    dnl with the current $CC $CFLAGS $CPPFLAGS.
    AC_MSG_CHECKING([whether -Wno-missing-field-initializers is supported])
    AC_CACHE_VAL([gl_cv_cc_nomfi_supported], [
      gl_save_CFLAGS="$CFLAGS"
      CFLAGS="$CFLAGS -W -Werror -Wno-missing-field-initializers"
      AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM([[]], [[]])],
        [gl_cv_cc_nomfi_supported=yes],
        [gl_cv_cc_nomfi_supported=no])
      CFLAGS="$gl_save_CFLAGS"])
    AC_MSG_RESULT([$gl_cv_cc_nomfi_supported])

    if test "$gl_cv_cc_nomfi_supported" = yes; then
      dnl Now check whether -Wno-missing-field-initializers is needed
      dnl for the { 0, } construct.
      AC_MSG_CHECKING([whether -Wno-missing-field-initializers is needed])
      AC_CACHE_VAL([gl_cv_cc_nomfi_needed], [
        gl_save_CFLAGS="$CFLAGS"
        CFLAGS="$CFLAGS -W -Werror"
        AC_COMPILE_IFELSE(
          [AC_LANG_PROGRAM(
             [[int f (void)
               {
                 typedef struct { int a; int b; } s_t;
                 s_t s1 = { 0, };
                 return s1.b;
               }
             ]],
             [[]])],
          [gl_cv_cc_nomfi_needed=no],
          [gl_cv_cc_nomfi_needed=yes])
        CFLAGS="$gl_save_CFLAGS"
      ])
      AC_MSG_RESULT([$gl_cv_cc_nomfi_needed])
    fi

    dnl Next, check if -Werror -Wuninitialized is useful with the
    dnl user's choice of $CFLAGS; some versions of gcc warn that it
    dnl has no effect if -O is not also used
    AC_MSG_CHECKING([whether -Wuninitialized is supported])
    AC_CACHE_VAL([gl_cv_cc_uninitialized_supported], [
      gl_save_CFLAGS="$CFLAGS"
      CFLAGS="$CFLAGS -Werror -Wuninitialized"
      AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM([[]], [[]])],
        [gl_cv_cc_uninitialized_supported=yes],
        [gl_cv_cc_uninitialized_supported=no])
      CFLAGS="$gl_save_CFLAGS"])
    AC_MSG_RESULT([$gl_cv_cc_uninitialized_supported])

  fi

  # List all gcc warning categories.
  # To compare this list to your installed GCC's, run this Bash command:
  #
  # comm -3 \
  #  <(sed -n 's/^  *\(-[^ 0-9][^ ]*\) .*/\1/p' manywarnings.m4 | sort) \
  #  <(gcc --help=warnings | sed -n 's/^  \(-[^ ]*\) .*/\1/p' | sort |
  #      grep -v -x -F -f <(
  #         awk '/^[^#]/ {print $1}' ../build-aux/gcc-warning.spec))

  gl_manywarn_set=
  for gl_manywarn_item in -fno-common \
    -W \
    -Wabi \
    -Waddress \
    -Waggressive-loop-optimizations \
    -Wall \
    -Wattributes \
    -Wbad-function-cast \
    -Wbool-compare \
    -Wbool-operation \
    -Wbuiltin-declaration-mismatch \
    -Wbuiltin-macro-redefined \
    -Wcast-align \
    -Wchar-subscripts \
    -Wchkp \
    -Wclobbered \
    -Wcomment \
    -Wcomments \
    -Wcoverage-mismatch \
    -Wcpp \
    -Wdangling-else \
    -Wdate-time \
    -Wdeprecated \
    -Wdeprecated-declarations \
    -Wdesignated-init \
    -Wdisabled-optimization \
    -Wdiscarded-array-qualifiers \
    -Wdiscarded-qualifiers \
    -Wdiv-by-zero \
    -Wdouble-promotion \
    -Wduplicated-branches \
    -Wduplicated-cond \
    -Wduplicate-decl-specifier \
    -Wempty-body \
    -Wendif-labels \
    -Wenum-compare \
    -Wexpansion-to-defined \
    -Wextra \
    -Wformat-contains-nul \
    -Wformat-extra-args \
    -Wformat-nonliteral \
    -Wformat-security \
    -Wformat-signedness \
    -Wformat-y2k \
    -Wformat-zero-length \
    -Wframe-address \
    -Wfree-nonheap-object \
    -Whsa \
    -Wignored-attributes \
    -Wignored-qualifiers \
    -Wimplicit \
    -Wimplicit-function-declaration \
    -Wimplicit-int \
    -Wincompatible-pointer-types \
    -Winit-self \
    -Winline \
    -Wint-conversion \
    -Wint-in-bool-context \
    -Wint-to-pointer-cast \
    -Winvalid-memory-model \
    -Winvalid-pch \
    -Wjump-misses-init \
    -Wlogical-not-parentheses \
    -Wlogical-op \
    -Wmain \
    -Wmaybe-uninitialized \
    -Wmemset-elt-size \
    -Wmemset-transposed-args \
    -Wmisleading-indentation \
    -Wmissing-braces \
    -Wmissing-declarations \
    -Wmissing-field-initializers \
    -Wmissing-include-dirs \
    -Wmissing-parameter-type \
    -Wmissing-prototypes \
    -Wmultichar \
    -Wnarrowing \
    -Wnested-externs \
    -Wnonnull \
    -Wnonnull-compare \
    -Wnull-dereference \
    -Wodr \
    -Wold-style-declaration \
    -Wold-style-definition \
    -Wopenmp-simd \
    -Woverflow \
    -Woverlength-strings \
    -Woverride-init \
    -Wpacked \
    -Wpacked-bitfield-compat \
    -Wparentheses \
    -Wpointer-arith \
    -Wpointer-compare \
    -Wpointer-sign \
    -Wpointer-to-int-cast \
    -Wpragmas \
    -Wpsabi \
    -Wrestrict \
    -Wreturn-local-addr \
    -Wreturn-type \
    -Wscalar-storage-order \
    -Wsequence-point \
    -Wshadow \
    -Wshift-count-negative \
    -Wshift-count-overflow \
    -Wshift-negative-value \
    -Wsizeof-array-argument \
    -Wsizeof-pointer-memaccess \
    -Wstack-protector \
    -Wstrict-aliasing \
    -Wstrict-overflow \
    -Wstrict-prototypes \
    -Wsuggest-attribute=const \
    -Wsuggest-attribute=format \
    -Wsuggest-attribute=noreturn \
    -Wsuggest-attribute=pure \
    -Wsuggest-final-methods \
    -Wsuggest-final-types \
    -Wswitch \
    -Wswitch-bool \
    -Wswitch-default \
    -Wswitch-unreachable \
    -Wsync-nand \
    -Wsystem-headers \
    -Wtautological-compare \
    -Wtrampolines \
    -Wtrigraphs \
    -Wtype-limits \
    -Wuninitialized \
    -Wunknown-pragmas \
    -Wunsafe-loop-optimizations \
    -Wunused \
    -Wunused-but-set-parameter \
    -Wunused-but-set-variable \
    -Wunused-function \
    -Wunused-label \
    -Wunused-local-typedefs \
    -Wunused-macros \
    -Wunused-parameter \
    -Wunused-result \
    -Wunused-value \
    -Wunused-variable \
    -Wvarargs \
    -Wvariadic-macros \
    -Wvector-operation-performance \
    -Wvla \
    -Wvolatile-register-var \
    -Wwrite-strings \
    \
    ; do
    gl_manywarn_set="$gl_manywarn_set $gl_manywarn_item"
  done

  # gcc --help=warnings outputs an unusual form for these options; list
  # them here so that the above 'comm' command doesn't report a false match.
  # Would prefer "min (PTRDIFF_MAX, SIZE_MAX)", but it must be a literal.
  # Also, AC_COMPUTE_INT requires it to fit in a long; it is 2**63 on
  # the only platforms where it does not fit in a long, so make that
  # a special case.
  AC_MSG_CHECKING([max safe object size])
  AC_COMPUTE_INT([gl_alloc_max],
    [LONG_MAX < (PTRDIFF_MAX < (size_t) -1 ? PTRDIFF_MAX : (size_t) -1)
     ? -1
     : PTRDIFF_MAX < (size_t) -1 ? (long) PTRDIFF_MAX : (long) (size_t) -1],
    [[#include <limits.h>
      #include <stddef.h>
      #include <stdint.h>
    ]],
    [gl_alloc_max=2147483647])
  case $gl_alloc_max in
    -1) gl_alloc_max=9223372036854775807;;
  esac
  AC_MSG_RESULT([$gl_alloc_max])
  gl_manywarn_set="$gl_manywarn_set -Walloc-size-larger-than=$gl_alloc_max"
  gl_manywarn_set="$gl_manywarn_set -Warray-bounds=2"
  gl_manywarn_set="$gl_manywarn_set -Wformat-overflow=2"
  gl_manywarn_set="$gl_manywarn_set -Wformat-truncation=2"
  gl_manywarn_set="$gl_manywarn_set -Wimplicit-fallthrough=5"
  gl_manywarn_set="$gl_manywarn_set -Wnormalized=nfc"
  gl_manywarn_set="$gl_manywarn_set -Wshift-overflow=2"
  gl_manywarn_set="$gl_manywarn_set -Wstringop-overflow=2"
  gl_manywarn_set="$gl_manywarn_set -Wunused-const-variable=2"
  gl_manywarn_set="$gl_manywarn_set -Wvla-larger-than=4031"

  # These are needed for older GCC versions.
  if test -n "$GCC"; then
    case `($CC --version) 2>/dev/null` in
      'gcc (GCC) '[[0-3]].* | \
      'gcc (GCC) '4.[[0-7]].*)
        gl_manywarn_set="$gl_manywarn_set -fdiagnostics-show-option"
        gl_manywarn_set="$gl_manywarn_set -funit-at-a-time"
          ;;
    esac
  fi

  # Disable specific options as needed.
  if test "$gl_cv_cc_nomfi_needed" = yes; then
    gl_manywarn_set="$gl_manywarn_set -Wno-missing-field-initializers"
  fi

  if test "$gl_cv_cc_uninitialized_supported" = no; then
    gl_manywarn_set="$gl_manywarn_set -Wno-uninitialized"
  fi

  $1=$gl_manywarn_set

  AC_LANG_POP([C])
])

# Specialization for _AC_LANG = C++.
# Use of m4_defun rather than AC_DEFUN works around a bug in autoconf < 2.63b.
m4_defun([gl_MANYWARN_ALL_GCC(C++)],
[
  gl_MANYWARN_ALL_GCC_CXX_IMPL([$1])
])

# mbrtowc.m4 serial 30  -*- coding: utf-8 -*-
dnl Copyright (C) 2001-2002, 2004-2005, 2008-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_MBRTOWC],
[
  AC_REQUIRE([gl_WCHAR_H_DEFAULTS])

  AC_REQUIRE([AC_TYPE_MBSTATE_T])
  gl_MBSTATE_T_BROKEN

  AC_CHECK_FUNCS_ONCE([mbrtowc])
  if test $ac_cv_func_mbrtowc = no; then
    HAVE_MBRTOWC=0
    AC_CHECK_DECLS([mbrtowc],,, [[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
]])
    if test $ac_cv_have_decl_mbrtowc = yes; then
      dnl On Minix 3.1.8, the system's <wchar.h> declares mbrtowc() although
      dnl it does not have the function. Avoid a collision with gnulib's
      dnl replacement.
      REPLACE_MBRTOWC=1
    fi
  else
    if test $REPLACE_MBSTATE_T = 1; then
      REPLACE_MBRTOWC=1
    else
      gl_MBRTOWC_NULL_ARG1
      gl_MBRTOWC_NULL_ARG2
      gl_MBRTOWC_RETVAL
      gl_MBRTOWC_NUL_RETVAL
      gl_MBRTOWC_EMPTY_INPUT
      gl_MBRTOWC_C_LOCALE
      case "$gl_cv_func_mbrtowc_null_arg1" in
        *yes) ;;
        *) AC_DEFINE([MBRTOWC_NULL_ARG1_BUG], [1],
             [Define if the mbrtowc function has the NULL pwc argument bug.])
           REPLACE_MBRTOWC=1
           ;;
      esac
      case "$gl_cv_func_mbrtowc_null_arg2" in
        *yes) ;;
        *) AC_DEFINE([MBRTOWC_NULL_ARG2_BUG], [1],
             [Define if the mbrtowc function has the NULL string argument bug.])
           REPLACE_MBRTOWC=1
           ;;
      esac
      case "$gl_cv_func_mbrtowc_retval" in
        *yes) ;;
        *) AC_DEFINE([MBRTOWC_RETVAL_BUG], [1],
             [Define if the mbrtowc function returns a wrong return value.])
           REPLACE_MBRTOWC=1
           ;;
      esac
      case "$gl_cv_func_mbrtowc_nul_retval" in
        *yes) ;;
        *) AC_DEFINE([MBRTOWC_NUL_RETVAL_BUG], [1],
             [Define if the mbrtowc function does not return 0 for a NUL character.])
           REPLACE_MBRTOWC=1
           ;;
      esac
      case "$gl_cv_func_mbrtowc_empty_input" in
        *yes) ;;
        *) AC_DEFINE([MBRTOWC_EMPTY_INPUT_BUG], [1],
             [Define if the mbrtowc function does not return (size_t) -2
              for empty input.])
           REPLACE_MBRTOWC=1
           ;;
      esac
      case $gl_cv_C_locale_sans_EILSEQ in
        *yes) ;;
        *) AC_DEFINE([C_LOCALE_MAYBE_EILSEQ], [1],
             [Define to 1 if the C locale may have encoding errors.])
           REPLACE_MBRTOWC=1
           ;;
      esac
    fi
  fi
])

dnl Test whether mbsinit() and mbrtowc() need to be overridden in a way that
dnl redefines the semantics of the given mbstate_t type.
dnl Result is REPLACE_MBSTATE_T.
dnl When this is set to 1, we replace both mbsinit() and mbrtowc(), in order to
dnl avoid inconsistencies.

AC_DEFUN([gl_MBSTATE_T_BROKEN],
[
  AC_REQUIRE([gl_WCHAR_H_DEFAULTS])

  AC_REQUIRE([AC_TYPE_MBSTATE_T])
  AC_CHECK_FUNCS_ONCE([mbsinit])
  AC_CHECK_FUNCS_ONCE([mbrtowc])
  if test $ac_cv_func_mbsinit = yes && test $ac_cv_func_mbrtowc = yes; then
    gl_MBRTOWC_INCOMPLETE_STATE
    gl_MBRTOWC_SANITYCHECK
    REPLACE_MBSTATE_T=0
    case "$gl_cv_func_mbrtowc_incomplete_state" in
      *yes) ;;
      *) REPLACE_MBSTATE_T=1 ;;
    esac
    case "$gl_cv_func_mbrtowc_sanitycheck" in
      *yes) ;;
      *) REPLACE_MBSTATE_T=1 ;;
    esac
  else
    REPLACE_MBSTATE_T=1
  fi
])

dnl Test whether mbrtowc puts the state into non-initial state when parsing an
dnl incomplete multibyte character.
dnl Result is gl_cv_func_mbrtowc_incomplete_state.

AC_DEFUN([gl_MBRTOWC_INCOMPLETE_STATE],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_JA])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc handles incomplete characters],
    [gl_cv_func_mbrtowc_incomplete_state],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                     # Guess no on AIX and OSF/1.
        aix* | osf*) gl_cv_func_mbrtowc_incomplete_state="guessing no" ;;
                     # Guess yes otherwise.
        *)           gl_cv_func_mbrtowc_incomplete_state="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_JA != none; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  if (setlocale (LC_ALL, "$LOCALE_JA") != NULL)
    {
      const char input[] = "B\217\253\344\217\251\316er"; /* "Büßer" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 1, 1, &state) == (size_t)(-2))
        if (mbsinit (&state))
          return 2;
    }
  return 0;
}]])],
          [gl_cv_func_mbrtowc_incomplete_state=yes],
          [gl_cv_func_mbrtowc_incomplete_state=no],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc works not worse than mbtowc.
dnl Result is gl_cv_func_mbrtowc_sanitycheck.

AC_DEFUN([gl_MBRTOWC_SANITYCHECK],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_ZH_CN])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc works as well as mbtowc],
    [gl_cv_func_mbrtowc_sanitycheck],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                    # Guess no on Solaris 8.
        solaris2.8) gl_cv_func_mbrtowc_sanitycheck="guessing no" ;;
                    # Guess yes otherwise.
        *)          gl_cv_func_mbrtowc_sanitycheck="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_ZH_CN != none; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <stdlib.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  /* This fails on Solaris 8:
     mbrtowc returns 2, and sets wc to 0x00F0.
     mbtowc returns 4 (correct) and sets wc to 0x5EDC.  */
  if (setlocale (LC_ALL, "$LOCALE_ZH_CN") != NULL)
    {
      char input[] = "B\250\271\201\060\211\070er"; /* "Büßer" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 3, 6, &state) != 4
          && mbtowc (&wc, input + 3, 6) == 4)
        return 2;
    }
  return 0;
}]])],
          [gl_cv_func_mbrtowc_sanitycheck=yes],
          [gl_cv_func_mbrtowc_sanitycheck=no],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc supports a NULL pwc argument correctly.
dnl Result is gl_cv_func_mbrtowc_null_arg1.

AC_DEFUN([gl_MBRTOWC_NULL_ARG1],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_FR_UTF8])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc handles a NULL pwc argument],
    [gl_cv_func_mbrtowc_null_arg1],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                  # Guess no on Solaris.
        solaris*) gl_cv_func_mbrtowc_null_arg1="guessing no" ;;
                  # Guess yes otherwise.
        *)        gl_cv_func_mbrtowc_null_arg1="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_FR_UTF8 != none; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <stdlib.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  int result = 0;

  if (setlocale (LC_ALL, "$LOCALE_FR_UTF8") != NULL)
    {
      char input[] = "\303\237er";
      mbstate_t state;
      wchar_t wc;
      size_t ret;

      memset (&state, '\0', sizeof (mbstate_t));
      wc = (wchar_t) 0xBADFACE;
      ret = mbrtowc (&wc, input, 5, &state);
      if (ret != 2)
        result |= 1;
      if (!mbsinit (&state))
        result |= 2;

      memset (&state, '\0', sizeof (mbstate_t));
      ret = mbrtowc (NULL, input, 5, &state);
      if (ret != 2) /* Solaris 7 fails here: ret is -1.  */
        result |= 4;
      if (!mbsinit (&state))
        result |= 8;
    }
  return result;
}]])],
          [gl_cv_func_mbrtowc_null_arg1=yes],
          [gl_cv_func_mbrtowc_null_arg1=no],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc supports a NULL string argument correctly.
dnl Result is gl_cv_func_mbrtowc_null_arg2.

AC_DEFUN([gl_MBRTOWC_NULL_ARG2],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_FR_UTF8])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc handles a NULL string argument],
    [gl_cv_func_mbrtowc_null_arg2],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
              # Guess no on OSF/1.
        osf*) gl_cv_func_mbrtowc_null_arg2="guessing no" ;;
              # Guess yes otherwise.
        *)    gl_cv_func_mbrtowc_null_arg2="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_FR_UTF8 != none; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  if (setlocale (LC_ALL, "$LOCALE_FR_UTF8") != NULL)
    {
      mbstate_t state;
      wchar_t wc;
      int ret;

      memset (&state, '\0', sizeof (mbstate_t));
      wc = (wchar_t) 0xBADFACE;
      mbrtowc (&wc, NULL, 5, &state);
      /* Check that wc was not modified.  */
      if (wc != (wchar_t) 0xBADFACE)
        return 2;
    }
  return 0;
}]])],
          [gl_cv_func_mbrtowc_null_arg2=yes],
          [gl_cv_func_mbrtowc_null_arg2=no],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc, when parsing the end of a multibyte character,
dnl correctly returns the number of bytes that were needed to complete the
dnl character (not the total number of bytes of the multibyte character).
dnl Result is gl_cv_func_mbrtowc_retval.

AC_DEFUN([gl_MBRTOWC_RETVAL],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_FR_UTF8])
  AC_REQUIRE([gt_LOCALE_JA])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CACHE_CHECK([whether mbrtowc has a correct return value],
    [gl_cv_func_mbrtowc_retval],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                                   # Guess no on HP-UX, Solaris, native Windows.
        hpux* | solaris* | mingw*) gl_cv_func_mbrtowc_retval="guessing no" ;;
                                   # Guess yes otherwise.
        *)                         gl_cv_func_mbrtowc_retval="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_FR_UTF8 != none || test $LOCALE_JA != none \
         || { case "$host_os" in mingw*) true;; *) false;; esac; }; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  int result = 0;
  int found_some_locale = 0;
  /* This fails on Solaris.  */
  if (setlocale (LC_ALL, "$LOCALE_FR_UTF8") != NULL)
    {
      char input[] = "B\303\274\303\237er"; /* "Büßer" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 1, 1, &state) == (size_t)(-2))
        {
          input[1] = '\0';
          if (mbrtowc (&wc, input + 2, 5, &state) != 1)
            result |= 1;
        }
      found_some_locale = 1;
    }
  /* This fails on HP-UX 11.11.  */
  if (setlocale (LC_ALL, "$LOCALE_JA") != NULL)
    {
      char input[] = "B\217\253\344\217\251\316er"; /* "Büßer" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 1, 1, &state) == (size_t)(-2))
        {
          input[1] = '\0';
          if (mbrtowc (&wc, input + 2, 5, &state) != 2)
            result |= 2;
        }
      found_some_locale = 1;
    }
  /* This fails on native Windows.  */
  if (setlocale (LC_ALL, "Japanese_Japan.932") != NULL)
    {
      char input[] = "<\223\372\226\173\214\352>"; /* "<日本語>" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 3, 1, &state) == (size_t)(-2))
        {
          input[3] = '\0';
          if (mbrtowc (&wc, input + 4, 4, &state) != 1)
            result |= 4;
        }
      found_some_locale = 1;
    }
  if (setlocale (LC_ALL, "Chinese_Taiwan.950") != NULL)
    {
      char input[] = "<\244\351\245\273\273\171>"; /* "<日本語>" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 3, 1, &state) == (size_t)(-2))
        {
          input[3] = '\0';
          if (mbrtowc (&wc, input + 4, 4, &state) != 1)
            result |= 8;
        }
      found_some_locale = 1;
    }
  if (setlocale (LC_ALL, "Chinese_China.936") != NULL)
    {
      char input[] = "<\310\325\261\276\325\132>"; /* "<日本語>" */
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, input + 3, 1, &state) == (size_t)(-2))
        {
          input[3] = '\0';
          if (mbrtowc (&wc, input + 4, 4, &state) != 1)
            result |= 16;
        }
      found_some_locale = 1;
    }
  return (found_some_locale ? result : 77);
}]])],
          [gl_cv_func_mbrtowc_retval=yes],
          [if test $? != 77; then
             gl_cv_func_mbrtowc_retval=no
           fi
          ],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc, when parsing a NUL character, correctly returns 0.
dnl Result is gl_cv_func_mbrtowc_nul_retval.

AC_DEFUN([gl_MBRTOWC_NUL_RETVAL],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gt_LOCALE_ZH_CN])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc returns 0 when parsing a NUL character],
    [gl_cv_func_mbrtowc_nul_retval],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                       # Guess no on Solaris 8 and 9.
        solaris2.[89]) gl_cv_func_mbrtowc_nul_retval="guessing no" ;;
                       # Guess yes otherwise.
        *)             gl_cv_func_mbrtowc_nul_retval="guessing yes" ;;
      esac
changequote([,])dnl
      if test $LOCALE_ZH_CN != none; then
        AC_RUN_IFELSE(
          [AC_LANG_SOURCE([[
#include <locale.h>
#include <string.h>
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main ()
{
  /* This fails on Solaris 8 and 9.  */
  if (setlocale (LC_ALL, "$LOCALE_ZH_CN") != NULL)
    {
      mbstate_t state;
      wchar_t wc;

      memset (&state, '\0', sizeof (mbstate_t));
      if (mbrtowc (&wc, "", 1, &state) != 0)
        return 2;
    }
  return 0;
}]])],
          [gl_cv_func_mbrtowc_nul_retval=yes],
          [gl_cv_func_mbrtowc_nul_retval=no],
          [:])
      fi
    ])
])

dnl Test whether mbrtowc returns the correct value on empty input.

AC_DEFUN([gl_MBRTOWC_EMPTY_INPUT],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether mbrtowc works on empty input],
    [gl_cv_func_mbrtowc_empty_input],
    [
      dnl Initial guess, used when cross-compiling or when no suitable locale
      dnl is present.
changequote(,)dnl
      case "$host_os" in
                              # Guess no on AIX and glibc systems.
        aix* | *-gnu* | gnu*) gl_cv_func_mbrtowc_empty_input="guessing no" ;;
                              # Guess yes on native Windows.
        mingw*)               gl_cv_func_mbrtowc_empty_input="guessing yes" ;;
        *)                    gl_cv_func_mbrtowc_empty_input="guessing yes" ;;
      esac
changequote([,])dnl
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
           #include <wchar.h>
           static wchar_t wc;
           static mbstate_t mbs;
           int
           main (void)
           {
             return mbrtowc (&wc, "", 0, &mbs) != (size_t) -2;
           }]])],
        [gl_cv_func_mbrtowc_empty_input=yes],
        [gl_cv_func_mbrtowc_empty_input=no],
        [:])
    ])
])

dnl Test whether mbrtowc reports encoding errors in the C locale.
dnl Although POSIX was never intended to allow this, the GNU C Library
dnl and other implementations do it.  See:
dnl https://sourceware.org/bugzilla/show_bug.cgi?id=19932

AC_DEFUN([gl_MBRTOWC_C_LOCALE],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether the C locale is free of encoding errors],
    [gl_cv_C_locale_sans_EILSEQ],
    [
     dnl Initial guess, used when cross-compiling or when no suitable locale
     dnl is present.
     gl_cv_C_locale_sans_EILSEQ="guessing no"

     AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <limits.h>
            #include <locale.h>
            #include <wchar.h>
          ]], [[
            int i;
            char *locale = setlocale (LC_ALL, "C");
            if (! locale)
              return 2;
            for (i = CHAR_MIN; i <= CHAR_MAX; i++)
              {
                char c = i;
                wchar_t wc;
                mbstate_t mbs = { 0, };
                size_t ss = mbrtowc (&wc, &c, 1, &mbs);
                if (1 < ss)
                  return 3;
              }
            return 0;
          ]])],
      [gl_cv_C_locale_sans_EILSEQ=yes],
      [gl_cv_C_locale_sans_EILSEQ=no],
      [case "$host_os" in
                 # Guess yes on native Windows.
         mingw*) gl_cv_C_locale_sans_EILSEQ="guessing yes" ;;
       esac
      ])
    ])
])

# Prerequisites of lib/mbrtowc.c.
AC_DEFUN([gl_PREREQ_MBRTOWC], [
  :
])


dnl From Paul Eggert

dnl This is an override of an autoconf macro.

AC_DEFUN([AC_FUNC_MBRTOWC],
[
  dnl Same as AC_FUNC_MBRTOWC in autoconf-2.60.
  AC_CACHE_CHECK([whether mbrtowc and mbstate_t are properly declared],
    [gl_cv_func_mbrtowc],
    [AC_LINK_IFELSE(
       [AC_LANG_PROGRAM(
            [[/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be
                 included before <wchar.h>.
                 BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h>
                 must be included before <wchar.h>.  */
              #include <stddef.h>
              #include <stdio.h>
              #include <time.h>
              #include <wchar.h>]],
            [[wchar_t wc;
              char const s[] = "";
              size_t n = 1;
              mbstate_t state;
              return ! (sizeof state && (mbrtowc) (&wc, s, n, &state));]])],
       [gl_cv_func_mbrtowc=yes],
       [gl_cv_func_mbrtowc=no])])
  if test $gl_cv_func_mbrtowc = yes; then
    AC_DEFINE([HAVE_MBRTOWC], [1],
      [Define to 1 if mbrtowc and mbstate_t are properly declared.])
  fi
])

# mbsinit.m4 serial 8
dnl Copyright (C) 2008, 2010-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_MBSINIT],
[
  AC_REQUIRE([gl_WCHAR_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])

  AC_REQUIRE([AC_TYPE_MBSTATE_T])
  gl_MBSTATE_T_BROKEN

  AC_CHECK_FUNCS_ONCE([mbsinit])
  if test $ac_cv_func_mbsinit = no; then
    HAVE_MBSINIT=0
    AC_CHECK_DECLS([mbsinit],,, [[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
]])
    if test $ac_cv_have_decl_mbsinit = yes; then
      dnl On Minix 3.1.8, the system's <wchar.h> declares mbsinit() although
      dnl it does not have the function. Avoid a collision with gnulib's
      dnl replacement.
      REPLACE_MBSINIT=1
    fi
  else
    if test $REPLACE_MBSTATE_T = 1; then
      REPLACE_MBSINIT=1
    else
      dnl On mingw, mbsinit() always returns 1, which is inappropriate for
      dnl states produced by mbrtowc() for an incomplete multibyte character
      dnl in multibyte locales.
      case "$host_os" in
        mingw*) REPLACE_MBSINIT=1 ;;
      esac
    fi
  fi
])

# Prerequisites of lib/mbsinit.c.
AC_DEFUN([gl_PREREQ_MBSINIT], [
  :
])

# mbstate_t.m4 serial 13
dnl Copyright (C) 2000-2002, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# From Paul Eggert.

# BeOS 5 has <wchar.h> but does not define mbstate_t,
# so you can't declare an object of that type.
# Check for this incompatibility with Standard C.

# AC_TYPE_MBSTATE_T
# -----------------
AC_DEFUN([AC_TYPE_MBSTATE_T],
[
   AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS]) dnl for HP-UX 11.11

   AC_CACHE_CHECK([for mbstate_t], [ac_cv_type_mbstate_t],
     [AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM(
           [AC_INCLUDES_DEFAULT[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>]],
           [[mbstate_t x; return sizeof x;]])],
        [ac_cv_type_mbstate_t=yes],
        [ac_cv_type_mbstate_t=no])])
   if test $ac_cv_type_mbstate_t = yes; then
     AC_DEFINE([HAVE_MBSTATE_T], [1],
               [Define to 1 if <wchar.h> declares mbstate_t.])
   else
     AC_DEFINE([mbstate_t], [int],
               [Define to a type if <wchar.h> does not define.])
   fi
])

# memchr.m4 serial 13
dnl Copyright (C) 2002-2004, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN_ONCE([gl_FUNC_MEMCHR],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  dnl Check for prerequisites for memory fence checks.
  gl_FUNC_MMAP_ANON
  AC_CHECK_HEADERS_ONCE([sys/mman.h])
  AC_CHECK_FUNCS_ONCE([mprotect])

  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  m4_ifdef([gl_FUNC_MEMCHR_OBSOLETE], [
    dnl These days, we assume memchr is present.  But if support for old
    dnl platforms is desired:
    AC_CHECK_FUNCS_ONCE([memchr])
    if test $ac_cv_func_memchr = no; then
      HAVE_MEMCHR=0
    fi
  ])
  if test $HAVE_MEMCHR = 1; then
    # Detect platform-specific bugs in some versions of glibc:
    # memchr should not dereference anything with length 0
    #   https://bugzilla.redhat.com/show_bug.cgi?id=499689
    # memchr should not dereference overestimated length after a match
    #   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=521737
    #   https://sourceware.org/bugzilla/show_bug.cgi?id=10162
    # Assume that memchr works on platforms that lack mprotect.
    AC_CACHE_CHECK([whether memchr works], [gl_cv_func_memchr_works],
      [AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#include <string.h>
#if HAVE_SYS_MMAN_H
# include <fcntl.h>
# include <unistd.h>
# include <sys/types.h>
# include <sys/mman.h>
# ifndef MAP_FILE
#  define MAP_FILE 0
# endif
#endif
]], [[
  int result = 0;
  char *fence = NULL;
#if HAVE_SYS_MMAN_H && HAVE_MPROTECT
# if HAVE_MAP_ANONYMOUS
  const int flags = MAP_ANONYMOUS | MAP_PRIVATE;
  const int fd = -1;
# else /* !HAVE_MAP_ANONYMOUS */
  const int flags = MAP_FILE | MAP_PRIVATE;
  int fd = open ("/dev/zero", O_RDONLY, 0666);
  if (fd >= 0)
# endif
    {
      int pagesize = getpagesize ();
      char *two_pages =
        (char *) mmap (NULL, 2 * pagesize, PROT_READ | PROT_WRITE,
                       flags, fd, 0);
      if (two_pages != (char *)(-1)
          && mprotect (two_pages + pagesize, pagesize, PROT_NONE) == 0)
        fence = two_pages + pagesize;
    }
#endif
  if (fence)
    {
      if (memchr (fence, 0, 0))
        result |= 1;
      strcpy (fence - 9, "12345678");
      if (memchr (fence - 9, 0, 79) != fence - 1)
        result |= 2;
      if (memchr (fence - 1, 0, 3) != fence - 1)
        result |= 4;
    }
  return result;
]])],
         [gl_cv_func_memchr_works=yes],
         [gl_cv_func_memchr_works=no],
         [case "$host_os" in
                    # Guess yes on native Windows.
            mingw*) gl_cv_func_memchr_works="guessing yes" ;;
                    # Be pessimistic for now.
            *)      gl_cv_func_memchr_works="guessing no" ;;
          esac
         ])
      ])
    case "$gl_cv_func_memchr_works" in
      *yes) ;;
      *) REPLACE_MEMCHR=1 ;;
    esac
  fi
])

# Prerequisites of lib/memchr.c.
AC_DEFUN([gl_PREREQ_MEMCHR], [
  AC_CHECK_HEADERS([bp-sym.h])
])

# mempcpy.m4 serial 11
dnl Copyright (C) 2003-2004, 2006-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_MEMPCPY],
[
  dnl Persuade glibc <string.h> to declare mempcpy().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  dnl The mempcpy() declaration in lib/string.in.h uses 'restrict'.
  AC_REQUIRE([AC_C_RESTRICT])

  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_CHECK_FUNCS([mempcpy])
  if test $ac_cv_func_mempcpy = no; then
    HAVE_MEMPCPY=0
  fi
])

# Prerequisites of lib/mempcpy.c.
AC_DEFUN([gl_PREREQ_MEMPCPY], [
  :
])

# memrchr.m4 serial 10
dnl Copyright (C) 2002-2003, 2005-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_MEMRCHR],
[
  dnl Persuade glibc <string.h> to declare memrchr().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_CHECK_DECLS_ONCE([memrchr])
  if test $ac_cv_have_decl_memrchr = no; then
    HAVE_DECL_MEMRCHR=0
  fi

  AC_CHECK_FUNCS([memrchr])
])

# Prerequisites of lib/memrchr.c.
AC_DEFUN([gl_PREREQ_MEMRCHR], [:])

# minmax.m4 serial 4
dnl Copyright (C) 2005, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_PREREQ([2.53])

AC_DEFUN([gl_MINMAX],
[
  AC_REQUIRE([gl_PREREQ_MINMAX])
])

# Prerequisites of lib/minmax.h.
AC_DEFUN([gl_PREREQ_MINMAX],
[
  gl_MINMAX_IN_HEADER([limits.h])
  gl_MINMAX_IN_HEADER([sys/param.h])
])

dnl gl_MINMAX_IN_HEADER(HEADER)
dnl The parameter has to be a literal header name; it cannot be macro,
dnl nor a shell variable. (Because autoheader collects only AC_DEFINE
dnl invocations with a literal macro name.)
AC_DEFUN([gl_MINMAX_IN_HEADER],
[
  m4_pushdef([header], AS_TR_SH([$1]))
  m4_pushdef([HEADER], AS_TR_CPP([$1]))
  AC_CACHE_CHECK([whether <$1> defines MIN and MAX],
    [gl_cv_minmax_in_]header,
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <$1>
            int x = MIN (42, 17);]],
          [[]])],
       [gl_cv_minmax_in_]header[=yes],
       [gl_cv_minmax_in_]header[=no])])
  if test $gl_cv_minmax_in_[]header = yes; then
    AC_DEFINE([HAVE_MINMAX_IN_]HEADER, 1,
      [Define to 1 if <$1> defines the MIN and MAX macros.])
  fi
  m4_popdef([HEADER])
  m4_popdef([header])
])

# serial 13

# Copyright (C) 2001, 2003-2004, 2006, 2008-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# On some systems, mkdir ("foo/", 0700) fails because of the trailing slash.
# On others, mkdir ("foo/./", 0700) mistakenly succeeds.
# On such systems, arrange to use a wrapper function.
AC_DEFUN([gl_FUNC_MKDIR],
[dnl
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_HEADERS_ONCE([unistd.h])
  AC_CACHE_CHECK([whether mkdir handles trailing slash],
    [gl_cv_func_mkdir_trailing_slash_works],
    [rm -rf conftest.dir
      AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#       include <sys/types.h>
#       include <sys/stat.h>
]], [return mkdir ("conftest.dir/", 0700);])],
      [gl_cv_func_mkdir_trailing_slash_works=yes],
      [gl_cv_func_mkdir_trailing_slash_works=no],
      [case "$host_os" in
                        # Guess yes on glibc systems.
         *-gnu* | gnu*) gl_cv_func_mkdir_trailing_slash_works="guessing yes" ;;
                        # Guess yes on MSVC, no on mingw.
         mingw*)        AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                          ],
                          [gl_cv_func_mkdir_trailing_slash_works="guessing yes"],
                          [gl_cv_func_mkdir_trailing_slash_works="guessing no"])
                        ;;
                        # If we don't know, assume the worst.
         *)             gl_cv_func_mkdir_trailing_slash_works="guessing no" ;;
       esac
      ])
    rm -rf conftest.dir
    ]
  )
  case "$gl_cv_func_mkdir_trailing_slash_works" in
    *yes) ;;
    *)
      REPLACE_MKDIR=1
      ;;
  esac

  AC_CACHE_CHECK([whether mkdir handles trailing dot],
    [gl_cv_func_mkdir_trailing_dot_works],
    [rm -rf conftest.dir
      AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#       include <sys/types.h>
#       include <sys/stat.h>
]], [return !mkdir ("conftest.dir/./", 0700);])],
      [gl_cv_func_mkdir_trailing_dot_works=yes],
      [gl_cv_func_mkdir_trailing_dot_works=no],
      [case "$host_os" in
                        # Guess yes on glibc systems.
         *-gnu* | gnu*) gl_cv_func_mkdir_trailing_dot_works="guessing yes" ;;
                        # Guess no on native Windows.
         mingw*)        gl_cv_func_mkdir_trailing_dot_works="guessing no" ;;
                        # If we don't know, assume the worst.
         *)             gl_cv_func_mkdir_trailing_dot_works="guessing no" ;;
       esac
      ])
    rm -rf conftest.dir
    ]
  )
  case "$gl_cv_func_mkdir_trailing_dot_works" in
    *yes) ;;
    *)
      REPLACE_MKDIR=1
      AC_DEFINE([FUNC_MKDIR_DOT_BUG], [1], [Define to 1 if mkdir mistakenly
        creates a directory given with a trailing dot component.])
      ;;
  esac
])

# mkdirat.m4 serial 1
dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

AC_DEFUN([gl_FUNC_MKDIRAT],
[
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([mkdirat])
  if test $ac_cv_func_mkdirat != yes; then
    HAVE_MKDIRAT=0
  fi
])

# Prerequisite of mkdirat's declaration and of lib/mkdirat.c.
AC_DEFUN([gl_PREREQ_MKDIRAT],
[
  AC_REQUIRE([AC_TYPE_MODE_T])
])

# serial 30
dnl Copyright (C) 2002-2003, 2005-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering.

AC_DEFUN([gl_TIME_T_IS_SIGNED],
[
  AC_CACHE_CHECK([whether time_t is signed],
    [gl_cv_time_t_is_signed],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM([[#include <time.h>
                          char time_t_signed[(time_t) -1 < 0 ? 1 : -1];]])],
       [gl_cv_time_t_is_signed=yes],
       [gl_cv_time_t_is_signed=no])])
  if test $gl_cv_time_t_is_signed = yes; then
    AC_DEFINE([TIME_T_IS_SIGNED], [1], [Define to 1 if time_t is signed.])
  fi
])

dnl Test whether mktime works. Set gl_cv_func_working_mktime.
AC_DEFUN([gl_FUNC_MKTIME_WORKS],
[
  AC_REQUIRE([gl_TIME_T_IS_SIGNED])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  dnl We don't use AC_FUNC_MKTIME any more, because it is no longer maintained
  dnl in Autoconf and because it invokes AC_LIBOBJ.
  AC_CHECK_HEADERS_ONCE([unistd.h])
  AC_CHECK_DECLS_ONCE([alarm])
  AC_CHECK_FUNCS_ONCE([tzset])
  AC_REQUIRE([gl_MULTIARCH])
  if test $APPLE_UNIVERSAL_BUILD = 1; then
    # A universal build on Apple Mac OS X platforms.
    # The test result would be 'yes' in 32-bit mode and 'no' in 64-bit mode.
    # But we need a configuration result that is valid in both modes.
    gl_cv_func_working_mktime=no
  fi
  AC_CACHE_CHECK([for working mktime], [gl_cv_func_working_mktime],
    [AC_RUN_IFELSE(
       [AC_LANG_SOURCE(
[[/* Test program from Paul Eggert and Tony Leneis.  */
#include <limits.h>
#include <stdlib.h>
#include <time.h>

#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif

#if HAVE_DECL_ALARM
# include <signal.h>
#endif

#ifndef TIME_T_IS_SIGNED
# define TIME_T_IS_SIGNED 0
#endif

/* Work around redefinition to rpl_putenv by other config tests.  */
#undef putenv

static time_t time_t_max;
static time_t time_t_min;

/* Values we'll use to set the TZ environment variable.  */
static char *tz_strings[] = {
  (char *) 0, "TZ=GMT0", "TZ=JST-9",
  "TZ=EST+3EDT+2,M10.1.0/00:00:00,M2.3.0/00:00:00"
};
#define N_STRINGS (sizeof (tz_strings) / sizeof (tz_strings[0]))

/* Return 0 if mktime fails to convert a date in the spring-forward gap.
   Based on a problem report from Andreas Jaeger.  */
static int
spring_forward_gap ()
{
  /* glibc (up to about 1998-10-07) failed this test. */
  struct tm tm;

  /* Use the portable POSIX.1 specification "TZ=PST8PDT,M4.1.0,M10.5.0"
     instead of "TZ=America/Vancouver" in order to detect the bug even
     on systems that don't support the Olson extension, or don't have the
     full zoneinfo tables installed.  */
  putenv ("TZ=PST8PDT,M4.1.0,M10.5.0");

  tm.tm_year = 98;
  tm.tm_mon = 3;
  tm.tm_mday = 5;
  tm.tm_hour = 2;
  tm.tm_min = 0;
  tm.tm_sec = 0;
  tm.tm_isdst = -1;
  return mktime (&tm) != (time_t) -1;
}

static int
mktime_test1 (time_t now)
{
  struct tm *lt;
  return ! (lt = localtime (&now)) || mktime (lt) == now;
}

static int
mktime_test (time_t now)
{
  return (mktime_test1 (now)
          && mktime_test1 ((time_t) (time_t_max - now))
          && mktime_test1 ((time_t) (time_t_min + now)));
}

static int
irix_6_4_bug ()
{
  /* Based on code from Ariel Faigon.  */
  struct tm tm;
  tm.tm_year = 96;
  tm.tm_mon = 3;
  tm.tm_mday = 0;
  tm.tm_hour = 0;
  tm.tm_min = 0;
  tm.tm_sec = 0;
  tm.tm_isdst = -1;
  mktime (&tm);
  return tm.tm_mon == 2 && tm.tm_mday == 31;
}

static int
bigtime_test (int j)
{
  struct tm tm;
  time_t now;
  tm.tm_year = tm.tm_mon = tm.tm_mday = tm.tm_hour = tm.tm_min = tm.tm_sec = j;
  now = mktime (&tm);
  if (now != (time_t) -1)
    {
      struct tm *lt = localtime (&now);
      if (! (lt
             && lt->tm_year == tm.tm_year
             && lt->tm_mon == tm.tm_mon
             && lt->tm_mday == tm.tm_mday
             && lt->tm_hour == tm.tm_hour
             && lt->tm_min == tm.tm_min
             && lt->tm_sec == tm.tm_sec
             && lt->tm_yday == tm.tm_yday
             && lt->tm_wday == tm.tm_wday
             && ((lt->tm_isdst < 0 ? -1 : 0 < lt->tm_isdst)
                  == (tm.tm_isdst < 0 ? -1 : 0 < tm.tm_isdst))))
        return 0;
    }
  return 1;
}

static int
year_2050_test ()
{
  /* The correct answer for 2050-02-01 00:00:00 in Pacific time,
     ignoring leap seconds.  */
  unsigned long int answer = 2527315200UL;

  struct tm tm;
  time_t t;
  tm.tm_year = 2050 - 1900;
  tm.tm_mon = 2 - 1;
  tm.tm_mday = 1;
  tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
  tm.tm_isdst = -1;

  /* Use the portable POSIX.1 specification "TZ=PST8PDT,M4.1.0,M10.5.0"
     instead of "TZ=America/Vancouver" in order to detect the bug even
     on systems that don't support the Olson extension, or don't have the
     full zoneinfo tables installed.  */
  putenv ("TZ=PST8PDT,M4.1.0,M10.5.0");

  t = mktime (&tm);

  /* Check that the result is either a failure, or close enough
     to the correct answer that we can assume the discrepancy is
     due to leap seconds.  */
  return (t == (time_t) -1
          || (0 < t && answer - 120 <= t && t <= answer + 120));
}

int
main ()
{
  int result = 0;
  time_t t, delta;
  int i, j;
  int time_t_signed_magnitude = (time_t) ~ (time_t) 0 < (time_t) -1;

#if HAVE_DECL_ALARM
  /* This test makes some buggy mktime implementations loop.
     Give up after 60 seconds; a mktime slower than that
     isn't worth using anyway.  */
  signal (SIGALRM, SIG_DFL);
  alarm (60);
#endif

  time_t_max = (! TIME_T_IS_SIGNED
                ? (time_t) -1
                : ((((time_t) 1 << (sizeof (time_t) * CHAR_BIT - 2)) - 1)
                   * 2 + 1));
  time_t_min = (! TIME_T_IS_SIGNED
                ? (time_t) 0
                : time_t_signed_magnitude
                ? ~ (time_t) 0
                : ~ time_t_max);

  delta = time_t_max / 997; /* a suitable prime number */
  for (i = 0; i < N_STRINGS; i++)
    {
      if (tz_strings[i])
        putenv (tz_strings[i]);

      for (t = 0; t <= time_t_max - delta && (result & 1) == 0; t += delta)
        if (! mktime_test (t))
          result |= 1;
      if ((result & 2) == 0
          && ! (mktime_test ((time_t) 1)
                && mktime_test ((time_t) (60 * 60))
                && mktime_test ((time_t) (60 * 60 * 24))))
        result |= 2;

      for (j = 1; (result & 4) == 0; j <<= 1)
        {
          if (! bigtime_test (j))
            result |= 4;
          if (INT_MAX / 2 < j)
            break;
        }
      if ((result & 8) == 0 && ! bigtime_test (INT_MAX))
        result |= 8;
    }
  if (! irix_6_4_bug ())
    result |= 16;
  if (! spring_forward_gap ())
    result |= 32;
  if (! year_2050_test ())
    result |= 64;
  return result;
}]])],
       [gl_cv_func_working_mktime=yes],
       [gl_cv_func_working_mktime=no],
       [case "$host_os" in
                  # Guess no on native Windows.
          mingw*) gl_cv_func_working_mktime="guessing no" ;;
          *)      gl_cv_func_working_mktime="guessing no" ;;
        esac
       ])
    ])
])

dnl Main macro of module 'mktime'.
AC_DEFUN([gl_FUNC_MKTIME],
[
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_FUNC_MKTIME_WORKS])

  REPLACE_MKTIME=0
  if test "$gl_cv_func_working_mktime" != yes; then
    REPLACE_MKTIME=1
    AC_DEFINE([NEED_MKTIME_WORKING], [1],
      [Define if the compilation of mktime.c should define 'mktime'
       with the algorithmic workarounds.])
  fi
  case "$host_os" in
    mingw*)
      REPLACE_MKTIME=1
      AC_DEFINE([NEED_MKTIME_WINDOWS], [1],
        [Define if the compilation of mktime.c should define 'mktime'
         with the native Windows TZ workaround.])
      ;;
  esac
])

dnl Main macro of module 'mktime-internal'.
AC_DEFUN([gl_FUNC_MKTIME_INTERNAL], [
  AC_REQUIRE([gl_FUNC_MKTIME_WORKS])

  WANT_MKTIME_INTERNAL=0
  dnl BeOS has __mktime_internal in libc, but other platforms don't.
  AC_CHECK_FUNC([__mktime_internal],
    [AC_DEFINE([mktime_internal], [__mktime_internal],
       [Define to the real name of the mktime_internal function.])
    ],
    [dnl mktime works but it doesn't export __mktime_internal,
     dnl so we need to substitute our own mktime implementation.
     WANT_MKTIME_INTERNAL=1
     AC_DEFINE([NEED_MKTIME_INTERNAL], [1],
       [Define if the compilation of mktime.c should define 'mktime_internal'.])
    ])
])

# Prerequisites of lib/mktime.c.
AC_DEFUN([gl_PREREQ_MKTIME], [:])

# mmap-anon.m4 serial 10
dnl Copyright (C) 2005, 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Detect how mmap can be used to create anonymous (not file-backed) memory
# mappings.
# - On Linux, AIX, OSF/1, Solaris, Cygwin, Interix, Haiku, both MAP_ANONYMOUS
#   and MAP_ANON exist and have the same value.
# - On HP-UX, only MAP_ANONYMOUS exists.
# - On Mac OS X, FreeBSD, NetBSD, OpenBSD, only MAP_ANON exists.
# - On IRIX, neither exists, and a file descriptor opened to /dev/zero must be
#   used.

AC_DEFUN([gl_FUNC_MMAP_ANON],
[
  dnl Persuade glibc <sys/mman.h> to define MAP_ANONYMOUS.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  # Check for mmap(). Don't use AC_FUNC_MMAP, because it checks too much: it
  # fails on HP-UX 11, because MAP_FIXED mappings do not work. But this is
  # irrelevant for anonymous mappings.
  AC_CHECK_FUNC([mmap], [gl_have_mmap=yes], [gl_have_mmap=no])

  # Try to allow MAP_ANONYMOUS.
  gl_have_mmap_anonymous=no
  if test $gl_have_mmap = yes; then
    AC_MSG_CHECKING([for MAP_ANONYMOUS])
    AC_EGREP_CPP([I cannot identify this map], [
#include <sys/mman.h>
#ifdef MAP_ANONYMOUS
    I cannot identify this map
#endif
],
      [gl_have_mmap_anonymous=yes])
    if test $gl_have_mmap_anonymous != yes; then
      AC_EGREP_CPP([I cannot identify this map], [
#include <sys/mman.h>
#ifdef MAP_ANON
    I cannot identify this map
#endif
],
        [AC_DEFINE([MAP_ANONYMOUS], [MAP_ANON],
          [Define to a substitute value for mmap()'s MAP_ANONYMOUS flag.])
         gl_have_mmap_anonymous=yes])
    fi
    AC_MSG_RESULT([$gl_have_mmap_anonymous])
    if test $gl_have_mmap_anonymous = yes; then
      AC_DEFINE([HAVE_MAP_ANONYMOUS], [1],
        [Define to 1 if mmap()'s MAP_ANONYMOUS flag is available after including
         config.h and <sys/mman.h>.])
    fi
  fi
])

# mode_t.m4 serial 2
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# For using mode_t, it's sufficient to use AC_TYPE_MODE_T and
# include <sys/types.h>.

# Define PROMOTED_MODE_T to the type that is the result of "default argument
# promotion" (ISO C 6.5.2.2.(6)) of the type mode_t.
AC_DEFUN([gl_PROMOTED_TYPE_MODE_T],
[
  AC_REQUIRE([AC_TYPE_MODE_T])
  AC_CACHE_CHECK([for promoted mode_t type], [gl_cv_promoted_mode_t], [
    dnl Assume mode_t promotes to 'int' if and only if it is smaller than 'int',
    dnl and to itself otherwise. This assumption is not guaranteed by the ISO C
    dnl standard, but we don't know of any real-world counterexamples.
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>]],
      [[typedef int array[2 * (sizeof (mode_t) < sizeof (int)) - 1];]])],
      [gl_cv_promoted_mode_t='int'],
      [gl_cv_promoted_mode_t='mode_t'])
  ])
  AC_DEFINE_UNQUOTED([PROMOTED_MODE_T], [$gl_cv_promoted_mode_t],
    [Define to the type that is the result of default argument promotions of type mode_t.])
])

# msvc-inval.m4 serial 1
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_MSVC_INVAL],
[
  AC_CHECK_FUNCS_ONCE([_set_invalid_parameter_handler])
  if test $ac_cv_func__set_invalid_parameter_handler = yes; then
    HAVE_MSVC_INVALID_PARAMETER_HANDLER=1
    AC_DEFINE([HAVE_MSVC_INVALID_PARAMETER_HANDLER], [1],
      [Define to 1 on MSVC platforms that have the "invalid parameter handler"
       concept.])
  else
    HAVE_MSVC_INVALID_PARAMETER_HANDLER=0
  fi
  AC_SUBST([HAVE_MSVC_INVALID_PARAMETER_HANDLER])
])

# msvc-nothrow.m4 serial 1
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_MSVC_NOTHROW],
[
  AC_REQUIRE([gl_MSVC_INVAL])
])

# multiarch.m4 serial 7
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Determine whether the compiler is or may be producing universal binaries.
#
# On Mac OS X 10.5 and later systems, the user can create libraries and
# executables that work on multiple system types--known as "fat" or
# "universal" binaries--by specifying multiple '-arch' options to the
# compiler but only a single '-arch' option to the preprocessor.  Like
# this:
#
#     ./configure CC="gcc -arch i386 -arch x86_64 -arch ppc -arch ppc64" \
#                 CXX="g++ -arch i386 -arch x86_64 -arch ppc -arch ppc64" \
#                 CPP="gcc -E" CXXCPP="g++ -E"
#
# Detect this situation and set APPLE_UNIVERSAL_BUILD accordingly.

AC_DEFUN_ONCE([gl_MULTIARCH],
[
  dnl Code similar to autoconf-2.63 AC_C_BIGENDIAN.
  gl_cv_c_multiarch=no
  AC_COMPILE_IFELSE(
    [AC_LANG_SOURCE(
      [[#ifndef __APPLE_CC__
         not a universal capable compiler
        #endif
        typedef int dummy;
      ]])],
    [
     dnl Check for potential -arch flags.  It is not universal unless
     dnl there are at least two -arch flags with different values.
     arch=
     prev=
     for word in ${CC} ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}; do
       if test -n "$prev"; then
         case $word in
           i?86 | x86_64 | ppc | ppc64)
             if test -z "$arch" || test "$arch" = "$word"; then
               arch="$word"
             else
               gl_cv_c_multiarch=yes
             fi
             ;;
         esac
         prev=
       else
         if test "x$word" = "x-arch"; then
           prev=arch
         fi
       fi
     done
    ])
  if test $gl_cv_c_multiarch = yes; then
    APPLE_UNIVERSAL_BUILD=1
  else
    APPLE_UNIVERSAL_BUILD=0
  fi
  AC_SUBST([APPLE_UNIVERSAL_BUILD])
])

# nocrash.m4 serial 4
dnl Copyright (C) 2005, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Based on libsigsegv, from Bruno Haible and Paolo Bonzini.

AC_PREREQ([2.13])

dnl Expands to some code for use in .c programs that will cause the configure
dnl test to exit instead of crashing. This is useful to avoid triggering
dnl action from a background debugger and to avoid core dumps.
dnl Usage:   ...
dnl          ]GL_NOCRASH[
dnl          ...
dnl          int main() { nocrash_init(); ... }
AC_DEFUN([GL_NOCRASH],[[
#include <stdlib.h>
#if defined __MACH__ && defined __APPLE__
/* Avoid a crash on Mac OS X.  */
#include <mach/mach.h>
#include <mach/mach_error.h>
#include <mach/thread_status.h>
#include <mach/exception.h>
#include <mach/task.h>
#include <pthread.h>
/* The exception port on which our thread listens.  */
static mach_port_t our_exception_port;
/* The main function of the thread listening for exceptions of type
   EXC_BAD_ACCESS.  */
static void *
mach_exception_thread (void *arg)
{
  /* Buffer for a message to be received.  */
  struct {
    mach_msg_header_t head;
    mach_msg_body_t msgh_body;
    char data[1024];
  } msg;
  mach_msg_return_t retval;
  /* Wait for a message on the exception port.  */
  retval = mach_msg (&msg.head, MACH_RCV_MSG | MACH_RCV_LARGE, 0, sizeof (msg),
                     our_exception_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
  if (retval != MACH_MSG_SUCCESS)
    abort ();
  exit (1);
}
static void
nocrash_init (void)
{
  mach_port_t self = mach_task_self ();
  /* Allocate a port on which the thread shall listen for exceptions.  */
  if (mach_port_allocate (self, MACH_PORT_RIGHT_RECEIVE, &our_exception_port)
      == KERN_SUCCESS) {
    /* See http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/mach_port_insert_right.html.  */
    if (mach_port_insert_right (self, our_exception_port, our_exception_port,
                                MACH_MSG_TYPE_MAKE_SEND)
        == KERN_SUCCESS) {
      /* The exceptions we want to catch.  Only EXC_BAD_ACCESS is interesting
         for us.  */
      exception_mask_t mask = EXC_MASK_BAD_ACCESS;
      /* Create the thread listening on the exception port.  */
      pthread_attr_t attr;
      pthread_t thread;
      if (pthread_attr_init (&attr) == 0
          && pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_DETACHED) == 0
          && pthread_create (&thread, &attr, mach_exception_thread, NULL) == 0) {
        pthread_attr_destroy (&attr);
        /* Replace the exception port info for these exceptions with our own.
           Note that we replace the exception port for the entire task, not only
           for a particular thread.  This has the effect that when our exception
           port gets the message, the thread specific exception port has already
           been asked, and we don't need to bother about it.
           See http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/task_set_exception_ports.html.  */
        task_set_exception_ports (self, mask, our_exception_port,
                                  EXCEPTION_DEFAULT, MACHINE_THREAD_STATE);
      }
    }
  }
}
#elif (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
/* Avoid a crash on native Windows.  */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <winerror.h>
static LONG WINAPI
exception_filter (EXCEPTION_POINTERS *ExceptionInfo)
{
  switch (ExceptionInfo->ExceptionRecord->ExceptionCode)
    {
    case EXCEPTION_ACCESS_VIOLATION:
    case EXCEPTION_IN_PAGE_ERROR:
    case EXCEPTION_STACK_OVERFLOW:
    case EXCEPTION_GUARD_PAGE:
    case EXCEPTION_PRIV_INSTRUCTION:
    case EXCEPTION_ILLEGAL_INSTRUCTION:
    case EXCEPTION_DATATYPE_MISALIGNMENT:
    case EXCEPTION_ARRAY_BOUNDS_EXCEEDED:
    case EXCEPTION_NONCONTINUABLE_EXCEPTION:
      exit (1);
    }
  return EXCEPTION_CONTINUE_SEARCH;
}
static void
nocrash_init (void)
{
  SetUnhandledExceptionFilter ((LPTOP_LEVEL_EXCEPTION_FILTER) exception_filter);
}
#else
/* Avoid a crash on POSIX systems.  */
#include <signal.h>
#include <unistd.h>
/* A POSIX signal handler.  */
static void
exception_handler (int sig)
{
  _exit (1);
}
static void
nocrash_init (void)
{
#ifdef SIGSEGV
  signal (SIGSEGV, exception_handler);
#endif
#ifdef SIGBUS
  signal (SIGBUS, exception_handler);
#endif
}
#endif
]])

# serial 34

# Copyright (C) 1996-1997, 1999-2007, 2009-2018 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering and Paul Eggert.

AC_DEFUN([gl_FUNC_GNU_STRFTIME],
[
 # This defines (or not) HAVE_TZNAME and HAVE_TM_ZONE.
 AC_REQUIRE([AC_STRUCT_TIMEZONE])

 AC_REQUIRE([gl_TM_GMTOFF])

 AC_CHECK_FUNCS_ONCE([tzset])

 AC_DEFINE([my_strftime], [nstrftime],
   [Define to the name of the strftime replacement function.])
])

# off_t.m4 serial 1
dnl Copyright (C) 2012-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Check whether to override the 'off_t' type.
dnl Set WINDOWS_64_BIT_OFF_T.

AC_DEFUN([gl_TYPE_OFF_T],
[
  m4_ifdef([gl_LARGEFILE], [
    AC_REQUIRE([gl_LARGEFILE])
  ], [
    WINDOWS_64_BIT_OFF_T=0
  ])
  AC_SUBST([WINDOWS_64_BIT_OFF_T])
])

# Test whether O_CLOEXEC is defined.

dnl Copyright 2017-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_PREPROC_O_CLOEXEC],
[
  AC_CACHE_CHECK([for O_CLOEXEC],
    [gl_cv_macro_O_CLOEXEC],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM([[#include <fcntl.h>
                          #ifndef O_CLOEXEC
                            choke me;
                          #endif
                        ]],
                        [[return O_CLOEXEC;]])],
       [gl_cv_macro_O_CLOEXEC=yes],
       [gl_cv_macro_O_CLOEXEC=no])])
])

# open.m4 serial 15
dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_OPEN],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_PREPROC_O_CLOEXEC])
  case "$host_os" in
    mingw* | pw*)
      REPLACE_OPEN=1
      ;;
    *)
      dnl open("foo/") should not create a file when the file name has a
      dnl trailing slash.  FreeBSD only has the problem on symlinks.
      AC_CHECK_FUNCS_ONCE([lstat])
      if test "$gl_cv_macro_O_CLOEXEC" != yes; then
        REPLACE_OPEN=1
      fi
      AC_CACHE_CHECK([whether open recognizes a trailing slash],
        [gl_cv_func_open_slash],
        [# Assume that if we have lstat, we can also check symlinks.
          if test $ac_cv_func_lstat = yes; then
            touch conftest.tmp
            ln -s conftest.tmp conftest.lnk
          fi
          AC_RUN_IFELSE(
            [AC_LANG_SOURCE([[
#include <fcntl.h>
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
int main ()
{
  int result = 0;
#if HAVE_LSTAT
  if (open ("conftest.lnk/", O_RDONLY) != -1)
    result |= 1;
#endif
  if (open ("conftest.sl/", O_CREAT, 0600) >= 0)
    result |= 2;
  return result;
}]])],
            [gl_cv_func_open_slash=yes],
            [gl_cv_func_open_slash=no],
            [
changequote(,)dnl
             case "$host_os" in
               freebsd* | aix* | hpux* | solaris2.[0-9] | solaris2.[0-9].*)
                 gl_cv_func_open_slash="guessing no" ;;
               *)
                 gl_cv_func_open_slash="guessing yes" ;;
             esac
changequote([,])dnl
            ])
          rm -f conftest.sl conftest.tmp conftest.lnk
        ])
      case "$gl_cv_func_open_slash" in
        *no)
          AC_DEFINE([OPEN_TRAILING_SLASH_BUG], [1],
            [Define to 1 if open() fails to recognize a trailing slash.])
          REPLACE_OPEN=1
          ;;
      esac
      ;;
  esac
  dnl Replace open() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    if test $REPLACE_OPEN = 0; then
      gl_TEST_FCHDIR
      if test $HAVE_FCHDIR = 0; then
        REPLACE_OPEN=1
      fi
    fi
  ])
  dnl Replace open() for supporting the gnulib-defined O_NONBLOCK flag.
  m4_ifdef([gl_NONBLOCKING_IO], [
    if test $REPLACE_OPEN = 0; then
      gl_NONBLOCKING_IO
      if test $gl_cv_have_open_O_NONBLOCK != yes; then
        REPLACE_OPEN=1
      fi
    fi
  ])
])

# Prerequisites of lib/open.c.
AC_DEFUN([gl_PREREQ_OPEN],
[
  AC_REQUIRE([gl_PROMOTED_TYPE_MODE_T])
  :
])

# serial 46
# See if we need to use our replacement for Solaris' openat et al functions.

dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

AC_DEFUN([gl_FUNC_OPENAT],
[
  AC_REQUIRE([gl_FCNTL_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([openat])
  AC_REQUIRE([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK])
  AC_REQUIRE([gl_PREPROC_O_CLOEXEC])
  case $ac_cv_func_openat+$gl_cv_func_lstat_dereferences_slashed_symlink+$gl_cv_macro_O_CLOEXEC in
  yes+*yes+yes)
    ;;
  yes+*)
    # Solaris 10 lacks O_CLOEXEC.
    # Solaris 9 has *at functions, but uniformly mishandles trailing
    # slash in all of them.
    REPLACE_OPENAT=1
    ;;
  *)
    HAVE_OPENAT=0
    ;;
  esac
])

# Prerequisites of lib/openat.c.
AC_DEFUN([gl_PREREQ_OPENAT],
[
  AC_REQUIRE([gl_PROMOTED_TYPE_MODE_T])
  :
])

# opendir.m4 serial 5
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_OPENDIR],
[
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_CHECK_FUNCS([opendir])
  if test $ac_cv_func_opendir = no; then
    HAVE_OPENDIR=0
  fi
  dnl Replace opendir() for supporting the gnulib-defined fchdir() function,
  dnl to keep fchdir's bookkeeping up-to-date.
  m4_ifdef([gl_FUNC_FCHDIR], [
    gl_TEST_FCHDIR
    if test $HAVE_FCHDIR = 0; then
      if test $HAVE_OPENDIR = 1; then
        REPLACE_OPENDIR=1
      fi
    fi
  ])
  dnl Replace opendir() on OS/2 kLIBC to support dirfd() function replaced
  dnl by gnulib.
  case $host_os,$HAVE_OPENDIR in
    os2*,1)
      REPLACE_OPENDIR=1;;
  esac
])

# parse-datetime.m4 serial 22
dnl Copyright (C) 2002-2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Define HAVE_COMPOUND_LITERALS if the C compiler supports compound literals
dnl as in ISO C99.
dnl Note that compound literals such as (struct s) { 3, 4 } can be used for
dnl initialization of stack-allocated variables, but are not constant
dnl expressions and therefore cannot be used as initializer for global or
dnl static variables (even though gcc supports this in pre-C99 mode).
AC_DEFUN([gl_C_COMPOUND_LITERALS],
[
  AC_CACHE_CHECK([for compound literals], [gl_cv_compound_literals],
  [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[struct s { int i, j; };]],
      [[struct s t = (struct s) { 3, 4 };
        if (t.i != 0) return 0;]])],
    gl_cv_compound_literals=yes,
    gl_cv_compound_literals=no)])
  if test $gl_cv_compound_literals = yes; then
    AC_DEFINE([HAVE_COMPOUND_LITERALS], [1],
      [Define if you have compound literals.])
  fi
])

AC_DEFUN([gl_PARSE_DATETIME],
[
  dnl Prerequisites of lib/parse-datetime.h.
  AC_REQUIRE([AM_STDBOOL_H])
  AC_REQUIRE([gl_TIMESPEC])

  dnl Prerequisites of lib/parse-datetime.y.
  AC_REQUIRE([gl_BISON])
  AC_REQUIRE([gl_C_COMPOUND_LITERALS])
  AC_STRUCT_TIMEZONE
  AC_REQUIRE([gl_CLOCK_TIME])
  AC_REQUIRE([gl_TM_GMTOFF])
])

# pathmax.m4 serial 10
dnl Copyright (C) 2002-2003, 2005-2006, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_PATHMAX],
[
  dnl Prerequisites of lib/pathmax.h.
  AC_CHECK_HEADERS_ONCE([sys/param.h])
])

# Expands to a piece of C program that defines PATH_MAX in the same way as
# "pathmax.h" will do.
AC_DEFUN([gl_PATHMAX_SNIPPET], [[
/* Arrange to define PATH_MAX, like "pathmax.h" does. */
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
#include <limits.h>
#if defined HAVE_SYS_PARAM_H && !defined PATH_MAX && !defined MAXPATHLEN
# include <sys/param.h>
#endif
#if !defined PATH_MAX && defined MAXPATHLEN
# define PATH_MAX MAXPATHLEN
#endif
#ifdef __hpux
# undef PATH_MAX
# define PATH_MAX 1024
#endif
#if (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
# undef PATH_MAX
# define PATH_MAX 260
#endif
]])

# Prerequisites of gl_PATHMAX_SNIPPET.
AC_DEFUN([gl_PATHMAX_SNIPPET_PREREQ],
[
  AC_CHECK_HEADERS_ONCE([unistd.h sys/param.h])
])

# printf.m4 serial 58
dnl Copyright (C) 2003, 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Test whether the *printf family of functions supports the 'j', 'z', 't',
dnl 'L' size specifiers. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_sizes_c99.

AC_DEFUN([gl_PRINTF_SIZES_C99],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gl_AC_HEADER_STDINT_H])
  AC_REQUIRE([gl_AC_HEADER_INTTYPES_H])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports size specifiers as in C99],
    [gl_cv_func_printf_sizes_c99],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#if HAVE_STDINT_H_WITH_UINTMAX
# include <stdint.h>
#endif
#if HAVE_INTTYPES_H_WITH_UINTMAX
# include <inttypes.h>
#endif
static char buf[100];
int main ()
{
  int result = 0;
#if HAVE_STDINT_H_WITH_UINTMAX || HAVE_INTTYPES_H_WITH_UINTMAX
  buf[0] = '\0';
  if (sprintf (buf, "%ju %d", (uintmax_t) 12345671, 33, 44, 55) < 0
      || strcmp (buf, "12345671 33") != 0)
    result |= 1;
#else
  result |= 1;
#endif
  buf[0] = '\0';
  if (sprintf (buf, "%zu %d", (size_t) 12345672, 33, 44, 55) < 0
      || strcmp (buf, "12345672 33") != 0)
    result |= 2;
  buf[0] = '\0';
  if (sprintf (buf, "%tu %d", (ptrdiff_t) 12345673, 33, 44, 55) < 0
      || strcmp (buf, "12345673 33") != 0)
    result |= 4;
  buf[0] = '\0';
  if (sprintf (buf, "%Lg %d", (long double) 1.5, 33, 44, 55) < 0
      || strcmp (buf, "1.5 33") != 0)
    result |= 8;
  return result;
}]])],
        [gl_cv_func_printf_sizes_c99=yes],
        [gl_cv_func_printf_sizes_c99=no],
        [
         case "$host_os" in
changequote(,)dnl
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_printf_sizes_c99="guessing yes";;
                                 # Guess yes on FreeBSD >= 5.
           freebsd[1-4].*)       gl_cv_func_printf_sizes_c99="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_printf_sizes_c99="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_printf_sizes_c99="guessing no";;
           darwin*)              gl_cv_func_printf_sizes_c99="guessing yes";;
                                 # Guess yes on OpenBSD >= 3.9.
           openbsd[1-2].* | openbsd3.[0-8] | openbsd3.[0-8].*)
                                 gl_cv_func_printf_sizes_c99="guessing no";;
           openbsd*)             gl_cv_func_printf_sizes_c99="guessing yes";;
                                 # Guess yes on Solaris >= 2.10.
           solaris2.[1-9][0-9]*) gl_cv_func_printf_sizes_c99="guessing yes";;
           solaris*)             gl_cv_func_printf_sizes_c99="guessing no";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_printf_sizes_c99="guessing no";;
           netbsd*)              gl_cv_func_printf_sizes_c99="guessing yes";;
changequote([,])dnl
                                 # Guess yes on MSVC, no on mingw.
           mingw*)               AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                                   ],
                                   [gl_cv_func_printf_sizes_c99="guessing yes"],
                                   [gl_cv_func_printf_sizes_c99="guessing no"])
                                 ;;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_printf_sizes_c99="guessing no";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports 'long double'
dnl arguments together with the 'L' size specifier. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_long_double.

AC_DEFUN([gl_PRINTF_LONG_DOUBLE],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports 'long double' arguments],
    [gl_cv_func_printf_long_double],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[10000];
int main ()
{
  int result = 0;
  buf[0] = '\0';
  if (sprintf (buf, "%Lf %d", 1.75L, 33, 44, 55) < 0
      || strcmp (buf, "1.750000 33") != 0)
    result |= 1;
  buf[0] = '\0';
  if (sprintf (buf, "%Le %d", 1.75L, 33, 44, 55) < 0
      || strcmp (buf, "1.750000e+00 33") != 0)
    result |= 2;
  buf[0] = '\0';
  if (sprintf (buf, "%Lg %d", 1.75L, 33, 44, 55) < 0
      || strcmp (buf, "1.75 33") != 0)
    result |= 4;
  return result;
}]])],
        [gl_cv_func_printf_long_double=yes],
        [gl_cv_func_printf_long_double=no],
        [case "$host_os" in
           beos*)  gl_cv_func_printf_long_double="guessing no";;
                   # Guess yes on MSVC, no on mingw.
           mingw*) AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                     ],
                     [gl_cv_func_printf_long_double="guessing yes"],
                     [gl_cv_func_printf_long_double="guessing no"])
                   ;;
           *)      gl_cv_func_printf_long_double="guessing yes";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports infinite and NaN
dnl 'double' arguments and negative zero arguments in the %f, %e, %g
dnl directives. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_infinite.

AC_DEFUN([gl_PRINTF_INFINITE],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports infinite 'double' arguments],
    [gl_cv_func_printf_infinite],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static int
strisnan (const char *string, size_t start_index, size_t end_index)
{
  if (start_index < end_index)
    {
      if (string[start_index] == '-')
        start_index++;
      if (start_index + 3 <= end_index
          && memcmp (string + start_index, "nan", 3) == 0)
        {
          start_index += 3;
          if (start_index == end_index
              || (string[start_index] == '(' && string[end_index - 1] == ')'))
            return 1;
        }
    }
  return 0;
}
static int
have_minus_zero ()
{
  static double plus_zero = 0.0;
  double minus_zero = - plus_zero;
  return memcmp (&plus_zero, &minus_zero, sizeof (double)) != 0;
}
static char buf[10000];
static double zero = 0.0;
int main ()
{
  int result = 0;
  if (sprintf (buf, "%f", 1.0 / zero) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%f", -1.0 / zero) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%f", zero / zero) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 2;
  if (sprintf (buf, "%e", 1.0 / zero) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 4;
  if (sprintf (buf, "%e", -1.0 / zero) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 4;
  if (sprintf (buf, "%e", zero / zero) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 8;
  if (sprintf (buf, "%g", 1.0 / zero) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 16;
  if (sprintf (buf, "%g", -1.0 / zero) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 16;
  if (sprintf (buf, "%g", zero / zero) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 32;
  /* This test fails on HP-UX 10.20.  */
  if (have_minus_zero ())
    if (sprintf (buf, "%g", - zero) < 0
        || strcmp (buf, "-0") != 0)
    result |= 64;
  return result;
}]])],
        [gl_cv_func_printf_infinite=yes],
        [gl_cv_func_printf_infinite=no],
        [
         case "$host_os" in
changequote(,)dnl
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_printf_infinite="guessing yes";;
                                 # Guess yes on FreeBSD >= 6.
           freebsd[1-5].*)       gl_cv_func_printf_infinite="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_printf_infinite="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_printf_infinite="guessing no";;
           darwin*)              gl_cv_func_printf_infinite="guessing yes";;
                                 # Guess yes on HP-UX >= 11.
           hpux[7-9]* | hpux10*) gl_cv_func_printf_infinite="guessing no";;
           hpux*)                gl_cv_func_printf_infinite="guessing yes";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_printf_infinite="guessing no";;
           netbsd*)              gl_cv_func_printf_infinite="guessing yes";;
                                 # Guess yes on BeOS.
           beos*)                gl_cv_func_printf_infinite="guessing yes";;
changequote([,])dnl
                                 # Guess yes on MSVC, no on mingw.
           mingw*)               AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                                   ],
                                   [gl_cv_func_printf_infinite="guessing yes"],
                                   [gl_cv_func_printf_infinite="guessing no"])
                                 ;;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_printf_infinite="guessing no";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports infinite and NaN
dnl 'long double' arguments in the %f, %e, %g directives. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_infinite_long_double.

AC_DEFUN([gl_PRINTF_INFINITE_LONG_DOUBLE],
[
  AC_REQUIRE([gl_PRINTF_LONG_DOUBLE])
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gl_BIGENDIAN])
  AC_REQUIRE([gl_LONG_DOUBLE_VS_DOUBLE])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  dnl The user can set or unset the variable gl_printf_safe to indicate
  dnl that he wishes a safe handling of non-IEEE-754 'long double' values.
  if test -n "$gl_printf_safe"; then
    AC_DEFINE([CHECK_PRINTF_SAFE], [1],
      [Define if you wish *printf() functions that have a safe handling of
       non-IEEE-754 'long double' values.])
  fi
  case "$gl_cv_func_printf_long_double" in
    *yes)
      AC_CACHE_CHECK([whether printf supports infinite 'long double' arguments],
        [gl_cv_func_printf_infinite_long_double],
        [
          AC_RUN_IFELSE(
            [AC_LANG_SOURCE([[
]GL_NOCRASH[
#include <float.h>
#include <stdio.h>
#include <string.h>
static int
strisnan (const char *string, size_t start_index, size_t end_index)
{
  if (start_index < end_index)
    {
      if (string[start_index] == '-')
        start_index++;
      if (start_index + 3 <= end_index
          && memcmp (string + start_index, "nan", 3) == 0)
        {
          start_index += 3;
          if (start_index == end_index
              || (string[start_index] == '(' && string[end_index - 1] == ')'))
            return 1;
        }
    }
  return 0;
}
static char buf[10000];
static long double zeroL = 0.0L;
int main ()
{
  int result = 0;
  nocrash_init();
  if (sprintf (buf, "%Lf", 1.0L / zeroL) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Lf", -1.0L / zeroL) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Lf", zeroL / zeroL) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 1;
  if (sprintf (buf, "%Le", 1.0L / zeroL) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Le", -1.0L / zeroL) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Le", zeroL / zeroL) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 1;
  if (sprintf (buf, "%Lg", 1.0L / zeroL) < 0
      || (strcmp (buf, "inf") != 0 && strcmp (buf, "infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Lg", -1.0L / zeroL) < 0
      || (strcmp (buf, "-inf") != 0 && strcmp (buf, "-infinity") != 0))
    result |= 1;
  if (sprintf (buf, "%Lg", zeroL / zeroL) < 0
      || !strisnan (buf, 0, strlen (buf)))
    result |= 1;
#if CHECK_PRINTF_SAFE && ((defined __ia64 && LDBL_MANT_DIG == 64) || (defined __x86_64__ || defined __amd64__) || (defined __i386 || defined __i386__ || defined _I386 || defined _M_IX86 || defined _X86_)) && !HAVE_SAME_LONG_DOUBLE_AS_DOUBLE
/* Representation of an 80-bit 'long double' as an initializer for a sequence
   of 'unsigned int' words.  */
# ifdef WORDS_BIGENDIAN
#  define LDBL80_WORDS(exponent,manthi,mantlo) \
     { ((unsigned int) (exponent) << 16) | ((unsigned int) (manthi) >> 16), \
       ((unsigned int) (manthi) << 16) | ((unsigned int) (mantlo) >> 16),   \
       (unsigned int) (mantlo) << 16                                        \
     }
# else
#  define LDBL80_WORDS(exponent,manthi,mantlo) \
     { mantlo, manthi, exponent }
# endif
  { /* Quiet NaN.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0xFFFF, 0xC3333333, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
    if (sprintf (buf, "%Le", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
    if (sprintf (buf, "%Lg", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
  }
  {
    /* Signalling NaN.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0xFFFF, 0x83333333, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
    if (sprintf (buf, "%Le", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
    if (sprintf (buf, "%Lg", x.value) < 0
        || !strisnan (buf, 0, strlen (buf)))
      result |= 2;
  }
  { /* Pseudo-NaN.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0xFFFF, 0x40000001, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) <= 0)
      result |= 4;
    if (sprintf (buf, "%Le", x.value) <= 0)
      result |= 4;
    if (sprintf (buf, "%Lg", x.value) <= 0)
      result |= 4;
  }
  { /* Pseudo-Infinity.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0xFFFF, 0x00000000, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) <= 0)
      result |= 8;
    if (sprintf (buf, "%Le", x.value) <= 0)
      result |= 8;
    if (sprintf (buf, "%Lg", x.value) <= 0)
      result |= 8;
  }
  { /* Pseudo-Zero.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0x4004, 0x00000000, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) <= 0)
      result |= 16;
    if (sprintf (buf, "%Le", x.value) <= 0)
      result |= 16;
    if (sprintf (buf, "%Lg", x.value) <= 0)
      result |= 16;
  }
  { /* Unnormalized number.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0x4000, 0x63333333, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) <= 0)
      result |= 32;
    if (sprintf (buf, "%Le", x.value) <= 0)
      result |= 32;
    if (sprintf (buf, "%Lg", x.value) <= 0)
      result |= 32;
  }
  { /* Pseudo-Denormal.  */
    static union { unsigned int word[4]; long double value; } x =
      { LDBL80_WORDS (0x0000, 0x83333333, 0x00000000) };
    if (sprintf (buf, "%Lf", x.value) <= 0)
      result |= 64;
    if (sprintf (buf, "%Le", x.value) <= 0)
      result |= 64;
    if (sprintf (buf, "%Lg", x.value) <= 0)
      result |= 64;
  }
#endif
  return result;
}]])],
            [gl_cv_func_printf_infinite_long_double=yes],
            [gl_cv_func_printf_infinite_long_double=no],
            [case "$host_cpu" in
                                     # Guess no on ia64, x86_64, i386.
               ia64 | x86_64 | i*86) gl_cv_func_printf_infinite_long_double="guessing no";;
               *)
                 case "$host_os" in
changequote(,)dnl
                                         # Guess yes on glibc systems.
                   *-gnu* | gnu*)        gl_cv_func_printf_infinite_long_double="guessing yes";;
                                         # Guess yes on FreeBSD >= 6.
                   freebsd[1-5].*)       gl_cv_func_printf_infinite_long_double="guessing no";;
                   freebsd* | kfreebsd*) gl_cv_func_printf_infinite_long_double="guessing yes";;
                                         # Guess yes on HP-UX >= 11.
                   hpux[7-9]* | hpux10*) gl_cv_func_printf_infinite_long_double="guessing no";;
                   hpux*)                gl_cv_func_printf_infinite_long_double="guessing yes";;
changequote([,])dnl
                                         # Guess yes on MSVC, no on mingw.
                   mingw*)               AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                                           ],
                                           [gl_cv_func_printf_infinite_long_double="guessing yes"],
                                           [gl_cv_func_printf_infinite_long_double="guessing no"])
                                         ;;
                                         # If we don't know, assume the worst.
                   *)                    gl_cv_func_printf_infinite_long_double="guessing no";;
                 esac
                 ;;
             esac
            ])
        ])
      ;;
    *)
      gl_cv_func_printf_infinite_long_double="irrelevant"
      ;;
  esac
])

dnl Test whether the *printf family of functions supports the 'a' and 'A'
dnl conversion specifier for hexadecimal output of floating-point numbers.
dnl (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_directive_a.

AC_DEFUN([gl_PRINTF_DIRECTIVE_A],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the 'a' and 'A' directives],
    [gl_cv_func_printf_directive_a],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[100];
static double zero = 0.0;
int main ()
{
  int result = 0;
  if (sprintf (buf, "%a %d", 3.1416015625, 33, 44, 55) < 0
      || (strcmp (buf, "0x1.922p+1 33") != 0
          && strcmp (buf, "0x3.244p+0 33") != 0
          && strcmp (buf, "0x6.488p-1 33") != 0
          && strcmp (buf, "0xc.91p-2 33") != 0))
    result |= 1;
  if (sprintf (buf, "%A %d", -3.1416015625, 33, 44, 55) < 0
      || (strcmp (buf, "-0X1.922P+1 33") != 0
          && strcmp (buf, "-0X3.244P+0 33") != 0
          && strcmp (buf, "-0X6.488P-1 33") != 0
          && strcmp (buf, "-0XC.91P-2 33") != 0))
    result |= 2;
  /* This catches a FreeBSD 6.1 bug: it doesn't round.  */
  if (sprintf (buf, "%.2a %d", 1.51, 33, 44, 55) < 0
      || (strcmp (buf, "0x1.83p+0 33") != 0
          && strcmp (buf, "0x3.05p-1 33") != 0
          && strcmp (buf, "0x6.0ap-2 33") != 0
          && strcmp (buf, "0xc.14p-3 33") != 0))
    result |= 4;
  /* This catches a Mac OS X 10.12.4 (Darwin 16.5) bug: it doesn't round.  */
  if (sprintf (buf, "%.0a %d", 1.51, 33, 44, 55) < 0
      || (strcmp (buf, "0x2p+0 33") != 0
          && strcmp (buf, "0x3p-1 33") != 0
          && strcmp (buf, "0x6p-2 33") != 0
          && strcmp (buf, "0xcp-3 33") != 0))
    result |= 4;
  /* This catches a FreeBSD 6.1 bug.  See
     <https://lists.gnu.org/r/bug-gnulib/2007-04/msg00107.html> */
  if (sprintf (buf, "%010a %d", 1.0 / zero, 33, 44, 55) < 0
      || buf[0] == '0')
    result |= 8;
  /* This catches a Mac OS X 10.3.9 (Darwin 7.9) bug.  */
  if (sprintf (buf, "%.1a", 1.999) < 0
      || (strcmp (buf, "0x1.0p+1") != 0
          && strcmp (buf, "0x2.0p+0") != 0
          && strcmp (buf, "0x4.0p-1") != 0
          && strcmp (buf, "0x8.0p-2") != 0))
    result |= 16;
  /* This catches the same Mac OS X 10.3.9 (Darwin 7.9) bug and also a
     glibc 2.4 bug <https://sourceware.org/bugzilla/show_bug.cgi?id=2908>.  */
  if (sprintf (buf, "%.1La", 1.999L) < 0
      || (strcmp (buf, "0x1.0p+1") != 0
          && strcmp (buf, "0x2.0p+0") != 0
          && strcmp (buf, "0x4.0p-1") != 0
          && strcmp (buf, "0x8.0p-2") != 0))
    result |= 32;
  return result;
}]])],
        [gl_cv_func_printf_directive_a=yes],
        [gl_cv_func_printf_directive_a=no],
        [
         case "$host_os" in
                                 # Guess yes on glibc >= 2.5 systems.
           *-gnu* | gnu*)
             AC_EGREP_CPP([BZ2908], [
               #include <features.h>
               #ifdef __GNU_LIBRARY__
                #if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 5) || (__GLIBC__ > 2)) && !defined __UCLIBC__
                 BZ2908
                #endif
               #endif
               ],
               [gl_cv_func_printf_directive_a="guessing yes"],
               [gl_cv_func_printf_directive_a="guessing no"])
             ;;
                                 # Guess no on native Windows.
           mingw*)               gl_cv_func_printf_directive_a="guessing no";;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_printf_directive_a="guessing no";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports the %F format
dnl directive. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_directive_f.

AC_DEFUN([gl_PRINTF_DIRECTIVE_F],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the 'F' directive],
    [gl_cv_func_printf_directive_f],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[100];
static double zero = 0.0;
int main ()
{
  int result = 0;
  if (sprintf (buf, "%F %d", 1234567.0, 33, 44, 55) < 0
      || strcmp (buf, "1234567.000000 33") != 0)
    result |= 1;
  if (sprintf (buf, "%F", 1.0 / zero) < 0
      || (strcmp (buf, "INF") != 0 && strcmp (buf, "INFINITY") != 0))
    result |= 2;
  /* This catches a Cygwin 1.5.x bug.  */
  if (sprintf (buf, "%.F", 1234.0) < 0
      || strcmp (buf, "1234") != 0)
    result |= 4;
  return result;
}]])],
        [gl_cv_func_printf_directive_f=yes],
        [gl_cv_func_printf_directive_f=no],
        [
         case "$host_os" in
changequote(,)dnl
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_printf_directive_f="guessing yes";;
                                 # Guess yes on FreeBSD >= 6.
           freebsd[1-5].*)       gl_cv_func_printf_directive_f="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_printf_directive_f="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_printf_directive_f="guessing no";;
           darwin*)              gl_cv_func_printf_directive_f="guessing yes";;
                                 # Guess yes on Solaris >= 2.10.
           solaris2.[1-9][0-9]*) gl_cv_func_printf_directive_f="guessing yes";;
           solaris*)             gl_cv_func_printf_directive_f="guessing no";;
changequote([,])dnl
                                 # Guess yes on MSVC, no on mingw.
           mingw*)               AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                                   ],
                                   [gl_cv_func_printf_directive_f="guessing yes"],
                                   [gl_cv_func_printf_directive_f="guessing no"])
                                 ;;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_printf_directive_f="guessing no";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports the %n format
dnl directive. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_printf_directive_n.

AC_DEFUN([gl_PRINTF_DIRECTIVE_N],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the 'n' directive],
    [gl_cv_func_printf_directive_n],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _MSC_VER
/* See page about "Parameter Validation" on msdn.microsoft.com.  */
static void cdecl
invalid_parameter_handler (const wchar_t *expression,
                           const wchar_t *function,
                           const wchar_t *file, unsigned int line,
                           uintptr_t dummy)
{
  exit (1);
}
#endif
static char fmtstring[10];
static char buf[100];
int main ()
{
  int count = -1;
#ifdef _MSC_VER
  _set_invalid_parameter_handler (invalid_parameter_handler);
#endif
  /* Copy the format string.  Some systems (glibc with _FORTIFY_SOURCE=2)
     support %n in format strings in read-only memory but not in writable
     memory.  */
  strcpy (fmtstring, "%d %n");
  if (sprintf (buf, fmtstring, 123, &count, 33, 44, 55) < 0
      || strcmp (buf, "123 ") != 0
      || count != 4)
    return 1;
  return 0;
}]])],
        [gl_cv_func_printf_directive_n=yes],
        [gl_cv_func_printf_directive_n=no],
        [case "$host_os" in
                   # Guess no on native Windows.
           mingw*) gl_cv_func_printf_directive_n="guessing no";;
           *)      gl_cv_func_printf_directive_n="guessing yes";;
         esac
        ])
    ])
])

dnl Test whether the *printf family of functions supports the %ls format
dnl directive and in particular, when a precision is specified, whether
dnl the functions stop converting the wide string argument when the number
dnl of bytes that have been produced by this conversion equals or exceeds
dnl the precision.
dnl Result is gl_cv_func_printf_directive_ls.

AC_DEFUN([gl_PRINTF_DIRECTIVE_LS],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the 'ls' directive],
    [gl_cv_func_printf_directive_ls],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
#include <string.h>
int main ()
{
  int result = 0;
  char buf[100];
  /* Test whether %ls works at all.
     This test fails on OpenBSD 4.0, IRIX 6.5, Solaris 2.6, Haiku, but not on
     Cygwin 1.5.  */
  {
    static const wchar_t wstring[] = { 'a', 'b', 'c', 0 };
    buf[0] = '\0';
    if (sprintf (buf, "%ls", wstring) < 0
        || strcmp (buf, "abc") != 0)
      result |= 1;
  }
  /* This test fails on IRIX 6.5, Solaris 2.6, Cygwin 1.5, Haiku (with an
     assertion failure inside libc), but not on OpenBSD 4.0.  */
  {
    static const wchar_t wstring[] = { 'a', 0 };
    buf[0] = '\0';
    if (sprintf (buf, "%ls", wstring) < 0
        || strcmp (buf, "a") != 0)
      result |= 2;
  }
  /* Test whether precisions in %ls are supported as specified in ISO C 99
     section 7.19.6.1:
       "If a precision is specified, no more than that many bytes are written
        (including shift sequences, if any), and the array shall contain a
        null wide character if, to equal the multibyte character sequence
        length given by the precision, the function would need to access a
        wide character one past the end of the array."
     This test fails on Solaris 10.  */
  {
    static const wchar_t wstring[] = { 'a', 'b', (wchar_t) 0xfdfdfdfd, 0 };
    buf[0] = '\0';
    if (sprintf (buf, "%.2ls", wstring) < 0
        || strcmp (buf, "ab") != 0)
      result |= 8;
  }
  return result;
}]])],
        [gl_cv_func_printf_directive_ls=yes],
        [gl_cv_func_printf_directive_ls=no],
        [
changequote(,)dnl
         case "$host_os" in
           openbsd*)       gl_cv_func_printf_directive_ls="guessing no";;
           irix*)          gl_cv_func_printf_directive_ls="guessing no";;
           solaris*)       gl_cv_func_printf_directive_ls="guessing no";;
           cygwin*)        gl_cv_func_printf_directive_ls="guessing no";;
           beos* | haiku*) gl_cv_func_printf_directive_ls="guessing no";;
                           # Guess yes on native Windows.
           mingw*)         gl_cv_func_printf_directive_ls="guessing yes";;
           *)              gl_cv_func_printf_directive_ls="guessing yes";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions supports POSIX/XSI format
dnl strings with positions. (POSIX:2001)
dnl Result is gl_cv_func_printf_positions.

AC_DEFUN([gl_PRINTF_POSITIONS],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports POSIX/XSI format strings with positions],
    [gl_cv_func_printf_positions],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
/* The string "%2$d %1$d", with dollar characters protected from the shell's
   dollar expansion (possibly an autoconf bug).  */
static char format[] = { '%', '2', '$', 'd', ' ', '%', '1', '$', 'd', '\0' };
static char buf[100];
int main ()
{
  sprintf (buf, format, 33, 55);
  return (strcmp (buf, "55 33") != 0);
}]])],
        [gl_cv_func_printf_positions=yes],
        [gl_cv_func_printf_positions=no],
        [
changequote(,)dnl
         case "$host_os" in
           netbsd[1-3]* | netbsdelf[1-3]* | netbsdaout[1-3]* | netbsdcoff[1-3]*)
                         gl_cv_func_printf_positions="guessing no";;
           beos*)        gl_cv_func_printf_positions="guessing no";;
                         # Guess no on native Windows.
           mingw* | pw*) gl_cv_func_printf_positions="guessing no";;
           *)            gl_cv_func_printf_positions="guessing yes";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions supports POSIX/XSI format
dnl strings with the ' flag for grouping of decimal digits. (POSIX:2001)
dnl Result is gl_cv_func_printf_flag_grouping.

AC_DEFUN([gl_PRINTF_FLAG_GROUPING],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the grouping flag],
    [gl_cv_func_printf_flag_grouping],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[100];
int main ()
{
  if (sprintf (buf, "%'d %d", 1234567, 99) < 0
      || buf[strlen (buf) - 1] != '9')
    return 1;
  return 0;
}]])],
        [gl_cv_func_printf_flag_grouping=yes],
        [gl_cv_func_printf_flag_grouping=no],
        [
changequote(,)dnl
         case "$host_os" in
           cygwin*)      gl_cv_func_printf_flag_grouping="guessing no";;
           netbsd*)      gl_cv_func_printf_flag_grouping="guessing no";;
                         # Guess no on native Windows.
           mingw* | pw*) gl_cv_func_printf_flag_grouping="guessing no";;
           *)            gl_cv_func_printf_flag_grouping="guessing yes";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions supports the - flag correctly.
dnl (ISO C99.) See
dnl <https://lists.gnu.org/r/bug-coreutils/2008-02/msg00035.html>
dnl Result is gl_cv_func_printf_flag_leftadjust.

AC_DEFUN([gl_PRINTF_FLAG_LEFTADJUST],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the left-adjust flag correctly],
    [gl_cv_func_printf_flag_leftadjust],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[100];
int main ()
{
  /* Check that a '-' flag is not annihilated by a negative width.  */
  if (sprintf (buf, "a%-*sc", -3, "b") < 0
      || strcmp (buf, "ab  c") != 0)
    return 1;
  return 0;
}]])],
        [gl_cv_func_printf_flag_leftadjust=yes],
        [gl_cv_func_printf_flag_leftadjust=no],
        [
changequote(,)dnl
         case "$host_os" in
                    # Guess yes on HP-UX 11.
           hpux11*) gl_cv_func_printf_flag_leftadjust="guessing yes";;
                    # Guess no on HP-UX 10 and older.
           hpux*)   gl_cv_func_printf_flag_leftadjust="guessing no";;
                    # Guess yes on native Windows.
           mingw*)  gl_cv_func_printf_flag_leftadjust="guessing yes";;
                    # Guess yes otherwise.
           *)       gl_cv_func_printf_flag_leftadjust="guessing yes";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions supports padding of non-finite
dnl values with the 0 flag correctly. (ISO C99 + TC1 + TC2.) See
dnl <https://lists.gnu.org/r/bug-gnulib/2007-04/msg00107.html>
dnl Result is gl_cv_func_printf_flag_zero.

AC_DEFUN([gl_PRINTF_FLAG_ZERO],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports the zero flag correctly],
    [gl_cv_func_printf_flag_zero],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[100];
static double zero = 0.0;
int main ()
{
  if (sprintf (buf, "%010f", 1.0 / zero, 33, 44, 55) < 0
      || (strcmp (buf, "       inf") != 0
          && strcmp (buf, "  infinity") != 0))
    return 1;
  return 0;
}]])],
        [gl_cv_func_printf_flag_zero=yes],
        [gl_cv_func_printf_flag_zero=no],
        [
changequote(,)dnl
         case "$host_os" in
                          # Guess yes on glibc systems.
           *-gnu* | gnu*) gl_cv_func_printf_flag_zero="guessing yes";;
                          # Guess yes on BeOS.
           beos*)         gl_cv_func_printf_flag_zero="guessing yes";;
                          # Guess no on native Windows.
           mingw*)        gl_cv_func_printf_flag_zero="guessing no";;
                          # If we don't know, assume the worst.
           *)             gl_cv_func_printf_flag_zero="guessing no";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions supports large precisions.
dnl On mingw, precisions larger than 512 are treated like 512, in integer,
dnl floating-point or pointer output. On Solaris 10/x86, precisions larger
dnl than 510 in floating-point output crash the program. On Solaris 10/SPARC,
dnl precisions larger than 510 in floating-point output yield wrong results.
dnl On AIX 7.1, precisions larger than 998 in floating-point output yield
dnl wrong results. On BeOS, precisions larger than 1044 crash the program.
dnl Result is gl_cv_func_printf_precision.

AC_DEFUN([gl_PRINTF_PRECISION],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf supports large precisions],
    [gl_cv_func_printf_precision],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
static char buf[5000];
int main ()
{
  int result = 0;
#ifdef __BEOS__
  /* On BeOS, this would crash and show a dialog box.  Avoid the crash.  */
  return 1;
#endif
  if (sprintf (buf, "%.4000d %d", 1, 33, 44) < 4000 + 3)
    result |= 1;
  if (sprintf (buf, "%.4000f %d", 1.0, 33, 44) < 4000 + 5)
    result |= 2;
  if (sprintf (buf, "%.511f %d", 1.0, 33, 44) < 511 + 5
      || buf[0] != '1')
    result |= 4;
  if (sprintf (buf, "%.999f %d", 1.0, 33, 44) < 999 + 5
      || buf[0] != '1')
    result |= 4;
  return result;
}]])],
        [gl_cv_func_printf_precision=yes],
        [gl_cv_func_printf_precision=no],
        [
changequote(,)dnl
         case "$host_os" in
           # Guess no only on Solaris, native Windows, and BeOS systems.
           solaris*)     gl_cv_func_printf_precision="guessing no" ;;
           mingw* | pw*) gl_cv_func_printf_precision="guessing no" ;;
           beos*)        gl_cv_func_printf_precision="guessing no" ;;
           *)            gl_cv_func_printf_precision="guessing yes" ;;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the *printf family of functions recovers gracefully in case
dnl of an out-of-memory condition, or whether it crashes the entire program.
dnl Result is gl_cv_func_printf_enomem.

AC_DEFUN([gl_PRINTF_ENOMEM],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([gl_MULTIARCH])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether printf survives out-of-memory conditions],
    [gl_cv_func_printf_enomem],
    [
      gl_cv_func_printf_enomem="guessing no"
      if test "$cross_compiling" = no; then
        if test $APPLE_UNIVERSAL_BUILD = 0; then
          AC_LANG_CONFTEST([AC_LANG_SOURCE([
]GL_NOCRASH[
changequote(,)dnl
#include <stdio.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <errno.h>
int main()
{
  struct rlimit limit;
  int ret;
  nocrash_init ();
  /* Some printf implementations allocate temporary space with malloc.  */
  /* On BSD systems, malloc() is limited by RLIMIT_DATA.  */
#ifdef RLIMIT_DATA
  if (getrlimit (RLIMIT_DATA, &limit) < 0)
    return 77;
  if (limit.rlim_max == RLIM_INFINITY || limit.rlim_max > 5000000)
    limit.rlim_max = 5000000;
  limit.rlim_cur = limit.rlim_max;
  if (setrlimit (RLIMIT_DATA, &limit) < 0)
    return 77;
#endif
  /* On Linux systems, malloc() is limited by RLIMIT_AS.  */
#ifdef RLIMIT_AS
  if (getrlimit (RLIMIT_AS, &limit) < 0)
    return 77;
  if (limit.rlim_max == RLIM_INFINITY || limit.rlim_max > 5000000)
    limit.rlim_max = 5000000;
  limit.rlim_cur = limit.rlim_max;
  if (setrlimit (RLIMIT_AS, &limit) < 0)
    return 77;
#endif
  /* Some printf implementations allocate temporary space on the stack.  */
#ifdef RLIMIT_STACK
  if (getrlimit (RLIMIT_STACK, &limit) < 0)
    return 77;
  if (limit.rlim_max == RLIM_INFINITY || limit.rlim_max > 5000000)
    limit.rlim_max = 5000000;
  limit.rlim_cur = limit.rlim_max;
  if (setrlimit (RLIMIT_STACK, &limit) < 0)
    return 77;
#endif
  ret = printf ("%.5000000f", 1.0);
  return !(ret == 5000002 || (ret < 0 && errno == ENOMEM));
}
changequote([,])dnl
          ])])
          if AC_TRY_EVAL([ac_link]) && test -s conftest$ac_exeext; then
            (./conftest 2>&AS_MESSAGE_LOG_FD
             result=$?
             _AS_ECHO_LOG([\$? = $result])
             if test $result != 0 && test $result != 77; then result=1; fi
             exit $result
            ) >/dev/null 2>/dev/null
            case $? in
              0) gl_cv_func_printf_enomem="yes" ;;
              77) gl_cv_func_printf_enomem="guessing no" ;;
              *) gl_cv_func_printf_enomem="no" ;;
            esac
          else
            gl_cv_func_printf_enomem="guessing no"
          fi
          rm -fr conftest*
        else
          dnl A universal build on Apple Mac OS X platforms.
          dnl The result would be 'no' in 32-bit mode and 'yes' in 64-bit mode.
          dnl But we need a configuration result that is valid in both modes.
          gl_cv_func_printf_enomem="guessing no"
        fi
      fi
      if test "$gl_cv_func_printf_enomem" = "guessing no"; then
changequote(,)dnl
        case "$host_os" in
                         # Guess yes on glibc systems.
          *-gnu* | gnu*) gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on Solaris.
          solaris*)      gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on AIX.
          aix*)          gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on HP-UX/hppa.
          hpux*)         case "$host_cpu" in
                           hppa*) gl_cv_func_printf_enomem="guessing yes";;
                           *)     gl_cv_func_printf_enomem="guessing no";;
                         esac
                         ;;
                         # Guess yes on IRIX.
          irix*)         gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on OSF/1.
          osf*)          gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on BeOS.
          beos*)         gl_cv_func_printf_enomem="guessing yes";;
                         # Guess yes on Haiku.
          haiku*)        gl_cv_func_printf_enomem="guessing yes";;
                         # If we don't know, assume the worst.
          *)             gl_cv_func_printf_enomem="guessing no";;
        esac
changequote([,])dnl
      fi
    ])
])

dnl Test whether the snprintf function exists. (ISO C99, POSIX:2001)
dnl Result is ac_cv_func_snprintf.

AC_DEFUN([gl_SNPRINTF_PRESENCE],
[
  AC_CHECK_FUNCS_ONCE([snprintf])
])

dnl Test whether the string produced by the snprintf function is always NUL
dnl terminated. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_snprintf_truncation_c99.

AC_DEFUN([gl_SNPRINTF_TRUNCATION_C99],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([gl_SNPRINTF_PRESENCE])
  AC_CACHE_CHECK([whether snprintf truncates the result as in C99],
    [gl_cv_func_snprintf_truncation_c99],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
#if HAVE_SNPRINTF
# define my_snprintf snprintf
#else
# include <stdarg.h>
static int my_snprintf (char *buf, int size, const char *format, ...)
{
  va_list args;
  int ret;
  va_start (args, format);
  ret = vsnprintf (buf, size, format, args);
  va_end (args);
  return ret;
}
#endif
static char buf[100];
int main ()
{
  strcpy (buf, "ABCDEF");
  my_snprintf (buf, 3, "%d %d", 4567, 89);
  if (memcmp (buf, "45\0DEF", 6) != 0)
    return 1;
  return 0;
}]])],
        [gl_cv_func_snprintf_truncation_c99=yes],
        [gl_cv_func_snprintf_truncation_c99=no],
        [
changequote(,)dnl
         case "$host_os" in
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on FreeBSD >= 5.
           freebsd[1-4].*)       gl_cv_func_snprintf_truncation_c99="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_snprintf_truncation_c99="guessing no";;
           darwin*)              gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on OpenBSD >= 3.9.
           openbsd[1-2].* | openbsd3.[0-8] | openbsd3.[0-8].*)
                                 gl_cv_func_snprintf_truncation_c99="guessing no";;
           openbsd*)             gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on Solaris >= 2.6.
           solaris2.[0-5] | solaris2.[0-5].*)
                                 gl_cv_func_snprintf_truncation_c99="guessing no";;
           solaris*)             gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on AIX >= 4.
           aix[1-3]*)            gl_cv_func_snprintf_truncation_c99="guessing no";;
           aix*)                 gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on HP-UX >= 11.
           hpux[7-9]* | hpux10*) gl_cv_func_snprintf_truncation_c99="guessing no";;
           hpux*)                gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on IRIX >= 6.5.
           irix6.5)              gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on OSF/1 >= 5.
           osf[3-4]*)            gl_cv_func_snprintf_truncation_c99="guessing no";;
           osf*)                 gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_snprintf_truncation_c99="guessing no";;
           netbsd*)              gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess yes on BeOS.
           beos*)                gl_cv_func_snprintf_truncation_c99="guessing yes";;
                                 # Guess no on native Windows.
           mingw*)               gl_cv_func_snprintf_truncation_c99="guessing no";;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_snprintf_truncation_c99="guessing no";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the return value of the snprintf function is the number
dnl of bytes (excluding the terminating NUL) that would have been produced
dnl if the buffer had been large enough. (ISO C99, POSIX:2001)
dnl For example, this test program fails on IRIX 6.5:
dnl     ---------------------------------------------------------------------
dnl     #include <stdio.h>
dnl     int main()
dnl     {
dnl       static char buf[8];
dnl       int retval = snprintf (buf, 3, "%d", 12345);
dnl       return retval >= 0 && retval < 3;
dnl     }
dnl     ---------------------------------------------------------------------
dnl Result is gl_cv_func_snprintf_retval_c99.

AC_DEFUN_ONCE([gl_SNPRINTF_RETVAL_C99],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([gl_SNPRINTF_PRESENCE])
  AC_CACHE_CHECK([whether snprintf returns a byte count as in C99],
    [gl_cv_func_snprintf_retval_c99],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
#if HAVE_SNPRINTF
# define my_snprintf snprintf
#else
# include <stdarg.h>
static int my_snprintf (char *buf, int size, const char *format, ...)
{
  va_list args;
  int ret;
  va_start (args, format);
  ret = vsnprintf (buf, size, format, args);
  va_end (args);
  return ret;
}
#endif
static char buf[100];
int main ()
{
  strcpy (buf, "ABCDEF");
  if (my_snprintf (buf, 3, "%d %d", 4567, 89) != 7)
    return 1;
  if (my_snprintf (buf, 0, "%d %d", 4567, 89) != 7)
    return 2;
  if (my_snprintf (NULL, 0, "%d %d", 4567, 89) != 7)
    return 3;
  return 0;
}]])],
        [gl_cv_func_snprintf_retval_c99=yes],
        [gl_cv_func_snprintf_retval_c99=no],
        [case "$host_os" in
changequote(,)dnl
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on FreeBSD >= 5.
           freebsd[1-4].*)       gl_cv_func_snprintf_retval_c99="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_snprintf_retval_c99="guessing no";;
           darwin*)              gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on OpenBSD >= 3.9.
           openbsd[1-2].* | openbsd3.[0-8] | openbsd3.[0-8].*)
                                 gl_cv_func_snprintf_retval_c99="guessing no";;
           openbsd*)             gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on Solaris >= 2.10.
           solaris2.[1-9][0-9]*) gl_cv_func_printf_sizes_c99="guessing yes";;
           solaris*)             gl_cv_func_printf_sizes_c99="guessing no";;
                                 # Guess yes on AIX >= 4.
           aix[1-3]*)            gl_cv_func_snprintf_retval_c99="guessing no";;
           aix*)                 gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_snprintf_retval_c99="guessing no";;
           netbsd*)              gl_cv_func_snprintf_retval_c99="guessing yes";;
                                 # Guess yes on BeOS.
           beos*)                gl_cv_func_snprintf_retval_c99="guessing yes";;
changequote([,])dnl
                                 # Guess yes on MSVC, no on mingw.
           mingw*)               AC_EGREP_CPP([Known], [
#ifdef _MSC_VER
 Known
#endif
                                   ],
                                   [gl_cv_func_snprintf_retval_c99="guessing yes"],
                                   [gl_cv_func_snprintf_retval_c99="guessing no"])
                                 ;;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_snprintf_retval_c99="guessing no";;
         esac
        ])
    ])
])

dnl Test whether the snprintf function supports the %n format directive
dnl also in truncated portions of the format string. (ISO C99, POSIX:2001)
dnl Result is gl_cv_func_snprintf_directive_n.

AC_DEFUN([gl_SNPRINTF_DIRECTIVE_N],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([gl_SNPRINTF_PRESENCE])
  AC_CACHE_CHECK([whether snprintf fully supports the 'n' directive],
    [gl_cv_func_snprintf_directive_n],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#include <string.h>
#if HAVE_SNPRINTF
# define my_snprintf snprintf
#else
# include <stdarg.h>
static int my_snprintf (char *buf, int size, const char *format, ...)
{
  va_list args;
  int ret;
  va_start (args, format);
  ret = vsnprintf (buf, size, format, args);
  va_end (args);
  return ret;
}
#endif
static char fmtstring[10];
static char buf[100];
int main ()
{
  int count = -1;
  /* Copy the format string.  Some systems (glibc with _FORTIFY_SOURCE=2)
     support %n in format strings in read-only memory but not in writable
     memory.  */
  strcpy (fmtstring, "%d %n");
  my_snprintf (buf, 4, fmtstring, 12345, &count, 33, 44, 55);
  if (count != 6)
    return 1;
  return 0;
}]])],
        [gl_cv_func_snprintf_directive_n=yes],
        [gl_cv_func_snprintf_directive_n=no],
        [
changequote(,)dnl
         case "$host_os" in
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on FreeBSD >= 5.
           freebsd[1-4].*)       gl_cv_func_snprintf_directive_n="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_snprintf_directive_n="guessing no";;
           darwin*)              gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on Solaris >= 2.6.
           solaris2.[0-5] | solaris2.[0-5].*)
                                 gl_cv_func_snprintf_directive_n="guessing no";;
           solaris*)             gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on AIX >= 4.
           aix[1-3]*)            gl_cv_func_snprintf_directive_n="guessing no";;
           aix*)                 gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on IRIX >= 6.5.
           irix6.5)              gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on OSF/1 >= 5.
           osf[3-4]*)            gl_cv_func_snprintf_directive_n="guessing no";;
           osf*)                 gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_snprintf_directive_n="guessing no";;
           netbsd*)              gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess yes on BeOS.
           beos*)                gl_cv_func_snprintf_directive_n="guessing yes";;
                                 # Guess no on native Windows.
           mingw*)               gl_cv_func_snprintf_directive_n="guessing no";;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_snprintf_directive_n="guessing no";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl Test whether the snprintf function, when passed a size = 1, writes any
dnl output without bounds in this case, behaving like sprintf. This is the
dnl case on Linux libc5.
dnl Result is gl_cv_func_snprintf_size1.

AC_DEFUN([gl_SNPRINTF_SIZE1],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([gl_SNPRINTF_PRESENCE])
  AC_CACHE_CHECK([whether snprintf respects a size of 1],
    [gl_cv_func_snprintf_size1],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdio.h>
#if HAVE_SNPRINTF
# define my_snprintf snprintf
#else
# include <stdarg.h>
static int my_snprintf (char *buf, int size, const char *format, ...)
{
  va_list args;
  int ret;
  va_start (args, format);
  ret = vsnprintf (buf, size, format, args);
  va_end (args);
  return ret;
}
#endif
int main()
{
  static char buf[8] = { 'D', 'E', 'A', 'D', 'B', 'E', 'E', 'F' };
  my_snprintf (buf, 1, "%d", 12345);
  return buf[1] != 'E';
}]])],
        [gl_cv_func_snprintf_size1=yes],
        [gl_cv_func_snprintf_size1=no],
        [case "$host_os" in
                   # Guess yes on native Windows.
           mingw*) gl_cv_func_snprintf_size1="guessing yes" ;;
           *)      gl_cv_func_snprintf_size1="guessing yes" ;;
         esac
        ])
    ])
])

dnl Test whether the vsnprintf function, when passed a zero size, produces no
dnl output. (ISO C99, POSIX:2001)
dnl For example, snprintf nevertheless writes a NUL byte in this case
dnl on OSF/1 5.1:
dnl     ---------------------------------------------------------------------
dnl     #include <stdio.h>
dnl     int main()
dnl     {
dnl       static char buf[8] = { 'D', 'E', 'A', 'D', 'B', 'E', 'E', 'F' };
dnl       snprintf (buf, 0, "%d", 12345);
dnl       return buf[0] != 'D';
dnl     }
dnl     ---------------------------------------------------------------------
dnl And vsnprintf writes any output without bounds in this case, behaving like
dnl vsprintf, on HP-UX 11 and OSF/1 5.1:
dnl     ---------------------------------------------------------------------
dnl     #include <stdarg.h>
dnl     #include <stdio.h>
dnl     static int my_snprintf (char *buf, int size, const char *format, ...)
dnl     {
dnl       va_list args;
dnl       int ret;
dnl       va_start (args, format);
dnl       ret = vsnprintf (buf, size, format, args);
dnl       va_end (args);
dnl       return ret;
dnl     }
dnl     int main()
dnl     {
dnl       static char buf[8] = { 'D', 'E', 'A', 'D', 'B', 'E', 'E', 'F' };
dnl       my_snprintf (buf, 0, "%d", 12345);
dnl       return buf[0] != 'D';
dnl     }
dnl     ---------------------------------------------------------------------
dnl Result is gl_cv_func_vsnprintf_zerosize_c99.

AC_DEFUN([gl_VSNPRINTF_ZEROSIZE_C99],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether vsnprintf respects a zero size as in C99],
    [gl_cv_func_vsnprintf_zerosize_c99],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <stdarg.h>
#include <stdio.h>
static int my_snprintf (char *buf, int size, const char *format, ...)
{
  va_list args;
  int ret;
  va_start (args, format);
  ret = vsnprintf (buf, size, format, args);
  va_end (args);
  return ret;
}
int main()
{
  static char buf[8] = { 'D', 'E', 'A', 'D', 'B', 'E', 'E', 'F' };
  my_snprintf (buf, 0, "%d", 12345);
  return buf[0] != 'D';
}]])],
        [gl_cv_func_vsnprintf_zerosize_c99=yes],
        [gl_cv_func_vsnprintf_zerosize_c99=no],
        [
changequote(,)dnl
         case "$host_os" in
                                 # Guess yes on glibc systems.
           *-gnu* | gnu*)        gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on FreeBSD >= 5.
           freebsd[1-4].*)       gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
           freebsd* | kfreebsd*) gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on Mac OS X >= 10.3.
           darwin[1-6].*)        gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
           darwin*)              gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on Cygwin.
           cygwin*)              gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on Solaris >= 2.6.
           solaris2.[0-5] | solaris2.[0-5].*)
                                 gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
           solaris*)             gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on AIX >= 4.
           aix[1-3]*)            gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
           aix*)                 gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on IRIX >= 6.5.
           irix6.5)              gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on NetBSD >= 3.
           netbsd[1-2]* | netbsdelf[1-2]* | netbsdaout[1-2]* | netbsdcoff[1-2]*)
                                 gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
           netbsd*)              gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on BeOS.
           beos*)                gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # Guess yes on native Windows.
           mingw* | pw*)         gl_cv_func_vsnprintf_zerosize_c99="guessing yes";;
                                 # If we don't know, assume the worst.
           *)                    gl_cv_func_vsnprintf_zerosize_c99="guessing no";;
         esac
changequote([,])dnl
        ])
    ])
])

dnl The results of these tests on various platforms are:
dnl
dnl 1 = gl_PRINTF_SIZES_C99
dnl 2 = gl_PRINTF_LONG_DOUBLE
dnl 3 = gl_PRINTF_INFINITE
dnl 4 = gl_PRINTF_INFINITE_LONG_DOUBLE
dnl 5 = gl_PRINTF_DIRECTIVE_A
dnl 6 = gl_PRINTF_DIRECTIVE_F
dnl 7 = gl_PRINTF_DIRECTIVE_N
dnl 8 = gl_PRINTF_DIRECTIVE_LS
dnl 9 = gl_PRINTF_POSITIONS
dnl 10 = gl_PRINTF_FLAG_GROUPING
dnl 11 = gl_PRINTF_FLAG_LEFTADJUST
dnl 12 = gl_PRINTF_FLAG_ZERO
dnl 13 = gl_PRINTF_PRECISION
dnl 14 = gl_PRINTF_ENOMEM
dnl 15 = gl_SNPRINTF_PRESENCE
dnl 16 = gl_SNPRINTF_TRUNCATION_C99
dnl 17 = gl_SNPRINTF_RETVAL_C99
dnl 18 = gl_SNPRINTF_DIRECTIVE_N
dnl 19 = gl_SNPRINTF_SIZE1
dnl 20 = gl_VSNPRINTF_ZEROSIZE_C99
dnl
dnl 1 = checking whether printf supports size specifiers as in C99...
dnl 2 = checking whether printf supports 'long double' arguments...
dnl 3 = checking whether printf supports infinite 'double' arguments...
dnl 4 = checking whether printf supports infinite 'long double' arguments...
dnl 5 = checking whether printf supports the 'a' and 'A' directives...
dnl 6 = checking whether printf supports the 'F' directive...
dnl 7 = checking whether printf supports the 'n' directive...
dnl 8 = checking whether printf supports the 'ls' directive...
dnl 9 = checking whether printf supports POSIX/XSI format strings with positions...
dnl 10 = checking whether printf supports the grouping flag...
dnl 11 = checking whether printf supports the left-adjust flag correctly...
dnl 12 = checking whether printf supports the zero flag correctly...
dnl 13 = checking whether printf supports large precisions...
dnl 14 = checking whether printf survives out-of-memory conditions...
dnl 15 = checking for snprintf...
dnl 16 = checking whether snprintf truncates the result as in C99...
dnl 17 = checking whether snprintf returns a byte count as in C99...
dnl 18 = checking whether snprintf fully supports the 'n' directive...
dnl 19 = checking whether snprintf respects a size of 1...
dnl 20 = checking whether vsnprintf respects a zero size as in C99...
dnl
dnl . = yes, # = no.
dnl
dnl                                  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
dnl   glibc 2.5                      .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
dnl   glibc 2.3.6                    .  .  .  .  #  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
dnl   FreeBSD 5.4, 6.1               .  .  .  .  #  .  .  .  .  .  .  #  .  #  .  .  .  .  .  .
dnl   Mac OS X 10.5.8                .  .  .  #  #  .  .  .  .  .  .  #  .  .  .  .  .  .  .  .
dnl   Mac OS X 10.3.9                .  .  .  .  #  .  .  .  .  .  .  #  .  #  .  .  .  .  .  .
dnl   OpenBSD 3.9, 4.0               .  .  #  #  #  #  .  #  .  #  .  #  .  #  .  .  .  .  .  .
dnl   Cygwin 1.7.0 (2009)            .  .  .  #  .  .  .  ?  .  .  .  .  .  ?  .  .  .  .  .  .
dnl   Cygwin 1.5.25 (2008)           .  .  .  #  #  .  .  #  .  .  .  .  .  #  .  .  .  .  .  .
dnl   Cygwin 1.5.19 (2006)           #  .  .  #  #  #  .  #  .  #  .  #  #  #  .  .  .  .  .  .
dnl   Solaris 11.3                   .  .  .  .  #  .  .  #  .  .  .  .  .  .  .  .  .  .  .  .
dnl   Solaris 11.0                   .  .  #  #  #  .  .  #  .  .  .  #  .  .  .  .  .  .  .  .
dnl   Solaris 10                     .  .  #  #  #  .  .  #  .  .  .  #  #  .  .  .  .  .  .  .
dnl   Solaris 2.6 ... 9              #  .  #  #  #  #  .  #  .  .  .  #  #  .  .  .  #  .  .  .
dnl   Solaris 2.5.1                  #  .  #  #  #  #  .  #  .  .  .  #  .  .  #  #  #  #  #  #
dnl   AIX 7.1                        .  .  #  #  #  .  .  .  .  .  .  #  #  .  .  .  .  .  .  .
dnl   AIX 5.2                        .  .  #  #  #  .  .  .  .  .  .  #  .  .  .  .  .  .  .  .
dnl   AIX 4.3.2, 5.1                 #  .  #  #  #  #  .  .  .  .  .  #  .  .  .  .  #  .  .  .
dnl   HP-UX 11.31                    .  .  .  .  #  .  .  .  .  .  .  #  .  .  .  .  #  #  .  .
dnl   HP-UX 11.{00,11,23}            #  .  .  .  #  #  .  .  .  .  .  #  .  .  .  .  #  #  .  #
dnl   HP-UX 10.20                    #  .  #  .  #  #  .  ?  .  .  #  #  .  .  .  .  #  #  ?  #
dnl   IRIX 6.5                       #  .  #  #  #  #  .  #  .  .  .  #  .  .  .  .  #  .  .  .
dnl   OSF/1 5.1                      #  .  #  #  #  #  .  .  .  .  .  #  .  .  .  .  #  .  .  #
dnl   OSF/1 4.0d                     #  .  #  #  #  #  .  .  .  .  .  #  .  .  #  #  #  #  #  #
dnl   NetBSD 5.0                     .  .  .  #  #  .  .  .  .  .  .  #  .  #  .  .  .  .  .  .
dnl   NetBSD 4.0                     .  ?  ?  ?  ?  ?  .  ?  .  ?  ?  ?  ?  ?  .  .  .  ?  ?  ?
dnl   NetBSD 3.0                     .  .  .  .  #  #  .  ?  #  #  ?  #  .  #  .  .  .  .  .  .
dnl   Haiku                          .  .  .  #  #  #  .  #  .  .  .  .  .  ?  .  .  ?  .  .  .
dnl   BeOS                           #  #  .  #  #  #  .  ?  #  .  ?  .  #  ?  .  .  ?  .  .  .
dnl   old mingw / msvcrt             #  #  #  #  #  #  .  .  #  #  .  #  #  ?  .  #  #  #  .  .
dnl   MSVC 9                         #  #  #  #  #  #  #  .  #  #  .  #  #  ?  #  #  #  #  .  .
dnl   mingw 2009-2011                .  #  .  #  .  .  .  .  #  #  .  .  .  ?  .  .  .  .  .  .
dnl   mingw-w64 2011                 #  #  #  #  #  #  .  .  #  #  .  #  #  ?  .  #  #  #  .  .

# quote.m4 serial 6
dnl Copyright (C) 2002-2003, 2005-2006, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_QUOTE],
[
  dnl Prerequisites of lib/quote.c.
  dnl (none)
  :
])

# quotearg.m4 serial 9
dnl Copyright (C) 2002, 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_QUOTEARG],
[
  :
])

# raise.m4 serial 4
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_RAISE],
[
  AC_REQUIRE([gl_SIGNAL_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS([raise])
  if test $ac_cv_func_raise = no; then
    HAVE_RAISE=0
  else
    m4_ifdef([gl_MSVC_INVAL], [
      AC_REQUIRE([gl_MSVC_INVAL])
      if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
        REPLACE_RAISE=1
      fi
    ])
    m4_ifdef([gl_SIGNALBLOCKING], [
      gl_SIGNALBLOCKING
      if test $HAVE_POSIX_SIGNALBLOCKING = 0; then
        m4_ifdef([gl_SIGNAL_SIGPIPE], [
          gl_SIGNAL_SIGPIPE
          if test $gl_cv_header_signal_h_SIGPIPE != yes; then
            REPLACE_RAISE=1
          fi
        ], [:])
      fi
    ])
  fi
])

# Prerequisites of lib/raise.c.
AC_DEFUN([gl_PREREQ_RAISE], [:])

# readdir.m4 serial 1
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_READDIR],
[
  AC_REQUIRE([gl_DIRENT_H_DEFAULTS])

  AC_CHECK_FUNCS([readdir])
  if test $ac_cv_func_readdir = no; then
    HAVE_READDIR=0
  fi
])

# readlink.m4 serial 13
dnl Copyright (C) 2003, 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_READLINK],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_FUNCS_ONCE([readlink])
  if test $ac_cv_func_readlink = no; then
    HAVE_READLINK=0
  else
    AC_CACHE_CHECK([whether readlink signature is correct],
      [gl_cv_decl_readlink_works],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
      /* Cause compilation failure if original declaration has wrong type.  */
      ssize_t readlink (const char *, char *, size_t);]])],
         [gl_cv_decl_readlink_works=yes], [gl_cv_decl_readlink_works=no])])
    dnl Solaris 9 ignores trailing slash.
    dnl FreeBSD 7.2 dereferences only one level of links with trailing slash.
    AC_CACHE_CHECK([whether readlink handles trailing slash correctly],
      [gl_cv_func_readlink_works],
      [# We have readlink, so assume ln -s works.
       ln -s conftest.no-such conftest.link
       ln -s conftest.link conftest.lnk2
       AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
]], [[char buf[20];
      return readlink ("conftest.lnk2/", buf, sizeof buf) != -1;]])],
         [gl_cv_func_readlink_works=yes], [gl_cv_func_readlink_works=no],
         [case "$host_os" in
                           # Guess yes on glibc systems.
            *-gnu* | gnu*) gl_cv_func_readlink_works="guessing yes" ;;
                           # If we don't know, assume the worst.
            *)             gl_cv_func_readlink_works="guessing no" ;;
          esac
         ])
      rm -f conftest.link conftest.lnk2])
    case "$gl_cv_func_readlink_works" in
      *yes)
        if test "$gl_cv_decl_readlink_works" != yes; then
          REPLACE_READLINK=1
        fi
        ;;
      *)
        AC_DEFINE([READLINK_TRAILING_SLASH_BUG], [1], [Define to 1 if readlink
          fails to recognize a trailing slash.])
        REPLACE_READLINK=1
        ;;
    esac
  fi
])

# Like gl_FUNC_READLINK, except prepare for separate compilation
# (no REPLACE_READLINK, no AC_LIBOBJ).
AC_DEFUN([gl_FUNC_READLINK_SEPARATE],
[
  AC_CHECK_FUNCS_ONCE([readlink])
  gl_PREREQ_READLINK
])

# Prerequisites of lib/readlink.c.
AC_DEFUN([gl_PREREQ_READLINK],
[
  :
])

# serial 5
# See if we need to provide readlinkat replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_READLINKAT],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([readlinkat])
  AC_REQUIRE([gl_FUNC_READLINK])
  if test $ac_cv_func_readlinkat = no; then
    HAVE_READLINKAT=0
  else
    AC_CACHE_CHECK([whether readlinkat signature is correct],
      [gl_cv_decl_readlinkat_works],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
             /* Check whether original declaration has correct type.  */
             ssize_t readlinkat (int, char const *, char *, size_t);]])],
         [gl_cv_decl_readlinkat_works=yes],
         [gl_cv_decl_readlinkat_works=no])])
    # Assume readinkat has the same trailing slash bug as readlink,
    # as is the case on Mac Os X 10.10
    case "$gl_cv_func_readlink_works" in
      *yes)
        if test "$gl_cv_decl_readlinkat_works" != yes; then
          REPLACE_READLINKAT=1
        fi
        ;;
      *)
        REPLACE_READLINKAT=1
        ;;
    esac
  fi
])

# realloc.m4 serial 15
dnl Copyright (C) 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

m4_version_prereq([2.70], [] ,[

# This is adapted with modifications from upstream Autoconf here:
# https://git.savannah.gnu.org/cgit/autoconf.git/commit/?id=04be2b7a29d65d9a08e64e8e56e594c91749598c
AC_DEFUN([_AC_FUNC_REALLOC_IF],
[
  AC_REQUIRE([AC_HEADER_STDC])dnl
  AC_REQUIRE([AC_CANONICAL_HOST])dnl for cross-compiles
  AC_CHECK_HEADERS([stdlib.h])
  AC_CACHE_CHECK([for GNU libc compatible realloc],
    [ac_cv_func_realloc_0_nonnull],
    [AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
          [[#if defined STDC_HEADERS || defined HAVE_STDLIB_H
            # include <stdlib.h>
            #else
            char *realloc ();
            #endif
          ]],
          [[char *p = realloc (0, 0);
            int result = !p;
            free (p);
            return result;]])
       ],
       [ac_cv_func_realloc_0_nonnull=yes],
       [ac_cv_func_realloc_0_nonnull=no],
       [case "$host_os" in
          # Guess yes on platforms where we know the result.
          *-gnu* | gnu* | freebsd* | netbsd* | openbsd* \
          | hpux* | solaris* | cygwin* | mingw*)
            ac_cv_func_realloc_0_nonnull=yes ;;
          # If we don't know, assume the worst.
          *) ac_cv_func_realloc_0_nonnull=no ;;
        esac
       ])
    ])
  AS_IF([test $ac_cv_func_realloc_0_nonnull = yes], [$1], [$2])
])# AC_FUNC_REALLOC

])

# gl_FUNC_REALLOC_GNU
# -------------------
# Test whether 'realloc (0, 0)' is handled like in GNU libc, and replace
# realloc if it is not.
AC_DEFUN([gl_FUNC_REALLOC_GNU],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  dnl _AC_FUNC_REALLOC_IF is defined in Autoconf.
  _AC_FUNC_REALLOC_IF(
    [AC_DEFINE([HAVE_REALLOC_GNU], [1],
               [Define to 1 if your system has a GNU libc compatible 'realloc'
                function, and to 0 otherwise.])],
    [AC_DEFINE([HAVE_REALLOC_GNU], [0])
     REPLACE_REALLOC=1
    ])
])# gl_FUNC_REALLOC_GNU

# gl_FUNC_REALLOC_POSIX
# ---------------------
# Test whether 'realloc' is POSIX compliant (sets errno to ENOMEM when it
# fails), and replace realloc if it is not.
AC_DEFUN([gl_FUNC_REALLOC_POSIX],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  AC_REQUIRE([gl_CHECK_MALLOC_POSIX])
  if test $gl_cv_func_malloc_posix = yes; then
    AC_DEFINE([HAVE_REALLOC_POSIX], [1],
      [Define if the 'realloc' function is POSIX compliant.])
  else
    REPLACE_REALLOC=1
  fi
])

# serial 29

# Copyright (C) 2001, 2003, 2005-2006, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Volker Borchert.
dnl Determine whether rename works for source file names with a trailing slash.
dnl The rename from SunOS 4.1.1_U1 doesn't.
dnl
dnl If it doesn't, then define RENAME_TRAILING_SLASH_BUG and arrange
dnl to compile the wrapper function.
dnl

AC_DEFUN([gl_FUNC_RENAME],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_STDIO_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([lstat])

  dnl Solaris 11, AIX 7.1 mistakenly allow rename("file","name/").
  dnl NetBSD 1.6 mistakenly forbids rename("dir","name/").
  dnl FreeBSD 7.2 mistakenly allows rename("file","link-to-file/").
  dnl The Solaris bug can be worked around without stripping
  dnl trailing slash, while the NetBSD bug requires stripping;
  dnl the two conditions can be distinguished by whether hard
  dnl links are also broken.
  AC_CACHE_CHECK([whether rename honors trailing slash on destination],
    [gl_cv_func_rename_slash_dst_works],
    [rm -rf conftest.f conftest.f1 conftest.f2 conftest.d1 conftest.d2 conftest.lnk
    touch conftest.f && touch conftest.f1 && mkdir conftest.d1 ||
      AC_MSG_ERROR([cannot create temporary files])
    # Assume that if we have lstat, we can also check symlinks.
    if test $ac_cv_func_lstat = yes; then
      ln -s conftest.f conftest.lnk
    fi
    AC_RUN_IFELSE(
      [AC_LANG_PROGRAM([[
#        include <stdio.h>
#        include <stdlib.h>
         ]],
         [[int result = 0;
           if (rename ("conftest.f1", "conftest.f2/") == 0)
             result |= 1;
           if (rename ("conftest.d1", "conftest.d2/") != 0)
             result |= 2;
#if HAVE_LSTAT
           if (rename ("conftest.f", "conftest.lnk/") == 0)
             result |= 4;
#endif
           return result;
         ]])],
      [gl_cv_func_rename_slash_dst_works=yes],
      [gl_cv_func_rename_slash_dst_works=no],
      dnl When crosscompiling, assume rename is broken.
      [case "$host_os" in
                 # Guess yes on glibc systems.
         *-gnu*) gl_cv_func_rename_slash_dst_works="guessing yes" ;;
                 # Guess no on native Windows.
         mingw*) gl_cv_func_rename_slash_dst_works="guessing no" ;;
                 # If we don't know, assume the worst.
         *)      gl_cv_func_rename_slash_dst_works="guessing no" ;;
       esac
      ])
    rm -rf conftest.f conftest.f1 conftest.f2 conftest.d1 conftest.d2 conftest.lnk
  ])
  case "$gl_cv_func_rename_slash_dst_works" in
    *yes) ;;
    *)
      REPLACE_RENAME=1
      AC_DEFINE([RENAME_TRAILING_SLASH_DEST_BUG], [1],
        [Define if rename does not correctly handle slashes on the destination
         argument, such as on Solaris 11 or NetBSD 1.6.])
      ;;
  esac

  dnl SunOS 4.1.1_U1 mistakenly forbids rename("dir/","name").
  dnl Solaris 9 mistakenly allows rename("file/","name").
  dnl FreeBSD 7.2 mistakenly allows rename("link-to-file/","name").
  dnl These bugs require stripping trailing slash to avoid corrupting
  dnl symlinks with a trailing slash.
  AC_CACHE_CHECK([whether rename honors trailing slash on source],
    [gl_cv_func_rename_slash_src_works],
    [rm -rf conftest.f conftest.f1 conftest.d1 conftest.d2 conftest.d3 conftest.lnk
    touch conftest.f && touch conftest.f1 && mkdir conftest.d1 ||
      AC_MSG_ERROR([cannot create temporary files])
    # Assume that if we have lstat, we can also check symlinks.
    if test $ac_cv_func_lstat = yes; then
      ln -s conftest.f conftest.lnk
    fi
    AC_RUN_IFELSE(
      [AC_LANG_PROGRAM([[
#        include <stdio.h>
#        include <stdlib.h>
         ]],
         [[int result = 0;
           if (rename ("conftest.f1/", "conftest.d3") == 0)
             result |= 1;
           if (rename ("conftest.d1/", "conftest.d2") != 0)
             result |= 2;
#if HAVE_LSTAT
           if (rename ("conftest.lnk/", "conftest.f") == 0)
             result |= 4;
#endif
           return result;
         ]])],
      [gl_cv_func_rename_slash_src_works=yes],
      [gl_cv_func_rename_slash_src_works=no],
      dnl When crosscompiling, assume rename is broken.
      [case "$host_os" in
                 # Guess yes on glibc systems.
         *-gnu*) gl_cv_func_rename_slash_src_works="guessing yes" ;;
                 # Guess yes on native Windows.
         mingw*) gl_cv_func_rename_slash_src_works="guessing yes" ;;
                 # If we don't know, assume the worst.
         *)      gl_cv_func_rename_slash_src_works="guessing no" ;;
       esac
      ])
    rm -rf conftest.f conftest.f1 conftest.d1 conftest.d2 conftest.d3 conftest.lnk
  ])
  case "$gl_cv_func_rename_slash_src_works" in
    *yes) ;;
    *)
      REPLACE_RENAME=1
      AC_DEFINE([RENAME_TRAILING_SLASH_SOURCE_BUG], [1],
        [Define if rename does not correctly handle slashes on the source
         argument, such as on Solaris 9 or cygwin 1.5.])
      ;;
  esac

  dnl NetBSD 1.6 and cygwin 1.5.x mistakenly reduce hard link count
  dnl on rename("h1","h2").
  dnl This bug requires stat'ting targets prior to attempting rename.
  AC_CHECK_FUNCS_ONCE([link])
  AC_CACHE_CHECK([whether rename manages hard links correctly],
    [gl_cv_func_rename_link_works],
    [if test $ac_cv_func_link = yes; then
       rm -rf conftest.f conftest.f1 conftest.f2
       if touch conftest.f conftest.f2 && ln conftest.f conftest.f1 &&
           set x `ls -i conftest.f conftest.f1` && test "$2" = "$4"; then
         AC_RUN_IFELSE(
           [AC_LANG_PROGRAM([[
#             include <errno.h>
#             include <stdio.h>
#             include <stdlib.h>
#             include <unistd.h>
              ]],
              [[int result = 0;
                if (rename ("conftest.f", "conftest.f1"))
                  result |= 1;
                if (unlink ("conftest.f1"))
                  result |= 2;

                /* Allow either the POSIX-required behavior, where the
                   previous rename kept conftest.f, or the (better) NetBSD
                   behavior, where it removed conftest.f.  */
                if (rename ("conftest.f", "conftest.f") != 0
                    && errno != ENOENT)
                  result |= 4;

                if (rename ("conftest.f1", "conftest.f1") == 0)
                  result |= 8;
                if (rename ("conftest.f2", "conftest.f2") != 0)
                  result |= 16;
                return result;
              ]])],
           [gl_cv_func_rename_link_works=yes],
           [gl_cv_func_rename_link_works=no],
           dnl When crosscompiling, assume rename is broken.
           [case "$host_os" in
                      # Guess yes on glibc systems.
              *-gnu*) gl_cv_func_rename_link_works="guessing yes" ;;
                      # Guess yes on native Windows.
              mingw*) gl_cv_func_rename_link_works="guessing yes" ;;
                      # If we don't know, assume the worst.
              *)      gl_cv_func_rename_link_works="guessing no" ;;
            esac
           ])
       else
         gl_cv_func_rename_link_works="guessing no"
       fi
       rm -rf conftest.f conftest.f1 conftest.f2
     else
       gl_cv_func_rename_link_works=yes
     fi
    ])
  case "$gl_cv_func_rename_link_works" in
    *yes) ;;
    *)
      REPLACE_RENAME=1
      AC_DEFINE([RENAME_HARD_LINK_BUG], [1],
        [Define if rename fails to leave hard links alone, as on NetBSD 1.6
         or Cygwin 1.5.])
      ;;
  esac

  dnl Cygwin 1.5.x mistakenly allows rename("dir","file").
  dnl mingw mistakenly forbids rename("dir1","dir2").
  dnl These bugs require stripping trailing slash to avoid corrupting
  dnl symlinks with a trailing slash.
  AC_CACHE_CHECK([whether rename manages existing destinations correctly],
    [gl_cv_func_rename_dest_works],
    [rm -rf conftest.f conftest.d1 conftest.d2
    touch conftest.f && mkdir conftest.d1 conftest.d2 ||
      AC_MSG_ERROR([cannot create temporary files])
    AC_RUN_IFELSE(
      [AC_LANG_PROGRAM([[
#        include <stdio.h>
#        include <stdlib.h>
         ]],
         [[int result = 0;
           if (rename ("conftest.d1", "conftest.d2") != 0)
             result |= 1;
           if (rename ("conftest.d2", "conftest.f") == 0)
             result |= 2;
           return result;
         ]])],
      [gl_cv_func_rename_dest_works=yes],
      [gl_cv_func_rename_dest_works=no],
      dnl When crosscompiling, assume rename is broken.
      [case "$host_os" in
                 # Guess yes on glibc systems.
         *-gnu*) gl_cv_func_rename_dest_works="guessing yes" ;;
                 # Guess no on native Windows.
         mingw*) gl_cv_func_rename_dest_works="guessing no" ;;
                 # If we don't know, assume the worst.
         *)      gl_cv_func_rename_dest_works="guessing no" ;;
       esac
      ])
    rm -rf conftest.f conftest.d1 conftest.d2
  ])
  case "$gl_cv_func_rename_dest_works" in
    *yes) ;;
    *)
      REPLACE_RENAME=1
      AC_DEFINE([RENAME_DEST_EXISTS_BUG], [1],
        [Define if rename does not work when the destination file exists,
         as on Cygwin 1.5 or Windows.])
      ;;
  esac
])

# serial 3
# See if we need to provide renameat replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_RENAMEAT],
[
  AC_REQUIRE([gl_FUNC_OPENAT])
  AC_REQUIRE([gl_FUNC_RENAME])
  AC_REQUIRE([gl_STDIO_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_HEADERS([linux/fs.h])
  AC_CHECK_FUNCS_ONCE([renameat])
  if test $ac_cv_func_renameat = no; then
    HAVE_RENAMEAT=0
  elif test $REPLACE_RENAME = 1; then
    dnl Solaris 9 and 10 have the same bugs in renameat as in rename.
    REPLACE_RENAMEAT=1
  fi
])

# rmdir.m4 serial 15
dnl Copyright (C) 2002, 2005, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_RMDIR],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  dnl Detect cygwin 1.5.x bug.
  AC_CHECK_HEADERS_ONCE([unistd.h])
  AC_CACHE_CHECK([whether rmdir works], [gl_cv_func_rmdir_works],
    [mkdir conftest.dir
     touch conftest.file
     AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
         [[#include <stdio.h>
           #include <errno.h>
           #if HAVE_UNISTD_H
           # include <unistd.h>
           #else /* on Windows with MSVC */
           # include <direct.h>
           #endif
]], [[int result = 0;
      if (!rmdir ("conftest.file/"))
        result |= 1;
      else if (errno != ENOTDIR)
        result |= 2;
      if (!rmdir ("conftest.dir/./"))
        result |= 4;
      return result;
    ]])],
       [gl_cv_func_rmdir_works=yes], [gl_cv_func_rmdir_works=no],
       [case "$host_os" in
                         # Guess yes on glibc systems.
          *-gnu* | gnu*) gl_cv_func_rmdir_works="guessing yes" ;;
                         # Guess no on native Windows.
          mingw*)        gl_cv_func_rmdir_works="guessing no" ;;
                         # If we don't know, assume the worst.
          *)             gl_cv_func_rmdir_works="guessing no" ;;
        esac
       ])
     rm -rf conftest.dir conftest.file])
  case "$gl_cv_func_rmdir_works" in
    *yes) ;;
    *)
      REPLACE_RMDIR=1
      ;;
  esac
])

# safe-read.m4 serial 6
dnl Copyright (C) 2002-2003, 2005-2006, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Prerequisites of lib/safe-read.c.
AC_DEFUN([gl_PREREQ_SAFE_READ],
[
  AC_REQUIRE([gt_TYPE_SSIZE_T])
])

# safe-write.m4 serial 4
dnl Copyright (C) 2002, 2005-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Prerequisites of lib/safe-write.c.
AC_DEFUN([gl_PREREQ_SAFE_WRITE],
[
  gl_PREREQ_SAFE_READ
])

# serial 10
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Prerequisites for lib/save-cwd.c.
AC_DEFUN([gl_SAVE_CWD],
[
  AC_CHECK_FUNCS_ONCE([fchdir])
])

# setenv.m4 serial 27
dnl Copyright (C) 2001-2004, 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_SETENV],
[
  AC_REQUIRE([gl_FUNC_SETENV_SEPARATE])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  if test $ac_cv_func_setenv = no; then
    HAVE_SETENV=0
  else
    AC_CACHE_CHECK([whether setenv validates arguments],
      [gl_cv_func_setenv_works],
      [AC_RUN_IFELSE([AC_LANG_PROGRAM([[
       #include <stdlib.h>
       #include <errno.h>
       #include <string.h>
      ]], [[
       int result = 0;
       {
         if (setenv ("", "", 0) != -1)
           result |= 1;
         else if (errno != EINVAL)
           result |= 2;
       }
       {
         if (setenv ("a", "=", 1) != 0)
           result |= 4;
         else if (strcmp (getenv ("a"), "=") != 0)
           result |= 8;
       }
       return result;
      ]])],
      [gl_cv_func_setenv_works=yes], [gl_cv_func_setenv_works=no],
      [case "$host_os" in
                        # Guess yes on glibc systems.
         *-gnu* | gnu*) gl_cv_func_setenv_works="guessing yes" ;;
                        # If we don't know, assume the worst.
         *)             gl_cv_func_setenv_works="guessing no" ;;
       esac
      ])])
    case "$gl_cv_func_setenv_works" in
      *yes) ;;
      *)
        REPLACE_SETENV=1
        ;;
    esac
  fi
])

# Like gl_FUNC_SETENV, except prepare for separate compilation
# (no REPLACE_SETENV, no AC_LIBOBJ).
AC_DEFUN([gl_FUNC_SETENV_SEPARATE],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  AC_CHECK_DECLS_ONCE([setenv])
  if test $ac_cv_have_decl_setenv = no; then
    HAVE_DECL_SETENV=0
  fi
  AC_CHECK_FUNCS_ONCE([setenv])
  gl_PREREQ_SETENV
])

AC_DEFUN([gl_FUNC_UNSETENV],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_DECLS_ONCE([unsetenv])
  if test $ac_cv_have_decl_unsetenv = no; then
    HAVE_DECL_UNSETENV=0
  fi
  AC_CHECK_FUNCS([unsetenv])
  if test $ac_cv_func_unsetenv = no; then
    HAVE_UNSETENV=0
  else
    HAVE_UNSETENV=1
    dnl Some BSDs return void, failing to do error checking.
    AC_CACHE_CHECK([for unsetenv() return type], [gt_cv_func_unsetenv_ret],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
            [[
#undef _BSD
#define _BSD 1 /* unhide unsetenv declaration in OSF/1 5.1 <stdlib.h> */
#include <stdlib.h>
extern
#ifdef __cplusplus
"C"
#endif
int unsetenv (const char *name);
            ]],
            [[]])],
         [gt_cv_func_unsetenv_ret='int'],
         [gt_cv_func_unsetenv_ret='void'])])
    if test $gt_cv_func_unsetenv_ret = 'void'; then
      AC_DEFINE([VOID_UNSETENV], [1], [Define to 1 if unsetenv returns void
       instead of int.])
      REPLACE_UNSETENV=1
    fi

    dnl Solaris 10 unsetenv does not remove all copies of a name.
    dnl Haiku alpha 2 unsetenv gets confused by assignment to environ.
    dnl OpenBSD 4.7 unsetenv("") does not fail.
    AC_CACHE_CHECK([whether unsetenv obeys POSIX],
      [gl_cv_func_unsetenv_works],
      [AC_RUN_IFELSE([AC_LANG_PROGRAM([[
       #include <stdlib.h>
       #include <errno.h>
       extern char **environ;
      ]], [[
       char entry1[] = "a=1";
       char entry2[] = "b=2";
       char *env[] = { entry1, entry2, NULL };
       if (putenv ((char *) "a=1")) return 1;
       if (putenv (entry2)) return 2;
       entry2[0] = 'a';
       unsetenv ("a");
       if (getenv ("a")) return 3;
       if (!unsetenv ("") || errno != EINVAL) return 4;
       entry2[0] = 'b';
       environ = env;
       if (!getenv ("a")) return 5;
       entry2[0] = 'a';
       unsetenv ("a");
       if (getenv ("a")) return 6;
      ]])],
      [gl_cv_func_unsetenv_works=yes], [gl_cv_func_unsetenv_works=no],
      [case "$host_os" in
                 # Guess yes on glibc systems.
         *-gnu*) gl_cv_func_unsetenv_works="guessing yes" ;;
                 # If we don't know, assume the worst.
         *)      gl_cv_func_unsetenv_works="guessing no" ;;
       esac
      ])])
    case "$gl_cv_func_unsetenv_works" in
      *yes) ;;
      *)
        REPLACE_UNSETENV=1
        ;;
    esac
  fi
])

# Prerequisites of lib/setenv.c.
AC_DEFUN([gl_PREREQ_SETENV],
[
  AC_REQUIRE([AC_FUNC_ALLOCA])
  AC_REQUIRE([gl_ENVIRON])
  AC_CHECK_HEADERS_ONCE([unistd.h])
  AC_CHECK_HEADERS([search.h])
  AC_CHECK_FUNCS([tsearch])
])

# Prerequisites of lib/unsetenv.c.
AC_DEFUN([gl_PREREQ_UNSETENV],
[
  AC_REQUIRE([gl_ENVIRON])
  AC_CHECK_HEADERS_ONCE([unistd.h])
])

# Check for setmode, DOS style.

# Copyright (C) 2001-2002, 2011-2012 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.

AC_DEFUN([AC_FUNC_SETMODE_DOS],
  [AC_CHECK_HEADERS([fcntl.h unistd.h])
   AC_CACHE_CHECK([for DOS-style setmode],
     [ac_cv_func_setmode_dos],
     [AC_TRY_LINK(
	[#include <io.h>
	 #if HAVE_FCNTL_H
	 # include <fcntl.h>
	 #endif
	 #if HAVE_UNISTD_H
	 # include <unistd.h>
	 #endif],
	[int ret = setmode && setmode (1, O_BINARY);],
	[ac_cv_func_setmode_dos=yes],
	[ac_cv_func_setmode_dos=no])])
   if test $ac_cv_func_setmode_dos = yes; then
     AC_DEFINE([HAVE_SETMODE_DOS], [1],
       [Define to 1 if you have the DOS-style `setmode' function.])
   fi])

# signal_h.m4 serial 18
dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_SIGNAL_H],
[
  AC_REQUIRE([gl_SIGNAL_H_DEFAULTS])
  AC_REQUIRE([gl_CHECK_TYPE_SIGSET_T])
  gl_NEXT_HEADERS([signal.h])

# AIX declares sig_atomic_t to already include volatile, and C89 compilers
# then choke on 'volatile sig_atomic_t'.  C99 requires that it compile.
  AC_CHECK_TYPE([volatile sig_atomic_t], [],
    [HAVE_TYPE_VOLATILE_SIG_ATOMIC_T=0], [[
#include <signal.h>
    ]])

  dnl Ensure the type pid_t gets defined.
  AC_REQUIRE([AC_TYPE_PID_T])

  AC_REQUIRE([AC_TYPE_UID_T])

  dnl Persuade glibc <signal.h> to define sighandler_t.
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_TYPE([sighandler_t], [], [HAVE_SIGHANDLER_T=0], [[
#include <signal.h>
    ]])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[#include <signal.h>
    ]], [pthread_sigmask sigaction
    sigaddset sigdelset sigemptyset sigfillset sigismember
    sigpending sigprocmask])
])

AC_DEFUN([gl_CHECK_TYPE_SIGSET_T],
[
  AC_CHECK_TYPES([sigset_t],
    [gl_cv_type_sigset_t=yes], [gl_cv_type_sigset_t=no],
    [[
      #include <signal.h>
      /* Mingw defines sigset_t not in <signal.h>, but in <sys/types.h>.  */
      #include <sys/types.h>
    ]])
  if test $gl_cv_type_sigset_t != yes; then
    HAVE_SIGSET_T=0
  fi
])

AC_DEFUN([gl_SIGNAL_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_SIGNAL_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_SIGNAL_H_DEFAULTS],
[
  GNULIB_PTHREAD_SIGMASK=0;    AC_SUBST([GNULIB_PTHREAD_SIGMASK])
  GNULIB_RAISE=0;              AC_SUBST([GNULIB_RAISE])
  GNULIB_SIGNAL_H_SIGPIPE=0;   AC_SUBST([GNULIB_SIGNAL_H_SIGPIPE])
  GNULIB_SIGPROCMASK=0;        AC_SUBST([GNULIB_SIGPROCMASK])
  GNULIB_SIGACTION=0;          AC_SUBST([GNULIB_SIGACTION])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_POSIX_SIGNALBLOCKING=1; AC_SUBST([HAVE_POSIX_SIGNALBLOCKING])
  HAVE_PTHREAD_SIGMASK=1;      AC_SUBST([HAVE_PTHREAD_SIGMASK])
  HAVE_RAISE=1;                AC_SUBST([HAVE_RAISE])
  HAVE_SIGSET_T=1;             AC_SUBST([HAVE_SIGSET_T])
  HAVE_SIGINFO_T=1;            AC_SUBST([HAVE_SIGINFO_T])
  HAVE_SIGACTION=1;            AC_SUBST([HAVE_SIGACTION])
  HAVE_STRUCT_SIGACTION_SA_SIGACTION=1;
                               AC_SUBST([HAVE_STRUCT_SIGACTION_SA_SIGACTION])
  HAVE_TYPE_VOLATILE_SIG_ATOMIC_T=1;
                               AC_SUBST([HAVE_TYPE_VOLATILE_SIG_ATOMIC_T])
  HAVE_SIGHANDLER_T=1;         AC_SUBST([HAVE_SIGHANDLER_T])
  REPLACE_PTHREAD_SIGMASK=0;   AC_SUBST([REPLACE_PTHREAD_SIGMASK])
  REPLACE_RAISE=0;             AC_SUBST([REPLACE_RAISE])
])

# size_max.m4 serial 10
dnl Copyright (C) 2003, 2005-2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_DEFUN([gl_SIZE_MAX],
[
  AC_CHECK_HEADERS([stdint.h])
  dnl First test whether the system already has SIZE_MAX.
  AC_CACHE_CHECK([for SIZE_MAX], [gl_cv_size_max], [
    gl_cv_size_max=
    AC_EGREP_CPP([Found it], [
#include <limits.h>
#if HAVE_STDINT_H
#include <stdint.h>
#endif
#ifdef SIZE_MAX
Found it
#endif
], [gl_cv_size_max=yes])
    if test -z "$gl_cv_size_max"; then
      dnl Define it ourselves. Here we assume that the type 'size_t' is not wider
      dnl than the type 'unsigned long'. Try hard to find a definition that can
      dnl be used in a preprocessor #if, i.e. doesn't contain a cast.
      AC_COMPUTE_INT([size_t_bits_minus_1], [sizeof (size_t) * CHAR_BIT - 1],
        [#include <stddef.h>
#include <limits.h>], [size_t_bits_minus_1=])
      AC_COMPUTE_INT([fits_in_uint], [sizeof (size_t) <= sizeof (unsigned int)],
        [#include <stddef.h>], [fits_in_uint=])
      if test -n "$size_t_bits_minus_1" && test -n "$fits_in_uint"; then
        if test $fits_in_uint = 1; then
          dnl Even though SIZE_MAX fits in an unsigned int, it must be of type
          dnl 'unsigned long' if the type 'size_t' is the same as 'unsigned long'.
          AC_COMPILE_IFELSE(
            [AC_LANG_PROGRAM(
               [[#include <stddef.h>
                 extern size_t foo;
                 extern unsigned long foo;
               ]],
               [[]])],
            [fits_in_uint=0])
        fi
        dnl We cannot use 'expr' to simplify this expression, because 'expr'
        dnl works only with 'long' integers in the host environment, while we
        dnl might be cross-compiling from a 32-bit platform to a 64-bit platform.
        if test $fits_in_uint = 1; then
          gl_cv_size_max="(((1U << $size_t_bits_minus_1) - 1) * 2 + 1)"
        else
          gl_cv_size_max="(((1UL << $size_t_bits_minus_1) - 1) * 2 + 1)"
        fi
      else
        dnl Shouldn't happen, but who knows...
        gl_cv_size_max='((size_t)~(size_t)0)'
      fi
    fi
  ])
  if test "$gl_cv_size_max" != yes; then
    AC_DEFINE_UNQUOTED([SIZE_MAX], [$gl_cv_size_max],
      [Define as the maximum value of type 'size_t', if the system doesn't define it.])
  fi
  dnl Don't redefine SIZE_MAX in config.h if config.h is re-included after
  dnl <stdint.h>. Remember that the #undef in AH_VERBATIM gets replaced with
  dnl #define by AC_DEFINE_UNQUOTED.
  AH_VERBATIM([SIZE_MAX],
[/* Define as the maximum value of type 'size_t', if the system doesn't define
   it. */
#ifndef SIZE_MAX
# undef SIZE_MAX
#endif])
])

dnl Autoconf >= 2.61 has AC_COMPUTE_INT built-in.
dnl Remove this when we can assume autoconf >= 2.61.
m4_ifdef([AC_COMPUTE_INT], [], [
  AC_DEFUN([AC_COMPUTE_INT], [_AC_COMPUTE_INT([$2],[$1],[$3],[$4])])
])

# ssize_t.m4 serial 5 (gettext-0.18.2)
dnl Copyright (C) 2001-2003, 2006, 2010-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.
dnl Test whether ssize_t is defined.

AC_DEFUN([gt_TYPE_SSIZE_T],
[
  AC_CACHE_CHECK([for ssize_t], [gt_cv_ssize_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <sys/types.h>]],
          [[int x = sizeof (ssize_t *) + sizeof (ssize_t);
            return !x;]])],
       [gt_cv_ssize_t=yes], [gt_cv_ssize_t=no])])
  if test $gt_cv_ssize_t = no; then
    AC_DEFINE([ssize_t], [int],
              [Define as a signed type of the same size as size_t.])
  fi
])

# Checks for stat-related time functions.

# Copyright (C) 1998-1999, 2001, 2003, 2005-2007, 2009-2018 Free Software
# Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

# st_atim.tv_nsec - Linux, Solaris, Cygwin
# st_atimespec.tv_nsec - FreeBSD, NetBSD, if ! defined _POSIX_SOURCE
# st_atimensec - FreeBSD, NetBSD, if defined _POSIX_SOURCE
# st_atim.st__tim.tv_nsec - UnixWare (at least 2.1.2 through 7.1)

# st_birthtimespec - FreeBSD, NetBSD (hidden on OpenBSD 3.9, anyway)
# st_birthtim - Cygwin 1.7.0+

AC_DEFUN([gl_STAT_TIME],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_HEADERS_ONCE([sys/time.h])

  AC_CHECK_MEMBERS([struct stat.st_atim.tv_nsec],
    [AC_CACHE_CHECK([whether struct stat.st_atim is of type struct timespec],
       [ac_cv_typeof_struct_stat_st_atim_is_struct_timespec],
       [AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
          [[
            #include <sys/types.h>
            #include <sys/stat.h>
            #if HAVE_SYS_TIME_H
            # include <sys/time.h>
            #endif
            #include <time.h>
            struct timespec ts;
            struct stat st;
          ]],
          [[
            st.st_atim = ts;
          ]])],
          [ac_cv_typeof_struct_stat_st_atim_is_struct_timespec=yes],
          [ac_cv_typeof_struct_stat_st_atim_is_struct_timespec=no])])
     if test $ac_cv_typeof_struct_stat_st_atim_is_struct_timespec = yes; then
       AC_DEFINE([TYPEOF_STRUCT_STAT_ST_ATIM_IS_STRUCT_TIMESPEC], [1],
         [Define to 1 if the type of the st_atim member of a struct stat is
          struct timespec.])
     fi],
    [AC_CHECK_MEMBERS([struct stat.st_atimespec.tv_nsec], [],
       [AC_CHECK_MEMBERS([struct stat.st_atimensec], [],
          [AC_CHECK_MEMBERS([struct stat.st_atim.st__tim.tv_nsec], [], [],
             [#include <sys/types.h>
              #include <sys/stat.h>])],
          [#include <sys/types.h>
           #include <sys/stat.h>])],
       [#include <sys/types.h>
        #include <sys/stat.h>])],
    [#include <sys/types.h>
     #include <sys/stat.h>])
])

# Check for st_birthtime, a feature from UFS2 (FreeBSD, NetBSD, OpenBSD, etc.)
# and NTFS (Cygwin).
# There was a time when this field was named st_createtime (21 June
# 2002 to 16 July 2002) But that window is very small and applied only
# to development code, so systems still using that configuration are
# not supported.  See revisions 1.10 and 1.11 of FreeBSD's
# src/sys/ufs/ufs/dinode.h.
#
AC_DEFUN([gl_STAT_BIRTHTIME],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_HEADERS_ONCE([sys/time.h])
  AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec], [],
    [AC_CHECK_MEMBERS([struct stat.st_birthtimensec], [],
      [AC_CHECK_MEMBERS([struct stat.st_birthtim.tv_nsec], [], [],
         [#include <sys/types.h>
          #include <sys/stat.h>])],
       [#include <sys/types.h>
        #include <sys/stat.h>])],
    [#include <sys/types.h>
     #include <sys/stat.h>])
])

# serial 14

# Copyright (C) 2009-2018 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STAT],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([lstat])
  case "$host_os" in
    mingw*)
      dnl On this platform, the original stat() returns st_atime, st_mtime,
      dnl st_ctime values that are affected by the time zone.
      REPLACE_STAT=1
      ;;
    *)
      dnl AIX 7.1, Solaris 9, mingw64 mistakenly succeed on stat("file/").
      dnl (For mingw, this is due to a broken stat() override in libmingwex.a.)
      dnl FreeBSD 7.2 mistakenly succeeds on stat("link-to-file/").
      AC_CACHE_CHECK([whether stat handles trailing slashes on files],
        [gl_cv_func_stat_file_slash],
        [touch conftest.tmp
         # Assume that if we have lstat, we can also check symlinks.
         if test $ac_cv_func_lstat = yes; then
           ln -s conftest.tmp conftest.lnk
         fi
         AC_RUN_IFELSE(
           [AC_LANG_PROGRAM(
             [[#include <sys/stat.h>
]], [[int result = 0;
               struct stat st;
               if (!stat ("conftest.tmp/", &st))
                 result |= 1;
#if HAVE_LSTAT
               if (!stat ("conftest.lnk/", &st))
                 result |= 2;
#endif
               return result;
             ]])],
           [gl_cv_func_stat_file_slash=yes], [gl_cv_func_stat_file_slash=no],
           [case "$host_os" in
                             # Guess yes on glibc systems.
              *-gnu* | gnu*) gl_cv_func_stat_file_slash="guessing yes" ;;
                             # If we don't know, assume the worst.
              *)             gl_cv_func_stat_file_slash="guessing no" ;;
            esac
           ])
         rm -f conftest.tmp conftest.lnk])
      case $gl_cv_func_stat_file_slash in
        *no)
          REPLACE_STAT=1
          AC_DEFINE([REPLACE_FUNC_STAT_FILE], [1], [Define to 1 if stat needs
            help when passed a file name with a trailing slash]);;
      esac
      case $host_os in
        dnl Solaris stat can return a negative tv_nsec.
        solaris*)
          REPLACE_FSTAT=1 ;;
      esac
      ;;
  esac
])

# Prerequisites of lib/stat.c and lib/stat-w32.c.
AC_DEFUN([gl_PREREQ_STAT], [
  AC_REQUIRE([gl_HEADER_SYS_STAT_H])
  :
])

# stdarg.m4 serial 6
dnl Copyright (C) 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.
dnl Provide a working va_copy in combination with <stdarg.h>.

AC_DEFUN([gl_STDARG_H],
[
  STDARG_H=''
  NEXT_STDARG_H='<stdarg.h>'
  AC_MSG_CHECKING([for va_copy])
  AC_CACHE_VAL([gl_cv_func_va_copy], [
    AC_COMPILE_IFELSE(
      [AC_LANG_PROGRAM(
         [[#include <stdarg.h>]],
         [[
#ifndef va_copy
void (*func) (va_list, va_list) = va_copy;
#endif
         ]])],
      [gl_cv_func_va_copy=yes],
      [gl_cv_func_va_copy=no])])
  AC_MSG_RESULT([$gl_cv_func_va_copy])
  if test $gl_cv_func_va_copy = no; then
    dnl Provide a substitute.
    dnl Usually a simple definition in <config.h> is enough. Not so on AIX 5
    dnl with some versions of the /usr/vac/bin/cc compiler. It has an <stdarg.h>
    dnl which does '#undef va_copy', leading to a missing va_copy symbol. For
    dnl this platform, we use an <stdarg.h> substitute. But we cannot use this
    dnl approach on other platforms, because <stdarg.h> often defines only
    dnl preprocessor macros and gl_ABSOLUTE_HEADER, gl_CHECK_NEXT_HEADERS do
    dnl not work in this situation.
    AC_EGREP_CPP([vaccine],
      [#if defined _AIX && !defined __GNUC__
        AIX vaccine
       #endif
      ], [gl_aixcc=yes], [gl_aixcc=no])
    if test $gl_aixcc = yes; then
      dnl Provide a substitute <stdarg.h> file.
      STDARG_H=stdarg.h
      gl_NEXT_HEADERS([stdarg.h])
      dnl Fallback for the case when <stdarg.h> contains only macro definitions.
      if test "$gl_cv_next_stdarg_h" = '""'; then
        gl_cv_next_stdarg_h='"///usr/include/stdarg.h"'
        NEXT_STDARG_H="$gl_cv_next_stdarg_h"
      fi
    else
      dnl Provide a substitute in <config.h>, either __va_copy or as a simple
      dnl assignment.
      gl_CACHE_VAL_SILENT([gl_cv_func___va_copy], [
        AC_COMPILE_IFELSE(
          [AC_LANG_PROGRAM(
             [[#include <stdarg.h>]],
             [[
#ifndef __va_copy
error, bail out
#endif
             ]])],
          [gl_cv_func___va_copy=yes],
          [gl_cv_func___va_copy=no])])
      if test $gl_cv_func___va_copy = yes; then
        AC_DEFINE([va_copy], [__va_copy],
          [Define as a macro for copying va_list variables.])
      else
        AH_VERBATIM([gl_VA_COPY], [/* A replacement for va_copy, if needed.  */
#define gl_va_copy(a,b) ((a) = (b))])
        AC_DEFINE([va_copy], [gl_va_copy],
          [Define as a macro for copying va_list variables.])
      fi
    fi
  fi
  AC_SUBST([STDARG_H])
  AM_CONDITIONAL([GL_GENERATE_STDARG_H], [test -n "$STDARG_H"])
  AC_SUBST([NEXT_STDARG_H])
])

# Check for stdbool.h that conforms to C99.

dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

#serial 7

# Prepare for substituting <stdbool.h> if it is not supported.

AC_DEFUN([AM_STDBOOL_H],
[
  AC_REQUIRE([AC_CHECK_HEADER_STDBOOL])

  # Define two additional variables used in the Makefile substitution.

  if test "$ac_cv_header_stdbool_h" = yes; then
    STDBOOL_H=''
  else
    STDBOOL_H='stdbool.h'
  fi
  AC_SUBST([STDBOOL_H])
  AM_CONDITIONAL([GL_GENERATE_STDBOOL_H], [test -n "$STDBOOL_H"])

  if test "$ac_cv_type__Bool" = yes; then
    HAVE__BOOL=1
  else
    HAVE__BOOL=0
  fi
  AC_SUBST([HAVE__BOOL])
])

# AM_STDBOOL_H will be renamed to gl_STDBOOL_H in the future.
AC_DEFUN([gl_STDBOOL_H], [AM_STDBOOL_H])

# This version of the macro is needed in autoconf <= 2.68.

AC_DEFUN([AC_CHECK_HEADER_STDBOOL],
  [AC_CACHE_CHECK([for stdbool.h that conforms to C99],
     [ac_cv_header_stdbool_h],
     [AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM(
           [[
             #include <stdbool.h>

             #ifdef __cplusplus
              typedef bool Bool;
             #else
              typedef _Bool Bool;
              #ifndef bool
               "error: bool is not defined"
              #endif
              #ifndef false
               "error: false is not defined"
              #endif
              #if false
               "error: false is not 0"
              #endif
              #ifndef true
               "error: true is not defined"
              #endif
              #if true != 1
               "error: true is not 1"
              #endif
             #endif

             #ifndef __bool_true_false_are_defined
              "error: __bool_true_false_are_defined is not defined"
             #endif

             struct s { Bool s: 1; Bool t; bool u: 1; bool v; } s;

             char a[true == 1 ? 1 : -1];
             char b[false == 0 ? 1 : -1];
             char c[__bool_true_false_are_defined == 1 ? 1 : -1];
             char d[(bool) 0.5 == true ? 1 : -1];
             /* See body of main program for 'e'.  */
             char f[(Bool) 0.0 == false ? 1 : -1];
             char g[true];
             char h[sizeof (Bool)];
             char i[sizeof s.t];
             enum { j = false, k = true, l = false * true, m = true * 256 };
             /* The following fails for
                HP aC++/ANSI C B3910B A.05.55 [Dec 04 2003]. */
             Bool n[m];
             char o[sizeof n == m * sizeof n[0] ? 1 : -1];
             char p[-1 - (Bool) 0 < 0 && -1 - (bool) 0 < 0 ? 1 : -1];
             /* Catch a bug in an HP-UX C compiler.  See
                https://gcc.gnu.org/ml/gcc-patches/2003-12/msg02303.html
                https://lists.gnu.org/r/bug-coreutils/2005-11/msg00161.html
              */
             Bool q = true;
             Bool *pq = &q;
             bool *qq = &q;
           ]],
           [[
             bool e = &s;
             *pq |= q; *pq |= ! q;
             *qq |= q; *qq |= ! q;
             /* Refer to every declared value, to avoid compiler optimizations.  */
             return (!a + !b + !c + !d + !e + !f + !g + !h + !i + !!j + !k + !!l
                     + !m + !n + !o + !p + !q + !pq + !qq);
           ]])],
        [ac_cv_header_stdbool_h=yes],
        [ac_cv_header_stdbool_h=no])])
   AC_CHECK_TYPES([_Bool])
])

dnl A placeholder for <stddef.h>, for platforms that have issues.
# stddef_h.m4 serial 5
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_STDDEF_H],
[
  AC_REQUIRE([gl_STDDEF_H_DEFAULTS])
  AC_REQUIRE([gt_TYPE_WCHAR_T])
  STDDEF_H=
  AC_CHECK_TYPE([max_align_t], [], [HAVE_MAX_ALIGN_T=0; STDDEF_H=stddef.h],
    [[#include <stddef.h>
    ]])
  if test $gt_cv_c_wchar_t = no; then
    HAVE_WCHAR_T=0
    STDDEF_H=stddef.h
  fi
  AC_CACHE_CHECK([whether NULL can be used in arbitrary expressions],
    [gl_cv_decl_null_works],
    [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stddef.h>
      int test[2 * (sizeof NULL == sizeof (void *)) -1];
]])],
      [gl_cv_decl_null_works=yes],
      [gl_cv_decl_null_works=no])])
  if test $gl_cv_decl_null_works = no; then
    REPLACE_NULL=1
    STDDEF_H=stddef.h
  fi
  AC_SUBST([STDDEF_H])
  AM_CONDITIONAL([GL_GENERATE_STDDEF_H], [test -n "$STDDEF_H"])
  if test -n "$STDDEF_H"; then
    gl_NEXT_HEADERS([stddef.h])
  fi
])

AC_DEFUN([gl_STDDEF_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_STDDEF_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
])

AC_DEFUN([gl_STDDEF_H_DEFAULTS],
[
  dnl Assume proper GNU behavior unless another module says otherwise.
  REPLACE_NULL=0;                AC_SUBST([REPLACE_NULL])
  HAVE_MAX_ALIGN_T=1;            AC_SUBST([HAVE_MAX_ALIGN_T])
  HAVE_WCHAR_T=1;                AC_SUBST([HAVE_WCHAR_T])
])

# stdint.m4 serial 51
dnl Copyright (C) 2001-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert and Bruno Haible.
dnl Test whether <stdint.h> is supported or must be substituted.

AC_DEFUN_ONCE([gl_STDINT_H],
[
  AC_PREREQ([2.59])dnl
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles

  AC_REQUIRE([gl_LIMITS_H])
  AC_REQUIRE([gt_TYPE_WINT_T])

  dnl Check for long long int and unsigned long long int.
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
  if test $ac_cv_type_long_long_int = yes; then
    HAVE_LONG_LONG_INT=1
  else
    HAVE_LONG_LONG_INT=0
  fi
  AC_SUBST([HAVE_LONG_LONG_INT])
  AC_REQUIRE([AC_TYPE_UNSIGNED_LONG_LONG_INT])
  if test $ac_cv_type_unsigned_long_long_int = yes; then
    HAVE_UNSIGNED_LONG_LONG_INT=1
  else
    HAVE_UNSIGNED_LONG_LONG_INT=0
  fi
  AC_SUBST([HAVE_UNSIGNED_LONG_LONG_INT])

  dnl Check for <wchar.h>, in the same way as gl_WCHAR_H does.
  AC_CHECK_HEADERS_ONCE([wchar.h])
  if test $ac_cv_header_wchar_h = yes; then
    HAVE_WCHAR_H=1
  else
    HAVE_WCHAR_H=0
  fi
  AC_SUBST([HAVE_WCHAR_H])

  dnl Check for <inttypes.h>.
  dnl AC_INCLUDES_DEFAULT defines $ac_cv_header_inttypes_h.
  if test $ac_cv_header_inttypes_h = yes; then
    HAVE_INTTYPES_H=1
  else
    HAVE_INTTYPES_H=0
  fi
  AC_SUBST([HAVE_INTTYPES_H])

  dnl Check for <sys/types.h>.
  dnl AC_INCLUDES_DEFAULT defines $ac_cv_header_sys_types_h.
  if test $ac_cv_header_sys_types_h = yes; then
    HAVE_SYS_TYPES_H=1
  else
    HAVE_SYS_TYPES_H=0
  fi
  AC_SUBST([HAVE_SYS_TYPES_H])

  gl_CHECK_NEXT_HEADERS([stdint.h])
  if test $ac_cv_header_stdint_h = yes; then
    HAVE_STDINT_H=1
  else
    HAVE_STDINT_H=0
  fi
  AC_SUBST([HAVE_STDINT_H])

  dnl Now see whether we need a substitute <stdint.h>.
  if test $ac_cv_header_stdint_h = yes; then
    AC_CACHE_CHECK([whether stdint.h conforms to C99],
      [gl_cv_header_working_stdint_h],
      [gl_cv_header_working_stdint_h=no
       AC_COMPILE_IFELSE([
         AC_LANG_PROGRAM([[
#define _GL_JUST_INCLUDE_SYSTEM_STDINT_H 1 /* work if build isn't clean */
#define __STDC_CONSTANT_MACROS 1
#define __STDC_LIMIT_MACROS 1
#include <stdint.h>
/* Dragonfly defines WCHAR_MIN, WCHAR_MAX only in <wchar.h>.  */
#if !(defined WCHAR_MIN && defined WCHAR_MAX)
#error "WCHAR_MIN, WCHAR_MAX not defined in <stdint.h>"
#endif
]
gl_STDINT_INCLUDES
[
#ifdef INT8_MAX
int8_t a1 = INT8_MAX;
int8_t a1min = INT8_MIN;
#endif
#ifdef INT16_MAX
int16_t a2 = INT16_MAX;
int16_t a2min = INT16_MIN;
#endif
#ifdef INT32_MAX
int32_t a3 = INT32_MAX;
int32_t a3min = INT32_MIN;
#endif
#ifdef INT64_MAX
int64_t a4 = INT64_MAX;
int64_t a4min = INT64_MIN;
#endif
#ifdef UINT8_MAX
uint8_t b1 = UINT8_MAX;
#else
typedef int b1[(unsigned char) -1 != 255 ? 1 : -1];
#endif
#ifdef UINT16_MAX
uint16_t b2 = UINT16_MAX;
#endif
#ifdef UINT32_MAX
uint32_t b3 = UINT32_MAX;
#endif
#ifdef UINT64_MAX
uint64_t b4 = UINT64_MAX;
#endif
int_least8_t c1 = INT8_C (0x7f);
int_least8_t c1max = INT_LEAST8_MAX;
int_least8_t c1min = INT_LEAST8_MIN;
int_least16_t c2 = INT16_C (0x7fff);
int_least16_t c2max = INT_LEAST16_MAX;
int_least16_t c2min = INT_LEAST16_MIN;
int_least32_t c3 = INT32_C (0x7fffffff);
int_least32_t c3max = INT_LEAST32_MAX;
int_least32_t c3min = INT_LEAST32_MIN;
int_least64_t c4 = INT64_C (0x7fffffffffffffff);
int_least64_t c4max = INT_LEAST64_MAX;
int_least64_t c4min = INT_LEAST64_MIN;
uint_least8_t d1 = UINT8_C (0xff);
uint_least8_t d1max = UINT_LEAST8_MAX;
uint_least16_t d2 = UINT16_C (0xffff);
uint_least16_t d2max = UINT_LEAST16_MAX;
uint_least32_t d3 = UINT32_C (0xffffffff);
uint_least32_t d3max = UINT_LEAST32_MAX;
uint_least64_t d4 = UINT64_C (0xffffffffffffffff);
uint_least64_t d4max = UINT_LEAST64_MAX;
int_fast8_t e1 = INT_FAST8_MAX;
int_fast8_t e1min = INT_FAST8_MIN;
int_fast16_t e2 = INT_FAST16_MAX;
int_fast16_t e2min = INT_FAST16_MIN;
int_fast32_t e3 = INT_FAST32_MAX;
int_fast32_t e3min = INT_FAST32_MIN;
int_fast64_t e4 = INT_FAST64_MAX;
int_fast64_t e4min = INT_FAST64_MIN;
uint_fast8_t f1 = UINT_FAST8_MAX;
uint_fast16_t f2 = UINT_FAST16_MAX;
uint_fast32_t f3 = UINT_FAST32_MAX;
uint_fast64_t f4 = UINT_FAST64_MAX;
#ifdef INTPTR_MAX
intptr_t g = INTPTR_MAX;
intptr_t gmin = INTPTR_MIN;
#endif
#ifdef UINTPTR_MAX
uintptr_t h = UINTPTR_MAX;
#endif
intmax_t i = INTMAX_MAX;
uintmax_t j = UINTMAX_MAX;

/* Check that SIZE_MAX has the correct type, if possible.  */
#if 201112 <= __STDC_VERSION__
int k = _Generic (SIZE_MAX, size_t: 0);
#elif (2 <= __GNUC__ || defined __IBM__TYPEOF__ \
       || (0x5110 <= __SUNPRO_C && !__STDC__))
extern size_t k;
extern __typeof__ (SIZE_MAX) k;
#endif

#include <limits.h> /* for CHAR_BIT */
#define TYPE_MINIMUM(t) \
  ((t) ((t) 0 < (t) -1 ? (t) 0 : ~ TYPE_MAXIMUM (t)))
#define TYPE_MAXIMUM(t) \
  ((t) ((t) 0 < (t) -1 \
        ? (t) -1 \
        : ((((t) 1 << (sizeof (t) * CHAR_BIT - 2)) - 1) * 2 + 1)))
struct s {
  int check_PTRDIFF:
      PTRDIFF_MIN == TYPE_MINIMUM (ptrdiff_t)
      && PTRDIFF_MAX == TYPE_MAXIMUM (ptrdiff_t)
      ? 1 : -1;
  /* Detect bug in FreeBSD 6.0 / ia64.  */
  int check_SIG_ATOMIC:
      SIG_ATOMIC_MIN == TYPE_MINIMUM (sig_atomic_t)
      && SIG_ATOMIC_MAX == TYPE_MAXIMUM (sig_atomic_t)
      ? 1 : -1;
  int check_SIZE: SIZE_MAX == TYPE_MAXIMUM (size_t) ? 1 : -1;
  int check_WCHAR:
      WCHAR_MIN == TYPE_MINIMUM (wchar_t)
      && WCHAR_MAX == TYPE_MAXIMUM (wchar_t)
      ? 1 : -1;
  /* Detect bug in mingw.  */
  int check_WINT:
      WINT_MIN == TYPE_MINIMUM (wint_t)
      && WINT_MAX == TYPE_MAXIMUM (wint_t)
      ? 1 : -1;

  /* Detect bugs in glibc 2.4 and Solaris 10 stdint.h, among others.  */
  int check_UINT8_C:
        (-1 < UINT8_C (0)) == (-1 < (uint_least8_t) 0) ? 1 : -1;
  int check_UINT16_C:
        (-1 < UINT16_C (0)) == (-1 < (uint_least16_t) 0) ? 1 : -1;

  /* Detect bugs in OpenBSD 3.9 stdint.h.  */
#ifdef UINT8_MAX
  int check_uint8: (uint8_t) -1 == UINT8_MAX ? 1 : -1;
#endif
#ifdef UINT16_MAX
  int check_uint16: (uint16_t) -1 == UINT16_MAX ? 1 : -1;
#endif
#ifdef UINT32_MAX
  int check_uint32: (uint32_t) -1 == UINT32_MAX ? 1 : -1;
#endif
#ifdef UINT64_MAX
  int check_uint64: (uint64_t) -1 == UINT64_MAX ? 1 : -1;
#endif
  int check_uint_least8: (uint_least8_t) -1 == UINT_LEAST8_MAX ? 1 : -1;
  int check_uint_least16: (uint_least16_t) -1 == UINT_LEAST16_MAX ? 1 : -1;
  int check_uint_least32: (uint_least32_t) -1 == UINT_LEAST32_MAX ? 1 : -1;
  int check_uint_least64: (uint_least64_t) -1 == UINT_LEAST64_MAX ? 1 : -1;
  int check_uint_fast8: (uint_fast8_t) -1 == UINT_FAST8_MAX ? 1 : -1;
  int check_uint_fast16: (uint_fast16_t) -1 == UINT_FAST16_MAX ? 1 : -1;
  int check_uint_fast32: (uint_fast32_t) -1 == UINT_FAST32_MAX ? 1 : -1;
  int check_uint_fast64: (uint_fast64_t) -1 == UINT_FAST64_MAX ? 1 : -1;
  int check_uintptr: (uintptr_t) -1 == UINTPTR_MAX ? 1 : -1;
  int check_uintmax: (uintmax_t) -1 == UINTMAX_MAX ? 1 : -1;
  int check_size: (size_t) -1 == SIZE_MAX ? 1 : -1;
};
         ]])],
         [dnl Determine whether the various *_MIN, *_MAX macros are usable
          dnl in preprocessor expression. We could do it by compiling a test
          dnl program for each of these macros. It is faster to run a program
          dnl that inspects the macro expansion.
          dnl This detects a bug on HP-UX 11.23/ia64.
          AC_RUN_IFELSE([
            AC_LANG_PROGRAM([[
#define _GL_JUST_INCLUDE_SYSTEM_STDINT_H 1 /* work if build isn't clean */
#define __STDC_CONSTANT_MACROS 1
#define __STDC_LIMIT_MACROS 1
#include <stdint.h>
]
gl_STDINT_INCLUDES
[
#include <stdio.h>
#include <string.h>
#define MVAL(macro) MVAL1(macro)
#define MVAL1(expression) #expression
static const char *macro_values[] =
  {
#ifdef INT8_MAX
    MVAL (INT8_MAX),
#endif
#ifdef INT16_MAX
    MVAL (INT16_MAX),
#endif
#ifdef INT32_MAX
    MVAL (INT32_MAX),
#endif
#ifdef INT64_MAX
    MVAL (INT64_MAX),
#endif
#ifdef UINT8_MAX
    MVAL (UINT8_MAX),
#endif
#ifdef UINT16_MAX
    MVAL (UINT16_MAX),
#endif
#ifdef UINT32_MAX
    MVAL (UINT32_MAX),
#endif
#ifdef UINT64_MAX
    MVAL (UINT64_MAX),
#endif
    NULL
  };
]], [[
  const char **mv;
  for (mv = macro_values; *mv != NULL; mv++)
    {
      const char *value = *mv;
      /* Test whether it looks like a cast expression.  */
      if (strncmp (value, "((unsigned int)"/*)*/, 15) == 0
          || strncmp (value, "((unsigned short)"/*)*/, 17) == 0
          || strncmp (value, "((unsigned char)"/*)*/, 16) == 0
          || strncmp (value, "((int)"/*)*/, 6) == 0
          || strncmp (value, "((signed short)"/*)*/, 15) == 0
          || strncmp (value, "((signed char)"/*)*/, 14) == 0)
        return mv - macro_values + 1;
    }
  return 0;
]])],
              [gl_cv_header_working_stdint_h=yes],
              [],
              [case "$host_os" in
                         # Guess yes on native Windows.
                 mingw*) gl_cv_header_working_stdint_h="guessing yes" ;;
                         # In general, assume it works.
                 *)      gl_cv_header_working_stdint_h="guessing yes" ;;
               esac
              ])
         ])
      ])
  fi

  HAVE_C99_STDINT_H=0
  HAVE_SYS_BITYPES_H=0
  HAVE_SYS_INTTYPES_H=0
  STDINT_H=stdint.h
  case "$gl_cv_header_working_stdint_h" in
    *yes)
      HAVE_C99_STDINT_H=1
      dnl Now see whether the system <stdint.h> works without
      dnl __STDC_CONSTANT_MACROS/__STDC_LIMIT_MACROS defined.
      AC_CACHE_CHECK([whether stdint.h predates C++11],
        [gl_cv_header_stdint_predates_cxx11_h],
        [gl_cv_header_stdint_predates_cxx11_h=yes
         AC_COMPILE_IFELSE([
           AC_LANG_PROGRAM([[
#define _GL_JUST_INCLUDE_SYSTEM_STDINT_H 1 /* work if build isn't clean */
#include <stdint.h>
]
gl_STDINT_INCLUDES
[
intmax_t im = INTMAX_MAX;
int32_t i32 = INT32_C (0x7fffffff);
           ]])],
           [gl_cv_header_stdint_predates_cxx11_h=no])])

      if test "$gl_cv_header_stdint_predates_cxx11_h" = yes; then
        AC_DEFINE([__STDC_CONSTANT_MACROS], [1],
                  [Define to 1 if the system <stdint.h> predates C++11.])
        AC_DEFINE([__STDC_LIMIT_MACROS], [1],
                  [Define to 1 if the system <stdint.h> predates C++11.])
      fi
      AC_CACHE_CHECK([whether stdint.h has UINTMAX_WIDTH etc.],
        [gl_cv_header_stdint_width],
        [gl_cv_header_stdint_width=no
         AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM([[
              /* Work if build is not clean.  */
              #define _GL_JUST_INCLUDE_SYSTEM_STDINT_H 1
              #ifndef __STDC_WANT_IEC_60559_BFP_EXT__
               #define __STDC_WANT_IEC_60559_BFP_EXT__ 1
              #endif
              #include <stdint.h>
              ]gl_STDINT_INCLUDES[
              int iw = UINTMAX_WIDTH;
              ]])],
           [gl_cv_header_stdint_width=yes])])
      if test "$gl_cv_header_stdint_width" = yes; then
        STDINT_H=
      fi
      ;;
    *)
      dnl Check for <sys/inttypes.h>, and for
      dnl <sys/bitypes.h> (used in Linux libc4 >= 4.6.7 and libc5).
      AC_CHECK_HEADERS([sys/inttypes.h sys/bitypes.h])
      if test $ac_cv_header_sys_inttypes_h = yes; then
        HAVE_SYS_INTTYPES_H=1
      fi
      if test $ac_cv_header_sys_bitypes_h = yes; then
        HAVE_SYS_BITYPES_H=1
      fi
      gl_STDINT_TYPE_PROPERTIES
      ;;
  esac

  dnl The substitute stdint.h needs the substitute limit.h's _GL_INTEGER_WIDTH.
  LIMITS_H=limits.h
  AM_CONDITIONAL([GL_GENERATE_LIMITS_H], [test -n "$LIMITS_H"])

  AC_SUBST([HAVE_C99_STDINT_H])
  AC_SUBST([HAVE_SYS_BITYPES_H])
  AC_SUBST([HAVE_SYS_INTTYPES_H])
  AC_SUBST([STDINT_H])
  AM_CONDITIONAL([GL_GENERATE_STDINT_H], [test -n "$STDINT_H"])
])

dnl gl_STDINT_BITSIZEOF(TYPES, INCLUDES)
dnl Determine the size of each of the given types in bits.
AC_DEFUN([gl_STDINT_BITSIZEOF],
[
  dnl Use a shell loop, to avoid bloating configure, and
  dnl - extra AH_TEMPLATE calls, so that autoheader knows what to put into
  dnl   config.h.in,
  dnl - extra AC_SUBST calls, so that the right substitutions are made.
  m4_foreach_w([gltype], [$1],
    [AH_TEMPLATE([BITSIZEOF_]m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_]),
       [Define to the number of bits in type ']gltype['.])])
  for gltype in $1 ; do
    AC_CACHE_CHECK([for bit size of $gltype], [gl_cv_bitsizeof_${gltype}],
      [AC_COMPUTE_INT([result], [sizeof ($gltype) * CHAR_BIT],
         [$2
#include <limits.h>], [result=unknown])
       eval gl_cv_bitsizeof_${gltype}=\$result
      ])
    eval result=\$gl_cv_bitsizeof_${gltype}
    if test $result = unknown; then
      dnl Use a nonempty default, because some compilers, such as IRIX 5 cc,
      dnl do a syntax check even on unused #if conditions and give an error
      dnl on valid C code like this:
      dnl   #if 0
      dnl   # if  > 32
      dnl   # endif
      dnl   #endif
      result=0
    fi
    GLTYPE=`echo "$gltype" | tr 'abcdefghijklmnopqrstuvwxyz ' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'`
    AC_DEFINE_UNQUOTED([BITSIZEOF_${GLTYPE}], [$result])
    eval BITSIZEOF_${GLTYPE}=\$result
  done
  m4_foreach_w([gltype], [$1],
    [AC_SUBST([BITSIZEOF_]m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_]))])
])

dnl gl_CHECK_TYPES_SIGNED(TYPES, INCLUDES)
dnl Determine the signedness of each of the given types.
dnl Define HAVE_SIGNED_TYPE if type is signed.
AC_DEFUN([gl_CHECK_TYPES_SIGNED],
[
  dnl Use a shell loop, to avoid bloating configure, and
  dnl - extra AH_TEMPLATE calls, so that autoheader knows what to put into
  dnl   config.h.in,
  dnl - extra AC_SUBST calls, so that the right substitutions are made.
  m4_foreach_w([gltype], [$1],
    [AH_TEMPLATE([HAVE_SIGNED_]m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_]),
       [Define to 1 if ']gltype[' is a signed integer type.])])
  for gltype in $1 ; do
    AC_CACHE_CHECK([whether $gltype is signed], [gl_cv_type_${gltype}_signed],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([$2[
            int verify[2 * (($gltype) -1 < ($gltype) 0) - 1];]])],
         result=yes, result=no)
       eval gl_cv_type_${gltype}_signed=\$result
      ])
    eval result=\$gl_cv_type_${gltype}_signed
    GLTYPE=`echo $gltype | tr 'abcdefghijklmnopqrstuvwxyz ' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'`
    if test "$result" = yes; then
      AC_DEFINE_UNQUOTED([HAVE_SIGNED_${GLTYPE}], [1])
      eval HAVE_SIGNED_${GLTYPE}=1
    else
      eval HAVE_SIGNED_${GLTYPE}=0
    fi
  done
  m4_foreach_w([gltype], [$1],
    [AC_SUBST([HAVE_SIGNED_]m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_]))])
])

dnl gl_INTEGER_TYPE_SUFFIX(TYPES, INCLUDES)
dnl Determine the suffix to use for integer constants of the given types.
dnl Define t_SUFFIX for each such type.
AC_DEFUN([gl_INTEGER_TYPE_SUFFIX],
[
  dnl Use a shell loop, to avoid bloating configure, and
  dnl - extra AH_TEMPLATE calls, so that autoheader knows what to put into
  dnl   config.h.in,
  dnl - extra AC_SUBST calls, so that the right substitutions are made.
  m4_foreach_w([gltype], [$1],
    [AH_TEMPLATE(m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_])[_SUFFIX],
       [Define to l, ll, u, ul, ull, etc., as suitable for
        constants of type ']gltype['.])])
  for gltype in $1 ; do
    AC_CACHE_CHECK([for $gltype integer literal suffix],
      [gl_cv_type_${gltype}_suffix],
      [eval gl_cv_type_${gltype}_suffix=no
       eval result=\$gl_cv_type_${gltype}_signed
       if test "$result" = yes; then
         glsufu=
       else
         glsufu=u
       fi
       for glsuf in "$glsufu" ${glsufu}l ${glsufu}ll ${glsufu}i64; do
         case $glsuf in
           '')  gltype1='int';;
           l)   gltype1='long int';;
           ll)  gltype1='long long int';;
           i64) gltype1='__int64';;
           u)   gltype1='unsigned int';;
           ul)  gltype1='unsigned long int';;
           ull) gltype1='unsigned long long int';;
           ui64)gltype1='unsigned __int64';;
         esac
         AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM([$2[
              extern $gltype foo;
              extern $gltype1 foo;]])],
           [eval gl_cv_type_${gltype}_suffix=\$glsuf])
         eval result=\$gl_cv_type_${gltype}_suffix
         test "$result" != no && break
       done])
    GLTYPE=`echo $gltype | tr 'abcdefghijklmnopqrstuvwxyz ' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'`
    eval result=\$gl_cv_type_${gltype}_suffix
    test "$result" = no && result=
    eval ${GLTYPE}_SUFFIX=\$result
    AC_DEFINE_UNQUOTED([${GLTYPE}_SUFFIX], [$result])
  done
  m4_foreach_w([gltype], [$1],
    [AC_SUBST(m4_translit(gltype,[abcdefghijklmnopqrstuvwxyz ],[ABCDEFGHIJKLMNOPQRSTUVWXYZ_])[_SUFFIX])])
])

dnl gl_STDINT_INCLUDES
AC_DEFUN([gl_STDINT_INCLUDES],
[[
  /* BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
     included before <wchar.h>.  */
  #include <stddef.h>
  #include <signal.h>
  #if HAVE_WCHAR_H
  # include <stdio.h>
  # include <time.h>
  # include <wchar.h>
  #endif
]])

dnl gl_STDINT_TYPE_PROPERTIES
dnl Compute HAVE_SIGNED_t, BITSIZEOF_t and t_SUFFIX, for all the types t
dnl of interest to stdint.in.h.
AC_DEFUN([gl_STDINT_TYPE_PROPERTIES],
[
  AC_REQUIRE([gl_MULTIARCH])
  if test $APPLE_UNIVERSAL_BUILD = 0; then
    gl_STDINT_BITSIZEOF([ptrdiff_t size_t],
      [gl_STDINT_INCLUDES])
  fi
  gl_STDINT_BITSIZEOF([sig_atomic_t wchar_t wint_t],
    [gl_STDINT_INCLUDES])
  gl_CHECK_TYPES_SIGNED([sig_atomic_t wchar_t wint_t],
    [gl_STDINT_INCLUDES])
  gl_cv_type_ptrdiff_t_signed=yes
  gl_cv_type_size_t_signed=no
  if test $APPLE_UNIVERSAL_BUILD = 0; then
    gl_INTEGER_TYPE_SUFFIX([ptrdiff_t size_t],
      [gl_STDINT_INCLUDES])
  fi
  gl_INTEGER_TYPE_SUFFIX([sig_atomic_t wchar_t wint_t],
    [gl_STDINT_INCLUDES])

  dnl If wint_t is smaller than 'int', it cannot satisfy the ISO C 99
  dnl requirement that wint_t is "unchanged by default argument promotions".
  dnl In this case gnulib's <wchar.h> and <wctype.h> override wint_t.
  dnl Set the variable BITSIZEOF_WINT_T accordingly.
  if test $GNULIB_OVERRIDES_WINT_T = 1; then
    BITSIZEOF_WINT_T=32
  fi
])

dnl Autoconf >= 2.61 has AC_COMPUTE_INT built-in.
dnl Remove this when we can assume autoconf >= 2.61.
m4_ifdef([AC_COMPUTE_INT], [], [
  AC_DEFUN([AC_COMPUTE_INT], [_AC_COMPUTE_INT([$2],[$1],[$3],[$4])])
])

# stdint_h.m4 serial 9
dnl Copyright (C) 1997-2004, 2006, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Paul Eggert.

# Define HAVE_STDINT_H_WITH_UINTMAX if <stdint.h> exists,
# doesn't clash with <sys/types.h>, and declares uintmax_t.

AC_DEFUN([gl_AC_HEADER_STDINT_H],
[
  AC_CACHE_CHECK([for stdint.h], [gl_cv_header_stdint_h],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <sys/types.h>
            #include <stdint.h>]],
          [[uintmax_t i = (uintmax_t) -1; return !i;]])],
       [gl_cv_header_stdint_h=yes],
       [gl_cv_header_stdint_h=no])])
  if test $gl_cv_header_stdint_h = yes; then
    AC_DEFINE_UNQUOTED([HAVE_STDINT_H_WITH_UINTMAX], [1],
      [Define if <stdint.h> exists, doesn't clash with <sys/types.h>,
       and declares uintmax_t. ])
  fi
])

# stdio_h.m4 serial 48
dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_STDIO_H],
[
  AH_VERBATIM([MINGW_ANSI_STDIO],
[/* Use GNU style printf and scanf.  */
#ifndef __USE_MINGW_ANSI_STDIO
# undef __USE_MINGW_ANSI_STDIO
#endif
])
  AC_DEFINE([__USE_MINGW_ANSI_STDIO])
  AC_REQUIRE([gl_STDIO_H_DEFAULTS])
  gl_NEXT_HEADERS([stdio.h])

  dnl Determine whether __USE_MINGW_ANSI_STDIO makes printf and
  dnl inttypes.h behave like gnu instead of system; we must give our
  dnl printf wrapper the right attribute to match.
  AC_CACHE_CHECK([which flavor of printf attribute matches inttypes macros],
    [gl_cv_func_printf_attribute_flavor],
    [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
       #define __STDC_FORMAT_MACROS 1
       #include <stdio.h>
       #include <inttypes.h>
       /* For non-mingw systems, compilation will trivially succeed.
          For mingw, compilation will succeed for older mingw (system
          printf, "I64d") and fail for newer mingw (gnu printf, "lld"). */
       #if ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__) && \
         (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
       extern char PRIdMAX_probe[sizeof PRIdMAX == sizeof "I64d" ? 1 : -1];
       #endif
      ]])], [gl_cv_func_printf_attribute_flavor=system],
      [gl_cv_func_printf_attribute_flavor=gnu])])
  if test "$gl_cv_func_printf_attribute_flavor" = gnu; then
    AC_DEFINE([GNULIB_PRINTF_ATTRIBUTE_FLAVOR_GNU], [1],
      [Define to 1 if printf and friends should be labeled with
       attribute "__gnu_printf__" instead of "__printf__"])
  fi

  dnl No need to create extra modules for these functions. Everyone who uses
  dnl <stdio.h> likely needs them.
  GNULIB_FSCANF=1
  gl_MODULE_INDICATOR([fscanf])
  GNULIB_SCANF=1
  gl_MODULE_INDICATOR([scanf])
  GNULIB_FGETC=1
  GNULIB_GETC=1
  GNULIB_GETCHAR=1
  GNULIB_FGETS=1
  GNULIB_FREAD=1
  dnl This ifdef is necessary to avoid an error "missing file lib/stdio-read.c"
  dnl "expected source file, required through AC_LIBSOURCES, not found". It is
  dnl also an optimization, to avoid performing a configure check whose result
  dnl is not used. But it does not make the test of GNULIB_STDIO_H_NONBLOCKING
  dnl or GNULIB_NONBLOCKING redundant.
  m4_ifdef([gl_NONBLOCKING_IO], [
    gl_NONBLOCKING_IO
    if test $gl_cv_have_nonblocking != yes; then
      REPLACE_STDIO_READ_FUNCS=1
      AC_LIBOBJ([stdio-read])
    fi
  ])

  dnl No need to create extra modules for these functions. Everyone who uses
  dnl <stdio.h> likely needs them.
  GNULIB_FPRINTF=1
  GNULIB_PRINTF=1
  GNULIB_VFPRINTF=1
  GNULIB_VPRINTF=1
  GNULIB_FPUTC=1
  GNULIB_PUTC=1
  GNULIB_PUTCHAR=1
  GNULIB_FPUTS=1
  GNULIB_PUTS=1
  GNULIB_FWRITE=1
  dnl This ifdef is necessary to avoid an error "missing file lib/stdio-write.c"
  dnl "expected source file, required through AC_LIBSOURCES, not found". It is
  dnl also an optimization, to avoid performing a configure check whose result
  dnl is not used. But it does not make the test of GNULIB_STDIO_H_SIGPIPE or
  dnl GNULIB_SIGPIPE redundant.
  m4_ifdef([gl_SIGNAL_SIGPIPE], [
    gl_SIGNAL_SIGPIPE
    if test $gl_cv_header_signal_h_SIGPIPE != yes; then
      REPLACE_STDIO_WRITE_FUNCS=1
      AC_LIBOBJ([stdio-write])
    fi
  ])
  dnl This ifdef is necessary to avoid an error "missing file lib/stdio-write.c"
  dnl "expected source file, required through AC_LIBSOURCES, not found". It is
  dnl also an optimization, to avoid performing a configure check whose result
  dnl is not used. But it does not make the test of GNULIB_STDIO_H_NONBLOCKING
  dnl or GNULIB_NONBLOCKING redundant.
  m4_ifdef([gl_NONBLOCKING_IO], [
    gl_NONBLOCKING_IO
    if test $gl_cv_have_nonblocking != yes; then
      REPLACE_STDIO_WRITE_FUNCS=1
      AC_LIBOBJ([stdio-write])
    fi
  ])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use, and which is not
  dnl guaranteed by both C89 and C11.
  gl_WARN_ON_USE_PREPARE([[#include <stdio.h>
    ]], [dprintf fpurge fseeko ftello getdelim getline gets pclose popen
    renameat snprintf tmpfile vdprintf vsnprintf])
])

AC_DEFUN([gl_STDIO_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_STDIO_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_STDIO_H_DEFAULTS],
[
  GNULIB_DPRINTF=0;              AC_SUBST([GNULIB_DPRINTF])
  GNULIB_FCLOSE=0;               AC_SUBST([GNULIB_FCLOSE])
  GNULIB_FDOPEN=0;               AC_SUBST([GNULIB_FDOPEN])
  GNULIB_FFLUSH=0;               AC_SUBST([GNULIB_FFLUSH])
  GNULIB_FGETC=0;                AC_SUBST([GNULIB_FGETC])
  GNULIB_FGETS=0;                AC_SUBST([GNULIB_FGETS])
  GNULIB_FOPEN=0;                AC_SUBST([GNULIB_FOPEN])
  GNULIB_FPRINTF=0;              AC_SUBST([GNULIB_FPRINTF])
  GNULIB_FPRINTF_POSIX=0;        AC_SUBST([GNULIB_FPRINTF_POSIX])
  GNULIB_FPURGE=0;               AC_SUBST([GNULIB_FPURGE])
  GNULIB_FPUTC=0;                AC_SUBST([GNULIB_FPUTC])
  GNULIB_FPUTS=0;                AC_SUBST([GNULIB_FPUTS])
  GNULIB_FREAD=0;                AC_SUBST([GNULIB_FREAD])
  GNULIB_FREOPEN=0;              AC_SUBST([GNULIB_FREOPEN])
  GNULIB_FSCANF=0;               AC_SUBST([GNULIB_FSCANF])
  GNULIB_FSEEK=0;                AC_SUBST([GNULIB_FSEEK])
  GNULIB_FSEEKO=0;               AC_SUBST([GNULIB_FSEEKO])
  GNULIB_FTELL=0;                AC_SUBST([GNULIB_FTELL])
  GNULIB_FTELLO=0;               AC_SUBST([GNULIB_FTELLO])
  GNULIB_FWRITE=0;               AC_SUBST([GNULIB_FWRITE])
  GNULIB_GETC=0;                 AC_SUBST([GNULIB_GETC])
  GNULIB_GETCHAR=0;              AC_SUBST([GNULIB_GETCHAR])
  GNULIB_GETDELIM=0;             AC_SUBST([GNULIB_GETDELIM])
  GNULIB_GETLINE=0;              AC_SUBST([GNULIB_GETLINE])
  GNULIB_OBSTACK_PRINTF=0;       AC_SUBST([GNULIB_OBSTACK_PRINTF])
  GNULIB_OBSTACK_PRINTF_POSIX=0; AC_SUBST([GNULIB_OBSTACK_PRINTF_POSIX])
  GNULIB_PCLOSE=0;               AC_SUBST([GNULIB_PCLOSE])
  GNULIB_PERROR=0;               AC_SUBST([GNULIB_PERROR])
  GNULIB_POPEN=0;                AC_SUBST([GNULIB_POPEN])
  GNULIB_PRINTF=0;               AC_SUBST([GNULIB_PRINTF])
  GNULIB_PRINTF_POSIX=0;         AC_SUBST([GNULIB_PRINTF_POSIX])
  GNULIB_PUTC=0;                 AC_SUBST([GNULIB_PUTC])
  GNULIB_PUTCHAR=0;              AC_SUBST([GNULIB_PUTCHAR])
  GNULIB_PUTS=0;                 AC_SUBST([GNULIB_PUTS])
  GNULIB_REMOVE=0;               AC_SUBST([GNULIB_REMOVE])
  GNULIB_RENAME=0;               AC_SUBST([GNULIB_RENAME])
  GNULIB_RENAMEAT=0;             AC_SUBST([GNULIB_RENAMEAT])
  GNULIB_SCANF=0;                AC_SUBST([GNULIB_SCANF])
  GNULIB_SNPRINTF=0;             AC_SUBST([GNULIB_SNPRINTF])
  GNULIB_SPRINTF_POSIX=0;        AC_SUBST([GNULIB_SPRINTF_POSIX])
  GNULIB_STDIO_H_NONBLOCKING=0;  AC_SUBST([GNULIB_STDIO_H_NONBLOCKING])
  GNULIB_STDIO_H_SIGPIPE=0;      AC_SUBST([GNULIB_STDIO_H_SIGPIPE])
  GNULIB_TMPFILE=0;              AC_SUBST([GNULIB_TMPFILE])
  GNULIB_VASPRINTF=0;            AC_SUBST([GNULIB_VASPRINTF])
  GNULIB_VFSCANF=0;              AC_SUBST([GNULIB_VFSCANF])
  GNULIB_VSCANF=0;               AC_SUBST([GNULIB_VSCANF])
  GNULIB_VDPRINTF=0;             AC_SUBST([GNULIB_VDPRINTF])
  GNULIB_VFPRINTF=0;             AC_SUBST([GNULIB_VFPRINTF])
  GNULIB_VFPRINTF_POSIX=0;       AC_SUBST([GNULIB_VFPRINTF_POSIX])
  GNULIB_VPRINTF=0;              AC_SUBST([GNULIB_VPRINTF])
  GNULIB_VPRINTF_POSIX=0;        AC_SUBST([GNULIB_VPRINTF_POSIX])
  GNULIB_VSNPRINTF=0;            AC_SUBST([GNULIB_VSNPRINTF])
  GNULIB_VSPRINTF_POSIX=0;       AC_SUBST([GNULIB_VSPRINTF_POSIX])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_DECL_FPURGE=1;            AC_SUBST([HAVE_DECL_FPURGE])
  HAVE_DECL_FSEEKO=1;            AC_SUBST([HAVE_DECL_FSEEKO])
  HAVE_DECL_FTELLO=1;            AC_SUBST([HAVE_DECL_FTELLO])
  HAVE_DECL_GETDELIM=1;          AC_SUBST([HAVE_DECL_GETDELIM])
  HAVE_DECL_GETLINE=1;           AC_SUBST([HAVE_DECL_GETLINE])
  HAVE_DECL_OBSTACK_PRINTF=1;    AC_SUBST([HAVE_DECL_OBSTACK_PRINTF])
  HAVE_DECL_SNPRINTF=1;          AC_SUBST([HAVE_DECL_SNPRINTF])
  HAVE_DECL_VSNPRINTF=1;         AC_SUBST([HAVE_DECL_VSNPRINTF])
  HAVE_DPRINTF=1;                AC_SUBST([HAVE_DPRINTF])
  HAVE_FSEEKO=1;                 AC_SUBST([HAVE_FSEEKO])
  HAVE_FTELLO=1;                 AC_SUBST([HAVE_FTELLO])
  HAVE_PCLOSE=1;                 AC_SUBST([HAVE_PCLOSE])
  HAVE_POPEN=1;                  AC_SUBST([HAVE_POPEN])
  HAVE_RENAMEAT=1;               AC_SUBST([HAVE_RENAMEAT])
  HAVE_VASPRINTF=1;              AC_SUBST([HAVE_VASPRINTF])
  HAVE_VDPRINTF=1;               AC_SUBST([HAVE_VDPRINTF])
  REPLACE_DPRINTF=0;             AC_SUBST([REPLACE_DPRINTF])
  REPLACE_FCLOSE=0;              AC_SUBST([REPLACE_FCLOSE])
  REPLACE_FDOPEN=0;              AC_SUBST([REPLACE_FDOPEN])
  REPLACE_FFLUSH=0;              AC_SUBST([REPLACE_FFLUSH])
  REPLACE_FOPEN=0;               AC_SUBST([REPLACE_FOPEN])
  REPLACE_FPRINTF=0;             AC_SUBST([REPLACE_FPRINTF])
  REPLACE_FPURGE=0;              AC_SUBST([REPLACE_FPURGE])
  REPLACE_FREOPEN=0;             AC_SUBST([REPLACE_FREOPEN])
  REPLACE_FSEEK=0;               AC_SUBST([REPLACE_FSEEK])
  REPLACE_FSEEKO=0;              AC_SUBST([REPLACE_FSEEKO])
  REPLACE_FTELL=0;               AC_SUBST([REPLACE_FTELL])
  REPLACE_FTELLO=0;              AC_SUBST([REPLACE_FTELLO])
  REPLACE_GETDELIM=0;            AC_SUBST([REPLACE_GETDELIM])
  REPLACE_GETLINE=0;             AC_SUBST([REPLACE_GETLINE])
  REPLACE_OBSTACK_PRINTF=0;      AC_SUBST([REPLACE_OBSTACK_PRINTF])
  REPLACE_PERROR=0;              AC_SUBST([REPLACE_PERROR])
  REPLACE_POPEN=0;               AC_SUBST([REPLACE_POPEN])
  REPLACE_PRINTF=0;              AC_SUBST([REPLACE_PRINTF])
  REPLACE_REMOVE=0;              AC_SUBST([REPLACE_REMOVE])
  REPLACE_RENAME=0;              AC_SUBST([REPLACE_RENAME])
  REPLACE_RENAMEAT=0;            AC_SUBST([REPLACE_RENAMEAT])
  REPLACE_SNPRINTF=0;            AC_SUBST([REPLACE_SNPRINTF])
  REPLACE_SPRINTF=0;             AC_SUBST([REPLACE_SPRINTF])
  REPLACE_STDIO_READ_FUNCS=0;    AC_SUBST([REPLACE_STDIO_READ_FUNCS])
  REPLACE_STDIO_WRITE_FUNCS=0;   AC_SUBST([REPLACE_STDIO_WRITE_FUNCS])
  REPLACE_TMPFILE=0;             AC_SUBST([REPLACE_TMPFILE])
  REPLACE_VASPRINTF=0;           AC_SUBST([REPLACE_VASPRINTF])
  REPLACE_VDPRINTF=0;            AC_SUBST([REPLACE_VDPRINTF])
  REPLACE_VFPRINTF=0;            AC_SUBST([REPLACE_VFPRINTF])
  REPLACE_VPRINTF=0;             AC_SUBST([REPLACE_VPRINTF])
  REPLACE_VSNPRINTF=0;           AC_SUBST([REPLACE_VSNPRINTF])
  REPLACE_VSPRINTF=0;            AC_SUBST([REPLACE_VSPRINTF])
])

# stdlib_h.m4 serial 44
dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_STDLIB_H],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  gl_NEXT_HEADERS([stdlib.h])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use, and which is not
  dnl guaranteed by C89.
  gl_WARN_ON_USE_PREPARE([[#include <stdlib.h>
#if HAVE_SYS_LOADAVG_H
# include <sys/loadavg.h>
#endif
#if HAVE_RANDOM_H
# include <random.h>
#endif
    ]], [_Exit atoll canonicalize_file_name getloadavg getsubopt grantpt
    initstate initstate_r mkdtemp mkostemp mkostemps mkstemp mkstemps
    posix_openpt ptsname ptsname_r qsort_r random random_r reallocarray
    realpath rpmatch secure_getenv setenv setstate setstate_r srandom
    srandom_r strtod strtoll strtoull unlockpt unsetenv])
])

AC_DEFUN([gl_STDLIB_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_STDLIB_H_DEFAULTS],
[
  GNULIB__EXIT=0;         AC_SUBST([GNULIB__EXIT])
  GNULIB_ATOLL=0;         AC_SUBST([GNULIB_ATOLL])
  GNULIB_CALLOC_POSIX=0;  AC_SUBST([GNULIB_CALLOC_POSIX])
  GNULIB_CANONICALIZE_FILE_NAME=0;  AC_SUBST([GNULIB_CANONICALIZE_FILE_NAME])
  GNULIB_GETLOADAVG=0;    AC_SUBST([GNULIB_GETLOADAVG])
  GNULIB_GETSUBOPT=0;     AC_SUBST([GNULIB_GETSUBOPT])
  GNULIB_GRANTPT=0;       AC_SUBST([GNULIB_GRANTPT])
  GNULIB_MALLOC_POSIX=0;  AC_SUBST([GNULIB_MALLOC_POSIX])
  GNULIB_MBTOWC=0;        AC_SUBST([GNULIB_MBTOWC])
  GNULIB_MKDTEMP=0;       AC_SUBST([GNULIB_MKDTEMP])
  GNULIB_MKOSTEMP=0;      AC_SUBST([GNULIB_MKOSTEMP])
  GNULIB_MKOSTEMPS=0;     AC_SUBST([GNULIB_MKOSTEMPS])
  GNULIB_MKSTEMP=0;       AC_SUBST([GNULIB_MKSTEMP])
  GNULIB_MKSTEMPS=0;      AC_SUBST([GNULIB_MKSTEMPS])
  GNULIB_POSIX_OPENPT=0;  AC_SUBST([GNULIB_POSIX_OPENPT])
  GNULIB_PTSNAME=0;       AC_SUBST([GNULIB_PTSNAME])
  GNULIB_PTSNAME_R=0;     AC_SUBST([GNULIB_PTSNAME_R])
  GNULIB_PUTENV=0;        AC_SUBST([GNULIB_PUTENV])
  GNULIB_QSORT_R=0;       AC_SUBST([GNULIB_QSORT_R])
  GNULIB_RANDOM=0;        AC_SUBST([GNULIB_RANDOM])
  GNULIB_RANDOM_R=0;      AC_SUBST([GNULIB_RANDOM_R])
  GNULIB_REALLOCARRAY=0;  AC_SUBST([GNULIB_REALLOCARRAY])
  GNULIB_REALLOC_POSIX=0; AC_SUBST([GNULIB_REALLOC_POSIX])
  GNULIB_REALPATH=0;      AC_SUBST([GNULIB_REALPATH])
  GNULIB_RPMATCH=0;       AC_SUBST([GNULIB_RPMATCH])
  GNULIB_SECURE_GETENV=0; AC_SUBST([GNULIB_SECURE_GETENV])
  GNULIB_SETENV=0;        AC_SUBST([GNULIB_SETENV])
  GNULIB_STRTOD=0;        AC_SUBST([GNULIB_STRTOD])
  GNULIB_STRTOLL=0;       AC_SUBST([GNULIB_STRTOLL])
  GNULIB_STRTOULL=0;      AC_SUBST([GNULIB_STRTOULL])
  GNULIB_SYSTEM_POSIX=0;  AC_SUBST([GNULIB_SYSTEM_POSIX])
  GNULIB_UNLOCKPT=0;      AC_SUBST([GNULIB_UNLOCKPT])
  GNULIB_UNSETENV=0;      AC_SUBST([GNULIB_UNSETENV])
  GNULIB_WCTOMB=0;        AC_SUBST([GNULIB_WCTOMB])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE__EXIT=1;              AC_SUBST([HAVE__EXIT])
  HAVE_ATOLL=1;              AC_SUBST([HAVE_ATOLL])
  HAVE_CANONICALIZE_FILE_NAME=1;  AC_SUBST([HAVE_CANONICALIZE_FILE_NAME])
  HAVE_DECL_GETLOADAVG=1;    AC_SUBST([HAVE_DECL_GETLOADAVG])
  HAVE_GETSUBOPT=1;          AC_SUBST([HAVE_GETSUBOPT])
  HAVE_GRANTPT=1;            AC_SUBST([HAVE_GRANTPT])
  HAVE_DECL_INITSTATE=1;     AC_SUBST([HAVE_DECL_INITSTATE])
  HAVE_MKDTEMP=1;            AC_SUBST([HAVE_MKDTEMP])
  HAVE_MKOSTEMP=1;           AC_SUBST([HAVE_MKOSTEMP])
  HAVE_MKOSTEMPS=1;          AC_SUBST([HAVE_MKOSTEMPS])
  HAVE_MKSTEMP=1;            AC_SUBST([HAVE_MKSTEMP])
  HAVE_MKSTEMPS=1;           AC_SUBST([HAVE_MKSTEMPS])
  HAVE_POSIX_OPENPT=1;       AC_SUBST([HAVE_POSIX_OPENPT])
  HAVE_PTSNAME=1;            AC_SUBST([HAVE_PTSNAME])
  HAVE_PTSNAME_R=1;          AC_SUBST([HAVE_PTSNAME_R])
  HAVE_QSORT_R=1;            AC_SUBST([HAVE_QSORT_R])
  HAVE_RANDOM=1;             AC_SUBST([HAVE_RANDOM])
  HAVE_RANDOM_H=1;           AC_SUBST([HAVE_RANDOM_H])
  HAVE_RANDOM_R=1;           AC_SUBST([HAVE_RANDOM_R])
  HAVE_REALLOCARRAY=1;       AC_SUBST([HAVE_REALLOCARRAY])
  HAVE_REALPATH=1;           AC_SUBST([HAVE_REALPATH])
  HAVE_RPMATCH=1;            AC_SUBST([HAVE_RPMATCH])
  HAVE_SECURE_GETENV=1;      AC_SUBST([HAVE_SECURE_GETENV])
  HAVE_SETENV=1;             AC_SUBST([HAVE_SETENV])
  HAVE_DECL_SETENV=1;        AC_SUBST([HAVE_DECL_SETENV])
  HAVE_DECL_SETSTATE=1;      AC_SUBST([HAVE_DECL_SETSTATE])
  HAVE_STRTOD=1;             AC_SUBST([HAVE_STRTOD])
  HAVE_STRTOLL=1;            AC_SUBST([HAVE_STRTOLL])
  HAVE_STRTOULL=1;           AC_SUBST([HAVE_STRTOULL])
  HAVE_STRUCT_RANDOM_DATA=1; AC_SUBST([HAVE_STRUCT_RANDOM_DATA])
  HAVE_SYS_LOADAVG_H=0;      AC_SUBST([HAVE_SYS_LOADAVG_H])
  HAVE_UNLOCKPT=1;           AC_SUBST([HAVE_UNLOCKPT])
  HAVE_DECL_UNSETENV=1;      AC_SUBST([HAVE_DECL_UNSETENV])
  REPLACE_CALLOC=0;          AC_SUBST([REPLACE_CALLOC])
  REPLACE_CANONICALIZE_FILE_NAME=0;  AC_SUBST([REPLACE_CANONICALIZE_FILE_NAME])
  REPLACE_MALLOC=0;          AC_SUBST([REPLACE_MALLOC])
  REPLACE_MBTOWC=0;          AC_SUBST([REPLACE_MBTOWC])
  REPLACE_MKSTEMP=0;         AC_SUBST([REPLACE_MKSTEMP])
  REPLACE_PTSNAME=0;         AC_SUBST([REPLACE_PTSNAME])
  REPLACE_PTSNAME_R=0;       AC_SUBST([REPLACE_PTSNAME_R])
  REPLACE_PUTENV=0;          AC_SUBST([REPLACE_PUTENV])
  REPLACE_QSORT_R=0;         AC_SUBST([REPLACE_QSORT_R])
  REPLACE_RANDOM_R=0;        AC_SUBST([REPLACE_RANDOM_R])
  REPLACE_REALLOC=0;         AC_SUBST([REPLACE_REALLOC])
  REPLACE_REALPATH=0;        AC_SUBST([REPLACE_REALPATH])
  REPLACE_SETENV=0;          AC_SUBST([REPLACE_SETENV])
  REPLACE_STRTOD=0;          AC_SUBST([REPLACE_STRTOD])
  REPLACE_UNSETENV=0;        AC_SUBST([REPLACE_UNSETENV])
  REPLACE_WCTOMB=0;          AC_SUBST([REPLACE_WCTOMB])
])

# strdup.m4 serial 13

dnl Copyright (C) 2002-2018 Free Software Foundation, Inc.

dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STRDUP],
[
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([strdup])
  AC_CHECK_DECLS_ONCE([strdup])
  if test $ac_cv_have_decl_strdup = no; then
    HAVE_DECL_STRDUP=0
  fi
])

AC_DEFUN([gl_FUNC_STRDUP_POSIX],
[
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_REQUIRE([gl_CHECK_MALLOC_POSIX])
  AC_CHECK_FUNCS_ONCE([strdup])
  if test $ac_cv_func_strdup = yes; then
    if test $gl_cv_func_malloc_posix != yes; then
      REPLACE_STRDUP=1
    fi
  fi
  AC_CHECK_DECLS_ONCE([strdup])
  if test $ac_cv_have_decl_strdup = no; then
    HAVE_DECL_STRDUP=0
  fi
])

# Prerequisites of lib/strdup.c.
AC_DEFUN([gl_PREREQ_STRDUP], [:])

# strerror.m4 serial 19
dnl Copyright (C) 2002, 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STRERROR],
[
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_REQUIRE([gl_HEADER_ERRNO_H])
  AC_REQUIRE([gl_FUNC_STRERROR_0])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  m4_ifdef([gl_FUNC_STRERROR_R_WORKS], [
    AC_REQUIRE([gl_FUNC_STRERROR_R_WORKS])
  ])
  if test "$ERRNO_H:$REPLACE_STRERROR_0" = :0; then
    AC_CACHE_CHECK([for working strerror function],
     [gl_cv_func_working_strerror],
     [AC_RUN_IFELSE(
        [AC_LANG_PROGRAM(
           [[#include <string.h>
           ]],
           [[if (!*strerror (-2)) return 1;]])],
        [gl_cv_func_working_strerror=yes],
        [gl_cv_func_working_strerror=no],
        [case "$host_os" in
                          # Guess yes on glibc systems.
           *-gnu* | gnu*) gl_cv_func_working_strerror="guessing yes" ;;
                          # If we don't know, assume the worst.
           *)             gl_cv_func_working_strerror="guessing no" ;;
         esac
        ])
    ])
    case "$gl_cv_func_working_strerror" in
      *yes) ;;
      *)
        dnl The system's strerror() fails to return a string for out-of-range
        dnl integers. Replace it.
        REPLACE_STRERROR=1
        ;;
    esac
    m4_ifdef([gl_FUNC_STRERROR_R_WORKS], [
      dnl If the system's strerror_r or __xpg_strerror_r clobbers strerror's
      dnl buffer, we must replace strerror.
      case "$gl_cv_func_strerror_r_works" in
        *no) REPLACE_STRERROR=1 ;;
      esac
    ])
  else
    dnl The system's strerror() cannot know about the new errno values we add
    dnl to <errno.h>, or any fix for strerror(0). Replace it.
    REPLACE_STRERROR=1
  fi
])

dnl Detect if strerror(0) passes (that is, does not set errno, and does not
dnl return a string that matches strerror(-1)).
AC_DEFUN([gl_FUNC_STRERROR_0],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  REPLACE_STRERROR_0=0
  AC_CACHE_CHECK([whether strerror(0) succeeds],
   [gl_cv_func_strerror_0_works],
   [AC_RUN_IFELSE(
      [AC_LANG_PROGRAM(
         [[#include <string.h>
           #include <errno.h>
         ]],
         [[int result = 0;
           char *str;
           errno = 0;
           str = strerror (0);
           if (!*str) result |= 1;
           if (errno) result |= 2;
           if (strstr (str, "nknown") || strstr (str, "ndefined"))
             result |= 4;
           return result;]])],
      [gl_cv_func_strerror_0_works=yes],
      [gl_cv_func_strerror_0_works=no],
      [case "$host_os" in
                        # Guess yes on glibc systems.
         *-gnu* | gnu*) gl_cv_func_strerror_0_works="guessing yes" ;;
                        # Guess yes on native Windows.
         mingw*)        gl_cv_func_strerror_0_works="guessing yes" ;;
                        # If we don't know, assume the worst.
         *)             gl_cv_func_strerror_0_works="guessing no" ;;
       esac
      ])
  ])
  case "$gl_cv_func_strerror_0_works" in
    *yes) ;;
    *)
      REPLACE_STRERROR_0=1
      AC_DEFINE([REPLACE_STRERROR_0], [1], [Define to 1 if strerror(0)
        does not return a message implying success.])
      ;;
  esac
])

# Configure a GNU-like replacement for <string.h>.

# Copyright (C) 2007-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 22

# Written by Paul Eggert.

AC_DEFUN([gl_HEADER_STRING_H],
[
  dnl Use AC_REQUIRE here, so that the default behavior below is expanded
  dnl once only, before all statements that occur in other macros.
  AC_REQUIRE([gl_HEADER_STRING_H_BODY])
])

AC_DEFUN([gl_HEADER_STRING_H_BODY],
[
  AC_REQUIRE([AC_C_RESTRICT])
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  gl_NEXT_HEADERS([string.h])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use, and which is not
  dnl guaranteed by C89.
  gl_WARN_ON_USE_PREPARE([[#include <string.h>
    ]],
    [ffsl ffsll memmem mempcpy memrchr rawmemchr stpcpy stpncpy strchrnul
     strdup strncat strndup strnlen strpbrk strsep strcasestr strtok_r
     strerror_r strsignal strverscmp])
])

AC_DEFUN([gl_STRING_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_HEADER_STRING_H_DEFAULTS],
[
  GNULIB_EXPLICIT_BZERO=0; AC_SUBST([GNULIB_EXPLICIT_BZERO])
  GNULIB_FFSL=0;        AC_SUBST([GNULIB_FFSL])
  GNULIB_FFSLL=0;       AC_SUBST([GNULIB_FFSLL])
  GNULIB_MEMCHR=0;      AC_SUBST([GNULIB_MEMCHR])
  GNULIB_MEMMEM=0;      AC_SUBST([GNULIB_MEMMEM])
  GNULIB_MEMPCPY=0;     AC_SUBST([GNULIB_MEMPCPY])
  GNULIB_MEMRCHR=0;     AC_SUBST([GNULIB_MEMRCHR])
  GNULIB_RAWMEMCHR=0;   AC_SUBST([GNULIB_RAWMEMCHR])
  GNULIB_STPCPY=0;      AC_SUBST([GNULIB_STPCPY])
  GNULIB_STPNCPY=0;     AC_SUBST([GNULIB_STPNCPY])
  GNULIB_STRCHRNUL=0;   AC_SUBST([GNULIB_STRCHRNUL])
  GNULIB_STRDUP=0;      AC_SUBST([GNULIB_STRDUP])
  GNULIB_STRNCAT=0;     AC_SUBST([GNULIB_STRNCAT])
  GNULIB_STRNDUP=0;     AC_SUBST([GNULIB_STRNDUP])
  GNULIB_STRNLEN=0;     AC_SUBST([GNULIB_STRNLEN])
  GNULIB_STRPBRK=0;     AC_SUBST([GNULIB_STRPBRK])
  GNULIB_STRSEP=0;      AC_SUBST([GNULIB_STRSEP])
  GNULIB_STRSTR=0;      AC_SUBST([GNULIB_STRSTR])
  GNULIB_STRCASESTR=0;  AC_SUBST([GNULIB_STRCASESTR])
  GNULIB_STRTOK_R=0;    AC_SUBST([GNULIB_STRTOK_R])
  GNULIB_MBSLEN=0;      AC_SUBST([GNULIB_MBSLEN])
  GNULIB_MBSNLEN=0;     AC_SUBST([GNULIB_MBSNLEN])
  GNULIB_MBSCHR=0;      AC_SUBST([GNULIB_MBSCHR])
  GNULIB_MBSRCHR=0;     AC_SUBST([GNULIB_MBSRCHR])
  GNULIB_MBSSTR=0;      AC_SUBST([GNULIB_MBSSTR])
  GNULIB_MBSCASECMP=0;  AC_SUBST([GNULIB_MBSCASECMP])
  GNULIB_MBSNCASECMP=0; AC_SUBST([GNULIB_MBSNCASECMP])
  GNULIB_MBSPCASECMP=0; AC_SUBST([GNULIB_MBSPCASECMP])
  GNULIB_MBSCASESTR=0;  AC_SUBST([GNULIB_MBSCASESTR])
  GNULIB_MBSCSPN=0;     AC_SUBST([GNULIB_MBSCSPN])
  GNULIB_MBSPBRK=0;     AC_SUBST([GNULIB_MBSPBRK])
  GNULIB_MBSSPN=0;      AC_SUBST([GNULIB_MBSSPN])
  GNULIB_MBSSEP=0;      AC_SUBST([GNULIB_MBSSEP])
  GNULIB_MBSTOK_R=0;    AC_SUBST([GNULIB_MBSTOK_R])
  GNULIB_STRERROR=0;    AC_SUBST([GNULIB_STRERROR])
  GNULIB_STRERROR_R=0;  AC_SUBST([GNULIB_STRERROR_R])
  GNULIB_STRSIGNAL=0;   AC_SUBST([GNULIB_STRSIGNAL])
  GNULIB_STRVERSCMP=0;  AC_SUBST([GNULIB_STRVERSCMP])
  HAVE_MBSLEN=0;        AC_SUBST([HAVE_MBSLEN])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_EXPLICIT_BZERO=1;        AC_SUBST([HAVE_EXPLICIT_BZERO])
  HAVE_FFSL=1;                  AC_SUBST([HAVE_FFSL])
  HAVE_FFSLL=1;                 AC_SUBST([HAVE_FFSLL])
  HAVE_MEMCHR=1;                AC_SUBST([HAVE_MEMCHR])
  HAVE_DECL_MEMMEM=1;           AC_SUBST([HAVE_DECL_MEMMEM])
  HAVE_MEMPCPY=1;               AC_SUBST([HAVE_MEMPCPY])
  HAVE_DECL_MEMRCHR=1;          AC_SUBST([HAVE_DECL_MEMRCHR])
  HAVE_RAWMEMCHR=1;             AC_SUBST([HAVE_RAWMEMCHR])
  HAVE_STPCPY=1;                AC_SUBST([HAVE_STPCPY])
  HAVE_STPNCPY=1;               AC_SUBST([HAVE_STPNCPY])
  HAVE_STRCHRNUL=1;             AC_SUBST([HAVE_STRCHRNUL])
  HAVE_DECL_STRDUP=1;           AC_SUBST([HAVE_DECL_STRDUP])
  HAVE_DECL_STRNDUP=1;          AC_SUBST([HAVE_DECL_STRNDUP])
  HAVE_DECL_STRNLEN=1;          AC_SUBST([HAVE_DECL_STRNLEN])
  HAVE_STRPBRK=1;               AC_SUBST([HAVE_STRPBRK])
  HAVE_STRSEP=1;                AC_SUBST([HAVE_STRSEP])
  HAVE_STRCASESTR=1;            AC_SUBST([HAVE_STRCASESTR])
  HAVE_DECL_STRTOK_R=1;         AC_SUBST([HAVE_DECL_STRTOK_R])
  HAVE_DECL_STRERROR_R=1;       AC_SUBST([HAVE_DECL_STRERROR_R])
  HAVE_DECL_STRSIGNAL=1;        AC_SUBST([HAVE_DECL_STRSIGNAL])
  HAVE_STRVERSCMP=1;            AC_SUBST([HAVE_STRVERSCMP])
  REPLACE_MEMCHR=0;             AC_SUBST([REPLACE_MEMCHR])
  REPLACE_MEMMEM=0;             AC_SUBST([REPLACE_MEMMEM])
  REPLACE_STPNCPY=0;            AC_SUBST([REPLACE_STPNCPY])
  REPLACE_STRCHRNUL=0;          AC_SUBST([REPLACE_STRCHRNUL])
  REPLACE_STRDUP=0;             AC_SUBST([REPLACE_STRDUP])
  REPLACE_STRNCAT=0;            AC_SUBST([REPLACE_STRNCAT])
  REPLACE_STRNDUP=0;            AC_SUBST([REPLACE_STRNDUP])
  REPLACE_STRNLEN=0;            AC_SUBST([REPLACE_STRNLEN])
  REPLACE_STRSTR=0;             AC_SUBST([REPLACE_STRSTR])
  REPLACE_STRCASESTR=0;         AC_SUBST([REPLACE_STRCASESTR])
  REPLACE_STRTOK_R=0;           AC_SUBST([REPLACE_STRTOK_R])
  REPLACE_STRERROR=0;           AC_SUBST([REPLACE_STRERROR])
  REPLACE_STRERROR_R=0;         AC_SUBST([REPLACE_STRERROR_R])
  REPLACE_STRSIGNAL=0;          AC_SUBST([REPLACE_STRSIGNAL])
  UNDEFINE_STRTOK_R=0;          AC_SUBST([UNDEFINE_STRTOK_R])
])

# strndup.m4 serial 22
dnl Copyright (C) 2002-2003, 2005-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STRNDUP],
[
  dnl Persuade glibc <string.h> to declare strndup().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])
  AC_CHECK_DECLS_ONCE([strndup])
  AC_CHECK_FUNCS_ONCE([strndup])
  if test $ac_cv_have_decl_strndup = no; then
    HAVE_DECL_STRNDUP=0
  fi

  if test $ac_cv_func_strndup = yes; then
    HAVE_STRNDUP=1
    # AIX 4.3.3, AIX 5.1 have a function that fails to add the terminating '\0'.
    AC_CACHE_CHECK([for working strndup], [gl_cv_func_strndup_works],
      [AC_RUN_IFELSE([
         AC_LANG_PROGRAM([[#include <string.h>
                           #include <stdlib.h>]], [[
#if !HAVE_DECL_STRNDUP
  extern
  #ifdef __cplusplus
  "C"
  #endif
  char *strndup (const char *, size_t);
#endif
  int result;
  char *s;
  s = strndup ("some longer string", 15);
  free (s);
  s = strndup ("shorter string", 13);
  result = s[13] != '\0';
  free (s);
  return result;]])],
         [gl_cv_func_strndup_works=yes],
         [gl_cv_func_strndup_works=no],
         [
changequote(,)dnl
          case $host_os in
            aix | aix[3-6]*) gl_cv_func_strndup_works="guessing no";;
            *)               gl_cv_func_strndup_works="guessing yes";;
          esac
changequote([,])dnl
         ])])
    case $gl_cv_func_strndup_works in
      *no) REPLACE_STRNDUP=1 ;;
    esac
  else
    HAVE_STRNDUP=0
  fi
])

# strnlen.m4 serial 13
dnl Copyright (C) 2002-2003, 2005-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_STRNLEN],
[
  AC_REQUIRE([gl_HEADER_STRING_H_DEFAULTS])

  dnl Persuade glibc <string.h> to declare strnlen().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  AC_CHECK_DECLS_ONCE([strnlen])
  if test $ac_cv_have_decl_strnlen = no; then
    HAVE_DECL_STRNLEN=0
  else
    m4_pushdef([AC_LIBOBJ], [:])
    dnl Note: AC_FUNC_STRNLEN does AC_LIBOBJ([strnlen]).
    AC_FUNC_STRNLEN
    m4_popdef([AC_LIBOBJ])
    if test $ac_cv_func_strnlen_working = no; then
      REPLACE_STRNLEN=1
    fi
  fi
])

# Prerequisites of lib/strnlen.c.
AC_DEFUN([gl_PREREQ_STRNLEN], [:])

# serial 7
# See if we need to provide symlink replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_SYMLINK],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_FUNCS_ONCE([symlink])
  dnl The best we can do on mingw is provide a dummy that always fails, so
  dnl that compilation can proceed with fewer ifdefs.  On FreeBSD 7.2, AIX 7.1,
  dnl and Solaris 9, we want to fix a bug with trailing slash handling.
  if test $ac_cv_func_symlink = no; then
    HAVE_SYMLINK=0
  else
    AC_CACHE_CHECK([whether symlink handles trailing slash correctly],
      [gl_cv_func_symlink_works],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
           ]],
           [[int result = 0;
             if (!symlink ("a", "conftest.link/"))
               result |= 1;
             if (symlink ("conftest.f", "conftest.lnk2"))
               result |= 2;
             else if (!symlink ("a", "conftest.lnk2/"))
               result |= 4;
             return result;
           ]])],
         [gl_cv_func_symlink_works=yes], [gl_cv_func_symlink_works=no],
         [case "$host_os" in
                           # Guess yes on glibc systems.
            *-gnu* | gnu*) gl_cv_func_symlink_works="guessing yes" ;;
                           # If we don't know, assume the worst.
            *)             gl_cv_func_symlink_works="guessing no" ;;
          esac
         ])
      rm -f conftest.f conftest.link conftest.lnk2])
    case "$gl_cv_func_symlink_works" in
      *yes) ;;
      *)
        REPLACE_SYMLINK=1
        ;;
    esac
  fi
])

# serial 8
# See if we need to provide symlinkat replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_SYMLINKAT],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_OPENAT])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_FUNCS_ONCE([symlinkat])
  if test $ac_cv_func_symlinkat = no; then
    HAVE_SYMLINKAT=0
  else
    AC_CACHE_CHECK([whether symlinkat handles trailing slash correctly],
      [gl_cv_func_symlinkat_works],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <fcntl.h>
             #include <unistd.h>
           ]],
           [[int result = 0;
             if (!symlinkat ("a", AT_FDCWD, "conftest.link/"))
               result |= 1;
             if (symlinkat ("conftest.f", AT_FDCWD, "conftest.lnk2"))
               result |= 2;
             else if (!symlinkat ("a", AT_FDCWD, "conftest.lnk2/"))
               result |= 4;
             return result;
           ]])],
         [gl_cv_func_symlinkat_works=yes],
         [gl_cv_func_symlinkat_works=no],
         [case "$host_os" in
                           # Guess yes on glibc systems.
            *-gnu* | gnu*) gl_cv_func_symlinkat_works="guessing yes" ;;
                           # If we don't know, assume the worst.
            *)             gl_cv_func_symlinkat_works="guessing no" ;;
          esac
         ])
      rm -f conftest.f conftest.link conftest.lnk2])
    case "$gl_cv_func_symlinkat_works" in
      *yes) ;;
      *)
        REPLACE_SYMLINKAT=1
        ;;
    esac
  fi
])

# sys_socket_h.m4 serial 23
dnl Copyright (C) 2005-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Simon Josefsson.

AC_DEFUN([gl_HEADER_SYS_SOCKET],
[
  AC_REQUIRE([gl_SYS_SOCKET_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])

  dnl On OSF/1, the functions recv(), send(), recvfrom(), sendto() have
  dnl old-style declarations (with return type 'int' instead of 'ssize_t')
  dnl unless _POSIX_PII_SOCKET is defined.
  case "$host_os" in
    osf*)
      AC_DEFINE([_POSIX_PII_SOCKET], [1],
        [Define to 1 in order to get the POSIX compatible declarations
         of socket functions.])
      ;;
  esac

  AC_CACHE_CHECK([whether <sys/socket.h> is self-contained],
    [gl_cv_header_sys_socket_h_selfcontained],
    [
      AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/socket.h>]], [[]])],
        [gl_cv_header_sys_socket_h_selfcontained=yes],
        [gl_cv_header_sys_socket_h_selfcontained=no])
    ])
  if test $gl_cv_header_sys_socket_h_selfcontained = yes; then
    dnl If the shutdown function exists, <sys/socket.h> should define
    dnl SHUT_RD, SHUT_WR, SHUT_RDWR.
    AC_CHECK_FUNCS([shutdown])
    if test $ac_cv_func_shutdown = yes; then
      AC_CACHE_CHECK([whether <sys/socket.h> defines the SHUT_* macros],
        [gl_cv_header_sys_socket_h_shut],
        [
          AC_COMPILE_IFELSE(
            [AC_LANG_PROGRAM([[#include <sys/socket.h>]],
               [[int a[] = { SHUT_RD, SHUT_WR, SHUT_RDWR };]])],
            [gl_cv_header_sys_socket_h_shut=yes],
            [gl_cv_header_sys_socket_h_shut=no])
        ])
      if test $gl_cv_header_sys_socket_h_shut = no; then
        SYS_SOCKET_H='sys/socket.h'
      fi
    fi
  fi
  # We need to check for ws2tcpip.h now.
  gl_PREREQ_SYS_H_SOCKET
  AC_CHECK_TYPES([struct sockaddr_storage, sa_family_t],,,[
  /* sys/types.h is not needed according to POSIX, but the
     sys/socket.h in i386-unknown-freebsd4.10 and
     powerpc-apple-darwin5.5 required it. */
#include <sys/types.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#ifdef HAVE_WS2TCPIP_H
#include <ws2tcpip.h>
#endif
])
  if test $ac_cv_type_struct_sockaddr_storage = no; then
    HAVE_STRUCT_SOCKADDR_STORAGE=0
  fi
  if test $ac_cv_type_sa_family_t = no; then
    HAVE_SA_FAMILY_T=0
  fi
  if test $ac_cv_type_struct_sockaddr_storage != no; then
    AC_CHECK_MEMBERS([struct sockaddr_storage.ss_family],
      [],
      [HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY=0],
      [#include <sys/types.h>
       #ifdef HAVE_SYS_SOCKET_H
       #include <sys/socket.h>
       #endif
       #ifdef HAVE_WS2TCPIP_H
       #include <ws2tcpip.h>
       #endif
      ])
  fi
  if test $HAVE_STRUCT_SOCKADDR_STORAGE = 0 || test $HAVE_SA_FAMILY_T = 0 \
     || test $HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY = 0; then
    SYS_SOCKET_H='sys/socket.h'
  fi
  gl_PREREQ_SYS_H_WINSOCK2

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
/* Some systems require prerequisite headers.  */
#include <sys/types.h>
#include <sys/socket.h>
    ]], [socket connect accept bind getpeername getsockname getsockopt
    listen recv send recvfrom sendto setsockopt shutdown accept4])
])

AC_DEFUN([gl_PREREQ_SYS_H_SOCKET],
[
  dnl Check prerequisites of the <sys/socket.h> replacement.
  AC_REQUIRE([gl_CHECK_SOCKET_HEADERS])
  gl_CHECK_NEXT_HEADERS([sys/socket.h])
  if test $ac_cv_header_sys_socket_h = yes; then
    HAVE_SYS_SOCKET_H=1
    HAVE_WS2TCPIP_H=0
  else
    HAVE_SYS_SOCKET_H=0
    if test $ac_cv_header_ws2tcpip_h = yes; then
      HAVE_WS2TCPIP_H=1
    else
      HAVE_WS2TCPIP_H=0
    fi
  fi
  AC_SUBST([HAVE_SYS_SOCKET_H])
  AC_SUBST([HAVE_WS2TCPIP_H])
])

# Common prerequisites of the <sys/socket.h> replacement and of the
# <sys/select.h> replacement.
# Sets and substitutes HAVE_WINSOCK2_H.
AC_DEFUN([gl_PREREQ_SYS_H_WINSOCK2],
[
  m4_ifdef([gl_UNISTD_H_DEFAULTS], [AC_REQUIRE([gl_UNISTD_H_DEFAULTS])])
  m4_ifdef([gl_SYS_IOCTL_H_DEFAULTS], [AC_REQUIRE([gl_SYS_IOCTL_H_DEFAULTS])])
  AC_CHECK_HEADERS_ONCE([sys/socket.h])
  if test $ac_cv_header_sys_socket_h != yes; then
    dnl We cannot use AC_CHECK_HEADERS_ONCE here, because that would make
    dnl the check for those headers unconditional; yet cygwin reports
    dnl that the headers are present but cannot be compiled (since on
    dnl cygwin, all socket information should come from sys/socket.h).
    AC_CHECK_HEADERS([winsock2.h])
  fi
  if test "$ac_cv_header_winsock2_h" = yes; then
    HAVE_WINSOCK2_H=1
    UNISTD_H_HAVE_WINSOCK2_H=1
    SYS_IOCTL_H_HAVE_WINSOCK2_H=1
  else
    HAVE_WINSOCK2_H=0
  fi
  AC_SUBST([HAVE_WINSOCK2_H])
])

AC_DEFUN([gl_SYS_SOCKET_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_SYS_SOCKET_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_SYS_SOCKET_H_DEFAULTS],
[
  GNULIB_SOCKET=0;      AC_SUBST([GNULIB_SOCKET])
  GNULIB_CONNECT=0;     AC_SUBST([GNULIB_CONNECT])
  GNULIB_ACCEPT=0;      AC_SUBST([GNULIB_ACCEPT])
  GNULIB_BIND=0;        AC_SUBST([GNULIB_BIND])
  GNULIB_GETPEERNAME=0; AC_SUBST([GNULIB_GETPEERNAME])
  GNULIB_GETSOCKNAME=0; AC_SUBST([GNULIB_GETSOCKNAME])
  GNULIB_GETSOCKOPT=0;  AC_SUBST([GNULIB_GETSOCKOPT])
  GNULIB_LISTEN=0;      AC_SUBST([GNULIB_LISTEN])
  GNULIB_RECV=0;        AC_SUBST([GNULIB_RECV])
  GNULIB_SEND=0;        AC_SUBST([GNULIB_SEND])
  GNULIB_RECVFROM=0;    AC_SUBST([GNULIB_RECVFROM])
  GNULIB_SENDTO=0;      AC_SUBST([GNULIB_SENDTO])
  GNULIB_SETSOCKOPT=0;  AC_SUBST([GNULIB_SETSOCKOPT])
  GNULIB_SHUTDOWN=0;    AC_SUBST([GNULIB_SHUTDOWN])
  GNULIB_ACCEPT4=0;     AC_SUBST([GNULIB_ACCEPT4])
  HAVE_STRUCT_SOCKADDR_STORAGE=1; AC_SUBST([HAVE_STRUCT_SOCKADDR_STORAGE])
  HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY=1;
                        AC_SUBST([HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY])
  HAVE_SA_FAMILY_T=1;   AC_SUBST([HAVE_SA_FAMILY_T])
  HAVE_ACCEPT4=1;       AC_SUBST([HAVE_ACCEPT4])
])

# sys_stat_h.m4 serial 31   -*- Autoconf -*-
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Eric Blake.
dnl Provide a GNU-like <sys/stat.h>.

AC_DEFUN([gl_HEADER_SYS_STAT_H],
[
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])

  dnl Check for broken stat macros.
  AC_REQUIRE([AC_HEADER_STAT])

  gl_CHECK_NEXT_HEADERS([sys/stat.h])

  dnl Ensure the type mode_t gets defined.
  AC_REQUIRE([AC_TYPE_MODE_T])

  dnl Whether to enable precise timestamps in 'struct stat'.
  m4_ifdef([gl_WINDOWS_STAT_TIMESPEC], [
    AC_REQUIRE([gl_WINDOWS_STAT_TIMESPEC])
  ], [
    WINDOWS_STAT_TIMESPEC=0
  ])
  AC_SUBST([WINDOWS_STAT_TIMESPEC])

  dnl Whether to ensure that struct stat.st_size is 64-bit wide.
  m4_ifdef([gl_LARGEFILE], [
    AC_REQUIRE([gl_LARGEFILE])
  ], [
    WINDOWS_64_BIT_ST_SIZE=0
  ])
  AC_SUBST([WINDOWS_64_BIT_ST_SIZE])

  dnl Define types that are supposed to be defined in <sys/types.h> or
  dnl <sys/stat.h>.
  AC_CHECK_TYPE([nlink_t], [],
    [AC_DEFINE([nlink_t], [int],
       [Define to the type of st_nlink in struct stat, or a supertype.])],
    [#include <sys/types.h>
     #include <sys/stat.h>])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[#include <sys/stat.h>
    ]], [fchmodat fstat fstatat futimens lchmod lstat mkdirat mkfifo mkfifoat
    mknod mknodat stat utimensat])
]) # gl_HEADER_SYS_STAT_H

AC_DEFUN([gl_SYS_STAT_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_SYS_STAT_H_DEFAULTS],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS]) dnl for REPLACE_FCHDIR
  GNULIB_FCHMODAT=0;    AC_SUBST([GNULIB_FCHMODAT])
  GNULIB_FSTAT=0;       AC_SUBST([GNULIB_FSTAT])
  GNULIB_FSTATAT=0;     AC_SUBST([GNULIB_FSTATAT])
  GNULIB_FUTIMENS=0;    AC_SUBST([GNULIB_FUTIMENS])
  GNULIB_LCHMOD=0;      AC_SUBST([GNULIB_LCHMOD])
  GNULIB_LSTAT=0;       AC_SUBST([GNULIB_LSTAT])
  GNULIB_MKDIRAT=0;     AC_SUBST([GNULIB_MKDIRAT])
  GNULIB_MKFIFO=0;      AC_SUBST([GNULIB_MKFIFO])
  GNULIB_MKFIFOAT=0;    AC_SUBST([GNULIB_MKFIFOAT])
  GNULIB_MKNOD=0;       AC_SUBST([GNULIB_MKNOD])
  GNULIB_MKNODAT=0;     AC_SUBST([GNULIB_MKNODAT])
  GNULIB_STAT=0;        AC_SUBST([GNULIB_STAT])
  GNULIB_UTIMENSAT=0;   AC_SUBST([GNULIB_UTIMENSAT])
  GNULIB_OVERRIDES_STRUCT_STAT=0; AC_SUBST([GNULIB_OVERRIDES_STRUCT_STAT])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_FCHMODAT=1;      AC_SUBST([HAVE_FCHMODAT])
  HAVE_FSTATAT=1;       AC_SUBST([HAVE_FSTATAT])
  HAVE_FUTIMENS=1;      AC_SUBST([HAVE_FUTIMENS])
  HAVE_LCHMOD=1;        AC_SUBST([HAVE_LCHMOD])
  HAVE_LSTAT=1;         AC_SUBST([HAVE_LSTAT])
  HAVE_MKDIRAT=1;       AC_SUBST([HAVE_MKDIRAT])
  HAVE_MKFIFO=1;        AC_SUBST([HAVE_MKFIFO])
  HAVE_MKFIFOAT=1;      AC_SUBST([HAVE_MKFIFOAT])
  HAVE_MKNOD=1;         AC_SUBST([HAVE_MKNOD])
  HAVE_MKNODAT=1;       AC_SUBST([HAVE_MKNODAT])
  HAVE_UTIMENSAT=1;     AC_SUBST([HAVE_UTIMENSAT])
  REPLACE_FSTAT=0;      AC_SUBST([REPLACE_FSTAT])
  REPLACE_FSTATAT=0;    AC_SUBST([REPLACE_FSTATAT])
  REPLACE_FUTIMENS=0;   AC_SUBST([REPLACE_FUTIMENS])
  REPLACE_LSTAT=0;      AC_SUBST([REPLACE_LSTAT])
  REPLACE_MKDIR=0;      AC_SUBST([REPLACE_MKDIR])
  REPLACE_MKFIFO=0;     AC_SUBST([REPLACE_MKFIFO])
  REPLACE_MKNOD=0;      AC_SUBST([REPLACE_MKNOD])
  REPLACE_STAT=0;       AC_SUBST([REPLACE_STAT])
  REPLACE_UTIMENSAT=0;  AC_SUBST([REPLACE_UTIMENSAT])
])

# Configure a replacement for <sys/time.h>.
# serial 9

# Copyright (C) 2007, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Written by Paul Eggert and Martin Lambers.

AC_DEFUN([gl_HEADER_SYS_TIME_H],
[
  dnl Use AC_REQUIRE here, so that the REPLACE_GETTIMEOFDAY=0 statement
  dnl below is expanded once only, before all REPLACE_GETTIMEOFDAY=1
  dnl statements that occur in other macros.
  AC_REQUIRE([gl_HEADER_SYS_TIME_H_BODY])
])

AC_DEFUN([gl_HEADER_SYS_TIME_H_BODY],
[
  AC_REQUIRE([AC_C_RESTRICT])
  AC_REQUIRE([gl_HEADER_SYS_TIME_H_DEFAULTS])
  AC_CHECK_HEADERS_ONCE([sys/time.h])
  gl_CHECK_NEXT_HEADERS([sys/time.h])

  if test $ac_cv_header_sys_time_h != yes; then
    HAVE_SYS_TIME_H=0
  fi

  dnl On native Windows with MSVC, 'struct timeval' is defined in <winsock2.h>
  dnl only. So include that header in the list.
  gl_PREREQ_SYS_H_WINSOCK2
  AC_CACHE_CHECK([for struct timeval], [gl_cv_sys_struct_timeval],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#if HAVE_SYS_TIME_H
             #include <sys/time.h>
            #endif
            #include <time.h>
            #if HAVE_WINSOCK2_H
            # include <winsock2.h>
            #endif
          ]],
          [[static struct timeval x; x.tv_sec = x.tv_usec;]])],
       [gl_cv_sys_struct_timeval=yes],
       [gl_cv_sys_struct_timeval=no])
    ])
  if test $gl_cv_sys_struct_timeval != yes; then
    HAVE_STRUCT_TIMEVAL=0
  else
    dnl On native Windows with a 64-bit 'time_t', 'struct timeval' is defined
    dnl (in <sys/time.h> and <winsock2.h> for mingw64, in <winsock2.h> only
    dnl for MSVC) with a tv_sec field of type 'long' (32-bit!), which is
    dnl smaller than the 'time_t' type mandated by POSIX.
    dnl On OpenBSD 5.1 amd64, tv_sec is 64 bits and time_t 32 bits, but
    dnl that is good enough.
    AC_CACHE_CHECK([for wide-enough struct timeval.tv_sec member],
      [gl_cv_sys_struct_timeval_tv_sec],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
            [[#if HAVE_SYS_TIME_H
               #include <sys/time.h>
              #endif
              #include <time.h>
              #if HAVE_WINSOCK2_H
              # include <winsock2.h>
              #endif
            ]],
            [[static struct timeval x;
              typedef int verify_tv_sec_type[
                sizeof (time_t) <= sizeof x.tv_sec ? 1 : -1
              ];
            ]])],
         [gl_cv_sys_struct_timeval_tv_sec=yes],
         [gl_cv_sys_struct_timeval_tv_sec=no])
      ])
    if test $gl_cv_sys_struct_timeval_tv_sec != yes; then
      REPLACE_STRUCT_TIMEVAL=1
    fi
  fi

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
#if HAVE_SYS_TIME_H
# include <sys/time.h>
#endif
#include <time.h>
    ]], [gettimeofday])
])

AC_DEFUN([gl_SYS_TIME_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_HEADER_SYS_TIME_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_HEADER_SYS_TIME_H_DEFAULTS],
[
  GNULIB_GETTIMEOFDAY=0;     AC_SUBST([GNULIB_GETTIMEOFDAY])
  dnl Assume POSIX behavior unless another module says otherwise.
  HAVE_GETTIMEOFDAY=1;       AC_SUBST([HAVE_GETTIMEOFDAY])
  HAVE_STRUCT_TIMEVAL=1;     AC_SUBST([HAVE_STRUCT_TIMEVAL])
  HAVE_SYS_TIME_H=1;         AC_SUBST([HAVE_SYS_TIME_H])
  REPLACE_GETTIMEOFDAY=0;    AC_SUBST([REPLACE_GETTIMEOFDAY])
  REPLACE_STRUCT_TIMEVAL=0;  AC_SUBST([REPLACE_STRUCT_TIMEVAL])
])

# sys_types_h.m4 serial 9
dnl Copyright (C) 2011-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN_ONCE([gl_SYS_TYPES_H],
[
  dnl Use sane struct stat types in OpenVMS 8.2 and later.
  AC_DEFINE([_USE_STD_STAT], 1, [For standard stat data types on VMS.])

  AC_REQUIRE([gl_SYS_TYPES_H_DEFAULTS])
  gl_NEXT_HEADERS([sys/types.h])

  dnl Ensure the type pid_t gets defined.
  AC_REQUIRE([AC_TYPE_PID_T])

  dnl Ensure the type mode_t gets defined.
  AC_REQUIRE([AC_TYPE_MODE_T])

  dnl Whether to override the 'off_t' type.
  AC_REQUIRE([gl_TYPE_OFF_T])

  dnl Whether to override the 'dev_t' and 'ino_t' types.
  m4_ifdef([gl_WINDOWS_STAT_INODES], [
    AC_REQUIRE([gl_WINDOWS_STAT_INODES])
  ], [
    WINDOWS_STAT_INODES=0
  ])
  AC_SUBST([WINDOWS_STAT_INODES])
])

AC_DEFUN([gl_SYS_TYPES_H_DEFAULTS],
[
])

# This works around a buggy version in autoconf <= 2.69.
# See <https://lists.gnu.org/r/autoconf/2016-08/msg00014.html>

m4_version_prereq([2.70], [], [

# This is taken from the following Autoconf patch:
# https://git.savannah.gnu.org/cgit/autoconf.git/commit/?id=e17a30e987d7ee695fb4294a82d987ec3dc9b974

m4_undefine([AC_HEADER_MAJOR])
AC_DEFUN([AC_HEADER_MAJOR],
[AC_CHECK_HEADERS_ONCE([sys/types.h])
AC_CHECK_HEADER([sys/mkdev.h],
  [AC_DEFINE([MAJOR_IN_MKDEV], [1],
    [Define to 1 if `major', `minor', and `makedev' are declared in
     <mkdev.h>.])])
if test $ac_cv_header_sys_mkdev_h = no; then
  AC_CHECK_HEADER([sys/sysmacros.h],
    [AC_DEFINE([MAJOR_IN_SYSMACROS], [1],
      [Define to 1 if `major', `minor', and `makedev' are declared in
       <sysmacros.h>.])])
fi
])

])

#serial 5

# Copyright (C) 2006-2007, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# glibc provides __gen_tempname as a wrapper for mk[ds]temp.  Expose
# it as a public API, and provide it on systems that are lacking.
AC_DEFUN([gl_FUNC_GEN_TEMPNAME],
[
  gl_PREREQ_TEMPNAME
])

# Prerequisites of lib/tempname.c.
AC_DEFUN([gl_PREREQ_TEMPNAME],
[
  :
])

# Configure a more-standard replacement for <time.h>.

# Copyright (C) 2000-2001, 2003-2007, 2009-2018 Free Software Foundation, Inc.

# serial 11

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Written by Paul Eggert and Jim Meyering.

AC_DEFUN([gl_HEADER_TIME_H],
[
  dnl Use AC_REQUIRE here, so that the default behavior below is expanded
  dnl once only, before all statements that occur in other macros.
  AC_REQUIRE([gl_HEADER_TIME_H_BODY])
])

AC_DEFUN([gl_HEADER_TIME_H_BODY],
[
  AC_REQUIRE([AC_C_RESTRICT])
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  gl_NEXT_HEADERS([time.h])
  AC_REQUIRE([gl_CHECK_TYPE_STRUCT_TIMESPEC])
])

dnl Check whether 'struct timespec' is declared
dnl in time.h, sys/time.h, pthread.h, or unistd.h.

AC_DEFUN([gl_CHECK_TYPE_STRUCT_TIMESPEC],
[
  AC_CHECK_HEADERS_ONCE([sys/time.h])
  AC_CACHE_CHECK([for struct timespec in <time.h>],
    [gl_cv_sys_struct_timespec_in_time_h],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <time.h>
          ]],
          [[static struct timespec x; x.tv_sec = x.tv_nsec;]])],
       [gl_cv_sys_struct_timespec_in_time_h=yes],
       [gl_cv_sys_struct_timespec_in_time_h=no])])

  TIME_H_DEFINES_STRUCT_TIMESPEC=0
  SYS_TIME_H_DEFINES_STRUCT_TIMESPEC=0
  PTHREAD_H_DEFINES_STRUCT_TIMESPEC=0
  UNISTD_H_DEFINES_STRUCT_TIMESPEC=0
  if test $gl_cv_sys_struct_timespec_in_time_h = yes; then
    TIME_H_DEFINES_STRUCT_TIMESPEC=1
  else
    AC_CACHE_CHECK([for struct timespec in <sys/time.h>],
      [gl_cv_sys_struct_timespec_in_sys_time_h],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
            [[#include <sys/time.h>
            ]],
            [[static struct timespec x; x.tv_sec = x.tv_nsec;]])],
         [gl_cv_sys_struct_timespec_in_sys_time_h=yes],
         [gl_cv_sys_struct_timespec_in_sys_time_h=no])])
    if test $gl_cv_sys_struct_timespec_in_sys_time_h = yes; then
      SYS_TIME_H_DEFINES_STRUCT_TIMESPEC=1
    else
      AC_CACHE_CHECK([for struct timespec in <pthread.h>],
        [gl_cv_sys_struct_timespec_in_pthread_h],
        [AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM(
              [[#include <pthread.h>
              ]],
              [[static struct timespec x; x.tv_sec = x.tv_nsec;]])],
           [gl_cv_sys_struct_timespec_in_pthread_h=yes],
           [gl_cv_sys_struct_timespec_in_pthread_h=no])])
      if test $gl_cv_sys_struct_timespec_in_pthread_h = yes; then
        PTHREAD_H_DEFINES_STRUCT_TIMESPEC=1
      else
        AC_CACHE_CHECK([for struct timespec in <unistd.h>],
          [gl_cv_sys_struct_timespec_in_unistd_h],
          [AC_COMPILE_IFELSE(
             [AC_LANG_PROGRAM(
                [[#include <unistd.h>
                ]],
                [[static struct timespec x; x.tv_sec = x.tv_nsec;]])],
             [gl_cv_sys_struct_timespec_in_unistd_h=yes],
             [gl_cv_sys_struct_timespec_in_unistd_h=no])])
        if test $gl_cv_sys_struct_timespec_in_unistd_h = yes; then
          UNISTD_H_DEFINES_STRUCT_TIMESPEC=1
        fi
      fi
    fi
  fi
  AC_SUBST([TIME_H_DEFINES_STRUCT_TIMESPEC])
  AC_SUBST([SYS_TIME_H_DEFINES_STRUCT_TIMESPEC])
  AC_SUBST([PTHREAD_H_DEFINES_STRUCT_TIMESPEC])
  AC_SUBST([UNISTD_H_DEFINES_STRUCT_TIMESPEC])
])

AC_DEFUN([gl_TIME_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_HEADER_TIME_H_DEFAULTS],
[
  GNULIB_CTIME=0;                        AC_SUBST([GNULIB_CTIME])
  GNULIB_MKTIME=0;                       AC_SUBST([GNULIB_MKTIME])
  GNULIB_LOCALTIME=0;                    AC_SUBST([GNULIB_LOCALTIME])
  GNULIB_NANOSLEEP=0;                    AC_SUBST([GNULIB_NANOSLEEP])
  GNULIB_STRFTIME=0;                     AC_SUBST([GNULIB_STRFTIME])
  GNULIB_STRPTIME=0;                     AC_SUBST([GNULIB_STRPTIME])
  GNULIB_TIMEGM=0;                       AC_SUBST([GNULIB_TIMEGM])
  GNULIB_TIME_R=0;                       AC_SUBST([GNULIB_TIME_R])
  GNULIB_TIME_RZ=0;                      AC_SUBST([GNULIB_TIME_RZ])
  GNULIB_TZSET=0;                        AC_SUBST([GNULIB_TZSET])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_DECL_LOCALTIME_R=1;               AC_SUBST([HAVE_DECL_LOCALTIME_R])
  HAVE_NANOSLEEP=1;                      AC_SUBST([HAVE_NANOSLEEP])
  HAVE_STRPTIME=1;                       AC_SUBST([HAVE_STRPTIME])
  HAVE_TIMEGM=1;                         AC_SUBST([HAVE_TIMEGM])
  HAVE_TZSET=1;                          AC_SUBST([HAVE_TZSET])
  dnl Even GNU libc does not have timezone_t yet.
  HAVE_TIMEZONE_T=0;                     AC_SUBST([HAVE_TIMEZONE_T])
  dnl If another module says to replace or to not replace, do that.
  dnl Otherwise, replace only if someone compiles with -DGNULIB_PORTCHECK;
  dnl this lets maintainers check for portability.
  REPLACE_CTIME=GNULIB_PORTCHECK;        AC_SUBST([REPLACE_CTIME])
  REPLACE_LOCALTIME_R=GNULIB_PORTCHECK;  AC_SUBST([REPLACE_LOCALTIME_R])
  REPLACE_MKTIME=GNULIB_PORTCHECK;       AC_SUBST([REPLACE_MKTIME])
  REPLACE_NANOSLEEP=GNULIB_PORTCHECK;    AC_SUBST([REPLACE_NANOSLEEP])
  REPLACE_STRFTIME=GNULIB_PORTCHECK;     AC_SUBST([REPLACE_STRFTIME])
  REPLACE_TIMEGM=GNULIB_PORTCHECK;       AC_SUBST([REPLACE_TIMEGM])
  REPLACE_TZSET=GNULIB_PORTCHECK;        AC_SUBST([REPLACE_TZSET])

  dnl Hack so that the time module doesn't depend on the sys_time module.
  dnl First, default GNULIB_GETTIMEOFDAY to 0 if sys_time is absent.
  : ${GNULIB_GETTIMEOFDAY=0};            AC_SUBST([GNULIB_GETTIMEOFDAY])
  dnl Second, it's OK to not use GNULIB_PORTCHECK for REPLACE_GMTIME
  dnl and REPLACE_LOCALTIME, as portability to Solaris 2.6 and earlier
  dnl is no longer a big deal.
  REPLACE_GMTIME=0;                      AC_SUBST([REPLACE_GMTIME])
  REPLACE_LOCALTIME=0;                   AC_SUBST([REPLACE_LOCALTIME])
])

dnl Reentrant time functions: localtime_r, gmtime_r.

dnl Copyright (C) 2003, 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Paul Eggert.

AC_DEFUN([gl_TIME_R],
[
  dnl Persuade glibc and Solaris <time.h> to declare localtime_r.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  AC_REQUIRE([AC_C_RESTRICT])

  dnl Some systems don't declare localtime_r() and gmtime_r() if _REENTRANT is
  dnl not defined.
  AC_CHECK_DECLS([localtime_r], [], [], [[#include <time.h>]])
  if test $ac_cv_have_decl_localtime_r = no; then
    HAVE_DECL_LOCALTIME_R=0
  fi

  AC_CHECK_FUNCS_ONCE([localtime_r])
  if test $ac_cv_func_localtime_r = yes; then
    HAVE_LOCALTIME_R=1
    AC_CACHE_CHECK([whether localtime_r is compatible with its POSIX signature],
      [gl_cv_time_r_posix],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
            [[#include <time.h>]],
            [[/* We don't need to append 'restrict's to the argument types,
                 even though the POSIX signature has the 'restrict's,
                 since C99 says they can't affect type compatibility.  */
              struct tm * (*ptr) (time_t const *, struct tm *) = localtime_r;
              if (ptr) return 0;
              /* Check the return type is a pointer.
                 On HP-UX 10 it is 'int'.  */
              *localtime_r (0, 0);]])
         ],
         [gl_cv_time_r_posix=yes],
         [gl_cv_time_r_posix=no])
      ])
    if test $gl_cv_time_r_posix = yes; then
      REPLACE_LOCALTIME_R=0
    else
      REPLACE_LOCALTIME_R=1
    fi
  else
    HAVE_LOCALTIME_R=0
  fi
])

# Prerequisites of lib/time_r.c.
AC_DEFUN([gl_PREREQ_TIME_R], [
  :
])

dnl Time zone functions: tzalloc, localtime_rz, etc.

dnl Copyright (C) 2015-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Paul Eggert.

AC_DEFUN([gl_TIME_RZ],
[
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  AC_REQUIRE([AC_STRUCT_TIMEZONE])

  AC_CHECK_TYPES([timezone_t], [], [], [[#include <time.h>]])
  if test "$ac_cv_type_timezone_t" = yes; then
    HAVE_TIMEZONE_T=1
  fi
])

# timegm.m4 serial 12
dnl Copyright (C) 2003, 2007, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_TIMEGM],
[
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  AC_REQUIRE([gl_FUNC_MKTIME_WORKS])
  REPLACE_TIMEGM=0
  AC_CHECK_FUNCS_ONCE([timegm])
  if test $ac_cv_func_timegm = yes; then
    if test "$gl_cv_func_working_mktime" != yes; then
      # Assume that timegm is buggy if mktime is.
      REPLACE_TIMEGM=1
    fi
  else
    HAVE_TIMEGM=0
  fi
])

# Prerequisites of lib/timegm.c.
AC_DEFUN([gl_PREREQ_TIMEGM], [
  :
])

#serial 15

# Copyright (C) 2000-2001, 2003-2007, 2009-2018 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

dnl From Jim Meyering

AC_DEFUN([gl_TIMESPEC], [:])

# tm_gmtoff.m4 serial 3
dnl Copyright (C) 2002, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_TM_GMTOFF],
[
 AC_CHECK_MEMBER([struct tm.tm_gmtoff],
                 [AC_DEFINE([HAVE_TM_GMTOFF], [1],
                            [Define if struct tm has the tm_gmtoff member.])],
                 ,
                 [#include <time.h>])
])

# serial 11

# Copyright (C) 2003, 2007, 2009-2018 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# See if we have a working tzset function.
# If so, arrange to compile the wrapper function.
# For at least Solaris 2.5.1 and 2.6, this is necessary
# because tzset can clobber the contents of the buffer
# used by localtime.

# Written by Paul Eggert and Jim Meyering.

AC_DEFUN([gl_FUNC_TZSET],
[
  AC_REQUIRE([gl_HEADER_TIME_H_DEFAULTS])
  AC_REQUIRE([gl_LOCALTIME_BUFFER_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([tzset])
  if test $ac_cv_func_tzset = no; then
    HAVE_TZSET=0
  fi
  gl_FUNC_TZSET_CLOBBER
  REPLACE_TZSET=0
  case "$gl_cv_func_tzset_clobber" in
    *yes)
      REPLACE_TZSET=1
      AC_DEFINE([TZSET_CLOBBERS_LOCALTIME], [1],
        [Define if tzset clobbers localtime's static buffer.])
      gl_LOCALTIME_BUFFER_NEEDED
      ;;
  esac
  case "$host_os" in
    mingw*) REPLACE_TZSET=1 ;;
  esac
])

# Set gl_cv_func_tzset_clobber.
AC_DEFUN([gl_FUNC_TZSET_CLOBBER],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether tzset clobbers localtime buffer],
                 [gl_cv_func_tzset_clobber],
    [AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <time.h>
#include <stdlib.h>

int
main ()
{
  time_t t1 = 853958121;
  struct tm *p, s;
  putenv ("TZ=GMT0");
  p = localtime (&t1);
  s = *p;
  putenv ("TZ=EST+3EDT+2,M10.1.0/00:00:00,M2.3.0/00:00:00");
  tzset ();
  return (p->tm_year != s.tm_year
          || p->tm_mon != s.tm_mon
          || p->tm_mday != s.tm_mday
          || p->tm_hour != s.tm_hour
          || p->tm_min != s.tm_min
          || p->tm_sec != s.tm_sec);
}
  ]])],
       [gl_cv_func_tzset_clobber=no],
       [gl_cv_func_tzset_clobber=yes],
       [case "$host_os" in
                         # Guess all is fine on glibc systems.
          *-gnu* | gnu*) gl_cv_func_tzset_clobber="guessing no" ;;
                         # Guess no on native Windows.
          mingw*)        gl_cv_func_tzset_clobber="guessing no" ;;
                         # If we don't know, assume the worst.
          *)             gl_cv_func_tzset_clobber="guessing yes" ;;
        esac
       ])
    ])

  AC_DEFINE([HAVE_RUN_TZSET_TEST], [1],
    [Define to 1 if you have run the test for working tzset.])
])

#serial 9
dnl Copyright (C) 2002, 2005-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_UNISTD_SAFER],
[
  AC_CHECK_FUNCS_ONCE([pipe])
])

# unistd_h.m4 serial 71
dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Simon Josefsson, Bruno Haible.

AC_DEFUN([gl_UNISTD_H],
[
  dnl Use AC_REQUIRE here, so that the default behavior below is expanded
  dnl once only, before all statements that occur in other macros.
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])

  gl_CHECK_NEXT_HEADERS([unistd.h])
  if test $ac_cv_header_unistd_h = yes; then
    HAVE_UNISTD_H=1
  else
    HAVE_UNISTD_H=0
  fi
  AC_SUBST([HAVE_UNISTD_H])

  dnl Ensure the type pid_t gets defined.
  AC_REQUIRE([AC_TYPE_PID_T])

  dnl Determine WINDOWS_64_BIT_OFF_T.
  AC_REQUIRE([gl_TYPE_OFF_T])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
/* Some systems declare various items in the wrong headers.  */
#if !(defined __GLIBC__ && !defined __UCLIBC__)
# include <fcntl.h>
# include <stdio.h>
# include <stdlib.h>
# if (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
#  include <io.h>
# endif
#endif
    ]], [chdir chown dup dup2 dup3 environ euidaccess faccessat fchdir fchownat
    fdatasync fsync ftruncate getcwd getdomainname getdtablesize getgroups
    gethostname getlogin getlogin_r getpagesize
    getusershell setusershell endusershell
    group_member isatty lchown link linkat lseek pipe pipe2 pread pwrite
    readlink readlinkat rmdir sethostname sleep symlink symlinkat
    truncate ttyname_r unlink unlinkat usleep])
])

AC_DEFUN([gl_UNISTD_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_UNISTD_H_DEFAULTS],
[
  GNULIB_CHDIR=0;                AC_SUBST([GNULIB_CHDIR])
  GNULIB_CHOWN=0;                AC_SUBST([GNULIB_CHOWN])
  GNULIB_CLOSE=0;                AC_SUBST([GNULIB_CLOSE])
  GNULIB_DUP=0;                  AC_SUBST([GNULIB_DUP])
  GNULIB_DUP2=0;                 AC_SUBST([GNULIB_DUP2])
  GNULIB_DUP3=0;                 AC_SUBST([GNULIB_DUP3])
  GNULIB_ENVIRON=0;              AC_SUBST([GNULIB_ENVIRON])
  GNULIB_EUIDACCESS=0;           AC_SUBST([GNULIB_EUIDACCESS])
  GNULIB_FACCESSAT=0;            AC_SUBST([GNULIB_FACCESSAT])
  GNULIB_FCHDIR=0;               AC_SUBST([GNULIB_FCHDIR])
  GNULIB_FCHOWNAT=0;             AC_SUBST([GNULIB_FCHOWNAT])
  GNULIB_FDATASYNC=0;            AC_SUBST([GNULIB_FDATASYNC])
  GNULIB_FSYNC=0;                AC_SUBST([GNULIB_FSYNC])
  GNULIB_FTRUNCATE=0;            AC_SUBST([GNULIB_FTRUNCATE])
  GNULIB_GETCWD=0;               AC_SUBST([GNULIB_GETCWD])
  GNULIB_GETDOMAINNAME=0;        AC_SUBST([GNULIB_GETDOMAINNAME])
  GNULIB_GETDTABLESIZE=0;        AC_SUBST([GNULIB_GETDTABLESIZE])
  GNULIB_GETGROUPS=0;            AC_SUBST([GNULIB_GETGROUPS])
  GNULIB_GETHOSTNAME=0;          AC_SUBST([GNULIB_GETHOSTNAME])
  GNULIB_GETLOGIN=0;             AC_SUBST([GNULIB_GETLOGIN])
  GNULIB_GETLOGIN_R=0;           AC_SUBST([GNULIB_GETLOGIN_R])
  GNULIB_GETPAGESIZE=0;          AC_SUBST([GNULIB_GETPAGESIZE])
  GNULIB_GETUSERSHELL=0;         AC_SUBST([GNULIB_GETUSERSHELL])
  GNULIB_GROUP_MEMBER=0;         AC_SUBST([GNULIB_GROUP_MEMBER])
  GNULIB_ISATTY=0;               AC_SUBST([GNULIB_ISATTY])
  GNULIB_LCHOWN=0;               AC_SUBST([GNULIB_LCHOWN])
  GNULIB_LINK=0;                 AC_SUBST([GNULIB_LINK])
  GNULIB_LINKAT=0;               AC_SUBST([GNULIB_LINKAT])
  GNULIB_LSEEK=0;                AC_SUBST([GNULIB_LSEEK])
  GNULIB_PIPE=0;                 AC_SUBST([GNULIB_PIPE])
  GNULIB_PIPE2=0;                AC_SUBST([GNULIB_PIPE2])
  GNULIB_PREAD=0;                AC_SUBST([GNULIB_PREAD])
  GNULIB_PWRITE=0;               AC_SUBST([GNULIB_PWRITE])
  GNULIB_READ=0;                 AC_SUBST([GNULIB_READ])
  GNULIB_READLINK=0;             AC_SUBST([GNULIB_READLINK])
  GNULIB_READLINKAT=0;           AC_SUBST([GNULIB_READLINKAT])
  GNULIB_RMDIR=0;                AC_SUBST([GNULIB_RMDIR])
  GNULIB_SETHOSTNAME=0;          AC_SUBST([GNULIB_SETHOSTNAME])
  GNULIB_SLEEP=0;                AC_SUBST([GNULIB_SLEEP])
  GNULIB_SYMLINK=0;              AC_SUBST([GNULIB_SYMLINK])
  GNULIB_SYMLINKAT=0;            AC_SUBST([GNULIB_SYMLINKAT])
  GNULIB_TRUNCATE=0;             AC_SUBST([GNULIB_TRUNCATE])
  GNULIB_TTYNAME_R=0;            AC_SUBST([GNULIB_TTYNAME_R])
  GNULIB_UNISTD_H_NONBLOCKING=0; AC_SUBST([GNULIB_UNISTD_H_NONBLOCKING])
  GNULIB_UNISTD_H_SIGPIPE=0;     AC_SUBST([GNULIB_UNISTD_H_SIGPIPE])
  GNULIB_UNLINK=0;               AC_SUBST([GNULIB_UNLINK])
  GNULIB_UNLINKAT=0;             AC_SUBST([GNULIB_UNLINKAT])
  GNULIB_USLEEP=0;               AC_SUBST([GNULIB_USLEEP])
  GNULIB_WRITE=0;                AC_SUBST([GNULIB_WRITE])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_CHOWN=1;           AC_SUBST([HAVE_CHOWN])
  HAVE_DUP2=1;            AC_SUBST([HAVE_DUP2])
  HAVE_DUP3=1;            AC_SUBST([HAVE_DUP3])
  HAVE_EUIDACCESS=1;      AC_SUBST([HAVE_EUIDACCESS])
  HAVE_FACCESSAT=1;       AC_SUBST([HAVE_FACCESSAT])
  HAVE_FCHDIR=1;          AC_SUBST([HAVE_FCHDIR])
  HAVE_FCHOWNAT=1;        AC_SUBST([HAVE_FCHOWNAT])
  HAVE_FDATASYNC=1;       AC_SUBST([HAVE_FDATASYNC])
  HAVE_FSYNC=1;           AC_SUBST([HAVE_FSYNC])
  HAVE_FTRUNCATE=1;       AC_SUBST([HAVE_FTRUNCATE])
  HAVE_GETDTABLESIZE=1;   AC_SUBST([HAVE_GETDTABLESIZE])
  HAVE_GETGROUPS=1;       AC_SUBST([HAVE_GETGROUPS])
  HAVE_GETHOSTNAME=1;     AC_SUBST([HAVE_GETHOSTNAME])
  HAVE_GETLOGIN=1;        AC_SUBST([HAVE_GETLOGIN])
  HAVE_GETPAGESIZE=1;     AC_SUBST([HAVE_GETPAGESIZE])
  HAVE_GROUP_MEMBER=1;    AC_SUBST([HAVE_GROUP_MEMBER])
  HAVE_LCHOWN=1;          AC_SUBST([HAVE_LCHOWN])
  HAVE_LINK=1;            AC_SUBST([HAVE_LINK])
  HAVE_LINKAT=1;          AC_SUBST([HAVE_LINKAT])
  HAVE_PIPE=1;            AC_SUBST([HAVE_PIPE])
  HAVE_PIPE2=1;           AC_SUBST([HAVE_PIPE2])
  HAVE_PREAD=1;           AC_SUBST([HAVE_PREAD])
  HAVE_PWRITE=1;          AC_SUBST([HAVE_PWRITE])
  HAVE_READLINK=1;        AC_SUBST([HAVE_READLINK])
  HAVE_READLINKAT=1;      AC_SUBST([HAVE_READLINKAT])
  HAVE_SETHOSTNAME=1;     AC_SUBST([HAVE_SETHOSTNAME])
  HAVE_SLEEP=1;           AC_SUBST([HAVE_SLEEP])
  HAVE_SYMLINK=1;         AC_SUBST([HAVE_SYMLINK])
  HAVE_SYMLINKAT=1;       AC_SUBST([HAVE_SYMLINKAT])
  HAVE_TRUNCATE=1;        AC_SUBST([HAVE_TRUNCATE])
  HAVE_UNLINKAT=1;        AC_SUBST([HAVE_UNLINKAT])
  HAVE_USLEEP=1;          AC_SUBST([HAVE_USLEEP])
  HAVE_DECL_ENVIRON=1;    AC_SUBST([HAVE_DECL_ENVIRON])
  HAVE_DECL_FCHDIR=1;     AC_SUBST([HAVE_DECL_FCHDIR])
  HAVE_DECL_FDATASYNC=1;  AC_SUBST([HAVE_DECL_FDATASYNC])
  HAVE_DECL_GETDOMAINNAME=1; AC_SUBST([HAVE_DECL_GETDOMAINNAME])
  HAVE_DECL_GETLOGIN=1;   AC_SUBST([HAVE_DECL_GETLOGIN])
  HAVE_DECL_GETLOGIN_R=1; AC_SUBST([HAVE_DECL_GETLOGIN_R])
  HAVE_DECL_GETPAGESIZE=1; AC_SUBST([HAVE_DECL_GETPAGESIZE])
  HAVE_DECL_GETUSERSHELL=1; AC_SUBST([HAVE_DECL_GETUSERSHELL])
  HAVE_DECL_SETHOSTNAME=1; AC_SUBST([HAVE_DECL_SETHOSTNAME])
  HAVE_DECL_TTYNAME_R=1;  AC_SUBST([HAVE_DECL_TTYNAME_R])
  HAVE_OS_H=0;            AC_SUBST([HAVE_OS_H])
  HAVE_SYS_PARAM_H=0;     AC_SUBST([HAVE_SYS_PARAM_H])
  REPLACE_CHOWN=0;        AC_SUBST([REPLACE_CHOWN])
  REPLACE_CLOSE=0;        AC_SUBST([REPLACE_CLOSE])
  REPLACE_DUP=0;          AC_SUBST([REPLACE_DUP])
  REPLACE_DUP2=0;         AC_SUBST([REPLACE_DUP2])
  REPLACE_FACCESSAT=0;    AC_SUBST([REPLACE_FACCESSAT])
  REPLACE_FCHOWNAT=0;     AC_SUBST([REPLACE_FCHOWNAT])
  REPLACE_FTRUNCATE=0;    AC_SUBST([REPLACE_FTRUNCATE])
  REPLACE_GETCWD=0;       AC_SUBST([REPLACE_GETCWD])
  REPLACE_GETDOMAINNAME=0; AC_SUBST([REPLACE_GETDOMAINNAME])
  REPLACE_GETDTABLESIZE=0; AC_SUBST([REPLACE_GETDTABLESIZE])
  REPLACE_GETLOGIN_R=0;   AC_SUBST([REPLACE_GETLOGIN_R])
  REPLACE_GETGROUPS=0;    AC_SUBST([REPLACE_GETGROUPS])
  REPLACE_GETPAGESIZE=0;  AC_SUBST([REPLACE_GETPAGESIZE])
  REPLACE_ISATTY=0;       AC_SUBST([REPLACE_ISATTY])
  REPLACE_LCHOWN=0;       AC_SUBST([REPLACE_LCHOWN])
  REPLACE_LINK=0;         AC_SUBST([REPLACE_LINK])
  REPLACE_LINKAT=0;       AC_SUBST([REPLACE_LINKAT])
  REPLACE_LSEEK=0;        AC_SUBST([REPLACE_LSEEK])
  REPLACE_PREAD=0;        AC_SUBST([REPLACE_PREAD])
  REPLACE_PWRITE=0;       AC_SUBST([REPLACE_PWRITE])
  REPLACE_READ=0;         AC_SUBST([REPLACE_READ])
  REPLACE_READLINK=0;     AC_SUBST([REPLACE_READLINK])
  REPLACE_READLINKAT=0;   AC_SUBST([REPLACE_READLINKAT])
  REPLACE_RMDIR=0;        AC_SUBST([REPLACE_RMDIR])
  REPLACE_SLEEP=0;        AC_SUBST([REPLACE_SLEEP])
  REPLACE_SYMLINK=0;      AC_SUBST([REPLACE_SYMLINK])
  REPLACE_SYMLINKAT=0;    AC_SUBST([REPLACE_SYMLINKAT])
  REPLACE_TRUNCATE=0;     AC_SUBST([REPLACE_TRUNCATE])
  REPLACE_TTYNAME_R=0;    AC_SUBST([REPLACE_TTYNAME_R])
  REPLACE_UNLINK=0;       AC_SUBST([REPLACE_UNLINK])
  REPLACE_UNLINKAT=0;     AC_SUBST([REPLACE_UNLINKAT])
  REPLACE_USLEEP=0;       AC_SUBST([REPLACE_USLEEP])
  REPLACE_WRITE=0;        AC_SUBST([REPLACE_WRITE])
  UNISTD_H_HAVE_WINSOCK2_H=0; AC_SUBST([UNISTD_H_HAVE_WINSOCK2_H])
  UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS=0;
                           AC_SUBST([UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS])
])

# unlink.m4 serial 12
dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_UNLINK],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_HEADERS_ONCE([unistd.h])

  dnl Detect FreeBSD 7.2, AIX 7.1, Solaris 9 bug.
  AC_CACHE_CHECK([whether unlink honors trailing slashes],
    [gl_cv_func_unlink_honors_slashes],
    [touch conftest.file
     # Assume that if we have lstat, we can also check symlinks.
     if test $ac_cv_func_lstat = yes; then
       ln -s conftest.file conftest.lnk
     fi
     AC_RUN_IFELSE(
       [AC_LANG_PROGRAM(
         [[#if HAVE_UNISTD_H
           # include <unistd.h>
           #else /* on Windows with MSVC */
           # include <io.h>
           #endif
           #include <errno.h>
         ]],
         [[int result = 0;
           if (!unlink ("conftest.file/"))
             result |= 1;
           else if (errno != ENOTDIR)
             result |= 2;
#if HAVE_LSTAT
           if (!unlink ("conftest.lnk/"))
             result |= 4;
           else if (errno != ENOTDIR)
             result |= 8;
#endif
           return result;
         ]])],
      [gl_cv_func_unlink_honors_slashes=yes],
      [gl_cv_func_unlink_honors_slashes=no],
      [case "$host_os" in
                 # Guess yes on glibc systems.
         *-gnu*) gl_cv_func_unlink_honors_slashes="guessing yes" ;;
                 # Guess no on native Windows.
         mingw*) gl_cv_func_unlink_honors_slashes="guessing no" ;;
                 # If we don't know, assume the worst.
         *)      gl_cv_func_unlink_honors_slashes="guessing no" ;;
       esac
      ])
     rm -f conftest.file conftest.lnk])
  case "$gl_cv_func_unlink_honors_slashes" in
    *no)
      REPLACE_UNLINK=1
      ;;
  esac

  dnl Detect Mac OS X 10.5.6 bug: On read-write HFS mounts, unlink("..") or
  dnl unlink("../..") succeeds without doing anything.
  AC_CACHE_CHECK([whether unlink of a parent directory fails as it should],
    [gl_cv_func_unlink_parent_fails],
    [case "$host_os" in
       darwin*)
         dnl Try to unlink a subdirectory of /tmp, because /tmp is usually on a
         dnl HFS mount on Mac OS X. Use a subdirectory, owned by the current
         dnl user, because otherwise unlink() may fail due to permissions
         dnl reasons, and because when running as root we don't want to risk
         dnl destroying the entire /tmp.
         if {
              # Use the mktemp program if available. If not available, hide the error
              # message.
              tmp=`(umask 077 && mktemp -d /tmp/gtXXXXXX) 2>/dev/null` &&
              test -n "$tmp" && test -d "$tmp"
            } ||
            {
              # Use a simple mkdir command. It is guaranteed to fail if the directory
              # already exists.  $RANDOM is bash specific and expands to empty in shells
              # other than bash, ksh and zsh.  Its use does not increase security;
              # rather, it minimizes the probability of failure in a very cluttered /tmp
              # directory.
              tmp=/tmp/gt$$-$RANDOM
              (umask 077 && mkdir "$tmp")
            }; then
           mkdir "$tmp/subdir"
           GL_SUBDIR_FOR_UNLINK="$tmp/subdir"
           export GL_SUBDIR_FOR_UNLINK
           AC_RUN_IFELSE(
             [AC_LANG_SOURCE([[
                #include <stdlib.h>
                #if HAVE_UNISTD_H
                # include <unistd.h>
                #else /* on Windows with MSVC */
                # include <direct.h>
                # include <io.h>
                #endif
                int main ()
                {
                  int result = 0;
                  if (chdir (getenv ("GL_SUBDIR_FOR_UNLINK")) != 0)
                    result |= 1;
                  else if (unlink ("..") == 0)
                    result |= 2;
                  return result;
                }
              ]])],
             [gl_cv_func_unlink_parent_fails=yes],
             [gl_cv_func_unlink_parent_fails=no],
             [# If we don't know, assume the worst.
              gl_cv_func_unlink_parent_fails="guessing no"
             ])
           unset GL_SUBDIR_FOR_UNLINK
           rm -rf "$tmp"
         else
           gl_cv_func_unlink_parent_fails="guessing no"
         fi
         ;;
       *)
         gl_cv_func_unlink_parent_fails="guessing yes"
         ;;
     esac
    ])
  case "$gl_cv_func_unlink_parent_fails" in
    *no)
      REPLACE_UNLINK=1
      AC_DEFINE([UNLINK_PARENT_BUG], [1],
        [Define to 1 if unlink() on a parent directory may succeed])
      ;;
  esac
])

# unlinkat.m4 serial 2
dnl Copyright (C) 2004-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Jim Meyering.

AC_DEFUN([gl_FUNC_UNLINKAT],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([unlinkat])
  AC_REQUIRE([gl_FUNC_UNLINK])
  AC_REQUIRE([gl_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK])
  if test $ac_cv_func_unlinkat = no; then
    HAVE_UNLINKAT=0
  else
    case "$gl_cv_func_lstat_dereferences_slashed_symlink" in
      *no)
        # Solaris 9 has *at functions, but uniformly mishandles trailing
        # slash in all of them.
        REPLACE_UNLINKAT=1
        ;;
      *)
        # GNU/Hurd has unlinkat, but it has the same bug as unlink.
        # Darwin has unlinkat, but it has the same UNLINK_PARENT_BUG.
        if test $REPLACE_UNLINK = 1; then
          REPLACE_UNLINKAT=1
        fi
        ;;
    esac
  fi
])

# utime.m4 serial 1
dnl Copyright (C) 2017-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_UTIME],
[
  AC_REQUIRE([gl_UTIME_H_DEFAULTS])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([utime])
  if test $ac_cv_func_utime = no; then
    HAVE_UTIME=0
  else
    case "$host_os" in
      mingw*)
        dnl On this platform, the original utime() or _utime() produces
        dnl timestamps that are affected by the time zone.
        REPLACE_UTIME=1
        ;;
    esac
  fi
])

# Prerequisites of lib/utime.c.
AC_DEFUN([gl_PREREQ_UTIME], [:])

# utime_h.m4 serial 1
dnl Copyright (C) 2017-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

AC_DEFUN([gl_UTIME_H],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_UTIME_H_DEFAULTS])
  AC_CHECK_HEADERS_ONCE([utime.h])
  gl_CHECK_NEXT_HEADERS([utime.h])

  if test $ac_cv_header_utime_h = yes; then
    HAVE_UTIME_H=1
  else
    HAVE_UTIME_H=0
  fi
  AC_SUBST([HAVE_UTIME_H])

  UTIME_H=''
  if test $ac_cv_header_utime_h != yes; then
    dnl Provide a substitute <utime.h> file.
    UTIME_H=utime.h
  else
    case "$host_os" in
      mingw*) dnl Need special handling of 'struct utimbuf'.
        UTIME_H=utime.h
        ;;
    esac
  fi
  AC_SUBST([UTIME_H])
  AM_CONDITIONAL([GL_GENERATE_UTIME_H], [test -n "$UTIME_H"])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[#include <utime.h>
    ]],
    [utime])
])

AC_DEFUN([gl_UTIME_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_UTIME_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_UTIME_H_DEFAULTS],
[
  GNULIB_UTIME=0;            AC_SUBST([GNULIB_UTIME])
  dnl Assume POSIX behavior unless another module says otherwise.
  HAVE_UTIME=1;              AC_SUBST([HAVE_UTIME])
  REPLACE_UTIME=0;           AC_SUBST([REPLACE_UTIME])
])

dnl Copyright (C) 2003-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl serial 8

AC_DEFUN([gl_UTIMENS],
[
  dnl Prerequisites of lib/utimens.c.
  AC_REQUIRE([gl_FUNC_UTIMES])
  AC_REQUIRE([gl_CHECK_TYPE_STRUCT_TIMESPEC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CHECK_FUNCS_ONCE([futimes futimesat futimens utimensat lutimes])

  if test $ac_cv_func_futimens = no && test $ac_cv_func_futimesat = yes; then
    dnl FreeBSD 8.0-rc2 mishandles futimesat(fd,NULL,time).  It is not
    dnl standardized, but Solaris implemented it first and uses it as
    dnl its only means to set fd time.
    AC_CACHE_CHECK([whether futimesat handles NULL file],
      [gl_cv_func_futimesat_works],
      [touch conftest.file
       AC_RUN_IFELSE([AC_LANG_PROGRAM([[
#include <stddef.h>
#include <sys/times.h>
#include <fcntl.h>
]], [[    int fd = open ("conftest.file", O_RDWR);
          if (fd < 0) return 1;
          if (futimesat (fd, NULL, NULL)) return 2;
        ]])],
        [gl_cv_func_futimesat_works=yes],
        [gl_cv_func_futimesat_works=no],
        [case "$host_os" in
                   # Guess yes on glibc systems.
           *-gnu*) gl_cv_func_futimesat_works="guessing yes" ;;
                   # If we don't know, assume the worst.
           *)      gl_cv_func_futimesat_works="guessing no" ;;
         esac
        ])
      rm -f conftest.file])
    case "$gl_cv_func_futimesat_works" in
      *yes) ;;
      *)
        AC_DEFINE([FUTIMESAT_NULL_BUG], [1],
          [Define to 1 if futimesat mishandles a NULL file name.])
        ;;
    esac
  fi
])

# serial 6
# See if we need to provide utimensat replacement.

dnl Copyright (C) 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# Written by Eric Blake.

AC_DEFUN([gl_FUNC_UTIMENSAT],
[
  AC_REQUIRE([gl_SYS_STAT_H_DEFAULTS])
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_CHECK_FUNCS_ONCE([utimensat])
  if test $ac_cv_func_utimensat = no; then
    HAVE_UTIMENSAT=0
  else
    AC_CACHE_CHECK([whether utimensat works],
      [gl_cv_func_utimensat_works],
      [AC_RUN_IFELSE(
         [AC_LANG_PROGRAM([[
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
]],         [[int result = 0;
              const char *f = "conftest.file";
              if (close (creat (f, 0600)))
                return 1;
              /* Test whether the AT_SYMLINK_NOFOLLOW flag is supported.  */
              {
                if (utimensat (AT_FDCWD, f, NULL, AT_SYMLINK_NOFOLLOW))
                  result |= 2;
              }
              /* Test whether UTIME_NOW and UTIME_OMIT work.  */
              {
                struct timespec ts[2];
                ts[0].tv_sec = 1;
                ts[0].tv_nsec = UTIME_OMIT;
                ts[1].tv_sec = 1;
                ts[1].tv_nsec = UTIME_NOW;
                if (utimensat (AT_FDCWD, f, ts, 0))
                  result |= 4;
              }
              sleep (1);
              {
                struct stat st;
                struct timespec ts[2];
                ts[0].tv_sec = 1;
                ts[0].tv_nsec = UTIME_NOW;
                ts[1].tv_sec = 1;
                ts[1].tv_nsec = UTIME_OMIT;
                if (utimensat (AT_FDCWD, f, ts, 0))
                  result |= 8;
                if (stat (f, &st))
                  result |= 16;
                else if (st.st_ctime < st.st_atime)
                  result |= 32;
              }
              return result;
            ]])],
         [gl_cv_func_utimensat_works=yes],
         [gl_cv_func_utimensat_works=no],
         [gl_cv_func_utimensat_works="guessing yes"])])
    if test "$gl_cv_func_utimensat_works" = no; then
      REPLACE_UTIMENSAT=1
    fi
  fi
])

# Detect some bugs in glibc's implementation of utimes.
# serial 5

dnl Copyright (C) 2003-2005, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# See if we need to work around bugs in glibc's implementation of
# utimes from 2003-07-12 to 2003-09-17.
# First, there was a bug that would make utimes set mtime
# and atime to zero (1970-01-01) unconditionally.
# Then, there was code to round rather than truncate.
# Then, there was an implementation (sparc64, Linux-2.4.28, glibc-2.3.3)
# that didn't honor the NULL-means-set-to-current-time semantics.
# Finally, there was also a version of utimes that failed on read-only
# files, while utime worked fine (linux-2.2.20, glibc-2.2.5).
#
# From Jim Meyering, with suggestions from Paul Eggert.

AC_DEFUN([gl_FUNC_UTIMES],
[
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether the utimes function works],
                 [gl_cv_func_working_utimes],
    [AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <utime.h>
#include <errno.h>

static int
inorder (time_t a, time_t b, time_t c)
{
  return a <= b && b <= c;
}

int
main ()
{
  int result = 0;
  char const *file = "conftest.utimes";
  /* On OS/2, file timestamps must be on or after 1980 in local time,
     with an even number of seconds.  */
  static struct timeval timeval[2] = {{315620000 + 10, 10},
                                      {315620000 + 1000000, 999998}};

  /* Test whether utimes() essentially works.  */
  {
    struct stat sbuf;
    FILE *f = fopen (file, "w");
    if (f == NULL)
      result |= 1;
    else if (fclose (f) != 0)
      result |= 1;
    else if (utimes (file, timeval) != 0)
      result |= 2;
    else if (lstat (file, &sbuf) != 0)
      result |= 1;
    else if (!(sbuf.st_atime == timeval[0].tv_sec
               && sbuf.st_mtime == timeval[1].tv_sec))
      result |= 4;
    if (unlink (file) != 0)
      result |= 1;
  }

  /* Test whether utimes() with a NULL argument sets the file's timestamp
     to the current time.  Use 'fstat' as well as 'time' to
     determine the "current" time, to accommodate NFS file systems
     if there is a time skew between the host and the NFS server.  */
  {
    int fd = open (file, O_WRONLY|O_CREAT, 0644);
    if (fd < 0)
      result |= 1;
    else
      {
        time_t t0, t2;
        struct stat st0, st1, st2;
        if (time (&t0) == (time_t) -1)
          result |= 1;
        else if (fstat (fd, &st0) != 0)
          result |= 1;
        else if (utimes (file, timeval) != 0
                 && (errno != EACCES
                     /* OS/2 kLIBC utimes fails on opened files.  */
                     || close (fd) != 0
                     || utimes (file, timeval) != 0
                     || (fd = open (file, O_WRONLY)) < 0))
          result |= 2;
        else if (utimes (file, NULL) != 0
                 && (errno != EACCES
                     /* OS/2 kLIBC utimes fails on opened files.  */
                     || close (fd) != 0
                     || utimes (file, NULL) != 0
                     || (fd = open (file, O_WRONLY)) < 0))
          result |= 8;
        else if (fstat (fd, &st1) != 0)
          result |= 1;
        else if (write (fd, "\n", 1) != 1)
          result |= 1;
        else if (fstat (fd, &st2) != 0)
          result |= 1;
        else if (time (&t2) == (time_t) -1)
          result |= 1;
        else
          {
            int m_ok_POSIX = inorder (t0, st1.st_mtime, t2);
            int m_ok_NFS = inorder (st0.st_mtime, st1.st_mtime, st2.st_mtime);
            if (! (st1.st_atime == st1.st_mtime))
              result |= 16;
            if (! (m_ok_POSIX || m_ok_NFS))
              result |= 32;
          }
        if (close (fd) != 0)
          result |= 1;
      }
    if (unlink (file) != 0)
      result |= 1;
  }

  /* Test whether utimes() with a NULL argument works on read-only files.  */
  {
    int fd = open (file, O_WRONLY|O_CREAT, 0444);
    if (fd < 0)
      result |= 1;
    else if (close (fd) != 0)
      result |= 1;
    else if (utimes (file, NULL) != 0)
      result |= 64;
    if (unlink (file) != 0)
      result |= 1;
  }

  return result;
}
  ]])],
       [gl_cv_func_working_utimes=yes],
       [gl_cv_func_working_utimes=no],
       [case "$host_os" in
                  # Guess no on native Windows.
          mingw*) gl_cv_func_working_utimes="guessing no" ;;
          *)      gl_cv_func_working_utimes="guessing no" ;;
        esac
       ])
    ])

  case "$gl_cv_func_working_utimes" in
    *yes)
      AC_DEFINE([HAVE_WORKING_UTIMES], [1], [Define if utimes works properly.])
      ;;
  esac
])

# vasnprintf.m4 serial 36
dnl Copyright (C) 2002-2004, 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_VASNPRINTF],
[
  AC_CHECK_FUNCS_ONCE([vasnprintf])
  if test $ac_cv_func_vasnprintf = no; then
    gl_REPLACE_VASNPRINTF
  fi
])

AC_DEFUN([gl_REPLACE_VASNPRINTF],
[
  AC_CHECK_FUNCS_ONCE([vasnprintf])
  AC_LIBOBJ([vasnprintf])
  AC_LIBOBJ([printf-args])
  AC_LIBOBJ([printf-parse])
  AC_LIBOBJ([asnprintf])
  if test $ac_cv_func_vasnprintf = yes; then
    AC_DEFINE([REPLACE_VASNPRINTF], [1],
      [Define if vasnprintf exists but is overridden by gnulib.])
  fi
  gl_PREREQ_PRINTF_ARGS
  gl_PREREQ_PRINTF_PARSE
  gl_PREREQ_VASNPRINTF
  gl_PREREQ_ASNPRINTF
])

# Prerequisites of lib/printf-args.h, lib/printf-args.c.
AC_DEFUN([gl_PREREQ_PRINTF_ARGS],
[
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
  AC_REQUIRE([gt_TYPE_WCHAR_T])
  AC_REQUIRE([gt_TYPE_WINT_T])
])

# Prerequisites of lib/printf-parse.h, lib/printf-parse.c.
AC_DEFUN([gl_PREREQ_PRINTF_PARSE],
[
  AC_REQUIRE([gl_FEATURES_H])
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
  AC_REQUIRE([gt_TYPE_WCHAR_T])
  AC_REQUIRE([gt_TYPE_WINT_T])
  AC_REQUIRE([AC_TYPE_SIZE_T])
  AC_CHECK_TYPE([ptrdiff_t], ,
    [AC_DEFINE([ptrdiff_t], [long],
       [Define as the type of the result of subtracting two pointers, if the system doesn't define it.])
    ])
  AC_REQUIRE([gt_AC_TYPE_INTMAX_T])
])

# Prerequisites of lib/vasnprintf.c.
AC_DEFUN_ONCE([gl_PREREQ_VASNPRINTF],
[
  AC_REQUIRE([AC_FUNC_ALLOCA])
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
  AC_REQUIRE([gt_TYPE_WCHAR_T])
  AC_REQUIRE([gt_TYPE_WINT_T])
  AC_CHECK_FUNCS([snprintf strnlen wcslen wcsnlen mbrtowc wcrtomb])
  dnl Use the _snprintf function only if it is declared (because on NetBSD it
  dnl is defined as a weak alias of snprintf; we prefer to use the latter).
  AC_CHECK_DECLS([_snprintf], , , [[#include <stdio.h>]])
  dnl Knowing DBL_EXPBIT0_WORD and DBL_EXPBIT0_BIT enables an optimization
  dnl in the code for NEED_PRINTF_LONG_DOUBLE || NEED_PRINTF_DOUBLE.
  AC_REQUIRE([gl_DOUBLE_EXPONENT_LOCATION])
  dnl We can avoid a lot of code by assuming that snprintf's return value
  dnl conforms to ISO C99. So check that.
  AC_REQUIRE([gl_SNPRINTF_RETVAL_C99])
  case "$gl_cv_func_snprintf_retval_c99" in
    *yes)
      AC_DEFINE([HAVE_SNPRINTF_RETVAL_C99], [1],
        [Define if the return value of the snprintf function is the number of
         of bytes (excluding the terminating NUL) that would have been produced
         if the buffer had been large enough.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting 'long double'
# arguments.
AC_DEFUN_ONCE([gl_PREREQ_VASNPRINTF_LONG_DOUBLE],
[
  AC_REQUIRE([gl_PRINTF_LONG_DOUBLE])
  case "$gl_cv_func_printf_long_double" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_LONG_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         'long double' arguments.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting infinite 'double'
# arguments.
AC_DEFUN([gl_PREREQ_VASNPRINTF_INFINITE_DOUBLE],
[
  AC_REQUIRE([gl_PRINTF_INFINITE])
  case "$gl_cv_func_printf_infinite" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_INFINITE_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         infinite 'double' arguments.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting infinite 'long double'
# arguments.
AC_DEFUN([gl_PREREQ_VASNPRINTF_INFINITE_LONG_DOUBLE],
[
  AC_REQUIRE([gl_PRINTF_INFINITE_LONG_DOUBLE])
  dnl There is no need to set NEED_PRINTF_INFINITE_LONG_DOUBLE if
  dnl NEED_PRINTF_LONG_DOUBLE is already set.
  AC_REQUIRE([gl_PREREQ_VASNPRINTF_LONG_DOUBLE])
  case "$gl_cv_func_printf_long_double" in
    *yes)
      case "$gl_cv_func_printf_infinite_long_double" in
        *yes)
          ;;
        *)
          AC_DEFINE([NEED_PRINTF_INFINITE_LONG_DOUBLE], [1],
            [Define if the vasnprintf implementation needs special code for
             infinite 'long double' arguments.])
          ;;
      esac
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the 'a' directive.
AC_DEFUN([gl_PREREQ_VASNPRINTF_DIRECTIVE_A],
[
  AC_REQUIRE([gl_PRINTF_DIRECTIVE_A])
  case "$gl_cv_func_printf_directive_a" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_DIRECTIVE_A], [1],
        [Define if the vasnprintf implementation needs special code for
         the 'a' and 'A' directives.])
      AC_CHECK_FUNCS([nl_langinfo])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the 'F' directive.
AC_DEFUN([gl_PREREQ_VASNPRINTF_DIRECTIVE_F],
[
  AC_REQUIRE([gl_PRINTF_DIRECTIVE_F])
  case "$gl_cv_func_printf_directive_f" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_DIRECTIVE_F], [1],
        [Define if the vasnprintf implementation needs special code for
         the 'F' directive.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the 'ls' directive.
AC_DEFUN([gl_PREREQ_VASNPRINTF_DIRECTIVE_LS],
[
  AC_REQUIRE([gl_PRINTF_DIRECTIVE_LS])
  case "$gl_cv_func_printf_directive_ls" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_DIRECTIVE_LS], [1],
        [Define if the vasnprintf implementation needs special code for
         the 'ls' directive.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the ' flag.
AC_DEFUN([gl_PREREQ_VASNPRINTF_FLAG_GROUPING],
[
  AC_REQUIRE([gl_PRINTF_FLAG_GROUPING])
  case "$gl_cv_func_printf_flag_grouping" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_FLAG_GROUPING], [1],
        [Define if the vasnprintf implementation needs special code for the
         ' flag.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the '-' flag.
AC_DEFUN([gl_PREREQ_VASNPRINTF_FLAG_LEFTADJUST],
[
  AC_REQUIRE([gl_PRINTF_FLAG_LEFTADJUST])
  case "$gl_cv_func_printf_flag_leftadjust" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_FLAG_LEFTADJUST], [1],
        [Define if the vasnprintf implementation needs special code for the
         '-' flag.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting the 0 flag.
AC_DEFUN([gl_PREREQ_VASNPRINTF_FLAG_ZERO],
[
  AC_REQUIRE([gl_PRINTF_FLAG_ZERO])
  case "$gl_cv_func_printf_flag_zero" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_FLAG_ZERO], [1],
        [Define if the vasnprintf implementation needs special code for the
         0 flag.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for supporting large precisions.
AC_DEFUN([gl_PREREQ_VASNPRINTF_PRECISION],
[
  AC_REQUIRE([gl_PRINTF_PRECISION])
  case "$gl_cv_func_printf_precision" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_UNBOUNDED_PRECISION], [1],
        [Define if the vasnprintf implementation needs special code for
         supporting large precisions without arbitrary bounds.])
      AC_DEFINE([NEED_PRINTF_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         'double' arguments.])
      AC_DEFINE([NEED_PRINTF_LONG_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         'long double' arguments.])
      ;;
  esac
])

# Extra prerequisites of lib/vasnprintf.c for surviving out-of-memory
# conditions.
AC_DEFUN([gl_PREREQ_VASNPRINTF_ENOMEM],
[
  AC_REQUIRE([gl_PRINTF_ENOMEM])
  case "$gl_cv_func_printf_enomem" in
    *yes)
      ;;
    *)
      AC_DEFINE([NEED_PRINTF_ENOMEM], [1],
        [Define if the vasnprintf implementation needs special code for
         surviving out-of-memory conditions.])
      AC_DEFINE([NEED_PRINTF_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         'double' arguments.])
      AC_DEFINE([NEED_PRINTF_LONG_DOUBLE], [1],
        [Define if the vasnprintf implementation needs special code for
         'long double' arguments.])
      ;;
  esac
])

# Prerequisites of lib/vasnprintf.c including all extras for POSIX compliance.
AC_DEFUN([gl_PREREQ_VASNPRINTF_WITH_EXTRAS],
[
  AC_REQUIRE([gl_PREREQ_VASNPRINTF])
  gl_PREREQ_VASNPRINTF_LONG_DOUBLE
  gl_PREREQ_VASNPRINTF_INFINITE_DOUBLE
  gl_PREREQ_VASNPRINTF_INFINITE_LONG_DOUBLE
  gl_PREREQ_VASNPRINTF_DIRECTIVE_A
  gl_PREREQ_VASNPRINTF_DIRECTIVE_F
  gl_PREREQ_VASNPRINTF_DIRECTIVE_LS
  gl_PREREQ_VASNPRINTF_FLAG_GROUPING
  gl_PREREQ_VASNPRINTF_FLAG_LEFTADJUST
  gl_PREREQ_VASNPRINTF_FLAG_ZERO
  gl_PREREQ_VASNPRINTF_PRECISION
  gl_PREREQ_VASNPRINTF_ENOMEM
])

# Prerequisites of lib/asnprintf.c.
AC_DEFUN([gl_PREREQ_ASNPRINTF],
[
])

# vasprintf.m4 serial 6
dnl Copyright (C) 2002-2003, 2006-2007, 2009-2018 Free Software Foundation,
dnl Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_VASPRINTF],
[
  AC_CHECK_FUNCS([vasprintf])
  if test $ac_cv_func_vasprintf = no; then
    gl_REPLACE_VASPRINTF
  fi
])

AC_DEFUN([gl_REPLACE_VASPRINTF],
[
  AC_LIBOBJ([vasprintf])
  AC_LIBOBJ([asprintf])
  AC_REQUIRE([gl_STDIO_H_DEFAULTS])
  if test $ac_cv_func_vasprintf = yes; then
    REPLACE_VASPRINTF=1
  else
    HAVE_VASPRINTF=0
  fi
  gl_PREREQ_VASPRINTF_H
  gl_PREREQ_VASPRINTF
  gl_PREREQ_ASPRINTF
])

# Prerequisites of the vasprintf portion of lib/stdio.h.
AC_DEFUN([gl_PREREQ_VASPRINTF_H],
[
  dnl Persuade glibc <stdio.h> to declare asprintf() and vasprintf().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])
])

# Prerequisites of lib/vasprintf.c.
AC_DEFUN([gl_PREREQ_VASPRINTF],
[
])

# Prerequisites of lib/asprintf.c.
AC_DEFUN([gl_PREREQ_ASPRINTF],
[
])

# warn-on-use.m4 serial 5
dnl Copyright (C) 2010-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# gl_WARN_ON_USE_PREPARE(INCLUDES, NAMES)
# ---------------------------------------
# For each whitespace-separated element in the list of NAMES, define
# HAVE_RAW_DECL_name if the function has a declaration among INCLUDES
# even after being undefined as a macro.
#
# See warn-on-use.h for some hints on how to poison function names, as
# well as ideas on poisoning global variables and macros.  NAMES may
# include global variables, but remember that only functions work with
# _GL_WARN_ON_USE.  Typically, INCLUDES only needs to list a single
# header, but if the replacement header pulls in other headers because
# some systems declare functions in the wrong header, then INCLUDES
# should do likewise.
#
# It is generally safe to assume declarations for functions declared
# in the intersection of C89 and C11 (such as printf) without
# needing gl_WARN_ON_USE_PREPARE.
AC_DEFUN([gl_WARN_ON_USE_PREPARE],
[
  m4_foreach_w([gl_decl], [$2],
    [AH_TEMPLATE([HAVE_RAW_DECL_]AS_TR_CPP(m4_defn([gl_decl])),
      [Define to 1 if ]m4_defn([gl_decl])[ is declared even after
       undefining macros.])])dnl
dnl FIXME: gl_Symbol must be used unquoted until we can assume
dnl autoconf 2.64 or newer.
  for gl_func in m4_flatten([$2]); do
    AS_VAR_PUSHDEF([gl_Symbol], [gl_cv_have_raw_decl_$gl_func])dnl
    AC_CACHE_CHECK([whether $gl_func is declared without a macro],
      gl_Symbol,
      [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([$1],
[@%:@undef $gl_func
  (void) $gl_func;])],
        [AS_VAR_SET(gl_Symbol, [yes])], [AS_VAR_SET(gl_Symbol, [no])])])
    AS_VAR_IF(gl_Symbol, [yes],
      [AC_DEFINE_UNQUOTED(AS_TR_CPP([HAVE_RAW_DECL_$gl_func]), [1])
       dnl shortcut - if the raw declaration exists, then set a cache
       dnl variable to allow skipping any later AC_CHECK_DECL efforts
       eval ac_cv_have_decl_$gl_func=yes])
    AS_VAR_POPDEF([gl_Symbol])dnl
  done
])

# warnings.m4 serial 13
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Simon Josefsson

# gl_AS_VAR_APPEND(VAR, VALUE)
# ----------------------------
# Provide the functionality of AS_VAR_APPEND if Autoconf does not have it.
m4_ifdef([AS_VAR_APPEND],
[m4_copy([AS_VAR_APPEND], [gl_AS_VAR_APPEND])],
[m4_define([gl_AS_VAR_APPEND],
[AS_VAR_SET([$1], [AS_VAR_GET([$1])$2])])])


# gl_COMPILER_OPTION_IF(OPTION, [IF-SUPPORTED], [IF-NOT-SUPPORTED],
#                       [PROGRAM = AC_LANG_PROGRAM()])
# -----------------------------------------------------------------
# Check if the compiler supports OPTION when compiling PROGRAM.
#
# The effects of this macro depend on the current language (_AC_LANG).
AC_DEFUN([gl_COMPILER_OPTION_IF],
[
dnl FIXME: gl_Warn must be used unquoted until we can assume Autoconf
dnl 2.64 or newer.
AS_VAR_PUSHDEF([gl_Warn], [gl_cv_warn_[]_AC_LANG_ABBREV[]_$1])dnl
AS_VAR_PUSHDEF([gl_Flags], [_AC_LANG_PREFIX[]FLAGS])dnl
AS_LITERAL_IF([$1],
  [m4_pushdef([gl_Positive], m4_bpatsubst([$1], [^-Wno-], [-W]))],
  [gl_positive="$1"
case $gl_positive in
  -Wno-*) gl_positive=-W`expr "X$gl_positive" : 'X-Wno-\(.*\)'` ;;
esac
m4_pushdef([gl_Positive], [$gl_positive])])dnl
AC_CACHE_CHECK([whether _AC_LANG compiler handles $1], m4_defn([gl_Warn]), [
  gl_save_compiler_FLAGS="$gl_Flags"
  gl_AS_VAR_APPEND(m4_defn([gl_Flags]),
    [" $gl_unknown_warnings_are_errors ]m4_defn([gl_Positive])["])
  AC_LINK_IFELSE([m4_default([$4], [AC_LANG_PROGRAM([])])],
                 [AS_VAR_SET(gl_Warn, [yes])],
                 [AS_VAR_SET(gl_Warn, [no])])
  gl_Flags="$gl_save_compiler_FLAGS"
])
AS_VAR_IF(gl_Warn, [yes], [$2], [$3])
m4_popdef([gl_Positive])dnl
AS_VAR_POPDEF([gl_Flags])dnl
AS_VAR_POPDEF([gl_Warn])dnl
])

# gl_UNKNOWN_WARNINGS_ARE_ERRORS
# ------------------------------
# Clang doesn't complain about unknown warning options unless one also
# specifies -Wunknown-warning-option -Werror.  Detect this.
#
# The effects of this macro depend on the current language (_AC_LANG).
AC_DEFUN([gl_UNKNOWN_WARNINGS_ARE_ERRORS],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])

# Specialization for _AC_LANG = C. This macro can be AC_REQUIREd.
# Use of m4_defun rather than AC_DEFUN works around a bug in autoconf < 2.63b.
m4_defun([gl_UNKNOWN_WARNINGS_ARE_ERRORS(C)],
[
  AC_LANG_PUSH([C])
  gl_UNKNOWN_WARNINGS_ARE_ERRORS_IMPL
  AC_LANG_POP([C])
])

# Specialization for _AC_LANG = C++. This macro can be AC_REQUIREd.
# Use of m4_defun rather than AC_DEFUN works around a bug in autoconf < 2.63b.
m4_defun([gl_UNKNOWN_WARNINGS_ARE_ERRORS(C++)],
[
  AC_LANG_PUSH([C++])
  gl_UNKNOWN_WARNINGS_ARE_ERRORS_IMPL
  AC_LANG_POP([C++])
])

AC_DEFUN([gl_UNKNOWN_WARNINGS_ARE_ERRORS_IMPL],
[gl_COMPILER_OPTION_IF([-Werror -Wunknown-warning-option],
   [gl_unknown_warnings_are_errors='-Wunknown-warning-option -Werror'],
   [gl_unknown_warnings_are_errors=])])

# gl_WARN_ADD(OPTION, [VARIABLE = WARN_CFLAGS/WARN_CXXFLAGS],
#             [PROGRAM = AC_LANG_PROGRAM()])
# -----------------------------------------------------------
# Adds parameter to WARN_CFLAGS/WARN_CXXFLAGS if the compiler supports it
# when compiling PROGRAM.  For example, gl_WARN_ADD([-Wparentheses]).
#
# If VARIABLE is a variable name, AC_SUBST it.
#
# The effects of this macro depend on the current language (_AC_LANG).
AC_DEFUN([gl_WARN_ADD],
[AC_REQUIRE([gl_UNKNOWN_WARNINGS_ARE_ERRORS(]_AC_LANG[)])
gl_COMPILER_OPTION_IF([$1],
  [gl_AS_VAR_APPEND(m4_if([$2], [], [[WARN_]_AC_LANG_PREFIX[FLAGS]], [[$2]]), [" $1"])],
  [],
  [$3])
m4_ifval([$2],
         [AS_LITERAL_IF([$2], [AC_SUBST([$2])])],
         [AC_SUBST([WARN_]_AC_LANG_PREFIX[FLAGS])])dnl
])

# Local Variables:
# mode: autoconf
# End:

dnl A placeholder for ISO C99 <wchar.h>, for platforms that have issues.

dnl Copyright (C) 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Eric Blake.

# wchar_h.m4 serial 42

AC_DEFUN([gl_WCHAR_H],
[
  AC_REQUIRE([gl_WCHAR_H_DEFAULTS])
  AC_REQUIRE([gl_WCHAR_H_INLINE_OK])
  dnl Prepare for creating substitute <wchar.h>.
  dnl Check for <wchar.h> (missing in Linux uClibc when built without wide
  dnl character support).
  dnl <wchar.h> is always overridden, because of GNULIB_POSIXCHECK.
  gl_CHECK_NEXT_HEADERS([wchar.h])
  if test $ac_cv_header_wchar_h = yes; then
    HAVE_WCHAR_H=1
  else
    HAVE_WCHAR_H=0
  fi
  AC_SUBST([HAVE_WCHAR_H])

  AC_REQUIRE([gl_FEATURES_H])

  AC_REQUIRE([gt_TYPE_WINT_T])
  if test $gt_cv_c_wint_t = yes; then
    HAVE_WINT_T=1
  else
    HAVE_WINT_T=0
  fi
  AC_SUBST([HAVE_WINT_T])

  AC_REQUIRE([gl_TYPE_WINT_T_PREREQ])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#if !(defined __GLIBC__ && !defined __UCLIBC__)
# include <stddef.h>
# include <stdio.h>
# include <time.h>
#endif
#include <wchar.h>
    ]],
    [btowc wctob mbsinit mbrtowc mbrlen mbsrtowcs mbsnrtowcs wcrtomb
     wcsrtombs wcsnrtombs wcwidth wmemchr wmemcmp wmemcpy wmemmove wmemset
     wcslen wcsnlen wcscpy wcpcpy wcsncpy wcpncpy wcscat wcsncat wcscmp
     wcsncmp wcscasecmp wcsncasecmp wcscoll wcsxfrm wcsdup wcschr wcsrchr
     wcscspn wcsspn wcspbrk wcsstr wcstok wcswidth wcsftime
    ])
])

dnl Check whether <wchar.h> is usable at all.
AC_DEFUN([gl_WCHAR_H_INLINE_OK],
[
  dnl Test whether <wchar.h> suffers due to the transition from '__inline' to
  dnl 'gnu_inline'. See <https://sourceware.org/bugzilla/show_bug.cgi?id=4022>
  dnl and <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=42440>. In summary,
  dnl glibc version 2.5 or older, together with gcc version 4.3 or newer and
  dnl the option -std=c99 or -std=gnu99, leads to a broken <wchar.h>.
  AC_CACHE_CHECK([whether <wchar.h> uses 'inline' correctly],
    [gl_cv_header_wchar_h_correct_inline],
    [gl_cv_header_wchar_h_correct_inline=yes
     AC_LANG_CONFTEST([
       AC_LANG_SOURCE([[#define wcstod renamed_wcstod
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
extern int zero (void);
int main () { return zero(); }
]])])
     dnl Do not rename the object file from conftest.$ac_objext to
     dnl conftest1.$ac_objext, as this will cause the link to fail on
     dnl z/OS when using the XPLINK object format (due to duplicate
     dnl CSECT names). Instead, temporarily redefine $ac_compile so
     dnl that the object file has the latter name from the start.
     save_ac_compile="$ac_compile"
     ac_compile=`echo "$save_ac_compile" | sed s/conftest/conftest1/`
     if AC_TRY_EVAL([ac_compile]); then
       AC_LANG_CONFTEST([
         AC_LANG_SOURCE([[#define wcstod renamed_wcstod
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int zero (void) { return 0; }
]])])
       dnl See note above about renaming object files.
       ac_compile=`echo "$save_ac_compile" | sed s/conftest/conftest2/`
       if AC_TRY_EVAL([ac_compile]); then
         if $CC -o conftest$ac_exeext $CFLAGS $LDFLAGS conftest1.$ac_objext conftest2.$ac_objext $LIBS >&AS_MESSAGE_LOG_FD 2>&1; then
           :
         else
           gl_cv_header_wchar_h_correct_inline=no
         fi
       fi
     fi
     ac_compile="$save_ac_compile"
     rm -f conftest1.$ac_objext conftest2.$ac_objext conftest$ac_exeext
    ])
  if test $gl_cv_header_wchar_h_correct_inline = no; then
    AC_MSG_ERROR([<wchar.h> cannot be used with this compiler ($CC $CFLAGS $CPPFLAGS).
This is a known interoperability problem of glibc <= 2.5 with gcc >= 4.3 in
C99 mode. You have four options:
  - Add the flag -fgnu89-inline to CC and reconfigure, or
  - Fix your include files, using parts of
    <https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=b037a293a48718af30d706c2e18c929d0e69a621>, or
  - Use a gcc version older than 4.3, or
  - Don't use the flags -std=c99 or -std=gnu99.
Configuration aborted.])
  fi
])

AC_DEFUN([gl_WCHAR_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_WCHAR_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_WCHAR_H_DEFAULTS],
[
  GNULIB_BTOWC=0;       AC_SUBST([GNULIB_BTOWC])
  GNULIB_WCTOB=0;       AC_SUBST([GNULIB_WCTOB])
  GNULIB_MBSINIT=0;     AC_SUBST([GNULIB_MBSINIT])
  GNULIB_MBRTOWC=0;     AC_SUBST([GNULIB_MBRTOWC])
  GNULIB_MBRLEN=0;      AC_SUBST([GNULIB_MBRLEN])
  GNULIB_MBSRTOWCS=0;   AC_SUBST([GNULIB_MBSRTOWCS])
  GNULIB_MBSNRTOWCS=0;  AC_SUBST([GNULIB_MBSNRTOWCS])
  GNULIB_WCRTOMB=0;     AC_SUBST([GNULIB_WCRTOMB])
  GNULIB_WCSRTOMBS=0;   AC_SUBST([GNULIB_WCSRTOMBS])
  GNULIB_WCSNRTOMBS=0;  AC_SUBST([GNULIB_WCSNRTOMBS])
  GNULIB_WCWIDTH=0;     AC_SUBST([GNULIB_WCWIDTH])
  GNULIB_WMEMCHR=0;     AC_SUBST([GNULIB_WMEMCHR])
  GNULIB_WMEMCMP=0;     AC_SUBST([GNULIB_WMEMCMP])
  GNULIB_WMEMCPY=0;     AC_SUBST([GNULIB_WMEMCPY])
  GNULIB_WMEMMOVE=0;    AC_SUBST([GNULIB_WMEMMOVE])
  GNULIB_WMEMSET=0;     AC_SUBST([GNULIB_WMEMSET])
  GNULIB_WCSLEN=0;      AC_SUBST([GNULIB_WCSLEN])
  GNULIB_WCSNLEN=0;     AC_SUBST([GNULIB_WCSNLEN])
  GNULIB_WCSCPY=0;      AC_SUBST([GNULIB_WCSCPY])
  GNULIB_WCPCPY=0;      AC_SUBST([GNULIB_WCPCPY])
  GNULIB_WCSNCPY=0;     AC_SUBST([GNULIB_WCSNCPY])
  GNULIB_WCPNCPY=0;     AC_SUBST([GNULIB_WCPNCPY])
  GNULIB_WCSCAT=0;      AC_SUBST([GNULIB_WCSCAT])
  GNULIB_WCSNCAT=0;     AC_SUBST([GNULIB_WCSNCAT])
  GNULIB_WCSCMP=0;      AC_SUBST([GNULIB_WCSCMP])
  GNULIB_WCSNCMP=0;     AC_SUBST([GNULIB_WCSNCMP])
  GNULIB_WCSCASECMP=0;  AC_SUBST([GNULIB_WCSCASECMP])
  GNULIB_WCSNCASECMP=0; AC_SUBST([GNULIB_WCSNCASECMP])
  GNULIB_WCSCOLL=0;     AC_SUBST([GNULIB_WCSCOLL])
  GNULIB_WCSXFRM=0;     AC_SUBST([GNULIB_WCSXFRM])
  GNULIB_WCSDUP=0;      AC_SUBST([GNULIB_WCSDUP])
  GNULIB_WCSCHR=0;      AC_SUBST([GNULIB_WCSCHR])
  GNULIB_WCSRCHR=0;     AC_SUBST([GNULIB_WCSRCHR])
  GNULIB_WCSCSPN=0;     AC_SUBST([GNULIB_WCSCSPN])
  GNULIB_WCSSPN=0;      AC_SUBST([GNULIB_WCSSPN])
  GNULIB_WCSPBRK=0;     AC_SUBST([GNULIB_WCSPBRK])
  GNULIB_WCSSTR=0;      AC_SUBST([GNULIB_WCSSTR])
  GNULIB_WCSTOK=0;      AC_SUBST([GNULIB_WCSTOK])
  GNULIB_WCSWIDTH=0;    AC_SUBST([GNULIB_WCSWIDTH])
  GNULIB_WCSFTIME=0;    AC_SUBST([GNULIB_WCSFTIME])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_BTOWC=1;         AC_SUBST([HAVE_BTOWC])
  HAVE_MBSINIT=1;       AC_SUBST([HAVE_MBSINIT])
  HAVE_MBRTOWC=1;       AC_SUBST([HAVE_MBRTOWC])
  HAVE_MBRLEN=1;        AC_SUBST([HAVE_MBRLEN])
  HAVE_MBSRTOWCS=1;     AC_SUBST([HAVE_MBSRTOWCS])
  HAVE_MBSNRTOWCS=1;    AC_SUBST([HAVE_MBSNRTOWCS])
  HAVE_WCRTOMB=1;       AC_SUBST([HAVE_WCRTOMB])
  HAVE_WCSRTOMBS=1;     AC_SUBST([HAVE_WCSRTOMBS])
  HAVE_WCSNRTOMBS=1;    AC_SUBST([HAVE_WCSNRTOMBS])
  HAVE_WMEMCHR=1;       AC_SUBST([HAVE_WMEMCHR])
  HAVE_WMEMCMP=1;       AC_SUBST([HAVE_WMEMCMP])
  HAVE_WMEMCPY=1;       AC_SUBST([HAVE_WMEMCPY])
  HAVE_WMEMMOVE=1;      AC_SUBST([HAVE_WMEMMOVE])
  HAVE_WMEMSET=1;       AC_SUBST([HAVE_WMEMSET])
  HAVE_WCSLEN=1;        AC_SUBST([HAVE_WCSLEN])
  HAVE_WCSNLEN=1;       AC_SUBST([HAVE_WCSNLEN])
  HAVE_WCSCPY=1;        AC_SUBST([HAVE_WCSCPY])
  HAVE_WCPCPY=1;        AC_SUBST([HAVE_WCPCPY])
  HAVE_WCSNCPY=1;       AC_SUBST([HAVE_WCSNCPY])
  HAVE_WCPNCPY=1;       AC_SUBST([HAVE_WCPNCPY])
  HAVE_WCSCAT=1;        AC_SUBST([HAVE_WCSCAT])
  HAVE_WCSNCAT=1;       AC_SUBST([HAVE_WCSNCAT])
  HAVE_WCSCMP=1;        AC_SUBST([HAVE_WCSCMP])
  HAVE_WCSNCMP=1;       AC_SUBST([HAVE_WCSNCMP])
  HAVE_WCSCASECMP=1;    AC_SUBST([HAVE_WCSCASECMP])
  HAVE_WCSNCASECMP=1;   AC_SUBST([HAVE_WCSNCASECMP])
  HAVE_WCSCOLL=1;       AC_SUBST([HAVE_WCSCOLL])
  HAVE_WCSXFRM=1;       AC_SUBST([HAVE_WCSXFRM])
  HAVE_WCSDUP=1;        AC_SUBST([HAVE_WCSDUP])
  HAVE_WCSCHR=1;        AC_SUBST([HAVE_WCSCHR])
  HAVE_WCSRCHR=1;       AC_SUBST([HAVE_WCSRCHR])
  HAVE_WCSCSPN=1;       AC_SUBST([HAVE_WCSCSPN])
  HAVE_WCSSPN=1;        AC_SUBST([HAVE_WCSSPN])
  HAVE_WCSPBRK=1;       AC_SUBST([HAVE_WCSPBRK])
  HAVE_WCSSTR=1;        AC_SUBST([HAVE_WCSSTR])
  HAVE_WCSTOK=1;        AC_SUBST([HAVE_WCSTOK])
  HAVE_WCSWIDTH=1;      AC_SUBST([HAVE_WCSWIDTH])
  HAVE_WCSFTIME=1;      AC_SUBST([HAVE_WCSFTIME])
  HAVE_DECL_WCTOB=1;    AC_SUBST([HAVE_DECL_WCTOB])
  HAVE_DECL_WCWIDTH=1;  AC_SUBST([HAVE_DECL_WCWIDTH])
  REPLACE_MBSTATE_T=0;  AC_SUBST([REPLACE_MBSTATE_T])
  REPLACE_BTOWC=0;      AC_SUBST([REPLACE_BTOWC])
  REPLACE_WCTOB=0;      AC_SUBST([REPLACE_WCTOB])
  REPLACE_MBSINIT=0;    AC_SUBST([REPLACE_MBSINIT])
  REPLACE_MBRTOWC=0;    AC_SUBST([REPLACE_MBRTOWC])
  REPLACE_MBRLEN=0;     AC_SUBST([REPLACE_MBRLEN])
  REPLACE_MBSRTOWCS=0;  AC_SUBST([REPLACE_MBSRTOWCS])
  REPLACE_MBSNRTOWCS=0; AC_SUBST([REPLACE_MBSNRTOWCS])
  REPLACE_WCRTOMB=0;    AC_SUBST([REPLACE_WCRTOMB])
  REPLACE_WCSRTOMBS=0;  AC_SUBST([REPLACE_WCSRTOMBS])
  REPLACE_WCSNRTOMBS=0; AC_SUBST([REPLACE_WCSNRTOMBS])
  REPLACE_WCWIDTH=0;    AC_SUBST([REPLACE_WCWIDTH])
  REPLACE_WCSWIDTH=0;   AC_SUBST([REPLACE_WCSWIDTH])
  REPLACE_WCSFTIME=0;   AC_SUBST([REPLACE_WCSFTIME])
])

# wchar_t.m4 serial 4 (gettext-0.18.2)
dnl Copyright (C) 2002-2003, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.
dnl Test whether <stddef.h> has the 'wchar_t' type.
dnl Prerequisite: AC_PROG_CC

AC_DEFUN([gt_TYPE_WCHAR_T],
[
  AC_CACHE_CHECK([for wchar_t], [gt_cv_c_wchar_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <stddef.h>
            wchar_t foo = (wchar_t)'\0';]],
          [[]])],
       [gt_cv_c_wchar_t=yes],
       [gt_cv_c_wchar_t=no])])
  if test $gt_cv_c_wchar_t = yes; then
    AC_DEFINE([HAVE_WCHAR_T], [1], [Define if you have the 'wchar_t' type.])
  fi
])

# wctype_h.m4 serial 21

dnl A placeholder for ISO C99 <wctype.h>, for platforms that lack it.

dnl Copyright (C) 2006-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Written by Paul Eggert.

AC_DEFUN([gl_WCTYPE_H],
[
  AC_REQUIRE([gl_WCTYPE_H_DEFAULTS])
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_CHECK_FUNCS_ONCE([iswcntrl])
  if test $ac_cv_func_iswcntrl = yes; then
    HAVE_ISWCNTRL=1
  else
    HAVE_ISWCNTRL=0
  fi
  AC_SUBST([HAVE_ISWCNTRL])

  AC_REQUIRE([gt_TYPE_WINT_T])
  if test $gt_cv_c_wint_t = yes; then
    HAVE_WINT_T=1
  else
    HAVE_WINT_T=0
  fi
  AC_SUBST([HAVE_WINT_T])

  AC_REQUIRE([gl_TYPE_WINT_T_PREREQ])

  gl_CHECK_NEXT_HEADERS([wctype.h])
  if test $ac_cv_header_wctype_h = yes; then
    if test $ac_cv_func_iswcntrl = yes; then
      dnl Linux libc5 has an iswprint function that returns 0 for all arguments.
      dnl The other functions are likely broken in the same way.
      AC_CACHE_CHECK([whether iswcntrl works], [gl_cv_func_iswcntrl_works],
        [
          AC_RUN_IFELSE(
            [AC_LANG_SOURCE([[
               /* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be
                  included before <wchar.h>.
                  BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h>
                  must be included before <wchar.h>.  */
               #include <stddef.h>
               #include <stdio.h>
               #include <time.h>
               #include <wchar.h>
               #include <wctype.h>
               int main () { return iswprint ('x') == 0; }
            ]])],
            [gl_cv_func_iswcntrl_works=yes], [gl_cv_func_iswcntrl_works=no],
            [dnl Guess no on Linux libc5, yes otherwise.
             AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stdlib.h>
                          #if __GNU_LIBRARY__ == 1
                          Linux libc5 i18n is broken.
                          #endif]], [])],
              [gl_cv_func_iswcntrl_works="guessing yes"],
              [gl_cv_func_iswcntrl_works="guessing no"])
            ])
        ])
    fi
    HAVE_WCTYPE_H=1
  else
    HAVE_WCTYPE_H=0
  fi
  AC_SUBST([HAVE_WCTYPE_H])

  case "$gl_cv_func_iswcntrl_works" in
    *yes) REPLACE_ISWCNTRL=0 ;;
    *)    REPLACE_ISWCNTRL=1 ;;
  esac
  AC_SUBST([REPLACE_ISWCNTRL])

  if test $HAVE_ISWCNTRL = 0 || test $REPLACE_ISWCNTRL = 1; then
    dnl Redefine all of iswcntrl, ..., iswxdigit in <wctype.h>.
    :
  fi

  if test $REPLACE_ISWCNTRL = 1; then
    REPLACE_TOWLOWER=1
  else
    AC_CHECK_FUNCS([towlower])
    if test $ac_cv_func_towlower = yes; then
      REPLACE_TOWLOWER=0
    else
      AC_CHECK_DECLS([towlower],,,
        [[/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be
             included before <wchar.h>.
             BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h>
             must be included before <wchar.h>.  */
          #include <stddef.h>
          #include <stdio.h>
          #include <time.h>
          #include <wchar.h>
          #if HAVE_WCTYPE_H
          # include <wctype.h>
          #endif
        ]])
      if test $ac_cv_have_decl_towlower = yes; then
        dnl On Minix 3.1.8, the system's <wctype.h> declares towlower() and
        dnl towupper() although it does not have the functions. Avoid a
        dnl collision with gnulib's replacement.
        REPLACE_TOWLOWER=1
      else
        REPLACE_TOWLOWER=0
      fi
    fi
  fi
  AC_SUBST([REPLACE_TOWLOWER])

  if test $HAVE_ISWCNTRL = 0 || test $REPLACE_TOWLOWER = 1; then
    dnl Redefine towlower, towupper in <wctype.h>.
    :
  fi

  dnl We assume that the wctype() and iswctype() functions exist if and only
  dnl if the type wctype_t is defined in <wchar.h> or in <wctype.h> if that
  dnl exists.
  dnl HP-UX 11.00 declares all these in <wchar.h> and lacks <wctype.h>.
  AC_CACHE_CHECK([for wctype_t], [gl_cv_type_wctype_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be
               included before <wchar.h>.
               BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h>
               must be included before <wchar.h>.  */
            #include <stddef.h>
            #include <stdio.h>
            #include <time.h>
            #include <wchar.h>
            #if HAVE_WCTYPE_H
            # include <wctype.h>
            #endif
            wctype_t a;
          ]],
          [[]])],
       [gl_cv_type_wctype_t=yes],
       [gl_cv_type_wctype_t=no])
    ])
  if test $gl_cv_type_wctype_t = no; then
    HAVE_WCTYPE_T=0
  fi

  dnl We assume that the wctrans() and towctrans() functions exist if and only
  dnl if the type wctrans_t is defined in <wctype.h>.
  AC_CACHE_CHECK([for wctrans_t], [gl_cv_type_wctrans_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be
               included before <wchar.h>.
               BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h>
               must be included before <wchar.h>.  */
            #include <stddef.h>
            #include <stdio.h>
            #include <time.h>
            #include <wchar.h>
            #include <wctype.h>
            wctrans_t a;
          ]],
          [[]])],
       [gl_cv_type_wctrans_t=yes],
       [gl_cv_type_wctrans_t=no])
    ])
  if test $gl_cv_type_wctrans_t = no; then
    HAVE_WCTRANS_T=0
  fi

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#if !(defined __GLIBC__ && !defined __UCLIBC__)
# include <stddef.h>
# include <stdio.h>
# include <time.h>
# include <wchar.h>
#endif
#include <wctype.h>
    ]],
    [wctype iswctype wctrans towctrans
    ])
])

AC_DEFUN([gl_WCTYPE_MODULE_INDICATOR],
[
  dnl Use AC_REQUIRE here, so that the default settings are expanded once only.
  AC_REQUIRE([gl_WCTYPE_H_DEFAULTS])
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

AC_DEFUN([gl_WCTYPE_H_DEFAULTS],
[
  GNULIB_ISWBLANK=0;    AC_SUBST([GNULIB_ISWBLANK])
  GNULIB_WCTYPE=0;      AC_SUBST([GNULIB_WCTYPE])
  GNULIB_ISWCTYPE=0;    AC_SUBST([GNULIB_ISWCTYPE])
  GNULIB_WCTRANS=0;     AC_SUBST([GNULIB_WCTRANS])
  GNULIB_TOWCTRANS=0;   AC_SUBST([GNULIB_TOWCTRANS])
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_ISWBLANK=1;      AC_SUBST([HAVE_ISWBLANK])
  HAVE_WCTYPE_T=1;      AC_SUBST([HAVE_WCTYPE_T])
  HAVE_WCTRANS_T=1;     AC_SUBST([HAVE_WCTRANS_T])
  REPLACE_ISWBLANK=0;   AC_SUBST([REPLACE_ISWBLANK])
])

# wint_t.m4 serial 7
dnl Copyright (C) 2003, 2007-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.
dnl Test whether <wchar.h> has the 'wint_t' type and whether gnulib's
dnl <wchar.h> or <wctype.h> would, if present, override 'wint_t'.
dnl Prerequisite: AC_PROG_CC

AC_DEFUN([gt_TYPE_WINT_T],
[
  AC_CACHE_CHECK([for wint_t], [gt_cv_c_wint_t],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be included
   before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
            wint_t foo = (wchar_t)'\0';]],
          [[]])],
       [gt_cv_c_wint_t=yes],
       [gt_cv_c_wint_t=no])])
  if test $gt_cv_c_wint_t = yes; then
    AC_DEFINE([HAVE_WINT_T], [1], [Define if you have the 'wint_t' type.])

    dnl Determine whether gnulib's <wchar.h> or <wctype.h> would, if present,
    dnl override 'wint_t'.
    AC_CACHE_CHECK([whether wint_t is too small],
      [gl_cv_type_wint_t_too_small],
      [AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM([[
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
   <wchar.h>.
   BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
   included before <wchar.h>.  */
#if !(defined __GLIBC__ && !defined __UCLIBC__)
# include <stddef.h>
# include <stdio.h>
# include <time.h>
#endif
#include <wchar.h>
              int verify[sizeof (wint_t) < sizeof (int) ? -1 : 1];
              ]])],
           [gl_cv_type_wint_t_too_small=no],
           [gl_cv_type_wint_t_too_small=yes])])
    if test $gl_cv_type_wint_t_too_small = yes; then
      GNULIB_OVERRIDES_WINT_T=1
    else
      GNULIB_OVERRIDES_WINT_T=0
    fi
  else
    GNULIB_OVERRIDES_WINT_T=0
  fi
  AC_SUBST([GNULIB_OVERRIDES_WINT_T])
])

dnl Prerequisites of the 'wint_t' override.
AC_DEFUN([gl_TYPE_WINT_T_PREREQ],
[
  AC_CHECK_HEADERS_ONCE([crtdefs.h])
  if test $ac_cv_header_crtdefs_h = yes; then
    HAVE_CRTDEFS_H=1
  else
    HAVE_CRTDEFS_H=0
  fi
  AC_SUBST([HAVE_CRTDEFS_H])
])

# write.m4 serial 6
dnl Copyright (C) 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_WRITE],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  m4_ifdef([gl_MSVC_INVAL], [
    AC_REQUIRE([gl_MSVC_INVAL])
    if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
      REPLACE_WRITE=1
    fi
  ])
  dnl This ifdef is just an optimization, to avoid performing a configure
  dnl check whose result is not used. It does not make the test of
  dnl GNULIB_UNISTD_H_SIGPIPE or GNULIB_SIGPIPE redundant.
  m4_ifdef([gl_SIGNAL_SIGPIPE], [
    gl_SIGNAL_SIGPIPE
    if test $gl_cv_header_signal_h_SIGPIPE != yes; then
      REPLACE_WRITE=1
    fi
  ])
  m4_ifdef([gl_NONBLOCKING_IO], [
    gl_NONBLOCKING_IO
    if test $gl_cv_have_nonblocking != yes; then
      REPLACE_WRITE=1
    fi
  ])
])

# Prerequisites of lib/write.c.
AC_DEFUN([gl_PREREQ_WRITE], [:])

# xalloc.m4 serial 18
dnl Copyright (C) 2002-2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_XALLOC], [:])

# xattr.m4 - check for Extended Attributes (Linux)
# serial 3

# Copyright (C) 2003, 2008-2012 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Originally written by Andreas Gruenbacher.
# http://www.suse.de/~agruen/coreutils/5.91/coreutils-xattr.diff

AC_DEFUN([gl_FUNC_XATTR],
[
  AC_ARG_ENABLE([xattr],
        AC_HELP_STRING([--disable-xattr],
                       [do not support extended attributes]),
        [use_xattr=$enableval], [use_xattr=yes])

  LIB_XATTR=
  AC_SUBST([LIB_XATTR])

  if test "$use_xattr" = "yes"; then
    AC_CHECK_HEADERS([attr/error_context.h attr/libattr.h])
    use_xattr=no
    if test $ac_cv_header_attr_libattr_h = yes \
        && test $ac_cv_header_attr_error_context_h = yes; then
      xattr_saved_LIBS=$LIBS
      AC_SEARCH_LIBS([attr_copy_file], [attr],
                     [test "$ac_cv_search_attr_copy_file" = "none required" ||
                        LIB_XATTR=$ac_cv_search_attr_copy_file])
      AC_CHECK_FUNCS([attr_copy_file attr_copy_action])
      LIBS=$xattr_saved_LIBS
      if test $ac_cv_func_attr_copy_file = yes \
	 && test $ac_cv_func_attr_copy_action = yes; then
        use_xattr=yes
      fi
    fi
    if test $use_xattr = no; then
      AC_MSG_WARN([libattr development library was not found or not usable.])
      AC_MSG_WARN([AC_PACKAGE_NAME will be built without xattr support.])
    fi
  fi
  AC_DEFINE_UNQUOTED([USE_XATTR], [`test $use_xattr != yes; echo $?`],
                     [Define if you want extended attribute support.])
])

# xsize.m4 serial 5
dnl Copyright (C) 2003-2004, 2008-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_XSIZE],
[
  dnl Prerequisites of lib/xsize.h.
  AC_REQUIRE([gl_SIZE_MAX])
  AC_CHECK_HEADERS([stdint.h])
])

# xstrndup.m4 serial 2
dnl Copyright (C) 2003, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_XSTRNDUP],
[
  gl_PREREQ_XSTRNDUP
])

# Prerequisites of lib/xstrndup.c.
AC_DEFUN([gl_PREREQ_XSTRNDUP], [
  :
])

# xvasprintf.m4 serial 2
dnl Copyright (C) 2006, 2009-2018 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl Prerequisites of lib/xvasprintf.c.
AC_DEFUN([gl_XVASPRINTF], [:])

