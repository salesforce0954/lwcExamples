public class createNewAccount{

 public string name {get;set;}
 public List<Account> accList {get;set;}
 
 public createNewAccount(){
   
  accList = [select Name from Account];
  for(Account acc : accList){
  
    acc.Name = name;
  }
  
 }
 
 
}