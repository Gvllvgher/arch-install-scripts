#! /bin/bash

while getopts ':p:' opt; do
    case $opt in
        p)
            OS_PART=${OPTARG}
            echo "OS Partition set to: ${OPTARG}"
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

if [[ -z "$OS_PART" ]]; then
    echo "Use parameter -p to define an OS partition"
    exit 1
fi

# Install systemd-boot
bootctl install

# Configure the bootloader
cat <<EOT >> /boot/loader/loader.conf
default arch
timeout 1
EOT

# Create arch linux boot entry
cat <<EOT >> /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid $OS_PART -s PARTUUID -o value) rw
EOT

# Enable the update service for automatic updates
systemctl enable systemd-boot-update.service
