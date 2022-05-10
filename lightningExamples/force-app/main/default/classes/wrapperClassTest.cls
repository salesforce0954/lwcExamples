public class wrapperClassTest{
  
   public List<accountWrapper> awList {get;set;}
   public List<account> accList {get;set;}
   public List<account> accountSelected {get;set;}
   
   
   public wrapperClassTest(){
   
      accList = [select id,name from Account];
         awList = new List<accountWrapper>();

      
      for(Account a:accList){
        awList.add(new accountWrapper(a));
      }
     
   }
   
   public void getSelectedAccounts(){
     accountSelected = new List<Account>();
      for(accountWrapper aw:awList){
         if(aw.selectedAccounts == true){
           accountSelected.add(aw.acc);
         }
         
      }
   }
  
  
  public class accountWrapper{
     public Account acc {get;set;}
     public boolean selectedAccounts {get;set;}
     
     
     public accountWrapper(Account acc){
       this.acc = acc;
       selectedAccounts = false;
     }
  }
}