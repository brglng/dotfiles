#include "..\utils.ahk"

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
        this.plangid := this.buffer.ptr + 4
        this._clsid := this.buffer.ptr + 8
        this._guidProfile := this.buffer.ptr + 24
        this._catid := this.buffer.ptr + 40
        this.phklSubstitute := this.buffer.ptr + 56
        this.pdwCaps := this.buffer.ptr + 64
        this.phkl := this.buffer.ptr + 72
        this.pdwFlags := this.buffer.ptr + 80
    }

    ptr {
        get => this.buffer.ptr
    }

    dwProfileType {
        get => NumGet(this.buffer.ptr, "uint")
        set {
            NumPut("uint", value, this.buffer.ptr)
        }
    }

    langid {
        get => NumGet(this.plangid, "ushort")
        set {
            NumPut("ushort", value, this.plangid)
        }
    }

    clsid {
        get => this._clsid
    }

    strClsid {
        get => guidToStr(this._clsid)
        set {
            guidFromStr(this._clsid, value)
        }
    }

    guidProfile {
        get => this._guidProfile
    }

    strGUIDProfile {
        get => guidToStr(this._guidProfile)
        set {
            guidFromStr(this._guidProfile, value)
        }
    }

    catid {
        get => this._catid
    }

    strCatid {
        get => guidToStr(this._catid)
        set {
            guidFromStr(this._catid, value)
        }
    }

    hklSubstitute {
        get => NumGet(this.phklSubstitute, "ptr")
        set {
            NumPut("ptr", value, this.phklSubstitute)
        }
    }

    dwCaps {
        get => NumGet(this.pdwCaps, "uint")
        set {
            NumPut("uint", value, this.pdwCaps)
        }
    }

    hkl {
        get => NumGet(this.phkl, "ptr")
        set {
            NumPut("ptr", value, this.phkl)
        }
    }

    dwFlags {
        get => NumGet(this.pdwFlags, "uint")
        set {
            NumPut("uint", value, this.pdwFlags)
        }
    }
}
