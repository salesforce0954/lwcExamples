trigger accountRecursive on Account (before insert) {

     for(Account a:Trigger.New){
        a.Name = 'SuneelRecursive';
     }
}