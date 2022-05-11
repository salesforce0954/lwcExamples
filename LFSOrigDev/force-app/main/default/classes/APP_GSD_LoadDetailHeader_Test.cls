@isTest
public class APP_GSD_LoadDetailHeader_Test{
    @testSetup static void staticRecords() {
        List<Admin_Settings__c> testAdminSettings = TestDatabuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void constructorStyleFalseTest(){
         Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.Id;
        insert appVar;  
        
       /* Application__c appNZ = new Application__c();
        appNZ.Brand_String__c = 'Gem';
        insert appNZ;
        Loan_Purpose__c lpNZ = new Loan_Purpose__c();
        lpNZ.Application__c = appNZ.Id;
        insert lpNZ; */
        
         
        //Added By Suneel
        Loan_Purpose__c lp = new Loan_Purpose__c();
       lp.Application__c = appVar.Id;       
       insert lp;
        
        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('controlStyle','false');
            ApexPages.CurrentPage().getParameters().put('brandString', null);
            ApexPages.CurrentPage().getParameters().put('id', appVar.Id);
            APP_GSD_LoadDetailHeader loanHeader = new APP_GSD_LoadDetailHeader();

            
            //loanHeader.controlStyle = false;        
        Test.StopTest();
          
        //System.assertEquals(false, loanHeader.controlStyle);
        //System.assertEquals(null, loanHeader.brandString);
    }
   
    
    static testMethod void constructorStyleTrueTest(){
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.Id;
        //Added By Suneel
        appVar.Is_Accepted_Primary__c = true;
        appVar.Is_Accepted_Secondary__c = true;        
        insert appVar;
        
        
        //Added By Suneel
        Loan_Purpose__c lp = new Loan_Purpose__c();
       lp.Application__c = appVar.Id;
       insert lp;
            
        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('controlStyle','true');
            ApexPages.CurrentPage().getParameters().put('brandString', GEN_OriginationsConstants.BRAND_NAME_GEMONEY);
            ApexPages.CurrentPage().getParameters().put('id', appVar.Id);
            APP_GSD_LoadDetailHeader loanHeader = new APP_GSD_LoadDetailHeader();
        Test.StopTest();

        System.assertEquals(true, loanHeader.controlStyle);
        System.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY, loanHeader.brandString);
        
        //Added the below lines to improve the code coverage - Suneel - 19/04/2018
        System.assertEquals(true,loanHeader.isAcceptedContract_App1);
        System.assertEquals(true,loanHeader.isAcceptedContract_App2 );
      
        
          
    }
    
    static testMethod void constructorStyleFalseTestNZ(){
         Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        Application__c appVar = testDataBuilder.createApplicationNZ(testBrand);
        appVar.Brand_Lookup__c = testBrand.Id;
        insert appVar;  
        
        Loan_Purpose__c lp = new Loan_Purpose__c();
        lp.Application__c = appVar.Id;       
        insert lp;
        
        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('controlStyle','false');
            ApexPages.CurrentPage().getParameters().put('brandString', null);
            ApexPages.CurrentPage().getParameters().put('id', appVar.Id);
            APP_GSD_LoadDetailHeader loanHeader = new APP_GSD_LoadDetailHeader();     
        Test.StopTest();
        System.assertEquals(false, loanHeader.controlStyle);

        
    }
    
    static testMethod void constructorStyleAUBroker(){
         Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Channel__c = 'Broker';
        appVar.Brand_Lookup__c = testBrand.Id;
        insert appVar;  
        
        Loan_Purpose__c lp = new Loan_Purpose__c();
        lp.Application__c = appVar.Id;       
        insert lp;
        
        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('controlStyle','false');
            ApexPages.CurrentPage().getParameters().put('brandString', null);
            ApexPages.CurrentPage().getParameters().put('id', appVar.Id);
            APP_GSD_LoadDetailHeader loanHeader = new APP_GSD_LoadDetailHeader();     
        Test.StopTest();
        System.assertEquals(false, loanHeader.controlStyle);

        
    }
    
    
}