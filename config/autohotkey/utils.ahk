LOWORD(dword) {
    return dword & 0xffff
}

FormatGUID(bufferPtr) {
    data1 := NumGet(bufferPtr, 0, "UInt")
    data2 := NumGet(bufferPtr, 4, "UShort")
    data3 := NumGet(bufferPtr, 6, "UShort")
    return Format("{:08X}-{:04X}-{:04X}-{:02X}{:02X}-{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}",
        data1, data2, data3,
        NumGet(bufferPtr + 8 + 0, "UChar"),
        NumGet(bufferPtr + 8 + 1, "UChar"),
        NumGet(bufferPtr + 8 + 2, "UChar"),
        NumGet(bufferPtr + 8 + 3, "UChar"),
        NumGet(bufferPtr + 8 + 4, "UChar"),
        NumGet(bufferPtr + 8 + 5, "UChar"),
        NumGet(bufferPtr + 8 + 6, "UChar"),
        NumGet(bufferPtr + 8 + 7, "UChar")
    )
}

StringToBinaryGUID(stringGuid) {
    ; Validate GUID format
    if !RegExMatch(stringGuid, "^{[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}}$")
        throw Error("Invalid GUID format")

    ; Remove the curly braces
    stringGuid := SubStr(stringGuid, 2, -1)

    ; Split the string based on the GUID structure
    parts := StrSplit(stringGuid, "-")

    ; Allocate a binary buffer of 16 bytes
    binaryGuid := Buffer(16)

    ; Convert each pair of hexadecimal characters into bytes
    NumPut("UInt", Integer("0x" parts[1]), binaryGuid)
    NumPut("UShort", Integer("0x" parts[2]), binaryGuid, 4)
    NumPut("UShort", Integer("0x" parts[3]), binaryGuid, 6)
    remaining := parts[4] . parts[5]
    Loop 8 {
        byte := SubStr(remaining, (A_Index - 1) * 2 + 1, 2)
        NumPut("UChar", Integer("0x" byte), binaryGuid, 8 + A_Index - 1)
    }
    return binaryGuid
}
