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

pacman -S \
  glfw-x11 \
  gnuradio \
  gnuradio-companion \
  python-setuptools \
  --noconfirm &> /dev/null

yayApps=( \
  "sdrpp-git" \
  "chirp-next" \
)

for yayApp in ${yayApps[@]}; do
    echo "Installing $yayApp"
    su $LOCAL_USER<<EOF
set -e
yay -S $yayApp --noconfirm &> /dev/null
exit
EOF
done