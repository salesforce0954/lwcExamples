/* Name        - updateAccreditationStatusTest
* Description  - This is a test class for the class "updateAccreditationStatus"
* Pavankumar         4/29/2014               Created.                         */ 
@isTest
private class updateAccreditationStatusTest {
    
    public static testMethod void updToContact() {
        
        
        
        
       list<Account> acct = TestingUtils.CreateAccount(1);
        Integer ctr = 1;
        for(Account a : acct)
        {
           a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
           ctr++;
        }
        insert acct;
        acct[0] = new Account(Name = 'TestAcc', Type='Cards AUS', BillingCountry='AUS',Accreditation_Account_Type__c='Group');
        insert acct[0];
        testingUtils.clear_execution_flags();
        
        //Contact cont = new Contact(accountId = acct.id, FirstName ='Test', LastName = 'User', Primary_Contact__c = true,Aggregator_Name__c = 'test');
        list<Contact> cont = TestingUtils.createContacts(1, acct[0].Id);
        insert cont;
        testingUtils.clear_execution_flags();
        
        test.startTest();
        Accreditation__c acc = new Accreditation__c(Account__c = acct[0].id,Merchant_Number_Generated__c=true, Accreditation_Process_Stage__c ='Initiate', 
                                          Contact__c=cont[0].id, Accreditation_Status__c='Merchant', Broker_Product__c='GEFP', 
                                          Accreditation_Active_Date__c=Date.Today(),Aggregator__c=acct[0].Id);

        insert acc;
        testingUtils.clear_execution_flags();
        test.stopTest();
        
        Contact ContAssert = [select id,Contact_Accreditation_Status__c from Contact where id = :cont[0].id];
        Account acctAssert = [select id,Account_Accreditation_Status_cons__c from Account where id = :acct[0].id];
        //system.assertEquals(contAssert.Contact_Accreditation_Status__c, acc.Accreditation_Status__c);
        //system.assertNotEquals(contAssert.Contact_Accreditation_Status__c, acc.Accreditation_Status__c);
        //system.assertNotEquals(acctAssert.Account_Accreditation_Status_cons__c, acc.Accreditation_Status__c);
        utils.get_apex_profile();
    }


    public static testMethod void updToNoContact() {
        
        Id AccRecTypeId = Schema.SObjectType.Accreditation__c.RecordTypeInfosByName.get('Broker').RecordTypeId;
        Id AccntRecTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Broker AU (Motor/PL)').RecordTypeId;
        
        list<Account> acct = TestingUtils.CreateAccounts(1, 'Banking', AccntRecTypeId);
        insert acct;
        
        TestingUtils.clear_execution_flags();  
        
        test.startTest();

        Accreditation__c acc = new Accreditation__c(Account__c = acct[0].id, Name = 'ACC1', Accreditation_Process_Stage__c ='Application in Progress', 
                                          Accreditation_Type__c = 'Account', Account_Type__c = 'Auto', Accreditation_Status__c = 'Active',
                                          RecordTypeId = AccRecTypeId, Broker_Product__c = 'PL');

        insert acc;

        test.stopTest();
        
        TestingUtils.clear_execution_flags();  
        
        Account acctAssert = [select id,Account_Accreditation_Status_cons__c from Account where id = :acct[0].id];
        system.assertEquals(acctAssert.Account_Accreditation_Status_cons__c, acc.Accreditation_Status__c);
        utils.get_apex_profile();
    }
    
  

}