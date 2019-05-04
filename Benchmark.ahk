/*
Tries to measure timing of Wooting API responses
Subscribes to a key using an AHK hotkey and a Wooting API subscription
Measures the time difference between each when you press the key
Calculations done when you release the key and not on first update of hotkey or analog API...
... as theoretically the API could respond before or after the hotkey
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
	if (value){
		MouseGetPos, x, y
		t := A_TickCount
		ToolTip % "Hotkey Pressed @ " t, x + 20, y-10, 1
		lastHotkeyTime := t
	}
}

; Called and passed analog value when key changes state
; value will be 0 for released, through to 255 for fully pressed
AxisChanged(value){
	global lastHotkeyTime
	static lastValue := -1
	static lastAxisTime := 0
	t := A_TickCount
	MouseGetPos, x, y
	if (lastValue == -1){
		lastAxisTime := t
	}
	if (value == 0 && lastValue > 0){
		elapsed := lastHotkeyTime - lastAxisTime
		if (elapsed >= 0)
			sgn := "+"
		ToolTip % "Axis Started Changing @ " lastAxisTime "(Hotkey " sgn elapsed ")", x + 20, y+10, 2
		lastValue := -1
	} else {
		ToolTip % "Axis Changed. Value: " value " @ " t, x + 20, y+30, 3
		lastValue := value
	}
}

^Esc::
	Wooting.Dispose()	; Reset RGB
	ExitApp
