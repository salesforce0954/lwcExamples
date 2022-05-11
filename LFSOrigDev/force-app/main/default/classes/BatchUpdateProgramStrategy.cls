global class BatchUpdateProgramStrategy implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
  
 global String propQry { get; set; }
 global database.querylocator start(Database.BatchableContext bc)
 {
   return Database.getQueryLocator(propQry);
 }
 
 global void execute(Database.BatchableContext bc, sObject[] objects)
 {
    Set<Id> accountId = new Set<Id>();
    Map<Id, Account> accountMap = new Map<Id, Account>();
    for(sobject s : objects){
        Account a = (Account)s;
        accountMap.put(a.Id, a);
    }
    
    List<Account> groupAccount = [select id, Name,Promotion_Strategy__c,
                                        (Select id, Name, Term__c,Promotion_Type__c ,Start_Date__c,
                                        End_Date__c, Product_Categories__c ,Minimum_Purchase__c,
                                        MSF__c,Channels__c,Promotion_Group_Account__c 
                                        from Promotions__r
                                        )
                                        from Account where id in:accountMap.keyset()];


    for(Account ac:groupAccount){
        ac.Promotion_Strategy__c = '';
        List<Promotions__c> promotions = ac.Promotions__r;
            for(Promotions__c p:promotions){
                if( p.End_Date__c >= System.today() ){
                    ac.Promotion_Strategy__c += 'Promotion' + ' \r\n';
                    ac.Promotion_Strategy__c += p.Name + ' \r\n';
                    ac.Promotion_Strategy__c += p.Term__c+ '\t' + p.Promotion_Type__c + ' \r\n';
                    ac.Promotion_Strategy__c += p.Start_Date__c.format() + '-' + p.End_Date__c.format() +' \r\n';
                    ac.Promotion_Strategy__c += 'Categories:' + '  ' + p.Product_Categories__c + ' \r\n';
                    ac.Promotion_Strategy__c += 'Minimum Purchase:' + '  ' + p.Minimum_Purchase__c+ ' \r\n';
                    ac.Promotion_Strategy__c += 'MSF (Incl. GST):' + '  ' + p.MSF__c+ ' \r\n';
                    ac.Promotion_Strategy__c += 'Channels:' + '  ' + p.Channels__c+ ' \r\n' + ' \r\n'  + ' \r\n'; 
                    accountMap.put(ac.Id, ac);  
                }
            }      
             accountMap.put(ac.Id, ac);  
        }
        
        Database.update(accountMap.values());
 }
 
 global void finish(Database.BatchableContext bc)
 {
 }
 
 
}