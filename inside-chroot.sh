#! /bin/bash

# Install Grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

# Set the timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Sync system clocks
hwclock --systohc

# Generate Locale
locale-gen

# Set locale in /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname in /etc/hostname
echo "arch" >> /etc/hostname