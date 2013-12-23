#!/bin/sh

##################################
#                                #
# Easy fglrx installation script #
#                                #
##################################

# easyfglrxinstall.sh written by netcyphe - 12/23/2013

# Accepted distro versions: gutsy, hardy, intrepid, jaunty, lucid, maverick, natty, oneiric, precise, quantal, raring
# Not yet implemented distro versions: breezy, dapper, feisty

agmethod() {
    echo "[F]ast or [v]erbose mode? \c"
    read modechoose

    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "agmethod() running in fast mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Removing all leftover fglrx installation files\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            echo "Installing via apt-get\n"
            sudo apt-get install fglrx fglrx-amdcccle

            # Set up initial driver config
            echo "Setting up initial fglrx configuration\n"
            sudo amdconfig --initial
            #sudo aticonfig --initial

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
            esac
    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "agmethod() running in verbose mode\n"
            echo "Remove all installed fglrx files? \c"
            read delchoose

            case $delchoose in
            [yY]) # Uninstall all .deb packages and .run leftovers
                  echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "You chose no. Please make sure that the fglrx driver was removed already. Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               agmethod;;
            esac

            echo "Do you want to install the fglrx driver with apt-get? \c"
            read instdecision

            case $instdecision in
            [yY]) echo "Installing via apt-get\n"
                  sudo apt-get install fglrx fglrx-amdcccle;;
            [nN]) echo "Returning to main menu."
                  mainmenu;;
            *) echo "Wrong input! Returning."
               agmethod;;
            esac

            echo "Create initial fglrx configuration? \c"
            read cfgdecision

            case $cfgdecision in
            [yY]) # Setup initial driver config
                  echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial;;
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing..."
                  continue;;
            *) echo "Wrong input! Returning."
               agmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootdecision

            case $rebootdecision in
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
    read modechoose    

    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "debmethod() running in fast mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Removing all leftover fglrx installation files\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Getting required dependencies for build
            echo "Downloading/installing build packages\n"
            sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4

            echo "Do you have a 32 bit or a 64 bit system? (32/64) \c"
            read archdecision

            case $archdecision in
            32) echo "System is not a 64 bit architecture. Skipping installation of lib32gcc1\n";;
            64) echo "Installing required 64 bit package\n"
                sudo apt-get install lib32gcc1;;
            *) echo "Wrong input! Returning."
               debmethod;;
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
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
            esac
    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "debmethod() running in verbose mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Uninstall all leftover fglrx files? \c"
            read uninstdecision

            case $uninstdecision in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Past fglrx installations must be removed. Returning to debmethod()"
                  debmethod;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            # Getting required dependencies for build
            echo "Download and install build packages? \c"
            read builddecision

            case $builddecision in
            [yY]) echo "Downloading/installing build packages\n"
                  sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4;;
            [nN]) echo "Make sure you have all the build packages installed."
                  continue;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            echo "Do you have a 32 bit or a 64 bit system? (32/64) \c"
            read archdecision

            case $archdecision in
            32) echo "System is not a 64 bit architecture. Skipping installation of lib32gcc1\n";;
            64) echo "Installing required 64 bit packages\n"
                sudo apt-get install lib32gcc1;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            echo "Extract fglrx .zip archive? \c"
            read unzipdecision

            case $unzipdecision in
            [yY]) echo "Extracting fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "You chose no. Make sure that the extracted files are in this folder. Continuing..."
                  continue;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            echo "WARNING: Is the .run file in the same folder as this script? (Y/N) \c"
            read runfiledecision

            case $runfiledecision in
            [yY]) echo "Continuing..."
                  continue;;
            [nN]) echo "The .run file must be in the same folder as this script."
                  debmethod;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            echo "Do you want to build the package for your Ubuntu version? \c"
            read buildingdecision

            case $buildingdecision in
            [yY]) echo "Building package\n"
                  sudo sh amd*.run --buildpkg;;
            [nN]) echo "You chose no. Returning to main menu."
                  mainmenu;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac

            echo "The debian package has been built for your distribution. Install it? (Y/N) \c"
            read instdecision

            # Install debian package
            case $instdecision in
            [yY]) echo "Installing package\n"
                  sudo dpkg -i fglrx*.deb;;
            [nN]) echo "You chose no. Returning to main menu."
                  mainmenu;;
            *) echo "Wrong input! Returning"
               debmethod;;
            esac

            echo "Create initial fglrx configuration? \c"
            read cfgdecision

            # Setup initial driver config
            case $cfgdecision in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial;;
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing..."
                  continue;;
            *) echo "Wrong input. Returning."
               debmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

runmethod() {
    echo "[F]ast or [v]erbose mode? \c"
    read modechoose

    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "runmethod() running in fast mode\n"
            echo "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) \c"
            read samefolder

            # Create xorg backup
            case $samefolder in
            [yY]) echo "Creating xorg backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.BAK

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
                  runmethod;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
            esac

    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "runmethod() running in verbose mode\n"
            echo "WARNING: Is the fglrx .run file in the same folder as this script? (Y/N) \c"
            read samefolder

            case $samefolder in
            [yY]) echo "Creating xorg backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.BAK;;
            [nN]) echo "The .run file has to be in this folder. Returning."
                  runmethod;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

            echo "Do you want to deinstall leftover fglrx files from past installations? \c"
            read uninstdecision

            case $uninstdecision in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Past installations must be removed. Returning to runmethod()"
                  runmethod;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Extract .zip archive? \c"
            read unzipfiles

            case $unzipfiles in
            [yY]) echo "Extracting fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "You chose no. Make sure that the extracted files are in this folder. Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Grant executable file permission rights to the .run file? \c"
            read grantingdecision

            case $grantingdecision in
            [yY]) echo "Granting executable file permission rights to fglrx .run file\n"
                  sudo chmod +x amd*.run;;
            [nN]) echo "You chose no. The .run file must be executable. Continuing..."
                  continue;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

            echo "Execute fglrx .run file? \c"
            read runningdecision

            case $runningdecision in
            [yY]) echo "Executing fglrx .run file\n"
                  sudo ./amd*.run;;
            [nN]) echo "Returning to main menu."
                  mainmenu;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

            echo "Create configuration file? \c"
            read cfgdecision

            case $cfgdecision in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "You chose no. Make sure to set the configuration before rebooting! Continuing..."
                  continue;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N) \c"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  mainmenu;;
            *) echo "Wrong input! Returning to main menu."
               mainmenu;;
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
2. Create a debian package and install it
3. Execute the fglrx .run file
4. AMD driver uninstall only
5. Reboot the system
6. Exit\n"

    read methodchoose

    if [ $methodchoose = 1 ]
        then 
            agmethod
        elif [ $methodchoose = 2 ]
            then
                debmethod
        elif [ $methodchoose = 3 ]
            then
                runmethod
        elif [ $methodchoose = 4 ]
            then
                # Uninstall all .deb packages and .run leftovers
                echo "Uninstalling...\n"
                sudo sh /usr/share/ati/fglrx-uninstall.sh
                sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                echo "Do you want to reboot? \c"
                read rebootdec

                if [ $rebootdec = y ] || [ $rebootdec = Y ]
                    then
                        sudo reboot
                else
                    echo "Be sure to reboot to apply the changes."
                    mainmenu
                fi
        elif [ $methodchoose = 5 ]
            then
                rebootmethod
        elif [ $methodchoose = 6 ]
            then
                echo "Exit"
                exit 0
        else
            echo "Wrong input."
            mainmenu
    fi
}

# Start main menu
mainmenu
