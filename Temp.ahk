#SingleInstance Force
^+r::Reload  ; Ctrl+Alt+R

^+t::
{
	BirthdayMonth := "01"
	BirthdayDay := "02"
	BirthdayYear := "1993"
	if (!(BirthdayMonth = "" || BirthdayDay = "" || BirthdayYear = "")) {
		ControlClick "RichEdit20A14", "ahk_class MedentClient"
		Sleep 100
		SendEvent "{Home}"
		Sleep 100
		SendEvent BirthdayMonth
		Sleep 100
		SendEvent BirthdayDay
		Sleep 100
		if (StrLen(BirthdayYear) = 2) {
			SendEvent BirthdayYear
		} else if (StrLen(BirthdayYear) = 4) {
			SendEvent "{Left}"
			Sleep 100
			SendEvent "{Left}"
			Sleep 100
			SendEvent BirthdayYear
		}
		Sleep 100
	}
}