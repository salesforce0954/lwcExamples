public with sharing class APP_LogoutExt {

    public String buttonStyle {get; set;}
    public String footerTextStyle {get; set;}
    public String homeURL {get; set;}

    public APP_LogoutExt() {
        List<Brand__c> brand = [SELECT Name, 
                                       URL_Home_Page__c     //Added by MLASALA: 18-MAR-16
                                FROM   Brand__c 
                                WHERE  Site__c = :site.getName() LIMIT 1];

        if(brand.size() == 1){
            //BEGIN MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            homeURL = brand[0].URL_Home_Page__c;
            if(brand[0].Name == GEN_OriginationsConstants.BRAND_NAME_AUSSIE){
                buttonStyle = 'color:#711371;';
                footerTextStyle = 'color:#711371';
            } else if(brand[0].Name == GEN_OriginationsConstants.BRAND_NAME_GEMONEY) {
                buttonStyle = 'color:#3b73b9;';
            } else if(brand[0].Name == GEN_OriginationsConstants.BRAND_NAME_KIWI) {
                buttonStyle = 'color:#000;';
                footerTextStyle = 'color:#6fa23e';
            } else{
                buttonStyle = 'color:#3a73ba;';
                footerTextStyle = 'color:#3a73ba';
            }
            //END MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        }
    }
}