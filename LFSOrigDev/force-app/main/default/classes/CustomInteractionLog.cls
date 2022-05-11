public class CustomInteractionLog {

    public String caseId { 
        get {
            if(caseId == null) {
                caseId = ApexPages.currentPage().getParameters().get('id');
            }
            return caseId;
        }
        set; 
    }

    public void updateWhoWhatId() {
        Integer caseCount = [Select COUNT() from Case where id =:caseId];
        if (caseCount==0) {
            statusMessage = 'This log is not associated with a Case or Contact! Please save the case.';
            return;
        }
        Case myCase = [Select id, contactId from Case where id =:caseId];
        task.whoId = myCase.contactId;
        task.whatId = myCase.id;
    }

    private void initializeTask() {
        updateWhoWhatId();
        task.subject = Subject;
    }
    
    private String Subject { 
        get {
            Subject = 'Call at ' + DateTime.now();
            return Subject;
        }
        set; 
    }

    public CustomInteractionLog(ApexPages.StandardController controller) {
        initializeTask();
    }       

    public String ANI { get; set;}
    public String CallObject { get; set;} 
    public Integer CallDurationInSeconds { get; set;} 
    public String CallType { get; set;}  
    public String CallDisposition { get; set;}        
    
    public String statusMessage { get; set; }

    public Task task { 
        get {
            if(task == null) {
                task = new Task();
            }
            return task;
        }
        set; 
    }
    
    public void setCallAttachedData() {
        task.CallObject = CallObject;
        //task.ANI__c = ANI;
    }     

    public void setCallEndData() {
        task.CallDurationInSeconds = CallDurationInSeconds;
        task.CallDisposition = CallDisposition;    
        save();
    }
    
    public void save() {
        upsert task;
        statusMessage = 'Last save at ' + DateTime.now();
    }
    
     public void saveAndNew() {
        save();
        task = null;
        initializeTask();
        //task.ANI__c= ANI;
        task.CallObject = CallObject;
    }        
}