#SingleInstance Force

global Saved := false
global fields := ["BirthdayMonth", "BirthdayDay", "BirthdayYear", "Sex", "FirstName", "MiddleName", "LastName", "Address1", "Address2", "City", "State", "Zip", "PhoneHome", "PhoneCell", "PhoneWork", "WorkExtension", "Email", "Language", "Ethnicity", "Race", "Doctor"]

^+r::Reload ; Ctrl+Alt+R

^+a::
{
	; Create Control Arrays
	LanguageControl := Array()
	EthnicityControl := Array()
	RaceControl := Array()
	
	global Current := false
	
	
	; Initialize Gui
	NewPatientGui := Gui(, "Basic Info Selection")
	
	; Date of Birth and Sex
	NewPatientGui.AddText("Section", "Birthday:")
	BirthdayMonth := NewPatientGui.AddEdit("YS-3 X+13 w23 r1 vBirthdayMonth Number Limit2")

	NewPatientGui.AddText("YS X+3", "/")
	BirthdayDay := NewPatientGui.AddEdit("YS-3 X+3 w23 r1 vBirthdayDay Number Limit2")
	NewPatientGui.AddText("YS X+3", "/")
	BirthdayYear := NewPatientGui.AddEdit("YS-3 X+3 w32 r1 vBirthdayYear Number Limit4")
	NewPatientGui.AddText("YS X+3", "(MDY)")
	NewPatientGui.AddText("YS X+68", "Sex:")
	Sex := NewPatientGui.AddDropDownList("YS-3 X+3 vSex w65 AltSubmit", ["Male", "Female", "Unknown"])
	
	; Name
	NewPatientGui.AddText("XS Section", "Name:")
	FirstName := NewPatientGui.AddEdit("YS-3 X+23 w100 r1 vFirstName")
	MiddleName := NewPatientGui.AddEdit("YS-3 X+3 w57 r1 vMiddleName")
	LastName := NewPatientGui.AddEdit("YS-3 X+3 w127 r1 vLastName")
	
	; Street Address
	NewPatientGui.AddText("XS Section", "Address:")
	Address1 := NewPatientGui.AddEdit("YS-3 X+13 w160 r1 vAddress1")
	NewPatientGui.AddText("YS X+5", "Line 2:")
	Address2 := NewPatientGui.AddEdit("YS-3 X+3 w90 r1 vAddress2")
	
	; City
	NewPatientGui.AddText("XS Section", "City:")
	City := NewPatientGui.AddEdit("YS-3 X+34 w160 r1 vCity")
	NewPatientGui.AddText("YS X+5", "State:")
	State := NewPatientGui.AddEdit("YS-3 X+7 w24 r1 vState ReadOnly", "PA")
	NewPatientGui.AddText("YS X+5", "Zip:")
	Zip := NewPatientGui.AddEdit("YS-3 X+3 w40 r1 vZip Number Limit5")
	
	
	; Phone
	NewPatientGui.AddText("XS Section", "Home:")
	PhoneHome := NewPatientGui.AddEdit("YS-3 X+23 w66 r1 vPhoneHome Number Limit10")
	NewPatientGui.AddText("YS X+5", "Cell:")
	PhoneCell := NewPatientGui.AddEdit("YS-3 X+3 w66 r1 vPhoneCell Number Limit10")
	NewPatientGui.AddText("YS X+5", "Work:")
	PhoneWork := NewPatientGui.AddEdit("YS-3 X+6 w66 r1 vPhoneWork Number Limit10")
	WorkExtension := NewPatientGui.AddEdit("YS-3 X+3 w21 r1 vWorkExtension")
	
	; Email
	NewPatientGui.AddText("XS Section", "Email:")
	Email := NewPatientGui.AddEdit("YS-3 X+26 w290 r1 vEmail")


	; Language
	NewPatientGui.AddText("XS Section", "Language:")
	Language := NewPatientGui.AddDropDownList("YS-3 X+3 vLanguage w120 AltSubmit Choose1", ["English", "Spanish", "Sign Language", "Not Reported"]) ; min width 97
	
	; Ethnicity
	NewPatientGui.AddText("XS Section", "Ethnicity:")
	Ethnicity := NewPatientGui.AddDropDownList("YS-3 X+11 vEthnicity w120 AltSubmit Choose2", ["Latino/Hispanic", "Not Latino/Hispanic", "Refused", "Not Reported"]) ; min width 120
	
	; Race
	NewPatientGui.AddText("XS Section", "Race:")
	Race := NewPatientGui.AddDropDownList("YS-3 X+25 vRace w120 AltSubmit Choose1", ["Caucasian", "African American", "Asian", "American Indian", "Hawiian/Pacific", "Bi-Racial", "Not Reported"]) ; min width 105
	
	; Doctor
	NewPatientGui.AddText("XS Section", "Doctor:")
	Doctor := NewPatientGui.AddComboBox("YS-3 X+19 vDoctor w120", ["Bauer"])
	
	; Resubmit
	NewPatientGui.AddText("XS Section", "Options:")
	Resubmit := NewPatientGui.AddCheckBox("YS X+15 Section vResubmit Hidden", "Resubmit unchanged text?")
	
	
	; Create Submit Button
	SubmitBtn := NewPatientGui.AddButton("Default XM Section", "Submit")
	SubmitBtn.OnEvent("Click", (*) => ProcessUserInput())
	
	; Create Load Previous Button
	PreviousBtn := NewPatientGui.AddButton("YS", "Load Previous")
	PreviousBtn.OnEvent("Click", (*) => LoadPrevious())
	
	; Create Submit Load Current
	PreviousBtn := NewPatientGui.AddButton("YS", "Load Current")
	PreviousBtn.OnEvent("Click", (*) => LoadCurrent())
	
	; Create Submit Load Current
	TestBtn := NewPatientGui.AddButton("YS", "Load Test")
	TestBtn.OnEvent("Click", (*) => LoadTest())
	
	; Create Cancel Button
	CancelBtn := NewPatientGui.AddButton("YS", "Cancel")
	CancelBtn.OnEvent("Click", (*) => NewPatientGui.Destroy())
	
	NewPatientGui.OnEvent('Escape', (*) => NewPatientGui.Destroy())
	
	NewPatientGui.Show("AutoSize")







	LoadPrevious(*)	{
		if (Saved != false) {
			for (fieldName in fields) {
				%fieldName%.Value := Saved.%fieldName%
			}
			Doctor.Text := Saved.Doctor
		}
	}
	
	LoadCurrent(*)	{
		lockFields := ["BirthdayMonth", "BirthdayDay", "BirthdayYear", "FirstName", "MiddleName", "LastName", "Address1", "Address2", "City", "State", "Zip", "PhoneHome", "PhoneCell", "PhoneWork", "WorkExtension", "Doctor"]	
		; Unlock fields
		for field in lockFields {
			%field%.Opt("-ReadOnly")
		}
	
	
		; Enter text from the patient page
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
		
		; lock all lockFields with a value
		for field in lockFields {
			if (%field%.Value != "") {
				%field%.Opt("+ReadOnly")
			}
		}
		
		global Current := NewPatientGui.Submit(false)
		
		Resubmit.Visible := true
	}
	
	LoadTest(*)	{
		BirthdayMonth.Value := "01"
		BirthdayDay.Value := "01"
		BirthdayYear.Value := "2000"
		Sex.Value := 1
		FirstName.Value := "Test"
		MiddleName.Value := "T"
		LastName.Value := "Testington Jr"
		Address1.Value := "1500 Main Street"
		Address2.Value := "Box 100"
		City.Value := "Beverly Hills"
		State.Value := "CA"
		Zip.Value := "90210"
		PhoneHome.Value := "5555555555"
		PhoneCell.Value := "5555555555"
		PhoneWork.Value := "5555555555"
		WorkExtension.Value := "Ext 5"
		Email.Value := "testttestington@gmail.com"
		Language.Value := 1
		Ethnicity.Value := 2
		Race.Value := 1
	}
	
	ProcessUserInput(*)	{
		global Saved := NewPatientGui.Submit()  ; Save the contents of named controls into an object.
		sleepTime := 150
		
		if (Current != false && Saved.Resubmit = false) {
			for (fieldName in fields) {
				if (Saved.%fieldName% = Current.%fieldName%) {
					Saved.%fieldName% := ""
				}
			}
		}
		
		
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
		
		if (Saved.FirstName != "" && Saved.MiddleName != "" && Saved.LastName != "") {
			ControlClick "RichEdit20A1", "ahk_class MedentClient"
			Sleep sleepTime
			sendByClipboard(Saved.FirstName)
			Sleep sleepTime
			SendEvent "{Tab}"
			Sleep sleepTime * 3
			sendByClipboard(Saved.LastName)
			Sleep sleepTime
			SendEvent "{Tab}"
			Sleep sleepTime * 4
			
			try {
				if (InStr(ControlGetText("Pop Label Class1", "ahk_class MedentClient"), "Already on File") > 0) {
					continueResult := MsgBox("Patient name already on file. Continue?",, "YesNo")
				}
				if (continueResult != "No") {
					if (ControlGetText("CHwndCppBase Window Class14", "ahk_class MedentClient") = "Yes") {
						mouseMoveClick("CHwndCppBase Window Class14")
					}
					Sleep sleepTime
					ControlClick "RichEdit20A3", "ahk_class MedentClient"
					Sleep sleepTime
				}
			}
			sendByClipboard(Saved.MiddleName) ; truncate here
			Sleep 100
		}
		if (Saved.Address1 != "") {
			ControlClick "RichEdit20A4", "ahk_class MedentClient"
			Sleep sleepTime
			sendByClipboard(Saved.Address1)
			Sleep sleepTime
			SendEvent "{Tab}"
			Sleep sleepTime * 2
			sendByClipboard(Saved.Address2)
			Sleep sleepTime
		}
		if (Saved.Zip != "") {
			ControlClick "RichEdit20A8", "ahk_class MedentClient"
			Sleep sleepTime
			SendEvent Saved.Zip
			Sleep sleepTime
			SendEvent "{Tab}"
			Sleep sleepTime * 2
			SendEvent Saved.City
			Sleep sleepTime * 2
			SendEvent "{Enter}"
			Sleep sleepTime * 2
		}
		if (Saved.PhoneHome != "" && Saved.PhoneCell != "" && Saved.PhoneWork != "" && Saved.WorkExtension != "") {
			ControlClick "RichEdit20A8", "ahk_class MedentClient"
			Sleep sleepTime * 2
			SendEvent "{Tab}"
			Sleep sleepTime
			SendEvent Saved.PhoneHome
			Sleep sleepTime
			if (Saved.PhoneCell != "" && Saved.PhoneWork != "" && Saved.WorkExtension != "") {
				SendEvent "{Tab}"
				Sleep sleepTime
				SendEvent Saved.PhoneCell
				Sleep sleepTime
				if (Saved.PhoneWork != "" && Saved.WorkExtension != "") {
					SendEvent "{Tab}"
					Sleep sleepTime
					SendEvent Saved.PhoneWork
					Sleep sleepTime
					if (Saved.WorkExtension != "") {
						SendEvent "{Tab}"
						Sleep sleepTime
						SendEvent Saved.WorkExtension
						Sleep sleepTime
					}
				}
			}
		}
		if (Saved.Email != "") {
			ControlClick "RichEdit20A13", "ahk_class MedentClient"
			Sleep sleepTime
			sendByClipboard(Saved.Email)
			Sleep sleepTime
		}
		if (!(Saved.BirthdayMonth = "" || Saved.BirthdayDay = "" || Saved.BirthdayYear = "")) {
			ControlClick "RichEdit20A14", "ahk_class MedentClient"
			Sleep sleepTime / 2
			SendEvent "{Home}"
			Sleep sleepTime / 2
			SendEvent Saved.BirthdayMonth
			Sleep sleepTime / 4
			SendEvent Saved.BirthdayDay
			Sleep sleepTime / 4
			if (StrLen(Saved.BirthdayYear) = 2) {
				SendEvent Saved.BirthdayYear
			} else if (StrLen(Saved.BirthdayYear) = 4) {
				SendEvent "{Left}"
				Sleep sleepTime / 2
				SendEvent "{Left}"
				Sleep sleepTime / 2
				SendEvent Saved.BirthdayYear
			}
			Sleep sleepTime
		}
		if (Saved.Sex != "") {
			ControlClick "RichEdit20A15", "ahk_class MedentClient"
			Sleep sleepTime
			switch Saved.Sex
			{
				case 1:
					SendEvent "M"
				case 2:
					SendEvent "F"
				case 3:
					SendEvent "U"
			}
			Sleep sleepTime
		}
	
		
		if (Saved.Race != 7 && Saved.Race != "") {
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
		
		if (Saved.Ethnicity != 4 && Saved.Ethnicity != "") {
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
		
		if (Saved.Language != 4 && Saved.Language != "") {
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
		
		NewPatientGui.Destroy()
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

sendByClipboard(textToSend) {
	oldClipboard := ClipboardAll()
	A_Clipboard := textToSend
	Sleep 25
	SendEvent "{RCtrl Down}v{RCtrl Up}"
	Sleep 50
	A_Clipboard := oldClipBoard
	Sleep 25
}

/*
Add reset button (hide resubmit checkbox too)
Move "Not Reported" for demographics to checkbox
Check if button text is correct each time before clicking
Make it compatible with collection patients
*/
