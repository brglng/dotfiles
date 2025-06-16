#include "IMM32.ahk"
#include "TSF.ahk"

EN_US := TF_INPUTPROCESSORPROFILE()
EN_US.dwProfileType := TF_PROFILETYPE_KEYBOARDLAYOUT
EN_US.langid := 0x0409
EN_US.strClsid := GUID_NULL_STR
EN_US.strGUIDProfile := GUID_NULL_STR
EN_US.strCatid := GUID_TFCAT_TIP_KEYBOARD_STR
EN_US.hklSubstitute := 0
EN_US.dwCaps := 0
EN_US.hkl := 0x04090409
EN_US.dwFlags := TF_IPP_FLAG_ENABLED

class IMEManager {
    __new() {
        ; this.threadMgr := ITfThreadMgr(CLSID_TF_ThreadMgr)
        ; this.langMgr := ITfInputProcessorProfiles(CLSID_TF_InputProcessorProfiles)
        this.tipMgr := ITfInputProcessorProfileMgr(CLSID_TF_InputProcessorProfiles)
        ; this.documentMgr := this.threadMgr.CreateDocumentMgr()
        ; this.threadMgr.SetFocus(this.documentMgr)
        ; retCreateContext := this.documentMgr.CreateContext(this.threadMgr.tid, 0, 0)
        ; this.context := retCreateContext[1]
        ; this.textStore := retCreateContext[2]
        ; this.documentMgr.Push(this.context)
        ; this.compartmentMgr := this.context.getCompartmentMgr()
        ; this.compartmentMgr := this.threadMgr.getCompartmentMgr()

        this.imeHelper := Gui("+AlwaysOnTop -Caption +Disabled +ToolWindow")
        this.imeHelper.BackColor := "FFFFFF"
        this.imeHelper.Opt("+Owner" WinExist("A"))
        this.imeHelper.Show("w1 h1 x-1 y-1 NoActivate")

        this.prevIME := this.getCurrentIME()
        if this.prevIME.langid == EN_US.langid {
            this.prevIME := this.getFirstChineseIME()
        }
    }

    getCurrentIME() {
        return this.tipMgr.GetActiveProfile(GUID_TFCAT_TIP_KEYBOARD)
    }
    
    switchToIME(profile) {
        this.tipMgr.ActivateProfile(profile.dwProfileType,
                                    profile.langid,
                                    profile.clsid,
                                    profile.guidProfile,
                                    profile.hkl,
                                    TF_IPPMF_FORPROCESS | TF_IPPMF_DONTCARECURRENTINPUTLANGUAGE)
    }
    
    getFirstChineseIME() {
        hKLCount :=  DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
        if (hKLCount = 0)
            return EN_US
    
        layoutList := Buffer(hKLCount * A_PtrSize, 0)
        DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)
    
        loop hKLCount {
            layoutID := NumGet(layoutList, A_PtrSize * (A_Index - 1), "uint")
            langid := LOWORD(layoutID)
    
            enumProfiles := this.tipMgr.EnumProfiles(langid)
    
            profile := TF_INPUTPROCESSORPROFILE()
            while enumProfiles.Next(1, profile) {
                if profile.strCatid == GUID_TFCAT_TIP_KEYBOARD_STR
                    and (profile.dwFlags & TF_IPP_FLAG_ENABLED)
                    and profile.langid == LANGID_ZH_CN
                {
                    return profile
                }
            }
        }
    
        return EN_US
    }

    toggleIME() {
        currentWin := WinExist("A")
        ; hasCaret := CaretGetPos(&x, &y)
        this.imeHelper.Opt("+Owner" currentWin)
        WinActivate this.imeHelper.hWnd
        currentIME := this.getCurrentIME()
        if (currentIME.langid == EN_US.langid) {
            targetIME := this.prevIME
        } else {
            this.prevIME := currentIME
            targetIME := EN_US
        }
        ; if targetIME.dwProfileType == TF_PROFILETYPE_INPUTPROCESSOR {
        ;     textControl := this.imeHelper.AddText("w100 h30 x6 y3", this.langMgr.GetLanguageProfileDescription(targetIME.clsid, targetIME.langid, targetIME.guidProfile))
        ;     textControl.SetFont("s12", "Segoe UI")
        ; }
        ; startTime := A_TickCount
        ; if hasCaret {
        ;     this.imeHelper.Show("w100 h30 x" x " y" y + 15)
        ; } else {
        ;     this.imeHelper.Show("w100 h30 x" A_ScreenWidth / 2 - 15 " y" A_ScreenHeight / 2 - 15)
        ; }
        WinActivate this.imeHelper.hWnd
        this.switchToIME(targetIME)
        if currentWin != "" {
            WinActivate currentWin
        }
        ; if A_TickCount - startTime < 500 {
        ;     Sleep 500 - (A_TickCount - startTime)
        ; }
    }
}

test() {
    hKLCount :=  DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
    if (hKLCount = 0)
        return []

    layoutList := Buffer(hKLCount * A_PtrSize, 0)
    DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

    tipMgr := ITfInputProcessorProfileMgr(CLSID_TF_InputProcessorProfiles)
    threadMgr := ITfThreadMgr(CLSID_TF_ThreadMgr)
    ; compartmentMgr := context.getCompartmentMgr()
    compartmentMgr := threadMgr.getCompartmentMgr()

    loop hKLCount {
        layoutID := NumGet(layoutList, A_PtrSize * (A_Index - 1), "uint")
        langid := LOWORD(layoutID)

        enumProfiles := tipMgr.EnumProfiles(langid)

        profile := TF_INPUTPROCESSORPROFILE()
        while enumProfiles.Next(1, profile) {
            if profile.strCatid == GUID_TFCAT_TIP_KEYBOARD_STR and (profile.dwFlags & TF_IPP_FLAG_ENABLED) {
                if langid == 0x0409 {
                    Tooltip Format("dwProfileType: 0x{:08X}`n"
                                   "langid: 0x{:04X}`n"
                                   "clsid: {}`n"
                                   "guidProfile: {}`n"
                                   "catid: {}`n"
                                   "hklSubstitute: 0x{:08X}`n"
                                   "dwCaps: 0x{:08X}`n"
                                   "hkl: 0x{:016X}`n"
                                   "dwFlags: 0x{:08X}`n",
                                   profile.dwProfileType,
                                   profile.langid,
                                   profile.strClsid,
                                   profile.strGUIDProfile,
                                   profile.strCatid,
                                   profile.hklSubstitute,
                                   profile.dwCaps,
                                   profile.hkl,
                                   profile.dwFlags)

                    ; tipMgr.ActivateProfile(profile.dwProfileType(),
                    ;                            profile.langid(),
                    ;                            pclsid,
                    ;                            pguidProfile,
                    ;                            hkl,
                    ;                            TF_IPPMF_FORPROCESS | TF_IPPMF_FORSESSION | TF_IPPMF_FORSYSTEMALL | TF_IPPMF_DONTCARECURRENTINPUTLANGUAGE)

                    openStatus := SendMessage(WM_IME_CONTROL, IMC_GETOPENSTATUS, 0, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))
                    ; openStatus := openStatus ^ IME_CMODE_NATIVE
                    ; SendMessage(WM_IME_CONTROL, IMC_SETOPENSTATUS, openStatus, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))
                    ; openStatus := SendMessage(WM_IME_CONTROL, IMC_GETOPENSTATUS, 0, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))

                    ; convMode := SendMessage(WM_IME_CONTROL, IMC_GETCONVERSIONMODE, 0, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))
                    ; convMode := convMode ^ IME_CMODE_NATIVE
                    ; SendMessage(WM_IME_CONTROL, IMC_SETCONVERSIONMODE, convMode, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))
                    convMode := SendMessage(WM_IME_CONTROL, IMC_GETCONVERSIONMODE, 0, DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", WinExist("A"), "Uint"))

                    keyboardDisabledCompartment := compartmentMgr.GetCompartment(GUID_COMPARTMENT_KEYBOARD_DISABLED)
                    varKeyboardDisabled := keyboardDisabledCompartment.GetValue()
                    ; keyboardDisabled := varKeyboardDisabled.vt == VT_EMPTY ? 0 : varKeyboardDisabled.lVal
                    ; keyboardDisabled := keyboardDisabled ^ 0x1
                    ; varKeyboardDisabled.lVal := keyboardDisabled
                    ; keyboardDisabledCompartment.SetValue(threadMgr.tid, varKeyboardDisabled)
                    ; varKeyboardDisabled := keyboardDisabledCompartment.GetValue()

                    keyboardOpenCloseCompartment := compartmentMgr.GetCompartment(GUID_COMPARTMENT_KEYBOARD_OPENCLOSE)
                    varKeyboardOpenClose := keyboardOpenCloseCompartment.GetValue()
                    ; keyboardOpenClose := varKeyboardOpenClose.vt == VT_EMPTY ? 0 : varKeyboardOpenClose.lVal
                    ; keyboardOpenClose := keyboardOpenClose ^ 0x1
                    ; varKeyboardOpenClose.lVal := keyboardOpenClose
                    ; keyboardOpenCloseCompartment.SetValue(threadMgr.tid, varKeyboardOpenClose)
                    ; varKeyboardOpenClose := keyboardOpenCloseCompartment.GetValue()

                    keyboardInputModeConversionCompartment := compartmentMgr.GetCompartment(GUID_COMPARTMENT_KEYBOARD_INPUTMODE_CONVERSION)
                    varKeyboardInputModeConversion := keyboardInputModeConversionCompartment.GetValue()
                    ; keyboardInputModeConversion := varKeyboardInputModeConversion.vt == VT_EMPTY ? 0 : varKeyboardInputModeConversion.lVal
                    ; keyboardInputModeConversion := keyboardInputModeConversion ^ IME_CMODE_NATIVE
                    ; varKeyboardInputModeConversion.lVal := keyboardInputModeConversion
                    ; keyboardInputModeConversionCompartment.SetValue(threadMgr.tid, varKeyboardInputModeConversion)
                    ; varKeyboardInputModeConversion := keyboardInputModeConversionCompartment.GetValue()

                    keyboardInputModeSentenceCompartment := compartmentMgr.GetCompartment(GUID_COMPARTMENT_KEYBOARD_INPUTMODE_SENTENCE)
                    varKeyboardInputModeSentence := keyboardInputModeSentenceCompartment.GetValue()

                    keyboardDisabled := varKeyboardDisabled.vt == VT_EMPTY ? 0xdeadbeef : varKeyboardDisabled.lVal
                    keyboardOpenClose := varKeyboardOpenClose.vt == VT_EMPTY ? 0xdeadbeef : varKeyboardOpenClose.lVal
                    keyboardInputModeConversion := varKeyboardInputModeConversion.vt == VT_EMPTY ? 0xdeadbeef : varKeyboardInputModeConversion.lVal
                    keyboardInputModeSentence := varKeyboardInputModeSentence.vt == VT_EMPTY ? 0xdeadbeef : varKeyboardInputModeSentence.lVal
                    ; Tooltip Format("openStatus: {:d}`n"
                    ;                "convMode: 0x{:08X}`n"
                    ;                "keyboardDisabled: 0x{:08X}`n"
                    ;                "keyboardOpenClose: 0x{:08X}`n"
                    ;                "keyboardInputModeConversion: 0x{:08X}`n"
                    ;                "keyboardInputModeSentence: 0x{:08X}`n",
                    ;                openStatus,
                    ;                convMode,
                    ;                keyboardDisabled,
                    ;                keyboardOpenClose,
                    ;                keyboardInputModeConversion,
                    ;                keyboardInputModeSentence)
                    break
                }
            }
        }
    }
}
; test()
