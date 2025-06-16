S_OK := 0
S_FALSE := 1

LOWORD(dword) {
    return dword & 0xffff
}

guidToStr(guid) {
    data1 := NumGet(guid, 0, "UInt")
    data2 := NumGet(guid, 4, "UShort")
    data3 := NumGet(guid, 6, "UShort")
    return Format("{{}{:08X}-{:04X}-{:04X}-{:02X}{:02X}-{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}{}}",
        data1, data2, data3,
        NumGet(guid + 8 + 0, "UChar"),
        NumGet(guid + 8 + 1, "UChar"),
        NumGet(guid + 8 + 2, "UChar"),
        NumGet(guid + 8 + 3, "UChar"),
        NumGet(guid + 8 + 4, "UChar"),
        NumGet(guid + 8 + 5, "UChar"),
        NumGet(guid + 8 + 6, "UChar"),
        NumGet(guid + 8 + 7, "UChar")
    )
}

guidFromStr(guid, strGUID) {
    ; Validate GUID format
    if !regExMatch(strGUID, "^{[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}}$")
        throw Error("Invalid GUID format")

    ; Remove the curly braces
    strGUID := subStr(strGUID, 2, -1)

    ; Split the string based on the GUID structure
    parts := strSplit(strGUID, "-")

    ; Convert each pair of hexadecimal characters into bytes
    numPut("UInt", Integer("0x" parts[1]), guid)
    numPut("UShort", Integer("0x" parts[2]), guid, 4)
    numPut("UShort", Integer("0x" parts[3]), guid, 6)
    remaining := parts[4] . parts[5]
    Loop 8 {
        byte := subStr(remaining, (A_Index - 1) * 2 + 1, 2)
        numPut("UChar", Integer("0x" byte), guid, 8 + A_Index - 1)
    }
    return guid
}

strToGUID(strGUID) {
    ; Allocate a binary guid of 16 bytes
    guid := Buffer(16)
    guidFromStr(guid, strGUID)
    return guid
}

GUID_NULL_STR := "{00000000-0000-0000-0000-000000000000}"
GUID_NULL := strToGUID(GUID_NULL_STR)
CLSID_NULL_STR := GUID_NULL_STR
CLSID_NULL := GUID_NULL

LANGID_EN_US := 0x0409
LANGID_ZH_CN := 0x0804
