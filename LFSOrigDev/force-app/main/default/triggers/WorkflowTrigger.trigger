/*
 * @Description: Trigger for workflow
 * @Author: Jade Serrano
 * @Date Created: 27-NOV-2013
 * @History:
 * =====================================================================
 * Jade - 27-NOV-13: Created
    30-APR-15: Updated Defect 1055 - Update application as out of sync when new risk referral is inserted
    2015-06-29: WFNZUPDATE - Adjust Workflow process for NZ applications, that does not require BM approval, the rate will be applied
                straight after PFR created the workflow - Tony xu
    18-AUG-15 - PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
 * =====================================================================
 */
trigger WorkflowTrigger on Workflow__c (before insert, before update, after insert, after update) {

    AccessControlTriggerHandler acth = new AccessControlTriggerHandler();
     
    //
    AppTriggerClass.createRiskFlow = false;
    
    //Risk_Referral
    Id riskReferralRecordType;
    String riskReferralRecordTypeName;
    //BM_Approval
    Id bmApprovalRecordType;
    String bmApprovalRecordTypeName;
    //Rate_Reduction
    Id rateReductionRecordType;
    String rateReductionRecordTypeName;
    //Close_Application
    Id closeApplicationRecordType;
    String closeApplicationRecordTypeName;
    //Lending_Limit_Override
    Id lendingLimitOverrideRecordType;
    String lendingLimitOverrideRecordTypeName;
    //Fee_Reduction
    Id feeReductionRecordType;
    String feeReductionRecordTypeName;

    //query record types on workflow object
    for (RecordType rt : [SELECT Id, Name,DeveloperName FROM RecordType WHERE SObjectType = 'Workflow__c' AND DeveloperName IN ('Risk_Referral', 'Manager_Approval', 'Rate_Reduction', 'Close_Application', 'Lending_Limit_Override', 'Fee_Reduction')]){
        //if Risk_Referral set id and name
        if(rt.DeveloperName == 'Risk_Referral'){
            riskReferralRecordType = rt.Id;
            riskReferralRecordTypeName = rt.Name;
        }
        //if BM_Approval set id and name
        if(rt.DeveloperName == 'Manager_Approval'){
            bmApprovalRecordType = rt.Id;
            bmApprovalRecordTypeName = rt.Name;
        }
        //if Rate_Reduction set id and name
        if(rt.DeveloperName == 'Rate_Reduction'){
            rateReductionRecordType = rt.Id;
            rateReductionRecordTypeName = rt.Name;
        }
        //if Close_Application set id and name
        if(rt.DeveloperName == 'Close_Application'){
            closeApplicationRecordType = rt.Id;
            closeApplicationRecordTypeName = rt.Name;
        }
        //if Lending_Limit_Override set id and name
        if(rt.DeveloperName == 'Lending_Limit_Override'){
            lendingLimitOverrideRecordType = rt.Id;
            lendingLimitOverrideRecordTypeName = rt.Name;
        }
        //if Fee_Reduction set id and name
        if(rt.DeveloperName == 'Fee_Reduction'){
            feeReductionRecordType = rt.Id;
            feeReductionRecordTypeName = rt.Name;
        }
    }
    //before
    if(Trigger.isBefore){
        
        //WFNZUPDATE - Construct a map of application to be used for NZ workflow automation
        set<ID> ApplicationIDSet = new set<ID>();
        for(Workflow__c w : Trigger.new){
            if(w.Application__c != null){
                ApplicationIDSet.add(w.Application__c);
            }
        }
        
        Map<ID, Application__c> appMap = new map<ID, Application__c>([select id, brand_Country__c from Application__c where id in: ApplicationIDSet]);      
        //WFNZUPDATE - Query the CMO user from custom settings to assign the risk referral workflow to
        list<User> lstCMOManager = new List<User>();
        lstCMOManager = [Select Id FROM User Where username =:NZ_Specific_Settings__c.getValues('CMO Manager').value__c];  
         
         //before insert
        if(Trigger.isInsert){
            for(Workflow__c w: Trigger.new){
                //check profile access
                if(w.RecordTypeId==riskReferralRecordType || w.RecordTypeId==lendingLimitOverrideRecordType || w.RecordTypeId==rateReductionRecordType || w.RecordTypeId==feeReductionRecordType || w.RecordTypeId==bmApprovalRecordType){
                    Boolean authorized = false;

                    if(w.RecordTypeId==riskReferralRecordType){
                        authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Risk_Referral__c');
                    }
                    if(w.RecordTypeId==lendingLimitOverrideRecordType){
                        authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Lending_Limit_Override__c');
                    }
                    if(w.RecordTypeId==rateReductionRecordType){
                        authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Rate_Reduction__c');
                    }
                    if(w.RecordTypeId==feeReductionRecordType){
                        authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Fee_Reduction__c');
                    }    
                    if(w.RecordTypeId==bmApprovalRecordType){
                        authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Manager_Approval__c');
                    }  
                    if(!authorized){
                        w.addError('You are not authorized to access this item');
                    }

                    Boolean appStatus = false;
                    if(w.RecordTypeId==riskReferralRecordType){
                        appStatus = acth.publisherResponseCodeControl(w.Response_Code__c, 'Risk_Referral__c');
                    }
                    if(w.RecordTypeId==lendingLimitOverrideRecordType){
                        appStatus = acth.publisherResponseCodeControl(w.Response_Code__c, 'Lending_Limit_Override__c');
                    }
                    if(w.RecordTypeId==rateReductionRecordType){
                        appStatus = acth.publisherResponseCodeControl(w.Response_Code__c, 'Rate_Reduction__c');
                    }
                    if(w.RecordTypeId==feeReductionRecordType){
                        appStatus = acth.publisherResponseCodeControl(w.Response_Code__c, 'Fee_Reduction__c');
                    }    
                    if(w.RecordTypeId==bmApprovalRecordType){
                        appStatus = acth.publisherResponseCodeControl(w.Response_Code__c, 'Manager_Approval__c');
                    }  
                    if(!appStatus){
                        w.addError('Item cannot be created at the current Application Status');
                    }
                }
                
                //WFNZUPDATE NZ rate reduction process adjustment, automatically approve the workflow
                system.debug('!@#$country:'+w.application__r.id);
                
                //Rate Reduction automation
                if(appMap.get(w.application__c).brand_Country__c == 'NZ' && w.RecordTypeId==rateReductionRecordType){
                    system.debug('!@#$NZ rate reduction auto done');
                    w.Risk_BM_Decision__c = 'Approved';
                }    
                
                //Fee reduction automation
                if(appMap.get(w.application__c).brand_Country__c == 'NZ' && w.RecordTypeId == feeReductionRecordType){
                    system.debug('!@#$NZ Fee reduction auto done');
                    w.Risk_BM_Decision__c = 'Approved';
                    w.Bypass_BM_Approval__c = true; 
                    w.DM_Decision__c = 'Approved';
                } 
                
                
                //Risk referral automation

                if(appMap.get(w.application__c).brand_country__c == 'NZ' && w.RecordTypeId == riskReferralRecordType && lstCMOManager != null){
                    system.debug('!@#$NZ risk referral auto done');
                    w.Assigned_To_2__c = lstCMOManager[0].Id;
                    w.Bypass_BM_Approval__c = true;       
                    w.Auto_Approval__c = true;    
                    w.Status__c = 'Assigned CMO';              
                }
                
            } 
        }
    }

    //after
    if(Trigger.isAfter){

        if(Trigger.isInsert){
            Set<Id> appIdsToFlush = new Set<Id>();
            Set<Id> appIdsToSync = new Set<Id>();
            DisbursementTriggerHandler disbursementHandler = new DisbursementTriggerHandler();

            for(Workflow__c w: Trigger.new){
                //Updated by DY 04-30-2015 Defect 1055 - Update out of synch when a new risk referral is added
                //Updated by devendra 30/4/2015 defect 1107
				/*if(w.RecordTypeId == rateReductionRecordType){
                    appIdsToFlush.add(w.Application__c);
                }

                if(!appIdsToFlush.isEmpty()){
                    disbursementHandler.flushInsurance(appIdsToFlush);
                }*/

				if(w.RecordTypeId == riskReferralRecordType){
                    appIdsToSync.add(w.Application__c);
                }

                if(!appIdsToSync.isEmpty()){
                    disbursementHandler.updateOutOfSync(appIdsToSync);
                }       
            }
        }

        //after update
        if(Trigger.isUpdate){
            List<Application_Response__c> appResList = new List<Application_Response__c>();
            Set<Id> applicationIds = new Set<Id>();
            Set<Id> pcaValidWFAppIds = new Set<Id>();
            
            Set<Id> appIdsToFlush = new Set<Id>();

            DisbursementTriggerHandler disbursementHandler = new DisbursementTriggerHandler();
            
            for(Workflow__c w: Trigger.new){

                //DEBUGS!!!! GRRRR
                System.debug('SYSDBG-riskReferralRecordType:' + riskReferralRecordType);
                System.debug('SYSDBG-rateReductionRecordType:' + rateReductionRecordType);
                System.debug('SYSDBG-feeReductionRecordType:' + feeReductionRecordType);
                System.debug('SYSDBG-lendingLimitOverrideRecordType:' + lendingLimitOverrideRecordType);
                System.debug('SYSDBG-w.RecordTypeId:' + w.RecordTypeId);
                System.debug('SYSDBG-w.Risk_CPU_Decision__c:' + w.Risk_CPU_Decision__c);
                System.debug('SYSDBG-w.Risk_BM_Decision__c:' + w.Risk_BM_Decision__c);
                System.debug('SYSDBG-trigger.oldMap.get(w.Id).Risk_CPU_Decision__c:' + trigger.oldMap.get(w.Id).Risk_CPU_Decision__c);
                System.debug('SYSDBG-trigger.oldMap.get(w.Id).Risk_BM_Decision__c:' + trigger.oldMap.get(w.Id).Risk_BM_Decision__c);
                System.debug('SYSDBG-trigger.oldMap.get(w.Id).DM_Decision__c:' + trigger.oldMap.get(w.Id).DM_Decision__c);
                System.debug('SYSDBG-GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA:' + GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA);
                System.debug('SYSDBG-w.Response_Code__c:' + w.Response_Code__c);
                System.debug('SYSDBG-w.Application__c:' + w.Application__c);

                //add all workflow rec types valid for PCA Applications
                if(((w.RecordTypeId == riskReferralRecordType && w.Risk_CPU_Decision__c == 'Approve' && trigger.oldMap.get(w.Id).Risk_CPU_Decision__c != 'Approve') ||
                    (w.RecordTypeId == rateReductionRecordType && w.Risk_BM_Decision__c == 'Approved' && trigger.oldMap.get(w.Id).Risk_BM_Decision__c != 'Approved') ||
                    (w.RecordTypeId == feeReductionRecordType && w.DM_Decision__c == 'Approved' && trigger.oldMap.get(w.Id).DM_Decision__c != 'Approved') ||
                    (w.RecordTypeId == lendingLimitOverrideRecordType && w.Risk_BM_Decision__c == 'Approved' && trigger.oldMap.get(w.Id).Risk_BM_Decision__c != 'Approved') ) &&
                   w.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA &&
                   w.Application__c != null){
                    
                    pcaValidWFAppIds.add(w.Application__c);
                    System.debug('SYSDBG-application added:' + w.Application__c);

                    //Updated by devendra 04-30-2015 Defect 1107
                    if(w.RecordTypeId == rateReductionRecordType){
                        appIdsToFlush.add(w.Application__c);
                    }

                }
                
                /**
                DEBUG TXU           
                **/
                
                system.debug('=====DEBUG========');
                system.debug('RecordTypeId:'+w.RecordTypeId);
                system.debug('riskReferralREcordType:'+riskReferralRecordType);         
                
                //check if workflow__c record type is Risk Referral
                if(w.RecordTypeId == riskReferralRecordType){
                    //check if workflow__c status is 'Approved'
                    Workflow__c oldWF = Trigger.oldMap.get(w.ID);
                    //if(w.Risk_CPU_Decision__c == 'Approve' && w.Status__c == 'CPU - Approve' &&
                    //   w.Locked_L1__c == true && w.Locked_L2__c == true){
                    
                    //DEBUG TXU
                    system.debug('oldWF.RiskCPUDecision:'+oldWF.Risk_CPU_Decision__c);
                    system.debug('w.Risk_CPU_Decision__c:'+w.Risk_CPU_Decision__c);
                    system.debug('w.Risk_CPU_Decision__c:'+w.Risk_CPU_Decision__c);
                    system.debug('oldWF.Status__c:'+oldWF.Status__c);
                    system.debug('w.Status__c:'+w.Status__c);
                    system.debug('w.Locked_L1__c:'+w.Locked_L1__c);
                    system.debug('oldWF.Locked_L2__c'+oldWF.Locked_L2__c);
                    system.debug('w.Locked_L2__c'+w.Locked_L2__c);                    
                    
                    if(oldWF.Risk_CPU_Decision__c != w.Risk_CPU_Decision__c && w.Risk_CPU_Decision__c == 'Approve' && 
                       oldWF.Status__c != w.Status__c && w.Status__c == 'CPU - Approve' &&
                       w.Locked_L1__c == true && oldWF.Locked_L2__c != w.Locked_L2__c && w.Locked_L2__c == true){

                        Application_Response__c ar = new Application_Response__c();
                        ar.Max_Capacity_Unsecured__c = w.Risk_Max_UnSecured_Amount__c;
                        ar.Max_Capacity_Secured__c = w.Risk_Max_Secured_Amount__c;
                        ar.Max_Term__c = w.Max_Term__c;
                        ar.Type__c = riskReferralRecordTypeName;
                        ar.Min_Collateral_Amount__c = w.Risk_Collateral__c;
                        ar.Application__c = w.Application__c;
                        appResList.add(ar);
                    }
                }
                
                //Rate Reduction
                if(w.RecordTypeId==rateReductionRecordType){
                    
                    //BEGIN MLASALA: 18-AUG-15 - PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES
                    //Workflow approved and Reason is Cancel Rate Reduction
                    if(w.Risk_BM_Decision__c == GEN_OriginationsConstants.WF_APPROVED){

                        if(w.Adjusted_Interest_Rate_Reason__c == GEN_OriginationsConstants.WF_CANCEL_RATE_REDUCTION){
                            applicationIds.add(w.Application__c);
                        } else {
                            appIdsToFlush.add(w.Application__c);
                        }
                    }
                    //END MLASALA: 18-AUG-15 - PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES
                }
            }
            /* Fel Saliba 15/07/2015 Code Scan fix
            need to put the method call outside the loop */         
            if(!appIdsToFlush.isEmpty()){
                disbursementHandler.flushInsurance(appIdsToFlush);
            }

            if(!pcaValidWFAppIds.isEmpty()) {
                List<Application__c> appToUpdate = [SELECT Out_Of_Sync__c, 
                                                           PCA_Flush__c 
                                                    FROM   Application__c
                                                    WHERE  Id IN: pcaValidWFAppIds
                                                    AND	   Generated_Doc_Confirm_Sent__c = true];	//MLASALA 19-APR-2016 FLUSH ONLY ON POST DOC GEN

                for(Application__c a: appToUpdate) {
                    a.Out_Of_Sync__c = true;
                    //a.PCA_Flush__c = true;
                }
                
                if(!appToUpdate.isEmpty()) {
                    System.debug('SYSDBG-appToUpdate flushed:' + appToUpdate);
                    update appToUpdate;
                    GEN_PCAUtility.flushComplianceChecklistandLoanDocuments(appToUpdate);
                }

            }

            //insert application response record
            insert appResList;

            if(!applicationIds.isEmpty()){
                System.debug('$$$ applicationIds: '+applicationIds);
                acth.cancelRateReduction(applicationIds);   //Invoke method to revert rates
            }
        }
    }

}