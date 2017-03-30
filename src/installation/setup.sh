#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Sets up basic partitions, wifi settings, and user info

# Tells the user if they have any steps left to complete
checkDone() {
	if [ $1 = 1 ]; then
		echo "$2: Finished"
	else
		echo "$2: Not Finished"
	fi
}

# Dialog Menu
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Arch Installer - Liam Lawrence - 3.29.17"
TITLE="Arch Install Menu"
MENU="Choose one of the following options:"

# Setup Values
DISK=0
WIFI=0

# Dialog Values
DIALOG_OK=0
DIALOG_CANCEL=1

# Partitioning information
ARCHFILE=""
SWAP=""
EFI=""
WINDOWS=1

# Options for the setup menu
OPTIONS=(1 "Partition Disk"
	 2 "Wifi Setup"
         3 "Finish Initial Setup")

# Loops through the setup menu
while true; do
	CHOICE=$(dialog --clear \
		        --backtitle "$BACKTITLE" \
		        --title "$TITLE" \
		        --menu "$MENU" \
		        $HEIGHT $WIDTH $CHOICE_HEIGHT \
		        "${OPTIONS[@]}" \
		        2>&1 >/dev/tty)

	# Quits if we hit cancel
	if [ $? = $DIALOG_CANCEL ]; then
		clear
		break
	fi
	clear

	# Choices in the setup menu
	case $CHOICE in
		1)
			# Manually partition drive
			read -p "Are you dual booting from a previous windows install [y/N]: " -n 1 -r
			REPLY=${REPLY,,}
			if [ "$REPLY" != "y" ]; then
				WINDOWS=0;
			else
				WINDOWS=1;
			fi

			fdisk -l
			read -p 'Enter the main drive you computer uses: ' mainvar

			cfdisk $mainvar
			clear
			
			# Tell the program which partitions you are using
			while true; do
				clear
				echo 'Example partition: /dev/nvme0n1p5'
				read -p 'Enter your Root partition: ' ARCHFILE
				read -p 'Enter your Swap partition: ' SWAP

				if [ $WINDOWS = 1 ]; then
					read -p 'Enter your EFI partition: ' EFI
				fi

				clear
				echo "ROOT: $ARCHFILE"
				echo "SWAP: $SWAP"
				echo "EFI: $EFI"

				read -p 'Do these look correct? [y/N] ' -n 1 -r
				REPLY=${REPLY,,}
				if [ "$REPLY" = "y" ]; then
					DISK=1
					break
				fi
				clear
			done
		    ;;
		2)
			wifi-menu
			WIFI=1
			;;
		3)
			# Checks to make sure that everything is completed before continuing
			if [ $DISK = 1 ] && [ $WIFI = 1 ]; then
				break
			else
				echo "Your setup is not complete, make sure you finish ALL steps before continuing"
				echo "========================="
				checkDone $DISK "Disk Setup"
				checkDone $WIFI "Wifi Setup"
				echo "========================="
				read -p 'Press ENTER to continue....'
				clear
			fi
		    ;;
esac
done

echo "$ARCHFILE" > ../ARCHFILE.txt
