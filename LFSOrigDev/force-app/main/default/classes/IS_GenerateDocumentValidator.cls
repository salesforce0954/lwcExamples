/*
Author: Dan Crisologo
Created Date: Jan 08, 2014
Description: Represents Generate Document data validation error performed before a web service callout is made
Update: 2015-03-11 DBHZL386 Tony Xu validates the payoff quote is retrieved on the same day of document generation
        2015-06-29 WFNZUPDATE Tony Xu for NZ application, BM approval is no longer needed
        2015-08-07 PMIHM-1644  Adrian Recio July 2015 fix pack. Validation fixes for POI
        2016-02-09 TQLQW-21 Kabir - Changes to Personal Reference Check
*/
public with sharing class IS_GenerateDocumentValidator extends IS_AbstractCommonValidator implements IS_IValidator{
  public IS_GenerateDocumentValidator() {
  
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
    
    //Fahad Akhtar : DBHZL-56 #Check if applicaiton satisfy the Auto Loan Criteria
    //Added by FSaliba - method is accepting List
    List<Application__c> appList = new List<Application__c>();
   
    if(applicationDTO.app.Type_of_Product__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN){

        /* Fahad Akhtar : DBHZL-56 Validation to check Auto Loan applicaiton has a security record of type Motor vehicle associated.*/
        if(applicationDTO.app.Security_Count__c < 1){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Application type auto loan should have security of type motor vehicle'));
        }

        AUT_BenjiRulesUtility autoRule = new AUT_BenjiRulesUtility();
        appList.add(applicationDTO.app);
        //autoRule.benjiRulesValidation(appList);
        //if(applicationDTO.app.Benji_Rule_Results__c != '')
        //    validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest',applicationDTO.app.Benji_Rule_Results__c));

        validationErrors.addAll(autoRule.benjiRulesValidation(appList));
    }
    
    // check the out of sync flag
    if(applicationDTO.app.Out_Of_Sync__c){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application is out of sync.'));
    }

    // Added by Adrian Recio
    // Esnure that doc gen will not go if 
    // maximum capacity is exceeded.
    
    // Generate remaining capacity
    Double remainingCapacity;
    try{
        remainingCapacity = Double.valueOf(applicationDTO.app.Max_Monthly_Capacity__c - applicationDTO.app.EMI_with_Service_Fee__c);
    }catch(exception e){
        remainingCapacity = 0;
    }  

    // Validate Remaining Capacity
    if(remainingCapacity<0){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Maximum capacity exceeded.'));
    }

    if(applicationDTO.app.Mirror__c == null){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Please set the Mirror value.'));
    }
    //Afreen - May 13 - 2016 - Prevent users if the application is restarted
    if(applicationDTO.app.Application_Restarted__c == true){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application has restarted. Please confirm the changes on search tab.'));
    }
    
    Boolean hasR12L = false;
    Boolean hasR12S = false;
    list<Decision__c> decisionList = new list<Decision__c>();
    if(applicationDTO.app != null)
    {
        decisionList = [Select Id,
                                  Name,
                                  NBSM_Code__c
                           From   Decision__c
                           Where  Application__c =: applicationDTO.app.Id];
    }
    if(decisionList != null)
    {
        for(Decision__c d: decisionList)
        {
            if(d.NBSM_Code__c.contains('R12L'))
            {
                hasR12L = true;
            }
            if(d.NBSM_Code__c.contains('R12S'))
            {
                hasR12S = true;
            }
        }
    }
    
    if(hasR12L == true)
    {
        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Application breaches lending limits'));
    }
    if(hasR12S == true)
    {
        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Offer balances out of sync, recalculate and resubmit'));
    }

    //WFNZUPDATE - only check manager approval for AU application
    //BEGIN MLASALA: 08-MAR-15 - TQLQW-126 Manager Approval to be Optional for AU
    //Optional as well for AU
    // if(applicationDTO.app.Is_Manager_Approved__c == false && applicationDTO.app.brand_country__c == 'AU'){
    //   validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Loan must have Manager approval before generating contract'));
    // }
    //END MLASALA: 08-MAR-15 - TQLQW-126 Manager Approval to be Optional for AU
    
    // Name: Adrian Recio
    // Date: 3/16/2016
    // Description: Remove SAR and SCR checks 

    //check application Status
    /*
    if(applicationDTO.app.Response_Code__c != 'SAR' && applicationDTO.app.Response_Code__c != 'SCR' && applicationDTO.app.Response_Code__c != 'PCO' && applicationDTO.app.Response_Code__c != 'DG00'){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application Status should either be SAR, SCR or PCO'));
    }
    */
  

    //check application Status
    if(applicationDTO.app.Response_Code__c != 'PCO' && applicationDTO.app.Response_Code__c != 'DG00'){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application Status should be PCO.'));
    }
    
    
    //check Applicant Email Address
    if(applicationDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
        if(applicationDTO.applicant.Email_Address__c == null){
           validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','E-mail address is required.'));
        }
        else{
            String email = applicationDTO.applicant.Email_Address__c; 
            if(!Pattern.matches(GEN_OriginationsConstants.patternEmail, email)){
                validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','E-mail address should be valid.'));
            }
        }
        
        //Added FSALIBA 9/1/2015 - DBHZL- 188
        if(applicationDTO.applicant2 != null){
            if(applicationDTO.applicant2.Email_Address__c == null){
                validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant 2 E-mail address is required.'));
            }
            else{
                String email = applicationDTO.applicant2.Email_Address__c; 
                if(!Pattern.matches(GEN_OriginationsConstants.patternEmail, email)){
                    validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant 2 E-mail address should be valid.'));
                }
                if(applicationDTO.applicant.Email_Address__c == applicationDTO.applicant2.Email_Address__c){
                    validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','E-mail address should be unique for both applicant.'));
                }
            }
        }
    }
    
    /*LYVKD-39 Make compliance checklist entry optional - MDAVID - 8/12/2016
    //Check Compliance_Check__c records
    if(applicationDTO.ComplianceCheckList == null){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application should have Compliance check records'));
    }
    else if(applicationDTO.ComplianceCheckList.isEmpty()){
       validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application should have Compliance check records'));
    }
    else{
        Integer pfrCounter = 0;
        Integer bmCounter = 0;
        Integer totalPFRCounter = 0;
        Integer totalBMCounter = 0;

       for(Compliance_Check__c c: applicationDTO.complianceCheckList){
            if(c.Pre_Contract_Indicator__c){
                if(c.PFR_Only__c){
                    totalPFRCounter++;
                    if(c.PFR_Check__c != null){
                        pfrCounter++;
                    }
                }

                if(c.BM_Only__c){
                    totalBMCounter++;
                    if(c.BM_Check__c != null){
                        bmCounter++;
                    }
                }
            }
        }
        
        //Check Application Fields for Compliance CheckList
        if(totalPFRCounter != 0 || totalBMCounter != 0){
            if(pfrCounter != totalPFRCounter){
               validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application PFR Compliance Check Total should be equal to PFR Check Count'));
            }
            system.debug('bm counter:::::: '+bmCounter+'---'+totalBMCounter);
            if(bmCounter != totalBMCounter){
               validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application PFR2 Check Count should be equal to BM Compliance Check Total'));
            }
        } else {
            validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application should have Pre Settlement Compliance check records'));
        }        
    }*/
    
    //Personal Reference Check
    /*Changed as per Requirements for TQLQW-21.
    No Personal Reference Check required for NZ
    Only 1 Personal Reference Check required for NZ 
    */
    // TQLQW-21 Added by Kabir Singh
    /* -- Removing the Personal Reference Check for Doc gen as part of E2E tactic enhancement
    if (Profile_country__c.getInstance().AU__c){
        if(applicationDTO.personalReferenceList==null || applicationDTO.personalReferenceList.isEmpty()){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Personal Reference Check is required'));
        }
    } */
    
    /*if(applicationDTO.personalReferenceList==null || applicationDTO.personalReferenceList.isEmpty()){
        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Personal Reference Check are required'));
    }
    else{
        
        Set<String> notRelative = new Set<String>{'Friend','Neighbour','Partner'};
        Decimal count = 3;
        for(Personal_Reference_Check__c pr: applicationDTO.personalReferenceList){
            if(!notRelative.contains(pr.Relationship__c)){
                count = 2;
            }
        }
        
        if(Profile_country__c.getInstance().NZ__c) {
          count = 1;
        }
        
        if(count == 1) {
          if(count > applicationDTO.app.Personal_Reference_Check_Count__c){ 
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Atleast 1 Personal Reference is required'));
          }
        } else {
            if(count > applicationDTO.app.Personal_Reference_Check_Count__c){
                if(count == 2){
                    validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Two Personal References are required')); 
                }else{
                    validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'Three Personal References are required if there is no relative')); 
                }   
            }
        }
        
    }*/
    
    Boolean hasTitle = false;
    Boolean hasCategory = false;
    Boolean hasType = false;
    Boolean hasTemplateName = false;
    System.debug('applicationDTO.acceptanceDocuments-->'+applicationDTO.acceptanceDocuments);
    if(applicationDTO.acceptanceDocuments != null){
        system.debug('======DEBUG Acceptance Docs===='+applicationDTO.acceptanceDocuments);
        for(Related_Document__c rd: applicationDTO.acceptanceDocuments){
            if(rd.Title__c == null){
                hasTitle = true;
            }
            if(rd.Document_Category__c == null){
                hasCategory = true;
            }
            if(rd.Type__c == null){
                hasType = true;
            }
            if(rd.Template_Name__c == null){
                hasTemplateName = true;
            }
        }
        
        if(hasTitle){
            validationErrors.add(new IS_ValidationError('Validate Related Document', 'Related Document Title Missing.'));
        }
        if(hasCategory){
            validationErrors.add(new IS_ValidationError('Validate Related Document', 'Related Document Category Missing.'));
        }
        if(hasType){
            validationErrors.add(new IS_ValidationError('Validate Related Document', 'Related Document Type Missing.'));
        }
        if(hasTemplateName){
            validationErrors.add(new IS_ValidationError('Validate Related Document', 'Related Document Template Name Missing.'));
        }
    }

    // iterate through the acceptanceDocuments
    // for each document type perform type specific validations
    
    
    //Added by Fel Saliba 13/2/2014
    //Check for the collaterals if required fields are populated
    Boolean hasCollateral_Body_Type = false;
    Boolean hasCollateral_Reg_No = false;
    Boolean hasCollateral_Eng_No = false;
    Boolean hasCollateral_VIN_No = false;
    Boolean hasCollateral_Type = false;
    //new validations added -- 3/7
    Boolean hasCollateral_Make = false;
    Boolean hasCollateral_Model = false;
    Boolean hasCollateral_Year = false;
    Boolean hasCollateral_Val = false;
    Boolean hasCollateral_Date_Valued = false;
    Boolean hasCollateral_Insurance_company_name = false;
    Boolean hasCollateral_Insurance_expiry_date = false;
    Boolean hasCollateral_Insurance_Policy_number = false;
    Boolean hasCollateral_NVIC = false;
    Boolean hasCollateral_State_of_Registration = false;
    
    Boolean isNotComplete = false;
    Boolean isSecured = false;

    if(applicationDTO.collateralList != null){
            
            for(Collateral__c collateral:applicationDTO.collateralList){
                hasCollateral_Reg_No = collateral.Collateral_Reg_No__c == null ? true: false;
                hasCollateral_VIN_No = collateral.Collateral_VIN_No__c == null ? true: false;
                hasCollateral_Eng_No = collateral.Collateral_Eng_No__c == null ? true: false;
                hasCollateral_Body_Type = collateral.Collateral_Body_Type__c == null ? true: false;
                hasCollateral_Type = collateral.Collateral_Type__c == null ? true: false;
                
                hasCollateral_Make = collateral.Collateral_Make__c == null ? true: false;
                hasCollateral_Model = collateral.Collateral_Model__c == null ? true: false;
                hasCollateral_Year = collateral.Collateral_Year__c == null ? true: false;
                hasCollateral_Val = collateral.Collateral_Val__c == null ? true: false;
                hasCollateral_Date_Valued = collateral.Collateral_Date_Valued__c == null ? true: false;
                hasCollateral_Insurance_company_name = collateral.Collateral_Insurance_company_name__c == null ? true: false;
                hasCollateral_Insurance_expiry_date = collateral.Collateral_Insurance_expiry_date__c == null ? true: false;
                hasCollateral_Insurance_Policy_number = collateral.Collateral_Insurance_Policy_number__c == null ? true: false;
                hasCollateral_NVIC = collateral.Collateral_NVIC__c == null ? true: false;
                hasCollateral_State_of_Registration = collateral.Collateral_State_of_Registration__c == null ? true: false;
                isSecured = true;
            }
            
            if(hasCollateral_Reg_No && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral REG No.'));
            }
            if(hasCollateral_VIN_No){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral VIN No.'));

            }
            if(hasCollateral_Eng_No && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral ENG No.'));

            }
            if(hasCollateral_Body_Type){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Body Type.'));
            }
            if(hasCollateral_Type && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have Collateral Type.
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Type.'));
            }
            
            
            if(hasCollateral_Make ){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Make.'));
            }
            if(hasCollateral_Model && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Model.'));
            }
            if(hasCollateral_Year && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Year.'));
            }
            if(hasCollateral_Val ){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Value.'));
            }
            if(hasCollateral_Date_Valued && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Date Valued.'));
            }
            if(hasCollateral_Insurance_company_name && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Insurance Company Name.'));
            }
            if(hasCollateral_Insurance_expiry_date ){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Insurance Expiry Date.'));
            }
            if(hasCollateral_Insurance_Policy_number && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION ){//NZ doesnt have
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral Insurance Policy Number.'));
            }
            if(hasCollateral_NVIC && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION ){//NZ doesnt have NVIC
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral NVIC.'));
            }
            if(hasCollateral_State_of_Registration && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION ){//NZ doesnt have state of registration
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate Collateral State of Registration.'));
            }
            
            if(isSecured && applicationDTO.app.Offered_Interest_Rate__c > 29.95 && applicationDTO.applicant.State_Res__c == GEN_OriginationsConstants.VICTORIA_STATE){
                validationErrors.add(new IS_ValidationError('', 'The maximum APR for secured loans for applicant(s) residing Victoria is 29.95%.'));
            }

            /*if(isNotComplete){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Please populate all Collateral fields'));
            }*/
    }
    /*else{
        validationErrors.add(new IS_ValidationError('Validate Application', 'NO Collateral found.'));
    }*/
    
    if(applicationDTO.app != null){
        if(applicationDTO.app.Total_Loan_Amount__c!=null && applicationDTO.app.Total_Disbursements__c!=null){
            Decimal TotalDisbursementWithoutBrokerFee =  applicationDTO.app.Brokerage_Fee__c !=  null ? applicationDTO.app.Total_Disbursements__c - applicationDTO.app.Brokerage_Fee__c : applicationDTO.app.Total_Disbursements__c;

            if(applicationDTO.app.Total_Loan_Amount__c != TotalDisbursementWithoutBrokerFee){
                validationErrors.add(new IS_ValidationError('Validate Application', 'Total Loan Amount must be equal to Total Disbursement Amounts'));
            }                       
        }else{
            validationErrors.add(new IS_ValidationError('Validate Application', 'Total Loan Amount or Total Disbursement Amounts must not be null'));
        }
    }else{
        validationErrors.add(new IS_ValidationError('Validate Application', 'No Application found.'));
    }
    
    // Validations on created Documents
    
    if(applicationDTO.applicant.Full_Name__c == null){
        validationErrors.add(new IS_ValidationError('Validate Applicant', 'No Applicant Name.'));
    }    
    else{
        if(applicationDTO.applicant.Date_Of_Birth__c == null){
            validationErrors.add(new IS_ValidationError('Validate Applicant', 'Applicant Date of Birth is required.'));
        }
        if(applicationDTO.applicant2 != null){
            if(applicationDTO.applicant2.Full_Name__c == null){
                validationErrors.add(new IS_ValidationError('Validate Applicant', 'No Applicant Name.'));
            }
            if(applicationDTO.applicant2.Date_Of_Birth__c == null){
                validationErrors.add(new IS_ValidationError('Validate Applicant', 'Applicant2 Date of Birth is required.'));
            }       
        }
    }

    Boolean hasAccountHolders = false;
    Boolean hasBankName = false;
    Boolean hasbranchLocation = false;
    Boolean hasBSBNumber = false;
    Boolean hasAccountNumber = false;
    Boolean hasCommencement= false;
/*
Author: Suneel Desiraju
Created Date: 28/05/2019
Project : Better Start
Description: if Product SubType is Standard PL ,the debit record type should be either direct debit or payment card
             if Product SubType is Better Start PL,the debit record type should be direct debit
             Payment Card is not allowed for Better Start Product.
*/   
   if(applicationDTO.app.Product_SubType__c == 'Standard PL'){
    if(applicationDTO.applicationAllDebits.isEmpty()){
       validationErrors.add(new IS_ValidationError('Validate Debit', 'Please create a direct debit or payment card.')); 
    }
    }
    if(applicationDTO.app.Product_SubType__c == 'Better Start PL'){
    if(applicationDTO.applicationAllDebits.isEmpty()){
       validationErrors.add(new IS_ValidationError('Validate Debit', 'Please create a direct debit.')); 
    }
    }
    if(applicationDTO.app.Product_SubType__c == 'Better Start PL'){
      if(applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION){
        Id appId = ApexPages.currentPage().getParameters().get('id');
        List<AggregateResult> debtResult = [select Count(RecordType.Name) dt from Debit__c where Application__r.id=:appId  and RecordType.Name='Payment Card'];
        Object debtCount = debtResult[0].get('dt');
        Integer countdebt = (Integer)debtCount;
        System.debug('Debt Count Result'+countdebt);
        if(countdebt > 0){
               validationErrors.add(new IS_ValidationError('Debit Count', 'Payment Card is not allowed for Better Start Product')); 
    
      }
      }else if(applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION){
       Id appId = ApexPages.currentPage().getParameters().get('id');
        List<AggregateResult> debtResult = [select Count(RecordType.Name) dt from Debit__c where Application__r.id=:appId  and (RecordType.Name='Payment Card' OR RecordType.Name='Automatic Payment')];
        Object debtCount = debtResult[0].get('dt');
        Integer countdebt = (Integer)debtCount;
        System.debug('Debt Count Result'+countdebt);
        if(countdebt > 0){
               validationErrors.add(new IS_ValidationError('Debit Count', 'Payment Card and Automatic Payment are not allowed for Better Start Product'));    
         }
      }
    }
//End Better Start
    if(applicationDTO.applicationDebits != null){
        for(Debit__c debit:applicationDTO.applicationDebits){
                      
            if(debit.Account_Holders__c == null){
                hasAccountHolders = true;
            }
            if(debit.Bank_Name__c == null){
                hasBankName = true;
            }
            if(debit.Branch_Location__c == null){ 
                hasbranchLocation = true;
            }
            if(debit.BSB_Number__c == null){
                hasBSBNumber = true;
            }
            //if(debit.Account_Number__c == null){
            //    hasAccountNumber = true;
            //}
            if(debit.Commencement_Date__c == null){
                hasCommencement = true;
            }

            //check debit if higher amount specified that it's not less than the emi
            if(debit.repayment_level__c !=null && debit.repayment_level__c == 'Higher') {
                Decimal monthlyHigherValue = debit.Specify_Higher_Amount__c;
                if(debit.Frequency_Code__c == 'W') {
                    monthlyHigherValue = debit.Specify_Higher_Amount__c * 4;
                } else if(debit.Frequency_Code__c == 'F') {
                    monthlyHigherValue = debit.Specify_Higher_Amount__c * 2;
                }
                
                if(debit.Minimum_Monthly_Amount_Currency__c >= monthlyHigherValue) {
                   validationErrors.add(new IS_ValidationError('Validate Debit', 'Direct Debit has a specifed higher amount that is lower than the minimum repayment amount'));
                }
            }           
        }  
             
    }
    if(hasAccountHolders){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit Account Holder Missing.'));
    }

    // Updated by: Adrian Recio
    // Validation Removed for Fix Pack 5/10/2016
    /*
    if(hasBankName){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit Bank Name Missing.'));
    }
    */

    // Updated by: Adrian Recio
    // Validation Removed for Fix Pack 5/10/2016
    /*
    if(hasbranchLocation){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit Branch Location Missing.'));
    }
    */
    
    if(hasBSBNumber){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit BSB Number Missing.'));
    }
    if(hasAccountNumber){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit Account Number Missing.'));
    }
    if(hasCommencement){
        validationErrors.add(new IS_ValidationError('Validate Debit', 'Debit Commencement Date Missing.'));
    }

    Boolean hasClosureAuthority = false;
    Boolean hasLimitReduction = false;
    Boolean hasLoanPayoutStatement = false;
    if(applicationDTO.disbursementList != null){
        for(Disbursement__c disbursement: applicationDTO.disbursementList){
            if(disbursement.Disbursement_Outcome__c == 'Close'){
                hasClosureAuthority = true;
            }
            if(disbursement.Disbursement_Outcome__c == 'Reduce'){
                hasLimitReduction = true;
            }
            if(disbursement.Disbursement_Account_Type__c == GEN_OriginationsConstants.PRODUCT_TYPE
               && disbursement.Disbursement_Outcome__c == 'Close' && disbursement.Fin_Institution__c == 'GE'){               
               hasLoanPayoutStatement = true;                
            }
        }  
    }
    
    //Validation for Disbursement type Broker Sold Insurance
    if(applicationDTO.disbursementList != null){
        for(Disbursement__c disbursement: applicationDTO.disbursementList){
            if(disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_BROKER_INSURANCE){
                if(disbursement.Payee__c == null){
                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Payee is required for Broker Insurance Disbursement type.'));
                }
                if(disbursement.Principal_Amount__c == null){
                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Amount is required for Broker Insurance Disbursement type.'));
                }
                if(disbursement.Insurance_Type__c == null){
                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Insurance Type is required for Broker Insurance Disbursement type.'));
                }
            }        
            //Added by Suneel - Validations for BSB and Account Number - Cheque Disbursement Removal Project
                        if(disbursement.Record_Type_Name__c == 'Broker Fee EFT'){

                                            if(disbursement.BSB__c ==   null){
                                                       validationErrors.add(new IS_ValidationError('Validate Disbursement', 'BSB Number is Missing in Broker Fee EFT'));
                                                       }
                                            if(disbursement.BSB__c == '000000'){
                                                       validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Please enter a valid BSB Number'));
                                             }
                                            if(disbursement.Bank_Acc_No__c == null ){
                                                       validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Account Number is Missing in Broker Fee EFT'));
                                                }
                                              if(disbursement.Bank_Acc_No__c == '000000' ){
                                                       validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Please enter a valid Account Number'));
                                                }
                          } 
            //Added by Suneel - Validations for BPAY Custom fields 06/02/2018
                     if(disbursement.Record_Type_Name__c == 'BPAY AU' || disbursement.Record_Type_Name__c == 'LFS Card Closure Interest Free' || disbursement.Record_Type_Name__c == 'LFS Card Closure Without Interest Free' || disbursement.Record_Type_Name__c == 'LFS Card Limit Reduction' || disbursement.Record_Type_Name__c == 'Non-LFS Card & Overdraft Closure - BPAY' || disbursement.Record_Type_Name__c == 'Non-LFS Card & Overdraft Limit Reduction - BPAY'){
                     
                                if(disbursement.BillerCode__c == null){
                                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Biller Code is Missing'));
                                }
                               if(disbursement.BillerShortName__c == null){
                                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Biller Short Name is Missing'));
                                }
                                if(disbursement.Reference__c == null){
                                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Reference Number is Missing'));
                                }
                                if(disbursement.Amount__c == null){
                                    validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Amount is Missing'));
                                }
                     
                     }
             //End - BPAY Validations

        }
    }
    
    
    //Closure Authority And Limit Reduction Authority
    
    Boolean hasBankAccountNumber = false;
    Boolean hasFinInstitution = false;
    Boolean hasInsAddress1 = false;
    Boolean hasInsAddress2 = false;
    Boolean hasProductName = false;
    Boolean payoffQuoteExpired = false; //DBHZL386
    
    if(hasClosureAuthority || hasLimitReduction){
        if(applicationDTO.disbursementPlanList != null){
            for(Disbursement__c d:applicationDTO.disbursementList){
                //if(d.Bank_Acc_No__c == null && 
                //  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_DIRECT_CREDIT ||
                //   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE)){                  
                //    hasBankAccountNumber = true;
                //}
                if(d.Fin_Institution__c == null && 
                  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE || 
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION)){
                    hasFinInstitution = true;
                }
                if(d.Financial_Institution_Address_1__c == null && 
                  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE || 
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION)){
                    hasInsAddress1 = true;
                }
                if(d.Financial_Institution_Address_2__c == null && 
                  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE || 
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION)){
                    hasInsAddress2 = true;
                }
                if(d.Product_Name__c == null &&
                  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE || 
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION ||
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_GECARD_CLOSURE_INTERES_FREE || 
                   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_GECARD_CLOSURE_WITHOUT_INTEREST_FREE)){
                    hasProductName = true;
                }
                //DBHZL386
                Integer PAYOFF_VALID_DAYS_AT_DOCGEN = Integer.valueOf(Admin_Settings__c.getValues('Payoff Valid Days at Doc Gen').value__c);
                
                Date expiryDate = date.Today().addDays(0-PAYOFF_VALID_DAYS_AT_DOCGEN);
                
                if(d.Payout_Effective_Date__c < expiryDate && (
                  d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE || d.Record_type_Name__c == 'Re-Finance'
                   //Temporary put in this OR statement as the record_type_name__c fireld is using the record type name rather than developer name,
                   //This field is already in Production, to prevent causing any further damage by changing the formula we put this OR statement in here                   
                   )){
                    payoffQuoteExpired = true;                 
                }
                
            }
        }
        
        if(hasBankAccountNumber){
           validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Bank Account Number Missing.'));
           
        }
        if(hasFinInstitution){
           validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Institution Missing.'));
           
        }
        if(hasInsAddress1){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Institution Address 1 Missing.'));
           
        }
        if(hasInsAddress2){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Institution Address 2 Missing.'));
            
        }
        if(hasProductName){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Product Name Missing.'));
            
        }
        //DBHZL386
        if(payoffQuoteExpired){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Payff quote expired,'));
        }
        
         
        if(applicationDTO.branch != null){
            if(applicationDTO.branch.Name == null){
                validationErrors.add(new IS_ValidationError('Validate Branch', 'Branch Name Missing.'));
                
            }
            if(applicationDTO.branch.Address__c == null){
                validationErrors.add(new IS_ValidationError('Validate Branch', 'Branch Address Missing.'));
                
            }
            if(applicationDTO.branch.Phone__c == null){
                validationErrors.add(new IS_ValidationError('Validate Branch', 'Branch Phone Missing.'));
                
            }
            if(applicationDTO.branch.fax__c == null){
                validationErrors.add(new IS_ValidationError('Validate Branch', 'Branch Fax Missing.'));
                
            }
        }      
    }
    
    //Closure Authority
    Boolean hasValidUntilDate = false;
    if(hasClosureAuthority){
        //Payout Amount
        if(applicationDTO.disbursementList != null){
            for(Disbursement__c disbursement: applicationDTO.disbursementList){
                if(disbursement.Valid_Until_Date__c == null &&
                  (disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE || 
                   disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION ||
                   disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_GECARD_CLOSURE_INTERES_FREE || 
                   disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_GECARD_CLOSURE_WITHOUT_INTEREST_FREE)){
                    hasValidUntilDate = true;
                }
            }
        }
        
        if(hasValidUntilDate){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Valid Until Date Missing.'));
        }
        
    }
    
    //Limit Reduction Authority
    Boolean hasNewCreditLimit = false;
    if(hasLimitReduction){
        //Current Balance
        if(applicationDTO.disbursementList != null){
            for(Disbursement__c disbursement: applicationDTO.disbursementList){
                if(disbursement.New_Credit_Limit__c == null && disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_GECARD_LIMIT_REDUCTION){
                    hasNewCreditLimit = true;
                }
            }
        }
        if(hasNewCreditLimit){
            validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Credit Limit Missing.'));
        }
        
    }
    
    
    //IF Rebate
    Boolean hasBankAccIF = false;
    Boolean hasIfCreditPlan = false;
    Boolean hasIfCurrentCreditPlan = false;
    Boolean hasRebateAmount = false;
    Boolean hasTotalRebate = false;
    Boolean hasTotalIfCreditPlan = false;
    
    if(applicationDTO.disbursementPlanList != null){
        for(Disbursement_Plan__c dp:applicationDTO.disbursementPlanList){
            
            //Branch Number, 
            
            /*if(dp.Disbursement__r.Bank_Acc_No__c == null){
                hasBankAccIF = true;
            }*/
            if(dp.IF_Credit_Plan_Number__c == null){
                hasIfCreditPlan = true;
            }
            if(dp.IF_Current_Credit_Plan_Balance__c == null){
                hasIfCurrentCreditPlan = true;
            }
            if(dp.Rebate_Amount__c == null){
                hasRebateAmount = true;
            }
            if(dp.Disbursement__r.Total_Rebate_Amount__c == null){
                hasTotalRebate = true;
            }
            if(dp.Disbursement__r.Total_IF_Credit_Plan_Balance__c == null){
                hasTotalIfCreditPlan = true;
            }
        }
    }
    
    /*if(hasBankAccIF){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Bank  Account Missing.'));
           
    }*/
    if(hasIfCreditPlan ){
        validationErrors.add(new IS_ValidationError('Validate Disbursement Plan', 'Disbursement Plan If Credit Plan Missing.'));
        
    }
    if(hasIfCurrentCreditPlan){
        validationErrors.add(new IS_ValidationError('Validate Disbursement Plan', 'Disbursement Plan If Current Credit Plan Missing.'));
        
    }
    if(hasRebateAmount){
        validationErrors.add(new IS_ValidationError('Validate Disbursement Plan', 'Disbursement Plan Rebate Amount Missing.'));
        
    }
    if(hasTotalRebate){
        validationErrors.add(new IS_ValidationError('Validate Disbursement Plan', 'Disbursement Total Rebate Missing.'));
        
    }
    if(hasTotalIfCreditPlan){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Total If Credit Plan Missing.'));
        
    }
    
    
    //Payout Statement
    Boolean hasBankAccPS = false;
    Boolean hasPayoutEffectiveDate = false;
    Boolean hasPrincipalAmount = false;
    Boolean hasInterestDue = false;
    Boolean hasLateFeesDue = false;
    Boolean hasPenaltyInterestDue = false;
    Boolean hasFeesOrChargesDue = false;
    Boolean hasChargeOfAmount = false;
    Boolean hasInsuranceRebate = false;
    Boolean hasEarlyTerminationFee = false;
    Boolean hasNetPayOffDue = false;
    
    if(hasLoanPayoutStatement){
        for(Disbursement__c d: applicationDTO.disbursementList){
            //if(d.Bank_Acc_No__c == null &&
            //  (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_DIRECT_CREDIT ||
            //   d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE)){
            //    hasBankAccPS = true;
            //}
            if(d.Payout_Effective_Date__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasPayoutEffectiveDate = true;
            }
            if(d.Principal_Amount__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasPrincipalAmount = true;
            }
            if(d.Interest_Due__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasInterestDue = true;
            }
            if(d.Late_Fees_Due__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasLateFeesDue = true;
            }
            if(d.Penalty_Interest_Due__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasPenaltyInterestDue = true;
            }
            if(d.Fees_or_Charges_Due__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasFeesOrChargesDue = true;
            }
            if(d.Charge_Off_Amount__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasChargeOfAmount = true;
            }
            if(d.Insurance_Rebate__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasInsuranceRebate = true;
            }
            if(d.Early_Termination_Fee__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE){
                hasEarlyTerminationFee = true;
            } 
            if(d.Net_Payoff_Due__c == null && d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE ){
                hasNetPayOffDue = true;
            }
        }
    }
    if(hasBankAccPS){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Bank Account Missing.'));
        
    }
    if(hasPayoutEffectiveDate){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Payout Effective Date Missing.'));
        
    }
    if(hasPrincipalAmount){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Principal Amount Missing.'));
        
    }
    if(hasInterestDue){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Interest Due Missing.'));
        
    }
    if(hasLateFeesDue){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Late Fees Due Missing.'));
        
    }
    if(hasPenaltyInterestDue){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Penalty Interest Due Missing.'));
        
    }
    if(hasFeesOrChargesDue){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Fees or Charges Due Missing.'));
        
    }
    if(hasChargeOfAmount){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Charge Of Amount Missing.'));
        
    }
    if(hasInsuranceRebate){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Insurance Amount Rebate Missing.'));
        
    }
    if(hasEarlyTerminationFee){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Early Termination Fee Missing.'));
        
    }
    if(hasNetPayOffDue){
        validationErrors.add(new IS_ValidationError('Validate Disbursement', 'Disbursement Net Pay Off Due Missing.'));
        
    }
    
    //Added by Mike Lasala 04/30/14 - GCO-2196
    //Check if Acceptance Channel is null
    if(applicationDTO.app.Acceptance_Channel__c == null){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application Acceptance Channel is required.'));
    }

    //Check if AML is done
    if(applicationDTO.applicant.Has_AML__c == false && 
        (applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION || 
            (applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
             applicationDTO.applicant.Verification_Method__c == GEN_OriginationsConstants.APPLICANT_VERIFICATION_TYPE_MANUAL_AML))){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant should have AML.'));
    }
    
    if(applicationDTO.applicant.Has_POA__c == false && 
       applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
       applicationDTO.applicant.Verification_Method__c == GEN_OriginationsConstants.APPLICANT_VERIFICATION_TYPE_POA){

      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant should have POA.'));
    }

    //Check if Credit File Check is done
    /* Removing this as part of the E2E Tactical enhancements LM-2238
    if(applicationDTO.applicant.Has_Credit_File_Check__c == false && !Profile_Country__c.getInstance().NZ__c){
      validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant should have Credit File Check.'));
    } */

    /***************************************************************************************************************************************************/
    // Updated by : Adrian Recio
    // Change Details: 8/7/2015 - July 2015 Fix Pack - PMIHM-1644
    // Description: Removed old POI validation via boolean field in applicant 1. Check is now based on reason code present in application response description
    /***************************************************************************************************************************************************/
    //if(applicationDTO.applicant.POI_Financial_Situation_Verified__c == false && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){
    /*if(applicationDTO.applicant.POI_Financial_Situation_Verified__c == false){
        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 1 is incomplete.'));
    }*/

    Boolean appli1hasPOIError = false;
    appli1hasPOIError = APP_CommonExt.parsePOICodes(applicationDTO.app.Response_Description__c,'Applicant 1');
    if(appli1hasPOIError){
        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 1 is incomplete.'));
    }
    /***************************************************************************************************************************************************/

    //Same check for joint application
    if(applicationDTO.applicant2 != null){

        if(applicationDTO.applicant2.Has_AML__c == false && 
           (applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION || 
            (applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
             applicationDTO.applicant.Verification_Method__c == GEN_OriginationsConstants.APPLICANT_VERIFICATION_TYPE_MANUAL_AML))){
          validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant 2 should have AML.'));
        }

        if(applicationDTO.applicant2.Has_POA__c == false && 
           applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION && 
           applicationDTO.applicant2.Verification_Method__c == GEN_OriginationsConstants.APPLICANT_VERIFICATION_TYPE_POA){

          validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant 2 should have POA.'));
        }

    /* Removing this as part of the E2E Tactical enhancements LM-2238
        if(applicationDTO.applicant2.Has_Credit_File_Check__c == false && !Profile_Country__c.getInstance().NZ__c){
          validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Applicant 2 should have Credit File Check.'));
        }
    */

        /***************************************************************************************************************************************************/
        // Updated by : Adrian Recio
        // Change Details: 8/7/2015 - July 2015 Fix Pack - PMIHM-1644 
        // Description: Removed old POI validation via boolean field in applicant 2. Check is now based on reason code present in application response description
        /***************************************************************************************************************************************************/
        //if(applicationDTO.applicant2.POI_Financial_Situation_Verified__c == false && applicationDTO.app.Brand_Lookup__r.Country__c != GEN_OriginationsConstants.NZ_REGION){
        /*
        if(applicationDTO.applicant2.POI_Financial_Situation_Verified__c == false){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 2 is incomplete'));
        }
        */
        Boolean appli2hasPOIError = false;
        appli2hasPOIError = APP_CommonExt.parsePOICodes(applicationDTO.app.Response_Description__c,'Applicant 2');
        if(appli2hasPOIError){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 2 is incomplete.'));
        }
        /***************************************************************************************************************************************************/

    }

    /*if(applicationDTO.disbursementList.size()>10){
        validationErrors.add(new IS_ValidationError('', 'The maximum number of disbursements per application is 10'));
    }*/
    
    //check for existing workflow
    if(applicationDTO.app.Workflow_In_Progress__c){
        validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','You cannot create an account when there is an existing workflow in progress.'));
    }
        
    return validationErrors; 
  }
}