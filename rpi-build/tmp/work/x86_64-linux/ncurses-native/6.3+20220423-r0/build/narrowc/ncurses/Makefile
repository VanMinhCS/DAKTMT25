# $Id: Makefile.in,v 1.182 2021/08/19 23:43:40 tom Exp $
##############################################################################
# Copyright 2018-2020,2021 Thomas E. Dickey                                  #
# Copyright 1998-2017,2018 Free Software Foundation, Inc.                    #
#                                                                            #
# Permission is hereby granted, free of charge, to any person obtaining a    #
# copy of this software and associated documentation files (the "Software"), #
# to deal in the Software without restriction, including without limitation  #
# the rights to use, copy, modify, merge, publish, distribute, distribute    #
# with modifications, sublicense, and/or sell copies of the Software, and to #
# permit persons to whom the Software is furnished to do so, subject to the  #
# following conditions:                                                      #
#                                                                            #
# The above copyright notice and this permission notice shall be included in #
# all copies or substantial portions of the Software.                        #
#                                                                            #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    #
# THE ABOVE COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        #
# DEALINGS IN THE SOFTWARE.                                                  #
#                                                                            #
# Except as contained in this notice, the name(s) of the above copyright     #
# holders shall not be used in advertising or otherwise to promote the sale, #
# use or other dealings in this Software without prior written               #
# authorization.                                                             #
##############################################################################
#
# Author: Thomas E. Dickey 1996-on
#
# Makefile for ncurses source code.
#
# This makes the following:
#	programs
#	includes
#	libraries (normal/debug/profile/shared)
#
# The variable 'srcdir' refers to the source-distribution, and can be set with
# the configure script by "--srcdir=DIR".
#
# The rules are organized to produce the libraries for the configured models,
# and the programs with the configured default model.

# turn off _all_ suffix rules; we'll generate our own
.SUFFIXES:

SHELL		= /bin/bash
VPATH		= ../../../git/ncurses
THIS		= Makefile

TOP_MFLAGS	=  DESTDIR="$(DESTDIR)" RPATH_LIST="$(RPATH_LIST)"


x		= 
o		= .o

MODEL		= shared
DESTDIR		= 
top_srcdir	= ../../../git
srcdir		= ../../../git/ncurses
prefix		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
exec_prefix	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
bindir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/bin
libdir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib
includedir	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include
datarootdir	= ${prefix}/share
datadir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/share
includesubdir	= /ncurses

INCLUDEDIR	= $(DESTDIR)$(includedir)$(includesubdir)

PACKAGE		= ncurses

LIBTOOL		= 
LIBTOOL_OPTS	=  
LIBTOOL_CLEAN	= 
LIBTOOL_COMPILE	= 
LIBTOOL_LINK	= ${CC}
LIBTOOL_INSTALL	= 
LIBTOOL_UNINSTALL = 
LT_UNDEF	= 

INSTALL		= /home/ubuntu/yocto/rpi-build/tmp/hosttools/install -c
INSTALL_LIB	= /home/ubuntu/yocto/rpi-build/tmp/hosttools/install -c -m 644
INSTALL_PROG	= ${INSTALL} 
INSTALL_DATA	= ${INSTALL} -m 644

AR		= ar
ARFLAGS		= -curv
AWK		= gawk
LD		= ld 
LN_S		= ln -s -f
NM		= nm

CTAGS		= 
ETAGS		= 

CC		= gcc 
CPP		= gcc  -E
CFLAGS		= -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -O2 -pipe --param max-inline-insns-single=1200 
LIBS		= 

INCDIR		= $(srcdir)/../include
CPPFLAGS	= -DHAVE_CONFIG_H -DBUILDING_NCURSES -I../ncurses -I. -I${srcdir} -I../include -I${srcdir}/../include -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600 -DNDEBUG

CCFLAGS		= $(CPPFLAGS) $(CFLAGS)

BUILD_CPPFLAGS	= -DHAVE_CONFIG_H -DUSE_BUILD_CC -I../ncurses -I$(srcdir) -I../include -I$(INCDIR) -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE
BUILD_CC	= gcc 
BUILD_CCFLAGS	= -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE -O2 -pipe
BUILD_LDFLAGS	= -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2
BUILD_LIBS	= ${LIBS}

# The executables built in this directory are used for generating source that
# is compiled into the build, or are test-programs that are not installed.

BUILD_EXEEXT	= $x
x		= 

CFLAGS_LIBTOOL	= $(CCFLAGS)
CFLAGS_NORMAL	= $(CCFLAGS) -DNCURSES_STATIC
CFLAGS_DEBUG	= $(CCFLAGS) -DNCURSES_STATIC -g -DTRACE
CFLAGS_PROFILE	= $(CCFLAGS) -DNCURSES_STATIC -pg
CFLAGS_SHARED	= $(CCFLAGS) -fPIC

CFLAGS_DEFAULT	= $(CFLAGS_SHARED)

LINK		= $(LIBTOOL)
LDFLAGS		= -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2 

SHLIB_DIRS	= -L../lib
SHLIB_LIST	= $(SHLIB_DIRS)  -ltinfo 
TINFO_LIST	= $(SHLIB_DIRS)  
TICS_LIST	= $(SHLIB_DIRS)  -ltinfo 

RPATH_LIST	= ${libdir}
RESULTING_SYMS	= 
VERSIONED_SYMS	= 
MK_SHARED_LIB	= ${CC} ${LDFLAGS} ${CFLAGS} -shared -Wl,-soname,`basename $@ .${REL_VERSION}`.${ABI_VERSION},-stats,-lc -o $@

NCURSES_MAJOR	= 6
NCURSES_MINOR	= 3
REL_VERSION	= 5.9
ABI_VERSION	= 5

RANLIB		= ranlib -D

LIBRARIES	=  ../lib/libtinfo.so.${REL_VERSION}  ../lib/libtic.so.${REL_VERSION}  ../lib/libncurses.so.${REL_VERSION}

LINT		= 
LINT_OPTS	= 
LINT_LIBS	= -lncurses 

FALLBACK_LIST	= 

USE_BIG_STRINGS	= 1
TERMINFO_CAPS	= $(top_srcdir)/include/Caps
CAPLIST		= $(TERMINFO_CAPS) $(top_srcdir)/include/Caps-ncurses

TERMINFO	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/share/terminfo
TERMINFO_SRC	= ${top_srcdir}/misc/terminfo.src
TIC_PATH	= 
INFOCMP_PATH	= 

AUTO_SRC = \
	./codes.c \
	./comp_captab.c \
	./comp_userdefs.c \
	./expanded.c \
	./fallback.c \
	./lib_gen.c \
	./lib_keyname.c \
	./link_test.c \
	./names.c \
	./unctrl.c \
	init_keytry.h \
	keys.list

HEADER_DEPS	=  \
	../include/ncurses_cfg.h \
	../include/ncurses_def.h \
	../include/ncurses_dll.h \
	../include/curses.h \
	../include/term.h \
	../include/unctrl.h \
	$(INCDIR)/nc_alloc.h \
	$(INCDIR)/nc_panel.h \
	$(INCDIR)/nc_string.h \
	$(INCDIR)/nc_termios.h \
	$(INCDIR)/nc_tparm.h \
	$(INCDIR)/nc_win32.h \
	$(INCDIR)/term_entry.h \
	$(srcdir)/curses.priv.h \
	$(srcdir)/new_pair.h \
	$(srcdir)/term.priv.h

TEST_DEPS	= ../lib/libncurses.so
TEST_ARGS	=  -L../lib -lform -lmenu -lpanel -lncurses -ltinfo 
TEST_LDFLAGS	=  $(TEST_ARGS)   -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2

TEST_PROGS = \
	captoinfo$x \
	hardscroll$x \
	hashmap$x \
	lib_mvcur$x \
	link_test$x \
	report_hashing$x

LOCAL_LIBDIR	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/build/narrowc/lib

base	 = $(srcdir)/base
serial	 = $(srcdir)/tty
tinfo	 = $(srcdir)/tinfo
trace	 = $(srcdir)/trace
wide	 = $(srcdir)/widechar
win32con = $(srcdir)/win32con

################################################################################

.PHONY :	all
.PHONY :	check
.PHONY :	clean
.PHONY :	distclean
.PHONY :	libs
.PHONY :	mostlyclean
.PHONY :	realclean
.PHONY :	sources
.PHONY :	test_progs

all libs ::	$(AUTO_SRC) ../lib $(LIBRARIES)

all libs ::	report_offsets$(BUILD_EXEEXT)

sources:	$(AUTO_SRC)

$(DESTDIR)$(bindir) \
$(DESTDIR)$(libdir) :
	mkdir -p $@

../lib : ; mkdir $@

./fallback.c : $(tinfo)/MKfallback.sh
	$(SHELL) -e $(tinfo)/MKfallback.sh $(TERMINFO) $(TERMINFO_SRC) "$(TIC_PATH)" "$(INFOCMP_PATH)" $(FALLBACK_LIST) >$@

./lib_gen.c : $(base)/MKlib_gen.sh ../include/curses.h
	$(SHELL) -e $(base)/MKlib_gen.sh "$(CPP) $(CPPFLAGS)" "$(AWK)" generated <../include/curses.h >$@

init_keytry.h : make_keys$(BUILD_EXEEXT) keys.list
	./make_keys$(BUILD_EXEEXT) keys.list > $@

keys.list :	$(tinfo)/MKkeys_list.sh
	AWK=$(AWK) $(SHELL) $(tinfo)/MKkeys_list.sh $(CAPLIST) | LC_ALL=C sort >$@

make_keys$(BUILD_EXEEXT) : \
		build.priv.h \
		$(tinfo)/make_keys.c \
		./names.c
	$(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(tinfo)/make_keys.c $(BUILD_LDFLAGS) $(BUILD_LIBS)

make_hash$(BUILD_EXEEXT) : \
		build.priv.h \
		$(tinfo)/make_hash.c \
		../include/hashsize.h
	$(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(tinfo)/make_hash.c $(BUILD_LDFLAGS) $(BUILD_LIBS)

report_offsets$(BUILD_EXEEXT) : \
		$(srcdir)/curses.priv.h \
		$(srcdir)/report_offsets.c
	$(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(srcdir)/report_offsets.c $(BUILD_LDFLAGS) $(BUILD_LIBS)
	./report_offsets$(BUILD_EXEEXT)

./expanded.c : $(srcdir)/curses.priv.h $(serial)/MKexpanded.sh
	$(SHELL) -e $(serial)/MKexpanded.sh "$(CPP)" $(CPPFLAGS) > $@

./comp_captab.c: \
		make_hash$(BUILD_EXEEXT) \
		../include/hashsize.h \
		$(tinfo)/MKcaptab.sh \
		$(tinfo)/MKcaptab.awk
	$(SHELL) -e $(tinfo)/MKcaptab.sh $(AWK) $(USE_BIG_STRINGS) $(tinfo)/MKcaptab.awk $(CAPLIST) > $@

./comp_userdefs.c: \
		make_hash$(BUILD_EXEEXT) \
		../include/hashsize.h \
		$(tinfo)/MKuserdefs.sh
	$(SHELL) -e $(tinfo)/MKuserdefs.sh $(AWK) $(USE_BIG_STRINGS) $(CAPLIST) > $@

./lib_keyname.c: keys.list $(base)/MKkeyname.awk
	$(AWK) -f $(base)/MKkeyname.awk bigstrings=$(USE_BIG_STRINGS) keys.list > $@

./codes.c: $(tinfo)/MKcodes.awk
	$(AWK) -f $(tinfo)/MKcodes.awk bigstrings=$(USE_BIG_STRINGS) $(CAPLIST) >$@

./names.c: $(tinfo)/MKnames.awk
	$(AWK) -f $(tinfo)/MKnames.awk bigstrings=$(USE_BIG_STRINGS) $(CAPLIST) >$@

./unctrl.c: $(base)/MKunctrl.awk
	echo | $(AWK) -f $(base)/MKunctrl.awk bigstrings=$(USE_BIG_STRINGS) >$@

tags:
	$(CTAGS) *.[ch] */*.[ch]

#TAGS:
#	$(ETAGS) *.[ch] */*.[ch]

mostlyclean ::
	-rm -f core tags TAGS *~ *.bak *.i *.ln *.atac
	-test -d trace || rm -f trace
	-rm -f $(TEST_PROGS)

clean :: mostlyclean
	-rm -f $(AUTO_SRC)
	-rm -f make_keys$(BUILD_EXEEXT)
	-rm -f make_hash$(BUILD_EXEEXT)
	-rm -f report_offsets$(BUILD_EXEEXT)
	-rm -rf .libs *.dSYM *.map

distclean :: clean
	-rm -f Makefile

realclean :: distclean

# These rules are used to allow "make -n" to work on a clean directory-tree
../include/hashsize.h \
../include/parametrized.h \
../include/term.h :
	( cd ../include && $(MAKE) $(TOP_MFLAGS) )

# These rules build test-programs for the modules that have test-drivers
.PHONY :	test_progs
test_progs : $(TEST_PROGS)

./link_test.c : $(base)/MKlib_gen.sh ../include/curses.h
	$(SHELL) -e $(base)/MKlib_gen.sh "$(CPP) $(CPPFLAGS)" "$(AWK)" implemented <../include/curses.h >$@

captoinfo$x : $(tinfo)/captoinfo.c $(TEST_DEPS)
	 $(LIBTOOL_LINK) -o $@ $(CFLAGS_DEFAULT) -DMAIN $(tinfo)/captoinfo.c $(TEST_LDFLAGS)

hardscroll$x : $(serial)/hardscroll.c $(TEST_DEPS)
	 $(LIBTOOL_LINK) -o $@ $(CFLAGS_DEFAULT) -DSCROLLDEBUG $(serial)/hardscroll.c $(TEST_LDFLAGS)

hashmap$x : $(serial)/hashmap.c $(serial)/hardscroll.c $(TEST_DEPS)
	 $(LIBTOOL_LINK) -o $@ $(CFLAGS_DEFAULT) -DHASHDEBUG $(serial)/hashmap.c $(serial)/hardscroll.c $(TEST_LDFLAGS)

lib_mvcur$x : $(serial)/lib_mvcur.c $(TEST_DEPS) \
		../obj_s/dump_entry$o
	 $(LIBTOOL_LINK) -o $@ $(CFLAGS_DEFAULT) -DNCURSES_TEST -I$(serial)/../../progs $(serial)/lib_mvcur.c ../obj_s/dump_entry$o $(TEST_LDFLAGS)

link_test$x : ./link_test.c $(TEST_DEPS) \
		../obj_s/link_test$o
	 $(CC) -o $@ $(CFLAGS_DEFAULT) ../obj_s/link_test$o $(TEST_LDFLAGS)

../obj_s/dump_entry$o:
	( cd ../progs && $(MAKE) ../obj_s/dump_entry$o )

report_hashing$x : \
		$(srcdir)/curses.priv.h \
		$(srcdir)/report_hashing.c $(TEST_DEPS)
	 $(CC) -o $@ $(CFLAGS_DEFAULT) report_hashing.c $(TEST_LDFLAGS)

# Verify that each header-file can be compiled without including another.
.PHONY :	check_headers
check_headers:
	@$(SHELL) -c "for header in *.h;\
		do \
			echo \"** testing \$${header}\" ; \
			echo \"#include <\$${header}>\" >headers.c; \
			echo \"int main(void) { return 0; }\" >>headers.c; \
			$(CC) -c $(CFLAGS) $(CPPFLAGS) headers.c; \
		done"
	-@rm -f headers.*

.PHONY :	check_objects
check_objects: test_progs

check :: check_headers check_objects

###############################################################################
# The remainder of this file is automatically generated during configuration
###############################################################################

# generated by mk-0th.awk
#   libname:    ncurses
#   subsets:    ticlib termlib+ext_tinfo base+ext_funcs
#   ticlib:     tic
#   termlib:    tinfo

.SUFFIXES: .c .cc .h .i .ii
.c.i :
	$(CPP) $(CPPFLAGS) $< >$@
.cc.ii :
	$(CPP) $(CPPFLAGS) $< >$@
.h.i :
	$(CPP) $(CPPFLAGS) $< >$@

C_SRC = \
	$(serial)/hardscroll.c \
	$(serial)/hashmap.c \
	$(base)/lib_addch.c \
	$(base)/lib_addstr.c \
	$(base)/lib_beep.c \
	$(base)/lib_bkgd.c \
	$(base)/lib_box.c \
	$(base)/lib_chgat.c \
	$(base)/lib_clear.c \
	$(base)/lib_clearok.c \
	$(base)/lib_clrbot.c \
	$(base)/lib_clreol.c \
	$(base)/lib_color.c \
	$(base)/lib_colorset.c \
	$(base)/lib_delch.c \
	$(base)/lib_delwin.c \
	$(base)/lib_echo.c \
	$(base)/lib_endwin.c \
	$(base)/lib_erase.c \
	$(base)/lib_flash.c \
	./lib_gen.c \
	$(base)/lib_getch.c \
	$(base)/lib_getstr.c \
	$(base)/lib_hline.c \
	$(base)/lib_immedok.c \
	$(base)/lib_inchstr.c \
	$(base)/lib_initscr.c \
	$(base)/lib_insch.c \
	$(base)/lib_insdel.c \
	$(base)/lib_insnstr.c \
	$(base)/lib_instr.c \
	$(base)/lib_isendwin.c \
	$(base)/lib_leaveok.c \
	$(base)/lib_mouse.c \
	$(base)/lib_move.c \
	$(serial)/lib_mvcur.c \
	$(base)/lib_mvwin.c \
	$(base)/lib_newterm.c \
	$(base)/lib_newwin.c \
	$(base)/lib_nl.c \
	$(base)/lib_overlay.c \
	$(base)/lib_pad.c \
	$(base)/lib_printw.c \
	$(base)/lib_redrawln.c \
	$(base)/lib_refresh.c \
	$(base)/lib_restart.c \
	$(base)/lib_scanw.c \
	$(base)/lib_screen.c \
	$(base)/lib_scroll.c \
	$(base)/lib_scrollok.c \
	$(base)/lib_scrreg.c \
	$(base)/lib_set_term.c \
	$(base)/lib_slk.c \
	$(base)/lib_slkatr_set.c \
	$(base)/lib_slkatrof.c \
	$(base)/lib_slkatron.c \
	$(base)/lib_slkatrset.c \
	$(base)/lib_slkattr.c \
	$(base)/lib_slkclear.c \
	$(base)/lib_slkcolor.c \
	$(base)/lib_slkinit.c \
	$(base)/lib_slklab.c \
	$(base)/lib_slkrefr.c \
	$(base)/lib_slkset.c \
	$(base)/lib_slktouch.c \
	$(base)/lib_touch.c \
	$(trace)/lib_tracedmp.c \
	$(trace)/lib_tracemse.c \
	$(serial)/lib_tstp.c \
	$(base)/lib_ungetch.c \
	$(serial)/lib_vidattr.c \
	$(base)/lib_vline.c \
	$(base)/lib_wattroff.c \
	$(base)/lib_wattron.c \
	$(base)/lib_winch.c \
	$(base)/lib_window.c \
	$(base)/nc_panel.c \
	$(base)/safe_sprintf.c \
	$(serial)/tty_update.c \
	$(trace)/varargs.c \
	$(base)/vsscanf.c \
	$(base)/lib_freeall.c \
	./expanded.c \
	$(base)/legacy_coding.c \
	$(base)/lib_dft_fgbg.c \
	$(tinfo)/lib_print.c \
	$(base)/new_pair.c \
	$(base)/resizeterm.c \
	$(trace)/trace_xnames.c \
	$(tinfo)/use_screen.c \
	$(base)/use_window.c \
	$(base)/wresize.c \
	$(tinfo)/access.c \
	$(tinfo)/add_tries.c \
	$(tinfo)/alloc_ttype.c \
	./codes.c \
	./comp_captab.c \
	$(tinfo)/comp_error.c \
	$(tinfo)/comp_hash.c \
	./comp_userdefs.c \
	$(tinfo)/db_iterator.c \
	$(tinfo)/doalloc.c \
	$(tinfo)/entries.c \
	./fallback.c \
	$(tinfo)/free_ttype.c \
	$(tinfo)/getenv_num.c \
	$(tinfo)/home_terminfo.c \
	$(tinfo)/init_keytry.c \
	$(tinfo)/lib_acs.c \
	$(tinfo)/lib_baudrate.c \
	$(tinfo)/lib_cur_term.c \
	$(tinfo)/lib_data.c \
	$(tinfo)/lib_has_cap.c \
	$(tinfo)/lib_kernel.c \
	./lib_keyname.c \
	$(tinfo)/lib_longname.c \
	$(tinfo)/lib_napms.c \
	$(tinfo)/lib_options.c \
	$(tinfo)/lib_raw.c \
	$(tinfo)/lib_setup.c \
	$(tinfo)/lib_termcap.c \
	$(tinfo)/lib_termname.c \
	$(tinfo)/lib_tgoto.c \
	$(tinfo)/lib_ti.c \
	$(tinfo)/lib_tparm.c \
	$(tinfo)/lib_tputs.c \
	$(trace)/lib_trace.c \
	$(trace)/lib_traceatr.c \
	$(trace)/lib_tracebits.c \
	$(trace)/lib_tracechr.c \
	$(tinfo)/lib_ttyflags.c \
	$(serial)/lib_twait.c \
	$(tinfo)/name_match.c \
	./names.c \
	$(tinfo)/obsolete.c \
	$(tinfo)/read_entry.c \
	$(tinfo)/read_termcap.c \
	$(tinfo)/strings.c \
	$(trace)/trace_buf.c \
	$(trace)/trace_tries.c \
	$(base)/tries.c \
	$(tinfo)/trim_sgr0.c \
	./unctrl.c \
	$(trace)/visbuf.c \
	$(tinfo)/alloc_entry.c \
	$(tinfo)/captoinfo.c \
	$(tinfo)/comp_expand.c \
	$(tinfo)/comp_parse.c \
	$(tinfo)/comp_scan.c \
	$(tinfo)/parse_entry.c \
	$(tinfo)/write_entry.c \
	$(base)/define_key.c \
	$(tinfo)/hashed_db.c \
	$(base)/key_defined.c \
	$(base)/keybound.c \
	$(base)/keyok.c \
	$(base)/version.c

# Producing llib-lncurses is time-consuming, so there's no direct-dependency for
# it in the lintlib rule.  We'll only remove in the cleanest setup.

NCURSES_SRC = \
	$(serial)/hardscroll.c \
	$(serial)/hashmap.c \
	$(base)/lib_addch.c \
	$(base)/lib_addstr.c \
	$(base)/lib_beep.c \
	$(base)/lib_bkgd.c \
	$(base)/lib_box.c \
	$(base)/lib_chgat.c \
	$(base)/lib_clear.c \
	$(base)/lib_clearok.c \
	$(base)/lib_clrbot.c \
	$(base)/lib_clreol.c \
	$(base)/lib_color.c \
	$(base)/lib_colorset.c \
	$(base)/lib_delch.c \
	$(base)/lib_delwin.c \
	$(base)/lib_echo.c \
	$(base)/lib_endwin.c \
	$(base)/lib_erase.c \
	$(base)/lib_flash.c \
	./lib_gen.c \
	$(base)/lib_getch.c \
	$(base)/lib_getstr.c \
	$(base)/lib_hline.c \
	$(base)/lib_immedok.c \
	$(base)/lib_inchstr.c \
	$(base)/lib_initscr.c \
	$(base)/lib_insch.c \
	$(base)/lib_insdel.c \
	$(base)/lib_insnstr.c \
	$(base)/lib_instr.c \
	$(base)/lib_isendwin.c \
	$(base)/lib_leaveok.c \
	$(base)/lib_mouse.c \
	$(base)/lib_move.c \
	$(serial)/lib_mvcur.c \
	$(base)/lib_mvwin.c \
	$(base)/lib_newterm.c \
	$(base)/lib_newwin.c \
	$(base)/lib_nl.c \
	$(base)/lib_overlay.c \
	$(base)/lib_pad.c \
	$(base)/lib_printw.c \
	$(base)/lib_redrawln.c \
	$(base)/lib_refresh.c \
	$(base)/lib_restart.c \
	$(base)/lib_scanw.c \
	$(base)/lib_screen.c \
	$(base)/lib_scroll.c \
	$(base)/lib_scrollok.c \
	$(base)/lib_scrreg.c \
	$(base)/lib_set_term.c \
	$(base)/lib_slk.c \
	$(base)/lib_slkatr_set.c \
	$(base)/lib_slkatrof.c \
	$(base)/lib_slkatron.c \
	$(base)/lib_slkatrset.c \
	$(base)/lib_slkattr.c \
	$(base)/lib_slkclear.c \
	$(base)/lib_slkcolor.c \
	$(base)/lib_slkinit.c \
	$(base)/lib_slklab.c \
	$(base)/lib_slkrefr.c \
	$(base)/lib_slkset.c \
	$(base)/lib_slktouch.c \
	$(base)/lib_touch.c \
	$(trace)/lib_tracedmp.c \
	$(trace)/lib_tracemse.c \
	$(serial)/lib_tstp.c \
	$(base)/lib_ungetch.c \
	$(serial)/lib_vidattr.c \
	$(base)/lib_vline.c \
	$(base)/lib_wattroff.c \
	$(base)/lib_wattron.c \
	$(base)/lib_winch.c \
	$(base)/lib_window.c \
	$(base)/nc_panel.c \
	$(base)/safe_sprintf.c \
	$(serial)/tty_update.c \
	$(trace)/varargs.c \
	$(base)/vsscanf.c \
	$(base)/lib_freeall.c \
	./expanded.c \
	$(base)/legacy_coding.c \
	$(base)/lib_dft_fgbg.c \
	$(tinfo)/lib_print.c \
	$(base)/new_pair.c \
	$(base)/resizeterm.c \
	$(trace)/trace_xnames.c \
	$(tinfo)/use_screen.c \
	$(base)/use_window.c \
	$(base)/wresize.c

clean ::
	rm -f llib-lncurses.*

realclean ::
	rm -f llib-lncurses

llib-lncurses : $(NCURSES_SRC)
	cproto -a -l -DNCURSES_ENABLE_STDBOOL_H=0 -DLINT $(CPPFLAGS) $(NCURSES_SRC) >$@

lintlib ::
	sh $(srcdir)/../misc/makellib ncurses $(CPPFLAGS)

lint ::
	$(LINT) $(LINT_OPTS) $(CPPFLAGS) $(NCURSES_SRC) $(LINT_LIBS)

TIC_SRC = \
	$(tinfo)/alloc_entry.c \
	$(tinfo)/captoinfo.c \
	$(tinfo)/comp_expand.c \
	$(tinfo)/comp_parse.c \
	$(tinfo)/comp_scan.c \
	$(tinfo)/parse_entry.c \
	$(tinfo)/write_entry.c

clean ::
	rm -f llib-ltic.*

realclean ::
	rm -f llib-ltic

llib-ltic : $(TIC_SRC)
	cproto -a -l -DNCURSES_ENABLE_STDBOOL_H=0 -DLINT $(CPPFLAGS) $(TIC_SRC) >$@

lintlib ::
	sh $(srcdir)/../misc/makellib tic $(CPPFLAGS)

lint ::
	$(LINT) $(LINT_OPTS) $(CPPFLAGS) $(TIC_SRC) $(LINT_LIBS)

TINFO_SRC = \
	$(tinfo)/access.c \
	$(tinfo)/add_tries.c \
	$(tinfo)/alloc_ttype.c \
	./codes.c \
	./comp_captab.c \
	$(tinfo)/comp_error.c \
	$(tinfo)/comp_hash.c \
	./comp_userdefs.c \
	$(tinfo)/db_iterator.c \
	$(tinfo)/doalloc.c \
	$(tinfo)/entries.c \
	./fallback.c \
	$(tinfo)/free_ttype.c \
	$(tinfo)/getenv_num.c \
	$(tinfo)/home_terminfo.c \
	$(tinfo)/init_keytry.c \
	$(tinfo)/lib_acs.c \
	$(tinfo)/lib_baudrate.c \
	$(tinfo)/lib_cur_term.c \
	$(tinfo)/lib_data.c \
	$(tinfo)/lib_has_cap.c \
	$(tinfo)/lib_kernel.c \
	./lib_keyname.c \
	$(tinfo)/lib_longname.c \
	$(tinfo)/lib_napms.c \
	$(tinfo)/lib_options.c \
	$(tinfo)/lib_raw.c \
	$(tinfo)/lib_setup.c \
	$(tinfo)/lib_termcap.c \
	$(tinfo)/lib_termname.c \
	$(tinfo)/lib_tgoto.c \
	$(tinfo)/lib_ti.c \
	$(tinfo)/lib_tparm.c \
	$(tinfo)/lib_tputs.c \
	$(trace)/lib_trace.c \
	$(trace)/lib_traceatr.c \
	$(trace)/lib_tracebits.c \
	$(trace)/lib_tracechr.c \
	$(tinfo)/lib_ttyflags.c \
	$(serial)/lib_twait.c \
	$(tinfo)/name_match.c \
	./names.c \
	$(tinfo)/obsolete.c \
	$(tinfo)/read_entry.c \
	$(tinfo)/read_termcap.c \
	$(tinfo)/strings.c \
	$(trace)/trace_buf.c \
	$(trace)/trace_tries.c \
	$(base)/tries.c \
	$(tinfo)/trim_sgr0.c \
	./unctrl.c \
	$(trace)/visbuf.c \
	$(base)/define_key.c \
	$(tinfo)/hashed_db.c \
	$(base)/key_defined.c \
	$(base)/keybound.c \
	$(base)/keyok.c \
	$(base)/version.c

clean ::
	rm -f llib-ltinfo.*

realclean ::
	rm -f llib-ltinfo

llib-ltinfo : $(TINFO_SRC)
	cproto -a -l -DNCURSES_ENABLE_STDBOOL_H=0 -DLINT $(CPPFLAGS) $(TINFO_SRC) >$@

lintlib ::
	sh $(srcdir)/../misc/makellib tinfo $(CPPFLAGS)

lint ::
	$(LINT) $(LINT_OPTS) $(CPPFLAGS) $(TINFO_SRC) $(LINT_LIBS)

# generated by mk-1st.awk (subset=ticlib)
#  name:            tic
#  traces:          DEBUG
#  MODEL:           SHARED
#  CXX_MODEL:       NORMAL
#  LIB_SUFFIX:      
#  USE_LIB_SUFFIX:  
#  model:           obj_s
#  prefix:          lib
#  suffix:          .so
#  subset:          ticlib
#  driver:          no
#  ShlibVer:        rel
#  ShlibVerInfix:   no
#  SymLink:         ln -s -f
#  TermlibRoot:     tinfo
#  TermlibSuffix:   .so
#  ReLink:          yes
#  ReRanlib:        yes
#  DoLinks:         yes
#  rmSoLocs:        no
#  ldconfig:        /sbin/ldconfig
#  make_phony:      yes
#  overwrite:       no
#  depend:          ../include/ncurses_cfg.h ${srcdir}/curses.priv.h
#  host:            x86_64-pc-linux-gnu
#  libtool_version: -version-number

SHARED_P_OBJS = \
	../obj_s/alloc_entry$o \
	../obj_s/captoinfo$o \
	../obj_s/comp_expand$o \
	../obj_s/comp_parse$o \
	../obj_s/comp_scan$o \
	../obj_s/parse_entry$o \
	../obj_s/write_entry$o

$(SHARED_P_OBJS) : ../include/ncurses_cfg.h ${srcdir}/curses.priv.h

../lib/libtic.so.$(REL_VERSION) : \
		../lib/libtinfo.so.$(REL_VERSION) \
		$(RESULTING_SYMS) $(SHARED_P_OBJS)
	@echo linking $@
	@mkdir -p ../lib
	$(MK_SHARED_LIB) $(SHARED_P_OBJS) $(TICS_LIST)
	cd ../lib && ($(LN_S) libtic.so.$(REL_VERSION) libtic.so.$(ABI_VERSION); $(LN_S) libtic.so.$(ABI_VERSION) libtic.so; )

install \
install.libs \
install.tic :: $(DESTDIR)$(libdir)/libtic.so.$(REL_VERSION)

$(DESTDIR)$(libdir)/libtic.so.$(REL_VERSION) : \
		../lib/libtinfo.so.$(REL_VERSION) \
		$(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION) \
		$(RESULTING_SYMS) $(SHARED_P_OBJS)
	@echo linking $@
	@mkdir -p $(DESTDIR)$(libdir)
	$(MK_SHARED_LIB) $(SHARED_P_OBJS) $(TICS_LIST)
	cd $(DESTDIR)$(libdir) && ($(LN_S) libtic.so.$(REL_VERSION) libtic.so.$(ABI_VERSION); $(LN_S) libtic.so.$(ABI_VERSION) libtic.so; )
	- test -z "$(DESTDIR)" && /sbin/ldconfig

uninstall \
uninstall.libs \
uninstall.tic ::
	@echo uninstalling $(DESTDIR)$(libdir)/libtic.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtic.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtic.so.$(ABI_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtic.so

clean ::
	-rm -f ../lib/libtic.so.$(REL_VERSION)
	-rm -f ../lib/libtic.so.$(ABI_VERSION)
	-rm -f ../lib/libtic.so

mostlyclean::
	-rm -f $(SHARED_P_OBJS)

# generated by mk-2nd.awk
#   model:      obj_s
#   MODEL:      SHARED
#   echo:       yes
#   subset:     ticlib
#   crenames:   yes
#   cxxrenames: yes
#   traces:     DEBUG
#   srcdir:     ../../git

../obj_s/alloc_entry$o :	$(tinfo)/alloc_entry.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/alloc_entry.c -o ../obj_s/alloc_entry$o

../obj_s/captoinfo$o :	$(tinfo)/captoinfo.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/captoinfo.c -o ../obj_s/captoinfo$o

../obj_s/comp_expand$o :	$(tinfo)/comp_expand.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/comp_expand.c -o ../obj_s/comp_expand$o

../obj_s/comp_parse$o :	$(tinfo)/comp_parse.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/comp_parse.c -o ../obj_s/comp_parse$o

../obj_s/comp_scan$o :	$(tinfo)/comp_scan.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/comp_scan.c -o ../obj_s/comp_scan$o

../obj_s/parse_entry$o :	$(tinfo)/parse_entry.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/parametrized.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/parse_entry.c -o ../obj_s/parse_entry$o

../obj_s/write_entry$o :	$(tinfo)/write_entry.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			$(INCDIR)/hashed_db.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/write_entry.c -o ../obj_s/write_entry$o


# generated by mk-1st.awk (subset=termlib+ext_tinfo)
#  name:            tinfo
#  traces:          DEBUG
#  MODEL:           SHARED
#  CXX_MODEL:       NORMAL
#  LIB_SUFFIX:      
#  USE_LIB_SUFFIX:  
#  model:           obj_s
#  prefix:          lib
#  suffix:          .so
#  subset:          termlib+ext_tinfo
#  driver:          no
#  ShlibVer:        rel
#  ShlibVerInfix:   no
#  SymLink:         ln -s -f
#  TermlibRoot:     tinfo
#  TermlibSuffix:   .so
#  ReLink:          yes
#  ReRanlib:        yes
#  DoLinks:         yes
#  rmSoLocs:        no
#  ldconfig:        /sbin/ldconfig
#  make_phony:      yes
#  overwrite:       no
#  depend:          ../include/ncurses_cfg.h ${srcdir}/curses.priv.h
#  host:            x86_64-pc-linux-gnu
#  libtool_version: -version-number

SHARED_T_OBJS = \
	../obj_s/access$o \
	../obj_s/add_tries$o \
	../obj_s/alloc_ttype$o \
	../obj_s/codes$o \
	../obj_s/comp_captab$o \
	../obj_s/comp_error$o \
	../obj_s/comp_hash$o \
	../obj_s/comp_userdefs$o \
	../obj_s/db_iterator$o \
	../obj_s/doalloc$o \
	../obj_s/entries$o \
	../obj_s/fallback$o \
	../obj_s/free_ttype$o \
	../obj_s/getenv_num$o \
	../obj_s/home_terminfo$o \
	../obj_s/init_keytry$o \
	../obj_s/lib_acs$o \
	../obj_s/lib_baudrate$o \
	../obj_s/lib_cur_term$o \
	../obj_s/lib_data$o \
	../obj_s/lib_has_cap$o \
	../obj_s/lib_kernel$o \
	../obj_s/lib_keyname$o \
	../obj_s/lib_longname$o \
	../obj_s/lib_napms$o \
	../obj_s/lib_options$o \
	../obj_s/lib_raw$o \
	../obj_s/lib_setup$o \
	../obj_s/lib_termcap$o \
	../obj_s/lib_termname$o \
	../obj_s/lib_tgoto$o \
	../obj_s/lib_ti$o \
	../obj_s/lib_tparm$o \
	../obj_s/lib_tputs$o \
	../obj_s/lib_trace$o \
	../obj_s/lib_ttyflags$o \
	../obj_s/lib_twait$o \
	../obj_s/name_match$o \
	../obj_s/names$o \
	../obj_s/obsolete$o \
	../obj_s/read_entry$o \
	../obj_s/read_termcap$o \
	../obj_s/strings$o \
	../obj_s/tries$o \
	../obj_s/trim_sgr0$o \
	../obj_s/unctrl$o \
	../obj_s/visbuf$o \
	../obj_s/define_key$o \
	../obj_s/hashed_db$o \
	../obj_s/key_defined$o \
	../obj_s/keybound$o \
	../obj_s/keyok$o \
	../obj_s/version$o

$(SHARED_T_OBJS) : ../include/ncurses_cfg.h ${srcdir}/curses.priv.h

../lib/libtinfo.so.$(REL_VERSION) : \
		$(RESULTING_SYMS) $(SHARED_T_OBJS)
	@echo linking $@
	@mkdir -p ../lib
	$(MK_SHARED_LIB) $(SHARED_T_OBJS) $(TINFO_LIST)
	cd ../lib && ($(LN_S) libtinfo.so.$(REL_VERSION) libtinfo.so.$(ABI_VERSION); $(LN_S) libtinfo.so.$(ABI_VERSION) libtinfo.so; )

install \
install.libs \
install.tinfo :: $(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION)

$(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION) : \
		$(RESULTING_SYMS) $(SHARED_T_OBJS)
	@echo linking $@
	@mkdir -p $(DESTDIR)$(libdir)
	$(MK_SHARED_LIB) $(SHARED_T_OBJS) $(TINFO_LIST)
	cd $(DESTDIR)$(libdir) && ($(LN_S) libtinfo.so.$(REL_VERSION) libtinfo.so.$(ABI_VERSION); $(LN_S) libtinfo.so.$(ABI_VERSION) libtinfo.so; )
	- test -z "$(DESTDIR)" && /sbin/ldconfig

uninstall \
uninstall.libs \
uninstall.tinfo ::
	@echo uninstalling $(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtinfo.so.$(ABI_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libtinfo.so

clean ::
	-rm -f ../lib/libtinfo.so.$(REL_VERSION)
	-rm -f ../lib/libtinfo.so.$(ABI_VERSION)
	-rm -f ../lib/libtinfo.so

mostlyclean::
	-rm -f $(SHARED_T_OBJS)

# generated by mk-2nd.awk
#   model:      obj_s
#   MODEL:      SHARED
#   echo:       yes
#   subset:     termlib+ext_tinfo
#   crenames:   yes
#   cxxrenames: yes
#   traces:     DEBUG
#   srcdir:     ../../git

../obj_s/access$o :	$(tinfo)/access.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/access.c -o ../obj_s/access$o

../obj_s/add_tries$o :	$(tinfo)/add_tries.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/add_tries.c -o ../obj_s/add_tries$o

../obj_s/alloc_ttype$o :	$(tinfo)/alloc_ttype.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/alloc_ttype.c -o ../obj_s/alloc_ttype$o

../obj_s/codes$o :	./codes.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/codes.c -o ../obj_s/codes$o

../obj_s/comp_captab$o :	./comp_captab.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/hashsize.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/comp_captab.c -o ../obj_s/comp_captab$o

../obj_s/comp_error$o :	$(tinfo)/comp_error.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/comp_error.c -o ../obj_s/comp_error$o

../obj_s/comp_hash$o :	$(tinfo)/comp_hash.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/hashsize.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/comp_hash.c -o ../obj_s/comp_hash$o

../obj_s/comp_userdefs$o :	./comp_userdefs.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/hashsize.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/comp_userdefs.c -o ../obj_s/comp_userdefs$o

../obj_s/db_iterator$o :	$(tinfo)/db_iterator.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/db_iterator.c -o ../obj_s/db_iterator$o

../obj_s/doalloc$o :	$(tinfo)/doalloc.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/doalloc.c -o ../obj_s/doalloc$o

../obj_s/entries$o :	$(tinfo)/entries.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/entries.c -o ../obj_s/entries$o

../obj_s/fallback$o :	./fallback.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/fallback.c -o ../obj_s/fallback$o

../obj_s/free_ttype$o :	$(tinfo)/free_ttype.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/free_ttype.c -o ../obj_s/free_ttype$o

../obj_s/getenv_num$o :	$(tinfo)/getenv_num.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/getenv_num.c -o ../obj_s/getenv_num$o

../obj_s/home_terminfo$o :	$(tinfo)/home_terminfo.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/home_terminfo.c -o ../obj_s/home_terminfo$o

../obj_s/init_keytry$o :	$(tinfo)/init_keytry.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			init_keytry.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/init_keytry.c -o ../obj_s/init_keytry$o

../obj_s/lib_acs$o :	$(tinfo)/lib_acs.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_acs.c -o ../obj_s/lib_acs$o

../obj_s/lib_baudrate$o :	$(tinfo)/lib_baudrate.c \
			$(HEADER_DEPS) \
			../include/termcap.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_baudrate.c -o ../obj_s/lib_baudrate$o

../obj_s/lib_cur_term$o :	$(tinfo)/lib_cur_term.c \
			$(HEADER_DEPS) \
			../include/termcap.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_cur_term.c -o ../obj_s/lib_cur_term$o

../obj_s/lib_data$o :	$(tinfo)/lib_data.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_data.c -o ../obj_s/lib_data$o

../obj_s/lib_has_cap$o :	$(tinfo)/lib_has_cap.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_has_cap.c -o ../obj_s/lib_has_cap$o

../obj_s/lib_kernel$o :	$(tinfo)/lib_kernel.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_kernel.c -o ../obj_s/lib_kernel$o

../obj_s/lib_keyname$o :	./lib_keyname.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/lib_keyname.c -o ../obj_s/lib_keyname$o

../obj_s/lib_longname$o :	$(tinfo)/lib_longname.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_longname.c -o ../obj_s/lib_longname$o

../obj_s/lib_napms$o :	$(tinfo)/lib_napms.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_napms.c -o ../obj_s/lib_napms$o

../obj_s/lib_options$o :	$(tinfo)/lib_options.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_options.c -o ../obj_s/lib_options$o

../obj_s/lib_raw$o :	$(tinfo)/lib_raw.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_raw.c -o ../obj_s/lib_raw$o

../obj_s/lib_setup$o :	$(tinfo)/lib_setup.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_setup.c -o ../obj_s/lib_setup$o

../obj_s/lib_termcap$o :	$(tinfo)/lib_termcap.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/termcap.h \
			$(INCDIR)/capdefaults.c
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_termcap.c -o ../obj_s/lib_termcap$o

../obj_s/lib_termname$o :	$(tinfo)/lib_termname.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_termname.c -o ../obj_s/lib_termname$o

../obj_s/lib_tgoto$o :	$(tinfo)/lib_tgoto.c \
			$(HEADER_DEPS) \
			../include/termcap.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_tgoto.c -o ../obj_s/lib_tgoto$o

../obj_s/lib_ti$o :	$(tinfo)/lib_ti.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_ti.c -o ../obj_s/lib_ti$o

../obj_s/lib_tparm$o :	$(tinfo)/lib_tparm.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_tparm.c -o ../obj_s/lib_tparm$o

../obj_s/lib_tputs$o :	$(tinfo)/lib_tputs.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			../include/termcap.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_tputs.c -o ../obj_s/lib_tputs$o

../obj_s/lib_trace$o :	$(trace)/lib_trace.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(trace)/lib_trace.c -o ../obj_s/lib_trace$o

../obj_s/lib_ttyflags$o :	$(tinfo)/lib_ttyflags.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/lib_ttyflags.c -o ../obj_s/lib_ttyflags$o

../obj_s/lib_twait$o :	$(serial)/lib_twait.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(serial)/lib_twait.c -o ../obj_s/lib_twait$o

../obj_s/name_match$o :	$(tinfo)/name_match.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/name_match.c -o ../obj_s/name_match$o

../obj_s/names$o :	./names.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/names.c -o ../obj_s/names$o

../obj_s/obsolete$o :	$(tinfo)/obsolete.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/obsolete.c -o ../obj_s/obsolete$o

../obj_s/read_entry$o :	$(tinfo)/read_entry.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			$(INCDIR)/hashed_db.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/read_entry.c -o ../obj_s/read_entry$o

../obj_s/read_termcap$o :	$(tinfo)/read_termcap.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/read_termcap.c -o ../obj_s/read_termcap$o

../obj_s/strings$o :	$(tinfo)/strings.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/strings.c -o ../obj_s/strings$o

../obj_s/tries$o :	$(base)/tries.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/tries.c -o ../obj_s/tries$o

../obj_s/trim_sgr0$o :	$(tinfo)/trim_sgr0.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/trim_sgr0.c -o ../obj_s/trim_sgr0$o

../obj_s/unctrl$o :	./unctrl.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c ../ncurses/unctrl.c -o ../obj_s/unctrl$o

../obj_s/visbuf$o :	$(trace)/visbuf.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(trace)/visbuf.c -o ../obj_s/visbuf$o

../obj_s/define_key$o :	$(base)/define_key.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/define_key.c -o ../obj_s/define_key$o

../obj_s/hashed_db$o :	$(tinfo)/hashed_db.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			$(INCDIR)/hashed_db.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(tinfo)/hashed_db.c -o ../obj_s/hashed_db$o

../obj_s/key_defined$o :	$(base)/key_defined.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/key_defined.c -o ../obj_s/key_defined$o

../obj_s/keybound$o :	$(base)/keybound.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/keybound.c -o ../obj_s/keybound$o

../obj_s/keyok$o :	$(base)/keyok.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/keyok.c -o ../obj_s/keyok$o

../obj_s/version$o :	$(base)/version.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -DUSE_TERMLIB -c $(base)/version.c -o ../obj_s/version$o


# generated by mk-1st.awk (subset=base+ext_funcs)
#  name:            ncurses
#  traces:          DEBUG
#  MODEL:           SHARED
#  CXX_MODEL:       NORMAL
#  LIB_SUFFIX:      
#  USE_LIB_SUFFIX:  
#  model:           obj_s
#  prefix:          lib
#  suffix:          .so
#  subset:          base+ext_funcs
#  driver:          no
#  ShlibVer:        rel
#  ShlibVerInfix:   no
#  SymLink:         ln -s -f
#  TermlibRoot:     tinfo
#  TermlibSuffix:   .so
#  ReLink:          yes
#  ReRanlib:        yes
#  DoLinks:         yes
#  rmSoLocs:        no
#  ldconfig:        /sbin/ldconfig
#  make_phony:      yes
#  overwrite:       no
#  depend:          ../include/ncurses_cfg.h ${srcdir}/curses.priv.h
#  host:            x86_64-pc-linux-gnu
#  libtool_version: -version-number

SHARED_OBJS = \
	../obj_s/hardscroll$o \
	../obj_s/hashmap$o \
	../obj_s/lib_addch$o \
	../obj_s/lib_addstr$o \
	../obj_s/lib_beep$o \
	../obj_s/lib_bkgd$o \
	../obj_s/lib_box$o \
	../obj_s/lib_chgat$o \
	../obj_s/lib_clear$o \
	../obj_s/lib_clearok$o \
	../obj_s/lib_clrbot$o \
	../obj_s/lib_clreol$o \
	../obj_s/lib_color$o \
	../obj_s/lib_colorset$o \
	../obj_s/lib_delch$o \
	../obj_s/lib_delwin$o \
	../obj_s/lib_echo$o \
	../obj_s/lib_endwin$o \
	../obj_s/lib_erase$o \
	../obj_s/lib_flash$o \
	../obj_s/lib_gen$o \
	../obj_s/lib_getch$o \
	../obj_s/lib_getstr$o \
	../obj_s/lib_hline$o \
	../obj_s/lib_immedok$o \
	../obj_s/lib_inchstr$o \
	../obj_s/lib_initscr$o \
	../obj_s/lib_insch$o \
	../obj_s/lib_insdel$o \
	../obj_s/lib_insnstr$o \
	../obj_s/lib_instr$o \
	../obj_s/lib_isendwin$o \
	../obj_s/lib_leaveok$o \
	../obj_s/lib_mouse$o \
	../obj_s/lib_move$o \
	../obj_s/lib_mvcur$o \
	../obj_s/lib_mvwin$o \
	../obj_s/lib_newterm$o \
	../obj_s/lib_newwin$o \
	../obj_s/lib_nl$o \
	../obj_s/lib_overlay$o \
	../obj_s/lib_pad$o \
	../obj_s/lib_printw$o \
	../obj_s/lib_redrawln$o \
	../obj_s/lib_refresh$o \
	../obj_s/lib_restart$o \
	../obj_s/lib_scanw$o \
	../obj_s/lib_screen$o \
	../obj_s/lib_scroll$o \
	../obj_s/lib_scrollok$o \
	../obj_s/lib_scrreg$o \
	../obj_s/lib_set_term$o \
	../obj_s/lib_slk$o \
	../obj_s/lib_slkatr_set$o \
	../obj_s/lib_slkatrof$o \
	../obj_s/lib_slkatron$o \
	../obj_s/lib_slkatrset$o \
	../obj_s/lib_slkattr$o \
	../obj_s/lib_slkclear$o \
	../obj_s/lib_slkcolor$o \
	../obj_s/lib_slkinit$o \
	../obj_s/lib_slklab$o \
	../obj_s/lib_slkrefr$o \
	../obj_s/lib_slkset$o \
	../obj_s/lib_slktouch$o \
	../obj_s/lib_touch$o \
	../obj_s/lib_tstp$o \
	../obj_s/lib_ungetch$o \
	../obj_s/lib_vidattr$o \
	../obj_s/lib_vline$o \
	../obj_s/lib_wattroff$o \
	../obj_s/lib_wattron$o \
	../obj_s/lib_winch$o \
	../obj_s/lib_window$o \
	../obj_s/nc_panel$o \
	../obj_s/safe_sprintf$o \
	../obj_s/tty_update$o \
	../obj_s/varargs$o \
	../obj_s/vsscanf$o \
	../obj_s/lib_freeall$o \
	../obj_s/expanded$o \
	../obj_s/legacy_coding$o \
	../obj_s/lib_dft_fgbg$o \
	../obj_s/lib_print$o \
	../obj_s/new_pair$o \
	../obj_s/resizeterm$o \
	../obj_s/use_screen$o \
	../obj_s/use_window$o \
	../obj_s/wresize$o

$(SHARED_OBJS) : ../include/ncurses_cfg.h ${srcdir}/curses.priv.h

../lib/libncurses.so.$(REL_VERSION) : \
		../lib/libtinfo.so.$(REL_VERSION) \
		$(RESULTING_SYMS) $(SHARED_OBJS)
	@echo linking $@
	@mkdir -p ../lib
	$(MK_SHARED_LIB) $(SHARED_OBJS) $(SHLIB_LIST)
	cd ../lib && ($(LN_S) libncurses.so.$(REL_VERSION) libncurses.so.$(ABI_VERSION); $(LN_S) libncurses.so.$(ABI_VERSION) libncurses.so; )

install \
install.libs \
install.ncurses :: $(DESTDIR)$(libdir)/libncurses.so.$(REL_VERSION)

$(DESTDIR)$(libdir)/libncurses.so.$(REL_VERSION) : \
		../lib/libtinfo.so.$(REL_VERSION) \
		$(DESTDIR)$(libdir)/libtinfo.so.$(REL_VERSION) \
		$(RESULTING_SYMS) $(SHARED_OBJS)
	@echo linking $@
	@mkdir -p $(DESTDIR)$(libdir)
	$(MK_SHARED_LIB) $(SHARED_OBJS) $(SHLIB_LIST)
	cd $(DESTDIR)$(libdir) && ($(LN_S) libncurses.so.$(REL_VERSION) libncurses.so.$(ABI_VERSION); $(LN_S) libncurses.so.$(ABI_VERSION) libncurses.so; )
	- test -z "$(DESTDIR)" && /sbin/ldconfig

uninstall \
uninstall.libs \
uninstall.ncurses ::
	@echo uninstalling $(DESTDIR)$(libdir)/libncurses.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libncurses.so.$(REL_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libncurses.so.$(ABI_VERSION)
	-rm -f $(DESTDIR)$(libdir)/libncurses.so

clean ::
	-rm -f ../lib/libncurses.so.$(REL_VERSION)
	-rm -f ../lib/libncurses.so.$(ABI_VERSION)
	-rm -f ../lib/libncurses.so

mostlyclean::
	-rm -f $(SHARED_OBJS)

# generated by mk-2nd.awk
#   model:      obj_s
#   MODEL:      SHARED
#   echo:       yes
#   subset:     base+ext_funcs
#   crenames:   yes
#   cxxrenames: yes
#   traces:     DEBUG
#   srcdir:     ../../git

../obj_s/hardscroll$o :	$(serial)/hardscroll.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/hardscroll.c -o ../obj_s/hardscroll$o

../obj_s/hashmap$o :	$(serial)/hashmap.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/hashmap.c -o ../obj_s/hashmap$o

../obj_s/lib_addch$o :	$(base)/lib_addch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_addch.c -o ../obj_s/lib_addch$o

../obj_s/lib_addstr$o :	$(base)/lib_addstr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_addstr.c -o ../obj_s/lib_addstr$o

../obj_s/lib_beep$o :	$(base)/lib_beep.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_beep.c -o ../obj_s/lib_beep$o

../obj_s/lib_bkgd$o :	$(base)/lib_bkgd.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_bkgd.c -o ../obj_s/lib_bkgd$o

../obj_s/lib_box$o :	$(base)/lib_box.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_box.c -o ../obj_s/lib_box$o

../obj_s/lib_chgat$o :	$(base)/lib_chgat.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_chgat.c -o ../obj_s/lib_chgat$o

../obj_s/lib_clear$o :	$(base)/lib_clear.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_clear.c -o ../obj_s/lib_clear$o

../obj_s/lib_clearok$o :	$(base)/lib_clearok.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_clearok.c -o ../obj_s/lib_clearok$o

../obj_s/lib_clrbot$o :	$(base)/lib_clrbot.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_clrbot.c -o ../obj_s/lib_clrbot$o

../obj_s/lib_clreol$o :	$(base)/lib_clreol.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_clreol.c -o ../obj_s/lib_clreol$o

../obj_s/lib_color$o :	$(base)/lib_color.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			$(srcdir)/new_pair.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_color.c -o ../obj_s/lib_color$o

../obj_s/lib_colorset$o :	$(base)/lib_colorset.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_colorset.c -o ../obj_s/lib_colorset$o

../obj_s/lib_delch$o :	$(base)/lib_delch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_delch.c -o ../obj_s/lib_delch$o

../obj_s/lib_delwin$o :	$(base)/lib_delwin.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_delwin.c -o ../obj_s/lib_delwin$o

../obj_s/lib_echo$o :	$(base)/lib_echo.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_echo.c -o ../obj_s/lib_echo$o

../obj_s/lib_endwin$o :	$(base)/lib_endwin.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_endwin.c -o ../obj_s/lib_endwin$o

../obj_s/lib_erase$o :	$(base)/lib_erase.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_erase.c -o ../obj_s/lib_erase$o

../obj_s/lib_flash$o :	$(base)/lib_flash.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_flash.c -o ../obj_s/lib_flash$o

../obj_s/lib_gen$o :	./lib_gen.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c ../ncurses/lib_gen.c -o ../obj_s/lib_gen$o

../obj_s/lib_getch$o :	$(base)/lib_getch.c \
			$(HEADER_DEPS) \
			$(srcdir)/fifo_defs.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_getch.c -o ../obj_s/lib_getch$o

../obj_s/lib_getstr$o :	$(base)/lib_getstr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_getstr.c -o ../obj_s/lib_getstr$o

../obj_s/lib_hline$o :	$(base)/lib_hline.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_hline.c -o ../obj_s/lib_hline$o

../obj_s/lib_immedok$o :	$(base)/lib_immedok.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_immedok.c -o ../obj_s/lib_immedok$o

../obj_s/lib_inchstr$o :	$(base)/lib_inchstr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_inchstr.c -o ../obj_s/lib_inchstr$o

../obj_s/lib_initscr$o :	$(base)/lib_initscr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_initscr.c -o ../obj_s/lib_initscr$o

../obj_s/lib_insch$o :	$(base)/lib_insch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_insch.c -o ../obj_s/lib_insch$o

../obj_s/lib_insdel$o :	$(base)/lib_insdel.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_insdel.c -o ../obj_s/lib_insdel$o

../obj_s/lib_insnstr$o :	$(base)/lib_insnstr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_insnstr.c -o ../obj_s/lib_insnstr$o

../obj_s/lib_instr$o :	$(base)/lib_instr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_instr.c -o ../obj_s/lib_instr$o

../obj_s/lib_isendwin$o :	$(base)/lib_isendwin.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_isendwin.c -o ../obj_s/lib_isendwin$o

../obj_s/lib_leaveok$o :	$(base)/lib_leaveok.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_leaveok.c -o ../obj_s/lib_leaveok$o

../obj_s/lib_mouse$o :	$(base)/lib_mouse.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_mouse.c -o ../obj_s/lib_mouse$o

../obj_s/lib_move$o :	$(base)/lib_move.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_move.c -o ../obj_s/lib_move$o

../obj_s/lib_mvcur$o :	$(serial)/lib_mvcur.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h \
			$(srcdir)/../progs/dump_entry.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/lib_mvcur.c -o ../obj_s/lib_mvcur$o

../obj_s/lib_mvwin$o :	$(base)/lib_mvwin.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_mvwin.c -o ../obj_s/lib_mvwin$o

../obj_s/lib_newterm$o :	$(base)/lib_newterm.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_newterm.c -o ../obj_s/lib_newterm$o

../obj_s/lib_newwin$o :	$(base)/lib_newwin.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_newwin.c -o ../obj_s/lib_newwin$o

../obj_s/lib_nl$o :	$(base)/lib_nl.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_nl.c -o ../obj_s/lib_nl$o

../obj_s/lib_overlay$o :	$(base)/lib_overlay.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_overlay.c -o ../obj_s/lib_overlay$o

../obj_s/lib_pad$o :	$(base)/lib_pad.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_pad.c -o ../obj_s/lib_pad$o

../obj_s/lib_printw$o :	$(base)/lib_printw.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_printw.c -o ../obj_s/lib_printw$o

../obj_s/lib_redrawln$o :	$(base)/lib_redrawln.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_redrawln.c -o ../obj_s/lib_redrawln$o

../obj_s/lib_refresh$o :	$(base)/lib_refresh.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_refresh.c -o ../obj_s/lib_refresh$o

../obj_s/lib_restart$o :	$(base)/lib_restart.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_restart.c -o ../obj_s/lib_restart$o

../obj_s/lib_scanw$o :	$(base)/lib_scanw.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_scanw.c -o ../obj_s/lib_scanw$o

../obj_s/lib_screen$o :	$(base)/lib_screen.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_screen.c -o ../obj_s/lib_screen$o

../obj_s/lib_scroll$o :	$(base)/lib_scroll.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_scroll.c -o ../obj_s/lib_scroll$o

../obj_s/lib_scrollok$o :	$(base)/lib_scrollok.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_scrollok.c -o ../obj_s/lib_scrollok$o

../obj_s/lib_scrreg$o :	$(base)/lib_scrreg.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_scrreg.c -o ../obj_s/lib_scrreg$o

../obj_s/lib_set_term$o :	$(base)/lib_set_term.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_set_term.c -o ../obj_s/lib_set_term$o

../obj_s/lib_slk$o :	$(base)/lib_slk.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slk.c -o ../obj_s/lib_slk$o

../obj_s/lib_slkatr_set$o :	$(base)/lib_slkatr_set.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkatr_set.c -o ../obj_s/lib_slkatr_set$o

../obj_s/lib_slkatrof$o :	$(base)/lib_slkatrof.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkatrof.c -o ../obj_s/lib_slkatrof$o

../obj_s/lib_slkatron$o :	$(base)/lib_slkatron.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkatron.c -o ../obj_s/lib_slkatron$o

../obj_s/lib_slkatrset$o :	$(base)/lib_slkatrset.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkatrset.c -o ../obj_s/lib_slkatrset$o

../obj_s/lib_slkattr$o :	$(base)/lib_slkattr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkattr.c -o ../obj_s/lib_slkattr$o

../obj_s/lib_slkclear$o :	$(base)/lib_slkclear.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkclear.c -o ../obj_s/lib_slkclear$o

../obj_s/lib_slkcolor$o :	$(base)/lib_slkcolor.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkcolor.c -o ../obj_s/lib_slkcolor$o

../obj_s/lib_slkinit$o :	$(base)/lib_slkinit.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkinit.c -o ../obj_s/lib_slkinit$o

../obj_s/lib_slklab$o :	$(base)/lib_slklab.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slklab.c -o ../obj_s/lib_slklab$o

../obj_s/lib_slkrefr$o :	$(base)/lib_slkrefr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkrefr.c -o ../obj_s/lib_slkrefr$o

../obj_s/lib_slkset$o :	$(base)/lib_slkset.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slkset.c -o ../obj_s/lib_slkset$o

../obj_s/lib_slktouch$o :	$(base)/lib_slktouch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_slktouch.c -o ../obj_s/lib_slktouch$o

../obj_s/lib_touch$o :	$(base)/lib_touch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_touch.c -o ../obj_s/lib_touch$o

../obj_s/lib_tstp$o :	$(serial)/lib_tstp.c \
			$(HEADER_DEPS) \
			$(srcdir)/SigAction.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/lib_tstp.c -o ../obj_s/lib_tstp$o

../obj_s/lib_ungetch$o :	$(base)/lib_ungetch.c \
			$(HEADER_DEPS) \
			$(srcdir)/fifo_defs.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_ungetch.c -o ../obj_s/lib_ungetch$o

../obj_s/lib_vidattr$o :	$(serial)/lib_vidattr.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/lib_vidattr.c -o ../obj_s/lib_vidattr$o

../obj_s/lib_vline$o :	$(base)/lib_vline.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_vline.c -o ../obj_s/lib_vline$o

../obj_s/lib_wattroff$o :	$(base)/lib_wattroff.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_wattroff.c -o ../obj_s/lib_wattroff$o

../obj_s/lib_wattron$o :	$(base)/lib_wattron.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_wattron.c -o ../obj_s/lib_wattron$o

../obj_s/lib_winch$o :	$(base)/lib_winch.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_winch.c -o ../obj_s/lib_winch$o

../obj_s/lib_window$o :	$(base)/lib_window.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_window.c -o ../obj_s/lib_window$o

../obj_s/link_test$o :	./link_test.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c ../ncurses/link_test.c -o ../obj_s/link_test$o

../obj_s/nc_panel$o :	$(base)/nc_panel.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/nc_panel.c -o ../obj_s/nc_panel$o

../obj_s/safe_sprintf$o :	$(base)/safe_sprintf.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/safe_sprintf.c -o ../obj_s/safe_sprintf$o

../obj_s/tty_update$o :	$(serial)/tty_update.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(serial)/tty_update.c -o ../obj_s/tty_update$o

../obj_s/varargs$o :	$(trace)/varargs.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(trace)/varargs.c -o ../obj_s/varargs$o

../obj_s/vsscanf$o :	$(base)/vsscanf.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/vsscanf.c -o ../obj_s/vsscanf$o

../obj_s/lib_freeall$o :	$(base)/lib_freeall.c \
			$(HEADER_DEPS) \
			$(INCDIR)/tic.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_freeall.c -o ../obj_s/lib_freeall$o

../obj_s/expanded$o :	./expanded.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c ../ncurses/expanded.c -o ../obj_s/expanded$o

../obj_s/legacy_coding$o :	$(base)/legacy_coding.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/legacy_coding.c -o ../obj_s/legacy_coding$o

../obj_s/lib_dft_fgbg$o :	$(base)/lib_dft_fgbg.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/lib_dft_fgbg.c -o ../obj_s/lib_dft_fgbg$o

../obj_s/lib_print$o :	$(tinfo)/lib_print.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/lib_print.c -o ../obj_s/lib_print$o

../obj_s/new_pair$o :	$(base)/new_pair.c \
			$(HEADER_DEPS) \
			$(srcdir)/new_pair.h
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/new_pair.c -o ../obj_s/new_pair$o

../obj_s/resizeterm$o :	$(base)/resizeterm.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/resizeterm.c -o ../obj_s/resizeterm$o

../obj_s/use_screen$o :	$(tinfo)/use_screen.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(tinfo)/use_screen.c -o ../obj_s/use_screen$o

../obj_s/use_window$o :	$(base)/use_window.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/use_window.c -o ../obj_s/use_window$o

../obj_s/wresize$o :	$(base)/wresize.c \
			$(HEADER_DEPS)
	$(LIBTOOL_COMPILE) $(CC) $(CFLAGS_SHARED) -c $(base)/wresize.c -o ../obj_s/wresize$o


.PHONY :	depend
depend : ${AUTO_SRC}
	makedepend -- ${CPPFLAGS} -- ${C_SRC}

# DO NOT DELETE THIS LINE -- make depend depends on it.
