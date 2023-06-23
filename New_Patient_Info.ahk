#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+a::
{
	; Create Control Arrays
	LanguageControl := Array()
	EthnicityControl := Array()
	RaceControl := Array()
	
	global Saved := false
	
	
	; Initialize Gui
	NewPatientGui := Gui(, "Basic Info Selection")
	
	NewPatientGui.AddText("Section", "Birthday:")
	BirthdayMonth := NewPatientGui.AddEdit("YS-3 X+13 w23 r1 vBirthdayMonth Number Limit2")
	NewPatientGui.AddText("YS X+3", "/")
	BirthdayDay := NewPatientGui.AddEdit("YS-3 X+3 w23 r1 vBirthdayDay Number Limit2")
	NewPatientGui.AddText("YS X+3", "/")
	BirthdayYear := NewPatientGui.AddEdit("YS-3 X+3 w32 r1 vBirthdayYear Number Limit4")
	NewPatientGui.AddText("YS X+3", "(MDY)")
	NewPatientGui.AddText("YS X+68", "Sex:")
	Sex := NewPatientGui.AddDropDownList("YS-3 X+3 vSex w65 AltSubmit", ["Male", "Female", "Unknown"])
	NewPatientGui.AddText("XS Section", "Name:")
	FirstName := NewPatientGui.AddEdit("YS-3 X+23 w100 r1 vFirstName")
	MiddleName := NewPatientGui.AddEdit("YS-3 X+3 w57 r1 vMiddleName")
	LastName := NewPatientGui.AddEdit("YS-3 X+3 w127 r1 vLastName")
	
	NewPatientGui.AddText("XS Section", "Address:")
	Address1 := NewPatientGui.AddEdit("YS-3 X+13 w160 r1 vAddress1")
	NewPatientGui.AddText("YS X+5", "Line 2:")
	Address2 := NewPatientGui.AddEdit("YS-3 X+3 w90 r1 vAddress2")
	
	NewPatientGui.AddText("XS Section", "City:")
	City := NewPatientGui.AddEdit("YS-3 X+34 w160 r1 vCity")
	NewPatientGui.AddText("YS X+5", "State:")
	State := NewPatientGui.AddEdit("YS-3 X+7 w24 r1 vState ReadOnly", "PA")
	NewPatientGui.AddText("YS X+5", "Zip:")
	Zip := NewPatientGui.AddEdit("YS-3 X+3 w40 r1 vZip Number Limit5")
	
	NewPatientGui.AddText("XS Section", "Home:")
	PhoneHome := NewPatientGui.AddEdit("YS-3 X+23 w66 r1 vPhoneHome Number Limit10")
	NewPatientGui.AddText("YS X+5", "Cell:")
	PhoneCell := NewPatientGui.AddEdit("YS-3 X+3 w66 r1 vPhoneCell Number Limit10")
	NewPatientGui.AddText("YS X+5", "Work:")
	PhoneWork := NewPatientGui.AddEdit("YS-3 X+6 w66 r1 vPhoneWork Number Limit10")
	WorkExtension := NewPatientGui.AddEdit("YS-3 X+3 w21 r1 vWorkExtension")
	
	NewPatientGui.AddText("XS Section", "Email:")
	Email := NewPatientGui.AddEdit("YS-3 X+26 w290 r1 vEmail")


	NewPatientGui.AddText("XS Section", "Language:")
	Language := NewPatientGui.AddDropDownList("YS-3 X+3 vLanguage w120 AltSubmit Choose1", ["English", "Spanish", "Sign Language", "Not Reported"]) ; min width 97
	
	NewPatientGui.AddText("XS Section", "Ethnicity:")
	Ethnicity := NewPatientGui.AddDropDownList("YS-3 X+11 vEthnicity w120 AltSubmit Choose2", ["Latino/Hispanic", "Not Latino/Hispanic", "Refused", "Not Reported"]) ; min width 120
	
	NewPatientGui.AddText("XS Section", "Race:")
	Race := NewPatientGui.AddDropDownList("YS-3 X+25 vRace w120 AltSubmit Choose1", ["Caucasian", "African American", "Asian", "American Indian", "Hawiian/Pacific", "Bi-Racial", "Not Reported"]) ; min width 105
	
	NewPatientGui.AddText("XS Section", "Doctor:")
	Doctor := NewPatientGui.AddComboBox("YS-3 X+19 vDoctor w120", ["Bauer"])
	
	
	/*NewPatientGui.AddText("XS Section", "Language:")
	LanguageControl.Push NewPatientGui.AddRadio("XS vLanguage Section", "English")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Spanish")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Sign Language")
	LanguageControl.Push NewPatientGui.AddRadio("YS X+0", "Not Reported")

	NewPatientGui.AddText("XS Section", "Ethnicity:")
	EthnicityControl.Push NewPatientGui.AddRadio("XS vEthnicity Section", "Latino/Hispanic")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Not Latino/Hispanic")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Refused")
	EthnicityControl.Push NewPatientGui.AddRadio("YS X+0", "Not Reported")

	NewPatientGui.AddText("XS Section", "Race:")
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
	RaceControl[7].Value := 1*/
	
	
	
	; Create Submit Button
	SubmitBtn := NewPatientGui.AddButton("Default XM Section", "Submit")
	SubmitBtn.OnEvent("Click", (*) => ProcessUserInput())
	
	; Create Submit Previous Button
	PreviousBtn := NewPatientGui.AddButton("YS", "Load Previous")
	PreviousBtn.OnEvent("Click", (*) => LoadPrevious())
	
	; Create Submit Previous Button
	PreviousBtn := NewPatientGui.AddButton("YS", "Load Current")
	PreviousBtn.OnEvent("Click", (*) => LoadCurrent())
	
	; Create Cancel Button
	CancelBtn := NewPatientGui.AddButton("YS", "Cancel")
	CancelBtn.OnEvent("Click", (*) => NewPatientGui.Destroy())
	
	NewPatientGui.OnEvent('Escape', (*) => NewPatientGui.Destroy())
	NewPatientGui.Show()








	LoadPrevious(*)	{
		if (Saved != false) {
			BirthdayMonth.Value := Saved.BirthdayMonth
			BirthdayDay.Value := Saved.BirthdayDay
			BirthdayYear.Value := Saved.BirthdayYear
			Sex.Value := Saved.Sex
			FirstName.Value := Saved.FirstName
			MiddleName.Value := Saved.MiddleName
			LastName.Value := Saved.LastName
			Address1.Value := Saved.Address1
			Address2.Value := Saved.Address2
			City.Value := Saved.City
			State.Value := Saved.State
			Zip.Value := Saved.Zip
			PhoneHome.Value := Saved.PhoneHome
			PhoneCell.Value := Saved.PhoneCell
			PhoneWork.Value := Saved.PhoneWork
			WorkExtension.Value := Saved.WorkExtension
			Email.Value := Saved.Email
			Language.Value := Saved.Language
			Ethnicity.Value := Saved.Ethnicity
			Race.Value := Saved.Race
			Doctor.Text := Saved.Doctor
		}
	}
	
	LoadCurrent(*)	{
		lockFields := ["BirthdayMonth", "BirthdayDay", "BirthdayYear", "FirstName", "MiddleName", "LastName", "Address1", "Address2", "City", "State", "Zip", "PhoneHome", "PhoneCell", "PhoneWork", "WorkExtension", "Doctor"]
		
		for field in lockFields {
			%field%.Opt("-ReadOnly")
		}
	
	
	
		Birthday := ControlGetText("RichEdit20A14", "ahk_class MedentClient")
		BirthdayMonth.Value := SubStr(Birthday, 1, 2)
		BirthdayDay.Value := SubStr(Birthday, 4, 2)
		BirthdayYear.Value := SubStr(Birthday, 7, 4)
		switch ControlGetText("RichEdit20A15", "ahk_class MedentClient") {
			case "Male":
				Sex.Value := 1
			case "Female":
				Sex.Value := 2
			case "Unknown":
				Sex.Value := 3
			default:
				Sex.Value := 0
		}
		FirstName.Value := ControlGetText("RichEdit20A1", "ahk_class MedentClient")
		MiddleName.Value := ControlGetText("RichEdit20A3", "ahk_class MedentClient")
		LastName.Value := ControlGetText("RichEdit20A2", "ahk_class MedentClient")
		Address1.Value := ControlGetText("RichEdit20A4", "ahk_class MedentClient")
		Address2.Value := ControlGetText("RichEdit20A5", "ahk_class MedentClient")
		City.Value := ControlGetText("RichEdit20A6", "ahk_class MedentClient")
		State.Value := ControlGetText("RichEdit20A7", "ahk_class MedentClient")
		Zip.Value := ControlGetText("RichEdit20A8", "ahk_class MedentClient")
		PhoneHome.Value := RegExReplace(ControlGetText("RichEdit20A9", "ahk_class MedentClient"), "[\(\)\- ]")
		PhoneCell.Value := RegExReplace(ControlGetText("RichEdit20A10", "ahk_class MedentClient"), "[\(\)\- ]")
		PhoneWork.Value := RegExReplace(ControlGetText("RichEdit20A11", "ahk_class MedentClient"), "[\(\)\- ]")
		WorkExtension.Value := ControlGetText("RichEdit20A12", "ahk_class MedentClient")
		Email.Value := ControlGetText("RichEdit20A13", "ahk_class MedentClient")
		switch ControlGetText("RichEdit20A18", "ahk_class MedentClient") {
			case "English":
				Language.Value := 1
			case "Spanish":
				Language.Value := 2
			case "Sign Language":
				Language.Value := 3
			default:
				Language.Value := 4
		}
		switch ControlGetText("RichEdit20A17", "ahk_class MedentClient") {
			case "Hispanic / Latino":
				Ethnicity.Value := 1
			case "Not Hispanic / Latino":
				Ethnicity.Value := 2
			case "Declined to Specify / Unknown":
				Ethnicity.Value := 3
			default:
				Ethnicity.Value := 4
		}
		switch ControlGetText("RichEdit20A16", "ahk_class MedentClient") {
			case "White":
				Race.Value := 1
			case "Black / African American":
				Race.Value := 2
			case "Asian":
				Race.Value := 3
			case "American Indian / Alaska Native":
				Race.Value := 4
			case "Native Hawaiian / Other Pacific Islander":
				Race.Value := 5
			default:
				Race.Value := 7
		}
		Doctor.Text := ControlGetText("RichEdit20A22", "ahk_class MedentClient")
	
	
		/*
		BirthdayMonth.Opt("+ReadOnly") ; locked because no common reason to change
		BirthdayDay.Opt("+ReadOnly") ; locked because no common reason to change
		BirthdayYear.Opt("+ReadOnly") ; locked because no common reason to change
		FirstName.Opt("+ReadOnly") ; locked because insurance information
		MiddleName.Opt("+ReadOnly") ; locked because insurance information
		LastName.Opt("+ReadOnly") ; locked because insurance information
		Address1.Opt("+ReadOnly") ; locked because contacts may share address
		Address2.Opt("+ReadOnly") ; locked because contacts may share address
		City.Opt("+ReadOnly") ; locked because contacts may share old address
		State.Opt("+ReadOnly") ; locked because contacts may share old address
		Zip.Opt("+ReadOnly") ; locked because contacts may share old address
		PhoneHome.Opt("+ReadOnly") ; locked because other users may share a phone with the new one
		PhoneCell.Opt("+ReadOnly") ; locked because other users may share a phone with the new one
		PhoneWork.Opt("+ReadOnly") ; locked because other users may share a phone with the new one
		WorkExtension.Opt("+ReadOnly") ; locked because other users may share a phone with the new one
		; Email.Opt("+ReadOnly") ; unlocked
		; Language.Opt("+ReadOnly") ; unlocked
		; Ethnicity.Opt("+ReadOnly") ; unlocked
		; Race.Opt("+ReadOnly") ; unlocked
		Doctor.Opt("+ReadOnly") ; locked because no common reason to change and can't properly load
		*/
		
		lockFields := ["BirthdayMonth", "BirthdayDay", "BirthdayYear", "FirstName", "MiddleName", "LastName", "Address1", "Address2", "City", "State", "Zip", "PhoneHome", "PhoneCell", "PhoneWork", "WorkExtension", "Doctor"]
		for field in lockFields {
			if (%field%.Value != "") {
				%field%.Opt("+ReadOnly")
			}
		}
	}
	
	ProcessUserInput(*)	{
		global Saved := NewPatientGui.Submit()  ; Save the contents of named controls into an object.
		
		if (ControlGetText("ChwndCppBase Window Class12", "ahk_class MedentClient") = "Add Account Memb") { ; If Class12 is Add Account, it a new account
			newAccount := true
		} else if  (ControlGetText("ChwndCppBase Window Class12", "ahk_class MedentClient") = "Hipaa") { ; If Class12 is Hipaa, it an existing account
			newAccount := false
		} else { ; If neither, it is likely on the wrong page and should cancel (by setting values to nothing)
			Saved.Race := 7
			Saved.Ethnicity := 4
			Saved.Language := 4	
			MsgBox("Wrong Page, Cancelling")
			return
		}
		Sleep 100
		SetKeyDelay 10
		
		ControlClick "RichEdit20A1", "ahk_class MedentClient"
		Sleep 400
		
		SendEvent Saved.FirstName
		Sleep 100
		SendEvent "{Tab}"
		Sleep 600
		SendEvent Saved.LastName
		Sleep 100
		SendEvent "{Tab}"
		Sleep 400
		
		try {
			if (InStr(ControlGetText("Pop Label Class1", "ahk_class MedentClient"), "Already on File") > 0) {
				continueResult := MsgBox("Patient name already on file. Continue?",, "YesNo")
			}
			if (continueResult != "No") {
				if (ControlGetText("CHwndCppBase Window Class14", "ahk_class MedentClient") = "Yes") {
					Sleep 200
					ControlGetPos &x, &y, &w, &h, "CHwndCppBase Window Class14", "ahk_class MedentClient"
					Sleep 200
					MouseMove x + (w / 2), y + (h / 2)
					Sleep 200
					ControlClick "CHwndCppBase Window Class14", "ahk_class MedentClient"
				}
				Sleep 200
				ControlClick "RichEdit20A3", "ahk_class MedentClient"
				Sleep 200
			}
		}
		
		SendEvent Saved.MiddleName ; truncate here
		Sleep 100
		SendEvent "{Tab}"
		Sleep 200
		SendEvent Saved.Address1
		Sleep 100
		SendEvent "{Tab}"
		Sleep 400
		SendEvent Saved.Address2
		Sleep 200
		ControlClick "RichEdit20A8", "ahk_class MedentClient"
		Sleep 200
		SendEvent Saved.Zip
		Sleep 100
		SendEvent "{Tab}"
		Sleep 200
		SendEvent Saved.City
		Sleep 200
		SendEvent "{Enter}"
		Sleep 200
		ControlClick "RichEdit20A8", "ahk_class MedentClient"
		Sleep 200
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
		SendEvent Saved.WorkExtension
		Sleep 100
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
		if (StrLen(Saved.BirthdayYear) = 2) {
			SendEvent Saved.BirthdayYear
		} else if (StrLen(Saved.BirthdayYear) = 4) {
			SendEvent "{Left}"
			Sleep 100
			SendEvent "{Left}"
			Sleep 100
			SendEvent Saved.BirthdayYear
		}
		Sleep 100
		SendEvent "{Tab}"
		Sleep 200
		
		switch Saved.Sex
		{
			case 1:
				SendEvent "M"
			case 2:
				SendEvent "F"
			case 3:
				SendEvent "U"
		}
		Sleep 400
	
		
		if (Saved.Race != 7) {
			if (newAccount) {
				ControlClick "Client Screen Element Window26", "ahk_class MedentClient"
			} else if (!newAccount) {
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
			
			if (Saved.Race != "Bi-Racial") {
				SendEvent "{Down}{Enter}{Esc}"
				Sleep 200
			}
			
			SendEvent "{Esc}"
			Sleep 300
		}
		
		if (Saved.Ethnicity != 4) {
			if (newAccount) {
				ControlClick "Client Screen Element Window28", "ahk_class MedentClient"
			} else if (!newAccount) {
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
			} else if (!newAccount) {
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
			Sleep 200
		}
		
		if (Saved.Doctor != "") {
			if (newAccount) {
				ControlClick "Client Screen Element Window41", "BROAD TOP AREA MEDICAL CENTER JP"
			} else if (!newAccount) {
				ControlClick "Client Screen Element Window42", "BROAD TOP AREA MEDICAL CENTER JP"
			}
			Sleep 400
			SendEvent Saved.Doctor
			Sleep 200
			SendEvent "{Enter}"
		}
	}
}

/*
If unset, don't lock when loading current
Make it use clicks instead of tabs for navigation and make lots of them optional (only when filled out)
Make it work for existing accounts
Make something to pull information from current page to compare
Move "Not Reported" for demographics to checkbox
Make it compatible with deceased/collection patients
*/
