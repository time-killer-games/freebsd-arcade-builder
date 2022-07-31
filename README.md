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

2) Overwrite "~/freebsd-arcade-builder/src/wine/executable/run.exe" with a valid fullscreen Microsoft Windows executable. 

The executable's main window must have no border or title bar and should fill the primary monitor's resolution. Make sure there is no way to switch out of fullscreen into windowed mode. GameMaker games are known to work, (both legacy and Studio-branded versions). Use GameMaker native DLL extensions sparingly, as they might not be compatible with WINE. For Visual C++ developers, you may use the Windows API code below, to set your window to fullscreen: 

```
int w = GetSystemMetrics(SM_CXSCREEN);
int h = GetSystemMetrics(SM_CYSCREEN);
SetWindowLongPtr(hwnd, GWL_STYLE, WS_VISIBLE | WS_POPUP);
SetWindowPos(hwnd, HWND_TOP, 0, 0, w, h, SWP_FRAMECHANGED);
```

3) Run the following to build yourself a bootable FreeBSD ISO image:

```
sudo ~/freebsd-arcade-builder-wine/build.sh
```

4) The output iso file will be located at "/usr/local/freebsd-build/iso/freebsd.iso". Get it out of there.

5) Run the following to delete files you longer need:

```
sudo rm -fr /usr/local/freebsd-build
```

