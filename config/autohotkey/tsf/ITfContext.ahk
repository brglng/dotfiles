#include "ITfCompartmentMgr.ahk"

class ITfContext {
    static IID := "{AA80E7FD-2021-11D2-93E0-0060B067B86E}"

    __new(ptr) {
        this.ptr := ptr
    }

    __delete() {
        ObjRelease(this.ptr)
    }

    getCompartmentMgr() {
        return ITfCompartmentMgr(ComObjQuery(this.ptr, ITfCompartmentMgr.IID))
    }
}
