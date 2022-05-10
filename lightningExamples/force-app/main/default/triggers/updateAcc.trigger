trigger updateAcc on Account (before insert) {

 if(Trigger.isBefore && Trigger.isInsert){
  for(Account acc:Trigger.New){
  system.debug('Executing trigger');
     acc.name = 'Rahul';
     acc.phone = '12345';
  }
 }
}