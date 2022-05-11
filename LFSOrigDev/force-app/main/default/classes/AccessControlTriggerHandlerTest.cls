/*
 * @Description: Access control trigger handler
 * @Author: Mac
 * @Date Created: 3-MAR-2014
 * @History:
 * =====================================================================
 *     Mac - 3-MAR-2014: Created
 * =====================================================================
 */
@isTest
public class AccessControlTriggerHandlerTest {
    @isTest static void test_method_one() {
        Profile p = [Select Id from Profile where Name = 'System Administrator'];
        AccessControlTriggerHandler acth = new AccessControlTriggerHandler();


        Response_Code_Control__c rcc = TestDataBuilder.createResponseCodeControlPA();
        Response_Code_Control__c rcc2 = TestDataBuilder.createResponseCodeControlPCO();		
        Profile_Control__c pc = TestDataBuilder.createProfileControl(true);
        insert rcc;
        insert rcc2;
        insert pc;

        Test.startTest();		
                Boolean isPub = acth.publisherResponseCodeControl('PAO', 'Personal_Reference_Check__c'); 
                System.assertEquals(isPub, true);
                Boolean isPub2 = acth.publisherResponseCodeControl('PCO', 'Credit_Ref_Check__c');
                System.assertEquals(isPub2, true);
                Boolean isPub3 = acth.publisherResponseCodeControl('PAO', 'Credit_File_Check__c');       
                System.assertEquals(isPub3, true); 
                Boolean isPub4 = acth.publisherResponseCodeControl('PCO', 'Risk_Referral__c');
                System.assertEquals(isPub4, true);
                Boolean isPub5 = acth.publisherResponseCodeControl('PAO', 'Lending_Limit_Override__c'); 
                System.assertEquals(isPub5, false);
                Boolean isPub6 = acth.publisherResponseCodeControl('PCO', 'Rate_Reduction__c');
                System.assertEquals(isPub6, false);
                Boolean isPub7 = acth.publisherResponseCodeControl('PAO', 'Fee_Reduction__c');      
                System.assertEquals(isPub7, false); 
                Boolean isPub8 = acth.publisherResponseCodeControl('PCO', 'Manager_Approval__c');  
                System.assertEquals(isPub8, true);

                Boolean isPubCon9 = acth.publisherProfileControl(p.Id, 'Personal_Reference_Check__c');
                System.assertEquals(isPubCon9, true);
                Boolean isPubCon10 = acth.publisherProfileControl(p.Id, 'Credit_Ref_Check__c'); 
                System.assertEquals(isPubCon10, true);
                Boolean isPubCon11 = acth.publisherProfileControl(p.Id, 'Credit_File_Check__c');
                System.assertEquals(isPubCon11, true);
                Boolean isPubCon12 = acth.publisherProfileControl(p.Id, 'Risk_Referral__c');     
                System.assertEquals(isPubCon12, true);
                Boolean isPubCon13 = acth.publisherProfileControl(p.Id, 'Lending_Limit_Override__c');     
                System.assertEquals(isPubCon13, true);
                Boolean isPubCon14 = acth.publisherProfileControl(p.Id, 'Rate_Reduction__c');     
                System.assertEquals(isPubCon14, true);
                Boolean isPubCon15 = acth.publisherProfileControl(p.Id, 'Fee_Reduction__c');     
                System.assertEquals(isPubCon15, true);
                Boolean isPubCon16 = acth.publisherProfileControl(p.Id, 'Manager_Approval__c');      
                System.assertEquals(isPubCon16, true);
        Test.stopTest();
    }

    @isTest static void test_method_Two() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end


        Response_Code_Control__c responseCode = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCode;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        AccessControlTriggerHandler acth = new AccessControlTriggerHandler();

        List<Personal_Reference_Check__c> perRefList = new List<Personal_Reference_Check__c>();
        for(Integer i=0; i <= 4; i ++){
                perRefList.add(TestDataBuilder.createPersonalReferenceCheck(testApplication.Id));
        }
        insert perRefList;

        Set<Id> appId = new Set<Id>();
        appId.add(testApplication.Id);
        Test.startTest();
                System.assert(acth.insertDisbursement(testApplication.Response_Code__c));
                System.assert(acth.updateDisbursement(testApplication.Response_Code__c));
                System.assert(acth.deleteDisbursement(testApplication.Response_Code__c));
                System.assert(acth.insertCollateral(testApplication.Response_Code__c));
                System.assert(acth.updateCollateral(testApplication.Response_Code__c));
                System.assert(acth.deleteCollateral(testApplication.Response_Code__c));
                System.assert(acth.insertDebit(testApplication.Response_Code__c));
                System.assert(acth.deleteDebit(testApplication.Response_Code__c));
                System.assert(acth.updateDebit(testApplication.Response_Code__c));
                acth.cancelRateReduction(appId);
                acth.blockUndelete(new List<Application__c>());
                acth.validatePersonalRefCheckCount(perRefList);
        Test.stopTest();
    }

    @isTest static void test_method_undelete() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Channel__c = 'Broker';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.Undelete__c = false;
        insert testProfileControl;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Collateral_Settings__c testCollateralSettings = TestDatabuilder.createCollateralSetting();
        insert testCollateralSettings;

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        insert testAML;

        Collateral__c testCollateral = TestDatabuilder.createCollateral(testApplication.Id);
        insert testCollateral;

        Credit_Ref_Check__c testCreditRefCheck = TestDatabuilder.createCreditRefCheck(testApplication.Id);
        insert testCreditRefCheck;

        Id directDebitRecordTypeId = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' AND DeveloperName = 'Direct_Debit' LIMIT 1].Id;

        Debit__c testDebit = TestDatabuilder.createDebit(directDebitRecordTypeId, testApplication.Id);
        insert testDebit;

        Disbursement__c testDisbursement = TestDatabuilder.createDisbursement(testApplication.Id);
        insert testDisbursement;

        Related_Document__c testRelatedDocument = TestDatabuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        insert testRelatedDocument;

        Requested_Document__c testRequestedDocument = TestDatabuilder.createRequestDoc(testApplication.Id);
        insert testRequestedDocument;

        delete testAML;
        delete testAsset;
        delete testDebit;
        delete testDisbursement;
        delete testExpense;
        delete testIncome;
        delete testDebt;
        delete testLoanPurpose;
        delete testCreditRefCheck;
        delete testRelatedDocument;
        delete testRequestedDocument;
        //delete testCollateral;

        Test.startTest();
            try{
                undelete testLoanPurpose;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testIncome;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testAsset;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }
            
            try{
                undelete testExpense;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testDebt;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testDebit;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testDisbursement;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }
            
            try{
                undelete testCreditRefCheck;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testRelatedDocument;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testRequestedDocument;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            try{
                undelete testAML;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }

            //try{
            //    undelete testCollateral;
            //}catch(DmlException e){
            //    System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            //}

            delete testApplicant;
            try{
                undelete testApplicant;
            }catch(DmlException e){
                System.assert(e.getMessage().contains('Undelete not allowed'), e.getMessage());
            }
        Test.stopTest();
    }
}