setuprc(){
    chroot ${release} touch /etc/rc.conf
    chroot ${release} sysrc hostname="freebsd"
    chroot ${release} sysrc dbus_enable="YES"
    chroot ${release} sysrc zfs_enable="YES"
    chroot ${release} sysrc moused_enable="NO"
    chroot ${release} sysrc dumpdev="NO"
    chroot ${release} sysrc background_dhclient="YES"
    chroot ${release} sysrc rc_startmsgs="NO"
}
