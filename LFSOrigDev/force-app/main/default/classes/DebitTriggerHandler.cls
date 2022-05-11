/* @Description: Trigger handler for Debit object
 * @Author: Mike Lasala
 * @Date Created: MAR-07-2014
 * @History:
 
 * Keerthan Tantry   30-3-2015  Added a method createBSBValue
   =====================================================================
       03-07-14: Created - Mike
   =====================================================================
 */

public class DebitTriggerHandler{
    
    /*  Description: Validate before insert/after undelete if debit record count is equal 1
     *  Author: Mike Lasala
     *  Date Created: MAR-07-2014
     */     
    public void checkDebitRecordCount(List<Debit__c> debitList, Boolean isInsert){
        Set<Id> applicationIds = new Set<Id>();
        //accList = [select id from account where isdeleted =: true ALL rows];
        
        if(!debitList.isEmpty()){
            for(Debit__c d: debitList){
                applicationIds.add(d.Application__c);
            }

            if(!applicationIds.isEmpty()){
                List<Debit__c> existingDebitList = new List<Debit__c>();

                existingDebitList = [SELECT Id
                                     FROM   Debit__c
                                     WHERE  Application__c
                                     IN:    applicationIds];
                
                if(!existingDebitList.isEmpty()){
                    if(isInsert){
                        for(Debit__c d: debitList){
                            d.addError('Debit record already exists');
                        }
                    } else {
                        if(existingDebitList.size()>1){
                            for(Debit__c d: debitList){
                                d.addError('Debit record already exists');
                            }
                        }
                    }
                }
            }
        }
    }
    
    /*  Description: Method to set Application Out of sync field to true.
     *  Author: Fel Saliba
     *  Date Created: May-27-2014
     */
    public static void setAppOutOfSync(Set<Id> appIds){
        
        List<Application__c> appList = new List<Application__c>();
        if(appIds.size()>0){
            appList = [Select Id, Out_Of_Sync__c FROM Application__c
                       WHERE Id IN: appIds];
        }
        
        List<Application__c> uAppList = new List<Application__c>();
        if(appList.size()>0){
            for(Application__c app: appList){
                app.Out_Of_Sync__c = true;
                uAppList.add(app);
            }
        }
        
        if(uAppList.size()>0){
            try{
                update uAppList;
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'DebitTriggerHandler', 'Application__c', 'Class');
            }
        }
    
    }
    /*  Description: Method to set the BSB number value 
     *  Author: Keerthan Tantry
     *  Date Created: March-30 -2015
     */ 
    public  void createBSBValue(List<Debit__c> debitList)
    {
        for(Debit__c db :debitList )
        {
            String bankNumber = db.Bank_Number__c != NULL ?  db.Bank_Number__c : '';
            String BranchNumber = db.Branch_Number__c != NULL ?  db.Branch_Number__c : '';
           if(Profile_country__c.getInstance().NZ__c)
           { 
              db.BSB_Number__c =  bankNumber + BranchNumber;
           }
        }
        
    }
}