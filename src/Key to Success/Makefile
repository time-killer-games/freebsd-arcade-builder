GCCVER := $(shell gcc -dumpversion | cut -c 1)

# Define current OS, while treating MidnightBSD as FreeBSD
ifeq ($(shell uname -s), MidnightBSD)
	OS := FreeBSD
else
	OS := $(shell uname -s)
endif

# Determine whether Unix-based
ifeq ($(OS), Darwin)
	UNIX_BASED := true
else ifeq ($(OS), Linux)
	UNIX_BASED := true
else ifeq ($(OS), FreeBSD)
	UNIX_BASED := true
else ifeq ($(OS), DragonFly)
	UNIX_BASED := true
else ifeq ($(OS), NetBSD)
	UNIX_BASED := true
else  ifeq ($(OS), OpenBSD)
	UNIX_BASED := true
else  ifeq ($(OS), SunOS)
	UNIX_BASED := true
else
	UNIX_BASED := false
endif

ifeq ($(UNIX_BASED), true)
	ARCH := $(shell uname -m)
	SUFFIX := -$(OS)-$(ARCH)
else
	ARCH := $(shell gcc -dumpmachine | sed 's/-w.*//')
	SUFFIX := -Windows-$(ARCH)
endif

# Determine current platform
ifeq ($(OS), Darwin)
	PLATFORM := Cocoa
	MKDIR := mkdir
	LIB_PFX := lib
	LIB_EXT := $(SUFFIX).dylib
	BIN_EXT := $(SUFFIX)
else ifeq ($(UNIX_BASED), true)
	PLATFORM := xlib
	MKDIR := mkdir
	LIB_PFX := lib
	LIB_EXT := $(SUFFIX).so
	BIN_EXT := $(SUFFIX)
else
	PLATFORM := Win32
	MKDIR := mkdir.exe
	LIB_PFX := lib
	LIB_EXT := $(SUFFIX).dll
	BIN_EXT := $(SUFFIX).exe
endif

# Global g++ flags
CXXFLAGS := -std=c++17 -Wall -Wextra -Wpedantic -g -I.
LDFLAGS := -g

# MacPorts include and lib folders
ifeq ($(OS), Darwin)
	CXXFLAGS += -I/opt/local/include -I/usr/local/include
	CFLAGS   += -I/opt/local/include -I/usr/local/include
	LDFLAGS  += -L/opt/local/lib -L/usr/local/lib
	LDFLIBS  += -L/opt/local/lib -L/usr/local/lib
endif

# FreeBSD include and lib folders
ifeq ($(OS), FreeBSD)
	CXXFLAGS += -I/usr/local/include
	CFLAGS   += -I/usr/local/include
	LDFLAGS  += -L/usr/local/lib
	LDFLIBS  += -L/usr/local/lib
endif

# DragonFlyBSD include and lib folders
ifeq ($(OS), DragonFly)
	CXXFLAGS += -I/usr/local/include
	CFLAGS   += -I/usr/local/include
	LDFLAGS  += -L/usr/local/lib
	LDFLIBS  += -L/usr/local/lib
endif

# NetBSD include and lib folders
ifeq ($(OS), NetBSD)
	CXXFLAGS += -I/usr/pkg/include
	CFLAGS   += -I/usr/pkg/include
	LDFLAGS  += -L/usr/pkg/lib
	LDFLIBS  += -L/usr/pkg/lib
endif

# OpenBSD include and lib folders
ifeq ($(OS), OpenBSD)
	CXXFLAGS += -I/usr/local/include
	CFLAGS   += -I/usr/local/include
	LDFLAGS  += -L/usr/local/lib
	LDFLIBS  += -L/usr/local/lib
endif

# SunOS include and lib folders
ifeq ($(OS), SunOS)
	CXXFLAGS += -I/usr/include
	CFLAGS   += -I/usr/include
	LDFLAGS  += -L/usr/lib/64
	LDFLIBS  += -L/usr/lib/64
endif

# These will be relative to the file that includes this Makefile
SRC_DIR := .
OBJ_DIR := .eobjs
WORKDIR := src/stigma/

# This implements a recursive wildcard allowing us to iterate in subdirs
rwildcard=$(wildcard $1/$2) $(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2))

PATH := $(eTCpath)$(PATH)
SHELL := /bin/sh
CP := /bin/cp

.PHONY: all clean .FORCE

all: .FORCE
	MKBUILDDIR := $(shell mkdir -p "build")
	$(CP) -f "src/stigma/data.res" "build/Key to Success.res"
ifeq ($(OS), Darwin)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="MacOSX" TARGET-PLATFORM="MacOSX" CC="clang" CXX="clang++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="Clang" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), Linux)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="Linux" CC="gcc" CXX="g++" MAKE="make" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="GNU_GCC_G++" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/Linux/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), FreeBSD)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="FreeBSD" CC="clang" CXX="clang++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="Clang" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/BSD/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), DragonFly)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="DragonFlyBSD" CC="gcc" CXX="g++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="GNU_GCC_G++" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/BSD/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), NetBSD)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="NetBSD" CC="gcc" CXX="g++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="GNU_GCC_G++" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/BSD/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), OpenBSD)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="OpenBSD" CC="clang" CXX="clang++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="Clang" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/BSD/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else ifeq ($(OS), SunOS)
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="xlib" TARGET-PLATFORM="SunOS" CC="gcc" CXX="g++" MAKE="gmake" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="GNU_GCC_G++" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie  -IPlatforms/xlib/SunOS/ -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
else
	@$(MAKE) -C "src" WORKDIR="stigma/" CODEGEN="stigma/" GMODE="Compile" GRAPHICS="OpenGL1" AUDIO="SDL" COLLISION="Precise" PLATFORM="Win32" TARGET-PLATFORM="Windows" CC="gcc" CXX="g++" MAKE="make" CXXFLAGS="-fdiagnostics-color=always" COMPILEPATH="GNU_GCC_G++" EXTENSIONS=" Universal_System/Extensions/chdir Universal_System/Extensions/HideErrors Universal_System/Extensions/Paths Universal_System/Extensions/Alarms" OUTPUTNAME="../build/Key to Success" CXXFLAGS="-fdiagnostics-color=always -std=c++17 -D_REENTRANT -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections -fno-pie -IBridges/OpenGL -IGraphics_Systems/OpenGL-Common/ -DHIDE_DEBUG_MESSAGES -DPATH_EXT_SET -fexceptions -I. -Istigma/"
endif

clean: .FORCE
	@$(MAKE) -C "src" clean
	@$(RM) -fr "build"

.FORCE:
