/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/19/13
Description: Postcode Exclusion Page Controller
02/20/13 Added PageReference to list view upon save without validation
*/

public with sharing class PostcodeExclusionController{
    //Variable Declaration
    public String postCodes {get; set;}
    public String retURL = ApexPages.currentPage().getParameters().get('retURL');
    public PageReference previousPage = new PageReference(retURL);
        
    public PostcodeExclusionController(ApexPages.StandardController stdController){
    
    }
    
    //Method for splitting content of text area and saving of Postcode Exclusion per record
    public PageReference saveRecords(){
    	try{
			//Split content of text area
	        List<String> postCodesList = postCodes.split(',');
	        List<Postcode_Exclusion__c> postCodeRecords = new List<Postcode_Exclusion__c>();
	        String errorString = '';
	        Integer ctr = 0;
	        Integer i = 0;
	
	        //Loop through Postcodes with characters > 10
	        for(String str: postCodesList){
	            if(str.length() > 10){
	                i++;
	            }//End if
	        }//End for
	        
	        for(String str: postCodesList){
	        	//Add invalid Postcodes to error message
	            if(str.length() > 10){
	                errorString += str;
	                ctr++;
	                if(i != ctr)
	                    errorString += ',';
	            } else {
	            //Insert valid Postcodes to list
	                Postcode_Exclusion__c pc = new Postcode_Exclusion__c(Postcode__c = str);
	                postCodeRecords.add(pc);
	            
	            }//End else
	            
	        }//End for
	        
	        //Create Postcode Exclusions
	        if(!postCodeRecords.isEmpty()){
	            insert postCodeRecords;            
	        }//End if
	
	        //Display error message for invalid Postcodes
	        if(ctr != 0){
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Postcode '+errorString+' must be less than 10 characters'));
	            //Retain invalid Postcodes in text area
	            this.postCodes = errorString;
	            return null;
	        } else {
	        //Redirect to Postcode Exclusion list
	            return previousPage;
	            
	        }//End else
    	} catch(System.DMLException e){
    	//Display error is Postcodes is null
	        ApexPages.addMessages(e);
	        return null;
        }
    }//End saveRecords()
    
    //Redirect to Postcode Exclusion list if cancelled
    public PageReference Cancel(){
        return previousPage;
        
    }//End Cancel()
    
}//End PostcodeExclusionController