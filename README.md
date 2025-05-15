# custom-tools

This is a repository containing simple tools I've developed for ease of use. See below:

## MFC-hardnested-RW.sh
A bash script that will crack a Mifare Classic 1K key with a hardnested attack, then write its data to another card, using linux libraries.
**Requires an NFC reader/writer component.**

```sudo ./MFC-hardnested-RW.sh [-h] [-i] [-r] [-c] [-d dumpname]``` <br>
-h: Display this help dialog. <br>
-i: Install mode. Installs required dependencies before running the script. <br>
-r: Read-Only mode. Dumps  will be outputted to /dumps. <br>
-c: Clean up. Removes dumps once the script has completed. <br>
-d dumpname: Specifies the filename of the dump. <br>
-k keyfile: Specifies a keyfile that contains custom keys to test.

**Warning: Only writes the first block of each sector. This is believed to be a bug with libnfc (https://github.com/nfc-tools/libnfc/issues/564). Mifare Classic Tool (Android) or equivalent is required to fully clone the tag.**
