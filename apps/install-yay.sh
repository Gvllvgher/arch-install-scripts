#! /bin/bash

# Parameters
while getopts ':u:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            echo "install-yay.sh: LOCAL_USER set to: ${OPTARG}"
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
    echo "install-yay.sh: Use paramter -u to specify a username."
    exit 1
fi

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Sy > /dev/null

git -C /opt clone https://aur.archlinux.org/yay-git.git > /dev/null
chown -R $LOCAL_USER:$LOCAL_USER /opt/yay-git > /dev/null

su $LOCAL_USER<<'EOF'
set -e
cd /opt/yay-git
makepkg -si --noconfirm > /dev/null
exit
EOF

echo "installed and updated yay"
