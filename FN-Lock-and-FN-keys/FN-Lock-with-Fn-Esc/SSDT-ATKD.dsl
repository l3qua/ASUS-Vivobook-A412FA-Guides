DefinitionBlock ("", "SSDT", 2, "A412FA", "X412FAG", 0)
{
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.XANE, MethodObj)
    External (_SB_.PCI0.LPCB.EC0_, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_.ST9E, MethodObj)
    External (_SB_.PCI0.LPCB.EC0_.XQD5, MethodObj)
    External (_SB.PCI0.LPCB.EC0.KFSK, IntObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        If (_OSI ("Darwin"))
        {
            // Sets FN+Lock disable default
            Name (\FNKL, Zero)
            If (!KFSK) { ST9E (0x3C, 0xFF, 0x04) }
        }
        
        // FN + Lock: Toggle
        // Reference: ASUS-ZenBook-Duo-14-UX481-Hackintosh (@Qonfused)
        Method (_QD5, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Switch (FNKL)
                {
                    Case (Zero) { Local0 = 0x08 }
                    Case (One) { Local0 = 0x04 }
                }
                FNKL ^= One
                ST9E (0x3C, 0xFF, Local0)
            }
            Else { XQD5 () }
        }
    }
    
    // Fix fn-lock (fn + esc)
    Scope (\_SB.ATKD)
    {
        Method (IANE, 1, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (Arg0 == 0xFF)
                {
                    \_SB.PCI0.LPCB.EC0._QD5()
                    Return (Zero)
                }
                Else { Return (\_SB.ATKD.XANE (Arg0)) }
            }
            Else { Return (\_SB.ATKD.XANE (Arg0)) }
        }
    }
}