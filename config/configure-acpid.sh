#!/bin/bash

# Install
pacman -S acpid --noconfirm &> /dev/null

# Enable
systemctl enable acpid &> /dev/null

# Start
systemctl start acpid &> /dev/null

sed -i "s#logger 'LID closed'#logger 'LID closed' \&\& DISPLAY=:0.0 su justin -c 'etc/acpi/dm-multimonitor.sh'#g" /etc/acpi/handler.sh

sed -i "s#logger 'LID opened'#logger 'LID opened' \&\& DISPLAY=:0.0 su justin -c 'etc/acpi/dm-multimonitor.sh'#g" /etc/acpi/handler.sh
