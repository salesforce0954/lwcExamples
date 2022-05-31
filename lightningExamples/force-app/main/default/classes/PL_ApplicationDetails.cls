public class PL_ApplicationDetails{

      public static string applicationDetails;
      public static string applicantDetails;
      
      @AuraEnabled(Cacheable=true)
      public static Application__c getApplicationInfo(Id appId){
          Application__c app = [select Applicant_Type__c,is_Applicant_Eligible__c from Application__c where id=:appId];
          return app;     
      }
      
      @AuraEnabled(Cacheable=true)
      public static List<Applicant__c> getApplicantInfo(List<Id> applicantList){
         system.debug('ApplicantList '+applicantList);
          List<Applicant__c> appList = [select First_Name__c,Last_Name__c,isPrimayApplicant__c,Phone__c,State__c,isDrivingLicense__c,Address__c,Application__c from Applicant__c where id in :applicantList];
          return appList;     
      } 
      
       @AuraEnabled(Cacheable=true)
      public static List<Income__c> getIncomeInfo(List<Id> incomeList){
          List<Income__c> incList = [select Id,name,Applicant__c,Employment_Type__c,Total_Income_Amount__c from Income__c where id in :incomeList];
          return incList;     
      } 
      
      @AuraEnabled(Cacheable=true)
      public static string sendPLAppsInformation(string applicantType,boolean isApplicantEligible){
          system.debug('Sending application details to Org 2');
              JSONGenerator gen = JSON.createGenerator(true);
              gen.writeStartObject();
              gen.writeStringField('applicantType',applicantType);
              gen.writeBooleanField('isApplicantEligible',isApplicantEligible);                           
              gen.writeEndObject();
              system.debug('Gen==> '+gen.getAsString());
              string requestJson = gen.getAsString();
              http h = new http();
              httpRequest hreq = new httpRequest();
              hreq.setMethod('POST');
              hreq.setEndpoint('callout:suneellwcApp/services/apexrest/plapps');
              hreq.setBody(requestJson);
              hreq.setHeader('Authorization','Bearer');
              hreq.setHeader('Content-Type','application/json');
              HttpResponse res = h.send(hreq);
              applicationDetails = res.getBody();
              system.debug('Application details $$$ '+applicationDetails);
              
              return applicationDetails;
      }
      
      @AuraEnabled
      public static string updateExternalID(string applicationId,string externalId){
         Application__c app= [select id,External_Id__c from Application__c where id=:applicationId];
         system.debug('Application Id $$$$ '+app.id);
         app.External_Id__c = externalId;
         update app;
         return app.External_Id__c;
      }
      
      @AuraEnabled(Cacheable=true)
      public static string sendPLAppsApplicantInformation(string applicationDetails,string firstName,string lastName){
        system.debug('Sending applicant details to Org 2');
        JSONGenerator gen = JSON.createGenerator(true);
              gen.writeStartObject();
              gen.writeStringField('applicationDetails',applicationDetails);
              gen.writeStringField('firstName',firstName);
              gen.writeStringField('lastName',lastName);
              gen.writeEndObject();
              system.debug('Gen==> '+gen.getAsString());
              string requestJson = gen.getAsString();
              http h = new http();
              httpRequest hreq = new httpRequest();
              hreq.setMethod('POST');
              hreq.setEndpoint('callout:suneellwcApp/services/apexrest/plappsApplicant');
              hreq.setBody(requestJson);
              hreq.setHeader('Authorization','Bearer');
              hreq.setHeader('Content-Type','application/json');
              HttpResponse res = h.send(hreq);
              applicantDetails = res.getBody();
        return applicantDetails;
      }
      
      @AuraEnabled
      public static string handleErrorLogs(string description,string id){
      system.debug('Error logs $$');
              Exception_logs__c e = new Exception_Logs__c();
              e.description__c = description;
              e.Application__c = id;
              insert e;
              system.debug('Description $$$ '+e.description__c);
              return e.description__c;
      }
      
      @AuraEnabled(Cacheable=true)
      public static string sendEmailToApplicant(List<Id> applicantIdList){
        List<Applicant__c> appList = [select First_Name__c,Application__r.Name,Last_Name__c,isPrimayApplicant__c,Phone__c,State__c,isDrivingLicense__c,Address__c,Application__c from Applicant__c where id in :applicantIdList];
        
        for(Applicant__c app:appList){
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          List<String> address = new List<String>{'suneel54@gmail.com'};
          mail.SetToAddresses(address);
          mail.setSubject('Application Number '+app.Application__r.Name);
          mail.setHtmlBody('<h1> Your Application has been created and below are applicant details </h1><p>Applicant Name :'+app.First_Name__c+ '</P><p>Applicant Phone :' +app.Phone__c +'</P><p> Thanks for applying the loan <p>');
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        return null;
      }
  
  }