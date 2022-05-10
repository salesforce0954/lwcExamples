trigger updateOldandNewPhone on Account (before update) {
  
   /** for(Account a : Trigger.New){
      a.phone = trigger.newMap.get(a.id).phone;
      a.AccountNumber = trigger.oldMap.get(a.id).phone;
    } */
        if(trigger.isbefore && trigger.isupdate)
      {
    oldandnewphonehelper.updateNewOld(Trigger.new,Trigger.newMap,Trigger.oldMap);
    }
}