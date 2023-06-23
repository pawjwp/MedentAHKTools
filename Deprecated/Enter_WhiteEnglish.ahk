#SingleInstance Force
^+w::
{
	SetKeyDelay 100
	Sleep 100
	
	ControlClick "Client Screen Element Window27", "BROAD TOP AREA MEDICAL CENTER JP"
	Sleep 400
	SendEvent "{Down}"
	Sleep 100
	SendEvent "{Enter}"
	Sleep 200
	SetKeyDelay 10
	SendEvent "white"
	SetKeyDelay 100
	Sleep 200
	SendEvent "{Enter}"
	Sleep 200
	SendEvent "{Down}{Enter}{Esc}"
	Sleep 200
	SendEvent "{Esc}"
	Sleep 200
	
	ControlClick "Client Screen Element Window29", "BROAD TOP AREA MEDICAL CENTER JP"
	Sleep 400
	SendEvent "{Down}"
	Sleep 100
	SendEvent "{Enter}"
	Sleep 200
	SetKeyDelay 10
	SendEvent "not"
	SetKeyDelay 100
	Sleep 200
	SendEvent "{Enter}{Esc}"
	Sleep 200
	
	ControlClick "Client Screen Element Window31", "BROAD TOP AREA MEDICAL CENTER JP"
	Sleep 400
	SetKeyDelay 10
	SendEvent "English"
	SetKeyDelay 100
	Sleep 100
	SendEvent "{Esc}"
}