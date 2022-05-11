@isTest
private class App_LoanPurpose_Test {
    
    @isTest static void testRefinance() {       
        list<Meta_ONR__c> monr = TestDataBuilder.createMetaONRLoanPurpose();  
        Meta_ONR__c monrRef = TestDataBuilder.createMetaONRLoanPurposeRef();
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.startTest();
            insert monr;        
            insert monrRef;
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            APP_LoanPurpose appLp = new APP_LoanPurpose();
            appLp.region='NZ';
            List<SelectOption> temp = appLp.loanPurposeOptions;         
        Test.stopTest();

        System.assert(!temp.isEmpty());
    }

    @isTest static void testOther() {       
        list<Meta_ONR__c> monr = TestDataBuilder.createMetaONRLoanPurpose();
        Meta_ONR__c monrRef = TestDataBuilder.createMetaONRLoanPurposeRef();
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Test.startTest();
            insert monr;
            insert monrRef; 
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_LoanPurpose appLp = new APP_LoanPurpose();
            appLp.region='NZ';          
            List<SelectOption> tempT = appLp.loanPurposeOptionsMain;
        Test.stopTest();

        System.assert(!tempT.isEmpty());
    }       
    
     @isTest static void testGem() {       
        list<Meta_ONR__c> monr = TestDataBuilder.createMetaONRLoanPurpose();
        Meta_ONR__c monrRef = TestDataBuilder.createMetaONRLoanPurposeRef();
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Test.startTest();
            insert monr;
            insert monrRef; 
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_LoanPurpose appLp = new APP_LoanPurpose();
            appLp.region='NZ';          
            List<SelectOption> tempT = appLp.loanPurposeOptionsForGem;
        Test.stopTest();

        System.assert(!tempT.isEmpty());
    }       
}