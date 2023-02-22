#! /bin/bash

OS_PART="/dev/sda3"

#bootctl install

cat <<EOT >> /boot/loader/loader.conf
default arch
timeout 3
EOT

cat <<EOT >> /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid $OS_PART -s PARTUUID -o value)
EOT
