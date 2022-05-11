@isTest
public with sharing class CreateQuoteTest {
    
    @isTest static void TestCreateQuote(){
         Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUOnline();
        if(quoteList.size() > 0){
            insert quoteList;
            Id quoteId = quoteList[0].Id;
            //Update the Quote Object
            Quote__c quoteObj = new Quote__c();
            quoteObj.Id = quoteId;
            quoteObj.Loan_Amount__c = 4000;
            update quoteObj;
            System.assertEquals(4000, quoteObj.Loan_Amount__c);
        }
    }

}