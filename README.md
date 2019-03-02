# About WootingAHK

An AutoHotkey wrapper for the [Wooting Keyboard](https://wooting.io/) [Analog](https://github.com/WootingKb/wooting-analog-sdk) and [RGB](https://github.com/WootingKb/wooting-rgb-sdk) APIs  
Allows you to write AutoHotkey scripts that can read analog values (Without using DirectInput or XInput) and set RGB values for the keys.  
Also provides helpers for handling AHK hotkeys for the associated keys.  
Should be layout-agnostic (QWERTY/AZERTY etc) as the Scan Code for Q should vary depending on your locale settings.  

## Current Limitations / Issues
* Currently, the [Scan Code to Wooting Code lookup table](https://github.com/evilC/WootingAHK/blob/master/WootingAHK/WootingCodeLookup.cs) is only complete for ISO keyboards. If you have an ANSI keyboard, please feel free to contribute  
At some point, the Wooting API should support Scan Codes, so this part should only be temporary.  
* The RGB API does not properly support all keys on the Wooting Two at the moment

## Downloads
Use the [Releases page](https://github.com/evilC/WootingAHK/releases) link at the top - **DO NOT** click the green "Clone or Download" button to the right!  
**After downloading, Right-click the Zip and select "Unblock", else the DLLs will be blocked**

## Contact / Discussion etc
Please use the [#woot_dev channel on the Wooting Discord server](https://discord.gg/zREJYgV)  

# Usage
See the some of the [Examples](https://github.com/evilC/WootingAHK/blob/master/Simple%20Example.ahk), or see the [Wiki](https://github.com/evilC/WootingAHK/wiki) for full documentation

# Interfacing with other stuff (Virtual Joysticks etc)
WootingAHK does not (Nor could it) control the analog sticks on the Wooting, or create sticks of it's own.  
If you wish to create DirectInput joysticks, you can use [CvJoyInterface](https://github.com/evilC/AHK-CvJoyInterface)  
If you wish to create XInput or DualShock 3 controllers, you can use [AHK-ViGEm-Bus](https://github.com/evilC/AHK-ViGEm-Bus), although this is still rather under-developed.  
It is also worth noting that if you need to deep block a key from windows (eg some game or app is seeing through AHK's block), the [AutoHotInterception](https://github.com/evilC/AutoHotInterception) library can do that, and uses an identical ScanCode identifier for keys.  

# Tools  
See the [Key Tester](https://github.com/evilC/WootingAHK/blob/master/AllKeyTest.ahk) script  
![](https://i.imgur.com/lG1GE44.png)  
