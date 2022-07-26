#!/bin/bash

while getopts ':u:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            ;;
        \?)
            echo "Invalid Option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

pacmanFonts=( \
    "noto-fonts
    noto-fonts-emoji
    ttf-linux-libertine
    ttf-dejavu
    ttf-liberation
    ttf-bitstream-vera
    cantarell-fonts
    opendesktop-fonts
    ttf-opensans
    ttf-croscore
    ttf-carlito
    ttf-caladea
    ttf-jetbrains-mono" \
)

yayFonts=( \
    "nerd-fonts-jetbrains-mono" \
)

if [[ -z "$LOCAL_USER" ]]; then
    if ! [[ -z "$SUDO_USER" ]]; then
        LOCAL_USER=$SUDO_USER
    else
        echo "Use -u to specify a user"
        exit 1
    fi
fi

pacman -S $pacmanFonts --noconfirm > /dev/null

su $LOCAL_USER<<EOF
set -e
yay -S ${yayFonts} --noconfirm > /dev/null
exit
EOF
