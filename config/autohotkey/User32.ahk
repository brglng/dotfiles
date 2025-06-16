GetForegroundWindow() {
    ; HWND GetForegroundWindow(void) docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getforegroundwindow
    static addr := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str","User32", "Ptr"), "AStr", "GetForegroundWindow", "Ptr")
    return DllCall(addr)
}
