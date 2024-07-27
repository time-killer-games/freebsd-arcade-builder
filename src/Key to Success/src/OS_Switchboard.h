// Identify the operating system
// Note: You should NOT ADD ON to this list if LateralGM doesn't run on the platform you intend to add!
#define OS_WINDOWS   0
#define OS_MACOSX    1
#define OS_LINUX     2
#define OS_FREEBSD   3
#define OS_DRAGONFLY 4
#define OS_NETBSD    5
#define OS_OPENBSD   6
#define OS_SUNOS     7

#if defined(_WIN32)
  #define CURRENT_PLATFORM_NAME "Windows"
  #define CURRENT_PLATFORM_ID   OS_WINDOWS
#elif defined(__APPLE__) || defined(__MACH__)
  #define CURRENT_PLATFORM_NAME "MacOSX"
  #define CURRENT_PLATFORM_ID   OS_MACOSX
#elif defined(__linux__)
  #define CURRENT_PLATFORM_NAME "Linux"
  #define CURRENT_PLATFORM_ID   OS_LINUX
#elif defined(__FreeBSD__)
  #define CURRENT_PLATFORM_NAME "FreeBSD"
  #define CURRENT_PLATFORM_ID   OS_FREEBSD
#elif defined(__DragonFly__)
  #define CURRENT_PLATFORM_NAME "DragonFlyBSD"
  #define CURRENT_PLATFORM_ID   OS_DRAGONFLY
#elif defined(__NetBSD__)
  #define CURRENT_PLATFORM_NAME "NetBSD"
  #define CURRENT_PLATFORM_ID   OS_NETBSD
#elif defined(__OpenBSD__)
  #define CURRENT_PLATFORM_NAME "OpenBSD"
  #define CURRENT_PLATFORM_ID   OS_OPENBSD
#elif defined(unix) || defined(__sun)
  #define CURRENT_PLATFORM_NAME "SunOS"
  #define CURRENT_PLATFORM_ID   OS_SUNOS
#else
  #error Unable to determine name of the target platform.
#endif
