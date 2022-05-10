trigger TestTrigger on Contact (before insert) {
   
   for(Contact acc:Trigger.New){
     acc.firstName = 'SunRec';
   }
}