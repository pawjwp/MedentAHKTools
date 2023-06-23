#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+a::
{
	; Create Control Arrays
	LanguageControl := Array()
	EthnicityControl := Array()
	RaceControl := Array()
	
	
	; Initialize Gui
	NewPatientGui := Gui(, "Basic Info Selection")

	NewPatientGui.AddText("Section", "Birthday (MDY)")
	NewPatientGui.AddEdit("YS-3 X+3 w24 r1 vBirthdayMonth")
	NewPatientGui.AddEdit("YS-3 X+3 w24 r1 vBirthdayDay")
	NewPatientGui.AddEdit("YS-3 X+3 w32 r1 vBirthdayYear")
	NewPatientGui.AddText("YS X+5", "Sex")
	NewPatientGui.AddRadio("YS X+3 vSex", "M")
	NewPatientGui.AddRadio("YS X+0", "F")
	
	NewPatientGui.AddText("XS Section", "Name")
	NewPatientGui.AddEdit("YS-3 X+3 w75 r1 vFirstName")
	NewPatientGui.AddEdit("YS-3 X+3 w20 r1 vMiddleName")
	NewPatientGui.AddEdit("YS-3 X+3 w75 r1 vLastName")
	
	NewPatientGui.AddText("XS Section", "Address")
	NewPatientGui.AddEdit("YS-3 X+3 w165 r1 vAddress1")
	NewPatientGui.AddEdit("YS-3 X+3 w165 r1 vAddress2")
	
	NewPatientGui.AddText("XS Section", "City")
	NewPatientGui.AddEdit("YS-3 X+3 w115 r1 vCity")
	NewPatientGui.AddText("YS X+5", "Zip")
	NewPatientGui.AddEdit("YS-3 X+3 w45 r1 vZip")
	
	NewPatientGui.AddText("XS Section", "Home")
	NewPatientGui.AddEdit("YS-3 X+3 w72 r1 vPhoneHome")
	NewPatientGui.AddText("YS X+5", "Cell")
	NewPatientGui.AddEdit("YS-3 X+3 w72 r1 vPhoneCell")
	NewPatientGui.AddText("YS X+5", "Work")
	NewPatientGui.AddEdit("YS-3 X+3 w72 r1 vPhoneWork")
	
	NewPatientGui.AddText("XS Section", "Email")
	NewPatientGui.AddEdit("YS-3 X+3 w170 r1 vEmail")

	NewPatientGui.AddText("XS Section", "Language")
	LanguageControl.Push NewPatientGui.AddRadio("XS vLanguage Section", "English")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Spanish")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Sign Language")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Not Reported")

	NewPatientGui.AddText("XS Section", "Ethnicity")
	EthnicityControl.Push NewPatientGui.AddRadio("XS vEthnicity Section", "Latino/Hispanic")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Not Latino/Hispanic")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Refused")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Not Reported")

	NewPatientGui.AddText("XS Section", "Race")
	RaceControl.Push NewPatientGui.AddRadio("XS vRace Section", "Caucasian")
	RaceControl.Push NewPatientGui.AddRadio("YS X+0", "African American")
	RaceControl.Push NewPatientGui.AddRadio("YS X+0", "Asian")
	RaceControl.Push NewPatientGui.AddRadio("YS X+0", "American Indian")
	RaceControl.Push NewPatientGui.AddRadio("YS X+0", "Hawiian/Pacific")
	RaceControl.Push NewPatientGui.AddRadio("XS Section", "Bi-Racial")
	RaceControl.Push NewPatientGui.AddRadio("YS X+0", "Not Reported")



	; Default Values
	LanguageControl[4].Value := 1
	EthnicityControl[4].Value := 1
	RaceControl[7].Value := 1
	
	
	
	; Create OK Button
	Btn := NewPatientGui.Add("Button", "Default XM Section", "OK")
	Btn.OnEvent("Click", ProcessUserInput)
	
	; Create Cancel Button
	Btn := NewPatientGui.Add("Button", "YS", "Cancel")
	Btn.OnEvent("Click", (*) => NewPatientGui.Destroy())
	
	NewPatientGui.OnEvent('Escape', (*) => NewPatientGui.Destroy())
	NewPatientGui.Show()

















	
	ProcessUserInput(*)	{
		Saved := NewPatientGui.Submit()  ; Save the contents of named controls into an object.
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
		
		if (newAccount) {
			ControlClick "RichEdit20A1", "ahk_class MedentClient"
			Sleep 400
			SetKeyDelay 10
			
			SendEvent Saved.FirstName
			Sleep 100
			SendEvent "{Tab}"
			Sleep 600
			SendEvent Saved.LastName
			SendEvent "{Tab}"
			Sleep 400
			
			try {
				if (InStr(ControlGetText("Pop Label Class1", "ahk_class MedentClient"), "Already on File") > 0) {
					continueResult := MsgBox("Patient name already on file. Continue?",, "YesNo")
					if (continueResult = "Yes") {
						ControlClick "CHwndCppBase Window Class15", "ahk_class MedentClient"
						Sleep 200
					ControlClick "RichEdit20A3", "ahk_class MedentClient"
					} else {
						return
					}
				}
			}
			
			SendEvent Saved.MiddleName ; truncate here
			Sleep 100
			SendEvent "{Tab}"
			Sleep 400
			SendEvent Saved.Address1
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.Address2
			Sleep 100
			ControlClick "RichEdit20A8", "ahk_class MedentClient"
			Sleep 200
			SendEvent Saved.Zip
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.City
			Sleep 400
			SendEvent "{Enter}"
			Sleep 200
			ControlClick "RichEdit20A8", "ahk_class MedentClient"
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.PhoneHome
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.PhoneCell
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.PhoneWork
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.Email
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			SendEvent Saved.BirthdayMonth
			Sleep 100
			SendEvent Saved.BirthdayDay
			Sleep 100
			SendEvent Saved.BirthdayYear ; do something here for date length
			Sleep 100
			SendEvent "{Tab}"
			Sleep 200
			if (Saved.Sex = 1) {
				SendEvent "M"
			}
			if (Saved.Sex = 2) {
				SendEvent "F"
			}
			Sleep 400
		}
		
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
			
			Sleep 400
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
			
			switch Saved.Language {
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
