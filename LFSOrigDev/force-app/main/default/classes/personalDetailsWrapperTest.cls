@isTest
public class personalDetailsWrapperTest {
    
    Boolean validationResult = true;
    //check if record is accessed from SUI or CUI
    Boolean isStaffUi ;
    Site sitename= new Site();
    
    
    Boolean flagMessage=false;
    String disableDrvcAst ;
    String maleSelected ;
    String femaleSelected ;
    String PostalFlag ;
    String birthYear ;
    String birthMonth ;
    String birthDate ;
    String issueYear ;
    String issueMonth ;
    String issueDate ;
    String issueYearSec ;
    String issueMonthSec ;
    String issueDateSec ;
    String expiryYear ;
    String expiryMonth ;
    String expiryDate ;
    String expiryYearSec ;
    String expiryMonthSec ;
    String expiryDateSec ;
    String NoOfDeps ;
    // String applicationCountry ;
    String TempDrivLicence;
    
    //Rendering variables
    Boolean errorTitle ;
    Boolean errorFName ;
    Boolean errorMName ;
    Boolean errorLName ;
    Boolean errorGender ;
    Boolean errorDateOfBirth ;
    Boolean errorRelStat ;
    Boolean errorNoOfDeps ;
    Boolean errorLicense ;
    Boolean errorResStat ;
    Boolean errorPrefContactMethod ;
    Boolean errorUnitNum ;
    Boolean errorStreetNum ;
    Boolean errorStreetName ;
    Boolean errorStreetType ;
    Boolean errorSuburb ;
    Boolean errorCity ;
    Boolean errorPostcode ;
    Boolean errorState ;
    Boolean errorCountry ;
    Boolean errorProperty ;
    Boolean errorTimeAtAddress ;
    Boolean errorHome ;
    Boolean errorMobile ;
    Boolean errorWork ;
    Boolean errorEmail ;
    Boolean errorPostalUnitNo ;
    Boolean errorPostalPostcode ;
    Boolean errorPostalStreetNo ;
    Boolean errorPostalStreet ;
    Boolean errorPostalStreetType ;
    Boolean errorPostalCountry ;
    Boolean errorPostalState ;
    Boolean errorPostalSuburb ;
    Boolean errorPostalCity ;
    Boolean errorPreviousPostcode ;
    Boolean errorPreviousStreet ;
    Boolean errorPreviousStreetType ;
    Boolean errorPreviousUnitNo ;
    Boolean errorPreviousSuburb ;
    Boolean errorPreviousCity ;
    Boolean errorPreviousStreetNo ;
    Boolean errorPreviousState ;
    Boolean errorPreviousCountry ;
    Boolean errorPreviousProperty ;
    Boolean errorTimePrevAtAddress ;
    Boolean disableEmail ;
    Boolean disableDOB ;
    Boolean errorPostalAddress ;
    Boolean errorPostalFlag ;
    Boolean errorServiceType ;
    Boolean errorServiceId ;
    Boolean errorCustomerIdType ;
    Boolean errorIdType ;
    Boolean errorVersion ;
    Boolean errorNZResidencyNumber ;
    Boolean errorIssuedate ;
    Boolean errorExpirydate ;
    Boolean errorIssuingcountry ;
    Boolean errorOtherdocument ;
    //DBHZL-81 -BEGIN
    Boolean errorSecIDExpiryDate ;
    Boolean errorSecIDNumber ;
    //DBHZL-81 -END
    
    //Error messages
    String errorTimePrevAtAddressMsg ;
    String errorPostalPostcodeMsg ;
    String errorPreviousPostcodeMsg ;
    String errorPreviousStreetMsg ;
    String errorPreviousStreetTypeMsg ;
    String errorPreviousUnitNoMsg ;
    String errorPreviousSuburbMsg ;
    String errorPreviousCityMsg ;
    String errorPreviousStreetNoMsg ;
    String errorPreviousStateMsg ;
    String errorPreviousCountryMsg ;
    String errorPreviousPropertyMsg ;
    String errorTimeAtAddressMsg ;
    String errorHomeMsg ;
    String errorMobileMsg ;
    String errorWorkMsg ;
    String errorEmailMsg ;
    String errorTitleMsg ;
    String errorFNameMsg ;
    String errorMNameMsg ;
    String errorLNameMsg ;
    String errorGenderMsg ;
    String errorDateOfBirthMsg ;
    String errorRelStatMsg ;
    String errorNoOfDepsMsg ;
    String errorLicenseMsg ;
    String errorResStatMsg ;
    String errorPrefContactMethodMsg ;
    String errorUnitNumMsg ;
    String errorStreetNumMsg ;
    String errorStreetNameMsg ;
    String errorStreetTypeMsg ;
    String errorSuburbMsg ;
    String errorCityMsg ;
    String errorPostcodeMsg ;
    String errorStateMsg ;
    String errorCountryMsg ;
    String errorPropertyMsg ;
    String errorPostalAddressMsg ;
    String errorPostalUnitNoMsg ;
    String errorPostalStreetNoMsg ;
    String errorPostalStreetTypeMsg ;
    String errorPostalStreetMsg ;
    String errorPostalSuburbMsg ;
    String errorPostalCityMsg ;
    String errorPostalCountryMsg ;
    String errorPostalStateMsg ;
    String errorPostalFlagMsg ;
    String errorServiceIdMsg ;
    String errorServiceTypeMsg ;
    String errorCustomerIdTypeMsg ;
    String errorCustomerIdNumberMsg ;
    String errorVersionMsg ;
    String errorNZResidencyNumberMsg ;
    String errorIssuedateMsg ;
    String errorExpirydateMsg ;
    String errorIssuingcountryMsg ;
    String applicationCountryMsg ;
    String errorOtherdocumentMsg ;
    //DBHZL-81 -BEGIN
    String errorSecIDExpiryDateMsg ;
    String errorSecIDNumberMsg ;
    Boolean errorConfirmEmail;
    String errorConfirmEmailMsg;
    String applicationCountry='NZ';
    
    
    
    static testMethod void SubmitApplicationTest(){
        
        
        
        
        personalDetailsWrapper ai1 = new personalDetailsWrapper();
        ai1.disableDrvcAst = '';
        ai1.isStaffUi=true;
        ai1.maleSelected = '';
        ai1.femaleSelected = '';
        ai1.PostalFlag = 'No';
        ai1.birthYear = '';
        ai1.birthMonth = '';
        ai1.birthDate = '';
        ai1.issueYear = '';
        ai1.issueMonth = '';
        ai1.issueDate = '';
        ai1.issueYearSec='';
        ai1.issueMonthSec='';
        ai1.issueYearSec='';
        ai1.issueDateSec='';
        ai1.NoOfDeps='';
        ai1.expiryDateSec='';
        ai1.expiryMonthSec='';
        ai1.expiryYearSec='';
        ai1.expiryYear = '';
        ai1.expiryMonth = '';
        ai1.expiryDate = '';
        ai1.TempDrivLicence='';
        ai1.applicationCountryMsg='';
        ai1.errorPostalFlag = false;
        ai1.disableEmail = false;
        ai1.disableDOB = false;
        ai1.errorTitle = true;
        ai1.errorFName = false;
        ai1.errorMName = false;
        ai1.errorLName = false;
        ai1.errorGender = false;
        ai1.errorDateOfBirth = false;
        ai1.errorRelStat = false;
        ai1.errorNoOfDeps = false;
        ai1.errorLicense = false;
        ai1.errorResStat = false;
        ai1.errorPrefContactMethod = false;
        ai1.errorUnitNum = false;
        ai1.errorStreetNum = false;
        ai1.errorStreetName = false;
        ai1.errorStreetType = false;
        ai1.errorSuburb = false;
        ai1.errorCity = false;
        ai1.errorPostcode = false;
        ai1.errorState = false;
        ai1.errorCountry = false;
        ai1.errorTimeAtAddress = false;
        ai1.errorHome = false;
        ai1.errorMobile = false;
        ai1.errorWork = false;
        ai1.errorEmail = false;
        ai1.errorPostalPostcode = false;
        ai1.errorPreviousPostcode = false;
        ai1.errorPreviousStreet = false;
        ai1.errorPreviousStreetType = false;
        ai1.errorPreviousUnitNo = false;
        ai1.errorPreviousSuburb = false;
        ai1.errorPreviousCity = false;
        ai1.errorPreviousStreetNo = false;
        ai1.errorPreviousState = false;
        ai1.errorPreviousCountry = false;
        ai1.errorPreviousProperty = false;
        ai1.errorTimePrevAtAddress = false;
        ai1.errorPostalAddress = false;
        ai1.errorPostalUnitNo = false;
        ai1.errorPostalStreetNo = false;
        ai1.errorPostalStreet = false;
        ai1.errorPostalState = false;
        ai1.errorPostalSuburb = false;
        ai1.errorPostalCity = false;
        ai1.errorPostalCountry = false;
        ai1.errorServiceType = false;
        ai1.errorServiceId = false;
        ai1.errorCustomerIdType = false;
        ai1.errorIdType = false;
        ai1.errorVersion = false;
        ai1.errorNZResidencyNumber = false;
        ai1.errorIssuedate = false;
        ai1.errorExpirydate = false;
        ai1.errorIssuingcountry = false;
        ai1.errorOtherdocument = false;
        
        ai1.errorSecIDExpiryDate = false;
        ai1.errorSecIDNumber = false;
        
        ai1.errorPostalFlagMsg = '';
        ai1.applicationCountry = 'NZ';
        ai1.errorTimePrevAtAddressMsg = '';
        ai1.errorPostalPostcodeMsg = '';
        ai1.errorPreviousPostcodeMsg = '';
        ai1.errorPreviousStreetMsg = '';
        ai1.errorPreviousStreetTypeMsg = '';
        ai1.errorPreviousUnitNoMsg = '';
        ai1.errorPreviousSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
        ai1.errorPreviousCityMsg = '';
        ai1.errorPreviousStreetNoMsg = '';
        ai1.errorPreviousStateMsg = '';
        ai1.errorPreviousCountryMsg = '';
        ai1.errorPreviousPropertyMsg = '';
        ai1.errorTimeAtAddressMsg = '';
        ai1.errorHomeMsg = '';
        ai1.errorMobileMsg = '';
        ai1.errorWorkMsg = '';
        ai1.errorEmailMsg = '';
        ai1.errorTitleMsg = '';
        ai1.errorFNameMsg = '';
        ai1.errorMNameMsg = '';
        ai1.errorLNameMsg = '';
        ai1.errorGenderMsg = '';
        ai1.errorDateOfBirthMsg = '';
        ai1.errorRelStatMsg = '';
        ai1.errorNoOfDepsMsg = '';
        ai1.errorLicenseMsg = '';
        ai1.errorResStatMsg = '';
        ai1.errorPrefContactMethodMsg = '';
        ai1.errorUnitNumMsg = '';
        ai1.errorStreetNumMsg = '';
        ai1.errorStreetNameMsg = '';
        ai1.errorStreetTypeMsg = '';
        ai1.errorSuburbMsg = '';
        ai1.errorCityMsg = '';
        ai1.errorPostcodeMsg = '';
        ai1.errorStateMsg = '';
        ai1.errorCountryMsg = '';
        ai1.errorPropertyMsg = '';
        ai1.errorPostalAddressMsg = '';
        ai1.errorPostalUnitNoMsg = '';
        ai1.errorPostalStreetNoMsg = '';
        ai1.errorPostalStreetMsg = '';
        ai1.errorPostalStatemsg = '';
        ai1.errorPostalSuburbMsg = '';
        ai1.errorPostalCityMsg = '';
        ai1.errorPostalCountrymsg = '';
        ai1.errorServiceTypeMsg = '';
        ai1.errorServiceIdMsg = '';
        ai1.errorCustomerIdTypeMsg = '';
        ai1.errorCustomerIdNumberMsg = '';
        ai1.errorVersionMsg = '';
        ai1.errorNZResidencyNumberMsg = '';
        ai1.errorIssuedateMsg = '';
        ai1.errorExpirydateMsg = '';
        ai1.errorIssuingcountryMsg = '';
        ai1.errorOtherdocumentMsg = '';
        
        ai1.errorSecIDExpiryDateMsg = '';
        ai1.errorSecIDNumberMsg = '';
        ai1.errorPostalFlagMsg = '';
        ai1.errorTimePrevAtAddressMsg = '';
        ai1.errorPostalPostcodeMsg = '';
        ai1.errorPreviousPostcodeMsg = '';
        ai1.errorPreviousStreetMsg = '';
        ai1.errorPreviousStreetTypeMsg = '';
        ai1.errorPreviousUnitNoMsg = '';
        ai1.errorPreviousSuburbMsg = '';
        ai1.errorPreviousCityMsg = '';
        ai1.errorPreviousStreetNoMsg = '';
        ai1.errorPreviousStateMsg = '';
        ai1.errorPreviousCountryMsg = '';
        ai1.errorPreviousPropertyMsg = '';
        ai1.errorTimeAtAddressMsg = '';
        ai1.errorHomeMsg = '';
        ai1.errorMobileMsg = '';
        ai1.errorWorkMsg = '';
        ai1.errorEmailMsg = '';
        ai1.errorTitleMsg = '';
        ai1.errorFNameMsg = '';
        ai1.errorMNameMsg = '';
        ai1.errorLNameMsg = '';
        ai1.errorGenderMsg = '';
        ai1.errorDateOfBirthMsg = '';
        ai1.errorRelStatMsg = '';
        ai1.errorNoOfDepsMsg = '';
        ai1.errorLicenseMsg = '';
        ai1.errorResStatMsg = '';
        ai1.errorPrefContactMethodMsg = '';
        ai1.errorUnitNumMsg = '';
        ai1.errorStreetNumMsg = '';
        ai1.errorStreetNameMsg = '';
        ai1.errorStreetTypeMsg = '';
        ai1.errorSuburbMsg = '';
        ai1.errorCityMsg = '';
        ai1.errorPostcodeMsg = '';
        ai1.errorStateMsg = '';
        ai1.errorCountryMsg = '';
        ai1.errorPropertyMsg = '';
        ai1.errorPostalAddressMsg = '';
        ai1.errorPostalUnitNoMsg = '';
        ai1.errorPostalStreetNoMsg = '';
        ai1.errorPostalStreetMsg = '';
        ai1.errorPostalStatemsg = '';
        ai1.errorPostalSuburbMsg = '';
        ai1.errorPostalCityMsg = '';
        ai1.errorPostalCountrymsg = '';
        ai1.errorServiceTypeMsg = '';
        ai1.errorServiceIdMsg = '';
        ai1.errorCustomerIdTypeMsg = '';
        ai1.errorCustomerIdNumberMsg = '';
        ai1.errorVersionMsg = '';
        ai1.errorNZResidencyNumberMsg = '';
        ai1.errorIssuedateMsg = '';
        ai1.errorExpirydateMsg = '';
        ai1.errorIssuingcountryMsg = '';
        ai1.errorOtherdocumentMsg = '';
        //DBHZL-81 -BEGIN
        ai1.errorSecIDExpiryDateMsg = '';
        ai1.errorSecIDNumberMsg = '';
        
        ai1.errorConfirmEmail=false;
        ai1.errorConfirmEmailMsg=''; 
        ai1.errorServiceId=true;
        
        Test.startTest();
        Application__c application1 = TestDataBuilder.createApplication();    
        insert application1;   
        
        Applicant__c app1 = new Applicant__c();
        app1.Application__c = application1.Id;
        
        app1.Title__c = 'Select';
        app1.PO_Box__c=true;
        app1.Street_No_Pos__c= null;
        app1.Country_Pos__c= null;
        app1.Street_Type_Pos__c= null;
        app1.Suburb_Pos__c= null;
        app1.City_Pos__c= null;
        app1.Postcode_Pos__c= null;
        app1.Service_Delivery_Id__c= 'Community Mail Box';
        app1.Street_Type_Res__c = null;
        app1.Suburb_Res__c= null;
        app1.City_Res__c= null;
        app1.Country_Res__c= null;
        app1.Customer_ID_Type__c ='NZ Passport';
        app1.Rel_Status__c = 'Please Select';
        app1.State_Res__c= null;
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Street_Type_Pre__c = 'Street';
        app1.Work__c= '0258258258';
        app1.Is_Primary_Applicant__c= false;
        app1.Email_Address__c= null;
        app1.ConfirmEmailAddress__c= null;
        app1.Years_At_Addr__c= '0';
        app1.Residential_Property_Name__c= null;
        app1.Unit_No_Res__c= null;
        app1.Unit_No_Pos__c= null;
        app1.Street_Res__c= null;
        app1.Postal_Addr_Flg__c= true;
        app1.Postal_Property_Name__c= null;
        
        app1.Service_Delivery_Type__c= 'PO Box';
        app1.Months_At_Addr__c= null;
        app1.Months_At_Prev_Addr__c= null;
        app1.Postcode_Pre__c= null;
        app1.Street_No_Pre__c= null;
        app1.Suburb_Pre__c= null;
        app1.City_Pre__c= null;
        app1.Country_Pre__c=null;
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Work__c= null; 
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Work__c= null;
        insert app1;
        
        ai1.validateApplicant(app1, ai1) ;   
        ai1.executePOBox();
        
        Boolean checkCity = personalDetailsWrapper.validateCity(app1.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(app1.Name, app1.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(app1.Name);
        
        Test.stopTest();
        
    }
    
    static testMethod void testApplicationCheck(){
        personalDetailsWrapper ai4 = new personalDetailsWrapper();
        ai4.disableDrvcAst = '';
        ai4.isStaffUi=false;
        ai4.maleSelected = '';
        ai4.femaleSelected = '';
        ai4.PostalFlag = 'No';
        ai4.birthYear = '1980';
        ai4.birthMonth = '04';
        ai4.birthDate = '25';
        ai4.issueYear = '2010';
        ai4.issueMonth = '03';
        ai4.issueDate = '12';
        ai4.issueYearSec='';
        ai4.issueMonthSec='';
        ai4.issueDateSec='';
        ai4.issueYearSec='';
        ai4.NoOfDeps='4';
        ai4.TempDrivLicence='';
        ai4.applicationCountryMsg='';
        ai4.expiryDateSec='';
        ai4.expiryMonthSec='';
        ai4.expiryYearSec='';
        ai4.expiryYear = '2022';
        ai4.expiryMonth = '02';
        ai4.expiryDate = '15';      
        
        ai4.errorSecIDExpiryDate = false;
        ai4.errorSecIDNumber = false;
        
        ai4.errorPostalFlagMsg = '';
        ai4.applicationCountry = 'AU';
        ai4.errorTimePrevAtAddressMsg = '';
        ai4.errorPostalPostcodeMsg = '';
        ai4.errorPreviousPostcodeMsg = '';
        ai4.errorPreviousStreetMsg = '';
        ai4.errorPreviousStreetTypeMsg = '';
        ai4.errorPreviousUnitNoMsg = '';
        ai4.errorPreviousSuburbMsg = '';
        ai4.errorPreviousCityMsg = '';
        ai4.errorPreviousStreetNoMsg = '';
        ai4.errorPreviousStateMsg = '';
        ai4.errorPreviousCountryMsg = '';
        ai4.errorPreviousPropertyMsg = '';
        ai4.errorTimeAtAddressMsg = '';
        ai4.errorHomeMsg = '';
        ai4.errorMobileMsg = '';
        ai4.errorWorkMsg = '';
        ai4.errorEmailMsg = 'Error: Please enter your e-mail address.';
        ai4.errorTitleMsg = '';
        ai4.errorFNameMsg = '';
        ai4.errorMNameMsg = '';
        ai4.errorLNameMsg = '';
        ai4.errorGenderMsg = '';
        ai4.errorDateOfBirthMsg = '';
        ai4.errorRelStatMsg = '';
        ai4.errorNoOfDepsMsg = '';
        ai4.errorLicenseMsg = '';
        ai4.errorResStatMsg = '';
        ai4.errorPrefContactMethodMsg = '';
        ai4.errorUnitNumMsg = '';
        ai4.errorStreetNumMsg = '';
        ai4.errorStreetNameMsg = '';
        ai4.errorStreetTypeMsg = '';
        ai4.errorSuburbMsg = '';
        ai4.errorCityMsg = '';
        ai4.errorPostcodeMsg = '';
        ai4.errorStateMsg = '';
        ai4.errorCountryMsg = '';
        ai4.errorPropertyMsg = '';
        ai4.errorPostalAddressMsg = '';
        ai4.errorPostalUnitNoMsg = '';
        ai4.errorPostalStreetNoMsg = '';
        ai4.errorPostalStreetMsg = '';
        ai4.errorPostalStatemsg = '';
        ai4.errorPostalSuburbMsg = '';
        ai4.errorPostalCityMsg = '';
        ai4.errorPostalCountrymsg = '';
        ai4.errorServiceTypeMsg = '';
        ai4.errorServiceIdMsg = '';
        ai4.errorCustomerIdTypeMsg = '';
        ai4.errorCustomerIdNumberMsg = '';
        ai4.errorVersionMsg = '';
        ai4.errorNZResidencyNumberMsg = '';
        ai4.errorIssuedateMsg = '';
        ai4.errorExpirydateMsg = '';
        ai4.errorIssuingcountryMsg = '';
        ai4.errorOtherdocumentMsg = '';
        
        
        //DBHZL-81 -BEGIN
        ai4.errorSecIDExpiryDateMsg = '';
        ai4.errorSecIDNumberMsg = '';
        
        ai4.errorConfirmEmail=false;
        ai4.errorConfirmEmailMsg=''; 
        
        
        
        
        Application__c application4 = TestDataBuilder.createApplication();
        
        insert application4;
        
        boolean flag = true;
           User siteUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1];
        System.runAs(siteUser) {
            System.debug('!@#testSite: ' + site.getName());
        }
        
        
        Applicant__c app4 = new Applicant__c();
        app4.Application__c = application4.Id;
        app4.PO_Box__c=true;
        
        app4.Date_Of_Birth__c = '01-01-1990';
        app4.Date_of_Birth_WS__c = '1990-01-01';
        app4.Drivers_Lic_No__c = '123123123';
        app4.Email_Address__c = 'Test@ge.com';
        app4.ConfirmEmailAddress__c = 'Test@ge.com';
        app4.First_Name__c = 'FirstName';
        app4.Gender__c = 'Male';
        app4.Home__c = '0212345678';
        app4.Drivers_Lic_Flg__c = false;
        app4.Last_Name__c = 'Lastname';
        app4.Middle_Name__c = 'MidName';
        app4.Mobile__c = '0412345678';
        app4.No_of_Deps__c = 2;
        app4.Residential_Property_Name__c='';
        app4.Postal_Addr_Flg__c = true;
        app4.Postcode_Pos__c = '4125';
        app4.Street_Pos__c = 'Sample';
        app4.Street_No_Pos__c = '123';
        app4.Street_Type_Pos__c = 'Street';
        app4.Suburb_Pos__c = 'NSW';
        app4.Unit_No_Pos__c = '1234';
        app4.Pref_Contact_Method__c = 'Phone';
        app4.Postcode_Pre__c = '4215';
        app4.Street_Pre__c = 'Sample';
        app4.Street_No_Pre__c = '123';
        app4.Street_Type_Pre__c = 'Street';
        app4.Suburb_Pre__c = 'NSW';
        app4.Unit_No_Pre__c = '123';
        app4.Rel_Status__c = 'Single';
        app4.Postcode_Res__c = '4125';
        app4.Res_Status__c = 'Renting';
        app4.Street_Res__c = 'Sample';
        app4.Street_No_Res__c = '123';
        app4.Street_Type_Res__c = 'Street';
        app4.Suburb_Res__c = 'NSW';
        app4.Unit_No_Res__c = '123';
        app4.Months_At_Addr__c = '2';
        app4.Years_At_Addr__c = '2';
        app4.Title__c = 'Select';
        app4.Work__c = '0212345678';
        app4.Country_Pos__c = 'australia';
        app4.Country_Res__c = 'Australia';
        app4.Country_Pre__c = 'Australia';
        app4.State_Res__c = 'PARRAMATTA';
        app4.State_Pos__c = 'PARRAMATTA';
        app4.State_Pre__c = 'PARRAMATTA';
        app4.Customer_ID_Type__c ='Driving Licence';
        app4.Is_Primary_Applicant__c=true;
        app4.Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)';
        app4.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
        
        
        insert app4;
        system.debug('Check Application'+app4);
        ai4.validateApplicant(app4, ai4) ;   
        ai4.executePOBox(); 
        Boolean checkCity = personalDetailsWrapper.validateCity(app4.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(app4.Name, app4.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(app4.Name);
        
        
    }
    
    static testMethod void constructorTest(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Gender__c = 'Female';
        testApplicant2.Drivers_Lic_Flg__c = true;
        testApplicant2.Email_Address__c = null;
        testApplicant2.Issue_Date__c = Date.today();
        testApplicant2.Expiry_Date__c = Date.today();
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.redirectTo = 'Save';
        jointPDExt.register();
        jointPDExt.logout();
        jointPDExt.getTimeOut();
        jointPDExt.getWarning();
        Test.StopTest();
        //Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        //Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        //Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
        System.assertEquals(true, jointPDExt.isJoint);
    }
    static testMethod void deleteApplicant_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;       
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Gender__c = 'Female';
        testApplicant2.Drivers_Lic_Flg__c = true;
        testApplicant2.Email_Address__c = null;
        insert testApplicant2;
        
        PageReference testDeleteApplicant = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id);
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        PageReference deleteApplicant = jointPDExt.deleteApplicant();
       // Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant2.Name);
        //Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant2.Name, testApplicant2.City_Pos__c);
        //Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant2.Name);
        
        Test.StopTest();
        
        System.assertEquals(testDeleteApplicant.getUrl(), deleteApplicant.getUrl());
    }
    
    static testMethod void saveApplicantSuccess_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        //User guestUser = [SELECT Id FROM User WHERE Name =: GEN_OriginationsConstants.GUEST_USERNAME LIMIT 1];
        //System.runAs(guestUser){
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        
        insert testApplicant;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        PageReference testSaveApplicant = new PageReference('/apex/app_timeout');
        
        Test.setCurrentPage(Page.APP_JointPersonalDetails);
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        UserUtility userUtil = new UserUtility ();
        userUtil.registerPassword = '1234'; 
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.redirectTo = 'Save';
        jointPDExt.applicantWrapper.PostalFlag = 'Yes';
        jointPDExt.applicantWrapper.applicationCountry='NZ';
        jointPDExt.applicantWrapper.NoOfDeps = '2';
        jointPDExt.applicantWrapper.birthMonth = '01';
        jointPDExt.applicantWrapper.birthDate = '01';
        jointPDExt.applicantWrapper.birthYear = '1990';    
        jointPDExt.applicantWrapper.PostalFlag = 'Yes';
        jointPDExt.applicantWrapper.NoOfDeps = '2';
        jointPDExt.applicantWrapper.birthMonth = '01';
        jointPDExt.applicantWrapper.birthDate = '01';
        jointPDExt.applicantWrapper.birthYear = '1990'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Issue_Date__c = Date.today();
        jointPDExt.applicantWrapper.applicant.Expiry_Date__c = Date.today();
        jointPDExt.applicantWrapper.applicant.City_Pos__c='Auckland';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c=null;
        jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c='PO Box';
        jointPDExt.applicantWrapper.disableEmail=false;
        jointPDExt.validateLoanFields();
        PageReference saveApplicant = jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant2.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant2.Name, testApplicant2.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant2.Name);
        
        System.assertEquals(testApplicant2.Id, jointPDExt.applicant2Wrapper.applicant.Id);
    }
    static testMethod void saveApplicantFail_NullFields(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.redirectTo = 'Save';
        jointPDExt.applicantWrapper.applicant.Title__c = 'Select';
        jointPDExt.applicantWrapper.applicant.First_name__c = '';
        jointPDExt.applicantWrapper.applicant.Middle_Name__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Last_Name__c = '';
        jointPDExt.applicantWrapper.applicant.Gender__c = null;
        jointPDExt.applicantWrapper.applicant.Date_of_Birth__c = 'ERR8';
        jointPDExt.applicantWrapper.birthMonth = 'Select';
        jointPDExt.applicantWrapper.applicant.Rel_Status__c = 'Please Select';
        jointPDExt.applicantWrapper.NoOfDeps  = '';
        jointPDExt.applicantWrapper.isStaffUI  = true;
        jointPDExt.applicantWrapper.applicant.Drivers_Lic_Flg__c = false;
        jointPDExt.applicantWrapper.applicant.Drivers_Lic_No__c = null;
        jointPDExt.applicantWrapper.applicant.Res_Status__c  = 'Please Select';
        jointPDExt.applicantWrapper.applicant.Residential_Property_Name__c  = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Unit_No_Res__c  = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Unit_No_Pos__c  = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_No_Res__c  = '123';
        jointPDExt.applicantWrapper.applicant.Street_No_Pos__c  = '123';
        jointPDExt.applicantWrapper.applicant.Street_Pos__c  = 'Sample';
        jointPDExt.applicantWrapper.applicant.Street_Res__c  = 'Sample';
        jointPDExt.applicantWrapper.applicant.City_Pos__c='Sydney';
        jointPDExt.applicantWrapper.applicant.Street_Type_Res__c = 'Street';
        jointPDExt.applicantWrapper.applicant.Street_Type_Pos__c = 'Street';
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c  = 'NSW';
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c  = 'NSW';
        jointPDExt.applicantWrapper.applicant.Postcode_Res__c = '4125';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '4125';
        jointPDExt.applicantWrapper.applicant.Country_Res__c= 'Australia';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c= 'Australia';
        jointPDExt.applicantWrapper.applicant.State_Pos__c='PARRAMATTA';
        jointPDExt.applicantWrapper.applicant.State_Res__c='PARRAMATTA';
        jointPDExt.applicantWrapper.PostalFlag ='Yes';
        jointPDExt.applicantWrapper.applicant.Mobile__c = '';
        jointPDExt.applicantWrapper.applicant.Home__c = '';
        jointPDExt.applicantWrapper.applicant.Work__c = '';
        jointPDExt.applicantWrapper.applicant.Email_Address__c = '';
        jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '123a';
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'ERR1';
        
        jointPDExt.applicant2Wrapper.applicant.First_Name__c  = 'ERR2';
        jointPDExt.applicant2Wrapper.applicant.Last_Name__c = 'a';
        jointPDExt.applicant2Wrapper.applicant.Date_of_Birth__c = 'ERR6';
        jointPDExt.applicant2Wrapper.NoOfDeps = 'a';
        jointPDExt.applicant2Wrapper.applicant.Drivers_Lic_Flg__c = false;
        jointPDExt.applicant2Wrapper.applicant.Drivers_Lic_No__c = 'ERR1';
        jointPDExt.applicant2Wrapper.applicant.Street_No_Res__c  = 'ERR1';
        jointPDExt.applicant2Wrapper.applicant.Street_Res__c  = 'ERR1';
        jointPDExt.applicant2Wrapper.applicant.Postcode_Res__c = '123l';
        jointPDExt.applicant2Wrapper.applicant.Country_Res__c = 'Australia';
        jointPDExt.applicant2Wrapper.applicant.State_Res__c = '';
        jointPDExt.applicant2Wrapper.applicant.Mobile__c = 'ERR4';
        jointPDExt.applicant2Wrapper.applicant.Work__c = 'ERR4';
        jointPDExt.applicant2Wrapper.applicant.Home__c = 'ERR4';
        jointPDExt.applicant2Wrapper.applicant.Email_Address__c = 'ERR5';
        jointPDExt.applicant2Wrapper.applicant.Country_Pos__c  = '';
        
        PageReference saveApplicant = jointPDExt.pageRedirect();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant2.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant2.Name, testApplicant2.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant2.Name);
        Test.StopTest();
        
        System.assertEquals(null, saveApplicant);
    }
    static testMethod void saveApplicantFail_ErrorFields(){
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.redirectTo = 'Save';
        jointPDExt.applicantWrapper.applicant.First_Name__c  = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Middle_Name__c ='ERR1';
        jointPDExt.applicantWrapper.applicant.Last_Name__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Date_of_Birth__c= 'ERR7';
        jointPDExt.applicantWrapper.applicant.Mobile__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Home__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Work__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Email_Address__c = 'ERR1';
        jointPDExt.applicantWrapper.PostalFlag ='No';
        jointPDExt.applicantWrapper.applicant.Unit_No_Pos__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_No_Pos__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_Pos__c  = 'ERR1';
        
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '2';
        jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '2';
        jointPDExt.applicantWrapper.applicant.Unit_No_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '';
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = '';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = '';
        jointPDExt.applicantWrapper.applicant.Street_Type_Pre__c  = '';
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c  = '';
        
        jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = '4';
        jointPDExt.applicant2Wrapper.applicant.Months_At_Addr__c = '4';
        jointPDExt.applicant2Wrapper.applicant.Email_Address__c = 'dummyTest@dummy.com';
        jointPDExt.applicant2Wrapper.applicant.ConfirmEmailAddress__c = 'dummyTest@dummy.com';
        jointPDExt.applicantWrapper.applicant.Street_Pos__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = '1234';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'ERR1';
        PageReference saveApplicant = jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant2.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant2.Name, testApplicant2.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant2.Name);
        System.assertEquals(null, saveApplicant);
    }
    static testMethod void timeout_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Test.setCurrentPage(Page.APP_JointPersonalDetails);
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.redirectTo = 'Timeout';
        jointPDExt.pageRedirect();
        Test.StopTest();
        
        //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
     static testMethod void NewValidationsCountry_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = 'Yes';
        jointPDExt.applicantWrapper.NoOfDeps = '';
         jointPDExt.applicantWrapper.applicationCountry = 'NZ';
        jointPDExt.applicantWrapper.applicant.Street_Res__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = '1234';
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.State_Pos__c = '';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'New Zealand';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = 'ERR1';
        jointPDExt.applicantWrapper.disableEmail  = false;
        jointPDExt.applicantWrapper.applicant.PO_Box__c = false;
        jointPDExt.applicantWrapper.PostalFlag = 'No';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
      //  jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'New Zealand';
        jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = 'PO Box';
         
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    } 
    
    static testMethod void NewValidations_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.applicant.Street_Res__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = '1234';
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.State_Pos__c = '';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = 'ERR1';
        jointPDExt.applicantWrapper.disableEmail  = false;
        jointPDExt.applicantWrapper.applicant.PO_Box__c = false;
        jointPDExt.applicantWrapper.PostalFlag = 'No';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = 'PO Box';
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
    static testMethod void NewValidationsAU_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.isStaffUi =false;
        jointPDExt.applicantWrapper.applicant.Street_Res__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = '1234';
        jointPDExt.applicantWrapper.applicationCountry = 'NZ'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.State_Pos__c = '';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = 'ERR1';
        jointPDExt.applicant2Wrapper.disableEmail  = false;
        jointPDExt.applicant2Wrapper.applicant.PO_Box__c = false;
        jointPDExt.applicant2Wrapper.PostalFlag = 'No';
        jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicant2Wrapper.applicant.Street_Pre__c = 'ERR10';
        jointPDExt.applicant2Wrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicant2Wrapper.applicant.Service_Delivery_Type__c = 'PO Box';
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
    static testMethod void NewValidationsServiceType_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.isStaffUi =false;
        jointPDExt.applicantWrapper.applicant.Street_Res__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = '1234';
        jointPDExt.applicantWrapper.applicationCountry = 'NZ'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'Test';
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.State_Pos__c = '';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = '0';
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR1';
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '123412';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = 'ERR1';
        jointPDExt.applicantWrapper.disableEmail  = false;
        jointPDExt.applicantWrapper.applicant.PO_Box__c = false;
        jointPDExt.applicantWrapper.PostalFlag = 'No';
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR10';
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
        jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = 'Counter Delivery';
        jointPDExt.applicantWrapper.applicant.City_Pos__c=null;
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
    
    static testMethod void saveApplicantSuccessCertifiedDocumentsNZ_Test(){
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        testbrand.Country__c = GEN_OriginationsConstants.NZ_REGION;
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
            User testuser = TestDataBuilder.createUser(profileId);
            testuser.AppId__c = testApplication.Id;
            insert testuser;
            
            List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
            insert adminSettingsList;        
            
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;
            
            RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
            
            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
            insert testONR;
            
            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            insert testLoanPurpose;
            
            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant;
            
            PageReference testSaveApplicant = new PageReference('/apex/app_applicationmain_int?id=' + testApplication.Id);
            
            Test.startTest();
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.applicantWrapper.PostalFlag = 'Yes';
            jointPDExt.applicantWrapper.errorServiceId=true;
            jointPDExt.applicantWrapper.NoOfDeps = '2';
            jointPDExt.applicantWrapper.applicant.Date_Of_Birth__c = '01/01/1990';
            jointPDExt.applicantWrapper.birthMonth = '01';
            jointPDExt.applicantWrapper.birthDate = '01';
            jointPDExt.applicantWrapper.birthYear = '1990';
            jointPDExt.applicantWrapper.applicant.Title__c = 'Mr';
            jointPDExt.applicantWrapper.applicant.First_name__c = 'Test';
            jointPDExt.applicantWrapper.applicant.Last_Name__c = 'Test';
            jointPDExt.applicantWrapper.applicant.Gender__c = 'Male';
            jointPDExt.applicantWrapper.applicant.Rel_Status__c = 'Single';
            jointPDExt.applicantWrapper.NoOfDeps  = '0';
            jointPDExt.applicantWrapper.applicant.Mobile__c  = '0212341234';
            jointPDExt.applicantWrapper.applicant.Email_Address__c = 'test@mail.com';
            jointPDExt.applicantWrapper.applicant.Street_No_Res__c  = '1';
            jointPDExt.applicantWrapper.applicant.Street_Res__c  = 'Street';
            jointPDExt.applicantWrapper.applicant.Street_Type_Res__c = 'Avenue';
            jointPDExt.applicantWrapper.applicant.City_Res__c = 'Town';
            jointPDExt.applicantWrapper.applicant.Postcode_Res__c = '1000';
            jointPDExt.applicantWrapper.applicant.Country_Res__c= 'New Zealand';
            jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '0';
            jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '3';
            jointPDExt.applicantWrapper.errorServiceId=true;
            jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = 'Community Mail Box';
            jointPDExt.applicantWrapper.applicant.Street_No_Pos__c  = '1';
            jointPDExt.applicantWrapper.applicant.Street_Pos__c  = 'Street';
            jointPDExt.applicantWrapper.applicant.Street_Type_Pos__c = 'Avenue';
            jointPDExt.applicantWrapper.applicant.City_Pos__c = 'Town';
            jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
            jointPDExt.applicantWrapper.applicant.Country_Pos__c= 'New Zealand';
            
            jointPDExt.redirectTo = 'Save';
            jointPDExt.applicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_CERTIFIED_DOCUMENTS_REQUIRED;
            jointPDExt.applicant.ID_Number__c = '123456789012345';
            
            
            Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
            Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
            Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
            Test.StopTest();
        }
    }
    
     static testMethod void NewValidationsCheck_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.isStaffUi =false;
        jointPDExt.applicantWrapper.applicant.Street_Res__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = null;
        jointPDExt.applicantWrapper.applicationCountry = 'NZ'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.State_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = null;
        jointPDExt.applicantWrapper.disableEmail  = false;
        jointPDExt.applicantWrapper.applicant.PO_Box__c = false;
        jointPDExt.applicantWrapper.PostalFlag = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = null;
        jointPDExt.applicantWrapper.applicant.City_Pos__c=null;
         jointPDExt.applicantWrapper.applicant.Customer_ID_Type__c='Driving License';
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
       static testMethod void NewValidationsCheckAU_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
            
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;
           boolean flag = true;
           User siteUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1];
        System.runAs(siteUser) {
            System.debug('!@#testSite: ' + site.getName());
        }
        
        Test.startTest();
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.isStaffUi =false;
        jointPDExt.applicantWrapper.applicant.Street_Res__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = null;
        jointPDExt.applicantWrapper.applicationCountry = 'AU'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.State_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'australia';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = null;
         jointPDExt.applicantWrapper.applicant.Customer_ID_Type__c='Driving License';   
            jointPDExt.applicant2Wrapper.expiryDate=null;
           
        jointPDExt.applicant2Wrapper.disableEmail  = false;
        jointPDExt.applicant2Wrapper.applicant.PO_Box__c = false;
        jointPDExt.applicant2Wrapper.PostalFlag = null;
        jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicant2Wrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicant2Wrapper.applicant.Country_Pre__c = null;
        jointPDExt.applicant2Wrapper.applicant.Service_Delivery_Type__c = null;
        jointPDExt.applicant2Wrapper.applicant.City_Pos__c=null;
         jointPDExt.applicant2Wrapper.applicant.Customer_ID_Type__c='Driving License';
           
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        Test.StopTest();
        Boolean checkCity = personalDetailsWrapper.validateCity(testApplicant.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(testApplicant.Name, testApplicant.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(testApplicant.Name);
        
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }
    
}