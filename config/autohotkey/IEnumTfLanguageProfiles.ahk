class IEnumTfLanguageProfiles {
    __new(ptr) {
        this.ptr := ptr
        this.cFetch := Buffer(4, 0)
    }

    Next(count, profile) {
        ; HRESULT Next([in] ULONG ulCount,
        ;              [out, size_is(ulCount), length_is(*pcFetch)] TF_LANGUAGEPROFILE *pProfile,
        ;              [out] ULONG *pcFetch);
        if ComCall(3 + 1, this.ptr, "int", count, "ptr", profile.buffer, "int*", this.cFetch.ptr) == 0
            return true
        return false
    }
}
