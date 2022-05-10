public class scheduleBatchApex implements Schedulable{

  public void execute(SchedulableContext sc){
    
     batchTestExample bte = new batchTestExample();
     database.executeBatch(bte);
  
    }

}