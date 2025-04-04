#include "TF_LANGUAGEPROFILE.ahk"
#include "IEnumTfLanguageProfiles.ahk"
#include "utils.ahk"

class ActiveLanguageProfile {
    __new(langid, guidProfile) {
        this.langid := langid
        this.guidProfile := guidProfile
    }

    strGuidProfile() {
        return FormatGUID(this.guidProfile.ptr)
    }
}

CLSID_TF_InputProcessorProfiles := "{33C53A50-F456-4884-B049-85FD643ECFED}"

class ITfInputProcessorProfiles {
    static IID := "{1F02B6C5-7842-4EE6-8A0B-9A24183A95CA}"

    static __new() {
        proto := this.Prototype
        proto.ActivateLanguageProfile := ComCall.Bind(3 + 7)
        ; proto.GetActiveLanguageProfile := ComCall.Bind(3 + 8)
        ; proto.GetLanguageProfileDescription := ComCall.Bind(3 + 9)
        proto.GetCurrentLanguage := ComCall.Bind(3 + 10)
        proto.ChangeCurrentLanguage := ComCall.Bind(3 + 11)
        proto.GetLanguageList := ComCall.Bind(3 + 12)
        ; proto.EnumLanguageProfiles := ComCall.Bind(3 + 13)
        ; proto.IsLanguageProfileEnabled := ComCall.Bind(3 + 15)
    }

    __new(clsid) {
        this.comObj := ComObject(clsid, ITfInputProcessorProfiles.IID)
        this.ptr := this.comObj.ptr
    }

    GetActiveLanguageProfile(clsid) {
        ; HRESULT GetActiveLanguageProfile([in] REFCLSID rclsid, 
        ;                                  [out] LANGID *plangid, 
        ;                                  [out] GUID *pguidProfile);
        binaryClsid := StringToBinaryGUID(clsid)
        langid := 0
        guidProfile := Buffer(16)
        if (result := ComCall(3 + 8, this.comObj, "ptr", binaryClsid, "ushort*", &langid, "ptr", guidProfile)) != 0 {
            throw Error(Format("ITfInputProcessorProfiles::GetActiveLanguageProfile failed with HRESULT 0x{:08x}", result))
        }
        return ActiveLanguageProfile(langid, guidProfile)
    }

    EnumLanguageProfiles(langid) {
        ; HRESULT EnumLanguageProfiles(
        ;     [in]  LANGID                  langid,
        ;     [out] IEnumTfLanguageProfiles **ppEnum
        ; );
        enumProfiles := 0
        if (result := ComCall(3 + 13, this.comObj, "ushort", langid, "ptr*", &enumProfiles)) != 0 {
            throw Error(Format("ITfInputProcessorProfiles::EnumLanguageProfiles failed with HRESULT 0x{:08x}", result))
        }
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
        if (result := ComCall(3 + 15, this.comObj,
                              "ptr", profile.pclsid,
                              "ushort", profile.langid(),
                              "ptr", profile.pGuidProfile,
                              "int*", &enabled)) != 0 {
            throw Error(Format("ITfInputProcessorProfiles::IsLanguageProfileEnabled failed with HRESULT 0x{:08x}", result))
        }
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
        if (result := ComCall(3 + 9, this.comObj,
                              "ptr", profile.pclsid,
                              "ushort", profile.langid(),
                              "ptr", profile.pGuidProfile,
                              "Str*", &bstrProfile)) != 0 {
            throw Error(Format("ITfInputProcessorProfiles::GetLanguageProfileDescription failed with HRESULT 0x{:08x}", result))
        }
        return bstrProfile
    }
}

GetEnabledInputMethods() {
    hKLCount :=  DllCall("GetKeyboardLayoutList", "int", 0, "ptr", 0)
    if (hKLCount = 0)
        return []

    layoutList := Buffer(hKLCount * A_PtrSize, 0)
    DllCall("GetKeyboardLayoutList", "int", hKLCount, "ptr", layoutList)

    profiles := ITfInputProcessorProfiles(CLSID_TF_InputProcessorProfiles)

    loop hKLCount {
        layoutID := NumGet(layoutList, A_PtrSize * (A_Index - 1), "uint")
        langid := LOWORD(layoutID)

        enumProfiles := profiles.EnumLanguageProfiles(langid)

        profile := TF_LANGUAGEPROFILE()
        while enumProfiles.Next(1, profile) {
            if profiles.IsLanguageProfileEnabled(profile) {
                profileDesc := profiles.GetLanguageProfileDescription(profile)
                Msgbox Format("{:04X}`n{}`n{}`n", profile.langid(), profile.strGuid(), profileDesc)
            }
        }
    }
}
