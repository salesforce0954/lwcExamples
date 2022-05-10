public class IdentifyDuplicate{

public List<Account> originalLst {get;set;}
public Set<String> setObj{get;set;}
public List<Account> dupList {get;set;}

public IdentifyDuplicate(){
originalLst = [select Name from Account];
setObj = new Set<String>();
dupList = new List<Account>();

for(Account ol:originalLst){
 
  if(setObj.contains(ol.Name))
  {
    dupList.add(ol);
    System.debug('duplist' + duplist);
    System.debug('+++++++Alert 1 ++++++++++');
  }
  else
  {
   setObj.add(ol.Name);
   System.debug('setObj' + setObj);
   System.debug('@@@@@@Alert 2@@@@@@@@@@@');
  }
     
}
  System.debug('Alert 3');
delete dupList;
}

}