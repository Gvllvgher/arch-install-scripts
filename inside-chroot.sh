#! /bin/bash

# Parameters
while getopts ':u:w:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            echo "LOCAL_USER set to: ${OPTARG}"
            ;;
        w)
            WINDOW_MANAGER=${OPTARG}
            echo "WINDOW_MANAGER set to: ${OPTARG}"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

if [[ -z "$LOCAL_USER" ]]; then
    echo "Use parameter -u to specify the username."
    exit 1
fi

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
systemctl enable NetworkManager > /dev/null
echo "Enabled the NetworkManager service"

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

# Setup the user
useradd -m $LOCAL_USER > /dev/null
usermod -aG wheel $LOCAL_USER > /dev/null

# Allow pacman with no password
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Check if running as virtual machine, if so, install vmware-tools
dmidecode -s system-product-name | grep 'VMware' &> /dev/null
if [[ $? == 0  ]]; then
    echo "Detected as running as VMware VM, installing vmware-tools"
    /temp/arch-customization-scripts/install-vmtools.sh
fi

# Execute install-yay.sh
/temp/arch-customization-scripts/install-yay.sh -u $LOCAL_USER

# Execute install-zsh.sh
/temp/arch-customization-scripts/install-zsh.sh -u $LOCAL_USER

# Check if -w was defined, install window manager
if [[ "$WINDOW_MANAGER" == "qtile" ]]; then
    /temp/arch-customization-scripts/install-qtile.sh -u $LOCAL_USER
fi

# Remove nopasswd allow
head -n -1 /etc/sudoers > /etc/sudoers.bak
mv /etc/sudoers.bak /etc/sudoers
