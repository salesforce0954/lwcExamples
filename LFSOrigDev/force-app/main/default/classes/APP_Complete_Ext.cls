/*
 * @Description: Controller extension for APP_Complete Page
 * @Author: Adrian
 * @Date Created: APR-03-2014
 * @History:
   =====================================================================
       Adrian   -  APR-03-14: Created
   =====================================================================
 */
public with sharing class APP_Complete_Ext extends APP_CommonExt{
	public String brandName {get;set;}
	public String homePage {get;set;}
	public String contactNumber {get;set;}

	/*  Description: Class constructor
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter ApexPages.StandardController
     *  Return: na
     */
	public APP_Complete_Ext(ApexPages.StandardController applicationController) {
		super(applicationController);

		List<Brand__c> bVar = [SELECT Id, Brand_Display_Name__c, URL_Home_Page__c, Contact_Number__c 
							   FROM Brand__c 
							   WHERE Site__c = :site.getName() LIMIT 1];

        if(bVar.size() == 1){
			brandName = bVar[0].Brand_Display_Name__c;
			homePage = bVar[0].URL_Home_Page__c;
			contactNumber = bVar[0].Contact_Number__c;
        }
	}
	
	/*  Description: getter method to pull booleab if application is single or joint.
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: boolean
     */
	public boolean getJointApplication(){
		if(applicantList.size()>1){
			return true;
		}
		return false;
	}
	
	/*  Description: getter method to pull booleab if application is single or joint.
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: boolean
     */
	public boolean getOffLine(){
		if(application.Acceptance_Channel__c == 'Offline Acceptance'){
			return true;
		}
		return false;
	}
	
	/*  Description: Redirect to post submit page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: pagereference
     */
	public pageReference redirectToPostSubmit(){
		//PageReference ref = new PageReference('http://www.'+brandName.deleteWhitespace()+'.com.au');
		PageReference ref = new PageReference(homePage);
		return ref;
	}
	
	public boolean getFromFileUpload(){
		string fromFileUploadStr = ApexPages.currentPage().getParameters().get('FileUpload');
		
		if(fromFileUploadStr == '1'){
			return true;
		}
		
		return false;
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
}