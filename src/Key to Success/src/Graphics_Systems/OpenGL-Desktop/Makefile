override CXXFLAGS += -IBridges/OpenGL

ifeq ($(TARGET-PLATFORM), Windows)
	override CXXFLAGS += -DGLEW_STATIC
	override LDLIBS += -lglew32 -lopengl32
else ifeq ($(TARGET-PLATFORM), MacOSX)
	override LDLIBS += -framework OpenGL
	ifeq ($(shell uname -m), arm64)
 		override LDFLAGS += "/opt/homebrew/lib/libGLEW.a"
 	else
 		override LDFLAGS += "/usr/local/lib/libGLEW.a"
	endif
else ifeq ($(TARGET-PLATFORM), Linux)
	override LDLIBS += -lGL -lGLEW
else ifeq ($(TARGET-PLATFORM), FreeBSD)
	override LDLIBS += -lGL -lGLEW
else ifeq ($(TARGET-PLATFORM), DragonFlyBSD)
	override LDLIBS += -lGL -lGLEW
else ifeq ($(TARGET-PLATFORM), NetBSD)
	override LDLIBS += -lGL -lGLEW
else ifeq ($(TARGET-PLATFORM), OpenBSD)
	override LDLIBS += -lGL -lGLEW
else ifeq ($(TARGET-PLATFORM), SunOS)
	override LDLIBS += -lGL -lGLEW
endif
