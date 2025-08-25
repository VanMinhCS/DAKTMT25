# $Id: Makefile.in,v 1.130 2021/12/18 23:00:28 tom Exp $
##############################################################################
# Copyright 2020,2021 Thomas E. Dickey                                       #
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
# Makefile for ncurses tests.

# turn off _all_ suffix rules; we'll generate our own
.SUFFIXES:

SHELL		= /bin/bash
VPATH		= ../../../git/test



destdir		=
x		= 
o		= .o

PACKAGE		= ncursesw

MODEL		= ../obj_s
top_srcdir	= ../../../git
srcdir		= ../../../git/test
prefix		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
exec_prefix	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
datarootdir	= ${prefix}/share

bindir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/bin
libexecdir	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/libexec
libdir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib
datarootdir	= ${prefix}/share
datadir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/share

real_bindir	= $(libexecdir)/$(PACKAGE)

BINDIR		= $(DESTDIR)$(bindir)
LIBEXECDIR	= $(DESTDIR)$(libexecdir)
LIBDIR		= $(DESTDIR)$(libdir)
DATADIR		= $(DESTDIR)$(datadir)

REAL_BINDIR	= $(LIBEXECDIR)/$(PACKAGE)

LIBTOOL		= 
LIBTOOL_OPTS	= 
LIBTOOL_CLEAN	= 
LIBTOOL_COMPILE	= 
LIBTOOL_LINK	= ${CC}

INSTALL		= /home/ubuntu/yocto/rpi-build/tmp/hosttools/install -c 
INSTALL_PROG	= ${INSTALL} 
INSTALL_SCRIPT	= ${INSTALL}
INSTALL_DATA	= ${INSTALL} -m 644
transform	= s,^,,
TRANSFORM	= sed 's/$x$$//'|sed '$(transform)'|sed 's/$$/$x/'

CTAGS		= 
ETAGS		= 

CC		= gcc 
CPP		= gcc  -E

CFLAGS		= -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -O2 -pipe --param max-inline-insns-single=1200 
CPPFLAGS	= -I. -I$(srcdir) -I../test -DHAVE_CONFIG_H -DDATA_DIR=\"$(datadir)\" -I. -I${srcdir} -I../include -I${srcdir}/../include -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600 -DNDEBUG

CCFLAGS		= $(CPPFLAGS) $(CFLAGS)

CFLAGS_LIBTOOL	= $(CCFLAGS)
CFLAGS_NORMAL	= $(CCFLAGS) -DNCURSES_STATIC
CFLAGS_DEBUG	= $(CCFLAGS) -DNCURSES_STATIC -g -DTRACE
CFLAGS_PROFILE	= $(CCFLAGS) -DNCURSES_STATIC -pg
CFLAGS_SHARED	= $(CCFLAGS) -fPIC

CFLAGS_DEFAULT	= $(CFLAGS_SHARED)

REL_VERSION	= 5.9
ABI_VERSION	= 5
LOCAL_LIBDIR	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/build/widec/lib
LOCAL_LIBS	= ../lib/libformw.so ../lib/libmenuw.so ../lib/libpanelw.so ../lib/libncursesw.so ../lib/libtinfo.so
MATH_LIB	= -lm
TEST_LIBS	= -lutil 

LD		= ld 
LINK		=  $(LIBTOOL_LINK) $(CFLAGS)

LDFLAGS		=   -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2

LDFLAGS_LIBTOOL	= $(LDFLAGS) $(CFLAGS_LIBTOOL)
LDFLAGS_NORMAL	= $(LDFLAGS) $(CFLAGS_NORMAL)
LDFLAGS_DEBUG	= $(LDFLAGS) $(CFLAGS_DEBUG)
LDFLAGS_PROFILE	= $(LDFLAGS) $(CFLAGS_PROFILE)
LDFLAGS_SHARED	= $(LDFLAGS) $(CFLAGS_SHARED) 

TEST_ARGS	=  -L../lib -lformw -lmenuw -lpanelw -lncursesw -ltinfo 

# use these for linking with all of the libraries
LIBS_DEFAULT	= $(TEST_ARGS)  $(TEST_LIBS)
LDFLAGS_DEFAULT	= $(LDFLAGS_SHARED) $(LIBS_DEFAULT)

# use these for linking with the (n)curses library and possibly pthreads
LIBS_THREADS	= `echo "$(TEST_ARGS) " | sed -e 's/-lform.*-lpanel[^ ]*//'` $(TEST_LIBS) 
LDFLAGS_THREADS	= $(LDFLAGS_SHARED) $(LIBS_THREADS)

# use these for linking with the (n)curses library
LIBS_CURSES	= `echo "$(TEST_ARGS) " | sed -e 's/-lform.*-lpanel[^ ]*//'` $(TEST_LIBS)
LDFLAGS_CURSES	= $(LDFLAGS_SHARED) $(LIBS_CURSES)

# use these when we need the math library
LDFLAGS_CURSES_M= $(LDFLAGS_CURSES) $(MATH_LIB)

# use these for linking with the tinfo library if we have it, or curses library if not
LIBS_TINFO	=  -ltinfo   $(TEST_LIBS)
LDFLAGS_TINFO	= -L../lib $(LDFLAGS_SHARED) $(LIBS_TINFO)

LINT		= 
LINT_OPTS	= 
LINT_LIBS	= -lform -lmenu -lpanel -lncurses 

INCDIR		= $(top_srcdir)/include
incdir		= ../include

HEADER_DEPS	= \
	$(incdir)/curses.h \
	$(incdir)/term.h \
	$(incdir)/ncurses_cfg.h \
	$(incdir)/ncurses_def.h \
	$(incdir)/ncurses_dll.h \
	$(incdir)/term.h \
	$(incdir)/unctrl.h \
	$(INCDIR)/nc_alloc.h

################################################################################

.PHONY :	all
.PHONY :	check

all::

# Verify that each header-file can be compiled without including another.
check::
	@$(SHELL) -c "for header in *.h;\
		do \
			echo \"** testing \$${header}\" ; \
			echo \"#include <\$${header}>\" >headers.c; \
			echo \"int main(void) { return 0; }\" >>headers.c; \
			$(CC) -c $(CFLAGS) $(CPPFLAGS) headers.c; \
		done"
	-@rm -f headers.*

# The rest is generated from the "programs" and "modules" files...
# generated by mk-test.awk

TESTS	= $(destdir)back_ground$x \
	  $(destdir)background$x \
	  $(destdir)blue$x \
	  $(destdir)bs$x \
	  $(destdir)cardfile$x \
	  $(destdir)chgat$x \
	  $(destdir)clip_printw$x \
	  $(destdir)color_content$x \
	  $(destdir)color_set$x \
	  $(destdir)combine$x \
	  $(destdir)demo_altkeys$x \
	  $(destdir)demo_defkey$x \
	  $(destdir)demo_forms$x \
	  $(destdir)demo_keyok$x \
	  $(destdir)demo_menus$x \
	  $(destdir)demo_new_pair$x \
	  $(destdir)demo_panels$x \
	  $(destdir)demo_tabs$x \
	  $(destdir)demo_termcap$x \
	  $(destdir)demo_terminfo$x \
	  $(destdir)ditto$x \
	  $(destdir)dots$x \
	  $(destdir)dots_curses$x \
	  $(destdir)dots_mvcur$x \
	  $(destdir)dots_termcap$x \
	  $(destdir)dots_xcurses$x \
	  $(destdir)dup_field$x \
	  $(destdir)echochar$x \
	  $(destdir)extended_color$x \
	  $(destdir)filter$x \
	  $(destdir)firework$x \
	  $(destdir)firstlast$x \
	  $(destdir)foldkeys$x \
	  $(destdir)form_driver_w$x \
	  $(destdir)gdc$x \
	  $(destdir)hanoi$x \
	  $(destdir)hashtest$x \
	  $(destdir)inch_wide$x \
	  $(destdir)inchs$x \
	  $(destdir)ins_wide$x \
	  $(destdir)insdelln$x \
	  $(destdir)inserts$x \
	  $(destdir)key_names$x \
	  $(destdir)keynames$x \
	  $(destdir)knight$x \
	  $(destdir)list_keys$x \
	  $(destdir)lrtest$x \
	  $(destdir)move_field$x \
	  $(destdir)movewindow$x \
	  $(destdir)ncurses$x \
	  $(destdir)newdemo$x \
	  $(destdir)padview$x \
	  $(destdir)pair_content$x \
	  $(destdir)picsmap$x \
	  $(destdir)railroad$x \
	  $(destdir)rain$x \
	  $(destdir)redraw$x \
	  $(destdir)savescreen$x \
	  $(destdir)sp_tinfo$x \
	  $(destdir)tclock$x \
	  $(destdir)test_add_wchstr$x \
	  $(destdir)test_addchstr$x \
	  $(destdir)test_addstr$x \
	  $(destdir)test_addwstr$x \
	  $(destdir)test_arrays$x \
	  $(destdir)test_get_wstr$x \
	  $(destdir)test_getstr$x \
	  $(destdir)test_instr$x \
	  $(destdir)test_inwstr$x \
	  $(destdir)test_opaque$x \
	  $(destdir)test_setupterm$x \
	  $(destdir)test_sgr$x \
	  $(destdir)test_termattrs$x \
	  $(destdir)test_tparm$x \
	  $(destdir)test_unget_wch$x \
	  $(destdir)test_vid_puts$x \
	  $(destdir)test_vidputs$x \
	  $(destdir)testaddch$x \
	  $(destdir)testcurs$x \
	  $(destdir)testscanw$x \
	  $(destdir)view$x \
	  $(destdir)worm$x \
	  $(destdir)xmas$x
SCRIPTS = \
	$(srcdir)/savescreen.sh \
	$(srcdir)/tput-colorcube \
	$(srcdir)/tput-initc \
	$(srcdir)/tracemunch
DATAFILES = \
	$(srcdir)/*.x* \
	$(srcdir)/*.dat

all:: $(TESTS)

sources:

check::
	@ echo The test-programs are interactive
tags:
	$(CTAGS) *.[ch]

# no libraries here
libs \
install.libs \
uninstall.libs:

install \
install.test \
uninstall \
uninstall.test:

mostlyclean ::
	-rm -f core tags TAGS *~ *.bak *.i *.ln *.atac trace

clean :: mostlyclean
	-$(SHELL) -c "if test -n '$x' ; then $(MAKE) clean x=''; fi"
	-rm -rf *$o screendump *.lis $(TESTS) .libs *.dSYM
	-rm -f $(PACKAGE)

distclean :: clean
	-rm -f Makefile ncurses_cfg.h config.status config.log

realclean :: distclean

lint:
	$(SHELL) -c 'for N in $(TESTS); do echo LINT:$$N; $(LINT) $(LINT_OPTS) $(CPPFLAGS) $(srcdir)/$$N.c $(LINT_LIBS); done'
$(BINDIR) $(REAL_BINDIR) $(DATADIR) :
	mkdir -p $@

$(destdir)back_ground$x: $(MODEL)/back_ground$o $(MODEL)/dump_window$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/back_ground$o $(MODEL)/dump_window$o $(LDFLAGS_CURSES)

$(destdir)background$x: $(MODEL)/background$o $(MODEL)/dump_window$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/background$o $(MODEL)/dump_window$o $(LDFLAGS_CURSES)

$(destdir)blue$x: $(MODEL)/blue$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/blue$o $(LDFLAGS_CURSES)

$(destdir)bs$x: $(MODEL)/bs$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/bs$o $(LDFLAGS_CURSES)

$(destdir)cardfile$x: $(MODEL)/cardfile$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/cardfile$o $(LDFLAGS_DEFAULT)

$(destdir)chgat$x: $(MODEL)/chgat$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/chgat$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)clip_printw$x: $(MODEL)/clip_printw$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/clip_printw$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)color_content$x: $(MODEL)/color_content$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/color_content$o $(LDFLAGS_CURSES)

$(destdir)color_set$x: $(MODEL)/color_set$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/color_set$o $(LDFLAGS_CURSES)

$(destdir)combine$x: $(MODEL)/combine$o $(MODEL)/dump_window$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/combine$o $(MODEL)/dump_window$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)demo_altkeys$x: $(MODEL)/demo_altkeys$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_altkeys$o $(LDFLAGS_CURSES)

$(destdir)demo_defkey$x: $(MODEL)/demo_defkey$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_defkey$o $(LDFLAGS_CURSES)

$(destdir)demo_forms$x: $(MODEL)/demo_forms$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_forms$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LDFLAGS_DEFAULT)

$(destdir)demo_keyok$x: $(MODEL)/demo_keyok$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_keyok$o $(LDFLAGS_CURSES)

$(destdir)demo_menus$x: $(MODEL)/demo_menus$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_menus$o $(LDFLAGS_DEFAULT)

$(destdir)demo_new_pair$x: $(MODEL)/demo_new_pair$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_new_pair$o $(MODEL)/popup_msg$o $(LDFLAGS_DEFAULT)

$(destdir)demo_panels$x: $(MODEL)/demo_panels$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_panels$o $(LDFLAGS_DEFAULT)

$(destdir)demo_tabs$x: $(MODEL)/demo_tabs$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_tabs$o $(LDFLAGS_CURSES)

$(destdir)demo_termcap$x: $(MODEL)/demo_termcap$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_termcap$o $(LDFLAGS_TINFO)

$(destdir)demo_terminfo$x: $(MODEL)/demo_terminfo$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/demo_terminfo$o $(LDFLAGS_TINFO)

$(destdir)ditto$x: $(MODEL)/ditto$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/ditto$o $(LDFLAGS_THREADS)

$(destdir)dots$x: $(MODEL)/dots$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dots$o $(LDFLAGS_TINFO)

$(destdir)dots_curses$x: $(MODEL)/dots_curses$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dots_curses$o $(LDFLAGS_CURSES)

$(destdir)dots_mvcur$x: $(MODEL)/dots_mvcur$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dots_mvcur$o $(LDFLAGS_CURSES)

$(destdir)dots_termcap$x: $(MODEL)/dots_termcap$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dots_termcap$o $(LDFLAGS_TINFO)

$(destdir)dots_xcurses$x: $(MODEL)/dots_xcurses$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dots_xcurses$o $(LDFLAGS_CURSES)

$(destdir)dup_field$x: $(MODEL)/dup_field$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/dup_field$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LDFLAGS_DEFAULT)

$(destdir)echochar$x: $(MODEL)/echochar$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/echochar$o $(LDFLAGS_CURSES)

$(destdir)extended_color$x: $(MODEL)/extended_color$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/extended_color$o $(LDFLAGS_CURSES)

$(destdir)filter$x: $(MODEL)/filter$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/filter$o $(LDFLAGS_CURSES)

$(destdir)firework$x: $(MODEL)/firework$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/firework$o $(LDFLAGS_CURSES)

$(destdir)firstlast$x: $(MODEL)/firstlast$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/firstlast$o $(LDFLAGS_DEFAULT)

$(destdir)foldkeys$x: $(MODEL)/foldkeys$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/foldkeys$o $(LDFLAGS_CURSES)

$(destdir)form_driver_w$x: $(MODEL)/form_driver_w$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/form_driver_w$o $(MODEL)/popup_msg$o $(LDFLAGS_DEFAULT)

$(destdir)gdc$x: $(MODEL)/gdc$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/gdc$o $(LDFLAGS_CURSES)

$(destdir)hanoi$x: $(MODEL)/hanoi$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/hanoi$o $(LDFLAGS_CURSES_M)

$(destdir)hashtest$x: $(MODEL)/hashtest$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/hashtest$o $(LDFLAGS_CURSES)

$(destdir)inch_wide$x: $(MODEL)/inch_wide$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/inch_wide$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)inchs$x: $(MODEL)/inchs$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/inchs$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)ins_wide$x: $(MODEL)/ins_wide$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/ins_wide$o $(LDFLAGS_CURSES)

$(destdir)insdelln$x: $(MODEL)/insdelln$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/insdelln$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)inserts$x: $(MODEL)/inserts$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/inserts$o $(LDFLAGS_CURSES)

$(destdir)key_names$x: $(MODEL)/key_names$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/key_names$o $(LDFLAGS_CURSES)

$(destdir)keynames$x: $(MODEL)/keynames$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/keynames$o $(LDFLAGS_CURSES)

$(destdir)knight$x: $(MODEL)/knight$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/knight$o $(LDFLAGS_CURSES)

$(destdir)list_keys$x: $(MODEL)/list_keys$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/list_keys$o $(LDFLAGS_TINFO)

$(destdir)lrtest$x: $(MODEL)/lrtest$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/lrtest$o $(LDFLAGS_CURSES)

$(destdir)move_field$x: $(MODEL)/move_field$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/move_field$o $(MODEL)/edit_field$o $(MODEL)/popup_msg$o $(LDFLAGS_DEFAULT)

$(destdir)movewindow$x: $(MODEL)/movewindow$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/movewindow$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)ncurses$x: $(MODEL)/ncurses$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/ncurses$o $(LDFLAGS_DEFAULT)

$(destdir)newdemo$x: $(MODEL)/newdemo$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/newdemo$o $(LDFLAGS_CURSES)

$(destdir)padview$x: $(MODEL)/padview$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/padview$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)pair_content$x: $(MODEL)/pair_content$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/pair_content$o $(LDFLAGS_CURSES)

$(destdir)picsmap$x: $(MODEL)/picsmap$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/picsmap$o $(LDFLAGS_CURSES)

$(destdir)railroad$x: $(MODEL)/railroad$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/railroad$o $(LDFLAGS_TINFO)

$(destdir)rain$x: $(MODEL)/rain$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/rain$o $(MODEL)/popup_msg$o $(LDFLAGS_THREADS)

$(destdir)redraw$x: $(MODEL)/redraw$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/redraw$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)savescreen$x: $(MODEL)/savescreen$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/savescreen$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)sp_tinfo$x: $(MODEL)/sp_tinfo$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/sp_tinfo$o $(LDFLAGS_TINFO)

$(destdir)tclock$x: $(MODEL)/tclock$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/tclock$o $(LDFLAGS_CURSES_M)

$(destdir)test_add_wchstr$x: $(MODEL)/test_add_wchstr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_add_wchstr$o $(LDFLAGS_CURSES)

$(destdir)test_addchstr$x: $(MODEL)/test_addchstr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_addchstr$o $(LDFLAGS_CURSES)

$(destdir)test_addstr$x: $(MODEL)/test_addstr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_addstr$o $(LDFLAGS_CURSES)

$(destdir)test_addwstr$x: $(MODEL)/test_addwstr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_addwstr$o $(LDFLAGS_CURSES)

$(destdir)test_arrays$x: $(MODEL)/test_arrays$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_arrays$o $(LDFLAGS_TINFO)

$(destdir)test_get_wstr$x: $(MODEL)/test_get_wstr$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_get_wstr$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)test_getstr$x: $(MODEL)/test_getstr$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_getstr$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)test_instr$x: $(MODEL)/test_instr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_instr$o $(LDFLAGS_CURSES)

$(destdir)test_inwstr$x: $(MODEL)/test_inwstr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_inwstr$o $(LDFLAGS_CURSES)

$(destdir)test_opaque$x: $(MODEL)/test_opaque$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_opaque$o $(LDFLAGS_CURSES)

$(destdir)test_setupterm$x: $(MODEL)/test_setupterm$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_setupterm$o $(LDFLAGS_CURSES)

$(destdir)test_sgr$x: $(MODEL)/test_sgr$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_sgr$o $(LDFLAGS_TINFO)

$(destdir)test_termattrs$x: $(MODEL)/test_termattrs$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_termattrs$o $(LDFLAGS_CURSES)

$(destdir)test_tparm$x: $(MODEL)/test_tparm$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_tparm$o $(LDFLAGS_TINFO)

$(destdir)test_unget_wch$x: $(MODEL)/test_unget_wch$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_unget_wch$o $(LDFLAGS_CURSES)

$(destdir)test_vid_puts$x: $(MODEL)/test_vid_puts$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_vid_puts$o $(LDFLAGS_CURSES)

$(destdir)test_vidputs$x: $(MODEL)/test_vidputs$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/test_vidputs$o $(LDFLAGS_CURSES)

$(destdir)testaddch$x: $(MODEL)/testaddch$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/testaddch$o $(LDFLAGS_CURSES)

$(destdir)testcurs$x: $(MODEL)/testcurs$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/testcurs$o $(LDFLAGS_CURSES)

$(destdir)testscanw$x: $(MODEL)/testscanw$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/testscanw$o $(LDFLAGS_CURSES)

$(destdir)view$x: $(MODEL)/view$o $(MODEL)/popup_msg$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/view$o $(MODEL)/popup_msg$o $(LDFLAGS_CURSES)

$(destdir)worm$x: $(MODEL)/worm$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/worm$o $(LDFLAGS_THREADS)

$(destdir)xmas$x: $(MODEL)/xmas$o $(LOCAL_LIBS)
	$(LINK) -o $@ $(MODEL)/xmas$o $(LDFLAGS_CURSES)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  