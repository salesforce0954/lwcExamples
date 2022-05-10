global class carDetails{

 public string name {get;set;}
 
  @RemoteAction
   global static List<Car__c> getCarDetails(String name){
   
     string Carname = '%'+name+'%';
    List<Car__c> carDetails = [select Build_Year__c,Description__c,Available_For_Rent__c from Car__c where name like :Carname];
    system.debug('Result '+carDetails);
     return carDetails;
   }

}