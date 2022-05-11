/**
 * @Description: Class extension for APP_CustomerUIFileUpload
 * @Author: Adrian Recio
 * @Date Created: 18/3/2014
 * @History:
   =====================================================================
       01-10-13: Created - Adrian Recio
   =====================================================================
 */
 
 
global without sharing class APP_CustomerUIFileUpload_Ext extends APP_CommonExt{
   
	// Class Variable Declaration
	public List<Requested_Document__c> rdMainList{get; set;}
	public List<Requested_Document__c> rdDeleteList{get; set;}
	public String removeIndex {get; set;}
	public WS_FileUpload fileUploadClass{get; set;}
	public String responseCodeControlType{get;set;}
	public Brand__c brand {get;set;}  //Variable used for display of brand display name and contact number

	/*  Description: Class constructor
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter ApexPages.StandardController
     *  Return: na
     */
	public APP_CustomerUIFileUpload_Ext(ApexPages.StandardController applicationController) {
		super(applicationController);
    commonAuthorizationRequired();
		queryDocumentRequest();
		fileUploadClass = new WS_FileUpload();
		fileUploadClass.applicationId = application.Id;
		fileUploadClass.getApplicantOptions();
    responseCodeControlType = getResponseCodeControlType();
    brand = [SELECT Contact_Number__c FROM Brand__c WHERE Id = :this.application.Brand_Lookup__c LIMIT 1];
	}
	
	/*  Description: Getter method to pull response code details
     *  Author: Adrian Recio
     *  Date Created: 2-APR-2014
     *  Parameter na
     *  Return: string
     */
	public string getResponseCodeControlType(){
		// Pull latest reposne code
		//List<Application_Response__c> applicationResponseList = [SELECT   Response_Code__c
		//						                                 FROM      Application_Response__c
		//						                                 WHERE     Application__c =:application.Id
		//						                                 ORDER BY  createdDate DESC limit 1];
  //      // If empty return empty string
  //      if(!applicationResponseList.isEmpty()){
  //          Application_Response__c applicationResponse = applicationResponseList.get(0);
            try {
                //responseCodeControlType = Response_Code_Control__c.getValues(applicationResponse.Response_Code__c).Type__c;
                responseCodeControlType = Response_Code_Control__c.getValues(application.Response_Code__c).Type__c;
            } catch(Exception e){
                responseCodeControlType = '';
            }
        //}        
        return responseCodeControlType;
	}
	
	/*  Description: Method to check if applicaiton is joint
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
	public Boolean getIsJoint(){
		if(applicantList.size()>1){
			return true;
		}
		
		return false;
	}
	
	/*  Description: Main Method to query requested document 
					 based on current application
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
	public void queryDocumentRequest(){
		// Pull Requested Document Records
		rdMainList = pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' AND Status__c != \'Complete\' order by createdDate ASC' );
	}
	
    /*  Description: Main method to construct query statement and pull field sets 
    				 to query related requested document based on current application.
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
	public List<Requested_Document__c> pullRequestedDocumentRecords(string queryCondition){
		
		// Build query string
		String query = 'SELECT ';
		
        for(Schema.FieldSetMember f : this.getRequestedDocumentFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,Applicant__r.First_Name__c,Applicant__r.Last_Name__c,Applicant__r.Full_Name__c FROM Requested_Document__c where ' + queryCondition;
        
        return Database.query(query);
	}
	
	/*  Description: Pull Requested Document Field Set
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: 
     */
	public List<Schema.FieldSetMember> getRequestedDocumentFields() {
        return SObjectType.Requested_Document__c.FieldSets.Requested_Document.getFields();
    }
    
    /*  Description: Method to redirect to main page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectMain(){
    	pageReference pgRef = Page.APP_ApplicationMain_INT;
    	pgRef.getParameters().put('Id', application.Id);
    	pgRef.setRedirect(true);
    	return pgRef;
    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 06-MAY-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }
    
    /*  Description: Getter method to pull requested document count
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Integer getRDCount(){
    	return rdMainList.size();
    }
    
    /*  Description: Method to redirect to complete page
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectToCompletePage(){
    	PageReference pgRef = Page.APP_Complete;
    	pgRef.getParameters().put('FileUpload','1');
    	pgRef.getParameters().put('Id', application.Id);
    	pgRef.setRedirect(true);
    	return pgRef;
    }
   	
   	/*  Description: Method that redirects page to app main or post submit page dependending on application status
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
   	public pageReference validatePostSubmit(){
   		
   		// Redirect to app complete page if response code is FIA
   		if(application.Response_Code__c == 'FIA'){
   			pageReference pgRef = Page.APP_Complete;
   			pgRef.getParameters().put('Id',application.Id);
   			pgRef.setRedirect(true);
   			return pgRef;
   		}
   		
   		// Pull application response code
   		Response_Code_Control__c responseValue = Response_Code_Control__c.getValues(application.Response_Code__c);
		String typeValue = '';
   		if(responseValue!=null){
   			typeValue = responseValue.Type__c;
   		}
   		
   		List<Requested_Document__c>rDocList = [Select Id, Name, Application__c from Requested_Document__c where Application__c = :application.Id];
   		
   		// Redirect page to app main if appliction is still new
   		if(application.Status__c=='New' ){
   			pageReference pgRef = Page.APP_Main;
   			pgRef.getParameters().put('Id',application.Id);
   			pgRef.setRedirect(true);
   			return pgRef;
   		}

   		// Redirect page to app main post submit if application is not new but response code is not valid
   		if(	(application.Response_Code__c == 'PCO') || (typeValue == 'Referred' && rDocList.size() == 0) || typeValue == ''){
   			pageReference pgRef = Page.APP_Main_PostSubmit;
   			pgRef.getParameters().put('Id',application.Id);
   			pgRef.setRedirect(true);
   			return pgRef;
   		}
   		
   		return null;
   	}
}