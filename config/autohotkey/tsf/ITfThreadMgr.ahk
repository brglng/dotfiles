#include "ITfCompartmentMgr.ahk"
#include "ITfDocumentMgr.ahk"

class ITfThreadMgr {
    static IID := "{AA80E801-2021-11D2-93E0-0060B067B86E}"

    __new(clsid) {
        this.comObj := ComObject(clsid, ITfThreadMgr.IID)

        ; HRESULT Activate([out] TfClientId *ptid);
        tid := 0
        hr := ComCall(3 + 0, this.comObj, "UInt*", &tid)
        if hr != 0
            throw Error(Format("ITfThreadMgr::Activate failed with HRESULT 0x{:08X}", hr))

        this.tid := tid
    }

    __delete() {
        ; HRESULT Deactivate();
        hr := ComCall(3 + 1, this.comObj)
        if hr != 0
            throw Error(Format("ITfThreadMgr::Deactivate failed with HRESULT 0x{:08X}", hr))
    }

    ptr {
        get => this.comObj.ptr
    }

    ; HRESULT CreateDocumentMgr([out] ITfDocumentMgr **ppdim);
    CreateDocumentMgr() {
        pDim := 0
        hr := ComCall(3 + 2, this.comObj, "ptr*", &pDim)
        if hr != 0
            throw Error(Format("ITfThreadMgr::CreateDocumentMgr failed with HRESULT 0x{:08X}", hr))
        return ITfDocumentMgr(pDim)
    }

    ; HRESULT EnumDocumentMgrs([out] IEnumTfDocumentMgrs **ppEnum);

    ; HRESULT GetFocus([out] ITfDocumentMgr **ppdimFocus);

    ; HRESULT SetFocus([in] ITfDocumentMgr *pdimFocus);
    SetFocus(pdimFocus) {
        hr := ComCall(3 + 5, this.comObj, "ptr", pdimFocus)
        if hr != 0
            throw Error(Format("ITfThreadMgr::SetFocus failed with HRESULT 0x{:08X}", hr))
    }

    ; HRESULT AssociateFocus([in] HWND hwnd,
    ;                        [in, unique] ITfDocumentMgr *pdimNew,
    ;                        [out] ITfDocumentMgr **ppdimPrev);
    AssociateFocus(hwnd, pdimNew) {
        pDimPrev := 0
        hr := ComCall(3 + 6, this.comObj,
                      "ptr", hwnd,
                      "ptr", pdimNew,
                      "ptr*", &pdimPrev)
        if hr != 0
            throw Error(Format("ITfThreadMgr::AssociateFocus failed with HRESULT 0x{:08X}", hr))
        return ITfDocumentMgr(pDimPrev)
    }

    ; HRESULT IsThreadFocus([out] BOOL *pfThreadFocus);

    ; HRESULT GetFunctionProvider([in] REFCLSID clsid,
    ;                             [out] ITfFunctionProvider **ppFuncProv);

    ; HRESULT EnumFunctionProviders([out] IEnumTfFunctionProviders **ppEnum);

    ; HRESULT GetGlobalCompartment([out] ITfCompartmentMgr **ppCompMgr);
    GetGlobalCompartment() {
        pCompMgr := 0
        hr := ComCall(3 + 10, this.comObj, "ptr*", &pCompMgr)
        if hr != 0
            throw Error(Format("ITfThreadMgr::GetGlobalCompartment failed with HRESULT 0x{:08X}", hr))
        return ITfCompartmentMgr(pCompMgr)
    }

    getCompartmentMgr() {
        return ITfCompartmentMgr(ComObjQuery(this.comObj, ITfCompartmentMgr.IID))
    }
}
