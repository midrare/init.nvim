#Requires AutoHotKey >=2.0
#NoTrayIcon

#include "%A_ScriptDir%/naiveargparse.ahk"

global WINDOWS_TERMINAL_START_DELAY_MS := 500
global WINDOWS_TERMINAL_POLL_MS := 250
global WINDOWS_TERMINAL_LAUNCHER := "wt.exe"
global WINDOWS_TERMINAL_EXE := "WindowsTerminal.exe"
global WINDOWS_TERMINAL_URI := "shell:AppsFolder\"
        . "Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"


; reference
; https://stackoverflow.com/a/73446628

ActivateWindowsTerminal(TermPid, TimeoutSecs := 5) {
    If (ProcessExist(TermPid) <= 0) {
        Return False
    }

    If (WinExist("ahk_pid " . TermPid,, TimeoutSecs) <= 0) {
        Return False
    }

    WinActivate("ahk_pid " . TermPid)
    If (WinWaitActive("ahk_pid " . TermPid,, TimeoutSecs) <= 0) {
        Return False
    }

    Return True
}

GetWindowsTerminalProcs() {
    ; https://www.autohotkey.com/docs/commands/Process.htm
    Query := "SELECT * FROM Win32_Process WHERE Name = '"
            . WINDOWS_TERMINAL_EXE . "'"
    Return ComObjGet("winmgmts:").ExecQuery(Query)
}

SendWindowsTerminalCmds(TermPid, Cmds) {
    If (!IsObject(Cmds)) {
        Cmds := [ Cmds ]
    }
    If (ActivateWindowsTerminal(TermPid)) {
        For _, Cmd In Cmds {
            SendInput(Cmd . "{Enter}")
        }
    }
}

OpenWindowsTerminal(WorkingDir, Profile := "", Cmd := "", TimeoutSecs := 5) {
    TermPid := -1

    OldProcs := GetWindowsTerminalProcs()
    Start := A_Hour * 60 * 60 + A_Min * 60 + A_Sec
    MidNight := 24 * 60 * 60
    UsedUri := False

    Try {
        TermCmd := WINDOWS_TERMINAL_LAUNCHER
        If (WorkingDir && StrLen(WorkingDir) > 0) {
            TermCmd := TermCmd
                    . " -d "
                    . "`"`"" . StrReplace(WorkingDir, "`"`"", "\`"`"") . "`"`""
        }
        If (Profile && StrLen(Profile) > 0) {
            TermCmd := TermCmd
                    . " -p "
                    . "`"`"" . StrReplace(Profile, "`"`"", "\`"`"") . "`"`""
        }
        Run(TermCmd,,, &TermPid)
        UsedUri := False
    } Catch as Ex {
        Run(WINDOWS_TERMINAL_URI, WorkingDir)
        UsedUri := True
    }

    While (True) {
        Now := A_Hour * 60 * 60 + A_Min * 60 + A_Sec
        If ((Now >= Start && Now - Start > TimeoutSecs)
                || (Now < Start && ((MidNight - Start) + Now > TimeoutSecs))) {
            Break
        }

        Procs := GetWindowsTerminalProcs()
        For Proc In Procs {
            IsNew := True
            For OldProc In OldProcs {
                If OldProc.ProcessId == Proc.ProcessId {
                    IsNew := False
                    Break
                }
            }

            If (IsNew) {
                TermPid := Proc.ProcessId
                Break
            }
        }

        If (TermPid >= 0) {
            Break
        }

        Sleep(WINDOWS_TERMINAL_POLL_MS)
    }

    If (TermPid >= 0) {
        WinWait("ahk_pid " . TermPid,, TimeoutSecs)
        If (UsedUri && WorkingDir && StrLen(WorkingDir) > 0) {
            SendWindowsTerminalCmds(TermPid, [ ("cd '" . WorkingDir . "'")
                , "cls; clear" ])
        }

        If (Cmd && StrLen(Cmd) > 0) {
            SendWindowsTerminalCmds(TermPid, [ Cmd ])
        }
    }

    Return TermPid
}

RunInWindowsTerminal(TermPid, Command) {
    If (!IsObject(Command)) {
        Command := [ Command ]
    }

    If (ActivateWindowsTerminal(TermPid)) {
        For I, Cmd In Command {
            If (I > 1) {
                SendInput(" ")
            }
            SendInput(Cmd)
        }
        SendInput("{Enter}")
    }
}


Args := NaiveParseArguments(A_Args)
OpenDir := A_WorkingDir

If (Args.GetParam("open-in-dir") && StrLen(Args.GetParam("open-in-dir")) > 0) {
    OpenDir := Args.GetParam("open-in-dir")
}

TermPid := -1

If (TermPid < 0 && Args.GetParam("reuse-pid")) {
    If (WinExist("ahk_pid " . Args.GetParam("reuse-pid")) > 0x0) {
        TermPid := Args.GetParam("reuse-pid")
    }
}

If (TermPid < 0 && Args.GetCount("reuse-scan") > 0) {
    Try {
        TermPid := WinGetPid("ahk_exe " . WINDOWS_TERMINAL_EXE)
        If (!TermPid || TermPid < 0) {
            TermPid := -1
        }
    } Catch TargetError as Ex {
        ; ignored
    }
}

If (TermPid < 0) {
    TermPid := OpenWindowsTerminal(OpenDir,
        Args.GetParam("open-with-profile"),
        Args.GetParam("open-with-cmd"))
}

If (TermPid >= 0) {
    If (Args.GetRemaining().Length > 0) {
        If (Args.GetParam("run-in-dir")
                && StrLen(Args.GetParam("run-in-dir") > 0)) {
            SendWindowsTerminalCmds(TermPid, [ ("cd '"
                . Args.GetParam("run-in-dir") . "'"),
                "cls; clear" ])
        }
        RunInWindowsTerminal(TermPid, Args.GetRemaining())
    } Else {
        ActivateWindowsTerminal(TermPid)
    }
}

If (Args.GetParam("ini-out") && StrLen(Args.GetParam("ini-out")) > 0) {
    OutPath := RegExReplace(Args.GetParam("ini-out"), "[\\/]+", "\")

    TempName := Random()
    TempName := A_Temp . "\" . "runterm-" . Floor(TempName) . ".tmp"

    OutDir := ""
    SplitPath(OutPath,, &OutDir)
    Try {
        DirCreate(OutDir)
    } Catch OSError as Ex {
        ; ignored
    }

    FileAppend("", TempName, "UTF-8")
    IniWrite(TermPid, TempName,"process", "pid")
    FileMove(TempName, OutPath, 1)
    Try {
        FileDelete(TempName)
    } Catch as Ex {
        ; ignored
    }
}

Exit(0)

