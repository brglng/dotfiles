class KeyboardLayoutManager {
    static EN_US := 0x04090409
    static WM_INPUTLANGCHANGEREQUEST := 0x50

    __new() {
        this.prevKeyboardLayout := this.getCurrentKeyboardLayout()
        if this.prevKeyboardLayout := KeyboardLayoutManager.EN_US
            this.prevKeyboardLayout := this.getFirstNonEnglishKeyboardLayout()
    }

    getCurrentKeyboardLayout() {
        windowID := WinGetID("A")
        threadID := DllCall("GetWindowThreadProcessId", "UInt", windowID, "UInt", 0, "UInt")
        layoutID := DllCall("GetKeyboardLayout", "UInt", threadID, "UInt")
        return layoutID
    }

    setKeyboardLayout(targetLayout) {
        PostMessage KeyboardLayoutManager.WM_INPUTLANGCHANGEREQUEST, 0, targetLayout, , "A"
    }

    getFirstNonEnglishKeyboardLayout() {
        hKLCount := DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
        if (hKLCount = 0) {
            return KeyboardLayoutManager.EN_US
        }

        layoutList := Buffer(hKLCount * A_PtrSize, 0)
        DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

        loop hKLCount {
            offset := A_PtrSize * (A_Index - 1)
            layoutID := NumGet(layoutList, offset, "UInt")
            if layoutID != KeyboardLayoutManager.EN_US {
                return layoutID
            }
        }

        return KeyboardLayoutManager.EN_US
    }

    toggleKeyboardLayout() {
        currentLayout := this.GetCurrentKeyboardLayout()
        if currentLayout = KeyboardLayoutManager.EN_US {
            this.setKeyboardLayout(this.prevKeyboardLayout)
        } else {
            this.prevKeyboardLayout := currentLayout
            this.setKeyboardLayout(KeyboardLayoutManager.EN_US)
        }
    }
}
