public class salaryBreakupController {
     
    public void getExperience() {
       System.debug('++++++++++++++++++++++++++ Experience +++++++++' + sb.Experience__c);
        if(sb.Experience__c == null)
       {
        System.debug('Experience is -----------------------None-------------------------'); 
        sb.Expected_Salary__c = 0.0;
        sb.Basic_Salary__c = 0.0; 
        BasicSalary = true;
        ExpectedSalary = true;
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       }else
       //if(sb.Experience__c.equals('1-5'))
       if(sb.Experience__c == '1-5' )
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.5 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
         BasicSalary = true;
        ExpectedSalary = true;
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       } else
       if(sb.Experience__c.equals('6-10'))
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.3 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       } else
       if(sb.Experience__c.equals('11-15'))
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.2 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       }else
       if(sb.Experience__c.equals('16-20'))
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.1 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       }else
       if(sb.Experience__c.equals('21-25'))
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.05 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       }else
       if(sb.Experience__c.equals('26-30'))
       {
        System.debug('Applicant Experience is ' + sb.Experience__c); 
        sb.Expected_Salary__c = (0.02 * emp.Previous_Employment_Salary__c) + emp.Previous_Employment_Salary__c;
        sb.Basic_Salary__c = (0.35 * sb.Expected_Salary__c); 
        System.debug('Expected Salary ' + sb.Expected_Salary__c); 
       }
    }


public string id;
 public SalaryBreakup__c sb {get;set;}
 public Education__c emp {get;set;}
 public jobapplication__c japp {get;set;}
 public boolean saldisplay {get; set;}
 public boolean BasicSalary {get;set;}
 public boolean ExpectedSalary {get;set;}

    public PageReference save() {
        insert sb;
          sb= [select JobApplication__c,Expected_Salary__c,Basic_Salary__c,Experience__c from SalaryBreakup__c where id = :sb.id];
         saldisplay = true;
         PageReference ref = Page.JobAppListView;
        ref.getParameters().put('id', japp.id);
        ref.setRedirect(true);
        return ref;

    }

 
 
 public salaryBreakupController(){
  
  saldisplay = false; 
  BasicSalary = false;
  ExpectedSalary = false;
  id = ApexPages.currentPage().getParameters().get('id');
  emp= [select Previous_Employment_Salary__c from Education__c where jobapplication__c = :id];
  japp = [select First_Name__c,Last_Name__c from jobApplication__c where id=:id];
  sb =new SalaryBreakup__c();
  sb.jobapplication__c = id;

 }
}