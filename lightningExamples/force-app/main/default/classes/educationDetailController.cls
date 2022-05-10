public class educationDetailController {

public string id;
public List<EducationDetails__c> eduListDetails {get;set;}
public EducationDetails__c eduDetail {get;set;}
public jobApplication__c  JobApp {get;set;}
//public Education__c eduApp {get;set;}

   

   public void Add(){
   string nid = ApexPages.currentPage().getParameters().get('id'); 
   EducationDetails__c eduDetails = new EducationDetails__c(); 
   eduDetails.Education__c = [select id from Education__c where JobApplication__c in (select id from JobApplication__c where id=:nid)].id;
   //eduListDetails = new List<EducationDetails__c>();
   
   eduListDetails.add(eduDetails);
   
   }

public educationDetailController(){
        eduDetail = new EducationDetails__c();
        eduListDetails = new List<EducationDetails__c>();
       // eduListDetails.add(eduDetail);
        id = ApexPages.currentPage().getParameters().get('id');
        eduDetail.Education__c = [select id from Education__c where JobApplication__c in (select id from JobApplication__c where id=:id)].id;
        //eduApp = [select Qualification__c from Education__c where id = :id];
        JobApp = [SELECT First_Name__c,Last_Name__c,(select Qualification__c,Previous_Employment_Salary__c from Educations__r) FROM JobApplication__c  where id=:id];

}

 public PageReference save() {
 system.debug('***********************************************'+eduListDetails);
        upsert eduListDetails;
        PageReference ref = Page.salaryBreakupAPP;
        ref.getParameters().put('id', JobApp.id);
        //PageReference.getParameters().put('id', jobApp.id);
        ref.setRedirect(true);
        return ref;
    }
}