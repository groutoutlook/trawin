#SingleInstance Force
#Requires AutoHotkey v2.0-a
A_IconHidden := true

transparencyEnabled := false
currentTransparency := 255
titleChangeDuration := 1000
currentProcess := ""

; Define hotkey to decrease transparency (Ctrl+Win+=)
^#!-:: {
    if (transparencyEnabled) {
        global currentTransparency := Max(currentTransparency - 10, 0)
        UpdateTransparency(currentProcess)
    }
}

; Define hotkey to increase transparency (Ctrl+Win+-)
^#!=:: {
    if (transparencyEnabled) {
        global currentTransparency := Min(currentTransparency + 10, 255)
        UpdateTransparency(currentProcess)
    }
}

; Example hotkey to set the current process (Ctrl+Win+RightClick)
^#!RButton:: {
    global currentProcess,transparencyEnabled,currentTransparency,titleChangeDuration
    currentProcess := WinGetProcessName("A")  ; Get the process name of the active window
    ToolTip "Process set to: " currentProcess


    ; Toggle transparency on or off
    if (!transparencyEnabled) {
        transparencyEnabled := true                ; Enable transparency mode
        currentTransparency := 220                 ; Set initial transparency level
        UpdateTransparency(currentProcess)         ; Apply transparency and show tooltip
    } else {
        ApplyTransparencyToProcess(currentProcess, "OFF") ; Turn off transparency
        transparencyEnabled := false               ; Reset flag
        currentTransparency := 255                 ; Reset to fully opaque
        SetTimer(() => ToolTip(), -titleChangeDuration)
    }

}

UpdateTransparency(processName) {
    global transparencyEnabled,currentTransparency
    ApplyTransparencyToProcess(processName, currentTransparency)
    
    if (transparencyEnabled) {
        MouseGetPos(&mouseX, &mouseY)
        ToolTip(Format("Process: {} | Opacity: {}", processName, currentTransparency), mouseX + 10, mouseY + 10)
        SetTimer(() => ToolTip(), -titleChangeDuration)
    }
}

ApplyTransparencyToProcess(processName, transparencyValue) {
    ; global currentProcess,transparencyEnabled,currentTransparency
    winList := WinGetList("ahk_exe " . processName)
    
    for hwnd in winList {
        if (transparencyValue = "OFF") {
            WinSetTransparent("OFF", hwnd)
        } else {
            WinSetTransparent(transparencyValue, hwnd)
        }
    }
}