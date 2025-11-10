# FN Lock with FN+Esc

---

## About
When you use macOS without any of the FN-related patches, you have to hold Fn to use the special functions of the Fn keys (Mute, Vol up, Vol down,...) and you can't toggle FN Lock. This guide shows you how to make FN Lock work and also how to change the default FN Lock behavior

## Requirements and Preparations

- MaciASL 
- Clear or edit key/function mapping contents of other methods
- Confirm FN-Lock key uses IANE method
- Plist editor ([ProperTree](https://github.com/corpnewt/ProperTree) is recommended)

### Confirm FN-Lock key uses IANE method
This specific patch only works if your FN-Lock sends `0xFF` event to `ATKD` through _SB.ATKD.IANE method. To check this, you can:
- 1. Confirm though System DSDT
	- Open MaciASL from the .app (not through a .dsl or .aml file). This opens the System DSDT inside MaciASL by default
		- You can open the System DSDT in File -> New from ACPI -> SSDT (DptfTabl) if it does not open the System DSDT by default
	- If you see `Method (IANE, 1, Serialized)` and `Notify (ATKD, 0xFF) // Hardware-Specific` inside the method, The FN Lock has a 99,99% chance that it sends the `0xFF` event to the mentioned `ATKD` device
- 2. Confirm with `acpi-listen` inside Linux
	- Boot Linux (can be an actual installation or a live installation)
	- Open terminal and run `sudo apt update` and `sudo apt install acpid`
	- Run `acpi_listen` and press FN + Esc
	- If the command shows `wmi PNP0C14:02 000000ff 00000000`, then the FN Lock has a 99,99% chance that it sends the `0xFF` event to the mentioned `ATKD` device
You should confirm both conditions to make sure that the patch will work

<details>
<summary>If the event is something other than 0xFF</summary>
<br>
If the second argument in the notify command inside the IANE method is different (e.g. 0xEF) and the third part inside acpi_listen output in Linux returns something simmilar to the second argument in the notify command (e.g. 000000ef) then you need to change the condition at line 42 inside SSDT-ATKD to the correct argument (example for 0xEF: If (Arg0 == 0xEF))
</details>

## Add replace values to config.plist
To make sure the our patch does not conflict with the existing functions of the system, we have to rename them to something else

There are 2 values (+1 more if you want FN-Lock to retain its value after sleep) that we want to replace:

P/S: The function is actually copied from [Qonfused's ASUS ZenBook Duo 14 UX481 Hackintosh](https://github.com/Qonfused/ASUS-ZenBook-Duo-14-UX481-Hackintosh) SSDT-ATKD and I could not find a way to combine his existing _QD5 function (for FN Lock) inside our IANE function. This means we have to also replace the _QD5 function inside the system DSDT to XQD5 in order for the function to work. If you know how to combine the _QD5 function to the IANE function, please let me know

- [FN Lock] IANE to XANE
	- Count: 1 (Number)
	- Find: 49414E45 (Data) (Hex)
	- Replace: 58414E45 (Data) (Hex)
- [FN Lock] _QD5 to XQD5
	- Count: 1 (Number)
	- Find: 5F514435 (Data) (Hex)
	- Replace: 58514435 (Data) (Hex)
- [XWAK] _WAK to XWAK (for sleep)
	- Count: 1 (Number)
	- Find: 5F57414B (Data) (Hex)
	- Replace: 5857414B (Data) (Hex)

Raw plist data copied from ProperTree:
````
	<dict>
		<key>Base</key>
		<string></string>
		<key>BaseSkip</key>
		<integer>0</integer>
		<key>Comment</key>
		<string>[ATKD] FN Lock - Rename IANE to XANE</string>
		<key>Count</key>
		<integer>1</integer>
		<key>Enabled</key>
		<true/>
		<key>Find</key>
		<data>SUFORQ==</data>
		<key>Limit</key>
		<integer>0</integer>
		<key>Mask</key>
		<data></data>
		<key>OemTableId</key>
		<data></data>
		<key>Replace</key>
		<data>WEFORQ==</data>
		<key>ReplaceMask</key>
		<data></data>
		<key>Skip</key>
		<integer>0</integer>
		<key>TableLength</key>
		<integer>0</integer>
		<key>TableSignature</key>
		<data></data>
	</dict>
	<dict>
		<key>Base</key>
		<string></string>
		<key>BaseSkip</key>
		<integer>0</integer>
		<key>Comment</key>
		<string>[ATKD] FN Lock - Rename _QD5 to XQD5</string>
		<key>Count</key>
		<integer>1</integer>
		<key>Enabled</key>
		<true/>
		<key>Find</key>
		<data>X1FENQ==</data>
		<key>Limit</key>
		<integer>0</integer>
		<key>Mask</key>
		<data></data>
		<key>OemTableId</key>
		<data></data>
		<key>Replace</key>
		<data>WFFENQ==</data>
		<key>ReplaceMask</key>
		<data></data>
		<key>Skip</key>
		<integer>0</integer>
		<key>TableLength</key>
		<integer>0</integer>
		<key>TableSignature</key>
		<data></data>
	</dict>
	<dict>
		<key>Base</key>
		<string></string>
		<key>BaseSkip</key>
		<integer>0</integer>
		<key>Comment</key>
		<string>[XWAK] Rename _WAK to XWAK</string>
		<key>Count</key>
		<integer>1</integer>
		<key>Enabled</key>
		<true/>
		<key>Find</key>
		<data>X1dBSw==</data>
		<key>Limit</key>
		<integer>0</integer>
		<key>Mask</key>
		<data></data>
		<key>OemTableId</key>
		<data></data>
		<key>Replace</key>
		<data>WFdBSw==</data>
		<key>ReplaceMask</key>
		<data></data>
		<key>Skip</key>
		<integer>0</integer>
		<key>TableLength</key>
		<integer>0</integer>
		<key>TableSignature</key>
		<data></data>
	</dict>
````

## Add SSDTs to EFI
After applying all the replacements, we can add the required SSDTs. There are 2 SSDTs in  "FN-Lock-with-Fn-Esc" folder. "SSDT-ATKD" includes the function to make FN Lock work propely, while "SSDT-XWAK" allows the FN-Lock to restore its state after sleep

If your IANE event value that you checked from [the previous step](### Confirm FN-Lock key uses IANE method) is different, you have to change that to your correct value before adding the SSDTs

The SSDTs inside the folder is saved as .dsl and OpenCore only accepts .aml so we have to compile the .dsl file first

First, open the SSDT-ATKD.dsl inside MaciASL then go to File -> Save As, then change the file extension from "" to "". After that, copy the .aml SSDT that you just saved to EFI\OC\ACPI folder then open your config.plist in ProperTree and do an OC Snapshot (File -> OC Snapshot)

If you want FN-Lock to retain its state after sleep, you can also add the SSDT-XWAK with the same procedure as compiling the SSDT-ATKD from the previous step

After all of that, you can restart your system and enjoy!