trigger updateAccRating on Opportunity (after insert,after update) {
set<id> accountIds = new set<Id>();
List<Account> accList = new List<Account>();
for(Opportunity opp: Trigger.New){
  if(opp.StageName == 'Closed Won'){
    accountIds.add(opp.AccountId);
  }
}
List<Account> accnt = [select id,Rating from Account where id = :accountIds];
if(accnt != null){
  for(Account acc:accnt){
    acc.Rating = 'Hot';
    accList.add(acc);
  }
  update accList;
}
}