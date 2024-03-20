# scripts

This is a repository containing .sh files for kali to automate certain processes. See below:

## MFC-hardnested-RW.sh
A script for Kali Linux that will crack a Mifare Classic 1K key with a hardnested attack, then write its data to another card.
Requires an NFC reader/writer component.

script usage: sudo ./MFC-hardnested-RW.sh [-h] [-i] [-r] [-c] [-d dumpname] <br>
-h: Display this help dialog. <br>
-i: Install mode. Installs required dependencies before running the script. <br>
-r: Read-Only mode. Dumps  will be outputted to /dumps. <br>
-c: Clean up. Removes dumps once the script has completed. <br>
-d dumpname: Specifies the filename of the dump. 

**Warning: Only writes the first block of each sector. This is believed to be a bug with libnfc (https://github.com/nfc-tools/libnfc/issues/564). Mifare Classic Tool (Android) or equivalent is required to fully clone the tag.**
