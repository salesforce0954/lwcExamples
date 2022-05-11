global class ScheduleProgramStrategy Implements Schedulable
{
/***** FUNCTION *****/
  global void execute(SchedulableContext sc)
  {
    CallBatch();
  }//End Func Execute
 
   public void CallBatch()
  {
      BatchUpdateProgramStrategy bolb = new BatchUpdateProgramStrategy();
      if(Test.isRunningTest()){
      bolb.propQry = 'Select a.id, a.Call_Strategy__c, a.Program_Strategy_cons__c,Promotion_Strategy__c from Account a where a.ParentId=NULL and a.Primary_Business_Unit__c=\'Consumer\' ';
      }else{
        bolb.propQry = 'Select a.id, a.Call_Strategy__c, a.Program_Strategy_cons__c,Promotion_Strategy__c from Account a where a.ParentId=NULL and a.Primary_Business_Unit__c=\'Consumer\' ';
      }
      ID batchprocessid = Database.executeBatch(bolb);      
  }
  
}