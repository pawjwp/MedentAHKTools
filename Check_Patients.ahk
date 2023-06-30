#SingleInstance Force

global People := Map() ; first value (key) is DOB, second is Name
global Output := ""

Loop Read "Patient_List.txt" {
	patientSplit := StrSplit(A_LoopReadLine, A_Tab)
	People[patientSplit[2]] := patientSplit[1]
	
	; old
	/*patientSplit := StrSplit(A_LoopReadLine, A_Tab)
	nameSplit := StrSplit(patientSplit[1], A_Space)
	dateSplit := StrSplit(patientSplit[2], "/")
	People[Format("{:02}/", dateSplit[1]) . Format("{:02}/", dateSplit[2]) . Format("{:04}", dateSplit[3])] := nameSplit[1] . " " . nameSplit[2]*/
}





^+r::Reload  ; Ctrl+Shift+R

^+c::
{
	SetKeyDelay 10
	
	for i, j in People { ; i is DOB, j is first, last name MI
		global Output
		Outcome := ""
		samePerson := false
		
		if (ControlGetText("CHwndCppBase Window Class14", "ahk_class MedentClient") = "Create account f") {
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
			Sleep 400
			
			/*
			loading := true
			while (loading) {
				try {
					if (ControlGetText("Pop Label Class1", "ahk_class MedentClient") = "No Patient(s) Found.") {
						loading := true
					}
					if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Select") {
					}
			}*/
			
			if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Select") {
				patientSelect := true
				while (patientSelect) {
					result := MsgBox("Please select " . j . " then click OK.`nClick cancel if the name is not shown",, "OC 4096")
					if (result = "OK") {
						if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") != "Select") {
							patientSelect := false
							samePerson := true
							Sleep 400
						}
					} else if (result = "Cancel") {
						patientSelect := false
						ControlClick "CHwndCppBase Window Class10", "ahk_class MedentClient"
						Outcome := "NO"
						Sleep 400
					}
				}
			}
			
			try {
				if (ControlGetText("Pop Label Class1", "ahk_class MedentClient") = "No Patient(s) Found.") {
					ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class11", "ahk_class MedentClient"
					Sleep 20
					MouseMove x + (w / 2), y + (h / 2)
					Sleep 80
					ControlClick "CHwndCppBase Window Class11", "ahk_class MedentClient"
					Sleep 200
					Outcome := "NO"
				}
			}
			
			if (Outcome = "") {
				Sleep 800
			}
			
			if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Chart") {
				; MsgBox(StrTitle(ControlGetText("RichEdit20A2", "ahk_class MedentClient") . ", " . ControlGetText("RichEdit20A1", "ahk_class MedentClient")) . "`n" . StrSplit(j, A_Space)[1] . " " . StrSplit(j, A_Space)[2])
				
				nameSplit := StrSplit(StrUpper(j), A_Space)
				FiLN := StrSplit(nameSplit[1], ",")[1]
				FiFN := StrSplit(nameSplit[2], ",")[1]
				
				MeLN := StrUpper(ControlGetText("RichEdit20A2", "ahk_class MedentClient"))
				MeFN := StrUpper(ControlGetText("RichEdit20A1", "ahk_class MedentClient"))
				
				if (FiFN = MeFN || FiLN = MeLN) {
					if (FiFN != MeFN || FiLN != MeLN) {
						result := MsgBox("Is " . FiFN . " " . FiLN . " and " . MeFN . " " . MeLN . " the same person?",, "YN 4096")
						if (result = "Yes") {
							samePerson := true
						} else {
							Outcome := "NO"
							backToMenu()
						}
					}
					if ((FiFN = MeFN && FiLN = MeLN) || samePerson) {
						if (ControlGetText("CHwndCppBase Window Class25", "ahk_class MedentClient") = "Status") {
							ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class25", "ahk_class MedentClient"
							Sleep 100
							MouseMove x + (w / 2), y + (h / 2)
							Sleep 100
							ControlClick "CHwndCppBase Window Class25", "ahk_class MedentClient"
							Sleep 800
							
							if (ControlGetText("CHwndCppBase Window Class12", "ahk_class MedentClient") = "Billing Related ") {
								k := ""
								try {
									k := ", " . StrUpper(StrSplit(ControlGetText("RichEdit20A1", "ahk_class MedentClient"), " ")[1])
								}
								Outcome := "YES" . k
								backToMenu()
							}
						}
					}
				} else {
					Outcome := "NO"
					backToMenu()
				}
			}
			
			ToolTip Outcome
			SetTimer () => ToolTip(), -3000
			
			Sleep 400
		}
		
		if (Outcome = "") {
			Output := Output . j .  A_Tab . i . "`n"
		} else {
			Output := Output . StrUpper(j) .  A_Tab . StrUpper(i) .  A_Tab . FormatTime(, "MM/dd/yyyy") .  A_Tab . Outcome . "`n"
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

backToMenu(*) {
	ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class5", "ahk_class MedentClient"
	Sleep 20
	MouseMove x + (w / 2), y + (h / 2)
	Sleep 200
	ControlClick "CHwndCppBase Window Class5", "ahk_class MedentClient"
	Sleep 400
}