# FreeBSD Arcade Builder

Make Custom Arcade Cabinet ISO's from Microsoft Windows Games.

Based on Potabi by Kai Lyons: https://github.com/Potabi/potabi-build

[Download pre-built ISO](https://drive.google.com/drive/folders/1Wy4dKiv4iAsebTv_V8W-aqdpFZwAZQ84?usp=share_link), (write to USB stick or SD card with [balenaEtcher](https://www.balena.io/etcher/)).

Screenshots of the pre-built ISO can be seen in the animated GIF below:

![slideshow.gif](https://github.com/time-killer-games/freebsd-arcade-builder/raw/main/slideshow.gif "slideshow")

---------------------------------------------------------------------

# Build Steps

1) Clone the repository on a FreeBSD 13.2-RELEASE installation, (download FreeBSD from [FreeBSD.org](https://www.freebsd.org/)):

```
git clone https://github.com/time-killer-games/freebsd-arcade-builder ~/freebsd-arcade-builder
```

2) Overwrite "~/freebsd-arcade-builder/src/wine/executable/run.exe" with a valid Microsoft Windows EXE. 

The executable's main window must have no border or title bar and should fill the primary monitor's resolution. Make sure there is no way to switch out of fullscreen into windowed mode. GameMaker games are known to work, (both legacy and Studio-branded versions). Use GameMaker native DLL extensions sparingly, as they might not be compatible with WINE. Prefer using WASD instead of arrow keys for keyboard controls. Mouse touchpads and touch screens do not work well without additional configuration. Gamepad and joystick support needs to be added manually. For Visual C++ developers, use the code below, to set your window to fullscreen: 

```
int w = GetSystemMetrics(SM_CXSCREEN);
int h = GetSystemMetrics(SM_CYSCREEN);
SetWindowLongPtr(hwnd, GWL_STYLE, WS_VISIBLE | WS_POPUP);
SetWindowPos(hwnd, HWND_TOP, 0, 0, w, h, SWP_FRAMECHANGED);
```

3) Run the following to build yourself a bootable FreeBSD ISO image:

```
sudo ~/freebsd-arcade-builder/build.sh
```

4) The output iso file will be located at "/usr/local/freebsd-build/iso/freebsd.iso". Get it out of there.

5) Run the following to delete files you longer need:

```
sudo rm -fr /usr/local/freebsd-build
```

The screen resolution of the operating system is rendered at `640x480` pixels. 

Edit `build.sh` and `loader.conf` to change this to a new screen resolution.
