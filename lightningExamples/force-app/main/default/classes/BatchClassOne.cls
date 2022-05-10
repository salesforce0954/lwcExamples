global class BatchClassOne implements Database.Batchable<Account>{

  public iterable<Account> start(Database.batchableContext bc){
    return new customIterable();
  }
  
  public void execute(Database.BatchableContext bc,List<Account> scope){
  }
  
  public void finish(Database.BatchableContext bc){
  }

}