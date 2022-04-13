#SingleInstance force
ListLines 0
KeyHistory 0
SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.

; :*?:wouldnt::wouldn't
; :?*:wouldnt::wouldn't
; to
; sure("wouldnt","wouldn't")

A_Clipboard:=RegExReplace(A_Clipboard, "m)^:(?:\?\*|\*\?):(.*)::((?:[^:]|`:)*?)$", "sure(`"$1`",`"$2`")")

SoundPlay "*-1"
ToolTip A_Clipboard
sleep 500

Exitapp

f3::Exitapp