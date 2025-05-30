#Requires AutoHotkey v2.0
#SingleInstance Force

A_MaxHotkeysPerInterval := 2000
global Mouse_Blocked := false  ; Initialize globally

#^!x::
{
    global Mouse_Blocked
    Mouse_Blocked := !Mouse_Blocked  ; Toggle the state
    if (Mouse_Blocked)
        BlockInput "MouseMove"
    else
        BlockInput "MouseMoveOff"
    ToolTip "Mouse " . (Mouse_Blocked ? "Blocked" : "Unblocked")
    SetTimer () => ToolTip(), -2000
    return
}

#HotIf Mouse_Blocked
LButton::
; RButton::
; WheelUp::
; WheelDown::
{
    return
}

; New hotkey to check Mouse_Blocked state
#^!s::
{
    global Mouse_Blocked
    MsgBox "Mouse_Blocked is " . (Mouse_Blocked ? "True" : "False")
    return Mouse_Blocked  ; Returns the state for potential scripting use
}

#HotIf
