class ModTapManager {
    __new(modMap, tapTimeout := 200) {
        this.modMap := Map(
            "LShift", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "RShift", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "LControl", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "RControl", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "LAlt", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "RAlt", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "LWin", {
                key: "",
                isDown: false,
                downTime: 0
            },
            "RWin", {
                key: "",
                isDown: false,
                downTime: 0
            }
        )
        this.keyToModMap := Map()
        for modKey, alternateKey in modMap {
            if alternateKey != "" {
                this.modMap[modKey].key := alternateKey
                this.keyToModMap[alternateKey] := modKey
            }
        }
    }

    onModKeyDown(modKey) {
        if this.modMap[modKey].downTime = 0 {
            this.modMap[modKey].downTime := A_TickCount
        }
        Send "{" modKey " down}"
    }

    onModKeyUp(modKey, onTap := "") {
        if A_TickCount - this.modMap[modKey].downTime < 200 and A_PriorKey = modKey {
            if onTap != "" {
                onTap()
            }
        }
        Send "{" modKey " up}"
        this.modMap[modKey].downTime := 0
        if this.modMap[modKey].isDown {
            this.modMap[modKey].isDown := false
        }
    }

    onAlternateModUp(alternateKey, allowedAlternateMods) {
        for alternateKey in allowedAlternateMods {
            modKey := this.keyToModMap[alternateKey]
            if GetKeyState(alternateKey, "P") and not this.modMap[modKey].isDown {
                this.modMap[modKey].isDown := true
                Send "{" modKey " down}"
            }
        }
        modKey := this.keyToModMap[alternateKey]
        if this.modMap[modKey].isDown {
            Send "{" modKey " up}"
            this.modMap[modKey].isDown := false
        } else {
            if strlen(alternateKey) > 1 {
                Send "{" alternateKey "}"
            } else {
                Send alternateKey
            }
        }
    }

    onOtherKey(otherKey, allowedAlternateMods) {
        for alternateKey in allowedAlternateMods {
            modKey := this.keyToModMap[alternateKey]
            if GetKeyState(alternateKey, "P") and not this.modMap[modKey].isDown {
                this.modMap[modKey].isDown := true
                Send "{" modKey " down}"
            }
        }
        if strlen(otherKey) > 1 {
            Send "{" otherKey "}"
        } else {
            Send otherKey
        }
    }
}
