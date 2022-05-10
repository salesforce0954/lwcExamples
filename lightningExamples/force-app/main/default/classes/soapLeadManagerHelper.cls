public class soapLeadManagerHelper{
  
   public static partnerSoapSforceCom.LoginResult getSessionId(){
    string username = 'salesforce0954@gmail.com';
    string password = 'Swinburne$*0909jfpZfLavbGWQI8qFuyT3WkFQ';
    partnerSoapSforceCom.soap psf = new partnerSoapSforceCom.soap();
    partnerSoapSforceCom.LoginResult loginRes = psf.login(username,password);
    string sessionId = loginRes.sessionId;
    system.debug(sessionId);
    return loginRes;   
   }
   
   public static soapLeadManager.SessionHeader_element getSessionObj(){
    soapLeadManager.SessionHeader_element sessionObj = new soapLeadManager.SessionHeader_element();
    partnerSoapSforceCom.LoginResult plr = soapLeadManagerHelper.getSessionId();
    sessionObj.sessionId = plr.sessionId;
    system.debug(sessionObj);
    return sessionObj;
   }
   
   public static soapLeadManager.firstSoapWebService insertLeadIntoServer(){
    soapLeadManager.firstSoapWebService  slm = new soapLeadManager.firstSoapWebService();
    soapLeadManager.SessionHeader_element sobj = soapLeadManagerHelper.getSessionObj();
    slm.SessionHeader = sobj;
    string result = slm.createLead('Debasisse','jenaaw','ctrlf11ww','debcet111111r@gwail.com','+971462896603');
    system.debug(result);
    return slm;
   }
   
   
   
   
}