/*
 * @Description: Test class for ApplicantTriggerHandler class
 * @Author: Adrian Recio
 * @Date Created: August 25, 2016
 * @History:
 * =====================================================================
 *     Adrian - August 25, 2016: Created
       
 * =====================================================================
 */
 @Istest
public without sharing class ApplicantTriggerHandlerTest {
	
	private static final String EXTRENAL_APP_ID_VALID = 'XAppId';
    private static final String EXTRENAL_APP_ID_INVALID = 'XAppIdInvalid';
    private static final String EXTRENAL_SECURITY_TOKEN = 'stoken';

	public static testmethod void ApplicantTriggerHandlerTest() {
		List<Web_Service_Settings__c> wssList = new List<Web_Service_Settings__c>();
        
        Web_Service_Settings__c wss1					= TestDataBuilder.createWebServiceSettings('SOLCode-AU-3rd Party Application', 'BC1');
        wssList.add(wss1);
        
        Web_Service_Settings__c wss2					= TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        wssList.add(wss2);
        
        insert wssList;
        
        Brand__c brand		 						= TestDataBuilder.createBrand();
        brand.Site__c								= GEN_OriginationsConstants.GEMONEY_AU_SITENAME;
        insert brand;
        
        GEProduct__c geProduct 						= TestDataBuilder.createGEProduct(brand.Id);
        insert geProduct;
        
        Product_Version__c prodVer					= TestDataBuilder.createProductVersion(geProduct.Id);
        insert prodver;
        
        Application__c currentApp 					= TestDataBuilder.createApplication();
        currentApp.Loan_Term_Months__c 				= 36;
        currentApp.Loan_Term__c  					= '3.5 years';
        currentApp.Payment_Frequency__c				= 'Monthly'; 
        currentApp.Total_Loan_Amount__c 			= 12344;
        currentApp.Higher_Approval_Consent__c 		= false;
        currentApp.X3rd_Party_Application_Number__c = EXTRENAL_APP_ID_VALID;
        currentApp.X3rd_Party_Security_Token__c 	= EXTRENAL_SECURITY_TOKEN;
        currentApp.X3rd_Party_Application_Source__c = 'Society One';
        currentApp.Channel__c 						= '3rd Party Application';
        currentApp.Response_Code__c 				= 'New';
        insert currentApp;
        
        Applicant__c app1 						= TestDataBuilder.createApplicant(null, currentApp.Id);
        app1.Is_Primary_Applicant__c 			= true;
        app1.First_Name__c 						= 'abcdkjkj';
        app1.Interested_in_other_services__c 	= true ; 		// Need to check with Weishen (on App Eligibitliy)
        app1.Meets_Eligibility_Criteria__c 		= true;
        app1.Agrees_to_Fees__c 					= true;
        app1.Agrees_to_Privacy_Policy__c 		= true;
        app1.KB_HL_or_Graduate__c 				= false;
        app1.Accept_Terms_and_Conditions__c 	= true;
        app1.EIDV__c							= 'Yes';
        app1.Email_Address__c 					= 'testuniqueemail@gmail.com';
        app1.Street_Type_Pos__c 				= 'Access';
        app1.Street_Type_Res__c 				= 'Access';	
        app1.Street_Type_Pre__c 				= 'Access';
        
        Applicant__c app2 						= TestDataBuilder.createApplicant(null, currentApp.Id);
        app2.Is_Primary_Applicant__c 			= true;
        app2.First_Name__c 						= 'abcdkjkj';
        app2.Interested_in_other_services__c 	= true ; 		// Need to check with Weishen (on App Eligibitliy)
        app2.Meets_Eligibility_Criteria__c 		= true;
        app2.Agrees_to_Fees__c 					= true;
        app2.Agrees_to_Privacy_Policy__c 		= true;
        app2.KB_HL_or_Graduate__c 				= false;
        app2.Accept_Terms_and_Conditions__c 	= true;
        app2.EIDV__c							= 'Yes';
        app2.Email_Address__c 					= 'testuniqueemail2@gmail.com';
        app1.Street_Type_Pos__c 				= null;
        app1.Street_Type_Res__c 				= null;	
        app1.Street_Type_Pre__c 				= null;

        Applicant__c app3 						= TestDataBuilder.createApplicant(null, currentApp.Id);
        app3.Is_Primary_Applicant__c 			= true;
        app3.First_Name__c 						= 'abcdkjkj';
        app3.Interested_in_other_services__c 	= true ; 		// Need to check with Weishen (on App Eligibitliy)
        app3.Meets_Eligibility_Criteria__c 		= true;
        app3.Agrees_to_Fees__c 					= true;
        app3.Agrees_to_Privacy_Policy__c 		= true;
        app3.KB_HL_or_Graduate__c 				= false;
        app3.Accept_Terms_and_Conditions__c 	= true;
        app3.EIDV__c							= 'Yes';
        app3.Email_Address__c 					= 'testuniqueemail@gmail.com';
    	
        List<Applicant__c> noDuplicateList = new List<Applicant__c>();
        noDuplicateList.add(app1);
        noDuplicateList.add(app2);

        Test.startTest();
            ApplicantTriggerHandler.populateThirdPartyST(noDuplicateList);
            ApplicantTriggerHandler.checkExternalApplicantEmail(noDuplicateList);
            insert app3;
            ApplicantTriggerHandler.checkExternalApplicantEmail(noDuplicateList);
        Test.stopTest();
	}
}