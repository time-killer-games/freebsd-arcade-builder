

#################
# configuration #
#################

# PLATFORM { Platforms/* }
include Config.mk

MAKE_TARGETS :=
MAKE_TARGETS += compile_game

# GMODE { Run, Build, Debug, Compile }
GMODE ?= Compile

# GRAPHICS { Graphics_Systems/* }
GRAPHICS ?= OpenGL1

# AUDIO { Audio_Systems/* }
AUDIO ?= SDL

# COLLISION { Collision_Systems/* }
COLLISION ?= Precise

# RESOURCE FILE WITH ICON AND VERSION INFO
ifeq ($(TARGET-PLATFORM), Windows)
RESOURCES += Preprocessor_Environment_Editable/Resources.rc
endif

# Default windres
WINDRES = windres.exe --codepage=65001

# Default find
FIND = find

SYSTEMS := Platforms/$(PLATFORM) Graphics_Systems/$(GRAPHICS) Audio_Systems/$(AUDIO) Collision_Systems/$(COLLISION) Universal_System

OBJDIR := $(WORKDIR).eobjs/$(COMPILEPATH)/$(GMODE)

###########
# options #
###########

CXX := g++
CC := gcc
DEPENDENCIES :=
override CXXFLAGS += -std=c++17

ifeq ($(OS), Darwin)
	ifeq ($(shell uname -m), arm64)
		override CXXFLAGS += -I/opt/homebrew/include -I/opt/homebrew/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
		override CFLAGS += -I/opt/homebrew/include -I/opt/homebrew/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
 		override LDFLAGS += "/opt/homebrew/lib/libSDL2.a" "/opt/homebrew/opt/zlib/lib/libz.a" "/opt/homebrew/lib/libpng.a" -liconv -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-weak_framework,CoreHaptics -Wl,-weak_framework,GameController -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal -framework CoreFoundation -framework CoreGraphics -framework AppKit -Xlinker -no_warn_duplicate_libraries
		override CXXFLAGS += -I/opt/homebrew/include -I/opt/homebrew/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
		override CFLAGS += -I/opt/homebrew/include -I/opt/homebrew/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
 		override LDLIBS += "/opt/homebrew/lib/libSDL2.a" "/opt/homebrew/opt/zlib/lib/libz.a" "/opt/homebrew/lib/libpng.a" -liconv -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-weak_framework,CoreHaptics -Wl,-weak_framework,GameController -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal -framework CoreFoundation -framework CoreGraphics -framework AppKit -Xlinker -no_warn_duplicate_libraries
 	else
 		override CXXFLAGS += -I/usr/local/include -I/usr/local/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
		override CFLAGS += -I/usr/local/include -I/usr/local/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
 		override LDFLAGS += "/usr/local/lib/libSDL2.a" "/usr/local/opt/zlib/lib/libz.a" "/usr/local/lib/libpng.a" -liconv -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-weak_framework,CoreHaptics -Wl,-weak_framework,GameController -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal -framework CoreFoundation -framework CoreGraphics -framework AppKit -Xlinker -no_warn_duplicate_libraries
		override CXXFLAGS += -I/usr/local/include -I/usr/local/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
		override CFLAGS += -I/usr/local/include -I/usr/local/include/SDL2 -DPROCESS_GUIWINDOW_IMPL -ObjC++
 		override LDLIBS += "/usr/local/lib/libSDL2.a" "/usr/local/opt/zlib/lib/libz.a" "/usr/local/lib/libpng.a" -liconv -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-weak_framework,CoreHaptics -Wl,-weak_framework,GameController -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal -framework CoreFoundation -framework CoreGraphics -framework AppKit -Xlinker -no_warn_duplicate_libraries
 	endif
else ifeq ($(OS), Linux)
	override CXXFLAGS += $(shell pkg-config --cflags sdl2) -DPROCESS_GUIWINDOW_IMPL
	override CFLAGS += $(shell pkg-config --cflags sdl2) -DPROCESS_GUIWINDOW_IMPL
	override LDLIBS += $(shell pkg-config --libs --static sdl2) -DPROCESS_GUIWINDOW_IMPL
	override LDFLAGS += $(shell pkg-config --libs --static sdl2) -DPROCESS_GUIWINDOW_IMPL
else ifeq ($(OS), FreeBSD)
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
else ifeq ($(OS), DragonFly)
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
else ifeq ($(OS), NetBSD)
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/pkg/include
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/pkg/include
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -L/usr/pkg/lib
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -L/usr/pkg/lib
else ifeq ($(OS), OpenBSD)
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/local/include
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -L/usr/local/lib
else ifeq ($(OS), SunOS)
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/include
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL -I/usr/include
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -L/usr/lib/64
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -L/usr/lib/64
else
	override CXXFLAGS += -DPROCESS_GUIWINDOW_IMPL $(shell pkg-config --cflags sdl2) -static
	override CFLAGS += -DPROCESS_GUIWINDOW_IMPL $(shell pkg-config --cflags sdl2) -static
	override LDLIBS += -DPROCESS_GUIWINDOW_IMPL -lmingw32 -lshell32 -lole32 -luuid -lsetupapi -lImm32 -lversion -loleaut32 $(shell pkg-config --libs sdl2) -static
	override LDFLAGS += -DPROCESS_GUIWINDOW_IMPL -lmingw32 -lshell32 -lole32 -luuid -lsetupapi -lImm32 -lversion -loleaut32 $(shell pkg-config --libs sdl2) -static
endif

ifeq ($(OS), Darwin)
	override LDFLAGS += -framework CoreGraphics -framework CoreFoundation -framework AppKit
	override LDLIBS += -framework CoreGraphics -framework CoreFoundation -framework AppKit
	override CXXFLAGS += -ObjC++
	override CFLAGS += -ObjC++
else ifeq ($(OS), Linux)
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lpthread -lm -lpng -lxcb -lXrandr -lXinerama -lXext
else ifeq ($(OS), FreeBSD)  
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lprocstat -lutil -lc -lpthread -lkvm -lm -linotify -lpng -lxcb -lXrandr -lXinerama -lXext
else ifeq ($(OS), DragonFly)
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lc -lpthread -lkvm -lm -lpng -lxcb -lXrandr -lXinerama -lXext
else ifeq ($(OS), NetBSD)
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lc -lpthread -lkvm -lm -lpng -lxcb -lXrandr -lXinerama -lXext
else ifeq ($(OS), OpenBSD)
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lc -lpthread -lkvm -lm -lpng -lxcb -lXrandr -lXinerama -lXext
else ifeq ($(OS), SunOS)
	override CXXFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override CFLAGS += $(shell pkg-config --cflags x11) $(shell pkg-config --cflags sdl2)
	override LDFLAGS += $(shell pkg-config --libs x11) $(shell pkg-config --libs sdl2) -lc -lpthread -lkvm -lm -lpng -lxcb -lXrandr -lXinerama -lXext
else
	override LDFLAGS += -lpng
endif

ifeq ($(OS), Darwin)
else
	override LDFLAGS += -lz
	override LDLIBS += -lz
endif
 
ifeq ($(GMODE), Debug)
	override CXXFLAGS += -Wall -g -DDEBUG_MODE
	override CFLAGS += -Wall -g -DDEBUG_MODE
	# Disable PIE when possible
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -no-pie
		override LDFLAGS += -no-pie
	endif
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -nopie
		override LDFLAGS += -nopie
	endif
else ifeq ($(GMODE), Compile)
	override CXXFLAGS += -Wall -s -O3 -fno-rtti -fno-exceptions -flto -fdata-sections -ffunction-sections
	override CFLAGS += -Wall -s -O3 -flto -fno-exceptions -fdata-sections -ffunction-sections
	override LDFLAGS += -flto -s -O3

	# Disable PIE when possible
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -no-pie
		override LDFLAGS += -no-pie
	endif
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -nopie
		override LDFLAGS += -nopie
	endif
else
	override CXXFLAGS += -Wall -s -O3 -fno-rtti -fno-exceptions
	override CFLAGS += -Wall -s -O3 -fno-exceptions
	# Disable PIE when possible
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -no-pie
		override LDFLAGS += -no-pie
	endif
	ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
		override CXXFLAGS += -fno-pie
		override CFLAGS += -fno-pie
		override LDLIBS += -nopie
		override LDFLAGS += -nopie
	endif
endif

ifeq ($(PLATFORM), Win32)
	ifeq ($(GMODE), Compile)
		override LDFLAGS += -static-libgcc -Wl,-subsystem,windows
	endif
endif

# CPPFLAGS needs these include dirs unconditionally
override CPPFLAGS += $(SYSTEMS:%=-I%/Info)
override CPPFLAGS += -I. -I$(CODEGEN)

.PHONY: all clean compile_game clean print_flags write_src_files

all: $(MAKE_TARGETS)

print_flags:
	@echo ""
	@echo "################ Compiler Info ################"
	@$(CXX) --version
	@echo "CXXFLAGS=\"$(CXXFLAGS) $(CPPFLAGS) $(INCLUDES)\""
	@echo "CFLAGS=\"$(CFLAGS) $(CPPFLAGS)\""
	@echo "LDFLAGS=\"$(LDFLAGS)\""
	@echo "################################################"
	@echo ""

clean:
	$(RM) $(OUTPUTNAME) $(RESOURCEBINARY)
	$(FIND) "$(WORKDIR).eobjs/$(COMPILEPATH)" -name "*.o" -exec $(RM) -rf {} \;
	$(FIND) "$(WORKDIR).eobjs/$(COMPILEPATH)" -name "*.d" -exec $(RM) -rf {} \;

SOURCES := $(wildcard *.cpp) $(wildcard Platforms/General/*.cpp)
include $(addsuffix /Makefile,$(SYSTEMS) $(EXTENSIONS))
include Bridges/$(PLATFORM)-$(GRAPHICS)/Makefile

ifeq ($(UNIX_BASED), false)
	override CXXFLAGS += -DPROCESS_WIN32EXE_INCLUDES -std=c++17
	override CFLAGS += -DPROCESS_WIN32EXE_INCLUDES -std=c++17
endif

override CXXFLAGS += -fexceptions
SOURCES += $(wildcard apifilesystem/*.cpp)
SOURCES += $(wildcard tempdir/*.cpp)

#This does not work, use a for loop and prepend it to each one not the whole string
OBJECTS := $(addprefix $(OBJDIR)/,$(patsubst %.m, %.o, $(patsubst %.cpp, %.o, $(patsubst %.c, %.o, $(SOURCES)))))
#RCFILES := $(addprefix $(WORKDIR),$(RESOURCES))
DEPENDS := $(OBJECTS:.o=.d)

OBJDIRS := $(sort $(dir $(OBJECTS) $(RCFILES)))

############
# building #
############

write_src_files:
	@echo "$(SOURCES)" > $(WORKDIR)/sources.list

compile_game: print_flags $(OBJECTS) $(RCFILES) $(RESOURCEBINARY) $(DEPENDENCIES)
	@echo "Linking $(OUTPUTNAME)"
	@$(CXX) $(LDFLAGS) -o "$(OUTPUTNAME)" $(OBJECTS) $(RESOURCEBINARY) $(LDLIBS)
	@echo Built to "$(OUTPUTNAME)"

# GCC will figure out dependencies and write out makefile rules in %.d when they change
# -MMD outputs dependencies to %.d as a side effect of compilation, ignoring system headers
# -MP gives phony rules for non-target files, avoiding problems with missing files
$(OBJDIR)/%.o: %.cpp | $(OBJDIRS)
	@echo [$(CXX)] $<
	@$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) -MMD -MP -c -o $(OBJDIR)/$*.o $<

$(OBJDIR)/%.o: %.c | $(OBJDIRS)
	@echo [$(CC)] $<
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) -MMD -MP -c -o $(OBJDIR)/$*.o $<

$(OBJDIR)/%.o: %.m | $(OBJDIRS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) -MMD -MP -c -o $(OBJDIR)/$*.o $<

GENERATED_FILE:

$(OBJDIR)/%.rc: %.rc
	@echo [$(WINDRES)] $<
	@$(WINDRES) -o $@ -I. -I$(WORKDIR) $^ -O rc $(RCFLAGS)

$(OBJDIRS):
	@$(MKDIR) -p $@

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPENDS)
endif
