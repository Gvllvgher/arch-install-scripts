#! /bin/bash

#disk stuff
sgdisk -Z /dev/sdb
sgdisk -n 0:0:+500M -t 0:ef00 -c 0:"efi" /dev/sdb
sgdisk -n 0:0:+3G -t 0:8200 -c 0:"swap" /dev/sdb
sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" /dev/sdb
sgdisk -p /dev/sdb
partprobe /dev/sdb

#temp
exit

#install
pacstrap /mnt base linux linux-firmware git wget curl vim nano grub efibootmgr net-tools wpa_supplicant
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
touch /etc/hostname
echo "arch" >> /etc/hostname
