#! /bin/bash

# Install Grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub > /dev/null
echo "Installed Grub"
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null
echo "Generated Grub configuration"

# Set the timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime > /dev/null
echo "Set Timezone to America/New_York"

# Sync system clocks
hwclock --systohc > /dev/null
echo "System clock sync"

# Generate Locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen > /dev/null
locale-gen > /dev/null
echo "Generated locale"

# Set locale in /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf > /dev/null

# Set hostname in /etc/hostname
echo "arch" >> /etc/hostname > /dev/null
echo "Set Hostname"