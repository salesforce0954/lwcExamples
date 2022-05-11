/* @Description: Test Class for APP_ProofIncomeExt_INT Class (Staff UI)
 * @Author: Adrian Recio
 * @Date Created: 19-02-2014
 * @History:
   =====================================================================
       19-02-14: Created - Adrian
   =====================================================================
 */ 
 @IsTest
public without sharing class APP_ProofIncomeExt_INT_Test {
    public static testMethod void testProofIncomeExtINT_ONE(){
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        insert appVar;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        // Create Applicant 1
        Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        appliVar1.Is_Primary_Applicant__c = true;
        insert appliVar1;
        
        // Create Applicant 2
        Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar2;
        
        // Create Test Income for Applicant 1
        Income__c inVar1 = testDataBuilder.createIncome(appliVar1.Id);
        insert inVar1;
        
        // Create Test Income for Applicant 2
        Income__c inVar2 = testDataBuilder.createIncome(appliVar2.Id);
        insert inVar2;

        // Pull auto created child income capacity
        Income_Capacity__c icVar1 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar1.Id limit 1];
        Income_Capacity__c icVar2 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar2.Id limit 1];
                                                      
        test.startTest();   
            ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
            APP_ProofIncomeExt_INT pIncomeExt = new APP_ProofIncomeExt_INT(standardCon);
            
            // Edit visibility methods
            pIncomeExt.renderEdit1();
            pIncomeExt.renderEdit2();
            
            // Get application mode
            pIncomeExt.getApplicantMode();
            
            //system.assertEquals(true, pIncomeExt.showEdit);
            
            //pIncomeExt.hideEdit();
            //system.assertEquals(false, pIncomeExt.showEdit);
            
            // Income Capacity Field set getter method
            List<Schema.FieldSetMember> iCFieldSet = pIncomeExt.getIncomeCapacityFields();
            system.assertEquals(true, iCFieldSet.size()>0);
            
            // Method to query income capacity of applicants related to controller application
            pIncomeExt.queryIncomeCapacityByApplicantIncome();
            system.assertEquals(icVar1.Id, pIncomeExt.icList1[0].Id);
            system.assertEquals(icVar2.Id, pIncomeExt.icList2[0].Id);
            
            // Save Income Capacity Method
            pIncomeExt.saveIncomeCapacity();
            
            // Validate mode
            // Satisfy null condition
            pIncomeExt.validateMode();
            // Satisfy with value condition
            ApexPages.currentPage().getParameters().put('requestedDocumentMode','Edit');
            pIncomeExt.validateMode();
            
            // Redirect main
            ApexPages.currentPage().getParameters().put('Id',appVar.Id);
            pIncomeExt.redirectMain();
            
            // Validate Income Capacity required fields
            Income_Capacity__c icVal = new Income_Capacity__c();
            List<Income_Capacity__c> icList = new List<Income_Capacity__c>();
            
            // Invalid Employment Type condition
            icVal = new Income_Capacity__c();
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Invalid Method of Verification condition
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Salary_Sacrifice__c='Yes';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Overtime Shift Allowance - payslip condition
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Overtime Shift Allowance';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Salary_Sacrifice__c = 'No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // validate tax return and profit loss
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Tax Return';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // validate profit & loss
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Profit & Loss';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Net Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Overtime Shift Allowance/payslip/net income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Employment_Type__c ='Overtime Shift Allowance';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income / not ytd income show
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.YTD_Income_show__c='No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Bank statement/ net income/ rental income private
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Rental Income Private';
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Bank Statement';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Bank statement/ net income/ casual
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Casual';
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Bank Statement';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Rental Validation
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c = 'Rental Income Private';
            icVal.Method_of_Verification__c = 'Rental Statement';
            icVal.Method_of_Calculation__c = 'Net Income';
            
            // YTD Validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c='Net YTD';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Gross Income Validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c='Gross Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Verbal validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c='Verbal';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);

            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.YTD_Income_show__c = 'No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Employment_Type__c = 'Overtime Shift Allowance';
            icVal.Method_of_Calculation__c = 'Net Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Centrelink - Verbal
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Centrelink';
            icVal.Method_of_Verification__c = 'Verbal';
            icVal.Salary_Sacrifice__c = 'Yes'; 
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Test Applicant Mode visibility
            ApexPages.currentPage().getParameters().put('applicantMode','2');
            system.assertEquals(false,pIncomeExt.getApplicantMode());
            
            
        test.stopTest();
    }   
    public static testMethod void testProofIncomeExtINT_NZ(){
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        //Create NZ Brand
        Brand__c brNZ = testDataBuilder.createBrandNZ();
        insert brNZ ;
        
        // Create Test NZ Application
        
        Application__c appVar = testDataBuilder.createApplicationNZ(brNZ);
        insert appVar;
        
        Application__c appVar1 = testDataBuilder.createApplicationNZ(brNZ);
        insert appVar1;
        
        Application__c appVar2 = testDataBuilder.createApplicationNZ(brNZ);
        insert appVar2;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        // Create Applicant 1
        ID NZRec =Schema.sObjectType.Applicant__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        appliVar1.Is_Primary_Applicant__c = true;
        appliVar1.Primary_Employment_Status__c='Full Time';
        appliVar1.RecordTypeId =NZRec;
        insert appliVar1;
        
        // Create Applicant 2
        Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        appliVar2.RecordTypeId =NZRec;
        appliVar2.Primary_Employment_Status__c='Full Time';
        insert appliVar2;
        
        //Create Applicant for Other Income type and Employments
         // Create Applicant 1 for Applicaiton 2 
       
        Applicant__c appliVar3 = testDataBuilder.createApplicant(accList[0].Id, appVar1.Id);
        appliVar3.Is_Primary_Applicant__c = true;
        appliVar3.Primary_Employment_Status__c='Full Time';
        appliVar3.RecordTypeId =NZRec;
        insert appliVar3;
        
        // Create Applicant 2 for Applicaiton 2 
        Applicant__c appliVar4 = testDataBuilder.createApplicant(accList[0].Id, appVar1.Id);
        appliVar4.RecordTypeId =NZRec;
        appliVar4.Primary_Employment_Status__c='Full Time';
        insert appliVar4;
        
        Applicant__c appliVar5 = testDataBuilder.createApplicant(accList[0].Id, appVar1.Id);
        appliVar5.Is_Primary_Applicant__c = true;
        appliVar5.Primary_Employment_Status__c='Contract';
        appliVar5.RecordTypeId =NZRec;
        insert appliVar5;
        
        // Create Applicant 2 for Applicaiton 2 
        Applicant__c appliVar6 = testDataBuilder.createApplicant(accList[0].Id, appVar1.Id);
        appliVar6.RecordTypeId =NZRec;
        appliVar6.Primary_Employment_Status__c='Contract';
        insert appliVar6;
        
        // Create Test Income for Applicant 1
        Income__c inVar1 = testDataBuilder.createIncome(appliVar1.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        // Create Test Income for Applicant 2
        Income__c inVar2 = testDataBuilder.createIncome(appliVar2.Id);
        inVar2.Income_Source__c ='Net Salary/Wages';
        insert inVar2;
        
        // Create Test Income for Applicant 1
        Income__c inVar3 = testDataBuilder.createIncome(appliVar3.Id);
        inVar3.Income_Source__c ='Rental Income';
        insert inVar3;
        
        // Create Test Income for Applicant 2
        Income__c inVar4 = testDataBuilder.createIncome(appliVar4.Id);
        inVar4.Income_Source__c ='Rental Income';
        insert inVar4;
        
        // Create Test Income for Applicant 1
        Income__c inVar5 = testDataBuilder.createIncome(appliVar5.Id);
        inVar5.Income_Source__c ='Other';
        insert inVar5;
        
        // Create Test Income for Applicant 2
        Income__c inVar6 = testDataBuilder.createIncome(appliVar6.Id);
        inVar6.Income_Source__c ='Other';
        insert inVar6;

        // Pull auto created child income capacity
        Income_Capacity__c icVar1 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar1.Id limit 1];
        Income_Capacity__c icVar2 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar2.Id limit 1];
        Income_Capacity__c icVar3 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar3.Id limit 1];
        Income_Capacity__c icVar4 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar4.Id limit 1];
        Income_Capacity__c icVar5 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar5.Id limit 1];
        Income_Capacity__c icVar6 = [Select Id,Income__c from Income_Capacity__c where Income__c = :inVar6.Id limit 1];
                                                      
        test.startTest();   
            ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
            APP_ProofIncomeExt_INT pIncomeExt = new APP_ProofIncomeExt_INT(standardCon);
            
             ApexPages.standardController standardCon1 = new ApexPages.standardController(appVar1);
            APP_ProofIncomeExt_INT pIncomeExt1 = new APP_ProofIncomeExt_INT(standardCon1);
            
             ApexPages.standardController standardCon2 = new ApexPages.standardController(appVar2);
            APP_ProofIncomeExt_INT pIncomeExt2 = new APP_ProofIncomeExt_INT(standardCon2);
            
            // Edit visibility methods
            pIncomeExt.renderEdit1();
            pIncomeExt.renderEdit2();
            
            // Get application mode
            pIncomeExt.getApplicantMode();
           
            List<Schema.FieldSetMember> iCFieldSet = pIncomeExt.getIncomeCapacityFields();
            system.assertEquals(true, iCFieldSet.size()>0);
            
            // Method to query income capacity of applicants related to controller application
            pIncomeExt.queryIncomeCapacityByApplicantIncome();
            system.assertEquals(icVar1.Id, pIncomeExt.icList1[0].Id);
            system.assertEquals(icVar2.Id, pIncomeExt.icList2[0].Id);
            
            // Save Income Capacity Method
            pIncomeExt.saveIncomeCapacity();
            
            // Validate mode
            // Satisfy null condition
            pIncomeExt.validateMode();
            // Satisfy with value condition
            ApexPages.currentPage().getParameters().put('requestedDocumentMode','Edit');
            pIncomeExt.validateMode();
            
            // Redirect main
            ApexPages.currentPage().getParameters().put('Id',appVar.Id);
            pIncomeExt.redirectMain();
            
            // Validate Income Capacity required fields
            Income_Capacity__c icVal = new Income_Capacity__c();
            List<Income_Capacity__c> icList = new List<Income_Capacity__c>();
            
            // Invalid Employment Type condition
            icVal = new Income_Capacity__c();
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Invalid Method of Verification condition
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Salary_Sacrifice__c='Yes';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Overtime Shift Allowance - payslip condition
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Overtime Shift Allowance';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Salary_Sacrifice__c = 'No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // validate tax return and profit loss
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Tax Return';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // validate profit & loss
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c = 'Profit & Loss';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Net Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Overtime Shift Allowance/payslip/net income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Employment_Type__c ='Overtime Shift Allowance';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income / not ytd income show
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.YTD_Income_show__c='No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Bank statement/ net income/ rental income private
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Rental Income Private';
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Bank Statement';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Bank statement/ net income/ casual
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c='Casual';
            icVal.Method_of_Calculation__c = 'Net Income';
            icVal.Method_of_Verification__c = 'Bank Statement';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Rental Validation
            icVal = new Income_Capacity__c();
            icVal.Employment_Type__c = 'Rental Income Private';
            icVal.Method_of_Verification__c = 'Rental Statement';
            icVal.Method_of_Calculation__c = 'Net Income';
            
            // YTD Validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c='Net YTD';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Gross Income Validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c='Gross Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Verbal validation
            icVal = new Income_Capacity__c();
            icVal.Method_of_Verification__c='Verbal';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);

            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.YTD_Income_show__c = 'No';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Income Source - Base gross income
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Employment_Type__c = 'Overtime Shift Allowance';
            icVal.Method_of_Calculation__c = 'Net Income';
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Centrelink - Verbal
            icVal = new Income_Capacity__c();
            icVal.Method_of_Calculation__c = 'Centrelink';
            icVal.Method_of_Verification__c = 'Verbal';
            icVal.Salary_Sacrifice__c = 'Yes'; 
            icList = new List<Income_Capacity__c>();
            icList.add(icVal);
            pIncomeExt.validateIncome(icList);
            
            // Test Applicant Mode visibility
            ApexPages.currentPage().getParameters().put('applicantMode','2');
            system.assertEquals(false,pIncomeExt.getApplicantMode());
            
            
        test.stopTest();
    }   
}