#include Lib\WootingWrapper.AHK

KeyWatchers := {}
Wooting := new WootingWrapper()
list := Wooting.Instance.GetScanCodeList()

for i in list {
	code := Format("{:x}", i)
	name := GetKeyName("SC" code)
	fn := Func("KeyPressed").Bind(i, name, 1)
	hotkey, % "~SC" code, % fn
	fn := Func("KeyPressed").Bind(i, name, 0)
	hotkey, % "~SC" code " up", % fn
}

return

KeyPressed(code, name, state){
	global Wooting, KeyWatchers
	static keyStates := {}
	;~ ToolTip % "Code: " code ", State: " state
	if (state && keyStates[code])
		return
	keyStates[code] := state
	if (keyStates[1] == 1 && keyStates[2] == 1){	; Hold Esc and 1 to exit
		ExitApp
	}
	if (state){
		Wooting.SetKeyRgb(name, 255, 0, 0)
	} else {
		Wooting.ResetKeyRgb(name)
	}
	if (KeyWatchers.HasKey(code))
		return
	KeyWatchers[code] := Wooting.SubscribeKeyCode(code		; Subscribe to the A key - use the AHK key name
		, Func("AxisChanged").Bind(code, name)) 					; Call the Function "AxisChanged" when it changes
}

AxisChanged(code, name, state){
	ToolTip % "Code: " code ", Name: " name ", State: " state
}

;~ ^Esc::
	;~ ExitApp