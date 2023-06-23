#SingleInstance Force
Persistent
SetKeyDelay 150


clickMode := false
currentField := 0
totalFields := 14

^1::		; Ctrl+1: Start Form Entry
{
	global currentField
	
	currentField := 0
}

^2::		; Ctrl+2: Next Form Field
{
	SetKeyDelay 150
	global currentField
	
	switch currentField {
		case 0:
			SendEvent "{Tab}{Tab}{Tab}"
			currentField++
			return
		case 1:
			SendEvent "{Tab}{Tab}{Tab}{Tab}"
			currentField++
			return
		case 2:
			SendEvent "{Tab}"
			currentField++
			return
		case 3:
			SendEvent "{Tab}"
			currentField++
			return
		case 4:
			SendEvent "{Tab}"
			currentField++
			return
		case 5:
			SendEvent "{Tab}{Tab}"
			currentField++
			return
		case 6:
			Click 700, 1060 ; Click Status
			Sleep 500
			SendEvent "{Tab}{Tab}{Tab}{Tab}{Tab}"
			currentField++
			return
		case 7:
			SendEvent "{Esc}"
			Sleep 500
			SendEvent "{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}"
			currentField++
			return
		case 8:
			SendEvent "{LShift down}{Tab}{LShift up}"
			currentField++
			return
		case 9:
			SendEvent "{LShift down}{Tab}{LShift up}"
			currentField++
			return
		case 10:
			Click 700, 1060 ; Click Status
			Sleep 500
			SendEvent "{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}"
			currentField++
			return
		case 11:
			SendEvent "{Tab}{Tab}{Tab}"
			currentField++
			return
		case 12:
			SendEvent "{LShift down}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{LShift up}"
			currentField++
			return
		case 13:
			SendEvent "{LShift down}{Tab}{LShift up}"
			currentField++
			return
		default:
			isActive := false
			currentField := 0
			return
	}
}

^3::		; Ctrl+3: Edit Field (Type Mode)
{
	SetKeyDelay 150
	global clickMode
	global currentField
	
	clickMode := false
	switch currentField {
		case 7:
			SendEvent "{F1}"
			return
		case 8:
			SendEvent "{F1}"
			return
		case 9:
			SendEvent "{F1}{Down}{Enter}"
			return
		case 10:
			SendEvent "{F1}{Down}{Enter}"
			return
		case 13:
			SendEvent "{F1}"
			return
		case 14:
			SendEvent "{F1}"
			return
	}
}

^4::		; Ctrl+4: Edit Field (Click Mode)
{
	SetKeyDelay 150
	global clickMode
	global currentField
	
	clickMode := true
	switch currentField {
		case 7:
			SendEvent "{F1}"
			return
		case 8:
			SendEvent "{F1}"
			return
		case 9:
			SendEvent "{F1}{Down}{Enter}"
			return
		case 10:
			SendEvent "{F1}{Down}{Enter}"
			return
		case 13:
			SendEvent "{F1}"
			return
		case 14:
			SendEvent "{F1}"
			return
	}
}

^5::		; Ctrl+2: Save Current Field
{
	SetKeyDelay 150
	global clickMode
	global currentField
	
	if (!clickMode) {
		switch currentField {
			case 7:
				SendEvent "{Enter}"
				return
			case 8:
				SendEvent "{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 9:
				SendEvent "{Enter}"
				; IF HISPANIC		SendEvent "{Down}{Enter}{Esc}"
				SendEvent "{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 10:
				SendEvent "{Enter}{Down}{Enter}{Esc}{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 13:
				SendEvent "{Enter}{LShift down}{Tab}{LShift up}"
				return
			case 14:
				SendEvent "{Enter}"
				return
		}
	}

	if (clickMode) {
		switch currentField {
			case 8:
				SendEvent "{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 9:
				SendEvent "{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 10:
				SendEvent "{Esc}{Esc}{LShift down}{Tab}{LShift up}"
				return
			case 13:
				SendEvent "{LShift down}{Tab}{LShift up}"
				return
		}
	}
}