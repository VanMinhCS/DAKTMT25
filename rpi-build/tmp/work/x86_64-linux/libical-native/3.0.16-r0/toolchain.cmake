# CMake system name must be something like "Linux".
# This is important for cross-compiling.
set( CMAKE_CROSSCOMPILING FALSE )
set( CMAKE_SYSTEM_NAME Linux )
set( CMAKE_SYSTEM_PROCESSOR x86_64 )
set( CMAKE_C_COMPILER gcc )
set( CMAKE_CXX_COMPILER g++ )
set( CMAKE_C_COMPILER_LAUNCHER  )
set( CMAKE_CXX_COMPILER_LAUNCHER  )
set( CMAKE_ASM_COMPILER gcc )
find_program( CMAKE_AR ar DOC "Archiver" REQUIRED )

set( CMAKE_C_FLAGS "  -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include -O2 -pipe" CACHE STRING "CFLAGS" )
set( CMAKE_CXX_FLAGS "  -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include -O2 -pipe" CACHE STRING "CXXFLAGS" )
set( CMAKE_ASM_FLAGS "  -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include -O2 -pipe" CACHE STRING "ASM FLAGS" )
set( CMAKE_C_FLAGS_RELEASE "-DNDEBUG" CACHE STRING "Additional CFLAGS for release" )
set( CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG" CACHE STRING "Additional CXXFLAGS for release" )
set( CMAKE_ASM_FLAGS_RELEASE "-DNDEBUG" CACHE STRING "Additional ASM FLAGS for release" )
set( CMAKE_C_LINK_FLAGS "  -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2" CACHE STRING "LDFLAGS" )
set( CMAKE_CXX_LINK_FLAGS "  -isystem/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include -O2 -pipe -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -L/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,--enable-new-dtags                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath-link,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib                         -Wl,-rpath,/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/lib                         -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--dynamic-linker=/home/ubuntu/yocto/rpi-build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2" CACHE STRING "LDFLAGS" )

# only search in the paths provided so cmake doesnt pick
# up libraries and tools from the native build machine
set( CMAKE_FIND_ROOT_PATH  /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native     /home/ubuntu/yocto/rpi-build/tmp/hosttools)
set( CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY )
set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH )
set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
set( CMAKE_PROGRAM_PATH "/" )



# Use qt.conf settings
set( ENV{QT_CONF_PATH} /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/qt.conf )

# We need to set the rpath to the correct directory as cmake does not provide any
# directory as rpath by default
set( CMAKE_INSTALL_RPATH /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib )

# Use RPATHs relative to build directory for reproducibility
set( CMAKE_BUILD_RPATH_USE_ORIGIN ON )

# Use our cmake modules
list(APPEND CMAKE_MODULE_PATH "/home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/share/cmake/Modules/")

# add for non /usr/lib libdir, e.g. /usr/lib64
set( CMAKE_LIBRARY_PATH /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/lib)

# add include dir to implicit includes in case it differs from /usr/include
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include)
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES /home/ubuntu/yocto/rpi-build/tmp/work/x86_64-linux/libical-native/3.0.16-r0/recipe-sysroot-native/usr/include)

