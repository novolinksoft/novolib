Class NovoLib.Utility.Log.AppError Extends %RegisteredObject
{

ClassMethod LogAsError(pLogString As %String) As %Status
{
	set $ZERROR = pLogString
	do BACK^%ETN
	Quit $$$OK
}

}
