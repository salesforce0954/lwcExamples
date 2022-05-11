@isTest
public class ComparisionRateCalculator_Test {
    
    static testMethod void QuoteRate_Test(){
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
         //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Quote_Rate__c =10;
        quoteObj.Loan_Term__c = '1 year';
        quoteObj.Monthly_Repayment__c = 1000;
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
                
        insert quoteObj;
        Quote__c objQuote = [SELECT ID, Loan_Amount__c,Quote_Rate__c,Loan_Term_Months__c,Brokerage_Fee__c,Monthly_Repayment__c FROM Quote__c Where ID =:quoteObj.ID];
        ComparisionRateCalculator.getRate(objQuote);
    }
}