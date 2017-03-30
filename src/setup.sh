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
MACHINE=0
WIFI=0

# Dialog Values
DIALOG_OK=0
DIALOG_CANCEL=1

# Machine information
USERPASS=""
ROOTPASS=""
HOST=""
USER=""

# Partitioning information
ARCHFILE=""
SWAP=""
EFI=""
WINDOWS=0

# Options for the setup menu
OPTIONS=(1 "Setup Profile"
         2 "Partition Disk"
	 3 "Wifi Setup"
         4 "Finish Initial Setup")

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
			# Sets up hostname, username, password and root password
		    
			# Defaults everything
			USERPASS=""
			ROOTPASS="toor"
			HOST="computer"
			USER="arch"

			# Begin user input
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
					read -p 'Would you like to set a different root password? [Y/n] ' -n 1 -r
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
			MACHINE=1
		    ;;
		2)
			# Manually partition drive
			read -p "Are you dual booting from a previous windows install [Y/n]: " windowsvar
			if [ "$windowsvar" != y ]; then
				WINDOWS=0;
			else
				WINDOWS=1;
			fi

			fdisk -l
			read -p "Enter your main file system: " mainvar
			cfdisk $mainvar
			clear
			
			# Tell the program which partitions you are using
			while true; do
				fdisk -l
				echo 'Example partition: /dev/nvme0n1p5'
				read -p 'Enter your Root partition: ' ARCHFILE
				read -p 'Enter your Swap partition: ' SWAP

				if [ $WINDOWS = 1 ]; then
					read -p 'Enter your EFI partition: ' EFI
				then
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
		3)
			wifi-menu
			WIFI=1
			;;
		4)
			# Checks to make sure that everything is completed before continuing
			if [ $MACHINE = 1 ] && [ $DISK = 1 ] && [ $WIFI = 1 ]; then
				break
			else
				echo "Your setup is not complete, make sure you finish ALL steps before continuing"
				echo "========================="
				checkDone $MACHINE "User Setup"
				checkDone $DISK "Disk Setup"
				checkDone $WIFI "Wifi Setup"
				echo "========================="
				read -p 'Press ENTER to continue....'
				clear
			fi
		    ;;
esac
done
