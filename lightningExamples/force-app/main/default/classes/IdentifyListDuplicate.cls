public class IdentifyListDuplicate{

  public List<Account> OriginalList {get;set;}
  public List<Account> dupList {get;set;}
  public List<Account> dup1List {get;set;}
  
  public IdentifyListDuplicate(){
  OriginalList = [select Name from Account];
  dupList= new List<Account>();
  dup1List = new List<Account>();
  dupList.addAll(OriginalList); 
          for(Account OL: OriginalList){
             for(Account dl:dupList){
            if(OL.Name.equals(dl.Name)){
            
              
             
            
            }
            }
           
           
           
          }
       delete dup1List;
  }
}