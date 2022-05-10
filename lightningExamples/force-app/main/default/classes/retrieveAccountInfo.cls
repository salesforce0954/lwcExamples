public class retrieveAccountInfo{
 public String deleteAcc{get;set;}
 public string listView {get;set;}
 Account acc;

  public List<Account> accList {get;set;}

    public retrieveAccountInfo(ApexPages.StandardController controller) {
    
        accList = [select id,Name from Account];

    }
  
  public pageReference doDelete(){
    acc = [select id,Name from Account where id =:deleteAcc];
    system.debug('Account'+acc);
    delete acc;

   return null;
  }
  public pageReference doListView(){
  acc = [select id,Name from Account where id =:listView];
  system.debug('ListView ' + listView);
    pagereference ref=new pagereference('/'+listView);
    ref.setredirect(true);
    return ref;  
    }

}