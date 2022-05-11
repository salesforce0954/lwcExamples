/**
*   Created by Abul Basar on April/07/2014
*   Consolidated all utilities related to testing. Creates test data for unit tests.
**/

public class TestingUtils {
    
    public static void disableTriggerCustSetting(Boolean disableTrigger,string setupOwnerId, string functionName){
        /*Override_User__c overrideUser = new Override_User__c();
        overrideUser.SetupOwnerId = setupOwnerId;
        overrideUser.Disable_Triggers__c = disableTrigger;*/
        
        Override_Function__c disableAtFunctionLevel = new Override_Function__c();
        disableAtFunctionLevel.Disable__c = disableTrigger;
        //disableAtFunctionLevel.SetupOwnerId = setupOwnerId;
        disableAtFunctionLevel.Name = functionName;
        
        insert disableAtFunctionLevel;
              
    }
    
    public static void clear_execution_flags(){
        AccountTriggerHandler.clear_execution_flags();
    }
   
     public static Account[] createHierarchyAccounts(Integer n, Account[] parent){
        Account[] accounts = new Account[0];
        for(Integer i=0; i<n; i++){
            Account temp = new Account(Name = 'TEST_ACCOUNT'+i,
                                        BillingStreet = '123 Main St', BillingCity = 'NA', 
                                        BillingPostalCode = '99999', BillingCountry='Australia',
                                   		BillingState='VIC', NumberofEmployees = 100,
                                        Phone = '000-000-0000',
                                        Website = 'www.test.com', ParentId = parent[i].Id);
            accounts.add(temp);                         
        }
        return accounts;
    }
    
     public static Account[] createHierarchyAccounts(Integer n, Account[] parent, Id recTypeId){
        Account[] accounts = new Account[0];
        for(Integer i=0; i<n; i++){
            Account temp = new Account(Name = 'TEST_ACCOUNT'+i,
                                        BillingStreet = '123 Main St', BillingCity = 'NA', 
                                        BillingPostalCode = '99999', BillingCountry='Australia',
                                   		BillingState='VIC', NumberofEmployees = 100,
                                        Phone = '000-000-0000',
                                        Website = 'www.test.com', 
                                        ParentId = parent[i].Id,
                                        RecordTypeId = recTypeId);
            accounts.add(temp);                         
        }
        return accounts;
    }    
    
    public static Account[] createAccounts(Integer count, String industry, Id recordTypeId){
        Account[] accounts = new Account[0];
        for(Integer i=0; i<count; i++){
            Account acct = new Account(Name = 'TEST_ACCOUNT' + i, 
                                        Industry = industry, 
                                        BillingStreet = '123 Main St', 
                                        BillingCity = 'NY', 
                                        BillingPostalCode = '99999', 
                                        BillingCountry='Australia',
                                   		BillingState='VIC', 
                                        NumberofEmployees = 10000,
                                        Phone = '000-000-0000', 
                                        //HQ_Phone__c = '000-000-0000',
                                        Website = 'www.test.com',
                                        ShippingState = 'VIC', 
                                        ShippingCountry = 'Australia');
            if(recordTypeId != null){ 
                acct.RecordTypeId = recordTypeId; 
            }
            accounts.add(acct);                         
        }
        return accounts;
    }
    
    
        
    
    
            
    
    
    
        
   
   
    public static List<Allowed_Record_Type__c> createCustomSettingData()
    {    
        List< Allowed_Record_Type__c> customSettingData = new List < Allowed_Record_Type__c>();
         Allowed_Record_Type__c custSettingData1 = new  Allowed_Record_Type__c(Name = 'RTypesForStageValidation', RecordTypes__c = 'CFB Opportunity;CFB Companies;CFB Intermediary;CFB Sponsor;CFB Test recordtype;CFB Testing Rtype;WCS;WCS Account;WCS Partner;Core Testing;CFL/ABL;Cross-border;ELP;ESSLP;Senior Only;Senior and Junior');
         customSettingData.add(custSettingData1);
         Allowed_Record_Type__c custSettingData2 = new  Allowed_Record_Type__c(Name = 'RTypesForTypeTransition', RecordTypes__c = 'CFB Opportunity;CFB Test recordtype;CFB Testing Rtype;WCS;Core Testing');
         customSettingData.add(custSettingData2);
         Allowed_Record_Type__c custSettingData3 = new  Allowed_Record_Type__c(Name = 'RTypesForCurrencyConversion', RecordTypes__c = 'CFB Opportunity;CFB Test recordtype;CFB Testing Rtype;WCS;Core Testing');
         customSettingData.add(custSettingData3);
         Allowed_Record_Type__c custSettingData4 = new  Allowed_Record_Type__c(Name = 'RTypesForDuplicateAccountCheck', RecordTypes__c = 'CFB Opportunity;CFB Test recordtype;CFB Testing Rtype;WCS;Core Testing');
         customSettingData.add(custSettingData4);
         Allowed_Record_Type__c custSettingData5 = new  Allowed_Record_Type__c(Name = 'RTypeForCFB', RecordTypes__c = 'CFB Opportunity;CFB');
         customSettingData.add(custSettingData5);
         Allowed_Record_Type__c custSettingData6= new  Allowed_Record_Type__c(Name = 'RTypesForAdminValidation', RecordTypes__c = 'CFB Opportunity;CFB Test recordtype;CFB Testing Rtype;WCS;Core Testing');
         customSettingData.add(custSettingData6);
         Allowed_Record_Type__c custSettingData7= new  Allowed_Record_Type__c(Name = 'RTypeForAccount', RecordTypes__c = 'WCS;WCS Account;WCS Partner;CFB Companies;CFB Intermediary;CFB Sponsor;Dummy CFB Core Testing');
         customSettingData.add(custSettingData7);
         Allowed_Record_Type__c custSettingData8= new  Allowed_Record_Type__c(Name = 'RTypeForUserCompliance', RecordTypes__c = 'House View;NDA acknowledgement');
         customSettingData.add(custSettingData8);
        Allowed_Record_Type__c custSettingData9= new  Allowed_Record_Type__c(Name = 'RTypeForContact', RecordTypes__c = 'EMEA Contact');
         customSettingData.add(custSettingData9);
        Allowed_Record_Type__c custSettingData10= new  Allowed_Record_Type__c(Name = 'RTypeForTask', RecordTypes__c = 'Task Check List');
         customSettingData.add(custSettingData10);
        Allowed_Record_Type__c custSettingData11= new  Allowed_Record_Type__c(Name = 'RTypesForDuplicateOpportunityCheck', RecordTypes__c = 'WCS;CFB Opportunity');
         customSettingData.add(custSettingData11);
        Allowed_Record_Type__c custSettingData12 = new  Allowed_Record_Type__c(Name = 'Deal Type', RecordTypes__c = 'Credit Line -New;Credit Line -Renew /Inc/Dec;Credit Review;New Program;Deal -Standalone'); 
        customSettingData.add(custSettingData12); 
        Allowed_Record_Type__c custSettingData13 = new  Allowed_Record_Type__c(Name = 'RTypeForOpportunity', RecordTypes__c = 'CFB Opportunity;CFB Test recordtype;CFB Testing Rtype;WCS;Core Testing;CFL/ABL;Cross-border;ELP;ESSLP;Senior Only;Senior and Junior;'); 
        customSettingData.add(custSettingData13); 
        Allowed_Record_Type__c custSettingData14 = new  Allowed_Record_Type__c(Name = 'RTypeForCallNote', RecordTypes__c = 'CFB Companies;CFB Intermediary;CFB Sponsor;EMEA Contact'); 
        customSettingData.add(custSettingData14); 
        
        return customSettingData ;
    }
    
    
    
    public static list<General_Properties__c> CreategeneralProperties(){
    
        list<General_Properties__c> generalproperties = new List <General_Properties__c>();
         
         General_Properties__c generalproperties1 = new  General_Properties__c(Name = 'House View', Value__c ='House View');
         generalproperties.add(generalproperties1);
         General_Properties__c generalproperties2 = new  General_Properties__c(Name = 'EmailOptOut_All', Value__c ='All');
         generalproperties.add(generalproperties2);
         General_Properties__c generalproperties3 = new  General_Properties__c(Name = 'EmailOptOut_ApprovalEmails', Value__c ='All Except Approval Emails');
         generalproperties.add(generalproperties3);
         General_Properties__c generalproperties4 = new  General_Properties__c(Name = 'TaskSubjectValues', Value__c ='Internal Fatal Flaw');
         generalproperties.add(generalproperties4);
         General_Properties__c generalproperties5 = new  General_Properties__c(Name = 'ProfilesExcludedInCodeExecution', Value__c ='System Administrator;~System Administrator');
         generalproperties.add(generalproperties5);
         General_Properties__c generalproperties6 = new  General_Properties__c(Name = 'Task Check List RecordTypeId', Value__c ='01290000000mPXk');
         generalproperties.add(generalproperties6);
         General_Properties__c generalproperties7 = new  General_Properties__c(Name = 'Approved By Compliance', Value__c ='Approved By Compliance');
         generalproperties.add(generalproperties7);
         General_Properties__c generalproperties8 = new  General_Properties__c(Name = 'CFB Opportunity', Value__c ='CFB Opportunity');
         generalproperties.add(generalproperties8);
         General_Properties__c generalproperties9 = new  General_Properties__c(Name = 'RegressionUrlPart', Value__c ='regression.salesforce');
         generalproperties.add(generalproperties9);
         General_Properties__c generalproperties10 = new  General_Properties__c(Name = 'Performing Waiver/Amendment', Value__c ='Performing Waiver/Amendment');
         generalproperties.add(generalproperties10);
         General_Properties__c generalproperties11 = new  General_Properties__c(Name = 'Intermediary', Value__c ='Intermediary');
         generalproperties.add(generalproperties11);
         General_Properties__c generalproperties12 = new  General_Properties__c(Name = 'Sponsor', Value__c ='Sponsor');
         generalproperties.add(generalproperties12);
         General_Properties__c generalproperties13 = new  General_Properties__c(Name = 'Not Tiered', Value__c ='Not Tiered');
         generalproperties.add(generalproperties13);
         General_Properties__c generalproperties14 = new General_Properties__c(Name='Decision_WindowTopURL',Org_Specific__c=false,Value__c='/sfdc/gecapital--regression.cs6.my');
         generalproperties.add(generalproperties14);
         General_Properties__c generalproperties15 = new General_Properties__c(Name='Account Extn Editable by Profiles',Value__c='WCS (Sales);WCS (Debtor Risk);WCS (Third Party);WCS (Capital Markets);WCS (Super User);System Administrator;~System Administrator');
         generalproperties.add(generalproperties15);
         General_Properties__c generalproperties16 = new General_Properties__c(Name='Ageing Limit',Value__c='10');
         generalproperties.add(generalproperties16);
         General_Properties__c generalproperties17 = new General_Properties__c(Name='Credit Line -New',Value__c='Credit Line -New');
         generalproperties.add(generalproperties17);
         General_Properties__c generalproperties18 = new General_Properties__c(Name='Credit Line -Renew /Inc/Dec',Value__c='Credit Line -Renew /Inc/Dec');
         generalproperties.add(generalproperties18);
         General_Properties__c generalproperties19 = new General_Properties__c(Name='Reject',Value__c='Reject');
         generalproperties.add(generalproperties19);
         General_Properties__c generalproperties20 = new General_Properties__c(Name='Pending',Value__c='Pending');
         generalproperties.add(generalproperties20);
         General_Properties__c generalproperties21 = new General_Properties__c(Name='Approval validation profiles exemption',Value__c='WCS (Sales);WCS (Third Party);WCS (Super User);WCS (Debtor Risk);WCS (Risk);System Administrator;~System Administrator');
         generalproperties.add(generalproperties21);
         General_Properties__c generalproperties22 = new General_Properties__c(Name='WCS ER CR Profiles exemption',Value__c='WCS (Sales);WCS (Capital Markets);WCS (Third Party);WCS (Super User);System Administrator;~System Administrator');
         generalproperties.add(generalproperties22);
         General_Properties__c generalproperties23 = new General_Properties__c(Name='WCS Submit for Credit Request',Value__c='Due Diligence');
         generalproperties.add(generalproperties23);
         General_Properties__c generalproperties24 = new General_Properties__c(Name='WCS Submit for Early Read',Value__c='PIC Creation');
         generalproperties.add(generalproperties24);
         
         General_Properties__c generalproperties25 = new General_Properties__c(Name='Legal Entity',Value__c='Legal Entity');
         generalproperties.add(generalproperties25);
         General_Properties__c generalproperties26 = new General_Properties__c(Name='DAM Submitted',Value__c='DAM Submitted');
         generalproperties.add(generalproperties26); 
         General_Properties__c generalproperties27 = new General_Properties__c(Name='Servicing Assignment',Value__c='Servicing');
         generalproperties.add(generalproperties27); 
         General_Properties__c generalproperties28 = new General_Properties__c(Name='Monetization Assignment',Value__c='Monetization');
         generalproperties.add(generalproperties28);                     
         General_Properties__c generalproperties29 = new General_Properties__c(Name='CFB Intermediary',Value__c='CFB Intermediary');
         generalproperties.add(generalproperties29); 
         General_Properties__c generalproperties30 = new General_Properties__c(Name='CFB Sponsor',Value__c='CFB Sponsor');
         generalproperties.add(generalproperties30);  
         General_Properties__c generalproperties31 = new General_Properties__c(Name='WCS (Debtor Risk)',Value__c='WCS (Debtor Risk)');
         generalproperties.add(generalproperties31); 
         General_Properties__c generalproperties32 = new General_Properties__c(Name='WCS (Servicing Integrations)',Value__c='WCS (Servicing Integrations)');
         generalproperties.add(generalproperties32);  
         General_Properties__c generalproperties33 = new General_Properties__c(Name='WCS (Integrations)',Value__c='WCS (Integrations)');
         generalproperties.add(generalproperties33);   
         General_Properties__c generalproperties34 = new General_Properties__c(Name='WCS Opportunity Record Type Name',Value__c='WCS');
         generalproperties.add(generalproperties34); 
         General_Properties__c generalproperties35 = new General_Properties__c(Name='TabDisplay_#ERM_WCS',Value__c='Early Read');
         generalproperties.add(generalproperties35);
         General_Properties__c generalproperties36 = new General_Properties__c(Name='WCS Partner RecordType Name',Value__c='WCS Partner');
         generalproperties.add(generalproperties36); 
         General_Properties__c generalproperties37 = new  General_Properties__c(Name = 'Deal Approval In Progress', Value__c ='Deal Approval In Progress (CC/CMS)');
         generalproperties.add(generalproperties37);    
         General_Properties__c generalproperties38 = new  General_Properties__c(Name = 'Deal Approval Submission', Value__c ='Deal Approval Submission (CC/CMS)');
         generalproperties.add(generalproperties38); 
         General_Properties__c generalproperties39 = new  General_Properties__c(Name = 'IndInfoAccountName', Value__c ='00Nd00000034ctF');
         generalproperties.add(generalproperties39); 
         General_Properties__c generalproperties40 = new  General_Properties__c(Name = 'IndInfoCountry', Value__c ='00NO00000019FPH');
         generalproperties.add(generalproperties40); 
         General_Properties__c generalproperties41 = new  General_Properties__c(Name = 'Opportunity_Platform_ID_Value', Value__c ='00Nd0000005dKo0');
         generalproperties.add(generalproperties41);
         General_Properties__c generalproperties42 = new  General_Properties__c(Name = 'Opportunity_Pole_Id_Value', Value__c ='00N90000002MY1a');
         generalproperties.add(generalproperties42); 
         General_Properties__c generalproperties43 = new  General_Properties__c(Name = 'Opportunity_Product_Id_Value', Value__c ='00Nd0000006b05q');
         generalproperties.add(generalproperties43); 
         General_Properties__c generalproperties44 = new  General_Properties__c(Name = 'Opportunity_Request_Type_Id_value', Value__c ='00N900000030YO3');
         generalproperties.add(generalproperties44); 
         General_Properties__c generalproperties45 = new  General_Properties__c(Name = 'Opportunity_Risk_Analyst_Id_value', Value__c ='CF00Nd0000006cSaq');
         generalproperties.add(generalproperties45); 
         General_Properties__c generalproperties46 = new  General_Properties__c(Name = 'Opportunity_Sub_Business_Id_Value', Value__c ='00Nd0000005dKod');
         generalproperties.add(generalproperties46);
         General_Properties__c generalproperties47 = new  General_Properties__c(Name = 'PIC_Early_Read_Approval_In_Progress', Value__c ='PIC/Early Read Approval In Progress');
         generalproperties.add(generalproperties47); 
         General_Properties__c generalproperties48 = new  General_Properties__c(Name = 'PIC_Early_Read_Submission', Value__c ='PIC/Early Read Submission');
         generalproperties.add(generalproperties48); 
         General_Properties__c generalproperties49 = new  General_Properties__c(Name = 'Partner_Field_ID_On_Opportunity', Value__c ='CF00N90000000mJzJ_lkid');
         generalproperties.add(generalproperties49);
         General_Properties__c generalproperties50 = new  General_Properties__c(Name = 'Partner_Name_Field_ID_On_Opportunity', Value__c ='CF00N90000000mJzJ');
         generalproperties.add(generalproperties50);
         General_Properties__c generalproperties51 = new  General_Properties__c(Name = 'Stage_Default_Value', Value__c ='Lead');
         generalproperties.add(generalproperties51);
         General_Properties__c generalproperties52 = new  General_Properties__c(Name = 'Sub_stage_value_Booked', Value__c ='Booked');
         generalproperties.add(generalproperties52); 
         General_Properties__c generalproperties53 = new  General_Properties__c(Name = 'Sub_stage_value_lost', Value__c ='Lost');
         generalproperties.add(generalproperties53); 
         General_Properties__c generalproperties54 = new  General_Properties__c(Name = 'WCS Account Record Type', Value__c ='WCS Account');
         generalproperties.add(generalproperties54); 
         General_Properties__c generalproperties55 = new  General_Properties__c(Name = 'WCS Compliance Profile', Value__c ='WCS (Compliance)');
         generalproperties.add(generalproperties55); 
         General_Properties__c generalproperties56 = new  General_Properties__c(Name = 'WCSKYCOwnerFieldId', Value__c ='CF00NN00000011duM');
         generalproperties.add(generalproperties56);   
         General_Properties__c generalproperties57 = new  General_Properties__c(Name = 'WCS Capital Profile', Value__c ='WCS (Capital Markets)');
         generalproperties.add(generalproperties57); 
         General_Properties__c generalproperties58 = new  General_Properties__c(Name = 'WCS Risk Profile', Value__c ='WCS (Risk)');
         generalproperties.add(generalproperties58);  
         General_Properties__c generalproperties59 = new  General_Properties__c(Name = 'WCS Sales Profile', Value__c ='WCS (Sales)');
         generalproperties.add(generalproperties59);      
         General_Properties__c generalproperties60 = new  General_Properties__c(Name = 'WCS Securitizations Role', Value__c ='WCS Securitizations');
         generalproperties.add(generalproperties60);
         General_Properties__c generalproperties61 = new  General_Properties__c(Name = 'WCS Syndications Role', Value__c ='WCS Syndications');
         generalproperties.add(generalproperties61);    
         General_Properties__c generalproperties62 = new  General_Properties__c(Name = 'WCS ThirdParty Profile', Value__c ='WCS (Third Party)');
         generalproperties.add(generalproperties62);    
         General_Properties__c generalproperties63 = new  General_Properties__c(Name = 'Closing Memo Stages', Value__c ='Closing Contract Approval In Progress');
         generalproperties.add(generalproperties63);    
         General_Properties__c generalproperties64 = new  General_Properties__c(Name = 'Portfolio Close Date', Value__c ='30');
         generalproperties.add(generalproperties64);  
         General_Properties__c generalproperties65 = new  General_Properties__c(Name = 'In Progress', Value__c ='In Progress');
         generalproperties.add(generalproperties65); 
         General_Properties__c generalproperties66 = new  General_Properties__c(Name = 'Complete/Closed', Value__c ='Complete/Closed');
         generalproperties.add(generalproperties66);     
         General_Properties__c generalproperties67 = new  General_Properties__c(Name = 'PerspecsysURL', Value__c ='https://regression.salesforce.capital.ge.com/');
         generalproperties.add(generalproperties67); 
         General_Properties__c generalproperties68 = new  General_Properties__c(Name = 'Opportunity_Local_Stage_Id_Value', Value__c ='00N9000000CcfaU');
         generalproperties.add(generalproperties68);                                            
         General_Properties__c generalproperties69 = new  General_Properties__c(Name = 'WCS Debtor Supported Request Type', Value__c ='New Debtor Limit;Debtor Limit Renewal;Debtor Review;Debtor Watchlist Review;Amendment');
         generalproperties.add(generalproperties69);
         General_Properties__c generalproperties70 = new  General_Properties__c(Name = 'Request Types', Value__c ='Client Review;Debtor Limit Renewal;Debtor Review;Debtor Watchlist Review;New Debtor Limit');
         generalproperties.add(generalproperties70);
         General_Properties__c generalproperties71 = new  General_Properties__c(Name = 'WCS Client Risk Request Type', Value__c ='New;Recurring;Renewal');
         generalproperties.add(generalproperties71);
         General_Properties__c generalproperties72 = new  General_Properties__c(Name = 'WCS Debtor Risk Roles', Value__c ='WCS Lead Underwriter;WCS Pole Leader;WCS Underwriter');
         generalproperties.add(generalproperties72);
         General_Properties__c generalproperties73 = new  General_Properties__c(Name = 'WCS Product Details validation', Value__c ='Amendment;New;Recurring; Renewal');
         generalproperties.add(generalproperties73);
         General_Properties__c generalproperties74 = new  General_Properties__c(Name = 'Org Wide Email Address EMEA', Value__c ='0D290000000CbqhCAC');
         generalproperties.add(generalproperties74);
         General_Properties__c generalproperties75 = new  General_Properties__c(Name = 'CFB', Value__c ='CFB');
         generalproperties.add(generalproperties75);
         General_Properties__c generalproperties76 = new  General_Properties__c(Name = 'WCS (Super User)', Value__c ='WCS (Super User)');
         generalproperties.add(generalproperties76);
         General_Properties__c generalproperties77= new  General_Properties__c(Name = 'Factoring', Value__c ='Factoring');
         generalproperties.add(generalproperties77);
         General_Properties__c generalproperties78 = new  General_Properties__c(Name = 'Syndication', Value__c ='Syndication');
         generalproperties.add(generalproperties78);
         General_Properties__c generalproperties79 = new  General_Properties__c(Name = 'Securitization', Value__c ='Securitization');
         generalproperties.add(generalproperties79);
         General_Properties__c generalproperties80 = new  General_Properties__c(Name = 'Deal Closed', Value__c ='Deal Closed');
         generalproperties.add(generalproperties80);
         General_Properties__c generalproperties81 = new  General_Properties__c(Name = 'New', Value__c ='New');
         generalproperties.add(generalproperties81);
         General_Properties__c generalproperties82 = new  General_Properties__c(Name = 'Renewal', Value__c ='Renewal');
         generalproperties.add(generalproperties82);
         General_Properties__c generalproperties83 = new  General_Properties__c(Name = 'House View Partner Record', Value__c ='001900000195QjjAAE');
         generalproperties.add(generalproperties83);
          General_Properties__c generalproperties84 = new  General_Properties__c(Name = 'HQ Reassign By', Value__c ='Gareth Bird');
         generalproperties.add(generalproperties84);
         General_Properties__c generalproperties85 = new  General_Properties__c(Name = 'CFB Capitalmarket', Value__c ='CFB Capitalmarket');
         generalproperties.add(generalproperties85);
         General_Properties__c generalproperties86 = new  General_Properties__c(Name = '01.a) Immediate oppo', Value__c ='Opportunity Identified');
         generalproperties.add(generalproperties86);
         General_Properties__c generalproperties87 = new  General_Properties__c(Name = '01.b) No opportunity', Value__c ='For Followup');
         generalproperties.add(generalproperties87);
         //BEGIN MLASALA: 04-APR-16 TQLQW-127 Re-brand
         General_Properties__c generalproperties88 = new  General_Properties__c(Name = 'CFB Origination DL', Value__c ='mayank.jain'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX);
         generalproperties.add(generalproperties88);
         General_Properties__c generalproperties89 = new  General_Properties__c(Name = 'All CFB DL', Value__c ='mayank.jain'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX);
         //END MLASALA: 04-APR-16 TQLQW-127 Re-brand
         generalproperties.add(generalproperties89);
         General_Properties__c generalproperties90 = new  General_Properties__c(Name = 'Portfolio Live', Value__c ='Portfolio Live');
         generalproperties.add(generalproperties90);
         General_Properties__c generalproperties91 = new  General_Properties__c(Name = 'Recurring', Value__c ='Recurring');
         generalproperties.add(generalproperties91);
         General_Properties__c generalproperties92 = new  General_Properties__c(Name = 'Factoring - Non Standard', Value__c ='Factoring - Non Standard');
         generalproperties.add(generalproperties92);
         
         General_Properties__c generalproperties93 = new  General_Properties__c(Name = 'Closed', Value__c ='Closed');
         generalproperties.add(generalproperties93);
         General_Properties__c generalproperties94 = new  General_Properties__c(Name = 'In Integrations', Value__c ='In Integrations');
         generalproperties.add(generalproperties94);
         General_Properties__c generalproperties95 = new  General_Properties__c(Name = 'Funding/Third Party Funding', Value__c ='Funding/Third Party Funding');
         generalproperties.add(generalproperties95);
         
         General_Properties__c generalproperties96 = new  General_Properties__c(Name = 'Closing Memo', Value__c ='Closing Memo');
         generalproperties.add(generalproperties96);
         General_Properties__c generalproperties97 = new  General_Properties__c(Name = 'Return From Risk', Value__c ='Return From Risk');
         generalproperties.add(generalproperties97);
         General_Properties__c generalproperties98 = new  General_Properties__c(Name = 'Inactive', Value__c ='Inactive');
         generalproperties.add(generalproperties98);
         General_Properties__c generalproperties99 = new  General_Properties__c(Name = 'Risk Analyst', Value__c ='Risk Analyst');
         generalproperties.add(generalproperties99);
         General_Properties__c generalproperties100 = new  General_Properties__c(Name = 'Owner', Value__c ='Owner');
         generalproperties.add(generalproperties100);
         
         
         return generalproperties ;
    }
    
    
        
    public static list<General_Properties__c> CreateContactStrategyManagement(){
    
         list<General_Properties__c> customSettingContactStrategy= new List <General_Properties__c>();
         
             General_Properties__c customSettingContactStrategy1 = new  General_Properties__c(Name = 'Annually',value__c = '365');
             customSettingContactStrategy.add(customSettingContactStrategy1);
             General_Properties__c customSettingContactStrategy2= new  General_Properties__c(Name = 'Fortnightly',value__c = '15');
             customSettingContactStrategy.add(customSettingContactStrategy2);
             General_Properties__c customSettingContactStrategy3= new  General_Properties__c(Name = 'Monthly',value__c = '30');
             customSettingContactStrategy.add(customSettingContactStrategy3);
             General_Properties__c customSettingContactStrategy4= new  General_Properties__c(Name = 'No Contact',value__c = '0');
             customSettingContactStrategy.add(customSettingContactStrategy4);
             General_Properties__c customSettingContactStrategy5= new  General_Properties__c(Name = 'Quarterly',value__c = '90');
             customSettingContactStrategy.add(customSettingContactStrategy5);
             General_Properties__c customSettingContactStrategy6= new  General_Properties__c(Name = 'Semi-Annually',value__c = '180');
             customSettingContactStrategy.add(customSettingContactStrategy6);
             General_Properties__c customSettingContactStrategy7= new  General_Properties__c(Name = 'Weekly',value__c = '7');
             customSettingContactStrategy.add(customSettingContactStrategy7);
             return customSettingContactStrategy;
        }
        
    
    
    
    
    
    public static List<Account> CreateAccount(Integer Size){
        List<Account> myAccounts = new List<Account>();
        for(Integer i = 0;i<=Size;i++){
            myAccounts.add(New Account(Name = 'TestAccName__'+i,industry = 'Agriculture',
                                        BillingStreet = '123 Main St', BillingCity = 'NA', 
                                        BillingPostalCode = '999999', BillingCountry='Australia',
                                  	    BillingState='VIC', NumberofEmployees = 100,
                                        Phone = '000-000-0000',Merchant_ID_Group__c = 'Cards AU',ABN__c = '58725115040',                       
                                        Website = 'www.test.com',Primary_Business_Unit__c='Consumer',Consumer_Accreditation_cons__c=true, 
                                        Location__Longitude__s=(-122.418+ (Size-10)), 
                                        Location__Latitude__s = (-80.00+ (Size-10))));
        }
        return myAccounts;
    }
    
    
    public static List<Account> CreateAccountMerchant(Integer Size,string recordTypeId,string Accreditationstatus,string MerchantIDGroup){
      List<Account> myAccounts = new List<Account>();
      for(Integer i = 0;i<=Size;i++){
        myAccounts.add(New Account(Name = 'TestAccName__'+i,
                                   recordTypeId = recordTypeId,
                                   Account_Accreditation_Status_cons__c =  Accreditationstatus,
                                   Merchant_ID_Group__c = MerchantIDGroup ,
                                   BillingCity='TestCity', 
                                   BillingCountry='Australia',
                                   BillingState='VIC', 
                                   ShippingCountry = 'Australia',
                                   ShippingState='VIC',
                                   abn__c='58725115040'));
      }
      return myAccounts;
    }
    
       
       
        public static List<Account> CreateAcctBatchcurrency(Integer Size){
        List<Account> myAccounts = new List<Account>();
        for(Integer i = 0;i<=Size;i++){
            myAccounts.add(New Account(Name = 'TestAccName__'+i,industry = 'Agriculture',
                                        BillingStreet = '123 Main St', BillingCity = 'NA', 
                                        BillingPostalCode = '999999', BillingCountry='Australia',
                                   		BillingState='VIC', NumberofEmployees = 100,
                                        Phone = '000-000-0000',Merchant_ID_Group__c = 'Cards AU',ABN__c = '58725115040',                      
                                        Website = 'www.test.com'
                                         /*Fleet_Limit_RSUM__c=250000*/ ));
        }
        return myAccounts;
    }
    
    
    public static List<ABN_Balances__c> CreateABNBalance(String Ident, Integer Size){
      List<ABN_Balances__c> myABNBalances = new List<ABN_Balances__c>();
      for(Integer i = 0;i<=Size;i++){
        myABNBalances.add(New ABN_Balances__c(GroupID__c = Ident+i+'__GID', EF_Revolving_Balance__c = 21321, 
                                              EF_Balance__c = 3213, CFS_Balance__c = 321421, ABN_NZ_COMPANY_NO__c = '58725115040'));
      }
      return myABNBalances;
    }
    
    
    
     public static List<Merchant_ID__c> CreateMerchantid (Integer Size,String CurrencyIsoCode, id accountid,integer MerchantNumber,string GroupMerchantNumber){
      List<Merchant_ID__c> myMerchantid = new List<Merchant_ID__c>();
      for(Integer i = 0;i<=Size;i++){
        myMerchantid.add(New Merchant_ID__c(Account__c = accountid,Merchant_Number__c = MerchantNumber,
                                             Group_Merchant_Number__c = GroupMerchantNumber));
      }
      return myMerchantid;
    }
    
    
    public static List<Account> CreateAccountDormant(Integer Size, Id recTypeId){
        List<Account> myAccounts = new List<Account>();
        for(Integer i = 0;i<=Size;i++){
        myAccounts.add(New Account(Name = 'TestAccName__'+i,Classification_Primary__c = 'Dormant', RecordTypeId = recTypeId));
        }
        return myAccounts;
    }   
    
    
  
    public static Contact[] createContacts(Integer count, Id accountId){
        Contact[] contacts = new Contact[0];
        for(Integer i=0; i<count; i++){
            contacts.add(new Contact(FirstName = 'TEST'+i, LastName = 'CONTACT', AccountId = accountId,Primary_Contact__c=true));                           
        }
        return contacts;
    }
    
   
   
    
       
   
  
    public static UserRole [] createRoles (List<String> roleNames) {
        
        List<UserRole> roles = new List<UserRole>();
        for (String roleName : roleNames) {
            roles.add(new UserRole(name = roleName));
        }

        return roles;
    }
    
    public static User[] createUsers(Integer count, String profile_name, String role_name, String currencyCode){
        User[] users = new User[0];
        for(Integer i=0; i < count; i++){
            //BEGIN MLASALA: 04-APR-16 TQLQW-127 Re-brand
            String email = System.now().getTime() + '_test_' + i +''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;
            users.add(new User(Alias = '123'+i, 
                                Email = 'general' + i +''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,
            //END MLASALA: 04-APR-16 TQLQW-127 Re-brand
                                EmailEncodingKey = 'UTF-8', 
                                LastName = 'Generaltesting'+i, 
                                LanguageLocaleKey = 'en_US',
                                LocaleSidkey = 'en_US', 
                                Profile = new Profile(Name = profile_name), 
                                UserRole = new UserRole(Name = role_name), 
                                Country = 'United States', 
                                Timezonesidkey = 'America/Los_Angeles',
                                 Business_Unit__c='AIR' , 
                                Username = email));   
        }
        return users;
    }

     public static User createUsers(Integer n, Id profileId, Id roleId){
        User[] users = new User[0];
         
        for(Integer i=0; i<n; i++){
            users.add(new User(Alias = '123'+i, Email = i +'test123'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,     //MLASALA: 04-APR-16 TQLQW-127 Re-brand
                                EmailEncodingKey = 'UTF-8', LastName = 'generalTesting'+i, LanguageLocaleKey = 'en_US',
                                LocaleSidkey = 'en_US', Profileid = profileId, Userroleid = roleId, 
                                Country = 'United States', Timezonesidkey = 'America/Los_Angeles', 
                                Username = 'generalTesting123@noemail.com'+i,Business_Unit__c = 'HS'));   
                                
         }
        return users[0];
    }   
    
        
    public String createRandomWord(){
      String ret = 'word' + math.rint( math.random() * 100000 );
      
      return ret;
    }  
   
   /***Used for Risk review****/ 
   
     //User builder
    public static User CreateUSer(String username,String profileid,String userrole){
        User newUser = new User();
        newUser.alias = 'standt'; 
        newUser.Business_Unit__c='Aircraft (AIR)';
        newUser.country='New Zealand';
        newUser.email='standarduser'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;     //MLASALA: 04-APR-16 TQLQW-127 Re-brand
        newUser.emailencodingkey='UTF-8';
        newUser.lastname='Testing';
        newUser.languagelocalekey='en_US';  
        newUser.localesidkey='en_IN'; 
        newUser.profileid = profileid; 
        newUser.TimeZoneSidKey='America/Los_Angeles';
        newUser.username=username;
        newUser.userRoleId= userrole; 
        return newUSer;
    }   
     
    
        public static List<Event> CreateEvent(Integer Size,id accountId,id ContactId ){
        List<Event> myEvents = new List<Event>();
        for(Integer i = 0;i<=Size;i++){
            myEvents.add(New Event(
                                    
                                    Subject = 'test_acc', 
                                    StartDateTime = System.Datetime.now(), 
                                    EndDateTime = System.Datetime.now(), 
                                    OwnerId = System.Userinfo.getUserId(), 
                                    WhoId = ContactId, 
                                    WhatId = accountId));
        }
        return myEvents;
    }
    
    
    //Task Creation
    public static List<Task> CreateTask(Integer Size,id WhoId,id WhatId ){
        List<Task> myTasks = new List<Task>();
        for(Integer i = 0;i<=Size;i++){
            myTasks.add(New Task(Subject = 'Call',
                                    Description = 'Sample Description',
                                    Type = 'Meeting',
                                    OwnerId = System.Userinfo.getUserId(),
                                    WhoId = WhoId, 
                                    WhatId = WhatId));
        }
        return myTasks;
    }
    
    
    
    
    //Record type builder
    public static ID getRecordType(String rName){
        ID recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rName).getRecordTypeId();
        return recordTypeId;
    }

    //Custom setting builder
    public static General_Properties__c CreateCustomSetting(String cname,String value){
        General_Properties__c profileCustomSetting = new General_Properties__c(Name = cname,Value__c = value);
        return profileCustomSetting;
    }
    
    
  
    /**
    * Description : Metnod used to create user using input as profile Name, UserRole, Username, Country
    */ 
    public static User createUserUserRole(string countryName,string busUnit, ID profileID, string userName, ID userRoleID){
        User u = new User();
        u.alias = 'standt';
        u.email='standarduser'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;     //MLASALA: 04-APR-16 TQLQW-127 Re-brand
        u.country=countryName;
        u.emailencodingkey='UTF-8';
        u.lastname='Testing';
        u.languagelocalekey='en_US';
        u.localesidkey='en_US';
        u.profileid = profileId;     
        u.userRoleId = userRoleId;
        u.timezonesidkey='America/Los_Angeles';
        u.username=userName;
        u.Business_Unit__c=busUnit;
        return u;   
        
    }
 
    
       //00000
      // This Method is used to create promotions for BatchUpdateProgramStrategyTest
   public static List<Promotions__c> createPromotions(Integer Size, Id AccountId)
    {       
    
    List<Promotions__c> PromotionsLst = new List<Promotions__c>();        
        for(Integer i = 0;i<=Size;i++){
            PromotionsLst.add(New Promotions__c(Name = 'Prom'+i, 
                                                Promotion_Group_Account__c =AccountId,
                                                Promotion_Type__c = 'type' +i,
                                                Product_Categories__c = 'Pcatgry' +i, 
                                                Term_Value__c = 10.0,
                                                Term_Period__c ='Days',
                                                Start_Date__c =System.Today() ,
                                                End_Date__c = System.Datetime.now().addDays(2).Date(),
                                                MSF__c = 10.0,
                                                Minimum_Purchase__c = 10.0,
                                                Channels__c = 'Online'));
        }

        return PromotionsLst;
    } 
    
       public static List<Account> accountCreation(){
            List<Account> myAccounts = new List<Account>();
            for(integer i=0;i<=5;i++){
            myAccounts.add(new account(Name = 'TestAccName__'+i,industry = 'Banks',
                                        BillingStreet = '123 Main St', BillingCity = 'NA', 
                                        BillingPostalCode = '999999', BillingCountry='Australia',
                                   		BillingState='VIC', NumberofEmployees = 100,
                                        Phone = '000-000-0000',Merchant_ID_Group__c = 'Cards AU',ABN__c = '58725115040',                       
                                        Website = 'www.test.com',Primary_Business_Unit__c='Consumer',Consumer_Accreditation_cons__c=true, 
                                        ASPAC_FEF_Region__c = 'South'));
            }
            //insert myAccounts;
            return myAccounts;
     } 
     public static List<Contact> createContacts(Integer Size){
        List<Contact> contactslist = new List<Contact>();
        for(Integer i=0; i<Size; i++){
            contactslist.add(new Contact(FirstName = 'TEST'+i, LastName = 'CONTACT', Email='ABC.XYZ@gmail.com'));                           
        }
        return contactslist;
    }
    
    
    
 }