#SingleInstance Force

global Output := ""

; Initialize Gui
CheckPatientGui := Gui(, "Check Patient Status")

; Street Address
CheckPatientGui.AddText("Section", "Input:")
InputText := CheckPatientGui.AddEdit("XS Section w480 r10 -Wrap vInputText")
CheckPatientGui.AddText("XS Section", "Output:")
OutputText := CheckPatientGui.AddEdit("XS Section w480 r10 -Wrap vOutputText")

; Options
CheckPatientGui.AddText("XS Section", "Options:")
SkipUserInput := CheckPatientGui.AddCheckBox("XS Section vSkipUserInput", "Skip People Requiring Input?")



; Create Run Button
RunBtn := CheckPatientGui.AddButton("Default XM Section", "Run")
RunBtn.OnEvent("Click", (*) => ProcessUserInput())

; Create Exit Button
ExitBtn := CheckPatientGui.AddButton("YS", "Exit")
ExitBtn.OnEvent("Click", (*) => CheckPatientGui.Destroy())

CheckPatientGui.OnEvent('Escape', (*) => CheckPatientGui.Destroy())

CheckPatientGui.Show()





ProcessUserInput(*)	{
	cancelling := false
	SetKeyDelay 10
	
	
	while ((StrLen(InputText.Value) > 1) and !cancelling) {
		Inputs := StrSplit(InputText.Value, "`n",, 2)
		patientSplit := StrSplit(Inputs[1], A_Tab)
		
		i := patientSplit[2]
		j := patientSplit[1]
		
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
			
			if (waitUntilControlHasText("CHwndCppBase Window Class11", ["Continue", "Select", "Chart"])) {
				if (MsgBox("Loading timed out, would you like to continue?",, "YC 4096") = "Cancel") {
					cancelling := true
				}
			}
			
			
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
					if (SkipUserInput.Value) {
						result := "Skip"
					} else {
						result := MsgBox("Please select " . j . " then click Yes.`nIf name is not shown, click No",, "YNC 4096")
					}
					
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
					} else if (result = "Skip") {
						patientSelect := false
						mouseMoveClick("CHwndCppBase Window Class10")
					}
				}
			}
			
			if (Outcome = "" && !SkipUserInput.Value) {
				waitUntilControlHasText("CHwndCppBase Window Class11", "Chart")
			}
			
			if (ControlGetText("CHwndCppBase Window Class11", "ahk_class MedentClient") = "Chart") {
				nameSplit := StrSplit(StrUpper(j), A_Space)
				FiLN := StrSplit(nameSplit[1], ",")[1]
				FiFN := StrSplit(nameSplit[2], ",")[1]
				
				MeLN := StrUpper(ControlGetText("RichEdit20A2", "ahk_class MedentClient"))
				MeFN := StrUpper(ControlGetText("RichEdit20A1", "ahk_class MedentClient"))
				
				if (FiFN = MeFN || FiLN = MeLN || samePerson) {
					if ((FiFN != MeFN || FiLN != MeLN) || (FiFN != MeFN && FiLN != MeLN && samePerson)) {
						if (SkipUserInput.Value) {
							result := "Skip"
						} else {
							result := MsgBox("Is " . FiFN . " " . FiLN . " and " . MeFN . " " . MeLN . " the same person?",, "YNC 4096")
						}
						
						if (result = "Yes") {
							samePerson := true
						} else if (result = "No") {
							Outcome := "NO"
							mouseMoveClick("CHwndCppBase Window Class5")
						} else if (result = "Cancel") {
							mouseMoveClick("CHwndCppBase Window Class5")
							cancelling := true
							Sleep 100
						} else if (result = "Skip") {
							mouseMoveClick("CHwndCppBase Window Class5")
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
						
							waitUntilControlHasText("CHwndCppBase Window Class12", "Billing Related ")
							
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
			for p in patientSplit {
				OutputText.Value := OutputText.Value . p . A_Tab
			}
			if (Inputs.Length > 1) {
				InputText.Value := Inputs[2]
			} else {
				InputText.Value := ""
			}
			OutputText.Value := OutputText.Value . "`n"
		} else {
			for p in patientSplit {
				OutputText.Value := OutputText.Value . StrUpper(p) . A_Tab
			}
			
			if (patientSplit.Length < 4) {
				OutputText.Value := OutputText.Value . FormatTime(, "MM/dd/yyyy") .  A_Tab
			}
			
			if (Inputs.Length > 1) {
				InputText.Value := Inputs[2]
			} else {
				InputText.Value := ""
			}
			OutputText.Value := OutputText.Value . Outcome . "`n"
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

waitUntilControlHasText(ClassNN, ControlText, Window := "ahk_class MedentClient", eachWait := 200, waitNum := 50) {
	endLoop := false
	Loop waitNum {
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
	return !endLoop ; returns true if loop reached maximum iterations
}