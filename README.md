# Arch Installation Scripts
These installation scripts do many things, and I intend to add more functionality to them.
They're meant to be run on the archiso, and they basically install arch for me. Explanations on each of the scripts below.

## `install.sh`
This is the "executor" script that fires everything else. It requires the following parameters:
  - `-d (INSTALL_DISK)` is the disk that arch is to be installed to. Usually something like /dev/sda or /dev/nvme0p1. Can determine disk with `fdisk -l` command.
  - `-u (LOCAL_USER)` is the user account to be created. It should not contain any spaces or special characters.
  - `-w (WINDOW_MANAGER)` is the desired window manager to be installed. As of now, `qtile` is the only option.

The script contains some default variables that can be changed with caution:
  - `SWAP_GB` defaults to 4G. The size of the swap partition.
  - `TEMP_DIR` defaults to /mnt/tmp. Temp directory for _outside_ chroot.
  - `INSIDE_TEMP_DIR` defaults to /temp. Temp directory for _inside_ chroot.
  - `GIT_BASE_URL` defaults to "https://github.com/Gvllvgher". This is the base url for the install repository. The repo will be cloned inisde chroot.
  - `REPO` defaults to "arch-install-scripts". The name of the repository.


