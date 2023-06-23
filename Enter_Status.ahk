#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R


; Income Array
incomeRef := [
	[14580, 18225, 21870, 25515, 29160, 29161],
	[19720, 24650, 29580, 34510, 39440, 39441],
	[24860, 31075, 37290, 43505, 49720, 49721],
	[30000, 37500, 45000, 52500, 60000, 60001],
	[35140, 43925, 52710, 62495, 70280, 70281],
	[40280, 50350, 60420, 70490, 80560, 80561],
	[45420, 56775, 68130, 79485, 90840, 90841],
	[50560, 63200, 75840, 88480, 101120, 101121]
]



^+s::
{
	
	; Create Control Arrays
	MaritalControl := Array()
	EmploymentControl := Array()
	StudentControl := Array()
	IncomeControl := Array()

	; Initialize Gui
	StatusGui := Gui(, "Status Selection")


	; Martial Status Section
	StatusGui.AddText("Section", "Marital Status")
	MaritalControl.Push StatusGui.AddRadio("XS vMarital Section", "Single")
	MaritalControl.Push StatusGui.AddRadio("YS", "Married")
	MaritalControl.Push StatusGui.AddRadio("YS", "Domestic Partner")
	MaritalControl.Push StatusGui.AddRadio("YS", "Divorced")
	MaritalControl.Push StatusGui.AddRadio("YS", "Separated")
	MaritalControl.Push StatusGui.AddRadio("YS", "Widowed")
	MaritalControl.Push StatusGui.AddRadio("YS", "Not Reported")

	; Employment Status Section
	StatusGui.AddText("XS Section", "Employment Status")
	EmploymentControl.Push StatusGui.AddRadio("XS vEmployment Section", "Full Time")
	EmploymentControl.Push StatusGui.AddRadio("YS", "Part Time")
	EmploymentControl.Push StatusGui.AddRadio("YS", "No")
	EmploymentControl.Push StatusGui.AddRadio("YS", "Retired")
	EmploymentControl.Push StatusGui.AddRadio("YS", "Military")
	EmploymentControl.Push StatusGui.AddRadio("YS", "Self-Employed")
	EmploymentControl.Push StatusGui.AddRadio("YS", "Not Reported")

	; Student Status Section
	StatusGui.AddText("XS Section", "Student Status")
	StudentControl.Push StatusGui.AddRadio("XS vStudent Section", "Full Time")
	StudentControl.Push StatusGui.AddRadio("YS", "Part Time")
	StudentControl.Push StatusGui.AddRadio("YS", "None")
	StudentControl.Push StatusGui.AddRadio("YS", "Not Reported")

	; Household Income Section
	StatusGui.AddText("XS Section", "Annual Household Income")
	Loop incomeRef.Length {
		if (A_Index = 1) {
			IncomeControl.Push StatusGui.AddRadio("XS vIncome Section", String(A_Index))
		} else {
			IncomeControl.Push StatusGui.AddRadio("XS Section", String(A_Index))
		}
		
		for j in incomeRef[A_Index] {
			IncomeControl.Push StatusGui.AddRadio("YS", "$" . j)
		}
	}

	; Default Values
	MaritalControl[1].Value := 1
	EmploymentControl[1].Value := 1
	StudentControl[3].Value := 1

	; Create OK Button
	Btn := StatusGui.Add("Button", "Default XM Section", "OK")
	Btn.OnEvent("Click", ProcessUserInput)
	
	; Create Cancel Button
	Btn := StatusGui.Add("Button", "YS", "Cancel")
	Btn.OnEvent("Click", (*) => StatusGui.Destroy())
	
	StatusGui.OnEvent('Escape', (*) => StatusGui.Destroy())
	StatusGui.Show()



	inputStep := 1
	
	quickKeys := InputHook("V B L1", "{Enter}{Esc}{Tab}{Up}{Down}{Right}{Left}")
	quickKeys.OnEnd := SetValues
	quickKeys.Start()
	
	
	SetValues(*) {
		if (quickKeys.EndReason = "Max") {
			switch inputStep {		
				case 1:
					MaritalControl[quickKeys.Input].Value := 1
					quickKeys.Start()
				case 2:
					EmploymentControl[quickKeys.Input].Value := 1
					quickKeys.Start()
				case 3:
					StudentControl[quickKeys.Input].Value := 1
					quickKeys.Start()
				case 4:
					global IncomeControlIndex
					IncomeControlIndex := 1 + ((quickKeys.Input - 1) * 7)
					IncomeControl[IncomeControlIndex].Value := 1
					quickKeys.Start()
				case 5:
					global IncomeControlIndex
					IncomeControl[IncomeControlIndex + quickKeys.Input].Value := 1
					quickKeys.Start()
			}
			
			inputStep++
		}
	}

















	ProcessUserInput(*) {
		quickKeys.Stop()
		Saved := StatusGui.Submit()  ; Save the contents of named controls into an object.
		; MsgBox("Marital Status:" Saved.Marital "`n" "Employment Status:" Saved.Employment "`n" "Student Status:" Saved.Student)
		
		SetKeyDelay 100
		Sleep 100
		
		if (Saved.Marital != 7) {
			ControlClick "Client Screen Element Window15", "ahk_class MedentClient"
			Sleep 400
			SetKeyDelay 10
			
			switch Saved.Marital {
				case 1:
					SendEvent "Never"
				case 2:
					SendEvent "Married"
				case 3:
					SendEvent "Partner"
				case 4:
					SendEvent "Divorced"
				case 5:
					SendEvent "Separated"
				case 6:
					SendEvent "Widowed"
			}
			
			SetKeyDelay 100
			Sleep 200
			SendEvent "{Enter}"
			Sleep 200
		}
		
		if (Saved.Student != 4) {
			ControlClick "Client Screen Element Window19", "ahk_class MedentClient"
			Sleep 400
			SetKeyDelay 10
			
			switch Saved.Student {
				case 1:
					SendEvent "Full"
				case 2:
					SendEvent "Part"
				case 3:
					SendEvent "Not"
			}
			
			SetKeyDelay 100
			Sleep 200
			SendEvent "{Enter}"
			Sleep 200
		}
		
		if (Saved.Employment != 7) {
			ControlClick "Client Screen Element Window21", "ahk_class MedentClient"
			Sleep 400
			SetKeyDelay 10
			
			switch Saved.Employment {
				case 1:
					SendEvent "Full"
				case 2:
					SendEvent "Part"
				case 3:
					SendEvent "Not"
				case 4:
					SendEvent "Retired"
				case 5:
					SendEvent "Military"
				case 6:
					SendEvent "Self"
			}
			
			SetKeyDelay 100
			Sleep 200
			SendEvent "{Enter}"
			Sleep 200
		}
		
		if (Saved.Income != 0) {
			ControlClick "RichEdit20A14", "ahk_class MedentClient"
			Sleep 200
			
			SetKeyDelay 10
			SendEvent String(1 + Floor((Saved.Income - 1) / 7))
			SetKeyDelay 100
			Sleep 200		
			
			
			if (Mod(Saved.Income - 1, 7) != 0) {
				ControlClick "RichEdit20A17", "ahk_class MedentClient"
				Sleep 200
				
				SetKeyDelay 10
				SendEvent String(incomeRef[1 + Floor((Saved.Income - 1) / 7)][(Mod(Saved.Income - 1, 7))])
				SetKeyDelay 100
				Sleep 200
			}
		}
	}
}
