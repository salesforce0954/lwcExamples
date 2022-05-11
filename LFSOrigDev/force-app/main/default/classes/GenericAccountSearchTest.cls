/*
  Description: Test class for the class GenericAccountSearch
  Date : 10/11/2014
*/ 

@isTest
public class GenericAccountSearchTest{

   static TestMethod void testGenericAccountSearchFirstXML(){
        Test.startTest();
        string recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Broker AU (Motor/PL)').getRecordTypeId(); 
        ApexPages.currentPage().getParameters().put('RecordType', recordTypeId);
        ApexPages.StandardController controller = new ApexPages.StandardController(new Account());
        GenericAccountSearch XMLTests = new GenericAccountSearch(controller);
        List<GenericAccountSearch.Result> results = new List<GenericAccountSearch.Result>();  
        results.add(new GenericAccountSearch.Result('cId', false , 'cName', 'cLegalName', 
                        '200', 'cABN', 'cPhone', 'cPost', 'cState', 'cCompIdentifier', false));            
                           
       
        // FOR AU   
        XMLTests.ABN = '093281';  
        XMLTests.Name= 'TestName';
        XMLTests.Phone = '9999 2323';
          
       
        // FOR NZ 
        XMLTests.ABN = '093281';  
        XMLTests.Name= 'TestName';
        XMLTests.Phone = '9999 2323';      
       
       
        //calling class methods to make moke call out
        String reqStr  = GenericAccountSearch.nzSrchReq('Test','Name');
        String reqStr1 = GenericAccountSearch.nzSrchReq('Test','Company'); 
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('entityStatus')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('ABN')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('mainName')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('otherTradingName')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('mainTradingName')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('legalName')));
        GenericAccountSearch.readABNCallout(new XmlStreamReader(createABNResponse('mainBusinessPhysicalAddress')));        
        GenericAccountSearch.readNZCallout(new XmlStreamReader(createNZResponse('companyName')));
        GenericAccountSearch.readNZCallout(new XmlStreamReader(createNZResponse('companyNumber')));    

      
        XMLTests.save();      
        Test.stopTest();
        System.assertNotEquals(reqStr, NULL);
        utils.get_apex_profile();
        
        
      }
      
      //Method for creating Mock call out
    
      public static string createABNResponse(string searchParam){
        String xmlResponse = '<?xml version="1.0"?>'
            +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap:Body xmlns:m="http://schemas.xmlsoap.org/soap/envelope/">';
        if(searchParam == 'ABN'){
            xmlResponse = xmlResponse + '<m:ABN>TestCompany</m:ABN>';
        }
        if(searchParam == 'entityStatus'){
            xmlResponse = xmlResponse + '<m:entityStatus>entityStatus</m:entityStatus>';
        }
        if(searchParam == 'mainName'){
            xmlResponse = xmlResponse + '<m:mainName>Test Name Name</m:mainName>';
        }
        if(searchParam == 'otherTradingName'){
            xmlResponse = xmlResponse + '<m:otherTradingName>otherTradingName</m:otherTradingName>';
        }
        if(searchParam == 'mainTradingName'){
            xmlResponse = xmlResponse + '<m:mainTradingName>mainTradingName</m:mainTradingName>';
        }
        if(searchParam == 'legalName'){
            xmlResponse = xmlResponse + '<m:legalName>legalName</m:legalName>';
        }
        if(searchParam == 'mainBusinessPhysicalAddress'){
            xmlResponse = xmlResponse + '<m:mainBusinessPhysicalAddress>mainBusinessPhysicalAddress</m:mainBusinessPhysicalAddress>';
        }
        xmlResponse = xmlResponse + '</soap:Body> </soap:Envelope>';
        System.assertNotEquals(xmlResponse, NULL);
        return xmlResponse; 
    }
    
     public static string createNZResponse(string searchParam){
        String xmlResponse = '<?xml version="1.0"?>'
            +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap:Body xmlns:m="http://schemas.xmlsoap.org/soap/envelope/">';
        if(searchParam == 'ABN'){
            xmlResponse = xmlResponse + '<m:ABN>TestCompany</m:ABN>';
        }
        if(searchParam == 'companyName'){
            xmlResponse = xmlResponse + '<m:companyName>companyName</m:companyName>';
        }
        if(searchParam == 'companyNumber'){
            xmlResponse = xmlResponse + '<m:mainName>Test Name Name</m:mainName>';
        }
        xmlResponse = xmlResponse + '</soap:Body> </soap:Envelope>';
        System.assertNotEquals(xmlResponse, NULL);
        return xmlResponse; 
    }
    
       
       
       //Method for calling all the class methods by instantiating class instance
    
       public static testMethod void testGenericAccountSearch() {
        Profile p = [select id from profile where name='~ Consumer (Accreditation Admin NZ)'];
        UserRole r = [select id from UserRole where name='System Administrator'];
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User u = new User(userRoleId=r.Id,alias = 'standt', email='standarduser'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX, country='India', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',  localesidkey='en_US', TimeZoneSidKey='America/Los_Angeles',  profileid = p.Id,   username='standardindiauser@testorg.com',Business_Unit__c='Corporate Financial Services (CFS)');
        RecordType rt = [SELECT r.SobjectType, r.Name, r.Id FROM RecordType r WHERE Name = 'Cards NZ' AND SObjectType = 'Account'];
        

         System.runAs(u){ 
            Test.StartTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());                                
            
            Account acc = new Account();            
            ApexPages.CurrentPage().getParameters().put('RecordType', rt.Id); 
            ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
            GenericAccountSearch oController = new GenericAccountSearch(ctrlInd);
            oController.getAPACTitle(); 
            oController.getABNLabel();
            oController.getcreateAccountAPACLabel();
            oController.getRenderABN();
            oController.getRenderPhone();
            oController.getCreateNewAPACLabel();
            oController.getAccountStatusValues();
            //oController.createNewEMEA();
            oController.getPhoneLabel();
            List<GenericAccountSearch.Result> results = new List<GenericAccountSearch.Result>();  
            results.add(new GenericAccountSearch.Result('cId', false , 'cName', 'cLegalName', 
                        '200', 'cABN', 'cPhone', 'cPost', 'cState', 'cCompIdentifier', false)); 
                            
            //oController.results =  results;
            
            GenericAccountSearch.nzCallout('ABN', '908321');
            GenericAccountSearch.abnCallout('908321','ABN'); 
            acc.Name = 'Prashant India Account';
            acc.Site = 'Prashant India Account'; 
            acc.Phone = '07829222988';
            acc.ASPAC_FEF_Region__c = 'North';
            acc.BillingCity = 'Delhi';
            acc.ASPAC_State__c = 'Delhi';
            acc.RecordTypeId = rt.Id;
            acc.ABN__c = '7829222988';
            insert acc;
            
            String reqStr = GenericAccountSearch.nzSrchReq('ABN', '908321');
            System.assertNotEquals(reqStr, NULL);            
            oController.showEditor = true;            
            oController.Name = acc.Name;             
            oController.Name= 'Prashant India Account';  
            oController.ABN = '7829222988';
            oController.Phone = '07829222988';
           
              
            GenericAccountSearch.readABNCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq('Name', 'Company')));  
            GenericAccountSearch.readNZCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq('Name', 'Company')));  
            GenericAccountSearch.readNZCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq('ABN', '908321'))); 
           
            GenericAccountSearch.readABNCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq('Company', 'Name')));  
            GenericAccountSearch.readNZCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq( 'Company', 'Name')));  
            GenericAccountSearch.readNZCallout(new XmlStreamReader(GenericAccountSearch.nzSrchReq( '908321','ABN'))); 
       
            oController.save();
               
            Test.StopTest(); 
           // System.assertEquals(oController.results.size()>0, true);
            utils.get_apex_profile(); 
        }
    }


    //Method for calling all the class methods by instantiating class instance in negative cases
    public static testMethod void NegativeTest()
    
     {
    
         ID userRoleId = [select id from UserRole where name='Consumer National Sales Leader NZ'].id;
         ID profileId = [select id from profile where name LIKE '~ Consumer (Accreditation Admin NZ)' limit 1].id;
         User CDFtestUser = testingUtils.createUsers(1, profileId, userRoleId);         
         insert CDFtestUser;
         RecordType rt = [SELECT r.SobjectType, r.Name, r.Id FROM RecordType r WHERE Name = 'Cards NZ' AND SObjectType = 'Account'];
         string usr = [select name from profile where name LIKE '%Consumer%' limit 1].name ;
         System.runAs(CDFtestUser){ 
         
            Test.StartTest();
            Account acc = new Account();
            acc.Name = 'Prashant India Account';
            acc.Site = 'Prashant India Account'; 
            acc.Phone = '07829222988';
            acc.ASPAC_FEF_Region__c = 'North';
            acc.BillingCity = 'Delhi';
            acc.ASPAC_State__c = 'Delhi';
            acc.RecordTypeId = rt.Id;
            insert acc;
            System.assertEquals(acc.RecordTypeId, rt.Id);
            
            
            PageReference pageRef = Page.GenericAccountSearch;
            Test.setCurrentPage(pageRef );   
            ApexPages.CurrentPage().getParameters().put('RecordType', rt.Id); 
            ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
            GenericAccountSearch oController = new GenericAccountSearch(ctrlInd);
            oController.profileName = usr;
            oController.getAPACTitle(); 
            oController.getABNLabel();
            oController.getcreateAccountAPACLabel();
            oController.getRenderABN();
            oController.getRenderPhone();
            oController.getCreateNewAPACLabel();
            oController.getAccountStatusValues();
            //oController.createNewEMEA();
            oController.getPhoneLabel();            
            
            Test.StopTest();
                 
     
        }
     
    }

   //Method for calling all the class methods by instantiating class instance for covering different profiles
      public static testMethod void NegativeTest1()
    
      {
        RecordType rt = [SELECT r.SobjectType, r.Name, r.Id FROM RecordType r WHERE Name = 'Cards Aus' AND SObjectType = 'Account'];
        Test.StartTest();
        Account acc = new Account();
        acc.Name = 'Prashant India Account';
        acc.Site = 'Prashant India Account'; 
        acc.Phone = '07829222988';
        acc.ASPAC_FEF_Region__c = 'North';
        acc.BillingCity = 'Delhi';
        acc.ASPAC_State__c = 'Delhi';
        acc.RecordTypeId = rt.Id;
        insert acc;
        System.assertEquals(acc.RecordTypeId, rt.Id);
        string usr = [select name from profile where name LIKE '%consumer%' limit 1].name ;
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(acc);
        GenericAccountSearch oController = new GenericAccountSearch(ctrlInd);
        oController.profileName = usr; 
        oController.getAPACTitle(); 
        oController.getABNLabel();
        oController.getcreateAccountAPACLabel();
        oController.getRenderABN();
        oController.getRenderPhone();
        oController.getCreateNewAPACLabel();
        oController.getAccountStatusValues();
        //oController.createNewEMEA();
        oController.getPhoneLabel(); 
        
        Test.stopTest();
        
        }
   
       //Method for calling all the class methods by instantiating class instance for account region parts
       public static testMethod void testupdateAccountRegion(){
       UserRole Urole = [select id from UserRole where name='System Administrator'];
       Profile p1 = [select id, name from profile where name LIKE '%Consumer%' limit 1];
       User u = TestingUtils.createUsers(1,p1.id, Urole.id);
       string usr = [select name from profile where name LIKE '%Consumer%' limit 1].name ;  
       u.Business_Unit__c = 'AIR';                  
       insert u;
       System.runAs(u){
           Test.startTest();
           // Region Creation
           
           
           // Account Creation
           List<Account> newAccounts = CreateAccount(20);
           for(Integer i=0;i<newAccounts.size();i++){
             newAccounts[i].BillingPostalCode = String.ValueOf(200+i);
             newAccounts[i].BillingCity = 'Banglore';
             newAccounts[i].BillingCountry = 'India';
            }
            insert newAccounts;            
           
            ApexPages.StandardController ctrlInd = new ApexPages.StandardController(newAccounts[0]);
            GenericAccountSearch oController = new GenericAccountSearch(ctrlInd);
            oController.profileName = usr; 
            oController.getAPACTitle(); 
            oController.getABNLabel();
            oController.getcreateAccountAPACLabel();
            oController.getRenderABN();
            oController.getRenderPhone();
            oController.getCreateNewAPACLabel();
            oController.getAccountStatusValues();
            //oController.createNewEMEA();
            oController.getPhoneLabel(); 
            System.assertEquals(oController.profileName, usr);
            Test.stopTest();
            utils.get_apex_profile();
        }
     }
    
       public static testMethod void testStringUtil(){
    
           List<Account> newAccounts = CreateAccount(20);
           for(Integer i=0;i<newAccounts.size();i++){
             newAccounts[i].BillingPostalCode = String.ValueOf(200+i);
             newAccounts[i].BillingCity = 'Banglore';
             newAccounts[i].BillingCountry = 'India';
           }
           Test.startTest();
           insert newAccounts; 
        
        // test new method to return statNum of stringUtility
        StringUtil.statNum('Review Started');
        StringUtil.statNum('Lodged with Credit');
        StringUtil.statNum('Accepted by Credit');
        StringUtil.statNum('Approved');
        StringUtil.statNum('Declined');
        StringUtil.statNum('Letter of Offer Issued');
        StringUtil.statNum('Request Received by Docs Team');
        StringUtil.statNum('Docs Issued');
        StringUtil.statNum('Docs Returned');
        StringUtil.statNum('Funded/Operational');
        StringUtil.statNum('Lost');
        string usr = [select name from profile where name LIKE '%Consumer%' limit 1].name ;
        ApexPages.StandardController ctrlInd = new ApexPages.StandardController(newAccounts[0]);
        GenericAccountSearch oController = new GenericAccountSearch(ctrlInd);
        oController.profileName = usr; 
        oController.getAPACTitle(); 
        oController.getABNLabel();
        oController.getcreateAccountAPACLabel();
        oController.getRenderABN();
        oController.getRenderPhone();
        oController.getCreateNewAPACLabel();
        oController.getAccountStatusValues();
        //oController.createNewEMEA();
        oController.getPhoneLabel(); 
        System.assertEquals(oController.profileName, usr);
        Test.stopTest();
             
    }
    
      
      // Account builder
      public static List<Account> CreateAccount(Integer Size){
      List<Account> myAccounts = new List<Account>();
      for(Integer i = 0;i<=Size;i++){
        myAccounts.add(New Account(Name = 'TestAccName__'+i));
      }
      return myAccounts;
    }
    
    public static List<Account> CreateAccount2(Integer Size){
      List<Account> myAccounts = new List<Account>();
      for(Integer i = 0;i<=Size;i++){
      }
      return myAccounts;
    }   
    
    

    
    
    // ABN Balances Builder
    public static List<ABN_Balances__c> CreateABNBalance(String Ident, Integer Size){
      List<ABN_Balances__c> myABNBalances = new List<ABN_Balances__c>();
      for(Integer i = 0;i<=Size;i++){
        myABNBalances.add(New ABN_Balances__c(GroupID__c = Ident+i+'__GID', EF_Revolving_Balance__c = 21321, 
                                              EF_Balance__c = 3213, CFS_Balance__c = 321421, ABN_NZ_COMPANY_NO__c = Ident+i));
      }
      return myABNBalances;
    }
  
    
    
   
    // Contact Builder
    public static List<Contact> CreateContact(List<Account> myAccounts, String AccountId, Integer Size){
      List<Contact> myContacts = new List<Contact>();
      if(AccountId == null){
        for(Account a:myAccounts){
          myContacts.add(New Contact(AccountId = a.Id, Salutation = 'Mr.', FirstName ='Fname', LastName='Lname'+'_'+a.Id, Phone = '0290099009', Fax = '0290099009', MobilePhone = '0290099009'));
        }
      }else{
        for(Integer i = 0;i<=Size;i++){
          myContacts.add(New Contact(AccountId = AccountId, Salutation = 'Mr.', FirstName ='Fname', LastName='Lname'+'_'+AccountId, Phone = '0290099009', Fax = '0290099009', MobilePhone = '0290099009'));
        }
      }
      return myContacts;
    }
   
   }