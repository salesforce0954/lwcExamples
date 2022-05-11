@isTest (seealldata = true)

public Class AccountOpenerTrainingClsTest{

    
    public static testMethod void testAccountOpenerTraining(){
   
        Account_Opener_Training__c acc = new Account_Opener_Training__c();
        List<Account> newAccounts = CreateAccount(2);
        insert newAccounts;
        testingUtils.clear_execution_flags();   
        
        if (SalesforceUrl__c.getOrgDefaults() == null){
        	insert TestDataBuilder.createSalesforceURLSettings();
        }

        SalesforceUrl__c urlParam = SalesforceUrl__c.getOrgDefaults();
        ApexPages.currentPage().getParameters().put(urlParam.Account_Opener_Training_Param__c, newAccounts[0].id);
        
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
        AccountOpenerTrainingCls a = new AccountOpenerTrainingCls(ctrlInd);
        
        Test.StartTest();
        a.cardVal ='';
        a.showHideGoGemSection();
        system.assertEquals(false,a.showGEMSection);
        system.assertEquals(false,a.showGOSection);
        
        //a.showGOSection = true;
        a.cardVal = 'GO';
        a.showHideGoGemSection();
        system.assertEquals(false,a.showGEMSection);
        system.assertEquals(true,a.showGOSection);
        
        //a.showGEMSection = true;
        a.cardVal = 'GEM';
        a.showHideGoGemSection();
        system.assertEquals(true,a.showGEMSection);
        system.assertEquals(false,a.showGOSection);
               
        a.getgoQ1(); a.getgoQ2(); a.getgoQ3(); a.getgoQ4(); a.getgoQ5(); a.getgoQ6(); a.getgoQ7(); a.getgoQ8();
        a.getgemQ1(); a.getgemQ2(); a.getgemQ3(); a.getgemQ4(); a.getgemQ5(); a.getgemQ6(); a.getgemQ7();
        system.assertNotEquals(null,a.getgemQ7());
        
        String testUrl = SalesforceUrl__c.getInstance().Link__c;
        PageReference pgTest = new PageReference(testUrl + '/' +a.acOpTr.Account__c);
        pagereference pgTestOne = a.cancel();
        system.assertEquals(pgTest.getUrl(),pgTestOne.getUrl());
        
        
        a.save();
        List<Apexpages.Message> messageInstance = ApexPages.getMessages();
        boolean isErrorMessage = false;
            for(Apexpages.Message testMessages : messageInstance){
                if (testMessages.getDetail().contains('Error:Please Complete all questions in Step 2.') )
                    isErrorMessage  = true;
            }
        system.assert(isErrorMessage);
        
        a.showGOSection = true;
        a.acOpTr.Go_Q1__c='test'; a.acOpTr.Go_Q2__c='test'; a.acOpTr.Go_Q3__c='test'; a.acOpTr.Go_Q4__c='test'; 
        a.acOpTr.Go_Q5__c='test'; a.acOpTr.Go_Q6__c='test'; a.acOpTr.Go_Q7__c='test'; a.acOpTr.Go_Q8__c='test';
        
        pagereference pgTestTwo = a.save();
        system.assertEquals(pgTest.getUrl(),pgTestTwo.getUrl());
        a.showGEMSection = false;
        a.showGEMSection = true;

        a.acOpTr.GEM_Q1__c='test'; a.acOpTr.GEM_Q2__c='test'; a.acOpTr.GEM_Q3__c='test'; a.acOpTr.GEM_Q4__c='test'; 
        a.acOpTr.GEM_Q5__c='test'; a.acOpTr.GEM_Q1__c='test'; a.acOpTr.Go_Q7__c='test'; a.acOpTr.Account__c = newAccounts[0].id;
        a.acOpTr.Account_Manager__c = userinfo.getUserId();  
        
       //a.save();   
               
        Test.StopTest();
        utils.get_apex_profile();
    }


    public static testMethod void testAccountOpenerTraining1(){
   
        Account_Opener_Training__c acc = new Account_Opener_Training__c();
        List<Account> newAccounts = CreateAccount(2);
        insert newAccounts; 
        testingUtils.clear_execution_flags();  

		if (SalesforceUrl__c.getOrgDefaults() == null){
        	insert TestDataBuilder.createSalesforceURLSettings();
        }

        SalesforceUrl__c urlParam = SalesforceUrl__c.getOrgDefaults();
        ApexPages.currentPage().getParameters().put(urlParam.Account_Opener_Training_Param__c, newAccounts[0].id);
           
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
        AccountOpenerTrainingCls a = new AccountOpenerTrainingCls(ctrlInd);

        Test.StartTest();
        a.showGOSection = true;

        a.acOpTr.Go_Q1__c='$25'; a.acOpTr.Go_Q2__c='21.74%'; a.acOpTr.Go_Q3__c='29.49%'; a.acOpTr.Go_Q4__c='outstanding balance only'; 
        a.acOpTr.Go_Q5__c='$0'; a.acOpTr.Go_Q6__c='$4.95'; a.acOpTr.Go_Q8__c='Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process';
        a.save();

        a.acOpTr.Go_Q1__c='$25'; a.acOpTr.Go_Q2__c='21.74%'; a.acOpTr.Go_Q3__c='29.49%'; a.acOpTr.Go_Q4__c='outstanding balance only'; 
        a.acOpTr.Go_Q5__c='$0'; a.acOpTr.Go_Q6__c='$4.95'; a.acOpTr.Go_Q7__c='all of the above'; a.acOpTr.Go_Q8__c='Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process';         
        a.save();   
                      
        Test.StopTest();
        utils.get_apex_profile();
        
    }

    public static testMethod void testAccountOpenerTraining2(){
   
        Account_Opener_Training__c acc = new Account_Opener_Training__c();
        List<Account> newAccounts = CreateAccount(2);
        insert newAccounts; 
        testingUtils.clear_execution_flags();  

		if (SalesforceUrl__c.getOrgDefaults() == null){
        	insert TestDataBuilder.createSalesforceURLSettings();
        }
			
        SalesforceUrl__c urlParam = SalesforceUrl__c.getOrgDefaults();
        ApexPages.currentPage().getParameters().put(urlParam.Account_Opener_Training_Param__c, newAccounts[0].id);
           
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
        ApexPages.StandardController ctrlInd2 = new ApexPages.StandardController(acc);
        AccountOpenerTrainingCls a = new AccountOpenerTrainingCls(ctrlInd);
        AccountOpenerTrainingCls a2 = new AccountOpenerTrainingCls(ctrlInd2);

        Test.StartTest();
        a.showGEMSection = true;
        a2.showGEMSection = true;

        a.acOpTr.GEM_Q1__c='$0'; a.acOpTr.GEM_Q2__c='True'; a.acOpTr.GEM_Q3__c='outstanding balance only'; a.acOpTr.GEM_Q4__c='$99'; 
        a.acOpTr.GEM_Q5__c='$0'; a.acOpTr.Go_Q7__c='Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application Process'; 
        a.save();

        a.acOpTr.GEM_Q1__c='$0'; a.acOpTr.GEM_Q2__c='True'; a.acOpTr.GEM_Q3__c='outstanding balance only'; a.acOpTr.GEM_Q4__c='$99'; 
        a.acOpTr.GEM_Q5__c='$0'; a.acOpTr.GEM_Q6__c='all of the above'; a.acOpTr.GEM_Q7__c='Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application Process'; 
        a.save();   
        
        a2.acOpTr.GEM_Q1__c='test'; a2.acOpTr.GEM_Q2__c='test'; a2.acOpTr.GEM_Q3__c='test'; a2.acOpTr.GEM_Q4__c='test'; 
        a2.acOpTr.GEM_Q5__c='test'; a2.acOpTr.GEM_Q6__c='test'; a2.acOpTr.GEM_Q7__c='test'; 
        a2.save(); 

        Test.StopTest();
        utils.get_apex_profile();
        
    }

    public static testMethod void noshowGEMandGOSection(){
   
        Account_Opener_Training__c acc = new Account_Opener_Training__c();
        List<Account> newAccounts = CreateAccount(2);
        insert newAccounts; 
        testingUtils.clear_execution_flags();  

		if (SalesforceUrl__c.getOrgDefaults() == null){
        	insert TestDataBuilder.createSalesforceURLSettings();
        }
		
        SalesforceUrl__c urlParam = SalesforceUrl__c.getOrgDefaults();
        ApexPages.currentPage().getParameters().put(urlParam.Account_Opener_Training_Param__c, newAccounts[0].id);
           
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
        ApexPages.StandardController ctrlInd2 = new ApexPages.StandardController(acc);
        AccountOpenerTrainingCls a = new AccountOpenerTrainingCls(ctrlInd);
        AccountOpenerTrainingCls a2 = new AccountOpenerTrainingCls(ctrlInd2);

        Test.StartTest();

        a.showGEMSection = true;
        a.save();

        a2.showGOSection = true;
        a2.save();
                      
        Test.StopTest();
        utils.get_apex_profile();
        
    }

     public static testMethod void testMerchantId(){
     
         List<Account> newAccounts = CreateAccount(2);
         newAccounts[0].Account_Accreditation_Status_cons__c = 'Merchant';
         newAccounts[0].Merchant_ID_Group__c = 'Cards AU';
         newAccounts[0].BillingCountry = 'Australia';
         newAccounts[0].BillingState = 'VIC';
         
         newAccounts[1].Account_Accreditation_Status_cons__c = 'Merchant';
         newAccounts[1].Merchant_ID_Group__c = 'Cards AU';
         newAccounts[1].BillingCountry = 'Australia';
         newAccounts[1].BillingState = 'VIC';
         
         insert newAccounts;
         testingUtils.clear_execution_flags();  
         
         Merchant_ID__c merch = new Merchant_ID__c (Account__c=newAccounts[0].Id);
         insert merch;
         testingUtils.clear_execution_flags();  
         utils.get_apex_profile();
     }


    public static List<Account> CreateAccount(Integer Size){
      
      Id rTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Cards Aus').RecordTypeId;
      List<Account> myAccounts = new List<Account>();
      for(Integer i = 0;i<=Size;i++){
        myAccounts.add(New Account(Name = 'TestAccName__'+i, BillingCity='TestCity', BillingCountry='TestCountry', RecordTypeId = rTypeID));
      }
      return myAccounts;
    }
}