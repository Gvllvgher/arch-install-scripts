#! /bin/bash

# Setup hardware clock
timedatectl set-ntp true > /dev/null
echo "Enabled NTP"

# Disk Partitioning
sgdisk -Z /dev/sda > /dev/null
sgdisk -n 0:0:+500M -t 0:ef00 -c 0:"efi" /dev/sda > /dev/null
sgdisk -n 0:0:+3G -t 0:8200 -c 0:"swap" /dev/sda > /dev/null
sgdisk -n 0:0:0 -t 0:8300 -c 0:"linux" /dev/sda > /dev/null
sgdisk -p /dev/sda > /dev/null
partprobe /dev/sda > /dev/null
echo "Partitioned disks"

# Disk Formatting
mkfs.ext4 /dev/sda3 > /dev/null
mkswap /dev/sda2 > /dev/null
mkfs.fat -F 32 /dev/sda1 > /dev/null
echo "Formatted disks"

# Mount the disks
mount /dev/sda3 /mnt > /dev/null
mount --mkdir /dev/sda1 /mnt/boot > /dev/null
swapon /dev/sda2 > /dev/null
echo "Mounted disks"

# Install essential packages
echo "Installing packages, this will take some time"
pacstrap /mnt base linux linux-firmware dhcpcd git wget curl vim nano grub efibootmgr net-tools wpa_supplicant > /dev/null
echo "Installed essential packages"

# Set a root password
echo "root:arch" | arch-chroot /mnt chpasswd > /dev/null
echo "Set root password"

# Generate fstab with current mount points
genfstab -U /mnt >> /mnt/etc/fstab > /dev/null
echo "Generated fstab"

# Copy inside-chroot.sh to /mnt
cp minimal-inside-chroot.sh /mnt/ > /dev/null
chmod +X /mnt/minimal-inside-chroot.sh > /dev/null
chmod +777 /mnt/minimal-inside-chroot.sh > /dev/null
echo "Copied inside-chroot.sh to /mnt"

# Execute inside-chroot.sh
arch-chroot /mnt /minimal-inside-chroot.sh
echo "Finished inside-chroot.sh execution"

# This is a test for now
rm /mnt/minimal-inside-chroot.sh > /dev/null
echo "Removed inside-chroot.sh from /mnt"