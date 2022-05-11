/**
 * @Description: Main Controller for the Wait Page
 * @Author: Jan Mark Domingo
 * @Date Created: Nov.27,2013
 * @History:
   =====================================================================
       11-27-13: Created  - Mac
       03-19-14: Updated referenced Page - Mike
   =====================================================================
 */
public class APP_WaitPageExt_INT{
    public String name {get;set;}
    public String timeoutSettings              {get; set;}       

    public List<Application_Response__C> appResList {get; set;}
    public String appId {get; set;}
    public String appRespId {get; set;}
    public ID  applicationId {get; set;}    
    public Boolean showComponent {get;set;}    
    
    public APP_WaitPageExt_INT(ApexPages.StandardController controller){           
       Web_Service_Settings__c sto =  Web_Service_Settings__c.getInstance('ResponseTimeOut');
        if(sto!=null) {
            timeoutSettings = sto.value__c;
        } else {
            timeoutSettings = '45'; //default 
        }
       showComponent = true;   
       name = 'AppStatusUpdates';    
       applicationId = (ID)ApexPages.currentPage().getParameters().get('id');       
    }

     /*  Description: Method to redirect the user to the Offer Page
     *  Author: Jan Mark Domingo
     *  Date Created: APR-2-2013
     *  Input: None     
     */
    public PageReference proceedToOffer(){
      //This is to check if the AppResponse created is for the correct Application      
      PageReference ref = Page.APP_ApplicationMain_INT;
      ref.getParameters().put('id',applicationId);      
      ref.getParameters().put('tab','offerTab');
      ref.getParameters().put('submit', String.valueOf('true'));
      return ref;            
    }

    /*  Description: Method to hide the loading component
     *  Author: Jan Mark Domingo
     *  Date Created: SEPT-19-2013
     *  Input: None     
     */
    public PageReference hideComponent(){
        showComponent = false;        
        PageReference ref = Page.APP_ApplicationMain_INT;
        ref.getParameters().put('timeout','true');
        ref.getParameters().put('id',applicationId);
        return ref;
    }

    /*  Description: Method to redirect the user to the Contract tab
     *  Author: Fel Saliba
     *  Date Created: APR-4-2013
     *  Input: None     
     */
    public PageReference proceedToContractAcceptance(){
      //This is to check if the AppResponse created is for the correct Application
      //if(applicationId == appId){
        PageReference ref;
        
        // Redirect to contract acceptance page 
        ref = Page.APP_ApplicationMain_INT;
        ref.getParameters().put('id',applicationId);
        ref.getParameters().put('tab', 'contractTab');
        ref.setRedirect(true);
        return ref; 
      //}      
      return null;
    }

    /*  Description: Method to insert into Push Topic 
     *  Author: Jan Mark Domingo
     *  Date Created: SEPT-19-2013
     *  Input: None     
     */
    public void checkPushTopic(){ 
        //check if the push topic already exists
        try{
          System.debug('### : topicsName ' + name);        
          List<PushTopic> topics = [SELECT id, name, query FROM PushTopic WHERE name =: name];
          System.debug('### : topics.size ' + topics.size());        
          if(topics.isEmpty()) {
              PushTopic pushTopic = new PushTopic();
              pushTopic.Name = name;              
              pushTopic.Query = 'SELECT Id, Application__c FROM Application_Response__c';
              pushTopic.ApiVersion = 30.0;
              //pushTopic.NotifyForOperations = 'All';
              pushTopic.NotifyForFields = 'Referenced';
              System.debug('*********** PUSH TOPIC ' + pushTopic);
              insert pushTopic;
          }
        }
        catch(Exception e){
            system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'checkPushTopic', 'APP_WaitPageExt_INT', 'Class', String.valueOf(applicationId));          
        }        
    }   
}