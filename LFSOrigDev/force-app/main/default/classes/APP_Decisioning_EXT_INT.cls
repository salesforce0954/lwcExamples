/*
 * @Description: Decisioning controller
 * @Author: Jade Serrano
 * @Date Created: 17-Dec-2013
 * @History:
   =====================================================================
       Jade - 17-Dec-13: Created
   =====================================================================
 */
public with sharing class APP_Decisioning_EXT_INT extends APP_CommonExt{

	transient public List<Decision__c> decList{get;set;}
	transient public Boolean manualAction{get;set;}
	transient public String applicationName{get;set;}
	transient public String reportId{get;set;}

	public Application__c currentApplication {get;set;}

	public APP_Decisioning_EXT_INT(ApexPages.StandardController controller) {		
        super(controller);
		currentApplication = (Application__c)controller.getRecord();

		if(currentApplication!=null){
			currentApplication = [Select Name, Response_Code__c, Response_Description__c From Application__c Where Id =: currentApplication.Id];
			decList = [Select Id,
							  Name,
							  Action__c,
							  Application__c,
							  Clearance__c,
							  Response_Code__c,
							  Response_Description__c,
							  NBSM_Code__c
					   From   Decision__c
					   Where  Application__c =: currentApplication.Id
					   And    Clearance__c = 'Manual'
					   And 	  Action__c = false];

			List<Report> reportList = [SELECT 	Id 
									   FROM 	Report 
									   WHERE 	DeveloperName =: GEN_OriginationsConstants.COMPLETED_DECISIONS_REPORT];

			if(!reportList.isEmpty()){
				reportId = reportList.get(0).Id;
			}

			applicationName = currentApplication.Name;
		}

		manualAction = true;

		if(decList.size()==0){
			manualAction = false;
		}
	}

	//compiles all the data needed for output
	public List<SystemWrapper> getSysWrap(){
		List<SystemWrapper> sysWrap = new List<SystemWrapper>();
		String a = currentApplication.Response_Description__c;
		if(a!=null){
			String[] resDes = a.split(';');
			for(String b: resDes){
				String[] d = b.split('\\|');
				if(d.size()==2){
					String e = d[0].substring(d[0].length()-1,d[0].length());
					if(e=='S'){
						sysWrap.add(new SystemWrapper(d[0],d[1]));
					}
				}
			}
		}
		return sysWrap;
	}

	//wrapper for data needed for output
	public class SystemWrapper{

		public String nbsmCode{get;set;}
		public String responseDescription{get;set;}
		
		public SystemWrapper(String nbsmCode, String responseDescription){
			this.nbsmCode = nbsmCode;
			this.responseDescription = responseDescription;
		}
	}

	/*  Description: Fire manual step verificaiton service
     *  Author: Adrian Recio
     *  Date Created: MARCH-23-2016
     */  
    public PageReference approveApplication(){
       
       	Boolean appHasErrors = false;

       	Application__c refreshAppCheck = [Select Id, Out_Of_Sync__c, Response_Code__c from Application__c where Id = :application.Id limit 1];

        if(!(refreshAppCheck.Response_Code__c == 'SAR' || refreshAppCheck.Response_Code__c == 'SCR')){
        	Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: ' + 'Application status should be SCR or SAR.');
        	appHasErrors = true;
        }

       	if(refreshAppCheck.Out_Of_Sync__c==true){
       		Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: ' + 'Application is out of sync.');
       		appHasErrors = true;
       	}

       	if(appHasErrors==true){
       		return null;
       	}

        List<IS_ValidationError> validationErrors = IS_ApproveApplication.approveApplicationRequest(currentApplication.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);

        system.debug('AA Validation Error Count:' + validationErrors.size());

        if(validationErrors.size()>0) {
            for(IS_ValidationError i: validationErrors){
                Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
            }
            return null;
        } else {
                   
            PageReference ref;
            ref = Page.APP_WaitPageStaff;
            ref.getParameters().put('id', String.valueOf(this.application.Id));            
            ref.getParameters().put('submit', String.valueOf('true'));
            ref.setRedirect(true);
            return ref;
        }
    }

    public Boolean referredValidation(){
    	if(application.Response_Code__c == 'SAR' || 
    		application.Response_Code__c == 'SCR'){
    		return true;
    	}else{
    		return false;
    	}

    }

    /*  Description: Flag method that determines if Manual verification button should be enabled.
     *  Author: Adrian Recio
     *  Date Created: MARCH-23-2016
     */ 
    public Boolean getDisableManualVerification(){
    	if(referredValidation() && 
    		application.Out_Of_Sync__c == false){
    		return false;
    	}else{
    		return true;
    	}
    }
}