' Argument from command-line 
strFile = WScript.Arguments(0) 

Dim objShell, objFSO, objFile 

Set objShell = CreateObject("WScript.Shell") 
Set objFSO = CreateObject("Scripting.FileSystemObject") 

If objFSO.FileExists(strFile) Then ' Check to see if the file exists 
Set objFile = objFSO.GetFile(strFile) 
strCmd = "powershell -nologo -command " & Chr(34) & "&{" & objFile.ShortPath & "}" & Chr(34) ' Chr(34) is "" 
objShell.Run strCmd, 0 ' 0 hides the window 
Else 
WScript.Quit 
End If 