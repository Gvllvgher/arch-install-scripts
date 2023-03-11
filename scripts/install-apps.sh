#!/bin/bash

# We need to 'su' the local user, so we ask for that here
while getopts ':u:w:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            ;;
        w)
            WORKING_DIR=${OPTARG}
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
    echo "Use -u to define a user"
    exit 1
fi

# Define apps that need to be installed with pacman
pacmanApps=( \
    "npm
    flameshot
    firefox
    starship
    alacritty
    python-pip
    python-pillow
    htop
    nodejs
    thunar
    neofetch
    neovim
    kitty
    dmenu
    dunst
    rofi
    bluez
    bluez-utils
    vim
    wireguard-tools
    net-tools
    dnsutils
    inetutils
    man
    ufw
    xclip
    pulseaudio
    pulseaudio-bluetooth
    pavucontrol
    cups
    cups-pdf
    nss-mdns
    avahi
    openssh
    highlight
    ranger" \
)

# Define apps that need to be installed with yay
yayApps=( \
    "betterlockscreen" \
    "vtop" \
)

pipApps=( \
    "catppuccin" \
    "neovim" \
    "pylint"
)

# Define any scripts that install custom apps
appScripts=( \
    "$WORKING_DIR/apps/install-zsh.sh" \
)

# Install pacman apps
for pacApp in ${pacmanApps[@]}; do
    echo "Installing $pacApp"
    pacman -S $pacApp --noconfirm &> /dev/null
done

# Install yay
"$WORKING_DIR/apps/install-yay.sh" -u justin

# Install yay apps
for yayApp in ${yayApps[@]}; do
    echo "Installing $yayApp"
    su $LOCAL_USER<<EOF
set -e
yay -S $yayApp --noconfirm &> /dev/null
exit
EOF
done

# Install pip apps
for pipApp in ${pipApps[@]}; do
    echo "Installing $pipApp"
    su $LOCAL_USER<<EOF
set -e
pip install $pipApp &> /dev/null
exit
EOF
done

su $LOCAL_USER<<EOF
set -e
yay -S onlyoffice-bin --noconfirm &> /dev/null
exit
EOF

# Excute any custom app scripts
for script in ${appScripts[@]}; do
    chmod +x $script
    $script -u justin
done

##################### App Customizations ########################
# Section should only be used for very minor customizations
# Example: enabling/starting services

# Enable betterlockscreen
systemctl enable betterlockscreen@$LOCAL_USER > /dev/null

# Enable bluetooth and load the btusb module
modprobe btusb &> /dev/null
systemctl enable bluetooth > /dev/null

# UFW enable and enable
systemctl enable ufw &> /dev/null
ufw enable &> /dev/null

# Enable NTP
timedatectl set-ntp true

# Printing
# Enable CUPS
systemctl enable cups
# Modify /etc/nsswitch.conf to enable hostname resolution
sed -i 's/mymachines resolve/mymachines mdns_minimal [NOTFOUND=return] resolve/g' /etc/nsswitch.conf
# Enable Avahi Daemon
systemctl enable avahi-daemon.service
