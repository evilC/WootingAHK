class AllKeyBinder{
	__New(callback, pfx := "~*"){
		keys := {}
		this.Callback := callback
		Loop 512 {
			i := A_Index
			if (i == 84)	; ignore PrintScreen on 84, use 311
				continue
			code := Format("{:x}", i)
			n := GetKeyName("sc" code)
			
			keys[n] := code
			
			fn := this.KeyEvent.Bind(this, i, n, 1)
			hotkey, % pfx "sc" code, % fn, On
			
			fn := this.KeyEvent.Bind(this, i, n, 0)
			hotkey, % pfx "sc" code " up", % fn, On		
		}
	}
	
	KeyEvent(code, name, state){
		this.Callback.Call(code, name, state)
	}
}
