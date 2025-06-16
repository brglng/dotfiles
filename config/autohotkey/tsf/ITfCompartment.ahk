#include "..\VARIANT.ahk"

class ITfCompartment {
    static IID := "{BB08F7A9-607A-4384-8623-056892B64371}"

    __new(ptr) {
        this.ptr := ptr
    }

    __delete() {
        ObjRelease(this.ptr)
    }

    ; HRESULT SetValue([in] TfClientId tid,
    ;                  [in] const VARIANT *pvarValue);
    SetValue(tid, pvarValue) {
        hr := ComCall(3 + 0, this.ptr, "uint", tid, "ptr", pvarValue)
        if hr != 0
            throw Error(Format("ITfCompartment::SetValue failed with HRESULT 0x{:08X}", hr))
    }

    ; HRESULT GetValue([out] VARIANT *pvarValue);
    GetValue() {
        pvarValue := VARIANT()
        hr := ComCall(3 + 1, this.ptr, "ptr", pvarValue)
        if hr != S_OK and hr != S_FALSE
            throw Error(Format("ITfCompartment::GetValue failed with HRESULT 0x{:08X}", hr))
        return pvarValue
    }
}
