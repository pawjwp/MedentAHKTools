#SingleInstance
#Persistent

isActive := false
currentField := 0
totalFields := 14

+1::
if (!isActive)
{
	isActive := true
}

+2::
if (isActive)
{
	switch currentField {
		case 0:
			send, {Tab 3}
			currentfield++
			return
		case 1:
			send, {Tab 4}
			currentfield++
			return
		case 2:
			send, {Tab}
			currentfield++
			return
		case 3:
			send, {Tab}
			currentfield++
			return
		case 4:
			send, {Tab}
			currentfield++
			return
		case 5:
			send, {Tab 2}
			currentfield++
			return
		case 6:
			; CLICK STATUS
			send, {Tab 5}
			currentfield++
			return
		case 7:
			send, {Esc}{Tab 18}
			currentfield++
			return
		case 8:
			send, {lshift down}{Tab 2}{lshift up}{Tab}
			currentfield++
			return
		case 9:
			send, {lshift down}{Tab 2}{lshift up}{Tab}
			currentfield++
			return
		case 10:
			; CLICK STATUS
			send, {Tab 11}
			currentfield++
			return
		case 11:
			send, {Tab 3}
			currentfield++
			return
		case 12:
			send, {lshift down}{Tab 7}{lshift up}{Tab}
			currentfield++
			return
		case 13:
			send, {lshift down}{Tab 2}{lshift up}{Tab}
			currentfield++
			return
		default:
			isActive := false
			currentField := 0
			return
	}
}

+3::
if (isActive)
{
	switch currentField {
		case 7:
			send, {F1}
			return
		case 8:
			send, {F1}
			return
		case 9:
			send, {F1}{Down}{Enter}
			return
		case 10:
			send, {F1}{Down}{Enter}
			return
		case 13:
			send, {F1}
			return
		case 14:
			send, {F1}
			return
	}
}

+4::
if (isActive)
{
	switch currentField {
		case 7:
			send, {Enter}
			return
		case 8:
			send, {Esc}{lshift down}{Tab 2}{lshift up}{Tab}
			return
		case 9:
			send, {Enter}
			; IF HISPANIC		send, {Down}{Enter}{Esc}
			send, {Esc}{lshift down}{Tab 2}{lshift up}{Tab}
			return
		case 10:
			send, {Enter}{Down}{Enter}{Esc}{Esc}{lshift down}{Tab 2}{lshift up}{Tab}
			return
		case 13:
			send, {Enter}{lshift down}{Tab 2}{lshift up}{Tab}
			return
		case 14:
			send, {Enter}
			return
	}
}