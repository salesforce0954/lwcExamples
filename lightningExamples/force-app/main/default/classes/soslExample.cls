public class soslExample{

  public string name {get;set;}
  public string id {get;set;}
  public integer accsize  {get;set;}
  public integer consize {get;set;}
  
  
  
  public List<Account> accList {get;set;}
  public List<Contact> conList {get;set;}
  public void searchName(){
    
   String searchStr1 = '*'+name+'*';
   String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name),Contact(lastname)';
   List<List <sObject>> searchList = search.query(searchQuery);
     
     //List<List<sObject>> searchName = [Find '+name+' IN  ALL FIELDS returning Account(id,name),Contact(lastname)];
     
         accsize = 0;
         consize = 0;
         
      accList = (List<Account>)searchList[0];
      accsize = accList.size();
      system.debug('Account size '+accsize);
      conList = (List<Contact>)searchList[1];
      consize = conList.size();
      system.debug('Contact size '+consize);
     
     for(Account acc : accList){
       name = acc.name;
       id = acc.id;
       system.debug('Name '+name);
       system.debug('Id '+id);
     }
     
     for(Contact con : conList){
       name = con.lastname;
       system.debug('lastName '+name);
     } 
  }
}