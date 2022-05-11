public with sharing class QuoteTriggerHandler extends BaseTriggerHandler{
    
    public override void beforeInsert(List<SObject> newObjects){
        //Update the Driver's License Flag based on the value: START
        List<Quote__c> quotesList =  (List<Quote__c>)newObjects;
        setQuoteDetailsBeforeInsert(quotesList);
        //Update the Driver's License Flag based on the value: END
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
        qdv.runCustomValidations((List<Quote__c>)newObjects);
    }

    public override void beforeUpdate(List<SObject> newObjects, Map<Id, SObject> newObjectsMap, Map<Id, SObject> oldObjectsMap){
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
        Map<Id,Quote__c> newQuoteMap =  (Map<Id,Quote__c>)newObjectsMap;
        Map<Id,Quote__c> oldQuoteMap =  (Map<Id,Quote__c>)oldObjectsMap;
        //Update the Driver's License Flag based on the value: START
        List<Quote__c> quotesList =  (List<Quote__c>)newQuoteMap.values();
        List<Quote__c> quoteListForProcessing = new List<Quote__c>();
        quoteListForProcessing = checkIfProcessingRequired(newQuoteMap,oldQuoteMap);
        setQuoteDetailsBeforeUpdate(quotesList,quoteListForProcessing);
        //Update the Driver's License Flag based on the value: END
            
        qdv.runCustomValidations(newQuoteMap.values());
        if(!Test.isRunningTest()){   
            qdv.checkCreditScore((List<Quote__c>)newObjects);  
        }
    }

    public override void afterUpdate(List<SObject> newObjects, Map<Id, SObject> newObjectsMap, Map<Id, SObject> oldObjectsMap) {
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
        Map<Id,Quote__c> newQuoteMap =  (Map<Id,Quote__c>)newObjectsMap;
        Map<Id,Quote__c> oldQuoteMap =  (Map<Id,Quote__c>)oldObjectsMap;

        List<Quote__c> quoteListForProcessing = new List<Quote__c>();
        List<Quote__c> quoteListForDpUpdate = new List<Quote__c>();
        List<Quote__c> quoteListForBrokerNotes = new List<Quote__c>();
        
        quoteListForProcessing = checkIfProcessingRequired(newQuoteMap,oldQuoteMap);
        quoteListForDpUpdate = checkIfDPRateUpdateRequired(newQuoteMap, oldQuoteMap);
        quoteListForBrokerNotes = checkIfNotesRequired(newQuoteMap, oldQuoteMap);
        
        if(!Test.isRunningTest()){
            if(quoteListForProcessing.size() > 0){
                qdv.invokeQuoteSubmit(quoteListForProcessing); 
            }
            if(quoteListForDpUpdate.size() > 0){
                qdv.invokeRateUpdate(quoteListForDpUpdate);
            }
            if(quoteListForBrokerNotes.size() > 0){
                createNotesForBrokerDecline(quoteListForBrokerNotes);
            }
        }
    }

    public override void afterInsert(List<SObject> newObjects, Map<Id, SObject> newObjectsMap) {

        //create a Quote Record for Broker Print
        createQuoteRecordForPrint((List<Quote__c>)newObjects);
        
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
        if(!Test.isRunningTest()){
            qdv.createQuoteProductLineItems((List<Quote__c>)newObjects);
            qdv.invokeQuoteSubmit((List<Quote__c>)newObjects); 
        }

    }

    /**
     * Description: Set the fields based on different conditions before a quote is inserted.
     */
    private void setQuoteDetailsBeforeInsert(List<Quote__c> quotesList){
        Id recordTypeId_AU = Schema.SObjectType.Quote__c.getRecordTypeInfosByDeveloperName().get('AU').getRecordTypeId();
        Id recordTypeId_NZ = Schema.SObjectType.Quote__c.getRecordTypeInfosByDeveloperName().get('NZ').getRecordTypeId();

        //Retrieve the previous quote contact stratergy
        String checkPreContactStat ='';
        List<Quote__c> preQuoteList = new List<Quote__c>();

        //COMMENTING FOR STAFF RELEASE: START

        //Assign Contact Strategy to quotes sequentially: Start
        //preQuoteList = [Select Id,name,Gender__c,Income_Source__c,Contact_Strategy__c,Channel__c from Quote__c where Channel__c !='Broker' order by createdDate desc Limit 1];
        
        /*if(preQuoteList.size() >0 && preQuoteList[0].Contact_Strategy__c != null){
              checkPreContactStat = preQuoteList[0].Contact_Strategy__c;              
        }*/
        //Assign Contact Strategy to quotes sequentially: End

        //COMMENTING FOR STAFF RELEASE: END
        
        for(Quote__c quoteObj : quotesList){
            //Set Driver's License Flag
            if(quoteObj.Driver_s_Licence_Number__c != null && quoteObj.Driver_s_Licence_Number__c != ''){
                quoteObj.Drivers_Lic_Flag__c = false;
            }else{
                quoteObj.Drivers_Lic_Flag__c = true;
            }
            //Capitalise the First Name
            if(quoteObj.First_Name__c != null){
                quoteObj.First_Name__c = quoteObj.First_Name__c.capitalize();
            }
             //Insert Street type transformation to match the Activate codes :Start
            if(quoteObj.Residential_Street_Type__c != null && quoteObj.Residential_Street_Type__c!= ''){
                quoteObj.Residential_Street_type_abbreviated_code__c= SoftQuoteUtil.checkStreetType(quoteObj.Residential_Street_Type__c,quoteObj.Region__c);
            }
             if(quoteObj.Previous_Street_Type__c != null && quoteObj.Previous_Street_Type__c != ''){
                quoteObj.Previous_ResStreet_type_abbreviated_code__c= SoftQuoteUtil.checkStreetType(quoteObj.Previous_Street_Type__c,quoteObj.Region__c);
            }
            //Insert Street type transformation to match the Activate codes :End

            //COMMENTING FOR STAFF RELEASE: START

            //Assign Contact Strategy to quotes sequentially: Start
            /*if(quoteObj.Channel__c != 'Broker'){
                  if(checkPreContactStat =='' || checkPreContactStat =='SMS'){
                          quoteObj.Contact_Strategy__c='Email';  
                  }else if(checkPreContactStat =='Email'){
                          quoteObj.Contact_Strategy__c='Phone';    
                  }else if(checkPreContactStat =='Phone'){
                          quoteObj.Contact_Strategy__c='SMS';  
                  }
             //Assign Contact Strategy to quotes sequentially: End 
            
            }*/

            //COMMENTING FOR STAFF RELEASE: END

            //Assign Record Type to an incoming record
            if(quoteObj.Product__c == GEN_OriginationsConstants.LATITUDE_PL_LOAN){
                quoteObj.RecordTypeId = recordTypeId_AU;
            }else if(quoteObj.Product__c == GEN_OriginationsConstants.GEM_PL_LOAN || quoteObj.Product__c == GEN_OriginationsConstants.KIWI_PL_LOAN){
                quoteObj.RecordTypeId = recordTypeId_NZ;
            }
               
        }
    }

    /**
     * Description: Set the fields based on different conditions before a quote is updated.
     */
    private void setQuoteDetailsBeforeUpdate(List<Quote__c> quotesList,List<Quote__c> quoteListForProcessing){

        for(Quote__c quoteObj : quotesList){
            if(quoteObj.Driver_s_Licence_Number__c != null && quoteObj.Driver_s_Licence_Number__c != ''){
                quoteObj.Drivers_Lic_Flag__c = false;
            }else{
                quoteObj.Drivers_Lic_Flag__c = true;
            }
             //Update Street type transformation to match the Activate codes :Start
            if(quoteObj.Residential_Street_Type__c != null && quoteObj.Residential_Street_Type__c!= ''){
                quoteObj.Residential_Street_type_abbreviated_code__c= SoftQuoteUtil.checkStreetType(quoteObj.Residential_Street_Type__c,quoteObj.Region__c);
            }
            if(quoteObj.Previous_Street_Type__c != null && quoteObj.Previous_Street_Type__c != ''){
                quoteObj.Previous_ResStreet_type_abbreviated_code__c= SoftQuoteUtil.checkStreetType(quoteObj.Previous_Street_Type__c,quoteObj.Region__c);
            }
            //Update Street type transformation to match the Activate codes :End
           //Flush the values of Interest rate, Pricing grade/Risk grade/Comparision Rate/Monthly Repayments when the update call is made
           if(quoteListForProcessing.size() > 0){
              if(quoteObj.Credit_Score__c!= null && quoteObj.Credit_Score__c!= '' && 
                 quoteObj.Risk_Grade__c!= null && quoteObj.Risk_Grade__c!= '' && 
                 quoteObj.Quote_Rate__c != null  && quoteObj.Quote_Rate__c != 0.00){ 
                    quoteObj.Credit_Score__c =null;
                    quoteObj.Risk_Grade__c =null;
                    quoteObj.Quote_Rate__c = null; 
                    quoteObj.Comparison_Rate__c = null;
                    quoteObj.Monthly_Repayment__c = null; 
              }
           }
            
        }

    }

    private List<Quote__c> checkIfProcessingRequired(Map<Id,Quote__c> newQuoteMap, Map<Id,Quote__c> oldQuoteMap){
        List<Quote__c> quoteListForProcessing = new List<Quote__c>();
        //If any of the below was changed then do not re-submit the quote downstream & do not re-validate the inputs.
        for(Id quoteId : newQuoteMap.keyset()){
            if(oldQuoteMap.get(quoteId).Service_Call_Required__c != newQuoteMap.get(quoteId).Service_Call_Required__c && 
                newQuoteMap.get(quoteId).Service_Call_Required__c == 'Yes'){
                    quoteListForProcessing.add(newQuoteMap.get(quoteId));
            }
        }

        return quoteListForProcessing;
    }

    /**
     * Name: checkIfDPRateUpdateRequired
     * Description: Check if the rate of interest has been updated in Salesforce, if yes then invoke a DP call.
     */
    private List<Quote__c> checkIfDPRateUpdateRequired(Map<Id,Quote__c> newQuoteMap, Map<Id,Quote__c> oldQuoteMap){
        List<Quote__c> quoteListForDpUpdate = new List<Quote__c>();
        //If any of the below was changed then do not re-submit the quote downstream & do not re-validate the inputs.
        //Remove the Response code check to trigger the Interest rate API whenever the Interest rate changes
        for(Id quoteId : newQuoteMap.keyset()){
            if(oldQuoteMap.get(quoteId).Quote_Rate__c != newQuoteMap.get(quoteId).Quote_Rate__c &&
                newQuoteMap.get(quoteId).Credit_Score__c != null && newQuoteMap.get(quoteId).Risk_Grade__c != null && 
                newQuoteMap.get(quoteId).Quote_Rate__c != null && 
                newQuoteMap.get(quoteId).Response_Code__c != GEN_OriginationsConstants.QUOTE_EXPIRED_RESPONSE_FIC){
                    quoteListForDpUpdate.add(newQuoteMap.get(quoteId));
            }
        }

        return quoteListForDpUpdate;
    }

    /**
     * Description: Add a note on the quote record for Broker Declined Apps. This note states that a decline email will be sent to the 
     *              customer 48 hours from now.
     */
    private List<Quote__c> checkIfNotesRequired(Map<Id,Quote__c> newQuoteMap, Map<Id,Quote__c> oldQuoteMap){
        List<Quote__c> quoteListForBrokerNotes = new List<Quote__c>();
        for(Id quoteId : newQuoteMap.keyset()){
            if(oldQuoteMap.get(quoteId).Response_Code__c != newQuoteMap.get(quoteId).Response_Code__c &&
                newQuoteMap.get(quoteId).Response_Code__c != null && newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_DECLINED_RESPONSE_CODE &&
                oldQuoteMap.get(quoteId).Broker_ID__c != null && newQuoteMap.get(quoteId).Broker_ID__c != null){
                quoteListForBrokerNotes.add(newQuoteMap.get(quoteId));
            }
        }

        return quoteListForBrokerNotes;
    }

    /**
     * For Online & Broker channels, if the quote response is a referred one then those quotes will be assigned to a Queue for the staff to process and clear the referral.
     */
    private List<Quote__c> checkIfQuoteReferred(Map<Id,Quote__c> newQuoteMap, Map<Id,Quote__c> oldQuoteMap){
        List<Quote__c> quoteReferredList = new List<Quote__c>();
        for(Id quoteId : newQuoteMap.keyset()){
            if(oldQuoteMap.get(quoteId).Response_Code__c != newQuoteMap.get(quoteId).Response_Code__c &&
               newQuoteMap.get(quoteId).Response_Code__c != null && (newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_REFERRED_RESPONSE_VAR || 
               newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_REFERRED_RESPONSE_MAR || 
               newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_REFERRED_RESPONSE_POR ||
               newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_REFERRED_RESPONSE_PRR ||
               newQuoteMap.get(quoteId).Response_Code__c == GEN_OriginationsConstants.QUOTE_REFERRED_RESPONSE_SCR) &&
               (newQuoteMap.get(quoteId).Channel__c == GEN_OriginationsConstants.QUOTE_CHANNEL_ONLINE || 
               newQuoteMap.get(quoteId).Channel__c == GEN_OriginationsConstants.QUOTE_CHANNEL_BROKER) ){

                quoteReferredList.add(newQuoteMap.get(quoteId));
            }
        }
        System.debug('quoteReferredList: '+quoteReferredList);
        return quoteReferredList;
    }

    /**
     * Create a Note against the quote for Broker declined apps. This note will be updated when the actual email has been sent out.
     */
    private static void createNotesForBrokerDecline(List<Quote__c> quoteListForBrokerNotes){
        List<Note> notesList = new List<Note>();
        for(Quote__c qObj : quoteListForBrokerNotes){
            Note noteObj = new Note();
            noteObj.IsPrivate = false;
            noteObj.ParentId = qObj.Id;
            noteObj.Title = 'Decline Email';
            noteObj.Body = 'An automated decline email will be sent to the customer 48 hours from now at '+System.now().addDays(2).format();
            notesList.add(noteObj);
        }
        if(notesList.size() > 0){
            insert notesList;
        }
    }

    private void createQuoteRecordForPrint(List<Quote__c> newObjects){
        Set<Id> quoteIdSet = new Set<Id>();
        for(Quote__c quotObj : newObjects){
            if(quotObj.Channel__c == 'Broker' && quotObj.Region__c =='AU'){
                quoteIdSet.add(quotObj.Id);
            }
        }
        //Process the records identified
        if(quoteIdSet.size() > 0){
            createShadowRecordForPrint(quoteIdSet);
        }
    }


    public static void createShadowRecordForPrint(Set<Id> quoteIdSet){
        List<Quote__c> quoteList = [SELECT  Id,
                                            Loan_Purpose__c,
                                            Loan_Amount__c,
                                            Channel__c,
                                            Loan_Term__c,
                                            Region__c,
                                            Consent_For_Soft_Enquiry__c,
                                            Product__c,
                                            Quote_Stage__c,
                                            Quote_Expires_On__c,
                                            Quote_Privacy_Consent__c,
                                            Title__c,
                                            First_Name__c,
                                            Middle_Name__c,
                                            Last_Name__c,
                                            Gender__c,
                                            Date_of_Birth__c,
                                            Email_ID__c,
                                            Mobile_Number__c,
                                            Driver_s_Licence_Number__c,
                                            Residential_Unit_Number__c,
                                            Residential_Street_Number__c,
                                            Residential_Street_Type__c,
                                            Residential_Street_Name__c,
                                            Residential_Suburb__c,
                                            Residential_State__c,
                                            Residential_Postcode__c,
                                            Residential_Country__c,
                                            Years_at_Residential_Address__c,
                                            Months_at_Residential_Address__c,
                                            Previous_Unit_Number__c,
                                            Previous_Street_Number__c,
                                            Previous_Street_Name__c,
                                            Previous_Street_Type__c,
                                            Previous_Suburb__c,
                                            Previous_State__c,
                                            Previous_Postcode__c,
                                            Previous_Country__c,
                                            Income_Source__c,
                                            Occupation__c,
                                            Years_at_Current_Employment__c,
                                            Months_at_Current_Employment__c,
                                            Residential_Status__c,
                                            Broker_ID__c,
                                            Brokerage_Fee__c  
                                     FROM   Quote__c
                                    WHERE   Id IN :quoteIdSet];
        List<Quote_Print_Broker__c> quotePrintForInsertList = new List<Quote_Print_Broker__c>();
        for(Quote__c qObj : quoteList){
            Quote_Print_Broker__c quotePrintObj = new Quote_Print_Broker__c();

            quotePrintObj.Loan_Purpose__c = qObj.Loan_Purpose__c;
            quotePrintObj.Loan_Amount__c = qObj.Loan_Amount__c;
            quotePrintObj.Channel__c = qObj.Channel__c;
            quotePrintObj.Loan_Term__c = qObj.Loan_Term__c;
            quotePrintObj.Region__c = qObj.Region__c;
            quotePrintObj.Consent_For_Soft_Enquiry__c = qObj.Consent_For_Soft_Enquiry__c;
            quotePrintObj.Product__c = qObj.Product__c;
            quotePrintObj.Quote_Stage__c = qObj.Quote_Stage__c;
            quotePrintObj.Quote_Privacy_Consent__c = qObj.Quote_Privacy_Consent__c;
            quotePrintObj.Quote__c = qObj.Id;
            quotePrintObj.Title__c = qObj.Title__c;
            quotePrintObj.First_Name__c = qObj.First_Name__c;
            quotePrintObj.Middle_Name__c = qObj.Middle_Name__c; 
            quotePrintObj.Last_Name__c = qObj.Last_Name__c;
            quotePrintObj.Gender__c = qObj.Gender__c;
            quotePrintObj.Date_of_Birth__c = qObj.Date_of_Birth__c;
            quotePrintObj.Email_ID__c = qObj.Email_ID__c;
            quotePrintObj.Mobile_Number__c = qObj.Mobile_Number__c;
            quotePrintObj.Quote_Expires_On__c = qObj.Quote_Expires_On__c;
            quotePrintObj.Drivers_Licence_Number__c = qObj.Driver_s_Licence_Number__c;
            quotePrintObj.Residential_Unit_Number__c = qObj.Residential_Unit_Number__c;
            quotePrintObj.Residential_Street_Number__c = qObj.Residential_Street_Number__c;
            quotePrintObj.Residential_Street_Name__c = qObj.Residential_Street_Name__c;
            quotePrintObj.Residential_Street_Type__c = qObj.Residential_Street_Type__c;
            quotePrintObj.Residential_Suburb__c = qObj.Residential_Suburb__c;
            quotePrintObj.Residential_State__c = qObj.Residential_State__c;
            quotePrintObj.Residential_Postcode__c = qObj.Residential_Postcode__c;
            quotePrintObj.Residential_Country__c = qObj.Residential_Country__c;
            quotePrintObj.Years_at_Residential_Address__c = qObj.Years_at_Residential_Address__c;
            quotePrintObj.Months_at_Residential_Address__c = qObj.Months_at_Residential_Address__c;
            quotePrintObj.Previous_Unit_Number__c = qObj.Previous_Unit_Number__c;
            quotePrintObj.Previous_Street_Number__c = qObj.Previous_Street_Number__c;
            quotePrintObj.Previous_Street_Name__c = qObj.Previous_Street_Name__c;
            quotePrintObj.Previous_Street_Type__c = qObj.Previous_Street_Type__c;
            quotePrintObj.Previous_Suburb__c = qObj.Previous_Suburb__c;
            quotePrintObj.Previous_State__c = qObj.Previous_State__c;
            quotePrintObj.Previous_Postcode__c = qObj.Previous_Postcode__c;
            quotePrintObj.Previous_Country__c = qObj.Previous_Country__c;
            quotePrintObj.Income_Source__c = qObj.Income_Source__c;
            quotePrintObj.Occupation__c = qObj.Occupation__c;
            quotePrintObj.Years_at_Current_Employment__c = qObj.Years_at_Current_Employment__c;
            quotePrintObj.Months_at_Current_Employment__c = qObj.Months_at_Current_Employment__c;
            quotePrintObj.Residential_Status__c = qObj.Residential_Status__c;
            quotePrintObj.Broker_ID__c = qObj.Broker_ID__c;
            quotePrintObj.Brokerage_Fee__c = qObj.Brokerage_Fee__c;
            
            quotePrintForInsertList.add(quotePrintObj);
        }
        if(quotePrintForInsertList.size() > 0){
            insert quotePrintForInsertList;

        }

    }


}