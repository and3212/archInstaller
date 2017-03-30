#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Formats partitions and installs base arch system

# Formats the main partition and creates swap
mkfs.ext4 $ARCHFILE
mkswap $SWAP
swapon $SWAP
read -p "Press enter to continue...." ra
# Mounts the main partition and mounts the EFI to the proper place
mount $ARCHFILE /mnt

if [ $WINDOWS = 1 ]; then
	mkdir /mnt/boot/efi
	mount $EFI /mnt/boot/efi
fi

# Install the base system for Arch Linux
pacstrap /mnt base base-devel

# Create fstab files and checks to see if they were created
genfstab /mnt >> /mnt/etc/fstab

# Finishes up and reboots
arch-chroot /mnt /bin/bash
umount -R /mnt
read -p "Rebooting now, keep flash drive inserted, hit ENTER to continue...." -r
systemctl reboot