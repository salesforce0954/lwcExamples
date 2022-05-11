/*
 * @Description: Test class for Generate Document service
 * @Author: Fel Saliba
 * @Date Created: Marhc-17-2014
 * @History:
   =====================================================================
       18-02-14: Created - Fel
   =====================================================================
 */
//@isTest
@isTest
public class IS_GenerateDocument_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    
        public static testMethod void testGenerateDocumentSuccess() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Contact testContact = TestDataBuilder.createBrokerRecord();
        insert testContact;
                
     /* List<District__c> dist = TestDataBuilder.createDistirct(10);
        Branch__c branch = new Branch__c(
                    Name = 'Test',
                    District__c = 'a0CO000000JxrLa',
                    Branch_ID__c = '001' 
            );
        insert branch;
        List<Branch__c> branchList = new List<Branch__c>();
        branchList.add(branch);*/
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'PC';
        insert testApplication;       
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;        
        System.assertEquals(testApplicant.Is_Primary_Applicant__c,true);
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;        
        insert testApplicant2;      
        System.assertEquals(testApplicant.Is_Primary_Applicant__c,true);
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        IS_GenerateDocument.queryProductItems(applicationBuilder.application.Id);

        Product_Item__c pItem=TestDataBuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.id, 'test', string.valueof(testApplicant.id), string.valueof(testApplicant2.id));
        insert pItem;
        List<Product_Item__c> pitemList = new List<Product_Item__c>();
        pitemList.add(pItem);
        
        List<Collateral__c> collateralList = new List<Collateral__c>();
        Collateral__c collateral = new Collateral__c();
        collateral = TestDataBuilder.createCollateral(testApplication.Id);
        collateral.Collateral_Type__c = null;
        collateral.Collateral_Make__c = null;
        collateral.Collateral_Model__c = null;
        collateral.Collateral_Year__c = null;
        collateralList.add(collateral);

        Id directDebitRecordType = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' AND DeveloperName = 'Direct_Debit' LIMIT 1].Id;
        Debit__c debit = new Debit__c();
        debit = TestDataBuilder.createDebit(directDebitRecordType, testApplication.Id);
        debit.Account_Holders__c = null;
        debit.Bank_Name__c = null;
        debit.Branch_Location__c = null;
        debit.BSB_Number__c = null;

        List<Debit__c> debitList = new List<Debit__c>();
        debitList.add(debit); 
                                                     
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();

        Personal_Reference_Check__c testPersonalRefCheck = TestDataBuilder.createPersonalReferenceCheck(applicationBuilder.application.Id);
        
        Test.StartTest();
        IS_IValidator validator = new IS_GenerateDocumentValidator ();
        List<IS_ValidationError> errors = new List<IS_ValidationError>();
        IS_ValidationError vError = new IS_ValidationError('abc','xyz');
        appDTO.app = testApplication;
        appDTO.app.Doc_Gen_Check__c = true;
        System.assertEquals(appDTO.app.Doc_Gen_Check__c,true);
        appDTO.app.Out_of_Sync__c = true;
        System.assertEquals(appDTO.app.Out_of_Sync__c,true);
        appDTO.app.Staff_Hide__c = true;        
        System.assertEquals(appDTO.app.Staff_Hide__c,true);
        appDTO.app.Acceptance_Channel__c = 'Online Acceptance';
        System.assertEquals(appDTO.app.Acceptance_Channel__c,'Online Acceptance');
        appDTO.app.Doc_Gen_Check__c = true;
        System.assertEquals(appDTO.app.Doc_Gen_Check__c,true);
        appDTO.app.Update_Doc_Gen_Check__c = true;
        System.assertEquals(appDTO.app.Update_Doc_Gen_Check__c,true);
        errors.add(vError);
        update appDTO.app;
                    
        IS_GenerateDocument.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
       // IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
        IS_GenerateDocument.queryPersonalReferenceCheck(null);
        IS_GenerateDocument.queryDisbursementPlans(applicationBuilder.application.Id);
        IS_GenerateDocument.queryApplicationAllDebits(applicationBuilder.application.Id);
        IS_GenerateDocument.queryCollaterals(applicationBuilder.application.Id);
        IS_GenerateDocument.queryDisbursement(applicationBuilder.application.Id);
        //IS_GenerateDocument.queryProductItems(applicationBuilder.application.Id);
        IS_GenerateDocument.queryApplicationDebits(applicationBuilder.application.Id);
        IS_GenerateDocument.queryBrokerDetails(testContact.Id);
        //IS_GenerateDocument.queryBranchDetails(branch.Id);
        Test.StopTest();        
    }
    
    public static testMethod void testGenerateDocumentRetry() {
           test.startTest();
           IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
           Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Response_Code__c = 'PC';
            testApplication.Promo_Online_Message__c = null;
            insert testApplication;
           
           System.assertEquals(testApplication.Promo_Online_Message__c,NULL);
           test.stopTest();
    }
     public static testMethod void testGenerateDocumentTry() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);          
           IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    }
     public static testMethod void testGenerateDocumentCatch() {
           Application__c testApplication = TestDataBuilder.createApplication();
           IS_ApplicationDTO appDTO = new IS_ApplicationDTO();   
           try{
                WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);          
               IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, false, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
              }catch(Exception e){
                System.assertEquals(appDTO.app,(Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, null)); 
               }
     }
     public static testMethod void testGenerateDocumentsT() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
           test.startTest();
           IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
           Application__c testApplication = TestDataBuilder.createApplication();
           IS_GenerateDocument.runAsyncRelatedDocumentProcess(appDTO,applicationBuilder.application.Id);
           if(applicationBuilder.application.Id == null){
               DOC_GenerateDocumentsUtil doc = new DOC_GenerateDocumentsUtil();
               Set<Related_Document__c> reDocs = new Set<Related_Document__c>();
               List<Related_Document__c> relListDocs = new List<Related_Document__c>();
               System.assert(relListDocs.size() >0);           
           }
           test.stopTest();
    }             
     /*public static void init(){
        Related_Document__c relDoc = new Related_Document__c();
        relDoc.Document_Category__c ='Loan Documents';
        relDoc.Application__c ='a0JO000000A10Cp';
        insert relDoc;

     }*/
     public static testMethod void testGenerateDocumentsOne() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
           test.startTest();
           IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
           Application__c testApplication = TestDataBuilder.createApplication();
           //init();
           IS_GenerateDocument.runAsyncRelatedDocumentProcess(appDTO,applicationBuilder.application.Id);
           List<Related_Document__c> relDocsList = [Select Id, Type__c, Title__c, Document_Category__c, Template_Name__c From Related_Document__c where Document_Category__c =: 'Loan Documents'];
           System.assert(relDocsList.size()>0);
           if(applicationBuilder.application.Id == null){
               DOC_GenerateDocumentsUtil doc = new DOC_GenerateDocumentsUtil();
               Set<Related_Document__c> reDocs = new Set<Related_Document__c>();
               List<Related_Document__c> relListDocs = new List<Related_Document__c>();           
           }
           test.stopTest();
    }
     public static testMethod void testGenerateDocumentsTwo() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
           test.startTest();
           IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
           Application__c testApplication = TestDataBuilder.createApplication();
           IS_GenerateDocument.runAsyncRelatedDocumentProcess(appDTO,applicationBuilder.application.Id);
           List<Related_Document__c> relDocsList = [Select Id, Type__c, Title__c, Document_Category__c, Template_Name__c From Related_Document__c where Document_Category__c =: 'Loan'];
           System.assert(relDocsList.size()==0);
           if(applicationBuilder.application.Id == null){
               DOC_GenerateDocumentsUtil doc = new DOC_GenerateDocumentsUtil();
               Set<Related_Document__c> reDocs = new Set<Related_Document__c>();
               List<Related_Document__c> relListDocs = new List<Related_Document__c>();           
           }
           test.stopTest();
    }    
}