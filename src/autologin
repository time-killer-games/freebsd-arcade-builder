#!/bin/sh
if [ `/usr/bin/uname -m` = "arm64" ]; then
    if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak' ]; then
        /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf";
    fi;
    if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf' ]; then
        /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak";
    fi;
else
    if [ `/sbin/sysctl machdep.bootmethod -n` = BIOS ]; then
        if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf' ]; then
            /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak";
        fi;
        if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak' ]; then
            /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf";
        fi;
    else
        if [ `/sbin/sysctl machdep.bootmethod -n` = UEFI ]; then
            if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak' ]; then
                /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf";
            fi;
            if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf' ]; then
                /usr/bin/su -l root -c "/bin/mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak";
            fi;
        fi;
    fi;
fi;
/usr/bin/login freebsd
