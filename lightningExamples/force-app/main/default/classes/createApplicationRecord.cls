public virtual class createApplicationRecord {

     protected Application__c createApplication(){
        Application__c app = new Application__c();
        insert app;
        //database.insert(app);
        return app;
    }
    
    public static List<Applicant__c> createApplicant(String id){
        List<Applicant__c> applicantList = [select id,First_Name__c,Last_Name__c from Applicant__c where Application__c =: id];
        insert applicantList;
        return applicantList;
    }
    
  /*  public static List<Applicant__c> retreiveApplicant(String parentId){
        string query = 'select id,first_name__c,last_name__c from applicant__c where application__c =:parentId';
        return database.query(query);
    } */
    }