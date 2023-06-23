currentField := 1

StatusGui := Gui(, "Status Selection")


StatusGui.AddText("Section", "Marital Status")
StatusGui.AddRadio("XS vMarital Section", "Single")
StatusGui.AddRadio("YS", "Married")
StatusGui.AddRadio("YS", "Domestic Partner")
StatusGui.AddRadio("YS", "Divorced")
StatusGui.AddRadio("YS", "Separated")
StatusGui.AddRadio("YS", "Widowed")

StatusGui.AddText("XS Section", "Employment Status")
StatusGui.AddRadio("XS vEmployment Section", "Full Time")
StatusGui.AddRadio("YS", "Part Time")
StatusGui.AddRadio("YS", "None")
StatusGui.AddRadio("YS", "Retired")
StatusGui.AddRadio("YS", "Military")
StatusGui.AddRadio("YS", "Self-Employed")

StatusGui.AddText("XS Section", "Student Status")
StatusGui.AddRadio("XS vStudent Section", "Full Time")
StatusGui.AddRadio("YS", "Part Time")
StatusGui.AddRadio("YS", "None")


MaritalControl := StatusGui["Marital"]
EmploymentControl := StatusGui["Employment"]
StudentControl := StatusGui["Student"]


Btn := StatusGui.Add("Button", "default XM", "OK")
Btn.OnEvent("Click", ProcessUserInput)
StatusGui.Show()


SetValues(*)
{
	;MaritalControl.Value := SubStr(quickKeys.Input, 1, 1)
	;EmploymentControl.Value := SubStr(quickKeys.Input, 2, 2)
	;StudentControl.Value := SubStr(quickKeys.Input, 3, 3)
	
	MsgBox("Marital Status:" SubStr(quickKeys.Input, 1, 1) "`n" "Employment Status:" SubStr(quickKeys.Input, 2, 2) "`n" "Student Status:" SubStr(quickKeys.Input, 3, 3))
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
