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
            "LShift", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "RShift", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "LControl", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "RControl", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "LAlt", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "RAlt", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "LWin", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 },
            "RWin", { extraMod: "", tapTimeout: 200, downTime: 0, upTime: 0 }
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
                modTimeout: extraModProps.hasOwnProp("modTimeout") ? extraModProps.modTimeout : 50,
                modTapTimeout: extraModProps.hasOwnProp("modTapTimeout") ? extraModProps.modTapTimeout : 200,
                repeatTimeout: extraModProps.hasOwnProp("repeatTimeout") ? extraModProps.repeatTimeout : 70,
                downTime: 0,
                upTime: 0,
                repeating: false,
                isAnyModDown: false,
            }
        }
        this.otherKeyMap := Map()
        this.sentKeys := ""
    }

    onModKeyDown(modKey) {
        Critical "On"
        if this.modMap[modKey].downTime == 0 {
            this.modMap[modKey].downTime := A_TickCount
        }
        this.sendKey(modKey, "down", "onModKeyDown: " modKey)
        Critical "Off"
    }

    onModKeyUp(modKey, onTap := "") {
        Critical "On"
        if A_PriorKey = modKey and A_TickCount - this.modMap[modKey].downTime < this.modMap[modKey].tapTimeout {
            if onTap != "" {
                onTap()
            }
        }
        this.sendKey(modKey, "up", "onModKeyUp: " modKey)
        this.modMap[modKey].downTime := 0
        this.modMap[modKey].upTime := A_TickCount
        Critical "Off"
    }

    onExtraMod(extraMod, allowedOtherExtraMods) {
        Critical "On"
        if this.extraModMap[extraMod].downTime == 0 {
            this.extraModMap[extraMod].downTime := A_TickCount
        }
        for modKey, modProps in this.modMap {
            if GetKeyState(modKey, "P") {
                this.extraModMap[extraMod].isAnyModDown := true
                this.sendKey(extraMod, "down", "onExtraMod 1: " extraMod)
                break
            }
        }
        if not this.extraModMap[extraMod].isAnyModDown {
            if this.extraModMap[extraMod].repeating == true {
                this.sendKey(extraMod, , "onExtraMod 2: " extraMod)
            } else {
                if A_PriorKey = extraMod
                    and A_TickCount - this.extraModMap[extraMod].upTime < this.extraModMap[extraMod].repeatTimeout {
                    this.extraModMap[extraMod].repeating := true
                }
                if not this.extraModMap[extraMod].repeating {
                    for otherExtraMod in allowedOtherExtraMods {
                        modKey := this.extraModMap[otherExtraMod].modKey
                        if GetKeyState(otherExtraMod, "P") and not GetKeyState(modKey)
                            and A_TickCount - this.extraModMap[otherExtraMod].downTime > this.extraModMap[extraMod].modTimeout {
                            this.sendKey(modKey, "down" , "onExtraMod 3: " extraMod)
                        }
                    }
                } else {
                    this.sendKey(extraMod, , "onExtraMod 4: " extraMod)
                }
            }
        }
        Critical "Off"
    }

    onExtraModUp(extraMod) {
        Critical "On"
        if this.extraModMap[extraMod].isAnyModDown {
            this.sendKey(extraMod, "up", "onExtraModUp 1: " extraMod)
        } else {
            modKey := this.extraModMap[extraMod].modKey
            if GetKeyState(modKey) and not GetKeyState(modKey, "P") {
                this.sendKey(modKey, "up", "onExtraModUp 2: " extraMod)
            } else {
                if not this.extraModMap[extraMod].repeating and A_PriorKey = extraMod {
                    if A_TickCount - this.extraModMap[extraMod].downTime > this.extraModMap[extraMod].modTapTimeout {
                        this.sendKey(modKey, "down", "onExtraModUp 3: " extraMod)
                        this.sendKey(modKey, "up", "onExtraModUp 4: " extraMod)
                    } else {
                        this.sendKey(extraMod, , "onExtraModUp 5: " extraMod)
                    }
                }
            }
        }
        this.extraModMap[extraMod].downTime := 0
        this.extraModMap[extraMod].upTime := A_TickCount
        this.extraModMap[extraMod].repeating := false
        this.extraModMap[extraMod].isAnyModDown := false
        Critical "Off"
    }

    onOtherKey(otherKey, allowedExtraMods) {
        Critical "On"
        if not this.otherKeyMap.has(otherKey) {
            this.otherKeyMap[otherKey] := {
                repeating: false,
                extraModsDown: [],
                downTime: A_TickCount,
                upTime: 0
            }
        }
        if this.otherKeyMap[otherKey].repeating {
            this.sendKey(otherKey, "down", "onOtherKey 1: " otherKey)
        } else {
            isAnyModDown := false
            for modKey, modProps in this.modMap {
                if GetKeyState(modKey, "P") {
                    isAnyModDown := true
                    break
                }
                if modProps.extraMod = ""
                    continue
                extraMod := modProps.extraMod
                if ArrayHasElement(allowedExtraMods, extraMod) and GetKeyState(extraMod, "P") {
                    this.otherKeyMap[otherKey].extraModsDown.push(extraMod)
                } else {
                    if GetKeyState(extraMod, "P") {
                        this.sendKey(extraMod, , "onOtherKey 2: " otherKey)
                    }
                    this.extraModMap[extraMod].repeating := false
                }
            }
            if A_PriorKey = otherKey and this.otherKeyMap[otherKey].downTime > this.otherKeyMap[otherKey].upTime {
                this.otherKeyMap[otherKey].repeating := true
                for extraMod in this.otherKeyMap[otherKey].extraModsDown {
                    modKey := this.extraModMap[extraMod].modKey
                    if GetKeyState(extraMod, "P") and not GetKeyState(modKey)
                        and A_TickCount - this.extraModMap[extraMod].downTime > this.extraModMap[extraMod].modTimeout {
                        this.sendKey(modKey, "down", "onOtherKey 3: " otherKey)
                    }
                }
                this.otherKeyMap[otherKey].extraModsDown := []
                this.sendKey(otherKey, "down", "onOtherKey 4: " otherKey)
                this.sendKey(otherKey, "down", "onOtherKey 5: " otherKey)
            } else {
                if isAnyModDown or this.otherKeyMap[otherKey].extraModsDown.length == 0 {
                    this.sendKey(otherKey, , "onOtherKey 6: " otherKey)
                }
            }
        }
        this.otherKeyMap[otherKey].downTime := A_TickCount
        Critical "Off"
    }

    onOtherKeyUp(otherKey) {
        Critical "On"
        if not this.otherKeyMap[otherKey].repeating {
            for extraMod in this.otherKeyMap[otherKey].extraModsDown {
                modKey := this.extraModMap[extraMod].modKey
                if GetKeyState(extraMod, "P") {
                    if not GetKeyState(modKey) {
                        if A_TickCount - this.extraModMap[extraMod].downTime > this.extraModMap[extraMod].modTimeout {
                            this.sendKey(modKey, "down", "onOtherKeyUp 1: " otherKey)
                        } else {
                            this.sendKey(extraMod, , "onOtherKeyUp 2: " otherKey)
                        }
                    }
                } else {
                    this.sendKey(extraMod, , "onOtherKeyUp 3: " otherKey)
                }
            }
            if this.otherKeyMap[otherKey].extraModsDown.length != 0 {
                this.sendKey(otherKey, , "onOtherKeyUp 4: " otherKey)
            }
        } else {
            this.sendKey(otherKey, "up", "onOtherKeyUp 5: " otherKey)
        }
        this.otherKeyMap[otherKey].extraModsDown := []
        this.otherKeyMap[otherKey].repeating := false
        this.otherKeyMap[otherKey].upTime := A_TickCount
        Critical "Off"
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
