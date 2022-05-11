public class TestController {
    String errormessage{get; set;}
    public TestController(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This is page 1 error');
        ApexPages.addmessage(myMsg);
   }
   
   public PageReference page2error(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This is page 2 error');
        ApexPages.addmessage(myMsg);
        PageReference ref =  new PageReference('/Apex/TestPage1');
        ref.setRedirect(false);
        return ref;
   }
   public PageReference next(){
        PageReference ref =  new PageReference('/Apex/TestPage2');
        ref.setRedirect(true);
        return ref;
   }    
}