class AllKeyBinder{
	__New(callback, pfx := "~*"){
		keys := {}
		this.Callback := callback
		Loop 512 {
			i := A_Index
			code := Format("{:x}", i)
			n := GetKeyName("sc" code)
			;~ str .= n "`n"
			if (!n || keys.HasKey(n))
				continue
			
			keys[n] := code
			
			fn := this.KeyEvent.Bind(this, i, n, 1)
			hotkey, % pfx "sc" code, % fn, On
			
			fn := this.KeyEvent.Bind(this, i, n, 0)
			hotkey, % pfx "sc" code " up", % fn, On		
		}
		;~ msgbox % str
	}
	
	KeyEvent(code, name, state){
		this.Callback.Call(code, name, state)
	}
}
