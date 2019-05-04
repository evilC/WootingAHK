/*
Simplest example of using the wooting wrapper for input only
Demos Analog and Digital input, and how to create WootingKeys
*/
#include Lib\WootingAHK.AHK

; Start up the WootingAHK library
Wooting := new WootingAHK()

; Create a wrapper for the "A" key
wootingKey := Wooting.AddKey(GetKeySC("A"))			; Create a WootingKey for the A key using the Scan Code
		.OnAnalog(Func("AxisChanged"))				; (Optional) Call the Function "AxisChanged" and pass it Analog value
		.OnDigital(Func("HotkeyChanged"))			; (Optional) Call the Function "HotkeyChanged" and pass it Digital value
		.SetBlock(true)								; (Optional) Enable blocking for the hotkey
		;.SetWinTitle("ahk_class Notepad")			; (Optional) Only enable the hotkey in Notepad
		.SetHotkey(true)							; (Optional) Turn on the hotkey
return

; Called and passed digital value when key changes state
; value will be 1 for pressed, 0 for released
HotkeyChanged(value){
	global lastHotkeyTime
	MouseGetPos, x, y
	t := A_TickCount
	ToolTip % "Hotkey Changed. Value: " value " @ " t, x + 20, y-10, 1
	if (value){
		lastHotkeyTime := t
	}
}

; Called and passed analog value when key changes state
; value will be 0 for released, through to 255 for fully pressed
AxisChanged(value){
	global lastHotkeyTime
	static lastValue := -1
	t := A_TickCount
	MouseGetPos, x, y
	if (lastValue == -1){
		ToolTip % "Axis Started Changing @ " t "(Hotkey + " t - lastHotkeyTime ")", x + 20, y+10, 2
	} else {
		ToolTip % "Axis Changed. Value: " value " @ " t, x + 20, y+30, 3
	}
	if (value == 0){
		lastValue := -1
	} else {
		lastValue := value
	}
}

^Esc::
	Wooting.Dispose()	; Reset RGB
	ExitApp
