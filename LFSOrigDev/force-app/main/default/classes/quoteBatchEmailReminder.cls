/**  SoftQuote Batch class for latitude/GEM with 3,5,10.13 days frequency emails
 * @Author: Madhusudhan Seethala
 * @Date Created: Oct-05-2020 
 * @History:
   ========================================================================
    Feb-24-2021 :Changed the Latitude/GEM email frequency to 1,3,5,10 days 
    Oct-14-2021 :Separate NZ batch email into another class QuoteBatchEmailReminderNZ
   ========================================================================
 */ 
global class quoteBatchEmailReminder implements Database.Batchable<SObject>, Database.Stateful {
    global string soqlquery;
     
     global quoteBatchEmailReminder(){
     
     }
     global database.querylocator start(database.batchableContext bc){
        String quoteStatus ='Quote Offered';
        String quoteSalesChannel ='Sales';
        String quoteOnlineChannel ='Online';
        String region = 'AU';
       
        soqlquery='Select Id,Name,Email_ID__c,Product__c,Quote_Rate__c,Quote_Secured_Rate__c,Quote_Offered_On__c,Quote_Stage__c,Channel__c, '+
        'Region__c,Loan_Term__c,Loan_Purpose__c,Loan_Amount__c,First_Name__c,Quote_Valid_For__c,Quote_Expires_On__c,Comparison_Rate__c, '+
        'Monthly_Repayment_For_Email__c,Sub_Type__c '+
        'from Quote__c where Quote_Rate__c <> null and Quote_Secured_Rate__c <> null and Quote_Stage__c=: quoteStatus and (Channel__c =: quoteSalesChannel or Channel__c =: quoteOnlineChannel) '+
        'and Quote_Offered_On__c <>null and  Quote_Offered_On__c = LAST_N_DAYS:13 AND Region__c = :region order by Quote_Offered_On__c desc';
        system.debug('SOQL check'+soqlquery);
        return database.getquerylocator(soqlquery);
       
     }
    
     global void execute(Database.BatchableContext bc, List<Quote__c> scope){
         List<String> toEmailAddress =  new List<String>();
         //declare the lists for daywise quotes
         List<Quote__c> quoteFirstDayAU = new List<Quote__c>();
          List<Quote__c> quoteThirdDayAU = new List<Quote__c>();
          List<Quote__c> quoteFifthDayAU = new List<Quote__c>();
          List<Quote__c> quoteTenthDayAU = new List<Quote__c>();
          List<Quote__c> quoteBSFirstDayAU = new List<Quote__c>();
          List<Quote__c> quoteBSThirdDayAU = new List<Quote__c>();
          List<Quote__c> quoteBSFifthDayAU = new List<Quote__c>();
          List<Quote__c> quoteBSTenthDayAU = new List<Quote__c>();      
          
          List<Messaging.SingleEmailMessage> mailingList = new List<Messaging.SingleEmailMessage>();
               
          Id orgLatitudeID;
    
          EmailTemplate emailTemplateDay1AU = new EmailTemplate();
          EmailTemplate emailTemplateDay3AU = new EmailTemplate();
          EmailTemplate emailTemplateDay5AU = new EmailTemplate();
          EmailTemplate emailTemplateDay10AU = new EmailTemplate();
          EmailTemplate emailTemplateDay1AUBS = new EmailTemplate();
          EmailTemplate emailTemplateDay3AUBS = new EmailTemplate();
          EmailTemplate emailTemplateDay5AUBS = new EmailTemplate();
          EmailTemplate emailTemplateDay10AUBS = new EmailTemplate();      
          
       //Retreive and prepare list of daywise quotes
        for (Quote__c quote: scope){
            if(quote.Sub_Type__c == 'Better Start') {
                if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-1){
                    quoteBSFirstDayAU.add(quote);
               }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-3){
                    quoteBSThirdDayAU.add(quote);
              }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-5){
                    quoteBSFifthDayAU.add(quote);
              }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-10){
                    quoteBSTenthDayAU.add(quote);
               }
            } else {
                if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-1){
                    quoteFirstDayAU.add(quote);
               }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-3){
                    quoteThirdDayAU.add(quote);
              }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-5){
                    quoteFifthDayAU.add(quote);
              }else if(quote.Quote_Offered_On__c.dateGMT() == System.Today()-10){
                    quoteTenthDayAU.add(quote);
               }                
            }
        }
           //Retrieving all Latitude/GEM Email Templates
           for(EmailTemplate emailTemp:[select Id,name, Body, htmlvalue, Subject  from EmailTemplate 
                                       where 
                                       name IN('Soft Quote Day1 Reminder AU','Soft Quote Day3 Reminder AU','Soft Quote Day5 Reminder AU','Soft Quote Day10 Reminder AU',
                                       'Soft Quote Day1 Reminder AU Better Start','Soft Quote Day3 Reminder AU Better Start','Soft Quote Day5 Reminder AU Better Start','Soft Quote Day10 Reminder AU Better Start')]){
                if (emailTemp.name == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_1 ){
                    emailTemplateDay1AU=emailTemp;
                }
                if (emailTemp.name == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_3){
                    emailTemplateDay3AU=emailTemp;
                }
                if (emailTemp.name == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_5){
                    emailTemplateDay5AU=emailTemp;
                }
                if (emailTemp.name == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_10){
                    emailTemplateDay10AU=emailTemp;
                }
                //Better Start
                if(emailTemp.name == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_1) {
                    emailTemplateDay1AUBS=emailTemp;
                }
                if(emailTemp.name == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_3) {
                    emailTemplateDay3AUBS=emailTemp;
                }
                if(emailTemp.name == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_5) {
                    emailTemplateDay5AUBS=emailTemp;
                }
                if(emailTemp.name == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_10) {
                    emailTemplateDay10AUBS=emailTemp;
                }                                     
          }
    
          //Oragnization wide email address for Latitude and GEM
          for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where  DisplayName='Latitude Personal Loans' LIMIT 4]) 
           {
            if(owa.DisplayName == GEN_OriginationsConstants.emailAddress_LFS && owa.address == GEN_OriginationsConstants.emailAddress_OrgLFS){
                orgLatitudeID =owa.id;
            }
           }
                  
          system.debug('First day check'+quoteFirstDayAU.size());
    
          if (quoteFirstDayAU.size() >0) {
              for (Quote__C quote: quoteFirstDayAU){
              Messaging.SingleEmailMessage mailFirstDayRem = new Messaging.SingleEmailMessage();
                  // Retrieve the HTML Template   
                  String outputFirstHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay1AU.htmlvalue,quote);
                  boolean createOutboundEmail = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay1AU.name,quote);
                  String[] toAddresses = new String[] {quote.Email_ID__c}; 
                   mailFirstDayRem.setToAddresses(toAddresses);
                   mailFirstDayRem.setSubject(emailTemplateDay1AU.Subject);
                   mailFirstDayRem.setHtmlBody(outputFirstHtml);
                   mailFirstDayRem.setBccSender(false);
                   mailFirstDayRem.setUseSignature(false);
                   mailFirstDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                   mailingList.add(mailFirstDayRem);          
            }
               
              
           }
         
          if (quoteThirdDayAU.size() >0) {
              for (Quote__C quote: quoteThirdDayAU){
              Messaging.SingleEmailMessage mailThirdDayRem = new Messaging.SingleEmailMessage();
              // Retrieve the HTML Template   
                   String outputThirdHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay3AU.htmlvalue,quote);
                   boolean createOutboundEmailThird = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay3AU.name,quote);
                   String[] toAddresses = new String[] {quote.Email_ID__c}; 
                   mailThirdDayRem.setToAddresses(toAddresses);
                   mailThirdDayRem.setSubject(quote.First_Name__c  +', apply within minutes');
                   mailThirdDayRem.setHtmlBody(outputThirdHtml);
                   mailThirdDayRem.setBccSender(false);
                   mailThirdDayRem.setUseSignature(false);
                   mailThirdDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                   mailingList.add(mailThirdDayRem);                   
               }
             
          }
           
           if (quoteFifthDayAU.size() >0) {
              for (Quote__C quote: quoteFifthDayAU){
              Messaging.SingleEmailMessage mailFifthDayRem = new Messaging.SingleEmailMessage();
              // Retrieve the HTML Template   
                  String outputFifthHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay5AU.htmlvalue,quote);
                  boolean createOutboundEmailFifth = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay5AU.name,quote);
                  String[] toAddresses = new String[] {quote.Email_ID__c}; 
                   mailFifthDayRem.setToAddresses(toAddresses);
                   mailFifthDayRem.setSubject(emailTemplateDay5AU.Subject);
                   mailFifthDayRem.setHtmlBody(outputFifthHtml);
                   mailFifthDayRem.setBccSender(false);
                   mailFifthDayRem.setUseSignature(false);
                   mailFifthDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                   mailingList.add(mailFifthDayRem);                      
               }
           }
            system.debug('Size of list'+quoteTenthDayAU.size());
           if (quoteTenthDayAU.size() >0) {
              for (Quote__C quote: quoteTenthDayAU){
              Messaging.SingleEmailMessage mailTenthDayRem = new Messaging.SingleEmailMessage();
              // Retrieve the HTML Template   
                  String outputTenthHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay10AU.htmlvalue,quote);
                  boolean createOutboundEmailTenth = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay10AU.name,quote);
                   String[] toAddresses = new String[] {quote.Email_ID__c}; 
                   mailTenthDayRem.setToAddresses(toAddresses);
                   mailTenthDayRem.setSubject(emailTemplateDay10AU.Subject);
                   mailTenthDayRem.setHtmlBody(outputTenthHtml);
                   mailTenthDayRem.setBccSender(false);
                   mailTenthDayRem.setUseSignature(false);
                   mailTenthDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                   mailingList.add(mailTenthDayRem);                        
               }
           }
    
           //Better Start Reminder Emails
           if (quoteBSFirstDayAU.size() >0) {
            for (Quote__C quote: quoteBSFirstDayAU){
            Messaging.SingleEmailMessage mailFirstDayRem = new Messaging.SingleEmailMessage();
                // Retrieve the HTML Template   
                String outputFirstHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay1AUBS.htmlvalue,quote);
                boolean createOutboundEmail = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay1AUBS.name,quote);
                String[] toAddresses = new String[] {quote.Email_ID__c}; 
                 mailFirstDayRem.setToAddresses(toAddresses);
                 mailFirstDayRem.setSubject(emailTemplateDay1AUBS.Subject);
                 mailFirstDayRem.setHtmlBody(outputFirstHtml);
                 mailFirstDayRem.setBccSender(false);
                 mailFirstDayRem.setUseSignature(false);
                 mailFirstDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                 mailingList.add(mailFirstDayRem);                     
             }
             
            
         }
       
        if (quoteBSThirdDayAU.size() >0) {
            for (Quote__C quote: quoteBSThirdDayAU){
            Messaging.SingleEmailMessage mailThirdDayRem = new Messaging.SingleEmailMessage();
            // Retrieve the HTML Template   
                 String outputThirdHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay3AUBS.htmlvalue,quote);
                 boolean createOutboundEmailThird = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay3AUBS.name,quote);
                 String[] toAddresses = new String[] {quote.Email_ID__c}; 
                 mailThirdDayRem.setToAddresses(toAddresses);
                 mailThirdDayRem.setSubject(quote.First_Name__c  +', apply within minutes');
                 mailThirdDayRem.setHtmlBody(outputThirdHtml);
                 mailThirdDayRem.setBccSender(false);
                 mailThirdDayRem.setUseSignature(false);
                 mailThirdDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                 mailingList.add(mailThirdDayRem);            
             }
           
        }
         
         if (quoteBSFifthDayAU.size() >0) {
            for (Quote__C quote: quoteBSFifthDayAU){
            Messaging.SingleEmailMessage mailFifthDayRem = new Messaging.SingleEmailMessage();
            // Retrieve the HTML Template   
                String outputFifthHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay5AUBS.htmlvalue,quote);
                boolean createOutboundEmailFifth = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay5AUBS.name,quote);
                String[] toAddresses = new String[] {quote.Email_ID__c}; 
                 mailFifthDayRem.setToAddresses(toAddresses);
                 mailFifthDayRem.setSubject(emailTemplateDay5AUBS.Subject);
                 mailFifthDayRem.setHtmlBody(outputFifthHtml);
                 mailFifthDayRem.setBccSender(false);
                 mailFifthDayRem.setUseSignature(false);
                 mailFifthDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                 mailingList.add(mailFifthDayRem);              
             }
         }
          system.debug('Size of list'+quoteTenthDayAU.size());
         if (quoteBSTenthDayAU.size() >0) {
            for (Quote__C quote: quoteBSTenthDayAU){
            Messaging.SingleEmailMessage mailTenthDayRem = new Messaging.SingleEmailMessage();
            // Retrieve the HTML Template   
                String outputTenthHtml = SoftQuoteUtil.getFinalHTMLTemplate(emailTemplateDay10AUBS.htmlvalue,quote);
                boolean createOutboundEmailTenth = SoftQuoteUtil.insertOutboundEmailComm(emailTemplateDay10AUBS.name,quote);
                 String[] toAddresses = new String[] {quote.Email_ID__c}; 
                 mailTenthDayRem.setToAddresses(toAddresses);
                 mailTenthDayRem.setSubject(emailTemplateDay10AUBS.Subject);
                 mailTenthDayRem.setHtmlBody(outputTenthHtml);
                 mailTenthDayRem.setBccSender(false);
                 mailTenthDayRem.setUseSignature(false);
                 mailTenthDayRem.setOrgWideEmailAddressId(orgLatitudeID);   
                 mailingList.add(mailTenthDayRem);                 
             }
         }       
         
         Messaging.sendEmail(mailingList);
     }
    
     global void finish(database.batchableContext bc){
           
     }
    }