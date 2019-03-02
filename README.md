# About WootingAHK

An AutoHotkey wrapper for the [Wooting Keyboard](https://wooting.io/) [Analog](https://github.com/WootingKb/wooting-analog-sdk) and [RGB](https://github.com/WootingKb/wooting-rgb-sdk) APIs  
Allows you to write AutoHotkey scripts that can read analog values (Without using DirectInput or XInput) and set RGB values for the keys. 

## Current Limitations / Issues
* Currently, the [Scan Code to Wooting Code lookup table](https://github.com/evilC/WootingAHK/blob/master/WootingAHK/WootingCodeLookup.cs) is only complete for ISO keyboards. If you have an ANSI keyboard, please feel free to contribute  
At some point, the Wooting API should support Scan Codes, so this part should only be temporary.  
* The RGB API does not properly support all keys on the Wooting Two at the moment

## Downloads
Use the [Releases page](https://github.com/evilC/WootingAHK/releases) link at the top - **DO NOT** click the green "Clone or Download" button to the right!  

## Contact / Discussion etc
Please use the [#woot_dev channel on the Wooting Discord server](https://discord.gg/zREJYgV)  

# Usage
See the some of the [Examples](https://github.com/evilC/WootingAHK/blob/master/Simple%20Example.ahk), or see the [Wiki](https://github.com/evilC/WootingAHK/wiki) for full documentation
