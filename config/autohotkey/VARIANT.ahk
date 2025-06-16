VT_EMPTY := 0
VT_NULL := 1
VT_I2 := 2
VT_I4 := 3
VT_R4 := 4
VT_R8 := 5
VT_CY := 6
VT_DATE := 7
VT_BSTR := 8
VT_DISPATCH := 9
VT_ERROR := 10
VT_BOOL := 11
VT_VARIANT := 12
VT_UNKNOWN := 13
VT_DECIMAL := 14
VT_I1 := 16
VT_UI1 := 17
VT_UI2 := 18
VT_UI4 := 19
VT_I8 := 20
VT_UI8 := 21
VT_INT := 22
VT_UINT := 23
VT_VOID := 24
VT_HRESULT := 25
VT_PTR := 26
VT_SAFEARRAY := 27
VT_CARRAY := 28
VT_USERDEFINED := 29
VT_LPSTR := 30
VT_LPWSTR := 31
VT_RECORD := 36
VT_INT_PTR := 37
VT_UINT_PTR := 38
VT_FILETIME := 64
VT_BLOB := 65
VT_STREAM := 66
VT_STORAGE := 67
VT_STREAMED_OBJECT := 68
VT_STORED_OBJECT := 69
VT_BLOB_OBJECT := 70
VT_CF := 71
VT_CLSID := 72
VT_VERSIONED_STREAM := 73
VT_BSTR_BLOB := 0xfff
VT_VECTOR := 0x1000
VT_ARRAY := 0x2000
VT_BYREF := 0x4000
VT_RESERVED := 0x8000
VT_ILLEGAL := 0xffff
VT_ILLEGALMASKED := 0xfff
VT_TYPEMASK := 0xfff

; typedef struct tagVARIANT {
;   union {
;     struct {
;       VARTYPE vt;
;       WORD    wReserved1;
;       WORD    wReserved2;
;       WORD    wReserved3;
;       union {
;         LONGLONG     llVal;
;         LONG         lVal;
;         BYTE         bVal;
;         SHORT        iVal;
;         FLOAT        fltVal;
;         DOUBLE       dblVal;
;         VARIANT_BOOL boolVal;
;         VARIANT_BOOL __OBSOLETE__VARIANT_BOOL;
;         SCODE        scode;
;         CY           cyVal;
;         DATE         date;
;         BSTR         bstrVal;
;         IUnknown     *punkVal;
;         IDispatch    *pdispVal;
;         SAFEARRAY    *parray;
;         BYTE         *pbVal;
;         SHORT        *piVal;
;         LONG         *plVal;
;         LONGLONG     *pllVal;
;         FLOAT        *pfltVal;
;         DOUBLE       *pdblVal;
;         VARIANT_BOOL *pboolVal;
;         VARIANT_BOOL *__OBSOLETE__VARIANT_PBOOL;
;         SCODE        *pscode;
;         CY           *pcyVal;
;         DATE         *pdate;
;         BSTR         *pbstrVal;
;         IUnknown     **ppunkVal;
;         IDispatch    **ppdispVal;
;         SAFEARRAY    **pparray;
;         VARIANT      *pvarVal;
;         PVOID        byref;
;         CHAR         cVal;
;         USHORT       uiVal;
;         ULONG        ulVal;
;         ULONGLONG    ullVal;
;         INT          intVal;
;         UINT         uintVal;
;         DECIMAL      *pdecVal;
;         CHAR         *pcVal;
;         USHORT       *puiVal;
;         ULONG        *pulVal;
;         ULONGLONG    *pullVal;
;         INT          *pintVal;
;         UINT         *puintVal;
;         struct {
;           PVOID       pvRecord;
;           IRecordInfo *pRecInfo;
;         } __VARIANT_NAME_4;
;       } __VARIANT_NAME_3;
;     } __VARIANT_NAME_2;
;     DECIMAL decVal;
;   } __VARIANT_NAME_1;
; } VARIANT;

class VARIANT {
    __new() {
        this.buffer := Buffer(24, 0)
        DllCall("oleaut32\VariantInit", "ptr", this.buffer)
        NumPut("UShort", VT_EMPTY, this.buffer, 0) ; VARTYPE
    }

    __delete() {
        DllCall("oleaut32\VariantClear", "ptr", this.buffer)
    }

    ptr {
        get => this.buffer.ptr
    }

    vt {
        get => NumGet(this.buffer, 0, "UShort") ; VARTYPE
        set {
            if (this.vt != VT_EMPTY) {
                throw Error("Cannot change the VARTYPE after it has been set.")
            }
            NumPut("UShort", value, this.buffer, 0) ; VARTYPE
        }
    }

    lVal {
        get {
            if (this.vt != VT_I4) {
                throw Error("Cannot get lVal unless the VARTYPE is VT_I4.")
            }
            return NumGet(this.buffer, 8, "Int") ; LONG
        }
        set {
            if (this.vt != VT_I4 and this.vt != VT_EMPTY) {
                throw Error("Cannot set lVal unless the VARTYPE is VT_I4 or VT_EMPTY.")
            }
            if (this.vt == VT_EMPTY) {
                this.vt := VT_I4
            }
            NumPut("Int", value, this.buffer, 8) ; LONG
        }
    }
}
