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
$*` up::modtap.onOtherKeyUp("``")
$*1::modtap.onOtherKey("1", ["Space", "j", "k", "l"])
$*1 up::modtap.onOtherKeyUp("1")
$*2::modtap.onOtherKey("2", ["Space", "j", "k", "l"])
$*2 up::modtap.onOtherKeyUp("2")
$*3::modtap.onOtherKey("3", ["Space", "j", "k", "l"])
$*3 up::modtap.onOtherKeyUp("3")
$*4::modtap.onOtherKey("4", ["Space", "j", "k", "l"])
$*4 up::modtap.onOtherKeyUp("4")
$*5::modtap.onOtherKey("5", ["Space", "j", "k", "l"])
$*5 up::modtap.onOtherKeyUp("5")
$*6::modtap.onOtherKey("6", ["Space", "f", "d", "s"])
$*6 up::modtap.onOtherKeyUp("6")
$*7::modtap.onOtherKey("7", ["Space", "f", "d", "s"])
$*7 up::modtap.onOtherKeyUp("7")
$*8::modtap.onOtherKey("8", ["Space", "f", "d", "s"])
$*8 up::modtap.onOtherKeyUp("8")
$*9::modtap.onOtherKey("9", ["Space", "f", "d", "s"])
$*9 up::modtap.onOtherKeyUp("9")
$*0::modtap.onOtherKey("0", ["Space", "f", "d", "s"])
$*0 up::modtap.onOtherKeyUp("0")
$*-::modtap.onOtherKey("-", ["Space", "f", "d", "s"])
$*- up::modtap.onOtherKeyUp("-")
$*=::modtap.onOtherKey("=", ["Space", "f", "d", "s"])
$*= up::modtap.onOtherKeyUp("=")
$*Backspace::modtap.onOtherKey("Backspace", ["Space", "f", "d", "s"])
$*Backspace up::modtap.onOtherKeyUp("Backspace")
$*Tab::modtap.onOtherKey("Tab", ["Space", "j", "k", "l"])
$*Tab up::modtap.onOtherKeyUp("Tab")
$*q::modtap.onOtherKey("q", ["Space", "j", "k", "l"])
$*q up::modtap.onOtherKeyUp("q")
$*w::modtap.onOtherKey("w", ["Space", "j", "k", "l"])
$*w up::modtap.onOtherKeyUp("w")
$*e::modtap.onOtherKey("e", ["Space", "j", "k", "l"])
$*e up::modtap.onOtherKeyUp("e")
$*r::modtap.onOtherKey("r", ["Space", "j", "k", "l"])
$*r up::modtap.onOtherKeyUp("r")
$*t::modtap.onOtherKey("t", ["Space", "j", "k", "l"])
$*t up::modtap.onOtherKeyUp("t")
$*y::modtap.onOtherKey("y", ["Space", "f", "d", "s"])
$*y up::modtap.onOtherKeyUp("y")
$*u::modtap.onOtherKey("u", ["Space", "f", "d", "s"])
$*u up::modtap.onOtherKeyUp("u")
$*i::modtap.onOtherKey("i", ["Space", "f", "d", "s"])
$*i up::modtap.onOtherKeyUp("i")
$*o::modtap.onOtherKey("o", ["Space", "f", "d", "s"])
$*o up::modtap.onOtherKeyUp("o")
$*p::modtap.onOtherKey("p", ["Space", "f", "d", "s"])
$*p up::modtap.onOtherKeyUp("p")
$*[::modtap.onOtherKey("[", ["Space", "f", "d", "s"])
$*[ up::modtap.onOtherKeyUp("[")
$*]::modtap.onOtherKey("]", ["Space", "f", "d", "s"])
$*] up::modtap.onOtherKeyUp("]")
$*\::modtap.onOtherKey("\", ["Space", "f", "d", "s"])
$*\ up::modtap.onOtherKeyUp("\")
$*a::modtap.onOtherKey("a", ["Space", "j", "k", "l"])
$*a up::modtap.onOtherKeyUp("a")
$*g::modtap.onOtherKey("g", ["Space", "j", "k", "l"])
$*g up::modtap.onOtherKeyUp("g")
$*h::modtap.onOtherKey("h", ["Space", "f", "d", "s"])
$*h up::modtap.onOtherKeyUp("h")
$*;::modtap.onOtherKey(";", ["Space", "f", "d", "s"])
$*; up::modtap.onOtherKeyUp(";")
$*'::modtap.onOtherKey("'", ["Space", "f", "d", "s"])
$*' up::modtap.onOtherKeyUp("'")
$*Enter::modtap.onOtherKey("Enter", ["Space", "f", "d", "s"])
$*Enter up::modtap.onOtherKeyUp("Enter")
$*z::modtap.onOtherKey("z", ["Space", "j", "k", "l"])
$*z up::modtap.onOtherKeyUp("z")
$*x::modtap.onOtherKey("x", ["Space", "j", "k", "l"])
$*x up::modtap.onOtherKeyUp("x")
$*c::modtap.onOtherKey("c", ["Space", "j", "k", "l"])
$*c up::modtap.onOtherKeyUp("c")
$*v::modtap.onOtherKey("v", ["Space", "j", "k", "l"])
$*v up::modtap.onOtherKeyUp("v")
$*b::modtap.onOtherKey("b", ["Space", "j", "k", "l"])
$*b up::modtap.onOtherKeyUp("b")
$*n::modtap.onOtherKey("n", ["Space", "f", "d", "s"])
$*n up::modtap.onOtherKeyUp("n")
$*m::modtap.onOtherKey("m", ["Space", "f", "d", "s"])
$*m up::modtap.onOtherKeyUp("m")
$*,::modtap.onOtherKey(",", ["Space", "f", "d", "s"])
$*, up::modtap.onOtherKeyUp(",")
$*.::modtap.onOtherKey(".", ["Space", "f", "d", "s"])
$*. up::modtap.onOtherKeyUp(".")
$*/::modtap.onOtherKey("/", ["Space", "f", "d", "s"])
$*/ up::modtap.onOtherKeyUp("/")
$*Esc::modtap.onOtherKey("Esc", ["Space", "j", "k", "l"])
$*Esc up::modtap.onOtherKeyUp("Esc")
$*F1::modtap.onOtherKey("F1", ["Space", "j", "k", "l"])
$*F1 up::modtap.onOtherKeyUp("F1")
$*F2::modtap.onOtherKey("F2", ["Space", "j", "k", "l"])
$*F2 up::modtap.onOtherKeyUp("F2")
$*F3::modtap.onOtherKey("F3", ["Space", "j", "k", "l"])
$*F3 up::modtap.onOtherKeyUp("F3")
$*F4::modtap.onOtherKey("F4", ["Space", "j", "k", "l"])
$*F4 up::modtap.onOtherKeyUp("F4")
$*F5::modtap.onOtherKey("F5", ["Space", "j", "k", "l"])
$*F5 up::modtap.onOtherKeyUp("F5")
$*F6::modtap.onOtherKey("F6", ["Space", "f", "d", "s"])
$*F6 up::modtap.onOtherKeyUp("F6")
$*F7::modtap.onOtherKey("F7", ["Space", "f", "d", "s"])
$*F7 up::modtap.onOtherKeyUp("F7")
$*F8::modtap.onOtherKey("F8", ["Space", "f", "d", "s"])
$*F8 up::modtap.onOtherKeyUp("F8")
$*F9::modtap.onOtherKey("F9", ["Space", "f", "d", "s"])
$*F9 up::modtap.onOtherKeyUp("F9")
$*F10::modtap.onOtherKey("F10", ["Space", "f", "d", "s"])
$*F10 up::modtap.onOtherKeyUp("F10")
$*F11::modtap.onOtherKey("F11", ["Space", "f", "d", "s"])
$*F11 up::modtap.onOtherKeyUp("F11")
$*F12::modtap.onOtherKey("F12", ["Space", "f", "d", "s"])
$*F12 up::modtap.onOtherKeyUp("F12")
$*Home::modtap.onOtherKey("Home", ["Space", "f", "d", "s"])
$*Home up::modtap.onOtherKeyUp("Home")
$*End::modtap.onOtherKey("End", ["Space", "f", "d", "s"])
$*End up::modtap.onOtherKeyUp("End")
$*Insert::modtap.onOtherKey("Insert", ["Space", "f", "d", "s"])
$*Insert up::modtap.onOtherKeyUp("Insert")
$*Delete::modtap.onOtherKey("Delete", ["Space", "f", "d", "s"])
$*Delete up::modtap.onOtherKeyUp("Delete")
$*Left::modtap.onOtherKey("Left", ["Space", "f", "d", "s"])
$*Left up::modtap.onOtherKeyUp("Left")
$*Up::modtap.onOtherKey("Up", ["Space", "f", "d", "s"])
$*Up up::modtap.onOtherKeyUp("Up")
$*Right::modtap.onOtherKey("Right", ["Space", "f", "d", "s"])
$*Right up::modtap.onOtherKeyUp("Right")
$*Down::modtap.onOtherKey("Down", ["Space", "f", "d", "s"])
$*Down up::modtap.onOtherKeyUp("Down")
