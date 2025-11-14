# Patch HDMI port

** Table of contents **
- [About](#about)
- [Requirements and Preparations](#requirements-and-preparations)

---

## About
After installing macOS on your laptop, the HDMI port may not work, this is because the connector is incorrectly mapped. Usually a connector patching or busid patching is required to get the HDMI port working

**Note**: This guide has a sample value for HDMI patching, this could help you save time *if it works*, if it does not work then you will have to follow the bus-id patching guide

## Preperation and requirements
- Working iGPU acceleration
- Plist editor ([ProperTree](https://github.com/corpnewt/ProperTree) is recommended)
- Time and patience

