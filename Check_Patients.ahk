#SingleInstance Force

global People := Array()
global Output := ""

Loop Read "Patient_List.txt" {
	patientSplit := StrSplit(A_LoopReadLine, A_Tab)
	People.Push(patientSplit)
	
	; old
	/*patientSplit := StrSplit(A_LoopReadLine, A_Tab)
	nameSplit := StrSplit(patientSplit[1], A_Space)
	dateSplit := StrSplit(patientSplit[2], "/")
	People[Format("{:02}/", dateSplit[1]) . Format("{:02}/", dateSplit[2]) . Format("{:04}", dateSplit[3])] := nameSplit[1] . " " . nameSplit[2]*/
}





^+r::Reload  ; Ctrl+Shift+R

^+c::
{
	cancelling := false
	SetKeyDelay 10
	
	Loop People.Length { ; i is DOB, j is first, last name MI
		i := People[A_Index][2]
		j := People[A_Index][1]
		
		global Output
		Outcome := ""
		samePerson := false
		
		if (!cancelling) {
			waitUntilControlHasText("CHwndCppBase Window Class14", "Create account f")
		}
		
		if (ControlGetText("CHwndCppBase Window Class14", "ahk_class MedentClient") = "Create account f" && !cancelling) {
			Sleep 100
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
			
			waitUntilControlHasText("CHwndCppBase Window Class11", ["Continue", "Select", "Chart"])
			
			try {
				if (ControlGetText("Pop Label Class1", "ahk_class MedentClient") = "No Patient(s) Found.") {
					mouseMoveClick("CHwndCppBase Window Class11")
					Sleep 200
					Outcome := "NO"
				}
			}
			
			if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Select") {
				patientSelect := true
				while (patientSelect) {
					MouseMove 250, 200
					result := MsgBox("Please select " . j . " then click Yes.`nIf name is not shown, click No",, "YNC 4096")
					if (result = "Yes") {
						if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") != "Select") {
							patientSelect := false
							samePerson := true
							Sleep 200
						}
					} else if (result = "No") {
						patientSelect := false
						mouseMoveClick("CHwndCppBase Window Class10")
						Outcome := "NO"
					} else if (result = "Cancel") {
						patientSelect := false
						mouseMoveClick("CHwndCppBase Window Class10")
						cancelling := true
					}
				}
			}
			
			if (Outcome = "") {
				waitUntilControlHasText("CHwndCppBase Window Class11", "Chart")
			}
			
			if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Chart") {
				; MsgBox(StrTitle(ControlGetText("RichEdit20A2", "ahk_class MedentClient") . ", " . ControlGetText("RichEdit20A1", "ahk_class MedentClient")) . "`n" . StrSplit(j, A_Space)[1] . " " . StrSplit(j, A_Space)[2])
				
				nameSplit := StrSplit(StrUpper(j), A_Space)
				FiLN := StrSplit(nameSplit[1], ",")[1]
				FiFN := StrSplit(nameSplit[2], ",")[1]
				
				MeLN := StrUpper(ControlGetText("RichEdit20A2", "ahk_class MedentClient"))
				MeFN := StrUpper(ControlGetText("RichEdit20A1", "ahk_class MedentClient"))
				
				if (FiFN = MeFN || FiLN = MeLN || samePerson) {
					if ((FiFN != MeFN || FiLN != MeLN) || (FiFN != MeFN && FiLN != MeLN && samePerson)) {
						result := MsgBox("Is " . FiFN . " " . FiLN . " and " . MeFN . " " . MeLN . " the same person?",, "YNC 4096")
						if (result = "Yes") {
							samePerson := true
						} else if (result = "No") {
							Outcome := "NO"
							mouseMoveClick("CHwndCppBase Window Class5")
						} else if (result = "Cancel") {
							mouseMoveClick("CHwndCppBase Window Class5")
							cancelling := true
							Sleep 100
						}
					}
					if ((FiFN = MeFN && FiLN = MeLN) || samePerson) {
						if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = "Status" || ControlGetText("CHwndCppBase Window Class26", "ahk_class MedentClient") = "Status") {
							if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = "Status") {
								mouseMoveClick("CHwndCppBase Window Class25")
							}
							if (ControlGetText("CHwndCppBase Window Class26", "ahk_class MedentClient") = "Status") {
								mouseMoveClick("CHwndCppBase Window Class26")
							}
							
							Sleep 800
							
							if (ControlGetText("CHwndCppBase Window Class12", "ahk_class MedentClient") = "Billing Related ") {
								k := ""
								try {
									k := ", " . StrUpper(StrSplit(ControlGetText("RichEdit20A1", "ahk_class MedentClient"), " ")[1])
								}
								Outcome := "YES" . k
								mouseMoveClick("CHwndCppBase Window Class5")
							}
						}
					}
				} else {
					Outcome := "NO"
					mouseMoveClick("CHwndCppBase Window Class5")
				}
			}
			
			ToolTip Outcome
			SetTimer () => ToolTip(), -3000
			
			Sleep 400
		}
		
		if (Outcome = "") {
			for p in People[A_Index] {
				Output := Output . p . A_Tab
			}
			Output := Output . "`n"
		} else {
			for p in People[A_Index] {
				Output := Output . StrUpper(p) . A_Tab
			}
			
			if (People[A_Index].Length < 4) {
				Output := Output . FormatTime(, "MM/dd/yyyy") .  A_Tab
			}
			
			Output := Output . Outcome . "`n"
		}
	}
	
	try FileDelete "Output.txt"
	FileAppend Output, "Output.txt"
}





/*waitUntilLoad(*) {
	try {
		ControlGetPos &x, &y, &w, &h, "White Area Class1", "ahk_class MedentClient"
		MsgBox(x . y . w . h)
	}
}*/

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

waitUntilControlHasText(ClassNN, ControlText, Window := "ahk_class MedentClient", eachWait := 100, waitNum := 50) {
	Loop waitNum {
		endLoop := false
		try {
			if (IsObject(ControlText)) {
				for i in ControlText {
					if (ControlGetText(ClassNN, "ahk_class MedentClient") = i) {
						endLoop := true
					}
				}
			}
			if (ControlGetText(ClassNN, "ahk_class MedentClient") = ControlText) {
				endLoop := true
			}
		}
		if (endLoop) {
			break
		}
		Sleep eachWait
	}
}