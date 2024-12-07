#include "utils.ahk"

class TF_INPUTPROCESSORPROFILE {
    __new() {
        ; typedef struct TF_INPUTPROCESSORPROFILE
        ; {
        ;     DWORD dwProfileType;   // InputProcessor or HKL           // 4 bytes
        ;     LANGID langid;         // language id                     // 2 bytes, offset 4
        ;     CLSID clsid;           // CLSID of tip                    // 16 bytes, offset 8
        ;     GUID guidProfile;      // profile description             // 16 bytes, offset 24
        ;     GUID catid;            // category of tip                 // 16 bytes, offset 40
        ;     HKL  hklSubstitute;    // substitute hkl                  // 8 bytes, offset 56
        ;     DWORD dwCaps;          // InputProcessor Capability       // 4 bytes, offset 64
        ;     HKL hkl;               // hkl                             // 8 bytes, offset 72
        ;     DWORD dwFlags;         // Flags.                          // 4 bytes, offset 80
        ; } TF_INPUTPROCESSORPROFILE;                                   // size 88
        this.buffer := Buffer(88, 0)
        this.ptr := this.buffer.ptr
        this.pdwProfileType := this.buffer.ptr
        this.plangid := this.buffer.ptr + 4
        this.pclsid := this.buffer.ptr + 8
        this.pguidProfile := this.buffer.ptr + 24
        this.pcatid := this.buffer.ptr + 40
        this.phklSubstitute := this.buffer.ptr + 56
        this.pdwCaps := this.buffer.ptr + 64
        this.phkl := this.buffer.ptr + 72
        this.pdwFlags := this.buffer.ptr + 80
    }

    dwProfileType() {
        return NumGet(this.pdwProfileType, "uint")
    }

    langid() {
        return NumGet(this.plangid, "ushort")
    }

    strClsid() {
        return FormatGUID(this.pclsid)
    }

    strGuidProfile() {
        return FormatGUID(this.pguidProfile)
    }

    strCatid() {
        return FormatGUID(this.pcatid)
    }

    hklSubstitute() {
        return NumGet(this.phklSubstitute, "ptr")
    }

    dwCaps() {
        return NumGet(this.pdwCaps, "uint")
    }

    hkl() {
        return NumGet(this.phkl, "ptr")
    }

    dwFlags() {
        return NumGet(this.pdwFlags, "uint")
    }
}
