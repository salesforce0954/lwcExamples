/**
 * @Description: Quote Helper class that is used to construct web service data from standard and custom sfdc objects
 * @Author: Madhusudhan Seethala
 * @Date Created: MAR-25-2020
 * @History:
   =====================================================================
    
   =====================================================================
 */ 
public class WS_QuoteWebServiceHelper { 


     /* Description: Method that maps values into ApplicationCustomerDataType WSobject
    *  Input Parameters: sfApplicationId -
                         applicants -
                         product -
                         loanDetails -
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType 
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType generateQuoteCustomerDataType(Quote__c quote) { 
        
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType applicationCustomerDataType = new ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType();
        ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType thirdParty = new ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType();
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicantInfo = new ConsumerAnzCapitalGeComOriginations.ApplicantCollection();
        applicationCustomerDataType.sfApplicationId = quote.Id;
        //Setting the Application Stage as "S" for AU and NZ soft quotes 
        applicationCustomerDataType.applicationStage = 'S';  
       
        if(quote.UID__c!=null) {
            applicationCustomerDataType.applicationId = quote.UID__c;
        }
        applicantTypeList.add(generateQuoteApplicantType(quote));
        applicationCustomerDataType.applicants = generateApplicantCollection(applicantTypeList); 
        applicationCustomerDataType.product = generateQuoteProductDetailsType(quote.Residential_Country__c, quote.Product__c);
        applicationCustomerDataType.loanDetails = generateLoanDetailsType(quote);
        applicationCustomerDataType.higherApprovalConsent = false;
        applicationCustomerDataType.initialRequestedAmount = 0.00;
        applicationCustomerDataType.totalAssets = 0; 
        applicationCustomerDataType.totalNetDebtAmount = 0; 
        applicationCustomerDataType.thirdPartyDetailsData = thirdParty; 
         system.debug('Broker id'+quote.Broker_ID__c);
        if( quote.Channel__c== 'Broker' && (quote.Broker_ID__c != null || quote.Broker_ID__c !='') ){
            applicationCustomerDataType.brokerDetails = generateBrokerDetailsType(quote.Broker_ID__c);
           
        }
        return applicationCustomerDataType;
        
    }
  
    /**  Author: Manoj kumar    
    *  Date Created: 04-Sep-2020
    *   Description: Method that maps values into ApplicationCustomerDataType WSobject
    *  Input Parameters: sfApplicationId -applicationId - initialInterestRate
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType 
    */
    public static ConsumerAnzCapitalGeComOriginations.applicationPartialCustomerDataType generateQuoteCustomerDataTypes(Quote__c quote) { 
        
        ConsumerAnzCapitalGeComOriginations.applicationPartialCustomerDataType applicationPartialCustomerDataType = new ConsumerAnzCapitalGeComOriginations.applicationPartialCustomerDataType();
        ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType thirdParty = new ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType();
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicantInfo = new ConsumerAnzCapitalGeComOriginations.ApplicantCollection();
        applicationPartialCustomerDataType.sfApplicationId = quote.Id;
        //applicationCustomerDataType.applicationStage = 'Q';  
       
        if(quote.UID__c!=null) {
            applicationPartialCustomerDataType.applicationId = quote.UID__c;
        }
        if(quote.Quote_Rate__c !=null) {
            applicationPartialCustomerDataType.initialInterestRate = quote.Quote_Rate__c;
        }
        return applicationPartialCustomerDataType;
        
    }

    /* Description: Method that maps values into QuoteType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Quote__c Object
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicantType
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicantType generateQuoteApplicantType(Quote__c quote) { 
        
        ConsumerAnzCapitalGeComOriginations.ApplicantType quoteType = new ConsumerAnzCapitalGeComOriginations.ApplicantType();
        quoteType.sfApplicantId = quote.Id;
        quoteType.personalDetails = generatePersonalDetailsType(quote);
        quoteType.budgetDetails = generateBudgetDetailsType(quote);
        quoteType.type_x = GEN_OriginationsConstants.APPLICANT_TYPE_PRIMARY;
        return quoteType;
        
    } 
    /* Description: Method that maps values into personalDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Applicant
    *  Return: ConsumerAnzCapitalGeComOriginations.TimeAtAddressType
    */
    public static ConsumerAnzCapitalGeComOriginations.PersonalDetailsType generatePersonalDetailsType(Quote__c quote) {
        
        ConsumerAnzCapitalGeComOriginations.PersonalDetailsType personalDetailsType = new ConsumerAnzCapitalGeComOriginations.PersonalDetailsType();
        personalDetailsType.title = quote.Title_Code__c;
        personalDetailsType.firstName = formatData(quote.First_Name__c);
        personalDetailsType.middleName = formatData(quote.Middle_Name__c);
        personalDetailsType.lastName = formatData(quote.Last_Name__c);        
        personalDetailsType.dateOfBirth = formatDate(quote.Date_of_Birth__c);
        personalDetailsType.gender = quote.Gender_Code__c;
        personalDetailsType.relationshipStatus = 'S';
        personalDetailsType.numberOfDependents = 0;
        if (quote.Driver_s_Licence_Number__c != '' || quote.Driver_s_Licence_Number__c != null  ){
            personalDetailsType.driverLicenseNumber = quote.Driver_s_Licence_Number__c; 
            personalDetailsType.isDriverLicense = true; 
        }else {
             personalDetailsType.isDriverLicense = false; 
        }
        
        
        if(quote.Residential_Country__c == 'New Zealand'){
            personalDetailsType.residentialAddress = generateAddress(quote.Property_Name__c,
                                                                 quote.Residential_Unit_Number__c, 
                                                                 quote.Residential_Street_Number__c, 
                                                                 quote.Residential_Street_Name__c, 
                                                                 quote.Residential_Street_Type__c, 
                                                                 quote.Residential_Suburb__c, 
                                                                 quote.Residential_Postcode__c,
                                                                 quote.Residential_State__c,
                                                                 quote.Residential_Country__c,
                                                                 quote.Residential_City__c,
                                                                 '', ''
                                                                 );                                                                  
                                                           
        }else{
             personalDetailsType.residentialAddress = generateAddress('',
                                                                 quote.Residential_Unit_Number__c, 
                                                                 quote.Residential_Street_Number__c, 
                                                                 quote.Residential_Street_Name__c, 
                                                                 quote.Residential_Street_Type_Code__c, 
                                                                 quote.Residential_Suburb__c, 
                                                                 quote.Residential_Postcode__c,
                                                                 quote.Residential_State__c,
                                                                 quote.Residential_Country__c,
                                                                 quote.Residential_City__c,
                                                                 '', ''
                                                                 );             
                                                                  
        }
        
      
        personalDetailsType.postalAddressSameAsResidential = true; 
        
        Integer yearsAtAddr = 0;
        Integer monthsAtAddr = 0;
        Integer yearsAtPrevAddr = 0;
        Integer monthsAtPrevAddr = 0;
        
        if(quote.Years_at_Residential_Address__c!=null) {
            yearsAtAddr = Integer.valueOf(quote.Years_at_Residential_Address__c);
        }
        if(quote.Months_at_Residential_Address__c!=null ) {
            monthsAtAddr = Integer.valueOf(quote.Months_at_Residential_Address__c);
        }
                
        personalDetailsType.timeAtCurrentAddress = generateTimeAtAddressType(yearsAtAddr, monthsAtAddr); 
        personalDetailsType.timeAtPreviousAddress = generateTimeAtAddressType(yearsAtPrevAddr, monthsAtPrevAddr); 
        
        personalDetailsType.residentialStatus= quote.Residential_Status_Code__c;

        personalDetailsType.mobileNumber = quote.Mobile_Number__c; 
        personalDetailsType.emailAddress = quote.Email_ID__c; 
        if(yearsAtAddr <= 3){
          if(quote.Previous_Country__c == 'New Zealand'){
            personalDetailsType.previousResidentialAddress = generateAddress(quote.Previous_Property_Name__c,
                                                                           quote.Previous_Unit_Number__c, 
                                                                           quote.Previous_Street_Number__c, 
                                                                           quote.Previous_Street_Name__c, 
                                                                           quote.Previous_Street_Type__c,
                                                                           quote.Previous_Suburb__c, 
                                                                           quote.Previous_Postcode__c,
                                                                           quote.Previous_State__c,
                                                                           quote.Previous_Country__c,
                                                                           quote.Previous_City__c,
                                                                           '',
                                                                           '');
          }else{
          //Added the Street Type code mapping
            personalDetailsType.previousResidentialAddress = generateAddress('',
                                                                           quote.Previous_Unit_Number__c, 
                                                                           quote.Previous_Street_Number__c, 
                                                                           quote.Previous_Street_Name__c, 
                                                                           quote.Previous_Street_Type_Code__c,
                                                                           quote.Previous_Suburb__c, 
                                                                           quote.Previous_Postcode__c,
                                                                           quote.Previous_State__c,
                                                                           quote.Previous_Country__c,
                                                                           quote.Previous_City__c,
                                                                           '',
                                                                           '');
          }
        }
        /*personalDetailsType.isTermAndCondition = false;
        personalDetailsType.eidvConsent = false;
        personalDetailsType.solicitFlag = false;*/
        personalDetailsType.insuranceEmailsAck = false;
        return personalDetailsType;
    }
    
    
    public static ConsumerAnzCapitalGeComOriginations.BudgetDetailsType generateBudgetDetailsType(Quote__c quote) {
       
        Decimal dbudgetVal = 0.00;
        Integer ibudgetVal = 0;
        ConsumerAnzCapitalGeComOriginations.BudgetDetailsType budgetDetails = new ConsumerAnzCapitalGeComOriginations.BudgetDetailsType();
        budgetDetails.incomeDetails = generateIncomeDetails();
        budgetDetails.totalIncome = dbudgetVal;
        budgetDetails.totalExpenses = dbudgetVal;
        budgetDetails.totalAdditionalIncome = ibudgetVal;

        Integer previousEmploymentYears = 0;
        Integer previousEmploymentMonths = 0;
       
        Decimal incomeSource = 0;
        Integer currentEmploymentYears = 0;
        Integer currentEmploymentMonths = 0;
                    
                    if(quote.Years_at_Current_Employment__c!=null) {
                        currentEmploymentYears = Integer.valueOf(quote.Years_at_Current_Employment__c);
                    }
                    if(quote.Months_at_Current_Employment__c!=null) {
                        currentEmploymentMonths = Integer.valueOf(quote.Months_at_Current_Employment__c);
                    }
                    
                    budgetDetails.timeWithCurrentEmployer = generateTimeWithEmployerType(currentEmploymentYears,currentEmploymentMonths);
                    budgetDetails.occupation = quote.Occupation_Code__c;

                  /* ConsumerAnzCapitalGeComOriginations.employerContactPhoneType ecpt = new ConsumerAnzCapitalGeComOriginations.employerContactPhoneType();
                    ecpt.areaCode = '02'; 
                    ecpt.phoneNumber = '44444444'; 
                    budgetDetails.employerContactPhone = ecpt;*/

        return budgetDetails;
    }
    /* Description: Method that maps values into IncomeDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: incomeList - 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.IncomeDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.IncomeDetails> generateIncomeDetails() {
         
        List<ConsumerAnzCapitalGeComOriginations.IncomeDetails> incomeDetailsList = new List<ConsumerAnzCapitalGeComOriginations.IncomeDetails>();
        ConsumerAnzCapitalGeComOriginations.IncomeDetails incomeDetail = new ConsumerAnzCapitalGeComOriginations.IncomeDetails();
        Decimal dIncomeVal = 0.00;
        incomeDetail.incomeType = 'FT';
        incomeDetail.incomeAmount = dIncomeVal;
        incomeDetail.incomeInterval = 'M';
        incomeDetailsList.add(incomeDetail);
        return incomeDetailsList;
    }
    
     /* Description: Method that maps values into ProductDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: orgId -
                         logoId - 
                         productName - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ProductDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.ProductDetailsType generateQuoteProductDetailsType(String Country,String nzBrand) { 
        
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetailsType = new ConsumerAnzCapitalGeComOriginations.ProductDetailsType();
        String sOrgAUValue= '200';
        String sOrgKIWIValue= '599';
        String sOrgGEMValue= '600';     
        String slogIDAUValue= '226';
        String slogIDNZValue= '236';
        String sAUProductValue= 'Unsecured Latitude PL';
        String sNZGEMProductValue= 'Unsecured GEM PL';
        String sNZKIWIProductValue= 'Unsecured Kiwibank PL';
       
        if(Country == 'Australia') {
            productDetailsType.orgId = sOrgAUValue;
            productDetailsType.logoId = slogIDAUValue;
            productDetailsType.productName= sAUProductValue;
        
        } else if(Country == 'New Zealand' && nzBrand =='Kiwibank'){
            productDetailsType.orgId = sOrgKIWIValue;   
            productDetailsType.logoId = slogIDNZValue;
            productDetailsType.productName= sNZKIWIProductValue;
        } else {
            productDetailsType.orgId = sOrgGEMValue;
            productDetailsType.logoId = slogIDNZValue;
            productDetailsType.productName= sNZGEMProductValue;
        }
        
        return productDetailsType;
        
    }
    
    /* Description: Method that maps values into LoanDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Quote Object
    *  Return: ConsumerAnzCapitalGeComOriginations.LoanDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType(Quote__c quote) { 
        
        ConsumerAnzCapitalGeComOriginations.LoanDetailsType loanDetailsType = new ConsumerAnzCapitalGeComOriginations.LoanDetailsType();
        
        loanDetailsType.totalLoanAmount = roundOffAmount(quote.Loan_Amount__c);
       
        loanDetailsType.loanInsuranceConsent = false;
        if(quote.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES){ 
            loanDetailsType.solicitationCode = Web_Service_Settings__c.getValues('SOLCode Sales').value__c;
        }
        else if(quote.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){ 
            loanDetailsType.solicitationCode = Web_Service_Settings__c.getValues('SOLCode Broker').value__c;
        }
        else {
            loanDetailsType.solicitationCode = Web_Service_Settings__c.getValues('SOLCode Customer').value__c;
        }
       
        loanDetailsType.OfferOptin = false;
        //loanDetailsType.CrossSellEligibilityAck = false;
        loanDetailsType.loanPurposes = generateLoanPurposeDetails(quote);
        loanDetailsType.securedLoanFlag = false;
        if(quote.Loan_Term_Months__c!=null) {
            loanDetailsType.loanTerm = Integer.valueOf(quote.Loan_Term_Months__c);
        }
       
        loanDetailsType.totalLoanInterestAmtPayable  = 0;
        loanDetailsType.totalInsuranceInterestAmtPayable = 0;
        loanDetailsType.initialInterestRate = 0.00;
        
        loanDetailsType.finalInterestRate = 0.00; 
        
        return loanDetailsType;
    }
    /* Description: Method that maps values into LoanPurposeDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 01-20-14
    *  Input Parameters: 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails> generateLoanPurposeDetails(Quote__c quote) { 
        
        List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails> loanPurposeDetails = new List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails>();
        ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails loanPurposeDetail = new ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails();
        loanPurposeDetail.loanPurposeAmount = roundOffAmount(quote.Loan_Amount__c);
        loanPurposeDetail.loanPurpose = quote.Loan_Purpose_Code__c;
        loanPurposeDetail.loanPurposeOther = quote.Other_Loan_Purpose__c;
        loanPurposeDetails.add(loanPurposeDetail);
        
        return loanPurposeDetails;
        
    }   

    
    /* Description: Method that maps values into ConsumerAnzCapitalGeComOriginations.BranchDetailsType WSobject
    *  Input Parameters: 
    *  Return: ConsumerAnzCapitalGeComOriginations.BranchDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.BranchDetailsType generateBranchDetailsType(Quote__c quote) {  // May-09-2016 - Afreen updated the signature to include the application channel
        
        ConsumerAnzCapitalGeComOriginations.BranchDetailsType branchDetailsType = new ConsumerAnzCapitalGeComOriginations.BranchDetailsType();
           
            branchDetailsType.branchNumber = GEN_OriginationsConstants.CUSTOMER_BRANCH_NUMBER;
            if(quote.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES && quote.ownerId!=null) {
                if(Util.isIdTypeOfObject(quote.ownerId, User.sObjectType)) {
                   User user = new User(); 
                   user= [SELECT Name,SSO_Number__c
                            FROM   User
                            WHERE  Id =: quote.ownerId];
                  branchDetailsType.salesStaffId = user.SSO_Number__c;
                  branchDetailsType.salesStaffName = user.Name;
                }
            
                
            }
            else if(quote.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){ 
            
                branchDetailsType.salesStaffId = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_ID;
                branchDetailsType.salesStaffName = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_NAME;
            }
            else{
                branchDetailsType.salesStaffId = GEN_OriginationsConstants.CUSTOMER_STAFF_ID;
                branchDetailsType.salesStaffName = GEN_OriginationsConstants.CUSTOMER_STAFF_NAME;
        }

        return branchDetailsType;
        
    }
    /* Description: Method that maps values into BrokerDetailsType
    *  Author: Dan Crisologo
    *  Date Created: 12-17-13
    *  Input Parameters: Contact broker
    *  Return: ConsumerAnzCapitalGeComOriginations.BrokerDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.BrokerDetailsType generateBrokerDetailsType(String qBrokerId) {
                                                                                                  
        ConsumerAnzCapitalGeComOriginations.BrokerDetailsType brokerDetails = new ConsumerAnzCapitalGeComOriginations.BrokerDetailsType();
        Id brokerRecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(GEN_OriginationsConstants.BROKER_RECORD_TYPE_APAC).RecordTypeId;
         
         List<Contact> brokerList = [Select Id, Name, Broker_ID__c, Contact_Accreditation_Status__c,Phone,
                                     firstname, lastname  From Contact Where Broker_ID__c = :qBrokerId
                                    and Contact_Accreditation_Status__c = : GEN_OriginationsConstants.ELIGIBITIY_BROKER_STATUS_ACTIVE 
                                    and (Broker_Product__c Like '%PL%' OR Broker_Product__c Like '%Motor Solutions%'  ) 
                                    and recordTypeId = :brokerRecordTypeId Limit 1];  
        if(brokerList.size() >0 && brokerList[0].Id != null ){
           brokerDetails.sfBrokerId = formatData(brokerList[0].Broker_ID__c, true);
           brokerDetails.firstName = formatData(brokerList[0].firstname, true);
           brokerDetails.lastName = formatData(brokerList[0].lastname, true);
           brokerDetails.landlineNumber = brokerList[0].Phone;
           brokerDetails.accreditationStatus = brokerList[0].Contact_Accreditation_Status__c;
        }
        
            
        return brokerDetails;
    }
    
    /* Description: Method that maps values into TimeWithEmployerType WSobject
     *  Input Parameters: years - 
                         months - 
    *  Return: ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType
    */
    public static ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType generateTimeWithEmployerType(Integer years, Integer months) {
        
        ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType timeWithEmployerType = new ConsumerAnzCapitalGeComOriginations.TimeWithEmployerType();
        timeWithEmployerType.years = years;
        timeWithEmployerType.months = months;
        
        return timeWithEmployerType;
    }
    
     /* Description: Method that maps values into TimeAtAddressType WSobject
     *  Input Parameters: years - 
                         months - 
    *  Return: ConsumerAnzCapitalGeComOriginations.TimeAtAddressType
    */
    public static ConsumerAnzCapitalGeComOriginations.TimeAtAddressType generateTimeAtAddressType(Integer years, Integer months) {
        
        ConsumerAnzCapitalGeComOriginations.TimeAtAddressType timeAtAddressType = new ConsumerAnzCapitalGeComOriginations.TimeAtAddressType();
        timeAtAddressType.years = years;
        timeAtAddressType.months = months;
        
        return timeAtAddressType;
    }
    /* Description: Method that maps values into Address WSobject
    *  Return: ConsumerAnzCapitalGeComOriginations.Address
    */
    public static ConsumerAnzCapitalGeComOriginations.Address generateAddress(String propertyName, String unitNumber, String houseNumber,
                                                                              String streetName, String streetType,
                                                                              String suburb, String postcode,
                                                                              String state, String country, String city,
                                                                              String servicetype, String serviceid) {

        ConsumerAnzCapitalGeComOriginations.Address address = new ConsumerAnzCapitalGeComOriginations.Address();
        address.PropertyName = propertyName;
        address.UnitNumber = formatData(unitNumber, true);
        address.HouseNumber = formatData(houseNumber, true);
        address.StreetName = streetName;
       if(country!= null && country!='' && streetType!= null && streetType!= ''
           && country.equalsIgnoreCase(GEN_OriginationsConstants.AML_COUNTRY_AU)){
           
              address.StreetType = formatData(streetType, true);
              address.City = formatData(suburb, true);
        }
        if(country!= null && country!='' && streetType!= null && streetType!= ''
           && country.equalsIgnoreCase(GEN_OriginationsConstants.AML_COUNTRY_NZ)){
        
          address.StreetType = formatData(SoftQuoteUtil.checkStreetType(streetType,GEN_OriginationsConstants.NZ_REGION), true);
          address.City = formatData(city, true);
          address.Suburb = formatData(suburb, true);
        }
       
        address.Postcode = formatData(postcode, true);
        address.State = formatData(state, true);
        address.Country = formatData(country, true);
        address.serviceDeliveryType = formatData(servicetype, true);
        address.serviceDeliveryID = formatData(serviceid, true);
        return address;
    }
    
       /* Description: Method that maps values into ApplicantCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: applicantTypeList -
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicantCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicantCollection generateApplicantCollection(List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList) { 
        
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicantCollection = new ConsumerAnzCapitalGeComOriginations.ApplicantCollection();                                          
        applicantCollection.applicant = applicantTypeList;
        return applicantCollection;
        
    }
    
    public static ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType generatequoteSupportingDataType(Quote__c quote){
    
        ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType quoteSupportData = new ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType();
        consumerAnzCapitalGeComOriginations.fingerPrintDetailsType fingerPrint = new consumerAnzCapitalGeComOriginations.fingerPrintDetailsType();
        caseModelServicingGeCom20.Case_x prodArrangement = new caseModelServicingGeCom20.Case_x();
        
        quoteSupportData.fingerPrintDetails = fingerPrint;
        quoteSupportData.productArrangementToCaseInput = prodArrangement;
        if(quote.Channel__c != null && quote.Channel__c == 'Sales'){
            quoteSupportData.acceptanceChannel = GEN_OriginationsConstants.ACCEPTANCE_CHANNEL_OFFLINE;
        }else{
            quoteSupportData.acceptanceChannel = GEN_OriginationsConstants.ACCEPTANCE_CHANNEL_ONLINE;
        }
        quoteSupportData.branchDetails = generateBranchDetailsType(quote);
        return quoteSupportData;
    }
    
     public static consumerAnzCapitalGeComOriginations.amlApplicantsCollection generatAmlApplicantCollection(Quote__c quote){
    
        consumerAnzCapitalGeComOriginations.amlApplicantsCollection quoteAmlApplicantData = new consumerAnzCapitalGeComOriginations.amlApplicantsCollection ();
         List<consumerAnzCapitalGeComOriginations.amlApplicantType> amlData= new List<consumerAnzCapitalGeComOriginations.amlApplicantType>();
         consumerAnzCapitalGeComOriginations.amlApplicantType quoteAmlApplicant = new consumerAnzCapitalGeComOriginations.amlApplicantType();
         consumerAnzCapitalGeComOriginations.IdDetail quoteIdDetail= new consumerAnzCapitalGeComOriginations.IdDetail();
         List<consumerAnzCapitalGeComOriginations.IdDetail> quoteIdDetailList= new List<consumerAnzCapitalGeComOriginations.IdDetail>();
         
         quoteIdDetail.identificationType = 'A';
         quoteIdDetail.amlVerifiedFlag = false;
         if (quote.Driver_s_Licence_Number__c != null){
             quoteIdDetail.iDNo = quote.Driver_s_Licence_Number__c;
         }
         if (quote.Driver_s_License_Issue_Date__c != null){
             quoteIdDetail.issueDate =formatDateWS(quote.Driver_s_License_Issue_Date__c);
         }
         if (quote.Driver_s_License_Expiry_Date__c != null){
             quoteIdDetail.expiryDate =formatDateWS(quote.Driver_s_License_Expiry_Date__c);
         }
         if (quote.Driver_s_License_Version__c != null){
             quoteIdDetail.version =quote.Driver_s_License_Version__c;
         }
         if (quote.Residential_Country__c != null){
             quoteIdDetail.issueCountry =quote.Residential_Country__c;
         }
         
         quoteIdDetailList.add(quoteIdDetail);
         quoteAmlApplicant.sfApplicantId =quote.Id;
         quoteAmlApplicant.dateVerified =date.today();    
         quoteAmlApplicant.Identifications= quoteIdDetailList;
         amlData.add(quoteAmlApplicant);
         quoteAmlApplicantData.applicant= amlData;     
        return quoteAmlApplicantData;
    }
       
    /* Description: Formats String data into Webservice request format
     *  Input Parameters: inputString
    *  Return: String
    */
    public static String formatData(String inputString) {      
                                                                         
        return inputString;  
    }
    
     public static String formatData(String inputString, Boolean mustBePresent) {   
        if(mustBePresent && inputString==null) {
            return '';
        } else {
            return formatData(inputString);
        }
    }
    
     /* Description: Checks for null value decimal and rounds off amount to 2 decimal place
      *  Input Parameters: inputNumber
    *  Return: Decimal - rounded decimal
    */
    public static Decimal roundOffAmount(Decimal inputNumber) {      
    
        if(inputNumber!=null) {
            return inputNumber.setScale(2);
        }
                                                                                  
        return 0; 
    }
    public static String formatDate(String inputDate){
        string finalConDate = '';
          if(inputDate!=null){
            List<string> splitVal = inputDate.split('/',3);
            finalConDate = splitVal[2] + '-' + splitVal[1] + '-' + splitVal[0];
        }
        return finalConDate;

    }
    public static Date formatDateWS(String inputDate){
        Date finalConDate = null;
        
        if(inputDate!=null){
            List<string> splitVal = inputDate.split('/',3);
        
            finalConDate = Date.newinstance (Util.stringToInteger(splitVal[2]),
                Util.stringToInteger(splitVal[1]),
                Util.stringToInteger(splitVal[0]));
            system.debug('Converted Date:' + finalConDate);
        }
        return finalConDate;

    }
}