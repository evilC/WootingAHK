#include %A_LineFile%\..\CLR.ahk

class WootingWrapper {
	WootingKeys := {}
	
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
	
	AddKey(scanCode){
		wk := new this.WootingKey(this, scanCode)
		this.WootingKeys[scanCode] := wk
		return wk
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
		_AnalogState := 0
		_DigitalState := 0
		_Blocked := 0
		_HotkeyEnabled := 0
		_WinTitle := ""
		_HotkeyStrings := {0: "", 1: ""}
		_AnalogCallback := 0
		_DigitalCallback := 0
		
		; ================ Public =================
		
		__New(parent, scanCode){
			this._Parent := parent
			this._KeyName := GetKeyName("SC" Format("{:x}", scanCode))
			this._ScanCode := scanCode
		}
		
		OnAnalog(callback := 0){
			this._AnalogCallback := callback
			this.Instance := this._Parent.Instance.SubscribeAnalog(this._ScanCode, this._AnalogStateChange.Bind(this))
			return this
		}
		
		OnDigital(callback := 0){
			this._DigitalCallback := callback
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		SetBlock(state){
			this._Blocked := state
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		ToggleBlock(){
			this.SetBlock(!this._Blocked)
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		SetWinTitle(winTitle){
			this._WinTitle := winTitle
			this._ResetHotkeyIfNeeded()
			return this
		}
		
		SetHotkey(state){
			this._SetHotkeyState(state)
			return this
		}
		
		SetRgb(red, green, blue){
			this._Parent.SetKeyRgb(this._ScanCode, red, green, blue)
		}
		
		_ResetHotkeyIfNeeded(){
			if (this._HotkeyEnabled){
				this._SetHotkeyState(true)
			}
		}
		
		Blocked(){
			return this._Blocked
		}
		
		HotkeyEnabled(){
			return this._HotkeyEnabled
		}
		
		AnalogState(){
			return this._AnalogState
		}
		
		DigitalState(){
			return this._DigitalState
		}
		
		; ================ Private =================
		
		_SetHotkeyState(state){
			if (this._WinTitle != ""){
				;~ this.Debug("Setting context to " this._WinTitle)
				hotkey, IfWinActive, % this._WinTitle
			}
			Loop 2 {
				i := A_Index - 1
				if (this._HotkeyStrings[i] != ""){
					Hotkey, % this._HotkeyStrings[i], Off
					this._HotkeyStrings[i] := ""
				}
			}
			if (state){
				blk := this._Blocked ? "" : "~"
				
				fn := this._DigitalStateChange.Bind(this, 1)
				str := blk "*$" this._KeyName
				this._HotkeyStrings[1] := str
				Hotkey, % str, % fn, On
				
				fn := this._DigitalStateChange.Bind(this, 0)
				str := blk "*$" this._KeyName " up"
				this._HotkeyStrings[0] := str
				Hotkey, % str, % fn, On
				hotkey, IfWinActive	; Turn off context-sensitve mode for further hotkeys
			}
			this._HotkeyEnabled := state
		}
		
		_AnalogStateChange(state){
			this._AnalogState := state
			if (this._AnalogCallback != 0)
				this._AnalogCallback.Call(state)
		}
		
		_DigitalStateChange(state){
			if (this._DigitalState == state)
				return
			;~ this.Debug("Digital State: " state)
			this._DigitalState := state
			if (this._DigitalCallback != 0)
				this._DigitalCallback.Call(state)
		}
		
		Debug(str){
			OutputDebug % "AHK| " str
		}
	}
}
