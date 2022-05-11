/*
 * @Description: Main Controller for the Privacy Policy Page
 * @Author: Mike Lasala
 * @Date Created: May 23,2014
 * @History:
   =====================================================================
       05-23-14: Created  - Mike
   =====================================================================
 */
public with sharing class APP_PrivacyPolicyExt {

    public String policyText {get; set;}

    public APP_PrivacyPolicyExt() {
        
        Brand__c brandVar = [SELECT Id 
                             FROM   Brand__c 
                             WHERE  Site__c = :site.getName() LIMIT 1];
        
        Brand_Content__c bCon = [SELECT Output_HTML__c 
                                 FROM   Brand_Content__c 
                                 WHERE  Brand__c =: brandVar.Id 
                                 AND    Name =: GEN_OriginationsConstants.BRAND_CONTENT_PRIVACY_POLICY LIMIT 1];    

        if(bCon.Output_HTML__c == null){
            policyText = '';
        } else {
            policyText = bCon.Output_HTML__c;
        }
    }
}