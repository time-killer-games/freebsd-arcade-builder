#!/bin/sh
cd "${0%/*}"
set -e -u 

# Run script as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root..."
    exit 1
fi

export cwd="`realpath | sed 's|/scripts||g'`"

. ${cwd}/conf/build.conf
. ${cwd}/conf/general.conf

cleanup(){
    umount ${release} || true
    umount ${release}/dev || true
    umount ${release}/var/cache/pkg/ || true
    mdconfig -d -u 0 || true
    rm -rf ${livecd}/pool.img || true
    rm -rf ${livecd} || true
}

setup(){
    # Make directories
    mkdir -pv ${livecd} ${base} ${iso} ${software} ${base} ${release} ${cdroot}

    # Create and mount pool
    truncate -s 6g ${livecd}/pool.img
    mdconfig -a -t vnode -f ${livecd}/pool.img -u 0
    zpool create freebsd /dev/md0
    zfs set mountpoint=${release} freebsd 
    zfs set compression=gzip-6 freebsd

    # UFS alternative code (just in case)
    # gpart create -s GPT md0
    # gpart add -t freebsd-ufs md0
    # bsdlabel -w md0 auto
    # newfs -U md0a
    # mount /dev/md0a ${release}
}

build(){
    # Base Preconfig
    mkdir -pv ${release}/etc
    
    # Add and extract base/kernel into ${release}
    cd ${base}
    # TODO: Switch with CoreNGS release
    fetch http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/`uname -r`/base.txz
    fetch http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/`uname -r`/kernel.txz
    fetch http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/`uname -r`/lib32.txz
    tar -zxvf base.txz -C ${release}
    tar -zxvf kernel.txz -C ${release}
    tar -zxvf lib32.txz -C ${release}

    # Add base items
    touch ${release}/etc/fstab
    mkdir -pv ${release}/cdrom

    # Add packages
    cp /etc/resolv.conf ${release}/etc/resolv.conf
    mkdir -pv ${release}/var/cache/pkg
    mount_nullfs ${software} ${release}/var/cache/pkg
    mount -t devfs devfs ${release}/dev
    cat ${pkgdir}/${tag}.${desktop}.${platform} | xargs pkg -c ${release} install -y
    chroot ${release} pkg install -y pkg
    chroot ${release} pkg install -y wine
    chroot ${release} pkg install -y winetricks

   # Add live session user
   chroot ${release} pw useradd freebsd \
      -c freebsd -d "/usr/home/freebsd"\
      -g operator -G video,wheel -m -s /bin/csh -k /usr/share/skel -w none

    # Add desktop environment
    chroot ${release} pw mod user "root" -w none
    chroot ${release} chsh -s /bin/csh "root"
    chroot ${release} pw mod user "freebsd" -w none
    chroot ${release} chsh -s /bin/csh "freebsd"
    echo "proc /proc procfs rw 0 0" >> ${release}/etc/fstab
    chroot ${release} mount -t procfs proc /proc
    chroot ${release} su -l freebsd -c "/usr/local/share/wine/pkg32.sh install -y wine mesa-dri"
    chroot ${release} su -l freebsd -c "setenv WINEPREFIX \"/usr/home/freebsd/.wine\" && winetricks dsound && winetricks winxp"
    mkdir -p ${release}/usr/local/etc/rc.d
    mkdir -p ${release}/usr/local/etc/X11/xorg.conf.d
    echo "/usr/home/freebsd/start.sh" > ${release}/usr/home/freebsd/.xinitrc
    echo "/usr/bin/su -l root -c \"/sbin/shutdown -p now\"" >> ${release}/usr/home/freebsd/.xinitrc
    chmod 777 ${release}/usr/home/freebsd/.xinitrc
    echo "RandomPlacement" > ${release}/usr/home/freebsd/.twmrc
    echo "BorderWidth 0" >> ${release}/usr/home/freebsd/.twmrc
    echo "NoTitle" >> ${release}/usr/home/freebsd/.twmrc
    echo "/usr/home/freebsd/start.sh" > ${release}/usr/home/freebsd/.xinitrc
    chmod 777 ${release}/usr/home/freebsd/.xinitrc
    cp -f "${srcdir}/autologin.sh" ${release}/usr/local/etc/rc.d/autologin.sh
    chmod 777 ${release}/usr/local/etc/rc.d/autologin.sh
    echo "kern.corefile=/dev/null" > ${release}/etc/sysctl.conf
    echo "kern.coredump=0" >> ${release}/etc/sysctl.conf
    echo "setenv WINEDLLOVERRIDES \"mscoree,mshtml=\"" >> ${release}/usr/home/freebsd/.login
    echo "startx -- -nocursor" >> ${release}/usr/home/freebsd/.login
    chmod 777 ${release}/usr/home/freebsd/.login
    echo "twm -display :0 &" > ${release}/usr/home/freebsd/start.sh
    echo "sleep 5" >> ${release}/usr/home/freebsd/start.sh
    echo "wine /usr/home/freebsd/executable/run.exe" >> ${release}/usr/home/freebsd/start.sh
    echo "/sbin/shutdown -p now" >> ${release}/usr/home/freebsd/start.sh
    chmod 777 ${release}/usr/home/freebsd/start.sh
    echo "Section \"InputClass\"" > ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Identifier \"evdev\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  MatchDevicePath \"/dev/input/event*\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Driver \"evdev\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "Section \"InputClass\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Identifier \"kbdmux\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  MatchDevicePath \"/dev/kbdmux*\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Driver \"kbd\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "Section  \"Device\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Identifier  \"Card0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Driver  \"scfb\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "Section \"Monitor\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Identifier \"Monitor0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "Section \"Screen\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Identifier \"Screen0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Monitor \"Monitor0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  Device \"Card0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  DefaultDepth 24" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  SubSection \"Display\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "    Depth 24" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "    Modes \"640x480\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "  EndSubSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-uefi.conf
    echo "Section \"InputClass\"" > ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Identifier \"evdev\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  MatchDevicePath \"/dev/input/event*\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Driver \"evdev\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "Section \"InputClass\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Identifier \"kbdmux\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  MatchDevicePath \"/dev/kbdmux*\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Driver \"kbd\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "Section  \"Device\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Identifier  \"Card0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Driver  \"vesa\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "Section \"Monitor\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Identifier \"Monitor0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "Section \"Screen\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Identifier \"Screen0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Monitor \"Monitor0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  Device \"Card0\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  DefaultDepth 24" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  SubSection \"Display\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "    Depth 24" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "    Modes \"640x480\"" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "  EndSubSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    echo "EndSection" >> ${release}/usr/local/etc/X11/xorg.conf.d/xorg-bios.conf
    cp -fR "${srcdir}/wine/executable" ${release}/usr/home/freebsd/

    # remove all packages that are not permissive; cannot use "pkg remove" because it will also remove permissive packages we need
    chroot ${release} pkg remove -y winetricks && chroot ${release} pkg autoremove -y && chroot ${release} pkg clean -y
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq binutils | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq ca_root_nss | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq desktop-file-utils | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq gcc* | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq gettext-runtime | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq gnutls | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq jbigkit | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq libiconv | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq libidn2 | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq liblz4 | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq libtasn1 | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq libunistring | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq nettle | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq readline | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq tpm-emulator | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release pkg info -lq webcamd | sed -e 's/^/\/usr\/local\/freebsd-build\/release/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq binutils | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq ca_root_nss | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq desktop-file-utils | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq gcc* | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq gettext-runtime | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq gnutls | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq jbigkit | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq libiconv | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq libidn2 | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq liblz4 | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq libtasn1 | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq libunistring | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq nettle | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq readline | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq tpm-emulator | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    rm -fr `chroot /usr/local/freebsd-build/release /usr/local/share/wine/pkg32.sh info -lq webcamd | sed -e 's/^/\/usr\/local\/freebsd-build\/release\/usr\/home\/freebsd\/.i386-wine-pkg/' | tr '\n' ' '`
    umount -f ${release}/proc
    
    # Add software overlays 
    mkdir -pv ${release}/usr/local/general ${release}/usr/local/freebsd

    rm ${release}/etc/resolv.conf
    umount ${release}/var/cache/pkg

    # Move source files
    cp ${base}/base.txz ${release}/usr/local/freebsd/base.txz
    cp ${base}/kernel.txz ${release}/usr/local/freebsd/kernel.txz
    cp ${base}/lib32.txz ${release}/usr/local/freebsd/lib32.txz
    
    # rc
    . ${srcdir}/setuprc.sh
    setuprc

    # Other configs
    #mv ${release}/usr/local/etc/devd/automount_devd.conf ${release}/usr/local/etc/devd/automount_devd.conf.skip
    chroot ${release} touch /boot/entropy

    # Extra configuration (borrowed from GhostBSD builder)
    echo "gop set 0" >> ${release}/boot/loader.rc.local

    # This sucks, but it has to function like this if we don't want it to break all the time
    echo "Unmounting ${release}/dev - this could take up to 60 seconds"
    umount ${release}/dev || true
    timer=0
    while [ "$timer" -lt 5000000 ]; do
        timer=$(($timer+1))
    done
    umount -f ${release}/dev || true

    # Uzip Ramdisk and Boot code borrowed from GhostBSD
    # Uzips
    install -o root -g wheel -m 755 -d "${cdroot}"
    mkdir -pv "${cdroot}/data"
    zfs snapshot freebsd@clean
    zfs send -c -e freebsd@clean | dd of=/usr/local/freebsd-build/cdroot/data/system.img status=progress bs=1M

    # Ramdisk
    ramdisk_root="${cdroot}/data/ramdisk"
    mkdir -pv ${ramdisk_root}
    cd "${release}"
    tar -cf - rescue | tar -xf - -C "${ramdisk_root}"
    cd "${prjdir}"
    install -o root -g wheel -m 755 "${rmddir}/init.sh.in" "${ramdisk_root}/init.sh"
    sed "s/@VOLUME@/FREEBSD/" "${rmddir}/init.sh.in" > "${ramdisk_root}/init.sh"
    mkdir -pv "${ramdisk_root}/dev"
    mkdir -pv "${ramdisk_root}/etc"
    touch "${ramdisk_root}/etc/fstab"
    install -o root -g wheel -m 755 "${rmddir}/rc.in" "${ramdisk_root}/etc/rc"
    cp ${release}/etc/login.conf ${ramdisk_root}/etc/login.conf
    makefs -M 10m -b '10%' "${cdroot}/data/ramdisk.ufs" "${ramdisk_root}"
    gzip "${cdroot}/data/ramdisk.ufs"
    rm -rf "${ramdisk_root}"

    # Boot
    cd ${release}
    tar -cf - boot | tar -xf - -C ${cdroot}
    echo "Boot directory listed as: ${boodir}"
    echo "CDRoot directory listed as: ${cdroot}"
    cp -r ${boodir}/* ${cdroot}/boot/.
    mkdir -pv ${cdroot}/etc
    cd ${prjdir} && zpool export freebsd && while zpool status freebsd >/dev/null; do :; done 2>/dev/null
}

image(){
    cd ${prjdir}
    sh ${mkidir}/mkiso.${platform}.sh -b ${label} ${isopath} ${cdroot}
    cd ${iso}
    echo "Build completed"
    ls
}

cleanup
setup
build
image
