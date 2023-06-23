#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+c::
{
	; Start from documents screen
	SetKeyDelay 20
	
	if (ControlGetText("CHwndCppBase Window Class26", "ahk_class MedentClient") = "New") {
		ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class26", "ahk_class MedentClient"
		Sleep 100
		MouseMove x + (w / 2), y + (h / 2)
		Sleep 100
		ControlClick "CHwndCppBase Window Class26", "ahk_class MedentClient"
		Sleep 400
		SendEvent "cov risk"
		Sleep 100
		SendEvent "{Enter}"
		Sleep 400
	}
	if (ControlGetText("CHwndCppBase Window Class15", "ahk_class MedentClient") = "Scan") {
		ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class15", "ahk_class MedentClient"
		Sleep 100
		MouseMove x + (w / 2), y + (h / 2)
		Sleep 100
		ControlClick "CHwndCppBase Window Class15", "ahk_class MedentClient"
		Sleep 400
		SendEvent "{Enter}"
		Sleep 400
	}
	if (ControlGetText("Button2", "MEDENT Scanning Options") = "Scan In Photo Documents") {
		ControlGetPos &x, &y, &w, &h, "Button1", "MEDENT Scanning Options"
		Sleep 100
		MouseMove x + (w / 2), y + (h / 2)
		Sleep 100
		ControlClick "Button1", "MEDENT Scanning Options"
		Sleep 100
		SendEvent "{Down}"
		Sleep 100
		SendEvent "{Enter}"
		Sleep 8000
	}
	if (ControlGetText("CHwndCppBase Window Class23", "ahk_class MedentClient") = "Close/Exit") {
		ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class23", "ahk_class MedentClient"
		Sleep 100
		MouseMove x + (w / 2), y + (h / 2)
		Sleep 100
		ControlClick "CHwndCppBase Window Class23", "ahk_class MedentClient"
		Sleep 2000
	}
	/*if (ControlGetText("CHwndCppBase Window Class5", "ahk_class MedentClient") = "Main Menu") {
		ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class5", "ahk_class MedentClient"
		Sleep 100
		MouseMove x + (w / 2), y + (h / 2)
		Sleep 100
		ControlClick "CHwndCppBase Window Class5", "ahk_class MedentClient"
	}*/
}