/*
Author: Andrew Manetakis Cloud Sherpas
Created Date: April 9, 2014
Description: Javascript remoting function for the Search and Match page. Intended as a work around 
			 until PerspecSys can support the Streaming API
*/
global class APP_SearchAndMatchRemote {

	public APP_SearchAndMatchRemote(ApexPages.StandardController controller) {

	}
	
	@RemoteAction
    global static integer checkForResultsNonStreaming(String applicantSearchId) {
        List<Applicant_CLV__c> applicantCLVList =   [   SELECT  Id, Applicant_Search__c, CLV__c, Message_Code__c, Message_Description__c 
                                                        FROM    Applicant_CLV__c
                                                        WHERE   Applicant_Search__c =: applicantSearchId
                                                    ];
        return applicantCLVList.size();
    } 
}