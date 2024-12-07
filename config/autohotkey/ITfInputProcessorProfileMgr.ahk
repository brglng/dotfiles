#include "TF_INPUTPROCESSORPROFILE.ahk"
#include "IEnumTfInputProcessorProfiles.ahk"
#include "utils.ahk"

GUID_TFCAT_TIP_KEYBOARD := StringToBinaryGUID("{34745C63-B2F0-4784-8B67-5E12C8701A31}")

class ITfInputProcessorProfileMgr {
    static IID := "{71C6E74C-0F28-11D8-A82A-00065B84435C}"

    __new(clsid) {
        this.comObj := ComObject(clsid, ITfInputProcessorProfileMgr.IID)
        this.ptr := this.comObj.ptr
    }

    ActivateProfile(profile, langid, pclsid, pguidProfile, hkl, dwFlags) {
        ; HRESULT ActivateProfile([in] DWORD dwProfileType, 
        ;                         [in] LANGID langid, 
        ;                         [in] REFCLSID clsid, 
        ;                         [in] REFGUID guidProfile, 
        ;                         [in] HKL hkl,
        ;                         [in] DWORD dwFlags);
        hr := ComCall(3 + 0, this.comObj,
                      "ushort", langid,
                      "ptr", pclsid,
                      "ptr", pguidProfile,
                      "ptr", hkl,
                      "uint", dwFlags)
        if hr != 0
            throw Error(Format("ITfInputProcessorProfileMgr::ActivateProfile failed with HRESULT 0x{:08X}", hr))
    }

    EnumProfiles(langid) {
        ; HRESULT EnumProfiles([in] LANGID langid, [out] IEnumTfInputProcessorProfiles **ppEnum);
        pEnum := 0
        hr := Comcall(3 + 3, this.comObj, "ushort", langid, "ptr*", &pEnum)
        if hr != 0
            throw Error(Format("ITfInputProcessorProfileMgr::EnumProfiles failed with HRESULT 0x{:08X}", hr))
        return IEnumTfInputProcessorProfiles(pEnum)
    }

    GetActiveProfile(pcatid) {
        ; HRESULT GetActiveProfile([in] REFGUID catid,
        ;                          [out] TF_INPUTPROCESSORPROFILE *pProfile);
        profile := TF_INPUTPROCESSORPROFILE()
        hr := ComCall(3 + 7, this.comObj, "ptr", pcatid, "ptr", profile.buffer)
        if hr != 0
            throw Error(Format("ITfInputProcessorProfileMgr::GetActiveProfile failed with HRESULT 0x{:08X}", hr))
        return profile
    }
}

ShowActiveProfile() {
    CLSID_TF_InputProcessorProfiles := "{33C53A50-F456-4884-B049-85FD643ECFED}"
    mgr := ITfInputProcessorProfileMgr(CLSID_TF_InputProcessorProfiles)
    profile := mgr.GetActiveProfile(GUID_TFCAT_TIP_KEYBOARD)
    Tooltip Format("dwProfileType: 0x{:08X}`n"
                   "langid: 0x{:04X}`n"
                   "clsid: {}`n"
                   "guidProfile: {}`n"
                   "catid: {}`n"
                   "hklSubstitute: 0x{:08X}`n"
                   "dwCaps: 0x{:08X}`n"
                   "hkl: 0x{:08X}`n"
                   "dwFlags: 0x{:08X}`n",
                   profile.dwProfileType(),
                   profile.langid(),
                   profile.strClsid(),
                   profile.strGuidProfile(),
                   profile.strCatid(),
                   profile.hklSubstitute(),
                   profile.dwCaps(),
                   profile.hkl(),
                   profile.dwFlags())
}
