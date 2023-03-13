#! /bin/bash

# Parameters
while getopts ':u:' opt; do
    case $opt in
        u)
            LOCAL_USER=${OPTARG}
            echo "install-zsh.sh: LOCAL_USER set to: ${OPTARG}"
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
    echo "install-zsh.sh: Use paramter -u to specify a username."
    exit 1
fi

pacman -Sy zsh --noconfirm > /dev/null
chsh -s $(which zsh) $LOCAL_USER
chsh -s $(which zsh)

mkdir -p /home/$LOCAL_USER/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions /home/$LOCAL_USER/.zsh/zsh-autosuggestions
git clone https://github.com/catppuccin/zsh-syntax-highlighting /home/$LOCAL_USER/.zsh/catppuccin-zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/$LOCAL_USER/.zsh/zsh-syntax-highlighting
