#!/bin/sh

#######################################################################################
#                                                                                     #
#  easyfglrxinstall.sh - Install the fglrx driver on Debian-based operating systems   #
#  Copyright (C) 2013-2017 Christian Heinrichs <christian.heinrichs@openmailbox.org>  #
#                                                                                     #
#  This program is free software: you can redistribute it and/or modify               #
#  it under the terms of the GNU General Public License as published by               #
#  the Free Software Foundation, either version 3 of the License, or                  #
#  (at your option) any later version.                                                #
#                                                                                     #
#  This program is distributed in the hope that it will be useful,                    #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of                     #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                      #
#  GNU General Public License for more details.                                       #
#                                                                                     #
#  You should have received a copy of the GNU General Public License                  #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.              #
#                                                                                     #
#######################################################################################

##################################
#                                #
# Easy fglrx installation script #
#                                #
##################################

# easyfglrxinstall.sh written by Christian Heinrichs - 05/29/2017

# Accepted distro versions should be irrelevant, also this script should work
# on Debian as well as Ubuntu systems regardless of the distro version

agmethod() {
    echo "[F]ast or [v]erbose mode? \c"
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            echo "agmethod() running in fast mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Removing all leftover fglrx installation files\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Not sure about this one anymore, could be fglrx-driver now
            echo "Installing via apt-get\n"
            sudo apt-get install fglrx fglrx-amdcccle fglrx-driver

            # Set up initial driver config
            echo "Setting up initial fglrx configuration\n"
            sudo amdconfig --initial
            #sudo aticonfig --initial

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu
               return;;
            esac
    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            echo "agmethod() running in verbose mode\n"
            echo "Remove all installed fglrx files? \c"
            read delchoice

            case $delchoice in
            [yY]) # Uninstall all .deb packages and .run leftovers
                  echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "You chose no. Please make sure that the fglrx driver was removed already. Continuing...";;
            *) echo "Wrong input! Returning"
               agmethod
               return;;
            esac

            echo "Do you want to install the fglrx driver with apt-get? \c"
            read instchoice

            case $instchoice in
            [yY]) echo "Installing via apt-get\n"
                  sudo apt-get install fglrx fglrx-amdcccle fglrx-driver;;
            [nN]) echo "Returning to main menu."
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning."
               agmethod
               return;;
            esac

            echo "Create initial fglrx configuration? \c"
            read cfgchoice

            case $cfgchoice in
            # Setup initial driver config
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial;;
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing...";;
            *) echo "Wrong input! Returning."
               agmethod
               return;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
            esac
    else
        echo "Please enter either f or v."
    fi
}

debmethod() {
    echo "[F]ast or [v]erbose mode? \c"
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            echo "debmethod() running in fast mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Removing all leftover fglrx installation files\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Getting required dependencies for build
            echo "Downloading and installing build packages\n"
            sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4

            echo "Do you have a 32-bit or a 64-bit system? (32/64) \c"
            read archchoice

            case $archchoice in
            32) echo "System is not a 64-bit architecture. Skipping installation of lib32gcc1\n";;
            64) echo "Installing required 64-bit package\n"
                sudo apt-get install lib32gcc1;;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "Extracting .zip archive\n"
            unzip amd*.zip

            echo "Building package\n"
            sudo sh amd*.run --buildpkg

            # Install debian package
            echo "Installing debian package\n"
            sudo dpkg -i fglrx*.deb

            # Setup initial driver config
            echo "Setting up initial fglrx configuration\n"
            sudo amdconfig --initial
            #sudo aticonfig --initial

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu
               return;;
            esac
    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            echo "debmethod() running in verbose mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Uninstall all leftover fglrx files? \c"
            read uninstchoice

            case $uninstchoice in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Past fglrx installations must be removed. Returning to debmethod()"
                  debmethod
                  return;;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            # Getting required dependencies for build
            echo "Download and install build packages? \c"
            read builddecision

            case $builddecision in
            [yY]) echo "Downloading and installing build packages\n"
                  sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4;;
            [nN]) echo "Make sure you have all the build packages installed.";;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "Do you have a 32-bit or a 64-bit system? (32/64) \c"
            read archchoice

            case $archchoice in
            32) echo "System is not a 64-bit architecture. Skipping installation of lib32gcc1\n";;
            64) echo "Installing required 64-bit packages\n"
                sudo apt-get install lib32gcc1;;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "Extract fglrx .zip archive? \c"
            read extchoice

            case $extchoice in
            [yY]) echo "Extracting fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "You chose no. Make sure that the extracted files are in this folder. Continuing...";;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "WARNING: Is the .run file in the same folder as this script? (Y/N) \c"
            read runfilechoice

            case $runfilechoice in
            [yY]) echo "Continuing...";;
            [nN]) echo "The .run file must be in the same folder as this script."
                  debmethod
                  return;;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "Do you want to build the package for your distro version? \c"
            read buildchoice

            case $buildchoice in
            [yY]) echo "Building package\n"
                  sudo sh amd*.run --buildpkg;;
            [nN]) echo "You chose no. Returning to main menu."
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning."
               debmethod
               return;;
            esac

            echo "The Debian package should have been built for your distribution. Install it? (Y/N) \c"
            read instchoice

            # Install Debian package
            case $instchoice in
            [yY]) echo "Installing package\n"
                  sudo dpkg -i fglrx*.deb;;
            [nN]) echo "You chose no. Returning to main menu."
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning"
               debmethod
               return;;
            esac

            echo "Create initial fglrx configuration? \c"
            read cfgchoice

            # Setup initial driver config
            case $cfgchoice in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial;;
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing...";;
            *) echo "Wrong input. Returning."
               debmethod
               return;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu
               return;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

runmethod() {
    echo "[F]ast or [v]erbose mode? \c"
    read modechoice

    if [ $modechoice = "f" ] || [ $modechoice = "F" ]
        then
            echo "runmethod() running in fast mode\n"
            echo "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) \c"
            read samefolder

            # Create xorg.conf backup
            case $samefolder in
            [yY]) echo "Creating xorg.conf backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf~

                  echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                  echo "Extracting .zip archive\n"
                  unzip amd*.zip

                  echo "Granting executable permission rights to fglrx .run file\n"
                  sudo chmod +x amd*.run

                  echo "Executing fglrx .run file\n"
                  sudo ./amd*.run

                  echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "It has to be in this folder. Returning."
                  runmethod
                  return;;
            *) echo "Wrong input! Returning."
               runmethod
               return;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu
               return;;
            esac

    elif [ $modechoice = "v" ] || [ $modechoice = "V" ]
        then
            echo "runmethod() running in verbose mode\n"
            echo "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) \c"
            read samefolder

            case $samefolder in
            [yY]) echo "Creating xorg.conf backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf~;;
            [nN]) echo "The .run file has to be in this folder. Returning."
                  runmethod
                  return;;
            *) echo "Wrong input! Returning."
               runmethod
               return;;
            esac

            echo "Do you want to uninstall leftover fglrx files from past installations? \c"
            read uninstchoice

            case $uninstchoice in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Past installations must be removed. Returning to runmethod()"
                  runmethod
                  return;;
            *) echo "Wrong input! Returning"
               runmethod
               return;;
            esac

            echo "Extract .zip archive? \c"
            read unzipfiles

            case $unzipfiles in
            [yY]) echo "Extracting fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "You chose no. Make sure that the extracted files are in this folder. Continuing...";;
            *) echo "Wrong input! Returning"
               runmethod
               return;;
            esac

            echo "Grant executable file permission rights to the .run file? \c"
            read chmodchoice

            case $chmodchoice in
            [yY]) echo "Granting executable file permission rights to fglrx .run file\n"
                  sudo chmod +x amd*.run;;
            [nN]) echo "You chose no. The .run file must be executable. Continuing...";;
            *) echo "Wrong input! Returning."
               runmethod
               return;;
            esac

            echo "Execute fglrx .run file? \c"
            read execrunchoice

            case $execrunchoice in
            [yY]) echo "Executing fglrx .run file\n"
                  sudo ./amd*.run;;
            [nN]) echo "Returning to main menu."
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning."
               runmethod
               return;;
            esac

            echo "Create configuration file? \c"
            read cfgchoice

            case $cfgchoice in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing...";;
            *) echo "Wrong input! Returning."
               runmethod
               return;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootchoice

            case $rebootchoice in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu
                  return;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu
               return;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

rebootmethod() {
    echo "Rebooting in 3 seconds."
    sleep 3
    sudo reboot
}

mainmenu() {
    echo "
Choose one of the installation methods:
1. apt-get method
2. Create a Debian package and install it
3. Execute the fglrx .run file
4. AMD driver uninstall only
5. Reboot the system
6. Exit\n"

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
                echo "Uninstalling...\n"
                sudo sh /usr/share/ati/fglrx-uninstall.sh
                sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                echo "Do you want to reboot? \c"
                read rebootchoice

                if [ $rebootchoice = "y" ] || [ $rebootchoice = "Y" ]
                    then
                        sudo reboot
                else
                    echo "Be sure to reboot to apply the changes."
                    mainmenu
                    return
                fi
        elif [ $methodchoice = 5 ]
            then
                rebootmethod
                return
        elif [ $methodchoice = 6 ]
            then
                echo "Exit"
                exit 0
        else
            echo "Wrong input."
            mainmenu
            return
    fi
}

# Start main menu
mainmenu
