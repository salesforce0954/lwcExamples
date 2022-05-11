/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 18 Feb 2013 
* @description Class to handle CallScriptPage Logic
*/

public with sharing class CallScriptController {

        // Variable Declaration
        public Opportunity oppVar;
        public List<Campaign> campList{get; set;}
        public Campaign campVar{get; set;}
        
        /**
        * @author Original: Adrian Recio Cloud Sherpas
        * @date Original: 18 Feb 2013 
        * @description  Method to query opportunity details based on oppId parameter 
                                        and query parent campaign that contains call script and attachement
        * @last modified by: Michael Lasala             4 Mar 2013              Change filter Campaign query to base on Opportunity.Letter_Stream__c            
        * @param
        */
        public void setupCampaign(){
                // Get url parameter oppId
                string oppId = ApexPages.currentPage().getParameters().get('oppId');
                
                if(oppId!=null){
                    try{
                        oppVar = [Select Id, campaign.Id, Letter_Stream__c  from Opportunity where Id = :oppId];
                        campList = [Select Id, Call_Script__c , Name from Campaign where name = :oppVar.Letter_Stream__c limit 1];
                        if(campList.size()==1){
                                campVar = campList[0];
                        }// End If
                    } catch(System.Exception e){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                       ApexPages.addMessage(myMsg);                                    
                    }  
                }// End If
        }// End setupCampaign
        
        /**
        * @author Original: Adrian Recio Cloud Sherpas
        * @date Original: 18 Feb 2013 
        * @description  Method to query campaign attachments based on campaign
        * @param
        */
        public List<Attachment> getCampaignAttachments(){
                // If campaign is not null, query attachments where parentId is equal to campaign's Id
                if(campVar!=null){
                        List<Attachment> attachList = [Select Id, Name, CreatedDate from Attachment where ParentId = :campList[0].Id];
                        return attachList;
                }else{
                        return null;
                }// End Else
        }// End getCampaignAttachments
}