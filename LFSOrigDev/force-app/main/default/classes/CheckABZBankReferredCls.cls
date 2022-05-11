public Class CheckABZBankReferredCls{
  public final Account acct;
  //private string strAlert = 'NOTPRESENT';
  private String consetAlert = 'NOTPRESETN';
  public String conAlert { get { return consetAlert; } set { consetAlert = value; } }
  public String consComment {get; set;}
   public CheckABZBankReferredCls(ApexPages.StandardController controller){
        System.debug('CHECKFORANZBANK=======>');   
        this.acct = (Account)controller.getRecord();
   }
   
   public void CheckOnload(){
       Account a = [Select Consumer_Accreditation_cons__c,Consumer_Accreditation_Comments_cons__c, id from Account where Id=:this.acct.id];

       if(a.Consumer_Accreditation_cons__c){
           conAlert = 'PRESENT';
           consComment = a.Consumer_Accreditation_Comments_cons__c;           
       }
       
   }
}