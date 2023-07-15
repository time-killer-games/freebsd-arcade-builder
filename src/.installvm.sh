#!/bin/sh
`zenity --question --text="Would you like to install this operating system to your virtual disk?"`;
if [ $? = 0 ]; then
  `zenity --info --text="Please be patient while the operating system is writing files to your virtual disk. Do not log out of this user session or shut down the virtual machine until you have been notified the process is complete."`;
  gpart create -s gpt ada0;
  if [ `sysctl -n machdep.bootmethod` = BIOS ]; then
    gpart add -t freebsd-boot -s 512K;
    dd if=/boot/gptboot of=/dev/ada0p1;
    export x=`diskinfo -v ada0 | awk 'FNR==3{print $1}'`;
    export y=`sysctl -n hw.physmem`;
    export z=`echo | awk BEGIN'{print 512*1024}'`
    export s=`echo | awk -v x=$x -v y=$y -v z=$z BEGIN'{print x-y-z}'`;
    gpart add -t freebsd-ufs -s $s ada0;
    newfs -U -L FreeBSD /dev/ada0p2;
    mount /dev/ada0p2 /mnt;
    cpdup -i0 -x / /mnt
    umount /mnt
  else 
    if [ `sysctl -n machdep.bootmethod` = UEFI ]; then
      gpart add -t efi -s 40M ada0;
      newfs_msdos -F 32 -c 1 /dev/ada0p1;
      mount -t msdosfs /dev/ada0p1 /mnt;
      mkdir -p /mnt/EFI/BOOT;
      cp /boot/loader.efi /mnt/EFI/BOOT/BOOTX64.efi;
      umount /mnt;
      export x=`diskinfo -v ada0 | awk 'FNR==3{print $1}'`;
      export y=`sysctl -n hw.physmem`;
      export z=`echo | awk BEGIN'{print 40*1024*1024}'`
      export s=`echo | awk -v x=$x -v y=$y -v z=$z BEGIN'{print x-y-z}'`;
      gpart add -t freebsd-ufs -s $s ada0;
      newfs -U -L FreeBSD /dev/ada0p2;
      mount /dev/ada0p2 /mnt;
      cpdup -i0 -x / /mnt
      umount /mnt
    fi;
  fi;
  `zenity --info --text="The installation process is now complete! Please shut down the virtual machine and remove the optical disk in order to begin using your virtual disk with persistent storage."`;
fi;
