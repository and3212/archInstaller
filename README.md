# archInstaller
A tool that will make installing Arch Linux simpler and easier

File System

- main_install.sh

  - setup.sh
 
  - install.sh
 
 - main_config.sh

   - config.sh
  
   - postInstall.sh
  
How to use:
- Go into src/ using `cd src`
- Run the command `chmod +x */*`
- To begin the progess type `./main_installer.sh`
- After the reboot, run `./main_config.sh`
- Reboot again and then run `grub-mkconfig -o /boot/grub/grub.cfg` to let GRUB see windows

**NOTE:** I take no responsibility to damaging your system, use at your own risk
