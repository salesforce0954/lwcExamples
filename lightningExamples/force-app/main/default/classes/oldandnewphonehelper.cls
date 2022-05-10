public class oldandnewphonehelper{

  public static void updateNewOld(List<Account> newList,Map<Id,Account> newMap,Map<Id,Account> oldMap){
     
     for(Account a:newList){
      a.phone = newMap.get(a.id).phone;
     }
     
     for(Account b:newList){
      b.AccountNumber = oldMap.get(b.id).phone;
     }
  }

}