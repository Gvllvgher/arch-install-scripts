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

su $LOCAL_USER<<EOF
set -e
yay -S sdrpp-git --noconfirm > /dev/null
exit
EOF
