/*
Author: Andrew Manetakis (Cloud Sherpas)
Created Date: Dec 18, 2013
Description: Represents a data validation error performed before a web service callout is made
*/
public with sharing class IS_ApplicationUpdateValidator extends IS_AbstractCommonValidator implements IS_IValidator{    
   public Integer countdisbCount;
   public Decimal countpayDownCount;
   public Decimal countlimitReductionCount;
   public Decimal countcardClosureCount;
   public Decimal TotalCount;
   public IS_ApplicationUpdateValidator() {
    }

    public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
            
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        
        //perform validations here
        //e.g. check if app.status != new

        if(applicationDTO.app.Total_Loan_Amount_New_Cash__c < 1000){
            IS_ValidationError ive = new IS_ValidationError('Validate Application', 'New Cash amount is less than $1000');

            validationErrors.add(ive);
        }
        //Added by Fel Saliba Jan 10, 2014
        
        //check Loan Purpose
        validationErrors.addAll(checkIfEmpty(applicationDTO.loanPurList,'Atleast 1 Loan Purpose is required'));
        
        //check Applicant 1 Asset 
        //validationErrors.addAll(checkIfEmpty(applicationDTO.assetList,'Atleast 1 Asset is required'));
        
        //check Applicant 1 Income
        validationErrors.addAll(checkIfEmpty(applicationDTO.incList,'Atleast 1 Income is required'));
        
        //check Applicant 1 Expense
        validationErrors.addAll(checkIfEmpty(applicationDTO.expenseList,'Atleast 1 Expense is required'));
        
        //check Applicant 1 Debt 
        //validationErrors.addAll(checkIfEmpty(applicationDTO.debtList,'Atleast 1 Debt is required'));
        
        //check if Joint
        if(applicationDTO.applicant2 != null){
            //check Applicant 2 Asset 
            //validationErrors.addAll(checkIfEmpty(applicationDTO.assetList2,'Atleast 1 Asset is required for Applicant 2'));
            
            //check Applicant 2 Income
            validationErrors.addAll(checkIfEmpty(applicationDTO.incList2,'Atleast 1 Income is required for Applicant 2'));
            
            //check Applicant 2 Expense
            // Commenting the below line as part of RL and NZCCCFA becasue expense records are at Application level
            //validationErrors.addAll(checkIfEmpty(applicationDTO.expenseList2,'Atleast 1 Expense is required for Applicant 2'));
            
            //check Applicant 2 Debt 
            //validationErrors.addAll(checkIfEmpty(applicationDTO.debtList2,'Atleast 1 Debt is required for Applicant 2'));
        }        
        /*if(applicationDTO.disbursementList.size()>10){
            IS_ValidationError ive = new IS_ValidationError('', 'The maximum number of disbursements per application is 10');
            validationErrors.add(ive);
        }*/                
        //BEGIN MLASALA: 08-AUG-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN
        // check the out of sync flag
        if((applicationDTO.app.Out_Of_Sync__c != true && 
            !applicationDTO.app.Response_Code__c.contains('ERA')) && 
            !applicationDTO.app.Doc_Gen_Check__c){      //Disregard validation if doc gen check is false                             
        //END MLASALA: 08-AUG-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN
        
            validationErrors.add(new IS_ValidationError('','Application is updated.'));
        }
        //BEGIN Suneel: 20-AUG-2018 - validation  appears when the  Count of both Disbursement and Disbursement plans records are more than 10
            if(applicationDTO.disbursementList.size()>0){
        Id appId = ApexPages.currentPage().getParameters().get('id');
        List<AggregateResult> disbMaster = [select Count(Application__r.Disbursement_Count__c) disb from Disbursement__c where Application__c = :appId];
        List<AggregateResult> payDown = [select SUM(No_of_Disbursement_Plans__c) pdown from Disbursement__c where Application__c = :appId and RecordType.Name = 'LFS Card Pay down with Interest Free'];
        List<AggregateResult> limitReduction = [select SUM(No_of_Disbursement_Plans__c) lReduction from Disbursement__c where Application__c = :appId and RecordType.Name = 'LFS Card Limit Reduction with Interest Free'];
        List<AggregateResult> cardClosure = [select SUM(No_of_Disbursement_Plans__c) cClosure from Disbursement__c where Application__c = :appId and RecordType.Name = 'LFS Card Closure Interest Free'];
        Object disbCount = disbMaster[0].get('disb');
        Object payDownCount = payDown[0].get('pdown');
        Object limitReductionCount = limitReduction[0].get('lReduction');
        Object cardClosureCount = cardClosure[0].get('cClosure');  
                   
        // countOne = (integer)groupedResults.get('plan');
        //countTwo = (integer)groupedResults.get('aver');      
        countdisbCount = (Integer)disbCount;
        countpayDownCount  = (Decimal)payDownCount; 
        countlimitReductionCount = (Decimal)limitReductionCount;
        countcardClosureCount = (Decimal)cardClosureCount;        
        if(countpayDownCount >= 1){
          countpayDownCount = 1 ;
        }else{
          countpayDownCount = 0;
        }
        if(countlimitReductionCount >= 1){
        countlimitReductionCount =1 ;
        }else {
        countlimitReductionCount =0 ;
        }
        if(countcardClosureCount >= 1){
        countcardClosureCount =1 ;
        }else{
        countcardClosureCount = 0;
        }
        TotalCount = countdisbCount  + countpayDownCount + countlimitReductionCount +  countcardClosureCount;
        System.debug('countdisbCount' +countdisbCount);
        System.debug('countpayDownCount' +countpayDownCount);
        System.debug('countlimitReductionCount'+countlimitReductionCount);
        System.debug('countcardClosureCount'+countcardClosureCount);
        System.debug(' Total count' + TotalCount);
        /*if(applicationDTO.disbursementList.size()>10){
            IS_ValidationError ive = new IS_ValidationError('', 'The maximum number of disbursements per application is 10');
            validationErrors.add(ive);
        }*/        
            if(TotalCount > 10){       
            validationErrors.add(new IS_ValidationError('', 'You have exceeded the maximum number of allowed disbursements (10)'));
            }
        }
        //END
      //Validation for checking Method of Verification is null - Verifier Fast Follower         
/*        List<Income_Capacity__c> incList = [select Method_of_Verification__c  from Income_Capacity__c where income__r.applicant__r.application__r.Id = :applicationDTO.app.Id];    
            for(Income_Capacity__c inc : incList){
               if(inc.Method_of_Verification__c == null && applicationDTO.applicant.Total_POI_Amount_Verified__c > 0){
                    IS_ValidationError ivmov = new IS_ValidationError('Method of Verification', 'Income Capacity record is partially filled. Please complete before update application.');
                    validationErrors.add(ivmov);
                    System.debug('****** Method of Verification ******');
                }
            } 
*/     
    //END  
          
         
    //Validation for Product SubType - Better Start
    Better_Start_Offer__c bsOffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
    if(applicationDTO.app.Brand_Country__c == 'AU'){
     if(applicationDTO.app.Product_SubType__c == null && bsOffer.BetterStartAUActive__c == true){
      validationErrors.add(new IS_ValidationError('Validate Product SubType', 'Product SubType is Missing'));
    }
    }else if(applicationDTO.app.Brand_Country__c == 'NZ'){
    if(applicationDTO.app.Product_SubType__c == null && bsOffer.BetterStartNZActive__c == true){
      validationErrors.add(new IS_ValidationError('Validate Product SubType', 'Product SubType is Missing'));
    }
    }       
        if(applicationDTO.app.Total_Loan_Amount__c < 20000 && applicationDTO.app.Product_SubType__c == 'Better Start PL'){
     validationErrors.add(new IS_ValidationError('Validate Loan Amount', 'Minimum required loan amount for Better Start is $20,000'));
    } 
        return validationErrors; 
    }
    
    
    /**
        Author: Fel Saliba (Cloud Sherpas)
        Created Date: Jan 10, 2014
        Description: Methods that checks for related records (Asset, Income, Expense and Debt, Loan Purpose) 
    **/
    
    public List<IS_ValidationError> checkIfEmpty(List<SObject> objList, String errorMessage) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        
        if(objList != null){
            if(objList.isEmpty()){
               IS_ValidationError ive = new IS_ValidationError('Validate Applicantion', errorMessage);
               validationErrors.add(ive);           
            }
        }
        return validationErrors;
    }
}