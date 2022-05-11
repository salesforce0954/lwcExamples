/**This class is used to handle the common functionalities that are required for 
 * the Soft Quote Feature.
 */
public without sharing class SoftQuoteUtil {
    
    /**
     * Name: checkIfSoftQuoteEnabled
     * Params: applicationId
     * Description: Check if the Soft Quote feature is enabled for a given application.
     * Return: isSoftQuoteEnabled
     * Date: 10-Mar-2020
     */
    public static Boolean checkIfSoftQuoteEnabled(Id applicationId){
        Boolean isSoftQuoteEnabled = false;
        List<Application__c> appList = new List<Application__c>();
        //Get the Brand linked to the application
        appList = [SELECT Brand_String__c
                     FROM Application__c
                    WHERE Id =: applicationId];
                    System.debug('appList IS SQ: '+appList);
        if(appList.size() == 1){
            String applicationBrand = appList[0].Brand_String__c;
            System.debug('appList Brand: '+applicationBrand);
            if((applicationBrand == 'Latitude' 
                && Admin_Settings__c.getValues('Enable Soft Quote AU') != null 
                && Admin_Settings__c.getValues('Enable Soft Quote AU').Value__c == 'True') ||
                ((applicationBrand == 'GEM' || applicationBrand == 'Kiwibank') 
                && Admin_Settings__c.getValues('Enable Soft Quote NZ') != null 
                && Admin_Settings__c.getValues('Enable Soft Quote NZ').Value__c == 'True')){
            isSoftQuoteEnabled = true;
           }
        }
           return isSoftQuoteEnabled;
    }
    
     /**
     * Name: checkSoftQuoteOrgEnabled
     * Params: none
     * Description: Check if the Soft Quote feature is enabled for organization.
     * Return: isSoftQuoteOrgEnabled
     * Date: 30-Jul-2020
     */
    public static Boolean checkSoftQuoteOrgEnabled(){
        Boolean isSoftQuoteOrgEnabled = false;
        
            if(Admin_Settings__c.getValues('Soft Quote Org Enabled') != null 
                && Admin_Settings__c.getValues('Soft Quote Org Enabled').Value__c == 'True'){
                isSoftQuoteOrgEnabled = true;
           }
           return isSoftQuoteOrgEnabled;
        }
   
        
    /**
     * Name: checkStreetType
     * Params: sType,country
     * Description: Check the street type 
     * Return: isSoftQuoteOrgEnabled
     * Date: 30-Jul-2020
     */
    public static String checkStreetType(String sType, String country){
        
        String street = '';
        Street_Type_Setting__c streetType = [SELECT Name, Value__c, Region__c, Value_Abbreviated_NZ__c, Value_Abbreviated__c 
                                        FROM Street_Type_Setting__c 
                                        where 
                                        Value__c =:sType OR Value_Abbreviated_NZ__c = :sType OR Value_Abbreviated__c = :sType LIMIT 1];
        if (country != null) { 
            if (country == 'NZ' && (streetType.Region__c.trim() == 'Both' || streetType.Region__c.trim() == 'NZ')) {
                    street = streetType.Value_Abbreviated_NZ__c;
            }
            if (country == 'AU' && (streetType.Region__c.trim() == 'Both' || streetType.Region__c.trim() == 'AU')) {
                   street = streetType.Value_Abbreviated__c;   
            }
         }
                
        return street;
        }     
           
       /**
     * Name: getFinalHTMLTemplate
     * Params: sHtmlTemplate,Quote__c
     * Description: Replace all the merge feilds with Quote data and return to final htlml email template
     * Return: htmlTemplate
     * Date: 04-Nov-2020
     */
    public static String getFinalHTMLTemplate(String sHtmlTemplate, Quote__c softQuote){
        String finalHtmlTemplate;
        String loanAmount;
        if(softQuote.Region__c =='AU'){
        //Reaplce all the merge feilds with Quote data and return  
        //Null checks 
            if(softQuote.First_Name__c != null && softQuote.Name != null && softQuote.Loan_Purpose__c !=null && 
               softQuote.Loan_Amount__c != null && softQuote.Loan_Term__c != null && softQuote.Quote_Rate__c != null && 
               softQuote.Monthly_Repayment_For_Email__c != null && softQuote.Quote_Secured_Rate__c != null){
                               
                finalHtmlTemplate = sHtmlTemplate.replace('{!Quote__c.Name}',softQuote.Name);
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.First_Name__c}',softQuote.First_Name__c);
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Purpose__c}',softQuote.Loan_Purpose__c);
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Amount__c}',softQuote.Loan_Amount__c.format());
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Term__c}',softQuote.Loan_Term__c);
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Quote_Rate__c}',String.valueOf(softQuote.Quote_Rate__c));
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Quote_Secured_Rate__c}',String.valueOf(softQuote.Quote_Secured_Rate__c));
                finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Monthly_Repayment_For_Email__c}',covertDecimal(String.valueOf(softQuote.Monthly_Repayment_For_Email__c)));
                
           }
       }else if(softQuote.Region__c =='NZ'){
        //Reaplce all the merge feilds with Quote data and return 
        //Null checks 
            if(softQuote.First_Name__c != null && softQuote.Name != null && softQuote.Loan_Purpose__c !=null 
            && softQuote.Loan_Amount__c != null && softQuote.Loan_Term__c != null && softQuote.Quote_Rate__c != null
             && softQuote.Monthly_Repayment_For_Email__c != null && softQuote.Quote_Secured_Rate__c != null){
                    loanAmount = covertDecimal(String.valueOf(softQuote.Loan_Amount__c));
                    system.debug('Checkloan amount'+loanAmount);
                     system.debug('Checkloan fromat'+softQuote.Loan_Amount__c.format());
                       system.debug('Check converted repayment '+covertDecimal(String.valueOf(softQuote.Monthly_Repayment_For_Email__c)));
                    finalHtmlTemplate = sHtmlTemplate.replace('{!Quote__c.Name}',softQuote.Name);
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.First_Name__c}',softQuote.First_Name__c);
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Purpose__c}',softQuote.Loan_Purpose__c);
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Amount__c}',softQuote.Loan_Amount__c.format());
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Loan_Term__c}',softQuote.Loan_Term__c);
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Quote_Rate__c}',String.valueOf(softQuote.Quote_Rate__c));
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Quote_Secured_Rate__c}',String.valueOf(softQuote.Quote_Secured_Rate__c));
                    finalHtmlTemplate = finalHtmlTemplate.replace('{!Quote__c.Monthly_Repayment_For_Email__c}',covertDecimal(String.valueOf(softQuote.Monthly_Repayment_For_Email__c)));
                   
         }
       }
       
       
       return finalHtmlTemplate;
    }
    /**
     * Name: covertDecimal
     * Params: feildConverted
     * Description: Convert string to decimal
     * Return: String
     * Date: 18-Nov-2020
     */
     public static string covertDecimal(String feildConverted){
         String[] convArray = feildConverted.split('\\.');
         string returnConverted = convArray[0];
         return returnConverted;
     } 
      
     /**
     * Name: Insert Oubound Emails comms for Reminder emails
     * Params: sHtmlTemplate,Quote__c
     * Description: Create a record for each quote while sending out reminder emails
     * Return: boolean
     * Date: 12-Nov-2020
     */
    public static Boolean insertOutboundEmailComm(String templateType, Quote__c softQuote){
     Boolean isQuoteOutboundComm =false;
      if (templateType !='' && softQuote !=null){
          Quote_Outbound_Communication_Emails__c quoteComm = new Quote_Outbound_Communication_Emails__c();
          quoteComm.Contact_Method__c ='Email';
          quoteComm.Email_Address__c = softQuote.Email_ID__c;
          quoteComm.Quote__c =softQuote.Id;
          if (templateType == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_1  || templateType == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_1){
                quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_Reminder_Email_1;
          }else if (templateType == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_3 || templateType == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_3){
              quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_Reminder_Email_3;
              
          }else if (templateType == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_5  || templateType == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_5){
              quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_Reminder_Email_5;
              
          }else if(templateType == GEN_OriginationsConstants.QUOTE_Reminder_EmailTemp_10 || templateType == GEN_OriginationsConstants.QUOTE_RemGem_EmailTemp_10){
              quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_Reminder_Email_10;
          } else if(templateType == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_1) {
            quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_BS_Reminder_Email_1;
          } else if(templateType == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_3) {
            quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_BS_Reminder_Email_3;              
          }else if(templateType == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_5) {
            quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_BS_Reminder_Email_5;              
          }else if(templateType == GEN_OriginationsConstants.QUOTE_BS_Reminder_EmailTemp_10) {
            quoteComm.Template__c= GEN_OriginationsConstants.QUOTE_BS_Reminder_Email_10;              
          }
         System.debug('BEFORE ERROR: '+quoteComm.Template__c);
         insert quoteComm;
         isQuoteOutboundComm =true;
      }   
     return isQuoteOutboundComm;
   }
    
  }