public class veriPhoneHelper{


  /** @invocablemethod(label='verify mobile')
    public static list<boolean> checkMobileNumber(list<String> mobileNumber){
       veriPhoneIntegration.veriPhoneWrapperClass vwc = veriPhoneIntegration.invokeVeriPhone(mobileNumber[0]);
       return new list<boolean> {vwc.phone_valid};
    } */
    
    @invocablemethod(label='verify mobile')
    public static void checkMobileNumber(list<string> phoneNumbers){
    system.debug('Test verify mobile');
      checkPhone(phoneNumbers);
    }
    
    @future(callout=true)
    public static void checkPhone(List<string> phoneNumbers){
      veriPhoneIntegration.veriPhoneWrapperClass vwc = veriPhoneIntegration.invokeVeriPhone(phoneNumbers[0]);
      
      List<Account> listAcc = new List<Account>();
      Account acc = [select Phone_Valid__c from Account where Id = '0017F00003dbfhbQAA'];
      acc.phone_valid__c = vwc.phone_valid;
      
      listAcc.add(acc);
      system.debug('List Acc '+listAcc);
       update listAcc;      
      
      
    }
 
    
 

}