/*
Author: Dan Crisologo
Created Date: Dec 19, 2013
Description: Represents verify AML data validation error performed before a web service callout is made
*/
public with sharing class IS_VerifyPOIValidator extends IS_AbstractCommonValidator implements IS_IValidator{

  public IS_VerifyPOIValidator() {
  
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

    //perform validations here
    
    //Added by Fel Saliba 1/7/2014
    //check for applicant Total POI Verified Amount
    if(applicationDTO.applicant.Total_POI_Amount_Verified__c == null || applicationDTO.applicant.Total_POI_Amount_Verified__c <= 0){
        IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Income should have POI Verified Amount');
        validationErrors.add(ive);
        //break;
    }
   
    //check for applicant Income Document
   /* if(applicationDTO.applicant.Has_Uploaded__c == false){
        IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Applicant should upload Income Document');
        validationErrors.add(ive);
    } */

    /*if(applicationDTO.applicant2 != null){
        if(applicationDTO.applicant2.Total_POI_Amount_Verified__c == null || applicationDTO.applicant2.Total_POI_Amount_Verified__c <= 0){
            IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Income should have POI Verified Amount for Applicant 2');
            validationErrors.add(ive);
        }
        if(applicationDTO.applicant2.Has_Uploaded__c == false){
            IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Applicant 2 should upload Income Document');
            validationErrors.add(ive);
        }
    }*/

    //Check if applicant/s' POI is already verified
     if(applicationDTO.app.Application_Type__c == 'Single'){
        if(applicationDTO.applicant.POI_Financial_Situation_Verified__c == true){
            IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Applicant 1 POI already verified');
            validationErrors.add(ive);
        }
    }

   if(applicationDTO.app.Application_Type__c == 'Joint'){
        if(applicationDTO.applicant2 != null){
            if(applicationDTO.applicant.POI_Financial_Situation_Verified__c == true && applicationDTO.applicant2.POI_Financial_Situation_Verified__c == true){
                IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Applicant 1 and Applicant 2 POI already verified');
                validationErrors.add(ive);
            }
        }
    }

    // check the out of sync flag
    if(applicationDTO.app.Out_Of_Sync__c == true){
        validationErrors.add(new IS_ValidationError('','Application details may have changed. Please update application.'));
    }
    
    // check the out of sync flag
    /**Comment out by Tony Xu DEFECT425
    if(applicationDTO.app.Generated_Doc_Confirm_Sent__c != true && applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION){
        validationErrors.add(new IS_ValidationError('','POI can only be verified after contract has been generated'));
    }**/
    //Added the below lines 66 to 73 by Suneel D Stage 2 POI Automation
    // Validate when the alerts are not verified 
   /*String id = ApexPages.currentPage().getParameters().get('id');
    List<Verify_POI_Check__c> vpc = [select id from Verify_POI_Check__c where Application__c= :id];
    String alertA1 = applicationDTO.app.EVerifier_Alert_Applicant_1__c;
    String alertA2 = applicationDTO.app.EVerifier_Alert_Applicant_2__c;
    
    if((alertA1 != null || alertA2 != null) && vpc.size() == 0){
     IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Alerts are not verified');
        validationErrors.add(ive);
    }
     Boolean result = b.contains('Alert');
        if(result == true &&  vpc.size() == 0){
        IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Alerts are not verified');
        validationErrors.add(ive);
        } 
        List<Income_Capacity__c> results = [Select Method_of_Verification__c  from Income_Capacity__c where income__r.applicant__r.application__r.UID__c='3009221015372' and Method_of_Verification__c ='Verifier'];
        if(results.size() > 1){
        IS_ValidationError ive = new IS_ValidationError('Validate Applicant', 'Verifier cannot be more than one');
        validationErrors.add(ive);
        } */
    return validationErrors; 
  }
}