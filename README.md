# FreeBSD Arcade Builder

Make Custom Arcade Cabinet ISO Images from Windows Games

Based on Potabi by Kai Lyons: https://github.com/Potabi/potabi-build

![slideshow.gif](https://github.com/time-killer-games/freebsd-arcade-builder/raw/main/slideshow.gif "slideshow")

---------------------------------------------------------------------

# Build Steps

1) Clone the repository on a FreeBSD 13.1-RELEASE installation, (download FreeBSD from https://www.freebsd.org/):

```
git clone https://github.com/time-killer-games/freebsd-arcade-builder ~/freebsd-arcade-builder
```

2) Overwrite "~/freebsd-arcade-builder/src/wine/executable/run.exe" with a valid fullscreen Windows executable. The executable's main window must have no border or title bar and should fill the primary monitor's resolution. For Visual C++ developers, a Windows API example which will work with default Window Manager, (twm), can be seen below: 

```
int w = GetSystemMetrics(SM_CXSCREEN);
int h = GetSystemMetrics(SM_CYSCREEN);
SetWindowLongPtr(hwnd, GWL_STYLE, WS_VISIBLE | WS_POPUP);
SetWindowPos(hwnd, HWND_TOP, 0, 0, w, h, SWP_FRAMECHANGED);
```

3) GameMaker developers, (both Legacy and Studio versions), may do this instead, to ensure the game runs fullscreen properly, turn on borderless window mode in Game Options a.k.a Global Game Settings, and do not set the window to fullscreen with window_set_fullscreen() or by any other method that is not the code below, (do this in the Step Event):

```
window_set_rectangle(0, 0, display_get_width(), display_get_height());
```

4) Run the following to build yourself a bootable FreeBSD ISO image:

```
sudo ~/freebsd-arcade-builder-wine/build.sh
```

5) The output iso file will be located at "/usr/local/freebsd-build/iso/freebsd.iso". Get it out of there.

6) Run the following to delete files you longer need:

```
sudo rm -fr /usr/local/freebsd-build
```

