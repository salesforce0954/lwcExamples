public without sharing class BrokerSubmittedEntities {
    
    /**
     * Get the Broker Id of the Logged in User. Based on the Broker Id or the Nominated Broker Id, the associated records
     * will be fetched.
     * 
     */
    @AuraEnabled(cacheable=true)
    public static BrokerDetailsWrapper getBrokerId(){
        String brokerId;
        String nominatedBrokerId;
        String loggedInUserEmail;
        Id loggedInUserContactId;
        String brokerType;
        String accessLevel;
        BrokerDetailsWrapper bdw = new BrokerDetailsWrapper();
        Id brokerRecordTypeId_APAC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('APAC_Contact').getRecordTypeId();
        Id brokerRecordTypeId_Assistant = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Broker_Assistants').getRecordTypeId();
        User userObj = [SELECT  ContactId,
                                Email,
                                Contact.Broker_Id__c,
                                Contact.Email,
                                Contact.AccountId,
                                Contact.RecordTypeId,
                                Contact.Broker_View_Access__c,
                                Contact.Nominated_Broker__c,
                                Contact.Nominated_Broker__r.Broker_ID__c 
                          FROM  User
                         WHERE  Id = :UserInfo.getUserId()];
        if(userObj != null){
            loggedInUserEmail = userObj.Email;
            loggedInUserContactId = userObj.ContactId;
            brokerId = userObj.Contact.Broker_Id__c;
            nominatedBrokerId = userObj.Contact.Nominated_Broker__r.Broker_ID__c;
            accessLevel = userObj.Contact.Broker_View_Access__c;
            //If Logged In User is a Broker Assistant
            if(userObj.Contact.RecordTypeId == brokerRecordTypeId_Assistant){
                brokerType = 'Broker_Assistants';
            //If Logged In User is a Broker
            }else if(userObj.Contact.RecordTypeId == brokerRecordTypeId_APAC){
                brokerType = 'APAC_Contact';
            }

            bdw.brokerId = brokerId;
            bdw.contactId = loggedInUserContactId;
            if(nominatedBrokerId == null){
                bdw.nominatedBrokerId = '';
            }else{
                bdw.nominatedBrokerId = nominatedBrokerId;
            }
            if(accessLevel == null){
                bdw.accessLevel = '';    
            }else{
                bdw.accessLevel = accessLevel;
            }
            bdw.accountId = userObj.Contact.AccountId;
            bdw.brokerType = brokerType;
        }
        return bdw;
    }

    /**
     * Description: Get the Quote details that match a certain Broker Id. The conditions are driven based on a few
     *              fields on the Contact Record.
     */
    @AuraEnabled
    public static List<Quote__c> getQuotes(String pageSize, String pageNumber, String emailId, String mobileNumber){
        BrokerDetailsWrapper brokerDetails = getBrokerId();
        List<Quote__c> brokerQuotesList = new List<Quote__c>();
        if(Test.isRunningTest()){
            List<Account> accList = TestDataBuilder.createAccounts(1);
            Account accObj = accList[0];
            brokerDetails.brokerType ='APAC_Contact';
            brokerDetails.accessLevel = 'Team View';
            brokerDetails.brokerId = 'B-123456';
            brokerDetails.accountId = accObj.Id;
        }
        if(brokerDetails != null && brokerDetails.brokerId != null){
            String brokerType = brokerDetails.brokerType;
            String accessLevel = brokerDetails.accessLevel;
            Id accountId = brokerDetails.accountId;
            String brokerId = brokerDetails.brokerId;
            String nominatedBrokerId = brokerDetails.nominatedBrokerId;
            List<String> brokersList = new List<String>();
            
            Integer ps;
            Integer pn;
            if(String.isNotBlank(pageSize)){
                ps = Integer.valueOf(pageSize);
            }
            if(String.isNotBlank(pageNumber)){
                pn = Integer.valueOf(pageNumber)-1;
            }
            String soqlQuery = '';
            Id brokerRecordTypeId_APAC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('APAC_Contact').getRecordTypeId();
            soqlQuery = 'SELECT  Id,Name,First_Name__c,Last_Name__c,Date_of_Birth__c,Mobile_Number__c,Quote_Stage__c,Email_ID__c,Loan_Amount__c,Loan_Term__c,Loan_Purpose__c,Quote_Rate__c,Interest_Rate_Offered__c FROM  Quote__c ';

            if(brokerType == 'APAC_Contact'){
                //Check the access level, if none specified then the Broker can only see his/her quotes (similar to Individual View). If Team View specified, then 
                //fetch the Broker Ids associated with that Account
                if(accessLevel == ''){
                    return brokerQuotesList;
                }else if(accessLevel == 'Individual View'){
                    if(brokerId == '' || brokerId == null){
                        return brokerQuotesList;
                    }
                    soqlQuery += ' WHERE Broker_ID__c = :brokerId ';
                }else if(accessLevel == 'Team View'){
                    brokersList = fetchBrokersInOffice(accountId, brokerRecordTypeId_APAC);
                    if(brokersList.size() == 0){
                        return brokerQuotesList;
                    }
                    soqlQuery += ' WHERE Broker_ID__c IN :brokersList ';
                }
            }else if(brokerType == 'Broker_Assistants'){
                /* if(accessLevel == ''){
                    return brokerQuotesList;
                }else if(accessLevel == 'Individual View'){
                    if(nominatedBrokerId == '' || nominatedBrokerId == null){
                        return brokerQuotesList;
                    }
                    soqlQuery += ' WHERE Broker_ID__c = :nominatedBrokerId ';
                }else if(accessLevel == 'Team View'){
                    brokersList = fetchBrokersInOffice(accountId, brokerRecordTypeId_APAC);
                    if(brokersList.size() == 0){
                        return brokerQuotesList;
                    }
                    soqlQuery += ' WHERE Broker_ID__c IN :brokersList ';
                }*/
            }else{
                return brokerQuotesList;
            }
            System.debug('brokersList SIZE: '+brokersList.size());
            System.debug('brokersList : '+brokersList);
            //Add Created Date Check
            soqlQuery += ' AND CreatedDate >= '+'2020-12-03T00:00:00Z';
            
            //Add additional filter conditions based on inputs.
            if(!String.isEmpty(emailId) && !String.isEmpty(mobileNumber)){
                soqlQuery += ' AND (Email_ID__c = \'' +String.escapeSingleQuotes(emailId)+ '\' OR Mobile_Number__c  = \'' +String.escapeSingleQuotes(mobileNumber)+ '\')';
            }else if(!String.isEmpty(emailId)){
                soqlQuery += ' AND Email_ID__c = \'' +String.escapeSingleQuotes(emailId)+ '\'';
            }else if(!String.isEmpty(mobileNumber)){
                soqlQuery += ' AND Mobile_Number__c = \'' +String.escapeSingleQuotes(mobileNumber)+ '\'';
            }
            soqlQuery += ' ORDER BY CreatedDate DESC ';
            if(String.isEmpty(emailId) && String.isEmpty(mobileNumber) && ps != null && pn != null){
                soqlQuery += ' LIMIT '+Integer.valueOf(ps)+' OFFSET '+ps*pn;
            }
            System.debug('soqlQuery QUOTES: '+soqlQuery);
            brokerQuotesList = Database.query(soqlQuery);   
        }
        return brokerQuotesList;
    }

    /**
     * Description: Get the Applicant details and the related Application Details that match a certain Broker Id. The conditions are driven based on a few
     *              fields on the Contact Record.
     */
    @AuraEnabled
    public static List<ApplicationDetailsWrapper.AppListView> getApplications(String loanNumber, String applicantName){
        BrokerDetailsWrapper brokerDetails = getBrokerId();      
        List<Applicant__c> brokerAppsList = new List<Applicant__c>();
        List<ApplicationDetailsWrapper.AppListView> brokerAppsWrapperList = new List<ApplicationDetailsWrapper.AppListView>();
        String appStatusNew = 'New';
        //Integer ps = Integer.valueOf(pageSize);
        //Integer pn = Integer.valueOf(pageNumber)-1;
        if(Test.isRunningTest()){
            List<Account> accList = TestDataBuilder.createAccounts(1);
            Account accObj = accList[0];
            brokerDetails.brokerType ='APAC_Contact';
            brokerDetails.accessLevel = 'Team View';
            brokerDetails.brokerId = 'B-123456';
            brokerDetails.accountId = accObj.Id;
        }
        
        if(brokerDetails != null && brokerDetails.brokerId != null){
            String brokerType = brokerDetails.brokerType;
            String accessLevel = brokerDetails.accessLevel;
            Id accountId = brokerDetails.accountId;
            String brokerId = brokerDetails.brokerId;
            String nominatedBrokerId = brokerDetails.nominatedBrokerId;
            String brokerContactId = brokerDetails.contactId;
            List<String> brokersList = new List<String>();

            String soqlQuery = '';
            Id brokerRecordTypeId_APAC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('APAC_Contact').getRecordTypeId();
            soqlQuery = 'SELECT Id, First_Name__c, Last_Name__c, Is_Primary_Applicant__c, Email_Address__c, Mobile__c, Application__r.Documents_in_Review__c, Application__c, Application__r.Generated_Doc_Confirm_Sent__c, Application__r.Offered_Interest_Rate__c, Application__r.Broker__r.FirstName, Application__r.Broker__r.LastName, Application__r.Broker_ID__c, Application__r.Name,Application__r.Response_Description__c,Application__r.Total_Loan_Amount__c,Application__r.Loan_Term__c,Application__r.UID__c,Application__r.Status__c,Application__r.Application_Type__c FROM Applicant__c  ';
            if(brokerType == 'APAC_Contact'){
                //Check the access level, if none specified then the Broker can only see his/her quotes (similar to Individual View). If Team View specified, then 
                //fetch the Broker Ids associated with that Account
                if(accessLevel == ''){
                    return brokerAppsWrapperList;
                }else if(accessLevel == 'Individual View'){
                    if(brokerId == '' || brokerId == null){
                        return brokerAppsWrapperList;
                    }
                    soqlQuery += ' WHERE Application__r.Broker_ID__c = :brokerId ';
                }else if(accessLevel == 'Team View'){
                    brokersList = fetchBrokersInOffice(accountId, brokerRecordTypeId_APAC);
                    if(brokersList.size() == 0){
                        return brokerAppsWrapperList;
                    }
                    soqlQuery += ' WHERE Application__r.Broker_ID__c IN :brokersList ';
                }
            }else if(brokerType == 'Broker_Assistants'){
               /* if(accessLevel == ''){
                    return brokerAppsWrapperList;
                }else if(accessLevel == 'Individual View'){
                    if(nominatedBrokerId == '' || nominatedBrokerId == null){
                        return brokerAppsWrapperList;
                    }
                    soqlQuery += ' WHERE Application__r.Broker_ID__c = :nominatedBrokerId ';
                }else if(accessLevel == 'Team View'){
                    brokersList = fetchBrokersInOffice(accountId, brokerRecordTypeId_APAC);
                    if(brokersList.size() == 0){
                        return brokerAppsWrapperList;
                    }
                    soqlQuery += ' WHERE Application__r.Broker_ID__c IN :brokersList ';
                } */
            }else{
                return brokerAppsWrapperList;
            }
            //Add Created Date Check
            soqlQuery += ' AND CreatedDate >= '+'2020-12-03T00:00:00Z';
            //Add Primary Applicant Check
            //soqlQuery += ' AND Is_Primary_Applicant__c = true';
            //Add Status Check
            soqlQuery += ' AND Application__r.Status__c != \'' +appStatusNew+ '\' ';

            if(!String.isEmpty(loanNumber)){
                soqlQuery += ' AND Application__r.UID__c = \'' +String.escapeSingleQuotes(loanNumber)+ '\'';
            }
            soqlQuery += ' ORDER BY Application__r.CreatedDate DESC ';
            System.debug('soqlQuery APPS: '+soqlQuery);
            brokerAppsList = Database.query(soqlQuery);
            //Filter the records based on first name & Last name
            if(applicantName != null && applicantName != ''){
                List<Applicant__c> filteredList = new List<Applicant__c>();
                filteredList = filterBasedOnName(brokerAppsList, loanNumber, String.escapeSingleQuotes(applicantName));
                brokerAppsList = filteredList;
            }

            //create map between application and secondary applicant if it's joint application
            Map<Id, Applicant__c> mapApplicationToSecondaryApplicant = new Map<Id, Applicant__c>();
            for(Applicant__c aObj : brokerAppsList){
                if(aObj.Is_Primary_Applicant__c == false) {
                    mapApplicationToSecondaryApplicant.put(aObj.Application__c, aObj);
                }
            }

            //get loan purpose
            System.debug('DEBERROR '+brokerContactId);
            List<Loan_Purpose__c> loanPurposes = [SELECT ID, Name, Value__c, Application__r.UID__c FROM Loan_Purpose__c
                                                 WHERE Application__r.Broker__c = :brokerContactId AND Application__r.UID__c != null];
                                                 System.debug('DEBERROR '+loanPurposes);
            Map<String, List<String>> mapApplicationLoanPurpose = new Map<String, List<String>>();
            for(Loan_Purpose__c lp : loanPurposes) {
                if(mapApplicationLoanPurpose.get(lp.Application__r.UID__c) == null) {
                    mapApplicationLoanPurpose.put(lp.Application__r.UID__c, new List<String>{lp.Value__c});
                } else {    
                    mapApplicationLoanPurpose.get(lp.Application__r.UID__c).add(lp.Value__c);
                }
            }

            //get debit
            List<Debit__c> otherDebit = [SELECT ID, RecordType.Name, Application__r.UID__c FROM Debit__c WHERE Application__r.UID__c != null AND Application__r.Broker__c = :brokerContactId];
            Map<String, List<Debit__c>> mapApplicationDebit = new Map<String, List<Debit__c>>();
            Map<String, List<Debit__c>> mapApplicationDirectDebit = new Map<String, List<Debit__c>>();
            for(Debit__c db: otherDebit) {
                if(db.RecordType.Name != 'Direct Debit') {
                    if(mapApplicationDebit.get(db.Application__r.UID__c) == null) {
                        mapApplicationDebit.put(db.Application__r.UID__c, new List<Debit__c>{db});
                    } else {
                        mapApplicationDebit.get(db.Application__r.UID__c).add(db);
                    }
                } else if(db.RecordType.Name == 'Direct Debit') {
                    if(mapApplicationDirectDebit.get(db.Application__r.UID__c) == null) {
                        mapApplicationDirectDebit.put(db.Application__r.UID__c, new List<Debit__c>{db});
                    } else {
                        mapApplicationDirectDebit.get(db.Application__r.UID__c).add(db);
                    }
                }
            }

            //get disbursement
            List<Disbursement__c> otherCredit = [SELECT ID, RecordType.Name, Application__r.UID__c FROM Disbursement__c WHERE 
                                                Application__r.UID__c != null AND Application__r.Broker__c = :brokerContactId];
            Map<String, List<Disbursement__c>> mapApplicationCredit = new Map<String, List<Disbursement__c>>();  
            Map<String, List<Disbursement__c>> mapApplicationDirectCredit = new Map<String, List<Disbursement__c>>();  
            for(Disbursement__c dc: otherCredit) {
                if(dc.RecordType.Name != 'Direct Credit' && dc.RecordType.Name != 'Broker Fee EFT') {
                    if(mapApplicationCredit.get(dc.Application__r.UID__c) == null) {
                        mapApplicationCredit.put(dc.Application__r.UID__c, new List<Disbursement__c>{dc});
                    } else {
                        mapApplicationCredit.get(dc.Application__r.UID__c).add(dc);
                    }
                } else if(dc.RecordType.Name == 'Direct Credit') {
                    if(mapApplicationDirectCredit.get(dc.Application__r.UID__c) == null) {
                        mapApplicationDirectCredit.put(dc.Application__r.UID__c, new List<Disbursement__c>{dc});
                    } else {
                        mapApplicationDirectCredit.get(dc.Application__r.UID__c).add(dc);
                    }
                }
            }                                              

            Map<String,String> statusMap = createAppStatusMap();
            Map<String, String> statusDescriptionMap = createAppStatusDescriptionMap();
            for(Applicant__c aObj : brokerAppsList){
                if(!aObj.Is_Primary_Applicant__c) {
                    continue;
                }
                ApplicationDetailsWrapper.AppListView adwObj = new ApplicationDetailsWrapper.AppListView();
                String status = mapStatusForPortal(statusMap,aObj.Application__r.Status__c,aObj.Application__r.Response_Description__c);
                if(status == 'Conditionally Approved' && aObj.Application__r.Generated_Doc_Confirm_Sent__c) {
                    status = 'Pending contract acceptance';
                }
                adwObj.firstName = aObj.First_Name__c;
                adwObj.lastName = aObj.Last_Name__c;
                adwObj.fullName = aObj.First_Name__c + ' ' + aObj.Last_Name__c;
                adwObj.applicationId = aObj.Application__c;
                adwObj.applicantId = aObj.Id;
                adwObj.brokerId = aObj.Application__r.Broker_ID__c;
                adwObj.applicationName = aObj.Application__r.Name;
                adwObj.loanAmount = aObj.Application__r.Total_Loan_Amount__c;
                adwObj.loanTerm = aObj.Application__r.Loan_Term__c;
                adwObj.loanNumber = aObj.Application__r.UID__c;
                adwObj.offeredInterestRate = aObj.Application__r.Offered_Interest_Rate__c;
                adwObj.status = status;
                adwObj.statusForDisplay = setStatusForDisplay(status, aObj.Application__r.Documents_in_Review__c);
                String description = '';
                if(statusDescriptionMap.get(adwObj.statusForDisplay) != null) {
                    description = statusDescriptionMap.get(adwObj.statusForDisplay);
                }
                adwObj.statusDescription = description;
                adwObj.isOnlyDebtConsolidation = false;
                if(mapApplicationLoanPurpose.get(aObj.Application__r.UID__c) != null) {
                    if(mapApplicationLoanPurpose.get(aObj.Application__r.UID__c).size() == 1 && mapApplicationLoanPurpose.get(aObj.Application__r.UID__c)[0].toLowerCase() == 'debt consolidation') {
                        adwObj.isOnlyDebtConsolidation = true;
                    }
                    adwObj.loanPurpose = String.join(mapApplicationLoanPurpose.get(aObj.Application__r.UID__c), ', ');
                } else {
                    adwObj.loanPurpose = '';
                }
                adwObj.hasAnotherDebit = false;
                if(mapApplicationDebit.get(aObj.Application__r.UID__C) != null) {
                    adwObj.hasAnotherDebit = true;
                }
                adwObj.hasAnotherCredit = false;
                if(mapApplicationCredit.get(aObj.Application__r.UID__C) != null) {
                    adwObj.hasAnotherCredit = true;
                }           
                adwObj.ddExist = false;
                if(mapApplicationDirectDebit.get(aObj.Application__r.UID__C) != null) {
                    adwObj.ddExist = true;
                }                 
                adwObj.dcExist = false;   
                if(mapApplicationDirectCredit.get(aObj.Application__r.UID__C) != null) {
                    adwObj.dcExist = true;
                }                   
                adwObj.applicationType = aObj.Application__r.Application_Type__c;
                adwObj.email = aObj.Email_Address__c;
                adwObj.mobile = aObj.Mobile__c;
                adwObj.brokerName = aObj.Application__r.Broker__r.FirstName + ' ' + aObj.Application__r.Broker__r.LastName;
                if(mapApplicationToSecondaryApplicant.get(aObj.Application__c) != null) {
                    adwObj.secondaryApplicant = mapApplicationToSecondaryApplicant.get(aObj.Application__c);
                }
                brokerAppsWrapperList.add(adwObj);
            }

        }
        return brokerAppsWrapperList;
    }
@TestVisible
    private static List<Applicant__c> filterBasedOnName(List<Applicant__c> brokerAppsList, String loanNumber, String applicantName){
        List<Applicant__c> filteredList = new List<Applicant__c>();
        String fName;
        String lName;
        for(Applicant__c appObj : brokerAppsList){
            if(!appObj.Is_Primary_Applicant__c) {
                continue;
            }
            if(applicantName.contains(' ')){
                List<String> nameList = applicantName.split(' ');
                fName = nameList[0];
                lName = nameList[1];
                if((appObj.First_Name__c != null && appObj.First_Name__c.containsIgnoreCase(fName)) ||
                    (appObj.Last_Name__c != null && appObj.Last_Name__c.containsIgnoreCase(lName)) || 
                    (loanNumber != null && appObj.Application__r.UID__c != null && appObj.Application__r.UID__c.equals(loanNumber))){
                        filteredList.add(appObj);
               }
            }else{
                if((appObj.First_Name__c != null && appObj.First_Name__c.containsIgnoreCase(applicantName)) ||
                    (appObj.Last_Name__c != null && appObj.Last_Name__c.containsIgnoreCase(applicantName)) || 
                    (loanNumber != null && appObj.Application__r.UID__c != null &&appObj.Application__r.UID__c.equals(loanNumber))){
                        filteredList.add(appObj);
               }
            }
        }
        return filteredList;
    }

    /**
     * Description: Get latest application status
     */
    @AuraEnabled
    public static List<String> getApplicationStatus(Id applicationId){
        try {
            List<String> statuses = new List<String>();
            Map<String,String> statusMap = createAppStatusMap();
            Map<String, String> statusDescriptionMap = createAppStatusDescriptionMap();
            Application__c app = [SELECT ID, Status__c, Documents_in_Review__c, Response_Description__c, Generated_Doc_Confirm_Sent__c FROM Application__c WHERE Id = :applicationId];
            String status = mapStatusForPortal(statusMap,app.Status__c,app.Response_Description__c);
            if(status == 'Conditionally Approved' && app.Generated_Doc_Confirm_Sent__c) {
                status = 'Pending contract acceptance';
            }
            String statusForDisplay = setStatusForDisplay(status, app.Documents_in_Review__c);
            statuses.add(status);
            statuses.add(statusForDisplay);
            statuses.add(statusDescriptionMap.get(statusForDisplay));
            return statuses;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Description: Get the Broker Record that was saved when the quote was created.
     */
    @AuraEnabled
    public static String getBrokerRecordForPrint(String quoteId, String user_dateOfBirth){
        
        List<Quote_Print_Broker__c> quotePrintBrokerList = new List<Quote_Print_Broker__c>();
        String quotePrintId = 'NOT_FOUND';
        Boolean quoteFound = false;
        if(String.isNotBlank(quoteId) && String.isNotBlank(user_dateOfBirth)){
            quoteFound = checkIfQuoteIdFound(quoteId);
            if(quoteFound){
                try{
                    Date dob = Date.parse(user_dateOfBirth);
                }catch(Exception e){
                    return 'INVALID_DATE_OF_BIRTH';
                }
                quotePrintBrokerList =   [SELECT  Id,
                                                  Date_of_Birth__c,
                                                  Quote__r.Name
                                             FROM Quote_Print_Broker__c
                                            WHERE Quote__c = :quoteId];
                                            System.debug('quotePrintBrokerList '+quotePrintBrokerList);
                if(quotePrintBrokerList.size() ==1){
                    String decision = checkAttemptsDob(quotePrintBrokerList[0].Id,quotePrintBrokerList[0].Quote__r.Name, 'Quote__c',
                                                        quotePrintBrokerList[0].Date_of_Birth__c,user_dateOfBirth);
                                                        System.debug('decision '+decision);
                    if(decision == 'DOB_VALID'){
                        quotePrintId = quotePrintBrokerList[0].Id;
                    }else{
                        quotePrintId = decision;
                    }                                                        
                    
                }
            }

        }
        return quotePrintId;
    }

    private static String checkAttemptsDob(String entityRecordId, String entityName, String entityApiName, String system_dateOfBirth,String user_dateOfBirth){
        String decision;
        List<Multi_Entity_Mfa__c> multiMfaList = [SELECT Failed_Attempts__c
                                                    FROM Multi_Entity_Mfa__c
                                                   WHERE Entity_Record_Id__c = :entityRecordId
                                                         AND 
                                                         Entity_Object_API_Name__c = :entityApiName];
        //Check if failed attempts is already 3
        if(multiMfaList.size() == 1 && multiMfaList[0].Failed_Attempts__c == 3){
            decision = 'MAX_ATTEMPTS_REACHED';
            return decision;
        }
        //If no entries found implies MFA validation has never been done for that record                                                 
        if(multiMfaList.size() == 0){
            //check if DOB matches
            if(system_dateOfBirth == user_dateOfBirth){
                decision = 'DOB_VALID';
                return decision;
            }else{
                //Insert Multi Entity MFA record
                Multi_Entity_Mfa__c mmfaObj =  new Multi_Entity_Mfa__c(Entity_Record_Id__c = entityRecordId,Entity_Object_API_Name__c=entityApiName,
                                                                        Entity_Name__c = entityName, Failed_Attempts__c = 1);
                insert mmfaObj;
                decision = 'DOB_NOT_VALID';
                return decision;
            }
        }else{
            //check if DOB matches
            if(system_dateOfBirth == user_dateOfBirth){
                decision = 'DOB_VALID';
                return decision;
            }else{
                Id recordId = multiMfaList[0].Id;
                Decimal failedAttempts = multiMfaList[0].Failed_Attempts__c;
                Multi_Entity_Mfa__c mmfaObj =  new Multi_Entity_Mfa__c(Id = recordId, Entity_Record_Id__c = entityRecordId,Entity_Object_API_Name__c=entityApiName,
                                                                        Entity_Name__c = entityName, Failed_Attempts__c = failedAttempts+1);
                update mmfaObj;
                decision = 'DOB_NOT_VALID';
                return decision;
            }
        }

    }

    /**
     * Description: Get the Details of the Quote and get the encrypted quote Id.
     */
    @AuraEnabled
    public static BrokerSubmittedEntities.QuoteWrapper getStatusAndEncryptedQuote(String quoteId){
        BrokerSubmittedEntities.QuoteWrapper qWrap = new BrokerSubmittedEntities.QuoteWrapper();
        Boolean quoteFound = false;
        if(String.isNotBlank(quoteId)){
            quoteFound = checkIfQuoteIdFound(quoteId);
        }
        if(quoteFound){
            Id brokerRecordTypeId_APAC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('APAC_Contact').getRecordTypeId();
            if(quoteId != null && quoteId != ''){
                String encryptedQuoteId = EncryptionManager.encryptQuoteId(quoteId);
                Quote__c quoteObj = [SELECT Quote_Stage__c,Broker_ID__c,Email_ID__c,Name, Sub_Type__c,
                                            First_Name__c,Last_Name__c,Date_of_Birth__c,
                                            Mobile_Number__c,Loan_Amount__c,Loan_Term__c,
                                            Loan_Purpose__c,Quote_Rate__c,Interest_Rate_Offered__c,
                                            Quote_Expires_On__c,Quote_Declined_On__c,Secured_Rate_Offered__c FROM Quote__c WHERE Id = :quoteId LIMIT 1];
                String brokerIdOnQuote = quoteObj.Broker_ID__c;
                if(brokerIdOnQuote != null){
                    Contact contObj = [SELECT FirstName, LastName FROM Contact WHERE Broker_ID__c = :brokerIdOnQuote AND RecordTypeId = :brokerRecordTypeId_APAC];
                    qWrap.brokerId = brokerIdOnQuote;
                    qWrap.brokerName = contObj.FirstName + ' '+contObj.LastName;
                }
                qWrap.quoteStage = quoteObj.Quote_Stage__c;
                qWrap.emailIdOnQuote = quoteObj.Email_ID__c;
                qWrap.encryptedQuoteId = encryptedQuoteId;
                qWrap.firstName = quoteObj.First_Name__c;
                qWrap.lastName = quoteObj.Last_Name__c;
                qWrap.dateOfBirth = quoteObj.Date_of_Birth__c;
                qWrap.emailId = quoteObj.Email_ID__c;
                qWrap.mobileNumber = quoteObj.Mobile_Number__c;
                qWrap.quoteReference = quoteObj.Name;
                qWrap.loanAmount = quoteObj.Loan_Amount__c;
                qWrap.loanPurpose = quoteObj.Loan_Purpose__c;
                qWrap.loanTerm = quoteObj.Loan_Term__c;
                qWrap.interestRateOffered = quoteObj.Interest_Rate_Offered__c;
                qWrap.securedRateOffered = quoteObj.Secured_Rate_Offered__c;
                qWrap.quoteExpiresOn = quoteObj.Quote_Expires_On__c;
                qWrap.quoteDeclinedOn = quoteObj.Quote_Declined_On__c;
                qWrap.productType = quoteObj.Sub_Type__c;
            }
        }
        return qWrap;
    }

    /**
     * Description: Get the Application Copy that is saved in Related Document. This document is created by Adobe.
     */
    @AuraEnabled
    public static string getAppCopyDocument(String applicationId,String user_dateOfBirth,String documentName,String entityName){
        System.debug(applicationId+' '+user_dateOfBirth+' '+documentName+' '+entityName);
        /**Validate if the Application Id Passed as an input is in the list of applications retrieved for the logged in user.*/
        List<ApplicationDetailsWrapper.AppListView> appList = new List<ApplicationDetailsWrapper.AppListView>();
        String base64String='NOT_FOUND';
        Boolean isAppFound = false;
        String entityApiName;

        if(documentName == 'Copy of Application'){
            entityApiName = 'Copy_of_Application';
        }else if(documentName == 'Copy of Contract'){
            entityApiName = 'Copy_of_Contract';
        }
        if(String.isNotBlank(applicationId) && String.isNotBlank(user_dateOfBirth)){
            appList = getApplications('', '');
            isAppFound = checkIfAppIdFound(applicationId,appList);
            if(isAppFound){
                try{
                    Date dob = Date.parse(user_dateOfBirth);
                }catch(Exception e){
                    base64String = 'INVALID_DATE_OF_BIRTH';
                    return base64String;
                }
                
                //Get the Broker Community Profile Id
                List<Profile> profileList = [SELECT Id  
                                            FROM  Profile
                                            WHERE  Name = 'A10 Latitude Broker Community Login'];
                if(profileList.size() == 1){
                    if(UserInfo.getProfileId() == profileList[0].Id){
                        //Get Primary Applicant's Date of Birth
                        List<Applicant__c> applicantList = [SELECT Date_of_Birth_Doc_Gen__c FROM Applicant__c WHERE Application__c = :applicationId AND Is_Primary_Applicant__c = true];
                        String system_dateOfBirth;
                        if(applicantList.size() == 1){
                            system_dateOfBirth = applicantList[0].Date_of_Birth_Doc_Gen__c;
                        }
                        //Validate attempts
                        String decision = checkAttemptsDob(applicationId,entityName, entityApiName,
                                                                system_dateOfBirth,user_dateOfBirth);
                        if(decision == 'DOB_VALID'){
                            
                            //Get the Related Document record that is linked to the application of type Copy of Application
                            List<Related_Document__c> relatedDocList = new List<Related_Document__c>();
                            if(documentName == 'Copy of Application'){
                                relatedDocList = [SELECT Id,
                                                        Application__r.Name
                                                FROM Related_Document__c 
                                                WHERE Application__c = :applicationId
                                                        AND 
                                                        Type__c = 'Copy of Application'
                                                        AND 
                                                        Document_Category__c = 'Internal'
                                                        AND 
                                                        Status__c = 'Received'];
    
                            }else if(documentName == 'Copy of Contract'){
                                relatedDocList = [SELECT Id,
                                                        Application__r.Name
                                                FROM Related_Document__c 
                                                WHERE Application__c = :applicationId
                                                        AND 
                                                        Type__c = 'Contract'
                                                        AND 
                                                        Document_Category__c = 'Loan Documents'
                                                        AND 
                                                        Status__c = 'Received'];
                            }
                            if(relatedDocList.size() == 1){
                                Id relatedDocumentId = relatedDocList[0].Id;

                                //Query the attachment object to get the Blob data
                                List<Attachment> aObjList = new List<Attachment>();
                                if(documentName == 'Copy of Application'){
                                    aObjList = [SELECT   Id,
                                                        Body 
                                                FROM   Attachment 
                                                WHERE   ParentId = :relatedDocumentId
                                                        AND 
                                                        Name LIKE '%Copy of Application%'];

                                }else if(documentName == 'Copy of Contract'){
                                    aObjList = [SELECT   Id,
                                                    Body 
                                            FROM   Attachment 
                                            WHERE   ParentId = :relatedDocumentId
                                                    AND 
                                                    Name LIKE '%Loan Contract Schedule%'];
                                }
                                if(aObjList.size() == 1){
                                    base64String = EncodingUtil.base64Encode(aObjList[0].Body);
                                }
                            }                            
                        }else{
                            base64String = decision;
                        }
                    }
                }
            }
        }
        System.debug('final:: '+base64String);
        return base64String;
    }

    /**
     * Check if the application Id exists in the list of applications the Broker/Assistant has access to.
     */
  @TestVisible   
    private static Boolean checkIfAppIdFound(String applicationId, List<ApplicationDetailsWrapper.AppListView> appList){
        Boolean appFound = false;
        for(ApplicationDetailsWrapper.AppListView appObj : appList){
            if(appObj.applicationId != null && appObj.applicationId != '' && 
                appObj.applicationId == applicationId){
                    appFound = true;
                    break;
            }
        }
        return appFound;
    }

    /**
     * Check if the quote Id exists in the list of quotes the Broker/Assistant has access to.
     */
    public static Boolean checkIfQuoteIdFound(String quoteId){
        System.debug('QUOTE ID OVERRIDE');
        List<Quote__c> quotesList = getQuotes(null,null,null,null);
        System.debug('quotesList QUOTE: '+quotesList);
        Boolean quoteFound = false;
        for(Quote__c quoteObj : quotesList){
            if(quoteObj.Id != null && quoteId != '' && 
                quoteObj.Id == quoteId){
                    quoteFound = true;
                    break;
            }
        }
        System.debug('NEW METHOD QUOTE FOUND: '+quoteFound);
        return quoteFound;
    }

    /**
     * Generate blob of QuotePrintablePage VFPage
     */
    @AuraEnabled
    public static String generateQuotePrintablePage(String recordId) {
        //get Quote_Print_Broker__c ID
        Quote_Print_Broker__c qpb = [SELECT Id FROM Quote_Print_Broker__c WHERE Quote__c = :recordId];

        // create a virtual page
        PageReference page = new PageReference('/apex/QuotePrintablePage');
        // add our record id
        page.getParameters().put('Id', qpb.Id);
        System.debug('DEB: '+String.valueOf(page));
        // generate and PDF blob
        // You can save this blob as a file, document, or attachment!

        if(Test.isRunningTest()) { 
            return 'Unit Test';
          } else {
            return EncodingUtil.base64Encode(page.getContent());
          }        
      }    

    /**
     * Fetch the Brokers who are associated with a particular office. In the org Office/Location is configured as an Account
     * and Brokers/Contacts are linked to that Account
     */
    @TestVisible 
    private static List<String> fetchBrokersInOffice(Id accountId, Id brokerRecordTypeId_APAC){
        List<Contact> brokersAssociatedList = [SELECT Broker_ID__c 
                                                 FROM Contact
                                                WHERE AccountId = :accountId
                                                      AND 
                                                      RecordTypeId = :brokerRecordTypeId_APAC];
        List<String> brokersList = new List<String>();
        for(Contact cObj : brokersAssociatedList){
            brokersList.add(cObj.Broker_ID__c);   
        }
        return brokersList;
    }

    /**
     * Get the Converted to Application Notes that were created when a Broker clicked on 'Convert to Application' from the Broker View.
     */
    @AuraEnabled
    public static List<Note> getConvertedToAppNotes(String quoteId){
        List<Note> notesList = new List<Note>();
        Boolean quoteFound = false;
        if(String.isNotBlank(quoteId)){
            quoteFound = checkIfQuoteIdFound(quoteId);
        }
        if(quoteFound){
            if(quoteId != null && quoteId != ''){
                notesList = [SELECT Body FROM Note WHERE ParentId = :quoteId 
                                                        AND Title = 'Converted to Application' 
                                                        AND isDeleted = false 
                                                        AND IsPrivate = false 
                                                        ORDER BY CreatedDate DESC];
            }
        }
        return notesList;
    }

    @AuraEnabled
    public static void createNote(String quoteId){
        Boolean quoteFound = false;
        if(String.isNotBlank(quoteId)){
            quoteFound = checkIfQuoteIdFound(quoteId);
        }
        if(quoteFound){
            //Create a Note against the Quote
            if(quoteId != null && quoteId != ''){
                Note noteObj = new Note();
                noteObj.parentId= quoteId;
                noteObj.body='Converted to Application by '+UserInfo.getFirstName() +' '+UserInfo.getLastName() +' on '+System.now().format(); 
                noteObj.title='Converted to Application'; 
                noteObj.isPrivate=false;  
                insert noteObj;
            }
        }
    }

    
@TestVisible
    private static String mapStatusForPortal(Map<String,String> statusMap,String applicationStatus,String responseDescription){
        //default status
        String mappedStatus = 'Referred';
        if(String.isNotBlank(applicationStatus)){
            //Check if the status is referred Sales
            if(applicationStatus == 'Referred: Sales' && String.isNotBlank(responseDescription)){
                
                //If one of C91AS or C91BS & one of C80AS or C80BS is present then both ID and POI are required
                if((responseDescription.containsIgnoreCase('C91AS') || responseDescription.containsIgnoreCase('C91BS')) && 
                    (responseDescription.containsIgnoreCase('C80AS') || responseDescription.containsIgnoreCase('C80BS'))){
                        mappedStatus = 'ID & Proof of Income required';
                }
                //If one of C91AS or C91BS is present then POI is required
                else if((responseDescription.containsIgnoreCase('C91AS') || responseDescription.containsIgnoreCase('C91BS'))){
                        mappedStatus = 'Proof of Income required';
                }
                //If one of C80AS or C80BS is present then ID is required
                else if((responseDescription.containsIgnoreCase('C80AS') || responseDescription.containsIgnoreCase('C80BS'))){
                        mappedStatus = 'ID required';
                }
            }else{
                if(statusMap.containsKey(applicationStatus)){
                    mappedStatus = statusMap.get(applicationStatus);
                }
            }
        }
        return mappedStatus;

    }

    private static String setStatusForDisplay(String status, Boolean documentsInReview) {
        if((status.toLowerCase() == 'id required' || status.toLowerCase() == 'proof of income required' ||
        status.toLowerCase() == 'id & proof of income required' || status.toLowerCase() == 'ID & Proof of Income required (Based on IDV or POI or both pending on the application)') && !documentsInReview) {
            return 'Upload documents';
        } else if((status.toLowerCase() == 'id required' || status.toLowerCase() == 'proof of income required' ||
        status.toLowerCase() == 'id & proof of income required' || status.toLowerCase() == 'ID & Proof of Income required (Based on IDV or POI or both pending on the application)') && documentsInReview) {
            return 'Documents in review';
        }
        else if(status.toLowerCase() == 'pending contract acceptance') {
            return 'Contract ready to accept';
        } else if(status.toLowerCase() == 'account created') {
            return 'Loan settled';
        } else if(status.toLowerCase() == 'awaiting response') {
            return 'Application in review';
        } else {
            return status;
        }
    }

    /**
     * Create a status map between App status in Salesforce and the status to be shown on broker portal
     */
    private static Map<String,String> createAppStatusMap(){
        //Create a Map of Status in Application & Status to be shown in BP
        Map<String,String> statusMap = new Map<String,String>();
        statusMap.put('Submitted', 'Submitted');
        statusMap.put('Conditionally Approved: AML', 'ID required');
        statusMap.put('Conditionally Approved: POI', 'Proof of Income required');
        statusMap.put('Conditionally Approved: AML and POI', 'ID & Proof of Income required');
        statusMap.put('Referred: Sales', 'ID & Proof of Income required (Based on IDV or POI or both pending on the application)');
        statusMap.put('Referred: Data validation', 'Referred');
        statusMap.put('Referred: Fraud', 'Referred');
        statusMap.put('Referred: Possible Bureau Match', 'Referred');
        statusMap.put('Referred: Possible match', 'Referred');
        statusMap.put('Referred: Pre-Bureau', 'Referred');
        statusMap.put('Referred: Watchlist', 'Referred');
        statusMap.put('Referred: Post-Bureau', 'Referred');
        statusMap.put('Referred: Refer to CPU/CMO', 'Referred');
        statusMap.put('Referred: Final Decision', 'Referred');
        statusMap.put('FIA Pending', 'Contract Accepted');
        statusMap.put('Contract Accepted', 'Contract Accepted');
        statusMap.put('Conditionally Approved: PCA', 'Conditionally Approved');
        statusMap.put('Conditionally Approved: Pending Contract Acceptance', 'Conditionally Approved');        
        statusMap.put('Accepted', 'Account Created');
        statusMap.put('Settled', 'Account Created');
        statusMap.put('Closed', 'Cancelled');
        statusMap.put('Cancel Pending', 'Cancelled');
        statusMap.put('Final Declined', 'Declined');
        statusMap.put('Declined', 'Declined');
        statusMap.put('Decline Pending', 'Declined');
        statusMap.put('Submission Failure', 'Awaiting Response');
        statusMap.put('Service Unavailable', 'Awaiting Response');
        statusMap.put('Documents in review', 'Documents in review');

        return statusMap;
    }

    private static Map<String,String> createAppStatusDescriptionMap() {
        Map<String,String> statusDescriptionMap = new Map<String,String>();
        statusDescriptionMap.put('Submitted', System.Label.BP_LBL_AppStatusDesc_Submitted);
        statusDescriptionMap.put('Upload documents', System.Label.BP_LBL_AppStatusDesc_UploadDoc);
        statusDescriptionMap.put('Referred', System.Label.BP_LBL_AppStatusDesc_Referred);
        statusDescriptionMap.put('Contract Accepted', System.Label.BP_LBL_AppStatusDesc_ContractAccepted);
        statusDescriptionMap.put('Conditionally Approved', System.Label.BP_LBL_AppStatusDesc_CondApproved);
        statusDescriptionMap.put('Contract ready to accept', System.Label.BP_LBL_AppStatusDesc_CTA);
        statusDescriptionMap.put('Loan settled', System.Label.BP_LBL_AppStatusDesc_LoanSettled);
        statusDescriptionMap.put('Cancelled', System.Label.BP_LBL_AppStatusDesc_Cancelled);
        statusDescriptionMap.put('Declined', System.Label.BP_LBL_AppStatusDesc_Declined);
        statusDescriptionMap.put('Application in review', System.Label.BP_LBL_AppStatusDesc_AppInReview);
        statusDescriptionMap.put('Documents in review', System.Label.BP_LBL_AppStatusDesc_DocInReview);
        
        return statusDescriptionMap;
    }

    public class QuoteWrapper{
        @AuraEnabled public String quoteStage{get;set;}
        @AuraEnabled public String encryptedQuoteId{get;set;}
        @AuraEnabled public String brokerId{get;set;}
        @AuraEnabled public String brokerName{get;set;}
        @AuraEnabled public String emailIdOnQuote{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String dateOfBirth{get;set;}
        @AuraEnabled public String emailId{get;set;}
        @AuraEnabled public String mobileNumber{get;set;}
        @AuraEnabled public String quoteReference{get;set;}
        @AuraEnabled public Double loanAmount{get;set;}
        @AuraEnabled public String loanPurpose{get;set;}
        @AuraEnabled public String loanTerm{get;set;}
        @AuraEnabled public String interestRateOffered{get;set;}
        @AuraEnabled public String securedRateOffered{get;set;}
        @AuraEnabled public String quoteExpiresOn{get;set;}
        @AuraEnabled public Datetime quoteDeclinedOn{get;set;}
        @AuraEnabled public String productType{get;set;}
    }

    
}