# $Id: Makefile.in,v 1.133 2021/07/03 18:53:57 tom Exp $
##############################################################################
# Copyright 2018-2020,2021 Thomas E. Dickey                                  #
# Copyright 1998-2015,2016 Free Software Foundation, Inc.                    #
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
# Author: Thomas E. Dickey
#
#  Simple makefile for c++ window class demo

# turn off _all_ suffix rules; we'll generate our own
.SUFFIXES:

SHELL		= /bin/bash
VPATH		= ../../../git/c++

CF_MFLAGS 	= 

x		= 
o		= .o

MODEL		= ../obj_s
DESTDIR		= 
top_srcdir	= ../../../git
srcdir		= ../../../git/c++
prefix		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
exec_prefix	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr
bindir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/bin
libdir		= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib
includedir	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include
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
LIBTOOL_VERSION = -version-number
LT_UNDEF	= 

INSTALL		= /home/ubuntu/yocto/rpi-build/tmp/hosttools/install -c
INSTALL_LIB	= $(INSTALL) -m 644
INSTALL_DATA	= ${INSTALL} -m 644
INSTALL_OPT_P	= 

AR		= ar
ARFLAGS		= -curv
AWK		= gawk
LD		= ld 
LN_S		= ln -s -f

CXX_AR		= $(AR)
CXX_ARFLAGS	= $(ARFLAGS)
RANLIB		= ranlib -D

CXX		= g++ 
CPP		= g++  -E
CXXFLAGS	= -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE -O2 -pipe 
CXXLIBS		= 

INCDIR		= ../include
CPPFLAGS	= -DHAVE_CONFIG_H -DBUILDING_NCURSES_CXX -I../c++ -I. -I${srcdir} -I../include -I${srcdir}/../include -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/include -D_GNU_SOURCE -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600 -DNDEBUG

CTAGS		= 
ETAGS		= 

CC		= ${CXX}
CCFLAGS		= $(CPPFLAGS) $(CXXFLAGS)

CFLAGS_LIBTOOL	= $(CCFLAGS)
CFLAGS_NORMAL	= $(CCFLAGS) -DNCURSES_STATIC
CFLAGS_DEBUG	= $(CCFLAGS) -DNCURSES_STATIC -g -DTRACE
CFLAGS_PROFILE	= $(CCFLAGS) -DNCURSES_STATIC -pg
CFLAGS_SHARED	= $(CCFLAGS) -fPIC

CFLAGS_DEFAULT	= $(CFLAGS_SHARED)

NCURSES_MAJOR	= 6
NCURSES_MINOR	= 3
REL_VERSION     = 5.9
ABI_VERSION	= 5

LOCAL_LIBDIR	= /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/build/narrowc/lib

LINK		=  $(LIBTOOL_LINK) 
SHLIB_DIRS	= -L../lib
SHLIB_LIST	= $(SHLIB_DIRS) \
		-lform \
		-lmenu \
		-lpanel \
		-lncurses  -ltinfo

LIBROOT		= ncurses++

LIBNAME_LIBTOOL	= lib$(LIBROOT).la
LIBNAME_NORMAL	= lib$(LIBROOT).a
LIBNAME		= lib$(LIBROOT).a

LIBRARIES	=  ../lib/libncurses++.a

LINT		= 
LINT_OPTS	= 
LINT_LIBS	= -lncurses 

LINK_FLAGS	=  -L../lib -l$(LIBROOT)
RPATH_LIST	= ${libdir}
MK_SHARED_LIB	= ${CC} ${LDFLAGS} ${CFLAGS} -shared -Wl,-soname,`basename $@ .${REL_VERSION}`.${ABI_VERSION},-stats,-lc -o $@

LINK_LIBTOOL	=  -L../lib $(LIBRARIES)
LINK_NORMAL	= $(LINK_FLAGS)
LINK_DEBUG	= $(LINK_FLAGS)
LINK_PROFILE	= $(LINK_FLAGS)
LINK_SHARED	= $(LINK_FLAGS)

# flags for test-programs
TEST_LIBS	= -lutil 
TEST_ARGS	=  -L../lib -lform -lmenu -lpanel -lncurses -ltinfo 
TEST_LDFLAGS	= $(TEST_ARGS) -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2 \
	 $(TEST_LIBS)   $(CXXLIBS)

LDFLAGS_LIBTOOL	= $(TEST_LDFLAGS) $(CFLAGS_LIBTOOL)
LDFLAGS_NORMAL	= $(TEST_LDFLAGS) $(CFLAGS_NORMAL)
LDFLAGS_DEBUG	= $(TEST_LDFLAGS) $(CFLAGS_DEBUG)
LDFLAGS_PROFILE	= $(TEST_LDFLAGS) $(CFLAGS_PROFILE)
LDFLAGS_SHARED	= $(TEST_LDFLAGS) $(CFLAGS_SHARED) 

LDFLAGS_DEFAULT	= $(LINK_SHARED) $(LDFLAGS_SHARED)

# flags for library built by this makefile
LDFLAGS		= $(TEST_ARGS) -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/ncurses-native/6.3+20220423-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2 \
	 $(TEST_LIBS)  $(CXXLIBS)

AUTO_SRC	= \
		etip.h

################################################################################

.PHONY :	all
.PHONY :	check
.PHONY :	clean
.PHONY :	depend
.PHONY :	distclean
.PHONY :	install
.PHONY :	install.libs
.PHONY :	libs
.PHONY :	mostlyclean
.PHONY :	realclean
.PHONY :	sources
.PHONY :	uninstall
.PHONY :	uninstall.libs

all \
libs ::		$(AUTO_SRC) $(LIBRARIES)

all ::		demo$x

depend :

sources :	$(AUTO_SRC)

tags:
	$(CTAGS) *.[h] *.cc

$(DESTDIR)$(libdir) :
	mkdir -p $@

mostlyclean ::
	-rm -f core tags TAGS *~ *.bak *.i *.ii *.ln *.atac trace

clean :: mostlyclean
	-$(SHELL) -c "if test -n '$x' ; then $(MAKE) clean x=''; fi"
	-rm -rf $(MODEL)/SunWS_cache
	-$(LIBTOOL_CLEAN) rm -f demo$x $(AUTO_SRC) $(LIBRARIES) $(OBJS_DEMO)
	-rm -rf .libs *.dSYM

distclean :: clean
	-rm -f Makefile

realclean :: distclean

###############################################################################

HEADER_DEPS	=  \
	etip.h \
	../include/curses.h \
	../include/eti.h \
	../include/form.h \
	../include/menu.h \
	../include/ncurses_cfg.h \
	../include/ncurses_def.h \
	../include/ncurses_dll.h \
	../include/panel.h \
	../include/unctrl.h \
	$(INCDIR)/nc_string.h \
	$(srcdir)/cursesp.h \
	$(srcdir)/cursesw.h \
	$(srcdir)/cursslk.h \
	$(srcdir)/internal.h

cursesw_h	= $(srcdir)/cursesw.h \
		  $(HEADER_DEPS)

cursesp_h	= $(srcdir)/cursesp.h \
		  $(cursesw_h)

cursesf_h	= $(srcdir)/cursesf.h \
		  $(cursesp_h)

cursesm_h	= $(srcdir)/cursesm.h \
		  $(cursesp_h)

cursslk_h	= $(srcdir)/cursslk.h \
		  $(cursesw_h)

cursesapp_h	= $(srcdir)/cursesapp.h \
		  $(cursslk_h)

$(INCDIR)/form.h :
	( cd ../form && $(MAKE) $@ )

$(INCDIR)/menu.h :
	( cd ../menu && $(MAKE) $@ )

$(INCDIR)/panel.h :
	( cd ../panel && $(MAKE) $@ )

###############################################################################

OBJS_DEMO = $(MODEL)/demo$o

$(MODEL)/demo$o : $(srcdir)/demo.cc \
		$(HEADER_DEPS) \
		$(cursesf_h) \
		$(cursesm_h) \
		$(cursesapp_h)
	@echo 'compiling demo (obj_s)'
	@( cd $(MODEL) && $(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_DEFAULT) -c $(top_srcdir)/c++/demo.cc -o $@ )

demo$x:	$(OBJS_DEMO) \
	$(LIBRARIES)  \
	../lib/libform.so ../lib/libmenu.so ../lib/libpanel.so ../lib/libncurses.so ../lib/libtinfo.so
	 $(LINK) -o $@ $(OBJS_DEMO) $(LDFLAGS_DEFAULT)

etip.h:	$(srcdir)/etip.h.in $(srcdir)/edit_cfg.sh
	cp $(srcdir)/etip.h.in $@
	$(SHELL) $(srcdir)/edit_cfg.sh ../include/ncurses_cfg.h $@

# Verify that each header-file can be compiled without including another.
check ::
	@$(SHELL) -c "for header in *.h;\
		do \
			[ \$${header} = etip.h ] && continue; \
			echo \"** testing \$${header}\" ; \
			echo \"#include <\$${header}>\" >headers.cc; \
			echo \"int main(int argc, char **argv) { (void) argc; (void) argv; return 0; }\" >>headers.cc; \
			$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) headers.cc; \
		done"
	-@rm -f headers.*

###############################################################################
# The remainder of this file is automatically generated during configuration
###############################################################################

# generated by mk-0th.awk
#   libname:    c++
#   subsets:    ticlib termlib+ext_tinfo base+ext_funcs

.SUFFIXES: .c .cc .h .i .ii
.c.i :
	$(CPP) $(CPPFLAGS) $< >$@
.cc.ii :
	$(CPP) $(CPPFLAGS) $< >$@
.h.i :
	$(CPP) $(CPPFLAGS) $< >$@

C_SRC = \
	$(srcdir)/cursesf.cc \
	$(srcdir)/cursesm.cc \
	$(srcdir)/cursesw.cc \
	$(srcdir)/cursespad.cc \
	$(srcdir)/cursesp.cc \
	$(srcdir)/cursslk.cc \
	$(srcdir)/cursesapp.cc \
	$(srcdir)/cursesmain.cc

clean ::
	rm -f llib-lc++.*

realclean ::
	rm -f llib-lc++

llib-lc++ : $(C_SRC)
	cproto -a -l -DNCURSES_ENABLE_STDBOOL_H=0 -DLINT $(CPPFLAGS) $(C_SRC) >$@

lintlib ::
	sh $(srcdir)/../misc/makellib c++ $(CPPFLAGS)

lint ::
	$(LINT) $(LINT_OPTS) $(CPPFLAGS) $(C_SRC) $(LINT_LIBS)





# overriding model from SHARED to match CXX_MODEL

# generated by mk-1st.awk (subset=base+ext_funcs)
#  name:            ncurses++
#  traces:          DEBUG
#  MODEL:           NORMAL
#  CXX_MODEL:       NORMAL
#  LIB_SUFFIX:      
#  USE_LIB_SUFFIX:  
#  model:           obj_s
#  prefix:          lib
#  suffix:          .a
#  subset:          base+ext_funcs
#  driver:          no
#  ShlibVer:        rel
#  ShlibVerInfix:   no
#  SymLink:         ln -s -f
#  TermlibRoot:     tinfo
#  TermlibSuffix:   .so
#  ReLink:          yes
#  ReRanlib:        yes
#  DoLinks:         no
#  rmSoLocs:        no
#  ldconfig:        /sbin/ldconfig
#  make_phony:      yes
#  overwrite:       no
#  depend:          ../include/ncurses_cfg.h
#  host:            x86_64-pc-linux-gnu
#  libtool_version: -version-number

NORMAL_OBJS = \
	../obj_s/cursesf$o \
	../obj_s/cursesm$o \
	../obj_s/cursesw$o \
	../obj_s/cursespad$o \
	../obj_s/cursesp$o \
	../obj_s/cursslk$o \
	../obj_s/cursesapp$o \
	../obj_s/cursesmain$o

$(NORMAL_OBJS) : ../include/ncurses_cfg.h

../lib/libncurses++.a : $(NORMAL_OBJS)
	$(CXX_AR) $(CXX_ARFLAGS) $@ $?
	$(RANLIB) $@

install \
install.libs \
install.ncurses++ :: $(DESTDIR)$(libdir) ../lib/libncurses++.a
	@echo installing ../lib/libncurses++.a as $(DESTDIR)$(libdir)/libncurses++.a
	$(INSTALL_DATA) ../lib/libncurses++.a $(DESTDIR)$(libdir)/libncurses++.a
	$(RANLIB) $(DESTDIR)$(libdir)/libncurses++.a

uninstall \
uninstall.libs \
uninstall.ncurses++ ::
	@echo uninstalling $(DESTDIR)$(libdir)/libncurses++.a
	-@rm -f $(DESTDIR)$(libdir)/libncurses++.a

clean ::
	-rm -f ../lib/libncurses++.a

mostlyclean::
	-rm -f $(NORMAL_OBJS)

# generated by mk-2nd.awk
#   model:      obj_s
#   MODEL:      SHARED
#   echo:       yes
#   subset:     base+ext_funcs
#   crenames:   yes
#   cxxrenames: yes
#   traces:     DEBUG
#   srcdir:     ../../git

../obj_s/cursesf$o :	$(srcdir)/cursesf.cc \
			$(internal_h) \
			$(cursesf_h) \
			$(cursesapp_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesf.cc -o ../obj_s/cursesf$o

../obj_s/cursesm$o :	$(srcdir)/cursesm.cc \
			$(internal_h) \
			$(cursesm_h) \
			$(cursesapp_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesm.cc -o ../obj_s/cursesm$o

../obj_s/cursesw$o :	$(srcdir)/cursesw.cc \
			$(internal_h) \
			$(cursesw_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesw.cc -o ../obj_s/cursesw$o

../obj_s/cursespad$o :	$(srcdir)/cursespad.cc \
			$(internal_h) \
			$(cursesw_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursespad.cc -o ../obj_s/cursespad$o

../obj_s/cursesp$o :	$(srcdir)/cursesp.cc \
			$(internal_h) \
			$(cursesp_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesp.cc -o ../obj_s/cursesp$o

../obj_s/cursslk$o :	$(srcdir)/cursslk.cc \
			$(internal_h) \
			$(cursesapp_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursslk.cc -o ../obj_s/cursslk$o

../obj_s/cursesapp$o :	$(srcdir)/cursesapp.cc \
			$(internal_h) \
			$(cursesapp_h)
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesapp.cc -o ../obj_s/cursesapp$o

../obj_s/cursesmain$o :	$(srcdir)/cursesmain.cc \
			$(internal_h) \
			$(cursesapp_h) \
			$(INCDIR)/nc_alloc.h
	$(LIBTOOL_COMPILE) $(CXX) $(CFLAGS_SHARED) -c $(srcdir)/cursesmain.cc -o ../obj_s/cursesmain$o


# generated by mk-hdr.awk
#  subset:     ticlib termlib+ext_tinfo base+ext_funcs
#  compat:     yes

${INCLUDEDIR} :
	mkdir -p $@

install \
install.libs \
install.includes :: ${AUTO_SRC} ${INCLUDEDIR} \
		$(srcdir)/cursesapp.h \
		$(srcdir)/cursesf.h \
		$(srcdir)/cursesm.h \
		$(srcdir)/cursesp.h \
		$(srcdir)/cursesw.h \
		$(srcdir)/cursslk.h \
		etip.h
	@ (cd ${INCLUDEDIR} && rm -f cursesapp.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursesapp.h
	@ (cd ${INCLUDEDIR} && rm -f cursesf.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursesf.h
	@ (cd ${INCLUDEDIR} && rm -f cursesm.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursesm.h
	@ (cd ${INCLUDEDIR} && rm -f cursesp.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursesp.h
	@ (cd ${INCLUDEDIR} && rm -f cursesw.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursesw.h
	@ (cd ${INCLUDEDIR} && rm -f cursslk.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} $(srcdir)/cursslk.h
	@ (cd ${INCLUDEDIR} && rm -f etip.h) ; ../headers.sh ${INSTALL_DATA} ${INCLUDEDIR} ${srcdir} etip.h

uninstall \
uninstall.libs \
uninstall.includes ::
	-@ (cd ${INCLUDEDIR} && rm -f cursesapp.h)
	-@ (cd ${INCLUDEDIR} && rm -f cursesf.h)
	-@ (cd ${INCLUDEDIR} && rm -f cursesm.h)
	-@ (cd ${INCLUDEDIR} && rm -f cursesp.h)
	-@ (cd ${INCLUDEDIR} && rm -f cursesw.h)
	-@ (cd ${INCLUDEDIR} && rm -f cursslk.h)
	-@ (cd ${INCLUDEDIR} && rm -f etip.h)
