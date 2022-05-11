/* @Description: Test Class for APP_ProofIncomeDetail_CCINT Class (Staff UI)
 * @Author: Adrian Recio
 * @Date Created: 28-02-2014
 * @History:
   =====================================================================
       19-02-14: Created - Adrian
   =====================================================================
 */ 
 @IsTest
public with sharing class APP_ProofIncomeDetail_CCINT_Test {
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Test AU and NZ proof of income events
    * @param 
    */
    public static testMethod void testProofIncomeDetail(){
        
        // Build Test Tax Table
        Tax_Income__c tiVar = TestDataBuilder.createTaxIncome();
        insert tiVar;
        
        Tax_Income_Line_Item__c tiLineItem1 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem1.Starting_Amount__c = 0;
        tiLineItem1.Max__c = 18200;
        tiLineItem1.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('AU').getRecordTypeId();
        tiLineItem1.Plus_Every__c = 0;
        
        Tax_Income_Line_Item__c tiLineItem2 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem2.Starting_Amount__c = 18201;
        tiLineItem2.Max__c = 37000;
        tiLineItem2.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('AU').getRecordTypeId();
        tiLineItem2.Plus_Every__c = 0.190;
        
        Tax_Income_Line_Item__c tiLineItem3 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem3.Starting_Amount__c = 37001;
        tiLineItem3.Max__c = 80000;
        tiLineItem3.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('AU').getRecordTypeId();
        tiLineItem3.Plus_Every__c = 0.325;
        
        Tax_Income_Line_Item__c tiLineItem4 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem4.Starting_Amount__c = 80001;
        tiLineItem4.Max__c = 180000;
        tiLineItem4.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('AU').getRecordTypeId();
        tiLineItem4.Plus_Every__c = 0.370;
        
        Tax_Income_Line_Item__c tiLineItem5 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem5.Starting_Amount__c = 180001;
        tiLineItem5.Max__c = 0;
        tiLineItem5.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('AU').getRecordTypeId();
        tiLineItem5.Plus_Every__c = 0.450;
        
        List<Tax_Income_Line_Item__c>tiLineItemList = new List<Tax_Income_Line_Item__c>();
        tiLineItemList.add(tiLineItem1);
        tiLineItemList.add(tiLineItem2);
        tiLineItemList.add(tiLineItem3);
        tiLineItemList.add(tiLineItem4);
        tiLineItemList.add(tiLineItem5);
        
        insert tiLineItemList;
        
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        insert appVar;
        
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
                    
        test.startTest();
            // Create Test AU Income 
            Income__c inVar = testDataBuilder.createIncome(appliVar.Id);
            inVar.RecordTypeId = testDataBuilder.IncomeRecordType.get('AU').getRecordTypeId();
            insert inVar;
        
            // Pull autocreated Income Capacity of Income Trigger after insert of Income
            Income_Capacity__c icVal = [Select Id, Method_of_Calculation__c,Previous_Employer_Name__c,Is_e_POI__c,Name, Income__c, RecordType.Name from Income_Capacity__c where Income__c = :inVar.Id];
            // Ensure that your test data is AU recordtype.
            // Do not assume that recordtype default is always AU for the current runnin user.
            //icVal.RecordTypeId = testDataBuilder.IncomeCapRecordType.get('AU').getRecordTypeId();
            //update icVal; 

            // Set Financial Year to test tax income line item previously created 
            icVal.Tax_Income__c = tiVar.Id;
            
            // Instantiate Class for Testing
            APP_ProofIncomeDetail_CCINT appPIDetailCC = new APP_ProofIncomeDetail_CCINT();
            
            // Test Tax Return Condition
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Self Employed';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Tax Return';
            icVal.Taxable_Income__c = 1500;
            icVal.plus_Depreciation__c = 1000;
            icVal.plus_Interest__c = 1000;
            icVal.plus_Personal_Superannuation__c = 1000;
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(4477.50,icVal.ADJUSTED_INCOME_YEARLY__c);
            
            // Test Profit & Loss Condition
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Self Employed';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Profit & Loss';
            icVal.Net_Profit_Before_Tax__c = 2500;
            icVal.plus_Depreciation__c = 1000;
            icVal.plus_Interest__c = 1000;
            icVal.plus_Personal_Superannuation__c = 1000;
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(5462.50,icVal.ADJUSTED_INCOME_YEARLY__c);
            
            // Salary Sacrifice
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'Yes';
            icVal.Method_of_Verification__c = null;
            icVal.SS_Frequency_of_Payment__c = 'Monthly';
            icVal.Lowest_Income_Deposit__c = 1300;
            icVal.Salary_Sacrifice_Income_Portion__c = 200; 
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(18000.00,icVal.Annualised_Net_Income__c);
            
            // Net Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Letter from Employer';
            icVal.Frequency_of_Payment__c = 'Monthly';
            icVal.Income_1__c = 1300;
            icVal.Method_of_Calculation__c = 'Net Income';
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(15600,icVal.Annualised_Net_Income__c);
            
            // Net YTD
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Verbal - Fax Request';
            icVal.Frequency_of_Payment__c = '';
            icVal.Income_1__c = 2000;
            icVal.YTD_Start_Date__c = Date.today().addMonths(-3);
            icVal.YTD_Finish_Date__c = Date.today();
            icVal.Method_of_Calculation__c = 'Net YTD';
            
            appPIDetailCC.incomeCalculation(icVal);
            //system.assertEquals(8021.98,icVal.Annualised_Net_Income__c.setScale(2));
            
            // Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Letter from Employer';
            icVal.Frequency_of_Payment__c = 'Monthly';
            icVal.Income_1__c = 1300;
            icVal.Method_of_Calculation__c = 'Gross Income';
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(15366.00,icVal.Annualised_Net_Income__c.setScale(2));
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Monthly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(18722.00,icVal.Annualised_Net_Income__c.setScale(2));
            
            // Gross Taxable Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Fixed Term Contract';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Notice of Assessment';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 2000;
            icVal.Method_of_Calculation__c = 'Gross Taxable Income';
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(1970.00,icVal.Annualised_Net_Income__c.setScale(2));
            
            // Gross YTD
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'PAYG Summary';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 2000;
            icVal.Method_of_Calculation__c = 'Gross YTD';
            icVal.YTD_Start_Date__c = Date.today().addMonths(-3);
            icVal.YTD_Finish_Date__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
        
        // Test Proviso with Full time
        appPIDetailCC.resetIncome(icVal);
        icVal.Employment_Type__c = 'Permanent Full Time';
        icVal.Salary_Sacrifice__c = 'No';
        icVal.Method_of_Verification__c = 'Proviso';
        icVal.Is_e_POI__c = True;       
        icVal.Method_of_Verification__c = 'Payslip';
        icVal.Employment_Type__c = 'Permanent Full Time';  
        icVal.Frequency_of_Payment__c = 'Monthly';
        icVal.Taxable_Income__c = 8000;
        icVal.plus_Depreciation__c = 1000;
        icVal.plus_Interest__c = 1000;
        icVal.plus_Personal_Superannuation__c = 1000;
        icVal.Minimum_Income_Used__c = 500;
        icVal.Annualised_Net_Income__c = 15000;
        
        icVal.Rental_Income_per_ppty_owners__c = 0;
        icVal.Gross_YTD__c = 0;
        icVal.Net_YTD__c = 0;
        icVal.Less_Tax__c = 0;
        icVal.Annualised_Gross_Income__c = 0;   
        icVal.Gross_Annualised_per_annum__c = 0;
        icVal.Gross_Annualised_per_month__c = 0;
        // Tax Return and Profit & Loss Fields
        icVal.EQUALS_ADJUSTED_INCOME__c = 0;
        icVal.ADJUSTED_INCOME_YEARLY__c = 0;
        icVal.Net_Monthly_Income__c = 0;
        
        appPIDetailCC.incomeCalculation(icVal);
      
        
        
            //system.assertEquals(7901.65,icVal.Annualised_Net_Income__c.setScale(2));
            //system.assertEquals(7989.44,icVal.Annualised_Net_Income__c.setScale(2));

            // Assert intervalAccount Method
            system.assertEquals(52,appPIDetailCC.intervalCount('Weekly', false));
            system.assertEquals(26,appPIDetailCC.intervalCount('Fortnightly', false));
            system.assertEquals(12,appPIDetailCC.intervalCount('Monthly', false));
            system.assertEquals(24,appPIDetailCC.intervalCount('Bi-Monthly', false));
            system.assertEquals(1,appPIDetailCC.intervalCount('Yearly', false));
            system.assertEquals(0,appPIDetailCC.intervalCount('', false));
            
            // Assert Reset to zero method
            system.assertEquals(0,appPIDetailCC.resetNullToZero(-1));
            system.assertEquals(0,appPIDetailCC.resetNullToZero(null));
            system.assertEquals(1,appPIDetailCC.resetNullToZero(1));
            
            // Ytd Value
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Monthly';
            icVal.Payslip_1_Income__c = 2000;
            icVal.YTD_Start_Date__c = Date.today().addMonths(-3);
            icVal.YTD_Finish_Date__c = Date.today();
            icVal.Method_of_Calculation__c = 'Net YTD';         
            //system.assertEquals(8022,appPIDetailCC.ytdValue(icVal, icVal.Payslip_1_Income__c).round());
            //system.assertEquals(8111,appPIDetailCC.ytdValue(icVal, icVal.Payslip_1_Income__c).round());
            
            // tax Value 
            icVal.Employment_Type__c = 'Fixed Term Contract';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Notice of Assessment';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 2000;
            icVal.Method_of_Calculation__c = 'Gross Taxable Income';
            
            system.assertEquals(30,appPIDetailCC.taxValue(icVal, icVal.Income_1__c).round());
            
            // tax Value Max
            icVal.Employment_Type__c = 'Fixed Term Contract';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Notice of Assessment';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 18000000;
            icVal.Method_of_Calculation__c = 'Gross Taxable Income';
            
            system.assertEquals(8343547,appPIDetailCC.taxValue(icVal, icVal.Income_1__c).round(RoundingMode.UP));
            
            // null tax value condition
            //system.assertEquals(0,appPIDetailCC.taxValue(new Income_Capacity__c(RecordTypeId = Schema.Sobjecttype.Income_Capacity__c.getRecordTypeInfosByName().get('AU').getRecordTypeId()), 0)); 
            
            // range Tax
            //system.assertEquals(17547,appPIDetailCC.computeTaxAmount( 80000 , tiVar.Id, false, 0).round(RoundingMode.UP)); //Removed by DYU 27-AUG-2015 PMIHM-1940
            
            // lowest Income Source
            icVal.Income_1__c = 200;
            icVal.Income_2__c = 100;
            icVal.Income_3__c = 300;
            icVal.Payslip_1_Income__c = 400;
            icVal.Payslip_2_Income__c = 500;
            icVal.Lowest_Income_Deposit__c = 600;
            icVal.Net_Income_Salary_Sacrifice__c = 700;
            
            system.assertEquals(100,appPIDetailCC.pullLowestIncomeSource(icVal));
            
            // rental income calculation
            icVal.Employment_Type__c = 'Rental Income Agency';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Lease Agreement';
            icVal.No_of_Property_Owners__c = '1';
            icVal.Income_1__c = 18000000;
            icVal.Method_of_Calculation__c = 'Net Income';
            
            system.assertEquals(16200000,appPIDetailCC.calculateRentalIncome(icVal,icVal.Income_1__c));
            
            // rental income calculation from incomeCalculation Method
            icVal.Employment_Type__c = 'Rental Income Agency';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Lease Agreement';
            icVal.No_of_Property_Owners__c = '1';
            icVal.Income_1__c = 18000000;
            icVal.Method_of_Calculation__c = 'Net Income';
            
            appPIDetailCC.incomeCalculation(icVal);
            system.assertEquals(90,icVal.Annualised_Net_Income__c.setScale(2));
            
            // ytd date Validation
            
            // Start date greater than today
            icVal.YTD_Start_Date__c = Date.today().addMonths(3);
            system.assertEquals(true,APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Finsih date greater than current date

            icVal.YTD_Start_Date__c = Date.today();
            icVal.YTD_Finish_Date__c = Date.today().addMonths(1);
            system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Start and finish date null
            icVal.YTD_Start_Date__c = null;
            icVal.YTD_Finish_Date__c = null;
            system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            
            //icVal.YTD_Start_Date__c = Date.today();
            //icVal.YTD_Finish_Date__c = null;
            //system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Start date greater than finish date
            icVal.YTD_Start_Date__c = Date.today();
            icVal.YTD_Finish_Date__c = Date.today().addMonths(-3);
            system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Span is not more than 2 months
            icVal.YTD_Start_Date__c = Date.today().addMonths(-1);
            icVal.YTD_Finish_Date__c = Date.today();
            system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Date should not be across financial years
            icVal.YTD_Start_Date__c = Date.today().addYears(-2);
            icVal.YTD_Finish_Date__c = Date.today();
            system.assertEquals(true, APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal));
            
            // Set class public variable that holds Income Capacity Value
            appPIDetailCC.icEditList = new List<Income_Capacity__c>();
            appPIDetailCC.icEditList.add(icVal);
            appPIDetailCC.indexValue = '0';
            
            // Clear methods
            appPIDetailCC.empTypeClear();
            appPIDetailCC.metVerClear();
            appPIDetailCC.sacrificeClear();
            
            // Reset methods
            appPIDetailCC.resetComputation(icVal);
            appPIDetailCC.resetIncome(icVal);
            appPIDetailCC.resetVerificationFields(icVal);
            appPIDetailCC.resetValues();
            
            // Tax Year values
            appPIDetailCC.getFinancialYear();
            
            // main method to calculate values
            appPIDetailCC.calculateValues();
            
            // financial date methods
            system.assertEquals(date.newInstance(2014, 7, 1),APP_ProofIncomeDetail_CCINT.financialStartDate(date.newInstance(2014, 7, 20),false));
            system.assertEquals(date.newInstance(2015, 6, 30),APP_ProofIncomeDetail_CCINT.financialFinishDate(date.newInstance(2014, 7, 1),false));
            // financial date method null condition
            system.assertEquals(null,APP_ProofIncomeDetail_CCINT.financialStartDate(null,false));
            system.assertEquals(null,APP_ProofIncomeDetail_CCINT.financialFinishDate(null,false));
            
            // validate document date methods
            
            // Incorrect Income Date Condition
            icVal.Income_1_DD__c = date.newInstance(2014, 7, 1);
            icVal.Income_2_DD__c = date.newInstance(2014, 7, 1);
            icVal.Income_3_DD__c = date.newInstance(2014, 7, 1);
            icVal.Payslip_1_DD__c = null;
            icVal.Payslip_2_DD__c = null;
            icVal.Frequency_of_Payment__c = 'Weekly';
            system.assertEquals(true,APP_ProofIncomeDetail_CCINT.validateDocDate(icVal, false));
            
            // Incorrect Payslip Date Condition
            //icVal.Income_1_DD__c = null;
            //icVal.Income_2_DD__c = null;
            //icVal.Income_3_DD__c = null;
            //icVal.Payslip_1_DD__c = date.newInstance(2014, 7, 1);
            //icVal.Payslip_2_DD__c = date.newInstance(2014, 7, 1);
            //icVal.Frequency_of_Payment__c = 'Weekly';
            //system.assertEquals(true,APP_ProofIncomeDetail_CCINT.validateDocDate(icVal));
            
            // getter methods
            appPIDetailCC.counterVar = 1;
            system.assertEquals(appPIDetailCC.getCounterVar(),1);
            
            // setter methods
            appPIDetailCC.setCounterVar(1);
            system.assertEquals(appPIDetailCC.counterVar, 1);
            
            appPIDetailCC.specialMainFieldReset();
            appPIDetailCC.getPayslipOther();
            appPIDetailCC.getPayslipPermanentNZ();
            appPIDetailCC.getOvershiftTwoMonthsYes();
            appPIDetailCC.getOvershiftTwoMonthsNo();
            
            appPIDetailCC.geticEditList();
            
            List<Income_Capacity__c> icList = new List<Income_Capacity__c>();
            icList.add(icVal);
          //  appPIDetailCC.seticEditList(icList);
            appPIDetailCC.buildIcList();
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Monthly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Payslip_1_DD__c = Date.today();
            icVal.Payslip_2_DD__c = Date.today()-1;
            icVal.Payslip_3_DD__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Weekly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Payslip_1_DD__c = Date.today();
            icVal.Payslip_2_DD__c = Date.today()-1;
            icVal.Payslip_3_DD__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Fortnightly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Payslip_1_DD__c = Date.today();
            icVal.Payslip_2_DD__c = Date.today()-1;
            icVal.Payslip_3_DD__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Bi-Monthly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Payslip_1_DD__c = Date.today();
            icVal.Payslip_2_DD__c = Date.today()-1;
            icVal.Payslip_3_DD__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
            
            // Base Gross Income
            appPIDetailCC.resetIncome(icVal);
            icVal.Employment_Type__c = 'Permanent full time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Payslip';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Payslip_1_Income__c = 1600;
            icVal.Method_of_Calculation__c = 'Base Gross Income';
            icVal.Payslip_1_DD__c = Date.today();
            icVal.Payslip_2_DD__c = Date.today()-1;
            icVal.Payslip_3_DD__c = Date.today();
            
            appPIDetailCC.incomeCalculation(icVal);
        test.stopTest();
    }

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 May 2015
    * @description Test NZ proof of income events
    * @param 
    */
    public static testMethod void testProofIncomeDetailNZ(){
        // Build Test Tax Table
        Tax_Income__c tiVar = TestDataBuilder.createTaxIncome();
        tiVar.Student_Loan_Threshold__c = 50;
        tiVar.Student_Loan_Rate__c = 50;
        tiVar.ACC_Earners_Levy__c = 50;
        insert tiVar;
        
        Tax_Income_Line_Item__c tiLineItem1 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem1.Starting_Amount__c = 0;
        tiLineItem1.Max__c = 18200;
        tiLineItem1.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('NZ').getRecordTypeId();
        tiLineItem1.Plus_Every__c = 0;
        
        Tax_Income_Line_Item__c tiLineItem2 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem2.Starting_Amount__c = 18201;
        tiLineItem2.Max__c = 37000;
        tiLineItem2.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('NZ').getRecordTypeId();
        tiLineItem2.Plus_Every__c = 0.190;
        
        Tax_Income_Line_Item__c tiLineItem3 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem3.Starting_Amount__c = 37001;
        tiLineItem3.Max__c = 80000;
        tiLineItem3.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('NZ').getRecordTypeId();
        tiLineItem3.Plus_Every__c = 0.325;
        
        Tax_Income_Line_Item__c tiLineItem4 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem4.Starting_Amount__c = 80001;
        tiLineItem4.Max__c = 180000;
        tiLineItem4.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('NZ').getRecordTypeId();
        tiLineItem4.Plus_Every__c = 0.370;
        
        Tax_Income_Line_Item__c tiLineItem5 = TestDataBuilder.createTILineItem(tiVar.Id);
        tiLineItem5.Starting_Amount__c = 180001;
        tiLineItem5.Max__c = 0;
        tiLineItem5.RecordTypeId = testDataBuilder.taxLineItemRecordType.get('NZ').getRecordTypeId();
        tiLineItem5.Plus_Every__c = 0.450;
        
        List<Tax_Income_Line_Item__c>tiLineItemList = new List<Tax_Income_Line_Item__c>();
        tiLineItemList.add(tiLineItem1);
        tiLineItemList.add(tiLineItem2);
        tiLineItemList.add(tiLineItem3);
        tiLineItemList.add(tiLineItem4);
        tiLineItemList.add(tiLineItem5);
        
        insert tiLineItemList;
        
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        insert appVar;
        
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
                    
        test.startTest();
            // Create Test AU Income 
            Income__c inVar = testDataBuilder.createIncome(appliVar.Id);
            inVar.RecordTypeId = testDataBuilder.IncomeRecordType.get('NZ').getRecordTypeId();
            insert inVar;
        
            // Pull autocreated Income Capacity of Income Trigger after insert of Income
            Income_Capacity__c icVal = [Select Id, Name, Income__c, RecordType.Name from Income_Capacity__c where Income__c = :inVar.Id];
            // Ensure that your test data is AU recordtype.
            // Do not assume that recordtype default is always AU for the current runnin user.
            icVal.RecordTypeId = testDataBuilder.IncomeCapRecordType.get('NZ').getRecordTypeId();
            // Set Financial Year to test tax income line item previously created 
            icVal.Tax_Income__c = tiVar.Id;
            
            update icVal; 

            // Refresh
            icVal = [Select Id, Name, Income__c, RecordType.Name,Tax_Income__c from Income_Capacity__c where Income__c = :inVar.Id];

            RecordType recTypeVar = [Select Name,Id from RecordType where Id = :icVal.RecordTypeId];
            system.debug('test recordtype name:' + recTypeVar.name);
            
            // Instantiate Class for Testing
            APP_ProofIncomeDetail_CCINT appPIDetailCC = new APP_ProofIncomeDetail_CCINT();
                        
            // tax Value 
            icVal.Employment_Type__c = 'Fixed Term Contract';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Notice of Assessment';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 2000;
            icVal.Method_of_Calculation__c = 'Gross Taxable Income';
            icVal.Kiwi_Saver__c = '3%';
            icVal.Student_Loan__c = 'Yes';
            
            // Code Scan Fix: Adrian Recio
            // Add Assertion
            appPIDetailCC.taxValue(icVal, icVal.Income_1__c);
            system.assertEquals(2035,appPIDetailCC.taxValue(icVal, icVal.Income_1__c).round());
            
            // tax Value Max
            icVal.Employment_Type__c = 'Fixed Term Contract';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Notice of Assessment';
            icVal.Frequency_of_Payment__c = 'Yearly';
            icVal.Income_1__c = 18000000;
            icVal.Method_of_Calculation__c = 'Gross Taxable Income';
            
            // Code Scan Fix: Adrian Recio
            // Add Assertion
            appPIDetailCC.taxValue(icVal, icVal.Income_1__c);
             //system.assertEquals(26613521,appPIDetailCC.taxValue(icVal, icVal.Income_1__c).round(RoundingMode.UP)); //Removed by DYU 27-AUG-2015 PMIHM-1940
            
            // null tax value condition
            //system.assertEquals(0,appPIDetailCC.taxValue(new Income_Capacity__c(RecordTypeId = Schema.Sobjecttype.Income_Capacity__c.getRecordTypeInfosByName().get('AU').getRecordTypeId()), 0)); 
            // Proviso Test
            icVal.Employment_Type__c = 'Permanent Full Time';
            icVal.Salary_Sacrifice__c = 'No';
            icVal.Method_of_Verification__c = 'Proviso';
            icVal.Frequency_of_Payment__c = 'Montly';
            icVal.Income_1__c = 8000;
            icVal.Is_e_POI__c = True;
        
            
            // Code Scan Fix: Adrian Recio
            // Add Assertion
            appPIDetailCC.taxValue(icVal, icVal.Income_1__c);

        test.stopTest();
    }
    
    public static testMethod void testPOICode(){
    APP_ProofIncomeDetail_CCINT apc = new APP_ProofIncomeDetail_CCINT();
    apc.recordTypeName = 'xyz';
    Test.startTest();
      Application__c application = TestDataBuilder.createApplication();
        insert application;
    
    Applicant__c appId = TestDataBuilder.createApplicant(null, application.Id);
       insert appId;
       
    Income__c income1 = new Income__c();
        income1.Applicant__c = appId.id;
        income1.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income1.Occupation__c = 'Developer';
        income1.Emp_Bus_Name__c = 'GlobalOnea';
        income1.Emp_Bus_Contact_No__c = '0234567890';
        income1.Years_With_Employer__c = 5;
        income1.Months_With_Employer__c = 6;
        income1.Income_Amount__c = 1234567;
        income1.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income1.Total_Income__c = 1234567;
        income1.POI_Amount_Verified__c = 10000.00;
        insert income1;
        
       Income_Capacity__c incCap = new Income_Capacity__c();
        incCap.Income__c = income1.id;
        incCap.RecordTypeId = testDataBuilder.IncomeCapRecordType.get('NZ').getRecordTypeId();
        incCap.Income_Detail__c = 'My permanent - full time job';
        //incCap.Employment_Type__c = 'Permanent Full Time';
        incCap.Employment_Type__c = 'Rental Income';
        incCap.Frequency_of_Payment__c ='Monthly';
        incCap.Method_of_Calculation__c ='Net Income';
        incCap.Method_of_Verification__c ='Bank Statement';
        incCap.Income_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap.Income_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap.Income_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap.Minimum_Income_Used__c = 10000.00;
        incCap.Annualised_Net_Income__c = 100000.00;
        incCap.Annualised_Net_Income_per_Month__c = 10000;
        incCap.Overtime_Shift_Allowance__c = 'No';     
        insert incCap;        
        
       Income_Capacity__c incCap1 = new Income_Capacity__c();
        incCap1.Income__c = income1.id;
        incCap1.Income_Detail__c = 'My permanent - full time job';
        incCap1.Employment_Type__c = 'Permanent Full Time';
        incCap1.Frequency_of_Payment__c ='Weekly';
        incCap1.Method_of_Calculation__c ='Net Income';
        incCap1.Method_of_Verification__c ='Payslip';
        incCap1.Payslip_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap1.Payslip_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap1.Payslip_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap1.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap1.Minimum_Income_Used__c = 10000.00;
        incCap1.Annualised_Net_Income__c = 100000.00;
        incCap1.Annualised_Net_Income_per_Month__c = 10000;
        incCap1.Overtime_Shift_Allowance__c = 'No';     
        insert incCap1;   
        
       Income_Capacity__c incCap2 = new Income_Capacity__c();
        incCap2.Income__c = income1.id;
        incCap2.Income_Detail__c = 'My permanent - full time job';
        incCap2.Employment_Type__c = 'Permanent Full Time';
        incCap2.Frequency_of_Payment__c ='Fortnightly';
        incCap2.Method_of_Calculation__c ='Net Income';
        incCap2.Method_of_Verification__c ='Payslip';
        incCap2.Payslip_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap2.Payslip_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap2.Payslip_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap2.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap2.Minimum_Income_Used__c = 10000.00;
        incCap2.Annualised_Net_Income__c = 100000.00;
        incCap2.Annualised_Net_Income_per_Month__c = 10000;
        incCap2.Overtime_Shift_Allowance__c = 'No';     
        insert incCap2;                     

   new APP_ProofIncomeDetail_CCINT.icListWithIndex(incCap,10,true);
   new APP_ProofIncomeDetail_CCINT.icListWithIndex(incCap,10,true).specialMOCHasError = true;
   
   apc.incomeCalculation(incCap);
   apc.calculateRentalIncome(incCap,10.0);
   apc.getPayslipPermanentAU();
   apc.getPayslipPermanent();
   apc.getPermanentIRDSummary();
   apc.getOvertimeShiftAllowanceAU(); 
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap,true);
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap1,true);
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap2,true);
   APP_ProofIncomeDetail_CCINT.validateYtdDate(incCap);
}
 public static testMethod void testPopulateVerifierCode(){
    APP_ProofIncomeDetail_CCINT apc = new APP_ProofIncomeDetail_CCINT();
    apc.recordTypeName = 'xyz';
    Test.startTest();

List<Application__c> apList = new List<Application__c>();

      Application__c application = TestDataBuilder.createApplication();
//        insert application;
          apList.add(application);
          insert apList;
          
    Applicant__c appId = TestDataBuilder.createApplicant(null, application.Id);
       insert appId;
       
       List<Income__c> incList = new List<Income__c>();
       
    Income__c income1 = new Income__c();
        income1.Applicant__c = appId.id;
        income1.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income1.Occupation__c = 'Developer';
        income1.Emp_Bus_Name__c = 'GlobalOnea';
        income1.Emp_Bus_Contact_No__c = '0234567890';
        income1.Years_With_Employer__c = 5;
        income1.Months_With_Employer__c = 6;
        income1.Income_Amount__c = 1234567;
        income1.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income1.Total_Income__c = 1234567;
        income1.POI_Amount_Verified__c = 10000.00;
        //insert income1;
    
    Income__c income2 = new Income__c();
        income2.Applicant__c = appId.id;
        income2.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income2.Occupation__c = 'Developer';
        income2.Emp_Bus_Name__c = 'GlobalOnea';
        income2.Emp_Bus_Contact_No__c = '0234567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        //insert income2;
        
        incList.add(income1);
        incList.add(income2);
        
        insert incList;
               
       Income_Capacity__c incCap = new Income_Capacity__c();
        incCap.Income__c = income1.id;
        incCap.RecordTypeId = testDataBuilder.IncomeCapRecordType.get('NZ').getRecordTypeId();
        incCap.Income_Detail__c = 'My permanent - full time job';
        //incCap.Employment_Type__c = 'Permanent Full Time';
        incCap.Employment_Type__c = 'Rental Income';
        incCap.Frequency_of_Payment__c ='Monthly';
        incCap.Method_of_Calculation__c ='Net Income';
        incCap.Method_of_Verification__c ='Bank Statement';
        incCap.Income_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap.Income_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap.Income_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap.Minimum_Income_Used__c = 10000.00;
        incCap.Annualised_Net_Income__c = 100000.00;
        incCap.Annualised_Net_Income_per_Month__c = 10000;
        incCap.Overtime_Shift_Allowance__c = 'No';     
        insert incCap;        
        
       Income_Capacity__c incCap1 = new Income_Capacity__c();
        incCap1.Income__c = income1.id;
        incCap1.Income_Detail__c = 'My permanent - full time job';
        incCap1.Employment_Type__c = 'Permanent Full Time';
        incCap1.Frequency_of_Payment__c ='Weekly';
        incCap1.Method_of_Calculation__c ='Net Income';
        incCap1.Method_of_Verification__c ='Payslip';
        incCap1.Payslip_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap1.Payslip_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap1.Payslip_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap1.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap1.Minimum_Income_Used__c = 10000.00;
        incCap1.Annualised_Net_Income__c = 100000.00;
        incCap1.Annualised_Net_Income_per_Month__c = 10000;
        incCap1.Overtime_Shift_Allowance__c = 'No';     
        insert incCap1;   
        
       Income_Capacity__c incCap2 = new Income_Capacity__c();
        incCap2.Income__c = income1.id;
        incCap2.Income_Detail__c = 'My permanent - full time job';
        incCap2.Employment_Type__c = 'Permanent Full Time';
        incCap2.Frequency_of_Payment__c ='Fortnightly';
        incCap2.Method_of_Calculation__c ='Net Income';
        incCap2.Method_of_Verification__c ='Payslip';
        incCap2.Payslip_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap2.Payslip_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap2.Payslip_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap2.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap2.Minimum_Income_Used__c = 10000.00;
        incCap2.Annualised_Net_Income__c = 100000.00;
        incCap2.Annualised_Net_Income_per_Month__c = 10000;
        incCap2.Overtime_Shift_Allowance__c = 'No';     
        insert incCap2;     

       Income_Capacity__c incCap3 = new Income_Capacity__c();
        incCap3.Income__c = income1.id;
        incCap3.Income_Detail__c = 'My permanent - full time job';
        incCap3.Employment_Type__c = 'Permanent Full Time';
        incCap3.Frequency_of_Payment__c ='Monthly';
        incCap3.Method_of_Calculation__c ='Net Income';
        incCap3.Method_of_Verification__c ='Verifier';
        incCap3.Payslip_1_DD__c = Date.newInstance(2016, 10, 7);
        incCap3.Payslip_2_DD__c = Date.newInstance(2016, 11, 8);
        incCap3.Payslip_3_DD__c = Date.newInstance(2016, 12, 9);
        incCap3.Lowest_Income_Deposit_DD__c = Date.newInstance(2016, 12, 9);
        incCap3.Minimum_Income_Used__c = 10000.00;
        incCap3.Annualised_Net_Income__c = 100000.00;
        incCap3.Annualised_Net_Income_per_Month__c = 10000;
        incCap3.Overtime_Shift_Allowance__c = 'No';     
        insert incCap3;                           

   new APP_ProofIncomeDetail_CCINT.icListWithIndex(incCap,10,true);
   new APP_ProofIncomeDetail_CCINT.icListWithIndex(incCap,10,true).specialMOCHasError = true;
   
   apc.incomeCalculation(incCap);
   apc.calculateRentalIncome(incCap,10.0);
   apc.getPayslipPermanentAU();
   apc.getPayslipPermanent();
   apc.getPermanentIRDSummary();
   apc.getOvertimeShiftAllowanceAU(); 
  // APP_ProofIncomeDetail_CCINT.populateVerifier(incCap3);
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap,true);
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap1,true);
   APP_ProofIncomeDetail_CCINT.validateDocDate(incCap2,true);
   APP_ProofIncomeDetail_CCINT.validateYtdDate(incCap);
       }       
}