trigger insertAccount on Account (before insert) {

    for(Account a:Trigger.new){
      a.name = 'Kapil';
    }
  
}