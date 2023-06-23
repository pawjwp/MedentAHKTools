#SingleInstance Force
^+d::
{
	SetKeyDelay 100
	Sleep 100
	
	ControlClick "Client Screen Element Window41", "BROAD TOP AREA MEDICAL CENTER JP"
	Sleep 400
	SetKeyDelay 10
	SendEvent "Bauer"
	SetKeyDelay 100
	Sleep 200
	SendEvent "{Enter}"
	
	ControlClick "Client Screen Element Window44", "BROAD TOP AREA MEDICAL CENTER JP"
	Sleep 400
	SetKeyDelay 10
	SendEvent "Bauer"
	SetKeyDelay 100
	Sleep 200
	SendEvent "{Enter}"
}