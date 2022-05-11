/**
 * @Description: Helper class that is used to construct web service data from standard and custom sfdc objects
 * @Author: Dan Crisologo
 * @Date Created: OCT-09-2013
 * @History:
   =====================================================================
       10-09-13: Created. - Dan
       11-07-14: Updated - DBHZL30 update generateAddress method to handle fields for new zealand addresses
       12-02-14: Updated - DBHZL64  Added new fields  -  Tony Xu
       12-16-14: Updated - DBHZL92  Added new bank detail fields  -  Tony Xu
       2015-03-02 Updated - DBHZL386 Retrieve Payout Figure - Tony Xu
       2015-06-17 Updated - Returned back doc gen population of service delivery and Id for postal and residential address - Adrian
       2015-08-12 PMIHM-1307 Returned back risk referral workflow decision and apporver's SSO - Tony xu
       2015-11-16 Rebranding - Added monthly repayment to LPI - Tony Xu
     2016-06-17 Green Id AML Function - Adrian Recio
   =====================================================================
 */ 
public class WS_WebServiceHelper { 

    private static Id refinanceDisbursement = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_RECORD_REFINANCE).getRecordTypeId();

    /* Description: Method that maps mainBusinessUnit and subBusinessUnit into business context ws object
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: mainBusinessUnit - assigned main business unit
                         subBusinessUnit - assigned sub business unit
    *  Return: ConsumerAnzCapitalGeComOriginations.BusinessContext
    */
    public static ConsumerAnzCapitalGeComOriginations.BusinessContext generateBusinessContext(String mainBusinessUnit, String subBusinessUnit) {
        
        ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = new ConsumerAnzCapitalGeComOriginations.BusinessContext();
        businessContext.mainBusinessUnit = mainBusinessUnit;
        businessContext.subBusinessUnit = subBusinessUnit;
        
        return businessContext;
    }
    
    /* Description: Method that maps mainBusinessUnit and subBusinessUnit into business context ws object
    *  Author: Tony Xu
    *  Date Created: 2015-03-02
    *  Input Parameters: mainBusinessUnit - assigned main business unit
                         subBusinessUnit - assigned sub business unit
    *  Return: PayoffQuoteAnzCapitalGeCom.BusinessContext
    */
    public static PayoffQuoteAnzCapitalGeCom.BusinessContext generatePayoffQuoteBusinessContext(String mainBusinessUnit, String subBusinessUnit) {
        
        PayoffQuoteAnzCapitalGeCom.BusinessContext businessContext = new PayoffQuoteAnzCapitalGeCom.BusinessContext();
        businessContext.mainBusinessUnit = mainBusinessUnit;
        businessContext.subBusinessUnit = subBusinessUnit;
        
        return businessContext;
    }
    
    /* Description: Method that maps values into ConsumerContext context ws object
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: requestedBy - 
                         requestedName - 
                         serviceVersion - 
                         targetService - 
                         businessUnit - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ConsumerContext
    */
    public static ConsumerAnzCapitalGeComOriginations.ConsumerContext generateConsumerContext(String requestedBy, 
                                                                                              String requestedName,
                                                                                              String serviceVersion,
                                                                                              String targetService,
                                                                                              ConsumerAnzCapitalGeComOriginations.BusinessContext businessUnit) {
        
        ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = new ConsumerAnzCapitalGeComOriginations.ConsumerContext();
        consumerContext.requestedBy = requestedBy;
        consumerContext.requestedName = requestedName;
        consumerContext.serviceVersion = serviceVersion;
        consumerContext.targetService = targetService;
        consumerContext.businessUnit = businessUnit;
        
        return consumerContext;
    }
    
    /* Description: Method that maps values into ConsumerContext context ws object
    *  Author: Tony Xu  
    *  Date Created: 2015-03-02
    *  Input Parameters: requestedBy - 
                         requestedName - 
                         serviceVersion - 
                         targetService - 
                         businessUnit - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ConsumerContext
    */
    public static PayoffQuoteAnzCapitalGeCom.ConsumerContext generatePayoffQuoteConsumerContext(String requestedBy, 
                                                                                              String requestedName,
                                                                                              String serviceVersion,
                                                                                              String targetService,
                                                                                              PayoffQuoteAnzCapitalGeCom.BusinessContext businessUnit) {
        
        PayoffQuoteAnzCapitalGeCom.ConsumerContext consumerContext = new PayoffQuoteAnzCapitalGeCom.ConsumerContext();
        consumerContext.requestedBy = requestedBy;
        consumerContext.requestedName = requestedName;
        consumerContext.serviceVersion = serviceVersion;
        consumerContext.targetService = targetService;
        consumerContext.businessUnit = businessUnit;
        
        return consumerContext;
    }    
    
    /* Description: Method that maps values into Exception_x ws object
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: code - 
                         severity - 
                         occurredTime - 
                         message - 
                         detailedMessage - 
                         message -
    *  Return: ConsumerAnzCapitalGeComOriginations.Exception_x
    */
    public static ConsumerAnzCapitalGeComOriginations.Exception_x generateExceptionX(String code, 
                                                                                     String severity,
                                                                                     DateTime occurredTime,
                                                                                     String message,
                                                                                     String detailedMessage,
                                                                                     String sourceSystem) {
        
        ConsumerAnzCapitalGeComOriginations.Exception_x exceptionX = new ConsumerAnzCapitalGeComOriginations.Exception_x();
        exceptionX.code = code;
        exceptionX.severity = severity;
        exceptionX.occurredTime = occurredTime;
        exceptionX.message = message;
        exceptionX.detailedMessage = detailedMessage;
        exceptionX.sourceSystem = sourceSystem;
        
        return exceptionX;
    }
    
    /* Description: Method that maps values into Exception_x ws object
    *  Author: Tony Xu
    *  Date Created: 2015-03-02
    *  Input Parameters: code - 
                         severity - 
                         occurredTime - 
                         message - 
                         detailedMessage - 
                         message -
    *  Return: PayoffQuoteAnzCapitalGeCom.Exception_x
    */
    public static PayoffQuoteAnzCapitalGeCom.Exception_x generatePayoffQuoteExceptionX(String code, 
                                                                                     String severity,
                                                                                     DateTime occurredTime,
                                                                                     String message,
                                                                                     String detailedMessage,
                                                                                     String sourceSystem) {
        
        PayoffQuoteAnzCapitalGeCom.Exception_x exceptionX = new PayoffQuoteAnzCapitalGeCom.Exception_x();
        exceptionX.code = code;
        exceptionX.severity = severity;
        exceptionX.occurredTime = occurredTime;
        exceptionX.message = message;
        exceptionX.detailedMessage = detailedMessage;
        exceptionX.sourceSystem = sourceSystem;
        
        return exceptionX;
    }
    
    /* Description: Method that maps values into ExceptionCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: exception_x[] - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ExceptionCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.ExceptionCollection generateExceptionCollection(ConsumerAnzCapitalGeComOriginations.Exception_x[] exception_x) {
        
        ConsumerAnzCapitalGeComOriginations.ExceptionCollection exceptionCollection = new ConsumerAnzCapitalGeComOriginations.ExceptionCollection();
        exceptionCollection.exception_x = exception_x;
        
        return exceptionCollection;
    }
    
    /* Description: Method that maps values into ExceptionCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: exception_x[] - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ExceptionCollection
    */
    public static PayoffQuoteAnzCapitalGeCom.ExceptionCollection generatePayoffQuoteExceptionCollection(PayoffQuoteAnzCapitalGeCom.Exception_x[] exception_x) {
        
        PayoffQuoteAnzCapitalGeCom.ExceptionCollection exceptionCollection = new PayoffQuoteAnzCapitalGeCom.ExceptionCollection();
        exceptionCollection.exception_x = exception_x;
        
        return exceptionCollection;
    }
    
    /* Description: Method that maps values into Service Context WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: consumer - 
                         exceptions - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ServiceContext
    */
    public static ConsumerAnzCapitalGeComOriginations.ServiceContext generateServiceContext(ConsumerAnzCapitalGeComOriginations.ConsumerContext consumer,
                                                                                            ConsumerAnzCapitalGeComOriginations.ExceptionCollection exceptions) {
        
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContext = new ConsumerAnzCapitalGeComOriginations.ServiceContext();
        serviceContext.consumer = consumer;
        serviceContext.exceptions = null;
        //serviceContext.exceptions = exceptions;
        
        return serviceContext;
    }
    
    /* Description: Method that maps values into Service Context WSobject
    *  Author: Tony Xu
    *  Date Created: 2015-03-02
    *  Input Parameters: consumer - 
                         exceptions - 
    *  Return: PayoffQuoteAnzCapitalGeCom.ServiceContext
    */
    public static PayoffQuoteAnzCapitalGeCom.ServiceContext generateServiceContext(PayoffQuoteAnzCapitalGeCom.ConsumerContext consumer,
                                                                                            PayoffQuoteAnzCapitalGeCom.ExceptionCollection exceptions) {
        
        PayoffQuoteAnzCapitalGeCom.ServiceContext serviceContext = new PayoffQuoteAnzCapitalGeCom.ServiceContext();
        serviceContext.consumer = consumer;
        serviceContext.exceptions = null;
        //serviceContext.exceptions = exceptions;
        
        return serviceContext;
    }
    
    /* Description: Method that maps values into TimeWithEmployerType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
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
    
    /* Description: Method that maps values into Address WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: years - 
                         months - 
    *  Return: ConsumerAnzCapitalGeComOriginations.Address
    */
    public static ConsumerAnzCapitalGeComOriginations.Address generateAddress(String propertyName, String unitNumber, String houseNumber,
                                                                              String streetName, String streetType,
                                                                              String suburb, String postcode,
                                                                              String state, String country, String city,
                                                                              String servicetype, String serviceid) {

        ConsumerAnzCapitalGeComOriginations.Address address = new ConsumerAnzCapitalGeComOriginations.Address();
        address.PropertyName = formatData(propertyName, true);
        address.UnitNumber = formatData(unitNumber, true);
        address.HouseNumber = formatData(houseNumber, true);
        address.StreetName = streetName;//formatData(streetName);
        address.StreetType = formatData(streetType, true);
        //Updated based on the #defect 102
        if(country!=null && country!='' && country.equalsIgnoreCase(GEN_OriginationsConstants.AML_COUNTRY_NZ)){
          address.City = formatData(city, true);
          address.Suburb = formatData(suburb, true);
        }else{
          address.City = formatData(suburb);
        }
        address.Postcode = formatData(postcode, true);
        address.State = formatData(state, true);
        address.Country = formatData(country, true);
        address.serviceDeliveryType = formatData(servicetype, true);
        address.serviceDeliveryID = formatData(serviceid, true);
        return address;
    }
    
    /* Description: Method that maps values into TimeAtAddressType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
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
    /* Description: Method that maps values into riskReferralDetails WSobject
    *  Author: Neha Desor
    *  Date Created: 24-03-15
    *  Input Parameters: nfl Flag, nflExpiryDate
    *  Return: ConsumerAnzCapitalGeComOriginations.RiskReferralDetailsType
    */    
    public static ConsumerAnzCapitalGeComOriginations.RiskReferralDetailsType generateRiskReferralDetailsType(Boolean nflFlag, Date nflExpiryDate) {
        
        ConsumerAnzCapitalGeComOriginations.RiskReferralDetailsType riskReferralDetailsType = new ConsumerAnzCapitalGeComOriginations.RiskReferralDetailsType();
        riskReferralDetailsType.nflFlag = nflFlag;
        riskReferralDetailsType.nflExpiryDate = nflExpiryDate;

        return riskReferralDetailsType;
    }
    
    /* Description: Method that maps values into personalDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Applicant
    *  Return: ConsumerAnzCapitalGeComOriginations.TimeAtAddressType
    */
    public static ConsumerAnzCapitalGeComOriginations.PersonalDetailsType generatePersonalDetailsType(Applicant__c applicant) {
        
        ConsumerAnzCapitalGeComOriginations.PersonalDetailsType personalDetailsType = new ConsumerAnzCapitalGeComOriginations.PersonalDetailsType();
        personalDetailsType.title = applicant.Title_Code__c;
        personalDetailsType.firstName = formatData(applicant.First_Name__c);
        personalDetailsType.middleName = formatData(applicant.Middle_Name__c);
        personalDetailsType.lastName = formatData(applicant.Last_Name__c);
        personalDetailsType.dateOfBirth = applicant.Date_of_Birth_WS__c;
        personalDetailsType.gender = applicant.Gender_Code__c;
        personalDetailsType.relationshipStatus = applicant.Relationship_Status_Code__c;
        personalDetailsType.numberOfDependents = 0;
        if(applicant.No_of_Deps__c!=null) {
            personalDetailsType.numberOfDependents = Integer.ValueOf(applicant.No_of_Deps__c);
        }
        personalDetailsType.driverLicenseNumber = applicant.Drivers_Lic_No__c; 
        personalDetailsType.isDriverLicense = applicant.Drivers_Lic_Flg__c; 
    
        //2015-06-01 TXU to fix the address not sending correctly issue.
        //The NZ Street type returned by Datatool is same as what we should send to activate, hence instead of sending the 
        //code we are directly sending street type
        if(applicant.Country_Res__c == 'New Zealand'){
            personalDetailsType.residentialAddress = generateAddress(applicant.Residential_Property_Name__c,
                                                                 applicant.Unit_No_Res__c, 
                                                                 applicant.Street_No_Res__c, 
                                                                 applicant.Street_Res__c, 
                                                                 applicant.Street_Type_Res__c, 
                                                                 applicant.Suburb_Res__c, 
                                                                 applicant.Postcode_Res__c,
                                                                 applicant.State_Res__c,
                                                                 applicant.Country_Res__c,
                                                                 applicant.City_Res__c,
                                                                 '', ''
                                                                 );                                                                  
                                                           
        }else{
             personalDetailsType.residentialAddress = generateAddress(applicant.Residential_Property_Name__c,
                                                                 applicant.Unit_No_Res__c, 
                                                                 applicant.Street_No_Res__c, 
                                                                 applicant.Street_Res__c, 
                                                                 applicant.Street_Type_Res_Code__c, 
                                                                 applicant.Suburb_Res__c, 
                                                                 applicant.Postcode_Res__c,
                                                                 applicant.State_Res__c,
                                                                 applicant.Country_Res__c,
                                                                 applicant.City_Res__c,
                                                                 '', ''
                                                                 );             
                                                                  
        }
        
        if(applicant.Country_Pos__c == 'New Zealand'){
             personalDetailsType.postalAddress = generateAddress(applicant.Postal_Property_Name__c,
                                                            applicant.Unit_No_Pos__c, 
                                                            applicant.Street_No_Pos__c, 
                                                            applicant.Street_Pos__c, 
                                                            applicant.Street_Type_Pos__c, 
                                                            applicant.Suburb_Pos__c, 
                                                            applicant.Postcode_Pos__c,
                                                            applicant.State_Pos__c,
                                                            applicant.Country_Pos__c,
                                                            applicant.City_Pos__c,
                                                            applicant.Service_Delivery_Code__c,
                                                            applicant.Service_Delivery_Id__c);     
        }else{
            personalDetailsType.postalAddress = generateAddress(applicant.Postal_Property_Name__c,
                                                            applicant.Unit_No_Pos__c, 
                                                            applicant.Street_No_Pos__c, 
                                                            applicant.Street_Pos__c, 
                                                            applicant.Street_Type_Pos_Code__c, 
                                                            applicant.Suburb_Pos__c, 
                                                            applicant.Postcode_Pos__c,
                                                            applicant.State_Pos__c,
                                                            applicant.Country_Pos__c,
                                                            applicant.City_Pos__c,
                                                            applicant.Service_Delivery_Code__c,
                                                            applicant.Service_Delivery_Id__c);
        }
        
        
       
        
        personalDetailsType.postalAddressSameAsResidential = !applicant.Postal_Addr_Flg__c; 
        
        Integer yearsAtAddr = 0;
        Integer monthsAtAddr = 0;
        Integer yearsAtPrevAddr = 0;
        Integer monthsAtPrevAddr = 0;
        
        if(applicant.Years_At_Addr__c!=null && applicant.Years_At_Addr__c!='') {
            yearsAtAddr = Integer.valueOf(applicant.Years_At_Addr__c);
        }
        if(applicant.Months_At_Addr__c!=null && applicant.Months_At_Addr__c!='') {
            monthsAtAddr = Integer.valueOf(applicant.Months_At_Addr__c);
        }
        if(applicant.Years_At_Prev_Addr__c!=null && applicant.Years_At_Prev_Addr__c!='') {
            yearsAtPrevAddr = Integer.valueOf(applicant.Years_At_Prev_Addr__c);
        }
        if(applicant.Months_At_Prev_Addr__c!=null && applicant.Months_At_Prev_Addr__c!='') {
            monthsAtPrevAddr = Integer.valueOf(applicant.Months_At_Prev_Addr__c);
        }
        
        personalDetailsType.timeAtCurrentAddress = generateTimeAtAddressType(yearsAtAddr, monthsAtAddr); 
        personalDetailsType.timeAtPreviousAddress = generateTimeAtAddressType(yearsAtPrevAddr, monthsAtPrevAddr); 
        
        personalDetailsType.residentialStatus= applicant.Residential_Status_Code__c;

        personalDetailsType.mobileNumber = applicant.Mobile__c; 

        personalDetailsType.homeNumberAreaCode = applicant.Home_Area_Code__c; 
        personalDetailsType.homeNumber = applicant.Home_WS__c; 

        personalDetailsType.workNumberAreaCode = applicant.Work_Area_Code__c; 
        personalDetailsType.workNumber = applicant.Work_WS__c; 

        personalDetailsType.preferredContactMethod = applicant.Pref_Contact_Method_Code__c; 
        personalDetailsType.emailAddress = applicant.Email_Address__c; 
        /**defect #477 Previous address block should not been sent when there is no previous address provided, fixed by Tony Xu**/
        if(yearsAtAddr <= 3){
          if(applicant.Country_Pre__c == 'New Zealand'){
            personalDetailsType.previousResidentialAddress = generateAddress(applicant.Previous_Property_Name__c,
                                                                           applicant.Unit_No_Pre__c, 
                                                                           applicant.Street_No_Pre__c, 
                                                                           applicant.Street_Pre__c, 
                                                                           applicant.Street_Type_Pre__c,
                                                                           applicant.Suburb_Pre__c, 
                                                                           applicant.Postcode_Pre__c,
                                                                           applicant.State_Pre__c,
                                                                           applicant.Country_Pre__c,
                                                                           applicant.City_Pre__c,
                                                                           '',
                                                                           '');
          }else{
            personalDetailsType.previousResidentialAddress = generateAddress(applicant.Previous_Property_Name__c,
                                                                           applicant.Unit_No_Pre__c, 
                                                                           applicant.Street_No_Pre__c, 
                                                                           applicant.Street_Pre__c, 
                                                                           applicant.Street_Type_Pre_Code__c,
                                                                           applicant.Suburb_Pre__c, 
                                                                           applicant.Postcode_Pre__c,
                                                                           applicant.State_Pre__c,
                                                                           applicant.Country_Pre__c,
                                                                           applicant.City_Pre__c,
                                                                           '',
                                                                           '');
          }
        }
        personalDetailsType.isTermAndCondition = applicant.Accept_Terms_and_Conditions__c;
        if(applicant.EIDV__c==GEN_OriginationsConstants.CHOICE_YES) {
            personalDetailsType.eidvConsent = true;
        } else if(applicant.EIDV__c==GEN_OriginationsConstants.CHOICE_NO) {
            personalDetailsType.eidvConsent = false;
        }
        

        
        personalDetailsType.solicitFlag = applicant.solicitflag__c;
        //Added by Suneel
        personalDetailsType.insuranceEmailsAck = applicant.Consent_to_Lpi__c;
        personalDetailsType.existingCustomerId = applicant.ICBS_Customer_Number__c;
        //Added by Suneel POI Automation 27/01/2021
        if(applicant.Country_Res__c  != 'New Zealand'){
        personalDetailsType.electronicPOIConsent = applicant.Agrees_to_Income_Verification__c;
        } 
        return personalDetailsType;
    }
    /* Description: Method that maps values into poiIncomeDetails WSobject
    *  Author: Fahad Akhtar
    *  Date Created: 04-09-14
    *  Input Parameters: incomeList - 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails> generatePOIIncomeDetails(List<Income__c> incomeList) {
        List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails> incomeDetailsList = new List<ConsumerAnzCapitalGeComOriginations.poiIncomeDetails>();
        if(incomeList!=null) {
            if(incomeList.size()>0) {
                for(Income__c income: incomeList) {
                     //for(List<Income_Capacity__c>  incpList : income.Income_Capacities_Calculator__r){
                    ConsumerAnzCapitalGeComOriginations.poiIncomeDetails incomeDetail = new ConsumerAnzCapitalGeComOriginations.poiIncomeDetails();
                    incomeDetail.incomeType = income.Income_Source_Code__c;
                    incomeDetail.incomeAmount = roundOffAmount(income.POI_Amount_Verified__c);                   
                    incomeDetail.incomeInterval = income.Income_Interval_Code__c;  
                    incomeDetail.verificationType = income.Verification_Type_Code__c;
                     //system.debug('size of income capacity$$$'+income.Income_Capacities_Calculator__r.size());
                     system.debug('Verification Type$$$$'+incomeDetail.verificationType);   
                          incomeDetailsList.add(incomeDetail);  
                      //}      
                }
            }
        }
        
        return incomeDetailsList;
    }
    /* Description: Method that maps values into IncomeDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: incomeList - 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.IncomeDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.IncomeDetails> generateIncomeDetails(List<Income__c> incomeList) {
         
        List<ConsumerAnzCapitalGeComOriginations.IncomeDetails> incomeDetailsList = new List<ConsumerAnzCapitalGeComOriginations.IncomeDetails>();
        if(incomeList!=null) {
            if(incomeList.size()>0) {
                for(Income__c income: incomeList) {
                    ConsumerAnzCapitalGeComOriginations.IncomeDetails incomeDetail = new ConsumerAnzCapitalGeComOriginations.IncomeDetails();
                    incomeDetail.incomeType = income.Income_Source_Code__c;
                    //Added by TXU to pass through Government Benefit
          if(income.Income_Source_Code__c == 'GB' && income.Government_Benefit_Type__c != null){
                        incomeDetail.governmentBenefitType = income.Government_Benefit_Type_Code__c;
                    }                    
                    incomeDetail.incomeAmount = roundOffAmount(income.Income_Amount__c);
                    incomeDetail.incomeInterval = income.Income_Interval_Code__c;
                    incomeDetailsList.add(incomeDetail);
                }
            }
        }
        
        return incomeDetailsList;
    }
    
    /* Description: Method that maps values into AssetDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: assetList - 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.AssetDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.AssetDetails> generateAssetDetails(List<Asset__c> assetList) {
        List<ConsumerAnzCapitalGeComOriginations.AssetDetails> assetDetailsList = null;
         if(assetList!=null) {
            if(assetList.size()>0) {
              assetDetailsList = new List<ConsumerAnzCapitalGeComOriginations.AssetDetails>();
       
                for(Asset__c asset: assetList) {
                    ConsumerAnzCapitalGeComOriginations.AssetDetails assetDetail = new ConsumerAnzCapitalGeComOriginations.AssetDetails();
                    assetDetail.assetCategory = asset.Asset_Category_Code__c;
                    assetDetail.assetValue = asset.Asset_Value__c;
                    assetDetail.vehicleMake = formatData(asset.Vehicle_Make__c);
                    assetDetail.vehicleModel = formatData(asset.Vehicle_Model__c);
                    assetDetail.yearOfManufacture = 0;
                    if(asset.Vehicle_Year__c!=null) {
                        assetDetail.yearOfManufacture = Integer.valueOf(asset.Vehicle_Year__c);
                    }
                    assetDetail.ownershipStatus = asset.Ownership_Status_Code__c;
                    assetDetailsList.add(assetDetail);
                }
            }
        }
        
        return assetDetailsList;
    }
    
    /* Description: Method that maps values into ExpenseDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-28-13
    *  Input Parameters: expenseList - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ExpenseDetails
    */
    public static ConsumerAnzCapitalGeComOriginations.ExpenseDetails generateExpenseDetails(List<Expense__c> expenseList,Applicant__c applnt) {
         
        ConsumerAnzCapitalGeComOriginations.ExpenseDetails expenseDetails = new ConsumerAnzCapitalGeComOriginations.ExpenseDetails();
        //Responsible Lending
        if(applnt.Is_Primary_Applicant__c == true){
        expenseDetails.livingExpenses = generateLivingExpenses(expenseList,applnt);
        expenseDetails.propertyExpenses = generatePropertyExpenses(expenseList,applnt);
        if(applnt.Country_Res__c == 'New Zealand'){
        expenseDetails.balloonPaymentDebtFlag = applnt.is_Lump_Sum_Debt__c;
        expenseDetails.balloonIntentionRepayFlag = false;
        expenseDetails.revolvingMortgageLimit= applnt.Revolving_Credit__c;
        } 
        
        if(expenseList!=null) {
            if(expenseList.size()>0) {
                for(Expense__c expense: expenseList) {
                    //we are only expecting ONE expense from the list
                    expenseDetails.livingExpenseAmount = roundOffAmount(expense.Living_Exp__c);
                    expenseDetails.livingExpenseInterval = expense.Living_Exp_Int_Code__c;
                    expenseDetails.rentPaymentAmount = roundOffAmount(expense.Rent_Board_Pay_Amt__c);
                    expenseDetails.rentPaymentInterval = expense.Rent_Board_Pay_Int_Code__c;
                    expenseDetails.agentOrLandlordName = expense.Agent_Landlord_Name__c;
                    expenseDetails.isSharedLivingExpense = !expense.I_Pay_All_Exp__c;
                    break;
                }
            }
        }
       } 
        return expenseDetails;
    }
    
    //Responsible Lending
    public static List<ConsumerAnzCapitalGeComOriginations.expensesDetailsArray> generateLivingExpenses(List<Expense__c> expenseList,Applicant__c expApplicant){
    
    List<ConsumerAnzCapitalGeComOriginations.expensesDetailsArray> livingExpenseList = new List<ConsumerAnzCapitalGeComOriginations.expensesDetailsArray>();   
     if(expenseList != null) {           
            if(expenseList.size()>0) { 
                      ConsumerAnzCapitalGeComOriginations.expensesDetailsArray livingExpenses = new ConsumerAnzCapitalGeComOriginations.expensesDetailsArray();
                      livingExpenses.expense = generateExpensesDetails(expenseList,expApplicant);
                      livingExpenseList.add(livingExpenses);
            }
     }
    return livingExpenseList;
    }
    
    public static List<consumerAnzCapitalGeComOriginations.propertyDetailsArray> generatePropertyExpenses(List<Expense__c> propertyDetailsList,Applicant__c propApplicant){
      
      List<consumerAnzCapitalGeComOriginations.propertyDetailsArray> propertyList = new List<consumerAnzCapitalGeComOriginations.propertyDetailsArray>();
      if(propertyDetailsList != null){
        if(propertyDetailsList.size()>0){
          consumerAnzCapitalGeComOriginations.propertyDetailsArray propValues = new consumerAnzCapitalGeComOriginations.propertyDetailsArray();
          propValues.property = generatePropExpenses(propertyDetailsList,propApplicant);
          propertyList.add(propValues);
        }
      }
      return propertyList;
    }
    public static List<ConsumerAnzCapitalGeComOriginations.propertyDetails> generatePropExpenses(List<Expense__c> propExpList,Applicant__c propertyApplicant){
     
     List<ConsumerAnzCapitalGeComOriginations.propertyDetails> pdList = new List<ConsumerAnzCapitalGeComOriginations.propertyDetails>();

     if(propExpList != null){
       if(propExpList.size() > 0){
       
       if(propertyApplicant.Country_Res__c == 'Australia' && propertyApplicant.Is_Primary_Applicant__c == true) {
       
         for(integer i=0;i<1;i++){
         ConsumerAnzCapitalGeComOriginations.propertyDetails pd = new ConsumerAnzCapitalGeComOriginations.propertyDetails();
                       if(propertyApplicant.Res_Status__c == 'Renting' || propertyApplicant.Res_Status__c == 'Boarding with Parents' || propertyApplicant.Res_Status__c == 'Boarding Other'){
                         if(i == 0){
                             pd.propertyCostType = 'RB';
                            
                             if(propExpList[0].Rent_Board_Pay_Amt__c == null){ 
                               pd.propertyAmount = 0;
                               pd.propertyInterval = 'M';
                             }else if(propExpList[0].Rent_Board_Pay_Amt__c != null){
                               pd.propertyAmount =  propExpList[0].Rent_Board_Pay_Amt__c;  
                               pd.propertyInterval = propExpList[0].Rent_Board_Pay_Int_Code__c;                           
                             }                                                         
                                             
                         }
                         pdList.add(pd);
                        }
                          
                 system.debug('Property Array List $$$'+pdList);
           }
       
       }
       
       
       if(propertyApplicant.Country_Res__c == 'New Zealand' && propertyApplicant.Is_Primary_Applicant__c == true) {
          for(integer i=0;i<4;i++){
         ConsumerAnzCapitalGeComOriginations.propertyDetails pd = new ConsumerAnzCapitalGeComOriginations.propertyDetails();
         
                      if(i == 0){
                             pd.propertyCostType = 'P';
                             if(propExpList[0].Rent_Board_Pay_Amt__c == null || propExpList[0].Rent_Board_Pay_Amt__c == 0){
                               pd.propertyAmount = 0;
                               pd.propertyInterval = 'M';
                             }else if(propExpList[0].Rent_Board_Pay_Amt__c != null){
                               pd.propertyAmount =  propExpList[0].Rent_Board_Pay_Amt__c;
                               pd.propertyInterval = propExpList[0].Rent_Board_Pay_Int_Code__c; 
                             }
                                               
                         }
                         
                         if(i == 1){
                             pd.propertyCostType = 'S';
                             if(propExpList[0].Secondary_Mortgage_Rent__c == null){
                                pd.propertyAmount = 0;
                                pd.propertyInterval = 'M';
                             }else if(propExpList[0].Secondary_Mortgage_Rent__c != null){
                                pd.propertyAmount =  propExpList[0].Secondary_Mortgage_Rent__c;
                                pd.propertyInterval = propExpList[0].Secondary_Mortgage_Rent_Interval_Code__c; 
                             }
                                                
                         }
                         
                         if(i == 2){
                             pd.propertyCostType = 'R';
                             if(propExpList[0].Property_rates__c == null){
                               pd.propertyAmount =  0;
                               pd.propertyInterval = 'M';
                             }else if(propExpList[0].Property_rates__c != null){
                               pd.propertyAmount =  propExpList[0].Property_rates__c;
                               pd.propertyInterval = propExpList[0].Property_rates_Interval_Code__c; 
                             }
                                                
                         }
                         
                         if(i == 3){
                             pd.propertyCostType = 'O';
                             if(propExpList[0].Other_Property_Expenses__c == null){
                               pd.propertyAmount =  0;
                               pd.propertyInterval = 'M';
                             }else if(propExpList[0].Other_Property_Expenses__c != null){
                               pd.propertyAmount =  propExpList[0].Other_Property_Expenses__c;
                               pd.propertyInterval = propExpList[0].Other_Property_Expenses_Interval_Code__c;
                             }
                                                 
                           }
                           pdList.add(pd);
                           system.debug('Property Array List $$$'+pdList);
                           
         }
       
       }
                             
                
         }
       }
     
     return pdList;
    }
    
    //Responsible Lending
    public static List<ConsumerAnzCapitalGeComOriginations.expensesDetails> generateExpensesDetails(List<Expense__c> expensesDetailsList,Applicant__c expensesApplicant){
    
    List<ConsumerAnzCapitalGeComOriginations.expensesDetails> expDetailsList = new List<ConsumerAnzCapitalGeComOriginations.expensesDetails>();

    if(expensesDetailsList != null){
      if(expensesDetailsList.size() > 0){
     
     if(expensesApplicant.Country_Res__c == 'Australia' && expensesApplicant.Is_Primary_Applicant__c == true) { 
     
      for(integer i=0;i<6;i++){

        ConsumerAnzCapitalGeComOriginations.expensesDetails expDetailsInf = new ConsumerAnzCapitalGeComOriginations.expensesDetails();
       
           if(i == 0){
                expDetailsInf.livingExpenseCategory = 'FO';
                
                if(expensesDetailsList[0].Food_Groc_Entert__c == null){
                  expDetailsInf.livingExpenseAmount = 0;
                  expDetailsInf.livingExpenseInterval = 'M';
                }else if(expensesDetailsList[0].Food_Groc_Entert__c != null){
                  expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Food_Groc_Entert__c;
                  expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Food_Groc_Interval_Code__c;  
                } 
                 
                          
           }
          if(i==1){
            expDetailsInf.livingExpenseCategory = 'IN';
            
            if(expensesDetailsList[0].Insurance_Expense__c == null){
              expDetailsInf.livingExpenseAmount = 0;
              expDetailsInf.livingExpenseInterval = 'M';
             } else if(expensesDetailsList[0].Insurance_Expense__c != null){
              expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Insurance_Expense__c;
              expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Insurance_Expense_Interval_Code__c;
             }
             
                       
          }
          if(i==2){
            expDetailsInf.livingExpenseCategory = 'UT';
            
            if(expensesDetailsList[0].Utilities_Expense__c == null){
              expDetailsInf.livingExpenseAmount = 0;
              expDetailsInf.livingExpenseInterval = 'M';
            }else if(expensesDetailsList[0].Utilities_Expense__c != null){
              expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Utilities_Expense__c;
              expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Utilities_Expense_Interval_Code__c;  
            }
                    
        }
          if(i==3){
            expDetailsInf.livingExpenseCategory = 'TR';
         
            if(expensesDetailsList[0].Transport_Expense__c == null){            
              expDetailsInf.livingExpenseAmount = 0;
              expDetailsInf.livingExpenseInterval = 'M';
            }else if(expensesDetailsList[0].Transport_Expense__c != null){
              expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Transport_Expense__c;
              expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Transport_Expense_Interval_Code__c; 
           }   
                  
        }
          if(i==4){
            expDetailsInf.livingExpenseCategory = 'ED';
            
            if(expensesDetailsList[0].Education_and_child_Expense__c == null){
             expDetailsInf.livingExpenseAmount = 0;
             expDetailsInf.livingExpenseInterval = 'M';
            }else if(expensesDetailsList[0].Education_and_child_Expense__c != null){
             expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Education_and_child_Expense__c; 
             expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Education_and_child_Expense_Int_Code__c; 
            }                    
        }
          if(i==5){
            expDetailsInf.livingExpenseCategory = 'OT';
           
            if(expensesDetailsList[0].Personal_Other_Expense__c == null){
             expDetailsInf.livingExpenseAmount = 0;
             expDetailsInf.livingExpenseInterval = 'M';
            }else if(expensesDetailsList[0].Personal_Other_Expense__c != null){
             expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Personal_Other_Expense__c;
             expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Personal_Other_Expense_Interval_Code__c;
            }          
                                
        }
        expDetailsList.add(expDetailsInf);
        system.debug('Living Expense Details Array $$$ '+expDetailsList);
      }
     }  
        if(expensesApplicant.Country_Res__c == 'New Zealand' && expensesApplicant.Is_Primary_Applicant__c == true) {
        for(integer i=0;i<7;i++){

        ConsumerAnzCapitalGeComOriginations.expensesDetails expDetailsInf = new ConsumerAnzCapitalGeComOriginations.expensesDetails();
        
                    if(i == 0){
                    expDetailsInf.livingExpenseCategory = 'FO';
                    
                    if(expensesDetailsList[0].Food_Groc_Entert__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Food_Groc_Entert__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Food_Groc_Entert__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Food_Groc_Interval_Code__c;
                    }                   
                                
                   }
                  if(i==1){
                    expDetailsInf.livingExpenseCategory = 'HE';
                  
                    if(expensesDetailsList[0].Insurance_Expense__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Insurance_Expense__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Insurance_Expense__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Insurance_Expense_Interval_Code__c;
                    }                   
                               
                  }
                  if(i==2){
                    expDetailsInf.livingExpenseCategory = 'IN';
                   
                    if(expensesDetailsList[0].Utilities_Expense__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Utilities_Expense__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Utilities_Expense__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Utilities_Expense_Interval_Code__c;
                    }                   
                              
                }
                  if(i==3){
                    expDetailsInf.livingExpenseCategory = 'TR';
                    
                    if(expensesDetailsList[0].Transport_Expense__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Transport_Expense__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Transport_Expense__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Transport_Expense_Interval_Code__c;  
                    }
                                              
                }
                  if(i==4){
                    expDetailsInf.livingExpenseCategory = 'ED';
                   
                    if(expensesDetailsList[0].Education_and_child_Expense__c == null){
                      expDetailsInf.livingExpenseAmount = 0;
                      expDetailsInf.livingExpenseInterval = 'M';
                     }else if(expensesDetailsList[0].Education_and_child_Expense__c != null){
                      expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Education_and_child_Expense__c;
                      expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Education_and_child_Expense_Int_Code__c; 
                     }                 
                              
                }
                  if(i==5){
                    expDetailsInf.livingExpenseCategory = 'PE';
                   
                    if(expensesDetailsList[0].Personal_Other_Expense__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Personal_Other_Expense__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Personal_Other_Expense__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Personal_Other_Expense_Interval_Code__c;
                    }                                        
                }
                
                if(i==6){
                    expDetailsInf.livingExpenseCategory = 'OT';
                    
                    if(expensesDetailsList[0].Any_Additional_expenses__c == null){
                     expDetailsInf.livingExpenseAmount = 0;
                     expDetailsInf.livingExpenseInterval = 'M';
                    }else if(expensesDetailsList[0].Any_Additional_expenses__c != null){
                     expDetailsInf.livingExpenseAmount = expensesDetailsList[0].Any_Additional_expenses__c;
                     expDetailsInf.livingExpenseInterval = expensesDetailsList[0].Any_Additional_expenses_Interval_Code__c; 
                    }
                    
                                       
                } 
                expDetailsList.add(expDetailsInf);
                system.debug('Living Expense Details Array $$$ '+expDetailsList);
             }             
         }
         }

      }
    return expDetailsList;
    }
    /* Description: Method that maps values into DebtDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-28-13
    *  Input Parameters: debtList - 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.DebtDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.DebtDetails> generateDebtDetails(List<Liability__c> debtList,Application__c app) {
         
        List<ConsumerAnzCapitalGeComOriginations.DebtDetails> debtDetailsList = null;
        if(debtList!=null) {
            if(debtList.size()>0) {
              debtDetailsList = new List<ConsumerAnzCapitalGeComOriginations.DebtDetails>();
                for(Liability__c debt: debtList) {
                    ConsumerAnzCapitalGeComOriginations.DebtDetails debtDetail = new ConsumerAnzCapitalGeComOriginations.DebtDetails();
                    debtDetail.debtCategory = debt.Debt_Category_Code__c;
                    debtDetail.otherDebtType = debt.Type_of_Debt__c;
                    
                    debtDetail.payoutAcknowledgement = debt.Acknowledge_Payout__c;
                    if(app.Brand_Country__c == 'AU'){
                             String capsFinancierName = formatData(debt.Financier_Name_LC__c);
                             
                             List<String> names = capsFinancierName.split(' ');
                                for (Integer i = 0; i < names.size(); i++){
                                    names[i] = names[i].capitalize();
                                }
                                capsFinancierName = String.join(names, ' ');
                            debtDetail.financierName = capsFinancierName;
                    }
                    if(app.Brand_Country__c == 'NZ'){
                             if(debt.Financier_List__c != 'Other'){
                             debtDetail.financierName = debt.Financier_List__c;
                             }else if(debt.Financier_List__c == 'Other'){
                             String capsFinancierName = formatData(debt.Financier_Name_LC__c);
                             
                             List<String> names = capsFinancierName.split(' ');
                                for (Integer i = 0; i < names.size(); i++){
                                    names[i] = names[i].capitalize();
                                }
                                capsFinancierName = String.join(names, ' ');
                             debtDetail.financierName = capsFinancierName;
                             }
                    }
                    debtDetail.originalDebtAmount = 0;

                    debtDetail.repaymentAmount = 0;
                    debtDetail.outstandingBalanceAmount = 0;
                    
                    //assign other element values based on debt category
                    if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT ||
                       debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || 
                       debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT ||
                       debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
                        
                        debtDetail.originalDebtAmount = roundOffAmount(debt.Credit_Limit_Amt__c);
                        debtDetail.outstandingBalanceAmount = roundOffAmount(debt.Card_Overdraft_Bal_Amt__c);
                        debtDetail.reducedCreditLimitAmount = 0;
                        if(debt.Reduced_Credit_Limit__c!=null) {
                            debtDetail.reducedCreditLimitAmount = debt.Reduced_Credit_Limit__c;
                        }
                        
                        if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT) {
                            debtDetail.debtApr = 0;
                            if(debt.Overdraft_APR__c!=null) {
                                debtDetail.debtApr = debt.Overdraft_APR__c;
                            }
                        }
                        
                        //Added by Tony Xu, discussed with Ilya, NBSM need this field pass through for NZ calculation
                        debtDetail.repaymentAmount = roundOffAmount(debt.Total_Debts__c);

                    } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE) {
                    
                        debtDetail.outstandingBalanceAmount = roundOffAmount(debt.Mortgage_Bal_Amt__c);
                        debtDetail.originalDebtAmount = roundOffAmount(debt.Mortgage_Borrowed_Amt__c);
                        debtDetail.repaymentAmount = roundOffAmount(debt.Mortgage_Repayment_Amt__c);
                        debtDetail.repaymentInterval = debt.Mortgage_Repayment_Interval_Code__c;
                        
                        // Updated by Adrian Recio
                        // Change Date: 2/12/2015
                        // Description: Included Hire Purchase category in debt prepopulation
                    } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN ||
                              debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN ||
                              debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) {
                              
                        debtDetail.outstandingBalanceAmount = roundOffAmount(debt.Car_Personal_Bal_Amt__c);
                        debtDetail.originalDebtAmount = roundOffAmount(debt.Car_Personal_Borrowed_Amt__c);
                        debtDetail.repaymentAmount = roundOffAmount(debt.Car_Personal_Repay_Amt__c);
                        debtDetail.repaymentInterval = debt.Car_Personal_Repayment_Interval_Code__c;
                        
                    } else if (debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER) {
                        if(debt.Other_Borrowed_Amt__c!=null) {
                            debtDetail.originalDebtAmount = roundOffAmount(debt.Other_Borrowed_Amt__c);
                        }
                        debtDetail.repaymentAmount = roundOffAmount(debt.Other_Repay_Amt__c);
                        debtDetail.repaymentInterval = debt.Other_Repayment_Interval_Code__c;
                    }

                    debtDetail.netDebtAmount = 0;

                    if(debt.Total_Debts__c!=null) {
                        debtDetail.netDebtAmount = roundOffAmount(debt.Total_Debts__c);
                    }
                    
                    debtDetailsList.add(debtDetail);
                }
            }
        }
        
        return debtDetailsList;
    }
    
    /* Description: Method that maps values into BudgetDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: applicant - 
                         incomeList - 
                         expenseList - 
    *  Return: ConsumerAnzCapitalGeComOriginations.BudgetDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.BudgetDetailsType generateBudgetDetailsType(Applicant__c applicant,
                                                                                                  List<Income__c> incomeList,
                                                                                                  List<Expense__c> expenseList,
                                                                                                  List<Disbursement__c> refinances) {
        //Sandeep - PMIHM#141 added refinances
        
        ConsumerAnzCapitalGeComOriginations.BudgetDetailsType budgetDetails = new ConsumerAnzCapitalGeComOriginations.BudgetDetailsType();
        budgetDetails.incomeDetails = generateIncomeDetails(incomeList);
        budgetDetails.totalIncome = roundOffAmount(applicant.total_income__c);
        budgetDetails.expenses = generateExpenseDetails(expenseList,applicant);
        budgetDetails.totalExpenses = roundOffAmount(applicant.total_expense__c);
        budgetDetails.totalAdditionalIncome = roundOffAmount(applicant.Additional_Income__c);
        
        budgetDetails.totalVerifiedIncome = roundOffAmount(applicant.Total_POI_Amount_Verified__c);
        budgetDetails.totalVerifiedAddlIncome = roundOffAmount(applicant.Total_Verified_Additional_Income__c);
       
        // Added for the capacity flag to be sent to activate for not overriding the existing POI income with verifier if already inserted
        budgetDetails.suppressAutoPOI = applicant.Capacity_Flag__c;
        System.debug('**********: '+budgetDetails.suppressAutoPOI);
        budgetDetails.alertConfirmation = applicant.isPOIVerified__c;
        System.debug('**********: '+budgetDetails.alertConfirmation);
        budgetDetails.incomeRedundancyFlag = applicant.Income_Redundancy__c;

        if(applicant.Primary_Employment_Status__c!=null) {
            budgetDetails.employmentStatus = applicant.Primary_Employment_Status_Code__c;
        }
        budgetDetails.employmentStatus = applicant.Primary_Employment_Status_Code__c;
        budgetDetails.previousEmploymentStatus = applicant.Previous_Employment_Status_Code__c;

        Integer previousEmploymentYears = 0;
        Integer previousEmploymentMonths = 0;
        
        if(applicant.Time_at_previous_employer_years__c!=null ) {
            previousEmploymentYears = Integer.valueOf(applicant.Time_at_previous_employer_years__c);
        }
        if(applicant.Time_at_previous_employer_months__c!=null ) {
            previousEmploymentMonths = Integer.valueOf(applicant.Time_at_previous_employer_months__c);
        }
        
        budgetDetails.timeWithPreviousEmployer = generateTimeWithEmployerType(previousEmploymentYears, previousEmploymentMonths); 
        budgetDetails.timeWithCurrentEmployer = generateTimeWithEmployerType(0, 0);
        Decimal incomeSource = 0;
        
        for(Income__c inc: incomeList) {
           if(inc.total_income__c!=null) {
                if(incomeSource<inc.total_income__c) {
                    Integer currentEmploymentYears = 0;
                    Integer currentEmploymentMonths = 0;
                    
                    if(inc.Years_With_Employer__c!=null) {
                        currentEmploymentYears = Integer.valueOf(inc.Years_With_Employer__c);
                    }
                    if(inc.Months_With_Employer__c!=null) {
                        currentEmploymentMonths = Integer.valueOf(inc.Months_With_Employer__c);
                    }
                    
                    budgetDetails.timeWithCurrentEmployer = generateTimeWithEmployerType(currentEmploymentYears,currentEmploymentMonths);
                    budgetDetails.employerName = inc.Emp_Bus_Name__c;
                    budgetDetails.occupation = inc.Occupation_Code__c;

                    ConsumerAnzCapitalGeComOriginations.employerContactPhoneType ecpt = new ConsumerAnzCapitalGeComOriginations.employerContactPhoneType();
                    ecpt.areaCode = inc.Employer_Business_Contact_No_Area_Code__c; 
                    ecpt.phoneNumber = inc.Employer_Business_Contact_No_WS__c; 
                    budgetDetails.employerContactPhone = ecpt;
                    
                    incomeSource = inc.total_income__c;
                    
                    //Added industry code Tony xu to fix #427
                    if(inc.Industry_Code__c != null && inc.Industry_Code__c != ''){
                      budgetDetails.industryTypes = inc.Industry_Code__c;
                    }
                }
            }
        }
        
        //Sandeep - PMIHM#141 start
       if(refinances!= null && !refinances.isEmpty()) {
            budgetDetails.refinanceAccounts = generateRefinance(refinances);
        }
        //Sandeep - PMIHM#141 end
        return budgetDetails;
    }
    
    /* Description: Method that maps values into ApplicantType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: clvId -
                         sfApplicantId - 
                         applicant - 
                         incomeList - 
                         assetList - 
                         expenseList -
                         liabilityList -
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicantType
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicantType generateApplicantType(String sfApplicantId,
                                                                                          Applicant__c applicant,
                                                                                          List<Income__c> incomeList,
                                                                                          List<Expense__c> expenseList,
                                                                                          List<Applicant_CLV__c> applicantCLVList,
                                                                                          List<Disbursement__c> refinances, 
                                                                                          Application__c application) { 
        //Sandeep - PMIHM#141 added refinances
        //Neha - DBHZL-206-  Added application to retrieve NFL related fields for applicants
        
        ConsumerAnzCapitalGeComOriginations.ApplicantType applicantType = new ConsumerAnzCapitalGeComOriginations.ApplicantType();
        if(applicantCLVList!=null) {
            if(!applicantCLVList.isEmpty()) {
                applicantType.clvDetails = generateCLVDetailsCollection(applicantCLVList);
            }
        }
        applicantType.sfApplicantId = sfApplicantId;
        
        //315
        applicantType.accessNumber = applicant.Kiwi_Bank_Access_Number__c; 
        System.debug('**********:'+applicantType.accessNumber);
        applicantType.personalDetails = generatePersonalDetailsType(applicant);
        applicantType.budgetDetails = generateBudgetDetailsType(applicant,incomeList,expenseList,refinances);
        if(applicant.Is_Primary_Applicant__c) {
            applicantType.type_x = GEN_OriginationsConstants.APPLICANT_TYPE_PRIMARY;
            
            //Neha - DBHZL-206-  Set NFL information for primary applicant
            if(application.Applicant_1_NFL__c!=null){
              if(application.Applicant_1_NFL__c == 'Yes'){
                applicantType.riskReferralDetails = generateRiskReferralDetailsType(true, application.Applicant_1_NFL_Expiry_Date__c);
              }
              else if(application.Applicant_1_NFL__c == 'No'){
                applicantType.riskReferralDetails = generateRiskReferralDetailsType(false, null);
              }
            }
            
            
        } else {
          
            applicantType.type_x = GEN_OriginationsConstants.APPLICANT_TYPE_SECONDARY;
            
            //Neha - DBHZL-206-  Set NFL information for secondary applicant
            if(application.Applicant_2_NFL__c!=null){
              if(application.Applicant_2_NFL__c == 'Yes'){
                applicantType.riskReferralDetails = generateRiskReferralDetailsType(true, application.Applicant_2_NFL_Expiry_Date__c);
              }
              else if(application.Applicant_2_NFL__c == 'No'){
                applicantType.riskReferralDetails = generateRiskReferralDetailsType(false, null);
              }
            }
        }
        
        return applicantType;
        
    } 
    
    /* Description: Method that maps values into CLVDetailsCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 01-06-14
    *  Input Parameters: List<Applicant_CLV__c> -
    *  Return: ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection generateCLVDetailsCollection(List<Applicant_CLV__c> appCLV) { 

        ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection clvDetailsCollection = new ConsumerAnzCapitalGeComOriginations.CLVDetailsCollection();
        List<ConsumerAnzCapitalGeComOriginations.clvDetailsType> clvDetailsType = new List<ConsumerAnzCapitalGeComOriginations.clvDetailsType>();
        
        for(Applicant_CLV__c clv: appCLV) {
        
            if(clv.message_code__c != GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS) {
                continue;
            }
        
            ConsumerAnzCapitalGeComOriginations.clvDetailsType clvDetails = new ConsumerAnzCapitalGeComOriginations.clvDetailsType();
            clvDetails.clvId = clv.CLV__c;
            clvDetails.icbsCustomerId = clv.ICBS_Customer_ID__c;
            clvDetails.geContactId = clv.GE_Contact_ID__c;
            clvDetails.dateOfBirth = clv.Date_of_Birth__c;
            clvDetails.driverLicense = clv.Drivers_License__c;
            clvDetails.title = clv.Title__c;
            clvDetails.firstName = clv.First_Name__c;
            clvDetails.middleName = clv.Middle_Name__c;
            clvDetails.surName = clv.Surname__c;
            clvDetails.workNumber = clv.Work__c;
            clvDetails.mobileNumber = clv.Mobile__c;
            clvDetails.home = clv.Home__c;
            clvDetails.street = clv.Street_Address__c;
            clvDetails.suburb = clv.Suburb__c;
            clvDetails.state = clv.State__c;
            clvDetails.postCode = clv.Post_Code__c;
            
            //BEGIN MLASALA: 16-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
            //Map new fields
            clvDetails.matchScore = clv.Match_Score__c;
            clvDetails.matchGrade = clv.Match_Grade__c;
            clvDetails.userMatchFlag = clv.User_Match_Flag__c;
            clvDetails.sfExtId = clv.Appliction_CLV_Code__c;
            //END MLASALA: 16-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
            
            clvDetailsType.add(clvDetails);
        }
        clvDetailsCollection.clv = clvDetailsType;
        system.debug('$$$ clvDetailsType: '+clvDetailsType);
        if(clvDetailsType.isEmpty()) {
            return null;
        } else {
            return clvDetailsCollection;
        }
        
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
    
    /* Description: Method that maps values into ProductDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: orgId -
                         logoId - 
                         productName - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ProductDetailsType 
    
    public static ConsumerAnzCapitalGeComOriginations.ProductDetailsType generateProductDetailsType(GEProduct__c product, Boolean isLoanSecured, Decimal insuranceCount, String applicantState) { 
        
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetailsType = new ConsumerAnzCapitalGeComOriginations.ProductDetailsType();
        productDetailsType.orgId = product.org_id__c;
        if(applicantState == GEN_OriginationsConstants.APPLICANT_STATE_VIC && 
           product.Product_Name__c == GEN_OriginationsConstants.PRODUCT_NAME_GELOAN &&
           isLoanSecured) {
            productDetailsType.logoId = Web_Service_Settings__c.getValues('Product Code Override - VIC').value__c;
        } else if(isLoanSecured) {
            if(product.Brands__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
               Integer.valueOf(insuranceCount) == 3){
                productDetailsType.logoId = product.Logo_Id_Bundled_Secured__c;
            } else {
                productDetailsType.logoId = product.Logo_Id_Secured__c;
            }
        } else {
            if(product.Brands__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
               Integer.valueOf(insuranceCount) == 3){
                productDetailsType.logoId = product.Logo_Id_Bundled__c;
            } else {
                productDetailsType.logoId = product.Logo_Id__c;
            }
        }
        productDetailsType.productName= product.Product_Name__c;
        return productDetailsType;
        
    } */
    /* Adding new parameter Application__c and new field productSubType data power field by Suneel - Better Start */
 public static ConsumerAnzCapitalGeComOriginations.ProductDetailsType generateProductDetailsType(Application__c application,GEProduct__c product, Boolean isLoanSecured, Decimal insuranceCount, String applicantState,Better_Start_Offer__c bsOffer) { 
        
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetailsType = new ConsumerAnzCapitalGeComOriginations.ProductDetailsType();
        productDetailsType.orgId = product.org_id__c;
        if(applicantState == GEN_OriginationsConstants.APPLICANT_STATE_VIC && 
           product.Product_Name__c == GEN_OriginationsConstants.PRODUCT_NAME_GELOAN &&
           // Added the below condition for allowing VIC region product code for Better Start
           isLoanSecured && application.Product_SubType__c == 'Better Start PL') {
            productDetailsType.logoId = product.Logo_Id_Secured__c;
        } else if(applicantState == GEN_OriginationsConstants.APPLICANT_STATE_VIC && 
           product.Product_Name__c == GEN_OriginationsConstants.PRODUCT_NAME_GELOAN &&
           isLoanSecured) {
            productDetailsType.logoId = Web_Service_Settings__c.getValues('Product Code Override - VIC').value__c;
        }
        else if(isLoanSecured) {
            if(product.Brands__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
               Integer.valueOf(insuranceCount) == 3){
                productDetailsType.logoId = product.Logo_Id_Bundled_Secured__c;
            } else {
                productDetailsType.logoId = product.Logo_Id_Secured__c;
            }
        } else {
            if(product.Brands__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
               Integer.valueOf(insuranceCount) == 3){
                productDetailsType.logoId = product.Logo_Id_Bundled__c;
            } else {
                productDetailsType.logoId = product.Logo_Id__c;
            }
        }
        productDetailsType.productName= product.Product_Name__c;
      /* if(application.Brand_Country__c == 'AU'){
        productDetailsType.productSubType = application.Product_SubType_Code__c;
        }*/
               if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false) && application.Brand_Country__c == 'AU'){
                productDetailsType.productSubType = application.Product_SubType_Code__c; 
                } 
                if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false) && application.Brand_Country__c == 'NZ'){
                productDetailsType.productSubType = application.Product_SubType_Code__c; 
                }           
        return productDetailsType;
        
    }
    /* End */
        
    /* Description: Method that maps values into LoanDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Application__c application,
                          List<Loan_Purpose__c> loanPurposeList,
                          GEProduct__c product,
                          String solCode
    *  Return: ConsumerAnzCapitalGeComOriginations.LoanDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.LoanDetailsType generateLoanDetailsType(Application__c application,
                                                                                              List<Loan_Purpose__c> loanPurposeList,
                                                                                              GEProduct__c product,
                                                                                              String solCode,
                                                                                              List<Debit__c> debits,
                                                                                              List<Fees_Charges__c> feesAndCharges) { 
        
        ConsumerAnzCapitalGeComOriginations.LoanDetailsType loanDetailsType = new ConsumerAnzCapitalGeComOriginations.LoanDetailsType();
        
        loanDetailsType.totalLoanAmount = roundOffAmount(application.Total_Loan_Amount__c);
        //loanDetailsType.cpuProposedMaxSecuredAmount = application.Max_Capacity_Secured_Risk__c; (removed)
        //loanDetailsType.cpuProposedMaxUnsecuredAmount = application.Max_Capacity_Unsecured_Risk__c; (removed)
        
        loanDetailsType.loanInsuranceConsent = application.Loan_Insurance_Consent__c;
        loanDetailsType.solicitationCode = solCode;
        //loanDetailsType.amlPosVerified = application.AML_Ver__c; (removed WSDL 7.71)
        //loanDetailsType.amlVerifiedDate = application.AML_Ver_Date__c; (removed WSDL 7.71)

        loanDetailsType.OfferOptin = application.Interested_in_other_services__c;
        loanDetailsType.CrossSellEligibilityAck = application.Credit_Card_Eligibility_Flag__c;
        if(loanPurposeList!=null) {
            if(loanPurposeList.size()>0) {
                loanDetailsType.loanPurposes = generateLoanPurposeDetails(loanPurposeList);
            }
        }
        loanDetailsType.securedLoanFlag = application.Is_Secured__c;
   //Appending 3 months for the Better Start applications for Copy of Application Document - 08/11/2019
            Better_Start_Offer__c bsOffer;
           try{
           bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
        if(application.Brand_Country__c == 'AU'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);
            if(application.Loan_Term_Months__c!=null) {
                if((application.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
                     Integer actualTerm = Integer.valueOf(application.Loan_Term_Months__c);
                     loanDetailsType.loanTerm = actualTerm + lterm;
                }else{
                     loanDetailsType.loanTerm = Integer.valueOf(application.Loan_Term_Months__c);        
                    }
            }
        }else if(application.Brand_Country__c == 'NZ'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);
            if(application.Loan_Term_Months__c!=null) {
                if((application.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false)){
                     Integer actualTerm = Integer.valueOf(application.Loan_Term_Months__c);
                     loanDetailsType.loanTerm = actualTerm + lterm;
                }else{
                     loanDetailsType.loanTerm = Integer.valueOf(application.Loan_Term_Months__c);        
                    }
            }
        } 
        }catch(Exception e){
        }
        //loanDetailsType.paymentFrequency = application.Payment_Frequency_Code__c; (removed WSDL 7.70)
        if(feesAndCharges!=null) {
            if(!feesAndCharges.isEmpty()) {
                loanDetailsType.fees = generateFeeDetails(feesAndCharges, application);
            }
        }
        /** Adding new PeriodRepayments Data power field for Better Start - 30/05/2019 **/
        if(debits!=null) {
            if(!debits.isEmpty()) {
               // loanDetailsType.repayments = generateRepaymentDetails(debits);
                loanDetailsType.periodRepayments= generateRepaymentDetails(debits);
                System.debug('loanDetailsType Repayments'+loanDetailsType.periodRepayments);
            }
        } 
        
             
        loanDetailsType.totalLoanInterestAmtPayable  = roundOffAmount(application.Total_Loan_Interest_Amount_Payable__c);
        loanDetailsType.totalInsuranceInterestAmtPayable = roundOffAmount(application.Total_Insurance_Interest_Amount_Payable__c);
        //p-404
        //loanDetailsType.initialInterestRate = formatData(application.Offered_Interest_Rate__c);
        /** Commenting the below line of code to support Better Start initial interest rate to Zero  **/
        //loanDetailsType.initialInterestRate = formatData(application.Offered_Interest_Rate_Orig__c);
        
        // Better Start: Updating the Initial interest to Zero
        if(application.Brand_Country__c == 'NZ'){
            if((application.Product_SubType__c == 'Better Start PL') && ((bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false))){
                 loanDetailsType.initialInterestRate = 0.0;
            }else{
                 loanDetailsType.initialInterestRate = formatData(application.Offered_Interest_Rate_Orig__c);
            }
        }else if(application.Brand_Country__c == 'AU'){
            if((application.Product_SubType__c == 'Better Start PL') && ((bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false))){
                  loanDetailsType.initialInterestRate = 0.0;
            }else{
                  loanDetailsType.initialInterestRate = formatData(application.Offered_Interest_Rate_Orig__c);
            }
        }
        //End 
        
        //p-404
//        loanDetailsType.instalmentAmtInclLSF = roundOffAmount(application.EMI_with_Service_Fee__c); //Added OASSv9.5
//        loanDetailsType.instalmentAmtExlLSF = roundOffAmount(application.Offered_Repayments__c); //Added OASSv9.5
        //loanDetailsType.finalInterestRate = formatData(application.Adjusted_Interest_Rate__c); //Added OASSv9.1
        //Changed by Lavanya, for the Rate Discretion Issue. Jira Number: 404
        loanDetailsType.finalInterestRate = formatData(application.Offered_Interest_Rate__c); 
        loanDetailsType.rateAdjustmentReason = formatData(application.Adjusted_Interest_Rate_Reason__c); //Added OASSv9.1
        
        return loanDetailsType;
    }
    
    /* Description: Method that maps values into LoanDetailsType WSobject
    *  Author: Dan Crisolog
    *  Date Created: 01-20-2014
    *  Input Parameters: application
    *  Return: ConsumerAnzCapitalGeComOriginations.feeDetails
    */
    public static ConsumerAnzCapitalGeComOriginations.feeDetails generateFeeDetails(List<Fees_Charges__c> feesAndCharges, Application__c application) { 
        
        ConsumerAnzCapitalGeComOriginations.feeDetails feeDetails = new ConsumerAnzCapitalGeComOriginations.feeDetails();
        
        feeDetails.establishmentFee = roundOffAmount(application.Offered_Establishment_Fee__c);
        
        for(Fees_Charges__c fc: feesAndCharges) {

            /*if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_ESTABLISHMENT) {
                feeDetails.establishmentFee = roundOffAmount(fc.Fee_Amount__c);
            }*/
            if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_EARLY_TERMINATION1) {
                feeDetails.earlyTerminationFee1 = roundOffAmount(fc.Fee_Amount__c);
            }
            if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_EARLY_TERMINATION2) {
                feeDetails.earlyTerminationFee2 = roundOffAmount(fc.Fee_Amount__c);
            }
            if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_PAYMENT_HANDLING) {
                feeDetails.paymentHandlingFee = roundOffAmount(fc.Fee_Amount__c);
            }
            if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_LOAN_SERVICE) {
                feeDetails.loanServiceFee = roundOffAmount(fc.Fee_Amount__c);
            }
            if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_LATE_PAYMENT) {
                feeDetails.latePaymentFee = roundOffAmount(fc.Fee_Amount__c);
            }
            
        }

        return feeDetails;
    
    }
    
    /* Description: Adding New Data power fields IntroInterestRate and NumberOfPayments,passing two repayment section in single period repayment
    *  Author: Suneel Desiraju
    *  Date Created: 30/05/2019  
    *  Project : Better Start
    *  Return: ConsumerAnzCapitalGeComOriginations.repaymentDetailsArray 
    */
   public static ConsumerAnzCapitalGeComOriginations.repaymentDetailsArray generateRepaymentDetails(List<Debit__c> debits) { 
    System.debug('Enter the Repayments Dragon');
    ConsumerAnzCapitalGeComOriginations.repaymentDetailsArray  repaymentDetailsArray = new ConsumerAnzCapitalGeComOriginations.repaymentDetailsArray();
    List<ConsumerAnzCapitalGeComOriginations.repaymentDetails> repaymentDetailsList = new List<ConsumerAnzCapitalGeComOriginations.repaymentDetails>();
    
     Id appId = ApexPages.currentPage().getParameters().get('id');
     Debit__c debit;
     try{
         debit = [select Application__r.Product_SubType__c from Debit__c where Application__r.id=:appId ];
     Integer i=1;
    do {
    for(Debit__c d: debits){
    Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
    ConsumerAnzCapitalGeComOriginations.repaymentDetails repaymentDetails = new ConsumerAnzCapitalGeComOriginations.repaymentDetails();
            repaymentDetails.repaymentMethod = d.Payment_Method_Code__c;
                    repaymentDetails.accountHolders = d.Account_Holders__c;
                    
                    if(d.Bank_Name__c!=null) {
                        repaymentDetails.bankName = d.Bank_Name__c;
                    }
                    if(d.Branch_Location__c!=null) {
                        repaymentDetails.branchLocation = d.Branch_Location__c;
                    }
                    if(d.BSB_Number__c!=null) {
                        repaymentDetails.bsbNumber = d.BSB_Number__c;
                    }
                    if(d.Account_Number__c!=null) {
                        repaymentDetails.accountNumber = d.Account_Number__c;
                    } 
                    
                     if(d.Bank_Number__c != null && d.Branch_Number__c != null){
                        repaymentDetails.bsbNumber = d.Bank_Number__c + d.Branch_Number__c;
                      }
                      if(d.Suffix_Number__c != null){
                        repaymentDetails.accountSuffix = d.Suffix_Number__c;
                      }
                      repaymentDetails.repaymentFrequency = d.Frequency_Code__c;
                    
                    if(d.Specify_Higher_Amount__c!=null) {
                        repaymentDetails.higherInstallmentAmount = d.Specify_Higher_Amount__c;
                    }
                    if(d.Commencement_Date__c!=null) {
                        repaymentDetails.commencementDate = d.Commencement_Date__c;
                    } else {
                        repaymentDetails.commencementDate = Date.Today();
                    }
                   /* if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1 ){
                       repaymentDetails.introInterestRate = 0.0;
                       repaymentDetails.numberOfPayments = 3;
                   }
                   else
                   {
                       repaymentDetails.introInterestRate = d.Application__r.Offered_Interest_Rate__c;
                       repaymentDetails.numberOfPayments = d.Application__r.Loan_Term_Months__c;
                   } */
                   
                    if(d.Application__r.Brand_Country__c == 'AU'){
                              if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1 && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
                                   repaymentDetails.introInterestRate = 0.0;
                                   repaymentDetails.numberOfPayments = Decimal.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);
                                   repaymentDetails.instalmentAmtInclLSF = 0.0;
                                   repaymentDetails.instalmentAmtExlLSF = 0.0;
                               }else if(bsOffer.BetterStartAUActive__c == true){
                                   repaymentDetails.introInterestRate = d.Application__r.Offered_Interest_Rate__c;
                                   repaymentDetails.numberOfPayments = d.Application__r.Loan_Term_Months__c;
                                   repaymentDetails.instalmentAmtInclLSF = roundOffAmount(d.Application__r.EMI_with_Service_Fee__c);
                                   repaymentDetails.instalmentAmtExlLSF = roundOffAmount(d.Application__r.Offered_Repayments__c);                                   
                               }else if(bsOffer.BetterStartAUActive__c == false){
                                   repaymentDetails.introInterestRate = d.Application__r.Offered_Interest_Rate__c;
                                   repaymentDetails.numberOfPayments = d.Application__r.Loan_Term_Months__c;
                                   repaymentDetails.instalmentAmtInclLSF = roundOffAmount(d.Application__r.EMI_with_Service_Fee__c);
                                   repaymentDetails.instalmentAmtExlLSF = roundOffAmount(d.Application__r.Offered_Repayments__c);                                   
                               }
                             } else if(d.Application__r.Brand_Country__c == 'NZ'){
                             if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1 && bsOffer.BetterStartNZActive__c == true ){
                                   repaymentDetails.introInterestRate = 0.0;
                                   repaymentDetails.numberOfPayments = Decimal.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);
                                   repaymentDetails.instalmentAmtInclLSF = 0.0;
                                   repaymentDetails.instalmentAmtExlLSF = 0.0;
                               }else if(bsOffer.BetterStartNZActive__c == true) {
                                  repaymentDetails.introInterestRate = d.Application__r.Offered_Interest_Rate__c;
                                  repaymentDetails.numberOfPayments = d.Application__r.Loan_Term_Months__c;
                                   repaymentDetails.instalmentAmtInclLSF = roundOffAmount(d.Application__r.EMI_with_Service_Fee__c);
                                   repaymentDetails.instalmentAmtExlLSF = roundOffAmount(d.Application__r.Offered_Repayments__c);                                   
                               }else if(bsOffer.BetterStartNZActive__c == false){
                                   repaymentDetails.introInterestRate = d.Application__r.Offered_Interest_Rate__c;
                                   repaymentDetails.numberOfPayments = d.Application__r.Loan_Term_Months__c;
                                   repaymentDetails.instalmentAmtInclLSF = roundOffAmount(d.Application__r.EMI_with_Service_Fee__c);
                                   repaymentDetails.instalmentAmtExlLSF = roundOffAmount(d.Application__r.Offered_Repayments__c);                                   
                               }
                               }
                    repaymentDetailsList.add(repaymentDetails);
    
    }  
    i++;  
        system.debug('Before While'+i);
    }
    while(i<3 && debit.Application__r.Product_SubType__c == 'Better Start PL' );
    System.debug('After While'+i);
    }
     catch(System.QueryException e){
         System.debug('Debit Record retrieval exception occured');
     }
     catch(System.NullPointerException e1){
         System.debug('Exception for Null pointer occured');
         System.debug('Product SubType Value' + debit.Application__r.Product_SubType__c);
    }
    system.debug('Repayment Details List ++++++++++++' + repaymentDetailsList);
    

    repaymentDetailsArray.repayment= repaymentDetailsList;
   system.debug('Repayment RepaymentDetails Array +++++'+repaymentDetailsArray.repayment);
    return repaymentDetailsArray; 
    
    }
    //End Better Start
    
   
    
    /* Description: Method that maps values into LoanPurposeDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 01-20-14
    *  Input Parameters: 
    *  Return: List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails>
    */
    public static List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails> generateLoanPurposeDetails(List<Loan_Purpose__c> loanPurpose) { 
        
        List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails> loanPurposeDetails = new List<ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails>();
        for(Loan_Purpose__c lp: loanPurpose) {
            ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails loanPurposeDetail = new ConsumerAnzCapitalGeComOriginations.LoanPurposeDetails();
            loanPurposeDetail.loanPurposeAmount = roundOffAmount(lp.Loan_Amount__c);
            loanPurposeDetail.loanPurpose = lp.Loan_Purpose_Value_Code__c;
            loanPurposeDetail.loanPurposeOther = lp.Other_Loan_Purpose__c;
            loanPurposeDetails.add(loanPurposeDetail);
        }
        return loanPurposeDetails;
        
    }
    
    /* Description: Method that maps values into ApplicationCustomerDataType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: sfApplicationId -
                         applicants -
                         product -
                         loanDetails -
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType 
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType generateApplicationCustomerDataType(Application__c application,
                                                                                                                      ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicants,
                                                                                                                      ConsumerAnzCapitalGeComOriginations.ProductDetailsType product,
                                                                                                                      ConsumerAnzCapitalGeComOriginations.LoanDetailsType loanDetails,
                                                                                                                      List<Asset__c> assetList,
                                                                                                                      List<Liability__c> liabilityList,
                                                                                                                      List<Asset__c> assetList2,
                                                                                                                      List<Liability__c> liabilityList2,
                                                                                                                      Applicant__c applicant1,
                                                                                                                      Applicant__c applicant2,
                                                                                                                      List<Collateral__c> collaterals,
                                                                                                                      List<Personal_Reference_Check__c> personalReferenceList) { 
        
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType applicationCustomerDataType = new ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType();
        applicationCustomerDataType.sfApplicationId = application.Id;
        //Code Changes Start as part of NZ CR code by Madhu
        system.debug('Updatecall stage'+ applicationCustomerDataType.applicationStage);
        system.debug('App stage'+ application.Application_Stage__c);
         system.debug('App stage'+ application.AU_Submit_Flag__c);       
       // if((application.Brand_Country__c == 'NZ') || (application.Brand_Country__c == 'AU' && application.AU_Submit_Flag__c == true)){       
            applicationCustomerDataType.applicationStage = application.Application_Stage__c;
        //}
        if(application.Brand_Country__c == 'NZ' && application.quote_Status__c != null){
            applicationCustomerDataType.quoteStatus = application.quote_Status__c;  
        }
         system.debug('Updatecall quotestatus'+ applicationCustomerDataType.quoteStatus);
        //Code Changes End as part of NZ CR code by Madhu
        
        //315
        applicationCustomerDataType.pbUid = application.pbuid__c; 
        if(application.Channel__c == 'Online'){
        applicationCustomerDataType.webSessionId = application.Web_Session_ID__c;
        }
        applicationCustomerDataType.liabilityVerifiedFlag = applicant1.Liability_flag__c;
        //added by vijay
        applicationCustomerDataType.bankAccountsHeld=application.Bank_Accounts_Code__c; 
        if(application.uid__c!=null) {
            applicationCustomerDataType.applicationId = application.uid__c;
        }

        applicationCustomerDataType.applicants = applicants;
        applicationCustomerDataType.product = product;
        applicationCustomerDataType.loanDetails = loanDetails;
        System.debug('loanDetailsCustomer+++++++++++'+applicationCustomerDataType.loanDetails);
        
        if(application.Brand_Country__c == 'AU'){
          applicationCustomerDataType.businessSource = application.Business_Source_Code__c;
          applicationCustomerDataType.applicationSource = application.Application_Source_code__c;
          applicationCustomerDataType.mirror = application.Mirror_Code__c;
        }
        
        //Changed by Tony xu to pass correct code to Activate in NZ
        if(application.Brand_Country__c == 'NZ'){
          
          applicationCustomerDataType.businessSource =  application.Mirror_Code__c;
          applicationCustomerDataType.applicationSource = application.Business_Source_Code__c;
          
        }
        
        //BEGIN MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        applicationCustomerDataType.higherApprovalConsent = applicant1.Higher_Approval_Consent__c;
        applicationCustomerDataType.initialRequestedAmount = roundOffAmount(application.Initial_Requested_Amount__c);
        System.debug('$$$ higherApprovalConsent: '+applicationCustomerDataType.higherApprovalConsent+', initialRequestedAmount: '+applicationCustomerDataType.initialRequestedAmount);
        //END MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        
        //combine the assets and debts when generating asset/debt details
        if(assetList2!=null) {
            assetList.addAll(assetList2);
        }
        //system.debug('assets list: '+liabilityList2.size() +' '+liabilityList.size());
        if(liabilityList2!=null) {
            /*Boolean withLiability = false;
            for(Liability__c l: liabilityList2){
              if(l.Debt_Category__c != null){
                  withLiability = true;
              }
            }
            system.debug('withliability '+withliability);
            if(withLiability){*/
              liabilityList.addAll(liabilityList2);
            //}
        }
        
        system.debug('assets list: '+assetList.size() +' '+liabilityList.size()+' '+liabilityList2);
        if(assetList!=null) {
            if(assetList.size()>0) {
                ConsumerAnzCapitalGeComOriginations.AssetCollection assetCollection = new ConsumerAnzCapitalGeComOriginations.AssetCollection();
                assetCollection.asset = generateAssetDetails(assetList);
                applicationCustomerDataType.assetDetails = assetCollection;
            }
        }
        
        if(liabilityList!=null) {
            if(liabilityList.size()>0) {
              Boolean withLiability = false;
              for(Liability__c l: liabilityList){
                if(l.Debt_Category__c != null){
                  withLiability = true;
                }
              }
              system.debug('withliability '+withliability);
              if(withLiability){
                ConsumerAnzCapitalGeComOriginations.DebtCollection debtCollection = new ConsumerAnzCapitalGeComOriginations.DebtCollection();
                //debtCollection.debt = generateDebtDetails(liabilityList);
                debtCollection.debt = generateDebtDetails(liabilityList,application);
                applicationCustomerDataType.debtDetails = debtCollection;
              }
            }
        }
        
        //compute total assets and total debts
        applicationCustomerDataType.totalAssets = roundOffAmount(applicant1.total_assets__c); //return 0 if total is null
        applicationCustomerDataType.totalNetDebtAmount = roundOffAmount(applicant1.total_debts__c); //return 0 if total is null
        system.debug('assets list2: '+ applicationCustomerDataType.totalAssets +' '+applicationCustomerDataType.totalNetDebtAmount);
        if(applicant2!=null) {
            applicationCustomerDataType.totalAssets = applicationCustomerDataType.totalAssets + roundOffAmount(applicant2.total_assets__c);
            applicationCustomerDataType.totalNetDebtAmount = applicationCustomerDataType.totalNetDebtAmount + roundOffAmount(applicant2.total_debts__c);
            
            //applicationCustomerDataType.higherApprovalConsent = applicant2.Higher_Approval_Consent__c;      //MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        }
        if(collaterals!=null) {
            if(!collaterals.isEmpty()) {
                applicationCustomerDataType.collaterals = generateCollateralCollection(collaterals, application);
            }
        }

        if(personalReferenceList!=null) {
            if(!personalReferenceList.isEmpty()) {
                applicationCustomerDataType.personalReferenceDataCollection = generatePersonalReferenceDataCollection(personalReferenceList);
            }
        }
        applicationCustomerDataType.offerDetails = generateOfferDetailsType(application);
        applicationCustomerDataType.thirdPartyDetailsData = generateThirdPartyDetails(application); //June 28,2016 - Afreen - Added the new third party information
        return applicationCustomerDataType;
        
    }
    
    /* Description: Method that maps values into FingerPrintDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: application -
    *  Return: ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType generateFingerPrintDetailsType(Application__c application) { 
        
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType fingerPrintDetailsType = new ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType();

        //fingerPrintDetailsType.correlationId = application.Correlation_ID__c; -- REMOVED as of OASS v9.1
        //fingerPrintDetailsType.blackBox = application.FP_Black_Box__c;
        //fingerPrintDetailsType.IPAddress = application.FP_IP_Address__c;
        //fingerPrintDetailsType.iOvationType = application.iOvation_Type__c;
        //fingerPrintDetailsType.fingerPrintStep = application.Fingerprint_Step__c;
        
        fingerPrintDetailsType.blackBox = '';
        fingerPrintDetailsType.IPAddress = '';
        fingerPrintDetailsType.iOvationType = '';
        fingerPrintDetailsType.fingerPrintStep = '';


        return fingerPrintDetailsType;
        
    }
    
    /* Description: Method that maps values into ApplicationSupportingDataType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: fingerPrintDetails -
                         addProductArrangementToCaseInput - 
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType generateApplicationSupportingDataType(ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType fingerPrintDetails,
                                                                                                                          String acceptanceChannel,
                                                                                                                          CaseModelServicingGeCom20.Case_x addProductArrangementToCaseInput,
                                                                                                                          Branch__c branch,
                                                                                                                          User staff, String applicationChannel) { 
        
        ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType applicationSupportingDataType = new ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType();

        applicationSupportingDataType.fingerPrintDetails = fingerPrintDetails;
        applicationSupportingDataType.productArrangementToCaseInput = addProductArrangementToCaseInput;
        applicationSupportingDataType.acceptanceChannel = acceptanceChannel;
        applicationSupportingDataType.branchDetails = generateBranchDetailsType(branch, staff, applicationChannel); // May-09-2016 - Afreen updated the signature to include the application channel

        return applicationSupportingDataType;
        
    }
    
    /* Description: Method that maps values into ConsumerAnzCapitalGeComOriginations.BranchDetailsType WSobject
    *  Author: Dan Crisologo
    *  Date Created: 02-05-14
    *  Input Parameters: 
    *  Return: ConsumerAnzCapitalGeComOriginations.BranchDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.BranchDetailsType generateBranchDetailsType(Branch__c branch, User staff, String applicationChannel) {  // May-09-2016 - Afreen updated the signature to include the application channel
        
        ConsumerAnzCapitalGeComOriginations.BranchDetailsType branchDetailsType = new ConsumerAnzCapitalGeComOriginations.BranchDetailsType();

        //assign default values if product is null
        if(branch!=null) {
            branchDetailsType.branchNumber = branch.Branch_Id__c;
            branchDetailsType.branchLocation = branch.Name;
            if(branch.Phone__c!=null) {
                branchDetailsType.phoneNumber = branch.Phone__c.replaceAll(' ', '');
            }
            if(branch.Fax__c!=null) {
                branchDetailsType.FaxNumber = branch.Fax__c.replaceAll(' ', '');
            }
            branchDetailsType.managerName = branch.Primary_Contact__r.Name;
        } else {
            branchDetailsType.branchNumber = GEN_OriginationsConstants.CUSTOMER_BRANCH_NUMBER;
        }
        
        //assign default values if staff is null
        if(staff!=null) {
            branchDetailsType.salesStaffId = staff.SSO_Number__c;
            branchDetailsType.salesStaffName = staff.Name;
        } else if(applicationChannel == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){  //// May-09-2016 - Afreen updated to send different SSO and Staff name for Broker applications
            branchDetailsType.salesStaffId = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_ID;
            branchDetailsType.salesStaffName = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_NAME;
        }else{
            branchDetailsType.salesStaffId = GEN_OriginationsConstants.CUSTOMER_STAFF_ID;
            branchDetailsType.salesStaffName = GEN_OriginationsConstants.CUSTOMER_STAFF_NAME;
        }

        return branchDetailsType;
        
    }
    
    /* Description: Method that maps values into PersonalReferenceDataCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-13-2014
    *  Input Parameters: referenceList - List of personal reference check records
    *  Return: ConsumerAnzCapitalGeComOriginations.PersonalReferenceDataCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.PersonalReferenceDataCollection generatePersonalReferenceDataCollection(List<Personal_Reference_Check__c> referenceList) { 
        
        ConsumerAnzCapitalGeComOriginations.PersonalReferenceDataCollection personalReferenceDataCollection = new ConsumerAnzCapitalGeComOriginations.PersonalReferenceDataCollection();
        
        List<ConsumerAnzCapitalGeComOriginations.PersonalReferenceData> personalReferenceDataList = new List<ConsumerAnzCapitalGeComOriginations.PersonalReferenceData>();
        for(Personal_Reference_Check__c prc: referenceList) {
            ConsumerAnzCapitalGeComOriginations.PersonalReferenceData prd = new ConsumerAnzCapitalGeComOriginations.PersonalReferenceData();
            prd.name = prc.Name__c;
            //prd.address = prc.Personal_Ref_Address__c;
            prd.phoneNumber = prc.Phone_Number__c;
            prd.relationship = prc.Relationship__c;
            prd.address = generateAddress(prc.Property_Name__c,
                                                                 prc.unit_Number__c, 
                                                                 prc.Street_Number__c, 
                                                                 prc.Street_Name__c, 
                                                                 prc.Street_Type__c, 
                                                                 prc.Suburb__c, 
                                                                 prc.Postcode__c,
                                                                 prc.State__c,
                                                                 prc.Country__c,
                                                                 prc.Town_City__c,
                                                                 '', ''
                                                                 ); 
            
            personalReferenceDataList.add(prd);
        }
        
        personalReferenceDataCollection.personalReferenceData = personalReferenceDataList;
        
        return personalReferenceDataCollection;
        
    }
    
    /* Description: Method that maps values into Case_x WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: owner -
                         contact - 
                         product -
                         productArrangement - 
                         note -
    *  Return: caseModelServicingGeCom20.Case_x
    */
    public static caseModelServicingGeCom20.Case_x generateCasex(CommonModelServicingGeCom.User_x owner, 
                                                                 ContactModelServicingGeCom.Contact[] contact, 
                                                                 ProductModelServicingGeCom.Product[] product,
                                                                 CaseModelServicingGeCom20.ProductArrangement[] productArrangement,
                                                                 CommonModelServicingGeCom.Note[] note) { 
        
        CaseModelServicingGeCom20.Case_x caseX = new CaseModelServicingGeCom20.Case_x();
        caseX.owner = owner;
        caseX.contact = contact;
        caseX.product = product;
        caseX.productArrangement = productArrangement;
        caseX.note = note;
        return caseX;
        
    }
    
    /* Description: Method that maps values into User_x WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: name -
                         sso - 
    *  Return: commonModelServicingGeCom.User_x
    */
    public static commonModelServicingGeCom.User_x generateUserx(User appOwner, Application__c application) { // May-05-2016- Afreen - chnaging the signature to include the application
        CommonModelServicingGeCom.User_x userX = new CommonModelServicingGeCom.User_x();
        //assign default user value
        userX.sso = GEN_OriginationsConstants.CUSTOMER_STAFF_ID;
        userX.name = GEN_OriginationsConstants.CUSTOMER_STAFF_NAME;
    // May-05-2016- Afreen - assigning the default values when application is broker
        if(application != null && ((application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER) || (application.Broker__c !=null))){
          userX.sso = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_ID;
          userX.name = GEN_OriginationsConstants.BROKER_CUSTOMER_STAFF_NAME;
        }
        //assign value if user and sso is present
        if(appOwner!=null) {
            if(appOwner.SSO_Number__c!=null) {
                            userX.sso = appOwner.SSO_Number__c;
            }
            userX.name  = appOwner.Name;
        }
        return userX;    
    }
    
    /* Description: Method that maps values into CodeName WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: typeCode -
                         displayName - 
    *  Return: commonModelServicingGeCom.CodeName
    */
    public static commonModelServicingGeCom.CodeName generateCodeName (String typeCode, String displayName) { 
        commonModelServicingGeCom.CodeName codeName = new commonModelServicingGeCom.CodeName();
        codeName.typeCode = typeCode;
        codeName.displayName = displayName;
        return codeName;
    }
    
    /* Description: Method that maps values into Note WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Id -
                         userName - 
                         userSSO - 
                         createdTime - 
                         message - 
                         category - 
                         typeCode - 
                         typeName - 
    *  Return: CommonModelServicingGeCom.Note
    */
    public static CommonModelServicingGeCom.Note generateNote(String Id, String userName, String userSSO, DateTime createdTime, 
                                                              String[] message, String category, String typeCode, String typeName) {
    
        CommonModelServicingGeCom.Note note = new CommonModelServicingGeCom.Note();
        note.Id = id;
        note.createdTime = createdTime;
        note.message = message;
        note.category = category; //posibble values: contact, contract, case, document, auditing
        note.type_x = generateCodeName(typeCode, typeName);
        
        return note;
    
    }
    
    /* Description: Method that maps values into Variable WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Id -
                         name - 
                         value - 
                         type_x - 
                         typeData - 
                         mandatory- 
    *  Return: CommonModelServicingGeCom.Variable 
    */
    public static CommonModelServicingGeCom.Variable generateVariable(String id, String name, String value, 
                                                                      String type_x, String typeData, Boolean mandatory) {
        CommonModelServicingGeCom.Variable variable = new CommonModelServicingGeCom.Variable();
        variable.id = id; 
        variable.name = name;
        variable.value = value;
        variable.type_x = type_x;
        variable.typeData = typeData;
        variable.mandatory = mandatory;
        return variable;
    }
    
    /* Description: Method that maps values into Product WSobject
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Id -
                         name - 
                         value - 
                         type_x - 
                         typeData - 
                         mandatory- 
    *  Return: productModelServicingGeCom.Product
    */
    public static productModelServicingGeCom.Product generateProduct(GEProduct__c product) {
        productModelServicingGeCom.Product commProduct = new productModelServicingGeCom.Product();
        commProduct.id = product.id; 
        commProduct.type_x = product.type__c;
        commProduct.name = product.Product_Name__c;
        commProduct.description = product.Description__c;
        
        List<CommonModelServicingGeCom.Variable> attributeList = new List<CommonModelServicingGeCom.Variable>();
        attributeList.add(generateVariable('', '', '', '', '', false)); 
        commProduct.attribute = attributeList;
        
        List<CommonModelServicingGeCom.CodeName> relationShipList = new List<CommonModelServicingGeCom.CodeName>();
        relationShipList.add(generateCodeName('', ''));
        commProduct.relationship = relationShipList;
        return commProduct;
    }
    
    /* Description: Method that maps values into CaseModelServicingGeCom20.ProductArrangement
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: String id -
                         SalesModelServicingGeCom.SalesDialog salesDialog -
                         DateTime createdTime -
                         DateTime lastUpdatedTime -
                         String salesContext -
                         String channel -
                         ProductModelServicingGeCom.Product product -
                         ApplicationModelServicingGeCom.Application application -
                         ContractModelServicingGeCom.Contract contract -
                         CaseModelServicingGeCom20.ProductArrangementRole[] productArrangementRole -
                         String state -
                         String caseId -
    *  Return: CaseModelServicingGeCom20.ProductArrangement
    */
    public static CaseModelServicingGeCom20.ProductArrangement generateProductArrangement(String id,
                                                                                          SalesModelServicingGeCom.SalesDialog salesDialog,
                                                                                          DateTime createdTime,
                                                                                          DateTime lastUpdatedTime,
                                                                                          String salesContext,
                                                                                          String channel,
                                                                                          ProductModelServicingGeCom.Product product,
                                                                                          ApplicationModelServicingGeCom.Application application,
                                                                                          ContractModelServicingGeCom.Contract contract,
                                                                                          CaseModelServicingGeCom20.ProductArrangementRole[] productArrangementRole,
                                                                                          String state,
                                                                                          String caseId){
        CaseModelServicingGeCom20.ProductArrangement productArrangement = new CaseModelServicingGeCom20.ProductArrangement();
        productArrangement.id = id; 
        productArrangement.salesDialog = salesDialog;
        productArrangement.createdTime = createdTime; 
        productArrangement.lastUpdatedTime = lastUpdatedTime; 
        productArrangement.salesContext = salesContext;  
        productArrangement.channel = channel; 
        productArrangement.product = product;
        productArrangement.application = application;
        productArrangement.contract = contract;
        productArrangement.productArrangementRole = productArrangementRole ;
        return productArrangement;
    }
    
    /* Description: Method that maps values into Application
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: id-
                         createdTime- 
                         accountNumber- 
                         caseId -
    *  Return: ApplicationModelServicingGeCom.Application
    */
    public static ApplicationModelServicingGeCom.Application generateApplication(String id, 
                                                                                 DateTime createdTime, 
                                                                                 String accountNumber, 
                                                                                 String caseId) {
        ApplicationModelServicingGeCom.Application application = new ApplicationModelServicingGeCom.Application();
        application.id = id;
        application.createdTime = createdTime;
        application.accountNumber = accountNumber;
        application.caseId = caseId;
        return application;
    }
    
    /* Description: Method that maps values into Contract 
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: id-
    *  Return: ContractModelServicingGeCom.Contract
    */
    public static ContractModelServicingGeCom.Contract generateContract(String id) {
        ContractModelServicingGeCom.Contract contract = new ContractModelServicingGeCom.Contract();
        contract.id = id;
        return contract;
    }
    
    /* Description: Method that maps values into SalesModelServicingGeCom.SalesDialog
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: id-
    *  Return: SalesModelServicingGeCom.SalesDialog
    */
    public static SalesModelServicingGeCom.SalesDialog generateSalesDialog(String id, 
                                                                           SalesModelServicingGeCom.SalesDialogInput[] salesDialogInput,
                                                                           ProductModelServicingGeCom.Product[] product) {
        SalesModelServicingGeCom.SalesDialog salesDialog = new SalesModelServicingGeCom.SalesDialog();
        salesDialog.id = id;
        salesDialog.salesDialogInput = salesDialogInput;
        salesDialog.product = product;
        return salesDialog ;
    }

    /* Description: Method that maps values into SalesDialogInput; used for Loan Purpose mapping
    *  Author: Dan Crisologo
    *  Date Created: 10-09-13
    *  Input Parameters: Id -
                         status - 
                         prompt- 
                         value - 
                         type_x -
    *  Return: SalesModelServicingGeCom.SalesDialogInput
    */
    public static SalesModelServicingGeCom.SalesDialogInput generateSalesDialogInput(String Id, String status, String prompt, String value, String type_x) {
        SalesModelServicingGeCom.SalesDialogInput salesDialogInput = new SalesModelServicingGeCom.SalesDialogInput();
        salesDialogInput.id = id;
        salesDialogInput.status = status; //where to map the status?
        salesDialogInput.prompt = prompt;
        salesDialogInput.value = new String[] {value};
        salesDialogInput.type_x = type_x;
        return salesDialogInput;
    }
    
    /* Description: Method that maps values into SalesDialogInput; used for other ONRs mapping
    *  Author: Dan Crisologo
    *  Date Created: 10-25-13
    *  Input Parameters: onr, 
                         status,
                         attribute,
                         salesDialogInputs
    *  Return: SalesModelServicingGeCom.SalesDialogInput
    */
    public static SalesModelServicingGeCom.SalesDialogInput generateSalesDialogInput(ONR__C onr, 
                                                                                     String status,
                                                                                     CommonModelServicingGeCom.Variable[] attribute,
                                                                                     SalesModelServicingGeCom.SalesDialogInput[] salesDialogInputs) {
        SalesModelServicingGeCom.SalesDialogInput salesDialogInput = new SalesModelServicingGeCom.SalesDialogInput();
        salesDialogInput.id = onr.geID__c;
        salesDialogInput.status = status;
        salesDialogInput.prompt = onr.prompt__c;
        salesDialogInput.value = new String[] {onr.value__c};
        salesDialogInput.type_x = onr.type__c;
        salesDialogInput.salesDialogInputs = salesDialogInputs;
        return salesDialogInput;
    }
    
    /* Description: Method that maps values into ApplicationDataType
    *  Author: Dan Crisologo
    *  Date Created: 11-08-13
    *  Input Parameters: sfApplicationId, 
                         applicationId,
                         intent,
                         reason
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationDataType
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicationDataType generateApplicationDataType(String sfApplicationId,
                                                                                                   String applicationId,
                                                                                                   String intent,
                                                                                                   String reason) {
                                                                                                   
        ConsumerAnzCapitalGeComOriginations.ApplicationDataType applicationDataType = new ConsumerAnzCapitalGeComOriginations.ApplicationDataType();
        applicationDataType.sfApplicationId = sfApplicationId;
        applicationDataType.applicationId = applicationId;
        applicationDataType.intent = intent;
        applicationDataType.reason = reason;
        return applicationDataType;
    }
    
    /* Description: Method that maps values into ApplicationCpuOverrideDataType 
    *  Author: Dan Crisologo
    *  Date Created: 12-17-13
    *  Input Parameters: minSecuredOverrideAmount, 
                         maxSecuredOverrideAmount,
                         sfOverrideCode,
                         workflowStatusCode
    *  Return: ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType 
    */
    public static ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType generateApplicationCpuOverrideDataType(Application__C app) {
                                                                                                   
        ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType applicationCpuOverrideDataType = new ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType ();
        applicationCpuOverrideDataType.maxUnSecuredOverrideAmount = app.Max_Capacity_Unsecured_Risk__c;
        applicationCpuOverrideDataType.maxSecuredOverrideAmount = app.Max_Capacity_Secured_Risk__c;
        applicationCpuOverrideDataType.sfOverrideCode = app.Response_Code_Override__c;
        return applicationCpuOverrideDataType;
    }

    /* Description: Method that maps values into decisionData 
    *  Author: Sandeep Gali
    *  Date Created: 20-01-15
    *  Return: ConsumerAnzCapitalGeComOriginations.decisionData 
    */
    public static ConsumerAnzCapitalGeComOriginations.decisionDataType generateDecisionDataType(Application__C app) {
       Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
       ConsumerAnzCapitalGeComOriginations.decisionDataType decisionData = new ConsumerAnzCapitalGeComOriginations.decisionDataType ();  
    if(app.Brand_Country__c == 'AU'){
         Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);                                                                                    
           //Added Deferred period to the loan term for Better PL - Added by Suneel - 13/11/2019       
        if((app.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
            Integer actualTerm = Integer.valueOf(app.Loan_Term_Months__c);
            decisionData.setUpLoanTerm = actualTerm + lterm;
        }else{         
            decisionData.setUpLoanTerm = Integer.valueOf(app.Loan_Term_Months__c);
        }
        decisionData.setUpLoanAmount = app.Total_Loan_Amount_with_Insurance__c;
    } 
    else if(app.Brand_Country__c == 'NZ'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);                                                                                   
           //Added Deferred period to the loan term for Better PL - Added by Suneel - 13/11/2019       
        if((app.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false)){
            Integer actualTerm = Integer.valueOf(app.Loan_Term_Months__c);
            decisionData.setUpLoanTerm = actualTerm + lterm;
        }else{         
            decisionData.setUpLoanTerm = Integer.valueOf(app.Loan_Term_Months__c);
        }
        decisionData.setUpLoanAmount = app.Total_Loan_Amount_with_Insurance__c; 
    }   
        return decisionData;
    }
    
    /* Description: Method that maps values into collateralCollection
    *  Author: Dan Crisologo
    *  Date Created: 12-17-13
    *  Input Parameters: collateralList
    *  Return: ConsumerAnzCapitalGeComOriginations.collateralCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.collateralCollection generateCollateralCollection(List<Collateral__c> collateralList, Application__c app) {
                                                                                                   
        ConsumerAnzCapitalGeComOriginations.CollateralCollection collateralCollection = new ConsumerAnzCapitalGeComOriginations.CollateralCollection();
        Decimal registrationFee = 0;
        Decimal searchFee = 0;
        if(collateralList!=null) {
            if(collateralList.size()>0) {
                if(app.Offered_PPSR_Registration_Fee__c!=null) {
                    registrationFee = app.Offered_PPSR_Registration_Fee__c/collateralList.size();
                }
                if(app.Offered_PPSR_Search_Fee__c!=null) {
                    searchFee = app.Offered_PPSR_Search_Fee__c/collateralList.size();
                }
            }
        }
    
        List<ConsumerAnzCapitalGeComOriginations.CollateralDetailsType> collateralDetailsList = new List<ConsumerAnzCapitalGeComOriginations.CollateralDetailsType>();
        for(Collateral__c c: collateralList) {
            ConsumerAnzCapitalGeComOriginations.CollateralDetailsType collateralDetail = new ConsumerAnzCapitalGeComOriginations.CollateralDetailsType();
            collateralDetail.ppsrSearchFee = searchFee;
            collateralDetail.ppsrRegistrationFee = registrationFee;
            collateralDetail.ppsrRegistrationNumber = c.PPSR_Reference_Number_1__c;
            collateralDetail.vinNumber = formatData(c.Collateral_VIN_No__c);
            collateralDetail.engineNumber = formatData(c.Collateral_Eng_No__c);
            collateralDetail.year = c.Collateral_Year__c!=null? Integer.valueOf(c.Collateral_Year__c) : 0;
            collateralDetail.model = formatData(c.Collateral_Model__c);
            collateralDetail.value = c.Collateral_Val__c;
            collateralDetail.bodyType = c.Collateral_Body_Type_Code__c;
            collateralDetail.registrationNumber = c.Collateral_Reg_No__c;
            collateralDetail.registrationState = c.Collateral_State_of_Registration_Code__c;
            collateralDetail.insuranceExpiryDate = c.Collateral_Insurance_expiry_date__c;
            collateralDetail.dateValued = c.Collateral_Date_Valued__c;
            collateralDetail.insurancePolicyNumber = c.Collateral_Insurance_Policy_number__c;
            collateralDetail.insuranceCompanyName = formatData(c.Collateral_Insurance_company_name__c);
            collateralDetail.nvic = c.Collateral_NVIC__c;
            collateralDetail.collateralType = c.Collateral_Type_Code__c;
            collateralDetail.owner = c.Collateral_Owner__c;
            
            //collateral make - use formula fields, check if at least one of the formula fields matches the collateral make.
            if(c.Collateral_Make__c!=null) {
                if(c.Collateral_Make_Code__c!=null && c.Collateral_Make_Code__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code__c;
                } else if(c.Collateral_Make_Code_2__c!=null && c.Collateral_Make_Code_2__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_2__c;
                } else if(c.Collateral_Make_Code_3__c!=null && c.Collateral_Make_Code_3__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_3__c;
                } else if(c.Collateral_Make_Code_4__c!=null && c.Collateral_Make_Code_4__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_4__c;
                } else if(c.Collateral_Make_Code_5__c!=null && c.Collateral_Make_Code_5__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_5__c;
                } else if(c.Collateral_Make_Code_6__c!=null && c.Collateral_Make_Code_6__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_6__c;
                } else if(c.Collateral_Make_Code_7__c!=null && c.Collateral_Make_Code_7__c!='') {
                    collateralDetail.collateralMake = c.Collateral_Make_Code_7__c;
                } 
            }
    
            collateralDetailsList.add(collateralDetail);
        }
        collateralCollection.collateral = collateralDetailsList;
        return collateralCollection;
        
    }
    
    /* Description: Method that maps values into BrokerDetailsType
    *  Author: Dan Crisologo
    *  Date Created: 12-17-13
    *  Input Parameters: Contact broker
    *  Return: ConsumerAnzCapitalGeComOriginations.BrokerDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.BrokerDetailsType generateBrokerDetailsType(Contact broker, Application__c application) {
                                                                                                  
        ConsumerAnzCapitalGeComOriginations.BrokerDetailsType brokerDetails = new ConsumerAnzCapitalGeComOriginations.BrokerDetailsType();
        
        brokerDetails.sfBrokerId = formatData(broker.Broker_ID__c, true);
        brokerDetails.firstName = formatData(broker.firstName, true);
        brokerDetails.lastName = formatData(broker.lastName, true);
        brokerDetails.accountName = formatData(broker.account.Name);
        brokerDetails.entityName = formatData(broker.account.Trust_Entity_Name__c);
        brokerDetails.aggregatorAccountName = formatData(broker.account.Aggregator_Account_Name__c);
        brokerDetails.suburb = broker.MailingCity;
        brokerDetails.state = broker.MailingState;
        brokerDetails.postCode = broker.MailingPostalCode;
        brokerDetails.landlineNumber = broker.Phone;
        brokerDetails.mobileNumber = broker.MobilePhone;
        brokerDetails.accreditationStatus = formatData(broker.Contact_Accreditation_Status__c, true);
        brokerDetails.fee = roundOffAmount(application.Brokerage_Fee__c);
        return brokerDetails;
    }
    
    /* Description: Method that maps values into OfferDetailsType (DBHZL -55)
    *  Author: Fel Saliba
    *  Date Created: 12-02-14
    *  Input Parameters: Application
    *  Return: ConsumerAnzCapitalGeComOriginations.OfferDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.OfferDetailsType generateOfferDetailsType(Application__c application) {
                                                                                                  
        ConsumerAnzCapitalGeComOriginations.OfferDetailsType offerDetails = new ConsumerAnzCapitalGeComOriginations.OfferDetailsType();
        offerDetails.promotionalCampaign = application.Promotional_Campaign_Code__c;
        offerDetails.existingAccountNumber = application.ICBS_Account_Number__c;
        offerDetails.riskGrade = application.Credit_Score__c;
        
        if(application.Previous_App_No__c != null){
          offerDetails.PreviousApplicationNumber = application.Previous_App_No__c;
        }

        if(application.Initial_Submit_Date__c != null){
            offerDetails.initialSubmitDate = application.Initial_Submit_Date__c.date();
        }
        if(application.Promo_Loan_Offer_Amount__c == null){
            offerDetails.promoLoanOfferAmount = 0;
        } else {
            offerDetails.promoLoanOfferAmount = application.Promo_Loan_Offer_Amount__c;
        }
        
        //BEGIN MLASALA 19-SEPT-16 TQLQW-487 Promo engine
        if(application.Promo_ID__c != null && 
           application.Promotional_Campaign_Code__c == '4'){
            offerDetails.promoId = application.Promo_ID__c;
        }
        //END MLASALA 19-SEPT-16 TQLQW-487 Promo engine
        
        return offerDetails;
    }

    /* Description: Method that maps values into DisbursementCollection
    *  Author: Dan Crisologo
    *  Date Created: 12-17-13
    *  Input Parameters: List<Disbursement__c> disbursements
    *  Return: ConsumerAnzCapitalGeComOriginations.DisbursementCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.DisbursementCollection generateDisbursementCollection(List<Disbursement__c> disbursements) {
                                                                                                  
        System.debug('Enter the Disbursement Dragon');
        ConsumerAnzCapitalGeComOriginations.DisbursementCollection disbursementCollection = new ConsumerAnzCapitalGeComOriginations.DisbursementCollection();
        List<ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType> disbursementDetailsTypes = new List<ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType>();
        for(Disbursement__c d: disbursements) {
            ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType disbursementDetail = new ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType();
            disbursementDetail.disbursementType = d.Disbursement_Type_Code__c;
            disbursementDetail.payee = 'Unknown'; //Set payee to unknown by default, this is a required field.
            if(d.Payee__c!=null) {
                disbursementDetail.payee = d.Payee__c;
            }
            /* Description: Map Payee value to Biller Short Name for BPAY (Cheque Disbursement Removal) 
            *  Author: Suneel Desiraju
            *  Date Created:  26/12/2017          
            */
            if(d.Disbursement_Type_Code__c == '004') {
                //disbursementDetail.payee = d.Biller_Short_Name__c;
                disbursementDetail.payee = d.BillerShortName__c;
            }
            /* End */
            disbursementDetail.amount = formatData(roundOffAmount(d.Amount__c));
            disbursementDetail.bsbNumber = d.BSB__c;
            disbursementDetail.accountNumber = d.Bank_Acc_No__c;
            /* Description:Mapping BillerCode and BillerName to LFS - Cheque Disbursement Removal
            *  Author: Suneel Desiraju
            *  Date Created:  26/12/2017          
            */
            /*disbursementDetail.billerCode = d.Biller_Code__r.Name;
            disbursementDetail.billerName = d.Biller_Short_Name__c;*/
            disbursementDetail.billerCode = d.BillerCode__c;
            disbursementDetail.billerName = d.BillerShortName__c;
            /* End */
            if(d.Card_Number_or_3rd_Party_Ref__c != null && d.Reference__c == null){          
              disbursementDetail.reference = d.Card_Number_or_3rd_Party_Ref__c;
            }else{
              disbursementDetail.reference = d.Reference__c;
            }
            disbursementDetail.accountSuffix = d.Suffix_Number__c;
            disbursementDetail.bankName = d.Bank_Name__c;
            disbursementDetail.branchName = d.Branch_Name__c; 
            
                       
             disbursementDetailsTypes.add(disbursementDetail);
        }    
        //BEGIN Suneel: 03-May-18 Map Rebate Amout to DP and Activate - Disbursement Plan
            //Get Application Id
            Id appId = ApexPages.currentPage().getParameters().get('id');
            for(Disbursement__c d: [select Amount__c,(select Disbursement__r.Total_Rebate_Amount__c,Disbursement_Type_Plan_Code__c,Rebate_Amount__c from Disbursement_Plans__r),Disbursement_Type_Code__c,BillerCode__c,BillerShortName__c,Card_Number_or_3rd_Party_Ref__c,Reference__c from Disbursement__c where Application__c = :appId])
            {   
             for(Disbursement_Plan__c dp:d.Disbursement_Plans__r){
              ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType disbursementDetail = new ConsumerAnzCapitalGeComOriginations.DisbursementDetailsType();
              disbursementDetail.disbursementType = dp.Disbursement_Type_Plan_Code__c;
              //disbursementDetail.amount = dp.Rebate_Amount__c;
              disbursementDetail.amount = dp.Disbursement__r.Total_Rebate_Amount__c;              
              disbursementDetail.billerCode = d.BillerCode__c;
              disbursementDetail.billerName = d.BillerShortName__c;
               if(d.Card_Number_or_3rd_Party_Ref__c != null && d.Reference__c == null){          
                  disbursementDetail.reference = d.Card_Number_or_3rd_Party_Ref__c;
               }else{
                  disbursementDetail.reference = d.Reference__c;
                    }
               if(d.Disbursement_Type_Code__c == '004') {
               //disbursementDetail.payee = d.Biller_Short_Name__c;
                 disbursementDetail.payee = d.BillerShortName__c;
            } 
              //End              
                disbursementDetailsTypes.add(disbursementDetail);
                break;
                } 
            }        
        System.debug('++++++++++++Disbursement Detail Types++++++++++++++'+disbursementDetailsTypes);             
        disbursementCollection.disbursement = disbursementDetailsTypes;
        return disbursementCollection;
    }

    /* Description: Method that maps values into AMLApplicantsCollection
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: amlList
    *  Return: ConsumerAnzCapitalGeComOriginations.AMLApplicantsCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.AmlApplicantsCollection generateAMLApplicantsCollection(List<AML__c> amlList, List<AML__c> amlList2) {
        system.debug('aml list: '+amlList+'--'+amlList2);                                                                            
        ConsumerAnzCapitalGeComOriginations.AMLApplicantsCollection applicantsCollection = new ConsumerAnzCapitalGeComOriginations.AMLApplicantsCollection();
        List<ConsumerAnzCapitalGeComOriginations.amlApplicantType> applicantType = new List<ConsumerAnzCapitalGeComOriginations.amlApplicantType>();
        if(amlList!=null) {
            if(!amlList.isEmpty()) {
                applicantType.add(generateAmlApplicantType(amlList));
            }
        }
        if(amlList2!=null) {
            if(!amlList2.isEmpty()) {
                applicantType.add(generateAmlApplicantType(amlList2));
            }
        }
        if(applicantType.size() > 0){
          applicantsCollection.applicant = applicantType;
        }
        return applicantsCollection;
    }
    
    /* Description: Method that maps values into AmlApplicantType
    *  Author: Dan Crisologo
    *  Date Created: 01-06-14
    *  Input Parameters: amlList
    *  Return: ConsumerAnzCapitalGeComOriginations.AmlApplicantType
    */
    public static ConsumerAnzCapitalGeComOriginations.AmlApplicantType generateAmlApplicantType(List<AML__c> amlList) {                                                                                     
        system.debug('aml list: '+amlList);
        ConsumerAnzCapitalGeComOriginations.AmlApplicantType applicantType = new ConsumerAnzCapitalGeComOriginations.amlApplicantType();
        List<ConsumerAnzCapitalGeComOriginations.IdDetail> identifications = new List<ConsumerAnzCapitalGeComOriginations.IdDetail>();
        List<ConsumerAnzCapitalGeComOriginations.POADetail> proofofaddress = new List<ConsumerAnzCapitalGeComOriginations.POADetail>();
        String preSubmitIdentification = '';
        Boolean isDedup = false;
        Integer dedupCounter = 0;
        
        //Mike Lasala: Iterate over AML list and identify pre submit identification
        //for(AML__c a: amlList){
        //    if(a.Id_Sequence_No__c == 0){
        //        preSubmitIdentification = a.Identification__c;
        //        break;
        //    }
        //    dedupCounter++;
        //}
        
        ////Mike Lasala: Iterate over AML list and identify if pre submit identification has duplicate on post submit records
        //for(AML__c a: amlList){
        //    if(a.Identification__c == preSubmitIdentification && 
        //       a.Id_Sequence_No__c != 0 &&
        //       a.Verified_Flag__c){
        //        isDedup = true;
        //    }
        //}

        ////Mike Lasala: Remove duplicate pre submit identification record
        //if(isDedup){
        //    amlList.remove(dedupCounter);
        //}

        Set<Id> setVar = new Set<Id>();

        Boolean isNZ = true;
        Boolean hasElectronic = false;
        AML__c elecAML;
        
        for(AML__c a: amlList){
            if(a.Id_Sequence_No__c > 0){
                isNZ = false;
                break;
            }

            setVar.add(a.Applicant__c);
            
            // Check if there is at least on Electronic AML
            if(a.AML_Pos_Verified_Type__c == 'Electronic'){
              hasElectronic = true;
                elecAML = a;
            }
        }
        
        // Pull applicant information related to AML - added by Adrian Recio for Green Id Story
        Map<Id,Applicant__c> amlUserMap = new Map<Id, Applicant__c>([Select Id, GreenId_Outcome__c from Applicant__c where Id In :setVar]);
        Applicant__c appVar;
        String outcomeVal;
        
        if(elecAML!=null){
          appVar = amlUserMap.get(elecAML.Applicant__c);
        }

        if(appVar!=null){
            outcomeVal = appVar.GreenId_Outcome__c;
        }   
        
        // If applicant has electronic AML, bypass other AML values and use it as priority
        if(hasElectronic && (outcomeVal == 'VERIFIED' || outcomeVal == 'VERIFIED_WITH_CHANGES' || outcomeVal == 'VERIFIED_ADMIN')){
            // Populate Green Id outcome if type is Electronic - added by Adrian Recio for Green Id Story
            if(elecAML.AML_Pos_Verified_Type__c == 'Electronic'){
              if(amlUserMap.get(elecAML.Applicant__c)!=null){
                applicantType.GreenIdOutcome = appVar.GreenId_Outcome__c;
                applicantType.verificationMethod = elecAML.AML_Pos_Verified_Type_Code__c;
                applicantType.sfApplicantId = elecAML.Applicant__c;
                applicantType.dateVerified = elecAML.Date_Verified__c;
                //applicantType.iDSightedBy = elecAML.Staff_ID_Sighted_By__c;
                //applicantType.staffIDSSO = elecAML.Staff_ID_SSO__c;
                
                // Create Empty Id Details
                ConsumerAnzCapitalGeComOriginations.IdDetail idDetail = new ConsumerAnzCapitalGeComOriginations.IdDetail();
                identifications.add(idDetail);
                applicantType.identifications = identifications;
              }
            }
        }else{
        
            for(AML__c a: amlList) {
                // Make electronic AML is not included in Proof Identity AML verification
                if(a.Identification__c != null && a.AML_Pos_Verified_Type__c != 'Electronic'){
    
                    ConsumerAnzCapitalGeComOriginations.IdDetail idDetail;
                    //2015-02-11 Tony Xu Fix the multiple ID sent issue
                    if(a.Identification__c != null){
                        idDetail = generateIdDetail(a);
                    }
                        
                     //NZ Localization of DBHZL-33 to set it for pre submit identification as well.
                      if(a.Id_Sequence_No__c == 0){
                            applicantType.sfApplicantId = a.Applicant__c;
                            applicantType.dateVerified = date.today();
                      }
          
                      //populate other applicant type field for sequence 1 aml entery
                      if((!isNZ && a.Id_Sequence_No__c == 1) || 
                           isNZ && a.Id_Sequence_No__c == 0 && 
                            (a.Identification__c != GEN_OriginationsConstants.AML_IDENTIFICATION_TYPE_SUPERGOLD && 
                            a.Verified_Flag__c)){
                          
                            applicantType.iDSightedBy = a.Staff_ID_Sighted_By__c;
                            applicantType.staffIDSSO = a.Staff_ID_SSO__c;
                            applicantType.dateVerified = a.Date_Verified__c;
                            applicantType.sfApplicantId = a.Applicant__c;
                
                            if(a.Verified_Flag__c){
                                applicantType.verificationMethod = a.AML_Pos_Verified_Type_Code__c;
                            }
                      }
                      identifications.add(idDetail);
                }
    
                if(a.POA_Provided_Flag__c && a.POA_Type__c != null){
                
                    ConsumerAnzCapitalGeComOriginations.POADetail poaDetail = generatepoaDetail(a);
                    proofofaddress.add(poaDetail);
                    applicantType.poadata = proofofaddress;
                }
            }
            
            if(identifications.size() > 0)
              applicantType.identifications = identifications;
        }// End Else
        
        return applicantType;
    }
    
    /* Description: Method that maps values into poaDetail
    *  Author: Mike lasala
    *  Date Created: 12-11-14
    *  Input Parameters: aml
    *  Return: ConsumerAnzCapitalGeComOriginations.POADetail
    */
    public static ConsumerAnzCapitalGeComOriginations.POADetail generatepoaDetail(AML__c aml) {
        ConsumerAnzCapitalGeComOriginations.POADetail poaDetail = new ConsumerAnzCapitalGeComOriginations.POADetail();
        poaDetail.poaType = aml.POA_Type_Code__c;
        
        if(aml.POA_Reference_Number__c != null) {
            poaDetail.poaReferenceNo = aml.POA_Reference_Number__c;
        }
        
        if(aml.POA_Issue_Date__c != null) {
            poaDetail.poaIssueDate = aml.POA_Issue_Date__c;
        }
        
        if(aml.ID_Issuer__c != null) {
            poaDetail.poaIssuer = aml.ID_Issuer__c;
        }
        
        poaDetail.poaProvidedFlag = aml.POA_Provided_Flag__c;
        
        return poaDetail;
    }

    /* Description: Method that maps values into IdDetail
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: aml
    *  Return: ConsumerAnzCapitalGeComOriginations.IdDetail
    */
    public static ConsumerAnzCapitalGeComOriginations.IdDetail generateIdDetail(AML__c aml) {
                                                                                                   
        ConsumerAnzCapitalGeComOriginations.IDDetail idDetail = new ConsumerAnzCapitalGeComOriginations.IDDetail();
        idDetail.identificationType = aml.Identification_Code__c;
        idDetail.iDNo = aml.ID_No__c;
        idDetail.amlVerifiedFlag = aml.Verified_Flag__c;

        if(aml.Version__c != null) {
            idDetail.version = aml.Version__c;
        }
        
        if(aml.NZ_Residency_Number__c != null) {
            idDetail.residencyNumber = aml.NZ_Residency_Number__c;
        }

        if(aml.ID_Issue_Date__c!=null) {
            idDetail.issueDate = aml.ID_Issue_Date__c;
        }
        if(aml.ID_Expiry_Date__c!=null) {
            idDetail.expiryDate = aml.ID_Expiry_Date__c;
        }
        if(aml.ID_Expiry_State__c!=null) {
            idDetail.issueState = aml.ID_Expiry_State__c;
        }
        if(aml.Issue_Country__c!=null) {
            idDetail.issueCountry = aml.Issue_Country__c;
        }
        if(aml.ID_Issuer__c!=null) {
            idDetail.issuer = aml.ID_Issuer__c;
        }

        
        return idDetail;
        
    }
    
    /* Description: Method that maps values into insuranceDetailsType
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: productItems
    *  Return: ConsumerAnzCapitalGeComOriginations.insuranceDetailsType
    */
    public static ConsumerAnzCapitalGeComOriginations.InsuranceCollection generateInsuranceCollection(List<Product_Item__c> productItems) {
        ConsumerAnzCapitalGeComOriginations.InsuranceCollection insuranceCollection = new ConsumerAnzCapitalGeComOriginations.InsuranceCollection();
        List<ConsumerAnzCapitalGeComOriginations.InsuranceDetailsType> insuranceDetailsType = new List<ConsumerAnzCapitalGeComOriginations.InsuranceDetailsType>();
        
        //Integer sequenceCounter = 1;
        for(Product_Item__c pi: productItems) {
            ConsumerAnzCapitalGeComOriginations.InsuranceDetailsType insuranceDetails = new ConsumerAnzCapitalGeComOriginations.InsuranceDetailsType();
            //set default values
            insuranceDetails.dealerCIFKey = ''; //no need to map. always blank
            insuranceDetails.officerNum = '0'; //no need to map. always 0
            insuranceDetails.policyNum = '0'; //no need to map. always 0
            insuranceDetails.policyType = (pi.Policy_Type__c!=null) ? String.valueOf(pi.Policy_Type__c) : '';
            insuranceDetails.insTerm = (pi.Ins_Term__c!=null) ? String.valueOf(pi.Ins_Term__c) : '';
            //insuranceDetails.policySeqNum = sequenceCounter;
            if(pi.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
              insuranceDetails.policySeqNum = 1;
            }
            else if(pi.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
              insuranceDetails.policySeqNum = 2;
            }
            else if(pi.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
              insuranceDetails.policySeqNum = 3;
            }
            insuranceDetails.insProdTypeNum = 0;
            if(pi.Product_Version__r.GEProduct__r.Insurance_Type_Num__c!=null) {
                insuranceDetails.insProdTypeNum = (long)pi.Product_Version__r.GEProduct__r.Insurance_Type_Num__c;
            }
            insuranceDetails.fixedPremiumAmt = formatData(pi.Fixed_Premium_Amount__c);
            insuranceDetails.coverAmt = formatData(pi.Cover_Amount_Formula__c);
            insuranceDetails.insGST = formatData(pi.Insurance_GST__c);
            insuranceDetails.insStampDuty = formatData(pi.Insurance_Stamp_Duty_Amount__c);
            //sequenceCounter++;
            insuranceDetailsType.add(insuranceDetails);
        }
        insuranceCollection.applicationInsurance = insuranceDetailsType;
        return insuranceCollection;
    }   

    /* Description: Method that maps values into POIApplicantsCollection
    *  Author: Dan Crisologo
    *  Date Created: 12-20-13
    *  Input Parameters: Applicant
    *  Return: ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection generatePOIApplicantsCollection(
                                                                                                            Applicant__c applicant1, 
                                                                                                            Applicant__c applicant2, 
                                                                                                            List<Income__c> incomeList, 
                                                                                                            List<Income__c> incomeList2
                                                                                                            ){
    
        ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection poiApplicantsCollection = new ConsumerAnzCapitalGeComOriginations.POIApplicantsCollection();
        List<ConsumerAnzCapitalGeComOriginations.POIApplicantType> poiApplicantType = new List<ConsumerAnzCapitalGeComOriginations.POIApplicantType>();
        if(applicant1!=null) {
            poiApplicantType.add(generatePOIApplicantType(applicant1,incomeList));
        }
        if(applicant2!=null) {
            poiApplicantType.add(generatePOIApplicantType(applicant2,incomeList2));
        }

        poiApplicantsCollection.applicant = poiApplicantType;
        
        return poiApplicantsCollection;
        
    }

    /* Description: Method that maps values into POIApplicantType
    *  Author: Dan Crisologo
    *  Date Created: 01-06-14
    *  Input Parameters: Applicant
    *  Return: ConsumerAnzCapitalGeComOriginations.POIApplicantType
    */
    public static ConsumerAnzCapitalGeComOriginations.POIApplicantType generatePOIApplicantType(Applicant__c applicant,List<Income__c> incomeList) {

        ConsumerAnzCapitalGeComOriginations.POIApplicantType poiApplicantType = new ConsumerAnzCapitalGeComOriginations.POIApplicantType();       
        //GCO-2377 - do not include applicant 2 income details if applicant 2 is not yet verified
        if(applicant.Is_Primary_Applicant__c || (!applicant.Is_Primary_Applicant__c && applicant.Total_POI_Amount_Verified__c>0)) {
            //poiApplicantType.poiIncomeDetails = generatePOIIncomeDetails(incomeList);
            poiApplicantType.IncomeDetails = generatePOIIncomeDetails(incomeList);            
            //Below condition added for POI Automation by Suneel 30/01/2021
            poiApplicantType.totalIncome = roundOffAmount(applicant.Total_POI_Amount_Verified__c);             
            poiApplicantType.totalAdditionalIncome = roundOffAmount(applicant.Total_Verified_Additional_Income__c);            
        }
        //poiApplicantType.verificationType = applicant.POI_Verification_Type_Code__c;
        poiApplicantType.sfApplicantId = applicant.Id;
        //Added by Suneel POI Automation 27/01/2021
        return poiApplicantType;  
        
    }
    
    /* Description: Method that maps values into RefinanceAccountsCollection
    *  Author: Dan Crisologo
    *  Date Created: 02-10-2014
    *  Input Parameters: refinanceList
    *  Return: ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection
    */
    public static ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection generateRefinance(List<Disbursement__c> refinanceList) {
                   
        Id refinanceRecId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_RECORD_REFINANCE).getRecordTypeId();
       
        ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection refinanceAccountsCollection = new ConsumerAnzCapitalGeComOriginations.RefinanceAccountsCollection();
        List<ConsumerAnzCapitalGeComOriginations.refinanceAccountType> refinanceAccounts = new List<ConsumerAnzCapitalGeComOriginations.refinanceAccountType>();
       
        for(Disbursement__c d: refinanceList) {
            if(d.recordTypeId == refinanceRecId) {
                ConsumerAnzCapitalGeComOriginations.refinanceAccountType ra = new ConsumerAnzCapitalGeComOriginations.refinanceAccountType();
                ra.accountNumber = d.Bank_Acc_No__c;
                ra.payOffQuote = formatData(roundOffAmount(d.Amount__c));
                refinanceAccounts.add(ra);
            }
        }
       
        refinanceAccountsCollection.refinanceAccount = refinanceAccounts;
        return refinanceAccountsCollection;
                   
    }
    
    
    //========================================
    //    Document Generation Helper Methods
    //========================================
        
    
    /* Description: Maps values into DocumentMetadataType
    *  Author: Dan Crisologo
    *  Date Created: 02-05-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DocumentMetadataType
    */
    public static GenerateDocumentGeComOriginations.DocumentMetadataType generateDocumentMetadataType(Map<String, String> docMetaDataTypeMap) {//List<SObject> srcObject

        GenerateDocumentGeComOriginations.DocumentMetadataType documentMetadataType = new GenerateDocumentGeComOriginations.DocumentMetadataType();
        
        GenerateDocumentGeComOriginations.DocumentMetadataPropertyList documentMetadataPropertyList = new GenerateDocumentGeComOriginations.DocumentMetadataPropertyList();
        
        List<GenerateDocumentGeComOriginations.DocumentMetadataProperty> documentMetadataProperties = new List<GenerateDocumentGeComOriginations.DocumentMetadataProperty>();
        
        for(String id: docMetaDataTypeMap.keySet()){
            GenerateDocumentGeComOriginations.DocumentMetadataProperty documentMetadataProperty = new GenerateDocumentGeComOriginations.DocumentMetadataProperty();
            documentMetadataProperty.propertyName = id;
            documentMetadataProperty.propertyValue = docMetaDataTypeMap.get(id);
            documentMetadataProperties.add(documentMetadataProperty);
        }
        
        documentMetadataPropertyList.documentMetadataProperty = documentMetadataProperties;
        documentMetadataType.documentMetadataPropertyList = documentMetadataPropertyList;
        
        return documentMetadataType;
        
    }
    
    /* Description: Maps values into DocumentsType
    *  Author: Dan Crisologo
    *  Date Created: 02-05-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DocumentsType
    */
    public static GenerateDocumentGeComOriginations.DocumentsType generateDocumentsType(List<GenerateDocumentGeComOriginations.ContractDocType> contractDocList,
                                                                                        List<GenerateDocumentGeComOriginations.oAndRType> oAndRList,
                                                                                        List<GenerateDocumentGeComOriginations.lpiType> lpiList,
                                                                                        List<GenerateDocumentGeComOriginations.directDebitType> directDebitList,
                                                                                        List<GenerateDocumentGeComOriginations.privacyNoticeType> privacyNoticeList,
                                                                                        List<GenerateDocumentGeComOriginations.accountClosureType> accountClosureList,
                                                                                        List<GenerateDocumentGeComOriginations.accountLimitReductionType> limitReductionList,
                                                                                        List<GenerateDocumentGeComOriginations.payoutStatementType> payoutStatementList,
                                                                                        List<GenerateDocumentGeComOriginations.interestFreeRebateType> interestFreeRebateList,
                                                                                        List<GenerateDocumentGeComOriginations.disbursementAuthorityType> disbursementList,
                                                                                        List<GenerateDocumentGeComOriginations.signUpLetterNZType> signUpLetterList) {
        
        //Added Fel Saliba 10/2/2014 construct Document Type
        GenerateDocumentGeComOriginations.DocumentsType documentsType = new GenerateDocumentGeComOriginations.DocumentsType();

        if(contractDocList.size()>0){        
            documentsType.contract = contractDocList;
        }
        if(oAndRList.size()>0){
            documentsType.OandR = oAndRList;
        }
        if(lpiList.size()>0){
            documentsType.lpi = lpiList;
        }
        if(directDebitList.size()>0){
            documentsType.directDebit = directDebitList;
        }
        if(privacyNoticeList.size()>0){
            documentsType.privacyNotice = privacyNoticeList;
        }
        if(accountClosureList.size()>0){
            documentsType.accountClosure = accountClosureList;
        }
        if(limitReductionList.size()>0){
            documentsType.accountLimitReduction = limitReductionList;
        }
        if(payoutStatementList.size()>0){
            documentsType.payoutStatement = payoutStatementList;
        }
        if(interestFreeRebateList.size()>0){
            documentsType.interestFreeRebate = interestFreeRebateList;
        }
        if(disbursementList.size()>0){
            documentsType.disbursementAuthority = disbursementList; 
        }
        //added as part of DBHZL-197 - devendra
        if(signUpLetterList.size()>0){
            documentsType.signUpLetterNZ = signUpLetterList; 
        } //---end-----             
        
        return documentsType;
        
    }
    
    /* Description: Method that maps values into contact WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Applicant
    *  Return: generateDocumentGeComOriginations.Contact
    */
    public static GenerateDocumentGeComOriginations.Contact generateContact(Applicant__c applicant) {
        
        GenerateDocumentGeComOriginations.Contact contact = new GenerateDocumentGeComOriginations.Contact();
        
        contact.id = applicant.id;
        if(applicant.Is_Primary_Applicant__c) {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_PRIMARY_ABBR;
        } else {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_SECONDARY_ABBR;
        }
        contact.dateOfBirth = applicant.Date_of_Birth_WS__c;
        contact.age = String.valueOf(applicant.Applicant_Age__c);
        contact.gender = applicant.Gender__c;
        contact.maritalStatus = applicant.Rel_Status__c;
        contact.contactName = generateContactName(applicant.Title__c,applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c);
        
        String unitNumber = applicant.Unit_No_Res__c != null ? applicant.Unit_No_Res__c : '';        
        String addressLineOne = unitNumber + ' ' + applicant.Street_No_Res__c + ' ' + applicant.Street_Res__c + ' ' + applicant.Street_Type_Res__c;
        
        List<GenerateDocumentGeComOriginations.Address> addressList= new List<GenerateDocumentGeComOriginations.Address>();
        
        //Changed by TXU to allow NZ address
        GenerateDocumentGeComOriginations.Address add = new GenerateDocumentGeComOriginations.Address();
        
        add = generateDocumentContactAddress(null,addressLineOne,null,null,
                                                       applicant.Suburb_Res__c,applicant.State_Res__c,applicant.Postcode_Res__c,
                                                       applicant.Country_Res__c,applicant.Unit_No_Res__c,applicant.Street_No_Res__c,
                                                       applicant.Residential_Property_Name__c,applicant.Street_Res__c,
                                                       applicant.Street_Type_Res__c);
                                                       
        if(applicant.Country_Res__c == 'New Zealand'){
          add.city = applicant.City_Res__c;
          add.suburb = applicant.Suburb_Res__c;
        }
                                                      
        
        
        addressList.add(add);
        contact.address = addressList; 
        
        contact.eligibilityDetails = generateEligibilityDetails(true, //eligibleToLoan - default to true
                                                                true, //fixedTermAndLoanMeetsNeed - default to true
                                                                true, //readAndAgreeToPrivacyPolicy - default to true
                                                                true, //readCreditGuide - default to true
                                                                //applicant.Loan_Insurance_Consent__c, //receiveInfoAboutLoanInsurance,
                                                                applicant.Agrees_to_Privacy_Policy__c,
                                                                applicant.Interested_in_other_services__c, //utilizeInfoForOtherProducts,
                                                                (applicant.EIDV__c == 'Yes') ? true : false,
                                                                applicant.Consent_to_Lpi__c,
                                                                applicant.Agrees_to_Income_Verification__c);
                                                                       
        return contact;
    }
    
    /* Description: Method that maps values into contactName WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Date
    *  Return: GenerateDocumentGeComOriginations.ContactName
    */
    public static GenerateDocumentGeComOriginations.ContactName generateContactName(String title,String fName,String Mname,String LName){
        
        GenerateDocumentGeComOriginations.ContactName contactName = new GenerateDocumentGeComOriginations.ContactName();
        
        contactName.title = title;
        contactName.givenName = fName;
        contactName.middleName = MName;
        contactName.lastName = LName;
        
        return contactName;
        
    }
    
    /* Description: Method that maps values into address WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: String id
                         String addressLineOne
                         String addressLineTwo
                         String addressLineThree
                         String city, String state
                         String postCode
                         String countryString 
                         String unitNumber
                         String houseNumber
                         String propertyName
                         String streetName
                         String streetType
                         
    *  Return: GenerateDocumentGeComOriginations.Address
    */
    public static GenerateDocumentGeComOriginations.Address generateDocumentContactAddress(String id, 
                                                                                           String addressLineOne, 
                                                                                           String addressLineTwo, 
                                                                                           String addressLineThree, 
                                                                                           String city, 
                                                                                           String state, 
                                                                                           String postCode, 
                                                                                           String country,
                                                                                           String unitNumber,
                                                                                           String houseNumber,
                                                                                           String propertyName,
                                                                                           String streetName,
                                                                                           String streetType ){
        
        GenerateDocumentGeComOriginations.Address address = new GenerateDocumentGeComOriginations.Address();
        
        address.id = id;
        address.addressLineOne = addressLineOne;
        address.addressLineTwo = addressLineTwo;
        address.addressLineThree = addressLineThree;
        address.city = city;
        address.state = state;
        address.postCode = postCode;
        address.country = country;
        address.unitNumber = unitNumber;
        address.houseNumber = houseNumber;
        address.streetNumber  = houseNumber;
        address.propertyName = propertyName;
        address.streetName = streetName;
        address.streetType = streetType;
              
        return address;
        
    }
    
    /* Description: Method that maps values into ContactList WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Applicant List
    *  Return: GenerateDocumentGeComOriginations.ContactList
    */
    public static GenerateDocumentGeComOriginations.ContactList generateContactList(Applicant__c applicant1, Applicant__c applicant2){
        
        GenerateDocumentGeComOriginations.ContactList contactList = new GenerateDocumentGeComOriginations.ContactList();
        
        List<Applicant__c> applicantList = new List<Applicant__c>();
        if(applicant1!=null){
            applicantList.add(applicant1);
        }        
        if(applicant2!=null) {
            applicantList.add(applicant2);
        }
        List<GenerateDocumentGeComOriginations.Contact> contacts = new List<GenerateDocumentGeComOriginations.Contact>();
        
        if(applicantList.size()>0){
            for(Applicant__c applicant:applicantList){
                contacts.add(generateContact(applicant));
            }
        } 
        
        contactList.contact = contacts;           
        return contactList;             
    }
    
    /* Description: Method that maps values into MortgageDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Collateral List, Applicant List
    *  Return: GenerateDocumentGeComOriginations.MortgageDetails
    */
    public static GenerateDocumentGeComOriginations.MortgageDetails generateMortgageDetails(Collateral__c collateral, 
                                                                                            Applicant__c applicant1, Applicant__c applicant2){
        
        GenerateDocumentGeComOriginations.MortgageDetails mortgageDetails = new GenerateDocumentGeComOriginations.MortgageDetails();
        
        //these fields should not be null because they are being checked in the validator class
        if(collateral.Record_Type_Name__c != NULL && collateral.Record_Type_Name__c.substring(collateral.Record_Type_Name__c.length()-2, collateral.Record_Type_Name__c.length()) == 'NZ'){
          mortgageDetails.property = collateral.Collateral_Make__c;
        }else{
          mortgageDetails.property = collateral.Collateral_Year__c + ' ' + collateral.Collateral_Make__c + ' ' + collateral.Collateral_Body_Type__c;
        }
        mortgageDetails.regNumber = collateral.Collateral_Reg_No__c;
        mortgageDetails.engineNumber = collateral.Collateral_Eng_No__c;
        mortgageDetails.chasisNumber = collateral.Collateral_VIN_No__c;
        mortgageDetails.propertyType = collateral.Collateral_Type__c;
        
        //Collateral description added for NZ
       if(collateral.Collateral_Type__c == null || collateral.Collateral_Type__c == ''){
          
          if(collateral.Record_Type_Name__c == 'Motorcycle NZ'){
            mortgageDetails.CollateralDescription = 'Motocycle';
          }else if(collateral.Record_Type_Name__c == 'Motor Vehicle NZ'){
            mortgageDetails.CollateralDescription = 'Motor Vehicle';
          }else if(collateral.Record_Type_Name__c == 'Jetski NZ'){
            mortgageDetails.CollateralDescription = 'Jetski';
          }else if(collateral.Record_Type_Name__c == 'Boat NZ'){
            mortgageDetails.CollateralDescription = 'Boat';
          }
          
        }else{
          mortgageDetails.CollateralDescription = collateral.Collateral_Type__c;
        }
        mortgageDetails.VehicleModel = collateral.Collateral_Model__c;
    mortgageDetails.VehicleYear = collateral.Collateral_Year__c;
        mortgageDetails.VehicleBodyType = collateral.Collateral_Body_Type__c;
        mortgageDetails.VehicleColour = collateral.Color__c;
        mortgageDetails.VehicleLength = collateral.Length__c != NULL ? String.valueOf(collateral.Length__c) : '';
        
        if(collateral.Collateral_Owner__c == GEN_OriginationsConstants.APPLICANT_1){
            mortgageDetails.ContactCollection =  generateContactList(applicant1, null);   
        }
        else if(collateral.Collateral_Owner__c == GEN_OriginationsConstants.APPLICANT_2){
            mortgageDetails.ContactCollection =  generateContactList(null, applicant2);
        }
        else if(collateral.Collateral_Owner__c == GEN_OriginationsConstants.BOTH){
            mortgageDetails.ContactCollection =  generateContactList(applicant1, applicant2);
        }         
        return mortgageDetails;        
    }
    
    /* Description: Method that maps values into MortgageDetailsCollection WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Application, Collateral List, Applicant List
    *  Return: GenerateDocumentGeComOriginations.MortgageDetailsCollection
    */
    public static GenerateDocumentGeComOriginations.MortgageDetailsCollection generateMortgageDetailsCollection(Application__c application, 
                                                                                                                List<Collateral__c> collateralList, 
                                                                                                                Applicant__c applicant1, Applicant__c applicant2){
        
        GenerateDocumentGeComOriginations.MortgageDetailsCollection mortgageDetailsCollection = new GenerateDocumentGeComOriginations.MortgageDetailsCollection();
        
        mortgageDetailsCollection.ppsrFee = String.valueOf(roundOffAmount(application.Offered_PPSR_Search_Fee__c));
        mortgageDetailsCollection.ppsrRegFee = String.valueOf(roundOffAmount(application.Offered_PPSR_Registration_Fee__c));
        mortgageDetailsCollection.noOfMortgages = String.valueOf(collateralList.size());
        
        List<GenerateDocumentGeComOriginations.MortgageDetails> mortgageList = new List<GenerateDocumentGeComOriginations.MortgageDetails>();
        for(Collateral__c collateral: collateralList){
            mortgageList.add(generateMortgageDetails(collateral,applicant1, applicant2));
        }
        mortgageDetailsCollection.MortgageDetails = mortgageList;
                  
        return mortgageDetailsCollection;        
    }
    
    /* Description: Method that maps values into DisbursementDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Disbursement
    *  Return: GenerateDocumentGeComOriginations.DisbursementDetails
    */
    public static GenerateDocumentGeComOriginations.DisbursementDetails generateDisbursementDetails(Disbursement__c disbursement){        
        
        GenerateDocumentGeComOriginations.DisbursementDetails disbursementDetails = new GenerateDocumentGeComOriginations.DisbursementDetails();
        if(disbursement.Amount__c > 0){
        disbursementDetails.disbursementTo = disbursement.Payee__c;
        //Added by Suneel - Mapping Payee as Biller Short Name for the Disbursement Type COde as '004' - Cheque Disbursement Removal 
         if(disbursement.Disbursement_Type_Code__c == '004')
         {
         //disbursementDetails.disbursementTo = disbursement.Biller_Short_Name__c;
           disbursementDetails.disbursementTo = disbursement.BillerShortName__c;
         }
         //End
        if(disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_BROKER_FEE){
            disbursementDetails.disbursementTo = disbursement.Broker_Aggregator_Account_Name__c;
        }               
        disbursementDetails.disbursementAmount = String.valueOf(roundOffAmount(disbursement.Amount__c));
        disbursementDetails.disbursementDescription = disbursement.Disbursement_Outcome_Comments__c;
        disbursementDetails.bankName = disbursement.Bank_Name__c;
        disbursementDetails.branchName = disbursement.Branch_Name__c;
        disbursementDetails.bankNumber = disbursement.Bank_Number__c;
        disbursementDetails.branchNumber = disbursement.Branch_Number__c;
        disbursementDetails.accountNumber = disbursement.Bank_Acc_No__c;
        disbursementDetails.suffix = disbursement.Suffix_Number__c;  }        
        return disbursementDetails;        
    }
    
    /* Description: Method that maps values into DisbursementDetailsCollection WSobject
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Disbursement List
    *  Return: GenerateDocumentGeComOriginations.DisbursementDetailsCollection
    */
    public static GenerateDocumentGeComOriginations.DisbursementDetailsCollection generateDisbursementDetailsCollection(List<Disbursement__c> disbursementList){
        
        Id geCardLimitReduc = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_GE_CARD_LIMIT_REDUC_RECORDTYPE).getRecordTypeId();
        Id nonGECardOVLimitReduct = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OV_LIMIT_REDUCT_RECORDTYPE).getRecordTypeId();
        Id geCardClosureWithoutInterestFree = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_GE_CARD_CLOSURE_WITHOUT_INTEREST_FREE_RECORDTYPE).getRecordTypeId();
        Id nonGECardOVClosure = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OV_CLOSURE_RECORDTYPE).getRecordTypeId();
        //Added as part of DBHZL-199--devendra
        Id nonGECardODLimitReduct_NZ = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OD_LIMIT_REDUCT_NZ_RECORDTYPE).getRecordTypeId();
        Id nonGECardODClosure_NZ = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OD_CLOSURE_NZ_RECORDTYPE).getRecordTypeId();
        
        GenerateDocumentGeComOriginations.DisbursementDetailsCollection disbursementDetailsCollection = new GenerateDocumentGeComOriginations.DisbursementDetailsCollection();
        
        List<GenerateDocumentGeComOriginations.DisbursementDetails> disbursements = new List<GenerateDocumentGeComOriginations.DisbursementDetails>();
        for(Disbursement__c d: disbursementList){
            
            if( !((d.recordTypeId == nonGECardODLimitReduct_NZ || d.recordTypeId == nonGECardODClosure_NZ || d.recordTypeId == geCardLimitReduc || d.recordTypeId == nonGECardOVLimitReduct || d.recordTypeId == geCardClosureWithoutInterestFree || d.recordTypeId == nonGECardOVClosure) && 
            (d.Amount__c == 0 || d.Amount__c == null))) {
                disbursements.add(generateDisbursementDetails(d));
            }
        }
        
        DisbursementDetailsCollection.disbursementDetails = disbursements;
                  
        return disbursementDetailsCollection;        
    }
    
    /* Description: Method that maps values into InsuranceDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 7-02-14
    *  Input Parameters: Application, Product Item List
    *  Return: GenerateDocumentGeComOriginations.InsuranceDetails
    */
    public static GenerateDocumentGeComOriginations.InsuranceDetails generateInsuranceDetails(Application__c application, 
                                                                                              List<Product_Item__c> prodItemList){
        
        GenerateDocumentGeComOriginations.InsuranceDetails insuranceDetails = new GenerateDocumentGeComOriginations.InsuranceDetails();
        
        Boolean hasLife = false;
        Boolean hasDisability = false;
        Boolean hasIUI = false;
        //BEGIN MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
        Boolean hasLife2 = false;     
        Boolean hasDisability2 = false;
        Boolean hasIUI2 = false;
        //END MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
        Boolean app1 = false;
        Boolean app2 = false;
        if(prodItemList.size()>0){ 
            if(application.Brand_Country__c == 'AU'){     
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                        
                        insuranceDetails.insuranceCreditLife = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceCreditLifeStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceCreditLifeGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceCreditLifeCount = String.valueOf(prod.Policy_Type__c);
                        hasLife = true;
                        
                        //BEGIN MLASALA 16-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                        // if(prod.Applicant1__c != NULL) {
                        //     insuranceDetails.primaryApplicantCCICover = 'Life Insurance';
                        // }
                        // if(prod.Applicant2__c != NULL) {
                        //     insuranceDetails.secondaryApplicantCCICover = 'Life Insurance';
                        // }
                        
                        if(prod.Applicant1__c != NULL) {
                            if(!hasDisability){
                                insuranceDetails.primaryApplicantCCICover = 'Life Insurance';
                            } else {
                                if(!hasIUI){
                                    insuranceDetails.primaryApplicantCCICover = 'Life & Disability';
                                } else {
                                    insuranceDetails.primaryApplicantCCICover = 'Full Insurance';
                                }
                            }
                        }
                        if(prod.Applicant2__c != NULL) {
                            hasLife2 = true;
                            
                            if(!hasDisability2){
                                insuranceDetails.secondaryApplicantCCICover = 'Life Insurance';
                            } else {
                                if(!hasIUI2){
                                    insuranceDetails.secondaryApplicantCCICover = 'Life & Disability';
                                } else {
                                    insuranceDetails.secondaryApplicantCCICover = 'Full Insurance';
                                }
                            }
                        }
                        //END MLASALA 16-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                    }
                  
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                      
                        insuranceDetails.insuranceCreditDisability = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitPercent = String.valueOf(prod.BenefitPercent__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitAmount = String.valueOf(prod.Benefit_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyMaxBenefit = String.valueOf(prod.Max_Benefit__c);
                        insuranceDetails.insuranceCreditDisabilityCount = String.valueOf(prod.Policy_Type__c);
                        hasDisability = true;
                        
                        //BEGIN MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                        // if(prod.Applicant1__c != NULL && hasLife) {
                        //     insuranceDetails.primaryApplicantCCICover = 'Full Insurance';
                        // } else {
                        //     insuranceDetails.primaryApplicantCCICover = 'Life Insurance';
                        // }
                        // if(prod.Applicant2__c != NULL && hasLife) {
                        //     insuranceDetails.secondaryApplicantCCICover = 'Full Insurance';
                        // } else {
                        //     insuranceDetails.secondaryApplicantCCICover = 'Repayment Insurance';
                        // }
                        
                        if(prod.Applicant1__c != NULL && hasLife) {
                            insuranceDetails.primaryApplicantCCICover = 'Life & Disability';
                        } else {
                            insuranceDetails.primaryApplicantCCICover = 'Disability';
                        }
                      
                        if(prod.Applicant2__c != NULL){
                            hasDisability2 = true;
                            
                            if(hasLife2){
                                insuranceDetails.secondaryApplicantCCICover = 'Life & Disability';
                            } else {
                                insuranceDetails.secondaryApplicantCCICover = 'Disability';
                            }
                        }
                        //END MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                    }
                    
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                    
                        insuranceDetails.insuranceInvoluntaryUnemploymentCover = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentMaxDurationOfRepay = String.valueOf(prod.Max_Duration_Of_Repay__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverCount = String.valueOf(prod.Policy_Type__c);
                        hasIUI = true;
                      
                        //BEGIN MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                        if(prod.Applicant1__c != NULL && hasLife){
                            insuranceDetails.primaryApplicantCCICover = 'Full Insurance';
                        } else {
                            insuranceDetails.primaryApplicantCCICover = 'Disability & IUI';
                        }
                        
                        if(prod.Applicant2__c != NULL){
                            hasIUI2 = true;
                            
                            if(hasLife2){
                                insuranceDetails.secondaryApplicantCCICover = 'Full Insurance';
                            } else {
                                insuranceDetails.secondaryApplicantCCICover = 'Disability & IUI';
                            }
                        }
                    }
                  
                    // if(prod.Applicant1__c != NULL && hasLife) {
                    //     insuranceDetails.primaryApplicantCCICover = 'Full Insurance';
                    // } else {
                    //     insuranceDetails.primaryApplicantCCICover = 'Life Insurance';
                    // }
                    // if(prod.Applicant2__c != NULL && hasLife) {
                    //     insuranceDetails.secondaryApplicantCCICover = 'Full Insurance';
                    // } else {
                    //     insuranceDetails.secondaryApplicantCCICover = 'Repayment Insurance';
                    // }
                    //END MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                }
                
                if(String.isBlank(insuranceDetails.primaryApplicantCCICover)) {
                    insuranceDetails.primaryApplicantCCICover = 'No insurance cover';
                }
                if(String.isBlank(insuranceDetails.secondaryApplicantCCICover)) {
                    insuranceDetails.secondaryApplicantCCICover = 'No insurance cover'; 
                }  
              
            } else if(application.Brand_Country__c == 'NZ'){
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                        
                        insuranceDetails.insuranceCreditLife = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceCreditLifeStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceCreditLifeGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceCreditLifeCount = String.valueOf(prod.Policy_Type__c);
                        hasLife = true;
                      
                        //BEGIN MLASALA 16-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                        // if(prod.Applicant1__c != NULL) {
                        //     insuranceDetails.primaryApplicantCCICover = 'Life Cover';
                        // }
                        // if(prod.Applicant2__c != NULL) {
                        //     insuranceDetails.secondaryApplicantCCICover = 'Life Cover';
                        // }
                        
                        if(prod.Applicant1__c != NULL) {
                            if(!hasDisability){
                                insuranceDetails.primaryApplicantCCICover = 'Life Cover';
                            } else {
                                insuranceDetails.primaryApplicantCCICover = 'Life and Repayment Cover';
                            }
                        }
                        if(prod.Applicant2__c != NULL) {
                            haslife2 = true;
                            
                            if(!hasDisability2){
                                insuranceDetails.secondaryApplicantCCICover = 'Life Cover';
                            } else {
                                insuranceDetails.secondaryApplicantCCICover = 'Life and Repayment Cover';
                            }
                        }
                        //END MLASALA 16-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                    }
                    
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                        
                        insuranceDetails.insuranceCreditDisability = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitPercent = String.valueOf(prod.BenefitPercent__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitAmount = String.valueOf(prod.Benefit_Amount__c);
                        insuranceDetails.insuranceCreditDisabilityOnceOnlyMaxBenefit = String.valueOf(prod.Max_Benefit__c);
                        insuranceDetails.insuranceCreditDisabilityCount = String.valueOf(prod.Policy_Type__c);
                        hasDisability = true;
                      
                        if(prod.Applicant1__c != NULL && hasLife) {
                            insuranceDetails.primaryApplicantCCICover = 'Life and Repayment Cover';
                        } else {
                            insuranceDetails.primaryApplicantCCICover = 'Repayment Cover';
                        }
                        //BEGIN MLASALA 12-MAY-2016 TQLQW-298 Fix Loan Document errors for CCI
                        // if(prod.Applicant2__c != NULL && hasLife) {
                        if(prod.Applicant2__c != NULL){
                            hasDisability2 = true;
                            
                            if(hasLife2){
                                insuranceDetails.secondaryApplicantCCICover = 'Life and Repayment Cover';
                            } else {
                                insuranceDetails.secondaryApplicantCCICover = 'Repayment Cover';
                            }
                        }
                    }
                    
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                      
                        insuranceDetails.insuranceInvoluntaryUnemploymentCover = String.valueOf(prod.Fixed_Premium_Amount__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverStampDuty = String.valueOf(prod.Insurance_Stamp_Duty_Amount__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverGST = String.valueOf(prod.Insurance_GST__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentMaxDurationOfRepay = String.valueOf(prod.Max_Duration_Of_Repay__c);
                        insuranceDetails.insuranceInvoluntaryUnemploymentCoverCount = String.valueOf(prod.Policy_Type__c);
                        hasIUI = true;
                    }
                }
                
                if(application.Application_Type__c == 'Single'){
                    if(String.isBlank(insuranceDetails.primaryApplicantCCICover)) {
                        insuranceDetails.primaryApplicantCCICover = 'No insurance cover';
                    }
                    insuranceDetails.secondaryApplicantCCICover = null;
                } else {
                    if(String.isBlank(insuranceDetails.primaryApplicantCCICover)) {
                        insuranceDetails.primaryApplicantCCICover = 'No insurance cover';
                    }
                    if(String.isBlank(insuranceDetails.secondaryApplicantCCICover)) {
                        insuranceDetails.secondaryApplicantCCICover = 'No insurance cover'; 
                    }
                }
            }            
            System.debug('$$$ primaryApplicantCCICover: '+insuranceDetails.primaryApplicantCCICover+', secondaryApplicantCCICover: '+insuranceDetails.secondaryApplicantCCICover);
            if(hasLife){
                insuranceDetails.insuranceCreditLifeReturn = String.valueOf(application.Total_Loan_Amount__c);
                if(application.Total_Loan_Amount__c > 100000){
                    insuranceDetails.insuranceCreditLifeReturn = '100000';
                }
            }
            else{
                insuranceDetails.insuranceCreditLife = '0.00';
                insuranceDetails.insuranceCreditLifeStampDuty = '0.00';
                insuranceDetails.insuranceCreditLifeGST = '0.00';
                insuranceDetails.insuranceCreditLifeReturn = '0.00';
                insuranceDetails.insuranceCreditLifeCount = '-1';                
            }
            
            if(hasDisability){
                insuranceDetails.insuranceCreditDisabilityReturn = String.valueOf(application.EMI_with_Service_Fee__c);
                if(application.Offered_Repayments__c > 1500){
                    insuranceDetails.insuranceCreditDisabilityReturn = '1500';
                }
            }
            else{
                insuranceDetails.insuranceCreditDisability = '0.00';
                insuranceDetails.insuranceCreditDisabilityStampDuty = '0.00';
                insuranceDetails.insuranceCreditDisabilityGST = '0.00';
                insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitPercent = '10';
                insuranceDetails.insuranceCreditDisabilityOnceOnlyBenefitAmount ='500';
                insuranceDetails.insuranceCreditDisabilityOnceOnlyMaxBenefit = '5000';  
                insuranceDetails.insuranceCreditDisabilityReturn = '0.00';  
                insuranceDetails.insuranceCreditDisabilityCount = '-1';            
            }
            
            if(hasIUI){
                insuranceDetails.insuranceInvoluntaryUnemploymentCoverReturn = String.valueOf(application.Offered_Repayments__c);
                if(application.Offered_Repayments__c > 1500){
                    insuranceDetails.insuranceInvoluntaryUnemploymentCoverReturn = '1500';
                }
            }
            else{
                insuranceDetails.insuranceInvoluntaryUnemploymentCover = '0.00';
                insuranceDetails.insuranceInvoluntaryUnemploymentCoverStampDuty = '0.00';
                insuranceDetails.insuranceInvoluntaryUnemploymentCoverGST = '0.00';
                insuranceDetails.insuranceInvoluntaryUnemploymentMaxDurationOfRepay = '6';  
                insuranceDetails.insuranceInvoluntaryUnemploymentCoverReturn = '0.00';  
                insuranceDetails.insuranceInvoluntaryUnemploymentCoverCount = '-1';        
            }
                
            if(hasLife || hasDisability || hasIUI){
                insuranceDetails.insuranceTotalPremium = String.valueOf(application.Total_Insurance_Premium__c);            
                insuranceDetails.policyTerm = String.valueOf(application.Loan_Term_Months__c);
                if(application.Loan_Term_Months__c > 84){
                    insuranceDetails.policyTerm = '84';
                }
            }       
        }          
        return insuranceDetails;        
    }
    
    /* Description: Method that maps values into DocumentCommonAttrType WSobject
    *  Author: Fel Saliba
    *  Date Created: 10-02-14
    *  Input Parameters: Related Document
    *  Return: GenerateDocumentGeComOriginations.DocumentCommonAttrType
    */
    public static GenerateDocumentGeComOriginations.DocumentCommonAttrType generateDocumentCommonAttrType(Related_Document__c relatedDocument){
        
        GenerateDocumentGeComOriginations.DocumentCommonAttrType documentCommonAttrType = new GenerateDocumentGeComOriginations.DocumentCommonAttrType();
        
        documentCommonAttrType.sfDocumentId = relatedDocument.Id;
        documentCommonAttrType.documentName = relatedDocument.application__r.UID__c + '-' + relatedDocument.Title__c + '-' + relatedDocument.Id;       
        documentCommonAttrType.documentCategory = relatedDocument.Document_Category__c;
        if(relatedDocument.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_NZ_SIGNUP_LETTER || relatedDocument.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_GEMONEY_NZ_SIGNUP_LETTER){
          documentCommonAttrType.documentType = GEN_OriginationsConstants.DOCUMENT_TYPE_CONTRACT; 
        }else if(relatedDocument.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT_NZ){
          documentCommonAttrType.documentType = GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT;
        }else{
          documentCommonAttrType.documentType = relatedDocument.Type__c;
        }      
        documentCommonAttrType.geTemplateName = relatedDocument.Template_Name__c;
                  
        return documentCommonAttrType;        
    }
    
    /* Description: Method that maps values into ContractType WSobject
    *  Author: Fel Saliba
    *  Date Created: 10-02-14
    *  Input Parameters: Application
    *  Return: GenerateDocumentGeComOriginations.ContractType
    */
    public static GenerateDocumentGeComOriginations.ContractType generateContractType(IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.ContractType contractType = new GenerateDocumentGeComOriginations.ContractType();
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            contractType.isJointCustomers = 'false';
        }
        else{
            contractType.isJointCustomers = 'true';
        }   
        contractType.ContractInfoCollection = generateContract(appDTO.app, appDTO.collateralList, appDTO.applicant, appDTO.applicant2, appDTO.brokerDetails, appDTO.disbursementList, appDTO.insuranceList, appDTO.feesAndCharges, appDTO.Product,appDTO.applicationDebits);
        contractType.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        if(appDTO.branch != null){
            contractType.Department = generateDepartment(appDTO.branch);
        }       
                  
        return contractType;        
    
    }
    
    /* Description: Method that maps values into Contract WSobject
    *  Author: Fel Saliba
    *  Date Created: 10-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.Contract
    */
    public static GenerateDocumentGeComOriginations.Contract generateContract(Application__c application, 
                                                                              List<Collateral__c> collateralList, 
                                                                              Applicant__c applicant1,
                                                                              Applicant__c applicant2, 
                                                                              Contact broker,
                                                                              List<Disbursement__c> disbursementList, 
                                                                              List<Product_Item__c> prodItemList,
                                                                              List<Fees_Charges__c> feesAndCharges,
                                                                              GEProduct__c product,
                                                                              List<Debit__c> debit){
        
        GenerateDocumentGeComOriginations.Contract contract = new GenerateDocumentGeComOriginations.Contract();
        
        contract.applicationNo = application.UID__c;
        //Added by Suneel -- Better Start
        Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
        if(application.Product_SubType__c == 'Better Start PL' && application.Brand_Country__c == 'AU' && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
        contract.loanType = 'Better Start Personal Loan';
        }else{
        contract.loanType = product.Description__c;
        }
        // disclosuredate for NZ
        contract.discloureDate = formatData(Date.today());
        
        
        //Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        contract.totalAmountOfCredit = String.valueOf(roundOffAmount(application.Total_Loan_Amount_with_Insurance__c));
        contract.payableAmount = String.valueOf(roundOffAmount(application.Total_Loan_Interest_Amount_Payable__c));
        
        Decimal totalAmouintOfInterest = roundOffAmount(application.Total_Loan_Interest_Amount_Payable__c);
        totalAmouintOfInterest += roundOffAmount(application.Total_Insurance_Interest_Amount_Payable__c);
        contract.totalAmouintOfInterest = String.valueOf(totalAmouintOfInterest);
        
        // Appending 3 months to the loan term in the contract document for Better start apps
        if(application.Brand_Country__c == 'AU'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);
                if((application.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){                
                    Integer actualTerm = Integer.valueOf(application.Loan_Term_Months__c);
                    Integer bsLoanTerm = actualTerm + lterm;
                    contract.noOfRepayments = String.valueOf(bsLoanTerm);
                }else{
                    contract.noOfRepayments = String.valueOf(application.Loan_Term_Months__c);
                }
            }else if(application.Brand_Country__c == 'NZ'){
                Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);
                if((application.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false)){                
                    Integer actualTerm = Integer.valueOf(application.Loan_Term_Months__c);
                    Integer bsLoanTerm = actualTerm + lterm;
                    contract.noOfRepayments = String.valueOf(bsLoanTerm);
                }else{
                    contract.noOfRepayments = String.valueOf(application.Loan_Term_Months__c);
                }
            }
                    
        // Adding for the Better Start
        //Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
       /* if((application.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartNZActive__c == true) && application.Brand_Country__c == 'NZ'){
            contract.noOfRepayments = String.valueOf(application.Loan_Term_Months__c) + 3;
        }else {
            contract.noOfRepayments = String.valueOf(application.Loan_Term_Months__c);
        } */
        //End 
        contract.annualPercentageRate = String.valueOf(application.Offered_Interest_Rate__c);
        
        contract.eachCombinedRepaymentAmount = String.valueOf(roundOffAmount(application.EMI_with_Service_Fee__c));
        contract.eachMonthlyRepaymentAmount = String.valueOf(roundOffAmount(application.Offered_Repayments__c));
        contract.totalPayableOverLoanTerm = String.valueOf(roundOffAmount(application.EMI_with_Service_Fee__c * application.Loan_Term_Months__c));
        
        Decimal totalIncludedInAmountOfCredit = 0;
        totalIncludedInAmountOfCredit += roundOffAmount(application.Offered_Establishment_Fee__c);
        totalIncludedInAmountOfCredit += roundOffAmount(application.Offered_PPSR_Search_Fee__c);
        totalIncludedInAmountOfCredit += roundOffAmount(application.Offered_PPSR_Registration_Fee__c);
        
        contract.feesAndChargesAmount = String.valueOf(roundOffAmount(totalIncludedInAmountOfCredit));
        contract.totalIncludedInAmountOfCredit = String.valueOf(roundOffAmount(totalIncludedInAmountOfCredit));     
        contract.loanServiceFeeThrougoutTheTerm = String.valueOf(roundOffAmount(application.Offered_Monthly_Loan_Service_Fee__c * application.Loan_Term_Months__c));
        contract.totalAmountOfCreditFeesAndCharges =  String.valueOf(roundOffAmount(totalIncludedInAmountOfCredit + (application.Offered_Monthly_Loan_Service_Fee__c * application.Loan_Term_Months__c)));
        
        contract.establishmentFee = String.ValueOf(roundOffAmount(application.Offered_Establishment_Fee__c));
        
        if(feesAndCharges!=null) {
            if(feesAndCharges.size()>0){
                for(Fees_Charges__c fc: feesAndCharges) {
                    if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_EARLY_TERMINATION1 && fc.Fee_Amount__c!=null) {
                        contract.earlyTerminationRepayFirstHalfLoanTerm = String.valueOf(roundOffAmount(fc.Fee_Amount__c));
                    }
                    if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_EARLY_TERMINATION2 && fc.Fee_Amount__c!=null) {
                        contract.earlyTerminationRepaySecHalfLoanTerm = String.valueOf(roundOffAmount(fc.Fee_Amount__c));
                    }
                    if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_PAYMENT_HANDLING && fc.Fee_Amount__c!=null) {
                        contract.paymentHandlingFee = String.valueOf(roundOffAmount(fc.Fee_Amount__c));
                    }
                    if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_LOAN_SERVICE && fc.Fee_Amount__c!=null) {
                        contract.loanServiceFee = String.valueOf(roundOffAmount(fc.Fee_Amount__c));
                    }
                    if(fc.Fee_Type__c == GEN_OriginationsConstants.FEE_LATE_PAYMENT && fc.Fee_Amount__c!=null) {
                        contract.latePaymentFee = String.valueOf(roundOffAmount(fc.Fee_Amount__c));
                    }
                }
            }
        }
        
        contract.isMortgage = 'false';
        if(collateralList != null){
            if(collateralList.size()>0){
                contract.isMortgage = 'true';
                contract.MortgageDetailsCollection = generateMortgageDetailsCollection(application, collateralList, applicant1, applicant2);
            }
        }          
        
        contract.isInsurance = 'false';
        if(prodItemList!= null){
            if(prodItemList.size()>0){
                Boolean hasInsurance = false;
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                           hasInsurance = true;
                     }   
                }
                if(hasInsurance){
                    contract.isInsurance = 'true';
                    contract.InsuranceDetails = generateInsuranceDetails(application,prodItemList);
                }
            }
        }
        
        Boolean hasBrokerInsurance = false;
        String payee = '';
        String type = '';
        Decimal amount = 0;
        if(disbursementList != null){                        
            for(Disbursement__c d:disbursementList){
                if(d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE 
                   || d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE_NZ){
                   hasBrokerInsurance = true;
                   payee = d.Broker_Aggregator_Account_Name__c;
                   type = d.Insurance_Type__c;
                   amount = roundOffAmount(d.Amount__c);
                }
            }
            contract.DisbursementDetailsCollection = generateDisbursementDetailsCollection(disbursementList);        
        }
         
        contract.isBrokerChannel = 'false'; 
        if(application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
            contract.isBrokerChannel = 'true';    
            contract.BrokerCommissionDetails = generateBrokerCommissionDetails(application.Broker_Aggregator_Account_Name__c,null);
        }
        contract.isBrokerSoldInsurance = 'false';
        if(hasBrokerInsurance){
            contract.isBrokerSoldInsurance = 'true';
            if(amount != 0){
                contract.BrokerCommissionDetails = generateBrokerCommissionDetails(payee,type);
            }           
        }
        
        contract.isOnline = 'false';
        if(application.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            contract.isOnline = 'true';
        }   
        contract.interestChargesPayableonLoan = String.valueOf(roundOffAmount(application.Total_Loan_Interest_Amount_Payable__c));
        contract.interestChargesPayableonInsuPremium = String.valueOf(roundOffAmount(application.Total_Insurance_Interest_Amount_Payable__c));
        contract.mirror                              = application.Mirror__c;   
        contract.channel                             = application.Channel__c;      
        //Better Start
        //contract.productSubType                      = application.Product_SubType_Code__c;
        if(application.Brand_Country__c == 'AU' && application.Product_SubType__c == 'Better Start PL' && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
        //if(application.Brand_Country__c == 'AU' && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
            contract.productSubType = application.Product_SubType_Code__c;
            //contract.productSubType = application.Product_SubType__c;
         }
        if(application.Brand_Country__c == 'NZ' && bsOffer.BetterStartNZActive__c == true){
            contract.productSubType = application.Product_SubType_Code__c;
         }
        if(debit !=null) { 
         for(Debit__c d:debit){
         if(d.Payment_Method_Code__c != 'RC'){
        contract.repaymentPeriods = generateDocumentRepaymentPeriodDetails(debit,application);
        }
       }
    }
       
        return contract;        
    }
    
    /* Description: Method that maps values into BrokerCommissionDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 10-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.BrokerCommissionDetails
    */
    public static GenerateDocumentGeComOriginations.BrokerCommissionDetails generateBrokerCommissionDetails(String commissionTo, String commissionOf){
        
        GenerateDocumentGeComOriginations.BrokerCommissionDetails brokerCommissionDetails = new GenerateDocumentGeComOriginations.BrokerCommissionDetails();
        
        brokerCommissionDetails.commissionTo = commissionTo;
        if(commissionOf!=null && commissionOf!='') {
            brokerCommissionDetails.commissionOf = commissionOf;
        }
        
        return brokerCommissionDetails;
    }
    
    
    /* Description: Method that maps values into Department WSobject
    *  Author: Fel Saliba
    *  Date Created: 10-02-14
    *  Input Parameters: Branch__c branch
    *  Return: GenerateDocumentGeComOriginations.Department
    */
    public static GenerateDocumentGeComOriginations.Department generateDepartment(Branch__c branch){
        
        GenerateDocumentGeComOriginations.Department department = new GenerateDocumentGeComOriginations.Department();
        
        department.id = branch.Branch_ID__c;
        department.name = branch.name; 
        
        String addressLineOne = branch.address__c != null ? branch.address__c : '';
        String suburb = branch.suburb__c != null ? branch.suburb__c : '';
        String state = branch.state__c != null ? branch.state__c : '';
        String postcode = branch.postcode__c != null ? branch.postcode__c : '';
        String country = branch.Country__c != null ? branch.country__c : ''; 
        
        department.address = generateDocumentContactAddress(null,addressLineOne,null,null,suburb,state,postcode,country,null,null,null,null,null);
        department.telephone = branch.Phone__c;
        department.fax = branch.Fax__c;
        department.departmentManagerName = branch.Primary_Contact__r.Name;
        
        return department;
    }
    
    /* Description: Method that maps values into FinancialInstitutionDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 02-12-14
    *  Input Parameters: finName
                         address
    *  Return: GenerateDocumentGeComOriginations.FinancialInstitutionDetails
    */
    public static GenerateDocumentGeComOriginations.FinancialInstitutionDetails generateFinancialInstitutionDetails(String finName,
                                                                                                                    GenerateDocumentGeComOriginations.Address address){

        GenerateDocumentGeComOriginations.FinancialInstitutionDetails financialInstitutionDetails = new GenerateDocumentGeComOriginations.FinancialInstitutionDetails();
        financialInstitutionDetails.financialInstitutionName = finName;
        financialInstitutionDetails.Address = address;

        return financialInstitutionDetails;
    }

    /**  Description: Creates Account Closure document mapping
    *  Author: Dan Crisologo
    *  Date Created: 02-13-14
    *  Input Parameters: Related_Document__c rd, IS_ApplicationDTO appDTO
    *  Return: GenerateDocumentGeComOriginations.AccountClosure
    */
    public static GenerateDocumentGeComOriginations.AccountClosure createAccountClosureDocument(Related_Document__c rd, IS_ApplicationDTO appDTO) {
        //create Department
        
        GenerateDocumentGeComOriginations.Department department;
        if(appDTO.branch != null){
            department = generateDepartment(appDTO.branch);        
        }
        
        //create document contact
        String fin1 = rd.Disbursement__r.Financial_Institution_Address_1__c != null ? rd.Disbursement__r.Financial_Institution_Address_1__c : '';
        String fin2 = rd.Disbursement__r.Financial_Institution_Address_2__c != null ? rd.Disbursement__r.Financial_Institution_Address_2__c : '';
        
        string addressLineOne;
        string addressLineTwo;
        
        if(appDTO.app.Brand_Country__c == 'AU'){
          addressLineOne = fin1 + ' ' + fin2;
        }else if(appDTO.app.Brand_Country__c == 'NZ'){
          addressLineOne = fin1;
          if(fin2 != null && fin2 != ''){
            addressLineTwo = fin2;
          }
        }
        

        GenerateDocumentGeComOriginations.Address finAddress = generateDocumentContactAddress (null, 
                                                                                               addressLineOne, 
                                                                                               addressLineTwo, 
                                                                                               null, 
                                                                                               rd.Disbursement__r.Financial_Institution_Suburb__c, 
                                                                                               rd.Disbursement__r.Financial_Institution_State__c, 
                                                                                               String.valueOf(rd.Disbursement__r.Financial_Institution_Postcode__c), 
                                                                                               null,null,null,null,null,null);
                                                                                               
        if(appDTO.app.Brand_Country__c == 'NZ'){
        finAddress.city = rd.Disbursement__r.Financial_Institution_City__c;
        finAddress.suburb = rd.Disbursement__r.Financial_Institution_Suburb__c;
      }                                                                                       
                                                                                              
        
        //create financial institution details
        GenerateDocumentGeComOriginations.financialInstitutionDetails financialInstitutionDetails = generateFinancialInstitutionDetails(rd.Disbursement__r.Fin_Institution__c, finAddress);

        //create contact list based on applicable parties
        GenerateDocumentGeComOriginations.ContactList contactCollection;
        
        if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH) {
            contactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        } else if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2) {
            contactCollection = generateContactList(appDTO.applicant2, null);
        } else {
            contactCollection = generateContactList(appDTO.applicant, null);
        }
                                                                                                              
        GenerateDocumentGeComOriginations.AccountClosure accountClosure = new GenerateDocumentGeComOriginations.AccountClosure();

        accountClosure.accountType = rd.Disbursement__r.Disbursement_Account_Type__c;
        accountClosure.productName = rd.Disbursement__r.Product_Name__c;
        
        if(refinanceDisbursement == rd.Disbursement__r.recordTypeId) {
            accountClosure.accountNumber = rd.Disbursement__r.Bank_Acc_No__c;
        } else {
          if(appDTO.app.Brand_Country__c == 'AU'){
              accountClosure.accountNumber = rd.Disbursement__r.Payee__c;
              //Added By Suneel - Mapping Account Number as Biller Short Name for Disbursement - Cheque Removal Disbursement - 19/12/2017
              if(rd.Disbursement__r.Disbursement_Type_Code__c == '004')
              {
                //accountClosure.accountNumber = rd.Disbursement__r.Biller_Short_Name__c;
                 accountClosure.accountNumber = rd.Disbursement__r.BillerShortName__c;
              }
              //End
          }else if(appDTO.app.Brand_Country__c == 'NZ'){
            if(rd.Disbursement__r.Disbursement_Account_Type__c == 'Credit Card'){
              string creditcardNumber = '';
              Integer length = rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.length();
              if(rd.Disbursement__r.Card_Number_or_3rd_Party_Ref__c != null && length > 8){
                creditcardNumber = creditcardNumber + rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.subString(0,4);
                Integer i = 0;
                while(i<length-8){
                  creditcardNumber = creditcardNumber + '*';
                  i++;
                }
                creditcardNumber = creditcardNumber + rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.subString(length-4, length);
              }else{
                creditcardNumber = rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c;
              }
              accountClosure.accountNumber = creditcardNumber;
            }else{
              accountClosure.accountNumber = rd.Disbursement__r.Card_Number_or_3rd_Party_Ref__c;
            }
            
          }
        }
        
        accountClosure.contactCollection = contactCollection;
        accountClosure.department = department;
        accountClosure.financialInstitutionDetails = financialInstitutionDetails;
        if(rd.Disbursement__r.Current_Balance__c!=null) {
            accountClosure.currentBalance = String.valueOf(roundOffAmount(rd.Disbursement__r.Current_Balance__c));
        }
        if(rd.Disbursement__r.Valid_Until_Date__c!=null) {
            accountClosure.dateOfBalance = formatData(rd.Disbursement__r.Valid_Until_Date__c);
            /*String dateOfBalance = String.valueOf(rd.Disbursement__r.Valid_Until_Date__c);
            String[] dateSplit = dateOfBalance.split('-');
            if(dateSplit.size()==3) {
                accountClosure.dateOfBalance = dateSplit[0] + '/' + dateSplit[1] + '/' + dateSplit[2];
            }*/           
        }
        //Added Non-LFS Card & Overdraft Closure - BPAY By Suneel - Mapping Account Number as Biller Short Name for Disbursement - Cheque Removal Disbursement - 19/12/2017
        if(rd.Disbursement__r.Amount__c!=null) {
            if(rd.Disbursement__r.Record_Type_Name__c == GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE
               || rd.Disbursement__r.Record_Type_Name__c == GEN_OriginationsConstants.GE_CARD_CLOSURE_WITHOUT_INTEREST_FREE
               || rd.Disbursement__r.Record_Type_Name__c == GEN_OriginationsConstants.NON_GE_CARD_OVERDRAFT_CLOSURE || rd.Disbursement__r.Record_Type_Name__c == 'Non-LFS Card & Overdraft Closure - BPAY'){
               
                accountClosure.disbursementAmount = String.valueOf(rd.Disbursement__r.Amount__c); 
            }                     
        }
         
        return accountClosure;
        
    }
    
    /**  Description: Creates Account Limit Reduction document mapping
    *  Author: Dan Crisologo
    *  Date Created: 02-13-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.AccountLimitReduction
    */
    public static GenerateDocumentGeComOriginations.AccountLimitReduction createAccountLimitReduction(Related_Document__c rd, IS_ApplicationDTO appDTO) {
        //create Department
        
        GenerateDocumentGeComOriginations.Department department;
        if(appDTO.branch != null){
            department = generateDepartment(appDTO.branch);
        }
        
        //create document contact
        
        String fin1 = rd.Disbursement__r.Financial_Institution_Address_1__c != null ? rd.Disbursement__r.Financial_Institution_Address_1__c : '';
        String fin2 = rd.Disbursement__r.Financial_Institution_Address_2__c != null ? rd.Disbursement__r.Financial_Institution_Address_2__c : '';
        
        string addressLineOne;
        string addressLineTwo;
        
        if(appDTO.app.Brand_Country__c == 'AU'){
          addressLineOne = fin1 + ' ' + fin2;
        }else if(appDTO.app.Brand_Country__c == 'NZ'){
          addressLineOne = fin1;
          if(fin2 != NULL && fin2 != ''){
            addressLineTwo = fin2;
          }
        }
        
    GenerateDocumentGeComOriginations.Address finAddress = generateDocumentContactAddress (null, 
                                                                                 addressLineOne, 
                                                                                 addressLineTwo, 
                                                                                 null, 
                                                                                 rd.Disbursement__r.Financial_Institution_Suburb__c, 
                                                                                 rd.Disbursement__r.Financial_Institution_State__c, 
                                                                                 String.valueOf(rd.Disbursement__r.Financial_Institution_Postcode__c), 
                                                                                 null,null,null,null,null,null);
        if(appDTO.app.Brand_Country__c == 'NZ'){
          finAddress.city = rd.Disbursement__r.Financial_Institution_City__c;
        finAddress.suburb = rd.Disbursement__r.Financial_Institution_Suburb__c;
        }
        //create financial institution details
        GenerateDocumentGeComOriginations.financialInstitutionDetails financialInstitutionDetails = generateFinancialInstitutionDetails(rd.Disbursement__r.Fin_Institution__c, finAddress);
        
        //create contact list based on applicable parties
        GenerateDocumentGeComOriginations.ContactList contactCollection;
        
        if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH) {
            contactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        } else if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2) {
            contactCollection = generateContactList(appDTO.applicant2, null);
        } else {
            contactCollection = generateContactList(appDTO.applicant, null);
        }
        
        //create account closure
        GenerateDocumentGeComOriginations.AccountLimitReduction limitReduction = new GenerateDocumentGeComOriginations.AccountLimitReduction();

        limitReduction.accountType = rd.Disbursement__r.Disbursement_Account_Type__c;
        limitReduction.productName = rd.Disbursement__r.Product_Name__c;
        
        if(refinanceDisbursement == rd.Disbursement__r.recordTypeId) {
            limitReduction.accountNumber = rd.Disbursement__r.Bank_Acc_No__c;
        } else {
          if(appDTO.app.Brand_Country__c == 'AU'){
              limitReduction.accountNumber = rd.Disbursement__r.Payee__c;
              //Added By Suneel - Mapping Account Number as Biller Short Name for Disbursement - Cheque Removal Disbursement - 19/12/2017
              if(rd.Disbursement__r.Disbursement_Type_Code__c == '004')
              {
                 //limitReduction.accountNumber = rd.Disbursement__r.Biller_Short_Name__c;
                   limitReduction.accountNumber = rd.Disbursement__r.BillerShortName__c;
              }
          }else if(appDTO.app.Brand_Country__c == 'NZ'){
            if(rd.Disbursement__r.Disbursement_Account_Type__c == 'Credit Card'){
              if(rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c != null){ 
                string creditcardNumber = '';
                Integer length = rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.length();
                if(rd.Disbursement__r.Card_Number_or_3rd_Party_Ref__c != null && length > 8){
                  creditcardNumber = creditcardNumber + rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.subString(0,4);
                  Integer i = 0;
                  while(i<length-8){
                    creditcardNumber = creditcardNumber + '*';
                    i++;
                  }
                  creditcardNumber = creditcardNumber + rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c.subString(length-4, length);
                }else{
                  creditcardNumber = rd.Disbursement__r.card_Number_or_3rd_Party_Ref__c;
                }
                limitReduction.accountNumber = creditcardNumber;
              }
            }else{
              limitReduction.accountNumber = rd.Disbursement__r.Card_Number_or_3rd_Party_Ref__c;
            }
            
          }
        }
        
        limitReduction.contactCollection = contactCollection;
        limitReduction.department = department;
        limitReduction.financialInstitutionDetails = financialInstitutionDetails; 
        if(rd.Disbursement__r.Current_Balance__c!=null) {
            limitReduction.currentBalance = String.valueOf(roundOffAmount(rd.Disbursement__r.Current_Balance__c));
        }
        if(rd.Disbursement__r.New_Credit_Limit__c!=null) {
            limitReduction.newCreditLimit = String.valueOf(rd.Disbursement__r.New_Credit_Limit__c);
        }

        return limitReduction;
        
    }
    
    /**  Description: Creates Payout Statement document mapping
    *  Author: Dan Crisologo
    *  Date Created: 02-13-14
    *  Input Parameters: Related_Document__c rd, IS_ApplicationDTO appDTO
    *  Return: GenerateDocumentGeComOriginations.PayoutStatement
    */
    public static GenerateDocumentGeComOriginations.PayoutStatement createPayoutStatement(Related_Document__c rd, IS_ApplicationDTO appDTO) {
        
        //create contact list based on applicable parties
        GenerateDocumentGeComOriginations.ContactList contactCollection;
        
        if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH) {
            contactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        } else if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2) {
            contactCollection = generateContactList(appDTO.applicant2, null);
        } else {
            contactCollection = generateContactList(appDTO.applicant, null);
        }
        
        //create Payout Statement 
        Boolean isOnline = false;
        if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE) {
            isOnline = true;
        }
        
        GenerateDocumentGeComOriginations.PayoutStatementDetails payoutStatementDetails = generatePayoutStatementDetails(rd, String.valueOf(isOnline));
        
        GenerateDocumentGeComOriginations.PayoutStatement payoutStatement = new GenerateDocumentGeComOriginations.PayoutStatement();
        
        //create Department
        if(appDTO.branch != null){
            GenerateDocumentGeComOriginations.Department department = generateDepartment(appDTO.branch);
            payoutStatement.Department = department;
        }       
        payoutStatement.ContactCollection = contactCollection;
        payoutStatement.PayoutStatementDetails = payoutStatementDetails;

        return payoutStatement;
        
    }
    
    /**  Description: Creates Objective And Requirements for Generate Document service
    *  Author: Dan Crisologo
    *  Date Created: 02-14-14
    *  Input Parameters: Related_Document__c rd, IS_ApplicationDTO appDTO
    *  Return: GenerateDocumentGeComOriginations.ObjectiveAndRequirements    
    */
    public static GenerateDocumentGeComOriginations.ObjectiveAndRequirements createONRDocument(Related_Document__c rd, IS_ApplicationDTO appDTO){
    
        GenerateDocumentGeComOriginations.ObjectiveAndRequirements onrDoc = new GenerateDocumentGeComOriginations.ObjectiveAndRequirements();
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            onrDoc.isJointCustomers = 'false';
        }
        else{
            onrDoc.isJointCustomers = 'true';
        }
        
        //create contact collections
        onrDoc.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        
        //create Payout Statement 
        String isOnline = 'false';
        if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE) {
            isOnline = 'true';
        }
        
        onrDoc.OnRInformation = generateOnRInformation(rd, 
                                                       appDTO.app,
                                                       appDTO.collateralList,
                                                       appDTO.applicant,
                                                       appDTO.applicant2,
                                                       appDTO.insuranceList,
                                                       appDTO.loanPurList,
                                                       isOnline,
                                                       appDTO.product);
        
        return onrDoc;
    
    }
 
    /* Description: Method that maps values into PayoutStatementDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 13-02-14
    *  Input Parameters: Related_Document__c rd, String isOnline    
    *  Return: GenerateDocumentGeComOriginations.PayoutStatementDetails
    */
    public static GenerateDocumentGeComOriginations.PayoutStatementDetails generatePayoutStatementDetails(Related_Document__c rd, String isOnline){
        
        GenerateDocumentGeComOriginations.PayoutStatementDetails payoutStatementDetails = new GenerateDocumentGeComOriginations.PayoutStatementDetails();
        
        if(refinanceDisbursement == rd.Disbursement__r.recordTypeId) {
            payoutStatementDetails.accountNumber = rd.Disbursement__r.Bank_Acc_No__c;
        } else {
            payoutStatementDetails.accountNumber = rd.Disbursement__r.Payee__c;
        }
        if(rd.Disbursement__r.Payout_Effective_Date__c != null){
           /*String payoutEffective = String.valueOf(rd.Disbursement__r.Payout_Effective_Date__c);
           String[] dateSplit = payoutEffective.split('-');
           if(dateSplit.size()==3) {
               payoutStatementDetails.payoutStatementDate = dateSplit[0] + '/' + dateSplit[1] + '/' + dateSplit[2];
           }*/
           payoutStatementDetails.payoutStatementDate = formatData(rd.Disbursement__r.Payout_Effective_Date__c);
        }
        if(rd.Disbursement__r.Principal_Amount__c!=null) {
            payoutStatementDetails.principalAmount = String.valueOf(roundOffAmount(rd.Disbursement__r.Principal_Amount__c));
        }
        if(rd.Disbursement__r.Interest_Due__c!=null) {
            payoutStatementDetails.interestDue = String.valueOf(rd.Disbursement__r.Interest_Due__c);
        }
        if(rd.Disbursement__r.Late_Fees_Due__c!=null) {
            payoutStatementDetails.lateFeesDue = String.valueOf(rd.Disbursement__r.Late_Fees_Due__c);
        }
        if(rd.Disbursement__r.Penalty_Interest_Due__c!=null) {
            payoutStatementDetails.penaltyInterestDue = String.valueOf(rd.Disbursement__r.Penalty_Interest_Due__c);
        }
        if(rd.Disbursement__r.Fees_or_Charges_Due__c!=null) {
            payoutStatementDetails.feesOrChargesDue = String.valueOf(rd.Disbursement__r.Fees_or_Charges_Due__c);
        }
        if(rd.Disbursement__r.Charge_Off_Amount__c!=null) {
            payoutStatementDetails.charge_offAmount = String.valueOf(roundOffAmount(rd.Disbursement__r.Charge_Off_Amount__c));
        }
        if(rd.Disbursement__r.Insurance_Rebate__c!=null) {
            payoutStatementDetails.insuranceRebate = String.valueOf(roundOffAmount(rd.Disbursement__r.Insurance_Rebate__c));
        }
        if(rd.Disbursement__r.Early_Termination_Fee__c!=null) {
            payoutStatementDetails.earlyTerminationFee = String.valueOf(roundOffAmount(rd.Disbursement__r.Early_Termination_Fee__c));
        }
        if(rd.Disbursement__r.Net_Payoff_Due__c!=null) {
            payoutStatementDetails.netPayoffDue = String.valueOf(rd.Disbursement__r.Net_Payoff_Due__c);
        }
        payoutStatementDetails.isOnline = isOnline;
        
        return payoutStatementDetails;
    }
    
    /* Description: Method that maps values into OnRInformation WSobject
    *  Author: Dan Crisologo
    *  Date Created: 14-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.OnRInformation
    */
    public static GenerateDocumentGeComOriginations.OnRInformation generateOnRInformation(Related_Document__c rd, 
                                                                                          Application__c app,
                                                                                          List<Collateral__c> collaterals,
                                                                                          Applicant__c applicant1,
                                                                                          Applicant__c applicant2,
                                                                                          List<Product_Item__c> prodItemList,
                                                                                          List<Loan_Purpose__c> loanPurList,
                                                                                          String isOnline,
                                                                                          GEProduct__c product){
        
        GenerateDocumentGeComOriginations.OnRInformation onRInformation = new GenerateDocumentGeComOriginations.OnRInformation();

        //onRInformation.loanType = product.Description__c;  
        
        //Added by Suneel -- Better Start        
        Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
        if(app.Product_SubType__c == 'Better Start PL' && app.Brand_Country__c == 'AU' && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
        onRInformation.loanType = 'Better Start Personal Loan';
        }else{
        onRInformation.loanType = product.Description__c; 
        }                 
        //Production bug fix #INC115041 
        if(app.Product_SubType__c!=null){
        onRInformation.productSubType = app.Product_SubType_Code__c;
        }else{
        onRInformation.productSubType = 'STD';
        }
        //End
        if(app.Offered_Interest_Rate__c!=null) {
            onRInformation.fixedInterestRate = String.valueOf(app.Offered_Interest_Rate__c);
        }
        if(app.EMI_with_Service_Fee__c!=null) {
            onRInformation.eachMonthlyRepaymentAmount = String.valueOf(roundOffAmount(app.EMI_with_Service_Fee__c));
        }
        if(app.Offered_Frequency_Repayments__c!=null) {
            //onRInformation.noOfRepayments = String.valueOf(app.Loan_Term_Months__c);
             Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);
             if((app.Product_SubType__c == 'Better Start PL') &&  app.Brand_Country__c == 'AU' && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){  
                     Integer actualTerm = Integer.valueOf(app.Loan_Term_Months__c);
                     Integer bsLoanTerm = actualTerm + lterm;
                     onRInformation.noOfRepayments = String.valueOf(bsLoanTerm );
             }else{
                     onRInformation.noOfRepayments = String.valueOf(app.Loan_Term_Months__c);
                  }
        }
        //Decimal brokerFee = app.Brokerage_Fee__c != null ? app.Brokerage_Fee__c : 0;
        onRInformation.totalAmountOfCredit = String.valueOf(roundOffAmount(app.Total_Loan_Amount_with_Insurance__c));
        
        onRInformation.isMortgage = 'false';
        if(collaterals != null){
            if(!collaterals.isEmpty()) {
                onRInformation.MortgageDetailsCollection = generateMortgageDetailsCollection(app, collaterals, applicant1, applicant2);
                onRInformation.isMortgage = 'true';
            }
        }
        
        onRInformation.isInsurance = 'false';
        if(prodItemList != null){
            if(prodItemList.size()>0){
                Boolean hasInsurance = false;
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                           hasInsurance = true;
                     }   
                }
                if(hasInsurance){
                    onRInformation.isInsurance = 'true';
                    onRInformation.InsuranceDetails = generateInsuranceDetails(app,prodItemList);
                }
            }
        }
          
        onRInformation.isOnline = isOnline;
        
        if(loanPurList != null){
            onRInformation.LoanPurposeCollection = generateLoanPurposeCollection(loanPurList);
        }
                
        return onRInformation;
    }
    
    /* Description: Method that maps values into LoanPurposeCollection WSobject
    *  Author: Dan Crisologo
    *  Date Created: 05-06-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.LoanPurposeCollection
    */
    public static GenerateDocumentGeComOriginations.LoanPurposeCollection generateLoanPurposeCollection(List<Loan_Purpose__c> loanPurpose) { 
        
        GenerateDocumentGeComOriginations.LoanPurposeCollection loanPurposeCollection = new GenerateDocumentGeComOriginations.LoanPurposeCollection();
        List<GenerateDocumentGeComOriginations.LoanPurpose> loanPurposeList = new List<GenerateDocumentGeComOriginations.LoanPurpose>();
        for(Loan_Purpose__c lp: loanPurpose) {
            GenerateDocumentGeComOriginations.LoanPurpose newLP = new GenerateDocumentGeComOriginations.LoanPurpose();
            newLP.loanPurposeAmount = String.valueOf(roundOffAmount(lp.Loan_Amount__c));
            newLP.loanPurpose = lp.Value__c;
            newLP.loanPurposeDescription = lp.Other_Loan_Purpose__c;
            loanPurposeList.add(newLP);
        }
        loanPurposeCollection.LoanPurpose = loanPurposeList;
        return loanPurposeCollection;
        
    }
    
    //LPI
    
    /* Description: Method that maps values into LoanProtectionInsurance WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.LoanProtectionInsurance(
    */
    public static GenerateDocumentGeComOriginations.LoanProtectionInsurance generateLoanProtectionInsurance(IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.LoanProtectionInsurance loanProtectionInsurance = new GenerateDocumentGeComOriginations.LoanProtectionInsurance();
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            loanProtectionInsurance.isJointCustomers = 'false';
        }
        else{
            loanProtectionInsurance.isJointCustomers = 'true';
        }
        
        loanProtectionInsurance.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        if(appDTO.branch != null){
            loanProtectionInsurance.Department = generateDepartment(appDTO.branch);
        }
        loanProtectionInsurance.loanProtectionInsuranceInformation = generateLoanProtectionInsuranceInformation(appDTO.app, appDTO.insuranceList);
        
        return loanProtectionInsurance;
    }
    
    
    /* Description: Method that maps values into LoanProtectionInsuranceInformation WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.LoanProtectionInsuranceInformation
    */
    public static GenerateDocumentGeComOriginations.LoanProtectionInsuranceInformation generateLoanProtectionInsuranceInformation(Application__c application, List<Product_Item__c> prodItemList){
        
        GenerateDocumentGeComOriginations.LoanProtectionInsuranceInformation loanProtectionInsuranceInformation = new GenerateDocumentGeComOriginations.LoanProtectionInsuranceInformation();
        
        loanProtectionInsuranceInformation.applicationNo = application.UID__c;
        loanProtectionInsuranceInformation.InsuranceDetails = generateInsuranceDetails(application, prodItemList);
        loanProtectionInsuranceInformation.isOnline = 'false';
        //The following field was added by TXU due to the rebranding change
        loanProtectionInsuranceInformation.eachMonthlyRepaymentAmount = String.valueof(roundOffAmount(application.Offered_Repayments__c));
        if(application.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            loanProtectionInsuranceInformation.isOnline = 'true';
        }

        return loanProtectionInsuranceInformation;
    }
    
    //Direct Debit    
    
    /* Description: Method that maps values into DirectDebitRequest WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DirectDebitRequest
    */
    public static GenerateDocumentGeComOriginations.DirectDebitRequest generateDirectDebitRequest(IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.DirectDebitRequest directDebitRequest = new GenerateDocumentGeComOriginations.DirectDebitRequest();
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            directDebitRequest.isJointCustomers = 'false';
        }
        else{
            directDebitRequest.isJointCustomers = 'true';
        }
        directDebitRequest.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        system.debug('===debug====='+appDTO.applicationDebits);
        if(appDTO.applicationDebits!=null) {
            if(!appDTO.applicationDebits.isEmpty()) {
                for(Debit__c debit: appDTO.applicationDebits) {
                    directDebitRequest.directDebitInformation = generateDirectDebitInformation(appDTO.app,appDTO.applicant, debit);
                    break;
                }
            }
        }
        
        return directDebitRequest;
    }
    
    /* Description: Method that maps values into DirectDebitInformationt WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DirectDebitInformation
    */
  public static GenerateDocumentGeComOriginations.DirectDebitInformation generateDirectDebitInformation(Application__c application, Applicant__c applicant,Debit__c debit){
        
        GenerateDocumentGeComOriginations.DirectDebitInformation directDebitInformation = new GenerateDocumentGeComOriginations.DirectDebitInformation();
        
        directDebitInformation.applicationNo = application.UID__c;
        //Better Start -- Added by Suneel
         Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
         if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartAUActive__c == true) && application.Brand_Country__c == 'AU'){
             directDebitInformation.productSubType = application.Product_SubType_Code__c;
         } else if((application.Product_SubType__c == 'Standard PL' || application.Product_SubType__c == NULL)&& (bsOffer.BetterStartAUActive__c == false) && application.Brand_Country__c == 'AU') {
             directDebitInformation.productSubType = 'STD';
         } else if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartAUActive__c == false) && application.Brand_Country__c == 'AU'){
             directDebitInformation.productSubType = application.Product_SubType_Code__c;
         }
       // Better Start phase 2 - Direct Debit information update for productSubType value Null       
         if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartNZActive__c == true) && application.Brand_Country__c == 'NZ'){
             directDebitInformation.productSubType = application.Product_SubType_Code__c;
         }  else if((application.Product_SubType__c == 'Standard PL' || application.Product_SubType__c == NULL)&& (bsOffer.BetterStartNZActive__c == false) && application.Brand_Country__c == 'NZ') {
             directDebitInformation.productSubType = 'STD';
         }  else if((application.Product_SubType__c == 'Better Start PL' || application.Product_SubType__c == 'Standard PL') && (bsOffer.BetterStartNZActive__c == false) && application.Brand_Country__c == 'NZ'){
             directDebitInformation.productSubType = application.Product_SubType_Code__c;
         } 
        //End           
        if(application.Brand_Country__c == 'AU'){
          directDebitInformation.bankAccountDetails = generateBankAccountDetails(applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c,debit.Account_Holders__c,debit.Bank_Name__c,debit.Branch_Location__c,debit.BSB_Number__c,debit.Account_Number__c,debit.Branch_Number__c,debit.Suffix_Number__c, application.Brand_Country__c);
        }else if (application.Brand_Country__c == 'NZ'){
          directDebitInformation.bankAccountDetails = generateBankAccountDetails(applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c,debit.Account_Holders__c,debit.Bank_Name__c,debit.Branch_Location__c,debit.Bank_Number__c,debit.Account_Number__c,debit.Branch_Number__c,debit.Suffix_Number__c, application.Brand_Country__c);          
        }
        directDebitInformation.repaymentDetails = generateDocumentRepaymentDetails(debit);
        directDebitInformation.isOnline = 'false';
        if(application.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            directDebitInformation.isOnline = 'true';
        }
        return directDebitInformation;
    }
    
        
    /* Description: Method that maps values into BankAccountDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.BankAccountDetails
    * updated 20-Feb-2015 : DBHZL-198 Direct Debit form changes - devendra
    */
    public static GenerateDocumentGeComOriginations.BankAccountDetails generateBankAccountDetails(string firstName,string middleName,String lastName,String accHolder, 
                                                                                                  String bankName,
                                                                                                  String branch,
                                                                                                  String bsb,
                                                                                                  String accountNumber,string branchNumber,string suffix, string country){
        GenerateDocumentGeComOriginations.BankAccountDetails bankAccountDetails = new GenerateDocumentGeComOriginations.BankAccountDetails();
        
        bankAccountDetails.accountHolderNames = accHolder;
        bankAccountDetails.bankName = bankName;
        bankAccountDetails.branch = branch;
        bankAccountDetails.bsbNumber = bsb;
        bankAccountDetails.accountNumber = accountNumber;
        bankAccountDetails.branchNumber = branchNumber;
        bankAccountDetails.suffixNumber = suffix;
        if(country == 'AU'){
        bankAccountDetails.payerReference=lastName!=null?lastName+' ':''+firstName!=null?firstName.substring(0, 1):''+middleName!=null?' '+middleName.substring(0, 1):'';
        }else if(country == 'NZ'){
          string reference = '';
          if(lastName != null && lastName != ''){
            if(lastName.length() > 8){
              reference = reference+lastname.substring(0,8);
            }else{
              reference = reference+lastname;
            }           
          }
          
          if(firstName != null && firstName != ''){
            reference = reference + ','+firstName.substring(0,1);
          }
          
          if(middleName != null && middleName != ''){
            system.debug('=====debug middlename===='+middleName);
            reference = reference + ',' + middleName.substring(0,1);
            }       
            
            bankAccountDetails.payerReference = reference;
        }
        return bankAccountDetails;
    }
    
    /* Description: Method that maps values into BPAY Related Generated Documents
    *  Author: Suneel Desiraju
    *  Date Created: 26/12/2017
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.BankAccountDetails
    */
     public static GenerateDocumentGeComOriginations.BankAccountDetails generateBPayBankAccountDetails(string firstName,string middleName,String lastName,String accHolder, 
                                                                                                  String bankName,
                                                                                                  String branch,
                                                                                                  String bsb,
                                                                                                  String accountNumber,string branchNumber,string suffix, string country,string disbursementType,string billerName,string billerCode,string reference,decimal amount){
        GenerateDocumentGeComOriginations.BankAccountDetails bankAccountDetails = new GenerateDocumentGeComOriginations.BankAccountDetails();
        
        bankAccountDetails.accountHolderNames = accHolder;
        bankAccountDetails.bankName = bankName;
        bankAccountDetails.branch = branch;
        bankAccountDetails.bsbNumber = bsb;
        bankAccountDetails.accountNumber = accountNumber;
        bankAccountDetails.branchNumber = branchNumber;
        bankAccountDetails.suffixNumber = suffix;
        bankAccountDetails.billerName = billerName;
        bankAccountDetails.disbursementType = disbursementType;
        bankAccountDetails.billerCode = billerCode;
        bankAccountDetails.reference = reference;
        //bankAccountDetails.amount = formatData(roundOffAmount(amount));
        bankAccountDetails.amount = string.valueOf(roundOffAmount(amount));
        if(country == 'AU'){
        bankAccountDetails.payerReference=lastName!=null?lastName+' ':''+firstName!=null?firstName.substring(0, 1):''+middleName!=null?' '+middleName.substring(0, 1):'';
        }else if(country == 'NZ'){
          string referenceName = '';
          if(lastName != null && lastName != ''){
            if(lastName.length() > 8){
              referenceName = referenceName +lastname.substring(0,8);
            }else{
              referenceName = referenceName +lastname;
            }           
          }
          
          if(firstName != null && firstName != ''){
            referenceName = referenceName + ','+firstName.substring(0,1);
          }
          
          if(middleName != null && middleName != ''){
            system.debug('=====debug middlename===='+middleName);
            referenceName = referenceName + ',' + middleName.substring(0,1);
            }       
            
            bankAccountDetails.payerReference = referenceName ;
            
        }
        return bankAccountDetails;
    }
    
   /* Description: Method that maps values into DocumentRepaymentDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: Debit__c
    *  Return: GenerateDocumentGeComOriginations.RepaymentDetails
    */
    public static GenerateDocumentGeComOriginations.RepaymentDetails generateDocumentRepaymentDetails(Debit__c debit){
        
        GenerateDocumentGeComOriginations.RepaymentDetails documentRepaymentDetails = new GenerateDocumentGeComOriginations.RepaymentDetails();
        
        documentRepaymentDetails.ddFrequency = debit.Frequency_Code__c;
        if(debit.Commencement_Date__c!=null){
           /*String commencement = String.valueOf(debit.Commencement_Date__c);
           String[] dateSplit = commencement.split('-');
           if(dateSplit.size()==3) {
               documentRepaymentDetails.ddStartDate = dateSplit[0] + '/' + dateSplit[1] + '/' + dateSplit[2];
           }*/
            documentRepaymentDetails.ddStartDate = String.valueOf(debit.Commencement_Date__c);
        }
              
        if(debit.Specify_Higher_Amount__c!=null) {
            documentRepaymentDetails.ddHigherAmt = String.valueOf(debit.Specify_Higher_Amount__c);
        } else {
            documentRepaymentDetails.ddHigherAmt = '';
        }

        documentRepaymentDetails.ddMinAmtWeek = String.valueOf(debit.Minimum_Weekly_Amount_Currency__c);
        documentRepaymentDetails.ddMinAmtFortnight = String.valueOf(debit.Minimum_Fortnightly_Amount_Currency__c);
        documentRepaymentDetails.ddMinAmtMonthly = String.valueOf(debit.Minimum_Monthly_Amount_Currency__c);

        
        return documentRepaymentDetails;
    }
    
    /*** Better Start Added By Suneel **/
   
   public static GenerateDocumentGeComOriginations.repaymentPeriods  generateDocumentRepaymentPeriodDetails(List<Debit__c> debit,Application__c application){
      GenerateDocumentGeComOriginations.repaymentPeriods  repaymentPeriodsArray = new GenerateDocumentGeComOriginations.repaymentPeriods();
      List<GenerateDocumentGeComOriginations.repaymentPeriod> repaymentPeriodsList = new List<GenerateDocumentGeComOriginations.repaymentPeriod>();
      Id appId = ApexPages.currentPage().getParameters().get('id');
      try{
      Debit__c debitResult = [select Application__r.Product_SubType__c from Debit__c where Application__r.id=:appId ];
      Integer i=0;

      do{
             for(Debit__c d: debit){             
             GenerateDocumentGeComOriginations.repaymentPeriod documentRepaymentDetails = new GenerateDocumentGeComOriginations.repaymentPeriod(); 
               /* if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1 && d.Application__r.Brand_Country__c == 'AU'){
                documentRepaymentDetails.introinterestRate  = 0.0;
                documentRepaymentDetails.numberOfRepayments = 3;
                documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                documentRepaymentDetails.combinedRepaymentAmount =roundOffAmount(application.EMI_with_Service_Fee__c);
                documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                }else{
                 documentRepaymentDetails.introinterestRate  = d.Application__r.Offered_Interest_Rate__c;
                documentRepaymentDetails.numberOfRepayments = d.Application__r.Loan_Term_Months__c;
                documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                documentRepaymentDetails.combinedRepaymentAmount = roundOffAmount(application.EMI_with_Service_Fee__c);
                documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);

                } */
               Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
               if(d.Application__r.Brand_Country__c == 'AU'){           
                                System.debug('bsOffer Active'+bsOffer.BetterStartAUActive__c);
                                  if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1  && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
                                        documentRepaymentDetails.introinterestRate  = 0.0;
                                        documentRepaymentDetails.numberOfRepayments = Decimal.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount =roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                                        }else if(bsOffer.BetterStartAUActive__c == true) {
                                         documentRepaymentDetails.introinterestRate  = d.Application__r.Offered_Interest_Rate__c;
                                        documentRepaymentDetails.numberOfRepayments = d.Application__r.Loan_Term_Months__c;
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount = roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                                        }else if(bsOffer.BetterStartAUActive__c == false){
                                        System.debug('Now it is entered in this section');
                                        documentRepaymentDetails.introinterestRate  = d.Application__r.Offered_Interest_Rate__c;
                                        documentRepaymentDetails.numberOfRepayments = d.Application__r.Loan_Term_Months__c;
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount = roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                                        }                                  
                               }else if(d.Application__r.Brand_Country__c == 'NZ'){
                                        if(d.Application__r.Product_SubType__c == 'Better Start PL' && i==1  && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false)){
                                        documentRepaymentDetails.introinterestRate  = 0.0;
                                        documentRepaymentDetails.numberOfRepayments = Decimal.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount =roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                                        }else if(bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false) {
                                         documentRepaymentDetails.introinterestRate  = d.Application__r.Offered_Interest_Rate__c;
                                        documentRepaymentDetails.numberOfRepayments = d.Application__r.Loan_Term_Months__c;
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount = roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);

                                        }
                               }
                                     /*if(d.Application__r.Brand_Country__c == 'AU'){
                               
                                     if (bsOffer.BetterStartAUActive__c == false || d.Application__r.Product_SubType__c == null){
                                       System.debug('Non Better Start success');
                                        documentRepaymentDetails.introinterestRate  = d.Application__r.Offered_Interest_Rate__c;
                                        documentRepaymentDetails.numberOfRepayments = d.Application__r.Loan_Term_Months__c;
                                        documentRepaymentDetails.monthlyRepaymentAmount = roundOffAmount(application.Offered_Repayments__c);
                                        documentRepaymentDetails.combinedRepaymentAmount = roundOffAmount(application.EMI_with_Service_Fee__c);
                                        documentRepaymentDetails.periodStartDate = String.valueOf(d.Commencement_Date__c);
                                        }      
                                        }*/
                                               

                repaymentPeriodsList.add(documentRepaymentDetails);
                }
                
                i++;
        }
        while(i<2 && debitResult.Application__r.Product_SubType__c == 'Better Start PL');
        repaymentPeriodsArray.repaymentPeriod = repaymentPeriodsList;
        }catch(System.QueryException e){
            System.debug('SQL Exception for Record occured');
        }catch(System.NULLPointerException e1){
            System.debug('Null pointer exception occured');
        }
        System.debug('Repayment Period Array ++++++'+repaymentPeriodsArray.repaymentPeriod);
        return repaymentPeriodsArray;
      

    }
   /** End **/
    //Privacy Notice
    
    /* Description: Method that maps values into PrivacyNotice WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.PrivacyNotice
    */
    public static GenerateDocumentGeComOriginations.PrivacyNotice generatePrivacyNotice(IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.PrivacyNotice privacyNotice = new GenerateDocumentGeComOriginations.PrivacyNotice();
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            privacyNotice.isJointCustomers = 'false';
        }
        else{
            privacyNotice.isJointCustomers = 'true';
        }
        privacyNotice.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        
        privacyNotice.isOnline = 'false';
        if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            privacyNotice.isOnline = 'true';
        }
        
        privacyNotice.isContractAcceptedOnline = 'false';
        if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            privacyNotice.isContractAcceptedOnline = 'true';
        }
        return privacyNotice;
    }
    
    //IF Rebate
    
    /* Description: Method that maps values into InterestFreeRebate WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.InterestFreeRebate
    */
    public static GenerateDocumentGeComOriginations.InterestFreeRebate generateInterestFreeRebate(Related_Document__c rd, IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.InterestFreeRebate interestFreeRebate = new GenerateDocumentGeComOriginations.InterestFreeRebate();
            
            if(appDTO.branch != null){
                interestFreeRebate.Department = generateDepartment(appDTO.branch);
            }
            
            //create contact list based on applicable parties
            GenerateDocumentGeComOriginations.ContactList contactCollection;
            
            if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH) {
                contactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
            } else if(rd.Disbursement__r.Applicable_Party__c == GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2) {
                contactCollection = generateContactList(appDTO.applicant2, null);
            } else {
                contactCollection = generateContactList(appDTO.applicant, null);
            }
            
            interestFreeRebate.ContactCollection = contactCollection;
            
            List<Disbursement_Plan__c> relatedDPList = new List<Disbursement_Plan__c>();
            for(Disbursement_Plan__c dp: appDTO.disbursementPlanList) {
                if(rd.disbursement__c == dp.disbursement__c) {
                    relatedDPList.add(dp);
                }
            }
            
            interestFreeRebate.interestFreeRebateDetailsCollection = generateInterestFreeRebateDetailsList(relatedDPList);
            if(relatedDPList != null){
                if(relatedDPList.size()>0){
                    Decimal totalCreditPlan = 0;
                    Decimal totalRebateAmt = 0;
                    for(Disbursement_Plan__c disbursements: relatedDPList){
                        interestFreeRebate.GECardNumber = disbursements.Disbursement__r.Payee__c;
                        totalCreditPlan = disbursements.Disbursement__r.Total_IF_Credit_Plan_Balance__c != null ? disbursements.Disbursement__r.Total_IF_Credit_Plan_Balance__c : 0;
                        totalRebateAmt = disbursements.Disbursement__r.Total_Rebate_Amount__c != null ? disbursements.Disbursement__r.Total_Rebate_Amount__c: 0;
                        interestFreeRebate.accountNumber = disbursements.Disbursement__r.Payee__c;
                    }
                    interestFreeRebate.ifTotalCreditPlanCurrBalance = String.valueOf(roundOffAmount(totalCreditPlan));
                    interestFreeRebate.ifTotalRebateAmount = String.valueOf(roundOffAmount(totalRebateAmt));
                }
            }
            interestFreeRebate.isOnline = 'false';
            if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
                interestFreeRebate.isOnline = 'true';
            }

        return interestFreeRebate;
    }
    
    /* Description: Method that maps values into InterestFreeRebateDetailsList WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList
    */
    public static GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList generateInterestFreeRebateDetailsList(List<Disbursement_Plan__c> disbursementPlanList){
        
        GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList interestFreeRebateDetailsList = new GenerateDocumentGeComOriginations.InterestFreeRebateDetailsList();
            
            List<GenerateDocumentGeComOriginations.InterestFreeRebateDetails> interestDetails = new List<GenerateDocumentGeComOriginations.InterestFreeRebateDetails>();
            for(Disbursement_Plan__c disbursement:disbursementPlanList){
                interestDetails.add(generateInterestFreeRebateDetails(disbursement));
            }
            interestFreeRebateDetailsList.interestFreeRebateDetails = interestDetails;
        
        return interestFreeRebateDetailsList;
    }
    
    /* Description: Method that maps values into InterestFreeRebateDetails WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.InterestFreeRebateDetails
    */
    public static GenerateDocumentGeComOriginations.InterestFreeRebateDetails generateInterestFreeRebateDetails(Disbursement_Plan__c disbursementPlan){
        
        GenerateDocumentGeComOriginations.InterestFreeRebateDetails interestFreeRebateDetails = new GenerateDocumentGeComOriginations.InterestFreeRebateDetails();
            
        interestFreeRebateDetails.ifCreditPlanNumber = disbursementPlan.IF_Credit_Plan_Number__c;
        interestFreeRebateDetails.ifCreditPlanCurrBalance = String.valueOf(roundOffAmount(disbursementPlan.IF_Current_Credit_Plan_Balance__c));
        interestFreeRebateDetails.ifRebateAmount = String.valueOf(roundOffAmount(disbursementPlan.Rebate_Amount__c));
        
        return interestFreeRebateDetails;
    }
    
    
    /* Description: Method that maps values into signUpLetterNZ WSobject
    *  Author: Devendra
    *  Date Created: 24-02-15
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.signUpLetterNZ
    */
    public static GenerateDocumentGeComOriginations.signUpLetterNZ generatesignUpLetterNZ(Related_Document__c rd, IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.signUpLetterNZ signUpLetterNZ = new GenerateDocumentGeComOriginations.signUpLetterNZ();
            
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            signUpLetterNZ.isJointCustomers = 'false';
        }
        else{
            signUpLetterNZ.isJointCustomers = 'true';
        }

    signUpLetterNZ.creationDate = formatdata(System.today());

        signUpLetterNZ.ContactCollection = generateContactListForNZSignupLetter(appDTO.app,appDTO.applicant, appDTO.applicant2);
        
        signUpLetterNZ.isMortgage = 'false';
        if(appDTO.collateralList != null){
            if(!appDTO.collateralList.isEmpty()) {
                signUpLetterNZ.isMortgage = 'true';
            }
        }
        signUpLetterNZ.isOnline = 'false';
        if(appDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            signUpLetterNZ.isOnline = 'true';
        }

        signUpLetterNZ.applicationNo = appDTO.app.UID__c;
        signUpLetterNZ.productName = appDTO.product.Product_Name__c;
        
      signUpLetterNZ.isInsurance = 'false';
        if(appDTO.insuranceList!= null){
            if(appDTO.insuranceList.size()>0){
                Boolean hasInsurance = false;
                for(Product_Item__c prod:appDTO.insuranceList){
                    if(prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE ||
                       prod.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                           hasInsurance = true;
                     }   
                }
                if(hasInsurance){
                    signUpLetterNZ.isInsurance = 'true';
                }
            }
        }
        
        signUpLetterNZ.isBrokerChannel = 'false'; 
        if(appDTO.app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
            signUpLetterNZ.isBrokerChannel = 'true';    
        }
        
        Boolean hasBrokerInsurance = false;
        if(appDTO.disbursementList != null){
          signUpLetterNZ.securityItemsNo = string.valueOf(appDTO.disbursementList.size());                      
            for(Disbursement__c d:appDTO.disbursementList){
                if(d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE 
                   || d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE_NZ){
                   hasBrokerInsurance = true;
                }
            }
        }
        
        signUpLetterNZ.isBrokerSoldInsurance = 'false';
        if(hasBrokerInsurance){
            signUpLetterNZ.isBrokerSoldInsurance = 'true';
        }
        
        if(appDTO.loanPurList!= null && appDTO.loanPurList.size()>0)signUpLetterNZ.loanPurpose = generateLoanPurposeList(appDTO.loanPurList);
        if(appDTO.assetList!= null && appDTO.assetList.size()>0)signUpLetterNZ.assetDetailsList = generateAssetDetailsList(appDTO.assetList);
        if(appDTO.debtList!= null && appDTO.debtList.size()>0)signUpLetterNZ.debtDetailsList = generateDebtDetailsList(appDTO.debtList,appDTO.app,appDTO.applicant);
        
        signUpLetterNZ.preferredContactMethod = appDTO.applicant.Pref_Contact_Method_Code__c;
        
        if(appDTO.applicationDebits!= null)
        for(Debit__c d: appDTO.applicationDebits) {////there should only ever be 1 max debit
            signUpLetterNZ.repaymentMethod = d.Payment_Method_Code__c;
        }
        
       if(appDTO.branch!=null && appDTO.app!=null)signUpLetterNZ.GEDirect=generateGEDirect(appDTO.branch,appDTO.app);
        
        return signUpLetterNZ;
    }
    
    
    /* Description: Method that maps values into GEDirect WSobject
    *  Author: Devendra
    *  Date Created: 24-02-15
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.GEDirect
    */
    public static GenerateDocumentGeComOriginations.GEDirectType generateGEDirect(Branch__c branch,Application__c app){ 
        GenerateDocumentGeComOriginations.GEDirectType GEDirect=new GenerateDocumentGeComOriginations.GEDirectType();
        GEDirect.branchFaxNumber=branch.Fax__c;
        if(app.Sales_Agent__c!=null)GEDirect.directSalesConsultant=app.Sales_Agent__r.Name;
        return GEDirect;
    }
    
    /* Description: Method that maps values into LoanPurposeCollection WSobject
    *  Author: Devendra
    *  Date Created: 24-02-15
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.LoanPurposeCollection
    */
    public static List<GenerateDocumentGeComOriginations.LoanPurpose> generateLoanPurposeList(List<Loan_Purpose__c> loanPurList) { 
        
        List<GenerateDocumentGeComOriginations.LoanPurpose> loanPurposeList = new List<GenerateDocumentGeComOriginations.LoanPurpose>();
        for(Loan_Purpose__c lp: loanPurList) {
            GenerateDocumentGeComOriginations.LoanPurpose newLP = new GenerateDocumentGeComOriginations.LoanPurpose();
            newLP.loanPurposeAmount = String.valueOf(roundOffAmount(lp.Loan_Amount__c));
            newLP.loanPurpose = lp.Value__c;
            newLP.loanPurposeDescription = lp.Other_Loan_Purpose__c;
            loanPurposeList.add(newLP);
        }
        return loanPurposeList;
        
    }
    
    
    /* Description: Method that maps values into ContactList WSobject
    *  Author: Devendra
    *  Date Created: 24-02-15
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.ContactList
    */
    public static GenerateDocumentGeComOriginations.ContactList generateContactListForNZSignupLetter(Application__c application,Applicant__c applicant1, Applicant__c applicant2){
        
        GenerateDocumentGeComOriginations.ContactList contactList = new GenerateDocumentGeComOriginations.ContactList();
        
        List<Applicant__c> applicantList = new List<Applicant__c>();
        if(applicant1!=null){
            applicantList.add(applicant1);
        }        
        if(applicant2!=null) {
            applicantList.add(applicant2);
        }
        List<GenerateDocumentGeComOriginations.Contact> contacts = new List<GenerateDocumentGeComOriginations.Contact>();
        
        if(applicantList.size()>0){
            for(Applicant__c applicant:applicantList){
                contacts.add(generateContactForNZSignUpLetter(application,applicant));
            }
        } 
        
        contactList.contact = contacts;           
        return contactList;             
    }
    
    
    /* Description: Method that maps values into contact WSobject
    *  Author: Devendra
    *  Date Created: 24-02-15
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.contact
    */
    public static GenerateDocumentGeComOriginations.Contact generateContactForNZSignUpLetter(Application__c application,Applicant__c applicant) {
        
        GenerateDocumentGeComOriginations.Contact contact = new GenerateDocumentGeComOriginations.Contact();
        
        contact.id = applicant.id;
        contact.marriageCertificateFlag = application.MarriageCertificateFlag__c;
        contact.nameChangeDocumenationFlag = application.NameChangeDocumenationFlag__c;
        contact.creditCardStatementFlag = application.CreditCardStatementFlag__c;
        contact.proofofPaymentofDefaultFlag = application.ProofOfPaymentOfDefaultFlag__c;
        GenerateDocumentGeComOriginations.creditReference cf = new GenerateDocumentGeComOriginations.creditReference();
        cf.creditReferenceFlag = application.CreditReferenceFlag__c;
        GenerateDocumentGeComOriginations.proofofPayment pp = new GenerateDocumentGeComOriginations.proofofPayment();
        pp.proofofPaymentflag = application.ProofOfPaymentFlag__c;
        contact.creditReference = cf;
        if(applicant.Is_Primary_Applicant__c) {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_PRIMARY_ABBR;
        } else {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_SECONDARY_ABBR;
        }
        contact.dateOfBirth = applicant.Date_of_Birth_WS__c;
        contact.age = String.valueOf(applicant.Applicant_Age__c);
        contact.gender = applicant.Gender__c;
        contact.maritalStatus = applicant.Rel_Status__c;
        contact.contactName = generateContactName(applicant.Title__c,applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c);
        
        String unitNumber = applicant.Unit_No_Res__c != null ? applicant.Unit_No_Res__c : '';        
        String addressLineOne = unitNumber + ' ' + applicant.Street_No_Res__c + ' ' + applicant.Street_Res__c + ' ' + applicant.Street_Type_Res__c;
        
        List<GenerateDocumentGeComOriginations.Address> addressList= new List<GenerateDocumentGeComOriginations.Address>();
        if(application.Brand_Country__c == 'AU'){
          addressList.add(generateDocumentContactAddress(null,addressLineOne,null,null,
                                                       applicant.Suburb_Res__c,applicant.State_Res__c,applicant.Postcode_Res__c,
                                                       applicant.Country_Res__c,applicant.Unit_No_Res__c,applicant.Street_No_Res__c,
                                                       applicant.Residential_Property_Name__c,applicant.Street_Res__c,
                                                       applicant.Street_Type_Res__c));
        }else if(application.Brand_Country__c == 'NZ'){
          GenerateDocumentGeComOriginations.Address ad = new GenerateDocumentGeComOriginations.Address();
          ad = generateDocumentContactAddress(null,addressLineOne,null,null,
                                                       applicant.Suburb_Res__c,applicant.State_Res__c,applicant.Postcode_Res__c,
                                                       applicant.Country_Res__c,applicant.Unit_No_Res__c,applicant.Street_No_Res__c,
                                                       applicant.Residential_Property_Name__c,applicant.Street_Res__c,
                                                       applicant.Street_Type_Res__c);
                                                       
            ad.city = applicant.City_Res__c;
            ad.suburb = applicant.Suburb_Res__c;                                          
                                                       
        addressList.add(ad);
            
        }
        contact.address = addressList; 
        
        contact.eligibilityDetails = generateEligibilityDetails(true, //eligibleToLoan - default to true
                                                                true, //fixedTermAndLoanMeetsNeed - default to true
                                                                true, //readAndAgreeToPrivacyPolicy - default to true
                                                                true, //readCreditGuide - default to true
                                                                //applicant.Loan_Insurance_Consent__c, //receiveInfoAboutLoanInsurance,
                                                                applicant.Agrees_to_Privacy_Policy__c,
                                                                applicant.Interested_in_other_services__c, //utilizeInfoForOtherProducts,
                                                                (applicant.EIDV__c == 'Yes') ? true : false,
                                                                applicant.Consent_to_Lpi__c,
                                                                applicant.Agrees_to_Income_Verification__c);
                                                                       
        return contact;
    }
    
    
    //Disbursement Notice
    
    /* Description: Method that maps values into DisbursementAuthority WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DisbursementAuthority
    */
    public static GenerateDocumentGeComOriginations.DisbursementAuthority generateDisbursementAuthority(Related_Document__c rd, IS_ApplicationDTO appDTO){
        
        GenerateDocumentGeComOriginations.DisbursementAuthority disbursementAuthority = new GenerateDocumentGeComOriginations.DisbursementAuthority();
            
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            disbursementAuthority.isJointCustomers = 'false';
        }
        else{
            disbursementAuthority.isJointCustomers = 'true';
        }
        disbursementAuthority.ContactCollection = generateContactList(appDTO.applicant, appDTO.applicant2);
        disbursementAuthority.disbursementAuthorityInformation = generateDisbursementAuthorityInformation(appDTO.app,appDTO.applicant, rd);
        
        return disbursementAuthority;
    }
    
    /* Description: Method that maps values into DisbursementAuthorityInformation WSobject
    *  Author: Fel Saliba
    *  Date Created: 13-02-14
    *  Input Parameters: 
    *  Return: GenerateDocumentGeComOriginations.DisbursementAuthorityInformation
    */
    public static GenerateDocumentGeComOriginations.DisbursementAuthorityInformation generateDisbursementAuthorityInformation(Application__c application,Applicant__c applicant, Related_Document__c rd){
        
        GenerateDocumentGeComOriginations.DisbursementAuthorityInformation disbursementAuthorityInformation = new GenerateDocumentGeComOriginations.DisbursementAuthorityInformation();
            
        disbursementAuthorityInformation.applicationNo = application.UID__c;
        //Commented the below function by Suneel as part of Cheque Disbursment Removal
        /*disbursementAuthorityInformation.bankAccountDetails = generateBankAccountDetails(applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c,rd.Disbursement__r.Account_Holders__c,rd.Disbursement__r.Fin_Institution__c,rd.Disbursement__r.Branch__c,rd.Disbursement__r.BSB__c,rd.Disbursement__r.Bank_Acc_No__c,rd.Disbursement__r.Branch_Number__c,rd.Disbursement__r.Suffix_Number__c, application.Brand_Country__c);*/
        // Added additional column names to the below function By Suneel -Cheque Disbursement removal        
        disbursementAuthorityInformation.bankAccountDetails = generateBPayBankAccountDetails(applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c,rd.Disbursement__r.Account_Holders__c,rd.Disbursement__r.Fin_Institution__c,rd.Disbursement__r.Branch__c,rd.Disbursement__r.BSB__c,rd.Disbursement__r.Bank_Acc_No__c,rd.Disbursement__r.Branch_Number__c,rd.Disbursement__r.Suffix_Number__c,application.Brand_Country__c,rd.Disbursement__r.Disbursement_Type_Code__c,rd.Disbursement__r.BillerShortName__c,rd.Disbursement__r.BillerCode__c,rd.Disbursement__r.Reference__c,rd.Disbursement__r.Amount__c);
        disbursementAuthorityInformation.isOnline = 'false';
        if(application.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
            disbursementAuthorityInformation.isOnline = 'true';
        }

        return disbursementAuthorityInformation;
    }
    
        
    /* Description: Private variable used to store Higher_Approval_Consent__c to construct application extract for NZ, because this field exists on Application__c
                    rather than Applicant__c, instead of changing the current static method of generateEligibilityDetails, use this variable instead.
    *  Author: Tony Xu
    *  Date Created: 12-03-2014
    */
    
    private static boolean higherApprovalConsent = false;
    
    
    /**  Description: Creates Objective And Requirements for Generate Document service
    *  Author: Dan Crisologo
    *  Date Created: 02-14-14
    *  Input Parameters: Related_Document__c rd, IS_ApplicationDTO appDTO
    *  Return: GenerateDocumentGeComOriginations.ApplicationExtract
    *  Update: 12-02-2014  DBHZL64  Tony Xu
    */
    public static GenerateDocumentGeComOriginations.ApplicationExtract createApplicationExtract(IS_ApplicationDTO appDTO){
    
        GenerateDocumentGeComOriginations.ApplicationExtract aeDoc = new GenerateDocumentGeComOriginations.ApplicationExtract();
        
        aeDoc.applicationNo = appDTO.app.UID__c;
        aeDoc.productName = appDTO.product.Product_Name__c;        
        /**12-03-2014  DBHZL  START**/
        if(appDTO.app.Higher_Approval_Consent__c != null){
            higherApprovalConsent = appDTO.app.Higher_Approval_Consent__c;
        }
        /**END**/
                
        //set up contact List
        GenerateDocumentGeComOriginations.ContactList contactList = new GenerateDocumentGeComOriginations.ContactList();
        List<GenerateDocumentGeComOriginations.Contact> contacts = new List<GenerateDocumentGeComOriginations.Contact>();
        contacts.add(generateAppExtractContact(appDTO.applicant, appDTO.expenseList, appDTO.incList, appDTO.app.Brand_Country__c));
        
        if(appDTO.app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
            aeDoc.isJointCustomers = 'false';
        } else{
            aeDoc.isJointCustomers = 'true';
            contacts.add(generateAppExtractContact(appDTO.applicant2, appDTO.expenseList2, appDTO.incList2, appDTO.app.Brand_Country__c)); //add additional contact in the list for joint application
        }
        
        contactList.contact = contacts;
        aeDoc.ContactCollection = contactList;

        aeDoc.loanDetails = generateAppExtractLoanDetails(appDTO.app.Total_Loan_Amount__c, appDTO.app.Loan_Insurance_Consent__c);
        aeDoc.loanPurposeApplicationSubmitList = generateAppExtractLoanPurposeApplicationSubmitList(appDTO.loanPurList, appDTO.app);
        if(appDTO.assetList!=null) {
            if(appDTO.assetList.size()>0) {
                aeDoc.assetDetailsList = generateAssetDetailsList(appDTO.assetList);
            }
        }
        if(appDTO.debtList!=null) {
            if(appDTO.debtList.size()>0) {
                aeDoc.debtDetailsList = generateDebtDetailsList(appDTO.debtList,appDTO.app,appDTO.applicant);
            }
        }
        //aeDoc.personalReferencesList = generatePersonalReferencesList(appDTO.personalReferenceList);
        //aeDoc.insuranceDetailsList = generateInsuranceDetailsList(appDTO.insuranceList);
        if(appDTO.brokerDetails!=null) {
            aeDoc.brokerDetails = generateAppExtractBrokerDetails(appDTO.brokerDetails, appDTO.app);
        }
        
        /**DBHZL64 Start Add applicationMetadata**/
        aeDoc.ApplicationMetadata = generateApplicationMetadata(appDTO.app);
        /**END**/
        

        return aeDoc;
    }  
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.Contact WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-18-14
    *  Input Parameters: Applicant
    *  Return: generateDocumentGeComOriginations.Contact
    *  Update: 12-02-2014   Added new fields for DBHZL64 - Tony xu
    */
    public static GenerateDocumentGeComOriginations.Contact generateAppExtractContact(Applicant__c applicant,
                                                                                      List<Expense__c> expenseList,
                                                                                      List<Income__c> incomeList,
                                                                                      String country) { //DBHZL64 Tony Xu
        
        GenerateDocumentGeComOriginations.Contact contact = new GenerateDocumentGeComOriginations.Contact();
        
        contact.id = applicant.id;
        if(applicant.Is_Primary_Applicant__c) {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_PRIMARY_ABBR;
        } else {
            contact.contactType = GEN_OriginationsConstants.APPLICANT_TYPE_SECONDARY_ABBR;
        }
        //dateOfBirth element cannot accept dd/mm/yyyy format
        contact.dateOfBirth = applicant.Date_of_Birth_WS__c;
        contact.gender = applicant.Gender__c; 
        contact.relationshipStatus = applicant.Rel_Status__c; 
        if(applicant.No_of_Deps__c!=null) {
            contact.noOfDependents = String.valueOf(applicant.No_of_Deps__c);
        }
        contact.driverLicenseNumber = applicant.Drivers_Lic_No__c; 
        contact.residentialStatus = applicant.Res_Status__c;       
        contact.contactName = generateContactName(applicant.Title__c,applicant.First_Name__c,applicant.Middle_Name__c,applicant.Last_Name__c);
        
        String unitNumber = applicant.Unit_No_Res__c != null ? applicant.Unit_No_Res__c : ''; 
        String addressLineOne = unitNumber + ' ' + applicant.Street_No_Res__c + ' ' + applicant.Street_Res__c + ' ' + applicant.Street_Type_Res__c;
        

        contact.residentialAddress = generateDocumentContactAddress(null,
                                                                    addressLineOne, 
                                                                    null, 
                                                                    null, 
                                                                    applicant.Suburb_Res__c, 
                                                                    applicant.State_Res__c, 
                                                                    applicant.Postcode_Res__c, 
                                                                    applicant.Country_Res__c,
                                                                    applicant.Unit_No_Res__c,
                                                                    applicant.Street_No_Res__c,
                                                                    applicant.Residential_Property_Name__c,
                                                                    applicant.Street_Res__c,
                                                                    applicant.Street_Type_Res__c);

        /**DBHZL64 Add new fields START**/
        if(applicant.City_Res__c != null){
            contact.residentialAddress.city = applicant.City_Res__c;
        }
        
        if(applicant.Suburb_Res__c != null){
          contact.residentialAddress.suburb = applicant.Suburb_Res__c;
        }
        
        if(applicant.Service_Delivery_Type__c != null){
            contact.residentialAddress.serviceDeliveryType = applicant.Service_Delivery_Type__c;
        }
        
        if(applicant.Service_Delivery_Code__c != null){
            contact.residentialAddress.serviceDeliveryCode = applicant.Service_Delivery_Code__c;
        }
        /**END**/
        
        
                                                                    
        String unitNumberPos = applicant.Unit_No_Pos__c != null ? applicant.Unit_No_Pos__c : '';                                                                     
        String addressLineOnePos = unitNumberPos + ' ' + applicant.Street_No_Pos__c + ' ' + applicant.Street_Pos__c + ' ' + applicant.Street_Type_Pos__c;                                                            
        
        if(country == 'AU'){
          //Use the city / state / postcode to check if populating the postal address is applicable
          if(applicant.Suburb_Pos__c!=null && applicant.State_Pos__c!=null && applicant.Postcode_Pos__c!=null) {
              contact.postalAddress = generateDocumentContactAddress(null,
                                                                     addressLineOnePos, 
                                                                     null, 
                                                                     null, 
                                                                     applicant.Suburb_Pos__c, 
                                                                     applicant.State_Pos__c, 
                                                                     applicant.Postcode_Pos__c, 
                                                                     applicant.Country_Pos__c,
                                                                     applicant.Unit_No_Pos__c,
                                                                     applicant.Street_No_Pos__c,
                                                                     applicant.Postal_Property_Name__c,
                                                                     applicant.Street_Pos__c,
                                                                     applicant.Street_Type_Pos__c); 
          
          }
        }else if (country == 'NZ'){
          if(applicant.City_Pos__c!=null && applicant.Postcode_Pos__c!=null){
            contact.postalAddress = generateDocumentContactAddress(null,
                                                                     addressLineOnePos, 
                                                                     null, 
                                                                     null, 
                                                                     applicant.Suburb_Pos__c, 
                                                                     applicant.State_Pos__c, 
                                                                     applicant.Postcode_Pos__c, 
                                                                     applicant.Country_Pos__c,
                                                                     applicant.Unit_No_Pos__c,
                                                                     applicant.Street_No_Pos__c,
                                                                     applicant.Postal_Property_Name__c,
                                                                     applicant.Street_Pos__c,
                                                                     applicant.Street_Type_Pos__c); 
          
              /**DBHZL64 Add new fields START**/
              system.debug(applicant.City_Pos__c);
              
              if(applicant.City_Pos__c != null){
                  contact.postalAddress.city = applicant.City_Pos__c;
              }
              
              if(applicant.Suburb_Pos__c != null && (applicant.Service_Delivery_Type__c == 'PO Box' || applicant.Service_Delivery_Type__c == 'Community Mail Box')){
                contact.postalAddress.suburb = applicant.Suburb_Pos__c;
              }
              
              // Updated by Adrian Recio
              // Description: Reenabled this condition
              if(applicant.Service_Delivery_Type__c != null){
                  contact.postalAddress.serviceDeliveryType = applicant.Service_Delivery_Type__c;
              }
              
              if(applicant.Service_Delivery_Code__c != null){
                  contact.postalAddress.serviceDeliveryCode = applicant.Service_Delivery_Code__c;
              }
              
              // Updated by Adrian Recio
              // Description: Reenabled this condition
              if(applicant.Service_Delivery_Id__c != null){
                contact.postalAddress.serviceDeliveryNumber = applicant.Service_Delivery_Id__c;
              }              
              
              /**END**/
          }
        }
        
        
        
        String unitNumberPre = applicant.Unit_No_Pre__c != null ? applicant.Unit_No_Pre__c : '';
        String addressLineOnePre = unitNumberPre + ' ' + applicant.Street_No_Pre__c + ' ' + applicant.Street_Pre__c + ' ' + applicant.Street_Type_Pre__c;
        if(country == 'AU'){
          //Use the city / state / postcode to check if populating the previous address is applicable
          if(applicant.Suburb_Pre__c!=null && applicant.State_Pre__c!=null && applicant.Postcode_Pre__c!=null) {
              contact.previousResidentialAddress = generateDocumentContactAddress(null,
                                                                          addressLineOnePre, 
                                                                          null, 
                                                                          null, 
                                                                          applicant.Suburb_Pre__c, 
                                                                          applicant.State_Pre__c, 
                                                                          applicant.Postcode_Pre__c, 
                                                                          applicant.Country_Pre__c,
                                                                          applicant.Unit_No_Pre__c,
                                                                          applicant.Street_No_Pre__c,
                                                                          applicant.Previous_Property_Name__c,
                                                                          applicant.Street_Pre__c,
                                                                          applicant.Street_Type_Pre__c); 
          
              /**DBHZL64 Add new fields START**/
              system.debug(applicant.City_Pos__c+' , '+applicant.City_Res__c);
              if(applicant.City_Pre__c != null){
                  contact.previousResidentialAddress.suburb = applicant.City_Pre__c;
              }
              
              if(applicant.Service_Delivery_Type__c != null){
                  contact.previousResidentialAddress.serviceDeliveryType = applicant.Service_Delivery_Type__c;
              }
              
              if(applicant.Service_Delivery_Code__c != null){
                  contact.previousResidentialAddress.serviceDeliveryCode = applicant.Service_Delivery_Code__c;
              }
              
              /**END**/
          
          } 
        }else if(country == 'NZ'){
          if(applicant.City_Pre__c!=null && applicant.Postcode_Pre__c!=null){
            contact.previousResidentialAddress = generateDocumentContactAddress(null,
                                                                          addressLineOnePre, 
                                                                          null, 
                                                                          null, 
                                                                          applicant.Suburb_Pre__c, 
                                                                          applicant.State_Pre__c, 
                                                                          applicant.Postcode_Pre__c, 
                                                                          applicant.Country_Pre__c,
                                                                          applicant.Unit_No_Pre__c,
                                                                          applicant.Street_No_Pre__c,
                                                                          applicant.Previous_Property_Name__c,
                                                                          applicant.Street_Pre__c,
                                                                          applicant.Street_Type_Pre__c); 
          
              /**DBHZL64 Add new fields START**/
              system.debug(applicant.City_Pos__c+' , '+applicant.City_Res__c);
              if(applicant.City_Pre__c != null){
                  contact.previousResidentialAddress.city = applicant.City_Pre__c;
              }
              
              if(applicant.Suburb_Pre__c != null){
                contact.previousResidentialAddress.suburb = applicant.Suburb_Pre__c;
              }
              
              // Updated by Adrian Recio
              // Description: Reenabled this condition
              if(applicant.Service_Delivery_Type__c != null){
                  contact.previousResidentialAddress.serviceDeliveryType = applicant.Service_Delivery_Type__c;
              }
              
              if(applicant.Service_Delivery_Code__c != null){
                  contact.previousResidentialAddress.serviceDeliveryCode = applicant.Service_Delivery_Code__c;
              }
              
              /**END**/
          }
        }
        
        contact.residentialHistory = generateResidentialHistory(applicant.Years_At_Addr__c,
                                                                applicant.Months_At_Addr__c,
                                                                applicant.Years_At_Prev_Addr__c,
                                                                applicant.Months_At_Prev_Addr__c,
                                                                country); //DBHZL64
        
        contact.communicationDetails = generateCommunicationDetails(applicant.Mobile__c,
                                                                    applicant.Home_Area_Code__c,
                                                                    applicant.Home_WS__c,
                                                                    applicant.Work_Area_Code__c,
                                                                    applicant.Work_WS__c,
                                                                    applicant.Email_Address__c);
                                                                 
        contact.eligibilityDetails = generateEligibilityDetails(true, //eligibleToLoan - default to true
                                                                true, //fixedTermAndLoanMeetsNeed - default to true
                                                                applicant.Agrees_to_Privacy_Policy__c, //Changed By TXU
                                                                true, //readCreditGuide - default to true
                                                                applicant.Agrees_to_Privacy_Policy__c, //receiveInfoAboutLoanInsurance,
                                                                applicant.Interested_in_other_services__c, //utilizeInfoForOtherProducts,
                                                                (applicant.EIDV__c == 'Yes') ? true : false,
                                                                applicant.Consent_to_Lpi__c,
                                                                applicant.Agrees_to_Income_Verification__c);
                                            
        contact.expenseDetails = generateAppExtractExpenseDetails(expenseList,applicant);
        List<GenerateDocumentGeComOriginations.IncomeDetailsList> incomeDetailList = new List<GenerateDocumentGeComOriginations.IncomeDetailsList>();
        incomeDetailList.add(generateAppExtractIncomeDetails(incomeList, applicant));
        contact.incomeDetailsList = incomeDetailList;

        return contact;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.ResidentialHistory WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: Applicant
    *  Return: generateDocumentGeComOriginations.ResidentialHistory
    */
    public static GenerateDocumentGeComOriginations.ResidentialHistory generateResidentialHistory(String timeAtCurrentAddressYears,
                                                                                                  String timeAtCurrentAddressMonths,
                                                                                                  String timeAtPreviousAddressYears,
                                                                                                  String timeAtPreviousAddressMonths,
                                                                                                  String country) {  //DBHZL64
        GenerateDocumentGeComOriginations.ResidentialHistory residentialHistory = new GenerateDocumentGeComOriginations.ResidentialHistory();
        //Mar-17-2016- Afreen Khan - Userstory 131 changing Picklist to free txt-->                                                                                             
        /*if(country == 'NZ' && Integer.valueOf(timeAtCurrentAddressYears) > 9){
          residentialHistory.timeAtCurrentAddressYears = 'More than 9 years';
        }else{
          residentialHistory.timeAtCurrentAddressYears = timeAtCurrentAddressYears;
        }*/
                                                                                                      
        residentialHistory.timeAtCurrentAddressYears = timeAtCurrentAddressYears;
        residentialHistory.timeAtCurrentAddressMonths = timeAtCurrentAddressMonths;
        
         //Mar-17-2016- Afreen Khan - Userstory 131 changing Picklist to free txt-->   
        /*if(country == 'NZ' && Integer.valueOf(timeAtPreviousAddressYears) > 9){
          residentialHistory.timeAtPreviousAddressYears = 'More than 9 years';
        }else{
          residentialHistory.timeAtPreviousAddressYears = timeAtPreviousAddressYears;
        }*/
                                                                                                      
        residentialHistory.timeAtPreviousAddressYears = timeAtPreviousAddressYears;
        residentialHistory.timeAtPreviousAddressMonths = timeAtPreviousAddressMonths;
        return residentialHistory;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.CommunicationDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: Applicant
    *  Return: generateDocumentGeComOriginations.CommunicationDetails
    */
    public static GenerateDocumentGeComOriginations.CommunicationDetails generateCommunicationDetails(String mobileNumber,
                                                                                                      String homeNumberAreaCode,
                                                                                                      String homeNumber,
                                                                                                      String workNumberAreaCode,
                                                                                                      String workNumber,
                                                                                                      String emailAddress) {
        GenerateDocumentGeComOriginations.CommunicationDetails communicationDetails = new GenerateDocumentGeComOriginations.CommunicationDetails();
        communicationDetails.mobileNumber = mobileNumber;
        communicationDetails.homeNumberAreaCode = homeNumberAreaCode;
        communicationDetails.homeNumber = homeNumber;
        communicationDetails.workNumberAreaCode = workNumberAreaCode;
        communicationDetails.workNumber = workNumber;
        communicationDetails.emailAddress = emailAddress;
        return communicationDetails;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.EligibilityDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: Applicant
    *  Return: generateDocumentGeComOriginations.EligibilityDetails
    */
    public static GenerateDocumentGeComOriginations.EligibilityDetails generateEligibilityDetails(Boolean eligibleToLoan,
                                                                                                  Boolean fixedTermAndLoanMeetsNeed,
                                                                                                  Boolean readAndAgreeToPrivacyPolicy,
                                                                                                  Boolean readCreditGuide,
                                                                                                  Boolean receiveInfoAboutLoanInsurance,
                                                                                                  Boolean utilizeInfoForOtherProducts,
                                                                                                  Boolean eidvConsent,
                                                                                                  Boolean insuranceEmailAck,
                                                                                                  Boolean verifierConsent) 
                                                                                                  {
        GenerateDocumentGeComOriginations.EligibilityDetails eligibilityDetails = new GenerateDocumentGeComOriginations.EligibilityDetails();
        eligibilityDetails.fixedTermAndLoanMeetsNeed = fixedTermAndLoanMeetsNeed;
        eligibilityDetails.readAndAgreeToPrivacyPolicy = readAndAgreeToPrivacyPolicy;
        eligibilityDetails.eidvConsent = eidvConsent;
        eligibilityDetails.consentToReceiveDocs = receiveInfoAboutLoanInsurance;
        eligibilityDetails.loanAmmountEligibility = higherApprovalConsent;
        eligibilityDetails.insuranceEmailsAck = insuranceEmailAck;
        //Added by Suneel POI Automation 27/01/2021      
        eligibilityDetails.verifierConsent = verifierConsent;   
        return eligibilityDetails;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.ExpenseDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: List<Expense>
    *  Return: generateDocumentGeComOriginations.ExpenseDetails
    */
    public static GenerateDocumentGeComOriginations.ExpenseDetails generateAppExtractExpenseDetails(List<Expense__c> expenseList,Applicant__c applnt) {
        GenerateDocumentGeComOriginations.ExpenseDetails expenseDetails = new GenerateDocumentGeComOriginations.ExpenseDetails();
        
        expenseDetails.livingExpensesList = generateLivingExpenseList(expenseList,applnt);
        expenseDetails.propertyCostList = generatePropertyCostList(expenseList,applnt);
            
        system.debug('====='+expenseList);
        for(Expense__c exp: expenseList) {
            expenseDetails.payAllExpensesForYourHousehold = exp.I_Pay_All_Exp__c;
            if(exp.Living_Exp__c!=null) {
                expenseDetails.myShareOfLivingExpenses = String.valueOf(roundOffAmount(exp.Living_Exp__c));
            }
            expenseDetails.livingExpenseInterval = exp.Living_Exp_Int__c;
            if(exp.Rent_Board_Pay_Amt__c!=null) {
                expenseDetails.rentPaymentAmount = String.valueOf(roundOffAmount(exp.Rent_Board_Pay_Amt__c));
            }
            expenseDetails.rentPaymentInterval = exp.Rent_Board_Pay_Int__c;
            expenseDetails.agentOrLandlordName = exp.Agent_Landlord_Name__c;
            if(applnt.Country_Res__c == 'Australia'){
                Decimal totalExp = roundOffAmount(exp.Total_Exp__c);
                Decimal rentBoardExp = roundOffAmount(exp.Rent_Board_Payment_Amount_Monthly__c);
                Decimal result = totalExp - rentBoardExp;
                expenseDetails.totalExpenses = String.valueOf(result); 
            }
           if(applnt.Country_Res__c == 'New Zealand'){
               expenseDetails.totalExpenses = String.valueOf(roundOffAmount(exp.Total_Exp__c)); 
           }
            
            expenseDetails.revolvingCreditLimit = String.valueOf(applnt.Revolving_Credit__c);

            break; //we are only expecting 1 expense in the list
        }
            
        return expenseDetails;
    }
    
    public static List<GenerateDocumentGeComOriginations.LivingExpensesList> generateLivingExpenseList(List<Expense__c> expList,Applicant__c livGenApplicant){
    List<GenerateDocumentGeComOriginations.LivingExpensesList> livExpList = new List<GenerateDocumentGeComOriginations.LivingExpensesList>();
    if(expList != null){
     if(expList.size() > 0){
       GenerateDocumentGeComOriginations.LivingExpensesList livingExp = new GenerateDocumentGeComOriginations.LivingExpensesList();
       livingExp.LivingExpenses = generateLivExpenses(expList,livGenApplicant);
       livExpList.add(livingExp);
     }
    }
     return livExpList;
    }
    public static List<GenerateDocumentGeComOriginations.propertyCostList> generatePropertyCostList(List<Expense__c> propList,Applicant__c propertyGenApplicant){
    List<GenerateDocumentGeComOriginations.propertyCostList> propCostList = new List<GenerateDocumentGeComOriginations.propertyCostList>();
    if(propList != null){
     if(propList.size() > 0){
       GenerateDocumentGeComOriginations.propertyCostList propCost = new GenerateDocumentGeComOriginations.propertyCostList();
       propCost.PropertyCosts = generatePropCosts(propList,propertyGenApplicant);
       propCostList.add(propCost);
     }
    }
     return propCostList;
    }
    public static List<GenerateDocumentGeComOriginations.LivingExpenses> generateLivExpenses(List<Expense__c> lvExpenseList,Applicant__c livingGenApplicant){
     List<GenerateDocumentGeComOriginations.LivingExpenses> livExpenseList = new List<GenerateDocumentGeComOriginations.LivingExpenses>();
     if(lvExpenseList != null){
       if(lvExpenseList.size() > 0){
       
                 for(integer i=0;i<7;i++){
        
                GenerateDocumentGeComOriginations.LivingExpenses livingExpensesInf = new GenerateDocumentGeComOriginations.LivingExpenses();
               
               if(livingGenApplicant.Country_Res__c == 'Australia'){
                       if(i == 0){
                            livingExpensesInf.livingExpenseCategory = 'Food, groceries and entertainment';
                            livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Food_Groc_Entert__c);
                            livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Food_Groc_Interval__c;            
                       }
                      if(i==1){
                        livingExpensesInf.livingExpenseCategory = 'Insurance';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Insurance_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Insurance_Expense_Interval__c;           
                      }
                      if(i==2){
                        livingExpensesInf.livingExpenseCategory = 'Utilities';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Utilities_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Utilities_Expense_Interval__c;          
                    }
                      if(i==3){
                        livingExpensesInf.livingExpenseCategory = 'Transport';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Transport_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Transport_Expense_Interval__c;          
                    }
                      if(i==4){
                        livingExpensesInf.livingExpenseCategory = 'Education and childcare';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Education_and_child_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Education_and_child_Expense_Interval__c;           
                    }
                      if(i==5){
                        livingExpensesInf.livingExpenseCategory = 'Personal / Other';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Personal_Other_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Personal_Other_Expense_Interval__c;                    
                    }
             }   
                if(livingGenApplicant.Country_Res__c == 'New Zealand'){
                    if(i == 0){
                            livingExpensesInf.livingExpenseCategory = 'Food , Groceries and Entertainment';
                            livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Food_Groc_Entert__c);
                            livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Food_Groc_Interval__c;            
                       }
                      if(i==1){
                        livingExpensesInf.livingExpenseCategory = 'Health and Life Insurance';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Insurance_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Insurance_Expense_Interval__c;           
                      }
                      if(i==2){
                        livingExpensesInf.livingExpenseCategory = 'Transport and Auto';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Transport_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Transport_Expense_Interval__c;          
                    }
                     if(i==3){
                        livingExpensesInf.livingExpenseCategory = 'Education and childcare';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Education_and_child_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Education_and_child_Expense_Interval__c;           
                    }
                     if(i==4){
                        livingExpensesInf.livingExpenseCategory = 'Personal, Fitness and Medical';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Personal_Other_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Personal_Other_Expense_Interval__c;                    
                    }
                      if(i==5){
                        livingExpensesInf.livingExpenseCategory = 'General insurance';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Utilities_Expense__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Utilities_Expense_Interval__c;          
                    }                    
                    if(i==6){
                        livingExpensesInf.livingExpenseCategory = 'Any Additional expenses';
                        livingExpensesInf.livingExpenseAmount = String.valueOf(lvExpenseList[0].Any_Additional_expenses__c);
                        livingExpensesInf.livingExpenseInterval = lvExpenseList[0].Any_Additional_expenses_Interval__c;                    
                    } 
                 }   
                   
                
                livExpenseList.add(livingExpensesInf);
                 }
       }
     }
     return livExpenseList;
    }
    
    public static List<GenerateDocumentGeComOriginations.PropertyCosts> generatePropCosts(List<Expense__c> propCostList,Applicant__c propGenApplicant){
    
    List<GenerateDocumentGeComOriginations.PropertyCosts> proCosList = new List<GenerateDocumentGeComOriginations.PropertyCosts>();
    
    if(propCostList != null){
      if(propCostList.size() > 0){
        
             for(integer i=0;i<5;i++){
                     GenerateDocumentGeComOriginations.PropertyCosts pc = new GenerateDocumentGeComOriginations.PropertyCosts();              
                    if(propGenApplicant.Country_Res__c == 'Australia'){  
                         if(i == 0){
                             pc.propertyCostType = 'Rent or Board';
                             pc.propertyAmount =  String.valueOf(propCostList[0].Rent_Board_Pay_Amt__c);
                             pc.propertyInterval = propCostList[0].Rent_Board_Pay_Int__c;                
                         }
                     }
                   
                   if(propGenApplicant.Country_Res__c == 'New Zealand'){  
                             if(i == 0){
                                 pc.propertyCostType = 'Mortgage, rent or board';
                                 pc.propertyAmount =  String.valueOf(propCostList[0].Rent_Board_Pay_Amt__c);
                                 pc.propertyInterval = propCostList[0].Rent_Board_Pay_Int__c;                   
                             }
                             
                             if(i == 1){
                                 pc.propertyCostType = 'Secondary Mortgage, rent or board';
                                 pc.propertyAmount =  String.valueOf(propCostList[0].Secondary_Mortgage_Rent__c);
                                 pc.propertyInterval = propCostList[0].Secondary_Mortgage_Rent_Interval__c;                    
                             }
                             
                             if(i == 2){
                                 pc.propertyCostType = 'Property rates';
                                 pc.propertyAmount =  String.valueOf(propCostList[0].Property_rates__c);
                                 pc.propertyInterval = propCostList[0].Property_rates_Interval__c;                    
                             }
                             
                             if(i == 3){
                                 pc.propertyCostType = 'Utilities & Other property expenses';
                                 pc.propertyAmount =  String.valueOf(propCostList[0].Other_Property_Expenses__c);
                                 pc.propertyInterval = propCostList[0].Other_Property_Expenses_Interval__c;                    
                               }
                     }
                     proCosList.add(pc);
             }
      }
    }
    
    return proCosList;
    }
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.ExpenseDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: List<Expense>
    *  Return: generateDocumentGeComOriginations.IncomeDetails
    *  Update: 12-02-2014   Added new fields for DBHZL64  -  Tony Xu
    */
    public static GenerateDocumentGeComOriginations.IncomeDetailsList generateAppExtractIncomeDetails(List<Income__c> incomeList, Applicant__c applicant) {
        
        GenerateDocumentGeComOriginations.IncomeDetailsList incomeDetailsList = new GenerateDocumentGeComOriginations.IncomeDetailsList();
        List<GenerateDocumentGeComOriginations.IncomeDetails> incomeDetails = new List<GenerateDocumentGeComOriginations.IncomeDetails>();
        if(incomeList!=null) {
            if(incomeList.size()>0) {
                for(Income__c income: incomeList) {
                    GenerateDocumentGeComOriginations.IncomeDetails incomeDetail = new GenerateDocumentGeComOriginations.IncomeDetails();
                    incomeDetail.incomeType = income.Income_Source__c; 
                    if(income.Income_Amount__c!=null) {
                        incomeDetail.incomeAmount = String.valueOf(roundOffAmount(income.Income_Amount__c));
                    }
                    incomeDetail.incomeInterval = income.Income_Interval__c; 
                    if(applicant.Total_Income__c!=null) {
                        incomeDetail.totalIncome = String.valueOf(roundOffAmount(applicant.Total_Income__c));
                    }
                    if(applicant.Additional_Income__c!=null) {
                        incomeDetail.totalAdditionalIncome = String.valueOf(roundOffAmount(applicant.Additional_Income__c));
                    }
                    incomeDetail.employmentStatus = applicant.Primary_Employment_Status__c; 
                    incomeDetail.occupation = income.Occupation__c; 
                    incomeDetail.employerName = income.Emp_Bus_Name__c;
                    incomeDetail.employerContactPhoneAreaCode = income.Employer_Business_Contact_No_Area_Code__c;
                    incomeDetail.employerContactPhoneNumber = income.Employer_Business_Contact_No_WS__c;
                    if(income.Years_With_Employer__c!=null) {
                        incomeDetail.timeWithCurrentEmployerYears = String.valueOf(income.Years_With_Employer__c);
                    }
                    if(income.Months_With_Employer__c!=null) {
                        incomeDetail.timeWithCurrentEmployerMonths = String.valueOf(income.Months_With_Employer__c);
                    }
                    
                    /** 12-02-2014  Add new fields DBHZL64 START **/
                    if(income.Government_Benefit_Type__c != null){
                        incomeDetail.incomeSubType = income.Government_Benefit_Type__c;
                    }
                    
                    if(income.Industry__c != null){
                        incomeDetail.industry = income.Industry__c;
                    }                   
                    
                    if(applicant.Previous_Employment_Status__c != null){
                        incomeDetail.previousEmploymentStatus = applicant.Previous_Employment_Status__c;
                    }
                    
                    if(applicant.Prev_Emp_Bus_Name__c != null){
                        incomeDetail.previousEmployerName = applicant.Prev_Emp_Bus_Name__c;
                    }
                    
                    if(applicant.Time_at_previous_employer_years__c != null || applicant.Time_at_previous_employer_months__c != null){
                        string prevEmpYear = '0';
                        string prevEmpMonth = '0';
                        if(applicant.Time_at_previous_employer_years__c != null && applicant.Time_at_previous_employer_years__c != 0){
                            prevEmpYear = string.valueOf(applicant.Time_at_previous_employer_years__c);
                        }
                        
                        if(applicant.Time_at_previous_employer_months__c != null && applicant.Time_at_previous_employer_months__c != 0){
                            prevEmpMonth = string.valueOf(applicant.Time_at_previous_employer_months__c);
                        }
                        
                        String yearLabel = applicant.Time_at_previous_employer_years__c > 1 ? ' Years ' : ' Year ';
                        String monthLabel = applicant.Time_at_previous_employer_months__c > 1 ? ' Months ' : ' Month';
                        
                        incomeDetail.timeAtPreviousEmployer = prevEmpYear + yearLabel + prevEmpMonth + monthLabel;                              
                                     
                    }
                    incomeDetail.incomeRedundancyFlag = applicant.Income_Redundancy__c; 
                    
                    /**END**/
                    
                    
                    
                    incomeDetails.add(incomeDetail);
                }
            }
        }
        
        incomeDetailsList.incomeDetails = incomeDetails;
        
        return incomeDetailsList;
    }

    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.LoanDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters: totalLoanAmount, loanInsuranceConsent
    *  Return: generateDocumentGeComOriginations.LoanDetails
    */
    public static GenerateDocumentGeComOriginations.LoanDetails generateAppExtractLoanDetails(Decimal totalLoanAmount,
                                                                                           Boolean loanInsuranceConsent) {
        GenerateDocumentGeComOriginations.LoanDetails loanDetails = new GenerateDocumentGeComOriginations.LoanDetails();
        if(totalLoanAmount!=null) {
            loanDetails.totalLoanAmount = String.valueOf(roundOffAmount(totalLoanAmount));
        }
        return loanDetails;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmitList WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters:  loanPurposes
    *  Return: generateDocumentGeComOriginations.LoanPurposeApplicationSubmitList
    */
    public static GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmitList generateAppExtractLoanPurposeApplicationSubmitList(List<Loan_Purpose__c> loanPurposes,
                                                                                                                                        Application__c app) {
        GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmitList loanPurposeApplicationSubmitList = new GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmitList();
        List<GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmit> loanPurposeApplicationSubmit = new List<GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmit>();
        
        for(Loan_Purpose__c lp: loanPurposes) {
            GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmit lpas = new GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmit();
            if(lp.Loan_Amount__c!=null) {
                lpas.loanPurposeAmount = String.valueOf(lp.Loan_Amount__c);
            }
            lpas.loanPurpose = lp.Value__c; 
        //Appending 3 months for the Better Start applications for Copy of Application Document - 08/11/2019
        Better_Start_Offer__c bsOffer = [ select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c ];
        //Decimal lterm = Decimal.valueOf(Web_Service_Settings__c.getValues('No of Payments - BS').value__c);
        if(app.Brand_Country__c == 'AU'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments AU - BS').value__c);

            if(app.Loan_Term_Months__c!=null) {
            if((app.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartAUActive__c == true || bsOffer.BetterStartAUActive__c == false)){
                     Integer actualTerm = Integer.valueOf(app.Loan_Term_Months__c);
                     Integer bsLoanTerm = actualTerm + lterm;
                     lpas.loanTerm = String.valueOf(bsLoanTerm);
                }else {
                     lpas.loanTerm = String.valueOf(app.Loan_Term_Months__c);
                }
            } 
        }else if(app.Brand_Country__c == 'NZ'){
            Integer lterm = Integer.valueOf(Web_Service_Settings__c.getValues('No of Payments NZ - BS').value__c);
            if(app.Loan_Term_Months__c!=null) {
                if((app.Product_SubType__c == 'Better Start PL') && (bsOffer.BetterStartNZActive__c == true || bsOffer.BetterStartNZActive__c == false)){
                     Integer actualTerm = Integer.valueOf(app.Loan_Term_Months__c);
                     Integer bsLoanTerm = actualTerm + lterm;
                     lpas.loanTerm = String.valueOf(bsLoanTerm);
                }else {
                     lpas.loanTerm = String.valueOf(app.Loan_Term_Months__c);
                }
            } 
        }
           /* if(app.Loan_Term_Months__c!=null) {
                lpas.loanTerm = String.valueOf(app.Loan_Term_Months__c);
            }*/
            loanPurposeApplicationSubmit.add(lpas);
        }

        loanPurposeApplicationSubmitList.loanPurposeApplicationSubmit = loanPurposeApplicationSubmit;
        return loanPurposeApplicationSubmitList;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.AssetDetailsList WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters:  assets
    *  Return: generateDocumentGeComOriginations.AssetDetailsList
    *  Update:Added as part of DBHZL-143 as some asset categories dont have ownership E.g.: Deposits and Kiwisaver/Superannuation 
    */
    public static GenerateDocumentGeComOriginations.AssetDetailsList generateAssetDetailsList(List<Asset__c> assets) {
        GenerateDocumentGeComOriginations.AssetDetailsList assetDetailsList = new GenerateDocumentGeComOriginations.AssetDetailsList();
        List<GenerateDocumentGeComOriginations.AssetDetails> assetDetails = new List<GenerateDocumentGeComOriginations.AssetDetails>();
        
        for(Asset__c a: assets) {
            GenerateDocumentGeComOriginations.AssetDetails assetDetail = new GenerateDocumentGeComOriginations.AssetDetails();
            assetDetail.assetType = a.asset_Category__c; 
            if(a.asset_Value__c!=null) {
                assetDetail.value = String.valueOf(a.asset_Value__c);
            }
            //Added as part of DBHZL-143 as some asset categories dont have ownership E.g.: Deposits and Kiwisaver/Superannuation
            if(a.Ownership_Status__c==null || a.Ownership_Status__c=='') {
                assetDetail.ownershipStatus = GEN_OriginationsConstants.ASSET_OWNERSHIP_NONE; 
            }else{
                assetDetail.ownershipStatus = a.Ownership_Status__c; 
            }
            assetDetail.vehicleMake = a.Vehicle_Make__c;
            assetDetail.vehicleModel = a.Vehicle_Model__c;
            assetDetail.yearOfManufacture = a.Vehicle_Year__c;
            assetDetails.add(assetDetail);
        }

        assetDetailsList.assetDetails = assetDetails;
        return assetDetailsList;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.DebtDetailsList WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters:  liabilities
    *  Return: generateDocumentGeComOriginations.DebtDetailsList
    *  Update: 12-02-2014  Add new field for DBHZL64  -  Tony Xu
    */
    public static GenerateDocumentGeComOriginations.DebtDetailsList generateDebtDetailsList(List<Liability__c> liabilities,Application__c app,Applicant__c applicant) {
        GenerateDocumentGeComOriginations.DebtDetailsList debtDetailsList = new GenerateDocumentGeComOriginations.DebtDetailsList();
        List<GenerateDocumentGeComOriginations.DebtDetails> debtDetails = new List<GenerateDocumentGeComOriginations.DebtDetails>();
        
        for(Liability__c l: liabilities) {
            GenerateDocumentGeComOriginations.DebtDetails debtDetail = new GenerateDocumentGeComOriginations.DebtDetails();
            
            debtDetail.debtCategory = l.Debt_Category__c; 
            debtDetail.wantToPayoutDebt = l.Acknowledge_Payout__c;
            
            if(app.Brand_Country__c == 'AU'){
             String capsFinancierName = formatData(l.Financier_Name__c);
             List<String> names = capsFinancierName.split(' ');
                                for (Integer i = 0; i < names.size(); i++){
                                    names[i] = names[i].capitalize();
                                }
                                capsFinancierName = String.join(names, ' ');
            debtDetail.financierName = capsFinancierName ;
            }
            if(app.Brand_Country__c == 'NZ'){
                       if(l.Financier_List__c != 'Other'){
                          debtDetail.financierName = l.Financier_List__c;
                       }else if(l.Financier_List__c == 'Other'){
                       String capsFinancierName = formatData(l.Financier_Name__c);
                       List<String> names = capsFinancierName.split(' ');
                                for (Integer i = 0; i < names.size(); i++){
                                    names[i] = names[i].capitalize();
                                }
                                capsFinancierName = String.join(names, ' ');
                                 debtDetail.financierName = capsFinancierName;
                       }
            }
            
            debtDetail.consolidateDebtOrReduceLimit = l.Consolidate_Debt_Reduce_Limit__c;
            debtDetail.balloonPaymentDebtFlag = applicant.is_Lump_Sum_Debt__c;
            debtDetail.balloonIntentionRepayFlag = false;            
            /**12-02-2014 Add new Field DBHZL64 Start**/
            if(l.Type_of_Credit_Card__c != null){
              
                debtDetail.debtType = l.Type_of_Credit_Card__c;
            }
            /**END**/
            
            if(l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT ||
               l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || 
               l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT ||
               l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
                
                if(l.Credit_Limit_Amt__c!=null) {
                    debtDetail.originalDebtAmount = String.valueOf(roundOffAmount(l.Credit_Limit_Amt__c));
                }
                if(l.Card_Overdraft_Bal_Amt__c!=null) {
                    debtDetail.outstandingBalanceAmount = String.valueOf(roundOffAmount(l.Card_Overdraft_Bal_Amt__c));
                }
                if(l.Reduced_Credit_Limit__c!=null) {
                    debtDetail.reducedCreditLimit = String.valueOf(roundOffAmount(l.Reduced_Credit_Limit__c));
                }
    
            } else if(l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE) {
            
                if(l.Mortgage_Bal_Amt__c!=null) {
                    debtDetail.outstandingBalanceAmount = String.valueOf(roundOffAmount(l.Mortgage_Bal_Amt__c));
                }
                if(l.Mortgage_Borrowed_Amt__c!=null) {
                    debtDetail.originalDebtAmount = String.valueOf(roundOffAmount(l.Mortgage_Borrowed_Amt__c));
                }
                if(l.Mortgage_Repayment_Amt__c!=null) {
                    debtDetail.repaymentAmount = String.valueOf(roundOffAmount(l.Mortgage_Repayment_Amt__c));
                }
                debtDetail.repaymentInterval = l.Mortgage_Repayment_Interval__c; 
                
            } else if(l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN ||
                      l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN ||
                      l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) {
                
                if(l.Car_Personal_Bal_Amt__c!=null) {
                    debtDetail.outstandingBalanceAmount = String.valueOf(roundOffAmount(l.Car_Personal_Bal_Amt__c));
                }
                if(l.Car_Personal_Borrowed_Amt__c!=null) {
                    debtDetail.originalDebtAmount = String.valueOf(roundOffAmount(l.Car_Personal_Borrowed_Amt__c));
                }
                if(l.Car_Personal_Repay_Amt__c!=null) {
                    debtDetail.repaymentAmount = String.valueOf(roundOffAmount(l.Car_Personal_Repay_Amt__c));
                }
                debtDetail.repaymentInterval = l.Car_Personal_Repay_Int__c; 
                
            } else if (l.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER) {
                if(l.Other_Borrowed_Amt__c!=null) {
                    debtDetail.originalDebtAmount = String.valueOf(roundOffAmount(l.Other_Borrowed_Amt__c));
                }
                if(l.Other_Repay_Amt__c!=null) {
                    debtDetail.repaymentAmount = String.valueOf(roundOffAmount(l.Other_Repay_Amt__c));
                }
                debtDetail.repaymentInterval = l.Other_Repay_Int__c;
            }

            debtDetails.add(debtDetail);
        }

        debtDetailsList.debtDetails = debtDetails;
        return debtDetailsList;
    }

    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.PersonalReferencesList WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-19-14
    *  Input Parameters:  prcList
    *  Return: generateDocumentGeComOriginations.PersonalReferencesList
    */
    public static GenerateDocumentGeComOriginations.PersonalReferencesList generatePersonalReferencesList(List<Personal_Reference_Check__c> prcList) {
        GenerateDocumentGeComOriginations.PersonalReferencesList personalReferencesList = new GenerateDocumentGeComOriginations.PersonalReferencesList();
        List<GenerateDocumentGeComOriginations.PersonalReferences> personalReferences = new List<GenerateDocumentGeComOriginations.PersonalReferences>();
        
        for(Personal_Reference_Check__c prc: prcList) {
            GenerateDocumentGeComOriginations.PersonalReferences personalReference = new GenerateDocumentGeComOriginations.PersonalReferences();
            personalReference.name = prc.Name__c;
            personalReference.relationship = prc.Relationship__c;
            personalReference.phoneNumber = prc.Phone_Number__c;
            personalReference.addressDetails = prc.Personal_Ref_Address__c;
            personalReferences.add(personalReference);
        }

        personalReferencesList.personalReferences = personalReferences;
        return personalReferencesList;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.InsuranceDetailsList WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-20-14
    *  Input Parameters:  
    *  Return: generateDocumentGeComOriginations.InsuranceDetailsList
    */
    public static GenerateDocumentGeComOriginations.InsuranceDetailsList generateInsuranceDetailsList(List<Product_Item__c> prodItems) {
        GenerateDocumentGeComOriginations.InsuranceDetailsList insuranceDetailsList = new GenerateDocumentGeComOriginations.InsuranceDetailsList();
        List<GenerateDocumentGeComOriginations.AppInsuranceDetails> insuranceDetails = new List<GenerateDocumentGeComOriginations.AppInsuranceDetails>();
        
        for(Product_Item__c pi: prodItems) {
            GenerateDocumentGeComOriginations.AppInsuranceDetails insuranceDetail = new GenerateDocumentGeComOriginations.AppInsuranceDetails();
            if(pi.Policy_Type__c!=null) {
                insuranceDetail.policyType = String.valueOf(pi.Policy_Type__c);
            }
            if(pi.Fixed_Premium_Amount__c!=null) {
                insuranceDetail.fixedPremiumAmount = String.valueOf(roundOffAmount(pi.Fixed_Premium_Amount__c));
            }
            if(pi.Cover_Amount_Formula__c!=null) {
                insuranceDetail.coverAmount = String.valueOf(roundOffAmount(pi.Cover_Amount_Formula__c));
            }
            if(pi.Ins_Term__c!=null) {
                insuranceDetail.insuranceTerm = String.valueOf(pi.Ins_Term__c);
            }
            if(pi.Policy_Num__c!=null) {
                insuranceDetail.policyNumber = String.valueOf(pi.Policy_Num__c);
            }
            if(pi.Insurance_GST__c!=null) {
                insuranceDetail.insuranceGST = String.valueOf(pi.Insurance_GST__c);
            }
            if(pi.Insurance_Stamp_Duty__c!=null) {
                insuranceDetail.insuranceStampDuty = String.valueOf(pi.Insurance_Stamp_Duty__c);
            }
            insuranceDetails.add(insuranceDetail);
        }

        insuranceDetailsList.insuranceDetails = insuranceDetails;
        return insuranceDetailsList;
    }
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.BrokerDetails WSobject
    *  Author: Dan Crisologo
    *  Date Created: 03-20-14
    *  Input Parameters:  
    *  Return: generateDocumentGeComOriginations.BrokerDetails
    */
    public static GenerateDocumentGeComOriginations.BrokerDetails generateAppExtractBrokerDetails(Contact broker, Application__c application) {
        GenerateDocumentGeComOriginations.BrokerDetails brokerDetails = new GenerateDocumentGeComOriginations.BrokerDetails();
        brokerDetails.brokerID = formatData(broker.Broker_ID__c);
        brokerDetails.firstName = formatData(broker.firstName);
        brokerDetails.lastName = formatData(broker.lastName);
        brokerDetails.accountName = formatData(broker.account.Name);
        brokerDetails.entityName = formatData(broker.account.Trust_Entity_Name__c);
        brokerDetails.aggregatorAccountName = formatData(broker.account.Aggregator_Account_Name__c);
        brokerDetails.suburb = broker.MailingCity;
        brokerDetails.state = broker.MailingState;
        brokerDetails.postcode = broker.MailingPostalCode;
        brokerDetails.phoneNumber = broker.Phone;
        brokerDetails.mobileNumber = broker.MobilePhone;
        if(application.Brokerage_Fee__c!=null) {
            brokerDetails.fee = String.valueOf(roundOffAmount(application.Brokerage_Fee__c));
        }
        return brokerDetails;
    }
    
    
    
    /* Description: Method that maps app extract values into GenerateDocumentGeComOriginations.ApplicationMetadata WSobject DBHZL64
    *  Author: Tony Xu
    *  Date Created: 12-02-14
    *  Input Parameters:  Application__c application
    *  Return: generateDocumentGeComOriginations.ApplicationMetadata
    */
    
    public static GenerateDocumentGeComOriginations.ApplicationMetadata generateApplicationMetadata(Application__c application){
        GenerateDocumentGeComOriginations.ApplicationMetadata applicationMetadata = new GenerateDocumentGeComOriginations.ApplicationMetadata();
        if(application.FP_IP_Address__c != null){
            applicationMetadata.applicationIPAddress = Application.FP_IP_Address__c;
        }
          
        if(application.Initial_Submit_Date__c != null){
            applicationMetadata.submissionDate = formatData(application.Initial_Submit_Date__c);    
        }
        
        return applicationMetadata;
    }
    
    

    //==========================
    //    Utility Functions
    //==========================
    
    /* Description: Formats date data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 11-08-13
    *  Input Parameters: inputDate
    *  Return: String
    */
    public static String formatData(Date inputDate) {        
        if(inputDate!=null) {
            system.debug(' date formatted ' + datetime.newInstanceGmt(inputDate.year(), inputDate.month(),inputDate.day()));
            return formatData(datetime.newInstanceGmt(inputDate.year(), inputDate.month(),inputDate.day()));
        }
        return null;
    }
    
    /* Description: Formats datetime data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 11-08-13
    *  Input Parameters: inputDateTime
    *  Return: String
    */
    public static String formatData(DateTime inputDateTime) {
    
        if(inputDateTime!=null) {
            system.debug('Date time format ' + inputDateTime.format('YYYY-MM-dd','Australia/Sydney'));
            return String.valueOf(inputDateTime.format('YYYY-MM-dd','Australia/Sydney'));
        }
                                                                                        
        return null;
    }
    
    /* Description: Formats string date field into date oject
    *  Author: Dan Crisologo
    *  Date Created: 02-03-2014
    *  Input Parameters: inputDateTime
    *  Return: String
    */
    public static Date formatStringToDate(String dateString) {
    
        Date dateResult;
        try { 
            if(dateString!=null) {
                //if(dateString.length()==10) {
                    String[] dateSplit = dateString.split('-');
                    if(dateSplit.size()==3) {
                        //year, month, date
                        dateResult = Date.newInstance(Integer.valueOf(dateSplit[2]), Integer.valueOf(dateSplit[1]), Integer.valueOf(dateSplit[0]));
                    }
               //}
            }
        } catch(Exception e) {
            throw e;
        }
                                                                                        
        return dateResult;
    }
    
    /* Description: Formats String data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 11-08-13
    *  Input Parameters: inputString
    *  Return: String
    */
    public static String formatData(String inputString) {      
    
       /* if(inputString!=null) {
            inputString = inputString.replaceAll('&"', '&amp;');
            inputString = inputString.replaceAll('"', '&quot;');
            inputString = inputString.replaceAll('\'', '&apos;');
            inputString = inputString.replaceAll('<', '&lt;');
            inputString = inputString.replaceAll('>', '&gt;');
        }*/ 
                                                                                  
        return inputString; 
    }

    public static String formatData(String inputString, Boolean mustBePresent) {   
        if(mustBePresent && inputString==null) {
            return '';
        } else {
            return formatData(inputString);
        }
    }
    
    /* Description: Formats Decimal data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 11-08-13
    *  Input Parameters: inputString
    *  Return: Decimal
    */
    public static Decimal formatData(Decimal inputNumber) {      
    
        if(inputNumber!=null) {
            return inputNumber;
        }
                                                                                  
        return 0; 
    }
    
    /* Description: Formats long data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: inputNumber
    *  Return: long 
    */
    public static long formatData(long inputNumber) {      
        if(inputNumber!=null) {
            return inputNumber;
        }                                                                       
        return 0; 
    }
    
    /* Description: Formats Double data into Webservice request format
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: inputNumber
    *  Return: Double 
    */
    public static Double formatData(Double inputNumber) {      
        if(inputNumber!=null) {
            return inputNumber;
        }                                                                       
        return 0; 
    }
    
    /* Description: Method that computes for the Applicant Age
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Date
    *  Return: Integer
    */
    public static Integer getApplicantAge(String bdate){        
        
        Integer age = 0;
        if(bdate != null && bdate != ''){
            Integer temp = formatStringToDate(bdate).daysBetween(Date.Today());
            age = Integer.valueOf(temp/365.2425);  
        }
        return age;   
        
    }
    
    /* Description: Method that convert Date to Datetime
    *  Author: Fel Saliba
    *  Date Created: 6-02-14
    *  Input Parameters: Date
    *  Return: Integer
    */
    public static Datetime formatDateToDatetime(Date bdate){        
        
        Datetime dt = datetime.newInstance(bdate.year(), bdate.month(),bdate.day());    
        return dt;
    }

    /* Description: Checks for null value decimal and rounds off amount to 2 decimal place
    *  Author: Dan Crisologo
    *  Date Created: 04-23-14
    *  Input Parameters: inputNumber
    *  Return: Decimal - rounded decimal
    */
    public static Decimal roundOffAmount(Decimal inputNumber) {      
    
        if(inputNumber!=null) {
            return inputNumber.setScale(2);
        }
                                                                                  
        return 0; 
    }
    
    /* Description: Return risk referral workflow decision and approver's SSO
    *  Author: Tony Xu
    *  Date Created: 2015-08-12
    *  Input Parameters: workflow__c
    *  Return: consumerAnzCapitalGeComOriginations.riskUserDataType
    *  MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance - Added application parameter for capacity limit and max offer amount
    */
    public static consumerAnzCapitalGeComOriginations.riskUserDataType generateRiskUserDataType(Workflow__c workflow, Application__c application){
        consumerAnzCapitalGeComOriginations.riskUserDataType riskUserDataType = new consumerAnzCapitalGeComOriginations.riskUserDataType();
        //BEGIN MLASALA: 30-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        //Added checking for workflow
        if(workflow != null){
            if(workflow.Risk_CPU_Decision__c != null){
                riskUserDataType.decisionOutcome = workflow.Risk_CPU_Decision__c;
            }
            
            if(workflow.Assigned_To_2__c != null){
                List<User> uList = [SELECT ID, SSO_Number__c FROM User WHERE id =: workflow.Assigned_To_2__c];
                riskUserDataType.riskUserId = uList[0].SSO_Number__c;
            }
        }
        //END MLASALA: 30-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        
        //BEGIN MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        riskUserDataType.capacityLimit = roundOffAmount(application.Capacity_Limit__c);
        riskUserDataType.maxOfferAmount = roundOffAmount(application.Max_Offer_Amount__c);
        System.debug('$$$ riskUserDataType: '+riskUserDataType);
        //END MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        
        return riskUserDataType;    
    }
    
    /* Description: Return thirdPartyDetails 
    *  Author: Afreen
    *  Date Created: June 22, 2016
    *  Input Parameters: Application__c
    *  Return: consumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType
    */
    public static consumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType generateThirdPartyDetails(Application__c application){
        consumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType thirdPartyDetails = new consumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType();
        if(application.X3rd_Party_Application_Number__c != null){
            thirdPartyDetails.applicationNumber = application.X3rd_Party_Application_Number__c;
        }
        if(application.X3rd_Party_Quoted_Rate__c != null){
            thirdPartyDetails.quotedRate = application.X3rd_Party_Quoted_Rate__c;
        }
        if(application.X3rd_Party_Quoted_Risk_Grade__c != null){
            thirdPartyDetails.quotedRiskGrade = application.X3rd_Party_Quoted_Risk_Grade__c;  
        }
        
        return thirdPartyDetails;     
    }
    
    /* Description: Return ReportDetails 
    *  Author: Afreen
    *  Date Created: June 22, 2016
    *  Input Parameters: Application__c
    *  Return: consumerAnzCapitalGeComOriginations.reportDetails
    */
    public static consumerAnzCapitalGeComOriginations.reportDetails generateReportDetails(Application__c application){
        consumerAnzCapitalGeComOriginations.reportDetails reportDetails = new consumerAnzCapitalGeComOriginations.reportDetails();
        
        reportDetails.reportDetail = generateReportDetail(application);
               
        return reportDetails;    
    }

  /* Description: Return ReportDetails 
    *  Author: Afreen
    *  Date Created: June 27, 2016
    *  Input Parameters: Application__c
    *  Return: List<consumerAnzCapitalGeComOriginations.reportDetail> 
    */
    public static List<consumerAnzCapitalGeComOriginations.reportDetail> generateReportDetail(Application__c application){
        
        List<ConsumerAnzCapitalGeComOriginations.reportDetail> reportDetailList = new List<ConsumerAnzCapitalGeComOriginations.reportDetail>();
        List<Reporting_Set_Up__mdt> reportingSetUp ;
        
        if(application != null){
            reportingSetUp = [Select Id, MasterLabel, DeveloperName, Value__c, Category__c From Reporting_Set_Up__mdt];
            for(Reporting_Set_Up__mdt reportData : reportingSetUp){
                if(application.get(reportData.Value__c) != null){
                  ConsumerAnzCapitalGeComOriginations.reportDetail reportDetail = new ConsumerAnzCapitalGeComOriginations.reportDetail();
                  reportDetail.Name = reportData.MasterLabel;
                  
                  //BEGIN MLASALA 14-JUL-16 DEFECT 1142 FIX
                  if(reportData.Value__c == 'Owner_at_Release_to_LPE_Queue__c'){
                      reportDetail.Value = String.valueOf(application.Owner_at_Release_to_LPE_Queue__r.SSO_Number__c);
                  } else if(reportData.Value__c == 'Owner_Name_at_release_from_IB_queue__c'){
                      reportDetail.Value = String.valueOf(application.Owner_Name_at_release_from_IB_queue__r.SSO_Number__c);
                  } else if(reportData.Value__c == 'Owner_Name_at_release_from_LPE_queue__c'){
                      reportDetail.Value = String.valueOf(application.Owner_Name_at_release_from_LPE_queue__r.SSO_Number__c);
                  } else {
                      reportDetail.Value = String.valueOf(application.get(reportData.Value__c));
                  }
                  //END MLASALA 14-JUL-16 DEFECT 1142 FIX
                  
                  reportDetail.Category = (String)reportData.Category__c;
                  reportDetailList.add(reportDetail);
                }
            }
        }
        
        return reportDetailList;
    } 
}