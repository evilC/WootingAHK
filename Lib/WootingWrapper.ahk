#include %A_LineFile%\..\CLR.ahk

class WootingWrapper {
	__New(){
		dllName := "WootingAHK.dll"
		dllFile := A_LineFile "\..\" dllName
		asm := CLR_LoadLibrary(dllFile)
		try {
			this.Instance := asm.CreateInstance("WootingAHK.WootingWrapper")
		}
		catch {
			MsgBox % dllName " failed to load`n`n" hintMessage
			ExitApp
		}
		if (this.Instance.OkCheck() != "OK"){
			MsgBox % dllName " loaded but check failed!`n`n" hintMessage
			ExitApp
		}
	}
	
	SubscribeKeyCode(keyCode, callback, wintitle := ""){
		kwr := new this.KeyWatcherWrapper(this, keyCode, callback, wintitle)
		return kwr
	}
	
	SubscribeKey(keyName, callback, wintitle := ""){
		keyCode := GetKeySC(keyName)
		kwr := new this.KeyWatcherWrapper(this, keyCode, callback, wintitle)
		return kwr
	}
	
	SetKeyRgb(keyName, red, green, blue){
		scanCode := GetKeySc(keyName)
		this.Instance.SetKeyRgb(scanCode, red, green, blue)
	}
	
	ResetKeyRgb(keyName){
		scanCode := GetKeySc(keyName)
		this.Instance.ResetKeyRgb(scanCode)
	}
	
	GetKeyRowColFromScanCode(code){
		return this.Instance.GetKeyRowColFromScanCode(code)
	}
	
	Dispose(){
		this.Instance.Dispose()
	}
	
	class KeyWatcherWrapper {
		AnalogState := 0
		DigitalState := 0
		Blocked := 0
		HotkeyStrings := {0: "", 1: ""}
		__New(parent, keyCode, callback, wintitle := ""){
			this.Parent := parent
			this.KeyName := GetKeyName("SC" Format("{:x}", keyCode))
			this.KeyCode := keyCode
			this.Callback := callback
			this.WinTitle := wintitle
			this.Instance := this.Parent.Instance.SubscribeKey(this.KeyCode, callback)
			;~ this.Instance := this.Parent.Instance.SubscribeKey(this.KeyCode, this._AnalogStateChange.Bind(this))
			this._SetHotkeyState(true)
		}
		
		SetBlock(state){
			this.Blocked := state
			this._SetHotkeyState(true)
			return this
		}
		
		ToggleBlock(){
			this.SetBlock(!this.Blocked)
		}
		
		_SetHotkeyState(state){
			if (this.WinTitle != ""){
				this.Debug("Setting context to " this.WinTitle)
				hotkey, IfWinActive, % this.WinTitle
			}
			Loop 2 {
				i := A_Index - 1
				if (this.HotKeyStrings[i] != ""){
					Hotkey, % this.HotKeyStrings[i], Off
					this.HotKeyStrings[i] := ""
				}
			}
			if (state){
				blk := this.Blocked ? "" : "~"
				
				fn := this._DigitalStateChange.Bind(this, 1)
				str := blk "*$" this.KeyName
				this.HotkeyStrings[1] := str
				Hotkey, % str, % fn, On
				
				fn := this._DigitalStateChange.Bind(this, 0)
				str := blk "*$" this.KeyName " up"
				this.HotkeyStrings[0] := str
				Hotkey, % str, % fn, On
				hotkey, IfWinActive	; Turn off context-sensitve mode for further hotkeys
			}
		}
		
		_DigitalStateChange(state){
			if (this.DigitalState == state)
				return
			;~ this.Debug("Digital State: " state)
			this.DigitalState := state
			;~ this.Callback.Call(state) ; Disabled - use analog only for now
		}
		
		/*
		_AnalogStateChange(state){
			if (this.AnalogState == state)
				return
			;~ this.Debug("Analog State: " state)
			this.AnalogState := state
			this.Callback.Call(1, state)
		}
		*/
		
		Debug(str){
			OutputDebug % "AHK| " str
		}
	}
}
