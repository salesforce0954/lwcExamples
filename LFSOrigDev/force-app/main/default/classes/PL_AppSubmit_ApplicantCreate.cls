public with sharing class PL_AppSubmit_ApplicantCreate {
    
    /**
      * Create Applicant(s) record(s)
      */
      public static List<Applicant__c> createApplicantRecord(PrimaryApplicantDetailsWrapper padw,String applicationId,String applicants){
        List<Applicant__c> applicantList = new List<Applicant__c>();
        List<PersonalInformationWrapper> applicantInfoList = new List<PersonalInformationWrapper>();
        try{
            if(!String.isBlank(applicants)){
                applicantInfoList.add(padw.personalDetails);
                if(applicants == '2'){
                    applicantInfoList.add(padw.personalDetailsJoint);
                }
            }
            System.debug('applicantInfoList '+applicantInfoList);
            applicantList = createApplicants(applicantInfoList,applicationId,padw);    
            System.debug('applicantList after insert '+applicantList);
        }catch(Exception e){
            throw new AppSubmitException(e.getMessage());
        }
        return applicantList;
    }

    /**
     * Create Primary Applicant. Validate & Map the fields as received
     */
    private static List<Applicant__c> createApplicants(List<PersonalInformationWrapper> applicantInfoList,String applicationId,PrimaryApplicantDetailsWrapper padw){
        List<Applicant__c> applicantForInsertList = new List<Applicant__c>();
        try{

            for(PersonalInformationWrapper personalDetails : applicantInfoList){

                Boolean isPrimaryApplicant =false;
                ConsentDetailsWrapper loanDetails = new ConsentDetailsWrapper();
                EmploymentDetailsWrapper employmentDetails = new EmploymentDetailsWrapper();
                ExpenseDetailsWrapper expenseDetails = new ExpenseDetailsWrapper();
                if(!String.isBlank(personalDetails.LatitudeUid)){
                    isPrimaryApplicant = true;
                    loanDetails = padw.loanDetails;
                    employmentDetails = padw.employmentDetails;
                    expenseDetails = padw.expenseDetails;
                }else{
                    employmentDetails = padw.employmentDetailsJoint;
                    expenseDetails = padw.expenseDetailsJoint;
                }
                
                
                    if(validateInputs(personalDetails)){
                        Applicant__c applicantObj = new Applicant__c();
                        applicantObj.Is_Primary_Applicant__c = isPrimaryApplicant;
                        applicantObj.Application__c = applicationId;
                        applicantObj.Debt_Consolidation_Acknowledgement__c=false; //TODO: Check if this is linked to Debts
    
                        // ************************CONSENT DETAILS: START****************************************
                        if(isPrimaryApplicant){
                            if(loanDetails.PrivacyConsent != null){
                                applicantObj.Meets_Eligibility_Criteria__c = Boolean.valueOf(loanDetails.PrivacyConsent); //Privacy and Credit reporting Consent
                            }
                            if(loanDetails.ProductDisclosure != null){
                                applicantObj.Agrees_to_Fees__c = Boolean.valueOf(loanDetails.ProductDisclosure); //Product Disclosure Consent
                            }
                            if(loanDetails.ECommunication != null){
                                applicantObj.Agrees_to_Privacy_Policy__c = Boolean.valueOf(loanDetails.ECommunication); //Electronic Communication Consent
                            }
                            //If the above 3 are true, then Accept_Terms_and_Conditions__c is automatically true
                            if(Boolean.valueOf(loanDetails.PrivacyConsent) && Boolean.valueOf(loanDetails.ProductDisclosure) && Boolean.valueOf(loanDetails.ECommunication)){
                                applicantObj.Accept_Terms_and_Conditions__c = true;
                            }else{
                                applicantObj.Accept_Terms_and_Conditions__c = false;
                            }
                            if(loanDetails.EIncome != null){
                                applicantObj.Agrees_to_Income_Verification__c = Boolean.valueOf(loanDetails.EIncome); //Electronic Income Verification (POI) Consent
                            }
                            if(loanDetails.EIdentification != null & !Boolean.valueOf(loanDetails.EIdentification)){
                                applicantObj.EIDV__c = 'No'; //Electronic Identification (EIDV) Consent
                            }else if(loanDetails.EIdentification != null & Boolean.valueOf(loanDetails.EIdentification)){
                                applicantObj.EIDV__c = 'Yes';
                            }
                        }
                        //**********************************CONSENT DETAILS: END**************************************
    
                        //*******************************PERSONAL DETAILS: START****************************************
                        applicantObj.Title__c=personalDetails.Title;
                        applicantObj.First_Name__c=personalDetails.FirstName;
                        applicantObj.Middle_Name__c=personalDetails.MiddleName;
                        applicantObj.Last_Name__c=personalDetails.LastName;
                        applicantObj.Gender__c=personalDetails.Gender;
                        String dob = personalDetails.DateOfBirth;
                        if(dob != null){
                            applicantObj.Date_of_Birth__c= dob.replace('/', '-'); // (DD-MM-YYYY)
                            List<String> dobList = dob.split('/');
                            applicantObj.Date_of_Birth_WS__c= dobList[2]+'-'+dobList[1]+'-'+dobList[0]; // (YYYY-MM-DD)
                            applicantObj.Applicant_Age__c = System.today().year() - Integer.valueOf(dobList[2]);
                        }
                        applicantObj.Date_of_Birth_Doc_Gen__c=personalDetails.DateOfBirth; // (DD/MM/YYYY)
                        applicantObj.Rel_Status__c=personalDetails.RelationshipStatus; 
                        if(!String.isBlank(personalDetails.Dependents)){
                            applicantObj.No_of_Deps__c=Double.valueOf(personalDetails.Dependents);
                        }
                        if(personalDetails.NoDL!= null && Boolean.valueOf(personalDetails.NoDL)){
                            applicantObj.Drivers_Lic_Flg__c = true;
                        }else{
                            applicantObj.Drivers_Lic_No__c = personalDetails.DLNumber;
                        }
                        
                        applicantObj.Mobile__c=personalDetails.MobileNumber; 
                        applicantObj.Home__c=personalDetails.HomeNumber;
                        applicantObj.Work__c=personalDetails.WorkNumber;
                        applicantObj.Email_Address__c=personalDetails.Email;
                        applicantObj.ConfirmEmailAddress__c = personalDetails.ConfirmEmail;
                        //Home_Area_Code__c:, Home_WS__c:, Work_Area_Code__c:, Work_WS__c //TODO: check how these fields are used 
    
                        //Residential Address Section
                        applicantObj.Residential_Property_Name__c=personalDetails.ResidentialPropName;
                        applicantObj.Unit_No_Res__c = personalDetails.ResidentialUnitNumber;
                        applicantObj.Street_No_Res__c= personalDetails.ResidentialStreetNumber;
                        applicantObj.Street_Res__c=personalDetails.ResidentialStreet;
                        applicantObj.Street_Type_Res__c=personalDetails.ResidentialStreetType;
                        applicantObj.Suburb_Res__c=personalDetails.ResidentialSuburb;
                        applicantObj.Postcode_Res__c=personalDetails.ResidentialPostcode;
                        applicantObj.State_Res__c=personalDetails.ResidentialState;
                        applicantObj.Country_Res__c='Australia';
                        applicantObj.Years_At_Addr__c=personalDetails.ResidentialYears;
                        if(String.isBlank(personalDetails.ResidentialMonths)){
                            applicantObj.Months_At_Addr__c= '0';    
                        }else{
                            applicantObj.Months_At_Addr__c=personalDetails.ResidentialMonths;
                        }
                        
    
                        if(!String.isBlank(personalDetails.ResidentialYears) && Integer.valueOf(personalDetails.ResidentialYears) < 3){
                            //Previous Residential Address Section
                            applicantObj.Previous_Property_Name__c=personalDetails.PrevProperty;
                            applicantObj.Unit_No_Pre__c = personalDetails.PrevUnitNumber;
                            applicantObj.Street_No_Pre__c= personalDetails.PrevStreetNumber;
                            applicantObj.Street_Pre__c=personalDetails.PrevStreet;
                            applicantObj.Street_Type_Pre__c=personalDetails.PrevStreetType;
                            applicantObj.Suburb_Pre__c=personalDetails.PrevSuburb;
                            applicantObj.Postcode_Pre__c=personalDetails.PrevPostcode;
                            applicantObj.State_Pre__c=personalDetails.PrevState;
                            applicantObj.Country_Pre__c='Australia';
                            applicantObj.Years_At_Prev_Addr__c=personalDetails.PrevYears;
                            if(String.isBlank(personalDetails.PrevMonths)){
                                applicantObj.Months_At_Prev_Addr__c= '0';
                            }else{
                                applicantObj.Months_At_Prev_Addr__c=personalDetails.PrevMonths;
                            }
                            
                        }
                        
                        //Is Postal Address same as Residential address
                        if(!String.isBlank(personalDetails.IsPostalAddSameAsRes) && Boolean.valueOf(personalDetails.IsPostalAddSameAsRes)){
                            //Copy Residential Address details to postal
                            applicantObj.Postal_Property_Name__c= personalDetails.ResidentialPropName;
                            applicantObj.Unit_No_Pos__c= personalDetails.ResidentialUnitNumber;
                            applicantObj.Street_No_Pos__c=personalDetails.ResidentialStreetNumber;
                            applicantObj.Street_Pos__c=personalDetails.ResidentialStreet;
                            applicantObj.Street_Type_Pos__c=personalDetails.ResidentialStreetType;
                            applicantObj.Suburb_Pos__c=personalDetails.ResidentialSuburb;
                            applicantObj.Postcode_Pos__c=personalDetails.ResidentialPostcode;
                            applicantObj.State_Pos__c=personalDetails.ResidentialState;
                            applicantObj.Country_Pos__c= 'Australia';
                            applicantObj.Postal_Addr_Flg__c = true;
                        }else{
                            //Map Postal address fields
                            applicantObj.Postal_Property_Name__c= personalDetails.PosPropertyName;
                            applicantObj.Unit_No_Pos__c= personalDetails.PosUnitNumber;
                            applicantObj.Street_No_Pos__c=personalDetails.PosStreetNumber;
                            applicantObj.Street_Pos__c=personalDetails.PosStreet;
                            applicantObj.Street_Type_Pos__c=personalDetails.PosStreetType;
                            applicantObj.Suburb_Pos__c=personalDetails.PosSuburb;
                            applicantObj.Postcode_Pos__c=personalDetails.PosPostcode;
                            applicantObj.State_Pos__c=personalDetails.PosState;
                            applicantObj.Country_Pos__c='Australia';
                            applicantObj.Postal_Addr_Flg__c = false;
                        }
    
                        applicantObj.Primary_Employment_Status__c = employmentDetails.EmploymentStatus;
                        applicantObj.Previous_Employment_Status__c = employmentDetails.PreviousEmploymentStatus;
                        if(!String.isBlank(employmentDetails.PrevEmploymentYears)){
                            applicantObj.Time_at_previous_employer_years__c = Double.valueOf(employmentDetails.PrevEmploymentYears);
                        }
                        if(!String.isBlank(padw.employmentDetails.PrevEmploymentMonths)){
                            applicantObj.Time_at_previous_employer_months__c = Double.valueOf(employmentDetails.PrevEmploymentMonths);
                        }
                        //RL Change: Same Residential status applicable for both A1 & A2
                        applicantObj.Res_Status__c = padw.expenseDetails.ResidentialStatus;
                        
                        //insert applicantObj;
                        applicantForInsertList.add(applicantObj);
                    }
            }
            if(!applicantForInsertList.isEmpty()){
                insert applicantForInsertList;
            }
        }catch(Exception e){
                throw new AppSubmitException('Invalid inputs provided. '+e.getMessage());
            }
        
        
        return applicantForInsertList;
    }

    /**
     * Validate the required inputs to create an applicant record
     */
    private static Boolean validateInputs(PersonalInformationWrapper personalDetails){
        Boolean isValid = false;
        if(personalDetails != null ){
        
            //Validate if the required fields have value else throw an exception
            if(String.isBlank(personalDetails.Title) || String.isBlank(personalDetails.FirstName) || String.isBlank(personalDetails.LastName) || String.isBlank(personalDetails.Gender) ||
                String.isBlank(personalDetails.DateOfBirth)|| String.isBlank(personalDetails.RelationshipStatus) || String.isBlank(personalDetails.ResidentialStreetNumber) || 
                String.isBlank(personalDetails.ResidentialStreet) || String.isBlank(personalDetails.ResidentialStreetType) || String.isBlank(personalDetails.ResidentialSuburb) || String.isBlank(personalDetails.ResidentialState) ||
                String.isBlank(personalDetails.ResidentialPostcode) || String.isBlank(personalDetails.ResidentialYears) ||
                String.isBlank(personalDetails.Email) || String.isBlank(personalDetails.MobileNumber)){
                    //throw exception
                    throw new AppSubmitException('Personal Details are mandatory for creating an Applicant.');
            }

            if(Integer.valueOf(personalDetails.ResidentialYears) < 3){
                if(String.isBlank(personalDetails.PrevStreetNumber) || String.isBlank(personalDetails.PrevStreet) || String.isBlank(personalDetails.PrevStreetType) || 
                    String.isBlank(personalDetails.PrevSuburb) || String.isBlank(personalDetails.PrevState) || String.isBlank(personalDetails.PrevPostcode) || 
                    String.isBlank(personalDetails.PrevState) || String.isBlank(personalDetails.PrevYears)){
                        //throw exception
                    throw new AppSubmitException('Previous Address Details are required.');
                }
            }

            if(!Boolean.valueOf(personalDetails.IsPostalAddSameAsRes)){
                if(String.isBlank(personalDetails.PosStreetNumber) || String.isBlank(personalDetails.PosStreet) || String.isBlank(personalDetails.PosStreetType) || 
                    String.isBlank(personalDetails.PosSuburb) || String.isBlank(personalDetails.PosState) || String.isBlank(personalDetails.PosPostcode)
                    || String.isBlank(personalDetails.PosState) ){
                        //throw exception
                    throw new AppSubmitException('Postal Address Details are required.');
                }
            }
            //If all the checks pass, then the request is valid
            isValid = true;
        }else{
            throw new AppSubmitException('Applicant Details cannot be empty.');
        }
        return isValid;
    }

    /**
     * Create Income records for the applicant
     */
    public static void createIncomeRecord(List<EmploymentDetailsWrapper.Income> incomeDetailsList,String applicantId){

        if(incomeDetailsList.isEmpty()){
            throw new AppSubmitException('Income Details are required.');
        }else{
            try{
                List<Income__c> incomeInsertList = new List<Income__c>();
                Double totalIncomeAmount = 0.0;
                String auIncomeRecordTypeId = Schema.SObjectType.Income__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
                for(EmploymentDetailsWrapper.Income incomeWrapperObj : incomeDetailsList){
                    Income__c incomeObj = new Income__c();
                    Double incomeAmount = 0.0;
                    incomeObj.Income_Source__c = incomeWrapperObj.IncomeFrom;
                    if(!String.isBlank(incomeWrapperObj.IncomeAmount)){
                        incomeObj.Income_Amount__c= Double.valueOf(incomeWrapperObj.IncomeAmount);
                    }
                    incomeObj.Income_Interval__c=incomeWrapperObj.IncomeFrequency;
                    incomeAmount = calculateTotalMonthlyAmount(Double.valueOf(incomeWrapperObj.IncomeAmount),incomeWrapperObj.IncomeFrequency);
                    incomeObj.Total_Income__c= incomeAmount;
                    totalIncomeAmount += incomeAmount;
                    incomeObj.RecordTypeId=auIncomeRecordTypeId; 
                    incomeObj.Occupation__c = incomeWrapperObj.Occupation;
                    incomeObj.Applicant__c=applicantId;
                    if(!String.isBlank(incomeWrapperObj.EmploymentMonths)){
                        incomeObj.Months_With_Employer__c = Double.valueOf(incomeWrapperObj.EmploymentMonths);
                    }
                    if(!String.isBlank(incomeWrapperObj.EmploymentYears)){
                        incomeObj.Years_With_Employer__c = Double.valueOf(incomeWrapperObj.EmploymentYears);
                    }
                    
                    incomeObj.Emp_Bus_Name__c = incomeWrapperObj.EmployerName;
                    incomeObj.Emp_Bus_Contact_No__c = incomeWrapperObj.EmployerContact;
                    if(!String.isBlank(incomeWrapperObj.EmployerContact)){
                        String empContact = incomeWrapperObj.EmployerContact;
                        incomeObj.Employer_Business_Contact_No_Area_Code__c = empContact.substring(0, 2);
                        incomeObj.Employer_Business_Contact_No_WS__c = empContact.substring(2);
                    }
                    incomeInsertList.add(incomeObj);
                }
                if(!incomeInsertList.isEmpty()){
                    insert incomeInsertList;
                }

                //Update Applicant Record with the Expense details
                Applicant__c applicantObj = new Applicant__c();
                applicantObj.Id = applicantId;
                applicantObj.Total_Income__c = totalIncomeAmount;
                update applicantObj;
            }catch(Exception e){
                throw new AppSubmitException('Error creating Income. '+e.getMessage());
            }
        }  
    }

    /**
     * Calculate the total monthly amount (applicable for income, expense) 
     */
    private static Double calculateTotalMonthlyAmount(Double amount, String frequency){
                    
            Double totalMonthlyAmount= 0;

            if(frequency==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                totalMonthlyAmount = (amount * 52) / 12;
            } else if (frequency==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                totalMonthlyAmount = (amount * 26) / 12;
            } else if (frequency==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                totalMonthlyAmount = amount;
            } else if (frequency==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
                totalMonthlyAmount = amount / 12;
            }else if(frequency == GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER){
                totalMonthlyAmount = amount / 3;
            }
            return totalMonthlyAmount;
    }

    /**
     * Create Expense record
     */
    public static void createExpenseRecord(ExpenseDetailsWrapper expenseDetails,String applicantId){
        System.debug('NEW EXPENSE: '+expenseDetails);
        System.debug('applicantId Expense '+applicantId);
        if(expenseDetails != null){
            try{
                Double totalExpense = 0.0;
                Double monthlyRentalExpense = 0.0;
                Double monthlyFoodExpense = 0.0;
                Double monthlyInsuranceExpense = 0.0;
                Double monthlyUtilitiesExpense = 0.0;
                Double monthlyTransportExpense = 0.0;
                Double monthlyEducationExpense = 0.0;
                Double monthlyPersonalExpense = 0.0;
                //String livingExp = expenseDetails.LivingExpenses;
                //String livingExpFreq = expenseDetails.LivingExpensesFreq;
                String payAllExpenses = expenseDetails.DoYouPayAllExpenses;
                Expense__c expenseObj = new Expense__c();
                
                
                expenseObj.Food_Groc_Entert__c = expenseDetails.FoodExpense;
                expenseObj.Food_Groc_Interval__c = expenseDetails.FoodFrequency;
                expenseObj.Insurance_Expense__c = expenseDetails.InsuranceExpense;
                expenseObj.Insurance_Expense_Interval__c = expenseDetails.InsuranceFrequency;
                expenseObj.Utilities_Expense__c = expenseDetails.UtilitiesExpense;
                expenseObj.Utilities_Expense_Interval__c = expenseDetails.UtilitiesFrequency;
                expenseObj.Transport_Expense__c = expenseDetails.TransportExpense;
                expenseObj.Transport_Expense_Interval__c = expenseDetails.TransportFrequency;
                expenseObj.Education_and_child_Expense__c = expenseDetails.EducationExpense;
                expenseObj.Education_and_child_Expense_Interval__c = expenseDetails.EducationFrequency;
                expenseObj.Personal_Other_Expense__c = expenseDetails.PersonalExpense;
                expenseObj.Personal_Other_Expense_Interval__c = expenseDetails.PersonalFrequency;
                if(expenseDetails.RentBoardPayments != null && !String.isBlank(expenseDetails.PaymentFrequency)){
                    monthlyRentalExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.RentBoardPayments),expenseDetails.PaymentFrequency);
                    expenseObj.Rent_Board_Pay_Amt__c = expenseDetails.RentBoardPayments;
                    expenseObj.Rent_Board_Pay_Int__c = expenseDetails.PaymentFrequency;
                    expenseObj.Agent_Landlord_Name__c = expenseDetails.LandlordName;
                }
                monthlyFoodExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.FoodExpense), expenseDetails.FoodFrequency);
                monthlyInsuranceExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.InsuranceExpense), expenseDetails.InsuranceFrequency);
                monthlyUtilitiesExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.UtilitiesExpense), expenseDetails.UtilitiesFrequency);
                monthlyTransportExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.TransportExpense), expenseDetails.TransportFrequency);
                monthlyEducationExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.EducationExpense), expenseDetails.EducationFrequency);
                monthlyPersonalExpense = calculateTotalMonthlyAmount(Double.valueOf(expenseDetails.PersonalExpense), expenseDetails.PersonalFrequency);
                
                totalExpense = monthlyRentalExpense + monthlyFoodExpense + monthlyInsuranceExpense + monthlyUtilitiesExpense + monthlyTransportExpense + monthlyEducationExpense + monthlyPersonalExpense;
                expenseObj.Total_Exp__c= totalExpense;
                expenseObj.Applicant__c=applicantId; 
                if(!String.isBlank(payAllExpenses)){
                    expenseObj.I_Pay_All_Exp__c=Boolean.valueOf(payAllExpenses);
                }   
                insert expenseObj;

                //Update Applicant Record with the Expense details
                    Applicant__c applicantObj = new Applicant__c();
                    applicantObj.Id = applicantId;
                    applicantObj.Total_Expense__c = totalExpense;
                    update applicantObj;
                
            }catch(Exception e){
                throw new AppSubmitException('Error creating Expense record. '+e.getMessage());
            }
        }else{
            throw new AppSubmitException('Expense Details cannot be empty.');
        }
    }


    

    /**
     * Create Dummy Expense record 
     */
    public static void createExpenseRecordJoint(String applicantId){
        try{
            Expense__c expenseObj = new Expense__c();
            expenseObj.Living_Exp__c= 0.0;
            expenseObj.Applicant__c=applicantId;
            insert expenseObj;
        }catch(Exception e){
            throw new AppSubmitException('Error creating Joint Expense record. '+e.getMessage());
        }

    }

    /**
     * 
     * Create Asset record
     */
    public static void createAssetRecord(PrimaryApplicantDetailsWrapper padw,String applicantId){
        if(padw != null && padw.assetDetails != null){
            try{
                List<Asset__c> assetInsertList = new List<Asset__c>();
                List<AssetDetailsWrapper.Asset> assetsList = padw.assetDetails.AssetInfo;
                Boolean noAssetsFlag = padw.assetDetails.NoAssets;
                Double totalAssetValue = 0.0;
                if(!noAssetsFlag){
                    String auAssetRecordTypeId = Schema.SObjectType.Asset__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
                    for(AssetDetailsWrapper.Asset assetWrapObj : assetsList){
                        Asset__c assetObj = new Asset__c();
                        totalAssetValue += Double.valueOf(assetWrapObj.AssetValue);
                        assetObj.RecordTypeId = auAssetRecordTypeId;
                        assetObj.Applicant__c = applicantId;
                        assetObj.Asset_Value__c = Double.valueOf(assetWrapObj.AssetValue);
                        assetObj.Ownership_Status__c = assetWrapObj.AssetOwnership;
                        assetObj.Total_Assets__c = Double.valueOf(assetWrapObj.AssetValue);
                        assetObj.Asset_Category__c = assetWrapObj.AssetType;
                        if(assetWrapObj.AssetType == GEN_OriginationsConstants.ASSET_CATEGORY_CAR){
                            assetObj.Vehicle_Make__c = assetWrapObj.VehicleMake;
                            assetObj.Vehicle_Model__c = assetWrapObj.VehicleModel;
                            assetObj.Vehicle_Year__c = assetWrapObj.YearOfManufacture;
                        }
                        assetInsertList.add(assetObj);
                    }
                    if(!assetInsertList.isEmpty()){
                        insert assetInsertList;
                    }
                }
                //Update Applicant Record with the asset details
                if(noAssetsFlag != null){
                    Applicant__c applicantObj = new Applicant__c();
                    applicantObj.Id = applicantId;
                    if(noAssetsFlag){
                        applicantObj.Asset_Exempt__c = true;
                    }
                    applicantObj.Total_Assets__c = totalAssetValue;
                    update applicantObj;
                }
                
            }catch(Exception e){
                throw new AppSubmitException('Error creating Assets. '+e.getMessage());
            }
        }
    }

    /**
     * Create Debt Record. For Debt Calculations, refer the original file, MyBudgetsDebtWrapper
     */
    public static void createDebtRecord(PrimaryApplicantDetailsWrapper padw,String applicantId){
        if(padw != null && padw.debtDetails != null){
            try{
                List<Liability__c> debtInsertList = new List<Liability__c>();
                List<DebtDetailsWrapper.Debt> debtsList = padw.debtDetails.DebtInfo;
                Boolean noDebtsFlag = padw.debtDetails.NoDebts;
                Double totalDebtValue = 0.0;
                if(!noDebtsFlag){
                    String auDebtRecordTypeId = Schema.SObjectType.Liability__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
                    for(DebtDetailsWrapper.Debt debtWrapObj : debtsList){
                        Liability__c debtObj = new Liability__c();
                        debtObj.RecordTypeId = auDebtRecordTypeId;
                        String debtCategory = debtWrapObj.DebtType;
                        if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.RepaymentAmount)){
                                debtObj.Mortgage_Repayment_Amt__c = Double.valueOf(debtWrapObj.RepaymentAmount);
                                monthlyDebtAmount = calculateTotalMonthlyAmount(Double.valueOf(debtWrapObj.RepaymentAmount),debtWrapObj.RepaymentInterval);
                            }
                            debtObj.Mortgage_Repayment_Interval__c = debtWrapObj.RepaymentInterval;
                            if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                debtObj.Acknowledge_Payout__c = true;
                                monthlyDebtAmount = 0.0;
                            }
                            debtObj.Total_Debts__c = monthlyDebtAmount;
                            debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                            if(!String.isBlank(debtWrapObj.AmountBorrowed)){
                                debtObj.Mortgage_Borrowed_Amt__c = Double.valueOf(debtWrapObj.AmountBorrowed);
                            }
                            if(!String.isBlank(debtWrapObj.BalanceRemaining)){
                                debtObj.Mortgage_Bal_Amt__c = Double.valueOf(debtWrapObj.BalanceRemaining);
                            }
                            totalDebtValue+= monthlyDebtAmount;
                            debtInsertList.add(debtObj);
                        }else if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN ||
                                    debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN || 
                                    debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.RepaymentAmount)){
                                debtObj.Car_Personal_Repay_Amt__c = Double.valueOf(debtWrapObj.RepaymentAmount);
                                monthlyDebtAmount = calculateTotalMonthlyAmount(Double.valueOf(debtWrapObj.RepaymentAmount),debtWrapObj.RepaymentInterval);
                            }
                            debtObj.Car_Personal_Repay_Int__c = debtWrapObj.RepaymentInterval;
                            if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                debtObj.Acknowledge_Payout__c = true;
                                monthlyDebtAmount = 0.0;
                            }
                            debtObj.Total_Debts__c = monthlyDebtAmount;
                            debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                            if(!String.isBlank(debtWrapObj.AmountBorrowed)){
                                debtObj.Car_Personal_Borrowed_Amt__c = Double.valueOf(debtWrapObj.AmountBorrowed);
                            }
                            if(!String.isBlank(debtWrapObj.BalanceRemaining)){
                                debtObj.Car_Personal_Bal_Amt__c = Double.valueOf(debtWrapObj.BalanceRemaining);
                            }
                            totalDebtValue+= monthlyDebtAmount;
                            debtInsertList.add(debtObj);
                        }else if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.RepaymentAmount)){
                                debtObj.Other_Repay_Amt__c = Double.valueOf(debtWrapObj.RepaymentAmount);
                                monthlyDebtAmount = calculateTotalMonthlyAmount(Double.valueOf(debtWrapObj.RepaymentAmount),debtWrapObj.RepaymentInterval);
                            }
                            debtObj.Other_Repay_Int__c = debtWrapObj.RepaymentInterval;
                            if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                debtObj.Acknowledge_Payout__c = true;
                                monthlyDebtAmount = 0.0;
                            }
                            debtObj.Total_Debts__c = monthlyDebtAmount;
                            debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                            if(!String.isBlank(debtWrapObj.AmountBorrowed)){
                                debtObj.Other_Borrowed_Amt__c = Double.valueOf(debtWrapObj.AmountBorrowed);
                            }
                            totalDebtValue+= monthlyDebtAmount;
                            debtInsertList.add(debtObj);
                        }else if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT ||
                                    debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.CardLimit) && !String.isBlank(debtWrapObj.BalanceRemaining)){
                                Double cardLimit = Double.valueOf(debtWrapObj.CardLimit);
                                Double cardBalance = Double.valueOf(debtWrapObj.BalanceRemaining);
                                debtObj.Credit_Limit_Amt__c = cardLimit;
                                debtObj.Card_Overdraft_Bal_Amt__c = cardBalance;
                                //For Cards, consider 3% 
                                if(cardBalance < cardLimit){
                                    monthlyDebtAmount = cardLimit * 0.03;
                                }else{  
                                    monthlyDebtAmount = cardBalance * 0.03;
                                }
                            }
                            if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                debtObj.Acknowledge_Payout__c = true;
                                monthlyDebtAmount = 0.0;
                            }
                            debtObj.Total_Debts__c = monthlyDebtAmount;
                            debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                            if(!String.isBlank(debtWrapObj.BalanceRemaining)){
                                debtObj.Card_Overdraft_Bal_Amt__c = Double.valueOf(debtWrapObj.BalanceRemaining);
                            }
                            totalDebtValue+= monthlyDebtAmount;
                            debtInsertList.add(debtObj);
                        }else if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.CardLimit) && !String.isBlank(debtWrapObj.BalanceRemaining)){
                                Double cardLimit = Double.valueOf(debtWrapObj.CardLimit);
                                Double cardBalance = Double.valueOf(debtWrapObj.BalanceRemaining);
                                debtObj.Credit_Limit_Amt__c = cardLimit;
                                debtObj.Card_Overdraft_Bal_Amt__c = cardBalance;

                                if(cardBalance < cardLimit){
                                    if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < cardLimit * 0.03){
                                        monthlyDebtAmount = cardLimit * 0.03;
                                    }else{
                                        monthlyDebtAmount = GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                                    } 
                                }else{
                                    if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < cardBalance * 0.03){
                                        monthlyDebtAmount = cardBalance * 0.03;
                                    }else{
                                        monthlyDebtAmount = GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                                    }
                                }
                                if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                    debtObj.Acknowledge_Payout__c = true;
                                    monthlyDebtAmount = 0.0;
                                }
                                debtObj.Total_Debts__c = monthlyDebtAmount;
                                debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                                totalDebtValue+= monthlyDebtAmount;
                                debtInsertList.add(debtObj);
                            }
                        }else if(debtCategory == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
                            Double monthlyDebtAmount = 0.0;
                            debtObj.Applicant__c = applicantId;
                            debtObj.Debt_Category__c = debtWrapObj.DebtType;
                            debtObj.Financier_Name__c = debtWrapObj.FinInstitution;
                            if(!String.isBlank(debtWrapObj.CardLimit) && !String.isBlank(debtWrapObj.BalanceRemaining) &&
                                !String.isBlank(debtWrapObj.InterestRate)){
                                Double cardLimit = Double.valueOf(debtWrapObj.CardLimit);
                                Double cardBalance = Double.valueOf(debtWrapObj.BalanceRemaining);
                                Double interestRate = Double.valueOf(debtWrapObj.InterestRate);
                                debtObj.Credit_Limit_Amt__c = cardLimit;
                                debtObj.Card_Overdraft_Bal_Amt__c = cardBalance;
                                debtObj.Overdraft_APR__c = interestRate;
                                if(cardBalance < cardLimit){
                                    monthlyDebtAmount = (cardLimit * (interestRate/100)) / 12;
                                }else{
                                    monthlyDebtAmount = (cardBalance * (interestRate/100)) / 12;
                                }
                               
                            }
                            if(!String.isBlank(debtWrapObj.PayOutNConsolidate) && Boolean.valueOf(debtWrapObj.PayOutNConsolidate)){
                                debtObj.Acknowledge_Payout__c = true;
                                monthlyDebtAmount = 0.0;
                            }
                            debtObj.Total_Debts__c = monthlyDebtAmount;
                            debtObj.Original_Total_Debt_Monthly__c = monthlyDebtAmount;
                            if(!String.isBlank(debtWrapObj.BalanceRemaining)){
                                debtObj.Card_Overdraft_Bal_Amt__c = Double.valueOf(debtWrapObj.BalanceRemaining);
                            }
                            totalDebtValue+= monthlyDebtAmount;
                            debtInsertList.add(debtObj);
                        }
                    }
                    if(!debtInsertList.isEmpty()){
                        System.debug('debtInsertList: '+debtInsertList);
                        System.debug('totalDebtValue: '+totalDebtValue);
                        insert debtInsertList;
                    }
                    
                }
                //Update Applicant Record with the debt details
                if(noDebtsFlag != null){
                    Applicant__c applicantObj = new Applicant__c();
                    applicantObj.Id = applicantId;
                    if(noDebtsFlag){
                        applicantObj.Debts_Exempt__c = true;
                    }
                    applicantObj.Total_Debts__c = totalDebtValue;
                    update applicantObj;
                }

            }catch(Exception e){
                throw new AppSubmitException('Error creating Debts. '+e.getMessage());
            }

        }
    }

}