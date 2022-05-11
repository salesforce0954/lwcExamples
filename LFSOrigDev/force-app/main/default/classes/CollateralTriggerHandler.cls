/*
    Author: Fel Saliba Cloud Sherpas
    Created Date: February 12, 2014
    Description: Class to handle CollateralTrigger Logic
    * @History:
       =====================================================================
           09-20-14: Created - Fel
           08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
           18-AUG-15: MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES - MLASALA
       =====================================================================
*/

public class CollateralTriggerHandler{ 

    /**  Description: Method that recalculates Application Fields
     *  Author: Fel Saliba
     *  Date Created: 02-12-14
     *  Input Parameters: Trigger.new - Collateral Entries
     *  Return: void
     */
    
    public void recalculateApplicationFees(List<Collateral__c> collateralList){
system.debug('========<> ' + collateralList.size());
        Set<String> applicationId = new Set<String>();

        List<Application__c> applicationListToUpdate = new List<Application__c>();
        List<Application__c> applicationList = new List<Application__c>();

        for(Collateral__c c: collateralList){    
            applicationId.add(c.Application__c);
        }
        
        //Used fieldsets - Fel 
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Application__c.FieldSets.Application_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Application__c where Id IN: applicationId';
        System.debug('Query ' + query);
        applicationList =  Database.query(query);
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItemsBySet(applicationId);

        Map<Id,List<Product_Item__c>> appProdItemMap = new Map<Id,List<Product_Item__c>>();
        for(Product_Item__c pi: offerCalculator.prodItems){
            if(appProdItemMap.containsKey(pi.Application__c)){
                appProdItemMap.get(pi.Application__c).add(pi);
            }else{
                appProdItemMap.put(pi.Application__c, new List<Product_Item__c> {pi});
            }
        }
        
        if(!applicationList.isEmpty()){
            
            //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            Debug_Log__c debugLog;
            
            for(Application__c app: applicationList){

                //BEGIN MLASALA: 18-AUG-15 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES
                //Check if application has insurance prior to flushing
                if(app.Total_Insurance_Premium__c != null && 
                   app.Total_Insurance_Premium__c != 0){
                    
                    String infoMessage = '';

                    //Identify which region because NZ does not have PPSR fee
                    if(app.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){
                    
                        infoMessage = GEN_OriginationsConstants.PPSR_FEE_INSURANCE_INFO_MESSAGE;
                    } else {
                    
                        infoMessage = GEN_OriginationsConstants.MULTIPLE_SCENARIO_INSURANCE_INFO_MESSAGE;
                    }
                
                    //Populate insurance info message on application
                    app.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(app.Id, 
                                                                                     app.Insurance_Error_Message__c, 
                                                                                     infoMessage);
                    //END MLASALA: 18-AUG-15 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES

                    //Create debug log record
                    debugLog = Util.createInsuranceActivity(app.Id, 
                                                            'Flush', 
                                                            GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                            'System', 
                                                            app.Total_Insurance_Premium__c, 
                                                            0);
                }
            }

            //Insert record
            if(debugLog != null){
            //Insert record
                try{
                    insert debugLog;
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', debugLog.Application__c);
                }
            }
            //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

            //Changes on PPSR and Registration Fee, flush insurance products first
            Gen_OfferUtility.flushOffers(applicationList);
        system.debug('===applicationList=====<> ' + applicationList.size());
            for(Application__c app: applicationList){
                system.debug('------> IN here');
                //app = GEN_OfferUtility.populateOfferFields(app);
                offerCalculator = new OFF_OfferFieldsCalculator();
                offerCalculator.prodItems = appProdItemMap.get(app.Id);
                app.Offered_PPSR_Search_Fee__c  = offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_PPSR_SEARCH);
                app.Offered_PPSR_Registration_Fee__c  = offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_PPSR_REGISTRATION);
                
                //since we have already flush the insurance products, set total insurance premium to zero.
                app.Total_Insurance_Premium__c = 0;
                app.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(app);
                app.Offered_Repayments__c  = offerCalculator.getRepaymentEMI(app);
                app.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(app);
                app.Out_Of_Sync__c = true;
                
                Application__c application = GEN_OfferUtility.getIndividualInsuranceAndPayable(app); 
                //add the application in a list for update
                applicationListToUpdate.add(application);
                
            }       
        }
        
        //check the list size prior update
        if(applicationListToUpdate.size() > 0){
            System.debug('applicationListToUpdate-->'+applicationListToUpdate);
            try{
                update applicationListToUpdate;
                //GEN_OfferUtility.calculateProductItems(applicationListToUpdate);
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'CollateralTriggerHandler', 'Application__c', 'Class');
            }
        }
    }

    /*  Description: This method will validate collateral records after insert and update
     *  Author: Jade Serrano
     *  Date Created: 17-FEB-2014
     *  Input Parameters: Trigger.new
     *  Return: void
     */
    public void validateCollateral(List<Collateral__c> collateralList, String event){

        Map<Id,Integer> productIdCollateralCountMap = new Map<Id,Integer>();
        Set<Id> applicationId = new Set<Id>();

        if(collateralList.size()>0){
            for(Collateral__c c: collateralList){
                applicationId.add(c.Application__c);
            }

            for(Application__c a: [SELECT Product_Id__c, Collateral_Count__c FROM Application__c WHERE Id IN: applicationId]){
                if(!productIdCollateralCountMap.containsKey(a.Product_Id__c)){
                    productIdCollateralCountMap.put(a.Product_Id__c,Integer.valueOf(a.Collateral_Count__c));
                }
            }

            for(Collateral__c c: collateralList){
                try{
                	system.debug('-------------< ' + c.Brand__c);
                    Decimal collateralMinimumValue = Collateral_Settings__c.getInstance(c.Brand__c).Collateral_Minimum_Value__c;
                    Decimal collateralMaximumValue = Collateral_Settings__c.getInstance(c.Brand__c).Collateral_Maximum_Value__c;                        
                    Decimal collateralNewAge = Collateral_Settings__c.getInstance(c.Brand__c).Collateral_New_Age__c;
                    Decimal collateralMaximumItems = Collateral_Settings__c.getInstance(c.Brand__c).Collateral_Maximum_Items__c;
                    
                    if(c.Collateral_Val__c!=null){
                        if(c.Collateral_Val__c < collateralMinimumValue){
                            c.Collateral_Val__c.addError('Collateral value must be greater than or equal to collateral setting minimum value');
                        }
                    }
                    if(c.Collateral_Val__c!=null){
                        if(c.Collateral_Val__c > collateralMaximumValue){
                            c.Collateral_Val__c.addError('Collateral value must be less than or equal to collateral setting maximum value');
                        }
                    }

                    if(c.Collateral_Year__c!=null){
                        Integer collateralAge = Date.today().year() - Integer.valueOf(c.Collateral_Year__c);
                        if(0 > collateralAge){
                            c.Collateral_Year__c.addError('Collateral year must be less than or equal to current year');
                        }

                        if(collateralAge > Integer.valueOf(collateralNewAge)){
                            c.Collateral_Year__c.addError('Collateral year must be less than or equal to collateral setting new age');
                        }
                    }

                    if(productIdCollateralCountMap.containsKey(c.Product_Id__c) && event == 'insert'){
                        Integer collateralCount = productIdCollateralCountMap.get(c.Product_Id__c);
                        system.debug('!@#collateralCount:'+collateralCount+' '+'collateralMaximumItems: '+collateralMaximumItems);
                        if(collateralCount == collateralMaximumItems){
                            c.addError('You have exceeded the collateral maximum items');
                        }
                    }
                }catch(Exception e){
                    //exception log
                    system.debug('EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                    ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'validateCollateral()', 'CollateralTriggerHandler', 'Class', String.valueOf(c.Application__c));
                    c.addError('An error has occured. Please contact your administrator.');
                }
            }                
        }
    }
}