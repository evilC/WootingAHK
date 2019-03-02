#include Lib\WootingWrapper.AHK
OutputDebug DBGVIEWCLEAR

fw := 400
infoText := "
(
This script will attempt to create a WootingKey object for every known ScanCode.
For each key, success or failure will be logged below.

A WootingKey object includes an AHK hotkey, plus a subscription to the Analog API.
On press, an attempt will be made to turn that key Red via the RGB API.
On release, an attempt will be made to turn that key back to it's default colour.
Again, all successes or failures will be logged.

Any activity (Digital presses via AHK or analog presses via the API) will be
added to the Key History

The 'Block Keys' checkbox will turn on / off blocking of the WootingKey objects. 
)"
Gui, Add, Text, % "xm w" fw, % infoText
Gui, Add, Button, % "xm y+10 w" fw " gGo", Go
Gui, Add, CheckBox, % "xm Checked vBlockHotkeys gBlockChanged", Block Keys (May need to run script as Admin to stop some apps seeing keys)
Gui, Add, Text, % "xm y+10 Center w" fw, Key History
Gui, Add, ListView, % "xm w" fw " hwndhAnalogData", Key Name|ScanCode (Dec)|Type|State
LV_ModifyCol(1, 100)
LV_ModifyCol(2, 100)
LV_ModifyCol(3, 100)
LV_ModifyCol(4, 50)
Gui, Add, Button, % "xm w" fw " gClearAnalogData", Clear Data
Gui, Add, Text, % "xm Center w" fw, Log
Gui, Add, Edit, % "xm w" fw " R15 hwndhLog"
Gui, Add, Button, % "xm w" fw " gClearLog", Clear Log
Gui, Show, , WootingAHK Analog / RGB Tester

HotkeysEnabled := 0
GoSub, BlockChanged	; Init block var
Wooting := new WootingWrapper()

return

Go:
	if (HotkeysEnabled)
		return
	keys := GetKeySCs()
	subbed := 0, failed := 0
	for i, obj in keys {
		code := obj.SC
		name := obj.Name
		wootingKey := Wooting.AddKey(code)
			.OnDigital(Func("InputEvent").Bind(code, name, true))
			.SetBlock(BlockHotkeys)
			.SetHotkey(true)
		try {
			wootingKey.OnAnalog(Func("InputEvent").Bind(code, name, false))
			rowCol := GetRowCol(code)
			LogMessage("Subscribed to Key via Analog API`nCode: " code ", Name: " name "`nRow: " rowCol.Row ", Column: " rowCol.Col )
			subbed++
		} catch e {
			LogMessage("SubscribeKeyCode exception:`nCode: " code "`nName: " name "`nMessage:`n" e.message)
			failed++
		}
	}
	LogMessage("Subscriptions complete.`nSubscribed:" subbed "`nFailed: " failed)
	HotkeysEnabled := 1
	return

BlockChanged:
	Gui, Submit, NoHide
	if (HotkeysEnabled){
		for code, wootingKey in Wooting.WootingKeys {
			wootingKey.SetBlock(BlockHotkeys)
		}
	}
	return

ClearAnalogData:
	Gui, ListView, % hAnalogData
	LV_Delete()
	return

ClearLog:
	GuiControl, , % hLog, % ""
	return

GuiClose:
	ExitApp

InputEvent(code, name, isDigital, state){
	global Wooting, hAnalogData, hLog
	Gui, ListView, % hAnalogData
	row := LV_Add(, name, code, (isDigital ? "AHK Hotkey" : "Analog API") , state)
	if (isDigital){
		if (state){
			try {
				Wooting.SetKeyRgb(code, 255, 0, 0)
			} catch e {
				LogMessage("SetKeyRgb Exception:`nName: " name "`nMessage`n:" e.message)
			}
		} else {
			try {
				Wooting.ResetKeyRgb(code)
			} catch e {
				LogMessage("ResetKeyRgb exception:`nName: " name "`nMessage:`n" e.message)
			}
		}
	}
	LV_Modify(row, "Vis")
}

LogMessage(str){
	global hLog
	str := RegExReplace(str, "\n", "`r`n") "`r`n====================`r`n"
	AppendText(hLog, &str)
}

GetRowCol(code){
	global Wooting
	try {
		return Wooting.GetKeyRowColFromScanCode(code)
	} catch e {
		LogMessage("GetKeyRowColFromScanCode exception:`nCode: " code "`nMessage:`n" e.message)
	}
}

AppendText(hEdit, ptrText) {
    SendMessage, 0x000E, 0, 0,, ahk_id %hEdit% ;WM_GETTEXTLENGTH
    SendMessage, 0x00B1, ErrorLevel, ErrorLevel,, ahk_id %hEdit% ;EM_SETSEL
    SendMessage, 0x00C2, False, ptrText,, ahk_id %hEdit% ;EM_REPLACESEL
}

GetKeySCs(){
	names := {}
	keys := []
	Loop 512 {
		i := A_Index
		if (i == 84)	; ignore PrintScreen on 84, use 311
			continue
		code := Format("{:x}", i)
		n := GetKeyName("sc" code)
		if (n == "" || names.HasKey(n))
			continue
		names[n] := 1
		keys.Push({SC: i, Name: n})
	}
	return keys
}