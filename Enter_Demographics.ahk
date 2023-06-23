#SingleInstance Force
^+w::
{
	; Create Control Arrays
	LanguageControl := Array()
	EthnicityControl := Array()
	RaceControl := Array()

	; Initialize Gui
	DemographicGui := Gui(, "Demographics Selection")


	; Language Section
	DemographicGui.AddText("Section", "Language")
	LanguageControl.Push DemographicGui.AddRadio("XS vLanguage Section", "English")
	LanguageControl.Push DemographicGui.AddRadio("YS", "Spanish")
	LanguageControl.Push DemographicGui.AddRadio("YS", "Sign Language")
	LanguageControl.Push DemographicGui.AddRadio("YS", "Not Reported")

	; Ethnicity Section
	DemographicGui.AddText("XS Section", "Ethnicity")
	EthnicityControl.Push DemographicGui.AddRadio("XS vEthnicity Section", "Latino/Hispanic")
	EthnicityControl.Push DemographicGui.AddRadio("YS", "Not Latino/Hispanic")
	EthnicityControl.Push DemographicGui.AddRadio("YS", "Refused")
	EthnicityControl.Push DemographicGui.AddRadio("YS", "Not Reported")

	; Race Section
	DemographicGui.AddText("XS Section", "Race")
	RaceControl.Push DemographicGui.AddRadio("XS vRace Section", "Caucasian")
	RaceControl.Push DemographicGui.AddRadio("YS", "African American")
	RaceControl.Push DemographicGui.AddRadio("YS", "Asian")
	RaceControl.Push DemographicGui.AddRadio("YS", "American Indian/Alaska Native")
	RaceControl.Push DemographicGui.AddRadio("YS", "Hawiian/Pacific Native")
	RaceControl.Push DemographicGui.AddRadio("YS", "Bi-Racial")
	RaceControl.Push DemographicGui.AddRadio("YS", "Not Reported")

	; Default Values
	LanguageControl[1].Value := 1
	EthnicityControl[2].Value := 1
	RaceControl[1].Value := 1


	; Create OK Button
	Btn := DemographicGui.Add("Button", "Default XM Section", "OK")
	Btn.OnEvent("Click", ProcessUserInput)
	
	; Create Cancel Button
	Btn := DemographicGui.Add("Button", "YS", "Cancel")
	Btn.OnEvent("Click", CloseWindow)
	
	DemographicGui.OnEvent('Escape', (*) => DemographicGui.Destroy())
	
	
	DemographicGui.Show()






	quickKeys := InputHook("V B L3", "{Enter}{Esc}{Tab}{Up}{Down}{Right}{Left}")
	quickKeys.OnEnd := SetValues
	quickKeys.Start()
	
	
	SetValues(*)
	{
		;MsgBox(quickKeys.EndReason)
		if (quickKeys.EndReason = "Max") {
			LanguageControl[SubStr(quickKeys.Input, 1, 1)].Value := 1
			EthnicityControl[SubStr(quickKeys.Input, 2, 1)].Value := 1
			RaceControl[SubStr(quickKeys.Input, 3, 1)].Value := 1
		}
	}

	CloseWindow(*)
	{
		DemographicGui.Destroy()
	}

	ProcessUserInput(*)
	{
		quickKeys.Stop()
		Saved := DemographicGui.Submit()  ; Save the contents of named controls into an object.
		; MsgBox("Language Status:" Saved.Language "`n" "Ethnicity Status:" Saved.Ethnicity "`n" "Race Status:" Saved.Race)
		
		if (ControlGetText("ChwndCppBase Window Class12", "ahk_class MedentClient") = "Add Account Memb") { ; If Class12 is Add Account, it a new account
			newAccount := true
		} else if  (ControlGetText("ChwndCppBase Window Class12", "ahk_class MedentClient") = "Hipaa") { ; If Class12 is Hipaa, it an existing account
			newAccount := false
		} else { ; If neither, it is likely on the wrong page and should cancel (by setting values to nothing)
			Saved.Race := 7
			Saved.Ethnicity := 4
			Saved.Language := 4
			
			MsgBox("Wrong Page, Cancelling")
		}
		
		SetKeyDelay 100
		Sleep 100
		
		if (Saved.Race != 7) {
			if (newAccount) {
				ControlClick "Client Screen Element Window26", "ahk_class MedentClient"
			} else {
				ControlClick "Client Screen Element Window27", "ahk_class MedentClient"
			}
			
			Sleep 400
			if (!newAccount) {
				SendEvent "{Down}"
				Sleep 100
				SendEvent "{Enter}"
				Sleep 200
			}
			
			SetKeyDelay 10
			
			switch Saved.Race
			{
				case 1:
					SendEvent "White"
				case 2:
					SendEvent "Black"
				case 3:
					SendEvent "Asian"
				case 4:
					SendEvent "Alaska"
				case 5:
					SendEvent "Pacific"
				case 6:
					SendEvent "Other Race"
			}
			
			SetKeyDelay 100
			Sleep 200
			SendEvent "{Enter}"
			Sleep 200
			
			if (Saved.Race != 6) {
				SendEvent "{Down}{Enter}{Esc}"
				Sleep 200
			}
			
			SendEvent "{Esc}"
			Sleep 300
		}
		
		if (Saved.Ethnicity != 4) {
			if (newAccount) {
				ControlClick "Client Screen Element Window28", "ahk_class MedentClient"
			} else {
				ControlClick "Client Screen Element Window29", "ahk_class MedentClient"
			}
			
			if (!newAccount) {
				SendEvent "{Down}"
				Sleep 100
				SendEvent "{Enter}"
				Sleep 200
			}
			
			SetKeyDelay 10
			
			switch Saved.Ethnicity
			{
				case 1:
					SendEvent "Hispanic"
				case 2:
					SendEvent "Not"
				case 3:
					SendEvent "Decline"
			}
			
			SetKeyDelay 100
			Sleep 200
			SendEvent "{Enter}"
			Sleep 200
			
			if (Saved.Ethnicity = 1) {
				SendEvent "{Down}{Enter}{Esc}"
				Sleep 200
			}
			
			SendEvent "{Esc}"
			Sleep 300
		}
		
		if (Saved.Language != 4) {
			if (newAccount) {
				ControlClick "Client Screen Element Window30", "ahk_class MedentClient"
			} else {
				ControlClick "Client Screen Element Window31", "ahk_class MedentClient"
			}
			Sleep 400
			SetKeyDelay 10
			
			switch Saved.Language
			{
				case 1:
					SendEvent "English"
				case 2:
					SendEvent "Spanish"
				case 3:
					SendEvent "Sign Languages"
			}
			
			SetKeyDelay 100
			Sleep 100
			SendEvent "{Esc}"
		}
	}
}
