public with sharing class CustomBranchLookupController {
	public List<Branch__c> results{get;set;} // search results
  	public string searchString{get;set;} // search keyword
  	public string product{get;set;}
  	public string Ptype{get;set;}
	public string searchStringNZ{get;set;}
  	public CustomBranchLookupController() {
    	
    // get the current search string
    	searchString = System.currentPageReference().getParameters().get('lksrch');
    	searchStringNZ=System.currentPageReference().getParameters().get('lksearch');
    	if(searchStringNZ.contains(',')){
    		product=searchStringNZ.split(',')[0];
    		Ptype=searchStringNZ.split(',')[1];
    	}
    	runSearch();  
  	}

  	// performs the keyword search
  	public PageReference search() {
    	runSearch();
    return null;
  	}

  	// prepare the query and issue the search command
  	private void runSearch() {
    	// TODO prepare query string for complex serarches & prevent injections
    	results = performSearch(searchString);               
  	} 

  	// run the search and return the records found. 
  	private List<Branch__c> performSearch(string searchString) {

    String soql = 'select id, Name from Branch__c';
    if(searchStringNZ.contains(',')){
      soql = soql +  ' where product__c = \'' + String.escapeSingleQuotes(product) +'\' and type__c =\''+String.escapeSingleQuotes(Ptype)+'\' and Branch_Status__c=\''+'Active'+'\'';
    	if(searchString != '' && searchString != null)soql = soql +' and name Like \'%'+String.escapeSingleQuotes(searchString)+'%\'';
    }else{
    	soql = soql +  ' where Branch_Status__c=\''+'Active'+'\' and country__c=\''+'Australia'+'\'';
    	if(searchString != '' && searchString != null)soql = soql +' and name Like \'%'+String.escapeSingleQuotes(searchString)+'%\'';
    }
    system.debug('!@#$SQL:'+soql);
    return database.query(soql); 

  	}

   // used by the visualforce page to send the link to the right dom element
  	public string getFormTag() {
    	return System.currentPageReference().getParameters().get('frm');
  	}

  	// used by the visualforce page to send the link to the right dom element for the text box
  	public string getTextBox() {
    	return System.currentPageReference().getParameters().get('txt');
  	}
}