/* @Description: Green Id simpleUI methods
 * @Author : Adrian Recio
 * @Date : 30-MAY-2016
 * @History:
   =========================================================================================================
   		30-MAY-2016 : Created - Adrian Recio
   =========================================================================================================
 */
global without sharing class GreenId_SimpleUI {

	public string applicationId {get; set;}
    public string applicantId {get; set;}
	public Applicant__c applicantMain {get; set;}
	public Application__c applicationMain {get; set;}
	public Boolean isPrimary{get; set;}
	public String tokenVar{get; set;}
    public String testToken{get; set;}
    public String siteId{get; set;}
    public String environment {get;set;}
    public string GreenId_Config{get; set;}
    public string GreenId_CSS{get; set;}
    public string GreenId_IEScript1{get; set;}
    public string GreenId_IEScript2{get; set;}
    public string GreenId_Js{get; set;}
    public string callScriptError{get; set;}
    
    public static Webservice_Credential__mdt webCreds{get; set;}
    public string timeoutSettings{get; set;}
    
    @RemoteAction
    global static Application_Response__c amlVerificationResponse(String applicationIdToLook){ 
        DateTime timePageWasLoaded = System.now().addSeconds(-10);       
        List<Application_Response__c> appResponseList = [Select Id from Application_Response__c where 
                                                         Application__c = :applicationIdToLook AND 
                                                         Credit_Score__c !=null AND  
                                                         CreatedDate > :timePageWasLoaded Order By CreatedDate];
        System.debug('appResponseList:' + appResponseList);    
        if(appResponseList.size()>0){
            return appResponseList[0];
        }else{
            return null;
        }
    }
    
    public void initResponseTimeOut(){
        Web_Service_Settings__c sto =  Web_Service_Settings__c.getInstance('ResponseTimeOut');
        if(sto!=null) {
            timeoutSettings = sto.value__c;
        } else {
            timeoutSettings = '45'; //default 
        }
    }

	public GreenId_SimpleUI() {
        
        siteId = site.getSiteId();
        applicationId = ApexPages.currentPage().getParameters().get('id');
        applicantId = ApexPages.currentPage().getParameters().get('aId');
        try{
            initGreenIdCreds();
        	initApplication();
       		initApplicant();
        	initSimpleUIToken();
            initResponseTimeOut();
        }catch(exception e){
            system.debug('Green Id Initialization Failed:' + e);
        }
        checkTestToken();
        defineGreenIdEndpoint();
	}
    
        
    public void initGreenIdCreds(){
        webCreds = new Webservice_Credential__mdt();
        try{
        	//MLASALA 28-JUL-16 - Added API_code__c
        	webCreds = [select Username__c, Password__c, API_code__c, Environment__c from Webservice_Credential__mdt where DeveloperName = 'Green_Id' limit 1];
            system.debug('Username:' + webCreds.Username__c );
            system.debug('Password:' + webCreds.Password__c );
            system.debug('simpleui key:' + webCreds.API_code__c );
            system.debug('environment:' + webCreds.Environment__c );
        }catch(exception e){
            system.debug('Meta Data Creds Error:' + e.getMessage()); 
        }
    }
    
    public void defineGreenIdEndpoint(){
        try{
            GreenId_CSS = [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_CSS' limit 1].Endpoint__c; 
            GreenId_Config = [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_Config' limit 1].Endpoint__c; 
            GreenId_JS = [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_Js' limit 1].Endpoint__c; 
            GreenId_IEScript1 = [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_IEScript1' limit 1].Endpoint__c; 
            GreenId_IEScript2 = [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_IEScript2' limit 1].Endpoint__c; 
        }catch(exception e){
            string csErr = 'Green Id core script call failed:' + e.getMessage();
            system.debug(csErr);
            callScriptError = csErr;
        }
    }

    public void checkTestToken(){
    	testToken = ApexPages.currentPage().getParameters().get('testToken');   
        if(testToken!=null && testToken!=''){
            tokenVar = testToken;
        }
    }
    
	public void initSimpleUIToken(){
		greenIdDynamicFormAPI.DynamicFormsServicePort greenIdDynamicFormCntrl = new greenIdDynamicFormAPI.DynamicFormsServicePort();
		greenIdDynamicFormCntrl.endpoint_x = getGreendIdEndpoint();
		system.debug('!@#getGreendIdEndpoint: ' + greenIdDynamicFormCntrl.endpoint_x);
		tokenVar = greenIdDynamicFormCntrl.getUserToken(webCreds.Username__c,webCreds.Password__c,string.valueOf(applicantMain.Id), null );
	}

	public void initApplicant(){
        List<Applicant__c>applicantMainTemp = new List<Applicant__c>();
            
            if(applicantId==null || applicantId==''){    
                
               	List<User> uList = [SELECT ID, AccountId FROM User WHERE Id = :UserInfo.getUserId() limit 1];
                if(uList.size()==1){
        			applicantMainTemp = [SELECT Id, 
                                            Email_Address__c, 
                                            Is_Primary_Applicant__c,
                                            GreenId_Outcome__c,
                                            GreenId_DB_Outcome__c,
                                         	Response_Code__c, 
                                            Drivers_Lic_No__c
                                            FROM   Applicant__c 
                                            WHERE  Account__c = :uList[0].AccountId limit 1];
                    
                }
            }else{
                applicantMainTemp = [SELECT Id, 
                                            Email_Address__c, 
                                            Is_Primary_Applicant__c,
                                            GreenId_Outcome__c,
                                            GreenId_DB_Outcome__c,
                                     		Response_Code__c, 
                                            Drivers_Lic_No__c
                                            FROM   Applicant__c 
                                            WHERE  Id =: applicantId];
                
                
            }
        	
        	if(applicantMainTemp.size()== 1){
                applicantMain = applicantMainTemp[0];  
                isPrimary = applicantMain.Is_Primary_Applicant__c;
            }
    }

    public void initApplication(){
        queryMainAppInfo();
    }

	public void queryMainAppInfo(){
        applicationMain = [SELECT  Id, Brokerage_Fee__c, Application_Type__c, Submission_Status__c, Status__c, Response_Code__c, Insurance_Acknowledgement__c, 
                            Out_Of_Sync__c, Total_Loan_Amount__c, Total_Insurance_Premium__c, Offered_Establishment_Fee__c, Offered_PPSR_Registration_Fee__c, 
                            Offered_PPSR_Search_Fee__c, Total_Loan_Amount_with_Insurance__c, Loan_Term__c, Is_Accepted_Primary__c, Is_Accepted_Secondary__c, 
                            Loan_Term_Months__c, Offered_Interest_Rate__c, Acceptance_Channel__c, Brand_Lookup__r.Brand_Display_Name__c, Applicant_1_Name__c, 
                            Applicant_2_Name__c, Is_Insurance_Acknowledgement_Enabled__c, Is_Insurance_Acknowledgement_Enabled_2nd__c, Insurance_Acknowledgement_Secondary__c, 
                            Brand_Lookup__r.Country__c, Brand_String__c, Brand_Lookup__r.Fax_Number__c, Brand_Lookup__r.Contact_Number__c,
                            
                            Brand_Lookup__r.URL_Complaints_Brochure__c, Brand_Lookup__r.URL_Credit_Guide__c, 
                            Brand_Lookup__r.URL_Electronic_ID_Consent__c, Brand_Lookup__r.URL_LPI_Complaints_Brochure__c, 
                            Brand_Lookup__r.URL_Terms_Conditions__c, Brand_Lookup__r.Site__c, Brand_Lookup__r.URL_PDS_FSG__c,
                            Brand_Lookup__r.URL_Disclosure_Statement__c
                             
                    FROM    Application__c 
                    WHERE   Id =: applicationId limit 1];
    }
    
    @RemoteAction
    global static string verifyGreenIdResult(string greenIdUsername, string greenIdPassword, 
                                             string applicationId, string applicantId, string gIdToken){
                                             	
        // Instantiate dynamic form class
        greenIdDynamicFormAPI.DynamicFormsServicePort greenIdDynamicFormCntrl = new greenIdDynamicFormAPI.DynamicFormsServicePort();
        greenIdDynamicFormCntrl.endpoint_x = getGreendIdEndpoint();
        
        
		system.debug('!@#getGreendIdEndpoint: ' + greenIdDynamicFormCntrl.endpoint_x);
       	// String accountId,String password,String verificationId,String verificationToken,greenIdDynamicFormAPI.nameValuePair[] optionalData
   		system.debug('Creds:' + greenIdUsername + '-' + greenIdPassword);
		greenIdDynamicFormAPI.currentStatus outcomeVal = greenIdDynamicFormCntrl.getSources(greenIdUsername,greenIdPassword,null, gIdToken,  null );
        system.debug('Green Id Outcome:' + outcomeVal.verificationResult.outcome);
        
        // Retrieve applicant for outcome update
        Applicant__c appVar = [Select Id, Application__r.Response_Code__c, GreenId_Outcome__c from Applicant__c where Id=:applicantId ];
        if(appVar.GreenId_Outcome__c!=outcomeVal.verificationResult.outcome){
            appVar.GreenId_Outcome__c = outcomeVal.verificationResult.outcome;
            update appVar;
        }
        
        // Pull old AML information 
        List<AML__c> oldAML = [Select Id,AML_Pos_Verified_Type__c,AML_Ver_Date__c,Applicant__c,Verified_Flag__c, Issue_Country__c
                                         from AML__c where AML_Pos_Verified_Type__c='Electronic' and Applicant__c = :applicantId limit 1];
        AML__c amlVar = new AML__c();
        if(oldAML.size()==1){
            amlVar = oldAML[0];
        }
        
        // If outcome is verified create AML record
        if(outcomeVal.verificationResult.outcome=='VERIFIED' || 
           outcomeVal.verificationResult.outcome=='VERIFIED_WITH_CHANGES' || 
           outcomeVal.verificationResult.outcome=='VERIFIED_ADMIN'){
            // Update Electronic AML information
            amlVar.Issue_Country__c = null;
            amlVar.AML_Pos_Verified_Type__c = 'Electronic';
            //amlVar.AML_Ver_Date__c = system.today();
            amlVar.Date_Verified__c = system.today();
            if(amlVar.Applicant__c==null){
            	amlVar.Applicant__c = appVar.Id;
            }
            amlVar.Verified_Flag__c = true;
            try{
                if(amlVar.Id!=null){
                  update amlVar;  
                }else{
            		insert amlVar;
                }
                return outcomeVal.verificationResult.outcome;
            } catch(Exception e){
            	return 'AML_CREATE_FAILED' + string.valueOf(e);
        	}
        }
        
        // Return current unverified outcome
        return outcomeVal.verificationResult.outcome;
    }
    
    @RemoteAction
    global static string verifyAmlServiceCall(string applicationId){
        
        List<IS_ValidationError> valErrorList = new List<IS_ValidationError>();
        
        // Call Sync AML Verification 
        try{
            system.debug('AML Verification Fired.');
            valErrorList = IS_VerifyAML.VerifyAMLRequest(applicationId, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
            
            if(valErrorList.size()>0){
                return 'VALIDATION ERRORS';
            }else{
                return 'AML VERIFIED';
            }
        } catch(Exception e){
            system.debug('AML Verification Failed.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured')); 
            return 'ACTIVATE VERIFY FAILED';
        }
    }
    
    private static String getGreendIdEndpoint(){
    	return [select Endpoint__c from Webservice_Endpoint__mdt where DeveloperName = 'GreenId_Dynamic_Forms' limit 1].Endpoint__c;
    }
}