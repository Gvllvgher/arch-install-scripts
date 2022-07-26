#!/bin/bash

pacman -Su open-vm-tools xf86-input-vmmouse xf86-video-vmware mesa gtk2 gtkmm gtkmm3 --noconfirm > /dev/null

echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config

systemctl enable vmtoolsd
systemctl enable vmware-vmblock-fuse.service
