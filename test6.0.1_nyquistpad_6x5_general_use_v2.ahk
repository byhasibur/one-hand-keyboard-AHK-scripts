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

index_TooltipX        := A_ScreenWidth / 2
normal_TooltipX       := index_TooltipX - 130
reload_TooltipX       := index_TooltipX - 45
arrowmode_TooltipX    := index_TooltipX - 35
suspend_TooltipX      := index_TooltipX + 50

NORMAL_SPACE_MODE := false
INDEX_MODE := true
ARROW_MODE := true
ToolTip("Arrow", arrowmode_TooltipX, 0, 8)

;-------------------------------------------------------------------

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

; LayoutSwitch()

#HotIf INDEX_MODE ; Start of INDEX_MODE

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
~Space & q:: Send "{CapsLock}"
~Space & w:: Send "{Tab}"
~Space & e::
~Space & r::
~Space & t::

;home row
~Space & a:: Send "{Up}"
~Space & s:: Send "{Down}"
~Space & d:: Send "{Left}"
~Space & d Up::
{
    global INDEX_MODE
    INDEX_MODE := true
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

*CapsLock::
{
    KeyWait("CapsLock")
    if (A_PriorKey = "CapsLock")
        Send "{Blind}{Enter}"
}

~CapsLock & a:: Send "+{Left}"
~CapsLock & d:: Send "+{Right}"
~CapsLock & w:: Send "+{Up}"
~CapsLock & s:: Send "+{Down}"

~LCtrl & Tab:: Send "{Blind}{Tab Down}"
~LCtrl & Tab Up:: Send "{Blind}{Tab Up}"

#HotIf ;end of INDEX_MODE


/*
   ----------------------------------------------
   ----------------------------------------------
   ------------Other modifier key----------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Suspend toggle
#SuspendExempt True

LCtrl & Space:: {
    if A_IsSuspended {
        Suspend
        ToolTip("", , , 7)  ; clear tooltip when unsuspending
    } else {
        Suspend
        ToolTip("Suspended", suspend_TooltipX, 0, 7)
    }
}

; Reload
LCtrl & Alt:: {
    ToolTip("Reloading...", reload_TooltipX, 0, 7)
    Sleep(1500)
    Reload
}

#SuspendExempt False

Shift & Space:: return

; Arrow mode
RShift:: {
    global ARROW_MODE
    ARROW_MODE := !ARROW_MODE
    ToolTip(ARROW_MODE ? "Arrow" : "", arrowmode_TooltipX, 0, 8)
}

#HotIf !ARROW_MODE
Up::    Send "?/"
Left::  Send "{Alt Down}"
Left Up:: Send "{Alt Up}"
Down::  Send "{Shift Down}"
Down Up:: Send "{Shift Up}"
Right:: Send "{Ctrl Down}"
Right Up:: Send "{Ctrl Up}"
#HotIf

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
    global INDEX_MODE
    global NORMAL_SPACE_MODE

    if !NORMAL_SPACE_MODE {
        NORMAL_SPACE_MODE := true
        INDEX_MODE := false

        ToolTip("Normal", normal_TooltipX, 0, 9)
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
    global INDEX_MODE
    if INDEX_MODE
        INDEX_MODE := false

    Send "{WheelUp 3}" ;scrollspeed:=5
}

$d Up::
{
    global INDEX_MODE

    INDEX_MODE := true
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
    global INDEX_MODE

    ToolTip(, , , 9)

    NORMAL_SPACE_MODE := false
    INDEX_MODE := true
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
                Send "#{PrintScreen}"
		; Send "{Shift}"

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

WheelUp:: {
    MouseGetPos(&mx)
    if (mx < A_ScreenWidth / 2)
        Send "{Volume_Up}"
    else
        Send "{vk7B}"  ; F12 = brightness up
}

WheelDown:: {
    MouseGetPos(&mx)
    if (mx < A_ScreenWidth / 2)
        Send "{Volume_Down}"
    else
        Send "{vk7A}"  ; F11 = brightness down
}

#HotIf

MouseIsOver(WinTitle) {
    MouseGetPos(, , &Win)
    Return WinExist(WinTitle " ahk_id " Win)
}

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Other additional code------------
   ----------------------------------------------
   ----------------------------------------------
*/

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