#! /bin/bash

# Setup hardware clock
timedatectl set-ntp true

# Disk Partitioning
sgdisk -Z /dev/sda
sgdisk -n 0:0:+500M -t 0:ef00 -c 0:"efi" /dev/sda
sgdisk -n 0:0:+3G -t 0:8200 -c 0:"swap" /dev/sda
sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" /dev/sda
sgdisk -p /dev/sda
partprobe /dev/sda

# Disk Formatting
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1

# Mount the disks
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

# Install essential packages
pacstrap /mnt base linux linux-firmware git wget curl vim nano grub efibootmgr net-tools wpa_supplicant

# Generate fstab with current mount points
genfstab -U /mnt >> /mnt/etc/fstab

# Copy inside-chroot.sh to /mnt/
cp inside-chroot.sh /mnt/
chmod +X /mnt/inside-chroot.sh
chmod +777 /mnt/inside-chroot.sh

# Execute inside-chroot.sh
arch-chroot /mnt /inside-chroot.sh

# This is a test for now
rm /mnt/inside-chroot.sh