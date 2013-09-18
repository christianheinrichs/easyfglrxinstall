#!/bin/sh

##################################
#                                #
# Easy fglrx installation script #
#                                #
##################################

# Accepted distro versions: gutsy, hardy, intrepid, jaunty, lucid, maverick, natty, oneiric, precise, quantal, raring
# Not yet implented distro versions: breezy, dapper, feisty

agmethod() {
    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "Fast mode\n"

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
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!";;
            *) echo "Wrong input! Returning."
               agmethod;;
            esac
    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "Verbose mode\n"
            echo "Remove all installed fglrx files?"
            read delchoose

            case $delchoose in
            [yY]) # Uninstall all .deb packages and .run leftovers
                  echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               agmethod;;
            esac

            echo "Do you want to install the fglrx driver with apt-get?"
            read instdecision

            case $instdecision in
            [yY]) echo "Installing via apt-get\n"
                  sudo apt-get install fglrx fglrx-amdcccle;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               agmethod;;
            esac

            echo "Create initial fglrx configuration?"
            read cfgdecision

            case $cfgdecision in
            [yY]) # Set up initial driver config
                  echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               agmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!";;
            *) echo "Wrong input! Returning."
               agmethod;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

debmethod() {
    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "Fast mode\n"

            echo "Uninstalling...\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Removing all leftover fglrx installation files\n"
            sudo sh /usr/share/ati/fglrx-uninstall.sh
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

            # Getting required dependencies for build
            echo "Downloading/installing build dependencies\n"
            sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4

            echo "Do you have a 32 bit or a 64 bit system? (32/64)"
            read archdecision

            case $archdecision in
            64) echo "Installing required x64 dependencies\n"
                sudo apt-get install lib32gcc1;;
            *) echo "System is not a 64 bit architecture; Skipping\n";;
            esac

            #distroversions=( gutsy hardy intrepid jaunty lucid maverick natty oneiric precise quantal raring ) # Accepted Ubuntu versions

            echo "What Ubuntu version is installed?"
            read distroversion

            # Very bad workaround for a problem with arrays due to .sh & bash madness:
            case $distroversion in
            gutsy) echo "Building for" Ubuntu/$distroversion;;
            hardy) echo "Building for" Ubuntu/$distroversion;;
            intrepid) echo "Building for" Ubuntu/$distroversion;;
            jaunty) echo "Building for" Ubuntu/$distroversion;;
            lucid) echo "Building for" Ubuntu/$distroversion;;
            maverick) echo "Building for" Ubuntu/$distroversion;;
            natty) echo "Building for" Ubuntu/$distroversion;;
            oneiric) echo "Building for" Ubuntu/$distroversion;;
            precise) echo "Building for" Ubuntu/$distroversion;;
            quantal) echo "Building for" Ubuntu/$distroversion;;
            raring) echo "Building for" Ubuntu/$distroversion;;
            *) echo "Please enter one of the following Ubuntu versions: gutsy, hardy, intrepid, jaunty, lucid, maverick, natty, oneiric, precise, quantal, raring"
               debmethod;;
            esac
            # End of very bad workaround

            echo "Unpacking .zip archive\n"
            unzip amd*.zip

            echo "Building package\n"
            sudo sh amd*.run --buildpkg Ubuntu/$distroversion

            # Install precise debian packages
            echo "Installing package\n"
            sudo dpkg -i fglrx*.deb

            # Set up initial driver config
            echo "Setting up initial fglrx configuration\n"
            sudo amdconfig --initial
            #sudo aticonfig --initial

            # Reboot dialog
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!";;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac
    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "Verbose mode\n"

            # Uninstall all .deb packages and .run leftovers
            echo "Uninstall all fglrx leftover files?"
            read uninstdecision

            case $uninstdecision in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               debmethod;;
            esac

            # Getting required dependencies for build
            echo "Download and install build packages?"
            read builddecision

            case $builddecision in
            [yY]) echo "Downloading/installing build dependencies\n"
                  sudo apt-get install build-essential cdbs dh-make dkms execstack dh-modaliases fakeroot libqtgui4;;
            [nN]) echo "Continuing..."
                  continue;;
            *) debmethod;;
            esac

            echo "Do you have a 32 bit or a 64 bit system? (32/64)"
            read archdecision

            case $archdecision in
            64) echo "Installing required x64 dependencies\n"
                sudo apt-get install lib32gcc1;;
            *) echo "System is not a 64 bit architecture; Skipping\n";;
            esac

            echo "WARNING: Is your .run in the same folder as this script? (Y/N)"
            read runfiledecision

            case $runfiledecision in
            [yY]) echo "What Ubuntu version?"
                  read distroversion;;
            [nN]) echo "Not building package"
                  continue;;
            *) echo "Wrong input! Returning"
               debmethod;;
            esac

            # Very bad workaround for non-functional arrays due to .sh & bash madness:
            case $distroversion in
            gutsy) echo "Building for" Ubuntu/$distroversion;;
            hardy) echo "Building for" Ubuntu/$distroversion;;
            intrepid) echo "Building for" Ubuntu/$distroversion;;
            jaunty) echo "Building for" Ubuntu/$distroversion;;
            lucid) echo "Building for" Ubuntu/$distroversion;;
            maverick) echo "Building for" Ubuntu/$distroversion;;
            natty) echo "Building for" Ubuntu/$distroversion;;
            oneiric) echo "Building for" Ubuntu/$distroversion;;
            precise) echo "Building for" Ubuntu/$distroversion;;
            quantal) echo "Building for" Ubuntu/$distroversion;;
            raring) echo "Building for" Ubuntu/$distroversion;;
            *) echo "Please enter one of the following Ubuntu versions: gutsy, hardy, intrepid, jaunty, lucid, maverick, natty, oneiric, precise, quantal, raring"
               debmethod;;
            esac
            # End of very bad workaround

            echo "Unzip fglrx .zip archive?"
            read unzipdecision

            case $unzipdecision in
            [yY]) echo "Unpacking fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "Not unzipping";;
            *) echo "Wrong input! Abort."
               debmethod;;
            esac

            echo "Do you want to build the package for yor Ubuntu version?"
            read buildingdecision

            case $buildingdecision in
            [yY]) echo "Building package\n"
                  sudo sh amd*.run --buildpkg Ubuntu/$distroversion;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               debmethod;;
            esac

            echo "The debian packages have been built for your distribution. Install them? (Y/N)"
            read instdecision

            # Install precise debian packages
            case $instdecision in
            [yY]) echo "Installing package\n"
                  sudo dpkg -i fglrx*.deb;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               debmethod;;
            esac

            echo "Create initial fglrx configuration?"
            read cfgdecision

            # Set up initial driver config
            case $cfgdecision in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "Continuing..."
                  continue;;
            *) debmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  exit 0;;
            *) echo "Wrong input! Returning."
               debmethod;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

runmethod() {
    if [ $modechoose = f ] || [ $modechoose = F ]
        then
            echo "Fast mode\n"
            echo "WARNING: Is your .run in the same folder as this script? (Y/N)"
            read samefolder

            # Create xorg backup
            case $samefolder in
            [yY]) echo "Creating xorg backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.BAK

                  echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates

                  echo "Unzipping .zip archive\n"
                  unzip amd*.zip

                  echo "Granting executable permission rights to fglrx .run file\n"
                  sudo chmod +x amd*.run

                  echo "Executing fglrx .run file\n"
                  sudo ./amd*.run

                  echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!"
                  exit 0;;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac

    elif [ $modechoose = v ] || [ $modechoose = V ]
        then
            echo "Verbose mode\n"
            echo "WARNING: Is your .run in the same folder as this script? (Y/N)"
            read samefolder

            case $samefolder in
            [yY]) echo "Creating xorg backup\n"
                  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.BAK;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Do you want to deinstall leftover fglrx files from past installation attempts?"
            read uninstdecision

            case $uninstdecision in
            [yY]) echo "Removing all leftover fglrx installation files\n"
                  sudo sh /usr/share/ati/fglrx-uninstall.sh
                  sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev*
                  sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Unpack .zip archive?"
            read unzipfiles

            case $unzipfiles in
            [yY]) echo "Unzipping fglrx .zip archive\n"
                  unzip amd*.zip;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Grant executable file permission rights?"
            read grantingdecision

            case $grantingdecision in
            [yY]) echo "Granting executable file permission rights to fglrx .run file\n"
                  sudo chmod +x amd*.run;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Execute fglrx .run file?"
            read runningdecision

            case $runningdecision in
            [yY]) echo "Executing fglrx .run file\n"
                  sudo ./amd*.run;;
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            echo "Create configuration file?"
            read cfgdecision

            case $cfgdecision in
            [yY]) echo "Setting up initial fglrx configuration\n"
                  sudo amdconfig --initial;;
                  #sudo aticonfig --initial
            [nN]) echo "Continuing..."
                  continue;;
            *) echo "Wrong input! Returning"
               runmethod;;
            esac

            # Reboot dialog
            echo "Reboot? (Y/N)"
            read rebootdecision

            case $rebootdecision in
            [yY]) echo "System going down\n"
                  sudo reboot;;
            [nN]) echo "Be sure to reboot!";;
            *) echo "Wrong input! Returning."
               runmethod;;
            esac
    else
        echo "Please enter either f or v"
    fi
}

echo "Run this script in (f)ast or (v)erbose mode?"
read modechoose

echo "
Choose one of the installation methods:
1. apt-get method
2. Create a debian package and install it
3. Execute the fglrx .run file
4. AMD driver uninstall only
5. Exit
"

read methodchoose

# Use if or case switch
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
            sudo apt-get remove --purge fglrx fglrx_* fglrx-amdcccle* fglrx-dev* # If this one fails, run the next command
            sudo apt-get remove --purge fglrx fglrx-amdcccle fglrx-dev fglrx-updates fglrx-amdcccle-updates
    elif [ $methodchoose = 5 ]
        then
            echo "Exit"
            exit 0
    else
        echo "Wrong input."
fi
