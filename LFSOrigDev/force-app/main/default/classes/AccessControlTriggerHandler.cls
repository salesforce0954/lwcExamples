/*
 * @Description: Access control trigger handler
 * @Author: Jade Serrano
 * @Date Created: 02-FEB-2014
 * @History:
 * =====================================================================
 *     Jade - 10-FEB-2014: Created
       08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
 * =====================================================================
 */
public with sharing class AccessControlTriggerHandler {
    
    public AccessControlTriggerHandler() {
        
    }

    /*
     *  Description: Response Code Control for publisher
     *  Author: Jade Serrano
     *  Date Created: 02-FEB-2014
     *  Input: 
     *  Return: Boolean
     */
    public Boolean publisherResponseCodeControl(String responseCode, String fieldName){
        Boolean ret = false;

        system.debug('!@#responseCode: '+responseCode+' fieldName: '+fieldName);

        if(responseCode!=null && fieldName!=null){
            if(fieldName=='Personal_Reference_Check__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Personal_Reference_Check__c;
                system.debug('!@#Personal_Reference_Check__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Credit_Ref_Check__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Credit_Ref_Check__c;
                system.debug('!@#Credit_Ref_Check__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Credit_File_Check__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Credit_File_Check__c;
                system.debug('!@#Credit_File_Check__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Risk_Referral__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Risk_Referral__c;
                system.debug('!@#Risk_Referral__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Lending_Limit_Override__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Lending_Limit_Override__c;
                system.debug('!@#Lending_Limit_Override__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Rate_Reduction__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Rate_Reduction__c;
                system.debug('!@#Rate_Reduction__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Fee_Reduction__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Fee_Reduction__c;
                system.debug('!@#Fee_Reduction__c1');
                system.debug('!@#ret1: '+ret);
            }else if(fieldName=='Manager_Approval__c'){
                ret = Response_Code_Control__c.getInstance(responseCode).Manager_Approval__c;
                system.debug('!@#Manager_Approval__c1');
                system.debug('!@#ret1: '+ret);
            }
        }

        return ret;
    }

    /*
     *  Description: Profile Control for publisher
     *  Author: Jade Serrano
     *  Date Created: 02-FEB-2014
     *  Input: Id
     *  Return: Boolean
     */
    public Boolean publisherProfileControl(String profileId, String fieldName){
        Boolean ret = false;
        system.debug('!@#profileId: '+profileId);
        if(profileId!=null && fieldName!=null){
            if(fieldName=='Personal_Reference_Check__c'){
                ret = Profile_Control__c.getInstance(profileId).Personal_Reference_Check__c;
                system.debug('!@#Personal_Reference_Check__c2');
                system.debug('!@#ret2: '+Profile_Control__c.getInstance(profileId).Personal_Reference_Check__c);
            }else if(fieldName=='Credit_Ref_Check__c'){
                ret = Profile_Control__c.getInstance(profileId).Credit_Ref_Check__c;
                system.debug('!@#Credit_Ref_Check__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Credit_File_Check__c'){
                ret = Profile_Control__c.getInstance(profileId).Credit_File_Check__c;
                system.debug('!@#Credit_File_Check__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Risk_Referral__c'){
                ret = Profile_Control__c.getInstance(profileId).Risk_Referral__c;
                system.debug('!@#Risk_Referral__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Lending_Limit_Override__c'){
                ret = Profile_Control__c.getInstance(profileId).Lending_Limit_Override__c;
                system.debug('!@#Lending_Limit_Override__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Rate_Reduction__c'){
                ret = Profile_Control__c.getInstance(profileId).Rate_Reduction__c;
                system.debug('!@#Rate_Reduction__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Fee_Reduction__c'){
                ret = Profile_Control__c.getInstance(profileId).Fee_Reduction__c;
                system.debug('!@#Fee_Reduction__c2');
                system.debug('!@#ret2: '+ret);
            }else if(fieldName=='Manager_Approval__c'){
                ret = Profile_Control__c.getInstance(profileId).Manager_Approval__c;
                system.debug('!@#Manager_Approval__c2');
                system.debug('!@#ret2: '+ret);
            }
        }

        return ret;
    }

    /*
     *  Description: Disbursement Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean insertDisbursement(String responseCode){

        Boolean flag = true;

        try{
            System.debug('!@#AccessControlTriggerHandler.insertDisbursement.responseCode: '+responseCode);
            flag = Response_Code_Control__c.getInstance(responseCode).Save_Disbursement_Standard__c;
            System.debug('!@#AccessControlTriggerHandler.insertDisbursement.flag: '+flag);
        }catch(Exception e){
            System.debug('!@#AccessControlTriggerHandler.insertDisbursement.e: '+e.getMessage() + ':' + e.getStackTraceString());
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Disbursement Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean updateDisbursement(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Save_Disbursement_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Disbursement Standard Delete Button
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean deleteDisbursement(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Delete_Disbursement_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Collateral Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean insertCollateral(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Save_Collateral_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Collateral Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean updateCollateral(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Edit_Collateral_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Collateral Standard Delete Button
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean deleteCollateral(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Delete_Collateral_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Debit Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean insertDebit(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Save_Debit_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Debit Standard Save Button Control
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean updateDebit(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Edit_Debit_Standard__c;
        }catch(Exception e){
            flag = false;
        }

        return flag;

    }

    /*
     *  Description: Debit Standard Delete Button
     *  Author: Jade Serrano
     *  Date Created: 28-APR-2014
     *  Input: String
     *  Return: Boolean
     */
    public Boolean deleteDebit(String responseCode){

        Boolean flag = true;

        try{
            flag = Response_Code_Control__c.getInstance(responseCode).Delete_Debit_Standard__c;
        }catch(Exception e){
            flag = false;
        }
        
        return flag;

    }

    /*
     *  Description: Undelete validation
     *  Author: Jade Serrano
     *  Date Created: 16-JUN-2014
     *  Input: String
     *  Return: Boolean
     */
    public void blockUndelete(List<SObject> sObj){

        System.debug('!@#blockUndelete');

        Boolean flag = false;

        try{
            flag = Profile_Control__c.getInstance(UserInfo.getProfileId()).Undelete__c;
        }catch(Exception e){
            flag = false;
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
        }

        System.debug('!@#flag: '+flag);        
        
        if(!flag){

            for(SObject s: sObj){
                s.addError('Undelete not allowed');
            }

        }

    }

    /*
     *  Description: Personal Reference Check count validator
     *  Author: Mike Lasala
     *  Date Created: 02-MAY-2014
     *  Input: List<Personal_Reference_Check__c>
     *  Return: null
     */
    public void validatePersonalRefCheckCount(List<Personal_Reference_Check__c> personalRefList){
        Set<Id> applicationIds = new Set<Id>();

        for(Personal_Reference_Check__c p: personalRefList){
            applicationIds.add(p.Application__c);
        }

        if(!applicationIds.isEmpty()){
            List<Personal_Reference_Check__c> existingPersonalRefList = [SELECT Id 
                                                                         FROM   Personal_Reference_Check__c 
                                                                         WHERE  Application__c IN: applicationIds];

            if(existingPersonalRefList.size() > 2){
                for(Personal_Reference_Check__c p: personalRefList){
                    p.addError('Application should only have a maximum of 3 Personal References');
                }
            }
        }
    }

    /*
     *  Description: Method to recalculate rates when Cancel Rate Reduction is approved
     *  Author: Mike Lasala
     *  Date Created: 06-MAY-2014
     *  Input: List<Application__c>
     *  Return: null
     */
    public void cancelRateReduction(Set<Id> applicationIds){
        AppTriggerClass handler = new AppTriggerClass();
        List<Application__c> applicationList = new List<Application__c>();
        
        //Query all Application fields
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Application__c.FieldSets.Application_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }

        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Application__c WHERE Id IN: applicationIds';
        
        applicationList = Database.query(query);
        
        if(!applicationList.isEmpty()){
            //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

            Debug_Log__c debugLog;

            for(Application__c a: applicationList){

                //Check if application has insurance
                if(a.Total_Insurance_Premium__c != null && 
                   a.Total_Insurance_Premium__c != 0){
                    
                    //Populate insurance info message
                    a.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(a.Id, 
                                                                                   a.Insurance_Error_Message__c, 
                                                                                   GEN_OriginationsConstants.RATE_CHANGE_INSURANCE_INFO_MESSAGE);
                    //Create debug log record
                    debugLog = Util.createInsuranceActivity(a.Id, 
                                                            'Flush', 
                                                            GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                            'System', 
                                                            a.Total_Insurance_Premium__c, 
                                                            0);
                }
            }

            if(debugLog != null){
            //Insert record
                try{
                    insert debugLog;
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', debugLog.Application__c);
                }
            }

            handler.calculateOfferedRate(applicationList, true, true);  //Recalculate rates

            update applicationList;
            //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        }

        List<Id> applicationIdList = new List<Id>();
        applicationIdList.addAll(applicationIds);
        
        if(!applicationIdList.isEmpty()){
            //Run Pricing Rule engine
            RUL_Engine.runPricingEngineAsync(applicationIdList);
        }
    }
}