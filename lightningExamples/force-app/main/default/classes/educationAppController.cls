public class educationAppController {

    public PageReference Cancel() {
        PageReference ref = Page.educationApp;
        ref.setRedirect(true);
        return ref;
    }


public string id{get; set;}
public Education__c  edu {get;set;}
public jobapplication__c japp{get; set;}

    public PageReference save() {
        insert edu;
         PageReference ref = Page.educationDetailApp;
        ref.getParameters().put('id', japp.id);
        //PageReference.getParameters().put('id', jobApp.id);
        ref.setRedirect(true);
        return ref;
    }
  
  public educationAppController(){
  id = ApexPages.currentPage().getParameters().get('id');
  japp = [select first_name__c, last_name__c from jobapplication__c where id=:id];
      
  edu = new Education__c();
  edu.JobApplication__c = id;
  }
  
}