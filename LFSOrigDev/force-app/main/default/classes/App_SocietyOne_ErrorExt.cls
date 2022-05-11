/* @Description: Controller for Page APP_SocietyOne_Wait.page
    *  @Author 	   : Afreen
    *  @Date       : Jun-15-2016
    *  @History	   :
    =========================================================================================================
        Jun-15-2016 : Created - Afreen Khan
    =========================================================================================================
	*/
public class App_SocietyOne_ErrorExt {
    private String errorCode;
    public String externalAppId{get;set;}
    public External_App_Message_Code__mdt currentmsg{get; set;}
    
    public App_SocietyOne_ErrorExt(){
        errorCode 		= Apexpages.currentPage().getParameters().get('err');
        externalAppId 	= Apexpages.currentPage().getParameters().get('externalappId');

       	populateErrorMessage();
    }
    
    public void populateErrorMessage(){
        if(errorCode == null || errorCode == ''){
            errorCode = 'ERR_005';
        }
       
        try{
              currentmsg =  [Select Id, Error_Message__c, Error_Description__c, Contact_Point__c From External_App_Message_Code__mdt where DeveloperName =: errorCode Limit 1];
        }catch(Exception e){
              currentmsg =  [Select Id, Error_Message__c, Error_Description__c From External_App_Message_Code__mdt where DeveloperName =: 'ERR_005' Limit 1];
        }

    }
}