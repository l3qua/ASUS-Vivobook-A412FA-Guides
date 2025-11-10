/*
 * Handles macOS-specific device initialization quirks on wake.
 */
 
DefinitionBlock ("", "SSDT", 2, "A412FA", "XWAK", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0_, DeviceObj)
    // config.plist ACPI > Patch renames
    External (XWAK, MethodObj)
    // SSDT-ATKD methods and variables
    External (_SB_.PCI0.LPCB.EC0_._QD5, MethodObj)
    External (FNKL, IntObj)

    Method (_WAK, 1, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Scope (\_SB.PCI0.LPCB.EC0)
            {
                // Restore FN+Lock to previous state
                FNKL ^= One
                _QD5 ()
            }
        }
        
        Return (XWAK (Arg0))
    }
}