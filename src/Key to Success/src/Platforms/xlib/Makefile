OS := $(shell uname -s)
ifeq ($(OS), Darwin)
	override CXXFLAGS += $(shell pkg-config x11 --cflags) -IPlatforms/xlib/Darwin/
	override CFLAGS += $(shell pkg-config x11 --cflags) -IPlatforms/xlib/Darwin/
	override LDFLAGS += $(shell pkg-config x11 --libs) -lXrandr -lXinerama
	override LDLIBS += $(shell pkg-config x11 --libs) -lXrandr -lXinerama
else ifeq ($(OS), Linux)
	override CXXFLAGS += -IPlatforms/xlib/Linux/
	override CFLAGS += -IPlatforms/xlib/Linux/
else ifeq ($(OS), FreeBSD)
	override CXXFLAGS += -IPlatforms/xlib/BSD/
	override CFLAGS += -IPlatforms/xlib/BSD/
else ifeq ($(OS), DragonFly)
	override CXXFLAGS += -IPlatforms/xlib/BSD/
	override CFLAGS += -IPlatforms/xlib/BSD/
else ifeq ($(OS), NetBSD)
	override CXXFLAGS += -IPlatforms/xlib/BSD/
	override CFLAGS += -IPlatforms/xlib/BSD/
else ifeq ($(OS), OpenBSD)
	override CXXFLAGS += -IPlatforms/xlib/BSD/
	override CFLAGS += -IPlatforms/xlib/BSD/
else ifeq ($(OS), SunOS)
	override CXXFLAGS += -IPlatforms/xlib/SunOS/
	override CFLAGS += -IPlatforms/xlib/SunOS/
endif
SOURCES += $(wildcard Platforms/xlib/*.cpp) $(wildcard Platforms/General/POSIX/*.cpp)

