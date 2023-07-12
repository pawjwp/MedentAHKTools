#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+t::
{
	i := "1/23/1945"

	ControlClick "RichEdit20A3", "ahk_class MedentClient"
	Sleep 200
	SendEvent "{Tab}"
	Sleep 200
	
	dateSplit := StrSplit(i, "/")
	SendEvent Format("{:02}", dateSplit[1])
	SendEvent Format("{:02}", dateSplit[2])
	Sleep 50
	SendEvent "{Left}"
	SendEvent "{Left}"
	Sleep 50
	SendEvent Format("{:04}", dateSplit[3])
	Sleep 200
	Send "{Enter}"
	
	waitUntilControlHasText("CHwndCppBase Window Class11", "Chart")
	
	if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = "Status" || ControlGetText("CHwndCppBase Window Class26", "ahk_class MedentClient") = "Status") {
		if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = "Status") {
			mouseMoveClick("CHwndCppBase Window Class25")
		}
		if (ControlGetText("CHwndCppBase Window Class26", "ahk_class MedentClient") = "Status") {
			mouseMoveClick("CHwndCppBase Window Class26")
		}
	}
}

mouseMoveClick(ClassNN, Window := "ahk_class MedentClient", speed := 1.0) {
	mouseGetPos(&oldx, &oldy)
	ControlGetPos &x, &y, &w, &h, ClassNN, Window
	Sleep 20 * speed
	MouseMove x + (w / 2), y + (h / 2)
	Sleep 100 * speed
	ControlClick ClassNN, Window
	Sleep 20 * speed
	MouseMove oldx, oldy
}

waitUntilControlHasText(TextMatch, Window := "ahk_class MedentClient", eachWait := 200, waitNum := 20) {
	i := 1
	Loop waitNum {
		endLoop := false
		try {
			for i in ControlText {
				if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = i) {
					endLoop := true
				}
			}
		}
		ToolTip i,,, 1
		Sleep eachWait
		if (endLoop) {
			break
		}
		i++
	}
}