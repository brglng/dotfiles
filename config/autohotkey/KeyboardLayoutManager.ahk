#include "utils.ahk"
#include "IMM32.ahk"
#include "User32.ahk"

; https://www.autohotkey.com/boards/viewtopic.php?t=84140
class KeyboardLayoutManager {
    __new() {
        this.prevKeyboardLayout := this.getCurrentKeyboardLayout()
        if this.prevKeyboardLayout := LANGID_EN_US {
            this.prevKeyboardLayout := this.getFirstNonEnglishKeyboardLayout()
        }
    }

    getCurrentKeyboardLayout() {
        ; Get handle (HWND) to the foreground window
        ; docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getforegroundwindow
        fgWnd := GetForegroundWindow()
        if WinActive("ahk_class ConsoleWindoClass") {
            ; Foreground window is a console winow
            imeWnd := ImmGetDefaultIMEWnd(fgWnd)
            if imeWnd == 0 {
                return LANGID_EN_US
            } else {
                fgWnd := imeWnd
            }
        } else if WinActive("ahk_class vguiPopupWindow") or WinActive("ahk_class ApplicationFrameWindow") {
            ; Steam, some UWP apps, get layout from a keyboard focused control since can't read it from a regular window
            ; autohotkey.com/boards/viewtopic.php?f=76&t=69414
            focused := ControlGetFocus("A")
            if focused == 0 {
                return LANGID_EN_US
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

    switchToKeyboardLayout(targetLayout) {
        if this.getCurrentKeyboardLayout() != targetLayout {
            ; Active window to SendMessage to, needs to be changed for '#32770' class (dialog window)
            targetWin := "A"
            if WinActive("ahk_class #32770") {
                ; Retrieves which control of the target window has keyboard focus, if any.
                ; autohotkey.com/boards/viewtopic.php?p=233011
                targetWin := ControlGetFocus("A")
            }
            ; PostMessage WM_INPUTLANGCHANGEREQUEST, 0, targetLayout, , targetWin
            SendMessage WM_INPUTLANGCHANGEREQUEST, 0, targetLayout, , 0xffff
        }
    }

    getFirstZHCNKeyboardLayout() {
        hKLCount := DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
        if hKLCount == 0 {
            return LANGID_EN_US
        }

        layoutList := Buffer(hKLCount * A_PtrSize, 0)
        DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

        loop hKLCount {
            offset := A_PtrSize * (A_Index - 1)
            layoutID := NumGet(layoutList, offset, "UInt") & 0xffff
            ; MsgBox Format("hKLCount: {}, A_Index: {}, offset: {}, layoutID: {:X}", hKLCount, A_Index, offset, layoutID)
            if layoutID == LANGID_ZH_CN {
                return layoutID
            }
        }

        return LANGID_EN_US
    }

    toggleKeyboardLayout() {
        currentLayout := this.getCurrentKeyboardLayout()
        if currentLayout == LANGID_EN_US {
            this.switchToKeyboardLayout(this.prevKeyboardLayout)
        } else {
            this.prevKeyboardLayout := currentLayout
            this.switchToKeyboardLayout(LANGID_EN_US)
        }
    }
}
