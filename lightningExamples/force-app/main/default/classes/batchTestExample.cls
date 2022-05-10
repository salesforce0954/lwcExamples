public class batchTestExample implements database.batchable<sObject>,database.stateful{

    set<id> successRecords = new set<id>();
    set<id> failureRecords = new set<id>();
    
    public integer sRecords = 0;
    public integer fRecords = 0;

   public database.queryLocator start(database.batchableContext bc){
   
      String query = 'select id,name from Account';
      return database.getQueryLocator(query);
   }
   
   public void execute(Database.BatchableContext bc ,List<Account> scope){
      
        for(Account acc:scope){
         acc.name = 'Dr '+acc.name;
        }
          List<Database.saveResult> srList = Database.update(scope,false);
          
          for(Database.saveResult sr : srList){
          
             if(sr.isSuccess()){
                
                successRecords.add(sr.getId());
                sRecords++;                
             }else{
             
               for(Database.error err : sr.getErrors()){
               
               }
               
               failureRecords.add(sr.getId());
               fRecords++;
             
             }
             
          }
   }
   
   public void finish(Database.BatchableContext bc){
   
      //system.debug('Success :'+successRecords);
      //system.debug('Failure :'+failureRecords);
      
      system.debug('Success :'+sRecords);
      system.debug('Failure :'+fRecords);
      
      
      
      
    /**  Messaging.SingleEmailMessage msm = new Messaging.SingleEmailMessage();
      List<String> address = new List<String>{'suneel54@gmail.com'};
      msm.SetToAddresses(address);
      msm.setSubject('Hi');
      msm.setPlainTextBody('Number of Successful records are '+successRecords+' Failure Records : '+failureRecords);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msm}); */
   }
}