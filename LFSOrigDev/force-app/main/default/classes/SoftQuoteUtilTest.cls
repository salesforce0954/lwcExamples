@isTest public class SoftQuoteUtilTest {
    
    @isTest public static void testUtility(){
        Application__c appObj = TestDataBuilder.createApplication();
        
        Admin_Settings__c softQuoteAU = new Admin_Settings__c();
        softQuoteAU.Name = 'Enable Soft Quote AU';
        softQuoteAU.Value__c = 'True';
        insert softQuoteAU;
                
        insert appObj;
        
        Boolean isEnabled = SoftQuoteUtil.checkIfSoftQuoteEnabled(appObj.Id);
        System.assertEquals(true, isEnabled);
       
       
      
    }

    @isTest public static void testUtilityNZ(){
    
        Brand__c testBrand = TestDataBuilder.createBrand();
          testBrand.Country__c = 'NZ';
          insert testBrand;
                
        Application__c appObj = TestDataBuilder.createApplicationNZ(testBrand);
        
        Admin_Settings__c softQuoteNZ = new Admin_Settings__c();
        softQuoteNZ.Name = 'Enable Soft Quote NZ';
        softQuoteNZ.Value__c = 'True';
        insert softQuoteNZ;
     
        insert appObj;
        
        Boolean isEnabled = SoftQuoteUtil.checkIfSoftQuoteEnabled(appObj.Id);
        System.assertEquals(True, isEnabled);
       
       
      
    }
    
    @isTest public static void checkStreetType(){
    
  
            Street_Type_Setting__c stsObj = new Street_Type_Setting__c();
            stsObj.Name = 'Road';
            stsObj.Region__c = 'Both';
            stsObj.Value__c = 'Road';
            stsObj.Value_Abbreviated__c = 'Rd';
            stsObj.Value_Abbreviated_NZ__c = 'Rd';
            insert stsObj;
        
            String abbrValue = SoftQuoteUtil.checkStreetType('Road', 'AU');
            System.assertEquals('Rd', abbrValue);
            String abbrValueNZ = SoftQuoteUtil.checkStreetType('Road', 'NZ');
            System.assertEquals('Rd', abbrValueNZ);        
          //Get Record Type for AU
        
    }
    
    @isTest public static void checkSoftQuote(){
        Admin_Settings__c softQuote = new Admin_Settings__c();
        softQuote.Name = 'Soft Quote Org Enabled';
        softQuote.Value__c = 'True';
        insert softQuote;
        
        List<Quote__c> quoteLst = TestDataBuilder.createQuoteAUOnline();
                
        Boolean isEnabled = SoftQuoteUtil.checkSoftQuoteOrgEnabled();
        System.assertEquals(true, isEnabled);
        SoftQuoteUtil.covertDecimal('test');
       // SoftQuoteUtil.insertOutboundEmailComm('test',quoteLst[0].id);
       
       
         //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
                                            
                                              Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        //Create Quote    
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000.00;
        quoteObj.Quote_Rate__c = 19.99;
        quoteObj.Monthly_Repayment__c = 254.33;
        quoteObj.Loan_Term__c = '3 years';
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
        quoteObj.Quote_Secured_Rate__c=10.99;
        quoteObj.Quote_Rate__c=12.99;
        quoteObj.Quote_Stage__c = 'Initial Submit';
        quoteLst.add(quoteObj);
          insert quoteLst;  
                
        quoteObj.Quote_Stage__c = 'Quote Offered';
        quoteObj.Monthly_Repayment__c=234.2;
        update quoteObj;
               
         Quote_Outbound_Communication_Emails__c quoteComm = new Quote_Outbound_Communication_Emails__c() ;
         quoteComm.Template__c = 'Quote Approved Email';
         quoteComm.Quote__c = quoteObj.id;
         insert quoteComm;
         
         
                 System.assertEquals(quoteComm.Template__c,'Quote Approved Email');

       //SoftQuoteUtil.insertOutboundEmailComm('Quote Approved Email',quoteObj);
       SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day3 Reminder AU',quoteObj);
       
        Boolean xyz ;
        SoftQuoteUtil.getFinalHTMLTemplate('test',quoteObj);
    }

    @isTest public static void checkSoftQuoteBetterStart(){
      Admin_Settings__c softQuote = new Admin_Settings__c();
      softQuote.Name = 'Soft Quote Org Enabled';
      softQuote.Value__c = 'True';
      insert softQuote;
      
      List<Quote__c> quoteLst = TestDataBuilder.createQuoteAUOnline();
              
      Boolean isEnabled = SoftQuoteUtil.checkSoftQuoteOrgEnabled();
      System.assertEquals(true, isEnabled);
      SoftQuoteUtil.covertDecimal('test');
     // SoftQuoteUtil.insertOutboundEmailComm('test',quoteLst[0].id);
     
     
       //Get Record Type for AU
      List<RecordType> recordTypeList = [SELECT Id 
                                           FROM RecordType
                                          WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
                                          
                                            Street_Type_Setting__c st1 = new Street_Type_Setting__c();
      St1.name='Road';
      St1.Value__c='Road';
      St1.Region__c='AU';
      St1.Value_Abbreviated_NZ__c='Rd';
      St1.Value_Abbreviated__c='Rd';
      insert St1;

      //Create Quote    
      Quote__c quoteObj = new Quote__c();
      quoteObj.RecordTypeId = recordTypeList[0].Id;
      quoteObj.Loan_Amount__c = 8000.00;
      quoteObj.Quote_Rate__c = 19.99;
      quoteObj.Monthly_Repayment__c = 254.33;
      quoteObj.Loan_Term__c = '3 years';
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
      quoteObj.Quote_Secured_Rate__c=10.99;
      quoteObj.Quote_Rate__c=12.99;
      quoteObj.Quote_Stage__c = 'Initial Submit';
      quoteLst.add(quoteObj);
        insert quoteLst;  
              
      quoteObj.Quote_Stage__c = 'Quote Offered';
      quoteObj.Monthly_Repayment__c=234.2;
      update quoteObj;
             
       Quote_Outbound_Communication_Emails__c quoteComm = new Quote_Outbound_Communication_Emails__c() ;
       quoteComm.Template__c = 'Quote Approved Email';
       quoteComm.Quote__c = quoteObj.id;
       insert quoteComm;
       
       
               System.assertEquals(quoteComm.Template__c,'Quote Approved Email');

     //SoftQuoteUtil.insertOutboundEmailComm('Quote Approved Email',quoteObj);
     SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day1 Reminder AU Better Start',quoteObj);
     SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day3 Reminder AU Better Start',quoteObj);
     SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day5 Reminder AU Better Start',quoteObj);
     SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day10 Reminder AU Better Start',quoteObj);
     
      Boolean xyz ;
      SoftQuoteUtil.getFinalHTMLTemplate('test',quoteObj);
  }    
    
    @isTest public static void checkSoftQuoteNZ(){
        Admin_Settings__c softQuote = new Admin_Settings__c();
        softQuote.Name = 'Enable Soft Quote NZ';
        softQuote.Value__c = 'True';
        insert softQuote;
                
        List<Quote__c> quoteLstNZ = TestDataBuilder.createQuoteNZOnlineKiwi();
        
        Boolean isEnabled = SoftQuoteUtil.checkSoftQuoteOrgEnabled();
        System.assertEquals(false, isEnabled);
        SoftQuoteUtil.covertDecimal('test');
       // SoftQuoteUtil.insertOutboundEmailComm('test',quoteLst[0].id);
       
       
         //Get Record Type for AU
        List<RecordType> recordTypeListNZ = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'NZ' AND sObjectType = 'Quote__c'];                                           
                                            
                                              Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
      Quote__c qNZ = new Quote__c();        
        qNZ.RecordTypeId = recordTypeListNZ[0].Id;
        qNZ.Loan_Amount__c = 3000;
        qNZ.Loan_Term__c = '3 years';
        qNZ.Loan_Purpose__c = 'Auto Purchase';
        qNZ.Monthly_Repayment__c = 254.33;
        qNZ.Channel__c = 'Online';
        qNZ.Region__c = 'NZ';
        qNZ.Consent_For_Soft_Enquiry__c = true;
        qNZ.Title__c = 'Mr';
        qNZ.First_Name__c = 'Larry';
        qNZ.Middle_Name__c = 'J';
        qNZ.Last_Name__c = 'Smith';
        qNZ.Date_of_Birth__c = '18/07/1976';
        qNZ.Gender__c = 'Male';
        qNZ.Mobile_Number__c = '0238484484';
        qNZ.Email_ID__c = 'asd@zzkiwi.com';
        qNZ.Driver_s_Licence_Number__c = 'AB435778';
        qNZ.Driver_s_License_Version__c = '456';
        qNZ.Driver_s_License_Issue_Date__c = '10/02/2010';
        qNZ.Driver_s_License_Expiry_Date__c = '10/02/2030';
        qNZ.Residential_Street_Number__c = '110';
        qNZ.Residential_Street_Name__c = 'City Road';
        qNZ.Residential_Street_Type__c = 'Road';
        qNZ.Residential_Suburb__c = 'Southbank';
        qNZ.Residential_State__c = 'VIC';
        qNZ.Residential_City__c = 'Auckland';
        qNZ.Residential_Postcode__c = '3006';
        qNZ.Residential_Country__c = 'New Zealand';
        qNZ.Years_at_Residential_Address__c = 3;
        qNZ.Months_at_Residential_Address__c = 4;
        qNZ.Income_Source__c = 'Rental Income';
        qNZ.Years_at_Current_Employment__c = 2;
        qNZ.Months_at_Current_Employment__c = 2;
        qNZ.Residential_Status__c = 'Renting';
        qNZ.Product__c='Kiwi Personal Loan';
        qNZ.Last_Webservice_Operation_Status__c='Not Submitted';
        qNZ.Consent_For_Soft_Enquiry__c = true;
        qNZ.Quote_Privacy_Consent__c= true;
        qNZ.Quote_Secured_Rate__c=10.99;
        insert qNZ;
        
         Quote_Outbound_Communication_Emails__c quoteComm = new Quote_Outbound_Communication_Emails__c() ;
         quoteComm.Template__c = 'Quote Reminder Email Day 3';
         quoteComm.Quote__c = qNZ.id;
         insert quoteComm;
                 System.assertEquals(quoteComm.Template__c,'Quote Reminder Email Day 3');

       SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day3 Reminder AU',qNZ);
       SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day5 Reminder AU',qNZ);
       SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day10 Reminder AU',qNZ);
       SoftQuoteUtil.insertOutboundEmailComm('Soft Quote Day1 Reminder AU',qNZ);
       
       qNZ = [SELECT Id, Name, RecordTypeId, Loan_Amount__c, Loan_Term__c, Loan_Purpose__c, Monthly_Repayment__c, Monthly_Repayment_For_Email__c, Channel__c,
              Region__c, Consent_For_Soft_Enquiry__c, Title__c, First_Name__c, Middle_Name__c, Last_Name__c, Date_of_Birth__c, Gender__c,
              Mobile_Number__c, Email_ID__c, Driver_s_Licence_Number__c, Driver_s_License_Version__c, Driver_s_License_Issue_Date__c, Driver_s_License_Expiry_Date__c,
              Residential_Street_Number__c, Residential_Street_Name__c, Residential_Street_Type__c, Residential_Suburb__c, Residential_State__c, Residential_City__c,
              Residential_Postcode__c, Residential_Country__c, Years_at_Residential_Address__c, Months_at_Residential_Address__c, Income_Source__c,
              Years_at_Current_Employment__c, Months_at_Current_Employment__c, Residential_Status__c, Product__c, Quote_Rate__c,
              Last_Webservice_Operation_Status__c, Quote_Privacy_Consent__c, Quote_Secured_Rate__c FROM Quote__c WHERE ID = :qNZ.Id];

        System.debug('DEB QNZ: '+qNZ.Monthly_Repayment_For_Email__c);
        System.debug('DEB QNZ: '+qNZ.Quote_Secured_Rate__c);      
        Boolean xyz ;
        SoftQuoteUtil.getFinalHTMLTemplate('test',qNZ);
    }

}