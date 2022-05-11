/**  SoftQuote Batch class for GEM
 * @Author: William Putra
 * @Date Created: Oct-14-2021 
 * @History:
   ========================================================================
   Change frequency of NZ email reminder only on day 1 and day 3
   ========================================================================
 */ 
global class QuoteBatchEmailReminderNZ implements Database.Batchable<SObject>, Database.Stateful {
    global string soqlQuery;

    global QuoteBatchEmailReminderNZ() {

    }

    global database.querylocator start(database.batchableContext bc){
        String quoteStatus ='Quote Offered';
        String quoteSalesChannel ='Sales';
        String quoteOnlineChannel ='Online';
        String region = 'NZ';
        String product = 'GEM Personal Loan';
       
        soqlQuery='Select Id,Name,Email_ID__c,Product__c,Quote_Rate__c,Quote_Secured_Rate__c, ' +
        'Quote_Offered_On__c,Quote_Stage__c,Channel__c,Region__c,Loan_Term__c,Loan_Purpose__c, ' +
        'Loan_Amount__c,First_Name__c,Quote_Valid_For__c,Quote_Expires_On__c,Comparison_Rate__c, ' +
        'Monthly_Repayment_For_Email__c,Sub_Type__c ' + 
        'from Quote__c where Quote_Rate__c <> null and Quote_Secured_Rate__c <> null and Quote_Stage__c=: quoteStatus and (Channel__c =: quoteSalesChannel or Channel__c =: quoteOnlineChannel) '+
        'and Quote_Offered_On__c <>null and  Quote_Offered_On__c = LAST_N_DAYS:13 AND Region__c = :region AND Product__c = :product order by Quote_Offered_On__c desc';
        system.debug('SOQL check'+soqlQuery);
        return database.getquerylocator(soqlQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<Quote__c> scope){
        List<String> toEmailAddress =  new List<String>();

        List<Quote__c> quoteFirstDayGEM = new List<Quote__c>();
        List<Quote__c> quoteThirdDayGEM = new List<Quote__c>();

        List<Messaging.SingleEmailMessage> mailingList = new List<Messaging.SingleEmailMessage>();

        Id orgGEMID;

        EmailTemplate emailTemplateDay1GEM = new EmailTemplate();
        EmailTemplate emailTemplateDay3GEM = new EmailTemplate();
        
        for (Quote__c quote: scope){
            if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-1 ){
                quoteFirstDayGEM.add(quote);
            }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-3 ){
                quoteThirdDayGEM.add(quote);
            }       
        }

       //Retrieving all Latitude/GEM Email Templates
       for(EmailTemplate emailTemp:[select Id,name, Body, htmlvalue, Subject  from EmailTemplate 
                                   where 
                                   name IN('GEM Soft Quote Day1 Reminder','GEM Soft Quote Day3 Reminder')]){                              
            if (emailTemp.name == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_1){
                emailTemplateDay1GEM=emailTemp;
            }
            if (emailTemp.name == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_3){
                emailTemplateDay3GEM=emailTemp;
            } 
      }        

      //Oragnization wide email address for Latitude and GEM
      for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where  DisplayName= 'Gem Personal Loans' LIMIT 4]) 
       {
         if(owa.DisplayName == GEN_OriginationsConstants.emailAddress_GEM && owa.address == GEN_OriginationsConstants.emailAddress_OrgGEM){
             orgGEMID =owa.id;
         }
       } 
       
      //GEM Reminder Emails
      if (quoteFirstDayGEM.size() >0) {
        for (Quote__C quote: quoteFirstDayGEM){
        Messaging.SingleEmailMessage mailFirstDayGEMRem = new Messaging.SingleEmailMessage();
        // Retrieve the HTML Template   
            String outputGEMHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay1GEM.htmlvalue,quote);
            boolean createOutboundEmailGEM = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay1GEM.name,quote);
            String[] toAddresses = new String[] {quote.Email_ID__c}; 
            mailFirstDayGEMRem.setToAddresses(toAddresses);
            mailFirstDayGEMRem.setSubject(emailTemplateDay1GEM.Subject);
            mailFirstDayGEMRem.setHtmlBody(outputGEMHtml);
            mailFirstDayGEMRem.setBccSender(false);
            mailFirstDayGEMRem.setUseSignature(false);
            mailFirstDayGEMRem.setOrgWideEmailAddressId(orgGEMID);   
            mailingList.add(mailFirstDayGEMRem);               
         }
     }
     if (quoteThirdDayGEM.size() >0) {
        for (Quote__C quote: quoteThirdDayGEM){
        Messaging.SingleEmailMessage mailThirdDayGEMRem = new Messaging.SingleEmailMessage();
        // Retrieve the HTML Template   
            String outputGEMThirdHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay3GEM.htmlvalue,quote);
            boolean createOutboundEmailGEMFifth = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay3GEM.name,quote);
            String[] toAddresses = new String[] {quote.Email_ID__c}; 
            mailThirdDayGEMRem.setToAddresses(toAddresses);
            mailThirdDayGEMRem.setSubject(quote.First_Name__c  +', apply within minutes');
            mailThirdDayGEMRem.setHtmlBody(outputGEMThirdHtml);
            mailThirdDayGEMRem.setBccSender(false);
            mailThirdDayGEMRem.setUseSignature(false);
            mailThirdDayGEMRem.setOrgWideEmailAddressId(orgGEMID);   
            mailingList.add(mailThirdDayGEMRem);                  
         }
     }  
     
     Messaging.sendEmail(mailingList);    
    }

    global void finish(database.batchableContext bc){
       
    }    
}