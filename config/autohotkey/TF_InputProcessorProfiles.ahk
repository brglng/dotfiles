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

#include "TF_LANGUAGEPROFILE.ahk"
#include "IEnumTfLanguageProfiles.ahk"

class TF_InputProcessorProfiles {
    static CLSID := "{33C53A50-F456-4884-B049-85FD643ECFED}"
    static IID := "{1F02B6C5-7842-4EE6-8A0B-9A24183A95CA}"

    static __new() {
        proto := this.Prototype
        proto.ActivateLanguageProfile := ComCall.Bind(3 + 7)
        proto.GetActiveLanguageProfile := ComCall.Bind(3 + 8)
        ; proto.GetLanguageProfileDescription := ComCall.Bind(3 + 9)
        proto.GetCurrentLanguage := ComCall.Bind(3 + 10)
        proto.ChangeCurrentLanguage := ComCall.Bind(3 + 11)
        proto.GetLanguageList := ComCall.Bind(3 + 12)
        ; proto.EnumLanguageProfiles := ComCall.Bind(3 + 13)
        ; proto.IsLanguageProfileEnabled := ComCall.Bind(3 + 15)
    }

    __new() {
        this.comObj := ComObject(TF_InputProcessorProfiles.CLSID, TF_InputProcessorProfiles.IID)
        this.ptr := this.comObj.ptr
    }

    EnumLanguageProfiles(langid) {
        ; HRESULT EnumLanguageProfiles(
        ;     [in]  LANGID                  langid,
        ;     [out] IEnumTfLanguageProfiles **ppEnum
        ; );
        enumProfiles := 0
        ComCall(3 + 13, this.comObj, "ushort", langid, "ptr*", &enumProfiles)
        return IEnumTfLanguageProfiles(enumProfiles)
    }

    IsLanguageProfileEnabled(profile) {
        ; HRESULT IsEnabledLanguageProfile(
        ;     [in]  REFCLSID rclsid,
        ;     [in]  LANGID   langid,
        ;     [in]  REFGUID  guidProfile,
        ;     [out] BOOL     *pfEnable
        ; );
        enabled := 0
        ComCall(3 + 15, this.comObj,
                "ptr", profile.pclsid,
                "ushort", profile.langid(),
                "ptr", profile.pGuidProfile,
                "int*", &enabled)
        return enabled
    }

    GetLanguageProfileDescription(profile) {
        ; HRESULT GetLanguageProfileDescription(
        ;     [in]  REFCLSID rclsid,
        ;     [in]  LANGID   langid,
        ;     [in]  REFGUID  guidProfile,
        ;     [out] BSTR     *pbstrProfile
        ; );
        bstrProfile := ""
        ComCall(3 + 9, this.comObj,
                "ptr", profile.pclsid,
                "ushort", profile.langid(),
                "ptr", profile.pGuidProfile,
                "Str*", &bstrProfile)
        return bstrProfile
    }
}

GetEnabledInputMethods() {
    hKLCount :=  DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
    if (hKLCount = 0)
        return []

    layoutList := Buffer(hKLCount * A_PtrSize, 0)
    DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

    profiles := TF_InputProcessorProfiles()

    loop hKLCount {
        layoutID := NumGet(layoutList, A_PtrSize * (A_Index - 1), "uint")
        langid := LOWORD(layoutID)

        enumProfiles := profiles.EnumLanguageProfiles(langid)

        profile := TF_LANGUAGEPROFILE()
        while enumProfiles.Next(1, profile) {
            if profiles.IsLanguageProfileEnabled(profile) {
                profileDesc := profiles.GetLanguageProfileDescription(profile)
                Msgbox Format("{:04X}n{}n{}n", profile.langid(), profile.strGuid(), profileDesc)
            }
        }
    }
}
