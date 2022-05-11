/* @Description: Test class for APP_Personal_Reference_Ext Class
 * @Author: Adrian Recio
 * @Date Created: 7-04-2015
 * @History:
   =====================================================================
       7-04-2015: Created - Adrian
                            Note: I didn't created the original class
                                  that's why I'm not familiar with the business process invloved.
                                  My only goal is to only create some proper test coverage for this class.
                                  Assertion might be clunky.
   =====================================================================
 */ 
@IsTest
public with sharing class APP_Personal_Reference_Ext_Test {
    public static testMethod void testProcess(){
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'AU';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        State_Setting__c states = new State_Setting__c();
        states.Name = 'VIC';
        states.Value__c = 'VIC';
        insert states;

        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        
        List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;



        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = testDataBuilder.createBrand();
        insert testBrand;

        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.id;      
        insert appVar;
        
    
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        

        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            App_Personal_Reference_Ext appPerRefExtCC = new App_Personal_Reference_Ext(standardCon);
            appPerRefExtCC.getStreetTypeOptionsInt();
            appPerRefExtCC.getCountryOptsInt();
            List<SelectOption> actualValues = appPerRefExtCC.stateOptions;
            List<SelectOption> relOptions = appPerRefExtCC.relationshipOptions;
            Personal_Reference_Check__c perRef = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef.Street_Number__c = '380';
            perRef.Street_Name__c = 'Little Lonsdale';
            perRef.Suburb__c = 'Melbourne';
            perRef.State__c = 'VIC';
            perRef.Postcode__c = '3000';
            perRef.Town_City__c = 'Melbourne';
            perRef.Street_Type__c = 'Alley';
            perRef.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef;
            appPerRefExtCC.save();
        test.stopTest();
    }

    public static testMethod void testProcess2(){
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'NZ';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        Profile_Country__c pc = new Profile_Country__c();
        pc.NZ__c = true;
        insert pc;

        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        Brand__c testBrand = testDataBuilder.createBrandNZ();
        insert testBrand;

        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplicationNZ(testBrand);
        insert appVar;
        

        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        

        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            App_Personal_Reference_Ext appPerRefExtCC = new App_Personal_Reference_Ext(standardCon);
            //appPerRefExtCC.getStreetTypeOptionsInt();
            appPerRefExtCC.getCountryOptsInt();
            List<SelectOption> actualValues = appPerRefExtCC.stateOptions;
            List<SelectOption> relOptions = appPerRefExtCC.relationshipOptions;
            Personal_Reference_Check__c perRef = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef.Street_Number__c = '52';
            perRef.Street_Name__c = 'test';
            perRef.Suburb__c = 'test';
            perRef.State__c = 'test';
            perRef.Postcode__c = '1206';
            perRef.Town_City__c = 'Auckland';
            perRef.Street_Type__c = 'Alley';
            perRef.Country__c = 'NZ';
            appPerRefExtCC.personalReference = perRef;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef2 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef2.Street_Number__c = '380';
            perRef2.Street_Name__c = 'Little Lonsdale';
            perRef2.Suburb__c = 'Melbourne';
            perRef2.State__c = 'VIC';
            perRef2.Postcode__c = '3000';
            perRef2.Town_City__c = 'Melbourne';
            perRef2.Street_Type__c = 'Alley';
            perRef2.Country__c = 'AU';
            perRef2.Phone_Number__c = '02123456';
            appPerRefExtCC.personalReference = perRef2;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef3 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef3.Street_Number__c = '380';
            perRef3.Street_Name__c = 'Little Lonsdale';
            perRef3.Suburb__c = 'Melbourne';
            perRef3.State__c = 'VIC';
            perRef3.Postcode__c = '3000';
            perRef3.Town_City__c = 'Melbourne';
            perRef3.Street_Type__c = 'Alley';
            perRef3.Country__c = 'AU';
            perRef3.Phone_Number__c = '04123456';
            appPerRefExtCC.personalReference = perRef3;
            appPerRefExtCC.save();
        test.stopTest();
    }

    public static testMethod void testProcess3(){
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'Both';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;



        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = testDataBuilder.createBrand();
        insert testBrand;

        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.id;      
        insert appVar;
        
    
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        

        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            App_Personal_Reference_Ext appPerRefExtCC = new App_Personal_Reference_Ext(standardCon);
            appPerRefExtCC.getStreetTypeOptionsInt();
            appPerRefExtCC.getCountryOptsInt();
            appPerRefExtCC.stateOptions = new List < SelectOption >();
            Personal_Reference_Check__c perRef = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef.Street_Number__c = '380';
            perRef.Street_Name__c = 'Little Lonsdale';
            perRef.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef;
            appPerRefExtCC.save();
        test.stopTest();
    }

    public static testMethod void testProcess4(){
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'NZ';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        

        Profile_Country__c pc = new Profile_Country__c();
        pc.NZ__c = true;
        insert pc;

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        Brand__c testBrand = testDataBuilder.createBrandNZ();
        insert testBrand;

        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplicationNZ(testBrand);
        insert appVar;
        

        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        

        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            App_Personal_Reference_Ext appPerRefExtCC = new App_Personal_Reference_Ext(standardCon);
            //appPerRefExtCC.getStreetTypeOptionsInt();
            appPerRefExtCC.getCountryOptsInt();
            appPerRefExtCC.stateOptions = new List < SelectOption >();
            Personal_Reference_Check__c perRef = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef.Street_Number__c = '52';
            perRef.Street_Name__c = 'test';
            perRef.Suburb__c = 'test';
            perRef.State__c = 'test';
            appPerRefExtCC.personalReference = perRef;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef2 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef2.Street_Number__c = '52';
            perRef2.Street_Name__c = '***((0))))';
            perRef2.Suburb__c = 'test';
            perRef2.State__c = 'test';
            perRef2.Postcode__c = '1206';
            perRef2.Town_City__c = 'Auckland';
            perRef2.Street_Type__c = 'Alley';
            perRef2.Country__c = 'NZ';
            appPerRefExtCC.personalReference = perRef2;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef3 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef3.Street_Number__c = '52';
            perRef3.Street_Name__c = 'test';
            perRef3.Suburb__c = '**&&&%%^^^';
            perRef3.State__c = 'test';
            perRef3.Postcode__c = '1206';
            perRef3.Town_City__c = 'Auckland';
            perRef3.Street_Type__c = 'Alley';
            perRef3.Country__c = 'NZ';
            appPerRefExtCC.personalReference = perRef3;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef4 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef4.Street_Number__c = '52';
            perRef4.Street_Name__c = 'test';
            perRef4.Suburb__c = 'test';
            perRef4.State__c = 'test';
            perRef4.Postcode__c = '1206';
            perRef4.Town_City__c = '***^^^^^%%';
            perRef4.Street_Type__c = 'Alley';
            perRef4.Country__c = 'NZ';
            appPerRefExtCC.personalReference = perRef4;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef5 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef5.Street_Number__c = '52';
            perRef5.Street_Name__c = 'test';
            perRef5.Suburb__c = 'test';
            perRef5.State__c = 'test';
            perRef5.Postcode__c = '1206';
            perRef5.Town_City__c = 'testtesttesttesttesttesttest';
            perRef5.Street_Type__c = 'Alley';
            perRef5.Country__c = 'NZ';
            appPerRefExtCC.personalReference = perRef5;
            appPerRefExtCC.save();
        test.stopTest();
    }

    public static testMethod void testProcess5(){
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'AU';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;



        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = testDataBuilder.createBrand();
        insert testBrand;

        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.id;      
        insert appVar;
        
    
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        

        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            App_Personal_Reference_Ext appPerRefExtCC = new App_Personal_Reference_Ext(standardCon);
            appPerRefExtCC.getStreetTypeOptionsInt();
            appPerRefExtCC.getCountryOptsInt();

            Personal_Reference_Check__c perRef = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef.Street_Number__c = '380';
            perRef.Street_Name__c = 'Little Lonsdale';
            perRef.Suburb__c = 'Melbourne';
            perRef.State__c = 'VIC';
            perRef.Postcode__c = '3000';
            perRef.Town_City__c = 'Melbourne';
            perRef.Street_Type__c = 'Alley';
            perRef.Country__c = 'AU';
            perRef.Property_Name__c = 'testtesttesttesttesttest';
            appPerRefExtCC.personalReference = perRef;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef2 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef2.Street_Number__c = '380';
            perRef2.Street_Name__c = 'Little Lonsdale';
            perRef2.Suburb__c = 'Melbourne';
            perRef2.State__c = 'VIC';
            perRef2.Postcode__c = '3000';
            perRef2.Town_City__c = 'Melbourne';
            perRef2.Street_Type__c = 'Alley';
            perRef2.Country__c = 'AU';
            perRef2.Unit_number__c = 'testtesttesttesttesttest';
            appPerRefExtCC.personalReference = perRef2;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef3 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef3.Street_Number__c = '3801234';
            perRef3.Street_Name__c = 'Little Lonsdale';
            perRef3.Suburb__c = 'Melbourne';
            perRef3.State__c = 'VIC';
            perRef3.Postcode__c = '3000';
            perRef3.Town_City__c = 'Melbourne';
            perRef3.Street_Type__c = 'Alley';
            perRef3.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef3;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef4 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef4.Street_Number__c = '380';
            perRef4.Street_Name__c = 'Little Lonsdale Street Test Test';
            perRef4.Suburb__c = 'Melbourne';
            perRef4.State__c = 'VIC';
            perRef4.Postcode__c = '3000';
            perRef4.Town_City__c = 'Melbourne';
            perRef4.Street_Type__c = 'Alley';
            perRef4.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef4;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef5 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef5.Street_Number__c = '380';
            perRef5.Street_Name__c = 'Little Lonsdale Street Test Test';
            perRef5.Suburb__c = '*****&&&&^^';
            perRef5.State__c = 'VIC';
            perRef5.Postcode__c = '3000';
            perRef5.Town_City__c = 'Melbourne';
            perRef5.Street_Type__c = 'Alley';
            perRef5.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef5;
            appPerRefExtCC.save();

            Personal_Reference_Check__c perRef6 = TestDataBuilder.createPersonalReferenceCheck(appVar.id);
            perRef6.Street_Number__c = '380';
            perRef6.Street_Name__c = 'Little Lonsdale Street Test Test';
            perRef6.Suburb__c = 'Melbourne';
            perRef6.State__c = 'VIC';
            perRef6.Postcode__c = '******';
            perRef6.Town_City__c = 'Melbourne';
            perRef6.Street_Type__c = 'Alley';
            perRef6.Country__c = 'AU';
            appPerRefExtCC.personalReference = perRef6;
            appPerRefExtCC.save();
        test.stopTest();
    }


}