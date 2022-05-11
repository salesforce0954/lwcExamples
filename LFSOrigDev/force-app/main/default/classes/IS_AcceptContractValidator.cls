/*
Author: Dan Crisologo
Created Date: 02-11-2014
Description: Represents Accept Contract data validation error performed before a web service callout is made
Update: 2015-03-11 Tony Xu DBHZL386 Contract cannot be accepted if refinance disbursement's payoff effective date is not
					within the X (customer settings) days
Update: 2015-06-01 Davey Yu Defect 1979 - Updated validate method to check on pre-settlement checklist for NZ PL
*/
public with sharing class IS_AcceptContractValidator extends IS_AbstractCommonValidator implements IS_IValidator{

    public IS_AcceptContractValidator() {
  
    }

    public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        
        if(applicationDTO.app.Out_Of_Sync__c == true){
          validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application is out of sync.'));
        }
        /*LYVKD-39 Make compliance checklist entry optional - MDAVID - 8/12/2016
         //Updated by DYU 06-02-2014 Defect 1679 - Always validate on pre-settlement checklist for NZ PL
        if(applicationDTO.collateralList.size() > 0 || applicationDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE
            || applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION){
            Integer pfrCounter = 0;
            Integer bmCounter = 0;
            Integer totalPFRCounter = 0;
            Integer totalBMCounter = 0;

            for(Compliance_Check__c c: applicationDTO.complianceCheckList){
                if(c.Pre_Settlement_Indicator__c){
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
                if(bmCounter != totalBMCounter){
                   validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application PFR2 Check Count should be equal to BM Compliance Check Total'));
                }
            } else {
                validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','Application should have Pre Settlement Compliance check records'));
            }     
        }*/

        // check the T&C Version Number if Acceptance Channel is Offline or there Collateral records
        //if(applicationDTO.collateralList != null){
        //    Boolean hasPPSRRegNo = true;

        //    for(Collateral__c collateral:applicationDTO.collateralList){
        //        if(collateral.PPSR_Reference_Number_1__c == null || collateral.PPSR_Reference_Number_1__c == ''){
        //            hasPPSRRegNo = false;
        //        }
        //    }

        //    if(!hasPPSRRegNo){
        //        validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest', 'Please populate Collateral PPSR Reference Number'));
        //    }

        //    if(applicationDTO.app.Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE){
        //        if(applicationDTO.app.TC_Version_Number__c == null || applicationDTO.app.TC_Version_Number__c == ''){
        //          validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','T&C Version Number is required.'));
        //        }
        //    }
        //}

        if(applicationDTO.app.Workflow_In_Progress__c){
            validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest','You cannot create an account when there is an existing workflow in progress.'));
        }
        
        // Removed by: Adrian Recio
        // Description: This validation is redundant and should be removed. This validation is already satisfied upon doc gen.
        // Date: 25/09/2015
        /*
        if(applicationDTO.applicant.POI_Financial_Situation_Verified__c == false && applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 1 is incomplete.'));
        }

        if(applicationDTO.applicant2 != null){
            
            if(applicationDTO.applicant2.POI_Financial_Situation_Verified__c == false && applicationDTO.app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.NZ_REGION){
            validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest', 'POI verification for applicant 2 is incomplete'));
            }
        }
        */
        
        system.debug('!@#$DisbursementList'+applicationDTO.disbursementList);
        
        //DBHZL386
        if(applicationDTO.disbursementList != null){
            
            Integer PAYOFF_VALID_DAYS = Integer.valueOf(Admin_Settings__c.getValues('Payoff Valid Days').value__c);
            
            Date expiryDate = date.today().addDays(0-PAYOFF_VALID_DAYS);
            
            system.debug('!@#$PAYOFF_VALID_DAYS:'+PAYOFF_VALID_DAYS);
            system.debug('!@#$expiryDate:'+expiryDAte);         
            
            for(Disbursement__c d:applicationDTO.disbursementList){
                system.debug('payout effective date:'+d.Payout_Effective_Date__c);
                if(d.Payout_Effective_Date__c < expiryDate && (d.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RTYPE_REFINANCE || d.Record_Type_Name__c == 'Re-Finance')){
                     validationErrors.add(new IS_ValidationError('IS_AcceptContract.acceptContractRequest', 'Payoff Quote is out of date'));                
                }
            }
        }
        
        system.debug(validationErrors);
        
        return validationErrors;
    }
}