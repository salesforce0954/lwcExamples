@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/07/13
Description: Class that will the records that will be used for testing
*/
public class TestDataBuilder{
    
    // Recordtype instance for testing.
    // Add recordtype instance here needed for your testing.
    
    // Account Recordtype
    public static Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Account;
    public static Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
    
    // Branch Assignment RecordType
    public static Schema.DescribeSObjectResult cfrSchemaBA = Schema.SObjectType.Branch_Assignment__c;
    public static Map<String,Schema.RecordTypeInfo> BranchAssignmentRecordType = cfrSchemaBA.getRecordTypeInfosByName();
    
    // Income RecordType
    public static Schema.DescribeSObjectResult cfrSchemaInc = Schema.SObjectType.Income__c;
    public static Map<String,Schema.RecordTypeInfo> IncomeRecordType = cfrSchemaInc.getRecordTypeInfosByName();

    // Income Capacity RecordType
    public static Schema.DescribeSObjectResult cfrSchemaIncCap = Schema.SObjectType.Income_Capacity__c;
    public static Map<String,Schema.RecordTypeInfo> IncomeCapRecordType = cfrSchemaIncCap.getRecordTypeInfosByName();
    
    // Tax Income Line Item RecordType
    public static Schema.DescribeSObjectResult cfrSchemaTILI = Schema.SObjectType.Tax_Income_Line_Item__c;
    public static Map<String,Schema.RecordTypeInfo> taxLineItemRecordType = cfrSchemaTILI.getRecordTypeInfosByName();

    // Custom Boolean Flag to enter test specific scenarios in your class.
    // Please use this if the condition is placed in an if-else condition
    // So that else condition can be satisfied. Test.isRunningTest() provided
    // by salesforce will always return true when running a test class. 
    // Use this variable to gain flexibility to turn on or off your test
    // specific condition so that all scenarios will be satisfied.
    public static Boolean IsTestFlag = false;

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Create account test record
    * @param 
    */
    public static List<Account> createAccounts(integer numberOfAccounts) {
        List<Account> accList = new List<Account>();
        Id recTypePersonal = AccountRecordTypeInfo .get('Business Account').getRecordTypeId();
        for(Integer i= 0; i<numberOfAccounts; i++){
            Account acc = new Account(Name='Account'+ string.valueOf(i + 1), RecordTypeId = recTypePersonal);
            accList.add(acc);
        }        
        return accList;
    }
    
    /**
    * @author Original: Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Create person account test record. 
    *               Person account auto creates child contact records.
    *               Created Account is coupled with this contact.
    * @param 
    */
    public static List<Account> createPersonAccounts(integer numberOfAccounts){
        List<Account> accList = new List<Account>();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        for(Integer i=0; i<numberOfAccounts; i++){
            Account acc = new Account(
                RecordTypeID=RecTypeId,
                FirstName='fname',
                LastName='lname',
                PersonMailingStreet='street',
                PersonMailingPostalCode='postal',
                PersonMailingCity='city',
                PersonEmail='testmail@ge.com',
                PersonHomePhone='homephone',
                PersonMobilePhone='mobilephone',
                PersonMailingState = 'state',
                PersonMailingCountry = 'country',
                CLV_Customer_Id__c = '14344'
            );
            accList.add(acc);
        }    
        return accList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Create opportunity test record
    * @param 
    */
    public static List<Opportunity> createOpportunities(integer numberOfOpportunities, Id accid) {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0; i<numberOfOpportunities; i++){
            Opportunity opp = new Opportunity(
                    StageName = 'New',
                    Name='Opp'+i,
                    AccountId = accid,
                    Branch_ID__c = '123',
                    Branch_Name__c = 'Branch' + string.valueOf(i + 1),
                    Branch_Postcode__c = '0000',
                    Branch_Suburb__c = 'Suburb',
                    Call_Type__c = 'Inbound Call',
                    Propensity_Score__c = 50,
                    CloseDate = Date.today(),
                    Live_Propensity_Score__c = 1
            );
            oppList.add(opp);
        }
        return oppList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create district test record
    * @param 
    */
    public static List<District__c> createDistirct(integer numberOfDistricts){
        List<District__c>districtList = new List<District__c>();
        for(Integer i=0; i<numberOfDistricts; i++){
            District__c districtVar = new District__c(
                    Name = 'District' + string.valueOf(i+1)
            );
            districtList.add(districtVar);
        }
        return districtList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create branch test record
    * @param 
    */
    public static List<Branch__c> createBranch(integer numberOfBranches){
        List<District__c> distList = createDistirct(1);
        District__c distVar = distList[0];
        insert distVar;
        
        List<Branch__c> branchList = new List<Branch__c>();
        for(Integer i=0; i<numberOfBranches; i++){
            Branch__c branchVar = new Branch__c(
                    Name = 'Branch' + string.ValueOf(i),
                    District__c = distVar.Id,
                    Branch_ID__c = '00' + string.ValueOf(i)
            );
            branchList.add(branchVar);
        }
        
        return branchList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create branch assignment test record
    * @param 
    */
    public static List<Branch_Assignment__c> createBranchAssignment(integer numberOfBA, List<Branch__c> branchIdList, Id usrIdVar, String recTypeStr){
        List<Branch_Assignment__c> baList = new List<Branch_Assignment__c>();
        for(Integer i=0; i<numberOfBA; i++){
            Branch_Assignment__c baVar = new Branch_Assignment__c(
                Branch__c = branchIdList[i].Id,
                User__c = usrIdVar,
                RecordTypeId = BranchAssignmentRecordType.get(recTypeStr).getRecordTypeId()
            );
            baList.add(baVar);
        }
        return baList;
    }
        
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create campaign assignment test record
    * @param 
    */
    public static List<Campaign_Assignment__c> createCampaignAssignment(integer numberOfCA, List<Campaign> campaignIdList, Id usrIdVar){
        List<Campaign_Assignment__c> caList = new List<Campaign_Assignment__c>();
        for(Integer i=0; i<numberOfCA; i++){
            Campaign_Assignment__c caVar = new Campaign_Assignment__c(
                Campaign__c = campaignIdList[i].Id,
                User__c = usrIdVar
            );
            caList.add(caVar);
        }
        return caList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create campaign test record
    * @param 
    */
    public static List<Campaign> createCampaign(integer numberOfCampaign){
        List<Campaign> campaignList = new List<Campaign>();
        for(Integer i=0; i<numberOfCampaign; i++){
            Campaign campaignVar = new Campaign(
                Name = 'Campaign' + string.ValueOf(i + 1),
                IsActive = true,
                StartDate = system.today(),
                EndDate = system.today(),
                Status = 'In Progress',
                Campaign_ID__c = '1001' + i
            );
            campaignList.add(campaignVar);
        }
        return campaignList;
    }

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description Create exception log
    * @param 
    */
    public static ExceptionLog__c createExceptionLog(String origin, String functionName, String objectName, String exceptionVar, String status, String params,Id recTypeId){
        ExceptionLog__c exceptionLogVar = new ExceptionLog__c(Origin__c =  origin,
                                                           Function_Name__c = functionName,
                                                           Object_Name__c = objectName,
                                                           Exception__c = exceptionVar,
                                                           Status__c = status,
                                                           Parameters__c = params,
                                                           Retry_Attempts__c = 2.0,
                                                           RecordTypeId = recTypeId);
        return exceptionLogVar;
    }// End createExceptionLog Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 14 May 2015
    * @description Create country iso custom setting
    * @param 
    */
    public static Country_Setting__c createCountrySetting(string name,string iso){
        Country_Setting__c counSetVar = new Country_Setting__c();
        counSetVar.name = name;
        counSetVar.Country_Name__c = name;
        counSetVar.Iso__c = iso;
        return counSetVar;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 02/12/13
    Description: Create Tasks
    */
    
    public static List<Task> createTasks(integer numberOfTasks) {
        List<Account> acct = createAccounts(1);
        insert acct;
        List<Opportunity> opp = createOpportunities(1, acct[0].id);
        insert opp;
        Opportunity o = [SELECT Id, OwnerId, Call_Type__c, Description, StageName FROM Opportunity WHERE Id =: opp[0].Id];
        List<Task> taskList = new List<Task>();
        for(Integer i=0; i<numberOfTasks; i++){
            Task tsk = new Task(
                whatID = o.ID,
                OwnerId = o.OwnerId,
                Subject = o.Call_Type__c,
                Description = o.Description,
                Call_Outcome__c = o.StageName
            );
            taskList.add(tsk);
        }
        return taskList;
    }
    
    public static List<Task> createTasks(integer numberOfTasks, Opportunity opp) {
        List<Task> taskList = new List<Task>();
        for(Integer i=0; i<numberOfTasks; i++){
            Task tsk = new Task(
                whatID = opp.ID,
                OwnerId = opp.OwnerId,
                Subject = opp.Call_Type__c,
                Description = opp.Description,
                Call_Outcome__c = opp.StageName
            );
            taskList.add(tsk);
        }
        return taskList;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 02/12/13
    Description: Create Events
    */
    
    public static List<Event> createEvents(integer numberOfEvents) {
        List<Account> acct = createAccounts(1);
        insert acct;
        List<Opportunity> opp = createOpportunities(1, acct[0].id);
        insert opp;
        Opportunity o = [SELECT Id, OwnerId, Call_Type__c, Description, StageName FROM Opportunity WHERE Id =: opp[0].Id];
        List<Event> eventList = new List<Event>();
        for(Integer i=0; i<numberOfEvents; i++){
            Event evnt = new Event(
                whatID = o.ID,
                OwnerId = o.OwnerId,
                Subject = o.Call_Type__c,
                Description = o.Description,
                DurationInMinutes = 10,
                ActivityDateTime = System.now()
            );
            eventList.add(evnt);
        }
        return eventList;
    }
    
    public static List<Event> createEvents(integer numberOfEvents, Opportunity opp) {
        List<Event> eventList = new List<Event>();
        for(Integer i=0; i<numberOfEvents; i++){
            Event evnt = new Event(
                whatID = opp.ID,
                OwnerId = opp.OwnerId,
                Subject = opp.Call_Type__c,
                Description = opp.Description,
                DurationInMinutes = 10,
                ActivityDateTime = System.now()
            );
            eventList.add(evnt);
        }
        return eventList;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 02/22/13
    Description: Create Postcode Exclusions
    */
    
    public static List<Postcode_Exclusion__c> createPostcodes(integer numberOfPostcodes){
        List<Postcode_Exclusion__c> postcodeList = new List<Postcode_Exclusion__c>();
        for(Integer i=0; i<numberofPostcodes; i++){
            Postcode_Exclusion__c pc = new Postcode_Exclusion__c(Postcode__c = '12345'+i);
            postcodeList.add(pc);
        }
        return postcodeList;
    }
    
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 03/04/13
    Description: Create Billing Vision Plus Record Instance
    */
    
    public static List<Billing_Vision_Plus__c> createBVision(integer numberOfBilling,String accIdStr){
        List<Billing_Vision_Plus__c> billList = new List<Billing_Vision_Plus__c>();
        for(Integer i=0; i<numberOfBilling; i++){
           Billing_Vision_Plus__c billVar = new Billing_Vision_Plus__c(Account__c = accIdStr);
           billList.add(billVar);
        }
        return billList;
    }
    
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 03/04/13
    Description: Create Billing Genesis Record Instance
    */
    
    public static List<Billing_Genesis__c> createBGenesis(integer numberOfBilling,String accIdStr){
        List<Billing_Genesis__c> billList = new List<Billing_Genesis__c>();
        for(Integer i=0; i<numberOfBilling; i++){
           Billing_Genesis__c billVar = new Billing_Genesis__c(Account__c = accIdStr);
           billList.add(billVar);
        }
        return billList;
    }
    
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 03/04/13
    Description: Create Billing ICBS Record Instance
    */
    
    public static List<Billing_ICBS__c> createBIcbs(integer numberOfBilling,String accIdStr){
        List<Billing_ICBS__c> billList = new List<Billing_ICBS__c>();
        for(Integer i=0; i<numberOfBilling; i++){
           Billing_ICBS__c billVar = new Billing_ICBS__c(Account__c = accIdStr);
           billList.add(billVar);
        }
        return billList;
    }
    
    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/06/13
    Description: Create Plans related to Billing Vision Plus
    */
    
    public static List<Plans__c> createPlans(integer numberOfPlans, String vPlusId){
        List<Plans__c> planList = new List<Plans__c>();
        for(Integer i=0; i<numberOfPlans; i++){
           Plans__c planVar = new Plans__c(Billing_Vision_Plus__c = vPlusId);
           planList.add(planVar);
        }
        return planList;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/25/2013
    Description: Create Application Response
    */
    
    public static Application_Response__c createApplicationResponse(Id appId){
           Application_Response__c appResponseVar = new Application_Response__c(Application__c = appId, Response_Code__c = 'PA', Response_Description__c = 'Partially Approved', Insurance_Eligibility_Flag_Applicant_1__c = 3, Insurance_Eligibility_Flag_Applicant_2__c = 3, Max_Capacity_Secured__c = 15000, Max_Capacity_Unsecured__c = 15000, Max_Monthly_Capacity__c = 15000, Credit_Score__c = 'A',UID__c='Test Id',Case_Manager_ID__c='Test Id',Min_Collateral_Amount__c = 10);
        return appResponseVar;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Applicant
    */
    public static Applicant__c createApplicant(Id accId, Id applicationId){
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
            applicant.Country_Pos__c = 'Australia';
            applicant.Country_Res__c = 'Australia';
            applicant.Country_Pre__c = 'Australia';
            applicant.State_Res__c = 'PARRAMATTA';
            applicant.State_Pos__c = 'PARRAMATTA';
            applicant.State_Pre__c = 'PARRAMATTA';
            applicant.Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)';
            applicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
        return applicant;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create PersonAccount
    */
    public static Account createPersonAccount(){
        RecordType personAccountRecordType = [SELECT Id FROM RecordType where DeveloperName = 'Originations' AND SObjectType = 'Account' LIMIT 1];
        Account account = new Account();
        account.RecordTypeId = personAccountRecordType.Id;
        account.FirstName = 'Test';
        account.LastName = 'PersonAccount';
        return account;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Application
    */
    public static Application__c createApplication(){
        //BEGIN - RCADAPAN 04-FEB-2016 - ADD NEW VALUE FOR Branch Locator
        Admin_Settings__c tomSetting = new Admin_Settings__c();
        tomSetting.Name = 'TOM Enabled';
        tomSetting.Value__c = 'FALSE';
        insert tomSetting;
        //END - RCADAPAN 04-FEB-2016
        
        Application__c application = new Application__c();
        application.Payment_Frequency__c = 'Weekly';
        application.Case_Manager_Id__c = '0916185395213';
        application.Loan_Term_Months__c = 24;
        application.Loan_Insurance_Consent__c = true;
        application.Interested_in_other_services__c = true;
        application.Application_type__c = 'Single';
        application.Total_Loan_Amount__c = 1000;
        application.Offered_Interest_Rate__c = 12;
        //application.Offered_Repayments__c = 1000;
        //application.Total_Insurance_Premium__c = 200;
        application.Response_Code__c = 'PA';
        application.Generated_Doc_Confirm_Sent__c = false;
        application.Offered_Monthly_Loan_Service_Fee__c = 50;
        //application.Adjusted_Interest_Rate__c = 50;
        application.Application_Source__c = 'CUSTOMER REFERRAL';
        application.Channel__c = 'Online';
        application.Last_Submit_Date__c = System.now();
        application.Submission_Status__c = 'Not Submitted';
        application.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;     //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        return application;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Product Version
    */
    public static Product_Version__c createProductVersion(Id prodId){
        Product_Version__c productVersion = new Product_Version__c();
        //productVersion.End_Date__c = Datetime.now().addYears(2);
        //productVersion.Start_Date__c = Datetime.now();
        productVersion.GEProduct__c = prodId;
        return productVersion;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Income
    */
    public static Income__c createIncome(Id appId){
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income.Occupation__c = 'Developer';
        income.Emp_Bus_Name__c = 'GlobalOne';
        income.Emp_Bus_Contact_No__c = '0234567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        return income;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create ONR
    */
    public static ONR__c createObjectivesAndRequirements(Id appId, Id rTypeId){
        ONR__c objective = new ONR__c();
        objective.RecordTypeId = rTypeId;
        objective.Application__c = appId;
        objective.Type__c =  'Table';
        objective.geID__c = '/personal/need/purposeTable';
        return objective;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Loan Purpose
    */
    public static Loan_Purpose__c createLoanPurpose(Id appId, Id onrId){
        Loan_Purpose__c LoanPurpose = new Loan_Purpose__c();
        LoanPurpose.Application__c = appId;
        LoanPurpose.ONR__c = onrId;
        LoanPurpose.Loan_Amount__c = 5000;
        LoanPurpose.Value__c = 'Car purchase';
        return LoanPurpose;
    }

    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Loan Purpose with Value
    */
    public static Loan_Purpose__c createLoanPurpose(Id appId, Id onrId, String sValue){
        Loan_Purpose__c LoanPurpose = new Loan_Purpose__c();
        LoanPurpose.Application__c = appId;
        LoanPurpose.ONR__c = onrId;
        LoanPurpose.Loan_Amount__c = 5000;
        LoanPurpose.Value__c = sValue;
        return LoanPurpose;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Loan Purpose
    */
    public static Loan_Purpose__c createLoanPurpose2(Id appId, Id onrId){
        Loan_Purpose__c LoanPurpose = new Loan_Purpose__c();
        LoanPurpose.Application__c = appId;
        LoanPurpose.ONR__c = onrId;        
        LoanPurpose.Value__c = 'Other';
        LoanPurpose.Other_Loan_Purpose__c = '';
        return LoanPurpose;
    }
    /*
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Asset
    */
    public static Asset__c createAsset(Id appId){
        RecordType assetRecordType =  [SELECT Id FROM RecordType Where Name = 'AU' AND SObjectType = 'Asset__c' LIMIT 1];
        Asset__c asset = new Asset__c();
        asset.Applicant__c = appId;
        asset.RecordTypeId = assetRecordType.Id;
        asset.Asset_Category__c = 'Car';
        asset.Asset_Value__c = 10000;
        asset.Vehicle_make__c = 'Mistubishi';
        asset.Vehicle_model__c = 'Lancer';
        asset.Vehicle_year__c = '2013';
        asset.Ownership_Status__c = 'Own outright';
        asset.Total_Assets__c = 1000000;
        asset.of_ownership_of_the_asset__c = 1000;
        asset.Asset_Shared__c = true;
        return asset;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Expense
    */
    public static Expense__c createExpense(Id appId){
        Expense__c expense = new Expense__c();
        expense.Applicant__c = appId;
        //expense.I_Pay_All_Exp__c = true;
        expense.Living_Exp__c = 1234567;
        expense.Living_Exp_Int__c = 'Week';
        expense.Rent_Board_Pay_Amt__c = 1000;
        expense.Rent_Board_Pay_Int__c  = 'Week';
        expense.Total_Exp__c = 10000;
        expense.Agent_Landlord_Name__c = 'Test';
        expense.Agent_Landlord_Phone_Number__c = '0412341234';
        return expense;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create Liability
    */
    public static Liability__c createCardLiability(Id appId){
        RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'AU'  AND SObjectType = 'Liability__c' LIMIT 1];
        Liability__c liability = new Liability__c();
        liability.Applicant__c = appId;
        liability.Debt_Category__c = 'Credit card';
        liability.RecordTypeId = liabilityRecordType.Id;
        liability.Financier_Name__c = 'Sample Financier';
        liability.Credit_Limit_Amt__c = 15000;
        liability.Card_Overdraft_Bal_Amt__c = 15000;
        liability.Total_Debts__c = liability.Card_Overdraft_Bal_Amt__c;
        return liability;
    }
    public static Liability__c createLoanLiability(Id appId){
        RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'AU'  AND SObjectType = 'Liability__c' LIMIT 1];
        Liability__c liability = new Liability__c();
        liability.Applicant__c = appId;
        liability.Debt_Category__c = 'Personal loan';
        liability.RecordTypeId = liabilityRecordType.Id;
        liability.Financier_Name__c = 'Sample Financier';
        liability.Car_Personal_Bal_Amt__c = 15000;
        liability.Car_Personal_Borrowed_Amt__c = 15000;
        liability.Car_Personal_Repay_Amt__c = 15000;
        liability.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        liability.Total_Debts__c = liability.Car_Personal_Bal_Amt__c;
        return liability;
    }
    public static Liability__c createOtherLiability(Id appId){
        RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'AU'  AND SObjectType = 'Liability__c' LIMIT 1];
        Liability__c liability = new Liability__c();
        liability.Applicant__c = appId;
        liability.Debt_Category__c = 'Other';
        liability.RecordTypeId = liabilityRecordType.Id;
        liability.Financier_Name__c = 'Sample Financier';
        liability.Other_Repay_Amt__c = 15000;
        liability.Car_Personal_Borrowed_Amt__c = 15000;
        liability.Other_Borrowed_Amt__c = 15000;
        liability.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        liability.Total_Debts__c = liability.Other_Repay_Amt__c;
        return liability;
    }
    public static Liability__c createOverdraftLiability(Id appId){
        RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'AU'  AND SObjectType = 'Liability__c' LIMIT 1];
        Liability__c liability = new Liability__c();
        liability.Applicant__c = appId;
        liability.Debt_Category__c = 'Overdraft';
        liability.RecordTypeId = liabilityRecordType.Id;
        liability.Financier_Name__c = 'Sample Financier';
        liability.Card_Overdraft_Bal_Amt__c = 15000;
        liability.Credit_Limit_Amt__c = 15000;
        liability.Overdraft_APR__c = 10;
        liability.Total_Debts__c = liability.Card_Overdraft_Bal_Amt__c;
        return liability;
    }
    /*
    Author: Dan Crisologo Cloud Sherpas
    Created Date: 09/26/2013
    Description: Create LiabilityMortgage
    */
    public static Liability__c createLiabilityMortgage(Id appId){
        RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'AU'  AND SObjectType = 'Liability__c' LIMIT 1];
        Liability__c liability = new Liability__c();
        liability.Applicant__c = appId;
        liability.Debt_Category__c = 'Mortgage';
        liability.Financier_Name__c = 'Sample Financier';
        liability.RecordTypeId = liabilityRecordType.Id;
        liability.Mortgage_Bal_Amt__c = 10000;
        liability.Mortgage_Borrowed_Amt__c = 50;
        liability.Mortgage_Repayment_Amt__c = 100;
        liability.Total_Debts__c = 1000;
        return liability;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 10/08/2013
    Description: Create Brand
    */
    public static Brand__c createBrand(){
        Brand__c Brand = new Brand__c();
        Brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;      //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        Brand.External_ID__c = '1';
        Brand.URL_Key__c = '1234';
        Brand.Country__c = 'AU';
        brand.Loan_Term__c='{1 year;2 year;6 Months}';
        brand.Brand_Template_Name__c = 'Branch';
        return Brand;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 10/08/2013
    Description: Create GEPRoduct
    */
    public static GEProduct__c createGEProduct(Id BrandId){
        GEProduct__c product = new GEProduct__c();
        product.Brands__c = BrandId;
        product.Name = 'Sample Loan Product';
        product.Type__c = 'Personal Loan';
        return product;
    }

    public static GEProduct__c createGEProduct(Id BrandId, String sType){
        GEProduct__c product = new GEProduct__c();
        product.Brands__c = BrandId;
        product.Name = 'Sample Loan Product';
        product.Type__c = sType;
        return product;
    }

    public static GEProduct__c createGEProduct(Id BrandId, String sType, String sProductName){
        GEProduct__c product = new GEProduct__c();
        product.Brands__c = BrandId;
        product.Name = sProductName;
        product.Type__c = sType;
        return product;
    }
    
    
    public static Product_Item__c createProductItem(Id appId, Id prodVerId){
        Product_Item__c productItem = new Product_Item__c();
        productItem.Application__c = appId;
        productItem.Product_Version__c = prodVerId;
        productItem.Rate__c = 100;
        productItem.Repayment__c = 12;
        productItem.Repayment_Period__c = '1 years';
        return productItem;
    }

    public static Meta_ONR__c createMetaONR(){
        Meta_ONR__c onr = new Meta_ONR__c();
        onr.geID__c = '/personal/need/openToOtherProduct';
        onr.ONR_Type__c = 'General';
        onr.Prompt__c = 'Test';
        onr.Type__c = 'YesOrNo';
        onr.Value__c = 'Test';
        return onr;
    }
    public static list<Meta_ONR__c> createMetaONRLoanPurpose(){
        Meta_ONR__c onr = new Meta_ONR__c();
        onr.geID__c = '/personal/need/openToOtherProduct';
        onr.ONR_Type__c = 'Loan Purpose';
        onr.Prompt__c = 'Test';
        onr.Type__c = 'Choice';
        onr.Value__c = 'Other';
        onr.region__c='NZ';
        Meta_ONR__c onr1 = new Meta_ONR__c();
        onr1.geID__c = '/personal/need/openToOtherProduct';
        onr1.ONR_Type__c = 'Loan Purpose';
        onr1.Prompt__c = 'Test';
        onr1.Type__c = 'Choice';
        onr1.Value__c = 'Housing';
        onr1.region__c='AU';
        Meta_ONR__c onr2 = new Meta_ONR__c();
        onr2.geID__c = '/personal/need/openToOtherProduct';
        onr2.ONR_Type__c = 'Loan Purpose';
        onr2.Prompt__c = 'Test';
        onr2.Type__c = 'Choice';
        onr2.Value__c = 'Car Loan';
        onr2.region__c='NZ';
        list<Meta_ONR__c> lstOnr=new list<Meta_ONR__c>();
        lstOnr.add(onr);
        lstOnr.add(onr1);
        lstOnr.add(onr2);
        return lstOnr;
    }
    public static Meta_ONR__c createMetaONRLoanPurposeRef(){
        Meta_ONR__c onr = new Meta_ONR__c();
        onr.geID__c = '/personal/need/openToOtherProduct';
        onr.ONR_Type__c = 'Loan Purpose';
        onr.Prompt__c = 'Test';
        onr.Type__c = 'Choice';
        onr.Value__c = 'Refinance';
        onr.region__c='AU';
        return onr;
    }
    public static AML__c createAML(Id applicantId){
        AML__c aml = new AML__c();
        aml.Applicant__c = applicantId;
        aml.Staff_ID_SSO__c = '1';
        aml.Date_Verified__c = Date.today();
        aml.ID_Expiry_Date__c = Date.today();
        aml.ID_No__c = '1';
        return aml;
    }
    public static Offer_Presented__c createOfferPresented(Id offerId, Id appResId){
        Offer_Presented__c offerPresented = new Offer_Presented__c();
        offerPresented.Offer__c = offerId;
        offerPresented.Application_Response__c = appResId;
        offerPresented.Accepted__c = true;
        offerPresented.Time_Accepted__c = DateTime.Now();
        return offerPresented;
    }
    public static Offer__c createOffer(Id prodId, String type, Id recordTypeId){
        Offer__c offer = new Offer__c();
        offer.Debt_Category__c = 'Card';
        offer.External_Id__c = '123Id';
        offer.Offer_Name__c = 'Sample Offer';
        offer.Product__c = prodId;
        offer.Type__c = type;
        offer.UI_Text__c = 'This is a sample offer only for test classes purposes.';
        offer.recordTypeId = recordTypeId;
        return offer;
    }
    public static Rule_Set__c createRuleSet(Id prodVersion){
        Rule_Set__c ruleSet = new Rule_Set__c();
        ruleSet.End_Date__c = DateTime.now();
        ruleSet.External_Id__c = '123Test';
        ruleSet.Maximum_Product_Offers__c = 1;
        ruleSet.Maximum_Restructure_Offers__c = 1;
        ruleSet.Maximum_Total_Offers__c = 1;
        ruleSet.Product_Version__c = prodVersion;
        ruleSet.Rule_Set_Name__c = 'Sample rule Set';
        ruleset.Start_Date__c = DateTime.now();
        ruleset.Type__c = 'Offers';
        return ruleSet;
    }
    public static Rule_Set__c createPricingRuleSet(Id prodVersion){
        Rule_Set__c ruleSet = new Rule_Set__c();
        ruleSet.End_Date__c = DateTime.now();
        ruleSet.External_Id__c = '123Test';
        ruleSet.Maximum_Product_Offers__c = 1;
        ruleSet.Maximum_Restructure_Offers__c = 1;
        ruleSet.Maximum_Total_Offers__c = 1;
        ruleSet.Product_Version__c = prodVersion;
        ruleSet.Rule_Set_Name__c = 'Sample rule Set';
        ruleset.Start_Date__c = DateTime.now();
        ruleset.Type__c = 'Pricing';
        return ruleSet;
    }

    public static Rule__c createRule1(Id offerId, Id ruleSetId){
        Rule__c rule = new Rule__c();
        rule.External_Id__c = '123test';
        rule.IsActive__c = true;
        rule.Offer__c = offerId;
        rule.Order__c = 1;
        rule.Rule_Set__c = ruleSetId;
        rule.stopOtherRulesIfPass__c = true;
        return rule;
    }
    public static Rule__c createRule2(Id offerId, Id ruleSetId){
        Rule__c rule = new Rule__c();
        rule.External_Id__c = '123test';
        rule.IsActive__c = true;
        rule.Offer__c = offerId;
        rule.Order__c = 2;
        rule.Rule_Set__c = ruleSetId;
        rule.stopOtherRulesIfPass__c = true;
        return rule;
    }

    /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create Applicant Search record
    */
    public static Applicant_Search__c appSearch(){
        String d = '1/31/2014';
        Applicant_Search__c apsearch    = new Applicant_Search__c();
        apsearch.Account_Number__c      = '12345';
        apsearch.Date_Of_Birth__c       = d;
        apsearch.Post_Code__c           = '1302';
        apsearch.Previous_Postcode__c   = '1033';
        apsearch.Mobile_Phone__c        = '0412345678';
        apsearch.Drivers_License__c     = 'AB2C3E4F5';
        return apsearch;
    }
    
    /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create Applicant CLV records
    */ 
    public static List<Applicant_CLV__c> applicantCLVList(Id appSearchId, Id applicantId){
        List<Applicant_CLV__c> appCLVList = new List<Applicant_CLV__c>(); 
        String d = '1/31/2014';
        for(Integer i=0; i<3; i++){
           Applicant_CLV__c appCLV = new Applicant_CLV__c(Applicant_Search__c = appSearchId, CLV__c = '123' + i, Date_of_Birth__c = d,
                                    Drivers_License__c = 'AB2C3E4F5', First_Name__c='George', Surname__c='Paul', Suburb__c='Burnley', 
                                    Home__c='0212345678', Mobile__c='041235678', Title__c='Mrs', GE_Contact_ID__c='1885721045', 
                                    ICBS_Customer_ID__c='2147483647' + i, Middle_Name__c='Late', Applicant__c = applicantId, Applicant_Bucket__c = '1');
           appCLVList.add(appCLV);
        }
        return appCLVList;
    }

     /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create Applicant CLV records
    */
    public static Applicant_CLV__c createApplicantCLV(Id appSearchId, Id applicantId){
        String d = '1/31/2014';
        Applicant_CLV__c appCLV = new Applicant_CLV__c();
        appCLV.Applicant_Search__c = appSearchId; 
        appCLV.CLV__c = '123'; 
        appCLV.Date_of_Birth__c = d;
        appCLV.Drivers_License__c = 'AB2C3E4F5'; 
        appCLV.First_Name__c='George';
        appCLV.Surname__c='Paul';
        appCLV.Suburb__c='Burnley'; 
        appCLV.Home__c='0212345678'; 
        appCLV.Mobile__c='041235678'; 
        appCLV.Title__c='Mrs';
        appCLV.GE_Contact_ID__c='1885721045';
        appCLV.ICBS_Customer_ID__c='2147483647'; 
        appCLV.Middle_Name__c='Late';
        appCLV.Applicant__c = applicantId; 
        appCLV.Applicant_Bucket__c = '1';
        return appCLV;
    }
    
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create CustomSetting Insurance Premium
    */
    public static Insurance_Premium_Calculation_Variables__c createInsurancePremium(){
        Insurance_Premium_Calculation_Variables__c insurance = new Insurance_Premium_Calculation_Variables__c();
        insurance.Name = 'counter';
        insurance.Description__c = 'This is a sample insurance premium only.';
        insurance.Value__c = 15.000;
        return insurance;
    }

    /*
    Author: Jade Serrano Cloud Sherpas
    Created Date: 03-MAR-2014
    Description: Create Custom Setting Insurance Premium Calculation Variables
    */
    public static List<Insurance_Premium_Calculation_Variables__c> createInsurancePremiumCalculationVariables(){
        
        List<Insurance_Premium_Calculation_Variables__c> insurancePremiumCalculationVariablesList = new List<Insurance_Premium_Calculation_Variables__c>();
        
        Insurance_Premium_Calculation_Variables__c i = new Insurance_Premium_Calculation_Variables__c();
        i.Name = 'counter';
        i.Description__c = 'description';
        i.Value__c = 15;
        insurancePremiumCalculationVariablesList.add(i);

        Insurance_Premium_Calculation_Variables__c i2 = new Insurance_Premium_Calculation_Variables__c();
        i2.Name = 'disabFee';
        i2.Description__c = 'description';
        i2.Value__c = 45;
        insurancePremiumCalculationVariablesList.add(i2);

        Insurance_Premium_Calculation_Variables__c i3 = new Insurance_Premium_Calculation_Variables__c();
        i3.Name = 'disabGst';
        i3.Description__c = 'description';
        i3.Value__c = 0.1;
        insurancePremiumCalculationVariablesList.add(i3);

        Insurance_Premium_Calculation_Variables__c i4 = new Insurance_Premium_Calculation_Variables__c();
        i4.Name = 'disabJoint';
        i4.Description__c = 'description';
        i4.Value__c = 1.8;
        insurancePremiumCalculationVariablesList.add(i4);

        Insurance_Premium_Calculation_Variables__c i5 = new Insurance_Premium_Calculation_Variables__c();
        i5.Name = 'iuiFee';
        i5.Description__c = 'description';
        i5.Value__c = 13;
        insurancePremiumCalculationVariablesList.add(i5);

        Insurance_Premium_Calculation_Variables__c i6 = new Insurance_Premium_Calculation_Variables__c();
        i6.Name = 'iuiGst';
        i6.Description__c = 'description';
        i6.Value__c = 0.1;
        insurancePremiumCalculationVariablesList.add(i6);

        Insurance_Premium_Calculation_Variables__c i7 = new Insurance_Premium_Calculation_Variables__c();
        i7.Name = 'lifeInsPremRate';
        i7.Description__c = 'description';
        i7.Value__c = 0.0136;
        insurancePremiumCalculationVariablesList.add(i7);

        Insurance_Premium_Calculation_Variables__c i8 = new Insurance_Premium_Calculation_Variables__c();
        i8.Name = 'lifeJoint';
        i8.Description__c = 'description';
        i8.Value__c = 1.6;
        insurancePremiumCalculationVariablesList.add(i8);

        Insurance_Premium_Calculation_Variables__c i9 = new Insurance_Premium_Calculation_Variables__c();
        i9.Name = 'maxMonthlyEmi';
        i9.Description__c = 'description';
        i9.Value__c = 1500.0000;
        insurancePremiumCalculationVariablesList.add(i9);

        Insurance_Premium_Calculation_Variables__c i10 = new Insurance_Premium_Calculation_Variables__c();
        i10.Name = 'maxPrincipal';
        i10.Description__c = 'description';
        i10.Value__c = 100000.0000;
        insurancePremiumCalculationVariablesList.add(i10);

        Insurance_Premium_Calculation_Variables__c i11 = new Insurance_Premium_Calculation_Variables__c();
        i11.Name = 'lifeSplitCoverNZ';
        i11.Description__c = 'description';
        i11.Value__c = 0.20;
        insurancePremiumCalculationVariablesList.add(i11);

        Insurance_Premium_Calculation_Variables__c i12 = new Insurance_Premium_Calculation_Variables__c();
        i12.Name = 'disabilitySplitCoverNZ';
        i12.Description__c = 'description';
        i12.Value__c = 0.45;
        insurancePremiumCalculationVariablesList.add(i12);

        Insurance_Premium_Calculation_Variables__c i13 = new Insurance_Premium_Calculation_Variables__c();
        i13.Name = 'iuiSplitCoverNZ';
        i13.Description__c = 'description';
        i13.Value__c = 0.35;
        insurancePremiumCalculationVariablesList.add(i13);

        Insurance_Premium_Calculation_Variables__c i14 = new Insurance_Premium_Calculation_Variables__c();
        i14.Name = 'jointCoverRateMultiplierNZ';
        i14.Description__c = 'description';
        i14.Value__c = 1.6;
        insurancePremiumCalculationVariablesList.add(i14);

        Insurance_Premium_Calculation_Variables__c i15 = new Insurance_Premium_Calculation_Variables__c();
        i15.Name = 'nZRepaymentMaxCoverAmt';
        i15.Description__c = 'description';
        i15.Value__c = 50000;
        insurancePremiumCalculationVariablesList.add(i15);

        Insurance_Premium_Calculation_Variables__c i16 = new Insurance_Premium_Calculation_Variables__c();
        i16.Name = 'gstRateNZ';
        i16.Description__c = 'description';
        i16.Value__c = 15;
        insurancePremiumCalculationVariablesList.add(i16);


        return insurancePremiumCalculationVariablesList;

    }

    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create Response Code Control Custom Setting
    */
    public static Response_Code_Control__c createResponseCodeControlPA(){
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PAO';
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
        return responseCodeControl;
    }
    /*
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/05/2013
    Description: Create Response Code Control Custom Setting
    */
    public static Response_Code_Control__c createResponseCodeControlPCO(){
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PCO';
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
        return responseCodeControl;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/09/2013
    Description: Create Workflow
    */
    public static Workflow__c createWorkflow(Id appId, Id userId, Id rtId){
        Workflow__c workflow = new Workflow__c();
        workflow.RecordTypeId = rtId;
        workflow.Risk_Max_UnSecured_Amount__c = 15000;
        workflow.Risk_Max_Secured_Amount__c = 15000;
        workflow.Max_Term__c = 2;
        workflow.Application__c = appId;
        workflow.Assigned_To_1__c = userId;
        workflow.Risk_CPU_Decision__c = 'Approve';
        workflow.Risk_Collateral__c = 10000;
        return workflow;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/09/2013
    Description: Create Group
    */
    public static Group createGroup(){
        Group testGroup = new Group();
        testGroup.Name = 'Sample Public Group';
        testGroup.DeveloperName = 'SamplePublicGroup';
        return testGroup;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/09/2013
    Description: Create Brand Assignment
    */
    public static Brand_Assignment__c createBrandAssignment(Id userId, Id brandId){
        Brand_Assignment__c brandAssignment = new Brand_Assignment__c();
        brandAssignment.User__c = userId;
        brandAssignment.Brand__c = brandId;
        return brandAssignment;
    }

    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/09/2013
    Description: Create User
    */
    public static User createUser(Id profileId){
        User testUser = new User();
        testUser.FirstName = 'Test';
        testUser.LastName = 'User';
        testUser.Alias = 'TestA';
        testUser.Email = 'TestEmail@ge.com';
        testUser.Username = 'Dummy@cloudsherpas.com';
        testUser.CommunityNickname = 'Test Nickname';
        testUser.ProfileId = profileId;
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey ='UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        //Added by Txu
        testUser.UserRoleId = [SELECT ID FROM UserRole WHERE name = 'System Administrator'].id;
        return testUser;
    }
    
    /*
    Description: Create Broker Portal User
    */
    public static User createBrokerPortalUser(Id contactId,Id profileId){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User testUser = new User();
        testUser.FirstName = 'John';
        testUser.LastName = 'Broker';
        testUser.UserRoleId = portalRole.Id;
        testUser.Alias = 'JohnB';
        testUser.Email = 'testBroker@test.com';
        testUser.Username = 'testBroker@test.com';
        testUser.CommunityNickname = 'John';
        testUser.ProfileId = profileId;
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey ='UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.ContactId = contactId;
        return testUser;
    }

    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 2/25/2014
    Description: Create Another User
    */
    public static User createUser2(Id profileId){
        User testUser = new User();
        testUser.FirstName = 'Test2';
        testUser.LastName = 'User2';
        testUser.First_Name__c = 'Test2';
        testUser.Last_Name__c = 'User2';
        testUser.Email__c = 'TestEmail2@ge.com';
        testUser.Alias = 'TestA2';
        testUser.Email = 'TestEmail2@ge.com';
        testUser.Username = 'Dummy2@cloudsherpas.com';
        testUser.CommunityNickname = 'Test Nickname2';
        testUser.ProfileId = profileId;
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey ='UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        return testUser;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 12/09/2013
    Description: Create GroupMember
    */
    public static GroupMember createGroupMember(Id groupId, Id userId){
        GroupMember testGroupMember = new GroupMember();
        testGroupMember.UserOrGroupId = userId;
        testGroupMember.GroupId = groupId;
        return testGroupMember;
    }

    /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 12/09/2013 
    Description: Create Admin Settings Record
    */
    public static List<Admin_Settings__c> adminSet(){
        List<Admin_Settings__c> admin2List = new List<Admin_Settings__c>();
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'Application';
        as1.Value__c = 'Application__c';
        admin2List.add(as1);

        Admin_Settings__c as2 = new Admin_Settings__c();
        as2.Name = 'Application Response';
        as2.Value__c = 'Application_Reponse__c';
        admin2List.add(as2);

        Admin_Settings__c as3 = new Admin_Settings__c();
        as3.Name = 'Communities URL';
        as3.Value__c = 'https://origdev-customer.cs5.force.com/customer';
        admin2List.add(as3);

        Admin_Settings__c as4 = new Admin_Settings__c();
        as4.Name = 'Inactivity';
        as4.Value__c = '90';
        admin2List.add(as4);  

        Admin_Settings__c as5 = new Admin_Settings__c();
        as5.Name = 'Liability';
        as5.Value__c = 'Liability__c';
        admin2List.add(as5); 
 
        Admin_Settings__c as6 = new Admin_Settings__c();
        as6.Name = 'Omniture Source';
        as6.Value__c = '//nexus.ensighten.com/gecapitalau/dev/Bootstrap.js';
        admin2List.add(as6); 

        Admin_Settings__c as7 = new Admin_Settings__c();
        as7.Name = 'Online Branch';
        as7.Value__c = 'a0AO0000008pqiPv';
        admin2List.add(as7); 

        Admin_Settings__c as8 = new Admin_Settings__c();
        as8.Name = 'Plan Delete Batch Size';
        as8.Value__c = '500';
        admin2List.add(as8); 

        Admin_Settings__c as9 = new Admin_Settings__c();
        as9.Name = 'Plan Delete Query Size';
        as9.Value__c = '-1';
        admin2List.add(as9); 

        Admin_Settings__c as10 = new Admin_Settings__c();
        as10.Name = 'Search';
        as10.Value__c = '60';
        admin2List.add(as10); 

        Admin_Settings__c as11 = new Admin_Settings__c();
        as11.Name = 'SearchTimeOut';
        as11.Value__c = '45';
        admin2List.add(as11);     

        Admin_Settings__c as12 = new Admin_Settings__c();
        as12.Name = 'Timeout';
        as12.Value__c = '900';
        admin2List.add(as12);                                                       

        Admin_Settings__c as13 = new Admin_Settings__c();
        as13.Name = 'Warning';
        as13.Value__c = '600';
        admin2List.add(as13);

        Admin_Settings__c as14 = new Admin_Settings__c();
        as14.Name = 'Net Monthly Income Value';
        as14.Value__c = '800';
        admin2List.add(as14);

        Admin_Settings__c as15 = new Admin_Settings__c();
        as15.Name = 'Net Monthly Income Multiplier';
        as15.Value__c = '1';
        admin2List.add(as15);
        
        Admin_Settings__c as16 = new Admin_Settings__c();
        as16.Name = 'Online Branch Kiwibank';
        as16.Value__c = '1';
        admin2List.add(as16);

        //BEGIN - DYU 13-AUG-2015 - ADD NEW VALUE FOR LIABILITY MESSAGE
        Admin_Settings__c as17 = new Admin_Settings__c();
        as17.Name = 'Liability Warning';
        as17.Value__c = 'Test';
        admin2List.add(as17);
        //END - DYU 13-AUG-2015 
        
        //BEGIN - RCADAPAN 04-FEB-2016 - ADD NEW VALUE FOR Branch Locator
        Admin_Settings__c as18 = new Admin_Settings__c();
        as18.Name = 'Branch Locator';
        as18.Value__c = 'Branch Locator';
        admin2List.add(as18);
        //END - RCADAPAN 04-FEB-2016

        //BEGIN - RCADAPAN 04-FEB-2016 - ADD NEW VALUE FOR Branch Locator
        Admin_Settings__c as19 = new Admin_Settings__c();
        as19.Name = 'TOM Enabled';
        as19.Value__c = 'FALSE';
        admin2List.add(as19);
        //END - RCADAPAN 04-FEB-2016
        
         //BEGIN - Softquote changes
        Admin_Settings__c as20 = new Admin_Settings__c();
        as20.Name = 'Enable Soft Quote NZ';
        as20.Value__c = 'True';
        admin2List.add(as20);
        //END  - Softquote changes
        
         //BEGIN - Softquote changes
        Admin_Settings__c as21 = new Admin_Settings__c();
        as21.Name = 'Enable Soft Quote AU';
        as21.Value__c = 'True';
        admin2List.add(as21);
        //END  - Softquote changes
        
        return admin2List;       
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Create Compliance Check Record
    */
    public static Compliance_Check__c  createComplianceCheck(Id applicationId){
        Compliance_Check__c compliance = new Compliance_Check__c();
        compliance.Application__c = applicationId;
        compliance.BM_Check__c = 'Yes';
        compliance.BM_ID__c = 'BMUser123';
        compliance.BM_Only__c = true;
        compliance.PFR_Date__c = Date.today();
        compliance.BM_Date__c = Date.Today();
        compliance.PFR_Check__c = 'Yes';
        compliance.PFR_ID__c = 'SamplePFR123';
        compliance.PFR_Only__c = true;
        compliance.PFR_User_ID__c = 'PFRUser123';
        return compliance;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Create Collateral Record
    */
    public static Collateral__c createCollateral(Id applicationId){
        Collateral__c collateral = new Collateral__c();
        collateral.Application__c = applicationId;
        collateral.Collateral_Type__c = 'Auto';
        collateral.Collateral_Make__c = 'ASIA';
        collateral.Collateral_Model__c = 'ModelTest';
        collateral.Collateral_Year__c = String.valueOf(Date.Today().Year()-1);
        collateral.Collateral_Reg_No__c = 'R1231';
        collateral.Collateral_VIN_No__c = 'V1231';
        collateral.Collateral_Eng_No__c = 'E1231';
        collateral.Collateral_Val__c = 12345;
        collateral.Collateral_HIN_Number__c = 'H1231';
        //collateral.Collateral_Ownership_Status__c = true;
        collateral.Collateral_State_of_Registration__c = 'VICTORIA';
        collateral.Collateral_Insurance_expiry_date__c = Date.Today()+1;
        collateral.Collateral_Date_Valued__c = Date.Today();
        collateral.Collateral_Total_Value__c = 1234567;
        collateral.Collateral_Insurance_Policy_number__c = 'P1234';
        collateral.Collateral_Insurance_company_name__c = 'Insurance Co.';
        collateral.Collateral_NVIC__c = 'NVIC123';
        collateral.Collateral_Body_Type__c = 'BOAT';
        return collateral;
    }

    /*
    Author: Jerome To Cloud Sherpas
    Created Date: 06 MAY 2015
    Description: Create Collateral Record
    */
    public static Collateral__c createCollateral(Id applicationId, Id recordTypeId){
        Collateral__c collateral = new Collateral__c();
        collateral.Application__c = applicationId;
        collateral.Collateral_Type__c = 'Auto';
        collateral.Collateral_Make__c = 'ASIA';
        collateral.Collateral_Model__c = 'ModelTest';
        collateral.Collateral_Year__c = String.valueOf(Date.Today().Year()-1);
        collateral.Collateral_Reg_No__c = 'R1231';
        collateral.Collateral_VIN_No__c = 'V1231';
        collateral.Collateral_Eng_No__c = 'E1231';
        collateral.Collateral_Val__c = 12345;
        collateral.Collateral_HIN_Number__c = 'H1231';
        //collateral.Collateral_Ownership_Status__c = true;
        collateral.Collateral_State_of_Registration__c = 'VICTORIA';
        collateral.Collateral_Insurance_expiry_date__c = Date.Today()+1;
        collateral.Collateral_Date_Valued__c = Date.Today();
        collateral.Collateral_Total_Value__c = 1234567;
        collateral.Collateral_Insurance_Policy_number__c = 'P1234';
        collateral.Collateral_Insurance_company_name__c = 'Insurance Co.';
        collateral.Collateral_NVIC__c = 'NVIC123';
        collateral.Collateral_Body_Type__c = 'BOAT';
        collateral.RecordTypeId = recordTypeId;
        return collateral;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Create Collateral Custom Setting Record
    */
    public static Collateral_Settings__c createCollateralSetting(){
        Collateral_Settings__c collateralSetting = new Collateral_Settings__c();
        collateralSetting.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;      //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        collateralSetting.Collateral_Maximum_Items__c = 1.0;
        collateralSetting.Collateral_Maximum_Value__c = 120000.0;
        collateralSetting.Collateral_Minimum_Value__c = 100.0;
        collateralSetting.Collateral_New_Age__c = 20.0;
        return collateralSetting;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Create Collateral Custom Setting Record
    */
    public static Credit_File_Check__c createCreditFileCheck(Id appId, Id applicationId){
        Credit_File_Check__c CreditFielCheck = new Credit_File_Check__c();
        CreditFielCheck.Address_Discrepancy__c = true;
        CreditFielCheck.Comments__c = 'This is a sample credit file check only';
        CreditFielCheck.DOB_Discrepancy__c = true;
        CreditFielCheck.DOB_Pass__c = true;
        CreditFielCheck.Applicant__c = appId;
        CreditFielCheck.Application__c = applicationId;
        return CreditFielCheck;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/28/2014
    Description: Create Web service setting Record
    */
    public static Datatools__c createDatatools(){
        Datatools__c dataTool = new Datatools__c();
        dataTool.Endpoint__c = 'https://gecapital-devuat.datatoolscloud.net.au';
        dataTool.Endpoint_json_ws__c = 'https://gecapital-devuat.datatoolscloud.net.au/dt_webservice/dt.asmx/';
        dataTool.URL_Key_2__c = 'U0115-02921-47432-4009';
        dataTool.Name = 'Datatools';
        return dataTool;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 01/30/2014
    Description: create Credit Ref Check Record
    */
    public static Credit_Ref_Check__c createCreditRefCheck(Id applicationId){
        Credit_Ref_Check__c creditRefCheck = new Credit_Ref_Check__c();
        creditRefCheck.Application__c = applicationId;
        creditRefCheck.Company__c = 'TestCompany';
        creditRefCheck.Contract_Account_No__c = 'TestContactAcocunt';
        creditRefCheck.Name_on_Contract__c = 'TestNameOnContact';
        creditRefCheck.Open_Date__c = Date.Today();
        creditRefCheck.End_Date__c = Date.Today();
        creditRefCheck.Contract_Term__c = 'TestContractTerm';
        creditRefCheck.Opening_Balance__c = 10000.0;
        creditRefCheck.Current_Balance__c = 5700.0;
        creditRefCheck.Repayments__c = 2300.0;
        creditRefCheck.Interest_Rate__c = 3.0;
        creditRefCheck.Account_Conduct__c = 'Good';
        return creditRefCheck;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 01/31/2014
    Description: create Disbursement Record
    */
    public static Disbursement__c createDisbursement(Id applicationId){
        Disbursement__c disburse = new Disbursement__c();
        disburse.BSB__c = '123456';
        disburse.Bank_Acc_No__c =  '0068389';
        disburse.Amount__c = 90000.0;
        disburse.GE_Debt__c = false;
        disburse.Disbursement_Outcome__c ='Reduce'; 
        disburse.Disbursement_Adj_Amt__c = 1029421; 
        disburse.Disbursement_Outcome_Comments__c = 'Test Comments';
        disburse.Fin_Institution__c = 'Test Fin';
        disburse.Financial_Institution_Postcode__c = '1234';
        disburse.Application__c = applicationId;
        disburse.Applicable_Party__c = 'Applicant 1';
        disburse.Payee__c = 'TestPayee';
        disburse.Branch__c='0902';
        disburse.Suffix_Number__c='0000';
        disburse.Bank_Number__c='01';
        //Added Reference__c by Suneel - Cheque Disbursement Removal
        disburse.Reference__c='123';
        return disburse;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 01/31/2014
    Description: create Disbursement Record
    */
    public static Disbursement__c createDisbursementRefinance(Id applicationId, Id loanPurposeId) {
        Disbursement__c disburse = new Disbursement__c();
        disburse.BSB__c = '12345';
        disburse.Bank_Acc_No__c =  '12345';
        disburse.Amount__c = 90000.0;
        disburse.GE_Debt__c = false;
        disburse.Disbursement_Outcome__c ='Reduce'; 
        disburse.Disbursement_Adj_Amt__c = 1029421; 
        disburse.Disbursement_Outcome_Comments__c = 'Test Comments';
        disburse.Fin_Institution__c = 'Test Fin';
        disburse.Financial_Institution_Postcode__c = '1234';
        disburse.Application__c = applicationId;
        disburse.Applicable_Party__c = 'Applicant 1';
        disburse.Disbursement_Account_type__c = 'Personal Loan';
        disburse.Interest_Rate__c = 10;
        disburse.Payout_Effective_Date__c = system.today().adddays(30);
        disburse.Principal_Amount__c = 10000;
        disburse.Interest_Due__c = 10;
        disburse.Late_Fees_Due__c = 10;
        disburse.Penalty_Interest_Due__c = 100;
        disburse.Fees_or_Charges_Due__c = 100;
        disburse.Charge_Off_Amount__c = 100;
        disburse.Insurance_Rebate__c = 100;
        disburse.Early_Termination_Fee__c = 100;
        disburse.Payee__c = 'TestPayee';
        disburse.Loan_Purpose__c = loanPurposeId;
        disburse.Branch__c='0902';
        disburse.Suffix_Number__c='0000';
        disburse.Bank_Number__c='01';
        //Added by Suneel - Beat the Banks - 20/01/2018
        disburse.Reference__c = '123';
        //End
        return disburse;
    }    
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/05/2014
    Description: create Related Document Record
    */
    public static Related_Document__c createRelatedDocument(Id applicantId, Id applicationId){
        Related_Document__c relatedDocument = new Related_Document__c();
        relatedDocument.GE_Document_ID__c = 'Sent';
        relatedDocument.Status__c = 'Draft';
        relatedDocument.Type__c ='O&Rs';  
        relatedDocument.GE_Link_Type__c = 'Evolve';
        relatedDocument.Document_Category__c = 'Loan Documents';
        relatedDocument.Applicant__c = applicantId;
        relatedDocument.Application__c = applicationId;
        return relatedDocument;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/05/2014
    Description: create Attachment Record
    */
    public static Attachment createAttachment(Id relatedDocumentId){
        Attachment Attach = new Attachment();
        String testBlob = 'Test Blob String';
        Blob myBlob = Blob.valueof(testBlob);
        Attach.Body = myBlob;
        Attach.Name = 'Test Attachment';
        Attach.ParentId = RelatedDocumentId;
        return Attach;
    }

    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 11/05/2015
    Description: create test document
    */
    public static Document createDocument(string devName){
        Document docVar = new Document();
        docVar.DeveloperName = devName;
        docVar.Name = devName;
        docVar.FolderId = UserInfo.getUserId();
        return docVar;
    }
    
    /*
    Author: Mike Lasala Cloud Sherpas
    Created Date: 02/17/2014
    Description: create Response Code Control custom setting
    */
    public static Response_Code_Control__c createResponseCodeControl(Boolean status, String responseCode){
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = responseCode;
        responseCodeControl.Accept_Offer_CLV__c = status;
        responseCodeControl.Close_CLV__c = status;
        responseCodeControl.CPU_Case_CLV__c = status;
        responseCodeControl.Credit_File_Check__c = status;
        responseCodeControl.Credit_Ref_Check__c = status;
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Edit_Asset__c = status;
        responseCodeControl.Edit_CLV__c = status;
        responseCodeControl.Edit_Contract_Generation__c = status;
        responseCodeControl.Edit_Debt__c = status;
        responseCodeControl.Edit_Document__c = status;
        responseCodeControl.Edit_Expense__c = status;
        responseCodeControl.Edit_Income__c = status;
        responseCodeControl.Edit_Personal_Details__c = status;
        responseCodeControl.Fee_Reduction__c = status;
        responseCodeControl.Generate_Contract__c = status;
        responseCodeControl.Lending_Limit_Override__c = status;
        responseCodeControl.Manager_Approval__c = status;
        responseCodeControl.New_Edit_Collateral__c = status;
        responseCodeControl.New_Edit_Compliance__c = status;
        responseCodeControl.New_Edit_Contract_Prerequisites__c = status;
        responseCodeControl.New_Edit_Document__c = status;
        responseCodeControl.New_AML__c = status;
        responseCodeControl.New_DB__c = status;
        responseCodeControl.Personal_Reference_Check__c = status;
        responseCodeControl.Rate_Reduction__c = status;
        responseCodeControl.Risk_Referral__c = status;
        responseCodeControl.Submit_CLV__c = status;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Update_Application__c = status;
        responseCodeControl.User_Login_User_created__c = status;
        responseCodeControl.User_Login_User_not_created__c = status;
        responseCodeControl.Verify_POI__c = status;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        responseCodeControl.Create_Account__c = true;
        responseCodeControl.Remove_Applicant__c = status;
        responseCodeControl.Submit_NZ__c=status;
        return responseCodeControl;
    }

    /*
    Author: Mike Lasala Cloud Sherpas
    Created Date: 02/17/2014
    Description: create Profile Control custom setting
    */
    public static Profile_Control__c createProfileControl(Boolean status){
        Profile_Control__c profileControl = new Profile_Control__c();
        profileControl.Close_CLV__c = status;
        profileControl.CPU_Case_CLV__c = status;
        profileControl.Credit_File_Check__c = status;
        profileControl.Credit_Ref_Check__c = status;
        profileControl.Edit_Asset__c = status;
        profileControl.Edit_CLV__c = status;
        profileControl.Edit_Contract_Generation__c = status;
        profileControl.Edit_Debt__c = status;
        profileControl.Edit_Document__c = status;
        profileControl.Edit_Expense__c = status;
        profileControl.Edit_Income__c = status;
        profileControl.Edit_Personal_Details__c = status;
        profileControl.Fee_Reduction__c = status;
        profileControl.Generate_Contract__c = status;
        profileControl.Lending_Limit_Override__c = status;
        profileControl.Manager_Approval__c = status;
        profileControl.New_Edit_Collateral__c = status;
        profileControl.New_Edit_Compliance__c = status;
        profileControl.New_Edit_Contract_Prerequisites__c = status;
        profileControl.New_Edit_Document__c = status;
        profileControl.New_AML__c = status;
        profileControl.New_DB__c = status;
        profileControl.Personal_Reference_Check__c = status;
        profileControl.Rate_Reduction__c = status;
        profileControl.Risk_Referral__c = status;
        profileControl.Submit_CLV__c = status;
        profileControl.Update_Application__c = status;
        profileControl.User_Login_User_created__c = status;
        profileControl.User_Login_User_not_created__c = status;
        profileControl.Verify_POI__c = status;
        profileControl.Create_Account__c = status;
        profileControl.Remove_Applicant__c = status;
        profileControl.Submit_NZ__c=status;
        return profileControl;
    }

    /*
    Author: Mike Lasala Cloud Sherpas
    Created Date: 02/17/2014
    Description: create Profile Control custom setting
    */
    public static Debit__c createDebit(Id recordType, Id appId){
        BSB__c bsb = new BSB__c();
        bsb.Name = '123456';
        insert bsb;
        
        Debit__c debit = new Debit__c();
        debit.Application__c = appId;
        debit.RecordTypeId = recordType;
        debit.Account_Holders__c = 'Holder';
        debit.Bank_Name__c = 'Bank';
        debit.Branch_Location__c = 'Location';
        debit.BSB_Number__c = bsb.Name;
        debit.Frequency__c = 'Weekly';
        debit.Commencement_Date__c = Date.today();
        debit.Specify_Higher_Amount__c = 2000;
        //Added by vijay Start
        debit.Account_Number__c = '68389';
        debit.Bank_Number__c='26';
        debit.Suffix_Number__c='0000';
        debit.Branch_Number__c='2600';
        
        return debit;
    }

    /*
    Author: Mike Lasala Cloud Sherpas
    Created Date: 02/19/2014
    Description: create web service settings custom setting
    */
    public static Web_Service_Settings__c createWebServiceSettings(String name, String value){
        Web_Service_Settings__c webServiceSettings = new Web_Service_Settings__c();
        webServiceSettings.Name =  name;
        webServiceSettings.Value__c = value;

        return webServiceSettings;
    }

    /*
    Author: Kristoffer Chuck Martin
    Created Date: 02/19/2014
    Description: Create Personal Reference Check
    */
    public static Personal_Reference_Check__c createPersonalReferenceCheck(Id appId){
        Personal_Reference_Check__c personalRefCheck = new Personal_Reference_Check__c();
        personalRefCheck.Personal_Ref_Address__c = 'Test Address';
        personalRefCheck.Application__c = appId;
        personalRefCheck.Name__c = 'Test Name';
        personalRefCheck.Phone_Number__c = '4155557000';
        personalRefCheck.Relationship__c = 'Brother';
        personalRefCheck.State__c = 'Vic';
        return personalRefCheck;
    }

    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/24/2014
    Description: create Applicant Account Record
    */
    public static Applicant_Account__c createApplicantAcocunt(Id appCLVId){
        Applicant_Account__c appAcc = new Applicant_Account__c();
        appAcc.Account_Number__c = '12345';
        appAcc.Selected_ICBS_Customer_Number__c = '12345';
        appAcc.Applicant_CLV__c = appCLVId;
        return appAcc;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/24/2014
    Description: create Applicant Account Customer Record
    */
    public static Applicant_Account_Customer__c createApplicantAccountCustomer(Id applicantId){
        Applicant_Account_Customer__c appAccCus = new Applicant_Account_Customer__c();
        appAccCus.Account_Number__c = '12345';
        appAccCus.Customer_Number__c = '12345';
        appAccCus.Applicant__c = applicantId;
        return appAccCus;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/24/2014
    Description: create Applicant Account Involved Party Record
    */
    public static Applicant_Account_Involved_Party__c createApplicantAccountInvolvedParty(Id appAcc){
        Applicant_Account_Involved_Party__c appAccInvolvedParty = new Applicant_Account_Involved_Party__c();
        appAccInvolvedParty.Applicant_Account__c = appAcc;
        appAccInvolvedParty.Customer_Identifier__c = '12345';
        return appAccInvolvedParty;
    }
    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 11/28/2014
    Description: create Applicant Account Bus Contract Record
    */
    public static App_Account_Bus_Contract_Goods__c createApplicantAccountBusContract(Id appAcc){
        App_Account_Bus_Contract_Goods__c appAccBusContract = new App_Account_Bus_Contract_Goods__c();
        appAccBusContract.Applicant_Account__c = appAcc;
        appAccBusContract.Description__c = 'testDescription';
        appAccBusContract.Year_Of_Manufacture__c = 2000;
        return appAccBusContract;
    }
    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 11/28/2014
    Description: create Applicant Account History Record
    */
    public static Applicant_Account_History__c createApplicantAccountHistory(Id appAcc){
        Applicant_Account_History__c appAccHistory = new Applicant_Account_History__c();
        appAccHistory.Applicant_Account__c = appAcc;
        appAccHistory.Cycle_Date__c = Date.today().addDays(5);
        return appAccHistory;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 11/28/2014
    Description: create Applicant Account Loss History Record
    */
    public static Applicant_Account_Loss_History__c createApplicantAccountLossHistory(Id appAcc){
        Applicant_Account_Loss_History__c appAccLossHistory = new Applicant_Account_Loss_History__c();
        appAccLossHistory.Applicant_Account__c = appAcc;
        return appAccLossHistory;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 11/28/2014
    Description: create Applicant Account Plan Record
    */
    public static Applicant_Account_Plan__c createApplicantAccountPlan(Id appAcc){
        Applicant_Account_Plan__c appAccPlan = new Applicant_Account_Plan__c();
        appAccPlan.Applicant_Account__c = appAcc;
        appAccPlan.Description__c = 'Test Description';
        return appAccPlan;
    }
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 02/25/2014
    Description: create Applicant Account Involved Party Record
    */
    public static Income_Capacity__c createIncomeCapacity(Id inc){
        Income_Capacity__c incCap = new Income_Capacity__c();
        incCap.Income__c = inc;
        incCap.Employment_Type__c = 'Self Employed';
        incCap.Frequency_of_Payment__c ='Monthly';
        incCap.Method_of_Calculation__c ='Net Income';
        incCap.Method_of_Verification__c ='Payslip';
        return incCap;
    }
        
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 02/28/2014
    Description: build Test Tax Income
    */
    public static Tax_Income__c createTaxIncome(){
        Tax_Income__c tiVar = new Tax_Income__c();
        tiVar.Medicare__c = 1.50;
        tiVar.Tax_Year__c = '2014';
        return tiVar;
    }
    
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 02/28/2014
    Description: build Test Tax Income
    */
    public static Tax_Income_Line_Item__c createTILineItem(Id parentTaxIncome){
        Tax_Income_Line_Item__c tILineItem = new Tax_Income_Line_Item__c();
        tILineItem.Tax_Income__c = parentTaxIncome;
        return tILineItem;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 03/03/2014
    Description: Create Rate Card Records
    */
    public static Rate_Card__c createRateCard(Id productVersion){
        Rate_Card__c rateCard = new Rate_Card__c();
        rateCard.Product_Version__c = productVersion;
        rateCard.Channel__c = 'Broker';
        rateCard.End_Date__c = datetime.now().addYears(10);
        rateCard.Start_Date__c = datetime.now().addDays(-1);
        rateCard.Rate_Card_Name__c = 'Test Name';
        return rateCard;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 12/17/2014
    Description: Create Rate Card Records
    */
    public static Rate_Card__c createRateCardFactorTable(){
        Rate_Card__c rateCard = new Rate_Card__c();
        rateCard.End_Date__c = datetime.now().addYears(10);
        rateCard.Start_Date__c = datetime.now().addDays(-1);
        rateCard.Rate_Card_Name__c = 'Rating Factor Table NZ';
        return rateCard;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 03/03/2014
    Description: Create Rate Records
    */
    public static Rate__c createRate(Id rateCardId){
        Rate__c rate = new Rate__c();
        rate.Credit_Score__c = 'A';
        rate.Principal_Maximum__c = 15000;
        rate.Principal_Minimum__c = 0;
        rate.Rate__c = 14;
        rate.Rate_Card__c = rateCardId;
        return rate;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 12/17/2014
    Description: Create Rate Records
    */
    public static Rate__c createRateFactorTable(Id rateCardId){
        Rate__c rate = new Rate__c();
        rate.Credit_Score__c = 'AA';
        rate.Principal_Maximum__c = 15000;
        rate.Principal_Minimum__c = 0;
        rate.Rate__c = 2.10;
        rate.Rate_Card__c = rateCardId;
        return rate;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 03/03/2014
    Description: Create Insurance Product Records
    */
    public static GEProduct__c createGEProductInsurance(Id BrandId, String productName){
        GEProduct__c product = new GEProduct__c();
        product.Brands__c = BrandId;
        product.Name = productName;
        product.Type__c = 'Insurance';
        product.Insurance_Type__c = productName;
        return product;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/07/2014
    Description: Create Meta Compliance Chck
    */
    public static Meta_Compliance_Check__c createMetaComplianceCheck(){
        Meta_Compliance_Check__c mcc = new Meta_Compliance_Check__c();
        mcc.Start_Date__c = Date.Today();
        mcc.End_Date__c = Date.Today().addDays(30);
        return mcc;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/07/2014
    Description: Create Meta Compliance Check Line Item
    */
    public static List<Meta_Compliance_Check_Line_Item__c> createMetaComplianceCheckLinteItem(Integer noOfItems, Boolean pfr, Boolean bm, Id mccId){
        List<Meta_Compliance_Check_Line_Item__c> mccliList = new List<Meta_Compliance_Check_Line_Item__c>();
        
        for(Integer i=0; i<noOfItems; i++){
            Meta_Compliance_Check_Line_Item__c mccli = new Meta_Compliance_Check_Line_Item__c();
            mccli.Meta_Compliance_Check__c = mccId;
            mccli.Section__c = String.valueOf(i);
            mccli.PFR_Only__c = pfr;
            mccli.BM_Only__c = bm;
            if(i==0){
                mccli.region__c='AU';
            }else{
                mccli.region__c='NZ';
            }
            mccliList.add(mccli);
        }
        return mccliList;
    }
    
    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/07/2014
    Description: Create Meta Compliance Pre Settle
    */    
    public static List<Meta_Compliance_Pre_Settle__c> createMetaCompliancePreSettle(Integer noOfItems, Boolean pfr, Boolean bm, Id mccId){
        List<Meta_Compliance_Pre_Settle__c> mcpsList = new List<Meta_Compliance_Pre_Settle__c>();
        
        for(Integer i=0; i<noOfItems; i++){
            Meta_Compliance_Pre_Settle__c mcps = new Meta_Compliance_Pre_Settle__c();
            mcps.Meta_Compliance_Check__c = mccId;
            mcps.Section__c = String.valueOf(i);
            mcps.PFR_Only__c = pfr;
            mcps.BM_Only__c = bm;
            if(i==0){
                mcps.region__c='AU';
            }else{
                mcps.region__c='NZ';
            }
            mcpsList.add(mcps);
        }
        return mcpsList;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/07/2014
    Description: Create Meta Compliance Post Settle
    */    
    public static List<Meta_Compliance_Post_Settle__c> createMetaCompliancePostSettle(Integer noOfItems, Boolean pfr, Boolean bm, Id mccId){
        List<Meta_Compliance_Post_Settle__c> mcpsList = new List<Meta_Compliance_Post_Settle__c>();
        
        for(Integer i=0; i<noOfItems; i++){
            Meta_Compliance_Post_Settle__c mcps = new Meta_Compliance_Post_Settle__c();
            mcps.Meta_Compliance_Check__c = mccId;
            mcps.Section__c = String.valueOf(i);
            mcps.PFR_Only__c = pfr;
            mcps.BM_Only__c = bm;
            if(i==0){
                mcps.region__c='AU';
            }else{
                mcps.region__c='NZ';
            }
            mcpsList.add(mcps);
        }
        return mcpsList;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/11/2014
    Description: Create Insurance Premium Calculation Variable
    */    
    public static Insurance_Premium_Calculation_Variables__c createInsurancePremiumCalculationVariable(String name, Integer value){
        Insurance_Premium_Calculation_Variables__c insurance = new Insurance_Premium_Calculation_Variables__c();
        insurance.Name = String.valueOf(name);
        insurance.Value__c = value;
        insurance.Description__c = 'test';
        return insurance;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 03/14/2014
    Description: Create Decision
    */ 
    public static Decision__c createDecision(Id applicationId, Boolean action){
        Decision__c decision = new Decision__c();
        decision.Application__c = applicationId;
        decision.Action__c = action;
        decision.Clearance__c = 'Manual';
        return decision;
    }
    
    /*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 03/14/2014
    Description: Create Requested Document
    */ 
    public static Requested_Document__c createRequestDoc(Id applicationId){
        Requested_Document__c rdVar = new Requested_Document__c();
        rdVar.Application__c = applicationId;
        return rdVar;
    }

    /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 03/15/2014
    Description: Create Condition
    */ 
    public static Condition__c createCondition1(Id ruleId){
        Condition__c cond = new Condition__c();
        cond.Rule__c = ruleId;
        cond.Type__c = 'Free Text';
        cond.Order__c = 1;
        return cond;
    }

    /*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 03/15/2014
    Description: Create Condition
    */ 
    public static Condition__c createCondition2(Id ruleId){
        Condition__c cond = new Condition__c();
        cond.Rule__c = ruleId;
        cond.Type__c = 'Free Text';
        cond.Order__c = 2;
        return cond;
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 03/18/2014
    Description: Create Fees And Charges
    */ 
    public static Fees_Charges__c createFeesAndcharges(Id prodVersion){
        Fees_Charges__c fee = new Fees_Charges__c();
        fee.Product_Version__c = prodVersion;
        fee.Disability_Plus_Premium_Rate__c = 100;
        fee.Disability_Plus_Premium_Term__c = 100;
        fee.Effective_End_Date__c = Date.Today().addDays(10);
        fee.Effective_Start_Date__c = Date.Today();
        fee.Fee_Amount__c = 100;
        fee.Fee_Type__c = 'Disability Plus Premium Rate';
        return fee;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 24/03/2014
    Description: Create AML Records
    */
    public static AML__c createAMLRecords(Id applicantId, Integer seq, String id){
        AML__c aml = new AML__c();
        aml.Applicant__c = applicantId;
        aml.Staff_ID_SSO__c = '1';
        aml.Date_Verified__c = Date.today();
        aml.ID_Expiry_Date__c = Date.today().addDays(100);
        aml.Identification__c = id;
        aml.AML_Pos_Verified_Type__c = 'In Branch';
        aml.Id_Sequence_No__c = seq;
        aml.Issue_Country__c  = 'Australia';
        aml.ID_Issue_Date__c = Date.today();
        aml.ID_Expiry_State__c = 'NSW';
        aml.ID_No__c = '12345'+seq;
        aml.ID_Issuer__c = 'Test';
        return aml;

    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 24/03/2014
    Description: Create AML Records
    */
    public static List<HeaderColors__c> createHeaderColors(){
        List<HeaderColors__c> headerColorList = new List<HeaderColors__c>();

        HeaderColors__c blue = new HeaderColors__c();
        blue.Name = 'pb-blue';
        headerColorList.add(blue);

        HeaderColors__c brown = new HeaderColors__c();
        brown.Name = 'pb-brown';
        headerColorList.add(brown);

        HeaderColors__c darkblue = new HeaderColors__c();
        darkblue.Name = 'pb-darkblue';
        headerColorList.add(darkblue);

        HeaderColors__c darkgray = new HeaderColors__c();
        darkgray.Name = 'pb-darkgray';
        headerColorList.add(darkgray);

        HeaderColors__c green = new HeaderColors__c();
        green.Name = 'pb-green';
        headerColorList.add(green);

        HeaderColors__c olive = new HeaderColors__c();
        olive.Name = 'pb-olive';
        headerColorList.add(olive);

        HeaderColors__c purple = new HeaderColors__c();
        purple.Name = 'pb-purple';
        headerColorList.add(purple);

        HeaderColors__c red = new HeaderColors__c();
        red.Name = 'pb-red';
        headerColorList.add(red);

        HeaderColors__c yellow = new HeaderColors__c();
        yellow.Name = 'pb-yellow';
        headerColorList.add(yellow);

        HeaderColors__c orange = new HeaderColors__c();
        orange.Name = 'pb-orange';
        headerColorList.add(orange);

        return headerColorList;

    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 2/04/2014
    Description: Create Insurance Product Item
    */
    public static Product_Item__c createInsuranceProductItem(Id appId, Id prodVerId, String insuranceType, String applicant1, String applicant2){
        Product_Item__c productItem = new Product_Item__c();
        productItem.Application__c = appId;
        productItem.Product_Version__c = prodVerId;
        productItem.Rate__c = 100;
        productItem.Repayment__c = 12;
        productItem.Repayment_Period__c = '1 years';
        productItem.Applicant1__c = applicant1;
        productItem.Applicant2__c = applicant2;
        return productItem;
    }
    public static Web_Service_Log__c createWebServiceLog(Id appId){
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        wsLog.Application__c = appId;
        wsLog.Service_Called__c = GEN_OriginationsConstants.SERVICENAME_SUBMIT;
        return wsLog;
    }

    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 05/29/2014
    Description: Create Brand Content
    */ 
    public static Brand_Content__c createBrandContent(Id brandId){
        Brand_Content__c brandContent = new Brand_Content__c();
        brandContent.Brand__c = brandId;
        brandContent.Output_HTML__c = 'test';
        brandContent.Description__c = 'Eligibility Questions';
        return brandContent;
    }

    public static void createListInsurancePremiumVars() {

        List<Insurance_Premium_Calculation_Variables__c> ipcvList = new List<Insurance_Premium_Calculation_Variables__c>();
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='counter',
                                                                    Value__c = 7.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabFee',
                                                                    Value__c = 20.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabGst',
                                                                    Value__c = 0.0500,
                                                                    Description__c = 'test'));                                                            
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabJoint',
                                                                    Value__c = 0.9000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='iuiFee',
                                                                    Value__c = 6.5000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='iuiGst',
                                                                    Value__c = 0.0500,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='lifeInsPremRate',
                                                                    Value__c = 0.075,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='lifeJoint',
                                                                    Value__c = 0.8000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='maxMonthlyEmi',
                                                                    Value__c =1500.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='maxPrincipal',
                                                                    Value__c = 100000.0000,
                                                                    Description__c = 'test'));
        insert ipcvList;
        
    }
    
    /*
    Author: vijaya kumar
    Created Date: 12/17/2014
    Description: Created Bank and Bank branch for Account Validation
    */
    
    public static list<bank__c> createBank(){
        list<bank__c> bankLst=new list<bank__c>();
        Bank__c b=new Bank__c();
        b.Name='01';
        b.Algorithm__c='{A;B}';
        
        Bank__c b1=new Bank__c();
        b1.Name='26';
        b1.Algorithm__c='{G}';
        
        bankLst.add(b);
        bankLst.add(b1);
        return bankLst;
    }
    //Added by vijay 
    public static list<Bank_Branch__c> createBranch(list<Bank__c> bankid){
        list<Bank_Branch__c> bankB=new list<Bank_Branch__c>();
        Bank_Branch__c bb1=new Bank_Branch__c();
        bb1.Bank_Id__c=bankId[0].id;
        bb1.Min_Range__c=0000;
        bb1.Max_Range__c=1100;
        
        Bank_Branch__c bb=new Bank_Branch__c();
        bb.Bank_Id__c=bankId[1].id;
        bb.Min_Range__c=2600;
        bb.Max_Range__c=2699;
        
        bankB.add(bb1);
        bankB.add(bb);
        return bankB;
    }
    //Added by vijay 
    public static Algorithm__c createAlgorithm(){
        Algorithm__c alg=new Algorithm__c();
        alg.Bank__c='0 0';
        alg.Name='A';
        alg.Branch__c='6 3 7 9';
        alg.Account_Base__c='0 0 10 5 8 4 2 1';
        alg.Modulo__c='11';
        alg.Suffix__c='0 0 0 0';
                        
        return alg;
    }
    
    public static list<Algorithm__c> createAlgorithms(){
        list<Algorithm__c> algo=new list<Algorithm__c>();
        Algorithm__c alg=new Algorithm__c();
        alg.Bank__c='0 0';
        alg.Name='B';
        alg.Branch__c='0 0 0 0';
        alg.Account_Base__c='0 0 10 5 8 4 2 1';
        alg.Modulo__c='11';
        alg.Suffix__c='0 0 0 0';
        
        Algorithm__c alg1=new Algorithm__c();
        alg1.Bank__c='0 0';
        alg1.Name='G';
        alg1.Branch__c='0 0 0 0';
        alg1.Account_Base__c='0 1 7 3 1 7 3 1';
        alg1.Modulo__c='10';
        alg1.Suffix__c='0 3 7 1';
        
        algo.add(alg);
        algo.add(alg1);
        
        return algo;
    }
    //Added by vijay 
    public static Payee__c createPayee(){
        Payee__c paye=new Payee__c();
        paye.name='Test';
        paye.Account_Number__c='0068389';
        paye.Branch__c='902';
        paye.Suffix__c='0000';
        paye.Bank__c='01';
        
        return paye;
    }
    //Added by vijay
    public static Disbursement__c createDisbursementPayee(Id applicationId,Id payeeId){
        Disbursement__c disburse = new Disbursement__c();
        disburse.BSB__c = '123456';
        disburse.Bank_Acc_No__c =  '68389';
        disburse.Amount__c = 90000.0;
        disburse.GE_Debt__c = false;
        disburse.Disbursement_Outcome__c ='Reduce'; 
        disburse.Disbursement_Adj_Amt__c = 1029421; 
        disburse.Disbursement_Outcome_Comments__c = 'Test Comments';
        disburse.Fin_Institution__c = 'Test Fin';
        disburse.Financial_Institution_Postcode__c = '1234';
        disburse.Application__c = applicationId;
        disburse.Applicable_Party__c = 'Applicant 1';
        disburse.Payee__c = 'TestPayee';
        disburse.Branch__c='902';
        disburse.Suffix_Number__c='00';
        disburse.Bank_Number__c='1';
        //disburse.Lookup_a_Payee__c= payeeId;
        return disburse;
    }
    
     public static Disbursement__c createDisbursementPayee1(Id applicationId,Id payeeId){
        Disbursement__c disburse = new Disbursement__c();
        disburse.BSB__c = '123456';
        disburse.Bank_Acc_No__c =  '68389';
        disburse.Amount__c = 90000.0;
        disburse.GE_Debt__c = false;
        disburse.Disbursement_Outcome__c ='Reduce'; 
        disburse.Disbursement_Adj_Amt__c = 1029421; 
        disburse.Disbursement_Outcome_Comments__c = 'Test Comments';
        disburse.Fin_Institution__c = 'Test Fin';
        disburse.Financial_Institution_Postcode__c = '1234';
        disburse.Application__c = applicationId;
        disburse.Applicable_Party__c = 'Applicant 1';
        disburse.Payee__c = 'TestPayee';
        disburse.Branch__c='2600';
        disburse.Suffix_Number__c='00';
        disburse.Bank_Number__c='26';
        //disburse.Lookup_a_Payee__c= payeeId;
        return disburse;
    }
    
    public static Application__c createApplicationNZ( brand__C brand){
        //BEGIN - RCADAPAN 04-FEB-2016 - ADD NEW VALUE FOR Branch Locator
        Admin_Settings__c tomSetting = new Admin_Settings__c();
        tomSetting.Name = 'TOM Enabled';
        tomSetting.Value__c = 'FALSE';
        insert tomSetting;
        //END - RCADAPAN 04-FEB-2016
        
        Application__c application = new Application__c();
        application.Payment_Frequency__c = 'Weekly';
        application.Application_Type__c = 'Joint';
        application.Case_Manager_Id__c = '0916185395213';
        application.Loan_Term_Months__c = 24;
        application.Loan_Insurance_Consent__c = true;
        application.Interested_in_other_services__c = true;
        application.Application_type__c = 'Single';
        application.Total_Loan_Amount__c = 1000;
        application.Offered_Interest_Rate__c = 12;
        //application.Offered_Repayments__c = 1000;
        //application.Total_Insurance_Premium__c = 200;
        application.Response_Code__c = 'PA';
        application.Generated_Doc_Confirm_Sent__c = false;
        application.Offered_Monthly_Loan_Service_Fee__c = 50;
        //application.Adjusted_Interest_Rate__c = 50;
        application.Application_Source__c = 'CUSTOMER REFERRAL';
        application.Channel__c = 'Broker';
        application.Last_Submit_Date__c = System.now();
        application.Submission_Status__c = 'Not Submitted';
        application.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;      //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        if(brand != NULL) {
          application.Brand_Lookup__c = brand.Id;
        }
        
        return application;
    }
    
    public static Brand__c createBrandNZ(){
        Brand__c Brand = new Brand__c();
        Brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;       //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        Brand.External_ID__c = '1';
        Brand.URL_Key__c = '1234';
        Brand.Country__c = 'NZ'; 
        brand.Template_Save_Retrieve_Sales__c = 'TEST';
        brand.OrgWide_Email_Address__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;       //MLASALA: 21-MAR-16 TQLQW-127 Re-brand 
        brand.Loan_Term__c='{1 year;2 year;6 Months}';
        return Brand;
    }
   public static EmailTemplate createEmailTemplate(String developerName)
   {
         EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = developerName;
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Your Subject Here';
        return validEmailTemplate;
       
   }
    
    public static Data_Perge_Settings__c createDataPurgeSetting(String name, Integer value){
        Data_Perge_Settings__c dataPurgeSetting = new Data_Perge_Settings__c();
        datapurgeSetting.Name = name;
        datapurgeSetting.Value__c = value;
        return dataPurgeSetting;
    }

    public static List<Data_Perge_Settings__c> createAllDataPurgeSettings(){
        List<Data_Perge_Settings__c> dataPurgeSettingsList = new List<Data_Perge_Settings__c>();

        Data_Perge_Settings__c dps1 = createDataPurgeSetting('Applicant Account', 60);
        Data_Perge_Settings__c dps2 = createDataPurgeSetting('Applicant CLV', 2);
        Data_Perge_Settings__c dps3 = createDataPurgeSetting('Applicant Search', 60);
        Data_Perge_Settings__c dps4 = createDataPurgeSetting('AU Billing Data', 90);
        Data_Perge_Settings__c dps5 = createDataPurgeSetting('Draft Document', 7);
        Data_Perge_Settings__c dps6 = createDataPurgeSetting('Evolve Draft Document', 90);
        Data_Perge_Settings__c dps7 = createDataPurgeSetting('Exception log', 90);
        Data_Perge_Settings__c dps8 = createDataPurgeSetting('Finalised Applications AU', 90);
        Data_Perge_Settings__c dps9 = createDataPurgeSetting('Finalised Applications NZ', 90);
        Data_Perge_Settings__c dps10 = createDataPurgeSetting('NZ Billing Data', 90);
        Data_Perge_Settings__c dps11 = createDataPurgeSetting('Resolved App WSL', 90);
        Data_Perge_Settings__c dps12 = createDataPurgeSetting('Submitted Applications AU', 90);
        Data_Perge_Settings__c dps13 = createDataPurgeSetting('Submitted Applications NZ', 90);
        Data_Perge_Settings__c dps14 = createDataPurgeSetting('Un-submitted Applications AU', 90);
        Data_Perge_Settings__c dps15 = createDataPurgeSetting('Un-submitted Applications NZ', 90);
        dataPurgeSettingsList.add(dps1);
        dataPurgeSettingsList.add(dps2);
        dataPurgeSettingsList.add(dps3);
        dataPurgeSettingsList.add(dps4);
        dataPurgeSettingsList.add(dps5);
        dataPurgeSettingsList.add(dps6);
        dataPurgeSettingsList.add(dps7);
        dataPurgeSettingsList.add(dps8);
        dataPurgeSettingsList.add(dps9);
        dataPurgeSettingsList.add(dps10);
        dataPurgeSettingsList.add(dps11);
        dataPurgeSettingsList.add(dps12);
        dataPurgeSettingsList.add(dps13);
        dataPurgeSettingsList.add(dps14);
        dataPurgeSettingsList.add(dps15);

        return dataPurgeSettingsList;
    }
    //Added by DYU 05-15-2015 Add NZ Specific Settings Custom Setting
    public static NZ_Specific_Settings__c createNZSpecificSettings(){
        NZ_Specific_Settings__c nz = new NZ_Specific_Settings__c();
        nz.name = 'CMO Manager';
        nz.Value__c = 'akash.aggarwal@'+GEN_OriginationsConstants.BRAND_NAME_GEMONEY.toLowerCase()+'.com.orignzdev';        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        return nz;
    }
    
    //Added SalesforceURL Setting - TXU
    public static SalesforceUrl__c createSalesforceURLSettings(){
        SalesforceUrl__c su = new SalesforceUrl__c();
        su.Account_Opener_Training_Param__c = 'CF00NN0000001PFMb_lkid';
        su.Link__c = 'https://www.salesforce.com';
        return su;
    }
    
     /*
    Author: Afreen Khan
    Created Date: 17 Feb 2015
    Description: Create meta documents
    */
    public static List<Meta_Document__c> createMetaDocument(){
        Meta_Document__c md = new Meta_Document__c();
        md.Category__c = 'POA PL';
        md.Document_Type__c =   'Utility Bill';
        md.Description__c = '<p>Can include any of the following and must be issued within 6 months:</p><ul><li>Landline telephone</li><li>SKY TV</li><li>Internet/ISP account</li><li>Electricity/gas</li><li>Mopbile Phone</li></ul>';

        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POA PL';
        md1.Document_Type__c =  'Government Issued Documents';
        md1.Description__c = '<p>Can include any of the following and must be issued within 6 months:</p><ul> <li>Driving Licence</li> <li>Passport</li></ul>';

        List<Meta_Document__c> docList = new List<Meta_Document__c>();
        docList.add(md);
        docList.add(md1);

        return docList;
    }
    
     /*
    Author: Afreen Khan
    Created Date: 17 Feb 2015
    Description: Create BSB records
    */
    
    public static List<BSB__c> createBSBList(){
        BSB__c bsb1 = new BSB__c();
        bsb1.Name = '123456';
        
        BSB__c bsb2 = new BSB__c();
        bsb2.Name = '234567';
        
        List<BSB__C> bsbList = new List<BSB__c>();
        bsbList.add(bsb1);
        bsbList.add(bsb2);
        
        return bsbList;
        
    }
    
    /*
    Author: Afreen Khan
    Created Date: 17 Feb 2015
    Description: Create Bank__c records
    */
    
    public static List<Bank__c> createBankrecords(){
        Bank__c b1 = new Bank__c(Name = '11');
        Bank__c b2 = new Bank__c(Name = '22');
        
        List<Bank__c> bankList = new List<Bank__c>();
        bankList.add(b1);
        bankList.add(b2);
        
        return bankList;
    }
    
        /*
    Author: Afreen Khan
    Created Date: 17 Feb 2015
    Description: Create Bank_Branch__c records
    */
    
    public static List<Bank_Branch__c> createBankBranchrecords(){  
        List<Bank__c> bankList = TestDataBuilder.createBankrecords();        
        Insert bankList;
        
        Bank_Branch__c bb1 = new Bank_Branch__c(Bank_Id__c = bankList[0].id, Min_Range__c= 01, Max_Range__c = 100);
        Bank_Branch__c bb2 = new Bank_Branch__c(Bank_Id__c = bankList[1].id, Min_Range__c= 110, Max_Range__c = 150);
        
        List<Bank_Branch__c> bbList = new List<Bank_Branch__c>();
        bbList.add(bb1);
        bbList.add(bb2);
        
        return bbList;
    }
    
    public static Contact createBrokerRecord(){
        Id brokerRecordType = Schema.SObjectType.Contact.RecordTypeInfosByName.get(GEN_OriginationsConstants.BROKER_RECORD_TYPE_APAC).RecordTypeId;
        Contact broker = new Contact();
        broker.FirstName= 'test ';
        broker.LastName = 'Broker';
        broker.Contact_Accreditation_Status__c =  GEN_OriginationsConstants.ELIGIBITIY_BROKER_STATUS_ACTIVE;
        broker.Broker_Product__c = GEN_OriginationsConstants.BROKER_PRODUCT_PL;
        broker.RecordTypeId = brokerRecordType;
        
        return broker;
    }
    
   public static Contact createBrokerAssistantRecord(){
        Id brokerRecordType = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Broker Assistants').RecordTypeId;
        Contact brokerAssistant = new Contact();
        brokerAssistant.FirstName= 'John';
        brokerAssistant.LastName = 'Broker Assistant';
        brokerAssistant.RecordTypeId = brokerRecordType;
        return brokerAssistant;
    }

    public static void createResponsePageRiskGradeSettings(){
        Response_Pages_Risk_Grades__c riskGrade1 = new Response_Pages_Risk_Grades__c();
        riskGrade1.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
        riskGrade1.Value__c = 'A;AA;B';

        Response_Pages_Risk_Grades__c riskGrade2 = new Response_Pages_Risk_Grades__c();
        riskGrade2.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        riskGrade2.Value__c = 'A;AA;B';

        Response_Pages_Risk_Grades__c riskGrade3 = new Response_Pages_Risk_Grades__c();
        riskGrade3.Name = GEN_OriginationsConstants.BRAND_NAME_KIWI;
        riskGrade3.Value__c = 'A;AA;B';

        Response_Pages_Risk_Grades__c riskGrade4 = new Response_Pages_Risk_Grades__c();
        riskGrade4.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        riskGrade4.Value__c = 'A;AA;B';

        List<Response_Pages_Risk_Grades__c> riskGrades = new List<Response_Pages_Risk_Grades__c>{riskGrade1,riskGrade2,riskGrade3,riskGrade4};
        insert riskGrades;
    }
    
    /*  Description: Create Promo
     *  Author: Mike Lasala
     *  Date Created: 23-SEPT-2016
     *  Input Parameters: Id
     *  Return: Promo__c
     */
     
    public static Promo__c createPromo(Id campaignId){
        Promo__c promo = new Promo__c();
        promo.Promo_ID__c = 'test1234';
        promo.Promo_Start__c = Date.today();
        promo.Promo_End__c = Date.today()+30;
        promo.Campaign__c = campaignId;
        return promo;
    }

    /** Name: createQuoteAUOnline
     * Description: Create a Quote record for Australia region and for online channel
     * Date: 23-MAR-2020
     */

    public static List<Quote__c> createQuoteAUOnline(){

        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];

        //Create Quote    
         List<Quote__c> quoteList = new List<Quote__c>();                             
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
         quoteObj.Quote_Privacy_Consent__c= true;
         quoteObj.Quote_Stage__c = 'Initial Submit';
        quoteList.add(quoteObj);
        return quoteList;
    }

    /** Name: createQuoteAUBroker
     * Description: Create a Quote record for Australia region and for Broker channel
     * Date: 23-MAR-2020
     */

    public static List<Quote__c> createQuoteAUBroker(){

        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
        
        //Create Quote
        List<Quote__c> quoteList = new List<Quote__c>();
         Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Broker';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Quote_Privacy_Consent__c= true;
        quoteObj.Broker_ID__c = 'B-2722695';
        quoteObj.Brokerage_Fee__c =200.00;        
        quoteList.add(quoteObj);
        return quoteList;
    }
    
    /** Name: createQuoteAUBrokerWithBrokerId
     * Description: Create a Quote record for Australia region and for Broker channel
     * Date: 23-MAR-2020
     */

    public static List<Quote__c> createQuoteAUBrokerWithBrokerId(Contact contactObj){
		System.debug('NEW BROKER ID : '+contactObj.Broker_ID__c);
        Contact brokerContact =  [SELECT Broker_ID__c FROM Contact WHERE Id =: contactObj.Id LIMIT 1];
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
        
        //Create Quote
        List<Quote__c> quoteList = new List<Quote__c>();
         Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Broker';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Quote_Privacy_Consent__c= true;
        quoteObj.Broker_ID__c = brokerContact.Broker_ID__c;
        quoteObj.Brokerage_Fee__c =200.00;        
        quoteList.add(quoteObj);
        return quoteList;
    }

    /** Name: createQuoteNZOnline
     * Description: Create a Quote record for New Zealand region and for Online channel
     * Date: 23-MAR-2020
     */

    public static List<Quote__c> createQuoteNZOnline(){

        //Get Record Type for NZ
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'NZ' AND sObjectType = 'Quote__c'];
        
        //Create Quote
        List<Quote__c> quoteList = new List<Quote__c>();
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 3000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Auto Purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'NZ';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/06/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0238484484';
        quoteObj.Email_ID__c = 'asd@zzgem.com';
        quoteObj.Driver_s_Licence_Number__c = 'AB435778';
        quoteObj.Driver_s_License_Version__c = '456';
        quoteObj.Driver_s_License_Issue_Date__c = '10/02/2010';
        quoteObj.Driver_s_License_Expiry_Date__c = '10/02/2030';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_City__c = 'Auckland';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'New Zealand';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'Rental Income';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='GEM Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Quote_Privacy_Consent__c= true;    
        quoteList.add(quoteObj);
        return quoteList;
    }

    /** Name: createQuoteNZOnline
     * Description: Create a Quote record for New Zealand region and for Online channel
     * Date: 23-MAR-2020
     */

    public static List<Quote__c> createQuoteNZOnlineKiwi(){

        //Get Record Type for NZ
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'NZ' AND sObjectType = 'Quote__c'];
        
        //Create Quote
        List<Quote__c> quoteList = new List<Quote__c>();
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 3000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Auto Purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'NZ';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/07/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0238484484';
        quoteObj.Email_ID__c = 'asd@zzkiwi.com';
        quoteObj.Driver_s_Licence_Number__c = 'AB435778';
        quoteObj.Driver_s_License_Version__c = '456';
        quoteObj.Driver_s_License_Issue_Date__c = '10/02/2010';
        quoteObj.Driver_s_License_Expiry_Date__c = '10/02/2030';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_City__c = 'Auckland';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'New Zealand';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'Rental Income';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Kiwi Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Quote_Privacy_Consent__c= true;    
        quoteList.add(quoteObj);
        return quoteList;
    }
}