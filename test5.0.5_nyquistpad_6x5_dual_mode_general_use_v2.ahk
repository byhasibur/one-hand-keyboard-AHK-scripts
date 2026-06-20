#Requires AutoHotkey v2
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
;#InstallKeybdHook
#SingleInstance Force
A_MaxHotkeysPerInterval := 200
Persistent
SetCapsLockState "AlwaysOff"
CoordMode "ToolTip"
; Get current mouse cursor position
MouseGetPos(&mouseX, &mouseY)

INSERT_MODE := true
INSERT_MODE_II := false ; Variable to track the state of the index layer
TOGGLE := false
NORMAL_SPACE_MODE := false
LAYOUT_SWITCH_MODE := false

; Global variables to track which GUI is currently displayed
oGui1 := "", oGui2 := "", oGui3 := "", oGui4 := "", oGui5 := "", oGui6 := ""
CurrentGui := 1
TotalGuis := 5
guiOpen := false
NumberInput := "" ; initial value for gui live display

index_TooltipX := A_ScreenWidth / 2 ; tooltip 1 index layer
vim_normal_TooltipX_Space := index_TooltipX - 117 ; tooltip 2 noraml layer 1
normal_TooltipX_Alt := index_TooltipX - 117 ; tooltip 9 normal layer 2
chord_TooltipX := index_TooltipX ; tooltip 3 for display chord dict
chord_TooltipY := A_ScreenHeight - 34  ; Y coordinate at the very bottom edge of the screen
; A_CaretX-50, A_CaretY-50 ; tooltip 3 for display chord dict
number_TooltipX := index_TooltipX + 100 ; tooltip 4 number layer
symbol_TooltipX := index_TooltipX + 100 ; tooltip 5 symbol layer
numpad_symbol_TooltipX := index_TooltipX + 100 ; tooltip 6 numpad symbol layer
numpad_number_TooltipX := index_TooltipX + 100 ; tooltip 7 numpad number layer
; MouseGetPos, x, y tooltip 8 for rbutton copy message
del_yank_change_visual_inside_NormalMode_TooltipX := index_TooltipX - 225 ; tooltip for 10 delete, yank, change, visual mode operation

;-------------------------------------------------------------------

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

LShift & Space::
{
    LayoutSwitch()
}

LayoutSwitch() {
    global INSERT_MODE
    global TOGGLE
    global LAYOUT_SWITCH_MODE

        if INSERT_MODE {
            LAYOUT_SWITCH_MODE := true
            INSERT_MODE := false
            TOGGLE := false
            ;ToolTip("", , , 1)  ; Hides the tooltip
            ToolTip(".", index_TooltipX, 0, 1)  ; Show "Layout"
    } else {
        LAYOUT_SWITCH_MODE := false
        INSERT_MODE := true
        ToolTip("Welcome to INSERT MODE", index_TooltipX, 0, 1)  ; Show "Insert"
        ;ToolTip("", , , 1)  ; Hides the tooltip
    }
}

#HotIf LAYOUT_SWITCH_MODE ; Start of LAYOUT_SWITCH_MODE

; Detect if d is pressed and released without combination
*d::
{
    if KeyWait("d", "T0.1") ; Wait to see if the 'd' key is held down for 100ms
        return  ; If 'd' is held down, do nothing
    KeyWait("d")  ; Wait for the 'd' key to be released
    return
}

*d Up::
{
    ; Check if d is pressed alone
    if (A_PriorKey != "d")
        return  ; If the prior key wasn't d alone, do nothing

     Send "{Blind}d"
}

; Hotkeys for d & other N key combinations
~d & s:: Send "{Up}"
~d & f:: Send "{Down}"
~d & g::AltTab
~d & x:: Send "{Left}"
~d & v:: Send "{Right}"
~d & t:: Send "{Delete}"
~d & w::
~d & r::

~d & Space:: Send "{Blind}{Space Down}"
~d & Space Up:: Send "{Blind}{Space Up}"

*1:: Send "{Blind}1"
*2:: Send "{Blind}2"
*3:: Send "{Blind}3"
*4:: Send "{Blind}4"
*5:: Send "{Blind}5"

*q:: Send "{Blind}q"
*w:: Send "{Blind}w"
*e:: Send "{Blind}e"
*r:: Send "{Blind}r"
*t:: Send "{Blind}t"

*a:: Send "{Blind}a"
*s:: Send "{Blind}s"
*f:: Send "{Blind}f"
*g:: Send "{Blind}g"

*z:: Send "{Blind}z"
*x:: Send "{Blind}x"
*c:: Send "{Blind}c"
*v:: Send "{Blind}v"
*b:: Send "{Blind}b"

;fn row
~Space & 1:: return
~Space & 2:: return
~Space & 3:: return
~Space & 4:: return
~Space & 5:: return

;top row
~Space & w::
~Space & e::
~Space & r::
~Space & t::

;home row
~Space & a:: Send "{Up}"
~Space & s:: Send "{Down}"
~Space & d:: Send "{Left}"
~Space & d Up::
{
    ToolTip(".", index_TooltipX, 0, 1)  ; Show "Layout"

    global LAYOUT_SWITCH_MODE
    LAYOUT_SWITCH_MODE := true

    ToolTip(".", index_TooltipX, 0, 1)  ; Show "Layout"
}

~Space & f:: Send "{Right}"
~Space & g::

;bottom row
~Space & z::
~Space & x::
~Space & c::
~Space & v::
~Space & b::

*Tab:: Send "{Blind}{Backspace}"
*CapsLock:: Send "{Blind}{Enter}"

~LCtrl & Tab:: Send "{Blind}{Tab Down}"
~LCtrl & Tab Up:: Send "{Blind}{Tab Up}"

#HotIf ;end of LAYOUT_SWITCH_MODE


#HotIf INSERT_MODE ; Start of INSERT_MODE
; Detect if d is pressed and released without combination
$d::
{
    if KeyWait("d", "T0.1") ; Wait to see if the 'd' key is held down for 100ms
        return  ; If 'd' is held down, do nothing
    KeyWait("d")  ; Wait for the 'd' key to be released
    return
}

$d Up::
{
    global TOGGLE, INSERT_MODE_II ; https://www.autohotkey.com/boards/viewtopic.php?p=501239#p501239

    ; Check if d is pressed alone
    if (A_PriorKey != "d")
        return  ; If the prior key wasn't d alone, do nothing

    ; TOGGLE the INSERT_MODE_II state
    INSERT_MODE_II := !INSERT_MODE_II
    if INSERT_MODE_II {
        TOGGLE := true
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        TOGGLE := false
        ToolTip("", , , 1)  ; Hides the tooltip
    }
    return
}

; Hotkeys for d & other N key combinations
~d & s:: Send "{Up}"
~d & f:: Send "{Down}"
~d & g::AltTab
~d & x:: Send "{Left}"
~d & v:: Send "{Right}"
~d & t:: Send "{Delete}"
~d & w:: Send "{Home} {Up} {End} {Enter}"
~d & r:: Send "{End} {Enter}"
~d & Space::
{
    if LongPress(200) {   ; Check if Space key is held down for more than 200ms
        ToolTip("Long Press Test!")
        SetTimer(() => ToolTip(""), -1000)  ; Clear the tooltip after 1 second
    } ; else
        ; Gui1Setup()  ; Call the function directly
}

#HotIf INSERT_MODE_II ; start of INSERT_MODE_II
;fn row
;*Esc::
*1::
{
    if GetKeyState("CapsLock", "T")  ; Check if CapsLock is on
        SetCapsLockState("Off")      ; Turn CapsLock off
    else
        SetCapsLockState("On")       ; Turn CapsLock on
}
*2:: Send "{Tab}"
*3:: Send("{Backspace}")
*4:: indexMode("x")
*5:: return

;top row
*q:: indexMode("z")
*w:: indexMode("b")
; Custom remapped Enter key
;*e::handleEnter()
*e:: Send "{Enter}"
*r:: indexMode("g")
*t:: indexMode("j")

;home row
*a:: indexMode("u")
*s:: indexMode("o")
*f:: indexMode("r")
*g:: indexMode("c")

;bottom row
;*LShift::Tab
*z:: indexMode("m")
*x:: indexMode("y")
*c:: indexMode("v")
*v:: indexMode("f")
*b:: indexMode("p")

;fn row
~Space & 1:: return
~Space & 2:: return
~Space & 3:: return
~Space & 4:: return
~Space & 5:: return
;top row
~Space & w:: Send 2
~Space & e:: Send 3
~Space & r:: Send 4
~Space & t:: Send "{-}"

/*
	[2] [3] [4] [-]
[+] [1] [0] [5] [9]
[*] [6] [7] [8] [.]

*/

;home row
~Space & a:: Send "{+}"
~Space & s:: Send 1
~Space & d:: Send 0
~Space & d Up::
{
    global INSERT_MODE_II
    INSERT_MODE_II := true

    ToolTip("Index", index_TooltipX, 0, 1)
}
~Space & f:: Send 5
~Space & g:: Send 9
;bottom row
~Space & z:: Send "{*}"
~Space & x:: Send 6
~Space & c:: Send 7
~Space & v:: Send 8
~Space & b:: Send "{.}"

~LShift & Space::
{
    LayoutSwitch()
}
#HotIf ;end of INSERT_MODE_II

;fn row
*1::
{
    if GetKeyState("CapsLock", "T")  ; Check if CapsLock is on
        SetCapsLockState("Off")      ; Turn CapsLock off
    else
        SetCapsLockState("On")       ; Turn CapsLock on
}
*2:: Send "{Tab}"

*3:: Send "{Enter}"
*4:: indexMode("x")
*5:: return

;top row
*q:: indexMode("q")
*w:: indexMode("h")
*e:: indexMode("t")
*r:: indexMode("i")
*t:: indexMode("p")

;home row
*a:: indexMode("s")
*s:: indexMode("e")
*f:: indexMode("a")
*g:: indexMode("w")

;bottom row
*z:: indexMode("n")
*x:: indexMode("l")
*c:: Send("{Backspace}")
*v:: indexMode("d")
*b:: indexMode("k")

;fn row
~Space & 1:: return
~Space & 2:: return
~Space & 3:: return
~Space & 4:: return
~Space & 5:: return

;top row
~Space & w:: tapMode("w", "/", "\") ; two key hotkey short/long
~Space & e:: tapMode("e", "-", "_") ; two key hotkey short/long
~Space & r:: tapMode("r", "=", "+") ; two key hotkey short/long
~Space & t:: tapMode("t", "&", "$") ; two key hotkey short/long

;home row
~Space & a:: tapMode("a", "!", "%") ; two key hotkey short/long
~Space & s:: tapMode("s", "`'", "`"") ; two key hotkey short/long
~Space & d:: tapMode("d", ";", ":") ; two key hotkey short/long
~Space & d Up::
{
    global INSERT_MODE_II

    INSERT_MODE_II := false
    ToolTip("", , , 1)  ; Hides the tooltip
}
~Space & f:: tapMode("f", ".", ",") ; two key hotkey short/long
~Space & g:: tapMode("g", "*", "?") ; two key hotkey short/long

;bottom row
~Space & z:: tapMode("z", "<", ">") ; two key hotkey short/long
~Space & x:: tapMode("x", "[", "]") ; two key hotkey short/long
~Space & c:: tapMode("c", "(", ")") ; two key hotkey
~Space & v:: tapMode("v", "{", "}") ; two key hotkey
~Space & b:: tapMode("b", "#", "@") ; two key hotkey short/long

#HotIf ;end of INSERT_MODE

/*
   ----------------------------------------------
   ----------------------------------------------
   ------------Other modifier key----------------
   ----------------------------------------------
   ----------------------------------------------
*/

LShift & d::
{
    if !LAYOUT_SWITCH_MODE {
        global TOGGLE, INSERT_MODE_II

        ; TOGGLE the INSERT_MODE_II state
        INSERT_MODE_II := !INSERT_MODE_II

        if INSERT_MODE_II {
            ssTOGGLE := true
            ToolTip("Index", index_TooltipX, 0, 1)
        } else {
            TOGGLE := false
            ToolTip("", , , 1)
        }
    } else {
        Send "D"
    }
}

LCtrl & d::
{
    if !LAYOUT_SWITCH_MODE {
        global TOGGLE, INSERT_MODE_II

        ; TOGGLE the INSERT_MODE_II state
        INSERT_MODE_II := !INSERT_MODE_II

        if INSERT_MODE_II {
            ssTOGGLE := true
            ToolTip("Index", index_TooltipX, 0, 1)
        } else {
            TOGGLE := false
            ToolTip("", , , 1)
        }
    }
}

LCtrl & Space:: Suspend ; Hotkey to suspend the script
LCtrl & Alt:: Reload	; Hotkey to reload the script

Space::
{
    if LongPress(250) {  ; Check if Space key is held down for more than 200ms
        NormalLabelSpace()
    } else {
        Send "{Space}" ; Action for short press
    }
}

/*
   --------------------------------------------------
   --------------------------------------------------
   -------press space to active normal layer---------
   --------------------------------------------------
   --------------------------------------------------
*/

NormalLabelSpace() {
    global LAYOUT_SWITCH_MODE
    global NORMAL_SPACE_MODE
    global INSERT_MODE
    global INSERT_MODE_II

    if !NORMAL_SPACE_MODE {
        NORMAL_SPACE_MODE := true
        INSERT_MODE := false
        INSERT_MODE_II := false

        ToolTip("Normal", normal_TooltipX_Alt, 0, 9)
    }
}

#HotIf NORMAL_SPACE_MODE
;$1::#^c ;shortcut key to TOGGLE invert color filter
$1:: Send "{PrintScreen}"
$2:: Send "{LWin}"
$3:: Send "{F5}"
$4:: Reload() ; Hotkey to reload the script
$5:: Suspend() ; Hotkey to suspend the script

$q:: return
$w:: return
$e:: return
$r:: return
$t:: return

;$a:: MouseClick "left"
$s:: Send 7
$d::
{
    global LAYOUT_SWITCH_MODE
    if LAYOUT_SWITCH_MODE
        LAYOUT_SWITCH_MODE := false

    Send "{WheelUp 3}" ;scrollspeed:=5
}

$d Up::
{
    global LAYOUT_SWITCH_MODE

    ToolTip(".", index_TooltipX, 0, 1)  ; Show "Layout"
    LAYOUT_SWITCH_MODE := true
    ToolTip(".", index_TooltipX, 0, 1)  ; Show "Layout"
}

$f:: Send "{WheelDown 3}" ;scrollspeed:=5
$g:: return

$z:: return
$x:: return
$c:: return
$v:: return
$b:: return

$`:: Send "1"
$Tab:: Send "2"

SetCapsLockState "Off"

$CapsLock:: Send "3"

$Shift::
$Ctrl::
$LWin:: Send "6"
$Alt:: Send "{Space Down}"
$Alt Up:: Send "{Space Up}"

$Space::
{
    global NORMAL_SPACE_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    ToolTip(, , , 9)

    NORMAL_SPACE_MODE := false

    if LAYOUT_SWITCH_MODE {
        INSERT_MODE := false
    } else {
        INSERT_MODE := true

        if TOGGLE {
            INSERT_MODE_II := true

            ToolTip("Index", index_TooltipX, 0, 1)
        }
    }
}

LShift & Space::return ; do nothing
#HotIf
/*
   ----------------------------------------------
   ----------------------------------------------
   ----------------Numpad Keys-------------------
   ----------------------------------------------
   ----------------------------------------------
*/

; SC037 NumpadMult
SC11C::LShift ;numpadenter
SC053::LCtrl ;NumpadDot:Scancode has higher presidence

*SC051:: Send("{blind}{Control Down}{Shift Down}") ;Numpad3
*SC051 Up:: Send("{blind} {Control Up} {Shift Up}")

;SC04D::Alt ;Numpad6
/*
NumpadDot::
Send {LShift down}
KeyWait, NumpadDot ; wait for LShift to be released
Send {LShift up}
return
*/


/*
   -----------------------------------------------
   ---------------Productivity mouse--------------
   -----------------------------------------------
   -----------------------------------------------
*/

global gui50 := "" ; right click drag down
global lastRClickTime := 0 ; right click drag down

global MyGui := 0 ; double right click
global ScreenOn := true ; duoble right click


RButton::
{
    global gui50, lastRClickTime

    MouseGetPos(&startX, &startY)
    dragActivated := false
    direction := ""

    ; --- Double-click detection ---
    now := A_TickCount
    timeSinceLast := now - lastRClickTime
    lastRClickTime := now

    if (timeSinceLast < 400 && timeSinceLast > 0) {
        ; Wait for key release before firing double-click action
        KeyWait("RButton")
        ToggleBlackScreen()
        return
    }

    loop {
        if !GetKeyState("RButton", "P") {
            if !dragActivated
                Send("{RButton}")  ; Only send right click if no drag occurred
            return
        }

        MouseGetPos(&curX, &curY)

        deltaX := curX - startX
        deltaY := curY - startY

        ; Need 20px threshold in any direction
        if (Abs(deltaX) > 20 || Abs(deltaY) > 20) {
            dragActivated := true

            ; Determine dominant direction
            if (Abs(deltaY) >= Abs(deltaX)) {
                direction := (deltaY > 0) ? "down" : "up"
            } else {
                direction := (deltaX > 0) ? "right" : "left"
            }

            ; Wait for mouse release before acting
            KeyWait("RButton")

            if (direction = "down") {
                ; --- Original drag-down menu logic ---
                CoordMode("Mouse", "Screen")
                MouseGetPos(&XposA, &YposA)
                XposA -= 80
                YposA -= 80

                if IsObject(gui50)
                    gui50.Destroy()

                gui50 := Gui("+AlwaysOnTop -Caption +ToolWindow")
                gui50.BackColor := "EEAA99"
                WinSetTransColor((gui50.BackColor := 000000) ' 255', gui50)

                ; Buttons (1st column)
                gui50.Add("Button", "x2 y0 w50 h50 BackgroundTrans", "Button 1").OnEvent("Click", dothis10)
                gui50.Add("Button", "x2 y60 w50 h50 BackgroundTrans", "Undo").OnEvent("Click", dothis20)
                gui50.Add("Button", "x2 y120 w50 h50 BackgroundTrans", "Redo").OnEvent("Click", dothis30)
                gui50.Add("Button", "x2 y180 w50 h50 BackgroundTrans")
                gui50.Add("Button", "x2 y240 w50 h50 BackgroundTrans")

                ; Buttons (2nd column)
                gui50.Add("Button", "x62 y0 w50 h50")
                gui50.Add("Button", "x62 y60 w50 h50 BackgroundTrans", "Cut").OnEvent("Click", dothis3)
                gui50.Add("Button", "x62 y120 w50 h50 BackgroundTrans", "New Button 3").OnEvent("Click", dothis00)
                gui50.Add("Button", "x62 y180 w50 h50 BackgroundTrans", "New Button 9").OnEvent("Click", dothis14)
                gui50.Add("Button", "x62 y240 w50 h50 BackgroundTrans", "New Button 10").OnEvent("Click", dothis15)

                ; Buttons (3rd column)
                gui50.Add("Button", "x122 y0 w50 h50 BackgroundTrans", "Minimize").OnEvent("Click", dothis5)
                gui50.Add("Button", "x122 y60 w50 h50 BackgroundTrans", "Copy").OnEvent("Click", dothis4)
                gui50.Add("Button", "x122 y120 w50 h50 Background000000", "Close").OnEvent("Click", closewarnmenu)
                gui50.Add("Button", "x122 y180 w50 h50 BackgroundTrans", "New Button 11").OnEvent("Click", dothis11)
                gui50.Add("Button", "x122 y240 w50 h50 BackgroundTrans", "New Button 12").OnEvent("Click", dothis32)

                ; Buttons (4th column)
                gui50.Add("Button", "x182 y0 w50 h50 BackgroundTrans", "Maximize").OnEvent("Click", dothis1)
                gui50.Add("Button", "x182 y60 w50 h50 BackgroundTrans", "Paste").OnEvent("Click", dothis2)
                gui50.Add("Button", "x182 y120 w50 h50 BackgroundTrans", "Full Screen").OnEvent("Click", dothis13)
                gui50.Add("Button", "x182 y180 w50 h50 BackgroundTrans", "New Button 14").OnEvent("Click", dothis14)
                gui50.Add("Button", "x182 y240 w50 h50 BackgroundTrans", "New Button 59").OnEvent("Click", dothis59)

                ; Buttons (5th column)
                gui50.Add("Button", "x242 y0 w50 h50 BackgroundTrans", "WinClose").OnEvent("Click", dothis9)
                gui50.Add("Button", "x242 y60 w50 h50 BackgroundTrans", "Select All").OnEvent("Click", dothis100)
                gui50.Add("Button", "x242 y120 w50 h50 BackgroundTrans", "New Button 6").OnEvent("Click", dothis111)
                gui50.Add("Button", "x242 y180 w50 h50 BackgroundTrans", "New Button 99").OnEvent("Click", dothis99)
                gui50.Add("Button", "x242 y240 w50 h50 BackgroundTrans", "New Button 78").OnEvent("Click", dothis78)

                gui50.Title := "menus"
                gui50.Show("x" XposA " y" YposA " h300 w299")

            } else if (direction = "up") {
                MyMenu := Menu()
                MyMenu.Add("A Item 1", item1handler)
                MyMenu.Add("B Item 2", item2handler)
                MyMenu.Show()

            } else if (direction = "left") {
                MsgBox("Drag Left!")

            } else if (direction = "right") {
                Send("{F11}")
            }

            return
        }

        Sleep(10)
    }
}

; ------------------------
; Emergency Screen Blank
; Double Right Click
; ------------------------
; Double Right Click toggles black screen


; MButton Up::ToggleBlackScreen()
End::ToggleBlackScreen()

ToggleBlackScreen() {
    global MyGui, ScreenOn

    if ScreenOn {
        MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
        MyGui.BackColor := "Black"
        MyGui.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)
        ScreenOn := false
    } else {
        if IsObject(MyGui)
            MyGui.Destroy()

        ScreenOn := true
    }
}
; ------------------------------
; Code Function
; Right Click and Drag Down
; ------------------------------
; Right Click and Drag Down toggles Menu

dothis00(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 3")
}

closewarnmenu(*) {
    if IsObject(gui50)
        gui50.Destroy()
}

dothis1(*) {
    if IsObject(gui50)
        gui50.Destroy()
    WinMaximize("A")
}

dothis2(*) {
    Send("^p")
}

dothis3(*) {
    Send("^x")
}

dothis4(*) {
    Send("^c")
}

dothis5(*) {
    if IsObject(gui50)
        gui50.Destroy()
    WinMinimize("A")
}

dothis9(*) {
    if IsObject(gui50)
        gui50.Destroy()
    WinClose("A")
}

dothis10(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 5")
}

dothis11(*) {
    if IsObject(gui50)
        gui50.Destroy()

    MsgBox("New Button 6")
}

dothis13(*) {
    if IsObject(gui50)
        gui50.Destroy()
    Send("{F11}")
}

dothis14(*) {
    if IsObject(gui50)
        gui50.Destroy()

    MsgBox("New Button 9")
}

dothis15(*) {
    if IsObject(gui50)
        gui50.Destroy()

    MsgBox("New Button 10")
}

dothis20(*) {
    Send("^z")
}

dothis30(*) {
    Send("^y")
}

dothis32(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 17")
}

dothis59(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 59")
}

dothis78(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 78")
}

dothis100(*) {
    Send("^a")
}

dothis111(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 15")
}

dothis99(*) {
    if IsObject(gui50)
        gui50.Destroy()
    MsgBox("New Button 99")
}

; ------------------------------
; Code Function
; Right Click and Drag Up
; ------------------------------
; Right Click and Drag Up toggles Menu


item1handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *) {
    MsgBox("You pressed item 1")
}

item2handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *) {
    MsgBox("You pressed item 2")
}


/*
  ----------------------------------------------
  ----------------------------------------------
  ----------------change volume-----------------
  ----------------------------------------------
  ----------------------------------------------
*/

#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp:: Send "{Volume_Up}"
WheelDown:: Send "{Volume_Down}"
#HotIf

MouseIsOver(WinTitle)
{
    MouseGetPos(, , &Win)
    Return WinExist(WinTitle . " ahk_id " . Win)
}

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Other additional code------------
   ----------------------------------------------
   ----------------------------------------------
*/

tapMode(physicalKey, shortTap, longTap)
{
    if (physicalKey == "" && longTap == "") {
        Send("{blind}{" shortTap "}")
    }
    else {
        ErrorLevel := !KeyWait(physicalKey, "T0.16")

        if (ErrorLevel) {
            SetKeyDelay(-1)
            Send("{blind}{" longTap "}")
        }
        else {
            SetKeyDelay(-1)
            Send("{blind}{" shortTap "}")
        }

        ErrorLevel := !KeyWait(physicalKey)
        return
    }
}

indexMode(key) {
    ; Check if Ctrl is pressed
    if GetKeyState("Ctrl", "P") {
        SendInput("{Ctrl down}" key "{Ctrl up}")  ; Send Ctrl+u

        ; Check if Alt is pressed
    } else if GetKeyState("Alt", "P") {
        SendInput("{Alt down}" key "{Alt up}")  ; Send Alt+u

        ; Check if Shift is pressed
    } else if GetKeyState("Shift", "P") {
        SendInput("{Shift down}" key "{Shift up}")  ; Send Shift+u (uppercase U)

        ; If no modifier is pressed
    } else
        SendInput(key)   ; Send lowercase u
}

LongPress(Timeout) {
    RegExMatch(Hotkey := A_ThisHotkey, "\W$|\w*$", &Key)
    KeyWait((Key && Key[0]))
    IF ((Key && Key[0]) Hotkey) != (A_PriorKey A_ThisHotkey)
        Exit()
    Return A_TimeSinceThisHotkey > Timeout
}

Morse(Timeout) {
    tout := Timeout / 1000
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    Loop {
        t := A_TickCount
        ErrorLevel := !KeyWait(key)
        Pattern .= A_TickCount - t > Timeout
        ErrorLevel := !KeyWait(key, "DT" tout)
        if (ErrorLevel)
            Return Pattern
    }
}