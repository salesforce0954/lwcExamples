/**
 * @Description: Main Controller for the EIDV Consent Page
 * @Author: Dan Crisologo
 * @Date Created: May 21,2014
 * @History:
   =====================================================================
       05-21-14: Created  - Dan
   =====================================================================
 */
public class APP_VerifyIdentityExt {

    public String consentText     {get; set;}
    public Date today             {get; set;}
    public Applicant__c applicant {get; set;}

    public APP_VerifyIdentityExt() {
        String applicationId = ApexPages.currentPage().getParameters().get('id');

        Brand__c brandVar = [Select Id, Name, Site__c from Brand__c where Site__c = :site.getName() limit 1];
        
        Brand_Content__c bCon = [Select Name, Brand__c, Output_HTML__c from Brand_Content__c where Brand__c = : brandVar.Id AND Name = 'APP_VerifyIdentity' LIMIT 1];
        if(bCon.Output_HTML__c == null){
            consentText = '';
        } else {
            consentText = bCon.Output_HTML__c;
        }

        if(applicationId != null){
            applicant = [SELECT    Id, First_Name__c, Last_Name__c 
                         FROM      Applicant__c 
                         WHERE     Application__c =: applicationId
                         AND       Is_Primary_Applicant__c = true LIMIT 1];

            today = date.today();
        }
    }
}