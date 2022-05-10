public class retrieveAccName implements database.batchable<sObject>,database.stateful{

      string name;
      
      set<id> success = new set<id>();
      set<id> failure = new set<id>();
      
      public retrieveAccName(String name){
        this.name = name;
      }
      
      public Database.queryLocator start(Database.BatchableContext bc){
        string query = 'select id,name,(select email,accountId from contacts) from Account where name =:name';
        return Database.getQueryLocator(query);
      }
      
      public void execute(Database.BatchableContext bc,List<Account> scope){
      
        List<contact> cList = new List<contact>();
        
       for(Account a : scope){
            for(Contact c:a.contacts){
            
                c.email = 'scopeOne@gmail.com';
                cList.add(c);
                system.debug(cList);
            }
          }
          
          //update cList;
        
          List<database.saveResult> sr = database.update(cList);
         
           for(Database.saveResult s:sr){
             if(s.isSuccess()){
                success.add(s.getId());
             }else{
               failure.add(s.getId());
             }
           }
      
      }
      
      public void finish(Database.batchableContext bc){
      
         //futureExample.getCarServicing();
         system.enqueuejob(new queueableEx());
         system.debug('Success '+success);
         system.debug('Failure '+failure);
      }
      
}