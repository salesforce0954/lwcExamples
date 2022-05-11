public class EnterNumbersController {

    public Account account{get;set;}
    public Contact contact{get;set;}
    public User user{get;set;}
    public String record_id{get;private set;}
    public Boolean isAccount{get;private set;}
    public Boolean isContact{get;private set;}
    public Boolean close_flag {get;set;}
    public String name{get;private set;}

    public boolean getIsValidationApplicable(){
        if(isAccount){
            if(account.Classification_Primary__c != 'Dormant' ){
                if((account.BillingCountry == 'Australia')||(account.BillingCountry =='' && user.Country == 'Australia')){  
                    return true;
                }
                if(account.BillingCountry != 'Australia'){
                    return true;
                }
            }
            
        }
        
        if(isContact){
            if((contact.MailingCountry == 'Australia') || (contact.MailingCountry  =='' && user.Country == 'Australia')){
                return true;
            }
            if(contact.MailingCountry != 'Australia'){
                return true;
            }
        }
        return false;
    
    }
   
    public EnterNumbersController () {
        isAccount = false;
        isContact = false;
        record_id = ApexPages.currentPage().getParameters().get('id');
        if(record_id.substring(0,3)=='001'){
            isAccount = true;
            Account = [SELECT Id,Name,Phone,Fax,Fax_Application_Responses__c,
                        Fax_Settlements_Statements__c,PRS_RECORD_ID__c,
                        BillingCountry,Classification_Primary__c
                      FROM Account WHERE Id = :record_id]; 
            name = account.Name;
        }
        if(record_id.substring(0,3)=='003'){
            isContact = true;
            contact = [select id,Name,phone,Fax,MobilePhone,OtherPhone,
                            AssistantPhone,PRS_RECORD_ID__c,MailingCountry
                             from Contact where id = :record_id];
            name = contact.Name;
        }     
    }
    
    public PageReference save(){
        try{
            if(isAccount){
                log('Account: ' + Account);
                update Account;
            }
            if(isContact){
                log('Contact: ' + contact);
                update contact;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            log('Exception#'+ex);
        }
        close_flag = true;
        
        return null;
    }
    private void log(Object obj){
        System.debug(LoggingLevel.INFO, obj);
    }
}