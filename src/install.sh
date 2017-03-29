#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Formats partitions and installs base arch system

# Formats the main partition and creates swap
mkfs.ext4 $ARCHFILE
mkswap $SWAP
swapon $SWAP

# Mounts the main partition and mounts the EFI to the proper place
mount $ARCHFILE /mnt
mkdir /mnt/boot/efi
mount $EFI /mnt/boot/efi

# Install the base system for Arch Linux
pacstrap /mnt base base-devel

# Create fstab files and checks to see if they were created
genfstab /mnt >> /mnt/etc/fstab
cat fstab

read -p "Does this file look correct? [Y/n] -n 1 -r
REPLY=${REPLY,,}
if [ $REPLY = "n" ]
	echo "ERROR IN FSTAB ENTRIES"
	exit
fi
