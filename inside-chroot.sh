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

# Enable DHCP sevrice
systemctl enable dhcpcd > /dev/null
echo "Enabled the DHCP service"

# Generate Locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen > /dev/null
echo "Generated locale"

# Set locale in /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname in /etc/hostname
echo "arch" >> /etc/hostname
echo "Set Hostname"

# Sudo setup
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Setup the `justin` user
useradd -m justin > /dev/null
usermod -aG wheel justin > /dev/null

# Allow pacman with no password
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Execute install-yay.sh
/temp/arch-customization-scripts/install-yay.sh

# Execute install-awesome.sh
#/temp/arch-customization-scripts/install-awesome.sh

# Execute install-zsh.sh
/temp/arch-customization-scripts/install-zsh.sh

# Execute install-omz.sh
/temp/arch-customization-scripts/install-omz.sh

# Execute install-sddm.sh
/temp/arch-customization-scripts/install-sddm.sh

# Execute install-dwm.sh
#/temp/arch-customization-scripts/install-dwm.sh

# Excute install-chadwm.sh
#/temp/arch-customization-scripts/install-chadwm.sh

# Remove nopasswd allow
head -n -1 /etc/sudoers > /etc/sudoers.bak
mv /etc/sudoers.bak /etc/sudoers
