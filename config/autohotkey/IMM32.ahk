#DllLoad "IMM32"

WM_INPUTLANGCHANGEREQUEST := 0x50
WM_IME_CONTROL := 0x283

IMC_GETCONVERSIONMODE := 0x0001
IMC_SETCONVERSIONMODE := 0x0002
IMC_SETOPENSTATUS := 0x0005
IMC_GETOPENSTATUS := 0x0005

IME_CMODE_ALPHANUMERIC := 0x0000
IME_CMODE_NATIVE       := 0x0001
IME_CMODE_CHINESE      := IME_CMODE_NATIVE
IME_CMODE_HANGUL       := IME_CMODE_NATIVE
IME_CMODE_JAPANESE     := IME_CMODE_NATIVE
IME_CMODE_KATAKANA     := 0x0002 ;only effect under IME_CMODE_NATIVE
IME_CMODE_LANGUAGE     := 0x0003
IME_CMODE_FULLSHAPE    := 0x0008
IME_CMODE_ROMAN        := 0x0010
IME_CMODE_CHARCODE     := 0x0020
IME_CMODE_HANJACONVERT := 0x0040
IME_CMODE_NATIVESYMBOL := 0x0080

IACE_CHILDREN := 1
IACE_DEFAULT := 16
IACE_IGNORENOCONTEXT := 32

ImmGetDefaultIMEWnd(hWnd) {
    ; HWND ImmGetDefaultIMEWnd(HWND Arg1) docs.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetdefaultimewnd
    ; Faster performance by looking up the function's address beforehand lexikos.github.io/v2/docs/commands/DllCall.htm. Invoke: DllCall(getDefIMEWnd, "Ptr",fgWin)
    static addr := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str","Imm32", "Ptr"), "AStr", "ImmGetDefaultIMEWnd", "Ptr")
    return DllCall(addr, "Ptr", hWnd)
}

