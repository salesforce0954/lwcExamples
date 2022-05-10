public class fetchRelatedObjects {
   
    public static Map<id,application__c> mapApp {get;set;}
    public static Map<Id,Applicant__c> applicantMap {get;set;}
    public static List<Applicant__c> applicantList {get;set;}
    public static List<Loan_purpose__c> loanList  {get;set;}
    public static List<Expenses__c> expenseList {get;set;}
    public static List<Income__c> incomeList {get;set;}
    public static List<Application__c> appList {get;set;}
      
    public static List<Application__c> getApplicationRelatedRecords(boolean isEligible){
        
         mapApp = new Map<Id,Application__c>();
         appList = [select is_Applicant_Eligible__c from Application__c where is_Applicant_Eligible__c =:isEligible];
        if(appList.size() > 0){
            for(Application__c app:appList){
            if(app.is_Applicant_Eligible__c == true){
                mapApp.put(app.id,app);
            }            
        }   
        }
        
        system.debug('Map Application Size '+mapApp.size());
        if(mapApp.size() > 0){
         loanList = [select Loan_amount__c,Loan_Name__c from Loan_purpose__c where Application__c in : mapApp.keySet()];
         system.debug('Loan List @@ '+loanList);
         applicantList = [select First_Name__c,isDrivingLicense__c,Phone__c,State__c from Applicant__c where Application__c in : mapApp.keySet()];
         system.debug('Applicant List @@ '+applicantList);    
        }
        applicantMap = new Map<Id,Applicant__c>();
        
        if(applicantList != null){
        for(Applicant__c applicant:applicantList){
            applicantMap.put(applicant.id,applicant);
        }
        }
        
        if(applicantMap.size() >0){
          expenseList = [select Total_Expense__c from Expenses__c where Applicant__c in :applicantMap.keySet()];
          system.debug('Expense List @@ '+expenseList);
          incomeList = [select Employment_Type__c,Total_Income_Amount__c from Income__c where Applicant__c in :applicantMap.keySet()];
          system.debug('Income List @@ '+incomeList);
        }
        return appList;
    }
}