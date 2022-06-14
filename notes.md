# Arch Install Script Notes

Steps from the install guide.
https://wiki.archlinux.org/title/installation_guide#Boot_the_live_environment

 > Can connect to Wifi using iw 

## Clock setup
```bash
timedatectl set-ntp true
```

## Partition disks

To list the disks
```
fdisk -l
```
To edit the disk to install to
```
fdisk /dev/[disk]
```
Partitions to create
1. EFI System (boot) - All space
2. swap - 1/2 memory
3. Linux x86-64 root - Remainder

## Format the disks
Root partition as EXT4
```
mkfs.ext4 /dev/root_partition
```
mkswap on Swap partition
```
mkswap /dev/swap_partition
```
Fat for the EFI/boot partition
```
mkfs.fat -F 32 /dev/efi_system_partition
```
## Mount the disks
Mount root partition to /mnt
```
mount /dev/root_partition /mnt
```
Mount boot partition to /mnt/boot
```
mount --mkdir /dev/efi_system_partition /mnt/boot
```
Make swap on swap
```
swapon /dev/swap_partition
```
## Install
Install essentials
 - more on WPA Supplicant https://wiki.archlinux.org/title/Wpa_supplicant#Installation
 - more on grub https://wiki.archlinux.org/title/GRUB#Installation
```
pacstrap /mnt base linux linux-firmware git wget curl vim nano grub efibootmgr net-tools wpa_supplicant
```
Export mounts to `fstab` - just in case something happens. *system will still not boot at this point*
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Archroot into the install
```
arch-chroot /mnt
```
Install grub to boot
```
grub-install --target=x86_64-efi --efi-directory=[Efi system partition mount point] --bootloader-id=grub
```
genfstab again
```
genfstab -U / >> /etc/fstab
```
 > at this point, the system should boot

## Configuration
Timezone
```
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
```
Run `hwclock` to generate `/etc/adjtime`
```
hwclock --systohc
```

Localization
```
locale-gen
```
Create `locale.conf`
```
touch /etc/locale.conf
```
Edit `locale.conf`
```
vim /etc/locale.conf
```
Set the following:
```
LANG=en_US.UTF-8
```

Change hostname
```
touch /etc/hostname
vim /etc/hostname
```

Set root password
```
passwd
```

Reboot!