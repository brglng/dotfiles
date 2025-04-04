#DllLoad "Imm32"

WM_INPUTLANGCHANGEREQUEST := 0x50
IACE_CHILDREN := 1
IACE_DEFAULT := 16
IACE_IGNORENOCONTEXT := 32

; https://www.autohotkey.com/boards/viewtopic.php?t=84140
class Imm32 {
    static EN_US := 0x04090409

    __new() {
        ; Get a handle for Imm32\ImmGetDefaultIMEWnd function to be used later in a getCurrentKeyboardLayout function
        ; Faster performance by looking up the function's address beforehand lexikos.github.io/v2/docs/commands/DllCall.htm. Invoke: DllCall(getDefIMEWnd, "Ptr",fgWin)
        ; HWND ImmGetDefaultIMEWnd(HWND Arg1) docs.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetdefaultimewnd
        this.pImmGetDefaultIMEWnd := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str","Imm32", "Ptr"), "AStr", "ImmGetDefaultIMEWnd", "Ptr")
        this.pGetForegroundWindow := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str","Imm32", "Ptr"), "AStr", "GetForegroundWindow", "Ptr")
        this.pImmAssociateContextEx := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str","Imm32", "Ptr"), "AStr", "ImmAssociateContextEx", "Ptr")

        this.prevKeyboardLayout := this.getCurrentKeyboardLayout()
        if this.prevKeyboardLayout := Imm32.EN_US {
            this.prevKeyboardLayout := this.getFirstNonEnglishKeyboardLayout()
        }
        this.hImcOld := DllCall("Imm32\ImmGetContext", "Ptr", WinExist("A"))
    }

    ImmGetDefaultIMEWnd(hWnd) {
        return DllCall(this.pImmGetDefaultIMEWnd, "Ptr", hWnd)
    }

    enableIME() {
        hwnd := WinExist("A")
        if this.hImcOld != 0 {
            DllCall("Imm32\ImmAssociateContextEx", "Ptr", hwnd, "Ptr", 0, "UInt", this.hImcOld)
        }
        Tooltip("IME enabled")
    }

    disableIME() {
        hwnd := WinExist("A")
        this.hImcOld := DllCall("Imm32\ImmGetContext", "Ptr", hwnd)
        DllCall("Imm32\ImmAssociateContextEx", "Ptr", hwnd, "Ptr", 0, "UInt", 0)
        Tooltip("IME disabled")
    }

    toggleIME() {
        hwnd := WinExist("A")
        hImc := DllCall("Imm32\ImmGetContext", "Ptr", hwnd)
        if hImc == 0 {
            if this.hImcOld != 0 {
                DllCall("Imm32\ImmAssociateContextEx", "Ptr", hwnd, "Ptr", 0, "UInt", this.hImcOld)
                Tooltip("IME enabled")
            }
        } else {
            this.hImcOld := hImc
            DllCall("Imm32\ImmAssociateContextEx", "Ptr", hwnd, "Ptr", 0, "UInt", 0)
            Tooltip("IME disabled")
        }
    }

    getCurrentKeyboardLayout() {
        ; Get handle (HWND) to the foreground window
        ; docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getforegroundwindow
        fgWnd := DllCall("GetForegroundWindow")
        if WinActive("ahk_class ConsoleWindoClass") {
            ; Foreground window is a console winow
            imeWnd := this.ImmGetDefaultIMEWnd(fgWnd)
            if imeWnd == 0 {
                return Imm32.EN_US
            } else {
                fgWnd := imeWnd
            }
        } else if WinActive("ahk_class vguiPopupWindow") or WinActive("ahk_class ApplicationFrameWindow") {
            ; Steam, some UWP apps, get layout from a keyboard focused control since can't read it from a regular window
            ; autohotkey.com/boards/viewtopic.php?f=76&t=69414
            focused := ControlGetFocus("A")
            if focused == 0 {
                return Imm32.EN_US
            } else {
                fgWnd := ControlGetHwnd(focused, "A")
            }
        }
        ; DWORD GetWindowThreadProcessId(HWND hWnd, LPDWORD lpdwProcessId)
        ; docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowthreadprocessid
        threadID := DllCall("GetWindowThreadProcessId", "Ptr", fgWnd, "Ptr", 0)
        layoutID := DllCall("GetKeyboardLayout", "UInt", threadID)
        return layoutID
    }

    setKeyboardLayout(targetLayout) {
        if this.getCurrentKeyboardLayout() != targetLayout {
            ; Active window to PostMessage to, needs to be changed for '#32770' class (dialog window)
            targetWin := "A"
            if WinActive("ahk_class #32770") {
                ; Retrieves which control of the target window has keyboard focus, if any.
                ; autohotkey.com/boards/viewtopic.php?p=233011
                targetWin := ControlGetFocus("A")
            }
            PostMessage WM_INPUTLANGCHANGEREQUEST, 0, targetLayout, , targetWin
        }
    }

    getFirstNonEnglishKeyboardLayout() {
        hKLCount := DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
        if hKLCount == 0 {
            return Imm32.EN_US
        }

        layoutList := Buffer(hKLCount * A_PtrSize, 0)
        DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

        loop hKLCount {
            offset := A_PtrSize * (A_Index - 1)
            layoutID := NumGet(layoutList, offset, "UInt")
            ; MsgBox Format("hKLCount: {}, A_Index: {}, offset: {}, layoutID: {:X}", hKLCount, A_Index, offset, layoutID)
            if layoutID != Imm32.EN_US {
                return layoutID
            }
        }

        return Imm32.EN_US
    }

    toggleKeyboardLayout() {
        currentLayout := this.getCurrentKeyboardLayout()
        if currentLayout == Imm32.EN_US {
            this.setKeyboardLayout(this.prevKeyboardLayout)
        } else {
            this.prevKeyboardLayout := currentLayout
            this.setKeyboardLayout(Imm32.EN_US)
        }
    }
}
