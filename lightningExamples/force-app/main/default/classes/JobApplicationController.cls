public class JobApplicationController {

    public PageReference cancel() {
        PageReference ref = Page.jobapplication;
        ref.setRedirect(true);
        return ref;
    }


    public PageReference save() {
        insert jobApp;
        // PageReference ref=new PageReference('https://c.ap5.visual.force.com/apex/success');
        PageReference ref = Page.educationAPP;
        ref.getParameters().put('id', jobApp.id);
        //PageReference.getParameters().put('id', jobApp.id);
        ref.setRedirect(true);
        return ref;
    }

  
   public JobApplication__c jobApp {get;set;}
   
   public JobApplicationController(){
    jobApp = new JobApplication__c();

   }
}