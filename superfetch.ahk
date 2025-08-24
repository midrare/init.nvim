#Requires AutoHotkey >=v2.0
#SingleInstance Force
#NoTrayIcon
DetectHiddenWindows true


; prefetch.ahk
; Loads Neovim into Windows SysMain (Prefetch/Superfetch) by starting
; a hidden Neovim instance and closing it immediately.


ExePath := "nvim.exe"
GuiExePath := "nvim-qt.exe"
WaitSecs := 5
TimeoutSecs := 10


OutputDebug("Running exe: " ExePath)
Run('"' ExePath '" -c "qa!"',,"Hide", &Pid)


OutputDebug("Running exe: " GuiExePath)
Run(GuiExePath,,"Hide", &Pid)
OutputDebug("PID: " Pid)
If (Pid < 0) {
    OutputDebug("Invalid PID: " Pid)
    ExitApp 1
}

Loop 1000 {
    If (WinExist("ahk_pid " Pid)) {
        WinHide("ahk_pid " Pid)
        Break
    }
    Sleep(1)
}


OutputDebug("Waiting for window [ahk_pid " Pid "]")
WinWait("ahk_pid " Pid,, 5)

If (!ProcessWait(Pid, 1)) {
    OutputDebug("Process failed to start.")
    ExitApp 1
}

If (WinExist("ahk_pid " Pid)) {
    OutputDebug("Waiting for " WaitSecs "s")
    Sleep(WaitSecs * 1000)
}


If (WinExist("ahk_pid " Pid)) {
    OutputDebug("Trying WinClose(" Pid ")")
    WinClose("ahk_pid " Pid)
    If (ProcessWaitClose(Pid, TimeoutSecs) == 0) {
        OutputDebug("WinClose(" Pid ") was successful.")
        ExitApp 0
    } Else {
        OutputDebug("WinClose(" Pid ") failed.")
    }
}

If (WinExist("ahk_pid " Pid)) {
    OutputDebug("Trying WM_CLOSE " Pid)
    WM_CLOSE := 0x10
    SendMessage(WM_CLOSE, 0, 0, , "ahk_pid " Pid)
    If (ProcessWaitClose(Pid, 1) == 0) {
        OutputDebug("WM_CLOSE " Pid " was successful.")
        ExitApp 0
    } Else {
        OutputDebug("WM_CLOSE " Pid " failed.")
    }
}

If (WinExist("ahk_pid " Pid)) {
    OutputDebug("Trying WM_QUIT " Pid)
    WM_QUIT := 0x12
    PostMessage(WM_QUIT, 0, 0, , "ahk_pid " Pid)
    If (ProcessWaitClose(Pid, 1) == 0) {
        OutputDebug("WM_QUIT " Pid " was successful.")
        ExitApp 0
    } Else {
        OutputDebug("WM_QUIT " Pid " failed.")
    }
}

OutputDebug("Trying ProcessClose(" Pid ")")
ProcessClose(Pid)
If (ProcessWaitClose(Pid, 1) == 0) {
    OutputDebug("ProcessClose(" Pid ") was successful.")
    ExitApp 0
} Else {
    OutputDebug("ProcessClose(" Pid ") failed.")
}
