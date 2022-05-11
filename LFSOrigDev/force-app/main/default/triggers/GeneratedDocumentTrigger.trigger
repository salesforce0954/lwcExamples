/*
Author: August Del Rosario Cloud Sherpas
Created Date: Febuary 05, 2014
Description: Update the related document status (to received) when a new attachmend is added.
*/
trigger GeneratedDocumentTrigger on Attachment (before insert,after insert) {

    GeneratedDocumentTriggerHandler Handler = new GeneratedDocumentTriggerHandler();
    //Update related document Status to recieved
    if(trigger.isBefore && trigger.isInsert){
        //pass the attachment records in the handler class method that will clear the Related Document Error fields.
        Handler.UpdateRelatedDocument(trigger.new);
    }
    
    // Updated by: Adrian Recio
    // Description: Method removed since this will be fired in page instead of waiting for an attachment to insert.
    //Call webservice Confirmation.
    /*
    if(trigger.isAfter && trigger.isInsert){
        Handler.callConfirmContractRecieved(trigger.new);
    }
    */

}