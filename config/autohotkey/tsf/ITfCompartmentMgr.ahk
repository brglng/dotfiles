#include "ITfCompartment.ahk"

class ITfCompartmentMgr {
    static IID := "{7DCF57AC-18AD-438B-824D-979BFFB74B7C}"

    __new(comObj) {
        this.comObj := comObj
    }

    ptr {
        get => this.comObj.ptr
    }

    ; HRESULT GetCompartment([in] REFGUID rguid,
    ;                        [out] ITfCompartment **ppcomp);
    GetCompartment(rguid) {
        pCompartment := 0
        hr := ComCall(3 + 0, this.ptr, "ptr", rguid, "ptr*", &pCompartment)
        if hr != 0
            throw Error(Format("ITfCompartmentMgr::GetCompartment failed with HRESULT 0x{:08X}", hr))
        return ITfCompartment(pCompartment)
    }

    ; HRESULT ClearCompartment([in] TfClientId tid, 
    ;                          [in] REFGUID rguid);
    ClearCompartment(tid, rguid) {
        hr := ComCall(3 + 1, this.ptr, "uint", tid, "ptr", rguid)
        if hr != 0
            throw Error(Format("ITfCompartmentMgr::ClearCompartment failed with HRESULT 0x{:08X}", hr))
    }

    ; HRESULT EnumCompartments([out] IEnumGUID **ppEnum);
    ; EnumCompartments() {
    ;     pEnum := 0
    ;     hr := ComCall(3 + 2, this.ptr, "ptr*", &pEnum)
    ;     if hr != 0
    ;         throw Error(Format("ITfCompartmentMgr::EnumCompartments failed with HRESULT 0x{:08X}", hr))
    ;     return IEnumGUID(pEnum)
    ; }
}
