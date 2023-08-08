#Requires AutoHotkey v2
#SingleInstance Force
^+n::
{
	if WinActive("ahk_class MozillaWindowClass") {
		Send "^+p"
	} else {
		Send "^+n"
	}
}