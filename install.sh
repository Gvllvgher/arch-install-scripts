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
pacstrap /mnt base linux linux-firmware dhcpcd git wget curl vim nano grub efibootmgr net-tools wpa_supplicant sudo base-devel > /dev/null
echo "Installed essential packages"

# Set a root password
echo "root:arch" | arch-chroot /mnt chpasswd > /dev/null
echo "Set root password"

# Generate fstab with current mount points
genfstab -U /mnt >> /mnt/etc/fstab
echo "Generated fstab"

# Make temp dir for this stuff
mkdir /mnt/temp > /dev/null

# Copy inside-chroot.sh to /mnt
cp inside-chroot.sh /mnt/temp/ > /dev/null
echo "Copied inside-chroot.sh to /mnt"

# Clone arch-customization-scripts to /temp
git -C /mnt/temp clone https://github.com/Gvllvgher/arch-customization-scripts > /dev/null

# Change all .sh file permissoins
chmod +x /mnt/temp/*.sh > /dev/null
chmod +777 /mnt/temp/*.sh > /dev/null
chmod +x /mnt/temp/**/*.sh > /dev/null
chmod +777 /mnt/temp/**/*.sh > /dev/null

# Execute inside-chroot.sh
arch-chroot /mnt /temp/inside-chroot.sh
echo "Finished inside-chroot.sh execution"

# This is a test for now
rm -rf /mnt/temp > /dev/null
echo "Removed /mnt/temp"

# Set `justin` user password to `arch`
echo "justin:arch" | arch-chroot /mnt chpasswd > /dev/null
echo "Set the justin account password"