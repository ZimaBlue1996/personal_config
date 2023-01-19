#!/bin/bash
# 在Linux学习中需要频繁操作的地方的记录

cd ~
mkdir dev
cd -

# yoga14s PC need install 
# sudo apt install thunderbolt-tools

# essential software
sudo apt install -y emacs vim build-essential git wget gcc gdb g++ htop minicom vsftpd openssh-server

# openssh-server and config 
if [ ! -e  /etc/ssh/sshd_config.bak ] ; then
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    echo "backup file: /etc/ssh/sshd_config"
fi
sudo cp -f ./sshd_config     /etc/ssh/sshd_config
sudo /etc/init.d/ssh start
sudo systemctl enable ssh.service


# ftp service and set anonymous_enable=YES
if [ ! -e  /etc/init.d/vsftpd.conf.bak ] ; then
    sudo cp /etc/init.d/vsftpd.conf   /etc/init.d/vsftpd.conf.bakCROSS_COMPILE
    echo "backup file: /etc/init.d/vsftpd.conf"
fi
sudo cp -f ./vsftpd.conf   /etc/init.d/vsftpd.conf
sudo /etc/init.d/vsftpd restart
sudo systemctl enable vsftpd.service

# kernel build need
# sudo apt install -y gcc g++ cpp m4 cmake make nasm bison flex autoconf automake autotools-dev   
# sudo apt install -y crossbuild-essential-armhf     gcc-arm-linux-gnueabihf  cpp-arm-linux-gnueabihf    g++-arm-linux-gnueabihf   #armhf toolchain
# sudo apt install -y crossbuild-essential-armel     gcc-arm-linux-gnueabi    cpp-arm-linux-gnueabi      g++-arm-linux-gnueabi     #armel toolchain
# sudo apt install -y crossbuild-essential-arm64     gcc-aarch64-linux-gnu    cpp-aarch64-linux-gnu      g++-aarch64-linux-gnu     #arm64 toolchain
# sudo apt install -y libmpc-dev libncurses5-dev libelf-dev libgmp3-dev u-boot-tools libssl-dev

## tftp server config
sudo apt-get install -y tftp-hpa tftpd-hpa xinetd uml-utilities bridge-utils pxelinux user-mode-linux
sudo cat << EOF > /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/$USER/dev/tftp" #该路径即为tftp可以访问到的路径
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="-l -c -s"
EOF



# edit linux kernel Makefile 
# ARCH		?= arm
# CROSS_COMPILE = arm-none-eabi-

#@ complile kernel
# make vexpress_defconfig
# make menuconfig     #checkout error
# make zImage  -j 2
# make modules -j 2
# make dtbs    -j 2
# make LOADADDR=0x60003000 uImage  -j 2

# mkdir -p ~/qemu_boot
# cp arch/arm/boot/zImage ~/qemu_boot
# cp arch/arm/boot/uImage ~/qemu_boot
# cp arch/arm/boot/dts/vexpress-v2p-ca9.dtb ~/qemu_boot
# cd ~/qemu_boot
# touch start.sh
# chmod 777 start.sh
# cat << EOF > start.sh
# qemu-system-arm \
#     -M vexpress-a9 \
#     -m 512M \
#     -kernel zImage \
#     -dtb vexpress-v2p-ca9.dtb \
#     -nographic \
#     -append "console=ttyAMA0"
# EOF

## build rootfs
# wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
# tar -xvf busybox-1.35.0.tar.bz2
# cd busybox-1.35.0
# sudo mkdir -p  /home/nfs
# sudo chmod 777 /home/nfs

## edit busybox Makefile 
# ARCH		?= arm
# CROSS_COMPILE = arm-linux-gnueabi-
# make menuconfig
## settings -> vi-style ....
## settings -> Destination patj ....
## set rootfs path   /home/nfs
# make install -j 2

## install link lib
# cd ~/dev/nfs
# mkdir lib
# cd /usr/arm-linux-gnueabi/lib
# cp *.so* ~/dev/nfs/lib -d

## create device node
# cd ~/dev/nfs
# mkdir dev
# cd dev
# sudo mknod -m 666 tty1 c 4 1
# sudo mknod -m 666 tty2 c 4 2
# sudo mknod -m 666 tty3 c 4 3
# sudo mknod -m 666 tty4 c 4 4
# sudo mknod -m 666 console c 5 1
# sudo mknod -m 666 null c 1 3

## init proc
# cd ~/dev/nfs
# mkdir -p etc/init.d
# cd etc/init.d
# touch rcS
# chmod 777 rcS
# cat << EOF > rcS
# #!/bin/sh
# PATH=/bin:/sbin:/usr/bin:/usr/sbin 
# export LD_LIBRARY_PATH=/lib:/usr/lib
# /bin/mount -n -t ramfs ramfs /var
# /bin/mount -n -t ramfs ramfs /tmp
# /bin/mount -n -t sysfs none /sys
# /bin/mount -n -t ramfs none /dev
# /bin/mkdir /var/tmp
# /bin/mkdir /var/modules
# /bin/mkdir /var/run
# /bin/mkdir /var/log
# /bin/mkdir -p /dev/pts
# /bin/mkdir -p /dev/shm
# /sbin/mdev -s
# /bin/mount -a
# echo "-----------------------------------"
# echo "*****welcome to vexpress board*****"
# echo "-----------------------------------"
# EOF

## set filesystem /etc/fstab
# cd ~/dev/nfs/etc
# touch fstab
# cat << EOF > fstab
#     proc    /proc           proc    defaults        0       0
#     none    /dev/pts        devpts  mode=0622       0       0
#     mdev    /dev            ramfs   defaults        0       0
#     sysfs   /sys            sysfs   defaults        0       0
#     tmpfs   /dev/shm        tmpfs   defaults        0       0
#     tmpfs   /dev            tmpfs   defaults        0       0
#     tmpfs   /mnt            tmpfs   defaults        0       0
#     var     /dev            tmpfs   defaults        0       0
#     ramfs   /dev            ramfs   defaults        0       0
# EOF

## set init script /etc/inittab
# cd ~/dev/nfs/etc
# touch inittab
# cat << EOF > inittab
# ::sysinit:/etc/init.d/rcS
# ::askfirst:-/bin/sh
# ::ctrlaltdel:/bin/umount -a -r
# EOF

## edit /etc/profile
# cd ~/dev/nfs/etc
# touch profile
# cat << EOF > profile
# USER="root"
# LOGNAME=$USER
# export HOSTNAME=`cat /etc/sysconfig/HOSTNAME`
# export USER=root
# export HOME=/root
# export PS1="[$USER@$HOSTNAME \W]\# "
# PATH=/bin:/sbin:/usr/bin:/usr/sbin
# LD_LIBRARY_PATH=/lib:/usr/lib:$LD_LIBRARY_PATH
# export PATH LD_LIBRARY_PATH
# EOF

## add host name
# cd ~/dev/nfs/etc
# mkdir sysconfig
# cd    sysconfig
# touch HOSTNAME
# echo vexpress > HOSTNAME

## create others fold
# cd ~/dev/nfs
# mkdir mnt proc root sys tmp var

## build rootfs and mount
# cd /tmp
# sudo mkdir temp
# sudo dd if=/dev/zero of=rootfs.ext3 bs=1M count=32
# sudo mkfs.ext3 rootfs.ext3
# sudo mount -t ext3 rootfs.ext3 temp/ -o loop
# sudo cp -r ~/dev/nfs/* temp/
# sudo umount temp
# sudo mv rootfs.ext3  ~/dev/qemu_vexpress/

## console start
# cd ~/dev/qemu_vexpress/
# cat << EOF > start_footfs.sh
# qemu-system-arm \
#    -M vexpress-a9 \
#    -m 512M \
#    -kernel zImage \
#    -dtb vexpress-v2p-ca9.dtb \
#    -nographic \
#    -append "root=/dev/mmcblk0 rw console=ttyAMA0" \
#    -sd rootfs.ext3
# EOF

## LCD start
# cd ~/dev/qemu_vexpress/
# cat << EOF > start_footfs.sh
# qemu-system-arm \
#     -M vexpress-a9 \
#     -m 512M \
#     -kernel zImage \
#     -dtb vexpress-v2p-ca9.dtb \
#     -append "root=/dev/mmcblk0 rw console=tty0" \
#     -sd rootfs.ext3
# EOF


## uboot: download and set ARCH and CROSS_COMPILE
# ARCH		?= arm
# CROSS_COMPILE ?= arm-linux-gnueabi-
# cd ~/dev/archive/u-boot-2022.10
# make vexpress_ca9x4_defconfig
# make -j2
# cd ~/dev/archive/u-boot-2022.10
# touch start_uboot.sh
# chmod 777 start_uboot.sh
# cat << EOF > start_uboot.sh
# qemu-system-arm    -M vexpress-a9 \
#     -kernel u-boot   \
#     -nographic       \
#     -m 512M          
# EOF

## tftp set
# cd ~/dev/
# mkdir tftp
# sudo chmod 777 tftp
# cp ./u-boot-2022.10/u-boot  ./tftp
# cp ./linux-5.15.86/uImage   ./tftp
# sudo /etc/init.d/tftpd-hpa restart

## build net bridge for qemu by tradition style
# sudo apt install net-tools bridge-utils uml-utilities
## build net bridge for qemu by moder style
# sudo apt install netplan.io


sudo apt install -y nfs-kernel-server
# append below text to /etc/exports
cat << EOF >> /etc/exports 
/home/$USER/dev/nfs *(rw,sync,no_root_squash,no_subtree_check)
EOF
sudo /etc/init.d/rpcbind restart
sudo /etc/init.d/nfs-kernel-server restart

## 1. rebuildding kernel for nfs 4
# cd linux kernel dir
# make menuconfig -> network ... -> nfs seting 
## 2. Or set host linux nfs setting
## append below text to  /etc/default/nfs-kernel-server
# cat << EOF >> /etc/default/nfs-kernel-server
# RPCSVCGSSDOPTS="--nfs-version 2,3,4 --debug --syslog"
# EOF

# tftp 0x60003000 uImage;tftp 0x60800000 vexpress-v2p-ca9.dtb;setenv bootargs 'root=/dev/nfs rw nfsroot=192.168.1.138:/home/nfs,proto=tcp,nfsvers=3,nolock init=/linuxrc ip=192.168.1.137 console=ttyAMA0';bootm 0x60003000 - 0x60800000;
