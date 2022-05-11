/*
Author: Adrian Recio Cloud Sherpas
Created Date: April 17, 2015
Description: Method to process personal details component
*/
public with sharing class APP_JointPersonalDetail extends APP_CommonExt{
	
	public Integer appCount;
	public string searchAddressValue{get; set;}
	public string appId{get; set;}
	
	
	/*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Getter method for income capacity list
     */
    public Integer getAppCount(){
        return AppCount;
    }
    
    
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Setter method for income capacity list
     */
    public void setAppCount(Integer AppCountPar){
        AppCount = AppCountPar;
        searchAddressValue = dtSearchPrepopulateApp(AppCount);
    }
    
	/*
	 * Author: Adrian Recio Cloud Sherpas
	 * Created Date: April 17, 2015
	 * Description: Method Constructor to initialize values
	*/
	public APP_JointPersonalDetail(){
		appId = ApexPages.currentPage().getParameters().get('id'); 
		system.debug('Constructor Application Id:' + appId);
	}
	
	/*
	 * Author: Adrian Recio Cloud Sherpas
	 * Created Date: April 17, 2015
	 * Description: Method to pull Applicant CLV Address for Applicant 1
	*/
	public string dtSearchPrepopulateApp(Integer appCountPar){	
		searchAddressValue = '';
		
		if(appCountPar!=null){
			List<Applicant__c> appliList = new List<Applicant__c>();
			
			if(appCountPar==1){
				appliList = [Select Id, Application__c, Is_Primary_Applicant__c from Applicant__c where Application__c = :appId and Is_Primary_Applicant__c=true]; 
			}else if(appCount==2){
				appliList = [Select Id, Application__c, Is_Primary_Applicant__c from Applicant__c where Application__c = :appId and Is_Primary_Applicant__c=false]; 
			}
			
			Applicant__c appliVar = new Applicant__c();
			Boolean hasApplicantMatch = false;
			
			for(Applicant__c appVar: appliList){
				appliVar = appVar;
				hasApplicantMatch = true;
			}
			
			system.debug('Has Applicant Match ' + appCountPar + '? ' + hasApplicantMatch);
			
			if(hasApplicantMatch == true){
				system.debug('Applicant ' + appCount +'For Query:' + appliVar.Id);
				List<Applicant_CLV__c> appliCLVList = [Select Id, Street_Address__c, Suburb__c, Prepopulate__c from Applicant_CLV__c where Applicant__c = :appliVar.Id and Prepopulate__c = true limit 1];
				
				system.debug('Applicant ' + appCount + 'CLV:' + appliCLVList);
				
				for(Applicant_CLV__c appCLVar: appliCLVList){
					searchAddressValue = appCLVar.Street_Address__c;
					if(searchAddressValue!=''){
						searchAddressValue = searchAddressValue + ' ' + stringNullChecker(appCLVar.Suburb__c);
					}else if(appCLVar.Suburb__c!='' && appCLVar.Suburb__c!=null){
						searchAddressValue = appCLVar.Suburb__c;
					}
				}
			}
		}
		return searchAddressValue;
	}	
	
	/*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: String null checker
     */
	public string stringNullChecker(string strPar){
		if(strPar==null){
			return '';
		}
		return strPar;
	}
	
}