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
EmploymentControl.Push StatusGui.AddRadio("YS", "None")
EmploymentControl.Push StatusGui.AddRadio("YS", "Retired")
EmploymentControl.Push StatusGui.AddRadio("YS", "Military")
EmploymentControl.Push StatusGui.AddRadio("YS", "Self-Employed")
EmploymentControl.Push StatusGui.AddRadio("YS", "Not Reported")

; Student Status Section
StatusGui.AddText("XS Section", "Student Status")
StudentControl.Push StatusGui.AddRadio("XS vStudent Section", "Full Time")
StudentControl.Push StatusGui.AddRadio("YS", "Part Time")
StudentControl.Push StatusGui.AddRadio("YS", "None")

; Default Values
MaritalControl[1].Value := 1
EmploymentControl[1].Value := 1
StudentControl[3].Value := 1


; Create Close Button
Btn := StatusGui.Add("Button", "default XM", "OK")
Btn.OnEvent("Click", ProcessUserInput)
StatusGui.Show()


SetValues(*)
{
	MaritalControl[SubStr(quickKeys.Input, 1, 1)].Value := 1
	EmploymentControl[SubStr(quickKeys.Input, 2, 1)].Value := 1
	StudentControl[SubStr(quickKeys.Input, 3, 1)].Value := 1
}

quickKeys := InputHook("L3")
quickKeys.OnEnd := SetValues
quickKeys.Start()




ProcessUserInput(*)
{
	Saved := StatusGui.Submit()  ; Save the contents of named controls into an object.
	MsgBox("Marital Status:" Saved.Marital "`n" "Employment Status:" Saved.Employment "`n" "Student Status:" Saved.Student)
	;Saved.Marital
}
