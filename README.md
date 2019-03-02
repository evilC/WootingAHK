# About WootingAHK

An AutoHotkey wrapper for the [Wooting Keyboard](https://wooting.io/) [Analog](https://github.com/WootingKb/wooting-analog-sdk) and [RGB](https://github.com/WootingKb/wooting-rgb-sdk) APIs  
Allows you to write AutoHotkey scripts that can read analog values (Without using DirectInput or XInput) and set RGB values for the keys. 

## Why ?
The Wooting API could be hit directly without an AHK wrapper, however this presents two problems for the consumer:  
1) The Wooting API does not use a standard way of identifying keys. It uses two methods - a "Key Code" (Not the same as Scan Code) and Row / Column.  
A [lookup table](https://github.com/evilC/WootingAHK/blob/master/WootingAHK/WootingCodeLookup.cs) is therefore needed to associate each Scan Code with it's equivalent Wooting key.  
I have discussed this with Wooting, and the next iteration of the API is likely to move to using Scan Codes, so this lookup table allows us to start writing scripts which use ScanCode straight away
2) The Wooting API is poll-based, requiring quite a lot of processing to get key events, which is not very suitable to do in AHK, as it is interpreted and a little slow.  
This library seeks to solve these issues using a C# DLL to do all the heavy lifting, with a light AHK wrapoer using CLR.  

## Current Limitations / Issues
* Currently, the lookup table is only complete for ISO keyboards. If you have an ANSI keyboard, please feel free to contribute  
* The RGB API does not properly support all keys on the Wooting Two at the moment

## Downloads
Use the Releases page link at the top - **DO NOT** click the green "Clone or Download" button to the right!  

## Contact / Discussion etc
Please use the [#woot_dev channel on the Wooting Discord server](https://discord.gg/zREJYgV)  

# Usage
See the some of the [Examples](https://github.com/evilC/WootingAHK/blob/master/Simple%20Example.ahk), or see the [Wiki](https://github.com/evilC/WootingAHK/wiki) for full documentation
