#include Lib\WootingWrapper.AHK
#include Lib\AllKeyBinder.AHK

fw := 400
infoText := "
(
When you click Start, an AHK hotkey for every key on the keyboard is activated
The first time you press each key, the script will attempt to Subscribe to 
the Analog API for that key

Then on any subsequent press, the Analog value for the key will be shown,
and an attempt willbe made to turn that key Red via the RGB API 

Any resulting errors will be shown in the log
Click Stop to turn off the hotkeys.
The analog subscriptions will remain but no new subscriptions will be made
)"
Gui, Add, Text, % "xm w" fw, % infoText
Gui, Add, Button, % "xm w" fw " gStartStop hwndhStartStop"
Gui, Add, ListView, % "xm w" fw " hwndhAnalogData", Name|Code|State
LV_ModifyCol(1, 100)
LV_ModifyCol(2, 50)
LV_ModifyCol(3, 50)
Gui, Add, Button, % "xm w" fw " gClearAnalogData", Clear Data
Gui, Add, Edit, % "xm w" fw " R15 hwndhLog"
Gui, Add, Button, % "xm w" fw " gClearLog", Clear Log
Gui, Show

SetStartStopState(0)
KeyWatchers := {}
Wooting := new WootingWrapper()

hotkey, if, HotkeysEnabled
kb := new AllKeyBinder(Func("KeyPressed"), "")
return

#if HotkeysEnabled ; Dummy block needed for hotkey, if
#If

StartStop:
	SetStartStopState(!HotkeysEnabled)
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

SetStartStopState(state){
	global HotkeysEnabled, hStartStop
	
	HotkeysEnabled := state
	GuiControl, , % hStartStop, % (state ? "Stop" : "Start")
}

KeyPressed(code, name, state){
	global Wooting, KeyWatchers, hLog
	static keyStates := {}
	;~ ToolTip % "Code: " code ", State: " state
	if (state && keyStates[code])
		return ; Filter key repeat
	keyStates[code] := state
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
	if (KeyWatchers.HasKey(code))
		return
	try {
		if (state){	;; Only subscribe on key press
			KeyWatchers[code] := Wooting.SubscribeKey(code		; Subscribe to the A key - use the AHK key name
				, Func("AxisChanged").Bind(code, name)) 			; Call the Function "AxisChanged" when it changes
			rowCol := GetRowCol(code)
			LogMessage("Subscribed to Key via API`nCode: " code ", Name: " name "`nRow: " rowCol.Row ", Column: " rowCol.Col )
		}
	} catch e {
		LogMessage("SubscribeKeyCode exception:`nCode: " code "`nName: " name "`nMessage:`n" e.message)
	}
}

AxisChanged(code, name, state){
	global hAnalogData, hLog
	;~ ToolTip % "Code: " code ", Name: " name ", State: " state
	Gui, ListView, % hAnalogData
	row := LV_Add(, name, code, state)
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