#!/bin/bash

# A script to automate the cracking and writing of Mifare Classic 1k
# tags using hardnested attacks.
# Works with 1st Gen Mifare Classic 1k magic cards, with the chinese
# backdoor.
# Will not work with other types of cards, such as if Sector 0 is directly
# writable.
#
# Currently only clones the first block of each sector (every 4th line)
# which is believed to be a bug within libnfc
# https://github.com/nfc-tools/libnfc/issues/564
#
# After finishing, please copy the necessary sector data using Mifare
# Classic Tool on Android.
#
# Author: Peter Walker

write="True"
cleanup="False"
dumpname="dump"
sourcename="source"
params=""

#************* READ FLAGS ***********************

while getopts 'hircdk:' OPTION; do
	case "$OPTION" in
		h)
			printf "script usage: sudo ./$(basename $0) [-h] [-i] [-r] [-c] [-d dumpname] \n\n\n
-h: Display this help dialog.\n
-i: Install mode. Installs required dependencies before running the script.\n
-r: Read-Only mode. Dumps  will be outputted to ${PWD}/dumps.\n
-c: Clean up. Removes dumps once the script has completed.\n
-d dumpname: Specifies the filename of the dump.\n
-k keyfile: Specifies the filename for custom keys.\n"
			exit 1
			;;
		i)
			sudo apt-get -y update
			sudo apt-get -y install git binutils make csh g++ sed gawk autoconf automake autotools-dev libglib2.0-dev libnfc-dev liblzma-dev libnfc-bin
			git clone https://github.com/nfc-tools/mfoc-hardnested
			cd mfoc-hardnested
			autoreconf -vis
			./configure
			make && sudo make install
			cd ../
			;;
		r)
			write="False"
			;;
		c)
			cleanup="True"
			;;
		d)
			dumpname="$OPTARG"
			;;
		k)
			mapfile -t keysArr < "$OPTARG"

			for key in "${keysArr[@]}"; do
				params+="-k $key "
			done
			;;
		?)
			printf "Unrecognised flag. Use -h for usage"
			exit 1
			;;
	esac
done
shift "$(($OPTIND -1))"

# ************** READ USER PROMPT ***************

printf "\n\n\n\n*********************************\nPlace the card to crack on the NFC attachment\n*********************************"
read input


# ******** READ AND CRACK ORIGINAL CARD *********

sudo modprobe -r pn533_usb
sudo modprobe -r pn533

mkdir -p dumps

mfoc-hardnested -O "dumps/$dumpname.mfd" -F $params


# ************** WRITE USER PROMPT **************

if [ "$write" = "True" ]; then

printf "\n\n\n\n*********************************\nPlace the card to be written on the NFC attachment\n*********************************"
read input


# ******** DUMP AND WRITE NEW CARD **************

sudo modprobe -r pn533_usb
sudo modprobe -r pn533

mfoc-hardnested -O dumps/source.mfd -F $params

nfc-mfclassic W a dumps/source.mfd "dumps/$dumpname.mfd"
nfc-mfclassic W b dumps/source.mfd "dumps/$dumpname.mfd"


# ******* CLEAN UP *****************************

rm dumps/source.mfd

printf "\n\n\n\n*********************************\nPlease update sectors with Mifare Classic Tool (MCT) on Android\n"
printf "This is due to a bug with libnfc, please open script for more details\n*********************************"
fi

if [ "$cleanup" = "True" ]; then

rm "dumps/$dumpname.mfd"
rmdir -d dumps

fi


