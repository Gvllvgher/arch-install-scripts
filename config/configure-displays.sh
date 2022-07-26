#!/bin/bash

cat << 'EOT' >> /etc/X11/xorg.conf.d/dm-multimonitor.sh
#!/bin/sh
# get the correct actual monitor names with
# xrandr | awk ' /connected/ { print $1, $2 }'
mon1=eDP-1
mon2=HDMI-1
# wait 3
if grep -q closed /proc/acpi/button/lid/LID/state; then
    xrandr --output "$mon1" --off --output "$mon2" --auto
elif xrandr | grep "$mon2 disconnected"; then
    xrandr --output "$mon2" --off --output "$mon1" --auto
else 
    xrandr --output "$mon1" --auto --output "$mon2" --right-of "$mon1" --auto
fi
EOT

chmod +x /etc/X11/xorg.conf.d/dm-multimonitor.sh

sed -i 's/#display-setup-script=/display-setup-script=\/etc\/X11\/xorg.conf.d\/dm-multimonitor.sh/g' /etc/lightdm/lightdm.conf
