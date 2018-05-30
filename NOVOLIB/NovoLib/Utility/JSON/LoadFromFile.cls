Class NovoLib.Utility.JSON.LoadFromFile Extends %RegisteredObject
{

ClassMethod LoadJSONFile(fullfilepath As %String)
{
    set stream=##class(%Stream.FileCharacter).%New()
    set sc=stream.LinkToFile(fullfilepath)
    if ('sc) W "Error on linking file "_filename,! Q
    try {
    	set array=[].$fromJSON(stream)
    	set iter=array.$getIterator() 
    	while iter.$getNext(.key,.value) { 
    		write !,"key "_key_":"_value."symbol"_value."name",! 
    		// Save the array item to a persistant class object = Equity
    		
    	}
    } catch ex {
    		w "Unable to parse file "_filename,!
    		w "Error type: "_ex.Name,!
    		w "Error code: "_ex.Code,!
    		w "Error location: "_ex.Location,!
    		set obj=""
    }
    Q
}

}
