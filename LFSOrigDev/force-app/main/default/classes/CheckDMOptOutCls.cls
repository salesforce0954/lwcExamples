public Class CheckDMOptOutCls{
  public final Contact cont;
  private string strAlert = 'NOTPRESENT';
  private String consetAlert = 'NOTPRESENT';
  public String propAlert { get { return strAlert; } set { strAlert = value; } }


   public CheckDMOptOutCls(ApexPages.StandardController controller){
        System.debug('CHECKFORDMOPTOUT=======>');   
        this.cont = (Contact)controller.getRecord();
   }
   
   public void CheckOnload(){
       Contact a = [Select Direct_Marketing__c, id from Contact where Id=:this.cont.id];
           if(a.Direct_Marketing__c != null){
                propAlert = 'PRESENT';
           }  
       }
       
   }