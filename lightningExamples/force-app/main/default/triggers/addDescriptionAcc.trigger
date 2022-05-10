trigger addDescriptionAcc on Account (before delete) {

  if(Trigger.isDelete){
     for(Account acc:Trigger.old){
       acc.Description = 'Account Discription';
     }
  }
}