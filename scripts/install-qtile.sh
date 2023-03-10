#! /bin/bash

# Parameters
while getopts ':u:w:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            echo "install-qtile.sh: LOCAL_USER set to: ${OPTARG}"
            ;;
        w)
            WORKING_DIR=${OPTARG}
            echo "install-qtile.sh: WORKING_DIR set to: ${OPTARG}"
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
    echo "install-qtile.sh: Use paramter -u to specify a username."
    exit 1
fi

# Install Dependencies
pacman -S \
  xorg-server \
  xorg-xinit \
  lightdm \
  lightdm-slick-greeter \
  xfce4-power-manager \
  xorg-mkfontscale \
  picom \
  nodejs \
  feh \
  papirus-icon-theme \
  arc-gtk-theme \
  alsa-utils \
  python-psutil \
  python-dbus-next \
  --noconfirm > /dev/null

# Install custom apps
$WORKING_DIR/scripts/install-apps.sh -u $LOCAL_USER -w $WORKING_DIR

# Install Fonts
$WORKING_DIR/scripts/install-fonts.sh -u $LOCAL_USER

# Install Qtile and lightdm
pacman -S qtile --noconfirm > /dev/null

# Enable the lightdm service for autostart
systemctl enable lightdm > /dev/null

# Configure lightdm to use lightdm-slick-greeter
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/#user-session=default/user-session=qtile/g" /etc/lightdm/lightdm.conf

# Configure lightdm-slick-greeter
cat <<EOT >> /etc/lightdm/slick-greeter.conf
[Greeter]
draw-user-backgrounds=false
draw-grid=true
theme-name=Arc-Dark
icon-theme=Oranchelo
show-a11y=false
background-color=#1e1e2e
EOT

su $LOCAL_USER<<EOF
set -e
yay -S oranchelo-icon-theme rofi-bluetooth-git --noconfirm > /dev/null
exit
EOF

# Enable the betterlockscreen service
systemctl enable betterlockscreen@$LOCAL_USER > /dev/null

# Run configure-displays.sh script
$WORKING_DIR/config/configure-displays.sh

# Copy default configuration
mkdir -p /home/$LOCAL_USER/.config/qtile
cp /usr/share/doc/qtile/default_config.py /home/$LOCAL_USER/.config/qtile/config.py
chown -R $LOCAL_USER:$LOCAL_USER /home/$LOCAL_USER/.config
