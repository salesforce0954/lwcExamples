/*
 * @Description: Test class for WS WebserviceHelper
 * @Author: Dan Crisologo
 * @Date Created: APR-15-2014
 * @History:
   =====================================================================
       15-04-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_WebServiceHelper_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    
    //this test method will cover other WS WebserviceHelper method not covered by the main ws test classes
    static testMethod void testWSHelperMethods() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest(); 
        
        CommonModelServicingGeCom.Note wsNote = WS_WebServiceHelper.generateNote('Test Id', 
                                                                                 'Username', 
                                                                                 'Staff SSO', 
                                                                                 DateTime.Now(),
                                                                                 new String[] {'test'}, 
                                                                                 'noteCategory', 
                                                                                 'NoteTypeCode', 
                                                                                 'NoteTypeName');
        
        System.assertEquals('noteCategory', wsNote.category); //check that mapping is correct
        
        ApplicationModelServicingGeCom.Application wsApplication = WS_WebServiceHelper.generateApplication('TestId', 
                                                                                                           DateTime.Now(), 
                                                                                                           '1234567890', 
                                                                                                           'caseID');
                                                                                       
        System.assertEquals('1234567890', wsApplication.accountNumber); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.BrokerCommissionDetails wsBrokerCommissionDetails = WS_WebServiceHelper.generateBrokerCommissionDetails('Test Agent', '5000.00');
        
        System.assertEquals('5000.00', wsBrokerCommissionDetails.commissionOf); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.Department wsDepartment = WS_WebServiceHelper.generateDepartment(applicationBuilder.branch);
        System.assertEquals('1234 5678 9012', wsDepartment.telephone); //check that mapping is correct
               
        applicationBuilder.relatedDocument[0].Disbursement__c = applicationBuilder.disList[0].id;
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        appDTO.branch = applicationBuilder.branch;
        appDTO.applicant = applicationBuilder.applicant1;
        appDTO.applicant2 = applicationBuilder.applicant2;
        
        GenerateDocumentGeComOriginations.AccountLimitReduction wsAccountLimitReduction = WS_WebServiceHelper.createAccountLimitReduction(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountLimitReduction.contactCollection.contact.size()); //check that mapping is correct

        GenerateDocumentGeComOriginations.AccountClosure wsAccountAccountClosure = WS_WebServiceHelper.createAccountClosureDocument(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountAccountClosure.contactCollection.contact.size()); //check that mapping is correct

        appDTO.app = applicationBuilder.application;

        GenerateDocumentGeComOriginations.PayoutStatement wsAccountPayoutStatement = WS_WebServiceHelper.createPayoutStatement(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals('false', wsAccountPayoutStatement.PayoutStatementDetails.isOnline); //check that mapping is correct

        appDTO.insuranceList = applicationBuilder.prodItemList;

        GenerateDocumentGeComOriginations.LoanProtectionInsurance wsLoanProtectionInsurance = WS_WebServiceHelper.generateLoanProtectionInsurance(appDTO);
        System.assertEquals('true', wsLoanProtectionInsurance.isJointCustomers); //check that mapping is correct
        
        //test for generateTimeWithEmployerType()
        ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType wsTimeWithEmployerType = WS_WebServiceHelper.generateTimeWithEmployerType(20, 5);
        System.assertEquals(20, wsTimeWithEmployerType.years); //check that mapping is correct
        
        //test for generateAddress()
        ConsumerAnzCapitalGeComOriginations.Address wsGenerateAddress= WS_WebServiceHelper.generateAddress('TestpropertyName', 'TestunitNumber', 'TesthouseNumber',
                                                                              'TeststreetName', 'TeststreetType',
                                                                              'Testcity', 'Testpostcode',
                                                                              'Teststate', 'Testcountry','Testsuburb','TestServicetype','TestServiceId');
        System.assertEquals('Testcountry', wsGenerateAddress.country); //check that mapping is correct
        
        //test for generateTimeAtAddressType()
        ConsumerAnzCapitalGeComOriginations.TimeAtAddressType wsGenerateTimeAtAddressType = WS_WebServiceHelper.generateTimeAtAddressType(20, 5);
        System.assertEquals(20, wsGenerateTimeAtAddressType.years); //check that mapping is correct
        
        //test for generatePersonalDetailsType(Applicant__c applicant)
        ConsumerAnzCapitalGeComOriginations.PersonalDetailsType wsGeneratePersonalDetailsType
            = WS_WebServiceHelper.generatePersonalDetailsType(applicationBuilder.applicant1);      
       System.assertEquals('Ruffles', wsGeneratePersonalDetailsType.lastName); //check that mapping is correct    
        
        //test for generatePOIIncomeDetails(List<Income__c> incomeList)
        List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails> wsGeneratePOIIncomeDetails
            = WS_WebServiceHelper.generatePOIIncomeDetails(applicationBuilder.incomeList);
        System.assertEquals(2000.00, wsGeneratePOIIncomeDetails[0].incomeAmount); //check that mapping is correct

        //test for generatePOIIncomeDetails(List<Asset__c> assetList)
        List<ConsumerAnzCapitalGeComOriginations.AssetDetails> wsGenerateAssetDetails
            = WS_WebServiceHelper.generateAssetDetails(applicationBuilder.assetList);
        System.assertEquals(50000.00, wsGenerateAssetDetails[0].assetValue); //check that mapping is correct   
        
        
        //test for generateExpenseDetails(List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.ExpenseDetails wsGenerateExpenseDetails
            = WS_WebServiceHelper.generateExpenseDetails(applicationBuilder.expenseList,applicationBuilder.applicant1);
        System.assertEquals(300.00, wsGenerateExpenseDetails.livingExpenseAmount); //check that mapping is correct

        //test for generateExpenseDetails(List<Expense__c> expenseList)
         List<ConsumerAnzCapitalGeComOriginations.DebtDetails> wsGenerateDebtDetails
            = WS_WebServiceHelper.generateDebtDetails(applicationBuilder.debtList,applicationBuilder.application);
//        System.assertEquals('Bank3', ''); //check that mapping is correct
        System.assertEquals(1000.00, wsGenerateDebtDetails[0].originalDebtAmount); //check that mapping is correct
        
        //test for generateBudgetDetailsType(Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.BudgetDetailsType wsGenerateBudgetDetailsType
            = WS_WebServiceHelper.generateBudgetDetailsType(applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.disList);
        System.assertEquals(5000, wsGenerateBudgetDetailsType.totalIncome); //check that mapping is correct
        System.assertEquals('SMART', wsGenerateBudgetDetailsType.employerName); //check that mapping is correct
        
        //test for generateApplicantType(String sfApplicantId,Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList,List<Applicant_CLV__c> applicantCLVList) 
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType
            = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, appDTO.app);
        System.assertEquals('TestsfApplicantId', wsGenerateApplicantType.sfApplicantId); //check that mapping is correct
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> listApplicantType = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        listApplicantType.add(wsGenerateApplicantType);
       
       //Added by Arshad                      
/*         ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection wsGenerateCLVDetailsCollection
            = WS_WebServiceHelper.generateCLVDetailsCollection(applicationBuilder.appCLVList);
         ConsumerAnzCapitalGeComOriginations.clvDetailsType clvdetone =  new ConsumerAnzCapitalGeComOriginations.clvDetailsType();           
*/       

        ConsumerAnzCapitalGeComOriginations.clvDetailsType clvDetails = new ConsumerAnzCapitalGeComOriginations.clvDetailsType();
            clvDetails.clvId = '1234';
            clvDetails.icbsCustomerId = '1234';
            clvDetails.geContactId = '1234';
            clvDetails.dateOfBirth = '02/09/1987';
            clvDetails.driverLicense = 'AB123456';
            clvDetails.title = 'test';
            clvDetails.firstName = 'test';
            clvDetails.middleName = 'test';
            clvDetails.surName = 'test';
            clvDetails.workNumber = '0473283782';
            clvDetails.mobileNumber = '0473283782';
            clvDetails.home = '0473283782';
            clvDetails.street = 'test';
            clvDetails.suburb = 'test';
            clvDetails.state = 'test';
            clvDetails.postCode = '1234';
            
            
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        testProduct.Product_Name__c = 'Latitude Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplicationNZ = TestDataBuilder.createApplicationNZ(testBrand);
        insert testApplicationNZ;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Product_SubType__c = 'Better Start PL';
        testApplication.Offered_Interest_Rate_Orig__c = 13.99;
        testApplication.Loan_Term_Months__c = 24;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Acceptance_Channel__c= 'Internet';
        testApplication.Offered_Interest_Rate__c = 13.99;
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Previous_App_No__c = 'new';
        testApplication.Promo_ID__c = 'old loan';
        testApplication.Initial_Submit_Date__c = System.Today();
        insert testApplication;

        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '0212345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '0212345678';
            testApplicant.Country_Pos__c = 'New Zealand';
            testApplicant.Country_Res__c = 'New Zealand';
            testApplicant.Country_Pre__c = 'New Zealand';
            testApplicant.State_Res__c = 'PARRAMATTA';
            testApplicant.State_Pos__c = 'PARRAMATTA';
            testApplicant.State_Pre__c = 'PARRAMATTA';
            testApplicant.City_Pos__c = 'TEST';
            testApplicant.City_Pre__c = 'VIC';
           insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        
        
        List<Applicant_CLV__c> applicantCLVList = new List<Applicant_CLV__c>();
        Applicant_CLV__c apCLV = TestDataBuilder.createApplicantCLV(appSearch.Id, testApplicant.Id);
        applicantCLVList.add(apCLV);
        insert applicantCLVList;

       ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection wsGenerateCLVDetailsCollectionn = WS_WebServiceHelper.generateCLVDetailsCollection(applicantCLVList);
                
        List<AML__c> amlLists = new List<AML__c>();
        AML__c amlOne = TestDataBuilder.createAMLRecords(testApplicant.Id,2,'test');
        amlLists.add(amlOne);
        insert amlLists;
        
        WS_WebServiceHelper.generateAMLApplicantsCollection(amlLists,amlLists);
        
             //Added By Arshad for Improving Code Coverage
//            Application__c testApplicatn = new Application__c();
//            insert testApplicatn;
         ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsTypes = WS_WebServiceHelper.generateProductDetailsType(testApplication,testProduct, TRUE, 0, 'VIC',new Better_Start_Offer__c());
         ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsTypees = WS_WebServiceHelper.generateProductDetailsType(testApplication,testProduct, TRUE, 4, 'VIC',new Better_Start_Offer__c());

         ConsumerAnzCapitalGeComOriginations.PersonalDetailsType wsGeneratePersonalDetailsTypee = WS_WebServiceHelper.generatePersonalDetailsType(testApplicant);    
 
         ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetailsTypee = WS_WebSErviceHelper.generateOfferDetailsType(testApplication);
 
//         GenerateDocumentGeComOriginations.Contact generateContacts = WS_WebServiceHelper.generateAppExtractContact(new Applicant__c(City_Res__c='klasfd',Service_Delivery_Type__c='lkalsdf',Suburb_Pos__c='awerw',Service_Delivery_Id__c='werwe'),new List<Expense__c>(), new List<Income__c>(),'NZ');
         GenerateDocumentGeComOriginations.Contact generateContacts = WS_WebServiceHelper.generateAppExtractContact(testApplicant,new List<Expense__c>(), new List<Income__c>(),'NZ');
         GenerateDocumentGeComOriginations.Contact     generateContactt = WS_WebServiceHelper.generateContactForNZSignUpLetter(testApplication,testApplicant);

         GenerateDocumentGeComOriginations.Contact     generateContacttt = WS_WebServiceHelper.generateContactForNZSignUpLetter(testApplicationNZ,testApplicant);
  
         WS_WebServiceHelper.generateAmlApplicantType(amlLists);

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

/*        Debit__c db = new Debit__c();
        db.Bank_Name__c = 'Test';
        db.Branch_Location__c = 'NSW';
        db.Account_Holders__c ='abcd';
        db.Bank_Number__c = '33';
        db.BSB_Number__c ='102901';
        db.Account_Number__c ='321212';
        db.Frequency__c ='Monthly';
        db.Repayment_Level__c ='Minimum';
        db.Specify_Higher_Amount__c = 500.00;
        db.Commencement_Date__c = Date.parse('02/07/2022');
*/        
        Fees_Charges__c fee=TestDataBuilder.createFeesAndcharges(testProductVersion.id);
        RecordType debitrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Debit__c' limit 1];
        Debit__c debit= TestDataBuilder.createDebit(debitrecordType.id,testApplication.Id);
       
        
        ConsumerAnzCapitalGeComOriginations.RepaymentDetailsArray generateRepaymentDetails = WS_WebServiceHelper.generateRepaymentDetails(new List<Debit__c>{debit});
      
        if(debit.Application__r.Product_Subtype__c != null){
        debit.Application__r.Product_Subtype__c = 'Better Start PL';
        }
/*          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
*/
       ConsumerAnzCapitalGeComOriginations.repaymentDetails repaymentDetails = new ConsumerAnzCapitalGeComOriginations.repaymentDetails();    
       Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
        Integer i;
        if(debit==null){
           bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;
            insert bsoffer;
          ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType = WS_WebServiceHelper.generateLoanDetailsType(testApplication, new list<Loan_Purpose__c>{testLoanPurpose}, testProduct, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});
        }else if (debit!=null){
           if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
        ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType = WS_WebServiceHelper.generateLoanDetailsType(testApplication, new list<Loan_Purpose__c>{testLoanPurpose}, testProduct, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});                  

//        ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetails = WS_WebServiceHelper.generateFeeDetails(new List<Fees_Charges__c>{fee}, testApplication);
        ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetails = WS_WebServiceHelper.generateFeeDetails(new List<Fees_Charges__c>
                                                                                                                                           {new Fees_Charges__c(Fee_Type__c='Early Termination Fee 1',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Early Termination Fee 2',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Payment Handling Fee',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Loan Service Fee',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Late Payment Fee',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Loan Service Fee',Fee_Amount__c=100),
                                                                                                                                            new Fees_Charges__c(Fee_Type__c='Late Payment Fee',Fee_Amount__c=100)},testApplication);
        
        GenerateDocumentGeComOriginations.repaymentPeriods rp = WS_WebServiceHelper.generateDocumentRepaymentPeriodDetails(new List<Debit__c>{debit},testApplication);
        
        WS_WebServiceHelper.generateLoanPurposeDetails(new list<Loan_Purpose__c>{testLoanPurpose});
        
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType generateFingerPrintDetailsType=WS_WebServiceHelper.generateFingerPrintDetailsType(testApplication);
        
        WS_WebServiceHelper.formatData(system.today());
        
        WS_WebServiceHelper.formatData(system.now());
        
        WS_WebServiceHelper.formatStringToDate('2014-12-05');
        
        Product_Item__c pItem=TestDataBuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.id, 'test', string.valueof(testApplicant.id), string.valueof(testApplicant2.id));
        
//        GenerateDocumentGeComOriginations.InsuranceDetailsList generateInsuranceDetailsList=WS_WebServiceHelper.generateInsuranceDetailsList(new List<Product_Item__c>{pItem});
        GenerateDocumentGeComOriginations.InsuranceDetailsList generateInsuranceDetailsList=WS_WebServiceHelper.generateInsuranceDetailsList(new List<Product_Item__c>{
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50)});
        
        GenerateDocumentGeComOriginations.InsuranceDetails generateInsuranceDetailz = WS_WebServiceHelper.generateInsuranceDetails(testApplication,new List<Product_Item__c>{
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50),
        new Product_Item__c(Policy_Type__c=5,Fixed_Premium_Amount__c=1000,Ins_Term__c=12,Policy_Num__c=3,Insurance_GST__c=100,Insurance_Stamp_Duty__c=50)});
        
        Personal_Reference_Check__c pRc=TestDataBuilder.createPersonalReferenceCheck(testApplication.id);
        
        GenerateDocumentGeComOriginations.PersonalReferencesList generatePersonalReferencesList= WS_WebServiceHelper.generatePersonalReferencesList(new List<Personal_Reference_Check__c>{pRc});
        
        Related_Document__c rD= TestDataBuilder.createRelatedDocument(testApplicant.id,testApplication.id);
        insert rD;
        
        GenerateDocumentGeComOriginations.DisbursementAuthorityInformation generateDisbursementAuthorityInformation=WS_WebServiceHelper.generateDisbursementAuthorityInformation(testApplication,testApplicant, rD);
        
        //WS_WebServiceHelper.generateInterestFreeRebateDetails(Disbursement_Plan__c disbursementPlan)
        try{
       GenerateDocumentGeComOriginations.InterestFreeRebate generateInterestFreeRebate = WS_WebServiceHelper.generateInterestFreeRebate(rD,appDTO);
       }catch(Exception e){
       }
            
        //WS_WebServiceHelper.generatePrivacyNotice(IS_ApplicationDTO appDTO)
            
        GenerateDocumentGeComOriginations.RepaymentDetails generateDocumentRepaymentDetails = WS_WebServiceHelper.generateDocumentRepaymentDetails(debit);
//        GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails = WS_WebServiceHelper.generateBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','branch','bsb','123456','902','0000', 'AU');
        GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails = WS_WebServiceHelper.generateBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','branch','bsb','123456','902','0000', 'NZ');
//        GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails = WS_WebServiceHelper.generateBPayBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','testBranch','testbsb','123456','902','0000', 'AU','004','Test','102901','222222',5000);
        GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails = WS_WebServiceHelper.generateBPayBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','testBranch','testbsb','123456','902','0000', 'NZ','004','Test','102901','222222',5000);
        GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformation=WS_WebServiceHelper.generateDirectDebitInformation(testApplication,testApplicant,  debit);
        GenerateDocumentGeComOriginations.LoanPurposeCollection generateLoanPurposeCollection=WS_WebServiceHelper.generateLoanPurposeCollection(new list<Loan_Purpose__c>{testLoanPurpose}); 
        

        system.debug('======<< ' + [select Response_code__c,Brand_String__c from Application__c Where Id = :testApplication.Id]);
        //Better_Start_Offer__c bsOffer = new Better_Start_Offer__c();
        Response_Code_Control__c code = TestDataBuilder.createResponseCodeControlPA();
        code.Name = 'Test';
        insert code;
        Response_Code_Control__c code1 = TestDataBuilder.createResponseCodeControlPA();
        code1.Name = 'SAR';
        insert code1;
        Collateral_Settings__c colSet = new Collateral_Settings__c();
        colSet.Name = 'GE';
        colSet.Collateral_Maximum_Items__c = 1;
        colSet.Collateral_Maximum_Value__c = 1000000; 
        colSet.Collateral_Minimum_Value__c = 2000;
        colSet.Collateral_New_Age__c = 1000;
        insert colSet;
        RecordType collateralRT = [SELECT ID FROM RecordType WHERE sObjectType='Collateral__c' and DeveloperName = 'Jetski_NZ'];
        Collateral__c col=TestDataBuilder.createCollateral(testApplication.id, collateralRT.Id);
        insert col;

        GenerateDocumentGeComOriginations.OnRInformation generateOnRInformation=WS_WebServiceHelper.generateOnRInformation(rD,  testApplication, new List<Collateral__c>{col}, testApplicant,
                                                                                          testApplicant2,
                                                                                          new List<Product_Item__c>{pItem},
                                                                                          new list<Loan_Purpose__c>{testLoanPurpose},
                                                                                          'isOnline',
                                                                                          testProduct);
                 
        GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformationList=WS_WebServiceHelper.generateDirectDebitInformation(testApplication,testApplicant, debit);
        
        /**Added Tony Xu for improving code coverage START**/
        ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext('test','test');
        ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext('test','test','test','test',businessContext);
        ConsumerAnzCapitalGeComOriginations.Exception_x exceptionX = WS_WebServiceHelper.generateExceptionX('text','text',Datetime.now(),'test','test','test');
//        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsType = WS_WebServiceHelper.generateProductDetailsType(applicationBuilder.product, TRUE, 0, 'Submitted');
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsType = WS_WebServiceHelper.generateProductDetailsType(testApplication,applicationBuilder.product, TRUE, 0, 'Submitted',new Better_Start_Offer__c());
        ConsumerAnzCapitalGeComOriginations.BranchDetailsType branchDetailsType = WS_WebServiceHelper.generateBranchDetailsType(applicationBuilder.Branch, null, 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        CommonModelServicingGeCom.Variable variable = WS_WebServiceHelper.generateVariable('test','test','test','test','test',true);
        productModelServicingGeCom.Product product = WS_WebServiceHelper.generateProduct(applicationBuilder.product);
        ContractModelServicingGeCom.Contract contract = WS_WebServiceHelper.generateContract('test');
        SalesModelServicingGeCom.SalesDialogInput salesDialogInput = WS_WebServiceHelper.generateSalesDialogInput('test','test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationDataType appDataType = WS_WebServiceHelper.generateApplicationDataType('test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType appCupOverrideDataType = WS_WebServiceHelper.generateApplicationCpuOverrideDataType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.BrokerDetailsType brokerDetailsType = WS_WebServiceHelper.generateBrokerDetailsType(applicationBuilder.broker,applicationBuilder.application);
//        ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetailsType = WS_WebSErviceHelper.generateOfferDetailsType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetailsType = WS_WebServiceHelper.generateOfferDetailsType(new Application__c(Promo_Loan_Offer_Amount__c=100,Promo_ID__c='safasdf'));
        ConsumerAnzCapitalGeComOriginations.DisbursementCollection disCollection = WS_WebserviceHelper.generateDisbursementCollection(applicationBuilder.disList);
        ConsumerAnzCapitalGeComOriginations.InsuranceCollection insuranceCollection = WS_WebServiceHelper.generateInsuranceCollection(applicationBuilder.prodItemList);      
        ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection poiAppCollection = WS_WebServiceHelper.generatePOIApplicantsCollection(applicationBuilder.applicant1,applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.incomeList);
        ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection refAccCollection = WS_WebServiceHelper.generateRefinance(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DisbursementDetails disbursementDetails = WS_WebserviceHelper.generateDisbursementDetails(applicationBuilder.disList[0]);
        GenerateDocumentGeComOriginations.DisbursementDetailsCollection disDetailsCollection = WS_WebServiceHelper.generateDisbursementDetailsCollection(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DocumentCommonAttrType docCommonAttrType = WS_WebServiceHelper.generateDocumentCommonAttrType(applicationBuilder.relatedDocument[0]);      
        
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType1 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant1.id),applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType2 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant2.id),applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new  List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        applicantTypeList.add(ApplicantType1);
        applicantTypeList.add(ApplicantType2);
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection ApplicantCollection =  WS_WebServiceHelper.generateApplicantCollection(applicantTypeList);
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType appCustomerDataType = WS_WebServiceHelper.generateApplicationCustomerDataType(applicationBuilder.application, ApplicantCollection, ProductDetailsType, generateLoanDetailsType, applicationBuilder.assetList,
                                                                                                                        applicationBuilder.debtList, null,null,applicationBuilder.applicant1, applicationBuilder.applicant2, new List<Collateral__c>{col}, new List<Personal_Reference_Check__c>{pRc});
       
        GenerateDocumentGeComOriginations.DirectDebitRequest dirDebRequest  = WS_WebServiceHelper.generateDirectDebitRequest(appDTO);                                                                   
        GenerateDocumentGeComOriginations.PrivacyNotice privacyNotice = WS_WebServiceHelper.generatePrivacyNotice(appDTO);
        
        WS_WebServiceHelper.generatePayoffQuoteBusinessContext('test','test');
        WS_WebServiceHelper.generatePayoffQuoteConsumerContext('test','test','test','test',NULL);
        WS_WebServiceHelper.generatePayoffQuoteExceptionX('test','test',datetime.now(),'test','test','test');
        WS_WebServiceHelper.generateExceptionCollection(new list<ConsumerAnzCapitalGeComOriginations.Exception_x>());
        WS_WebServiceHelper.generatePayoffQuoteExceptionCollection(new list<PayoffQuoteAnzCapitalGeCom.Exception_x>());
        WS_WebServiceHelper.generateServiceContext(new ConsumerAnzCapitalGeComOriginations.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateServiceContext(new PayoffQuoteAnzCapitalGeCom.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateRiskReferralDetailsType(true,date.today());
        WS_WebServiceHelper.generateApplicationSupportingDataType(new ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType(),'test',new CaseModelServicingGeCom20.Case_x(),new Branch__c(),new User(), 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        WS_WebServiceHelper.generateCasex(NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateUserx(NULL, null);
        WS_WebServiceHelper.generateProductArrangement(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialog(NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialogInput(new ONR__c(),NULL,NULL,NULL);
        WS_WebServiceHelper.generateDecisionDataType(new Application__c());
        WS_WebServiceHelper.generateAMLApplicantsCollection(NULL,NULL);
//      WS_WebServiceHelper.generateAmlApplicantType(new list<AML__c>());
        WS_WebServiceHelper.generateAmlApplicantType(new list<AML__c>{
                                                                      new AML__c(AML_Pos_Verified_Type__c='Electronic',Id_Sequence_No__c=0,Verified_Flag__c=true,POA_Provided_Flag__c=True,POA_Type__c='Insurance'),
                                                                      new AML__c(AML_Pos_Verified_Type__c='Certified Document',Id_Sequence_No__c=1,Verified_Flag__c=false,POA_Provided_Flag__c=True,POA_Type__c='Electronic POV')});
        WS_WebServiceHelper.generatepoaDetail(new AML__c(POA_Reference_Number__c='sdfsee',POA_Issue_Date__c=Date.today(),ID_Issuer__c='woierw'));
//      WS_WebServiceHelper.generateIdDetail(new AML__c());
        WS_WebServiceHelper.generateIdDetail(new AML__c(Version__c='test',NZ_Residency_Number__c='hlkjasdf'));
        WS_WebServiceHelper.generateDocumentMetadataType(new Map<String,String>());
        WS_WebServiceHelper.generateDocumentsType(new list<GenerateDocumentGeComOriginations.ContractDocType>{new GenerateDocumentGeComOriginations.ContractDocType()},
                                                  new list<GenerateDocumentGeComOriginations.oAndRType>{new GenerateDocumentGeComOriginations.oAndRType()},
                                                  new list<GenerateDocumentGeComOriginations.lpiType>{new GenerateDocumentGeComOriginations.lpiType()},
                                                  new list<GenerateDocumentGeComOriginations.directDebitType>{new GenerateDocumentGeComOriginations.directDebitType()},
                                                  new list<GenerateDocumentGeComOriginations.privacyNoticeType>{new GenerateDocumentGeComOriginations.privacyNoticeType()},
                                                  new list<GenerateDocumentGeComOriginations.accountClosureType>{new GenerateDocumentGeComOriginations.accountClosureType()},
                                                  new list<GenerateDocumentGeComOriginations.accountLimitReductionType>{new GenerateDocumentGeComOriginations.accountLimitReductionType()},
                                                  new list<GenerateDocumentGeComOriginations.payoutStatementType>{new GenerateDocumentGeComOriginations.payoutStatementType()},
                                                  new list<GenerateDocumentGeComOriginations.interestFreeRebateType>{new GenerateDocumentGeComOriginations.interestFreeRebateType()},
                                                  new list<GenerateDocumentGeComOriginations.disbursementAuthorityType>{new GenerateDocumentGeComOriginations.disbursementAuthorityType()},
                                                  new list<GenerateDocumentGeComOriginations.signUpLetterNZType>{new GenerateDocumentGeComOriginations.signUpLetterNZType()});
       // WS_WebServiceHelper.generateContractType(new IS_ApplicationDTO());
//        WS_WebServiceHelper.generateContract(new Application__c(EMI_with_Service_Fee__c = 1,Loan_Term_Months__c = 1,Offered_Monthly_Loan_Service_Fee__c = 1),new List<Collateral__c>(),new Applicant__c(),new Applicant__c(),new Contact(),new list<Disbursement__c>(),new list<Product_Item__c>(),new list<Fees_Charges__c>(),new GEProduct__c());
        WS_WebServiceHelper.generateContract(new Application__c(EMI_with_Service_Fee__c = 1,Loan_Term_Months__c = 1,Offered_Monthly_Loan_Service_Fee__c = 1),new List<Collateral__c>(),new Applicant__c(),new Applicant__c(),new Contact(),new list<Disbursement__c>{new Disbursement__c(Insurance_Type__c='Motor Vehicle Insurance'),new Disbursement__c(Insurance_Type__c='Gap Protection')},
                                             new list<Product_Item__c>(),
                                             new list<Fees_Charges__c>{new Fees_Charges__c(Fee_Type__c='Early Termination Fee 1',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Early Termination Fee 2',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Payment Handling Fee',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Loan Service Fee',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Late Payment Fee',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Loan Service Fee',Fee_Amount__c=100),new Fees_Charges__c(Fee_Type__c='Late Payment Fee',Fee_Amount__c=100)},
                                             new GEProduct__c(),new list<Debit__c>());
                                             
          //Added By Suneel for Improving Code Coverage
    Application__c testApplicatn = new Application__c();
    insert testApplicatn;
        
        WS_WebServiceHelper.formatDateToDatetime(Date.Today());
        WS_WebServiceHelper.getApplicantAge('27-11-1988');
        WS_WebServiceHelper.formatData(12);
        WS_WebServiceHelper.formatData(121);
        WS_WebServiceHelper.generateApplicationMetadata(testApplication);
        WS_WebServiceHelper.generateAppExtractBrokerDetails(new Contact(),new Application__c());
        WS_WebServiceHelper.generateDebtDetailsList(new List<Liability__c>{new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT,Credit_Limit_Amt__c = 1,Card_Overdraft_Bal_Amt__c = 1,Reduced_Credit_Limit__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE,Mortgage_Bal_Amt__c = 1,Mortgage_Borrowed_Amt__c = 1,Mortgage_Repayment_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN ,Car_Personal_Bal_Amt__c = 1,Car_Personal_Borrowed_Amt__c = 1,Car_Personal_Repay_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OTHER ,Other_Borrowed_Amt__c = 1,Other_Repay_Amt__c = 1,Car_Personal_Repay_Amt__c = 1)},applicationBuilder.application,applicationBuilder.applicant1);
        WS_WebServiceHelper.generateAssetDetailsList(new List<Asset__c>   {new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruis', Vehicle_Year__c='22-12-2012'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruisr', Vehicle_Year__c='22-12-2016'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruiser', Vehicle_Year__c='22-12-2015'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruser', Vehicle_Year__c='22-12-2014')});
        WS_WebServiceHelper.generateAppExtractLoanPurposeApplicationSubmitList(new List<Loan_Purpose__c>(),new Application__c(Loan_Term_Months__c=36,Product_SubType__c='Better Start PL'));
                                                                                
        WS_WebServiceHelper.generateAppExtractLoanDetails(12,true);
        WS_WebServiceHelper.generateAppExtractIncomeDetails(new List<Income__c>(),new Applicant__c());
        
   
    
    //GenerateDocumentGeComOriginations.ApplicationExtract generateApplicationExtract = WS_WebServiceHelper.createApplicationExtract(new IS_ApplicationDTO()); 
    GenerateDocumentGeComOriginations.Contact generateContact = WS_WebServiceHelper.generateAppExtractContact(TestDataBuilder.createApplicant(null, testApplicatn.Id),new List<Expense__c>(), new List<Income__c>(),'AU');
    
    //GenerateDocumentGeComOriginations.ApplicationExtract aeDoc = new GenerateDocumentGeComOriginations.ApplicationExtract();
    //aeDoc.applicationNo = '123456789';
    //aeDoc.productName = 'Test';

     //Applicant__c applicant = new Applicant__c();
     //GenerateDocumentGeComOriginations.Contact contact = new GenerateDocumentGeComOriginations.Contact();
    
    
     //IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
     //Disbursement__c generatedisb = TestBuilder.createDisbursement
   //  insert appDTO.disbursementList;
             //contact.id = applicant.id;
             GenerateDocumentGeComOriginations.ContactList  generateContactList = WS_WebServiceHelper.generateContactListForNZSignupLetter(new Application__c(),new Applicant__c(),new Applicant__c());
             GenerateDocumentGeComOriginations.CommunicationDetails generateCommDetails = WS_WebServiceHelper.generateCommunicationDetails('038474838','3121','0483478374','038474838','3121','test@gmail.com');
             GenerateDocumentGeComOriginations.ExpenseDetails generateExpDetails = WS_WebServiceHelper.generateAppExtractExpenseDetails(new List<Expense__c>(),new Applicant__c());
             consumerAnzCapitalGeComOriginations.riskUserDataType generateriskUsrData = WS_WebServiceHelper.generateRiskUserDataType(new Workflow__c(),new Application__c());
             List<consumerAnzCapitalGeComOriginations.reportDetail>     genRepDetail        = WS_WebServiceHelper.generateReportDetail(new Application__c());
             consumerAnzCapitalGeComOriginations.reportDetails   genRepDetails        = WS_WebServiceHelper.generateReportDetails(new Application__c());
             GenerateDocumentGeComOriginations.GEDirectType genGeDirType = WS_WebServiceHelper.generateGEDirect(new Branch__c() ,new Application__c());
             GenerateDocumentGeComOriginations.signUpLetterNZ genSignupletNZ = WS_WebServiceHelper.generatesignUpLetterNZ(new Related_Document__c(),new Is_ApplicationDTO());
             //GenerateDocumentGeComOriginations.InterestFreeRebate genIntFreeDeb = WS_WebServiceHelper.generateInterestFreeRebate(new Related_Document__c(),new Is_ApplicationDTO());
             GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList genIntFreeRebDL = WS_WebServiceHelper.generateInterestFreeRebateDetailsList(new List<Disbursement_Plan__c>());
            //GenerateDocumentGeComOriginations.ObjectiveAndRequirements genObjandReq = WS_WebServiceHelper.createONRDocument(rD, appDTO);
            //GenerateDocumentGeComOriginations.ContractType genConType = WS_WebServiceHelper.generateContractType(appDTO);
            GenerateDocumentGeComOriginations.InterestFreeRebateDetails genDocGeOrg = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c());
//           List<GenerateDocumentGeComOriginations.LoanPurpose> genLoanPurpp = WS_WebServiceHelper.generateLoanPurposeList(new List<Loan_Purpose__c>());
           List<GenerateDocumentGeComOriginations.LoanPurpose> genLoanPurpp = WS_WebServiceHelper.generateLoanPurposeList(new List<Loan_Purpose__c>{
           new Loan_Purpose__c(Loan_Amount__c=2000,Value__c='test',Other_Loan_Purpose__c='sdfsdf'),
           new Loan_Purpose__c(Loan_Amount__c=2000,Value__c='test',Other_Loan_Purpose__c='sdfsdf')});
                      
           
          GenerateDocumentGeComOriginations.DisbursementAuthority genDisbAuth = WS_WebServiceHelper.generateDisbursementAuthority(rD, appDTO);
          GenerateDocumentGeComOriginations.GEDirectType genGEDirect =WS_WebServiceHelper.generateGEDirect(applicationBuilder.branch,testApplication);

          
          GenerateDocumentGeComOriginations.ResidentialHistory genResHis = WS_WebServiceHelper.generateResidentialHistory('1','2','4','5','AU');
          GenerateDocumentGeComOriginations.InterestFreeRebateDetails generateInterestIFRD = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c(IF_Credit_Plan_Number__c = 'testdisb',IF_Current_Credit_Plan_Balance__c=100,Rebate_Amount__c=300));
           
            
        
        /**STOP**/
        Test.stopTest();
    }
    }
    
    private static testMethod void coverWsVariables()
    {
     
            Applicant_CLV__c clv = new Applicant_CLV__c();
            clv.CLV__c ='12345';
            clv.ICBS_Customer_ID__c='1234';
            clv.GE_Contact_ID__c='1234';
            clv.Date_of_Birth__c='02/07/1985';
            clv.Drivers_License__c='AB123456';
            clv.Title__c='Mr';
            clv.First_Name__c='Testone';
            clv.Middle_Name__c='TestMiddle';
            clv.Surname__c='Testtwo';          
            clv.Street_Address__c='jfhj';
            clv.Suburb__c='Hawthorn';
            clv.State__c='VIC';
            clv.Post_Code__c='3121';
            
            insert clv;
           
            
            WS_WebServiceHelper.formatData(20.5);
            
            
       ConsumerAnzCapitalGeComOriginations.Address wsGenerateAddress= WS_WebServiceHelper.generateAddress('TestpropertyName', 'TestunitNumber', 'TesthouseNumber',
                                                                              'TeststreetName', 'TeststreetType',
                                                                              'Testcity', 'Testpostcode',
                                                                              'Teststate', 'New Zealand','Testsuburb','TestServicetype','TestServiceId');
                                                                              System.assertEquals('New Zealand', wsGenerateAddress.country);
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
 
         GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails = WS_WebServiceHelper.generateBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','branch','bsb','123456','902','0000', 'AU');
         GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails = WS_WebServiceHelper.generateBPayBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','testBranch','testbsb','123456','902','0000', 'AU','004','Test','102901','222222',5000);
        //List<ConsumerAnzCapitalGeComOriginations.clvDetailsType> clvdetone =  List<ConsumerAnzCapitalGeComOriginations.clvDetailsType>();
        
          
        Applicant__c testApplicantNZ = WS_WebServiceHelper_Test.createApplicantNZ(null, testApplication.Id);
        insert testApplicantNZ;
        
        Applicant__c testApplicant2NZ = WS_WebServiceHelper_Test.createApplicantNZ(null, testApplication.Id);
        insert testApplicant2NZ;                                                                     
                    
                                                                              }
               public static Applicant__c createApplicantNZ(Id accId, Id applicationId){
        Applicant__c applicant = new Applicant__c();
            applicant.Account__c = accId;
            applicant.Application__c = applicationId;
            applicant.Date_Of_Birth__c = '01-01-1990';
            applicant.Date_of_Birth_WS__c = '1990-01-01';
            applicant.Drivers_Lic_No__c = '123123123';
            applicant.Email_Address__c = 'Test@ge.com';
            applicant.First_Name__c = 'FirstName';
            applicant.Gender__c = 'Male';
            applicant.Home__c = '0212345678';
            applicant.Drivers_Lic_Flg__c = false;
            applicant.Last_Name__c = 'Lastname';
            applicant.Middle_Name__c = 'MidName';
            applicant.Mobile__c = '0412345678';
            applicant.No_of_Deps__c = 2;
            applicant.Postal_Addr_Flg__c = true;
            applicant.Postcode_Pos__c = '4125';
            applicant.Street_Pos__c = 'Sample';
            applicant.Street_No_Pos__c = '123';
            applicant.Street_Type_Pos__c = 'Street';
            applicant.Suburb_Pos__c = 'NSW';
            applicant.Unit_No_Pos__c = '1234';
            applicant.Pref_Contact_Method__c = 'Phone';
            applicant.Postcode_Pre__c = '4215';
            applicant.Street_Pre__c = 'Sample';
            applicant.Street_No_Pre__c = '123';
            applicant.Street_Type_Pre__c = 'Street';
            applicant.Suburb_Pre__c = 'NSW';
            applicant.Unit_No_Pre__c = '123';
            applicant.Rel_Status__c = 'Single';
            applicant.Postcode_Res__c = '4125';
            applicant.Res_Status__c = 'Renting';
            applicant.Street_Res__c = 'Sample';
            applicant.Street_No_Res__c = '123';
            applicant.Street_Type_Res__c = 'Street';
            applicant.Suburb_Res__c = 'NSW';
            applicant.Unit_No_Res__c = '123';
            applicant.Months_At_Addr__c = '2';
            applicant.Years_At_Addr__c = '2';
            applicant.Title__c = 'Mr';
            applicant.Work__c = '0212345678';
            applicant.Country_Pos__c = 'New Zealand';
            applicant.Country_Res__c = 'New Zealand';
            applicant.Country_Pre__c = 'New Zealand';
            applicant.State_Res__c = 'PARRAMATTA';
            applicant.State_Pos__c = 'PARRAMATTA';
            applicant.State_Pre__c = 'PARRAMATTA';
            applicant.Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)';
            applicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
        return applicant;
    }
         
      
  //Added by Suneel to improve the Code Coverage 
  static testMethod void testGenerateDocumentSuccess() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Contact testContact = TestDataBuilder.createBrokerRecord();
        insert testContact;
        
        List<Branch__c> testBranch = TestDataBuilder.createBranch(10);
        insert testBranch;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        //insert appDTO;
        
        Personal_Reference_Check__c testPersonalRefCheck = TestDataBuilder.createPersonalReferenceCheck(applicationBuilder.application.Id);
        //insert testPersonalRefCheck;
        
       // ExceptionLog__c testExpection = TestDataBuilder.createExceptionLog('origin','functionName','objectName','exceptionVar','status','params','2.0',1);
                                                                                     
        System.debug('***:'+[Select count() from Related_Document__c]);
        IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
        IS_GenerateDocument.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
        IS_GenerateDocument.generateDocumentRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
        IS_GenerateDocument.queryPersonalReferenceCheck(null);
        //IS_GenerateDocument.queryFeesAndCharges(new Application__c());
        IS_GenerateDocument.queryDisbursementPlans(applicationBuilder.application.Id);
        IS_GenerateDocument.queryApplicationAllDebits(applicationBuilder.application.Id);
        IS_GenerateDocument.queryCollaterals(applicationBuilder.application.Id);
        IS_GenerateDocument.queryDisbursement(applicationBuilder.application.Id);
        IS_GenerateDocument.queryProductItems(applicationBuilder.application.Id);
        IS_GenerateDocument.queryApplicationDebits(applicationBuilder.application.Id);
        IS_GenerateDocument.queryBrokerDetails(testContact.Id);
        //IS_GenerateDocument.queryBranchDetails(testBranch);
        // IS_GenerateDocument.queryDocumentRecord(testApplication.Id);
        //IS_GenerateDocument.processWSGenerateDocument(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
        
        //IS_GenerateDocument.queryPersonalReferenceCheck(applicationBuilder.application.Id);
        
        
        
        //TODO: Assertions here
    }

   // Added from WS_ApplicationSubmit_Test
   static testMethod void testSuccessfulJointSubmit() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        // Create Application and assign test branch
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 1' + country_channel_Key);
        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSingleSubmit() {
        TestDataBuilder.IsTestFlag = true;

         // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 2' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSubmitRetryRequest() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.OFFLINE_ACCEPTANCE;

        system.debug('Own Key 3' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }

    static testMethod void testSubmitException() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }

    static testMethod void testSingleSubmitCalloutException() {
        TestDataBuilder.IsTestFlag = false;

         // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 2' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }
    //End
    
    //Added from WS_GenerateAppplicationExtract_Test
     static testMethod void testSuccessfulJointAppExtract() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.generateApplicationExtractRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSingleAppExtract() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.generateApplicationExtractRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulAppExtractRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //There should be a validatior error returned
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    //End

        static testMethod void testWS_NZ() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest(); 
        
        // Create Brand
        Brand__c testBrandNZ = TestDataBuilder.createBrand();
        testBrandNZ.Country__c = 'NZ';
        insert testBrandNZ;
        
         Application__c testApplication1 = TestDataBuilder.createApplication();
        testApplication1.save_quote_comments__c='Testing';
        applicationBuilder.application.Brand_Lookup__c = testBrandNZ.Id;
        testApplication1.sub_Status__c='3.Followed up – more time requested';
        testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
        insert testApplication1;  
        
        CommonModelServicingGeCom.Note wsNote = WS_WebServiceHelper.generateNote('Test Id', 
                                                                                 'Username', 
                                                                                 'Staff SSO', 
                                                                                 DateTime.Now(),
                                                                                 new String[] {'test'}, 
                                                                                 'noteCategory', 
                                                                                 'NoteTypeCode', 
                                                                                 'NoteTypeName');
        
        System.assertEquals('noteCategory', wsNote.category); //check that mapping is correct
        
        ApplicationModelServicingGeCom.Application wsApplication = WS_WebServiceHelper.generateApplication('Test Id', 
                                                                                                           DateTime.Now(), 
                                                                                                           '1234567890', 
                                                                                                           'caseID');
                                                                                       
        System.assertEquals('1234567890', wsApplication.accountNumber); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.BrokerCommissionDetails wsBrokerCommissionDetails = WS_WebServiceHelper.generateBrokerCommissionDetails('Test Agent', '5000.00');
        
        System.assertEquals('5000.00', wsBrokerCommissionDetails.commissionOf); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.Department wsDepartment = WS_WebServiceHelper.generateDepartment(applicationBuilder.branch);
        System.assertEquals('1234 5678 9012', wsDepartment.telephone); //check that mapping is correct
        
        applicationBuilder.relatedDocument[0].Disbursement__c = applicationBuilder.disList[0].id;
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        appDTO.branch = applicationBuilder.branch;
        appDTO.applicant = applicationBuilder.applicant1;
        appDTO.applicant2 = applicationBuilder.applicant2;
       
        GenerateDocumentGeComOriginations.AccountLimitReduction wsAccountLimitReduction = WS_WebServiceHelper.createAccountLimitReduction(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountLimitReduction.contactCollection.contact.size()); //check that mapping is correct

        GenerateDocumentGeComOriginations.AccountClosure wsAccountAccountClosure = WS_WebServiceHelper.createAccountClosureDocument(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountAccountClosure.contactCollection.contact.size()); //check that mapping is correct
        
        // Added as part of NZ CR code
       
        appDTO.app = applicationBuilder.application;

        GenerateDocumentGeComOriginations.PayoutStatement wsAccountPayoutStatement = WS_WebServiceHelper.createPayoutStatement(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals('false', wsAccountPayoutStatement.PayoutStatementDetails.isOnline); //check that mapping is correct

        appDTO.insuranceList = applicationBuilder.prodItemList;

        GenerateDocumentGeComOriginations.LoanProtectionInsurance wsLoanProtectionInsurance = WS_WebServiceHelper.generateLoanProtectionInsurance(appDTO);
        System.assertEquals('true', wsLoanProtectionInsurance.isJointCustomers); //check that mapping is correct
        
        //test for generateTimeWithEmployerType()
        ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType wsTimeWithEmployerType = WS_WebServiceHelper.generateTimeWithEmployerType(20, 5);
        System.assertEquals(20, wsTimeWithEmployerType.years); //check that mapping is correct
        
        //test for generateAddress()
        ConsumerAnzCapitalGeComOriginations.Address wsGenerateAddress= WS_WebServiceHelper.generateAddress('TestpropertyName', 'TestunitNumber', 'TesthouseNumber',
                                                                              'TeststreetName', 'TeststreetType',
                                                                              'Testcity', 'Testpostcode',
                                                                              'Teststate', 'Testcountry','Testsuburb','TestServicetype','TestServiceId');
        System.assertEquals('Testcountry', wsGenerateAddress.country); //check that mapping is correct
        
        //test for generateTimeAtAddressType()
        ConsumerAnzCapitalGeComOriginations.TimeAtAddressType wsGenerateTimeAtAddressType = WS_WebServiceHelper.generateTimeAtAddressType(20, 5);
        System.assertEquals(20, wsGenerateTimeAtAddressType.years); //check that mapping is correct
        
        //test for generatePersonalDetailsType(Applicant__c applicant)
        ConsumerAnzCapitalGeComOriginations.PersonalDetailsType wsGeneratePersonalDetailsType
            = WS_WebServiceHelper.generatePersonalDetailsType(applicationBuilder.applicant1);
        System.assertEquals('Ruffles', wsGeneratePersonalDetailsType.lastName); //check that mapping is correct    
        
        //test for generatePOIIncomeDetails(List<Income__c> incomeList)
        List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails> wsGeneratePOIIncomeDetails
            = WS_WebServiceHelper.generatePOIIncomeDetails(applicationBuilder.incomeList);
        System.assertEquals(2000.00, wsGeneratePOIIncomeDetails[0].incomeAmount); //check that mapping is correct

        //test for generatePOIIncomeDetails(List<Asset__c> assetList)
        List<ConsumerAnzCapitalGeComOriginations.AssetDetails> wsGenerateAssetDetails
            = WS_WebServiceHelper.generateAssetDetails(applicationBuilder.assetList);
        System.assertEquals(50000.00, wsGenerateAssetDetails[0].assetValue); //check that mapping is correct   
        
        
        //test for generateExpenseDetails(List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.ExpenseDetails wsGenerateExpenseDetails
            = WS_WebServiceHelper.generateExpenseDetails(applicationBuilder.expenseList,applicationBuilder.applicant1);
        System.assertEquals(300.00, wsGenerateExpenseDetails.livingExpenseAmount); //check that mapping is correct

        //test for generateExpenseDetails(List<Expense__c> expenseList)
         List<ConsumerAnzCapitalGeComOriginations.DebtDetails> wsGenerateDebtDetails
            = WS_WebServiceHelper.generateDebtDetails(applicationBuilder.debtList,applicationBuilder.application);
      //  System.assertEquals('Bank3', wsGenerateDebtDetails[0].financierName); //check that mapping is correct
        
        //test for generateBudgetDetailsType(Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.BudgetDetailsType wsGenerateBudgetDetailsType
            = WS_WebServiceHelper.generateBudgetDetailsType(applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.disList);
        System.assertEquals(5000, wsGenerateBudgetDetailsType.totalIncome); //check that mapping is correct
        System.assertEquals('SMART', wsGenerateBudgetDetailsType.employerName); //check that mapping is correct
        
        //test for generateApplicantType(String sfApplicantId,Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList,List<Applicant_CLV__c> applicantCLVList) 
//        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, appDTO.app);
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, new Application__c(Applicant_1_NFL__c='Yes'));
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType2 = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, new Application__c(Applicant_1_NFL__c='No'));
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType3 = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, new Application__c(Applicant_2_NFL__c='Yes'));
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType4 = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, new Application__c(Applicant_2_NFL__c='No'));
        System.assertEquals('TestsfApplicantId', wsGenerateApplicantType.sfApplicantId); //check that mapping is correct
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> listApplicantType = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        listApplicantType.add(wsGenerateApplicantType);
     
         ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection wsGenerateCLVDetailsCollection
            = WS_WebServiceHelper.generateCLVDetailsCollection(applicationBuilder.appCLVList);
         ConsumerAnzCapitalGeComOriginations.clvDetailsType clvdetone =  new ConsumerAnzCapitalGeComOriginations.clvDetailsType();           
       
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'NZ';
        insert testBrand;
        
        Brand__c testBrandAU = TestDataBuilder.createBrand();
        testBrandAU.Country__c = 'AU';
        insert testBrandAU;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        insert testProduct;
        GEProduct__c testProductAU = TestDataBuilder.createGEProduct(testBrandAU.Id,'Personal Loan','Life Insurance');
        insert testProductAU;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Product_Version__c testProductVersionAU = TestDataBuilder.createProductVersion(testProductAU.Id);
        insert testProductVersionAU;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Offered_Interest_Rate_Orig__c = 13.99;
        testApplication.Loan_Term_Months__c = 24;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Offered_Interest_Rate__c = 13.99;
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.sub_Status__c='1. Not Interested';
        testApplication.Channel__c='Sales';
        insert testApplication;
        
        Application__c testApplicationAU = TestDataBuilder.createApplication();
        testApplicationAU.Brand_Lookup__c = testBrandNZ.Id;
        testApplicationAU.Response_Code__c = 'Test';
        testApplicationAU.Brand_String__c = testBrand.Name;
        testApplicationAU.Product_SubType__c = 'Standard PL';
        testApplicationAU.Offered_Interest_Rate_Orig__c = 13.99;
        testApplicationAU.Loan_Term_Months__c = 24;
        testApplicationAU.Product_SubType__c = 'Standard PL';
        testApplicationAU.Offered_Interest_Rate__c = 13.99;
        testApplicationAU.Brand_Lookup__c = testBrand.Id;
        testApplicationAU.sub_Status__c='1. Not Interested';
        testApplicationAU.Channel__c='Sales';
        insert testApplicationAU;

        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '0212345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '0212345678';
            testApplicant.Country_Pos__c = 'Australia';
            testApplicant.Country_Res__c = 'Australia';
            testApplicant.Country_Pre__c = 'Australia';
            testApplicant.State_Res__c = 'PARRAMATTA';
            testApplicant.State_Pos__c = 'PARRAMATTA';
            testApplicant.State_Pre__c = 'PARRAMATTA';
           insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Fees_Charges__c fee=TestDataBuilder.createFeesAndcharges(testProductVersion.id);
        RecordType debitrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Debit__c' limit 1];
        Debit__c debit= TestDataBuilder.createDebit(debitrecordType.id,testApplication.Id);
        Debit__c debitAU= TestDataBuilder.createDebit(debitrecordType.id,testApplicationAU.Id);
        if(debit.Application__r.Product_Subtype__c != null){
        debit.Application__r.Product_Subtype__c = 'Better Start PL';
        }
        if(debitAU.Application__r.Product_Subtype__c != null){
        debitAU.Application__r.Product_Subtype__c = 'Better Start PL';
        }
/*        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
*/
       ConsumerAnzCapitalGeComOriginations.repaymentDetails repaymentDetails = new ConsumerAnzCapitalGeComOriginations.repaymentDetails();    
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
        Integer i;
        if(debit==null || debitAU==null){
          ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType = WS_WebServiceHelper.generateLoanDetailsType(testApplication, new list<Loan_Purpose__c>{testLoanPurpose}, testProduct, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});
           ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsTypeAU = WS_WebServiceHelper.generateLoanDetailsType(testApplicationAU, new list<Loan_Purpose__c>{testLoanPurpose}, testProductAU, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});
        }
       else if (debit!=null || debitAU!=null){
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
           ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType = WS_WebServiceHelper.generateLoanDetailsType(testApplication, new list<Loan_Purpose__c>{testLoanPurpose}, testProduct, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});
           ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsTypeAU = WS_WebServiceHelper.generateLoanDetailsType(testApplicationAU, new list<Loan_Purpose__c>{testLoanPurpose}, testProductAU, 'test', new List<Debit__c>{debit}, new List<Fees_Charges__c>{fee});         

        ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetails = WS_WebServiceHelper.generateFeeDetails(new List<Fees_Charges__c>{fee}, testApplication);
         ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetailsAU = WS_WebServiceHelper.generateFeeDetails(new List<Fees_Charges__c>{fee}, testApplicationAU);
        
        ConsumerAnzCapitalGeComOriginations.RepaymentDetailsArray generateRepaymentDetails = WS_WebServiceHelper.generateRepaymentDetails(new List<Debit__c>{debit});
        
        GenerateDocumentGeComOriginations.repaymentPeriods rp = WS_WebServiceHelper.generateDocumentRepaymentPeriodDetails(new List<Debit__c>{debit},testApplication);
        GenerateDocumentGeComOriginations.repaymentPeriods rpAU = WS_WebServiceHelper.generateDocumentRepaymentPeriodDetails(new List<Debit__c>{debit},testApplicationAU);
        
        
        WS_WebServiceHelper.generateLoanPurposeDetails(new list<Loan_Purpose__c>{testLoanPurpose});
        
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType generateFingerPrintDetailsType=WS_WebServiceHelper.generateFingerPrintDetailsType(testApplication);
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType generateFingerPrintDetailsTypeAU=WS_WebServiceHelper.generateFingerPrintDetailsType(testApplicationAU);
        
        WS_WebServiceHelper.formatData(system.today());
        
        WS_WebServiceHelper.formatData(system.now());
        
        WS_WebServiceHelper.formatStringToDate('2014-12-05');
        
        Product_Item__c pItem=TestDataBuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.id, 'test', string.valueof(testApplicant.id), string.valueof(testApplicant2.id));
         Product_Item__c pItemAU=TestDataBuilder.createInsuranceProductItem(testApplicationAU.Id, testProductVersionAU.id, 'test', string.valueof(testApplicant.id), string.valueof(testApplicant2.id));
        GenerateDocumentGeComOriginations.InsuranceDetailsList generateInsuranceDetailsList=WS_WebServiceHelper.generateInsuranceDetailsList(new List<Product_Item__c>{pItem});
        
        Personal_Reference_Check__c pRc=TestDataBuilder.createPersonalReferenceCheck(testApplication.id);
        Personal_Reference_Check__c pRcAU=TestDataBuilder.createPersonalReferenceCheck(testApplicationAU.id);
        
        GenerateDocumentGeComOriginations.PersonalReferencesList generatePersonalReferencesList= WS_WebServiceHelper.generatePersonalReferencesList(new List<Personal_Reference_Check__c>{pRc});
        
        Related_Document__c rD= TestDataBuilder.createRelatedDocument(testApplicant.id,testApplication.id);
        Related_Document__c rDAU= TestDataBuilder.createRelatedDocument(testApplicant.id,testApplicationAU.id);
        
        GenerateDocumentGeComOriginations.DisbursementAuthorityInformation generateDisbursementAuthorityInformation=WS_WebServiceHelper.generateDisbursementAuthorityInformation(testApplication,testApplicant, rD);
        GenerateDocumentGeComOriginations.DisbursementAuthorityInformation generateDisbursementAuthorityInformationAU=WS_WebServiceHelper.generateDisbursementAuthorityInformation(testApplicationAU,testApplicant, rD);
                
        GenerateDocumentGeComOriginations.RepaymentDetails generateDocumentRepaymentDetails = WS_WebServiceHelper.generateDocumentRepaymentDetails(debit);
        GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails = WS_WebServiceHelper.generateBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','branch','bsb','123456','902','0000', 'AU');
        GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails = WS_WebServiceHelper.generateBPayBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','testBranch','testbsb','123456','902','0000', 'AU','004','Test','102901','222222',5000);
        GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformation=WS_WebServiceHelper.generateDirectDebitInformation(testApplication,testApplicant,  debit);
         GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformationAU=WS_WebServiceHelper.generateDirectDebitInformation(testApplicationAU,testApplicant,  debit);       
        GenerateDocumentGeComOriginations.LoanPurposeCollection generateLoanPurposeCollection=WS_WebServiceHelper.generateLoanPurposeCollection(new list<Loan_Purpose__c>{testLoanPurpose}); 
        

        system.debug('======<< ' + [select Response_code__c,Brand_String__c,Brand_Country__c,sub_Status__c,Application_Stage__c,
                                    quote_Status__c,pbuid__c,Bank_Accounts_Code__c,uid__c,Business_Source_Code__c,Application_Source_code__c,
                                    Mirror_Code__c,Initial_Requested_Amount__c
                                     from Application__c Where Id = :testApplication.Id]);
                                     
      Application__c AppNZCR = [select Id,Channel__c,Response_code__c,Brand_String__c,Brand_Country__c,sub_Status__c,Application_Stage__c,quote_Status__c,AU_Submit_Flag__c
                                ,pbuid__c,Bank_Accounts_Code__c,uid__c,Business_Source_Code__c,Application_Source_code__c,
                                 Mirror_Code__c,Initial_Requested_Amount__c,Offered_PPSR_Registration_Fee__c,Offered_PPSR_Search_Fee__c
                                 ,Promotional_Campaign_Code__c,ICBS_Account_Number__c,Credit_Score__c,Previous_App_No__c,Initial_Submit_Date__c,
                                 Promo_Loan_Offer_Amount__c,Promo_ID__c,X3rd_Party_Application_Number__c,X3rd_Party_Quoted_Rate__c,
                                 X3rd_Party_Quoted_Risk_Grade__c,Offered_Interest_Rate__c,EMI_with_Service_Fee__c,Total_Loan_Amount_with_Insurance__c,
                                 Offered_Frequency_Repayments__c,Loan_Term_Months__c,Product_SubType__c,Acceptance_Channel__c,
                                 Product_SubType_Code__c                                 
                                 from                                  
                                 Application__c 
                                 Where 
                                 Id = :testApplication.Id];
         
        Response_Code_Control__c code = TestDataBuilder.createResponseCodeControlPA();
        code.Name = 'Test';
        insert code;
        Response_Code_Control__c code1 = TestDataBuilder.createResponseCodeControlPA();
        code1.Name = 'SAR';
        insert code1;
        Collateral_Settings__c colSet = new Collateral_Settings__c();
        colSet.Name = 'GE';
        colSet.Collateral_Maximum_Items__c = 1;
        colSet.Collateral_Maximum_Value__c = 1000000; 
        colSet.Collateral_Minimum_Value__c = 2000;
        colSet.Collateral_New_Age__c = 1000;
        insert colSet;
        RecordType collateralRT = [SELECT ID FROM RecordType WHERE sObjectType='Collateral__c' and DeveloperName = 'Jetski_NZ'];
        Collateral__c col=TestDataBuilder.createCollateral(testApplication.id, collateralRT.Id);
        insert col;

        GenerateDocumentGeComOriginations.MortgageDetails md = WS_WebServiceHelper.generateMortgageDetails(col,testApplicant,testApplicant2);
        
        GenerateDocumentGeComOriginations.OnRInformation generateOnRInformation=WS_WebServiceHelper.generateOnRInformation(rD,  AppNZCR, new List<Collateral__c>{col}, testApplicant,
                                                                                          testApplicant2,
                                                                                          new List<Product_Item__c>{pItem},
                                                                                          new list<Loan_Purpose__c>{testLoanPurpose},
                                                                                          'isOnline',
                                                                                          testProduct);
                                                                                            
               
        GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformationList=WS_WebServiceHelper.generateDirectDebitInformation(AppNZCR,testApplicant, debit);
       
        /**Added Tony Xu for improving code coverage START**/
        ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext('test','test');
        ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext('test','test','test','test',businessContext);
        ConsumerAnzCapitalGeComOriginations.Exception_x exceptionX = WS_WebServiceHelper.generateExceptionX('text','text',Datetime.now(),'test','test','test');
//        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsType = WS_WebServiceHelper.generateProductDetailsType(applicationBuilder.product, TRUE, 0, 'Submitted');
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsType = WS_WebServiceHelper.generateProductDetailsType(AppNZCR,applicationBuilder.product, TRUE, 0, 'Submitted',new Better_Start_Offer__c());
        
        ConsumerAnzCapitalGeComOriginations.BranchDetailsType branchDetailsType = WS_WebServiceHelper.generateBranchDetailsType(applicationBuilder.Branch, null, 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        CommonModelServicingGeCom.Variable variable = WS_WebServiceHelper.generateVariable('test','test','test','test','test',true);
        productModelServicingGeCom.Product product = WS_WebServiceHelper.generateProduct(applicationBuilder.product);
        ContractModelServicingGeCom.Contract contract = WS_WebServiceHelper.generateContract('test');
        SalesModelServicingGeCom.SalesDialogInput salesDialogInput = WS_WebServiceHelper.generateSalesDialogInput('test','test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationDataType appDataType = WS_WebServiceHelper.generateApplicationDataType('test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType appCupOverrideDataType = WS_WebServiceHelper.generateApplicationCpuOverrideDataType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.BrokerDetailsType brokerDetailsType = WS_WebServiceHelper.generateBrokerDetailsType(applicationBuilder.broker,applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetailsType = WS_WebSErviceHelper.generateOfferDetailsType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.DisbursementCollection disCollection = WS_WebserviceHelper.generateDisbursementCollection(applicationBuilder.disList);
        ConsumerAnzCapitalGeComOriginations.InsuranceCollection insuranceCollection = WS_WebServiceHelper.generateInsuranceCollection(applicationBuilder.prodItemList);      
        ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection poiAppCollection = WS_WebServiceHelper.generatePOIApplicantsCollection(applicationBuilder.applicant1,applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.incomeList);
        ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection refAccCollection = WS_WebServiceHelper.generateRefinance(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DisbursementDetails disbursementDetails = WS_WebserviceHelper.generateDisbursementDetails(applicationBuilder.disList[0]);
        GenerateDocumentGeComOriginations.DisbursementDetailsCollection disDetailsCollection = WS_WebServiceHelper.generateDisbursementDetailsCollection(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DocumentCommonAttrType docCommonAttrType = WS_WebServiceHelper.generateDocumentCommonAttrType(applicationBuilder.relatedDocument[0]);      
        
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType1 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant1.id),applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType2 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant2.id),applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new  List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        applicantTypeList.add(ApplicantType1);
        applicantTypeList.add(ApplicantType2);
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection ApplicantCollection =  WS_WebServiceHelper.generateApplicantCollection(applicantTypeList);
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType appCustomerDataType = WS_WebServiceHelper.generateApplicationCustomerDataType(AppNZCR, ApplicantCollection, ProductDetailsType, generateLoanDetailsType, applicationBuilder.assetList,
                                                                                                                        applicationBuilder.debtList, null,null,applicationBuilder.applicant1, applicationBuilder.applicant2, new List<Collateral__c>{col}, new List<Personal_Reference_Check__c>{pRc});
       
                                                                                                       
         GenerateDocumentGeComOriginations.DirectDebitRequest dirDebRequest  = WS_WebServiceHelper.generateDirectDebitRequest(appDTO);                                                                   
        GenerateDocumentGeComOriginations.PrivacyNotice privacyNotice = WS_WebServiceHelper.generatePrivacyNotice(appDTO);
        
        WS_WebServiceHelper.generatePayoffQuoteBusinessContext('test','test');
        WS_WebServiceHelper.generatePayoffQuoteConsumerContext('test','test','test','test',NULL);
        WS_WebServiceHelper.generatePayoffQuoteExceptionX('test','test',datetime.now(),'test','test','test');
        WS_WebServiceHelper.generateExceptionCollection(new list<ConsumerAnzCapitalGeComOriginations.Exception_x>());
        WS_WebServiceHelper.generatePayoffQuoteExceptionCollection(new list<PayoffQuoteAnzCapitalGeCom.Exception_x>());
        WS_WebServiceHelper.generateServiceContext(new ConsumerAnzCapitalGeComOriginations.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateServiceContext(new PayoffQuoteAnzCapitalGeCom.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateRiskReferralDetailsType(true,date.today());
        WS_WebServiceHelper.generateApplicationSupportingDataType(new ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType(),'test',new CaseModelServicingGeCom20.Case_x(),new Branch__c(),new User(), 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        WS_WebServiceHelper.generateCasex(NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateUserx(NULL, null);
        WS_WebServiceHelper.generateProductArrangement(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialog(NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialogInput(new ONR__c(),NULL,NULL,NULL);
        WS_WebServiceHelper.generateDecisionDataType(new Application__c());
        WS_WebServiceHelper.generateAMLApplicantsCollection(NULL,NULL);
        WS_WebServiceHelper.generateAmlApplicantType(new list<AML__c>());
        WS_WebServiceHelper.generatepoaDetail(new AML__c());
        WS_WebServiceHelper.generateIdDetail(new AML__c());
        WS_WebServiceHelper.generateDocumentMetadataType(new Map<String,String>());
        WS_WebServiceHelper.generateDocumentsType(new list<GenerateDocumentGeComOriginations.ContractDocType>{new GenerateDocumentGeComOriginations.ContractDocType()},
                                                  new list<GenerateDocumentGeComOriginations.oAndRType>{new GenerateDocumentGeComOriginations.oAndRType()},
                                                  new list<GenerateDocumentGeComOriginations.lpiType>{new GenerateDocumentGeComOriginations.lpiType()},
                                                  new list<GenerateDocumentGeComOriginations.directDebitType>{new GenerateDocumentGeComOriginations.directDebitType()},
                                                  new list<GenerateDocumentGeComOriginations.privacyNoticeType>{new GenerateDocumentGeComOriginations.privacyNoticeType()},
                                                  new list<GenerateDocumentGeComOriginations.accountClosureType>{new GenerateDocumentGeComOriginations.accountClosureType()},
                                                  new list<GenerateDocumentGeComOriginations.accountLimitReductionType>{new GenerateDocumentGeComOriginations.accountLimitReductionType()},
                                                  new list<GenerateDocumentGeComOriginations.payoutStatementType>{new GenerateDocumentGeComOriginations.payoutStatementType()},
                                                  new list<GenerateDocumentGeComOriginations.interestFreeRebateType>{new GenerateDocumentGeComOriginations.interestFreeRebateType()},
                                                  new list<GenerateDocumentGeComOriginations.disbursementAuthorityType>{new GenerateDocumentGeComOriginations.disbursementAuthorityType()},
                                                  new list<GenerateDocumentGeComOriginations.signUpLetterNZType>{new GenerateDocumentGeComOriginations.signUpLetterNZType()});
       
        WS_WebServiceHelper.generateContract(new Application__c(EMI_with_Service_Fee__c = 1,Loan_Term_Months__c = 1,Offered_Monthly_Loan_Service_Fee__c = 1),new List<Collateral__c>(),new Applicant__c(),new Applicant__c(),new Contact(),new list<Disbursement__c>(),new list<Product_Item__c>(),new list<Fees_Charges__c>(),new GEProduct__c(),new list<Debit__c>());
       
        WS_WebServiceHelper.formatDateToDatetime(Date.Today());
        WS_WebServiceHelper.getApplicantAge('27-11-1988');
        WS_WebServiceHelper.formatData(12);
        WS_WebServiceHelper.formatData(121);
        WS_WebServiceHelper.generateApplicationMetadata(new Application__c(FP_IP_Address__c='akflakjls'));
        WS_WebServiceHelper.generateAppExtractBrokerDetails(new Contact(),new Application__c());
        WS_WebServiceHelper.generateDebtDetailsList(new List<Liability__c>{new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT,Credit_Limit_Amt__c = 1,Card_Overdraft_Bal_Amt__c = 1,Reduced_Credit_Limit__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE,Mortgage_Bal_Amt__c = 1,Mortgage_Borrowed_Amt__c = 1,Mortgage_Repayment_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN ,Car_Personal_Bal_Amt__c = 1,Car_Personal_Borrowed_Amt__c = 1,Car_Personal_Repay_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OTHER ,Other_Borrowed_Amt__c = 1,Other_Repay_Amt__c = 1,Car_Personal_Repay_Amt__c = 1)},applicationBuilder.application,applicationBuilder.applicant1);
        WS_WebServiceHelper.generateAssetDetailsList(new List<Asset__c>   {new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruis', Vehicle_Year__c='22-12-2012'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruisr', Vehicle_Year__c='22-12-2016'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruiser', Vehicle_Year__c='22-12-2015'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruser', Vehicle_Year__c='22-12-2014')});
        WS_WebServiceHelper.generateAppExtractLoanPurposeApplicationSubmitList(new List<Loan_Purpose__c>(),new Application__c());
        WS_WebServiceHelper.generateAppExtractLoanDetails(12,true);
        WS_WebServiceHelper.generateAppExtractIncomeDetails(new List<Income__c>(),new Applicant__c());
        
     //Added By Suneel for Improving Code Coverage
    Application__c testApplicatn = new Application__c();
    insert testApplicatn;
    
    Related_Document__c crd = TestDataBuilder.createRelatedDocument(testApplicant.id,testApplication.id);
    
    //GenerateDocumentGeComOriginations.ApplicationExtract generateApplicationExtract = WS_WebServiceHelper.createApplicationExtract(new IS_ApplicationDTO()); 
    GenerateDocumentGeComOriginations.Contact generateContact = WS_WebServiceHelper.generateAppExtractContact(TestDataBuilder.createApplicant(null, testApplicatn.Id),new List<Expense__c>(), new List<Income__c>(),'AU');
    
             GenerateDocumentGeComOriginations.ContactList  generateContactList = WS_WebServiceHelper.generateContactListForNZSignupLetter(new Application__c(),new Applicant__c(),new Applicant__c());
             GenerateDocumentGeComOriginations.CommunicationDetails generateCommDetails = WS_WebServiceHelper.generateCommunicationDetails('038474838','3121','0483478374','038474838','3121','test@gmail.com');
             GenerateDocumentGeComOriginations.ExpenseDetails generateExpDetails = WS_WebServiceHelper.generateAppExtractExpenseDetails(new List<Expense__c>(),new Applicant__c());
             consumerAnzCapitalGeComOriginations.riskUserDataType generateriskUsrData = WS_WebServiceHelper.generateRiskUserDataType(new Workflow__c(),new Application__c());
             List<consumerAnzCapitalGeComOriginations.reportDetail>     genRepDetail        = WS_WebServiceHelper.generateReportDetail(new Application__c());
             consumerAnzCapitalGeComOriginations.reportDetails   genRepDetails        = WS_WebServiceHelper.generateReportDetails(new Application__c());
             GenerateDocumentGeComOriginations.GEDirectType genGeDirType = WS_WebServiceHelper.generateGEDirect(new Branch__c() ,new Application__c());
             GenerateDocumentGeComOriginations.signUpLetterNZ genSignupletNZ = WS_WebServiceHelper.generatesignUpLetterNZ(new Related_Document__c(),new Is_ApplicationDTO());
             //GenerateDocumentGeComOriginations.InterestFreeRebate genIntFreeDeb = WS_WebServiceHelper.generateInterestFreeRebate(new Related_Document__c(),new Is_ApplicationDTO());
             GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList genIntFreeRebDL = WS_WebServiceHelper.generateInterestFreeRebateDetailsList(new List<Disbursement_Plan__c>());
            //GenerateDocumentGeComOriginations.ObjectiveAndRequirements genObjandReq = WS_WebServiceHelper.createONRDocument(rD, appDTO);
            //GenerateDocumentGeComOriginations.ContractType genConType = WS_WebServiceHelper.generateContractType(appDTO);
            GenerateDocumentGeComOriginations.InterestFreeRebateDetails genDocGeOrg = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c());
           List<GenerateDocumentGeComOriginations.LoanPurpose> genLoanPurpp = WS_WebServiceHelper.generateLoanPurposeList(new List<Loan_Purpose__c>());
          GenerateDocumentGeComOriginations.DisbursementAuthority genDisbAuth = WS_WebServiceHelper.generateDisbursementAuthority(rD, appDTO);
          GenerateDocumentGeComOriginations.GEDirectType genGEDirect =WS_WebServiceHelper.generateGEDirect(applicationBuilder.branch,testApplication);

          
          GenerateDocumentGeComOriginations.ResidentialHistory genResHis = WS_WebServiceHelper.generateResidentialHistory('1','2','4','5','AU');
          GenerateDocumentGeComOriginations.InterestFreeRebateDetails generateInterestIFRD = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c(IF_Credit_Plan_Number__c = 'testdisb',IF_Current_Credit_Plan_Balance__c=100,Rebate_Amount__c=300));
                                                                                                                          
        /**STOP**/
        Test.stopTest();
    }
    }
    
    static testMethod void testWS_AU() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest(); 
        
        // Create Brand
        Brand__c testBrandNZ = TestDataBuilder.createBrand();
        testBrandNZ.Country__c = 'AU';
        insert testBrandNZ;
        
         Application__c testApplication1 = TestDataBuilder.createApplication();
        testApplication1.save_quote_comments__c='Testing';
        applicationBuilder.application.Brand_Lookup__c = testBrandNZ.Id;
        testApplication1.sub_Status__c='3.Followed up – more time requested';
        testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
        insert testApplication1;  
        
        CommonModelServicingGeCom.Note wsNote = WS_WebServiceHelper.generateNote('Test Id', 
                                                                                 'Username', 
                                                                                 'Staff SSO', 
                                                                                 DateTime.Now(),
                                                                                 new String[] {'test'}, 
                                                                                 'noteCategory', 
                                                                                 'NoteTypeCode', 
                                                                                 'NoteTypeName');
        
        System.assertEquals('noteCategory', wsNote.category); //check that mapping is correct
        
        ApplicationModelServicingGeCom.Application wsApplication = WS_WebServiceHelper.generateApplication('Test Id', 
                                                                                                           DateTime.Now(), 
                                                                                                           '1234567890', 
                                                                                                           'caseID');
                                                                                       
        System.assertEquals('1234567890', wsApplication.accountNumber); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.BrokerCommissionDetails wsBrokerCommissionDetails = WS_WebServiceHelper.generateBrokerCommissionDetails('Test Agent', '5000.00');
        
        System.assertEquals('5000.00', wsBrokerCommissionDetails.commissionOf); //check that mapping is correct
        
        GenerateDocumentGeComOriginations.Department wsDepartment = WS_WebServiceHelper.generateDepartment(applicationBuilder.branch);
        System.assertEquals('1234 5678 9012', wsDepartment.telephone); //check that mapping is correct
        
        applicationBuilder.relatedDocument[0].Disbursement__c = applicationBuilder.disList[0].id;
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        appDTO.branch = applicationBuilder.branch;
        appDTO.applicant = applicationBuilder.applicant1;
        appDTO.applicant2 = applicationBuilder.applicant2;
       
        GenerateDocumentGeComOriginations.AccountLimitReduction wsAccountLimitReduction = WS_WebServiceHelper.createAccountLimitReduction(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountLimitReduction.contactCollection.contact.size()); //check that mapping is correct

        GenerateDocumentGeComOriginations.AccountClosure wsAccountAccountClosure = WS_WebServiceHelper.createAccountClosureDocument(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals(1, wsAccountAccountClosure.contactCollection.contact.size()); //check that mapping is correct
        
        // Added as part of NZ CR code
       
        appDTO.app = applicationBuilder.application;

        GenerateDocumentGeComOriginations.PayoutStatement wsAccountPayoutStatement = WS_WebServiceHelper.createPayoutStatement(applicationBuilder.relatedDocument[0], appDTO);
        System.assertEquals('false', wsAccountPayoutStatement.PayoutStatementDetails.isOnline); //check that mapping is correct

        appDTO.insuranceList = applicationBuilder.prodItemList;

        GenerateDocumentGeComOriginations.LoanProtectionInsurance wsLoanProtectionInsurance = WS_WebServiceHelper.generateLoanProtectionInsurance(appDTO);
        System.assertEquals('true', wsLoanProtectionInsurance.isJointCustomers); //check that mapping is correct
        
        //test for generateTimeWithEmployerType()
        ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType wsTimeWithEmployerType = WS_WebServiceHelper.generateTimeWithEmployerType(20, 5);
        System.assertEquals(20, wsTimeWithEmployerType.years); //check that mapping is correct
        
        //test for generateAddress()
        ConsumerAnzCapitalGeComOriginations.Address wsGenerateAddress= WS_WebServiceHelper.generateAddress('TestpropertyName', 'TestunitNumber', 'TesthouseNumber',
                                                                              'TeststreetName', 'TeststreetType',
                                                                              'Testcity', 'Testpostcode',
                                                                              'Teststate', 'Testcountry','Testsuburb','TestServicetype','TestServiceId');
        System.assertEquals('Testcountry', wsGenerateAddress.country); //check that mapping is correct
        
        //test for generateTimeAtAddressType()
        ConsumerAnzCapitalGeComOriginations.TimeAtAddressType wsGenerateTimeAtAddressType = WS_WebServiceHelper.generateTimeAtAddressType(20, 5);
        System.assertEquals(20, wsGenerateTimeAtAddressType.years); //check that mapping is correct
        
        //test for generatePersonalDetailsType(Applicant__c applicant)
        ConsumerAnzCapitalGeComOriginations.PersonalDetailsType wsGeneratePersonalDetailsType
            = WS_WebServiceHelper.generatePersonalDetailsType(applicationBuilder.applicant1);
        System.assertEquals('Ruffles', wsGeneratePersonalDetailsType.lastName); //check that mapping is correct    
        
        //test for generatePOIIncomeDetails(List<Income__c> incomeList)
        List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails> wsGeneratePOIIncomeDetails
            = WS_WebServiceHelper.generatePOIIncomeDetails(applicationBuilder.incomeList);
        System.assertEquals(2000.00, wsGeneratePOIIncomeDetails[0].incomeAmount); //check that mapping is correct

        //test for generatePOIIncomeDetails(List<Asset__c> assetList)
        List<ConsumerAnzCapitalGeComOriginations.AssetDetails> wsGenerateAssetDetails
            = WS_WebServiceHelper.generateAssetDetails(applicationBuilder.assetList);
        System.assertEquals(50000.00, wsGenerateAssetDetails[0].assetValue); //check that mapping is correct   
        
        
        //test for generateExpenseDetails(List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.ExpenseDetails wsGenerateExpenseDetails
            = WS_WebServiceHelper.generateExpenseDetails(applicationBuilder.expenseList,applicationBuilder.applicant1);
        System.assertEquals(300.00, wsGenerateExpenseDetails.livingExpenseAmount); //check that mapping is correct

        //test for generateExpenseDetails(List<Expense__c> expenseList)
         List<ConsumerAnzCapitalGeComOriginations.DebtDetails> wsGenerateDebtDetails
            = WS_WebServiceHelper.generateDebtDetails(applicationBuilder.debtList,applicationBuilder.application);
       // System.assertEquals('Bank3', wsGenerateDebtDetails[0].financierName); //check that mapping is correct
        
        //test for generateBudgetDetailsType(Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList)
        ConsumerAnzCapitalGeComOriginations.BudgetDetailsType wsGenerateBudgetDetailsType
            = WS_WebServiceHelper.generateBudgetDetailsType(applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.disList);
        System.assertEquals(5000, wsGenerateBudgetDetailsType.totalIncome); //check that mapping is correct
        System.assertEquals('SMART', wsGenerateBudgetDetailsType.employerName); //check that mapping is correct
        
        //test for generateApplicantType(String sfApplicantId,Applicant__c applicant,List<Income__c> incomeList,List<Expense__c> expenseList,List<Applicant_CLV__c> applicantCLVList) 
        ConsumerAnzCapitalGeComOriginations.ApplicantType wsGenerateApplicantType
            = WS_WebServiceHelper.generateApplicantType('TestsfApplicantId', applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList,applicationBuilder.disList, appDTO.app);
        System.assertEquals('TestsfApplicantId', wsGenerateApplicantType.sfApplicantId); //check that mapping is correct
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> listApplicantType = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        listApplicantType.add(wsGenerateApplicantType);
     
         ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection wsGenerateCLVDetailsCollection
            = WS_WebServiceHelper.generateCLVDetailsCollection(applicationBuilder.appCLVList);
         ConsumerAnzCapitalGeComOriginations.clvDetailsType clvdetone =  new ConsumerAnzCapitalGeComOriginations.clvDetailsType();           
       
               
        Brand__c testBrandAU = TestDataBuilder.createBrand();
        testBrandAU.Country__c = 'AU';
        insert testBrandAU;
       
        GEProduct__c testProductAU = TestDataBuilder.createGEProduct(testBrandAU.Id,'Personal Loan','Life Insurance');
        insert testProductAU;
        
        
        Product_Version__c testProductVersionAU = TestDataBuilder.createProductVersion(testProductAU.Id);
        insert testProductVersionAU;
       
        
        Application__c testApplicationAU = TestDataBuilder.createApplication();
        testApplicationAU.Brand_Lookup__c = testBrandAU.Id;
        testApplicationAU.Response_Code__c = 'Test';
        testApplicationAU.Brand_String__c = testBrandAU.Name;
        testApplicationAU.Product_SubType__c = 'Standard PL';
        testApplicationAU.Offered_Interest_Rate_Orig__c = 13.99;
        testApplicationAU.Loan_Term_Months__c = 24;
        testApplicationAU.Product_SubType__c = 'Standard PL';
        testApplicationAU.Offered_Interest_Rate__c = 13.99;
        testApplicationAU.Brand_Lookup__c = testBrandAU.Id;
        testApplicationAU.sub_Status__c='1. Not Interested';
        testApplicationAU.Channel__c='Sales';
        insert testApplicationAU;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplicationAU.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplicationAU.Id);
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '0212345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '0212345678';
            testApplicant.Country_Pos__c = 'Australia';
            testApplicant.Country_Res__c = 'Australia';
            testApplicant.Country_Pre__c = 'Australia';
            testApplicant.State_Res__c = 'PARRAMATTA';
            testApplicant.State_Pos__c = 'PARRAMATTA';
            testApplicant.State_Pre__c = 'PARRAMATTA';
            testApplicant.EIDV__c = 'No';
           insert testApplicant;
           
                         
        Liability__c lbty = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
          insert lbty;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplicationAU.Id);        
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplicationAU.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Fees_Charges__c fee=TestDataBuilder.createFeesAndcharges(testProductVersionAU.id);
        RecordType debitrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Debit__c' limit 1];
      
        Debit__c debitAU= TestDataBuilder.createDebit(debitrecordType.id,testApplicationAU.Id);
       
        if(debitAU.Application__r.Product_Subtype__c != null){
        debitAU.Application__r.Product_Subtype__c = 'Better Start PL';
        }
/*        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
*/
       ConsumerAnzCapitalGeComOriginations.repaymentDetails repaymentDetails = new ConsumerAnzCapitalGeComOriginations.repaymentDetails();    
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
        Integer i;
        if(debitAU==null){
          
           ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsTypeAU = WS_WebServiceHelper.generateLoanDetailsType(testApplicationAU, new list<Loan_Purpose__c>{testLoanPurpose}, testProductAU, 'test', new List<Debit__c>{debitAU}, new List<Fees_Charges__c>{fee});
        }
       else if (debitAU!=null){
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
           ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsTypeAU = WS_WebServiceHelper.generateLoanDetailsType(testApplicationAU, new list<Loan_Purpose__c>{testLoanPurpose}, testProductAU, 'test', new List<Debit__c>{debitAU}, new List<Fees_Charges__c>{fee});         

      
         ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetailsAU = WS_WebServiceHelper.generateFeeDetails(new List<Fees_Charges__c>{fee}, testApplicationAU);
        
        ConsumerAnzCapitalGeComOriginations.RepaymentDetailsArray generateRepaymentDetails = WS_WebServiceHelper.generateRepaymentDetails(new List<Debit__c>{debitAU});

        consumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType gtpd = WS_WebServiceHelper.generateThirdPartyDetails(new Application__c(X3rd_Party_Application_Number__c='123456789',X3rd_Party_Quoted_Rate__c=10,X3rd_Party_Quoted_Risk_Grade__c='B'));
        
        
        GenerateDocumentGeComOriginations.repaymentPeriods rpAU = WS_WebServiceHelper.generateDocumentRepaymentPeriodDetails(new List<Debit__c>{debitAU},testApplicationAU);
        
        
        WS_WebServiceHelper.generateLoanPurposeDetails(new list<Loan_Purpose__c>{testLoanPurpose});
        
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType generateFingerPrintDetailsTypeAU=WS_WebServiceHelper.generateFingerPrintDetailsType(testApplicationAU);
        
        WS_WebServiceHelper.formatData(system.today());
        
        WS_WebServiceHelper.formatData(system.now());
        
        WS_WebServiceHelper.formatStringToDate('2014-12-05');
        
        Product_Item__c pItemAU=TestDataBuilder.createInsuranceProductItem(testApplicationAU.Id, testProductVersionAU.id, 'test', string.valueof(testApplicant.id), string.valueof(testApplicant2.id));
        GenerateDocumentGeComOriginations.InsuranceDetailsList generateInsuranceDetailsList=WS_WebServiceHelper.generateInsuranceDetailsList(new List<Product_Item__c>{pItemAU});
       
        Personal_Reference_Check__c pRcAU=TestDataBuilder.createPersonalReferenceCheck(testApplicationAU.id);
        
        GenerateDocumentGeComOriginations.PersonalReferencesList generatePersonalReferencesList= WS_WebServiceHelper.generatePersonalReferencesList(new List<Personal_Reference_Check__c>{pRcAU});
        
         Related_Document__c rDAU= TestDataBuilder.createRelatedDocument(testApplicant.id,testApplicationAU.id);
        
        GenerateDocumentGeComOriginations.DisbursementAuthorityInformation generateDisbursementAuthorityInformationAU=WS_WebServiceHelper.generateDisbursementAuthorityInformation(testApplicationAU,testApplicant, rDAU);
                
        GenerateDocumentGeComOriginations.RepaymentDetails generateDocumentRepaymentDetails = WS_WebServiceHelper.generateDocumentRepaymentDetails(debitAU);
        GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails = WS_WebServiceHelper.generateBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','branch','bsb','123456','902','0000', 'AU');
        GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails = WS_WebServiceHelper.generateBPayBankAccountDetails('firstname','middleName','LatName','accHolder', 'bankName','testBranch','testbsb','123456','902','0000', 'AU','004','Test','102901','222222',5000);
       
         GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformationAU=WS_WebServiceHelper.generateDirectDebitInformation(testApplicationAU,testApplicant,  debitAU);       
        GenerateDocumentGeComOriginations.LoanPurposeCollection generateLoanPurposeCollection=WS_WebServiceHelper.generateLoanPurposeCollection(new list<Loan_Purpose__c>{testLoanPurpose}); 
        

        system.debug('======<< ' + [select Response_code__c,Brand_String__c,Brand_Country__c,sub_Status__c,Application_Stage__c,
                                    quote_Status__c,pbuid__c,Bank_Accounts_Code__c,uid__c,Business_Source_Code__c,Application_Source_code__c,
                                    Mirror_Code__c,Initial_Requested_Amount__c
                                     from Application__c Where Id = :testApplicationAU.Id]);
      Application__c AppAUCR = [select Id,Channel__c,Response_code__c,Brand_String__c,Brand_Country__c,sub_Status__c,Application_Stage__c,quote_Status__c,AU_Submit_Flag__c
                                ,pbuid__c,Bank_Accounts_Code__c,uid__c,Business_Source_Code__c,Application_Source_code__c,
                                 Mirror_Code__c,Initial_Requested_Amount__c,Offered_PPSR_Registration_Fee__c,Offered_PPSR_Search_Fee__c
                                 ,Promotional_Campaign_Code__c,ICBS_Account_Number__c,Credit_Score__c,Previous_App_No__c,Initial_Submit_Date__c,
                                 Promo_Loan_Offer_Amount__c,Promo_ID__c,X3rd_Party_Application_Number__c,X3rd_Party_Quoted_Rate__c,
                                 X3rd_Party_Quoted_Risk_Grade__c,Offered_Interest_Rate__c,EMI_with_Service_Fee__c,Total_Loan_Amount_with_Insurance__c,
                                 Offered_Frequency_Repayments__c,Loan_Term_Months__c,Product_SubType__c,Acceptance_Channel__c,
                                 Product_SubType_Code__c                                 
                                 from                                  
                                 Application__c 
                                 Where 
                                 Id = :testApplicationAU.Id];
        Response_Code_Control__c code = TestDataBuilder.createResponseCodeControlPA();
        code.Name = 'Test';
        insert code;
        Response_Code_Control__c code1 = TestDataBuilder.createResponseCodeControlPA();
        code1.Name = 'SAR';
        insert code1;
        Collateral_Settings__c colSet = new Collateral_Settings__c();
        colSet.Name = 'GE';
        colSet.Collateral_Maximum_Items__c = 1;
        colSet.Collateral_Maximum_Value__c = 1000000; 
        colSet.Collateral_Minimum_Value__c = 2000;
        colSet.Collateral_New_Age__c = 1000;
        insert colSet;
        RecordType collateralRT = [SELECT ID FROM RecordType WHERE sObjectType='Collateral__c' and DeveloperName = 'Jetski_NZ'];
        Collateral__c col=TestDataBuilder.createCollateral(testApplicationAU.id, collateralRT.Id);
        insert col;
         
        GenerateDocumentGeComOriginations.OnRInformation generateOnRInformation=WS_WebServiceHelper.generateOnRInformation(rDAU,  AppAUCR, new List<Collateral__c>{col}, testApplicant,
                                                                                          testApplicant2,
                                                                                          new List<Product_Item__c>{pItemAU},
                                                                                          new list<Loan_Purpose__c>{testLoanPurpose},
                                                                                          'isOnline',
                                                                                          testProductAU);
                                                                                       
                 
        GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformationListAU=WS_WebServiceHelper.generateDirectDebitInformation(AppAUCR,testApplicant, debitAU);
        /**Added Tony Xu for improving code coverage START**/
        ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext('test','test');
        ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext('test','test','test','test',businessContext);
        ConsumerAnzCapitalGeComOriginations.Exception_x exceptionX = WS_WebServiceHelper.generateExceptionX('text','text',Datetime.now(),'test','test','test');
//        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsType = WS_WebServiceHelper.generateProductDetailsType(applicationBuilder.product, TRUE, 0, 'Submitted');
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType ProductDetailsTypeAU = WS_WebServiceHelper.generateProductDetailsType(AppAUCR,applicationBuilder.product, TRUE, 0, 'Submitted',new Better_Start_Offer__c());
        ConsumerAnzCapitalGeComOriginations.BranchDetailsType branchDetailsType = WS_WebServiceHelper.generateBranchDetailsType(applicationBuilder.Branch, null, 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        CommonModelServicingGeCom.Variable variable = WS_WebServiceHelper.generateVariable('test','test','test','test','test',true);
        productModelServicingGeCom.Product product = WS_WebServiceHelper.generateProduct(applicationBuilder.product);
        ContractModelServicingGeCom.Contract contract = WS_WebServiceHelper.generateContract('test');
        SalesModelServicingGeCom.SalesDialogInput salesDialogInput = WS_WebServiceHelper.generateSalesDialogInput('test','test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationDataType appDataType = WS_WebServiceHelper.generateApplicationDataType('test','test','test','test');
        ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType appCupOverrideDataType = WS_WebServiceHelper.generateApplicationCpuOverrideDataType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.BrokerDetailsType brokerDetailsType = WS_WebServiceHelper.generateBrokerDetailsType(applicationBuilder.broker,applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetailsType = WS_WebSErviceHelper.generateOfferDetailsType(applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.DisbursementCollection disCollection = WS_WebserviceHelper.generateDisbursementCollection(applicationBuilder.disList);
        ConsumerAnzCapitalGeComOriginations.InsuranceCollection insuranceCollection = WS_WebServiceHelper.generateInsuranceCollection(applicationBuilder.prodItemList);      
        ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection poiAppCollection = WS_WebServiceHelper.generatePOIApplicantsCollection(applicationBuilder.applicant1,applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.incomeList);
        ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection refAccCollection = WS_WebServiceHelper.generateRefinance(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DisbursementDetails disbursementDetails = WS_WebserviceHelper.generateDisbursementDetails(applicationBuilder.disList[0]);
        GenerateDocumentGeComOriginations.DisbursementDetailsCollection disDetailsCollection = WS_WebServiceHelper.generateDisbursementDetailsCollection(applicationBuilder.disList);
        GenerateDocumentGeComOriginations.DocumentCommonAttrType docCommonAttrType = WS_WebServiceHelper.generateDocumentCommonAttrType(applicationBuilder.relatedDocument[0]);      
        
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType1 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant1.id),applicationBuilder.applicant1, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        ConsumerAnzCapitalGeComOriginations.ApplicantType ApplicantType2 = WS_WebServiceHelper.generateApplicantType(string.valueOf(applicationBuilder.applicant2.id),applicationBuilder.applicant2, applicationBuilder.incomeList, applicationBuilder.expenseList, applicationBuilder.appCLVList, applicationBuilder.disList, applicationBuilder.application);
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new  List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        applicantTypeList.add(ApplicantType1);
        applicantTypeList.add(ApplicantType2);
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection ApplicantCollection =  WS_WebServiceHelper.generateApplicantCollection(applicantTypeList);
        
       // ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType appCustomerDataTypeAU = WS_WebServiceHelper.generateApplicationCustomerDataType(AppAUCR, ApplicantCollection, ProductDetailsTypeAU, generateLoanDetailsTypeAU, applicationBuilder.assetList,
       //                                                                                                                 applicationBuilder.debtList, null,null,applicationBuilder.applicant1, applicationBuilder.applicant2, new List<Collateral__c>{col}, new List<Personal_Reference_Check__c>{pRcAU});
                                                                                                                        
         GenerateDocumentGeComOriginations.DirectDebitRequest dirDebRequest  = WS_WebServiceHelper.generateDirectDebitRequest(appDTO);                                                                   
        GenerateDocumentGeComOriginations.PrivacyNotice privacyNotice = WS_WebServiceHelper.generatePrivacyNotice(appDTO);
        
        WS_WebServiceHelper.generatePayoffQuoteBusinessContext('test','test');
        WS_WebServiceHelper.generatePayoffQuoteConsumerContext('test','test','test','test',NULL);
        WS_WebServiceHelper.generatePayoffQuoteExceptionX('test','test',datetime.now(),'test','test','test');
        WS_WebServiceHelper.generateExceptionCollection(new list<ConsumerAnzCapitalGeComOriginations.Exception_x>());
        WS_WebServiceHelper.generatePayoffQuoteExceptionCollection(new list<PayoffQuoteAnzCapitalGeCom.Exception_x>());
        WS_WebServiceHelper.generateServiceContext(new ConsumerAnzCapitalGeComOriginations.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateServiceContext(new PayoffQuoteAnzCapitalGeCom.ConsumerContext(),NULL);
        WS_WebServiceHelper.generateRiskReferralDetailsType(true,date.today());
        WS_WebServiceHelper.generateApplicationSupportingDataType(new ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType(),'test',new CaseModelServicingGeCom20.Case_x(),new Branch__c(),new User(), 'broker'); // Afreen- May-09-2016 - updated to match the new method signature
        WS_WebServiceHelper.generateCasex(NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateUserx(NULL, null);
        WS_WebServiceHelper.generateProductArrangement(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialog(NULL,NULL,NULL);
        WS_WebServiceHelper.generateSalesDialogInput(new ONR__c(),NULL,NULL,NULL);
        WS_WebServiceHelper.generateDecisionDataType(new Application__c());
        WS_WebServiceHelper.generateAMLApplicantsCollection(NULL,NULL);
        WS_WebServiceHelper.generateAmlApplicantType(new list<AML__c>());
        WS_WebServiceHelper.generatepoaDetail(new AML__c());
        WS_WebServiceHelper.generateIdDetail(new AML__c());
        WS_WebServiceHelper.generateDocumentMetadataType(new Map<String,String>());
       WS_WebServiceHelper.generateDocumentsType(new list<GenerateDocumentGeComOriginations.ContractDocType>{new GenerateDocumentGeComOriginations.ContractDocType()},
                                                  new list<GenerateDocumentGeComOriginations.oAndRType>{new GenerateDocumentGeComOriginations.oAndRType()},
                                                  new list<GenerateDocumentGeComOriginations.lpiType>{new GenerateDocumentGeComOriginations.lpiType()},
                                                  new list<GenerateDocumentGeComOriginations.directDebitType>{new GenerateDocumentGeComOriginations.directDebitType()},
                                                  new list<GenerateDocumentGeComOriginations.privacyNoticeType>{new GenerateDocumentGeComOriginations.privacyNoticeType()},
                                                  new list<GenerateDocumentGeComOriginations.accountClosureType>{new GenerateDocumentGeComOriginations.accountClosureType()},
                                                  new list<GenerateDocumentGeComOriginations.accountLimitReductionType>{new GenerateDocumentGeComOriginations.accountLimitReductionType()},
                                                  new list<GenerateDocumentGeComOriginations.payoutStatementType>{new GenerateDocumentGeComOriginations.payoutStatementType()},
                                                  new list<GenerateDocumentGeComOriginations.interestFreeRebateType>{new GenerateDocumentGeComOriginations.interestFreeRebateType()},
                                                  new list<GenerateDocumentGeComOriginations.disbursementAuthorityType>{new GenerateDocumentGeComOriginations.disbursementAuthorityType()},
                                                  new list<GenerateDocumentGeComOriginations.signUpLetterNZType>{new GenerateDocumentGeComOriginations.signUpLetterNZType()});
        WS_WebServiceHelper.generateContract(new Application__c(EMI_with_Service_Fee__c = 1,Loan_Term_Months__c = 1,Offered_Monthly_Loan_Service_Fee__c = 1),new List<Collateral__c>(),new Applicant__c(),new Applicant__c(),new Contact(),new list<Disbursement__c>(),new list<Product_Item__c>(),new list<Fees_Charges__c>(),new GEProduct__c(),new list<Debit__c>());
       
        WS_WebServiceHelper.formatDateToDatetime(Date.Today());
        WS_WebServiceHelper.getApplicantAge('27-11-1988');
        WS_WebServiceHelper.formatData(12);
        WS_WebServiceHelper.formatData(121);
        WS_WebServiceHelper.generateApplicationMetadata(new Application__c());
        WS_WebServiceHelper.generateAppExtractBrokerDetails(new Contact(),new Application__c());
        WS_WebServiceHelper.generateDebtDetailsList(new List<Liability__c>{new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT,Credit_Limit_Amt__c = 1,Card_Overdraft_Bal_Amt__c = 1,Reduced_Credit_Limit__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE,Mortgage_Bal_Amt__c = 1,Mortgage_Borrowed_Amt__c = 1,Mortgage_Repayment_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN ,Car_Personal_Bal_Amt__c = 1,Car_Personal_Borrowed_Amt__c = 1,Car_Personal_Repay_Amt__c = 1),
                                                                           new Liability__c(Type_of_Credit_Card__c='ssdf',Debt_Category__c= GEN_OriginationsConstants.DEBT_CATEGORY_OTHER ,Other_Borrowed_Amt__c = 1,Other_Repay_Amt__c = 1,Car_Personal_Repay_Amt__c = 1)},applicationBuilder.application,applicationBuilder.applicant1);
        WS_WebServiceHelper.generateAssetDetailsList(new List<Asset__c>   {new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruis', Vehicle_Year__c='22-12-2012'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruisr', Vehicle_Year__c='22-12-2016'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruiser', Vehicle_Year__c='22-12-2015'),
                                                                           new Asset__c(asset_Value__c=5000,Ownership_Status__c='Own outright', Vehicle_Make__c='honda', Vehicle_Model__c='Land Cruser', Vehicle_Year__c='22-12-2014')});
        WS_WebServiceHelper.generateAppExtractLoanPurposeApplicationSubmitList(new List<Loan_Purpose__c>(),new Application__c());
        WS_WebServiceHelper.generateAppExtractLoanDetails(12,true);
        WS_WebServiceHelper.generateAppExtractIncomeDetails(new List<Income__c>(),new Applicant__c());
        
     //Added By Suneel for Improving Code Coverage
    Application__c testApplicatn = new Application__c();
    insert testApplicatn;
    
    //GenerateDocumentGeComOriginations.ApplicationExtract generateApplicationExtract = WS_WebServiceHelper.createApplicationExtract(new IS_ApplicationDTO()); 
    GenerateDocumentGeComOriginations.Contact generateContact = WS_WebServiceHelper.generateAppExtractContact(TestDataBuilder.createApplicant(null, testApplicatn.Id),new List<Expense__c>(), new List<Income__c>(),'AU');
    
             GenerateDocumentGeComOriginations.ContactList  generateContactList = WS_WebServiceHelper.generateContactListForNZSignupLetter(new Application__c(),new Applicant__c(),new Applicant__c());
             GenerateDocumentGeComOriginations.CommunicationDetails generateCommDetails = WS_WebServiceHelper.generateCommunicationDetails('038474838','3121','0483478374','038474838','3121','test@gmail.com');
             GenerateDocumentGeComOriginations.ExpenseDetails generateExpDetails = WS_WebServiceHelper.generateAppExtractExpenseDetails(new List<Expense__c>(),new Applicant__c());
             consumerAnzCapitalGeComOriginations.riskUserDataType generateriskUsrData = WS_WebServiceHelper.generateRiskUserDataType(new Workflow__c(Risk_CPU_Decision__c='Approve'),new Application__c());
             List<consumerAnzCapitalGeComOriginations.reportDetail>     genRepDetail        = WS_WebServiceHelper.generateReportDetail(new Application__c());
             consumerAnzCapitalGeComOriginations.reportDetails   genRepDetails        = WS_WebServiceHelper.generateReportDetails(new Application__c());
             GenerateDocumentGeComOriginations.GEDirectType genGeDirType = WS_WebServiceHelper.generateGEDirect(new Branch__c() ,new Application__c());
             GenerateDocumentGeComOriginations.signUpLetterNZ genSignupletNZ = WS_WebServiceHelper.generatesignUpLetterNZ(new Related_Document__c(),new Is_ApplicationDTO());
           
             GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList genIntFreeRebDL = WS_WebServiceHelper.generateInterestFreeRebateDetailsList(new List<Disbursement_Plan__c>());
            
            GenerateDocumentGeComOriginations.InterestFreeRebateDetails genDocGeOrg = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c());
           List<GenerateDocumentGeComOriginations.LoanPurpose> genLoanPurpp = WS_WebServiceHelper.generateLoanPurposeList(new List<Loan_Purpose__c>());
          GenerateDocumentGeComOriginations.DisbursementAuthority genDisbAuth = WS_WebServiceHelper.generateDisbursementAuthority(rDAU, appDTO);
          GenerateDocumentGeComOriginations.GEDirectType genGEDirect =WS_WebServiceHelper.generateGEDirect(applicationBuilder.branch,testApplicationAU);

          
          GenerateDocumentGeComOriginations.ResidentialHistory genResHis = WS_WebServiceHelper.generateResidentialHistory('1','2','4','5','AU');
          GenerateDocumentGeComOriginations.InterestFreeRebateDetails generateInterestIFRD = WS_WebServiceHelper.generateInterestFreeRebateDetails(new Disbursement_Plan__c(IF_Credit_Plan_Number__c = 'testdisb',IF_Current_Credit_Plan_Balance__c=100,Rebate_Amount__c=300));
                                                                                                                          
        /**STOP**/
        Test.stopTest();
    }
    }

 static testMethod void testCodeCoverageImprove(){
  Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        Brand__c testBrandNZ = TestDataBuilder.createBrandNZ();
        insert testBrandNZ;
        
        System.assertEquals(testBrand.Id!=NULL ,true);
        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        insert testApplication;    
          
         System.assertEquals(testApplication.Id!=NULL ,true);  
          
          
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Insurance_Acknowledgement__c = true;
        testApplication2.Contract_Account_Number__c = '123123123123';
        testApplication2.Brand_Lookup__c = testBrand.id;
        insert testApplication2;        
        
         System.assertEquals(testApplication2.Id!=NULL ,true); 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
 
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
       
        System.assertEquals(testApplicant.Id!=NULL ,true); 
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        insert testApplicant2;
        
        Applicant__c testApplicant3 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant3.Is_Primary_Applicant__c = true;
        testApplicant3.Country_Res__c = 'New Zealand';
        insert testApplicant3;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        RecordType debitrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Debit__c' limit 1];
        Debit__c debit= TestDataBuilder.createDebit(debitrecordType.id,testApplication.Id);        
        
        List<Liability__c> lbList = new List<Liability__c>();
        Liability__c lb1 = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        Liability__c lb2 = TestDataBuilder.createCardLiability(testApplicant.Id);
        Liability__c lb3 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        Liability__c lb4 = TestDataBuilder.createLiabilityMortgage(testApplicant2.Id);
        Liability__c lb5 = TestDataBuilder.createOtherLiability(testApplicant.Id);
        Liability__c lb6 = TestDataBuilder.createOtherLiability(testApplicant2.Id);
        lbList.add(lb1);
        lbList.add(lb2);
        lbList.add(lb3);
        lbList.add(lb4);
        lbList.add(lb5);
        lbList.add(lb6);
        insert lbList;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        GEProduct__c testProductNZ = TestDataBuilder.createGEProduct(testBrandNZ.Id);
        insert testProductNZ;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        List<Loan_Purpose__c> lpList = new List<Loan_Purpose__c>();
        Loan_Purpose__c testLoanPurpose1 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);       
        lpList.add(testLoanPurpose1);
        lpList.add(testLoanPurpose2);
        insert lpList;
        
        List<Expense__c> expList = new List<Expense__c>();
          Expense__c expOne = TestDatabuilder.createExpense(testApplicant.Id);
            expOne.Rent_Board_Pay_Amt__c = 1000;
            expOne.Food_Groc_Entert__c = 1000;
            expOne.Food_Groc_Interval__c = 'Week';
            expOne.Insurance_Expense__c = 1000;
            expOne.Insurance_Expense_Interval__c = 'Week';
            expOne.Utilities_Expense__c = 1000;
            expOne.Utilities_Expense_Interval__c = 'Week';
            expOne.Transport_Expense__c = 1000;
            expOne.Transport_Expense_Interval__c = 'Week';
            expOne.Education_and_child_Expense__c = 1000;
            expOne.Education_and_child_Expense_Interval__c = 'Week';
            expOne.Personal_Other_Expense__c = 1000;
            expOne.Personal_Other_Expense_Interval__c = 'Week';
            expList.add(expOne);
          insert expList;
          
        List<Expense__c> expListNZ = new List<Expense__c>();
          Expense__c expOneNZ = TestDatabuilder.createExpense(testApplicant3.Id);
            expOneNZ.Rent_Board_Pay_Amt__c = 1000;
            expOneNZ.Secondary_Mortgage_Rent__c = 1000;
            expOneNZ.Property_rates__c = 1000;
            expOneNZ.Other_Property_Expenses__c = 1000;
            expOneNZ.Food_Groc_Entert__c = 1000;
            expOneNZ.Food_Groc_Interval__c = 'Week';
            expOneNZ.Insurance_Expense__c = 1000;
            expOneNZ.Insurance_Expense_Interval__c = 'Week';
            expOneNZ.Utilities_Expense__c = 1000;
            expOneNZ.Utilities_Expense_Interval__c = 'Week';
            expOneNZ.Transport_Expense__c = 1000;
            expOneNZ.Transport_Expense_Interval__c = 'Week';
            expOneNZ.Education_and_child_Expense__c = 1000;
            expOneNZ.Education_and_child_Expense_Interval__c = 'Week';
            expOneNZ.Personal_Other_Expense__c = 1000;
            expOneNZ.Personal_Other_Expense_Interval__c = 'Week';
            expOneNZ.Any_Additional_expenses__c = 1000;
            expListNZ.add(expOneNZ);
          insert expListNZ;

        List<Expense__c> expListNZOne = new List<Expense__c>();
          Expense__c expOneNZ1 = TestDatabuilder.createExpense(testApplicant3.Id);
            expOneNZ.Rent_Board_Pay_Amt__c = null;
            expOneNZ.Secondary_Mortgage_Rent__c = null;
            expOneNZ.Property_rates__c = null;
            expOneNZ.Other_Property_Expenses__c = null;
            expOneNZ1.Food_Groc_Entert__c = null;
            expOneNZ1.Food_Groc_Interval__c = 'Week';
            expOneNZ1.Insurance_Expense__c = null;
            expOneNZ1.Insurance_Expense_Interval__c = 'Week';
            expOneNZ1.Utilities_Expense__c = null;
            expOneNZ1.Utilities_Expense_Interval__c = 'Week';
            expOneNZ1.Transport_Expense__c = null;
            expOneNZ1.Transport_Expense_Interval__c = 'Week';
            expOneNZ1.Education_and_child_Expense__c = null;
            expOneNZ1.Education_and_child_Expense_Interval__c = 'Week';
            expOneNZ1.Personal_Other_Expense__c = null;
            expOneNZ1.Personal_Other_Expense_Interval__c = 'Week';
            expOneNZ1.Any_Additional_expenses__c = null;
            expListNZOne.add(expOneNZ1);
          insert expListNZOne;
          
        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        
        List<Fees_Charges__c> fcList = new List<Fees_Charges__c>();
        Fees_Charges__c fc1 = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        Fees_Charges__c fc2 = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        fcList.add(fc1);
        fcList.add(fc2);
        insert fcList;
       
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;
        try{
        insert appResponse;
        }catch(DMLException e){}

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);
            WS_WebServiceHelper.generateLoanDetailsType(testApplication,lpList,testProduct,'test',new List<Debit__c>{debit},fcList);
            WS_WebServiceHelper.generateRepaymentDetails(new List<Debit__c>{debit});
            WS_WebServiceHelper.generateDebtDetails(lbList,testApplication);
            WS_WebServiceHelper.generateProductDetailsType(testApplication,testProductNZ,true,3,'VIC',new Better_Start_Offer__c());
            WS_WebServiceHelper.generateProductDetailsType(testApplication,testProductNZ,false,3,'VIC',new Better_Start_Offer__c());
            WS_WebServiceHelper.generateExpensesDetails(expList,testApplicant);
            WS_WebServiceHelper.generateExpensesDetails(expListNZ,testApplicant3);
            WS_WebServiceHelper.generateExpensesDetails(expListNZOne,testApplicant3);
            WS_WebServiceHelper.generatePropExpenses(expList,testApplicant);
            WS_WebServiceHelper.generatePropExpenses(expListNZ,testApplicant3);
            WS_WebServiceHelper.generatePropExpenses(expListNZOne,testApplicant3);
        Test.StopTest();
 
 }

}