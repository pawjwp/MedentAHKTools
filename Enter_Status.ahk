#SingleInstance Force
^+s::
{
	; Create Control Arrays
	MaritalControl := Array()
	EmploymentControl := Array()
	StudentControl := Array()

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

	; Default Values
	MaritalControl[1].Value := 1
	EmploymentControl[1].Value := 1
	StudentControl[3].Value := 1


	; Create OK Button
	Btn := StatusGui.Add("Button", "Default XM Section", "OK")
	Btn.OnEvent("Click", ProcessUserInput)
	
	; Create Cancel Button
	Btn := StatusGui.Add("Button", "YS", "Cancel")
	Btn.OnEvent("Click", CloseWindow)
	
	StatusGui.OnEvent('Escape', (*) => StatusGui.Destroy())
	
	
	StatusGui.Show()






	quickKeys := InputHook("V B L3", "{Enter}{Esc}{Tab}{Up}{Down}{Right}{Left}")
	quickKeys.OnEnd := SetValues
	quickKeys.Start()
	
	
	SetValues(*)
	{
		;MsgBox(quickKeys.EndReason)
		if (quickKeys.EndReason = "Max") {
			MaritalControl[SubStr(quickKeys.Input, 1, 1)].Value := 1
			EmploymentControl[SubStr(quickKeys.Input, 2, 1)].Value := 1
			StudentControl[SubStr(quickKeys.Input, 3, 1)].Value := 1
		}
	}

	CloseWindow(*)
	{
		StatusGui.Destroy()
	}

	ProcessUserInput(*)
	{
		quickKeys.Stop()
		Saved := StatusGui.Submit()  ; Save the contents of named controls into an object.
		; MsgBox("Marital Status:" Saved.Marital "`n" "Employment Status:" Saved.Employment "`n" "Student Status:" Saved.Student)
		
		SetKeyDelay 100
		Sleep 100
		
		if (Saved.Marital != 7) {
			ControlClick "Client Screen Element Window15", "ahk_class MedentClient"
			Sleep 400
			SetKeyDelay 10
			
			switch Saved.Marital
			{
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
			
			switch Saved.Student
			{
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
			
			switch Saved.Employment
			{
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
		
		ControlClick "RichEdit20A14", "ahk_class MedentClient"
	}
}
