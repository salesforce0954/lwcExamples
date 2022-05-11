public without sharing class UserTriggerHandler {

    public UserTriggerHandler() {
        
    }

    public void updateUserContact(Map<Id, User> personAccountUserMap){      

        List<Contact> personAccountList = [SELECT Id, Email, FirstName, LastName, Title FROM Contact WHERE Id IN: personAccountUserMap.keySet()];

        for(Contact c: personAccountList){
            
            if(personAccountUserMap.containsKey(c.Id)){

                c.Email = personAccountUserMap.get(c.Id).Email__c;
                c.FirstName = personAccountUserMap.get(c.Id).First_Name__c;
                c.LastName = personAccountUserMap.get(c.Id).Last_Name__c;
                c.Password_Reset_Token__c = personAccountUserMap.get(c.Id).Password_Reset_Token__c;
                c.Salutation = personAccountUserMap.get(c.Id).Title;

            }

        }

        update personAccountList;

    }

    public void sendEmail(User user){

        Map<Id,Id> userOweaMap = new Map<Id,Id>();

        //p - start
        //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: user.Brand__c LIMIT 1];

        //quey brand specific template
        //List<Brand__c> brandTemplate = [SELECT Id, Template_Password_Reset__c FROM Brand__c WHERE Name =: user.Brand__c LIMIT 1];

        List<Brand__c> brandTemplate = [SELECT Id, Template_Password_Reset__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: user.Brand__c LIMIT 1];

        string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

        if(sDsiplayName == null || sDsiplayName == '' ) {
            sDsiplayName = user.Brand__c;
        }

        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];



        //p - end

        //query the actual template
        EmailTemplate passwordResetTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Password_Reset__c LIMIT 1];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        mail.setTargetObjectId(user.ContactId);
        mail.setTemplateId(passwordResetTemplate.Id);
        mail.setSaveAsActivity(false); 
        mail.setWhatId(brandTemplate.get(0).Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

}