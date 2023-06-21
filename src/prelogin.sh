#!/bin/sh
if [ `uname -m` = "arm64" ]; then
    if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak' ]; then
        su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf";
    fi;
    if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf' ]; then
        su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak";
    fi;
else
    if [ `/sbin/sysctl machdep.bootmethod | /usr/bin/awk -F' ' '{print $2}'` = BIOS ]; then
        if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf' ]; then
            su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak";
        fi;
        if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak' ]; then
        su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf";
        fi;
    else
        if [ `/sbin/sysctl machdep.bootmethod | /usr/bin/awk -F' ' '{print $2}'` = UEFI ]; then
            if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak' ]; then
                su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf.bak /usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf";
            fi;
            if [ -r '/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf' ]; then
                su -l root -c "mv -f /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf /usr/local/etc/X11/xorg.conf.d/xorg-bios.conf.bak";
            fi;
        fi;
    fi;
fi;