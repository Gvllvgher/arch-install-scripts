#! /bin/bash
timedatectl set-ntp true
# Can install git on archiso using pacman -Sy git --noconfirm
#disk stuff
sgdisk -Z /dev/sda
sgdisk -n 0:0:+500M -t 0:ef00 -c 0:"efi" /dev/sda
sgdisk -n 0:0:+3G -t 0:8200 -c 0:"swap" /dev/sda
sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" /dev/sda
sgdisk -p /dev/sda
partprobe /dev/sda

mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1

mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

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