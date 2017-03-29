# archInstaller
A tool that will make installing Arch Linux simpler and easier

How to use:
- Go into src/ using `cd src`
- Run the command `chmod +x *`
- To begin the progess type `./archInstaller.sh`

**NOTE:** Once this is completed open up a terminal in your new system and type the command

`grub-mkconfig -o /boot/grub/grub.cfg`

This will allow your computer to load your other partitions into GRUB
