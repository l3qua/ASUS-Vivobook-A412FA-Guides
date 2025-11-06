# FN Lock with FN+Esc

---

## About
When you use macOS without any of the FN-related patches, you have to hold Fn to use the special functions of the Fn keys (Mute, Vol up, Vol down,...) and you can't toggle FN Lock. This guide shows you how to make FN Lock work and also how to change the default FN Lock behavior

## Requirements and Preparations

- MaciASL 
- Clear or edit key/function mapping contents of other methods
- Confirm FN-Lock key uses IANE method

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
If the second argument in the notify command inside the IANE method is different (e.g. 0xEF) and the third part inside acpi_listen output in Linux returns something simmilar to the second argument in the notify command (e.g. 000000ef) then you need to change the condition at line 42 inside [SSDT-ATKD](https://github.com/l3qua/ASUS-Vivobook-A412FA-Guides/blob/main/FN-Lock-and-FN-keys/FN-Lock-with-Fn-Esc/SSDT-ATKD.dsl#L42) to the correct argument (example for 0xEF: If (Arg0 == 0xEF))
</details>

