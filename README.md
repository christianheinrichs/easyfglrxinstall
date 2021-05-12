easyfglrxinstall
================

*A lot of time has passed since I wrote and published this script. Alas, not
only did Debian drop support for their officially maintained fglrx packages, but
so did Ubuntu in terms of stable distro versions. It is therefore not
recommended to rely on this script’s apt installation method. In fact, building
a fglrx .deb package is also a bad idea, since the latest downloadable versions
seem to be from 2015. There is no actual reason to use this script anymore.*

Easy fglrx installation script

What can this script do?

This script was written to help people troubleshoot their fglrx installation
faster when it causes problems. So instead of manually entering all the commands
found on the tutorial pages, this script does all the work for you.

It lets you choose between 3 installation methods:
- Downloading and installing fglrx via apt-get
- Creating and installing a debian package for your system
- Simply execute the .run file found in the ZIP archive downloaded from AMD

If you want to post feedback, improvements or suggestions, feel free to do so at
[Ubuntu Forums](https://ubuntuforums.org/showthread.php?t=2174060).

Instructions (Assuming you are using ~/Downloads/fglrx/):

1. Download the appropriate .zip file for your system at
[AMD's driver download page](https://support.amd.com/en-us/download).
2. Create a new folder like so: `mkdir ~/Downloads/fglrx/`
3. Place the .zip file into ~/Downloads/fglrx/
4. Download the script from this repository with any method of your choice. 
   The simplest way is to just click the
[`Download ZIP`](/archive/master.zip) button.
5. Save it as easyfglrxinstall.sh in the folder where you saved that zip file.
6. Open a terminal and type the following commands:

   ```shell
   cd ~/Downloads/fglrx
   ./easyfglrxinstall.sh
   ```

   or

   ```shell
   cd ~/Downloads/fglrx
   sh easyfglrxinstall.sh
   ```

7. Select either the fast mode or the verbose mode by entering `f` or `v`.
8. Answer the questions by entering `n` for no or `y` for yes.
9. Enjoy!

This script would not be possible without the instructions of the following
websites:
- [AskUbuntu](https://askubuntu.com)
- [Linux Tech Tips](https://www.linuxtechtips.com/)
- [Ubuntu documentation](https://help.ubuntu.com/)
- [Unofficial Wiki for the ATI Linux Driver](http://wiki.cchtml.com/)

**Disclaimer:** I cannot be held responsible for any system damage or data loss.
Use this script at your own risk!
