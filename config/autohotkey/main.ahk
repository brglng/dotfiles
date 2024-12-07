#Requires AutoHotKey 2
#SingleInstance Force
InstallKeybdHook
; InstallMouseHook
#UseHook True
; #MaxThreadsPerHotkey 10
; A_MaxHotkeysPerInterval := 20000
SendMode "Event"
SetKeyDelay -1, -1
ProcessSetPriority "High"
SetWorkingDir A_ScriptDir

; FullCommandLine := DllCall("GetCommandLine", "str")
; if not (A_IsAdmin or RegExMatch(FullCommandLine, " /restart(?!\S)")) {
;     try {
;         if A_IsCompiled
;             Run '*RunAs "' A_ScriptFullPath '" /restart'
;         else
;             Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
;     }
;     ExitApp
; }

DetectHiddenWindows true

#include "KeyboardLayoutManager.ahk"
#include "ModTapManager.ahk"

global CapsLockDownTime := 0

CapsLock::{
    global CapsLockDownTime
    if CapsLockDownTime = 0 {
        CapsLockDownTime := A_TickCount
    }
}

CapsLock Up::{
    global CapsLockDownTime
    if A_PriorKey = "CapsLock" and A_TickCount - CapsLockDownTime < 300 {
        Send "{Esc}"
    } else {
        Send "{LWin Down}{Space}{LWin Up}"
    }
    CapsLockDownTime := 0
}

*CapsLock::return

kl := KeyboardLayoutManager()

modtap := ModTapManager(Map(
    "Space", { modKey: "LShift", repeatTimeout: 0 },
    "f", { modKey: "LControl" },
    "d", { modKey: "LAlt" },
    "s", { modKey: "LWin" },
    "j", { modKey: "RControl" },
    "k", { modKey: "RAlt" },
    "l", { modKey: "RWin" }
))

$*LShift::modtap.onModKeyDown("LShift")
$*LShift up::modtap.onModKeyUp("LShift", () => kl.toggleKeyboardLayout())
$*RShift::modtap.onModKeyDown("RShift")
$*RShift up::modtap.onModKeyUp("RShift", () => kl.toggleKeyboardLayout())
$*LControl::modtap.onModKeyDown("LControl")
$*LControl up::modtap.onModKeyUp("LControl")
$*RControl::modtap.onModKeyDown("RControl")
$*RControl up::modtap.onModKeyUp("RControl")
$*LAlt::modtap.onModKeyDown("LAlt")
$*LAlt up::modtap.onModKeyUp("LAlt")
$*RAlt::modtap.onModKeyDown("RAlt")
$*RAlt up::modtap.onModKeyUp("RAlt")
$*LWin::modtap.onModKeyDown("LWin")
$*LWin up::modtap.onModKeyUp("LWin")
$*RWin::modtap.onModKeyDown("RWin")
$*RWin up::modtap.onModKeyUp("RWin")

$*Space::modtap.onExtraMod("Space", ["f", "d", "s", "j", "k", "l"])
$*Space up::modtap.onExtraModUp("Space")
$*f::modtap.onExtraMod("f", ["Space", "j", "k", "l"])
$*f up::modtap.onExtraModUp("f")
$*d::modtap.onExtraMod("d", ["Space", "j", "k", "l"])
$*d up::modtap.onExtraModUp("d")
$*s::modtap.onExtraMod("s", ["Space", "j", "k", "l"])
$*s up::modtap.onExtraModUp("s")
$*j::modtap.onExtraMod("j", ["Space", "f", "d", "s"])
$*j up::modtap.onExtraModUp("j")
$*k::modtap.onExtraMod("k", ["Space", "f", "d", "s"])
$*k up::modtap.onExtraModUp("k")
$*l::modtap.onExtraMod("l", ["Space", "f", "d", "s"])
$*l up::modtap.onExtraModUp("l")

$*`::modtap.onOtherKey("``", ["Space", "j", "k", "l"])
$*1::modtap.onOtherKey("1", ["Space", "j", "k", "l"])
$*2::modtap.onOtherKey("2", ["Space", "j", "k", "l"])
$*3::modtap.onOtherKey("3", ["Space", "j", "k", "l"])
$*4::modtap.onOtherKey("4", ["Space", "j", "k", "l"])
$*5::modtap.onOtherKey("5", ["Space", "j", "k", "l"])
$*6::modtap.onOtherKey("6", ["Space", "f", "d", "s"])
$*7::modtap.onOtherKey("7", ["Space", "f", "d", "s"])
$*8::modtap.onOtherKey("8", ["Space", "f", "d", "s"])
$*9::modtap.onOtherKey("9", ["Space", "f", "d", "s"])
$*0::modtap.onOtherKey("0", ["Space", "f", "d", "s"])
$*-::modtap.onOtherKey("-", ["Space", "f", "d", "s"])
$*=::modtap.onOtherKey("=", ["Space", "f", "d", "s"])
$*Backspace::modtap.onOtherKey("Backspace", ["Space", "f", "d", "s"])
$*Tab::modtap.onOtherKey("Tab", ["Space", "j", "k", "l"])
$*q::modtap.onOtherKey("q", ["Space", "j", "k", "l"])
$*w::modtap.onOtherKey("w", ["Space", "j", "k", "l"])
$*e::modtap.onOtherKey("e", ["Space", "j", "k", "l"])
$*r::modtap.onOtherKey("r", ["Space", "j", "k", "l"])
$*t::modtap.onOtherKey("t", ["Space", "j", "k", "l"])
$*y::modtap.onOtherKey("y", ["Space", "f", "d", "s"])
$*u::modtap.onOtherKey("u", ["Space", "f", "d", "s"])
$*i::modtap.onOtherKey("i", ["Space", "f", "d", "s"])
$*o::modtap.onOtherKey("o", ["Space", "f", "d", "s"])
$*p::modtap.onOtherKey("p", ["Space", "f", "d", "s"])
$*[::modtap.onOtherKey("[", ["Space", "f", "d", "s"])
$*]::modtap.onOtherKey("]", ["Space", "f", "d", "s"])
$*\::modtap.onOtherKey("\", ["Space", "f", "d", "s"])
$*a::modtap.onOtherKey("a", ["Space", "j", "k", "l"])
$*g::modtap.onOtherKey("g", ["Space", "j", "k", "l"])
$*h::modtap.onOtherKey("h", ["Space", "f", "d", "s"])
$*;::modtap.onOtherKey(";", ["Space", "f", "d", "s"])
$*'::modtap.onOtherKey("'", ["Space", "f", "d", "s"])
$*Enter::modtap.onOtherKey("Enter", ["Space", "f", "d", "s"])
$*z::modtap.onOtherKey("z", ["Space", "j", "k", "l"])
$*x::modtap.onOtherKey("x", ["Space", "j", "k", "l"])
$*c::modtap.onOtherKey("c", ["Space", "j", "k", "l"])
$*v::modtap.onOtherKey("v", ["Space", "j", "k", "l"])
$*b::modtap.onOtherKey("b", ["Space", "j", "k", "l"])
$*n::modtap.onOtherKey("n", ["Space", "f", "d", "s"])
$*m::modtap.onOtherKey("m", ["Space", "f", "d", "s"])
$*,::modtap.onOtherKey(",", ["Space", "f", "d", "s"])
$*.::modtap.onOtherKey(".", ["Space", "f", "d", "s"])
$*/::modtap.onOtherKey("/", ["Space", "f", "d", "s"])
$*Left::modtap.onOtherKey("Left", ["Space", "f", "d", "s"])
$*Up::modtap.onOtherKey("Up", ["Space", "f", "d", "s"])
$*Right::modtap.onOtherKey("Right", ["Space", "f", "d", "s"])
$*Down::modtap.onOtherKey("Down", ["Space", "f", "d", "s"])
