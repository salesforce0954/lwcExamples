public class jobAppListController {

    public PageReference removeContact() {
        return null;
    }


    public PageReference updateApp() {
    update jobApp;
        system.debug('*********************' + jobApp);
    update eduApp;
        system.debug('*********************' + eduApp);
    update eduDetails;
    system.debug('*********************' + eduDetails);
    
        return null;
    }


    public PageReference save() {
        return null;
    }

  public JobApplication__c jobApp {get;set;}
  public string id; 
  public Education__c eduApp {get;set;}
  //public list<EducationDetails__c> eduDetails {get;set;}
  public EducationDetails__c eduDetails {get;set;}
  public SalaryBreakup__c sbreakup {get;set;}
  
  public jobAppListController(){
     id = ApexPages.currentPage().getParameters().get('id');
     jobApp= [select First_Name__c,Last_Name__c from JobApplication__c where id=:id];
     eduApp= [select JobApplication__c,Qualification__c,Previous_Employment_Salary__c from Education__c where JobApplication__c = :id];
     sbreakup = [select Experience__c,Expected_Salary__c,Basic_Salary__c from SalaryBreakup__c where JobApplication__c = :id];
   // eduDetails = [select Skill_Set__c,Organization_Name__c from EducationDetails__c where Education__c in (select id from Education__c where JobApplication__c = :id)];    
     eduDetails = [select Skill_Set__c,Organization_Name__c from EducationDetails__c where Education__c in (select id from Education__c where JobApplication__c = :id) limit 1];    
  }
}