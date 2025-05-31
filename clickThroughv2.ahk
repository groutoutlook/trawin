#Requires AutoHotkey v2.0
#SingleInstance
#Include block-mouse-input.ahk

; Constants
WS_EX_TRANSPARENT := 0x20
GWL_EXSTYLE := -20
SWP_NOMOVE := 0x2
SWP_NOSIZE := 0x1
SWP_NOZORDER := 0x4
SWP_FRAMECHANGED := 0x20
SWP_FLAGS := SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED

; Toggle click-through for a given HWND (or active window if omitted)
; Returns true if click-through enabled, false if disabled
ToggleClickThrough(hwnd := "") {
    if hwnd = "" || hwnd = "A"
        hwnd := WinExist("A")  ; Get HWND of active window

    if !WinExist("ahk_id " hwnd)
        throw "Window does not exist"

    exStyle := DllCall("GetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt")

    if (exStyle & WS_EX_TRANSPARENT) {
        ; Disable click-through
        newExStyle := exStyle & ~WS_EX_TRANSPARENT
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt", newExStyle)
        DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", SWP_FLAGS)
        return false
    } else {
        ; Enable click-through
        newExStyle := exStyle | WS_EX_TRANSPARENT
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt", newExStyle)
        DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", SWP_FLAGS)
        return true
    }
}

; Check if a window is currently click-through
; Returns true if click-through, false if not, throws if window doesn't exist
IsClickThrough(hwnd := "") {
    if hwnd = "" || hwnd = "A"
        hwnd := WinExist("A")

    if !WinExist("ahk_id " hwnd)
        throw "Window does not exist"

    exStyle := DllCall("GetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt")
    return (exStyle & WS_EX_TRANSPARENT) != 0
}

; Hotkey Ctrl+Win+Alt+C to toggle click-through on the active window
^#!c::
{
    hwnd := WinExist("A")
    if hwnd {
        try {
            ; Send "^+{F3}"
            ; ToolTip "Click-through toggled"
            toggled := ToggleClickThrough(hwnd)
            if toggled
                Send "^+{F3}"
                ToolTip "Click-through enabled"
            else
                Send "^+{F3}"               
                ToolTip "Click-through disabled"
            SetTimer(() => ToolTip(), -1000)  ; Hide tooltip after 1 second
        } catch {
            MsgBox("Error: cant toggle?") ; e.Message
        }
    } else {
        MsgBox("No active window found.")
    }
}
