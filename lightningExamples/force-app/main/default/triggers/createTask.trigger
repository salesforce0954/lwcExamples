trigger createTask on Opportunity (after insert,after update) {

  List<Task> taskList = new List<Task>();
  
   for(Opportunity opp:Trigger.new){
   
       if(opp.StageName == 'Closed won'){
         Task t = new Task();
         t.whatId = opp.id;
         t.subject = 'Follow up';
         taskList.add(t);
      } 
   }
   upsert taskList;

}