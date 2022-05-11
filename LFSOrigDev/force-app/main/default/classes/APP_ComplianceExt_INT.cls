/* @Description: Controller for Digitized Compliance Checklist (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: DEC-13-2013
 * @History:
   =====================================================================
       12-13-13: Created - Mike
       12-16-13: Changed PFR Id from User Id to SSO Id and added logic for column rendering on page - Mike
       12-17-13: Added map for displaying the latest version of questions - Mike
       12-19-13: Changed value from Username to Name (full name) being saved to ID fields - Mike
       01-22-13: Added Acceptance Channel - Mike
       13-02-14: Added getCollateralRecords method - Adrian Recio
       13-02-14: Added update snippet in updateAcceptance method to apply changes to collateral - Adrian Recio
       13-02-14: Removed method Is_Secured__c condition when pulling Meta Compliance Pre Settle records - Adrian Recio           
   =====================================================================
 */ 
public with sharing class APP_ComplianceExt_INT {
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    transient public Boolean isNew {get;set;}   //Display if first set/column of fields are shown
    transient public Boolean newEditComplianceButton {get;set;} //Enable/disable of buttons
    transient public Boolean isPFR {get;set;}
    public String brandCountry {get;set;}
    
    public Application__c app {get;set;}    //Loaded application record
    public User currentUser {get;set;}  //Current Staff logged in
    public Boolean formState {get;set;} //Display view or input
    public Boolean acceptanceState {get;set;}   //Display view or input of Acceptance field
    public Map<String, List<checklistWrapper>> checklistMap {get;set;}  //Compliance check map
    public Map<String, List<checklistWrapper>> preChecklistMap {get;set;}   //Meta compliance pre settle map
    public Map<String, List<checklistWrapper>> postChecklistMap {get;set;}  //Meta compliance post settle map
    public List<Collateral__c> collateralList {get;set;}    //Collateral records
    public String acceptanceChannel {get;set;}
    
    public List<Compliance_Check__c> complianceCheckList; //Compliance check records
    public List<Meta_Compliance_Check_Line_Item__c> mccLineItems;               //Meta compliance check line items records
    public List<Meta_Compliance_Pre_Settle__c> mcPreLineItems;                  //Meta compliance check pre settle items records
    public List<Meta_Compliance_Post_Settle__c> mcPostLineItems;                //Meta compliance check post settle items records
    public Meta_Compliance_Check__c latestMCC;                                  //Latest version of Meta compliance check
    public Map<Id, Compliance_Check__c> complianceMap;
    public static string country;
    public boolean isDocsReceived {get;set;}    //MLASALA 30-JUN-16 DEFECT 922 FIX
    
    /*  Description: Main Controller class used for all initializations
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public APP_ComplianceExt_INT(ApexPages.StandardController applicationController) {
        app = (Application__c)applicationController.getRecord();    //Retrieve application record
        
        formState = false;
        acceptanceState = false;
        
        //Retrieve logged in user data
        currentUser = [SELECT   Id, 
                                SSO_Number__c, 
                                Name, 
                                Country__c, 
                                UserRole.Name 
                       FROM     User
                       WHERE    Id =: UserInfo.getUserId() LIMIT 1];
        
        country = currentUser.Country__c;
        system.debug('country controller: '+country);
        
        isPFR = false;
        if(currentUser.userRole != null && currentUser.userRole.Name != null){
            if(currentUser.UserRole.Name != null && currentUser.UserRole.Name.contains('PFR')){
                isPFR = true;
            }
        }
        System.debug('$$$ isPFR: '+isPFR);

        complianceCheckList = new List<Compliance_Check__c>();
        
        refreshComplianceCheckList();
        
        responseCodeProfileControl(app.Response_Code__c);
    }
        
    /*  Description: Pull child security/collateral records for display
     *  Author: Adrian Recio
     *  Date Created: FEB-13-2014
     *  Input: None
     *  Return: List of Collateral Records
     */
     public List<Collateral__c> getCollateralRecords(){
        collateralList = [SELECT    Id, 
                                    RecordType.Name, 
                                    Collateral_Reg_No__c, 
                                    PPSR_Reference_Number_1__c 
                          FROM      Collateral__c 
                          WHERE     Application__c = :app.Id];

        return collateralList;
     }
    
    /*  Description: Referesh Compliance Check records
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public void refreshComplianceCheckList(){
        
        country=currentUser.Country__c;
        system.debug('country refresh: '+country+' '+currentUser.id);
        
        //Reload application data
        app = [SELECT   Id,
                        Is_Secured__c,
                        Acceptance_Channel__c,
                        Broker__r.Account.RecordTypeId,
                        Collateral_Count__c,
                        Response_Code__c,
                        TC_Version_Number__c,
                        Generated_Doc_Confirm_Sent__c,
                        Brand_Country__c
               FROM     Application__c 
               WHERE    Id =: app.Id];

        brandCountry = app.Brand_Country__c;
    system.debug('brand country: '+country+' '+currentUser.id);
        //Reload compliance check records
        complianceCheckList = [SELECT   PFR_Check__c,
                                        PFR_ID__c,
                                        PFR_Date__c,
                                        BM_Check__c,
                                        BM_ID__c,
                                        BM_Date__c,
                                        Meta_Compliance_Check_Line_Item__c,
                                        Meta_Compliance_Check_Line_Item__r.PFR_Only__c,
                                        Meta_Compliance_Check_Line_Item__r.BM_Only__c,
                                        Meta_Compliance_Check__c,
                                        PFR_User_ID__c,
                                        BM_User_ID__c,
                                        Meta_Compliance_Pre_Settle__c,
                                        Meta_Compliance_Pre_Settle__r.PFR_Only__c,
                                        Meta_Compliance_Pre_Settle__r.BM_Only__c,
                                        Meta_Compliance_Post_Settle__c,
                                        Meta_Compliance_Post_Settle__r.PFR_Only__c,
                                        Meta_Compliance_Post_Settle__r.BM_Only__c,
                                        Pre_Settlement_Indicator__c
                               FROM     Compliance_Check__c
                               WHERE    Application__c =: app.Id
                               ORDER BY NAME];
        
        getCollateralRecords();

        complianceMap = new Map<Id, Compliance_Check__c>();
        
        if(!complianceCheckList.isEmpty()){
            //With existing compliance check record
            isNew = false;
            for(Compliance_Check__c c: complianceCheckList){
                complianceMap.put(c.Meta_Compliance_Check_Line_Item__c, c);
                complianceMap.put(c.Meta_Compliance_Pre_Settle__c, c);
                complianceMap.put(c.Meta_Compliance_Post_Settle__c, c);
            }
            
            //Retrieve meta compliance check line items from related meta compliance check
            mccLineItems = retrievemccLineItems(complianceCheckList.get(0).Meta_Compliance_Check__c);
            
            if(!mccLineItems.isEmpty()){
                checklistMap = new Map<String, List<checklistWrapper>>();
                //Map Line Item to it's respective Compliance Check record
                for(Meta_Compliance_Check_Line_Item__c m: mccLineItems){
                    checklistWrapper cw = new checklistWrapper();
                    
                    cw.mccLineItem = m;
                    if(complianceMap.containsKey(m.Id)){
                        cw.compCheck = complianceMap.get(m.Id);
                    }
                    
                    //Group meta compliance check line items by Section
                    if(checklistMap.containsKey(m.Section__c)){
                        checklistMap.get(m.Section__c).add(cw);                     
                    } else {
                        List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                        tempWrapper.add(cw);
                        checklistMap.put(m.Section__c, tempWrapper);
                    }
                }
            }
            
            //Retrieve meta compliance check post settle from related meta compliance check
            mcPostLineItems = retrievemcPostLineItems(complianceCheckList.get(0).Meta_Compliance_Check__c);
            
            if(!mcPostLineItems.isEmpty()){
                postChecklistMap = new Map<String, List<checklistWrapper>>();
                //Map Post Settle to it's respective Compliance Check record
                for(Meta_Compliance_Post_Settle__c m: mcPostLineItems){
                    checklistWrapper cw = new checklistWrapper();
                    
                    cw.mcpostLineItem = m;
                    if(complianceMap.containsKey(m.Id)){
                        cw.compCheck = complianceMap.get(m.Id);
                    }
                    
                    //Group meta compliance check post settle by Section
                    if(postChecklistMap.containsKey(m.Section__c)){
                        postChecklistMap.get(m.Section__c).add(cw);                     
                    } else {
                        List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                        tempWrapper.add(cw);
                        postChecklistMap.put(m.Section__c, tempWrapper);
                    }
                }
            }

            checkPreSettlement();
        } else {
            //No existing compliance check record
            isNew = true;

            //Get latest version of meta compliance check
            List<Meta_Compliance_Check__c> mccList = [SELECT    Id 
                                                      FROM      Meta_Compliance_Check__c 
                                                      WHERE     (Start_Date__c = null OR Start_Date__c <= TODAY)
                                                      AND       (End_Date__c = null  OR End_Date__c >= TODAY) LIMIT 1];
            
            checklistMap = new Map<String, List<checklistWrapper>>();
            postChecklistMap = new Map<String, List<checklistWrapper>>(); 
            system.debug('vijay :'+mccList);
            if(!mccList.isEmpty()){
                latestMCC = mccList.get(0);     //assign to public variable
                
                //Retrieve meta compliance check line items from latest meta compliance check
                mccLineItems = retrievemccLineItems(latestMCC.Id);
                
                //Map each Line Item to a new Compliance Check record
                if(!mccLineItems.isEmpty()){
                    for(Meta_Compliance_Check_Line_Item__c m: mccLineItems){
                        checklistWrapper cw = new checklistWrapper();
                        cw.mccLineItem = m;

                        //Assign default values to new records
                        cw.compCheck = new Compliance_Check__c(Meta_Compliance_Check_Line_Item__c = m.Id, 
                                                               Meta_Compliance_Check__c = latestMCC.Id,
                                                               Application__c = app.Id,
                                                               Pre_Contract_Indicator__c = true); 

                        //Identify whether line item is for PFR/BM only
                        if(!m.BM_Only__c){
                            cw.compCheck.PFR_Only__c = true;
                        }
                        
                        if(!m.PFR_Only__c){
                            cw.compCheck.BM_Only__c = true;
                        }
                        
                        complianceCheckList.add(cw.compCheck);
                        
                        //Group meta compliance check line items by Section
                        if(checklistMap.containsKey(m.Section__c)){
                            checklistMap.get(m.Section__c).add(cw);                     
                        } else {
                            List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                            tempWrapper.add(cw);
                            checklistMap.put(m.Section__c, tempWrapper);
                        }
                    }
                }
                
                checkPreSettlement();

                //Retrieve meta compliance check post settle from related meta compliance check
                mcPostLineItems = retrievemcPostLineItems(latestMCC.Id);
                
                if(!mcPostLineItems.isEmpty()){
                    for(Meta_Compliance_Post_Settle__c m: mcPostLineItems){
                        checklistWrapper cw = new checklistWrapper();
                        cw.mcpostLineItem = m;

                        //Assign default values to new records
                        cw.compCheck = new Compliance_Check__c(Meta_Compliance_Post_Settle__c = m.Id, 
                                                               Meta_Compliance_Check__c = latestMCC.Id,
                                                               Application__c = app.Id); 
                        
                        //Identify whether post settle is for PFR/BM only
                        if(!m.BM_Only__c){
                            cw.compCheck.PFR_Only__c = true;
                        }
                        
                        if(!m.PFR_Only__c){
                            cw.compCheck.BM_Only__c = true;
                        }
                        
                        complianceCheckList.add(cw.compCheck);
                        
                        //Group meta compliance check post settle by Section
                        if(postChecklistMap.containsKey(m.Section__c)){
                            postChecklistMap.get(m.Section__c).add(cw);                     
                        } else {
                            List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                            tempWrapper.add(cw);
                            postChecklistMap.put(m.Section__c, tempWrapper);
                        }
                    }
                }
            } else {
                //Display error message if this no Meta compliance check records
                Util.addMessage(ApexPages.Severity.ERROR, GEN_OriginationsConstants.COMPLIANCE_ERROR_MESSAGE);
            }
        }
    }
    
    /*  Description: Pre Settlement checking and population
     *  Author: Mike Lasala
     *  Date Created: APR-29-2014
     *  Input: None
     *  Return: void
     */
    public void checkPreSettlement(){
        if(!collateralList.isEmpty() || 
            app.Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE || 
            brandCountry == GEN_OriginationsConstants.NZ_REGION){
            
            //Retrieve meta compliance check pre settle from related meta compliance check
            mcPreLineItems = retrievemcPreLineItems(complianceCheckList.get(0).Meta_Compliance_Check__c); 
            
            List<Compliance_Check__c> preSettleList = new List<Compliance_Check__c>();
            preSettleList = [SELECT Id 
                             FROM   Compliance_Check__c 
                             WHERE  Meta_Compliance_Pre_Settle__c != null
                             AND    Application__c =: app.Id];

            
            if(!preSettleList.isEmpty()){
                preChecklistMap = new Map<String, List<checklistWrapper>>();
                //Map Pre Settle to it's respective Compliance Check record
                for(Meta_Compliance_Pre_Settle__c m: mcPreLineItems){
                    checklistWrapper cw = new checklistWrapper();
                    
                    cw.mcpreLineItem = m;
                    if(complianceMap.containsKey(m.Id)){
                        cw.compCheck = complianceMap.get(m.Id);
                    }
                    
                    //Group meta compliance check pre settle by Section
                    if(preChecklistMap.containsKey(m.Section__c)){
                        preChecklistMap.get(m.Section__c).add(cw);                      
                    } else {
                        List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                        tempWrapper.add(cw);
                        preChecklistMap.put(m.Section__c, tempWrapper);
                    }
                }
            } else {
                //Get latest version of meta compliance check
                List<Meta_Compliance_Check__c> mccList = [SELECT    Id 
                                                          FROM      Meta_Compliance_Check__c 
                                                          ORDER BY  Version__c DESC LIMIT 1];
                
                preChecklistMap = new Map<String, List<checklistWrapper>>();
                
                if(!mccList.isEmpty()){
                    latestMCC = mccList.get(0);     //assign to public variable
                    //Retrieve meta compliance check pre settle from related meta compliance check
                    mcPreLineItems = retrievemcPreLineItems(latestMCC.Id);
                    
                    if(!mcPreLineItems.isEmpty()){
                        for(Meta_Compliance_Pre_Settle__c m: mcPreLineItems){
                            checklistWrapper cw = new checklistWrapper();
                            cw.mcpreLineItem = m;

                            //Assign default values to new records
                            cw.compCheck = new Compliance_Check__c(Meta_Compliance_Pre_Settle__c = m.Id, 
                                                                   Meta_Compliance_Check__c = latestMCC.Id,
                                                                   Application__c = app.Id,
                                                                   Pre_Settlement_Indicator__c = true); 
                            
                            //Identify whether pre settle is for PFR/BM only
                            if(!m.BM_Only__c){
                                cw.compCheck.PFR_Only__c = true;
                            }
                            
                            if(!m.PFR_Only__c){
                                cw.compCheck.BM_Only__c = true;
                            }
                            
                            complianceCheckList.add(cw.compCheck);
                            
                            //Group meta compliance check pre settle by Section
                            if(preChecklistMap.containsKey(m.Section__c)){
                                preChecklistMap.get(m.Section__c).add(cw);                      
                            } else {
                                List<checklistWrapper> tempWrapper = new List<checklistWrapper>();
                                tempWrapper.add(cw);
                                preChecklistMap.put(m.Section__c, tempWrapper);
                            }
                        }
                    }
                }   
            }
        }
    }

    /*  Description: Enable editable fields
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public void showForm(){
        refreshComplianceCheckList();
        
        //BEGIN MLASALA 30-JUN-16 DEFECT 922 FIX
        isDocsReceived = true;
        
        List<Related_Document__c> relatedDocumentList = [SELECT  Status__c
                                                         FROM    Related_Document__c 
                                                         WHERE   GE_Link_Type__c =: DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED
                                                         AND     Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN 
                                                         AND     Application__c = :app.Id];
        
        if(!relatedDocumentList.isEmpty()){
            for(Related_Document__c rd : relatedDocumentList) {
                if(rd.Status__c != GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_RECEIVED){
                    isDocsReceived = false;
                    break;
                }
            }
        }
        //END MLASALA 30-JUN-16 DEFECT 922 FIX
        
        formState = true;
    }
    
    /*  Description: Enable Acceptance Channel field
     *  Author: Mike Lasala
     *  Date Created: JAN-22-2013
     *  Input: None
     *  Return: void
     */
    public void showAcceptance(){
        acceptanceState = true;
    }
    
    /*  Description: Set Compliance Check fields and upsert of records
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public void save(){
        //Update application if TC Version Number is not empty (for Offline Acceptance)
        if(Util.nullCheck(app.TC_Version_Number__c)){   //05.14.15 Mike Lasala: Code Scan fix
            try{
                update app;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ComplianceExt_INT', 'Application__c', 'Class', String.valueOf(app.Id));    
            }
        }

        try{
            //Set PFR fields if Check is not null
            if(!complianceCheckList.isEmpty()){
                for(Compliance_Check__c c: complianceCheckList){
                    if(c.PFR_Check__c != null){
                        if(c.Id == null){
                            c.PFR_Date__c = Date.today();
                            c.PFR_ID__c = UserInfo.getName(); 
                            c.PFR_User_ID__c = currentUser.Id;
                        }
                    }

                    if(c.BM_Check__c != null){
                        if(c.Id == null){
                            c.BM_Date__c = Date.today();
                            c.BM_ID__c = UserInfo.getName(); 
                            c.BM_User_ID__c = currentUser.Id;
                        }
                    }
                }
                
                upsert complianceCheckList;
            }
            
            // Update child collateral records
            if(collateralList!=null){
                update collateralList;
            }

            refreshComplianceCheckList();   //Reload all records

            formState = false;  //Display view state
        } catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_ComplianceExt_INT', 'Compliance_Check__c', 'Class', String.valueOf(app.Id));    
        }
        
      //  try {
      //      app.Out_Of_Sync__c = true;
            //update app;
      //  } catch(DMLException e){
      //      ErrorHandlerException.recordException(e.getMessage(), 'APP_ComplianceExt_INT', 'Application__c', 'Class', String.valueOf(app.Id));
      //  }
    }
    
    /*  Description: Update Application
     *  Author: Mike Lasala
     *  Date Created: JAN-22-2013
     *  Input: None
     *  Return: void
     */
    public void updateAcceptance(){
        
        app.Acceptance_Channel__c = acceptanceChannel;
        
        if(app.Acceptance_Channel__c != GEN_OriginationsConstants.OFFLINE_ACCEPTANCE && 
           brandCountry != GEN_OriginationsConstants.NZ_REGION){
            flushPreSettleCompliance();
        }

        try{
        //  app.Out_Of_Sync__c = true;
            update app;
            
            refreshComplianceCheckList();   //Reload all records
            
            acceptanceState = false;
        } catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_ComplianceExt_INT', 'Application__c', 'Class', String.valueOf(app.Id));    
        }
    }
    
    /*  Description: Disable editable fields and show data table
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public void cancel(){
        formState = false;
    }
    
    /*  Description: Enable Acceptance Channel field
     *  Author: Mike Lasala
     *  Date Created: JAN-22-2013
     *  Input: None
     *  Return: void
     */
    public void cancelAcceptance(){
        acceptanceState = false;
    }
    
    /*  Description: Flush Pre Settle compliance check records
     *  Author: Mike Lasala
     *  Date Created: APR-29-2014
     *  Input: None
     *  Return: void
     */
    public void flushPreSettleCompliance(){
        System.debug('Coming into Flush Compliance');
        List<Compliance_Check__c> preSettleList = new List<Compliance_Check__c>();
        preSettleList = [SELECT Id 
                         FROM   Compliance_Check__c 
                         WHERE  Meta_Compliance_Pre_Settle__c != null
                         AND    Application__c =: app.Id];
        System.debug('Presettlement List = ' + preSettleList);
        if(!preSettleList.isEmpty()){
            try{
                delete preSettleList;
                
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ComplianceExt_INT', 'Compliance_Check__c', 'Class', String.valueOf(app.Id));    
            }
        }
    }

    /*  Description: This will control button rendering
     *  Author: Jade Serrano
     *  Date Created: 21-Jan-2014
     *  Input Parameters: String
     *  Return: Void
     */
    public void responseCodeProfileControl(String status) {
        List<Response_Code_Control__c> rList = new List<Response_Code_Control__c>();
        rList = [Select Id From Response_Code_Control__c Where Name =: status];
        if(rList.size()>0){
            Boolean resNewEditCompliance = Response_Code_Control__c.getInstance(status).New_Edit_Compliance__c;

            Boolean proNewEditCompliance = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_Edit_Compliance__c;

            system.debug('!@#resNewEditCompliance: '+resNewEditCompliance+' proNewEditCompliance:'+proNewEditCompliance);
            if(resNewEditCompliance && proNewEditCompliance){
                newEditComplianceButton = false;
            }else{
                newEditComplianceButton = true;
            }
        }            
    }
    
    /*  Description: Get PFR Check picklist values
     *  Author: Mike Lasala
     *  Date Created: DEC-13-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getPFRCheck() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Compliance_Check__c.PFR_Check__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    /*  Description: Get Acceptance Channel picklist values
     *  Author: Mike Lasala
     *  Date Created: JAN-21-2014
     *  Input Parameters: None
     *  Return: SelectOption
     * Commented out by Lavanya for Jira - 71
    public List<SelectOption> getAcceptanceChannels() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Application__c.Acceptance_Channel__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //Retrieve Originations - Broker record type Id
        Schema.DescribeSObjectResult appSchema = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> accountRecordTypeInfo = appSchema.getRecordTypeInfosByName();
        String brokerRTId = accountRecordTypeInfo.get(GEN_OriginationsConstants.COMPLIANCE_BROKER).getRecordTypeId();
        
        for(Schema.PicklistEntry p : ple){
            //if(app.Broker__r.Account.RecordTypeId != null){
            //  if(brokerRTId == app.Broker__r.Account.RecordTypeId && p.getValue() == GEN_OriginationsConstants.COMPLIANCE_OFFLINE_ACCEPTANCE){
                    options.add(new SelectOption(p.getValue(), p.getValue()));
            //  }
            //} else {
            //  options.add(new SelectOption(p.getValue(), p.getValue()));
            //}
        }
        return options; 
    }
    
    /*
        Description: Get Acceptance Channel Picklist values based on Single / Joint Application Type, Jira Number: 71
        Author: Lavanya Kavuri
        Date Created: 18 March 2015
        Input Parameters: None
        Return: Select Options
    */
    
    public List<SelectOption> AcceptanceChannels
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', 'Please Select'));
            //Changed by Fahad: to make both online and offline channel available for both Single and Joint for AU and NZ.
            options.add(new SelectOption(GEN_OriginationsConstants.ONLINE_ACCEPTANCE, GEN_OriginationsConstants.ONLINE_ACCEPTANCE));
            options.add(new SelectOption(GEN_OriginationsConstants.OFFLINE_ACCEPTANCE, GEN_OriginationsConstants.OFFLINE_ACCEPTANCE));
        
        return options;
        }set;
        
    }
    
    /*  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input:   fieldSetMembers - object field set of related object
                 objectName - object name of related object to query
                 parentObjectFieldName - field name of the parent / lookup
                 parentRecordId - parent record id
     *  Return: List<sObject>
     */
    public static List<sObject> queryRelatedRecords (List<Schema.FieldSetMember> fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma Added by Vijay
        if(objectName == 'Meta_Compliance_Check_Line_Item__c' || objectName == 'Meta_Compliance_Post_Settle__c'){
         query += ' FROM ' + objectName + ' WHERE isActive__c=true AND'+' '+ parentObjectFieldName + ' =: parentRecordId AND region__c=\''+country+'\' ORDER BY CreatedDate ASC';
         system.debug('query:::: '+country+' --- '+query);
        }else{
         query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId AND region__c=\''+country+'\' ORDER BY CreatedDate ASC';
         system.debug('query:::: '+country+' --- '+query);
        }
        return Database.query(query);
    }
    
    /*  Description: retrieves lists of Meta Compliance Check Line Item
     *  Author: Mike Lasala
     *  Date Created: JAN-21-2014
     *  Input: None
     *  Return: List<Meta_Compliance_Check_Line_Item__c>
     */
    public static List<Meta_Compliance_Check_Line_Item__c> retrievemccLineItems(Id complianceCheckId) {
        List<Meta_Compliance_Check_Line_Item__c> mccLineItems = new List<Meta_Compliance_Check_Line_Item__c>();
        if(complianceCheckId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Meta_Compliance_Check_Line_Item__c.FieldSets.Check_Line_Item_Commons.getFields(), 'Meta_Compliance_Check_Line_Item__c', 'Meta_Compliance_Check__c', complianceCheckId)) {
                mccLineItems.add((Meta_Compliance_Check_Line_Item__c)o);
            }
        }
        system.debug('Line Item Match:' + mccLineItems);
        return mccLineItems;
    }
    
    /*  Description: retrieves lists of Meta Compliance Pre Settle
     *  Author: Mike Lasala
     *  Date Created: JAN-21-2014
     *  Input: None
     *  Return: List<Meta_Compliance_Pre_Settle__c>
     */
    public static List<Meta_Compliance_Pre_Settle__c> retrievemcPreLineItems(Id complianceCheckId) {
        List<Meta_Compliance_Pre_Settle__c> mcPreLineItems = new List<Meta_Compliance_Pre_Settle__c>();
        if(complianceCheckId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Meta_Compliance_Pre_Settle__c.FieldSets.Pre_Settle_Commons.getFields(), 'Meta_Compliance_Pre_Settle__c', 'Meta_Compliance_Check__c', complianceCheckId)) {
                mcPreLineItems.add((Meta_Compliance_Pre_Settle__c)o);
            }
        }
        return mcPreLineItems;
    }
    
    /*  Description: retrieves lists of Meta Compliance Post Settle
     *  Author: Mike Lasala
     *  Date Created: JAN-21-2014
     *  Input: None
     *  Return: List<Meta_Compliance_Post_Settle__c>
     */
    public static List<Meta_Compliance_Post_Settle__c> retrievemcPostLineItems(Id complianceCheckId) {
        List<Meta_Compliance_Post_Settle__c> mcPostLineItems = new List<Meta_Compliance_Post_Settle__c>();
        if(complianceCheckId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Meta_Compliance_Post_Settle__c.FieldSets.Post_Settle_Commons.getFields(), 'Meta_Compliance_Post_Settle__c', 'Meta_Compliance_Check__c', complianceCheckId)) {
                mcPostLineItems.add((Meta_Compliance_Post_Settle__c)o);
            }
        } 
        return mcPostLineItems;
    }
    //===============================================================
    //                    INNER CLASSES / WRAPPERS
    //===============================================================    
    /*  Description: Wrapper class for the Compliance Check and Meta Compliance Check Line Item object
     *  Author: Mike Lasala
     *  Date Created: DEC-13-2013
     */
    public class checklistWrapper {
        public Meta_Compliance_Check_Line_Item__c mccLineItem   {get;set;}
        public Meta_Compliance_Pre_Settle__c mcpreLineItem      {get;set;}
        public Meta_Compliance_Post_Settle__c mcpostLineItem    {get;set;}
        public Compliance_Check__c compCheck                    {get;set;}
    }
}