;Created by P. Zheng
;Version: 2.0.0
;Date: Jul. 24 2013

#SingleInstance force
#NoTrayIcon

;Pre-define parameters as default
EditLoadParams := "D:\params.txt"
EditLoadUltraedit := "C:\Program Files\IDM Computer Solutions\UltraEdit\Uedit32.exe"

;Add menu for this GUI
Menu, HelpMenu, Add, &About, HelpAbout
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar

Gui, Add, Edit, vEditLoadParams x42 y30 w320 h20 , Please load params.txt...
Gui, Add, GroupBox, x22 y10 w390 h50 , Params.txt
Gui, Add, Button, x372 y30 w30 h20 gLoadParams, ...

Gui, Add, Edit, vEditLoadUltraedit x42 y90 w320 h20 , Please load UltraEdit editor...
Gui, Add, GroupBox, x22 y70 w390 h50 , Uedit32.exe
Gui, Add, Button, x372 y90 w30 h20 gLoadUltraedit, ...

Gui, Show, x433 y272 h135 w429, QuickOpen
Return

LoadParams:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedParamsTxt, 3,%EditLoadParams%, Select File, Params (*.txt)
if SelectedParamsTxt =  ; No file selected.
    return
else
		GuiControl,, EditLoadParams, %SelectedParamsTxt%
return

LoadUltraedit:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedUltraedit, 3,%EditLoadUltraedit%, Select File, Uedit32 (*.exe)
if SelectedUltraedit =  ; No file selected.
    return
else
		GuiControl,, EditLoadUltraedit, %SelectedUltraedit%
return

HelpAbout:
Gui, 2:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui +Disabled  ; Disable main window.
Gui, 2:Add, Button, x266 y7 w100 h30 , OK
Gui, 2:Add, Text, x26 y7 w170 h20 , QuickOpen v2.0.0 20130724
Gui, 2:Add, Text, x26 y27 w200 h20 , Press "Alt+O" to open relative path file.
Gui, 2:Add, Text, x26 y57 w170 h20 , Created By P. Zheng
Gui, 2:Add, Text, x26 y77 w170 h20 , www.pzheng.me
Gui, 2:Add, Text, x26 y97 w170 h20 , Powered by AutoHotKey
Gui, 2:Show, x406 y249 h118 w388,About
return

2ButtonOK:  ; This section is used by the "help box" above.
2GuiClose:
2GuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the help box.
return

; "Alt + o" to quickly open relative path file.
!o::
Gui, Submit, NoHide

original = %clipboard%
Send {HOME}+{END}^c{END}
clipwait
StringReplace, clipboard, clipboard,`r`n,,All	;remove "Enter"
StringSplit, PathName, clipboard, ],		;split path name
Part1 = %PathName1%			
FilePath = %PathName2%			;words after ]
StringSplit, FirstPart, Part1, [,		
RelPath = %FirstPart2%			;words between [ and ]

ParamsPath := EditLoadParams

IfNotExist, %ParamsPath%
{
	MsgBox, %ParamsPath% does not exist! Please load the correct params.txt.
	return
}

UEPath := EditLoadUltraedit

Loop
{
	FileReadLine, line, %ParamsPath%, %A_Index%
	
	if ErrorLevel
 		break
 		
	IfInString, line, %RelPath%			;search the line with specific string in params.txt
		break
}

IfInString, line, %RelPath%
	StringSplit, DirName, line, ",			;split the line and get the first part of absolute path	
else
{
	MsgBox, Cannot find %RelPath% in params.txt
	return	
}
	
AbsPath = %DirName2%%PathName2%	;combine the absolute path
clipboard = %original%


IfExist, %UEPath%
{
	run, %UEPath% %AbsPath%
	return
}
else
{
	MsgBox, %UEPath% does not exist! Please load the correct UltraEdit directory.
	run, notepad %AbsPath%
	return
}

return


GuiClose:
ExitApp