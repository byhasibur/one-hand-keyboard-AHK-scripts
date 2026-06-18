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
    } else
        Gui1Setup()  ; Call the function directly
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
    if LongPress(200) {  ; Check if Space key is held down for more than 200ms
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
   --------------------------------------------------
   --------------------------------------------------
   -----------------------gui------------------------
   --------------------------------------------------
   --------------------------------------------------
*/

checkGui() {
    global guiOpen
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE

; Code to execute after the jump
if !guiOpen {
    guiOpen := true
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := false
    }
}

; Define the remapped hotkeys for switching between GUIs
#HotIf guiOpen
	;fn row
    $1::
    {
        DestroyGui()
        Gui1Setup()
    }
    $2::
    {
        DestroyGui()
        Gui2Setup()
    }
    $3::
    {
        DestroyGui()
        Gui3Setup()
    }
    $4::
    {
        DestroyGui()
        Gui4Setup()
    }
    $5::
    {
        DestroyGui()
        Gui5Setup()
    }

    ; Top row remapping
    $q::return
    $w::HandleNumber(7)
    $e::HandleNumber(8)
    $r::HandleNumber(9)
    $t::return

    ; Home row remapping
	$a::HandleNumber(1)
    $s::HandleNumber(4)
    $d::HandleNumber(5)
    $f::HandleNumber(6)
    $g::HandleNumber(0)

    ; Bottom row remapping
    $z::return
    $x::HandleNumber(1)
    $c::HandleNumber(2)
    $v::HandleNumber(3)
    $b::return

    $Alt::return
    $Tab::return
    $CapsLock::return
    $Down::return
    $Shift::return
    $Ctrl::return
    $Right::return

    $space::
    {
        global oGui1, oGui2, oGui3, oGui4, oGui5, oGui6

        global guiOpen, VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE
        global TOGGLE, INSERT_MODE, INSERT_MODE_II

        ; Destroy existing GUIs if they exist
        if IsObject(oGui1) {
            oGui1.Destroy()
            oGui1 := "" ; Optional: Reset variable to indicate no GUI is assigned
        }
        if IsObject(oGui2) {
            oGui2.Destroy()
            oGui2 := ""
        }
        if IsObject(oGui3) {
            oGui3.Destroy()
            oGui3 := ""
        }
        if IsObject(oGui4) {
            oGui4.Destroy()
            oGui4 := ""
        }
        if IsObject(oGui5) {
            oGui5.Destroy()
            oGui5 := ""
        }
        if IsObject(oGui6) {
            oGui6.Destroy()
            oGui6 := ""
        }

        guiOpen := false
        VIM_NORMAL_SPACE_MODE := false
        SYMBOL_MODE := false
        NUMBER_MODE := false
        INSERT_MODE := true

        if TOGGLE {
            INSERT_MODE_II := true
            ToolTip("Index", index_TooltipX, 0, 1)
        }
    }
#HotIf

liveDisplayGui() {

    ; Calculate the position for the input display GUI
    ScreenWidth := A_ScreenWidth ; 1920
    ScreenHeight := A_ScreenHeight ; 1080

	DisplayHeight := 40  ; Height of the input display box
	DisplayWidth := 85 ; Width of the input display box

	; Calculate Y position for the bottom of the screen
	DisplayY := ScreenHeight - DisplayHeight - 54  ; 20 pixels above the bottom for padding

	; Calculate X position to center the display horizontally
	DisplayX := (ScreenWidth - DisplayWidth) / 2.05  ; Use '/' for floating-point division

    ; Create the GUI window
    global oGui6 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui6.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)
    oGui6.SetFont("Bold s15", "Verdana")  ; Set the font size and style

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui6.BackColor := 000000) ' 255', oGui6)

    ; Add a text control to display the input
    oGui6.Add("Text", Format("w{} h{} BackgroundWhite center cBlack vLiveDisplay", DisplayWidth, DisplayHeight), NumberInput)

    ; Show the GUI with the specified parameters
    oGui6.Show(Format("x{} y{} w{} h{} NoActivate", DisplayX, DisplayY, DisplayWidth, DisplayHeight))
}

; Define the GUI setups
Gui1Setup() {
    global CurrentGui
    checkGui()
	CurrentGui := 1

    ; Create the GUI window
    global oGui1 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui1.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui1.BackColor := 000000) ' 255', oGui1)

	; Add transparent buttons w 150 h 120
	global ogcGui1Button11Action := oGui1.Add("Button", "x101 y1 w140 h110 BackgroundTrans", "Volume Min")
	ogcGui1Button11Action.OnEvent("Click", Gui1Button11Action)
	global ogcGui1Button12Action := oGui1.Add("Button", "x101 y119 w140 h110 BackgroundTrans ", "Volume Max")
	ogcGui1Button12Action.OnEvent("Click", Gui1Button12Action)
	global ogcGui1Button13Action := oGui1.Add("Button", "x101 y239 w140 h110 BackgroundTrans ", "Volume Mute")
	ogcGui1Button13Action.OnEvent("Click", Gui1Button13Action)
	global ogcGui1Button14Action := oGui1.Add("Button", "x101 y359 w140 h110 BackgroundTrans ", "Show Tooltip")
	ogcGui1Button14Action.OnEvent("Click", Gui1Button14Action)
	global ogcGui1Button15Action := oGui1.Add("Button", "x101 y479 w140 h110 BackgroundTrans ", "Null Value")
	ogcGui1Button15Action.OnEvent("Click", Gui1Button15Action)
;-------------------------------------------------------
	global ogcGui1Button16Action := oGui1.Add("Button", "x251 y1 w140 h110 BackgroundTrans ", "Button 16")
	ogcGui1Button16Action.OnEvent("Click", Gui1Button16Action)
	global ogcGui1Button17Action := oGui1.Add("Button", "x251 y119 w140 h110 BackgroundTrans ", "Button 17")
	ogcGui1Button17Action.OnEvent("Click", Gui1Button17Action)
	global ogcGui1Button18Action := oGui1.Add("Button", "x251 y239 w140 h110 BackgroundTrans ", "Button 18")
	ogcGui1Button18Action.OnEvent("Click", Gui1Button18Action)
	global ogcGui1Button19Action:= oGui1.Add("Button", "x251 y359 w140 h110 BackgroundTrans ", "Button 19")
	ogcGui1Button19Action.OnEvent("Click", Gui1Button19Action)
	global ogcGui1Button20Action := oGui1.Add("Button", "x251 y479 w140 h110 BackgroundTrans ", "Button 20")
	ogcGui1Button20Action.OnEvent("Click", Gui1Button20Action)
;----------------------------------------------------
	global ogcGui1Button21Action := oGui1.Add("Button", "x401 y1 w140 h110 BackgroundTrans ", "Button 21")
	ogcGui1Button21Action.OnEvent("Click", Gui1Button21Action)
	global ogcGui1Button22Action := oGui1.Add("Button", "x401 y119 w140 h110 BackgroundTrans ", "Button 22")
	ogcGui1Button22Action.OnEvent("Click", Gui1Button22Action)
	global ogcGui1Button23Action := oGui1.Add("Button", "x401 y239 w140 h110 BackgroundTrans ", "Button 23")
	ogcGui1Button23Action.OnEvent("Click", Gui1Button23Action)
	global ogcGui1Button24Action := oGui1.Add("Button", "x401 y359 w140 h110 BackgroundTrans ", "Button 24")
	ogcGui1Button24Action.OnEvent("Click", Gui1Button24Action)
	global ogcGui1Button25Action := oGui1.Add("Button", "x401 y479 w140 h110 BackgroundTrans ", "Button 25")
	ogcGui1Button25Action.OnEvent("Click", Gui1Button25Action)
;-------------------------------------
	global ogcGui1Button26Action := oGui1.Add("Button", "x551 y1 w140 h110 BackgroundTrans ", "Button 26")
	ogcGui1Button26Action.OnEvent("Click", Gui1Button26Action)
	global ogcGui1Button27Action := oGui1.Add("Button", "x551 y119 w140 h110 BackgroundTrans ", "Button 27")
	ogcGui1Button27Action.OnEvent("Click", Gui1Button27Action)
	global ogcGui1Button28Action := oGui1.Add("Button", "x551 y239 w140 h110 BackgroundTrans ", " Current Gui " CurrentGui)
	ogcGui1Button28Action.OnEvent("Click", Gui1Button28Action)
	global ogcGui1Button29Action := oGui1.Add("Button", "x551 y359 w140 h110 BackgroundTrans ", "Button 29")
	ogcGui1Button29Action.OnEvent("Click", Gui1Button29Action)
	global ogcGui1Button30Action := oGui1.Add("Button", "x551 y479 w140 h110 BackgroundTrans ", "Button 30")
	ogcGui1Button30Action.OnEvent("Click", Gui1Button30Action)
;---------------------------------
	global ogcGui1Button31Action := oGui1.Add("Button", "x701 y1 w140 h110 BackgroundTrans ", "Button 31")
	ogcGui1Button31Action.OnEvent("Click", Gui1Button31Action)
	global ogcGui1Button32Action := oGui1.Add("Button", "x701 y119 w140 h110 BackgroundTrans ", "Button 32")
	ogcGui1Button32Action.OnEvent("Click", Gui1Button32Action)
	global ogcGui1Button33Action := oGui1.Add("Button", "x701 y239 w140 h110 BackgroundTrans ", "Button 33")
	ogcGui1Button33Action.OnEvent("Click", Gui1Button33Action)
	global ogcGui1Button34Action := oGui1.Add("Button", "x701 y359 w140 h110 BackgroundTrans ", "Button 34")
	ogcGui1Button34Action.OnEvent("Click", Gui1Button34Action)
	global ogcGui1Button35Action := oGui1.Add("Button", "x701 y479 w140 h110 BackgroundTrans ", "Button 35")
	ogcGui1Button35Action.OnEvent("Click", Gui1Button35Action)
;-------------------------------------
	global ogcGui1Button36Action := oGui1.Add("Button", "x851 y1 w140 h110 BackgroundTrans ", "Button 36")
	ogcGui1Button36Action.OnEvent("Click", Gui1Button36Action)
	global ogcGui1Button37Action := oGui1.Add("Button", "x851 y119 w140 h110 BackgroundTrans ", "WSL Ubuntu Bash shell`n37")
	ogcGui1Button37Action.OnEvent("Click", Gui1Button37Action)
	global ogcGui1Button38Action := oGui1.Add("Button", "x851 y239 w140 h110 BackgroundTrans ", "Button 38")
	ogcGui1Button38Action.OnEvent("Click", Gui1Button38Action)
	global ogcGui1Button39Action := oGui1.Add("Button", "x851 y359 w140 h110 BackgroundTrans ", "Button 39")
	ogcGui1Button39Action.OnEvent("Click", Gui1Button39Action)
	global ogcGui1Button40Action := oGui1.Add("Button", "x851 y479 w140 h110 BackgroundTrans ", "Button 40")
	ogcGui1Button40Action.OnEvent("Click", Gui1Button40Action)
;--------------------------
	global ogcGui1Button41Action := oGui1.Add("Button", "x1001 y1 w140 h110 BackgroundTrans ", "Button 41")
	ogcGui1Button41Action.OnEvent("Click", Gui1Button41Action)
	global ogcGui1Button42Action := oGui1.Add("Button", "x1001 y119 w140 h110 BackgroundTrans ", "Button 42")
	ogcGui1Button42Action.OnEvent("Click", Gui1Button42Action)
	global ogcGui1Button43Action := oGui1.Add("Button", "x1001 y239 w140 h110 BackgroundTrans ", "Button 43")
	ogcGui1Button43Action.OnEvent("Click", Gui1Button43Action)
	global ogcGui1Button44Action:= oGui1.Add("Button", "x1001 y359 w140 h110 BackgroundTrans ", "Button 44")
	ogcGui1Button44Action.OnEvent("Click", Gui1Button44Action)
	global ogcGui1Button45Action := oGui1.Add("Button", "x1001 y479 w140 h110 BackgroundTrans ", "Button 45")
	ogcGui1Button45Action.OnEvent("Click", Gui1Button45Action)

	oGui1.Add("Button", "x1151 y239 w50 h110 BackgroundTrans ", "Next").OnEvent("Click", Gui1Button0Action)

    oGui1.OnEvent('Close', (*) => ExitApp())
	oGui1.Title := "Control Panel"
	oGui1.Show("w1246 h621")  ; Display the GUI with the buttons

	liveDisplayGui()
}

; Define the GUI setups
Gui2Setup() {
    global CurrentGui
    checkGui()
	CurrentGui := 2

    ; Create the GUI window
    global oGui2 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui2.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui2.BackColor := 000000) ' 255', oGui2)

    oGui2.Add("Button", "x41 y239 w50 h110 BackgroundTrans ", "Prev").OnEvent("Click", Gui2Button1Action)

	; Add transparent buttons w 150 h 120
	global ogcGui2Button11Action := oGui2.Add("Button", "x101 y1 w140 h110 BackgroundTrans", "Volume Min")
	;ogcGui2Button11Action.OnEvent("Click", Gui2Button11Action)
	global ogcGui2Button12Action := oGui2.Add("Button", "x101 y119 w140 h110 BackgroundTrans ", "Volume Max")
	;ogcGui2Button12Action.OnEvent("Click", Gui2Button12Action)
	global ogcGui2Button13Action := oGui2.Add("Button", "x101 y239 w140 h110 BackgroundTrans ", "Volume Mute")
	;ogcGui2Button13Action.OnEvent("Click", Gui2Button13Action)
	global ogcGui2Button14Action := oGui2.Add("Button", "x101 y359 w140 h110 BackgroundTrans ", "Show Tooltip")
	;ogcGui2Button14Action.OnEvent("Click", Gui2Button14Action)
	global ogcGui2Button15Action := oGui2.Add("Button", "x101 y479 w140 h110 BackgroundTrans ", "Null Value")
	ogcGui2Button15Action.OnEvent("Click", Gui2Button15Action)
;-------------------------------------------------------
	global ogcGui2Button16Action := oGui2.Add("Button", "x251 y1 w140 h110 BackgroundTrans ", "Button 16")
	;ogcGui2Button16Action.OnEvent("Click", Gui2Button16Action)
	global ogcGui2Button17Action := oGui2.Add("Button", "x251 y119 w140 h110 BackgroundTrans ", "Button 17")
	;ogcGui2Button17Action.OnEvent("Click", Gui2Button17Action)
	global ogcGui2Button18Action := oGui2.Add("Button", "x251 y239 w140 h110 BackgroundTrans ", "Button 18")
	;ogcGui2Button18Action.OnEvent("Click", Gui2Button18Action)
	global ogcGui2Button19Action:= oGui2.Add("Button", "x251 y359 w140 h110 BackgroundTrans ", "Button 19")
	;ogcGui2Button19Action.OnEvent("Click", Gui2Button19Action)
	global ogcGui2Button20Action := oGui2.Add("Button", "x251 y479 w140 h110 BackgroundTrans ", "Button 20")
	;ogcGui2Button20Action.OnEvent("Click", Gui2Button20Action)
;----------------------------------------------------
	global ogcGui2Button21Action := oGui2.Add("Button", "x401 y1 w140 h110 BackgroundTrans ", "Button 21")
	;ogcGui2Button21Action.OnEvent("Click", Gui2Button21Action)
	global ogcGui2Button22Action := oGui2.Add("Button", "x401 y119 w140 h110 BackgroundTrans ", "Button 22")
	;ogcGui2Button22Action.OnEvent("Click", Gui2Button22Action)
	global ogcGui2Button23Action := oGui2.Add("Button", "x401 y239 w140 h110 BackgroundTrans ", "Button 23")
	;ogcGui2Button23Action.OnEvent("Click", Gui2Button23Action)
	global ogcGui2Button24Action := oGui2.Add("Button", "x401 y359 w140 h110 BackgroundTrans ", "Button 24")
	;ogcGui2Button24Action.OnEvent("Click", Gui2Button24Action)
	global ogcGui2Button25Action := oGui2.Add("Button", "x401 y479 w140 h110 BackgroundTrans ", "Button 25")
	;ogcGui2Button25Action.OnEvent("Click", Gui2Button25Action)
;-------------------------------------
	global ogcGui2Button26Action := oGui2.Add("Button", "x551 y1 w140 h110 BackgroundTrans ", "Button 26")
	;ogcGui2Button26Action.OnEvent("Click", Gui2Button26Action)
	global ogcGui2Button27Action := oGui2.Add("Button", "x551 y119 w140 h110 BackgroundTrans ", "Button 27")
	;ogcGui2Button27Action.OnEvent("Click", Gui2Button27Action)
	global ogcGui2Button28Action := oGui2.Add("Button", "x551 y239 w140 h110 BackgroundTrans ", " Current Gui " CurrentGui)
	ogcGui2Button28Action.OnEvent("Click", Gui2Button28Action)
	global ogcGui2Button29Action := oGui2.Add("Button", "x551 y359 w140 h110 BackgroundTrans ", "Button 29")
	;ogcGui2Button29Action.OnEvent("Click", Gui2Button29Action)
	global ogcGui2Button30Action := oGui2.Add("Button", "x551 y479 w140 h110 BackgroundTrans ", "Button 30")
	;ogcGui2Button30Action.OnEvent("Click", Gui2Button30Action)
;---------------------------------
	global ogcGui2Button31Action := oGui2.Add("Button", "x701 y1 w140 h110 BackgroundTrans ", "Button 31")
	;ogcGui2Button31Action.OnEvent("Click", Gui2Button31Action)
	global ogcGui2Button32Action := oGui2.Add("Button", "x701 y119 w140 h110 BackgroundTrans ", "Button 32")
	;ogcGui2Button32Action.OnEvent("Click", Gui2Button32Action)
	global ogcGui2Button33Action := oGui2.Add("Button", "x701 y239 w140 h110 BackgroundTrans ", "Button 33")
	;ogcGui2Button33Action.OnEvent("Click", Gui2Button33Action)
	global ogcGui2Button34Action := oGui2.Add("Button", "x701 y359 w140 h110 BackgroundTrans ", "Button 34")
	;ogcGui2Button34Action.OnEvent("Click", Gui2Button34Action)
	global ogcGui2Button35Action := oGui2.Add("Button", "x701 y479 w140 h110 BackgroundTrans ", "Button 35")
	;ogcGui2Button35Action.OnEvent("Click", Gui2Button35Action)
;-------------------------------------
	global ogcGui2Button36Action := oGui2.Add("Button", "x851 y1 w140 h110 BackgroundTrans ", "Button 36")
	;ogcGui2Button36Action.OnEvent("Click", Gui2Button36Action)
	global ogcGui2Button37Action := oGui2.Add("Button", "x851 y119 w140 h110 BackgroundTrans ", "Button 37")
	;ogcGui2Button37Action.OnEvent("Click", Gui2Button37Action)
	global ogcGui2Button38Action := oGui2.Add("Button", "x851 y239 w140 h110 BackgroundTrans ", "Button 38")
	;ogcGui2Button38Action.OnEvent("Click", Gui2Button38Action)
	global ogcGui2Button39Action := oGui2.Add("Button", "x851 y359 w140 h110 BackgroundTrans ", "Button 39")
	;ogcGui2Button39Action.OnEvent("Click", Gui2Button39Action)
	global ogcGui2Button40Action := oGui2.Add("Button", "x851 y479 w140 h110 BackgroundTrans ", "Button 40")
	;ogcGui2Button40Action.OnEvent("Click", Gui2Button40Action)
;--------------------------
	global ogcGui2Button41Action := oGui2.Add("Button", "x1001 y1 w140 h110 BackgroundTrans ", "Button 41")
	;ogcGui2Button41Action.OnEvent("Click", Gui2Button41Action)
	global ogcGui2Button42Action := oGui2.Add("Button", "x1001 y119 w140 h110 BackgroundTrans ", "Button 42")
	;ogcGui2Button42Action.OnEvent("Click", Gui2Button42Action)
	global ogcGui2Button43Action := oGui2.Add("Button", "x1001 y239 w140 h110 BackgroundTrans ", "Button 43")
	;ogcGui2Button43Action.OnEvent("Click", Gui2Button43Action)
	global ogcGui2Button44Action:= oGui2.Add("Button", "x1001 y359 w140 h110 BackgroundTrans ", "Button 44")
	;ogcGui2Button44Action.OnEvent("Click", Gui2Button44Action)
	global ogcGui2Button45Action := oGui2.Add("Button", "x1001 y479 w140 h110 BackgroundTrans ", "Button 45")
	;ogcGui2Button45Action.OnEvent("Click", Gui2Button45Action)

    oGui2.Add("Button", "x1151 y239 w50 h110 BackgroundTrans ", "Next").OnEvent("Click", Gui2Button0Action)

    oGui2.OnEvent('Close', (*) => ExitApp())
	oGui2.Title := "Control Panel"
	oGui2.Show("w1246 h621")  ; Display the GUI with the buttons

    liveDisplayGui()
}

Gui3Setup() {
    global CurrentGui
	checkGui()
	CurrentGui := 3

    global oGui3 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui3.BackColor := "EEAA99"
    oGui3.Add("Text", "x10 y10 w200 h30", " Current Gui " CurrentGui)

    oGui3.Add("Button", "x100 y100 w200 h50 ", "Prev").OnEvent("Click", Gui3Button1Action)
	oGui3.Add("Button", "x100 y200 w200 h50 ", "Next").OnEvent("Click", Gui3Button0Action)

    oGui3.Title := "Control Panel"
    oGui3.Show("w400 h300")

    liveDisplayGui()
}

Gui4Setup() {
    global CurrentGui
	checkGui()
	CurrentGui := 4

    global oGui4 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui4.BackColor := "EEAA99"
    oGui4.Add("Text", "x10 y10 w200 h30", " Current Gui " CurrentGui)

    oGui4.Add("Button", "x100 y100 w200 h50 ", "Prev").OnEvent("Click", Gui4Button1Action)
	oGui4.Add("Button", "x100 y200 w200 h50 ", "Next").OnEvent("Click", Gui4Button0Action)

    oGui4.Title := "Control Panel"
    oGui4.Show("w400 h300")

    liveDisplayGui()
}

Gui5Setup() {
    global CurrentGui
	checkGui()
	CurrentGui := 5

    global oGui5 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui5.BackColor := "EEAA99"
    oGui5.Add("Text", "x10 y10 w200 h30", " Current Gui " CurrentGui)

    oGui5.Add("Button", "x100 y100 w200 h50 ", "Prev").OnEvent("Click", Gui5Button1Action)

    oGui5.Title := "Control Panel"
    oGui5.Show("w400 h300")

    liveDisplayGui()
}

; Handle number input and update live display
HandleNumber(Num) {
    global oGui6, guiOpen, NumberInput, LastInputTime
    if (guiOpen) {
        if (StrLen(NumberInput) < 2) {
            NumberInput .= Num
            LastInputTime := A_TickCount
            oGui6["LiveDisplay"].Value := NumberInput  ; ← moved inside
            SetTimer(ProcessInput, -500)               ; ← moved inside
        }
        ; if already 2 digits, do nothing — don't reset the timer
    }
}

ProcessInput()
{
    global guiOpen, NumberInput, LastInputTime, oGui6
    if (guiOpen && (A_TickCount - LastInputTime >= 500)) {
        TempInput := NumberInput
        ; Check if the input is a valid button number

        if (CurrentGui = 1) && (Gui1ButtonNumber(NumberInput)) {
            ResetDisplayAndInputField()
            Gui1Button%TempInput%Action()  ; Trigger corresponding button action
        }
        else if (CurrentGui = 2) && (Gui2ButtonNumber(NumberInput)) {
            ResetDisplayAndInputField()
            Gui2Button%TempInput%Action()  ; Trigger corresponding button action
        }
        else if (CurrentGui = 3) && (Gui3ButtonNumber(NumberInput)) {
            ResetDisplayAndInputField()
            Gui3Button%TempInput%Action()  ; Trigger corresponding button action
        }
        else if (CurrentGui = 4) && (Gui4ButtonNumber(NumberInput)) {
            ResetDisplayAndInputField()
            Gui4Button%TempInput%Action()  ; Trigger corresponding button daction
        }
        else if (CurrentGui = 5) && (Gui5ButtonNumber(NumberInput)) {
            ResetDisplayAndInputField()
            Gui5Button%TempInput%Action()  ; Trigger corresponding button action
        }
    }
}

ResetDisplayAndInputField()
{
    global oGui6, NumberInput

    ; Reset the display and input fields
    oGui6["LiveDisplay"].Value := "..."  ; Clear the live input display
    NumberInput := ""  ; Reset the input after handling
}


Gui1ButtonNumber(Num) {
    return (Num != "") && ((Num >= 11 && Num <= 45) || (Num = 0) || (Num = 1))
}

Gui2ButtonNumber(Num) {
    return (Num != "") && ((Num = 0) || (Num = 1) || (Num = 15) || (Num = 28))
}

Gui3ButtonNumber(Num) {
    return (Num != "") && ((Num = 0) || (Num = 1))
}

Gui4ButtonNumber(Num) {
    return (Num != "") && ((Num = 0) || (Num = 1))
}

Gui5ButtonNumber(Num) {
    return (Num != "") && ((Num = 0) || (Num = 1))
}

; -----------------------------DestroyGui--------------------------------------

DestroyGui() {
    global oGui1, oGui2, oGui3, oGui4, oGui5, oGui6

    ; Destroy existing GUIs if they exist
    if IsObject(oGui1) {
        oGui1.Destroy()
        oGui1 := "" ; Optional: Reset variable to indicate no GUI is assigned
    }
    if IsObject(oGui2) {
        oGui2.Destroy()
        oGui2 := ""
    }
    if IsObject(oGui3) {
        oGui3.Destroy()
        oGui3 := ""
    }
    if IsObject(oGui4) {
        oGui4.Destroy()
        oGui4 := ""
    }
    if IsObject(oGui5) {
        oGui5.Destroy()
        oGui5 := ""
    }
    if IsObject(oGui6) {
        oGui6.Destroy()
        oGui6 := ""
    }
}

Gui1Button1Action(*) ; 1 for prev
{
}

Gui1Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui2Setup()
}

Gui1Button00Action(*) ; 0 for next
{
    DestroyGui()
    Gui2Setup()
}

Gui2Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui1Setup()
}

Gui2Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui3Setup()
}

Gui2Button00Action(*) ; 0 for next
{
    DestroyGui()
    Gui3Setup()
}

Gui3Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui2Setup()
}

Gui3Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui4Setup()
}

Gui3Button00Action(*) ; 0 for next
{
    DestroyGui()
    Gui4Setup()
}

Gui4Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui3Setup()
}

Gui4Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui5Setup()
}

Gui4Button00Action(*) ; 0 for next
{
    DestroyGui()
    Gui5Setup()
}

Gui5Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui4Setup()
}

Gui5Button0Action(*) ; 0 for next
{
}

Gui5Button00Action(*) ; 0 for next
{
}

; ---------------------------------Gui1-----------------------------------------

Gui1Button11Action(*)
{
    ; Set volume to 0 (mute)
	SoundSetVolume(0)  ; Mute the system volume
	ToolTip(ogcGui1Button11Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button12Action(*)
{
	ToolTip(ogcGui1Button12Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button13Action(*)
{
	ToolTip(ogcGui1Button13Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button14Action(*)
{
	ToolTip(ogcGui1Button14Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button15Action(*)
{
	ToolTip(ogcGui1Button15Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button16Action(*)
{
	ToolTip(ogcGui1Button16Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button17Action(*)
{
	ToolTip(ogcGui1Button17Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button18Action(*)
{
	ToolTip(ogcGui1Button18Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button19Action(*)
{
	ToolTip(ogcGui1Button19Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button20Action(*)
{
	ToolTip(ogcGui1Button20Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button21Action(*)
{
    ToolTip(ogcGui1Button21Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button22Action(*)
{
    ToolTip(ogcGui1Button22Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button23Action(*)
{
    ToolTip(ogcGui1Button23Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button24Action(*)
{
    ToolTip(ogcGui1Button24Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button25Action(*)
{
    ToolTip(ogcGui1Button25Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button26Action(*)
{
    ToolTip(ogcGui1Button26Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button27Action(*)
{
    ToolTip(ogcGui1Button27Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button28Action(*)
{
    ToolTip(ogcGui1Button28Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button29Action(*)
{
    ToolTip(ogcGui1Button29Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button30Action(*)
{
    ToolTip(ogcGui1Button30Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button31Action(*)
{
    ToolTip(ogcGui1Button31Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button32Action(*)
{
    ToolTip(ogcGui1Button32Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button33Action(*)
{
    ToolTip(ogcGui1Button33Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button34Action(*)
{
    ToolTip(ogcGui1Button34Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button35Action(*)
{
    ToolTip(ogcGui1Button35Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button36Action(*)
{
    ToolTip(ogcGui1Button36Action.Text)
    Sleep(1000)
    ToolTip()
}


Gui1Button37Action(*)
{
    DestroyGui()

    ToolTip("Please wait... Opening WSL Ubuntu Bash shell")
    Sleep(500)
    ToolTip()

    ; Launch directly into the bash shell of Ubuntu
    ;Run('wt.exe -p "Ubuntu-22.04" -- wsl -d Ubuntu-22.04 -e bash -l')

    Run("wt.exe")
    /*
    🔧 To Set WSL as the Default Profile:

    i. Open Windows Terminal.
    ii. Click the down arrow (˅) next to the tab bar → choose Settings.
    iii. In Startup, set the Default profile to your desired WSL distribution (e.g., "Ubuntu").
    iv. Now, every time you open Windows Terminal, it starts in WSL by default.
    */

    global guiOpen, VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

        guiOpen := false
        VIM_NORMAL_SPACE_MODE := false
        SYMBOL_MODE := false
        NUMBER_MODE := false
        INSERT_MODE := true

        if TOGGLE {
            INSERT_MODE_II := true
            ToolTip("Index", index_TooltipX, 0, 1)
        }
}


/*
Gui1Button37Action(*)
{
    ToolTip('Please wait opening- Ubuntu: Bourne Again shell (bash)')

    Sleep(1000)
    ToolTip()
}
*/

Gui1Button38Action(*)
{
    ToolTip(ogcGui1Button38Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button39Action(*)
{
    ToolTip(ogcGui1Button39Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button40Action(*)
{
    ToolTip(ogcGui1Button40Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button41Action(*)
{
    ToolTip(ogcGui1Button41Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button42Action(*)
{
    ToolTip(ogcGui1Button42Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button43Action(*)
{
    ToolTip(ogcGui1Button43Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button44Action(*)
{
    ToolTip(ogcGui1Button44Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button45Action(*)
{
    ToolTip(ogcGui1Button45Action.Text)
    Sleep(1000)
    ToolTip()
}

; ---------------------------------Gui2-----------------------------------------

Gui2Button15Action(*) {
    ToolTip(ogcGui2Button15Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui2Button28Action(*)
{
    ToolTip(ogcGui2Button28Action.Text)
    Sleep(1000)
    ToolTip()
}

/*
   -----------------------------------------------
   ---------------Productivity mouse--------------
   -----------------------------------------------
   -----------------------------------------------
*/

global gui50 := ""

RButton::
{
    global gui50

    MouseGetPos(&startX, &startY)
    dragActivated := false

    loop {
        if !GetKeyState("RButton", "P") {
            if !dragActivated
                Send("{RButton}")  ; Only send right click if no drag occurred
            return
        }

        MouseGetPos(&curX, &curY)

        if (curY - startY > 20) {
            dragActivated := true
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
            break
        }
        Sleep(10)
    }
}

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

;--------------------------------------------------------------

f1::
{
    MyMenu := Menu()
    MyMenu.Add("A Item 1", item1handler)
    MyMenu.Add("B Item 2", item2handler)
    MyMenu.Show()
}

item1handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *) {
    MsgBox("You pressed item 1")
}

item2handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *) {
    MsgBox("You pressed item 2")
}

;-----------------------------------------------------

/*
RButton::
{
    g := Morse(300)

    If (g = "00") {
    }
    Else If (g = "0")
        MsgBox("0 Pressed")
}
*/

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------chrome autmation----------------
   ----------------------------------------------
   ----------------------------------------------
*/

#HotIf WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe",)
$space:: Send "{Space Down}"
$space Up:: Send "{Space Up}"
#HotIf

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------------mod-----------------------
   ----------------------------------------------
   ----------------------------------------------
*/

; --- Existing ---
PgUp Up:: Send "#{PrintScreen}"
; vk9E Up:: Send "#{PrintScreen}"

; ------------------------
; Emergency Screen Blank
; End key OR double-right-click
; ------------------------
; DPI button (VK9E) toggles black screen

global MyGui := 0
global ScreenOn := true

MButton Up::ToggleBlackScreen()
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