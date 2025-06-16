#include "ITfCompartmentMgr.ahk"
#include "ITfContext.ahk"

class ITfDocumentMgr {
    static IID := "{AA80E7F4-2021-11D2-93E0-0060B067B86E}"

    __new(ptr) {
        this.ptr := ptr
    }

    __delete() {
        ObjRelease(this.ptr)
    }

    ; HRESULT CreateContext([in] TfClientId tidOwner,
    ;                       [in] DWORD dwFlags,
    ;                       [in, unique] IUnknown *punk,
    ;                       [out] ITfContext **ppic,
    ;                       [out] TfEditCookie *pecTextStore);
    CreateContext(tidOwner, dwFlags, punk) {
        pic := 0
        ecTextStore := 0
        hr := ComCall(3 + 0, this.ptr,
                      "uint", tidOwner,
                      "uint", dwFlags,
                      "ptr", punk,
                      "ptr*", &pic,
                      "uint*", &ecTextStore)
        if hr != 0
            throw Error(Format("ITfDocumentMgr::CreateContext failed with HRESULT 0x{:08X}", hr))
        return [ITfContext(pic), ecTextStore]
    }

    ; HRESULT Push([in] ITfContext *pic);
    Push(pic) {
        hr := ComCall(3 + 1, this.ptr, "ptr", pic)
        if hr != 0
            throw Error(Format("ITfDocumentMgr::Push failed with HRESULT 0x{:08X}", hr))
    }

    ; const DWORD TF_POPF_ALL = 0x0001;

    ; HRESULT Pop([in] DWORD dwFlags);

    ; HRESULT GetTop([out] ITfContext **ppic);

    ; HRESULT GetBase([out] ITfContext **ppic);

    ; HRESULT EnumContexts([out] IEnumTfContexts **ppEnum);
    
    getCompartmentMgr() {
        return ITfCompartmentMgr(ComObjQuery(this.ptr, ITfCompartmentMgr.IID))
    }
}
