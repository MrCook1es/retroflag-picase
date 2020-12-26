#!/bin/bash
# Retroflag Advanced Shutdown Mod by crcerror
# This is exclusivly for BATOCERA
# Intended to work for BATOCERA versions 5.24
#
# Release Power Button to shutdown your Raspberry
# Press Reset during ES to reload ES
# Press Reset in running emulator will kick you back to ES

version=$(grep -o '^[^ ]*' $HOME/data.version)
git_url="https://raw.githubusercontent.com/crcerror/retroflag-picase/master/other_os/batocera_safeshutdown.py"
file_dest="/usr/bin/rpi-retroflag-SafeShutdown"

# Minimum version of BATOCERA is 5.24 because here batocera-es-swissknife is integrated
# so all versions less then 5.24 will be dropped from further install
if [[ ${version//[^[:digit:]]/} -lt 5.24 ]]; then
    echo "Error! Please try annother installer"
    echo "Your current version of Batocera is '$version'"
    echo "You need at least 5.24 ...."
    exit
fi 

echo "Welcome to the Safe Shutdown installer..."
echo "Batocera '$version' detected..."
sleep 2

if ! grep -q "^dtoverlay=gpio-poweroff,gpiopin=4,active_low=1,input=1" "/boot/config.txt"; then
    mount -o remount, rw /boot
    echo "Activating overlay file...."
    echo "# Overlay setup for proper powercut, needed for Retroflag cases" >> "/boot/config.txt"
    echo "dtoverlay=gpio-poweroff,gpiopin=4,active_low=1,input=1" >> "/boot/config.txt"
fi

if [[ ${version//[^[:digit:]]/} -gt 524 ]]; then
    echo "Activate RETROFLAG in batocera.conf"
    batocera-settings set system.power.switch RETROFLAG_ADV
    sleep 2
    echo; echo
    echo "Rebooting in 5 seconds...."
    sleep 5
    shutdown -r now
    exit
fi

echo
echo "Downloading script now!"
wget -q --show-progress "$git_url" -O "$file_dest"
sleep 2

echo
echo "Adding -x flag to make script excutable"
chmod +x "$file_dest"
sleep 2

echo
echo "Activating UART ... now"
batocera-settings /boot/config.txt activate enable_uart

echo "Activate RETROFLAG in batocera.conf"
batocera-settings set system.power.switch RETROFLAG
sleep 2

echo
echo "Making changes permanent..."
batocera-save-overlay

echo; echo
echo "Rebooting in 5 seconds...."
sleep 5
shutdown -r now
