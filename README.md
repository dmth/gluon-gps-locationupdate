# gluon-gps-locationupdate
a script which updates the location of a router using gluon, by reading a gps

Original source:
https://forum.freifunk.net/t/freifunk-location-update-via-gps/1493
* * *

##Tested Devices:##
..and the required kernel modules:

###Navilock###
NL-602U -> kmod-usb-acm -> /dev/ttyUSB0

NL-302U -> kmod-usb-serial-pl2303 -> /dev/ttyACM0 -> 4800 Baud

###U-Blox 7 based GPS?###
G-7020 -> kmod-usb-acm -> /dev/ttyACM0


### Venus ###
Venus638 -> -> /dev/ttyATH0 -> 9600 Baud

* * *

## Required Kernel Modules ##
To use a USB-GPS module, you might require the following kernelmodules:

    opkg install kmod-usb-core
    opkg install kmod-usb-ohci
    opkg install kmod-usb2
    opkg install kmod-usb-serial-pl2303
    opkg install kmod-usb-acm

The script configures the Baudrate with stty. In order to do so you require:

    opkg install coreutils-stty
    
To run the script, it is likely that you need to change the GPS-Device '/dev/ttyACM0' and the baudrate
