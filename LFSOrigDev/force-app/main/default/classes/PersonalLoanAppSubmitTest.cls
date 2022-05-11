@isTest
public class PersonalLoanAppSubmitTest {

    @TestSetup
    static void makeData(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'broker' + 'test3920@test.com',
            Alias = 'brokeest',
            Email='broker.tsst392@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='broker',
            Lastname='test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
       
        User portalUser ;
        Contact testBroker = new Contact();    
        System.runAs ( portalAccountOwner1 ) 
        {
        //Create account
            Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            System.debug('2XXXXX');
            //Create contact
            testBroker = TestDataBuilder.createBrokerRecord();
            testBroker.Broker_View_Access__c = 'Individual View';
            testBroker.Email = 'testBroker332@test.com';
            testBroker.FirstName = 'Test';
            testBroker.Lastname = 'McTesty';
            testBroker.MobilePhone = '0400050900';
            testBroker.Fax = '0411110090';
            testBroker.AccountId = portalAccount1.Id;   
            testBroker.Primary_Contact__c=true; 
            //testBroker.Email_Permission__c = 'No Permission Given';
            Database.insert(testBroker);
            System.debug('3XXXXX');
        
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where name ='A10 Latitude Broker Community Login' Limit 1];
            portalUser = new User(
            Username = 'brokerptest02345@test.com',
            ContactId = testBroker.Id,
            ProfileId = portalProfile.Id,
            Alias = 'por123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'pdsd',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            Database.insert(portalUser);     
            System.debug('USERRRRRRRR: '+portalUser.id);     
                    
        }
        System.debug('4XXXXX');
        
        
        
    } 
    
    @isTest
    static void applicationSubmit_JointApp(){

        Brand__c brandObj = TestDataBuilder.createBrand();
        insert brandObj;
        GEProduct__c geProductObj = TestDataBuilder.createGEProduct(brandObj.Id);
        insert geProductObj;
        Product_Version__c pvObj = TestDataBuilder.createProductVersion(geProductObj.Id);
        insert pvObj;
        Product_Version__c pvc = [SELECT Type__c,Brand__c FROM Product_Version__c WHERE Id =:pvObj.Id];
        System.debug('PVCCCC: '+pvc);

        /**CUSTOM SETTINGS */
        Admin_Settings__c asObj = new Admin_Settings__c();
        asObj.Name='TOM Enabled';
        asObj.Value__c = 'TRUE';
        insert asObj;


        Response_Code_Control__c rccObj = new Response_Code_Control__c();
        rccObj.Name = 'New';
        rccObj.Save_Disbursement_Standard__c = true;
        insert rccObj;

        Web_Service_Settings__c wss = new Web_Service_Settings__c();
        wss.Name ='Requested Name Customer';
        wss.Value__c ='CustomerUI';
        insert wss;

        List<Insurance_Premium_Calculation_Variables__c> ipcvList = new List<Insurance_Premium_Calculation_Variables__c>();
        Insurance_Premium_Calculation_Variables__c ipcvObj = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj.Name = 'counter';
        ipcvObj.Description__c = 'counter';
        ipcvObj.Value__c = 15.0;
        ipcvList.add(ipcvObj);

        Insurance_Premium_Calculation_Variables__c ipcvObj1 = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj1.Name = 'maxMonthlyEmi';
        ipcvObj1.Description__c = 'maxMonthlyEmi';
        ipcvObj1.Value__c = 1500.0;
        ipcvList.add(ipcvObj1);

        Insurance_Premium_Calculation_Variables__c ipcvObj2 = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj2.Name = 'maxPrincipal';
        ipcvObj2.Description__c = 'maxPrincipal';
        ipcvObj2.Value__c = 100000.0000;
        ipcvList.add(ipcvObj2);
        insert ipcvList;

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        

        Contact contactObj = new Contact();
        for(Contact cObj : [SELECT Id,Broker_ID__c,Email FROM Contact]){
            if(cObj.Email == 'testBroker332@test.com'){
                contactObj = cObj;
            }
        }
        User userObj = [SELECT Id FROM User WHERE Username = 'brokerptest02345@test.com'];
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(contactObj);
        quoteList[0].Date_of_Birth__c = '10/10/1985';
        insert quoteList;
        String quoteId = quoteList[0].Id;
        
        System.runas(userObj ){
            String loanDetails = '{"loanDetails":{"Applicants":"2","Applicant2Name":"Julia","PrivacyConsent":true,"EIncome":true,"EIdentification":true,"MaxLimit":true,"LoanAmountQuote":13500,"LoanPurposeQuote":"Household furnishings","LoanTerm":"1 year","ProductDisclosure":true,"ECommunication":true,"Applicant1Name":"Kiara","LoanInfo":[]},"personalDetails":{"LatitudeUid":"3007797000000","Title":"Ms","FirstName":"Kiara","LastName":"Pattinson","Gender":"Female","dobDay":"04","dobMonth":"06","dobYear":"1999","DateOfBirth":"04/06/1999","DLNumber":"KPYU87991","ResidentialStreetNumber":"2","ResidentialStreet":"sdfsdf","ResidentialStreetType":"Ave","ResidentialSuburb":"sdfsdf","ResidentialState":"VIC","ResidentialPostcode":"3000","ResidentialCountry":"Australia","ResidentialYears":3,"ResidentialMonths":0,"IsPostalAddSameAsRes":true,"Email":"kiara@pat.com","MobileNumber":"0400981119","BrokerFees":430,"QuoteId":'+'"'+quoteId+'"'+',"RelationshipStatus":"Single","Dependents":"0","ConfirmEmail":"kiara@pat.com"},"personalDetailsJoint":{"FirstName":"Julia","IsPostalAddSameAsRes":true,"LastName":"Joansen","Title":"Miss","Gender":"Female","dobDay":"03","dobMonth":"03","dobYear":"1985","RelationshipStatus":"Single","DLNumber":"HJJH78999","ResidentialStreetNumber":"283","ResidentialStreet":"City Road","ResidentialStreetType":"Rd","ResidentialSuburb":"Southbank","ResidentialState":"VIC","ResidentialPostcode":"3006","ResidentialYears":"3","ResidentialMonths":"4","Email":"j@j.com","ConfirmEmail":"j@j.com","MobileNumber":"0409866899","WorkNumber":"","DateOfBirth":"03/03/1985"},"employmentDetails":{"IncomeQuote":"My permanent - full time job","OccupationQuote":"IT","EmploymentYearsQuote":2,"EmploymentMonthsQuote":3,"EmploymentStatus":"Permanent (work over 20 hours per week)","IncomeInfo":[{"IncomeFrom":"My permanent - full time job","Occupation":"IT","EmploymentYears":"2","EmploymentMonths":3,"IncomeAmount":"4520","id":1,"IncomeFrequency":"Fortnight","EmployerName":"TYU","EmployerContact":"0212123663"}]},"employmentDetailsJoint":{"EmploymentStatus":"Permanent (work over 20 hours per week)","IncomeInfo":[{"IncomeFrom":"My permanent - full time job","EmploymentYears":"1","EmploymentMonths":"2","IncomeAmount":"5563","id":1,"IncomeFrequency":"Fortnight","Occupation":"Armed Services","EmployerName":"GHY","EmployerContact":"0245658899"}]},"expenseDetails":{"ResidentialStatus":"Own a home outright","DoYouPayAllExpenses":"true","LivingExpenses":"1236","LivingExpensesFreq":"Fortnight"},"expenseDetailsJoint":{"ResidentialStatus":"Own a home outright","DoYouPayAllExpenses":"true","LivingExpenses":"569","LivingExpensesFreq":"Week"},"assetDetails":{"NoAssets":false,"AssetInfo":[{"AssetType":"Car","id":1,"AssetValue":"4569","AssetOwnership":"Own outright","VehicleMake":"HUIO","VehicleModel":"L","YearOfManufacture":"2019"},{"AssetType":"Motor home","id":2,"AssetValue":"546321","AssetOwnership":"Own outright"}]},"debtDetails":{"NoDebts":false,"DebtInfo":[{"DebtType":"Personal loan","id":1,"PayOutNConsolidate":false,"FinInstitution":"TYU","RepaymentAmount":"150","RepaymentInterval":"Fortnight","AmountBorrowed":"8500","BalanceRemaining":"4500"},{"DebtType":"Credit card","id":2,"PayOutNConsolidate":false,"FinInstitution":"HJI","CardLimit":"9800","BalanceRemaining":"8471"},{"DebtType":"Overdraft","id":3,"PayOutNConsolidate":false,"FinInstitution":"TYU","CardLimit":"8878","BalanceRemaining":"6523","InterestRate":"2"}]}}';
            Test.startTest();
            PersonalLoanAppSubmit.applicationSubmit(loanDetails);
            Test.stopTest();
        }
        
    }

    @isTest
    static void applicationSubmit_SingleApp(){

        Brand__c brandObj = TestDataBuilder.createBrand();
        insert brandObj;
        GEProduct__c geProductObj = TestDataBuilder.createGEProduct(brandObj.Id);
        insert geProductObj;
        Product_Version__c pvObj = TestDataBuilder.createProductVersion(geProductObj.Id);
        insert pvObj;
        Product_Version__c pvc = [SELECT Type__c,Brand__c FROM Product_Version__c WHERE Id =:pvObj.Id];
        System.debug('PVCCCC: '+pvc);

        /**CUSTOM SETTINGS */
        Admin_Settings__c asObj = new Admin_Settings__c();
        asObj.Name='TOM Enabled';
        asObj.Value__c = 'TRUE';
        insert asObj;


        Response_Code_Control__c rccObj = new Response_Code_Control__c();
        rccObj.Name = 'New';
        rccObj.Save_Disbursement_Standard__c = true;
        insert rccObj;

        Web_Service_Settings__c wss = new Web_Service_Settings__c();
        wss.Name ='Requested Name Customer';
        wss.Value__c ='CustomerUI';
        insert wss;

        List<Insurance_Premium_Calculation_Variables__c> ipcvList = new List<Insurance_Premium_Calculation_Variables__c>();
        Insurance_Premium_Calculation_Variables__c ipcvObj = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj.Name = 'counter';
        ipcvObj.Description__c = 'counter';
        ipcvObj.Value__c = 15.0;
        ipcvList.add(ipcvObj);

        Insurance_Premium_Calculation_Variables__c ipcvObj1 = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj1.Name = 'maxMonthlyEmi';
        ipcvObj1.Description__c = 'maxMonthlyEmi';
        ipcvObj1.Value__c = 1500.0;
        ipcvList.add(ipcvObj1);

        Insurance_Premium_Calculation_Variables__c ipcvObj2 = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj2.Name = 'maxPrincipal';
        ipcvObj2.Description__c = 'maxPrincipal';
        ipcvObj2.Value__c = 100000.0000;
        ipcvList.add(ipcvObj2);
        insert ipcvList;

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        Contact contactObj = new Contact();
        for(Contact cObj : [SELECT Id,Broker_ID__c,Email FROM Contact]){
            if(cObj.Email == 'testBroker332@test.com'){
                contactObj = cObj;
            }
        }
        User userObj = [SELECT Id FROM User WHERE Username = 'brokerptest02345@test.com'];
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(contactObj);
        quoteList[0].Date_of_Birth__c = '10/10/1985';
        insert quoteList;
        String quoteId = quoteList[0].Id;
        
        System.runas(userObj ){
            String loanDetails_Single = '{"loanDetails":{"PrivacyConsent":true,"EIncome":true,"EIdentification":true,"MaxLimit":true,"LoanAmountQuote":13500,"LoanPurposeQuote":"Household furnishings","LoanTerm":"3 years","ProductDisclosure":true,"ECommunication":true,"Applicants":"1","LoanInfo":[{"id":1,"loanAmount":4500,"loanPurpose":"Educational expenses","isOtherPurpose":false}]},"personalDetails":{"LatitudeUid":"3007797177405","Title":"Ms","FirstName":"Kiara","LastName":"Pattinson","Gender":"Female","dobDay":"04","dobMonth":"06","dobYear":"1999","DateOfBirth":"04/06/1999","DLNumber":"KPYU87991","ResidentialStreetNumber":"2","ResidentialStreet":"sdfsdf","ResidentialStreetType":"Ave","ResidentialSuburb":"sdfsdf","ResidentialState":"VIC","ResidentialPostcode":"3000","ResidentialCountry":"Australia","ResidentialYears":"2","ResidentialMonths":0,"IsPostalAddSameAsRes":false,"Email":"kiara@pat.com","MobileNumber":"0400981119","BrokerFees":430,"QuoteId":'+'"'+quoteId+'"'+',"RelationshipStatus":"Single","Dependents":"0","PrevStreetNumber":"281","PrevStreet":"City Road","PrevStreetType":"Rd","PrevSuburb":"Southbank","PrevState":"VIC","PrevPostcode":"3006","PrevProperty":"","PrevYears":"2","PrevMonths":"0","PosStreetNumber":"282","PosStreet":"City Road","PosStreetType":"Rd","PosSuburb":"Southbank","PosState":"VIC","PosPostcode":"3006","PosPropertyName":"","ConfirmEmail":"kiara@pat.com"},"personalDetailsJoint":{},"employmentDetails":{"IncomeQuote":"My permanent - full time job","OccupationQuote":"IT","EmploymentYearsQuote":2,"EmploymentMonthsQuote":3,"EmploymentStatus":"Permanent (work over 20 hours per week)","IncomeInfo":[{"IncomeFrom":"My permanent - full time job","Occupation":"IT","EmploymentYears":2,"EmploymentMonths":3,"IncomeAmount":"230000","id":1,"IncomeFrequency":"Year","EmployerName":"GHYU","EmployerContact":"0212121212"}]},"employmentDetailsJoint":{},"expenseDetails":{"ResidentialStatus":"Renting","DoYouPayAllExpenses":"true","LivingExpenses":"1456","LivingExpensesFreq":"Year","RentBoardPayments":"520","PaymentFrequency":"Month","LandlordName":"GHY"},"expenseDetailsJoint":{},"assetDetails":{"NoAssets":true,"AssetInfo":[]},"debtDetails":{"NoDebts":false,"DebtInfo":[{"DebtType":"Mortgage","id":1,"PayOutNConsolidate":false,"FinInstitution":"HJYU","RepaymentAmount":"1450","RepaymentInterval":"Week","AmountBorrowed":"54630","BalanceRemaining":"22104"},{"DebtType":"Charge card","id":2,"PayOutNConsolidate":false,"FinInstitution":"NSD","CardLimit":"4562","BalanceRemaining":"4123"},{"DebtType":"Other","id":3,"PayOutNConsolidate":true,"FinInstitution":"UIL","AmountBorrowed":"5563","RepaymentAmount":"120","RepaymentInterval":"Fortnight"}]}}';
            Test.startTest();
            PersonalDetailsController.getStreetTypeValues();
            PersonalLoanAppSubmit.applicationSubmit(loanDetails_Single);
            ExpenseDetailsWrapper edw = new ExpenseDetailsWrapper();
            edw.LandlordName ='A';
            edw.RentBoardPayments = 2.0;
            edw.PaymentFrequency = 'Month'; 
            AppSubmitException ase = new AppSubmitException();
            Test.stopTest();

            //Cancel Quote
            String quoteCancelDetails = '{"PrimaryReason":"Rate was too high","QuoteId":'+'"'+quoteId+'"'+',"ClientFinance":"Used another lender"}';
            QuoteActionsManager.cancelQuote(quoteCancelDetails);
        }
        
    }

    @isTest
    static void applicationSubmit_SingleApp_Exception(){

        Brand__c brandObj = TestDataBuilder.createBrand();
        insert brandObj;
        GEProduct__c geProductObj = TestDataBuilder.createGEProduct(brandObj.Id);
        insert geProductObj;
        Product_Version__c pvObj = TestDataBuilder.createProductVersion(geProductObj.Id);
        insert pvObj;
        Product_Version__c pvc = [SELECT Type__c,Brand__c FROM Product_Version__c WHERE Id =:pvObj.Id];
        System.debug('PVCCCC: '+pvc);

        /**CUSTOM SETTINGS */
        Admin_Settings__c asObj = new Admin_Settings__c();
        asObj.Name='TOM Enabled';
        asObj.Value__c = 'TRUE';
        insert asObj;


        Response_Code_Control__c rccObj = new Response_Code_Control__c();
        rccObj.Name = 'New';
        rccObj.Save_Disbursement_Standard__c = true;
        insert rccObj;

        Web_Service_Settings__c wss = new Web_Service_Settings__c();
        wss.Name ='Requested Name Customer';
        wss.Value__c ='CustomerUI';
        insert wss;

        List<Insurance_Premium_Calculation_Variables__c> ipcvList = new List<Insurance_Premium_Calculation_Variables__c>();
        Insurance_Premium_Calculation_Variables__c ipcvObj = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj.Name = 'counter';
        ipcvObj.Description__c = 'counter';
        ipcvObj.Value__c = 15.0;
        ipcvList.add(ipcvObj);

        Insurance_Premium_Calculation_Variables__c ipcvObj1 = new Insurance_Premium_Calculation_Variables__c();
        ipcvObj1.Name = 'maxMonthlyEmi';
        ipcvObj1.Description__c = 'maxMonthlyEmi';
        ipcvObj1.Value__c = 1500.0;
        ipcvList.add(ipcvObj1);

        

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        Contact contactObj = new Contact();
        for(Contact cObj : [SELECT Id,Broker_ID__c,Email FROM Contact]){
            if(cObj.Email == 'testBroker332@test.com'){
                contactObj = cObj;
            }
        }
        User userObj = [SELECT Id FROM User WHERE Username = 'brokerptest02345@test.com'];
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(contactObj);
        quoteList[0].Date_of_Birth__c = '10/10/1985';
        insert quoteList;
        String quoteId = quoteList[0].Id;
        
        System.runas(userObj ){
            String loanDetails_Single = '{"loanDetails":{"PrivacyConsent":true,"EIncome":true,"EIdentification":true,"MaxLimit":true,"LoanAmountQuote":13500,"LoanPurposeQuote":"Household furnishings","LoanTerm":"3 years","ProductDisclosure":true,"ECommunication":true,"Applicants":"1","LoanInfo":[{"id":1,"loanAmount":4500,"loanPurpose":"Educational expenses","isOtherPurpose":false}]},"personalDetails":{"LatitudeUid":"3007797177405","Title":"Ms","FirstName":"Sijo","LastName":"Pattinson","Gender":"Female","dobDay":"04","dobMonth":"06","dobYear":"1999","DateOfBirth":"04/06/1999","DLNumber":"KPYU87991","ResidentialStreetNumber":"2","ResidentialStreet":"sdfsdf","ResidentialStreetType":"Ave","ResidentialSuburb":"sdfsdf","ResidentialState":"VIC","ResidentialPostcode":"3000","ResidentialCountry":"Australia","ResidentialYears":"2","ResidentialMonths":0,"IsPostalAddSameAsRes":false,"Email":"kiara@pat.com","MobileNumber":"0400981119","BrokerFees":430,"QuoteId":'+'"'+quoteId+'"'+',"RelationshipStatus":"Single","Dependents":"0","PrevStreetNumber":"281","PrevStreet":"City Road","PrevStreetType":"Rd","PrevSuburb":"Southbank","PrevState":"VIC","PrevPostcode":"3006","PrevProperty":"","PrevYears":"2","PrevMonths":"0","PosStreetNumber":"282","PosStreet":"City Road","PosStreetType":"Rd","PosSuburb":"Southbank","PosState":"VIC","PosPostcode":"3006","PosPropertyName":"","ConfirmEmail":"kiara@pat.com"},"personalDetailsJoint":{},"employmentDetails":{"IncomeQuote":"My permanent - full time job","OccupationQuote":"IT","EmploymentYearsQuote":2,"EmploymentMonthsQuote":3,"EmploymentStatus":"Permanent (work over 20 hours per week)","IncomeInfo":[{"IncomeFrom":"My permanent - full time job","Occupation":"IT","EmploymentYears":2,"EmploymentMonths":3,"IncomeAmount":"230000","id":1,"IncomeFrequency":"Year","EmployerName":"GHYU","EmployerContact":"0212121212"}]},"employmentDetailsJoint":{},"expenseDetails":{"ResidentialStatus":"Renting","DoYouPayAllExpenses":"true","LivingExpenses":"1456","LivingExpensesFreq":"Year","RentBoardPayments":"520","PaymentFrequency":"Month","LandlordName":"GHY"},"expenseDetailsJoint":{},"assetDetails":{"NoAssets":true,"AssetInfo":[]},"debtDetails":{"NoDebts":false,"DebtInfo":[{"DebtType":"Mortgage","id":1,"PayOutNConsolidate":false,"FinInstitution":"HJYU","RepaymentAmount":"1450","RepaymentInterval":"Week","AmountBorrowed":"54630","BalanceRemaining":"22104"},{"DebtType":"Charge card","id":2,"PayOutNConsolidate":false,"FinInstitution":"NSD","CardLimit":"4562","BalanceRemaining":"4123"},{"DebtType":"Other","id":3,"PayOutNConsolidate":true,"FinInstitution":"UIL","AmountBorrowed":"5563","RepaymentAmount":"120","RepaymentInterval":"Fortnight"}]}}';
            Test.startTest();
            try{
                PersonalLoanAppSubmit.applicationSubmit(loanDetails_Single);
            }catch(Exception e){
                //DO NOTHING
            }
            
            Test.stopTest();

           
        }
        
    }
}