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

if [[ -z "$LOCAL_USER" ]]; then
    if ! [[ -z "$SUDO_USER" ]]; then
        LOCAL_USER=$SUDO_USER
    else
        echo "Use -u to specify a user"
        exit 1
    fi
fi

pacmanApps=( \
  "gnuradio
  gnuradio-companion
  python-setuptools" \
)

yayApps=( \
  "sdrpp-git" \
  "chirp-next" \
)

for pacApp in ${pacmanApps[@]}; do
    echo "Installing $pacApp"
    pacman -S $pacApp --noconfirm &> /dev/null
done

for yayApp in ${yayApps[@]}; do
    echo "Installing $yayApp"
    su $LOCAL_USER<<EOF
set -e
yay -S $yayApp --noconfirm &> /dev/null
exit
EOF
done
