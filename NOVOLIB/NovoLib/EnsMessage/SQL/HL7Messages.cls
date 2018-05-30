Class NovoLib.EnsMessage.SQL.HL7Messages Extends %RegisteredObject
{

ClassMethod GetMessages() As %Status
{
	set SQL = "select msg.ID,msg.TimeCreated,"
    set SQL = SQL_"msg.DocType,"
    set SQL = SQL_"msgHdr.SourceConfigName,"
    set SQL = SQL_"msgHdr.TargetConfigName,"
    set SQL = SQL_"msg.RawContent "
	set SQL = SQL_"from EnsLib_HL7.SearchTable srchTbl"
	set SQL = SQL_"join enslib_hl7.message msg on msg.id=srchTbl.docid "
	set SQL = SQL_"join Ens.MessageHeader msgHdr on msgHdr.MessageBodyId=srchTbl.docid"
	set SQL = SQL_"where  (srchTbl.propid=(select propid from Ens_Config.SearchTableProp where classextent='EnsLib.HL7.SearchTable' and name='PatientSSN')"
    set SQL = SQL_"   and srchTbl.propvalue = '123-25-4612')"
    set SQL = SQL_"and msgHdr.SourceConfigName='HL7.File.In'"
}

ClassMethod CountMessages() As %Status
{
 &SQL(DECLARE C1 CURSOR FOR SELECT MessageBodyId INTO :id FROM Ens.MessageHeader WHERE MessageBodyClassName='EnsLib.HL7.Message' AND TimeCreated BETWEEN '2016-07-15' AND '2016-07-16')
 &SQL(OPEN C1)
 &SQL(FETCH C1)
 while (SQLCODE = 0) {
   set msg = ##class(EnsLib.HL7.Message).%OpenId(id)
   if (msg.GetValueAt("MSH:SendingApplication") = "Ensemble") {
      //do something with this message
   }
   	&SQL(FETCH C1)
	}
 &SQL(CLOSE C1)
}

}
