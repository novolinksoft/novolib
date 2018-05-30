Class NovoLib.CDAtoSDA.Process.Transformer Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TargetConfigName As %String;

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	try {
	// Transform the CDA to SDA
	set tNewRequest = ##class(HS.Message.ECRUpdateRequest).%New()
	#dim tSDA As %Stream.Object
	
	//$$$ThrowOnError(##class(Ens.Util.URLStream).GetURLStream("file:///C:/InterSystems/XSLT/CCDA-to-SDA.xsl", .tXSLTTransform))
	set tTransformer = ##class(HS.Util.XSLTTransformer).%New()
	// default path = intersystems/ENS2016/csp/xslt
	set tSC = tTransformer.Transform(pRequest.Stream,"/CCDA-to-SDA.xsl",.tSDA)
	$$$ThrowOnError(tSC)
	set tNewRequest.ContentStream = tSDA
	set tNewRequest.HSCoreVersion = "15.03"
	set tNewRequest.UpdateECRDemographics = 1
	set tNewRequest.QueryCacheUpdate = 0
	set tNewRequest.StreamContentType = "SDA3"
	Set tSC =..SendRequestAsync(..TargetConfigName,tNewRequest)
	} catch ex {
		set tSC=ex.AsStatus()
		$$$TRACE("Error -"_" "_ex.DisplayString())
	}
	Quit tSC
}

Storage Default
{
<Data name="TransformerDefaultData">
<Subscript>"Transformer"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>TransformerDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
