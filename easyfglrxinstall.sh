#!/bin/sh

######################################################################################
#                                                                                    #
#  easyfglrxinstall.sh - Install the fglrx driver on Debian-based operating systems  #
#  Copyright (C) 2013-2019 Christian Heinrichs <christian.heinrichs@mykolab.ch>      #
#                                                                                    #
#  This program is free software: you can redistribute it and/or modify              #
#  it under the terms of the GNU General Public License as published by              #
#  the Free Software Foundation, either version 3 of the License, or                 #
#  (at your option) any later version.                                               #
#                                                                                    #
#  This program is distributed in the hope that it will be useful,                   #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of                    #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                     #
#  GNU General Public License for more details.                                      #
#                                                                                    #
#  You should have received a copy of the GNU General Public License                 #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.             #
#                                                                                    #
######################################################################################

####################################
#                                  #
#  Easy fglrx installation script  #
#                                  #
####################################

# easyfglrxinstall.sh written by Christian Heinrichs - Last modified 12/05/2021

# Accepted distro versions should be irrelevant, also this script should work on
# Debian as well as Ubuntu systems regardless of the distro version

agmethod() {
    printf "[F]ast or [v]erbose mode? "
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            printf "agmethod() running in fast mode\n\n"

            # Uninstall all .deb packages and .run leftovers
            printf "Removing all leftover fglrx installation files\n\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get purge -y fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get purge -y fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Not sure about this one anymore, could be fglrx-driver now
            printf "Installing via apt-get\n\n"
            sudo apt-get install -y fglrx fglrx-amdcccle fglrx-driver

            # Set up initial driver config
            printf "Setting up initial fglrx configuration\n\n"
            sudo amdconfig --initial

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu
               return;;
            esac
    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            printf "agmethod() running in verbose mode\n\n"
            printf "Remove all installed fglrx files? "
            read delchoice

            case $delchoice in
            [yY]) # Uninstall all .deb packages and .run leftovers
                  printf "Removing all leftover fglrx installation files\n\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) printf "You chose no. Please make sure that the fglrx driver was removed already. Continuing...\n";;
            *) printf "Wrong input! Returning\n"
               agmethod
               return;;
            esac

            printf "Do you want to install the fglrx driver with apt-get? "
            read instchoice

            case $instchoice in
            [yY]) printf "Installing via apt-get\n\n"
                  sudo apt-get install fglrx fglrx-amdcccle fglrx-driver;;
            [nN]) printf "Returning to main menu.\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning.\n"
               agmethod
               return;;
            esac

            printf "Create initial fglrx configuration? "
            read cfgchoice

            case $cfgchoice in
            # Setup initial driver config
            [yY]) printf "Setting up initial fglrx configuration\n\n"
                  sudo amdconfig --initial;;
            [nN]) printf "You chose no. Make sure to set the configuration before rebooting! Continuing...\n";;
            *) printf "Wrong input! Returning.\n"
               agmethod
               return;;
            esac

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu;;
            esac
    else
        printf "Please enter either f or v.\n"
    fi
}

debmethod() {
    printf "[F]ast or [v]erbose mode? "
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            printf "debmethod() running in fast mode\n\n"

            # Uninstall all .deb packages and .run leftovers
            printf "Removing all leftover fglrx installation files\n\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get purge -y fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get purge -y fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Getting required dependencies for build
            printf "Downloading and installing build packages\n\n"
            sudo apt-get install -y build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4

            printf "Do you have a 32-bit or a 64-bit system? (32/64) "
            read archchoice

            case $archchoice in
            32) printf "System is not a 64-bit architecture. Skipping installation of lib32gcc1\n\n";;
            64) printf "Installing required 64-bit package\n\n"
                sudo apt-get install -y lib32gcc1;;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "Extracting .zip archive\n\n"
            unzip amd*.zip

            printf "Building package\n\n"
            sudo sh amd*.run --buildpkg

            # Install Debian package
            printf "Installing Debian package\n\n"
            sudo dpkg -i fglrx*.deb

            # Setup initial driver config
            printf "Setting up initial fglrx configuration\n\n"
            sudo amdconfig --initial

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu
               return;;
            esac
    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            printf "debmethod() running in verbose mode\n\n"

            # Uninstall all .deb packages and .run leftovers
            printf "Uninstall all leftover fglrx files? "
            read uninstchoice

            case $uninstchoice in
            [yY]) printf "Removing all leftover fglrx installation files\n\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) printf "Past fglrx installations must be removed. Returning to debmethod()\n"
                  debmethod
                  return;;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            # Getting required dependencies for build
            printf "Download and install build packages? "
            read builddecision

            case $builddecision in
            [yY]) printf "Downloading and installing build packages\n\n"
                  sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4;;
            [nN]) printf "Make sure you have all the build packages installed.\n";;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "Do you have a 32-bit or a 64-bit system? (32/64) "
            read archchoice

            case $archchoice in
            32) printf "System is not a 64-bit architecture. Skipping installation of lib32gcc1\n\n";;
            64) printf "Installing required 64-bit package\n\n"
                sudo apt-get install lib32gcc1;;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "Extract fglrx .zip archive? "
            read extchoice

            case $extchoice in
            [yY]) printf "Extracting fglrx .zip archive\n\n"
                  unzip -v amd*.zip;;
            [nN]) printf "You chose no. Make sure that the extracted files are in this folder. Continuing...\n";;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "WARNING: Is the .run file in the same folder as this script? (Y/N) "
            read runfilechoice

            case $runfilechoice in
            [yY]) printf "Continuing...\n";;
            [nN]) printf "The .run file must be in the same folder as this script.\n"
                  debmethod
                  return;;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "Do you want to build the package for your distro version? "
            read buildchoice

            case $buildchoice in
            [yY]) printf "Building package\n\n"
                  sudo sh amd*.run --buildpkg;;
            [nN]) printf "You chose no. Returning to main menu.\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning.\n"
               debmethod
               return;;
            esac

            printf "The Debian package should have been built for your distribution. Install it? (Y/N) "
            read instchoice

            # Install Debian package
            case $instchoice in
            [yY]) printf "Installing package\n\n"
                  sudo dpkg -i fglrx*.deb;;
            [nN]) printf "You chose no. Returning to main menu.\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning\n"
               debmethod
               return;;
            esac

            printf "Create initial fglrx configuration? "
            read cfgchoice

            # Setup initial driver config
            case $cfgchoice in
            [yY]) printf "Setting up initial fglrx configuration\n\n"
                  sudo amdconfig --initial;;
            [nN]) printf "You chose no. Make sure to set the configuration before rebooting! Continuing...\n";;
            *) printf "Wrong input. Returning.\n"
               debmethod
               return;;
            esac

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu
               return;;
            esac
    else
        printf "Please enter either f or v\n"
    fi
}

runmethod() {
    printf "[F]ast or [v]erbose mode? "
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            printf "runmethod() running in fast mode\n\n"
            printf "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) "
            read samefolder

            # Create xorg.conf backup
            case $samefolder in
            [yY]) printf "Creating xorg.conf backup\n\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf~

                  printf "Removing all leftover fglrx installation files\n\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get purge -y fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get purge -y fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                  printf "Extracting .zip archive\n\n"
                  unzip amd*.zip

                  printf "Granting executable permission rights to fglrx .run file\n\n"
                  sudo chmod +x amd*.run

                  printf "Executing fglrx .run file\n\n"
                  sudo ./amd*.run

                  printf "Setting up initial fglrx configuration\n\n"
                  sudo amdconfig --initial;;

            [nN]) printf "It has to be in this folder. Returning.\n"
                  runmethod
                  return;;
            *) printf "Wrong input! Returning.\n"
               runmethod
               return;;
            esac

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu
               return;;
            esac

    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            printf "runmethod() running in verbose mode\n\n"
            printf "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) "
            read samefolder

            case $samefolder in
            [yY]) printf "Creating xorg.conf backup\n\n"
                  sudo cp -v /etc/X11/xorg.conf /etc/X11/xorg.conf~;;
            [nN]) printf "The .run file has to be in this folder. Returning.\n"
                  runmethod
                  return;;
            *) printf "Wrong input! Returning.\n"
               runmethod
               return;;
            esac

            printf "Do you want to uninstall leftover fglrx files from past installations? "
            read uninstchoice

            case $uninstchoice in
            [yY]) printf "Removing all leftover fglrx installation files\n\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) printf "Past installations must be removed. Returning to runmethod()\n"
                  runmethod
                  return;;
            *) printf "Wrong input! Returning\n"
               runmethod
               return;;
            esac

            printf "Extract .zip archive? "
            read unzipfiles

            case $unzipfiles in
            [yY]) printf "Extracting fglrx .zip archive\n\n"
                  unzip -v amd*.zip;;
            [nN]) print "You chose no. Make sure that the extracted files are in this folder. Continuing...\n";;
            *) printf "Wrong input! Returning\n"
               runmethod
               return;;
            esac

            printf "Grant executable file permission rights to the .run file? "
            read chmodchoice

            case $chmodchoice in
            [yY]) printf "Granting executable file permission rights to fglrx .run file\n\n"
                  sudo chmod +x -v amd*.run;;
            [nN]) printf "You chose no. The .run file must be executable. Continuing...\n";;
            *) printf "Wrong input! Returning.\n"
               runmethod
               return;;
            esac

            printf "Execute fglrx .run file? "
            read execrunchoice

            case $execrunchoice in
            [yY]) printf "Executing fglrx .run file\n\n"
                  sudo ./amd*.run;;
            [nN]) printf "Returning to main menu.\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning.\n"
               runmethod
               return;;
            esac

            printf "Create configuration file? "
            read cfgchoice

            case $cfgchoice in
            [yY]) printf "Setting up initial fglrx configuration\n\n"
                  sudo amdconfig --initial;;

            [nN]) printf "You chose no. Make sure to set the configuration before rebooting! Continuing...\n";;
            *) printf "Wrong input! Returning.\n"
               runmethod
               return;;
            esac

            # Reboot dialog
            printf "Reboot? (Y/N) "
            read rebootchoice

            case $rebootchoice in
            [yY]) printf "System going down\n\n"
                  systemctl reboot;;
            [nN]) printf "Be sure to reboot!\n"
                  mainmenu
                  return;;
            *) printf "Wrong input! Returning to main menu.\n"
               mainmenu
               return;;
            esac
    else
        printf "Please enter either f or v\n"
    fi
}

rebootmethod() {
    printf "Rebooting in 3 seconds.\n"
    sleep 3
    systemctl reboot
}

mainmenu() {
    printf "
Choose one of the installation methods:
1. apt-get method
2. Create a Debian package and install it
3. Execute the fglrx .run file
4. AMD driver uninstall only
5. Reboot the system
6. Exit\n\n"

    read methodchoice

    if [ $methodchoice = 1 ]
        then 
            agmethod
            return
        elif [ $methodchoice = 2 ]
            then
                debmethod
                return
        elif [ $methodchoice = 3 ]
            then
                runmethod
                return
        elif [ $methodchoice = 4 ]
            then
                # Uninstall all .deb packages and .run leftovers
                printf "Uninstalling...\n\n"
                sudo sh /usr/share/ati/fglrx-uninstall.sh
                sudo apt-get purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                sudo apt-get purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                printf "Do you want to reboot? "
                read rebootchoice

                if [ $rebootchoice = "y" ] || [ $rebootchoice = "Y" ]
                    then
                        systemctl reboot
                else
                    printf "Be sure to reboot to apply the changes.\n"
                    mainmenu
                    return
                fi
        elif [ $methodchoice = 5 ]
            then
                rebootmethod
                return
        elif [ $methodchoice = 6 ]
            then
                printf "Exit\n"
                exit 0
        else
            printf "Wrong input.\n"
            mainmenu
            return
    fi
}

# Start main menu
mainmenu
