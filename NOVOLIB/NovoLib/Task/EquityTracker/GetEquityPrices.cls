Include Ensemble

Class NovoLib.Task.EquityTracker.GetEquityPrices Extends %SYS.Task.Definition
{

Property SMTPServer As %String [ InitialExpression = "SMTP.gmail.com", Required ];

Property EmailDistributionList As %String(MAXLEN = 200) [ Required ];

/// How many days of messages should not be purged
Property NumberToQuery As %Integer(MINVAL = 0) [ InitialExpression = 7, Required ];

/// The type of thing to purge
Property PeriodToQuery As %String(DISPLAYLIST = ",Day(s),Week(s),Month(s)", VALUELIST = ",DAY,WEEK,MONTH") [ InitialExpression = "DAY", Required ];

Parameter TaskName = "NovoLib.Task.DailyFreeDiskSpaceMonitor";

/// This task will generate an email containing Disk Space Information.
/// 
/// The email will contain the following detail:
///    DiskSpace
///    
///    
Method OnTask() As %Status
{
	s tStatus = $$$OK
	s sSQL = ""
	
	s tPeriodToQuery = ..PeriodToQuery
	s tNumberToQuery = ..NumberToQuery
	
	//Do a REST API call to get stock quotes for today
	set tURL = "https://finance.google.com/finance/getprices?q=AAPL&i=3600&p=1d&f=d,c,h,l,o,v"

	// for yesterday single quote
	set tURL = "https://finance.google.com/finance/getprices?q=AAPL&p=2d&f=d,c,h,l,o,v"
	/*
	EXCHANGE%3DNASDAQ
	MARKET_OPEN_MINUTE=570
	MARKET_CLOSE_MINUTE=960
	INTERVAL=3600
	COLUMNS=DATE,CLOSE,HIGH,LOW,OPEN,VOLUME
	DATA=
	TIMEZONE_OFFSET=-240
	a1526047200,189.53,190.06,188.6,189.49,3641708
	1,189.24,189.59,188.98,189.5299,2954999
	2,189.01,189.25,188.43,189.24,2499271
	3,188.56,189.1,188.25,189.01,1816692

	convert Unix timestamp to DateTime string in Cache:
	
	USER>write $ZDATETIME($ZDATETIMEH({UNIXTIMESTAMP}, -2),1)
	USER>write $ZDATETIME($ZDATETIMEH({1526047200}, -2),1)
	USER>05/11/2018 07:00:00
	
	1525982400

	 Set httprequest=##class(%Net.HttpRequest).%New()
	 *** must create TLS in ManagementPortal
 	 Set httprequest.SSLConfiguration="TLS"
 	 Set httprequest.Https=1
 	Set httprequest.Server="api.particle.io"
 	Do httprequest.InsertFormData("access_token�,�your access token here�)
 	Do httprequest.InsertFormData("args�,�on�)
 	Do httprequest.Post("/v1/your device number here/led")
 	Do httprequest.HttpResponse.OutputToDevice()
 	q
	7) You can also test from a Linux Curl command:
	curl https://api.particle.io/v1/devices/your device number/led -d access_token=your access_token -d args=on
	
	*/
		
	s theEmailBody="<HTML>"
	s theEmailBody=theEmailBody_"<h3>[DO NOT REPLY TO THIS EMAIL]</h3>" 
	
	s theEmailBody=theEmailBody_"<table><tr><td style='font-weight:bold'>System:</td><td>"_$SYSTEM_"</td></tr>"
	s theEmailBody=theEmailBody_"<tr><td style='font-weight:bold'>Namespace:</td><td>"_$NAMESPACE_"</td></tr></table>"

	s theEmailBody=theEmailBody_"<br><table border='1'><tr><td/><td style='font-weight:bold'>Count</td></tr>"
	
	
	s theEmailBody=theEmailBody_"</table><br>"
	
	s theEmailBody=theEmailBody_"<br><h4>This email was generated by the �Daily Free Space� task on the "_$NAMESPACE_"</h4>"
	s theEmailBody=theEmailBody_"<h3>[DO NOT REPLY TO THIS EMAIL]</h3>"
	s theEmailBody=theEmailBody_"</HTML>"
	do ..SendMail(theEmailBody)

	$$$LOGINFO("Free Diskspace Task has completed successfully.")
	
 	Quit tStatus
}

Method GetEquityPrices() As %Status
{
	
	Quit tSC
}

Method SendMail(emailBody As %String) As %Status
{
	
    // Create an SMTP object and connect to a server
    Set Mailer = ##class(%Net.SMTP).%New()
    Set Mailer.smtpserver = ..SMTPServer

	Set msg = ##class(%Net.MailMessage).%New()
    set msg.From = "no-reply@gmail.com"

	s distList = $listfromstring(..EmailDistributionList)
	if ('$listvalid(distList)) {
		quit $$$ERROR($$$GeneralError, "EmailDistributionList is not a valid comma delimited list")
	}
	for i=1:1:$listlength(distList) {
		do msg.To.Insert($list(distList,i))
	}

    Set msg.Subject="Free Disk Space "_$zd($h, 12)_", "_$zd($h, 3)
    Set msg.IsBinary=0
    Set msg.IsHTML=1
    Do msg.TextData.Write(emailBody)
    // Send the message and close objects
    Do Mailer.Send(msg)

    Quit $$$OK
}

}
