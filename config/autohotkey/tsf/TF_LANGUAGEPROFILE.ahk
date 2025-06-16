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
        this.clsid := this.buffer.ptr
        this.plangid := this.buffer.ptr + 16
        this.catid := this.buffer.ptr + 20
        this.pfActive := this.buffer.ptr + 36
        this.guidProfile := this.buffer.ptr + 40
    }

    ptr {
        get => this.buffer.ptr
    }

    strClsid {
        get => guidToStr(this.clsid)
        set => guidFromStr(this.clsid, value)
    }

    langid {
        get => NumGet(this.plangid, "ushort")
    }

    strCatid {
        get => guidToStr(this.catid)
        set => guidFromStr(this.catid, value)
    }

    fActive {
        get => NumGet(this.pfActive, "int")
    }

    strGUIDProfile {
        get => guidToStr(this.guidProfile)
    }
}
