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
	
	AddKey(scanCode, callback){
		kwr := new this.WootingKey(this, scanCode, callback)
		return kwr
	}
	
	SetKeyRgb(scanCode, red, green, blue){
		this.Instance.SetKeyRgb(scanCode, red, green, blue)
	}
	
	ResetKeyRgb(scanCode){
		this.Instance.ResetKeyRgb(scanCode)
	}
	
	GetKeyRowColFromScanCode(scanCode){
		return this.Instance.GetKeyRowColFromScanCode(scanCode)
	}
	
	Dispose(){
		this.Instance.Dispose()
	}
	
	class WootingKey {
		DigitalState := 0
		Blocked := 0
		HotkeyEnabled := 0
		WinTitle := ""
		HotkeyStrings := {0: "", 1: ""}
		
		__New(parent, scanCode, callback){
			this.Parent := parent
			this.KeyName := GetKeyName("SC" Format("{:x}", scanCode))
			this.ScanCode := scanCode
			this.Callback := callback
			this.Instance := this.Parent.Instance.SubscribeAnalog(this.ScanCode, callback)
		}
		
		SetBlock(state){
			this.Blocked := state
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		ToggleBlock(){
			this.SetBlock(!this.Blocked)
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		SetWinTitle(title){
			this.WinTitle := winTitle
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		Init(){
			this._SetHotkeyState(true)
			return this
		}
		
		_ResetHotkeyIfNeeded(){
			if (this.HotkeyEnabled){
				this._SetHotkeyState(true)
			}
		}
		
		_SetHotkeyState(state){
			if (this.WinTitle != ""){
				;~ this.Debug("Setting context to " this.WinTitle)
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
			this.HotkeyEnabled := state
		}
		
		_DigitalStateChange(state){
			if (this.DigitalState == state)
				return
			;~ this.Debug("Digital State: " state)
			this.DigitalState := state
			this.Callback.Call(true, state)
		}
		
		Debug(str){
			OutputDebug % "AHK| " str
		}
	}
}
