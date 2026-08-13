#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
SendMode "Input"
SetWorkingDir A_ScriptDir

; =========================
; Configuration
; =========================
preWrittenText := "Could you please provide a revised version of my original question to enhance its native English fluency?"

codePath := "C:\Program Files\Microsoft VS Code\Code.exe"
windowsTerminal := "C:\Users\omid\AppData\Local\Microsoft\WindowsApps\wt.exe"
dataGripPath := "C:\Program Files\JetBrains\DataGrip 2025.3.4\bin\datagrip64.exe"
acrobatPath := "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
chromePath := "C:\Program Files\Google\Chrome\Application\chrome.exe"
postmanPath := "C:\Users\onajmi\AppData\Local\Postman\Postman.exe"
abricotinePath := "C:\Users\onajmi\AppData\Local\Programs\abricotine\Abricotine.exe"
obsidianPath := "C:\Users\omid\AppData\Local\Obsidian\Obsidian.exe"
unityPath := "E:\Program Files\UnityEditor\6000.3.18f1\Editor\Unity.exe"
zenPath := "C:\Program Files\Zen Browser\zen.exe"

SetCapsLockState "AlwaysOff"

; =========================
; Helper functions
; =========================
ActivateOrRun(winCriteria, exePath) {
    if WinExist(winCriteria)
        WinActivate(winCriteria)
    else
        Run exePath
}

SendTextViaClipboard(text) {
    clipSaved := ClipboardAll()
    A_Clipboard := text
    ClipWait 1
    Send "^v"
    Sleep 50
    A_Clipboard := clipSaved
}

SwitchToNextWindowOfSameApp() {
    activeHwnd := WinExist("A")
    if !activeHwnd
        return

    activeProcess := WinGetProcessName("ahk_id " activeHwnd)
    windows := WinGetList("ahk_exe " activeProcess)

    for hwnd in windows {
        if hwnd != activeHwnd {
            WinActivate("ahk_id " hwnd)
            break
        }
    }
}

ToggleMaxRestore() {
    state := WinGetMinMax("A")
    if (state = 1)
        WinRestore "A"
    else
        WinMaximize "A"
}

; =========================
; General hotkeys
; =========================

; Ctrl+Shift+X -> paste pre-written text while preserving clipboard
^+x:: SendTextViaClipboard(preWrittenText)

; Use CapsLock as Escape when tapped
*CapsLock::
{
    Send "{Blind}{Esc Down}"
    KeyWait "CapsLock"
    Send "{Blind}{Esc Up}"
    if (A_PriorKey = "CapsLock")
        return
}

; Disable Alt+Escape
!Escape:: return

; Vim-style navigation with CapsLock combos
CapsLock & h:: Send "{Left}"
CapsLock & j:: Send "{Down}"
CapsLock & k:: Send "{Up}"
CapsLock & l:: Send "{Right}"

; Ctrl+Space -> Win+Space
^Space:: Send "#{Space}"

; Alt+Q -> close active window
!q:: WinClose("A")

; =========================
; App launch / activate
; =========================

#w:: ActivateOrRun("ahk_exe Zen.exe", zenPath)
#c:: ActivateOrRun("ahk_exe Code.exe", codePath)
#z:: ActivateOrRun("ahk_exe Obsidian.exe", obsidianPath)
#t::
{
    if WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
        WinActivate("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
    else
        Run windowsTerminal
}
#Enter:: Run windowsTerminal
#+d:: ActivateOrRun("ahk_exe datagrip64.exe", dataGripPath)
#b:: ActivateOrRun("ahk_exe Acrobat.exe", acrobatPath)
#+w:: ActivateOrRun("ahk_exe chrome.exe", chromePath)
#p:: ActivateOrRun("ahk_exe Postman.exe", postmanPath)
#u:: ActivateOrRun("ahk_exe Unity.exe", unityPath)
#m:: ActivateOrRun("ahk_exe Abricotine.exe", abricotinePath)
; Win+E -> focus an existing Explorer window, otherwise open a new one
#e::
{
    activeIsExplorer := WinActive("ahk_class CabinetWClass")
    existingExplorer := WinExist("ahk_class CabinetWClass")

    if activeIsExplorer {
        ; اگر همین الان داخل Explorer هستی، یک پنجره جدید باز کن
        Run "explorer.exe"
    }
    else if existingExplorer {
        ; اگر Explorer باز هست ولی فعال نیست، همون را فعال کن
        WinRestore("ahk_id " existingExplorer)
        WinActivate("ahk_id " existingExplorer)
    }
    else {
        ; اگر هیچ Explorerی باز نیست، یکی جدید باز کن
        Run "explorer.exe"
    }
}

; Win+` -> switch between windows of same application
#`:: SwitchToNextWindowOfSameApp()
; Win+F -> toggle maximize/restore
#f:: ToggleMaxRestore()

; =========================
; Zen-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Zen.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!r:: Send "^r"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; VS Code-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Code.exe")
!+f:: Send "^+f"
!f:: Send "^f"
#HotIf

; =========================
; DataGrip-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe datagrip64.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; Acrobat-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Acrobat.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; Chrome-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe chrome.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!r:: Send "^r"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; Postman-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Postman.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; Abricotine-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Abricotine.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf

; =========================
; Obsidian-specific hotkeys
; =========================
#HotIf WinActive("ahk_exe Obsidian.exe")
![:: Send "^+{Tab}"
!]:: Send "^{Tab}"
!w:: Send "^w"
!e:: Send "^e"
!p:: Send "^p"
!t:: Send "^t"
!n:: Send "^n"
!l:: Send "^l"
!r:: Send "^r"
!+t:: Send "^+t"
!h:: Send "{WheelLeft}"
!j:: Send "{WheelDown}"
!k:: Send "{WheelUp}"
!;:: Send "{WheelRight}"
#HotIf