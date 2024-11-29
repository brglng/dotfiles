class TF_LANGUAGEPROFILE {
    __new() {
        ; typedef struct TF_LANGUAGEPROFILE {
        ;     CLSID clsid;        // CLSID of tip           // GUID, 16 bytes
        ;     LANGID langid;      // language id            // WORD, 2 bytes, offset 16
        ;     GUID catid;         // category of tip        // GUID, 16 bytes, offset 20
        ;     BOOL fActive;       // activated profile      // int, 4 bytes, offset 36
        ;     GUID guidProfile;   // profile description    // GUID, 16 bytes, offset 40
        ; } TF_LANGUAGEPROFILE;
        this.buffer := Buffer(56, 0)
        this.ptr := this.buffer.ptr
        this.pclsid := this.buffer.ptr
        this.plangid := this.buffer.ptr + 16
        this.pcatid := this.buffer.ptr + 20
        this.pfActive := this.buffer.ptr + 36
        this.pGuidProfile := this.buffer.ptr + 40
    }

    langid() {
        return NumGet(this.plangid, "ushort")
    }

    strGuid() {
        return FormatGUID(this.pGuidProfile)
    }
}
