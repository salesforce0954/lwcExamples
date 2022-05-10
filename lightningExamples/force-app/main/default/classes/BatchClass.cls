global class BatchClass implements Database.Batchable<Account>{
   global Iterable<Account> start(Database.BatchableContext info){
       return new CustomIterable();
   }
   global void execute(Database.BatchableContext info, List<Account> scope){
       List<Account> accsToUpdate = new List<Account>();
       for(Account acc : scope){
           acc.Name = 'true';
           acc.NumberOfEmployees = 69;
           accsToUpdate.add(acc);
       }
       update accsToUpdate;
   }
   global void finish(Database.BatchableContext info){
   }
}