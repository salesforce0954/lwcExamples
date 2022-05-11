public without sharing class PL_AppSubmit_AppCreate {
    
    
    /**
     * Creates an Application record for a Broker Application
     * This method also creates Product_Item__c record
     */

    public static String createApplicationRecord(PrimaryApplicantDetailsWrapper padw){
        Application__c appObj = new Application__c();
        if(padw != null && padw.loanDetails != null && padw.personalDetails != null){
            if(validateInputs(padw)){
                ConsentDetailsWrapper loanDetails = padw.loanDetails;
                PersonalInformationWrapper personalDetails = padw.personalDetails;
                PersonalInformationWrapper personalDetailsJoint = padw.personalDetailsJoint;
                try{
                    //Fetch the Product Version, Product Id (GEProduct__c) from the Product Version object
                    System.debug('RUN User id: '+UserInfo.getUserId());
                    Product_Version__c prodVersionObj = [SELECT Id, 
                                                                GEProduct__c,
                                                                GEProduct__r.Brands__r.Name, 
                                                                GEProduct__r.Brands__r.Id,
                                                                GEProduct__r.Brands__r.Online_Branch__c 
                                                        FROM Product_Version__c 
                                                        WHERE Type__c ='Personal Loan' 
                                                                AND 
                                                                Brand__c ='Latitude'];
                    System.debug('prodVersionObj APEX: '+prodVersionObj);
                    
                    //Get the Broker Id, Broker First Name & Broker Last Name from Contact
                    User userObj =      [SELECT  Contact.FirstName, 
                                                Contact.LastName, 
                                                Contact.Broker_ID__c,
                                                Contact.Id,
                                                Contact.MobilePhone
                                            FROM User 
                                        WHERE Id = :UserInfo.getUserId()];
                    System.debug('userObj APEX: '+userObj);
                    String productVersionId;
                    String productId;
                    String brandId;
                    String brandName;
                    String branchId;
                    String brokerFirstName;
                    String brokerLastName;
                    String brokerId;
                    String brokerRecordId;
                    String brokerContactNumber;
                    if(prodVersionObj != null && userObj != null){
                        productVersionId = prodVersionObj.Id;
                        productId = prodVersionObj.GEProduct__c;
                        brandId = prodVersionObj.GEProduct__r.Brands__r.Id;
                        brandName = prodVersionObj.GEProduct__r.Brands__r.Name;
                        branchId = prodVersionObj.GEProduct__r.Brands__r.Online_Branch__c;

                        //Broker Details
                        brokerFirstName = userObj.Contact.FirstName;
                        brokerLastName = userObj.Contact.LastName;
                        brokerId = userObj.Contact.Broker_ID__c;
                        brokerRecordId = userObj.Contact.Id;
                        brokerContactNumber = userObj.Contact.MobilePhone;
                        Decimal totalLoanAmount = calculateTotalLoanAmount(loanDetails);

                        //Create Application record
                        
                        String loanTerm = loanDetails.LoanTerm;
                        appObj.Product_Id__c = productId;
                        appObj.UID__c = personalDetails.LatitudeUid;
                        appObj.Brand_String__c = brandName;
                        appObj.Brand_Lookup__c = brandId;
                        appObj.Payment_Frequency__c = 'Monthly';
                        appObj.Channel__c = 'Broker';
                        if(padw.loanDetails.Applicants == '1'){
                            appObj.Application_Type__c = 'Single'; 
                            appObj.Applicant_1_Name__c = personalDetails.FirstName + ' '+ personalDetails.LastName;
                        }else if(padw.loanDetails.Applicants == '2'){
                            appObj.Application_Type__c = 'Joint';
                            appObj.Applicant_1_Name__c = personalDetails.FirstName + ' '+ personalDetails.LastName; 
                            appObj.Applicant_2_Name__c = personalDetailsJoint.FirstName + ' '+ personalDetailsJoint.LastName; 
                        }
                        appObj.Broker__c = brokerRecordId;
                        appObj.Broker_First_Name_Captured__c = brokerFirstName;
                        appObj.Broker_Last_Name_Captured__c = brokerLastName;
                        appObj.Broker_Contact_Number__c = brokerContactNumber; 
                        appObj.Broker_ID__c = brokerId;
                        appObj.Type_of_Product__c = 'Personal Loan';
                        appObj.Product_SubType__c = loanDetails.ProductType;
                        appObj.Application_Source__c = 'INTERNET';
                        appObj.Business_Source__c = 'BROKER LOAN';
                        appObj.Branch__c = branchId;
                        appObj.Mirror__c = 'Broker';
                        appObj.Initial_Requested_Amount__c = totalLoanAmount;
                        appObj.Loan_Term__c = loanTerm;
                        appObj.Total_Loan_Amount__c = totalLoanAmount;
                        appObj.Loan_Term_Months__c = Decimal.valueOf(loanTerm.split(' ', 2)[0])*12;
                        //Maximum Limit consent captured here
                        if(loanDetails.MaxLimit != null){
                            appObj.Higher_Approval_Consent__c = loanDetails.MaxLimit;
                        }else{
                            appObj.Higher_Approval_Consent__c = false;
                        }
                        insert appObj;

                        //Create Product Item (Essential for identifying product version and thus calculating the interest rate)
                        createProductItem(appObj.Id,productVersionId);
                    }else{
                        throw new AppSubmitException('Error fetching Brand & User Information');
                    }
                }catch(Exception e){
                    throw new AppSubmitException('Error creating Application & Product Item record. Error Details: '+e.getMessage());
                }
            }            
        }else{
            throw new AppSubmitException('Loan Details cannot be empty.');
        }
        return appObj.Id;
    }

     /**
     * Creates an Product Item record for a Broker Application
     */

    private static void createProductItem(String applicationId, String productVersionId){
        Product_Item__c piObj = new Product_Item__c();
        piObj.Application__c = applicationId;
        piObj.Product_Version__c = productVersionId;
        insert piObj;
    }

    /**
     * Calculate the total loan amount from all the loan purposes mentioned in the application
     */
    private static Decimal calculateTotalLoanAmount(ConsentDetailsWrapper loanDetails){
        Decimal totalLoanAmount = 0.0;
        Decimal totalAmount = 0.0;//Total of loan amounts for additional loan purposes added
        for(ConsentDetailsWrapper.Loan loanObj : loanDetails.LoanInfo){
            totalAmount += Decimal.valueOf(loanObj.loanAmount);
        }
        totalLoanAmount = totalAmount + Decimal.valueOf(loanDetails.LoanAmountQuote);
        return totalLoanAmount; 
    }


    public static String createONRRecord(PrimaryApplicantDetailsWrapper padw,String applicationId){
        
        String generalRecordTypeId = Schema.SObjectType.ONR__c.getRecordTypeInfosByName().get('General').getRecordTypeId();
        String loanPurposeRecordTypeId = Schema.SObjectType.ONR__c.getRecordTypeInfosByName().get('Loan Purpose').getRecordTypeId();
        List<ONR__c> onrInsertList = new List<ONR__c>();
        String onrId;//Id used to link Loan purposes
        try{
            ONR__c onrObj = new ONR__c();
            onrObj.Type__c = 'Table';
            onrObj.geID__c = '/personal/need/purposeTable';
            onrObj.Application__c = applicationId;
            onrObj.RecordTypeId = generalRecordTypeId;
            onrInsertList.add(onrObj);
            if(!padw.loanDetails.LoanInfo.isEmpty()){
                ONR__c onrObj1 = new ONR__c();
                onrObj1.Type__c = 'YesOrNo';
                onrObj1.geID__c = '/personal/need/openToOtherProduct';
                onrObj1.Value__c = 'No';
                onrObj1.Prompt__c = 'Consumer is open for other products?';
                onrObj1.Application__c = applicationId;
                onrObj1.RecordTypeId = loanPurposeRecordTypeId;
                onrInsertList.add(onrObj1);
            }
            if(onrInsertList.size()>0){
                insert onrInsertList;
                for(ONR__c onr : onrInsertList){
                    if(onr.Type__c == 'Table'){
                        onrId = onr.Id;
                    }
                }
            }
        }catch(Exception e){
            throw new AppSubmitException('Error creating ONR record. Error Details: '+e.getMessage());
        }
        return onrId;
    }

    /**
     * Create Loan Purpose records for all the Loan purposes
     */
    public static void createLoanPurposeRecord(PrimaryApplicantDetailsWrapper padw, String applicationId,String onrId){
        List<ConsentDetailsWrapper.Loan> loanInfoList = padw.loanDetails.LoanInfo;
        List<Loan_Purpose__c> loanPurposeInsertList = new List<Loan_Purpose__c>();
        try{
            for(ConsentDetailsWrapper.Loan loanObj : loanInfoList){
                Loan_Purpose__c lpObj = new Loan_Purpose__c();
                lpObj.Application__c = applicationId;
                lpObj.Loan_Amount__c = Decimal.valueOf(loanObj.loanAmount);
                lpObj.Value__c = loanObj.loanPurpose;
                if(loanObj.loanPurpose == 'Other'){
                    lpObj.Other_Loan_Purpose__c = loanObj.otherLoanPurpose;
                }
                lpObj.ONR__c = onrId;
                loanPurposeInsertList.add(lpObj);
            }
            Loan_Purpose__c lpObj_q = new Loan_Purpose__c();
            lpObj_q.Application__c = applicationId;
            lpObj_q.Loan_Amount__c = Decimal.valueOf(padw.loanDetails.LoanAmountQuote);
            lpObj_q.Value__c = padw.loanDetails.LoanPurposeQuote;
            if(padw.loanDetails.LoanPurposeQuote == 'Other'){
                lpObj_q.Other_Loan_Purpose__c = padw.loanDetails.OtherLoanPurposeQuote;
            }
            lpObj_q.ONR__c = onrId;
            loanPurposeInsertList.add(lpObj_q);
            if(loanPurposeInsertList.size()>0){
                insert loanPurposeInsertList;
            }
        }catch(Exception e){
            throw new AppSubmitException('Error creating Loan Purpose record. Error Details: '+e.getMessage());
        }
    }

    /**
     * Create Disbursement record to record Broker Fees (Broker Fee EFT)
     */

     public static void createDisbursementRecord(PrimaryApplicantDetailsWrapper padw, String applicationId){
        try{
            System.debug('padw: '+padw.personalDetails);
            String brokerFeeEftRecordTypeId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Broker Fee EFT').getRecordTypeId();
            System.debug('brokerFeeEftRecordTypeId: '+brokerFeeEftRecordTypeId);
            User userObj =      [SELECT     Contact.FirstName, 
                                            Contact.LastName
                                        FROM User 
                                    WHERE Id = :UserInfo.getUserId()];
                                    System.debug('userObj: '+userObj);
            Disbursement__c disbObj = new Disbursement__c();
            disbObj.RecordTypeId = brokerFeeEftRecordTypeId; 
            disbObj.Payee__c = userObj.Contact.FirstName+' '+userObj.Contact.LastName;
            disbObj.Amount__c = Decimal.valueOf(padw.personalDetails.BrokerFees);
            disbObj.BSB__c = '000000';
            disbObj.Bank_Acc_No__c = '000000';
            disbObj.Application__c = applicationId;
            System.debug('disbObj: '+disbObj);
            insert disbObj;
        }catch(Exception e){
            throw new AppSubmitException('Error creating Disbursement record. Error Details: '+e.getMessage());
        }
     }

     /**
      * 
      */
      private static Boolean validateInputs(PrimaryApplicantDetailsWrapper padw){
        Boolean isValid = false;
        PersonalInformationWrapper personalDetails = padw.personalDetails;
        ConsentDetailsWrapper loanDetails = padw.loanDetails;
        if(String.isBlank(loanDetails.LoanTerm) || String.isBlank(loanDetails.LoanAmountQuote) || String.isBlank(loanDetails.LoanPurposeQuote) ||
            String.isBlank(loanDetails.Applicants) || String.isBlank(personalDetails.FirstName) || String.isBlank(personalDetails.LastName)){
                throw new AppSubmitException('Loan Details are mandatory for creating an Application and cannot be empty.');
            }else{
                isValid = true;
            }
        return isValid;
      }
     
}