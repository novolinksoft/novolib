Class NovoLib.Utility.Log.LogToFile Extends %RegisteredObject
{

ClassMethod LogComment(pComment As %String, pLogFileFolder As %String)
{
	#Dim tLogFileName as %String
	if $LENGTH(pLogFileFolder) = 0
	{
		 set pLogFileFolder = "c:\InterSystems\Logs\" 
	}
	set tCurrentTime = ##class(%Library.UTC).NowLocal()
	set tLogFileName = pLogFileFolder_$Replace($Piece(tCurrentTime," ",1),"-","_")_"_log.txt"
	w tLogFileName, !
	set tSC = $$$OK
	
	try {
	if ##class(%File).Exists(tLogFileName) {             
	    set tLogFile = ##class(%File).%New(tLogFileName)
	    do tLogFile.Open("WAS",10)
	    w "file exists", !                   
	 }
	 else {
	    set tLogFile = ##class(%File).%New(tLogFileName)
	    do tLogFile.%Close()                           
	    do tLogFile.Open("WSN",10)
	    w "Create new file", !
	 }
	 set tCurrentTime = ##class(%Library.UTC).NowLocal()
	 do tLogFile.WriteLine(tCurrentTime_" - "_pComment)
	} catch ex {
 			w "Error - "_ex.DisplayString(), !
 			set tSC=ex.AsStatus()
	}
	Quit tSC
}

}
