public without sharing class SalesAndLeadsUtility{

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 27 Feb 2013
    * @description Send email notification based on specified user Id
    * @param 
    */
    public void pushEmail(Id usrId, Id oppId){
            // Query email of current user and query email template 'New lead Owner'          
            User usrVar = [Select Id, ContactId, Email from User where Id = :usrId];
            EmailTemplate emailTempVar = [Select Id from EmailTemplate where DeveloperName = 'New_Lead_Owner' limit 1];
               
            // Create temporary contact to be use for sending email since it is required         
            Contact conVar = new Contact(LastName = 'test', Email = usrVar.Email);
            insert conVar;
               
            // Send email         
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(emailTempVar.Id);
            mail.setTargetObjectId(conVar.Id);   
            mail.setWhatId(oppId);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
               
            // Delete temporary contact         
            delete conVar;
                         
            system.debug('Email result:' + results);
    }// End pushEmail Method


}