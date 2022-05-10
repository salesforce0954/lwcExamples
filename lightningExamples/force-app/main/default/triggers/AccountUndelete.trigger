trigger AccountUndelete on Account (after undelete) {

    List<Account> accList = new List<Account>();
    for(Account undeletedAccount : [SELECT ID, Name from Account where Id IN : trigger.new]){ 
        undeletedAccount.Name = ('Undeleted :' + undeletedAccount.Name);
        accList.add(undeletedAccount);
    } 
    update accList;
}