#!/bin/sh

# A script to automate the cracking and writing of Mifare Classic 1k
# tags using hardnested attacks.
# Works with 1st Gen Mifare Classic 1k magic cards, with the chinese
# backdoor.
# Will not work with other types of cards, such as if Sector 0 is directly
# writable.
#
# Author: Peter Walker

#***************** INSTALLATION *****************

sudo apt-get -y update
sudo apt-get -y install git binutils make csh g++ sed gawk autoconf automake autotools-dev libglib2.0-dev libnfc-dev liblzma-dev libnfc-bin

git clone https://github.com/nfc-tools/mfoc-hardnested
cd mfoc-hardnested
autoreconf -vis
./configure
make && sudo make install


# ************** READ USER PROMPT ***************

printf "\n\n\n\n\nPlace the card to read on the NFC attachment"
read input


# ******** READ AND CRACK ORIGINAL CARD *********

sudo modprobe -r pn533_usb
sudo modprobe -r pn533

mfoc-hardnested -O dump.mfd
# -k 6001fe966778 -k 447524f55503


# ************** WRITE USER PROMPT **************

printf "\n\n\n\n\nPlace the card to be written on the NFC attachment"
read input


# ******** DUMP AND WRITE NEW CARD **************

sudo modprobe -r pn533_usb
sudo modprobe -r pn533

mfoc-hardnested -O source.mfd

nfc-mfclassic W a source.mfd dump.mfd
nfc-mfclassic W b source.mfd dump.mfd


# ******* CLEAN UP *****************************

printf "\n\n\n\n\nPlease check cards with Mifare Classic Tool (MCT) on Android"

rm dump.mfd
rm source.mfd


