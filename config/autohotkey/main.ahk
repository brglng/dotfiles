#Requires AutoHotKey 2
#SingleInstance Force
InstallKeybdHook
InstallMouseHook
#UseHook True
#MaxThreadsPerHotkey 10
A_MaxHotkeysPerInterval := 1000
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
    if A_PriorKey = "CapsLock" and A_TickCount - CapsLockDownTime < 200 {
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
), , false)

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

$*Space::modtap.onExtraMod("Space")
$*Space up::modtap.onExtraModUp("Space", ["f", "d", "s", "j", "k", "l"])
$*f::modtap.onExtraMod("f")
$*f up::modtap.onExtraModUp("f", ["Space", "j", "k", "l"])
$*d::modtap.onExtraMod("d")
$*d up::modtap.onExtraModUp("d", ["Space", "j", "k", "l"])
$*s::modtap.onExtraMod("s")
$*s up::modtap.onExtraModUp("s", ["Space", "j", "k", "l"])
$*j::modtap.onExtraMod("j")
$*j up::modtap.onExtraModUp("j", ["Space", "f", "d", "s"])
$*k::modtap.onExtraMod("k")
$*k up::modtap.onExtraModUp("k", ["Space", "f", "d", "s"])
$*l::modtap.onExtraMod("l")
$*l up::modtap.onExtraModUp("l", ["Space", "f", "d", "s"])

$*`::modtap.onOtherKey("``", ["Space", "j", "k", "l"])
$*` up::modtap.onOtherKeyUp("``", ["Space", "j", "k", "l"])
$*1::modtap.onOtherKey("1", ["Space", "j", "k", "l"])
$*1 up::modtap.onOtherKeyUp("1", ["Space", "j", "k", "l"])
$*2::modtap.onOtherKey("2", ["Space", "j", "k", "l"])
$*2 up::modtap.onOtherKeyUp("2", ["Space", "j", "k", "l"])
$*3::modtap.onOtherKey("3", ["Space", "j", "k", "l"])
$*3 up::modtap.onOtherKeyUp("3", ["Space", "j", "k", "l"])
$*4::modtap.onOtherKey("4", ["Space", "j", "k", "l"])
$*4 up::modtap.onOtherKeyUp("4", ["Space", "j", "k", "l"])
$*5::modtap.onOtherKey("5", ["Space", "j", "k", "l"])
$*5 up::modtap.onOtherKeyUp("5", ["Space", "j", "k", "l"])
$*6::modtap.onOtherKey("6", ["Space", "f", "d", "s"])
$*6 up::modtap.onOtherKeyUp("6", ["Space", "f", "d", "s"])
$*7::modtap.onOtherKey("7", ["Space", "f", "d", "s"])
$*7 up::modtap.onOtherKeyUp("7", ["Space", "f", "d", "s"])
$*8::modtap.onOtherKey("8", ["Space", "f", "d", "s"])
$*8 up::modtap.onOtherKeyUp("8", ["Space", "f", "d", "s"])
$*9::modtap.onOtherKey("9", ["Space", "f", "d", "s"])
$*9 up::modtap.onOtherKeyUp("9", ["Space", "f", "d", "s"])
$*0::modtap.onOtherKey("0", ["Space", "f", "d", "s"])
$*0 up::modtap.onOtherKeyUp("0", ["Space", "f", "d", "s"])
$*-::modtap.onOtherKey("-", ["Space", "f", "d", "s"])
$*- up::modtap.onOtherKeyUp("-", ["Space", "f", "d", "s"])
$*=::modtap.onOtherKey("=", ["Space", "f", "d", "s"])
$*= up::modtap.onOtherKeyUp("=", ["Space", "f", "d", "s"])
$*Backspace::modtap.onOtherKey("Backspace", ["Space", "f", "d", "s"])
$*Backspace up::modtap.onOtherKeyUp("Backspace", ["Space", "f", "d", "s"])
$*Tab::modtap.onOtherKey("Tab", ["Space", "j", "k", "l"])
$*Tab up::modtap.onOtherKeyUp("Tab", ["Space", "j", "k", "l"])
$*q::modtap.onOtherKey("q", ["Space", "j", "k", "l"])
$*q up::modtap.onOtherKeyUp("q", ["Space", "j", "k", "l"])
$*w::modtap.onOtherKey("w", ["Space", "j", "k", "l"])
$*w up::modtap.onOtherKeyUp("w", ["Space", "j", "k", "l"])
$*e::modtap.onOtherKey("e", ["Space", "j", "k", "l"])
$*e up::modtap.onOtherKeyUp("e", ["Space", "j", "k", "l"])
$*r::modtap.onOtherKey("r", ["Space", "j", "k", "l"])
$*r up::modtap.onOtherKeyUp("r", ["Space", "j", "k", "l"])
$*t::modtap.onOtherKey("t", ["Space", "j", "k", "l"])
$*t up::modtap.onOtherKeyUp("t", ["Space", "j", "k", "l"])
$*y::modtap.onOtherKey("y", ["Space", "f", "d", "s"])
$*y up::modtap.onOtherKeyUp("y", ["Space", "f", "d", "s"])
$*u::modtap.onOtherKey("u", ["Space", "f", "d", "s"])
$*u up::modtap.onOtherKeyUp("u", ["Space", "f", "d", "s"])
$*i::modtap.onOtherKey("i", ["Space", "f", "d", "s"])
$*i up::modtap.onOtherKeyUp("i", ["Space", "f", "d", "s"])
$*o::modtap.onOtherKey("o", ["Space", "f", "d", "s"])
$*o up::modtap.onOtherKeyUp("o", ["Space", "f", "d", "s"])
$*p::modtap.onOtherKey("p", ["Space", "f", "d", "s"])
$*p up::modtap.onOtherKeyUp("p", ["Space", "f", "d", "s"])
$*[::modtap.onOtherKey("[", ["Space", "f", "d", "s"])
$*[ up::modtap.onOtherKeyUp("[", ["Space", "f", "d", "s"])
$*]::modtap.onOtherKey("]", ["Space", "f", "d", "s"])
$*] up::modtap.onOtherKeyUp("]", ["Space", "f", "d", "s"])
$*\::modtap.onOtherKey("\", ["Space", "f", "d", "s"])
$*\ up::modtap.onOtherKeyUp("\", ["Space", "f", "d", "s"])
$*a::modtap.onOtherKey("a", ["Space", "j", "k", "l"])
$*a up::modtap.onOtherKeyUp("a", ["Space", "j", "k", "l"])
$*g::modtap.onOtherKey("g", ["Space", "j", "k", "l"])
$*g up::modtap.onOtherKeyUp("g", ["Space", "j", "k", "l"])
$*h::modtap.onOtherKey("h", ["Space", "f", "d", "s"])
$*h up::modtap.onOtherKeyUp("h", ["Space", "f", "d", "s"])
$*;::modtap.onOtherKey(";", ["Space", "f", "d", "s"])
$*; up::modtap.onOtherKeyUp(";", ["Space", "f", "d", "s"])
$*'::modtap.onOtherKey("'", ["Space", "f", "d", "s"])
$*' up::modtap.onOtherKeyUp("'", ["Space", "f", "d", "s"])
$*Enter::modtap.onOtherKey("Enter", ["Space", "f", "d", "s"])
$*Enter up::modtap.onOtherKeyUp("Enter", ["Space", "f", "d", "s"])
$*z::modtap.onOtherKey("z", ["Space", "j", "k", "l"])
$*z up::modtap.onOtherKeyUp("z", ["Space", "j", "k", "l"])
$*x::modtap.onOtherKey("x", ["Space", "j", "k", "l"])
$*x up::modtap.onOtherKeyUp("x", ["Space", "j", "k", "l"])
$*c::modtap.onOtherKey("c", ["Space", "j", "k", "l"])
$*c up::modtap.onOtherKeyUp("c", ["Space", "j", "k", "l"])
$*v::modtap.onOtherKey("v", ["Space", "j", "k", "l"])
$*v up::modtap.onOtherKeyUp("v", ["Space", "j", "k", "l"])
$*b::modtap.onOtherKey("b", ["Space", "j", "k", "l"])
$*b up::modtap.onOtherKeyUp("b", ["Space", "j", "k", "l"])
$*n::modtap.onOtherKey("n", ["Space", "f", "d", "s"])
$*n up::modtap.onOtherKeyUp("n", ["Space", "f", "d", "s"])
$*m::modtap.onOtherKey("m", ["Space", "f", "d", "s"])
$*m up::modtap.onOtherKeyUp("m", ["Space", "f", "d", "s"])
$*,::modtap.onOtherKey(",", ["Space", "f", "d", "s"])
$*, up::modtap.onOtherKeyUp(",", ["Space", "f", "d", "s"])
$*.::modtap.onOtherKey(".", ["Space", "f", "d", "s"])
$*. up::modtap.onOtherKeyUp(".", ["Space", "f", "d", "s"])
$*/::modtap.onOtherKey("/", ["Space", "f", "d", "s"])
$*/ up::modtap.onOtherKeyUp("/", ["Space", "f", "d", "s"])
$*Esc::modtap.onOtherKey("Esc", ["Space", "j", "k", "l"])
$*Esc up::modtap.onOtherKeyUp("Esc", ["Space", "j", "k", "l"])
$*F1::modtap.onOtherKey("F1", ["Space", "j", "k", "l"])
$*F1 up::modtap.onOtherKeyUp("F1", ["Space", "j", "k", "l"])
$*F2::modtap.onOtherKey("F2", ["Space", "j", "k", "l"])
$*F2 up::modtap.onOtherKeyUp("F2", ["Space", "j", "k", "l"])
$*F3::modtap.onOtherKey("F3", ["Space", "j", "k", "l"])
$*F3 up::modtap.onOtherKeyUp("F3", ["Space", "j", "k", "l"])
$*F4::modtap.onOtherKey("F4", ["Space", "j", "k", "l"])
$*F4 up::modtap.onOtherKeyUp("F4", ["Space", "j", "k", "l"])
$*F5::modtap.onOtherKey("F5", ["Space", "j", "k", "l"])
$*F5 up::modtap.onOtherKeyUp("F5", ["Space", "j", "k", "l"])
$*F6::modtap.onOtherKey("F6", ["Space", "f", "d", "s"])
$*F6 up::modtap.onOtherKeyUp("F6", ["Space", "f", "d", "s"])
$*F7::modtap.onOtherKey("F7", ["Space", "f", "d", "s"])
$*F7 up::modtap.onOtherKeyUp("F7", ["Space", "f", "d", "s"])
$*F8::modtap.onOtherKey("F8", ["Space", "f", "d", "s"])
$*F8 up::modtap.onOtherKeyUp("F8", ["Space", "f", "d", "s"])
$*F9::modtap.onOtherKey("F9", ["Space", "f", "d", "s"])
$*F9 up::modtap.onOtherKeyUp("F9", ["Space", "f", "d", "s"])
$*F10::modtap.onOtherKey("F10", ["Space", "f", "d", "s"])
$*F10 up::modtap.onOtherKeyUp("F10", ["Space", "f", "d", "s"])
$*F11::modtap.onOtherKey("F11", ["Space", "f", "d", "s"])
$*F11 up::modtap.onOtherKeyUp("F11", ["Space", "f", "d", "s"])
$*F12::modtap.onOtherKey("F12", ["Space", "f", "d", "s"])
$*F12 up::modtap.onOtherKeyUp("F12", ["Space", "f", "d", "s"])
$*Home::modtap.onOtherKey("Home", ["Space", "f", "d", "s"])
$*Home up::modtap.onOtherKeyUp("Home", ["Space", "f", "d", "s"])
$*End::modtap.onOtherKey("End", ["Space", "f", "d", "s"])
$*End up::modtap.onOtherKeyUp("End", ["Space", "f", "d", "s"])
$*Insert::modtap.onOtherKey("Insert", ["Space", "f", "d", "s"])
$*Insert up::modtap.onOtherKeyUp("Insert", ["Space", "f", "d", "s"])
$*Delete::modtap.onOtherKey("Delete", ["Space", "f", "d", "s"])
$*Delete up::modtap.onOtherKeyUp("Delete", ["Space", "f", "d", "s"])
$*Left::modtap.onOtherKey("Left", ["Space", "f", "d", "s"])
$*Left up::modtap.onOtherKeyUp("Left", ["Space", "f", "d", "s"])
$*Up::modtap.onOtherKey("Up", ["Space", "f", "d", "s"])
$*Up up::modtap.onOtherKeyUp("Up", ["Space", "f", "d", "s"])
$*Right::modtap.onOtherKey("Right", ["Space", "f", "d", "s"])
$*Right up::modtap.onOtherKeyUp("Right", ["Space", "f", "d", "s"])
$*Down::modtap.onOtherKey("Down", ["Space", "f", "d", "s"])
$*Down up::modtap.onOtherKeyUp("Down", ["Space", "f", "d", "s"])
