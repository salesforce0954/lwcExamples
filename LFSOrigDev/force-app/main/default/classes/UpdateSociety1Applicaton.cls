/* @Description: Called from Process Builder "Society One Appplication"
*  @Author     : Afreen
*  @Date       : Jun-09-2016
*  @History    :
=========================================================================================================
    Jun-02-2016 : Created - Afreen Khan
=========================================================================================================
*/
public class UpdateSociety1Applicaton {
    
    @InvocableMethod     
    public static void updateFields(List<Id> ApplicationIds){
        List<Product_Item__c> productItemList = new List<Product_Item__c>();
        Brand__c bVar =   [SELECT   Id,  Name,  Getting_Started_HTML__c, Eligibility_HTML__c,  Brand_Display_Name__c, Site__c, Country__c, Online_Branch__c FROM     Brand__c WHERE    Site__c = 'Latitude' LIMIT 1];

        Product_Version__c prodVer =    [Select Id,GEProduct__c FROM Product_Version__c  WHERE GEProduct__r.Type__c = 'Personal Loan' AND (Start_Date__c = null OR Start_Date__c <= TODAY) AND  (End_Date__c = null  OR End_Date__c >= TODAY) And GEProduct__r.Brands__c =:bVar.Id limit 1];
        
        Group fQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'AU_3rd_Party_Application_Failed_Queue' LIMIT 1];
        
        List<Application__c> appList = [Select Id, Name, Brand_Lookup__c From Application__c where id in :ApplicationIds ] ;
        for(Application__c app : appList){
            app.Brand_Lookup__c         = bVar.id;      
            app.Brand_String__c         = bVar.Name;
            app.Branch__c               = bVar.Online_Branch__c;
            app.Product_Id__c           = prodVer.GEProduct__c;
            app.Channel__c              = '3rd Party Application';
            //app.Channel__c                = 'Online';
            app.Mirror__c               = 'SocietyOne'; 
            app.Business_Source__c      = 'INTERNET APPLICATION';
            app.ownerId                 = fQueue.Id; // Assign Failed Queue Owner, Added by: Adrian Recio 
            productItemList.add(createPIforApp(app, prodVer));
        }
        update appList;
        insert productItemList;
    }
    
    public static Product_Item__c createPIforApp(Application__c app, Product_Version__c prodVer){
        Product_Item__c pItem = new Product_Item__c(Application__c = app.Id, Product_Version__c = prodVer.Id);
        return pItem;
    }
    
}