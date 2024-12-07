ArrayHasElement(arr, elem) {
    for e in arr {
        if e = elem {
            return true
        }
    }
    return false
}

class ModTapManager {
    __new(extraModMap, modMap := Map()) {
        this.modMap := Map(
            "LShift", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "RShift", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "LControl", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "RControl", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "LAlt", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "RAlt", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "LWin", { extraMod: "", tapTimeout: 200, downTime: 0 },
            "RWin", { extraMod: "", tapTimeout: 200, downTime: 0 }
        )
        this.extraModMap := Map()
        for modKey, modProps in modMap {
            if modProps.hasOwnProp("tapTimeout")
                this.modMap[modKey].tapTimeout := modProps.tapTimeout
        }
        for extraMod, extraModProps in extraModMap {
            this.modMap[extraModProps.modKey].extraMod := extraMod
            this.extraModMap[extraMod] := {
                modKey: extraModProps.modKey,
                modTimeout: extraModProps.hasOwnProp("modTimeout") ? extraModProps.modTimeout : 70,
                modTapTimeout: extraModProps.hasOwnProp("modTapTimeout") ? extraModProps.modTapTimeout : 300,
                repeatTimeout: extraModProps.hasOwnProp("repeatTimeout") ? extraModProps.repeatTimeout : 100,
                downTime: 0,
                upTime: 0,
                repeating: false,
                tapInOtherKey: false
            }
        }
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
        if A_PriorKey = modKey and A_TickCount - this.modMap[modKey].downTime < this.modMap[modKey].tapTimeout {
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
            this.sendKey(extraMod, , "1 extraMod: " extraMod)
        } else {
            if A_PriorKey = extraMod and A_TickCount - this.extraModMap[extraMod].upTime < this.extraModMap[extraMod].repeatTimeout {
                this.extraModMap[extraMod].repeating := true
            }
            if not this.extraModMap[extraMod].repeating {
                for extraMod in allowedExtraMods {
                    modKey := this.extraModMap[extraMod].modKey
                    if GetKeyState(extraMod, "P") and not GetKeyState(modKey) {
                        this.sendKey(modKey, "down" , "2 extraMod: " extraMod)
                    }
                }
            } else {
                this.sendKey(extraMod, , "3 extraMod: " extraMod)
            }
        }
        Critical "Off"
    }

    onExtraModUp(extraMod) {
        modKey := this.extraModMap[extraMod].modKey
        Critical "On"
        if GetKeyState(modKey) {
            this.sendKey(modKey, "up", "extraMod up: " extraMod)
        } else {
            if not this.extraModMap[extraMod].repeating {
                if A_TickCount - this.extraModMap[extraMod].downTime > this.extraModMap[extraMod].modTapTimeout {
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
            if ArrayHasElement(allowedExtraMods, extraMod) and not this.extraModMap[extraMod].repeating {
                if GetKeyState(extraMod, "P") and not GetKeyState(modKey) and
                    A_TickCount - this.extraModMap[extraMod].downTime > this.extraModMap[extraMod].modTimeout {
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
