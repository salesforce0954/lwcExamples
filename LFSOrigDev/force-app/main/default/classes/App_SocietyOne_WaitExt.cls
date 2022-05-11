/* @Description: Controller for Page APP_SocietyOne_Wait.page
*  @Author     : Afreen
*  @Date       : Jun-02-2016
*  @History    :
=========================================================================================================
    Jun-02-2016 : Created - Afreen Khan
=========================================================================================================
*/

public class App_SocietyOne_WaitExt extends APP_CommonExt {
    // public variables
    public String ex_AppId                  {get; set;} 
    public String ex_Token                  {get; set;}
    public Id sf_AppId                      {get; set;}
    public Applicant__c ex_applicant        {get; set;}
    public Application__c ex_application    {get; set;}
    public string userTypeVar               {get; set;}
    public string blackBoxTxt;

    // private variables
    private Boolean isProcessingSuccess;
    private UserUtility userUtility ;
    
    /*
    * Constructor
    */
    public App_SocietyOne_WaitExt(){
        // get page parameters
        userUtility = new UserUtility();
        
        ex_AppId = ApexPages.currentPage().getParameters().get('ANo ');
        ex_Token = ApexPages.currentPage().getParameters().get('LoanAmount');   
        
        sf_AppId  = ApexPages.currentPage().getParameters().get('Id');
        userTypeVar = UserInfo.getUserType();
    }
    
    /* 
    * Description : search for the required application
    */
    @RemoteAction
    public static List<X3rd_Party_Application_Status_Log__c> startPolling(String externalAppId){
        List<X3rd_Party_Application_Status_Log__c> statusList = [Select Id, Status__c, Status_Code__c, X3rd_Party_Application_Number__c From X3rd_Party_Application_Status_Log__c 
                                                                 where X3rd_Party_Application_Number__c = : externalAppId Order BY CreatedDate DESC ];
        if(statusList.size() >0){
            return statusList;
        }
        return null;
    }
    
    public PageReference afterPoll(){
        blackBoxTxt = Apexpages.currentPage().getParameters().get('blackBoxTxt');
        system.debug('!@#after poll');
        system.debug('!@#blackBoxTxt:' + blackBoxTxt);
        return retrieveRecords();
    }
    
    /* 
    * Description : Perform post Search steps
    */
    public PageReference retrieveRecords(){
        isProcessingSuccess = true;
        return getAndSetApplicationId(); // Pull Application Id based on society one Application Id  
    }
    
    /*
    * Get and Set Application Id to be able to reuse the current retrieve application method inside APP_Common extension
    */
    private PageReference getAndSetApplicationId(){
        
        // retrieve the application using the 3rd party external id
        List<Application__c> thisApplication =  new List<Application__c>();
        thisApplication = [SELECT Id, X3rd_Party_Security_Token__c FROM Application__c WHERE X3rd_Party_Application_Number__c = : ex_AppId LIMIT 1];
        
        // check whether a record has been retrieved
        if(!thisApplication.isEmpty()){
            // check if the token has already been flush, if not, it means that this application hasn't been processed and proceed to the next method.
            if(thisApplication[0].X3rd_Party_Security_Token__c != '' && thisApplication[0].X3rd_Party_Security_Token__c != null){
                sf_AppId = thisApplication[0].Id;
                return processApplication(); // process application and loan purpose for calculations and default values settings
            }
            // if the token is null or flushed, it means that the application is already in progress. Redirect the user to the error page advising that the application is already in progress.
            else{
                isProcessingSuccess = false;
                return setRedirect('ERR_003',ex_AppId);
            }
        }
        // if no application has been retrieved from database, it is a system error
        else{
            isProcessingSuccess = false;
            return setRedirect('ERR_005',ex_AppId);
        }
        system.debug('!@#null return');
        return null;
    }
    
    /*
    * Retrieve the whole application record. Reusing the retrieveApplication method inside the APP_Common extension
    * Set the public variable for page references
    */
    private PageReference processApplication(){
        // reuse the method from APP_Common to retrieve the whole application instance
        ex_application = retrieveApplication(sf_AppId);
        System.debug('!@#ex_application' + ex_application);
        // reuse the variable from APP_Common to initialize the application record
        application = ex_application;
        //System.debug('!@#application' + application);
        
        // retrieve all loan purposes
        List<Loan_Purpose__c> loanPurposes = retrieveLoanPurposeList();
        
        // get the ONR Id to be related to the Loan Purpose and Application
        Id onrId = getParentONRId(application.Id);
        
        // calculate total loan amount
        application.Total_Loan_Amount__c = 0;
        for(Loan_Purpose__c lp: loanPurposes){
            // set ONR for each loan purpose
            lp.ONR__c = onrId;
            ex_application.Total_Loan_Amount__c += lp.Loan_Amount__c;
        }
        
        // flush token - this is to indicate whether the application has been processed in Salesforce side
        ex_application.X3rd_Party_Security_Token__c = '';
        
        // iovation fields
        ex_application.FP_Black_Box__c = blackBoxTxt;
        ex_application.Fingerprint_Step__c = GEN_OriginationsConstants.IOVATION_FINGERPRINT_STEP;
        ex_application.FP_IP_Address__c = APP_ApplicationMain_INTCC.getIPAddress();
        ex_application.Initial_Requested_Amount__c = application.Total_Loan_Amount__c;

        try{
            Brand__c appBrand = [SELECT iOvation_Type_Online__c, 
                                            iOvation_Type_Sales__c , iOvation_Type_3rd_Party__c 
                                     FROM   Brand__c 
                                     WHERE  Id =: application.Brand_Lookup__c];
            
            ex_application.iOvation_Type__c = appBrand.iOvation_Type_3rd_Party__c;
        }catch(Exception e){
            System.debug('!@#ERROR_iOvationType: ' + e.getStackTraceString());
        }
                     
        // set default product type
        ex_application.Type_of_Product__c = GEN_OriginationsConstants.PRODUCT_TYPE;
        
        // set Mirror__c 
        ex_application.Mirror__c = GEN_OriginationsConstants.SOCIETY_ONE;
        
        // set Channel
        ex_application.Channel__c = GEN_OriginationsConstants.APPLICATION_CHANNEL_3RD_PARTY;
        
        // set business source
        ex_application.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_INTERNET_APPLICATION;
        
        // update all records where modifications has been made
        try{
            //validateApply();
            update ex_application;
            update loanPurposes;
            processApplicantAndChildren(); // process applicant and child records for computations
        }
        // if any DML error occure, send the user to the error page showing the system error message and description
        catch(Exception e){
            isProcessingSuccess = false;
            System.debug('!@#ERROR: ' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage(), 'APP_SocietyOne_WaitExt', 'Application__c', 'Class', String.valueOf(application.Id));
            return setRedirect('ERR_005', ex_AppId);
        }
        return null;
    }
    
    /*
    * Retrieve the applicant record. Reusing the retrieveApplicant method inside the APP_Common extension
    * Set the public variable for page references
    */
    private PageReference processApplicantAndChildren(){
        
        // reuse the method from APP_Common to retrieve the whole applicant instance
        List<Applicant__c> applicantList = APP_CommonVariables.retrieveApplicants(sf_AppId);
        
        // set application total amount to zero
        ex_applicant = applicantList[0];
        ex_applicant.Total_Income__c = 0;
        ex_applicant.Total_Expense__c = 0;
        ex_applicant.Total_Assets__c = 0;
        ex_applicant.Total_Debts__c = 0;
        
        // calculate income using CUI wrapper class and its methods
        List<MyBudgetsIncomeWrapper> incomeList = new List<MyBudgetsIncomeWrapper>();
        for(Income__c i: ex_applicant.Incomes__r){
            incomeList.add(new MyBudgetsIncomeWrapper(i, ex_applicant, true, 'AU'));
        }
        
        List<Income__c> finalIncomeList = new List<Income__c>();
        for(MyBudgetsIncomeWrapper i: incomeList){
            i.computeTotalIncome();
            finalIncomeList.add(i.income);
            ex_applicant.Total_Income__c += i.income.Total_Income__c;
        }
        
        
        // // calculate expense using CUI wrapper class and its methods
        List<MyBudgetsExpenseWrapper> expenseList = new List<MyBudgetsExpenseWrapper>();
        for(Expense__c e: ex_applicant.Expenses__r){
            expenseList.add(new MyBudgetsExpenseWrapper(e, ex_applicant));
        }
        
        Boolean isRent = (ex_applicant.Res_Status__c == GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING
                        || ex_applicant.Res_Status__c == GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY
                        || ex_applicant.Res_Status__c == GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER) ? true : false;
                        
        List<Expense__c> finalExpenseList = new List<Expense__c>();
        for(MyBudgetsExpenseWrapper e: expenseList){
            e.computeTotalExpense(isRent, ex_application.Brand_Country__c);
            finalExpenseList.add(e.expense);
            ex_applicant.Total_Expense__c += e.expense.Total_Exp__c;
        }
        
        // calculate asset using CUI wrapper class and its methods
        List<MyBudgetsAssetWrapper> assetList = new List<MyBudgetsAssetWrapper>();
        List<Asset__c> finalAssetList = new List<Asset__c>();
        for(Asset__c a: ex_applicant.Assets__r){
            a.Total_Assets__c = a.Asset_Value__c;
            if(a.Total_Assets__c!=null){
                ex_applicant.Total_Assets__c += a.Total_Assets__c;
            }
            finalAssetList.add(a);
        }
        
        // calculate debt CUI wrapper class and its methods
        List<MyBudgetsDebtWrapper> debtList = new List<MyBudgetsDebtWrapper>();
        for(Liability__c d: ex_applicant.Liabilities__r){
            debtList.add(new MyBudgetsDebtWrapper(d));
        }
        
        List<Liability__c> finalDebtList = new List<Liability__c>();
        for(MyBudgetsDebtWrapper d: debtList){
            try{
                ex_applicant.Total_Debts__c += d.getDebtAmount(ex_application.Brand_Country__c);
            }catch(Exception e){
                System.debug('!@#DebtError: ' + e.getStackTraceString());
                finalDebtList.add(d.debt);
            }
        }
        
        // update all records where modifications has been made
        try{
            update finalIncomeList;
            update finalExpenseList;
            update finalAssetList;
            update finalDebtList;
            update ex_applicant;
        }
        // if any DML error occure, send the user to the error page showing the system error message and description
        catch(Exception e){
            isProcessingSuccess = false;
            System.debug('!@#ERROR: ' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage(), 'APP_SocietyOne_WaitExt', 'Application__c', 'Class', String.valueOf(application.Id));
            return setRedirect('ERR_005', ex_AppId);
        }
        return null;
    }
    public PageReference cuiPage;
    
    /* 
    * Description : create community user for third party application
    */
    public void performPostProcessing(){    
        cuiPage = userUtility.createCommunityUser(application, ex_applicant);
    }
    
    /* 
    * Description : Fire submit and redirect to wait page
    */
    public pageReference submitAndRedirect(){ 
        submitServiceCallCustomer();
        if(cuiPage!=null && ex_applicant.Account__c!=null){
            return cuiPage;
        }else{
            return setRedirect('ERR_005',ex_AppId);
        }
    }
    
    /* 
    * Description : method to be called from the page for any error handling redirection
    */
    public PageReference sendToErrorPage(){
        String errorCode = Apexpages.currentPage().getParameters().get('errCode');
        return setRedirect(errorCode, ex_AppId);
    }
    
    /* 
    * Description : method to be called from the controller for any error handling redirection
    */
    public pageReference setRedirect(String errCodeParam, String appId){
        try{
            Group fQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'AU_3rd_Party_Application_Failed_Queue' LIMIT 1];
            ex_application.ownerId = fQueue.Id;
            update ex_application;
        }catch(Exception e){
            system.debug('!@#ERROR: ' + e.getStackTraceString());
        } 

        PageReference pr = Page.App_SocietyOne_SysError;
        pr.getParameters().put('err', errCodeParam);
        pr.getParameters().put('externalappId', appId);
        pr.setRedirect(true);
        return pr;
    }
    /*  Description: Retrieve/Create parentONR Id
     *  Author: Mike Lasala
     *  Date Created: JAN-24-2014
     *  Input Parameters: None
     *  Return: Id
     */
    public Id getParentONRId(Id appId){
        ONR__c parentONR;
        
        List<ONR__c> onrList = [SELECT  Id 
                                FROM    ONR__c 
                                WHERE   Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                AND     recordType.Name =: GEN_OriginationsConstants.ONR_GENERAL
                                AND     Application__c =: appId
                                LIMIT   1];

        if(onrList.size()<1){
            //create new onr based on meta onr if there is no existing ONR yet
            List<Meta_ONR__c> metaONR = [SELECT GeId__c
                                         FROM   Meta_onr__c 
                                         WHERE  Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                         AND    Onr_type__c =: GEN_OriginationsConstants.ONR_GENERAL];
            
            Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c; 
            Map<String,Schema.RecordTypeInfo> onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
            Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();
            
            if(!metaONR.isEmpty()){
                parentONR = new ONR__c(Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE, 
                                       RecordTypeId = onrGeneral,
                                       GeId__c = metaONR[0].geId__c,
                                       Application__c = appId);
                insert parentONR;
            }
        } else {
            parentONR = onrList.get(0);
        }
        
        return parentONR.Id;
    }
}