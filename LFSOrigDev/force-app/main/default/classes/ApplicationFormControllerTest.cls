@isTest
public class ApplicationFormControllerTest {
    
    @isTest
    static void getQuoteDetails_test(){
        Street_Type_Setting__c stsObj = new Street_Type_Setting__c();
        stsObj.Name = 'Road';
        stsObj.Region__c = 'Both';
        stsObj.Value__c = 'Road';
        stsObj.Value_Abbreviated__c = 'Rd';
        stsObj.Value_Abbreviated_NZ__c = 'Rd';
        insert stsObj;

         //APAC & Individual View Scenario
         Contact testBroker = TestDataBuilder.createBrokerRecord();
         testBroker.Broker_View_Access__c = 'Individual View';
         testBroker.Email = 'testBroker@test.com';
         insert testBroker;
 
        //Better Start Offer config
        Better_Start_Offer__c bso = new Better_Start_Offer__c();
        bso.BetterStartAUActive__c = true;
        insert bso;

        //Latitude Brand record
        Brand__c latitudeBrand = TestDataBuilder.createBrand();
        insert latitudeBrand;

        Test.startTest();
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        insert quoteList;
        String quoteId = quoteList[0].Id;        
        Quote__c qObj = ApplicationFormController.getQuoteDetails(quoteId);
        ApplicationFormController.getBetterStartOfferConfig();
        ApplicationFormController.getLatitudeBrandRecord();
        Test.stopTest();


  

    }

}