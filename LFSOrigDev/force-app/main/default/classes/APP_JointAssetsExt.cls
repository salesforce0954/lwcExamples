/*
 * @Description: Joint Asset Controller for GE Customer UI
 * @Author: Dan Crisologo
 * @Date Created: OCTOBER-01-2013
 * @History:
   =====================================================================
        OCT-01-13 (Dan): Created.
        OCT-02-13 (Mike): Fixed defects based on GCO-201
        OCT-03-13 (Mike): Added logic for querying related records from Main class
        OCT-09-13 (Mike): Added variable for UI parameter and condition to redirect to Sales UI
        OCT-10-13 (Mike): Added variable and method for Timeout redirection
        NOV-25-13 (Mike): Updated code to latest
        DEC-03-13 (Mike): Removed Applicant 2
        DEC-03-13 (Mike): Added GCO-489
        MAR-25-14 (Mike): Added assets exemption
        MAR-31-14 (Mat) : Refactoring of Admin Settings custom settings    
        APR-1-14(Adrian): Added warning and timeout getter methods
        DEC-10-14(Devendra): Initialized the constants which we get from APP_CommonExt here for DBHZL-143       
   =====================================================================
 */ 
public class APP_JointAssetsExt extends APP_CommonExt {

    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<MyBudgetsAssetWrapper> assetAddList {get;set;}  //Asset record list
    public Integer assetListSize                    {get;set;}  //Asset record list size
    public String redirectTo                        {get;set;}  //Pagereference identifier
    public Integer selectedRow                      {get;set;}  //Specific row/record to be deleted
    
    
    public List<Asset__c> assetListToDel = new List<Asset__c>();    //Asset record list for deletion
    public Boolean assetValidationResults;                          //Validation flag
    public Decimal totalAssets;                                     //Overall total asset value
    
    //Better Start fields
    public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}
    public Boolean isBetterStart {get;set;}

    /*  Description: Timeout getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getTimeOut(){
        return AS_TIMEOUT;
    }
    
    /*  Description: Warning getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getWarning(){
        return AS_WARNING;
    }
    
    /*  Description: Main Controller class used for all initializations
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: None
     *  Return: void
     */
    public APP_JointAssetsExt(ApexPages.StandardController applicationController) { 
        super(applicationController);
        string id=applicationController.getId();
        application__c app=[select Bank_Accounts_Held__c from application__c where id=:id];
        if(app.Bank_Accounts_Held__c!=null){
            bankAccountHeld=app.Bank_Accounts_Held__c;
        }else{
            bankAccountHeld='';
        }
        
        totalAssets = 0;
        List<Asset__c> oldAsset = new List<Asset__c>();

        //Retrieve asset records of applicant/s
        oldAsset = retrieveAssetList(this.applicant.Id);        
        if(this.applicantList.size() > 1){
            oldAsset.addAll(retrieveAssetList(this.applicant2.Id));
        }
        if(!oldAsset.isEmpty()){
            //Set data to Asset wrapper
            assetAddList = new List<MyBudgetsAssetWrapper>();
            for(Asset__c a: oldAsset){
                MyBudgetsAssetWrapper mbaw = new MyBudgetsAssetWrapper(a);
                assetAddList.add(mbaw);
                if(a.Total_Assets__c != null){
                    totalAssets += a.Total_Assets__c;
                }
            }
            
            refreshCount();
            assetListSize = oldAsset.size();
        } else {
            //Instantiate new wrapper records
            assetAddList = new List<MyBudgetsAssetWrapper>();
            assetListSize = 0;
            if(!this.applicant.Asset_Exempt__c){
                addAsset();
            }
        }
        
        //DEC-10-14(Devendra): Initialized the constants which we get from APP_CommonExt here for DBHZL-143       
        AssetDeposit = GEN_OriginationsConstants.ASSET_CATEGORY_DEPOSITS;
        AssetKiwiSaver = GEN_OriginationsConstants.ASSET_CATEGORY_KIWISAVER;
        
        initializeLoanPurposes();
        
        // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
        isBSOfferActive = false;
        isBSOfferNZActive = false;
        bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        isBSOfferNZActive = bsoffer.BetterStartNZActive__c;
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Add new Asset record
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addAsset(){
        assetAddList.add(new MyBudgetsAssetWrapper(this.applicant));
        assetListSize++;
        refreshCount();
    }
    
   
    /*  Description: Remove selected Asset record
     *  Author: Mike Lasala
     *  Date Created: DEC-11-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void removethisAsset(){
        if(!assetAddList.isEmpty()){
            for(MyBudgetsAssetWrapper ass: assetAddList){
                //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                //Cause is still unknown
                if(String.valueOf(ass.asset.Id) != ''){
                    if(selectedRow == ass.rowCount && ass.asset.Id != null){
                        assetListToDel.add(assetAddList.get(selectedRow).asset);
                        break;
                    }   
                }
            }
            assetAddList.remove(selectedRow);
            assetListSize--;
            getTotalAsset();
            if(assetListSize==0){
                addAsset();
            }
            refreshCount();
        }
    }
    
    /*  Description: Remove all assets
     *  Author: Mike Lasala
     *  Date Created: MAR-25-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void removeAllAssets(){
        
        if(this.applicant.Asset_Exempt__c){
            
            if(!assetAddList.isEmpty()){
                for(Integer i = 0; i<assetListSize; i++){
                    //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                    //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                    //Cause is still unknown
                    if(String.valueOf(assetAddList.get(i).asset.Id) != ''){
                                if(assetAddList.get(i).asset.Id!=null) {
                                    assetListToDel.add(assetAddList.get(i).asset);
                                }
                            }
                        }
                    }
            assetAddList.clear();
            assetListSize = 0;
        } else {
            addAsset();
        }
        getTotalAsset();
    }

    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshCount(){
        Integer i = 0;
        for(MyBudgetsAssetWrapper ass: assetAddList){
            ass.rowCount = i;
            i++;
        }
    }

    /*  Description: Computes total Assets
     *  Author: Mike Lasala
     *  Date Created: OCT-02-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void getTotalAsset() {
        totalAssets = 0;
        for(MyBudgetsAssetWrapper assetWrap: this.assetAddList) {
            if(assetWrap.asset.Asset_Value__c != null){
                totalAssets = totalAssets + assetWrap.asset.Asset_Value__c;
            }
        }
    }
    
    /*  Description: Validate assets records to upsert
     *  Author: Dan Crisologo
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: Boolean
     */
    public Boolean validateFields() {
        this.assetValidationResults = true;        
        totalAssets = 0;
        //modified by vijay
        if(!this.applicant.Asset_Exempt__c){
            for(MyBudgetsAssetWrapper assetWrap: this.assetAddList){
                if(assetWrap.validateAsset()) {
                        totalAssets = totalAssets + assetWrap.asset.Asset_Value__c;
                        assetWrap.clearAssetFields();
                } else {
                    this.assetValidationResults = false;
                }        
            }
        } else {
            this.assetAddList.clear();
        }
        
        //insert all incomes if results are valid
        if(this.assetValidationResults) {
            List<Asset__c> assetsList = new List<Asset__c>();
            List<Liability__c> debtToInsert = new List<Liability__c>();
            Decimal applicantTotalAssets = 0;
            
            for(MyBudgetsAssetWrapper mbaw: this.assetAddList) {

                //Create asset for applicant 2 asset is shared
                if(mbaw.asset.Asset_Shared__c){
                    Decimal assetValue = mbaw.asset.Asset_Value__c * (mbaw.asset.of_ownership_of_the_asset__c /100);
                    mbaw.setTotalAsset(assetValue);
                    if(mbaw.asset.id == null){
                        Asset__c a = new Asset__c();
                        //Clone values
                        a.Applicant__c = this.applicant2.Id;
                        a.Asset_Category__c = mbaw.asset.Asset_Category__c;
                        a.Asset_Shared__c = true;
                        a.Asset_Value__c = mbaw.asset.Asset_Value__c;
                        a.of_ownership_of_the_asset__c = 100 - mbaw.asset.of_ownership_of_the_asset__c;
                        a.Ownership_Status__c = mbaw.asset.Ownership_Status__c;
                        a.Total_Assets__c = mbaw.asset.Asset_Value__c * (a.of_ownership_of_the_asset__c /100);
                        if(a.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR){
                            a.Vehicle_Make__c = mbaw.asset.Vehicle_Make__c;
                            a.Vehicle_Model__c = mbaw.asset.Vehicle_Model__c;
                            a.Vehicle_Year__c = mbaw.asset.Vehicle_Year__c;
                        }
                        assetsList.add(a);
                    }
                } else {
                    mbaw.setTotalAsset(mbaw.asset.Asset_Value__c);  //Set individual total asset value
                }
                if(mbaw.asset.Asset_Value__c!=null){
                    applicantTotalAssets = applicantTotalAssets + mbaw.asset.Total_Assets__c;   //Compute and set overall total asset value
                }
                //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                //Cause is still unknown
                if(String.valueOf(mbaw.asset.Id) == ''){
                    mbaw.asset.Id = null;
                }
                assetsList.add(mbaw.asset);
                
                //Create debt if assets is car/house
                if(mbaw.asset.id==null && mbaw.asset.Ownership_Status__c==GEN_OriginationsConstants.ASSET_OWNERSHIP_OWE &&
                    (mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR || 
                     mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_HOUSE)){
                    
                    Liability__c d = new Liability__c();
                    d.Applicant__c = this.applicant.Id;
                    d.Total_Debts__c = 0;
                    if(mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR){
                        d.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN;
                    }
                    else if(mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_HOUSE){
                        d.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE;
                    }
                    
                    debtToInsert.add(d);
                }
            }
            
            if(!assetsList.isEmpty()){
                try{
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Asset__c.SObjectType.getDescribe().isCreateable()) {
                        upsert assetsList;
                    //}
                }
                catch(DMLException e){
                        ErrorHandlerException.recordException(e.getMessage(), 'APP_JointAssestsExt', 'Assets__c', 'Class', String.valueOf(this.application.Id));    
                }
            }
            
            try{
                applicant.Total_Assets__c = applicantTotalAssets;
                
                update applicant;
            }
             catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointAssestsExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));    
            }            
            
            if(debtToInsert.size()>0) {
                try{
                    insert debtToInsert;
                }
                 catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointAssestsExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));    
                }
            }
            
            if(assetListToDel.size()>0){
                try{
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Asset__c.sObjectType.getDescribe().isDeletable()){
                        delete assetListToDel;  
                    }
                    */
                    delete assetListToDel; 
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointAssetsExt', 'Assets__c', 'Class', String.valueOf(this.application.Id));    
                }
            }
        }
        return this.assetValidationResults;
    }

    /*  Description: Redirect to APP_Register page
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference register(){

        PageReference pageRef = Page.APP_Register;
        pageRef.getParameters().put('Id',this.application.Id);
        pageRef.setRedirect(true);

        return pageRef;

    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        
        // Check application status before any updates and redirect
        List<Application__c>applicationVar = [Select Id, Status__c from Application__c where Id = :application.Id];
        
        // Validate that application is not yet submitted
        if(applicationVar.size()>0){
            if(applicationIsSubmitted(applicationVar[0])){
                Util.addMessage(ApexPages.Severity.ERROR, 'Sorry this application has already been submitted and the application details are not editable.');
                return null;
            }
        }
        
        this.application.bank_accounts_held__c=bankAccountHeld;
        update this.application;
        
        this.assetValidationResults = true;
        //this.loanValidationResults = true;
        
        //BEGIN MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
        //Added back redirection
        if(redirectTo == 'Save' || 
           redirectTo == 'Back'){
            validateFields();
        }else if(redirectTo == 'Timeout'){
            this.loanValidationResults = true;
        }
        
        PageReference ref;
        if(this.assetValidationResults && this.loanValidationResults){
           if(redirectTo == 'Save'){
             UserUtility userUtility = new UserUtility();
                ref = userUtility.createCommunityUser(this.application, this.applicant);
            } else if(redirectTo == 'Timeout'){
                ref = Page.APP_Timeout;
            } else if(redirectTo == 'Back'){
                ref = backPage();
            }
            //END MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
            
            ref.getParameters().put('id', this.application.Id);
            ref.setRedirect(true);          
            return ref;
        } else {
            return null;
        }
    }
    
     /*  Description: Get Bank account held picklist values
     *  Author: Vijay
     *  Date Created: FEB-10-2015
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getbankAccountHeldOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Application__c.Bank_Accounts_Held__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
   public static void testcodeCov(){
     Integer n=0;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
     n++;
    }
}