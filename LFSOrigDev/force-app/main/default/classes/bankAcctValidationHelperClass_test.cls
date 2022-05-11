/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class bankAcctValidationHelperClass_test {

     static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
              
        Schema.DescribeSObjectResult d = Schema.SObjectType.Debit__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        string recType=rtMapByName.get('Direct Debit').getRecordTypeId();
        list<Account> a=TestDataBuilder.createAccounts(1);
        
        insert a;
        
        Application__c app=TestDataBuilder.createApplication();
        app.Channel__c = 'Broker';
        insert app;
        
        List<Insurance_Premium_Calculation_Variables__c> inPrmm=TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert inPrmm;
        
        list<Bank__c> b=new list<Bank__c>();
        b.addAll(TestDataBuilder.createBank());
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        list<Algorithm__c> algs=TestDataBuilder.createAlgorithms();
        insert algs;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;
        
        Profile_Country__c prCountry = new Profile_Country__c(SetupOwnerId = Userinfo.getProfileId(),NZ__c = true);
		insert prCountry;
        
        Debit__c dB=TestDataBuilder.createDebit(recType,app.id);
        db.Account_Holders__c='aaa111';
        db.Account_Number__c='68389';
        db.Branch_Number__c='902';
        db.Bank_Number__c='1';
        db.Suffix_Number__c='0000';
        insert dB;
        
        Disbursement__c DS=TestDataBuilder.createDisbursementPayee1(app.id,null);
        insert DS;
        
            
    }
    
         static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        
              
        Schema.DescribeSObjectResult d = Schema.SObjectType.Debit__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        string recType=rtMapByName.get('Direct Debit').getRecordTypeId();
        list<Account> a=TestDataBuilder.createAccounts(1);
        
        insert a;
        
        Application__c app=TestDataBuilder.createApplication();
        app.Channel__c = 'Broker';
        insert app;
        
        List<Insurance_Premium_Calculation_Variables__c> inPrmm=TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert inPrmm;
        
        list<Bank__c> b=new list<Bank__c>();
        b.addAll(TestDataBuilder.createBank());
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        list<Algorithm__c> algs=TestDataBuilder.createAlgorithms();
        insert algs;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;
        
        Profile_Country__c prCountry = new Profile_Country__c(SetupOwnerId = Userinfo.getProfileId(),NZ__c = true);
		insert prCountry;
        
        
        List<Debit__c> debitList=new List<Debit__c>();
        
        Debit__c dB1=TestDataBuilder.createDebit(recType,app.id);
        db1.Account_Holders__c='aaa$$111';
        db1.Account_Number__c='68a89';
        db1.Branch_Number__c='902a';
        db1.Bank_Number__c='1a';
        db1.Suffix_Number__c='000a';
    	debitList.add(db1);
        
                
        Debit__c dB2=TestDataBuilder.createDebit(recType,app.id);
        dB2.Account_Holders__c='aaa111';
        dB2.Account_Number__c='68a89';
        dB2.Branch_Number__c='902a';
        dB2.Bank_Number__c='1a';
        dB2.Suffix_Number__c='000a';
    	debitList.add(db2);
        
        Debit__c dB3=TestDataBuilder.createDebit(recType,app.id);
        dB3.Account_Holders__c='aaa111';
        dB3.Account_Number__c='68389';
        dB3.Branch_Number__c='902a';
        dB3.Bank_Number__c='1a';
        dB3.Suffix_Number__c='000a';
    	debitList.add(db3);
        
        Debit__c dB4=TestDataBuilder.createDebit(recType,app.id);
        dB4.Account_Holders__c='aaa111';
        dB4.Account_Number__c='68389';
        dB4.Branch_Number__c='902';
        dB4.Bank_Number__c='1a';
        dB4.Suffix_Number__c='000a';
    	debitList.add(db4);
        
        Debit__c dB5=TestDataBuilder.createDebit(recType,app.id);
        dB5.Account_Holders__c='aaa111';
        dB5.Account_Number__c='68389';
        dB5.Branch_Number__c='902';
        dB5.Bank_Number__c='1';
        dB5.Suffix_Number__c='000a';
    	debitList.add(db5);
        	
        
		database.insert(debitList,false);
        
        Disbursement__c DS=TestDataBuilder.createDisbursementPayee1(app.id,null);
        insert DS;
        
            
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Debit__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        string recType=rtMapByName.get('Direct Debit').getRecordTypeId();
        list<Account> a=TestDataBuilder.createAccounts(1);
        
        insert a;
        
        Application__c app=TestDataBuilder.createApplication();
        app.Channel__c = 'Broker';
        
        insert app;
        
        List<Insurance_Premium_Calculation_Variables__c> inPrmm=TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert inPrmm;
        
        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        list<Algorithm__c> algs=TestDataBuilder.createAlgorithms();
        insert algs;
        
        payee__c pay=TestDataBuilder.createPayee();
        insert pay;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;
        
        Profile_Country__c prCountry = new Profile_Country__c(SetupOwnerId = Userinfo.getProfileId(),NZ__c = true);
		insert prCountry;
        
        Disbursement__c DS=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        DS.Account_Holders__c='aaa111';
        DS.Bank_Acc_No__c='68389';
        DS.Branch_Number__c='902';
        DS.Bank_Number__c='1';
        DS.Suffix_Number__c='0000';
        insert DS;
        
    }
    
    /*static testMethod void myUnitTest3() {
        // TO DO: implement unit test fail case
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Debit__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        string recType=rtMapByName.get('Direct Debit').getRecordTypeId();
        list<Account> a=TestDataBuilder.createAccounts(1);
        
        insert a;
        
        Application__c app=TestDataBuilder.createApplication();
        
        insert app;
        
        List<Insurance_Premium_Calculation_Variables__c> inPrmm=TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert inPrmm;
        
        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        list<Algorithm__c> algs=TestDataBuilder.createAlgorithms();
        insert algs;
        
        payee__c pay=TestDataBuilder.createPayee();
        insert pay;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;
        
        Profile_Country__c prCountry = new Profile_Country__c(SetupOwnerId = Userinfo.getProfileId(),NZ__c = true);
		insert prCountry;
        
        Disbursement__c dB1=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        db1.Account_Holders__c='aaa$$111';
        db1.Bank_Acc_No__c='6389';
        db1.Branch_Number__c='902';
        db1.Bank_Number__c='01';
        db1.Suffix_Number__c='000';
        insert dB1;
        
        
        Disbursement__c dB2=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        db2.Account_Holders__c='aaa111';
        db2.Bank_Acc_No__c='6r389';
        db2.Branch_Number__c='902a';
        db2.Bank_Number__c='1a';
        db2.Suffix_Number__c='000a';
        insert dB2;
        
        Disbursement__c dB3=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        db3.Account_Holders__c='aaa$$111';
        db3.Bank_Acc_No__c='68389';
        db3.Branch_Number__c='902a';
        db3.Bank_Number__c='1a';
        db3.Suffix_Number__c='000a';
        insert dB3;
        
        
        Disbursement__c dB4=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        db4.Account_Holders__c='aaa$$111';
        db4.Bank_Acc_No__c='68389';
        db4.Branch_Number__c='902';
        db4.Bank_Number__c='1a';
        db4.Suffix_Number__c='000a';
        insert dB4;
        
        
        Disbursement__c dB5=TestDataBuilder.createDisbursementPayee(app.id,pay.id);
        db5.Account_Holders__c='aaa111';
        db5.Bank_Acc_No__c='68389';
        db5.Branch_Number__c='902';
        db5.Bank_Number__c='1';
        db5.Suffix_Number__c='000a';
        insert dB5;
        
    }*/
    
    
   
}