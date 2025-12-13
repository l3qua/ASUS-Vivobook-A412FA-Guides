# Fix NVRAM

**Table of Contents**
- [About](#about)
- [Fix native NVRAM](#fix-native-nvram)
- [Fix emulated NVRAM](#fix-emulated-nvram)

## About
After using macOS for a while, you may notice something: Brightness and audio level does not retain after reboot/shutdown. This is because you do not have proper NVRAM support. There are 2 ways to fix this, you should only use the latter one if the native NVRAM on your system is borked

## Fix native NVRAM
While the asus x412fag uses an 8th-gen CPU, it shares a same thing with 9th-gen laptops: They need SSDT-PMC in order to fix native NVRAM. The instruction on how to grab one is discribed [here](https://dortania.github.io/Getting-Started-With-ACPI/Universal/nvram.html)

## Fix emulated NVRAM
This is the way to use if your native NVRAM is borked, or you can not get native NVRAM to work. This way can make the volume and brightness level retain after reboot/shutdown. Please note that values that are not viewable when using `nvram -p` command in Terminal is not saved after reboot/shutdown

Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/misc/nvram.html) to emulate NVRAM
