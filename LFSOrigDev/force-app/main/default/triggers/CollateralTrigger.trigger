/*
    Author: Fel Saliba Cloud Sherpas
    Created Date: February 12, 2014
    Description: Trigger timings for Collateral object
*/

trigger CollateralTrigger on Collateral__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {    
    
    CollateralTriggerHandler trig = new CollateralTriggerHandler();
    AccessControlTriggerHandler accessControl = new AccessControlTriggerHandler();

    //before
    if(Trigger.isBefore){
        
        //before insert
        if(Trigger.isInsert){
            //code logic here
            trig.validateCollateral(trigger.new, 'insert');
            for(Collateral__c c: Trigger.new){
                //Added as part of DBHZL-193 for localizing labels for NZ region.If AU then no change to Collateral_VIN_No__c
                if(c.Collateral_VIN_NZ_No__c!=null)c.Collateral_VIN_No__c=c.Collateral_VIN_NZ_No__c;
                
                //added this code as  the collateral type is populating with  null values---start------------
                RecordType colRecType=[select id,name from RecordType where id=:c.RecordTypeId limit 1];
                String recType='';
                if(colRecType.Name!=null && colRecType.Name.contains(GEN_OriginationsConstants.NZ_REGION)){
                    recType=colRecType.Name.removeEnd(' '+GEN_OriginationsConstants.NZ_REGION);
                }
                else {
                    recType=colRecType.Name;
                }
                c.Collateral_Type__c=recType;
                //----end--------------------------------------
                
                Boolean flag = true;
                system.debug('=======< ' + c.Response_Code__c);
                flag = accessControl.insertCollateral(c.Response_Code__c);

                if(!flag){
                    c.addError('Application status already Accepted. You are no longer allowed to insert a record.');
                }

            }  
        }
        //before update
        if(Trigger.isUpdate){
            //code logic here
            trig.validateCollateral(trigger.new, 'update');
            for(Collateral__c c: Trigger.new){
                //Added as part of DBHZL-193 for localizing labels for NZ region.
                if(c.Collateral_VIN_NZ_No__c!=null)c.Collateral_VIN_No__c=c.Collateral_VIN_NZ_No__c;
                Boolean flag = true;
                flag = accessControl.updateCollateral(c.Response_Code__c);

                if(!flag){
                    c.addError('Application status already Accepted. You are no longer allowed to update a record.');
                }

            } 
        }
        //before delete
        if(Trigger.isDelete){
            //code logic here
            for(Collateral__c c: Trigger.old){

                Boolean flag = true;
                flag = accessControl.deleteCollateral(c.Response_Code__c);

                if(!flag){
                    c.addError('Application status already Accepted. You are no longer allowed to delete a record.');
                }

            } 
        }
    }

    //after
    if(Trigger.isAfter){
        
        //after insert
        if(Trigger.isInsert){
            //code logic here
            trig.recalculateApplicationFees(trigger.new);
        }
        //after update
        if(Trigger.isUpdate){
            Set<Id> appIds = new Set<Id>();
            List<Collateral__c> collateralInsuranceFlush = new List<Collateral__c>();
            
            for(Collateral__c c: Trigger.new){
                
                Collateral__c oldCollateral = Trigger.oldMap.get(c.ID);
                
                //condition added by mlasala 6/4/14: Checking to exclude changed value of ppsr reference number to avoid flushing 
                //of compliance records and related documents when application is in PCO
                if(oldCollateral.Collateral_Body_Type__c != c.Collateral_Body_Type__c ||
                   oldCollateral.Collateral_Owner__c != c.Collateral_Owner__c ||
                   oldCollateral.Collateral_Date_Valued__c != c.Collateral_Date_Valued__c ||
                   oldCollateral.Collateral_Eng_No__c != c.Collateral_Eng_No__c ||
                   //oldCollateral.Collateral_HIN_Number__c != c.Collateral_HIN_Number__c ||
                   oldCollateral.Collateral_Insurance_company_name__c != c.Collateral_Insurance_company_name__c ||
                   oldCollateral.Collateral_Insurance_expiry_date__c != c.Collateral_Insurance_expiry_date__c ||
                   oldCollateral.Collateral_Insurance_Policy_number__c != c.Collateral_Insurance_Policy_number__c ||
                   oldCollateral.Is_Secured__c != c.Is_Secured__c ||
                   oldCollateral.Collateral_Make__c != c.Collateral_Make__c ||
                   oldCollateral.Collateral_Model__c != c.Collateral_Model__c ||
                   oldCollateral.Collateral_NVIC__c != c.Collateral_NVIC__c ||
                   oldCollateral.Collateral_Reg_No__c != c.Collateral_Reg_No__c ||
                   oldCollateral.Collateral_State_of_Registration__c != c.Collateral_State_of_Registration__c ||
                   //oldCollateral.Collateral_Total_Value__c != c.Collateral_Total_Value__c ||
                   oldCollateral.Collateral_Type__c != c.Collateral_Type__c ||
                   oldCollateral.Collateral_Val__c != c.Collateral_Val__c ||
                   oldCollateral.Collateral_VIN_No__c != c.Collateral_VIN_No__c ||
                   oldCollateral.Collateral_Year__c != c.Collateral_Year__c){
                   appIds.add(c.Application__c);
                   collateralInsuranceFlush.add(c); 
                }        
            }
            
            if(appIds.size()>0){
                DebitTriggerHandler.setAppOutOfSync(appIds);
            }
            if(collateralInsuranceFlush.size()>0){
                trig.recalculateApplicationFees(collateralInsuranceFlush);
            }            
        }
        //after delete
        if(Trigger.isDelete){
            //code logic here
            trig.recalculateApplicationFees(trigger.old);
        }

        if(Trigger.isUndelete){
            AccessControlTriggerHandler act = new AccessControlTriggerHandler();
            act.blockUndelete(Trigger.new);
        }
    }
}