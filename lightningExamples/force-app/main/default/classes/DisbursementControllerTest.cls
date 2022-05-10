@isTest

public class DisbursementControllerTest {  
   static testMethod void testDisbursement(){
     Disbursement__c dcon = new Disbursement__c(BillerName__c = 'Test',BillerCode__c ='1234');
     
     List<Disbursement__c> disbList = [SELECT BillerName__c,BillerCode__c FROM Disbursement__c limit 1];
     ApexPages.StandardController sc = new ApexPages.standardController(dcon); 
    //ApexPages.StandardController sc = new ApexPages.standardController(dcon);  
      DisbursementController dc = new DisbursementController(sc); 
          
    //dc.Testcov();
           
   }   
}