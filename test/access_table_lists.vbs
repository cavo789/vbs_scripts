' ===========================================================================
'
' Author : Christophe Avonture
' Date   : November 2017
'
' Display the list of tables of a specific MS Access database 
' (the file should exists)
'
' Requires 
' ========
'
' 	* src\classes\MSAccess.vbs
'
' ===========================================================================

Option Explicit

Sub ShowHelp()

	Wscript.Echo " ====================================================="
	Wscript.Echo " = Scan for MS Access databases with attached tables ="
	Wscript.Echo " ====================================================="
	WScript.Echo ""	
	WScript.Echo " Please specify the name of the database to scan; f.i. : "
	WScript.Echo " " & Wscript.ScriptName & " 'C:\Temp\db1.accdb'"
	WScript.Echo ""

	WScript.Quit 

End sub

' Include the script library in this context
Sub IncludeFile(sFileName) 

	Dim objFSO, objFile

	Set objFSO = CreateObject("Scripting.FileSystemObject")	

	If (objFSO.FileExists(sFileName)) Then

		Set objFile = objFSO.OpenTextFile(sFileName, 1)  ' ForReading

		ExecuteGlobal objFile.ReadAll()

		objFile.close

	Else

		wScript.Echo "ERROR - IncludeFile - File " & sFileName & " not found!"

	End If

	Set objFSO = Nothing

End Sub

' Included needed classes
Sub IncludeClasses()

	Dim objFSO, objFile
	DIm sFolder

	' Get fullpath for the needed classes files, located in the parent folder
	' (this sample script is in the /src/test folder and the class is in 
	' the /src/classes folder)
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")		
	Set objFile = objFSO.GetFile(Wscript.ScriptName)
	sFolder = objFSO.GetParentFolderName(objFile) & "\"
	sFolder = objFSO.GetParentFolderName(sFolder) & "\"
	Set objFile = Nothing

	IncludeFile(sFolder & "src\classes\MSAccess.vbs")
	
End Sub

Dim cMSAccess
Dim sFile
Dim arrDBNames(0)

	' Get the first argument (f.i. "C:\Temp\db1.accdb")
	If (wScript.Arguments.Count = 0) Then 

		Call ShowHelp

	Else 

		' Get the path specified on the command line
		sFile = Wscript.Arguments.Item(0)
	
		' Includes external classes
		Call IncludeClasses
		
		Set cMSAccess = New clsMSAccess

		arrDBNames(0) = sFile
		
		wScript.Echo cMSAccess.GetListOfTables(arrDBNames, false)

		Set cMSAccess = Nothing

	End If