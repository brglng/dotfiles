class IMEManager {
    EN_US := "0409-{00000000-0000-0000-0000-000000000000}"

    __new() {
        this.prevIME := this.getCurrentIME()
        if this.prevIME == this.EN_US {
            this.prevIME := "0804-{82B1D863-86B6-8B98-B8FF-A585BD0F186F}"
        }
    }

    getCurrentIME() {
        tempFilePath := A_Temp . "\im-control-output-" . A_TickCount . ".txt"
        try {
            RunWait("im-control.exe -o " . tempFilePath, , "Hide")
            output := FileRead(tempFilePath)
            output := RTrim(output, "`r`n")
            FileDelete(tempFilePath)
            return output
        }
    }
    
    switchToIME(key) {
        Run("im-control.exe " key " -k open", , "Hide")
    }
    
    toggleIME() {
        ; currentIME := this.getCurrentIME()
        ; if (currentIME == this.EN_US) {
        ;     targetIME := this.prevIME
        ; } else {
        ;     this.prevIME := currentIME
        ;     targetIME := this.EN_US
        ; }
        ; this.switchToIME(targetIME)
        try {
            tempFilePath := A_Temp . "\im-control-output-" . A_TickCount . ".txt"
            RunWait("im-control.exe " . this.prevIME . " --if " . this.EN_US . " --else " . this.EN_US . " -o " . tempFilePath, , "Hide")
            output := FileRead(tempFilePath)
            output := RTrim(output, "`r`n")
            FileDelete(tempFilePath)
            this.prevIME := output
        }
    }
}
