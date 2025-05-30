#SingleInstance
#NoTrayIcon

; Initialize global variables
transparencyEnabled := false
currentTransparency := 255 ; Default full opacity
titleChangeDuration := 1000 ; Duration in milliseconds (1 second) for which the tooltip is displayed

; Toggle transparency with CTRL+WIN+ALT+RightClick
^#!RButton::
    ; Get the process name of the currently active window
    WinGet, currentProcess, ProcessName, A
    if (currentProcess = "") {
        MsgBox, 48, Error, No Process Found!
        return
    }

    ; Toggle transparency on or off
    if (!transparencyEnabled) {
        transparencyEnabled := true                ; Enable transparency mode
        currentTransparency := 220                 ; Set initial transparency level
        UpdateTransparency(currentProcess)         ; Apply transparency and show tooltip
    } else {
        ApplyTransparencyToProcess(currentProcess, "OFF") ; Turn off transparency
        transparencyEnabled := false               ; Reset flag
        currentTransparency := 255                 ; Reset to fully opaque
        ToolTip                                     ; Remove any tooltip
    }
return

; Increase transparency with CTRL+WIN+ALT+=
^#!=::
    if (transparencyEnabled) {
        currentTransparency -= 10
        if (currentTransparency < 0)
            currentTransparency := 0
        UpdateTransparency(currentProcess)
    }
return

; Decrease transparency with CTRL+WIN+ALT+-
^#!-::
    if (transparencyEnabled) {
        currentTransparency += 10
        if (currentTransparency > 255)
            currentTransparency := 255
        UpdateTransparency(currentProcess)
    }
return

; === Function: UpdateTransparency ===
; Applies transparency and displays a tooltip with current opacity
UpdateTransparency(processName) {
    global currentTransparency, transparencyEnabled, titleChangeDuration
    ApplyTransparencyToProcess(processName, currentTransparency)  ; Set window transparency

    if (transparencyEnabled) {
        MouseGetPos, mouseX, mouseY    ; Get current mouse position
        ToolTip, % "Process: " processName " | Opacity: " currentTransparency, mouseX + 10, mouseY + 10
        SetTimer, RemoveTooltip, -%titleChangeDuration%  ; Auto-remove tooltip after duration
    }
}


; === Function: ApplyTransparencyToProcess ===
; Applies a given transparency value to all windows of a specific process
ApplyTransparencyToProcess(processName, transparencyValue) {
    WinGet, winList, List, ahk_exe %processName%  ; Get all window handles for the process

    Loop, %winList% {
        hwnd := winList%A_Index%
        if (transparencyValue = "OFF") {
            WinSet, Transparent, OFF, ahk_id %hwnd%  ; Remove transparency
        } else {
            WinSet, Transparent, %transparencyValue%, ahk_id %hwnd%  ; Apply transparency value
        }
    }
}

; Function to remove the tooltip after the specified time
RemoveTooltip:
ToolTip ; Remove tooltip
return