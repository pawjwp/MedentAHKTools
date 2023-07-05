#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+p::
{
	; Create Control Arrays
	; Initialize Gui
	PurgeEntryGui := Gui(, "Purge Entries")

	PurgeEntryGui.AddText("Section", "Name:")
	Name := PurgeEntryGui.AddEdit("YS-3 X+13 r1 vName")

	PurgeEntryGui.AddText("XS Section", "Birthday:")
	DOB := PurgeEntryGui.AddEdit("YS-3 X+3 r1 vDOB")

	PurgeEntryGui.AddText("XS Section", "Last OV:")
	LOV := PurgeEntryGui.AddEdit("YS-3 X+5 r1 vLOV")

	; Create OK Button
	Btn := PurgeEntryGui.Add("Button", "Default XM Section", "OK")
	Btn.OnEvent("Click", ProcessUserInput)
	
	; Create Cancel Button
	Btn := PurgeEntryGui.Add("Button", "YS", "Cancel")
	Btn.OnEvent("Click", (*) => PurgeEntryGui.Destroy())
	
	PurgeEntryGui.OnEvent('Escape', (*) => PurgeEntryGui.Destroy())
	PurgeEntryGui.Show()


	ProcessUserInput(*) {
		Saved := PurgeEntryGui.Submit()  ; Save the contents of named controls into an object.
		SetKeyDelay 1
		Sleep 20
		SendEvent Saved.Name
		
		SendEvent "{Right}"
		
		SendEvent SubStr(Saved.DOB, 1, 2)
		SendEvent "/"
		SendEvent SubStr(Saved.DOB, 3, 2)
		SendEvent "/"
		SendEvent SubStr(Saved.DOB, 5)
	
		SendEvent "{Right}"
		
		SendEvent SubStr(Saved.LOV, 1, 2)
		SendEvent "/"
		SendEvent SubStr(Saved.LOV, 3, 2)
		SendEvent "/"
		SendEvent SubStr(Saved.LOV, 5, 2)
		
		SendEvent "{Enter}{Left}{Left}"
		
		Name.Value := ""
		DOB.Value := ""
		LOV.Value := ""
		
		PurgeEntryGui.Show()
	}
}
