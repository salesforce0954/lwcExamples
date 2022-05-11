/*
 * @Description: Test class for Generate Document service
 * @Author: Fel Saliba
 * @Date Created: Marhc-17-2014
 * @History:
   =====================================================================
       18-02-14: Created - Fel
   =====================================================================
 */

@isTest
public class WS_GenerateDocument_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }

    static testMethod void testGenerateDocumentSuccess() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        System.debug('***:'+[Select count() from Related_Document__c]);
        IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
    
        //TODO: Assertions here
    }

    /*static testMethod void testGenerateDocumentRetry() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);

        List<Related_Document__c> retryDoc = new List<Related_Document__c>();
        retryDoc = [Select Id from Related_Document__c 
                    Where Application__c =: applicationBuilder.application.Id
                    And Status__c = 'Sent'
                    And Document_Category__c =: 'Loan Documents'];
                                                                                     
        
        IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,retryDoc[0].Id);
    
        //TODO: Assertions here
    }*/
    
}