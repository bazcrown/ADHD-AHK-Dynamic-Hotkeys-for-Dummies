﻿; evilC's Macro Template
; To add an extra hotkey, duplicate the lines between the vvv and ^^^ blocks
; vvvvvvvvv
; Like this
; ^^^^^^^^^
; And replace old name (eg HotKey2) with a new name - eg HotKey3
adh_core_version := 0.1

; ToDo:
; Rename all variables and functions to have a prefix, so user can code without worry

adh_macro_name := "My Macro"			; Change this to your macro name
adh_version := 0.1						; The version number of your script
adh_author := "Insert Name Here"		; Your Name
adh_link_text := "HomePage"				; The text of a link to your page about this macro
adh_link_url := "http://google.com"		; The URL for the homepage of your script

; Change the number of hotkeys here
adh_num_hotkeys := 2
adh_hotkey_names := "Fire, Toggle fire rate"

; You *may* need to edit some of these settings - eg Sendmode for some games

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ===== Do not edit the Header =================================================================================================
#InstallKeybdHook
#InstallMouseHook
#MaxHotKeysPerInterval, 200
 
OnExit, GuiClose

adh_mouse_buttons := "LButton|RButton|MButton|XButton1|XButton2|WheelUp|WheelDown|WheelLeft|WheelRight"

adh_ignore_events := 1	; Setting this to 1 while we load the GUI allows us to ignore change messages generated while we build the GUI

IniRead, adh_gui_x, %A_ScriptName%.ini, Settings, gui_x, 0
IniRead, adh_gui_y, %A_ScriptName%.ini, Settings, gui_y, 0
if (adh_gui_x == ""){
	adh_gui_x := 0	; in case of crash empty values can get written
}
if (adh_gui_y == ""){
	adh_gui_y := 0
}

; You may need to edit these depending on game
SendMode, Event
SetKeyDelay, 0, 50

; Uncomment and alter to limit hotkeys to one specific program
;Hotkey, IfWinActive, ahk_class CryENGINE

; Set up the GUI

adh_gui_w := 375
adh_gui_h := 150

Gui, Add, Tab2, x0 w%adh_gui_w% h%adh_gui_h%, Main|Bindings|Profiles|About

Gui, Tab, 1
Gui, Add, Text, x5 y40, Add your settings here...`n`nFire rate, weapon selection etc

Gui, Tab, 2

Gui, Add, Text, x5 y40 W100 Center, Name
Gui, Add, Text, xp+100 W70 Center, Keyboard
Gui, Add, Text, xp+90 W70 Center, Mouse
Gui, Add, Text, xp+82 W30 Center, Ctrl
Gui, Add, Text, xp+30 W30 Center, Shift
Gui, Add, Text, xp+30 W30 Center, Alt

adh_tabtop := 40
row := adh_tabtop + 20

IniRead, adh_profile_list, %A_ScriptName%.ini, Settings, profile_list, Default
IniRead, CurrentProfile, %A_ScriptName%.ini, Settings, current_profile, Default

if (adh_hotkey_names != null){
	StringSplit, adh_hotkey_names, adh_hotkey_names, `,
}

Loop, %adh_num_hotkeys%
{
	if (adh_hotkey_names%A_Index% != null){
		tmpname := trim(adh_hotkey_names%A_Index%)
	} else {
		tmpname := "HotKey" %A_Index%
	}
	Gui, Add, Text,x5 W100 y%row%, %tmpname%
	Gui, Add, Hotkey, yp-5 xp+100 W70 vHKK%A_Index% gKeyChanged
	Gui, Add, DropDownList, yp xp+80 W90 vHKM%A_Index% gMouseChanged, None||%adh_mouse_buttons%
	Gui, Add, CheckBox, xp+100 yp+5 W25 vHKC%A_Index% gOptionChanged
	Gui, Add, CheckBox, xp+30 yp W25 vHKS%A_Index% gOptionChanged
	Gui, Add, CheckBox, xp+30 yp W25 vHKA%A_Index% gOptionChanged
	row := row + 30
}

Gui, Add, Checkbox, x5 yp+30 vProgramMode gProgramModeToggle, Program Mode

Gui, Tab, 3
row := adh_tabtop + 20
Gui, Add, Text,x5 W40 y%row%,Profile
Gui, Add, DropDownList, xp+40 yp-5 W150 vCurrentProfile gProfileChanged, Default||%adh_profile_list%
Gui, Add, Button, xp+160 yp-2 gAddProfile, Add
Gui, Add, Button, xp+40 yp gDeleteProfile, Delete
Gui, Add, Button, xp+50 yp gDuplicateProfile, Duplicate
GuiControl,ChooseString, CurrentProfile, %CurrentProfile%

Gui, Tab, 4
row := adh_tabtop + 10
Gui, Add, Link,x5 y%adh_tabtop%, This macro was created using AHK Dynamic Hotkeys by Clive "evilC" Galway
Gui, Add, Link,x5 yp+25, <a href="http://evilc.com/proj/adh">HomePage</a>    <a href="https://github.com/evilC/AHK-Dynamic-Hotkeys">GitHub Page</a>
Gui, Add, Link,x5 yp+35, This macro ("%adh_macro_name%") was created by %adh_author%
Gui, Add, Link,x5 yp+25, <a href="%adh_link_url%">%adh_link_text%</a>



; Show the GUI =====================================
Gui, Show, x%adh_gui_x% y%adh_gui_y% w%adh_gui_w% h%adh_gui_h%, %adh_macro_name% v%adh_version% (ADH v%adh_core_version%)

Gui, Submit, NoHide	; Fire GuiSubmit while adh_ignore_events is on to set all the variables
adh_ignore_events := 0

GoSub, ProgramModeToggle
Gosub, ProfileChanged

return
; ===== End Header ==============================================================================================================




; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
; Set up HotKey 1

; Fired on key down
HotKey1:
	tooltip, 1 down
	;Send 1
	return

; Fired on key up
HotKey1_up:
	tooltip, 1 up
	;Send q
	return
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
; Set up HotKey 2

; Fired on key down
HotKey2:
	tooltip, 2 down
	;Send 2
	return

; Fired on key up
HotKey2_up:
	tooltip, 2 up
	;Send w
	return
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

; === SHOULD NOT NEED TO EDIT BELOW HERE!===========================================================================

ProfileChanged:
	Gosub, DisableHotKeys
	Gui, Submit, NoHide
	UpdateINI("current_profile", "Settings", CurrentProfile,"")

	Loop, %adh_num_hotkeys%
	{
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKK%A_Index%, 
		GuiControl,,HKK%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKM%A_Index%, None
		GuiControl, ChooseString, HKM%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKC%A_Index%, 0
		GuiControl,, HKC%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKS%A_Index%, 0
		GuiControl,, HKS%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKA%A_Index%, 0
		GuiControl,, HKA%A_Index%, %tmp%
	}

	Gosub, EnableHotKeys
	
	return

AddProfile:
	InputBox, tmp, Profile Name, Please enter a profile name
	AddProfile(tmp)
	Gosub, ProfileChanged
	return

AddProfile(name){
	global adh_profile_list
	if (adh_profile_list == ""){
		adh_profile_list := name
	} else {
		adh_profile_list := adh_profile_list "|" name
	}
	Sort, adh_profile_list, D|
	
	GuiControl,, CurrentProfile, |Default||%adh_profile_list%
	GuiControl,ChooseString, CurrentProfile, %name%
	
	UpdateINI("profile_list", "Settings", adh_profile_list, "")
}

DeleteProfile:
	if (CurrentProfile != "Default"){
		StringSplit, tmp, adh_profile_list, |
		out := ""
		Loop, %tmp0%{
			if (tmp%a_index% != CurrentProfile){
				if (out != ""){
					out := out "|"
				}
				out := out tmp%a_index%
			}
		}
		adh_profile_list := out
		
		IniDelete, %A_ScriptName%.ini, %CurrentProfile%
		UpdateINI("profile_list", "Settings", adh_profile_list, "")		
		
		GuiControl,, CurrentProfile, |Default||%adh_profile_list%
		Gui, Submit, NoHide
				
		Gosub, ProfileChanged
	}
	return

DuplicateProfile:
	InputBox, tmp, Profile Name, Please enter a profile name
	DuplicateProfile(tmp)
	return

DuplicateProfile(name){
	global adh_profile_list
	global CurrentProfile
	
	if (adh_profile_list == ""){
		adh_profile_list := name
	} else {
		adh_profile_list := adh_profile_list "|" name
	}
	Sort, adh_profile_list, D|
	
	GuiControl,, CurrentProfile, |Default||%adh_profile_list%
	GuiControl,ChooseString, CurrentProfile, %name%
	UpdateINI("profile_list", "Settings", adh_profile_list, "")
	
	Loop, %adh_num_hotkeys%
	{
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKK%A_Index%, 	
		GuiControl,,HKK%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKM%A_Index%, None
		GuiControl, ChooseString, HKM%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKC%A_Index%, 0
		GuiControl,, HKC%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKS%A_Index%, 0
		GuiControl,, HKS%A_Index%, %tmp%
		
		IniRead, tmp, %A_ScriptName%.ini, %CurrentProfile%, HKA%A_Index%, 0
		GuiControl,, HKA%A_Index%, %tmp%
	}
	UpdateINI("current_profile", "Settings", name,"")
	Gosub, OptionChanged
	;Gosub, ProfileChanged

	return
}

KeyChanged:
	tmp := %A_GuiControl%
	ctr := 0
	max := StrLen(tmp)
	Loop, %max%
	{
		chr := substr(tmp,ctr,1)
		if (chr != "^" && chr != "!" && chr != "+"){
			ctr := ctr + 1
		}
	}
	; Only modifier keys pressed?
	if (ctr == 0){
		return
	}
	
	; key pressed
	if (ctr < max){
		GuiControl,, %A_GuiControl%, None
		Gosub, OptionChanged
	}
	else
	{
		tmp := SubStr(A_GuiControl,4)
		; Set the mouse field to blank
		GuiControl,ChooseString, HKM%tmp%, None
		Gosub, OptionChanged
	}
	return

MouseChanged:
	tmp := SubStr(A_GuiControl,4)
	; Set the keyboard field to blank
	GuiControl,, HKK%tmp%, None
	Gosub, OptionChanged
	return

OptionChanged:
	if (adh_ignore_events != 1){
		Gui, Submit, NoHide
		
		Loop, %adh_num_hotkeys%
		{
			UpdateINI("HKK" A_Index, CurrentProfile, HKK%A_Index%, "")
			UpdateINI("HKM" A_Index, CurrentProfile, HKM%A_Index%, "None")
			UpdateINI("HKC" A_Index, CurrentProfile, HKC%A_Index%, 0)
			UpdateINI("HKS" A_Index, CurrentProfile, HKS%A_Index%, 0)
			UpdateINI("HKA" A_Index, CurrentProfile, HKA%A_Index%, 0)
		}
		UpdateINI("profile_list", "Settings", adh_profile_list,"")
	}	
	return

EnableHotKeys:
	Gui, Submit, NoHide
	Loop, %adh_num_hotkeys%
	{
		pre := BuildPrefix(A_Index)
		tmp := HKK%A_Index%
		if (tmp == ""){
			tmp := HKM%A_Index%
			if (tmp == "None"){
				tmp := ""
			}
		}
		;soundplay, *16
		if (tmp != ""){
			set := pre tmp
			Hotkey, ~%set% , HotKey%A_Index%
			Hotkey, ~%set% up , HotKey%A_Index%_up
			/*
			; Up event does not fire for wheel "buttons", but cannot bind two events to one hotkey ;(
			if (tmp == "WheelUp" || tmp == "WheelDown" || tmp == "WheelLeft" || tmp == "WheelRight"){
				Hotkey, ~%set% , HotKey%A_Index%_up
			} else {
				Hotkey, ~%set% up , HotKey%A_Index%_up
			}
			*/
		}
		GuiControl, Disable, HKK%A_Index%
		GuiControl, Disable, HKM%A_Index%
		GuiControl, Disable, HKC%A_Index%
		GuiControl, Disable, HKS%A_Index%
		GuiControl, Disable, HKA%A_Index%
	}
	return

DisableHotKeys:
	Loop, %adh_num_hotkeys%
	{
		pre := BuildPrefix(A_Index)
		tmp := HKK%A_Index%
		if (tmp == ""){
			tmp := HKM%A_Index%
			if (tmp == "None"){
				tmp := ""
			}
		}
		if (tmp != ""){
			set := pre tmp
			; ToDo: Is there a better way to remove a hotkey?
			HotKey, ~%set%, DoNothing
			HotKey, ~%set% up, DoNothing
		}
		GuiControl, Enable, HKK%A_Index%
		GuiControl, Enable, HKM%A_Index%
		GuiControl, Enable, HKC%A_Index%
		GuiControl, Enable, HKS%A_Index%
		GuiControl, Enable, HKA%A_Index%
	}
	return

; An empty stub to redirect unbound hotkeys to
DoNothing:
	return

BuildPrefix(hk){
	out := ""
	tmp = HKC%hk%
	GuiControlGet,%tmp%
	if (HKC%hk% == 1){
		out := out "^"
	}
	if (HKA%hk% == 1){
		out := out "!"
	}
	if (HKS%hk% == 1){
		out := out "+"
	}
	return out
}
	
; Updates the settings file. If value is default, it deletes the setting to keep the file as tidy as possible
UpdateINI(key, section, value, default){
	tmp := A_ScriptName ".ini"
	if (value != default){
		IniWrite,  %value%, %tmp%, %section%, %key%
	} else {
		IniDelete, %tmp%, %section%, %key%
	}
}

; Kill the macro if the GUI is closed
GuiClose:
	Gui, +Hwndgui_id
	WinGetPos, adh_gui_x, adh_gui_y,,, ahk_id %gui_id%
	IniWrite, %adh_gui_x%, %A_ScriptName%.ini, Settings, gui_x
	IniWrite, %adh_gui_y%, %A_ScriptName%.ini, Settings, gui_y
	ExitApp
	return

; Code from http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys/
; This code enables extra keys in a Hotkey GUI control
#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
	*AppsKey::                       ;Add support for these special keys,
	*BackSpace::                     ;  which the hotkey control does not normally allow.
	*Delete::
	*Enter::
	*Escape::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
	; Can use mouse hotkeys like this - it detects them but does not display them
	;~*WheelUp::
	modifier := ""
	If GetKeyState("Shift","P")
		modifier .= "+"
	If GetKeyState("Ctrl","P")
		modifier .= "^"
	If GetKeyState("Alt","P")
		modifier .= "!"
	Gui, Submit, NoHide											;If BackSpace is the first key press, Gui has never been submitted.
	If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)	;If the control has text but no modifiers held,
		GuiControl,,%ctrl%                                      ;  allow BackSpace to clear that text.
	Else                                                     	;Otherwise,
		GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)	;  show the hotkey.
	;validateHK(ctrl)
	Gosub, OptionChanged
	return
#If

HotkeyCtrlHasFocus() {
	GuiControlGet, ctrl, Focus       ;ClassNN
	If InStr(ctrl,"hotkey") {
		GuiControlGet, ctrl, FocusV     ;Associated variable
		Return, ctrl
	}
}

ProgramModeToggle:
	Gui, Submit, NoHide
	if (ProgramMode == 1){
		; Enable controls, stop hotkeys
		GoSub, DisableHotKeys
	} else {
		; Disable controls, start hotkeys
		GoSub, EnableHotKeys
	}
	return
	
