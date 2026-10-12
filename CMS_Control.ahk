#NoEnv
#SingleInstance Force
SendMode Input

SetMouseDelay, -1
SetKeyDelay, 0, 0
CoordMode, Mouse, Client

#IfWinActive ahk_exe CMS.exe

; Camera 1
Numpad1::
NumpadEnd::
TakeSnapshot(455, 234)
return

; Camera 2
Numpad2::
NumpadDown::
TakeSnapshot(1009, 234)
return

; Camera 3
Numpad3::
NumpadPgDn::
TakeSnapshot(455, 632)
return

; Camera 4
Numpad4::
NumpadLeft::
TakeSnapshot(1009, 632)
return

#IfWinActive
