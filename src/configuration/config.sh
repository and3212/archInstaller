#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Configuration for Arch Linux

# Install location for GRUB
ARCHFILE=$( cat ../ARCHFILE.txt )

# Dialog Menu
TITLE="United States Time Zones"
MENU="Choose your time zone:"
HEIGHT=25
WIDTH=40
CHOICE_HEIGHT=20
BACKTITLE="Arch Installer - Liam Lawrence - 3.29.17"
ZONE=""

# Defaults everything
USERPASS=""
ROOTPASS="toor"
HOST="computer"
USER="arch"

# Turns on wifi so we can work with it for the rest of the configuration process
wifi-menu

# Sets up hostname, username, password and root password
read -p 'Username: ' uservar
read -p 'Hostname: ' hostvar
while [ "$USERPASS" = "" ]; do
	read -sp 'Password: ' pass1var
	echo
	read -sp 'Retype Password: ' pass2var
	echo 
	if [ "$pass1var" = "$pass2var" ]; then
		USER="$uservar"
		HOST="$hostvar"
		USERPASS="$pass1var"
		ROOTPASS="$pass1var"
		echo '---------------------------------------'
		echo 'Hostname, username and password are set'
		read -sp 'Would you like to set a different root password? [Y/n] ' -n 1 -r
		REPLY=${REPLY,,} #toLower
		if [ "$REPLY" != "n" ]; then
			echo
			while [ "$ROOTPASS" = "$USERPASS" ]; do
				read -sp 'Root Password: ' pass1var
				echo
				read -sp 'Retype Root Password: ' pass2var
				echo
				if [ "$pass1var" = "$pass2var" ]; then
					ROOTPASS="$pass1var"
				else
					echo "Sorry, passwords do not match"
					continue
				fi
			done
		fi
	else
		echo "Sorry, passwords do not match."
		continue
	fi
done

# Sets your language to en_US.UTF-8 UTF-8
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# Generate new locales
locale-gen

# Tells the computer what language to use and creates a file
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Options for the time zone menu
OPTIONS=(1 "Alaska"
	 2 "Arizona"
	 3 "Eastern"
	 4 "Hawaii"
	 5 "Michigan"
	 6 "Pacific"
	 7 "Samoa"
	 8 "Aleutian"
	 9 "Central"
	 10 "East-Indiana"
	 11 "Indiana-Starke"
	 12 "Mountain"
	 13 "Pacific-New")

CHOICE=$(dialog --clear \
	        --backtitle "$BACKTITLE" \
	        --title "$TITLE" \
	        --menu "$MENU" \
	        $HEIGHT $WIDTH $CHOICE_HEIGHT \
	        "${OPTIONS[@]}" \
	        2>&1 >/dev/tty)

clear

# Lets you choose your favorite time zone
case $CHOICE in
		1)
			$ZONE="Alaska"
			;;
		2)
			$ZONE="Arizona"
			;;
		3)
			$ZONE="Eastern"
			;;
		4)
			$ZONE="Hawaii"
			;;
		5)
			$ZONE="Michigan"
			;;
		6)
			$ZONE="Pacific"
			;;
		7)
			$ZONE="Samoa"
			;;
		8)
			$ZONE="Aleutian"
			;;
		9)
			$ZONE="Central"
			;;
		10)
			$ZONE="East-Indiana"
			;;
		11)
			$ZONE="Indiana-Starke"
			;;
		12)
			$ZONE="Mountain"
			;;
		13)
			$ZONE="Pacific-New"
			;;
esac
ln -s /usr/share/zoneinfo/US/$ZONE /etc/localtime
hwlock --systohc --utc

# Sets root password
echo -e "$ROOTPASS\n$ROOTPASS" | passwd

# Sets up network
echo "#<ip-address>	<hostname.domain.org>	<hostname>" > /etc/hosts
echo "127.0.0.1		localhost.localdomain	localhost" >> /etc/hosts
echo "::1		localhost.localdomain	localhost" >> /etc/hosts
echo "127.0.1.1		$HOST.localdomain	$HOST" >> /etc/hosts
echo "$HOST" > /etc/hostname
systemctl enable dhcpcd

# Sets up our Network Manager Applet
pacman -S --noconfirm network-manager-applet
systemctl enable NetworkManager.service

clear
ip link

read -p "Do you have an ethernet device [y/N]: " -n 1 -r
REPLY=${REPLY,,}
if [ "$REPLY" != "n" ]; then
	read -p "Enter the name of your ethernet device: " ethvar
	systemctl disable $ethvar.service
fi
echo

read -p "Enter the name of your wifi device: " wifivar
systemctl disable netctl-auto@$wifivar.service

# Installs Yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
pacman -Sy --noconfirm yaourt

# Installs GRUB
pacman -S --noconfirm grub os-prober
grub-install $ARCHFILE
grub-mkconfig -o /boot/grub/grub.cfg
