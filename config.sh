#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Configuration for Arch Linux

TIMEZONE=""

# Switch to the newly installed base system
arch-chroot /mnt /bin/bash

# Sets your language to en_US.UTF-8 UTF-8
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# Generate new locales
locale-gen

# Tells the computer what language to use and creates a file
echo "LANG=en_US.UTF-8" > /etc/locale.conf

clear
ls /usr/share/zoneinfo
echo "===================="
read -p "Pick a timezone to use"

# Sets root password
echo -e "$ROOTPASS\n$ROOTPASS" | passwd

# Sets up network
echo "#<ip-address>	<hostname.domain.org>	<hostname>" > /etc/hosts
echo "127.0.0.1		localhost.localdomain	localhost" >> /etc/hosts
echo "::1			localhost.localdomain	localhost" >> /etc/hosts
echo "127.0.1.1		$HOST.localdomain		$HOST" >> /etc/hosts
echo "$HOST" >> /etc/hostname
systemctl enable dhcpcd

# Sets up our Network Manager Applet
pacman -S --noconfirm network-manager-applet
systemctl enable NetworkManager.service

while true; do
	clear
	ip link

	read -p "Do you have an ethernet device [y/N]: " -n 1 -r
	REPLY={REPLY,,}
	if [ "$REPLY" != "n" ]; then
		read -p "Enter the name of your ethernet device: " ethvar
		read -p "Is this the name of your ethernet device - $ethvar - [y/N]: " -n 1 -r
		REPLY={REPLY,,}
		if [ "$REPLY" != "n" ]; then
			continue
		else
			systemctl disable $ethvar.service
		fi
	fi
	
	clear
	ip link

	read -p "Enter the name of your wifi device: " wifivar
	read -p "Is this the name of your wifi device - $wifivar - [y/N]: " -n 1 -r
	REPLY={REPLY,,}
	if [ "$REPLY" != "n" ]; then
		continue
	else
		systemctl disable netctl-auto@$wifivar.service
	fi
done

# Installs sound drivers
pacman -S --noconfirm alsa-utils

# Installs Yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf
pacman -Sy --noconfirm yaourt

# Installs GRUB
pacman -S --noconfirm grub os-prober
grub-install $ARCHFILE
grub-mkconfig -o /boot/grub/grub.cfg
