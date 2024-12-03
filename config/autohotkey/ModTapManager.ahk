arrayHasElement(arr, elem) {
    for e in arr {
        if e = elem {
            return true
        }
    }
    return false
}

class ModTapManager {
    __new(modMap, modTapTimeout := 200, tapModTimeout := 150, repeatTimeout := 100) {
        this.modMap := Map(
            "LShift", { extraMod: "", downTime: 0 },
            "RShift", { extraMod: "", downTime: 0 },
            "LControl", { extraMod: "", downTime: 0 },
            "RControl", { extraMod: "", downTime: 0 },
            "LAlt", { extraMod: "", downTime: 0 },
            "RAlt", { extraMod: "", downTime: 0 },
            "LWin", { extraMod: "", downTime: 0 },
            "RWin", { extraMod: "", downTime: 0 }
        )
        this.extraModMap := Map()
        for modKey, extraMod in modMap {
            if extraMod != "" {
                this.modMap[modKey].extraMod := extraMod
                this.extraModMap[extraMod] := { modKey: modKey, downTime: 0, upTime: 0, repeating: false, tapInOtherKey: false }
            }
        }
        this.modTapTimeout := modTapTimeout
        this.tapModTimeout := tapModTimeout
        this.repeatTimeout := repeatTimeout
        ; this.sentKeys := ""
    }

    onModKeyDown(modKey) {
        Critical "On"
        if this.modMap[modKey].downTime = 0 {
            this.modMap[modKey].downTime := A_TickCount
        }
        this.sendKey(modKey, "down", "mod down: " modKey)
        Critical "Off"
    }

    onModKeyUp(modKey, onTap := "") {
        Critical "On"
        if A_PriorKey = modKey and A_TickCount - this.modMap[modKey].downTime < this.modTapTimeout {
            if onTap != "" {
                onTap()
            }
        }
        this.sendKey(modKey, "up", "mod up: " modKey)
        this.modMap[modKey].downTime := 0
        Critical "Off"
    }

    onExtraMod(extraMod, allowedExtraMods) {
        Critical "On"
        if this.extraModMap[extraMod].downTime = 0 {
            this.extraModMap[extraMod].downTime := A_TickCount
        }
        if this.extraModMap[extraMod].repeating = true {
            this.sendKey(extraMod, , "extraMod: " extraMod)
        } else {
            if A_PriorKey = extraMod and A_TickCount - this.extraModMap[extraMod].upTime < this.repeatTimeout {
                this.extraModMap[extraMod].repeating := true
            }
            if not this.extraModMap[extraMod].repeating {
                for extraMod in allowedExtraMods {
                    modKey := this.extraModMap[extraMod].modKey
                    if GetKeyState(extraMod, "P") and not GetKeyState(modKey) {
                        this.sendKey(modKey, "down" , "extraMod: " extraMod)
                    }
                }
            } else {
                this.sendKey(extraMod, , "extraMod: " extraMod)
            }
        }
        Critical "Off"
    }

    onExtraModUp(extraMod) {
        modKey := this.extraModMap[extraMod].modKey
        Critical "On"
        if not this.extraModMap[extraMod].repeating {
            if GetKeyState(modKey) {
                this.sendKey(modKey, "up", "extraMod up: " extraMod)
            } else {
                if A_TickCount - this.extraModMap[extraMod].downTime > this.tapModTimeout {
                    this.sendKey(modKey, "down")
                    this.sendKey(modKey, "up")
                } else {
                    if not this.extraModMap[extraMod].tapInOtherKey {
                        this.sendKey(extraMod, , "extraMod up: " extraMod)
                    }
                    this.extraModMap[extraMod].tapInOtherKey := false
                }
            }
        }
        this.extraModMap[extraMod].downTime := 0
        this.extraModMap[extraMod].upTime := A_TickCount
        this.extraModMap[extraMod].repeating := false
        Critical "Off"
    }

    onOtherKey(otherKey, allowedExtraMods) {
        for modKey, modProps in this.modMap {
            if modProps.extraMod = ""
                continue
            extraMod := modProps.extraMod
            Critical "On"
            if arrayHasElement(allowedExtraMods, extraMod) and not this.extraModMap[extraMod].repeating {
                if GetKeyState(extraMod, "P") and not GetKeyState(modKey) and
                    A_TickCount - this.extraModMap[extraMod].downTime > this.tapModTimeout {
                    this.sendKey(modKey, "down", "otherKey: " otherKey)
                }
            } else {
                if GetKeyState(extraMod, "P") and not this.extraModMap[extraMod].tapInOtherKey {
                    this.extraModMap[extraMod].tapInOtherKey := true
                    this.sendKey(extraMod, , "otherKey: " otherKey)
                }
                this.extraModMap[extraMod].repeating := false
            }
            Critical "Off"
        }
        this.sendKey(otherKey)
    }

    sendKey(key, state := "", msg := "") {
        if state != "" {
            Send "{" key " " state "}"
        } else {
            if strlen(key) > 1 {
                Send "{" key "}"
            } else {
                Send key
            }
        }

        ; this.sentKeys := this.sentKeys "`n" key " " state " " msg
        ; Tooltip this.sentKeys
    }
}
