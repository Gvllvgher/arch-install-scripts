# Arch Installation Scripts
These installation scripts do many things, and I intend to add more functionality to them.
They're meant to be run on the archiso, and they basically install arch for me. Explanations on each of the scripts below.

## Getting Started
1. Clone the repo
   ```
   git clone https://github.com/Gvllvgher/arch-install-scripts
   ```

2. `cd` into the cloned repo
   ```
   cd arch-install-scripts/
   ```

4. Execute script
   ```
   ./install.sh
   ```

## install.sh
This script does the following:
    - Disk
        - Partition
        - Format
        - Mount
    - Run `pacman -Sy archlinux-keyring` to update the keyring
    - Installs Applications
        - paman `
