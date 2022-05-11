@isTest
public class APP_SaveQuote_INTCC_Test {
    
    static testMethod void APP_SaveQuote_INTCC_Test() {
        //Catch constructor
         Application__c testApplication = TestDataBuilder.createApplication();
              
        List<SelectOption> testOptions = new List<SelectOption>();

        ApexPages.currentPage().getParameters().put('id', '');
        Test.StartTest();
            APP_SaveQuote_INTCC saveQuote= new APP_SaveQuote_INTCC();
           
            saveQuote.save();
             saveQuote.cancel();
              
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
        
        System.assert(isError);
        System.assertEquals(null, saveQuote.saveQuoteReasonStr);
        System.assertEquals(null, saveQuote.quoteComment);
        
    }
   
    static testMethod void APP_SaveQuote_INTCC_Test2() {
       
        Application__c testApplication1 = TestDataBuilder.createApplication();
        testApplication1.save_quote_comments__c='Testing';
        testApplication1.sub_Status__c='3.Followed up – more time requested';
        testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
        insert testApplication1;  
        
               
        List<SelectOption> testOptions = new List<SelectOption>();
        PageReference pageRef = Page.APP_SaveQuote_INT;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',testApplication1.id);

        
     
         ApexPages.currentPage().getParameters().put('id', testApplication1.id);
         
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;
        String applicationId = ApexPages.currentPage().getParameters().get('id');
        
         Test.StartTest();
            APP_SaveQuote_INTCC saveQuote1= new APP_SaveQuote_INTCC();
           testOptions = saveQuote1.saveReason;
            saveQuote1.save();
            saveQuote1.CallUpdatebService();
            saveQuote1.clearProp();  
            
            
        Test.StopTest();
        
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
      
        
    }
     
    static testMethod void APP_SaveQuote_INTCC_Test3() {
       
         Application__c testApplication1 = TestDataBuilder.createApplication();
         testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
          testApplication1.sub_Status__c='4. Not Interested - to close';
          testApplication1.save_quote_comments__c='TEsting';
        insert testApplication1;  
                
        List<SelectOption> testOptions = new List<SelectOption>();
     
         ApexPages.currentPage().getParameters().put('Id', testApplication1.id);
          Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;
        String applicationId = ApexPages.currentPage().getParameters().get('id');
         Test.StartTest();
            APP_SaveQuote_INTCC saveQuote1= new APP_SaveQuote_INTCC();
           
            saveQuote1.save();
            
            
        Test.StopTest();
        
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
      
        
    }

  
    static testMethod void APP_SaveQuote_INTCC_Error() {
       
         Application__c testApplication1 = TestDataBuilder.createApplication();
         testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
           testApplication1.sub_Status__c='4. Not Interested - to close';
          testApplication1.save_quote_comments__c='TEsting';
        insert testApplication1;  
                
         List<SelectOption> testOptions = new List<SelectOption>();
     
         ApexPages.currentPage().getParameters().put('Id', testApplication1.id);
          Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;
        String applicationId = ApexPages.currentPage().getParameters().get('id');
     
         Test.StartTest();
            APP_SaveQuote_INTCC saveQuote1= new APP_SaveQuote_INTCC();
           testOptions =saveQuote1.saveReason;
            saveQuote1.save();
           testApplication1.sub_Status__c=null;
          testApplication1.save_quote_comments__c='';
          Update testApplication1;
          APP_SaveQuote_INTCC saveQuote2= new APP_SaveQuote_INTCC();
          testOptions =saveQuote2.saveReason;
           saveQuote2.save(); 
        Test.StopTest();
        
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
      
        
    }

 static testMethod void APP_SaveQuote_INTCC_Test5() {
       
        Application__c testApplication1 = TestDataBuilder.createApplication();
        testApplication1.save_quote_comments__c='Testing';
        testApplication1.sub_Status__c='4. Not Interested - to close';
        testApplication1.Response_Code__c='Referred: Refer to CPU/CMO';
        insert testApplication1;  
       
        PageReference pageRef = Page.APP_SaveQuote_INT;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',testApplication1.id);
         ApexPages.currentPage().getParameters().put('id', testApplication1.id);
         
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;
        String applicationId = ApexPages.currentPage().getParameters().get('id');
        
         Test.StartTest();
            APP_SaveQuote_INTCC saveQuote1= new APP_SaveQuote_INTCC();
            saveQuote1.save();
            saveQuote1.CallUpdatebService();
        Test.StopTest();
        
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
      
        
    }
  
}