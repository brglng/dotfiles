ArrayHasElement(arr, elem) {
    for e in arr {
        if e = elem {
            return true
        }
    }
    return false
}

class ModTapManager {
    __new(extraModMap, modMap := Map(), logging := false) {
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
                modTimeout: extraModProps.hasOwnProp("modTimeout") ? extraModProps.modTimeout : 0,
                modTapTimeout: extraModProps.hasOwnProp("modTapTimeout") ? extraModProps.modTapTimeout : 200,
                repeatTimeout: extraModProps.hasOwnProp("repeatTimeout") ? extraModProps.repeatTimeout : 80,
                downTime: 0,
                upTime: 0,
                repeating: false,
            }
        }
        this.otherKeyMap := Map()
        this.logging := logging
        this.keyQueue := []
        this.sentKeys := ""
    }

    addTooltip(msg) {
        if this.logging {
            this.sentKeys := this.sentKeys "`n" msg
            Tooltip this.sentKeys
        }
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
        this.addTooltip(msg ": sent " key " " state)
    }

    isKeyQueued(key) {
        for k in this.keyQueue {
            if k = key {
                return true
            }
        }
        return false
    }

    isAnyKeyQueued(keys) {
        for key in keys {
            if this.isKeyQueued(key) {
                return true
            }
        }
        return false
    }

    isAnyModDown() {
        for modKey, modProps in this.modMap {
            if GetKeyState(modKey, "P") {
                return true
            }
        }
        return false
    }

    isAnyKeyDown(keys) {
        for key in keys {
            if GetKeyState(key, "P") {
                return true
            }
        }
        return false
    }

    onModKeyDown(modKey) {
        Critical "On"
        if this.modMap[modKey].downTime == 0 {
            this.modMap[modKey].downTime := A_TickCount
        }
        Critical "Off"
    }

    onModKeyUp(modKey, onTap := "") {
        Critical "On"
        if A_PriorKey = modKey and onTap != "" {
            if A_TickCount - this.modMap[modKey].downTime < this.modMap[modKey].tapTimeout {
                onTap()
            } else {
                if not GetKeyState(modKey) {
                    this.sendKey(modKey, "down", "onModKeyDown(" modKey ")")
                }
                this.sendKey(modKey, "up", "onModKeyUp(" modKey ")")
            }
        }
        this.modMap[modKey].downTime := 0
        this.modMap[modKey].upTime := A_TickCount
        Critical "Off"
    }

    logQueue(msg := "") {
        txt := "[ "
        for key in this.keyQueue {
            txt := txt key " "
        }
        txt := txt "]"
        this.addTooltip(msg ": keyQueue: " txt)
    }

    onExtraMod(extraMod) {
        Critical "On"
        for modKey, modProps in this.modMap {
            if GetKeyState(modKey, "P") {
                this.sendKey(modKey, "down", "onExtraMod(" extraMod ") 0")
            }
        }
        for otherExtraMod, otherExtraModProps in this.extraModMap {
            if otherExtraMod != extraMod {
                otherExtraModProps.repeating := false
            }
        }
        for otherKey, otherKeyProps in this.otherKeyMap {
            otherKeyProps.repeating := false
        }

        if this.extraModMap[extraMod].repeating {
            this.sendKey(extraMod, , "onExtraMod(" extraMod ") 1")
        } else {
            if this.extraModMap[extraMod].downTime == 0 {
                this.extraModMap[extraMod].downTime := A_TickCount
                if this.isAnyModDown() {
                    this.sendKey(extraMod, "down", "onExtraMod(" extraMod ") 2")
                } else {
                    if A_PriorKey = extraMod and A_TickCount - this.extraModMap[extraMod].upTime <= this.extraModMap[extraMod].repeatTimeout {
                        this.sendKey(extraMod, , "onExtraMod(" extraMod ") 3")
                        this.extraModMap[extraMod].repeating := true
                    } else {
                        this.keyQueue.push(extraMod)
                        this.logQueue("onExtraMod(" extraMod ") 4")
                    }
                }
            }
        }
        Critical "Off"
    }

    onExtraModUp(extraMod, allowedOtherExtraMods) {
        Critical "On"
        if not this.extraModMap[extraMod].repeating 
            and this.keyQueue.length > 0 and this.keyQueue[this.keyQueue.length] == extraMod
        {
            modsSent := []
            for key in this.keyQueue {
                if ArrayHasElement(allowedOtherExtraMods, key) {
                    modKey := this.extraModMap[key].modKey
                    if GetKeyState(key, "P") {
                        if not GetKeyState(modKey) and A_TickCount - this.extraModMap[key].downTime >= this.extraModMap[key].modTimeout {
                            this.sendKey(modKey, "down", "onExtraModUp(" extraMod ") 1")
                            modsSent.push(modKey)
                        } else {
                            this.sendKey(key, , "onExtraModUp(" extraMod ") 2")
                        }
                    } else {
                        this.sendKey(key, , "onExtraModUp(" extraMod ") 3")
                    }
                } else if key = extraMod and A_TickCount - this.extraModMap[key].downTime >= this.extraModMap[key].modTapTimeout {
                    modKey := this.extraModMap[key].modKey
                    this.sendKey(modKey, "down", "onExtraModUp(" extraMod ") 4")
                    this.sendKey(modKey, "up", "onExtraModUp(" extraMod ") 5")
                } else {
                    this.sendKey(key, , "onExtraModUp(" extraMod ") 6")
                }

            }
            this.keyQueue := []
            while modsSent.length > 0 {
                modKey := modsSent.pop()
                if not GetKeyState(this.modMap[modKey].extraMod, "P") {
                    this.sendKey(modKey, "up", "onExtraModUp(" extraMod ") 7")
                }
            }
        }
        if GetKeyState(this.extraModMap[extraMod].modKey) and not GetKeyState(this.extraModMap[extraMod].modKey, "P") {
            this.sendKey(this.extraModMap[extraMod].modKey, "up", "onExtraModUp(" extraMod ") 8")
        }
        this.extraModMap[extraMod].downTime := 0
        this.extraModMap[extraMod].upTime := A_TickCount
        this.extraModMap[extraMod].repeating := false
        Critical "Off"
    }

    onOtherKey(otherKey, allowedExtraMods) {
        Critical "On"
        if not this.otherKeyMap.has(otherKey) {
            this.otherKeyMap[otherKey] := {
                handleUpEvent: true,
                repeating: false
            }
        }

        for modKey, modProps in this.modMap {
            if GetKeyState(modKey, "P") {
                this.sendKey(modKey, "down", "onOtherKey(" extraMod ") 0")
            }
        }
        for extraMod, extraModProps in this.extraModMap {
            extraModProps.repeating := false
        }
        for otherOtherKey, otherOtherKeyProps in this.otherKeyMap {
            if otherOtherKey != otherKey {
                otherOtherKeyProps.repeating := false
            }
        }

        if this.isAnyModDown() {
            this.sendKey(otherKey, , "onOtherKey(" otherKey ") 1")
            this.otherKeyMap[otherKey].handleUpEvent := true
        } else if this.otherKeyMap[otherKey].repeating or this.keyQueue.length > 0
            and this.keyQueue[this.keyQueue.length] = otherKey
        {
            for key in this.keyQueue {
                if ArrayHasElement(allowedExtraMods, key) {
                    modKey := this.extraModMap[key].modKey
                    if GetKeyState(key, "P") {
                        if not GetKeyState(modKey)
                            and A_TickCount - this.extraModMap[key].downTime >= this.extraModMap[key].modTimeout
                        {
                            this.sendKey(modKey, "down", "onOtherKey(" otherKey ") 2")
                        } else {
                            this.sendKey(key, , "onOtherKey(" otherKey ") 3")
                        }
                    } else {
                        this.sendKey(key, , "onOtherKey(" otherKey ") 4")
                    }
                } else {
                    this.sendKey(key, , "onOtherKey(" otherKey ") 5")
                }
            }
            this.sendKey(otherKey, , "onOtherKey(" otherKey ") 6")
            this.keyQueue := []
            this.otherKeyMap[otherKey].repeating := true
            this.otherKeyMap[otherKey].handleUpEvent := false
        } else if this.isAnyKeyQueued(allowedExtraMods) {
            this.keyQueue.push(otherKey)
            this.logQueue("onOtherKey(" otherKey ") 7")
            this.otherKeyMap[otherKey].handleUpEvent := true
        } else {
            for key in this.keyQueue {
                this.sendKey(key, , "onOtherKey(" otherKey ") 8")
            }
            this.keyQueue := []
            this.sendKey(otherKey, , "onOtherKey(" otherKey ") 9")
            this.otherKeyMap[otherKey].handleUpEvent := false
        }
        Critical "Off"
    }

    onOtherKeyUp(otherKey, allowedExtraMods) {
        Critical "On"
        if not this.otherKeyMap.has(otherKey) {
            this.otherKeyMap[otherKey] := {
                handleUpEvent: false,
                repeating: false
            }
        }
        if this.otherKeyMap[otherKey].handleUpEvent {
            modsSent := []
            for key in this.keyQueue {
                if ArrayHasElement(allowedExtraMods, key) {
                    modKey := this.extraModMap[key].modKey
                    if GetKeyState(key, "P") {
                        if not GetKeyState(modKey)
                            and A_TickCount - this.extraModMap[key].downTime >= this.extraModMap[key].modTimeout
                        {
                            this.sendKey(modKey, "down", "onOtherKeyUp(" otherKey ") 1")
                            modsSent.push(modKey)
                        } else {
                            this.sendKey(key, , "onOtherKeyUp(" otherKey ") 2")
                        }
                    } else {
                        this.sendKey(key, , "onOtherKeyUp(" otherKey ") 3")
                    }
                } else {
                    this.sendKey(key, , "onOtherKeyUp(" otherKey ") 4")
                }
            }
            while modsSent.length > 0 {
                modKey := modsSent.pop()
                if not GetKeyState(this.modMap[modKey].extraMod, "P") {
                    this.sendKey(modKey, "up", "onOtherKeyUp(" otherKey ") 5")
                }
            }
            this.keyQueue := []
        }
        this.otherKeyMap[otherKey].repeating := false
        this.otherKeyMap[otherKey].handleUpEvent := true
        Critical "Off"
    }
}
