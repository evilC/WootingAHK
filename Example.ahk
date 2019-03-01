#include Lib\WootingWrapper.AHK

Wooting := new WootingWrapper()

last := A_TickCount
keyWatcher := Wooting.SubscribeKey(GetKeySC("A")	; Subscribe to the A key - use the Scan Code
		, Func("AxisChanged") 						; Call the Function "AxisChanged" when it changes
		, "ahk_class Notepad")						; Key Blocking is only active in Notepad

GoSub, ToggleBlock						; Turn on blocking
return

; Toggle disabling of key, even if in Notepad
F1::
ToggleBlock:
	keyWatcher.ToggleBlock()			; Toggle blocking
	if (keyWatcher.Blocked){
		Wooting.SetKeyRgb(GetKeySC("F1"), 255, 0, 0)	; Turn F1 Red to indicate key is disabled
	} else {
		Wooting.SetKeyRgb(GetKeySC("F1"), 0, 255, 0)	; Turn F1 Green to indicate key is enabled
	}
	return

; Called and passed analog value when key changes state
AxisChanged(value){
	static threshold := 100
	static oldVal := 0
	static lastEvent := "NONE"
	Global Wooting
	if (oldVal == 0 && value){
		; Press
		lastEvent := "INITIAL PRESS"
	}
	if (oldval < threshold && value >= threshold){
		; Press past 50 %
		lastEvent := "PRESS PAST THRESH"
	} else if (oldval >= threshold && value < threshold){
		; Release past 50 %
		lastEvent := "RELEASE PAST THRESH"
	}
	if (oldVal && value == 0){
		; Full release
		lastEvent := "FULL RELEASE"
	}
	ToolTip % "Axis Changed. Old Value: " oldVal ", New Value: " value ", Last Event: " lastEvent
	
	oldVal := value
}

^Esc::
	Wooting.Dispose()	; Reset RGB
	ExitApp
