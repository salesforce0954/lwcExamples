/* @Description: Controller for document request 
 * @Author: Adrian Recio
 * @Date Created: 12-03-2014
 * @History:
   =====================================================================
       12-03-14: Created - Adrian
       DEC-15-14(Devendra Babu) : Modified where condition for displaying localized description for meta documents DBHZL-95
   =====================================================================
 */ 
public with sharing class APP_RequestedDocumentExt_INT extends APP_CommonExt{

    // Class Variable Declaration
    public List<Requested_Document__c> rdMainList;
    public List<Requested_Document__c> rdDeleteList;
    public String removeIndex {get; set;}
    transient public Boolean showList{get; set;}
    public List<RequestedDocumentWrapper> wrapperRD{get; set;}
    
    /*  Description: Class constructor
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter ApexPages.StandardController
     *  Return: na
     */
    public APP_RequestedDocumentExt_INT(ApexPages.StandardController applicationController) {
        super(applicationController);
        queryDocumentRequest();
        validateMode(); 
    }
    
    public void validateMode(){
        if(ApexPages.currentPage().getParameters().get('requestedDocumentMode')=='Edit'){
            showList = false;
        }else{
            showList = true;
        }
    }
    
    /*  Description: Method to check if applicaiton is joint
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Boolean getIsJoint(){
        if(applicantList.size()>1){
            return true;
        }
        
        return false;
    }
    
    /*  Description: Main Method to query requested document 
                     based on current application
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void queryDocumentRequest(){
        // Pull Requested Document Records
        
        /*if(getIsJoint()){
            rdMainList = pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' and (Applicant__c = \'' + applicant.Id + '\' or Applicant__c = \'' + applicant2.Id + '\') order by createdDate ASC' );
        }else{
            rdMainList = pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' and Applicant__c = \'' + applicant.Id + '\' order by createdDate ASC');
        }*/
        
        rdMainList = pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' order by createdDate ASC' ) != null ? pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' order by createdDate ASC' ):new List<Requested_Document__c>();
        wrapperRD = new List<RequestedDocumentWrapper>();
        if(rdMainList.size()>0){
            for(Requested_Document__c rd:rdMainList){
                RequestedDocumentWrapper rdw = new RequestedDocumentWrapper();
                rdw.rd = rd;
                rdw.applicantSelected = rd.Applicant__c;
                wrapperRD.add(rdw);
            }
        }
        /*if(rdMainList.size()==0){
            addMoreRequestDocument();
        }*/
    }
    
    /*  Description: Main method to construct query statement and pull field sets 
                     to query related requested document based on current application.
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public List<Requested_Document__c> pullRequestedDocumentRecords(string queryCondition){
        
        // Build query string
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : this.getRequestedDocumentFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,Applicant__r.First_Name__c,Applicant__r.Last_Name__c FROM Requested_Document__c where ' + queryCondition;
        
        return Database.query(query);
    }
    
    /*  Description: Pull Requested Document Field Set
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: 
     */
    public List<Schema.FieldSetMember> getRequestedDocumentFields() {
        return SObjectType.Requested_Document__c.FieldSets.Requested_Document.getFields();
    }
    
    /*  Description: Reset a null value to string 
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public string nullSetter(String checkStr){
        if(checkStr == null){
            return '';
        }
        
        return checkStr;
    }
    
    /*  Description: Pull related applicant options
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: 
     */
    public List<SelectOption> getJointApplicant(){
        List<SelectOption> options = new List<SelectOption>();
        
        String nameStr1 = '';
        String nameStr2 = '';
        
        nameStr1 = nullSetter(applicant.First_Name__c) + ' ' + nullSetter(applicant.Last_Name__c);
        
        if(applicant.First_Name__c==null && applicant.Last_Name__c==null){
            nameStr1 = 'Applicant 1';
        }
        
        options.add(new SelectOption(applicant.Id, nameStr1));
        
        if(getIsJoint()){
            
            nameStr2 = nullSetter(applicant2.First_Name__c) + ' ' + nullSetter(applicant2.Last_Name__c);
            
            if(applicant2.First_Name__c==null && applicant2.Last_Name__c==null){
                nameStr2 = 'Applicant 2';
            }
            
            options.add(new SelectOption(applicant2.Id,nameStr2));
            options.add(new SelectOption('Both','Both'));
        }

        return options;
    }   
    
    /*  Description: Method to add more new requested document to main list
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void addMoreRequestDocument(){
        RequestedDocumentWrapper rdw = new RequestedDocumentWrapper();
        if(getIsJoint()){
            //rdMainList.add(new Requested_Document__c(status__c='Draft',Application__c=application.Id));            
            rdw.rd =(new Requested_Document__c(status__c='Draft',Application__c=application.Id));
            rdw.applicantSelected = null;
        }else{
            //rdMainList.add(new Requested_Document__c(status__c='Draft',Application__c=application.Id,Applicant__c=applicant.Id));
            rdw.rd= (new Requested_Document__c(status__c='Draft',Application__c=application.Id,Applicant__c=applicant.Id));
            rdw.applicantSelected = applicant.Id;
        }
        wrapperRD.add(rdw);
    }
    
    /*  Description: Method to remove requested document based on index value
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void removeRequestedDocument(){
        system.debug('Index value:' + removeIndex);
        
        if(rdDeleteList == null){
            rdDeleteList = new List<Requested_Document__c>();
        }
        
        if(wrapperRD[Integer.valueOf(removeIndex)].rd.Id!=null){
            rdDeleteList.add(wrapperRD[Integer.valueOf(removeIndex)].rd);
        }
        wrapperRD.remove(Integer.valueOf(removeIndex));
        
        if(rdDeleteList.size()>0){
            /*CHECKMARX
            // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
            if(Requested_Document__c.sObjectType.getDescribe().isDeletable()){
                delete rdDeleteList;
                rdDeleteList = new List<Requested_Document__c>();
            }
            */
            delete rdDeleteList;
            rdDeleteList = new List<Requested_Document__c>();
        }        
    }
    
    /*  Description: Method to perform validation and save of requested document records
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference saveToRequested(){
        
        rdMainList = new List<Requested_Document__c>();
        for(RequestedDocumentWrapper rdw: wrapperRD){
            if(rdw.applicantSelected != 'Both'){
                rdw.rd.Applicant__c = rdw.applicantSelected;
            }
            rdMainList.add(rdw.rd);
        }
        
        Boolean hasError = validateRequestedDocument(rdMainList);
        
        if(hasError==false){
            for(Requested_Document__c rcVar: rdMainList){
                if(rcVar.Status__c == 'Draft'){
                    rcVar.Status__c = 'Requested';
                }
            }
            //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
            //if(Requested_Document__c.SObjectType.getDescribe().isCreateable()) {
                upsert rdMainList;
            //}
            if(rdDeleteList!=null){
                if(rdDeleteList.size()>0){
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Requested_Document__c.sObjectType.getDescribe().isDeletable()){
                        delete rdDeleteList;
                    }
                    */
                    delete rdDeleteList;
                }
            }
            
           /* try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_RequestedDocumentExt_INT', 'Application__c', 'Class', String.valueOf(this.application.Id));
            }
            */    
            
            return redirectMain();
        }
        
        return null;
    }
    
    /*  Description: Main method to perform requested document validation
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Boolean validateRequestedDocument(List<Requested_Document__c> rdList){
        Boolean hasError = false;
        for(Requested_Document__c rdVar: rdList){
            
            if(rdVar.Category__c==null){
                rdVar.Category__c.addError('Field Required.');
                hasError = true;
            }
            
            if(rdVar.Document_Type__c==null){
                rdVar.Document_Type__c.addError('Field Required.');
                hasError = true;
            }
            
            if(rdVar.Number_Required__c==null){
                rdVar.Number_Required__c.addError('Field Required.');
                hasError = true;
            }
        }
        
        return hasError;
    }
    
    /*  Description: Method to set requested document status to complete
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void completeDocument(){
        wrapperRd[Integer.valueOf(removeIndex)].rd.status__c = 'Complete';
        Requested_Document__c rdVar = wrapperRd[Integer.valueOf(removeIndex)].rd;
        update rdVar;
    }
    
   
    
    /*  Description: Method to refresh page and show edit page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference showEdit(){
        pageReference pgRef = Page.APP_RequestedDocument_INT;
        pgRef.getParameters().put('requestedDocumentMode', 'Edit');
        pgRef.getParameters().put('Id', application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Method to redirect to main page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference redirectMain(){
        pageReference pgRef = Page.APP_ApplicationMain_INT;
        pgRef.getParameters().put('Id', application.Id);
        pgRef.getParameters().put('document', 'true');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Getter method to pull requested document count
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Integer getRDCount(){
        return wrapperRd.size();
    }
    
    /*  Description: Method to set requested document description based on selected Document Type
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return:
     *  DEC-15-14(Devendra Babu) : Modified where condition for displaying localized description for meta documents DBHZL-95
     */
    public void descriptionValue(){
        system.debug('====='+wrapperRD[Integer.valueOf(removeIndex)].rd.Category__c+'======='+wrapperRD[Integer.valueOf(removeIndex)].rd.Document_Type__c+'===='+brand.Country__c);
        List<Meta_Document__c> mdList = [Select Id, Description__c from Meta_Document__c 
                                         where Category__c = :wrapperRD[Integer.valueOf(removeIndex)].rd.Category__c 
                                         and Document_Type__c = :wrapperRD[Integer.valueOf(removeIndex)].rd.Document_Type__c and Recordtype.Name =:brand.Country__c limit 1];
        
        if(mdList.size()>0){
            wrapperRd[Integer.valueOf(removeIndex)].rd.description__c = mdList[0].Description__c;
        }
    }
    
    /*  Description: Method to reset document type and description field
     *  Author: Adrian Recio
     *  Date Created: 17-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void refreshDescription(){
        wrapperRd[Integer.valueOf(removeIndex)].rd.Document_Type__c = null;
        wrapperRd[Integer.valueOf(removeIndex)].rd.description__c = null;
    }
    
    public class RequestedDocumentWrapper{
        public Requested_Document__c rd {get; set;}
        public String applicantSelected {get; set;}
        
        public requestedDocumentWrapper(){
            rd = new Requested_Document__c();
            //applicantSelected = '';
        }
    }
}