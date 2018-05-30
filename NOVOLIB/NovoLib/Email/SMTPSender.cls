Class NovoLib.Email.SMTPSender Extends %RegisteredObject
{

ClassMethod SendMailUsingGoogle() as %Status
{
	// Make sure the GMAIL user account is set to allow access using less secure apps
	
	// Create an SMTP object and connect to a server
    Set Mailer = ##class(%Net.SMTP).%New()
    Set Mailer.smtpserver = "smtp.gmail.com"
    Set Mailer.port=465
    Set Mailer.SSLConfiguration = "gmail"

    // objects to carry authentication
    Set auth=##class(%Net.Authenticator).%New()
    Set auth.UserName="thirdnarrows@gmail.com"
    Set auth.Password="B1gwall3y3!"
 
  	Set Mailer.authenticator=auth
  	Set Mailer.AuthFrom=auth.UserName
	
	Set msg = ##class(%Net.MailMessage).%New()
    set msg.From = "no-reply@gmail.com"
    do msg.To.Insert("thirdnarrows@gmail.com")
    
    Set msg.Subject="Free Disk Space "_$zd($h, 12)_", "_$zd($h, 3)
    Set msg.IsBinary=0
    Set msg.IsHTML=1
    Do msg.TextData.Write("Hello Don this is direct from InterSystems")
    // Send the message and close objects
    Do Mailer.Send(msg)

    Quit $$$OK
}

ClassMethod SendMailUsingPaperCut() as %Status
{
	// Make sure PaperCut is INSTALLED and configured in WINDOWS
	
	// Create an SMTP object and connect to a server
    Set Mailer = ##class(%Net.SMTP).%New()
    Set Mailer.smtpserver = "localhost"
    Set Mailer.port=25

	Set msg = ##class(%Net.MailMessage).%New()
    set msg.From = "no-reply@gmail.com"
    do msg.To.Insert("thirdnarrows@gmail.com")
    
    Set msg.Subject="Free Disk Space "_$zd($h, 12)_", "_$zd($h, 3)
    Set msg.IsBinary=0
    Set msg.IsHTML=1
    Do msg.TextData.Write("Hello Don this is direct from InterSystems")
    // Send the message and close objects
    Do Mailer.Send(msg)

    Quit $$$OK
}

}