/**  SoftQuote SMS reminder batch class for Latitude
 * @Author: William Putra
 * @Date Created: Oct-07-2021 
 * @History:
   ========================================================================
   William Putra:Oct-21-2021  Change frequency to 2, 4, and 13 days
   ========================================================================
 */ 

global class QuoteBatchSMSReminder implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    global string soqlquery;

    global QuoteBatchSMSReminder() {

    }

    global database.QueryLocator start(Database.BatchableContext bc) {
        String quoteStatus ='Quote Offered';
        String quoteSalesChannel ='Sales';
        String quoteOnlineChannel ='Online'; 
        String region = 'AU';

        soqlquery='Select Id,Name,Email_ID__c,Product__c,Quote_Rate__c,Quote_Secured_Rate__c,'+
        'Quote_Offered_On__c,Quote_Stage__c,Channel__c,Region__c,Loan_Term__c,Loan_Purpose__c,Loan_Amount__c,'+
        'First_Name__c,Quote_Valid_For__c,Quote_Expires_On__c,Comparison_Rate__c,Monthly_Repayment_For_Email__c,'+
        'Sub_Type__c, Mobile_Number__c '+ 
        'from Quote__c '+ 
        'where Quote_Rate__c <> null and Quote_Secured_Rate__c <> null and '+
        'Quote_Stage__c=: quoteStatus and (Channel__c =: quoteSalesChannel or Channel__c =: quoteOnlineChannel) '+
        'and Quote_Offered_On__c <>null and  Quote_Offered_On__c = LAST_N_DAYS:20 AND Region__c = :region '+ 
        'ORDER BY Quote_Offered_On__c desc';
        
        return database.getquerylocator(soqlquery);
    }

    global void execute(Database.BatchableContext bc, List<Quote__c> quotes) {
        //get all SMS reminder templates from brand content object
        List<Brand_Content__c> brandContents = [SELECT Name, Output_HTML__c
                                            FROM Brand_Content__c
                                            WHERE Name IN ('Quote Reminder SMS AU Day 2', 'Quote Reminder SMS AU Day 4', 'Quote Reminder SMS AU Day 13')];

        //put brand contents to map
        Map<String, Brand_Content__c> mapBrandContent = new Map<String, Brand_Content__c>();                                    
        for(Brand_Content__c brandCon: brandContents) {
            switch on brandCon.Name {
                when  'Quote Reminder SMS AU Day 2'{
                    mapBrandContent.put('AUD2', brandCon);
                }
                when  'Quote Reminder SMS AU Day 4'{
                    mapBrandContent.put('AUD4', brandCon);
                }
                when  'Quote Reminder SMS AU Day 13'{
                    mapBrandContent.put('AUD13', brandCon);
                }                                                                          
                when else {
                    
                }
            }
        }

        //Get environment information for testing purpose
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        Boolean isProduction = true;
        if(org.IsSandbox) {
            isProduction = false;
        }       

        //process the quotes
        Map<String, List<Quote__c>> mapQuoteToSendSMS = new Map<String, List<Quote__c>>();
        for(Quote__c quote: quotes) {
            System.debug('QON: '+quote.Quote_Offered_On__c);
            System.debug('QON2: '+quote.Quote_Offered_On__c.dateGMT());
            if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-2){
                this.putQuoteIntoMap(mapQuoteToSendSMS, 'AUD2', quote);
            }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-4){
                this.putQuoteIntoMap(mapQuoteToSendSMS, 'AUD4', quote);
            }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-13){
                this.putQuoteIntoMap(mapQuoteToSendSMS, 'AUD13', quote);
            }                 
        }

        List<SmsManager.BulkSMSWrapper> listBulkSMSWrapper = new List<SmsManager.BulkSMSWrapper>();
        List<Quote_Outbound_Communication_Emails__c> listQCH = new List<Quote_Outbound_Communication_Emails__c>();
        String namePlaceholder = '[NAME]';
        //iterate the quote map
        for (String key : mapQuoteToSendSMS.keySet()) {
            for(Quote__c quote: mapQuoteToSendSMS.get(key)) {
                SmsManager.BulkSMSWrapper bsw = new SmsManager.BulkSMSWrapper();
                String mn = quote.Mobile_Number__c;
                String mobileNumber = '';
                if(!isProduction && Label.AU_Quote_SMS_Dummy_Number != '' && Label.AU_Quote_SMS_Dummy_Number != null) {
                    mobileNumber = '+61'+Label.AU_Quote_SMS_Dummy_Number.substringAfter('0');
                    System.debug('Non Production Environment : '+mobileNumber);
                } else if(isProduction && mn != null && mn.substring(0, 1) == '0') {
                    mobileNumber = '+61'+mn.substringAfter('0');
                    System.debug('Production Environment : '+mobileNumber);
                }
                String htmlBody = String.valueOf(mapBrandContent.get(key).Output_HTML__c);
                String name = quote.First_Name__c;
                if(name.length() > 14) {
                    name = '';
                }
                htmlBody = htmlBody.replace(namePlaceholder, name);
                bsw.content = String.valueOf(htmlBody);
                bsw.destination_number = mobileNumber;
                bsw.source_number = 'Latitude';
                System.debug('BSW :'+bsw);
                listBulkSMSWrapper.add(bsw);

                //add to quote contact history
                Quote_Outbound_Communication_Emails__c qch = new Quote_Outbound_Communication_Emails__c();
                qch.Quote__c = quote.Id;
                qch.Template__c = getContactType(key);
                qch.Contact_Method__c = 'SMS';
                listQCH.add(qch);
            }
        }        

        String messageId = SmsManager.sendBulkMessage(listBulkSMSWrapper);
        if(messageId != GEN_OriginationsConstants.ERROR_STATUS) {
            insert listQCH;
        }
        System.debug('Message Id: '+messageId);
    }

    global void finish(database.batchableContext bc){
       
    }

    private void putQuoteIntoMap(Map<String, List<Quote__c>> mapQuoteToSendSMS, String key, Quote__c quote) {
        if(mapQuoteToSendSMS.get(key) == null) {
            mapQuoteToSendSMS.put(key, new List<Quote__c>{quote});
        } else {
            mapQuoteToSendSMS.get(key).add(quote);
        }        
    }

    private String getContactType(String key) {
        switch on key {
            when  'AUD2'{
                return 'Quote SMS Reminder 2';
            }
            when  'AUD4'{
                return 'Quote SMS Reminder 4';
            }
            when  else{
                return 'Quote SMS Reminder 13';
            }
        }
    }
}