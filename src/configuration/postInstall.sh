#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Post installation that configures the rest of the system

pacman -Syu --noconfirm

# Sets up mirrorlist
echo "[...]" >> /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Installs sound drivers
pacman -S --noconfirm alsa-utils

# Edits our mirrorlist

pacman --noconfirm -Syy

# Sets up the users account
useradd -m -g users -G wheel,storage,power -s /bin/bash $USER
echo -e "$USERPASS\n$USERPASS" | passwd $USER
pacman -S --noconfirm sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

# Installs xorg
pacman -S --noconfirm xorg xorg-server


# Options for the xorg menu
OPTIONS=(1 "Xfce"
         2 "Budgie"
	 3 "GNOME"
	 4 "Cinnamon"
	 5 "KDE"
	 6 "Mate"
	 7 "Deepin"
	 8 "Enlightenment"
	 9 "LXDE"
	 10 "lxqt")

TITLE="Xorg - Desktop Managers"
MENU="Choose a desktop manager to install:"


CHOICE=$(dialog --clear \
	        --backtitle "$BACKTITLE" \
	        --title "$TITLE" \
	        --menu "$MENU" \
	        $HEIGHT $WIDTH $CHOICE_HEIGHT \
	        "${OPTIONS[@]}" \
	        2>&1 >/dev/tty)

clear

# Lets you choose your favorite version of X
case $CHOICE in
	1)
		pacman -S --noconfirm xfce4 xfce4-goodies
		;;
	2)
		pacman -S --noconfirm budgie-desktop			
		;;
	3)
		pacman -S --noconfirm gnome gnome-extra
		;;
	4)
		pacman -S --noconfirm Cinnamon nemo-filerroller
		;;
	5)
		pacman -S --noconfirm plasma
		;;
	6)
		pacman -S --noconfirm mate mate-extra
		;;
	7)	
		pacman -S --noconfirm deepin deepin-extra
		;;
	8)
		pacman -S --noconfirm enlightenment
		;;
	9)
		pacman -S --noconfirm lxde
		;;
	10)
		pacman -S --noconfirm lxqt
		;;
esac

# Finishes install
pacman -S --noconfirm lxdm
systemctl enable lxdm
read -p "Finished installation, the system will now reboot, remove the USB stick" -r
rm ../ARCHFILE.txt
reboot
