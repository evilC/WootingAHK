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

## Current Limitations
Currently, the lookup table is only complete for ISO keyboards. If you have an ANSI keyboard, please feel free to contribute  

## Downloads
Use the Releases page link at the top - **DO NOT** click the green "Clone or Download" button to the right!  

## Contact / Discussion etc
Please use the [#woot_dev channel on the Wooting Discord server](https://discord.gg/zREJYgV)  

# Usage

1) Include the library  
Place the script next to the WootingAHK `Lib` folder and include the library:  
`#include Lib\WootingWrapper.AHK`  

1) Instantiate the wrapper  
`Wooting := new WootingWrapper()`  

## Analog API

### Subscribe to a Key
With WootingAHK, you create an AHK hotkey, and a Wooting Analog API subscription with one command - `SubscribeKey`  
`SubscribeKey` returns a `KeyWatcher` object, which can be used to alter aspects of the subscription at run-time (eg turning on or off blocking of that key)  
`keyWatcher := Wooting.SubscribeKey(<Scan Code>, <Callcack> [, <Window Title> ])`  
eg 
```
keyWatcher := Wooting.SubscribeKey(GetKeySC("A")	; Subscribe to the A key - use the AHK key name
		, Func("AxisChanged") 						; Call the Function "AxisChanged" when it changes
		, "ahk_class Notepad")						; Key Blocking is only active in Notepad
    
[...]

AxisChanged(value){

}
```
**Scan Code:** The Scan Code for the key. This can be obtained from key name using AutoHotkey's `GetKeySC()` function.  
**Callback:** A Function Object to fire when the key changes state. The function is passed one parameter, which holds the new value for the axis, in the range `0..255`  
**Window Title:** An optional string containing an AHK `WinTitle` parameter (eg `NameOfSomeWindow` or `ahk_exe SomeGame.exe`)  
If specified, the hotkey will only function (and block, if that is chosen) while the specified application is active.  

## KeyWatcher Objects
The KeyWatcher object returned by `SubscribeKey` has the following functions:  

## SetBlock
Turns on / off blocking of the key  
`keyWatcher := keyWatcher.SetBlock(<True/False>)`  
Returns itself, so you can "chain" commands - eg  
```
keyWatcher := Wooting.SubscribeKey(GetKeySC("A"), Func("AxisChanged"))
  .Setblock(true)`
```

## ToggleBlock
Toggles blocking On / Off  
`keyWatcher.ToggleBlock()`  
