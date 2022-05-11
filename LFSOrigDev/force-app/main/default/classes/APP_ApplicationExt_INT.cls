/* @Description: Controller for Application page (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: JAN-28-2014
 * @History:
   =====================================================================
       01-28-14: Created - Mike
   =====================================================================
 */ 
public class APP_ApplicationExt_INT extends APP_CommonExt {
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    transient public List<AML__c>               amlList         {get;set;}
    transient public List<Related_Document__c>  documentList    {get;set;}
    
    transient public List<AML__c>               amlList2        {get;set;}
    transient public List<Related_Document__c>  documentList2   {get;set;}
    
    //For enable/disable of new/edit buttons
    transient public Boolean editPersonalDetailsButton          {get;set;}
    transient public Boolean editIncomeButton                   {get;set;}
    transient public Boolean editAssetButton                    {get;set;}
    transient public Boolean editExpenseButton                  {get;set;}
    transient public Boolean editDebtButton                     {get;set;}
    transient public Boolean newAMLButton                       {get;set;}
    transient public Boolean newAMLButton2                      {get;set;}
    transient public Boolean newEditDocumentButton              {get;set;}
    
    transient public String applicantTab                        {get;set;}  //For identifying which applicant tab is focused 1 or 2
    transient public Brand__c applicationBrand                  {get;set;}
    transient public Boolean isJoint                            {get;set;}
    transient public Boolean isStraightThrough                  {get;set;}  //ADDED by RCADAPAN 18-MAR-2016 for TQLQW-99
    public String redirectTo                                    {get;set;}  //For identifying which page to go to
    public String redirectWho                                   {get;set;}  //For identifying which applicant to go to

    transient public Boolean removeApplicantButton                        {get;set;} //remove applicant button control

      //Better Start
        public Boolean isBSAUActive {get;set;}
        public Boolean isBSNZActive {get;set;}
        
    public APP_ApplicationExt_INT(ApexPages.StandardController applicationController) { 
        super(applicationController);
          //Better Start
        isBSAUActive = false;
        isBSNZActive = false;
         Better_Start_Offer__c bso = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
         isBSAUActive = bso.BetterStartAUActive__c;
         isBSNZActive = bso.BetterStartNZActive__c;
        //End  
        removeApplicantButton = buttonControl();

        isJoint = isJoint();    //Identify Application if Single or Joint

        if(this.application.Brand_Lookup__c != null){
            //Get Brand Name
            applicationBrand = [SELECT  Name 
                                FROM    Brand__c 
                                WHERE   Id =: this.application.Brand_Lookup__c];
        }
            
        if(!this.applicantList.isEmpty()){
            this.totalIncome = 0;
            totalExpense = 0;
            totalDebt = 0;
            totalAsset = 0;
            
            //Calculate total amounts
            for(Applicant__c a: this.applicantList){
                if(a.Total_Income__c != null){
                    this.totalIncome += a.Total_Income__c;    
                }
                if(a.Total_Expense__c != null){
                    totalExpense += a.Total_Expense__c;
                }
                if(a.Total_Debts__c != null){
                    totalDebt += a.Total_Debts__c;
                }    
                if(a.Total_Assets__c != null){
                    totalAsset += a.Total_Assets__c;
                }
            }

            //Retrieve related records
            incomeList   = this.applicantList[0].Incomes__r;
            assetList    = this.applicantList[0].Assets__r;
            expenseList  = this.applicantList[0].Expenses__r;
            debtList     = this.applicantList[0].Liabilities__r;
            amlList      = this.applicantList[0].AMLs__r;
            documentList = this.applicantList[0].Related_Documents__r;   
            
            //Retrieve related records for Applicant 2
            if(this.applicantList.size()>1){
                incomeList2   = this.applicantList[1].Incomes__r;
                expenseList2  = this.applicantList[1].Expenses__r;
                amlList2      = this.applicantList[1].AMLs__r;
                documentList2 = this.applicantList[1].Related_Documents__r;
            }
        }
        // Start - ADDED by RCADAPAN 18-MAR-2016 for TQLQW-99
        isStraightThrough = false;
        if(this.application.Response_Code__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
            Id appId = this.application.Id;
            Application__c currentApplication = APP_GSD_BaseController.queryApplicationRecord(appId);
            isStraightThrough = APP_GSD_BaseController.isApplicationStraightThrough(currentApplication);
        }
        // End - TQLQW-99

        updateStatusTracker(this.applicantList);    //Toggles status icon on sub tabs
        showHideButton(String.valueOf(application.Response_Code__c));   //Enable/disable of buttons on the page
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Sets status icons on Applicant sub tab
     *  Author: Russell Cadapan
     *  Input Parameters: List<Applicant__c>
     *  Return: void
     */ 
    public void updateStatusTracker(List<Applicant__c> applicantListEntries){
        //Set initial status to false
        this.app1AboutMe = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app1Income = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app1Asset = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app1Expense = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app1Debts = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app1Status = GEN_OriginationsConstants.STATUS_UNCHECK;
        
        this.app2AboutMe = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app2Income = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app2Asset = GEN_OriginationsConstants.STATUS_CHECK;
        this.app2Expense = GEN_OriginationsConstants.STATUS_UNCHECK;
        this.app2Debts = GEN_OriginationsConstants.STATUS_CHECK;
        this.app2Status = GEN_OriginationsConstants.STATUS_UNCHECK;
        
        //Set status to true if conditions are met
        if(!applicantListEntries.isEmpty()){
            //Applicant 1
            if(this.applicantList[0].First_Name__c != null && this.applicantList[0].Last_Name__c != null){
                this.app1AboutMe = GEN_OriginationsConstants.STATUS_CHECK;
            }
            if(this.incomeList.size() > 0){
                this.app1Income = GEN_OriginationsConstants.STATUS_CHECK;
            }
            if(this.assetList.size() > 0){
                this.app1Asset = GEN_OriginationsConstants.STATUS_CHECK;
            }
            if(this.expenseList.size() > 0){
                this.app1Expense = GEN_OriginationsConstants.STATUS_CHECK;
            }
            if(this.debtList.size() > 0){
                //indication that the debt is inserted from owed asset has been completed
                if(this.debtList[0].Financier_Name__c != null || this.debtList[0].Financier_List__c != null){
                    this.app1Debts = GEN_OriginationsConstants.STATUS_CHECK; 
                }
            }            
            if(this.app1AboutMe == GEN_OriginationsConstants.STATUS_CHECK && this.app1Income == GEN_OriginationsConstants.STATUS_CHECK && this.app1Asset == GEN_OriginationsConstants.STATUS_CHECK && this.app1Expense == GEN_OriginationsConstants.STATUS_CHECK && this.app1Debts == GEN_OriginationsConstants.STATUS_CHECK){
                this.app1Status = GEN_OriginationsConstants.STATUS_CHECK;
            }
            
            //Applicant 2
            if(applicantListEntries.size() > 1){
                if(applicantListEntries[1].First_Name__c != null && this.applicantList[1].Last_Name__c != null){
                    this.app2AboutMe = GEN_OriginationsConstants.STATUS_CHECK;
                }
                if(this.incomeList2.size() > 0){
                    this.app2Income = GEN_OriginationsConstants.STATUS_CHECK;
                }
                if(this.expenseList2.size() > 0){
                    this.app2Expense = GEN_OriginationsConstants.STATUS_CHECK;
                }
                //looking for applicant 1 asset and debt records for joint to track completeness for applicant 2
                if(this.assetList.size() > 0){
                    this.app2Asset = GEN_OriginationsConstants.STATUS_CHECK;
                }
                if(this.debtList.size() > 0){
                    this.app2Debts = GEN_OriginationsConstants.STATUS_CHECK; 
                }
                if(this.app2AboutMe == GEN_OriginationsConstants.STATUS_CHECK && this.app2Income == GEN_OriginationsConstants.STATUS_CHECK && this.app2Asset == GEN_OriginationsConstants.STATUS_CHECK && this.app2Expense == GEN_OriginationsConstants.STATUS_CHECK && this.app2Debts == GEN_OriginationsConstants.STATUS_CHECK){
                    this.app2Status = GEN_OriginationsConstants.STATUS_CHECK;
                }
            }
        }
    }
    
    /* 
    *  Description: This will control button rendering
    *  Author: Jade Serrano
    *  Input Parameters: String
    *  Return: Boolean
    */
    public void showHideButton (String status) {
        List<Response_Code_Control__c> rList = new List<Response_Code_Control__c>();
        
        //Retreive Response Code Control record based on status parameter
        rList = [SELECT Id 
                 FROM   Response_Code_Control__c 
                 WHERE  Name =: status];
                 
        if(!rList.isEmpty()){
            //Get values: enable/disable based on Response Code and Profile Control settings
            Boolean resEditPersonalDetails = Response_Code_Control__c.getInstance(status).Edit_Personal_Details__c;
            Boolean proEditPersonalDetails = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Personal_Details__c;

            Boolean resEditIncome = Response_Code_Control__c.getInstance(status).Edit_Income__c;
            Boolean proEditIncome = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Income__c;

            Boolean resEditAsset = Response_Code_Control__c.getInstance(status).Edit_Asset__c;
            Boolean proEditAsset = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Asset__c;

            Boolean resEditExpense = Response_Code_Control__c.getInstance(status).Edit_Expense__c;
            Boolean proEditExpense = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Expense__c;

            Boolean resEditDebt = Response_Code_Control__c.getInstance(status).Edit_Debt__c;
            Boolean proEditDebt = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Debt__c;

            Boolean resNewAML = Response_Code_Control__c.getInstance(status).New_AML__c;
            Boolean proNewAML = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_AML__c;

            Boolean resNewEditDocument = Response_Code_Control__c.getInstance(status).New_Edit_Document__c;
            Boolean proNewEditDocument = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_Edit_Document__c;
            
            //Identify whether both Response Code and Profile Control values are true
            if(resEditPersonalDetails && proEditPersonalDetails){
                editPersonalDetailsButton = false;
            } else {
                editPersonalDetailsButton = true;
            }

            if(resEditIncome && proEditIncome){
                editIncomeButton = false;
            } else {
                editIncomeButton = true;
            }

            if(resEditAsset && proEditAsset){
                editAssetButton = false;
            } else {
                editAssetButton = true;
            }

            if(resEditExpense && proEditExpense){
                editExpenseButton = false;
            } else {
                editExpenseButton = true;
            }

            if(resEditDebt && proEditDebt){
                editDebtButton = false;
            } else {
                editDebtButton = true;
            }

            if(resNewAML && proNewAML){
                newAMLButton = false;
                newAMLButton2 = false;
            } else {
                newAMLButton = true;
                newAMLButton2 = true;
            }

            if(resNewEditDocument && proNewEditDocument){
                newEditDocumentButton = false;
            } else {
                newEditDocumentButton = true;
            }
                        
        } else {
            editPersonalDetailsButton = true;
            editIncomeButton = true;
            editAssetButton = true;
            editExpenseButton = true;
            editDebtButton = true;
            newAMLButton = true;
            newEditDocumentButton = true;
            Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');            
        }
    }

    //application button rendering
    public Boolean buttonControl(){

        Boolean ret;

        List<Response_Code_Control__c> responseCodeControlList = new List<Response_Code_Control__c>();
        responseCodeControlList = [Select Id From Response_Code_Control__c Where Name =: this.application.Response_Code__c];

        if(responseCodeControlList.size()>0){

        Boolean responseCodeControl = Response_Code_Control__c.getInstance(this.application.Response_Code__c).Remove_Applicant__c;
        Boolean profileControl = Profile_Control__c.getInstance(UserInfo.getProfileId()).Remove_Applicant__c;

        if(responseCodeControl && profileControl){
            ret = false;
        }else{
            ret = true;
        }

        return ret;

        }else{

          Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
          return ret;

        }
    }
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-28-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        PageReference ref;
        
        if(redirectTo == 'applicant'){
            ref = Page.APP_JointPersonalDetails_INT;
        } else if(redirectTo == 'income'){
            ref = Page.APP_JointIncome_INT;
        } else if(redirectTo == 'asset'){
            ref = Page.APP_JointAssets_INT;
        } else if(redirectTo == 'expense'){
            ref = Page.APP_JointExpenses_INT;
        } else if(redirectTo == 'debt'){
            ref = Page.APP_JointDebtAndLiabilities_INT;
        } else if(redirectTo == 'aml'){
            ref = Page.APP_AML;
        } else {
            return null;
        }
        
        if(redirectTo == 'aml' || redirectTo == 'document'){
            if(redirectWho == '1'){
                ref.getParameters().put('aId', applicant.Id);
            } else if(redirectWho == '2'){
                ref.getParameters().put('aId', applicant2.Id);
            }
        }
        
        ref.getParameters().put('mode', 'Edit');
        ref.getParameters().put('id', this.application.Id);
        ref.setRedirect(true);          
        return ref;
    }

    /* Description: Method to call the class that handles the delete of Applicant 2.
     *  Author: Fel Saliba
     *  Date Created: JAN-30-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference deleteApplicant(){
        System.debug('### DELETING APPLICANT ' + applicant + ' ' + applicant2);
        IS_ApplicationDTO applicationDTO  = new IS_ApplicationDTO();
        applicationDTO.app = application;
        applicationDTO.applicant = applicant;
        applicationDTO.applicant2 = applicant2;
        
        APP_RemoveSecondApplicant removeApplicant = new APP_RemoveSecondApplicant();
        removeApplicant.deleteApplicantRecord(applicationDTO);
        
        PageReference ref;
        ref = Page.APP_ApplicationMain_INT;
        ref.getParameters().put('id', String.valueOf(this.application.Id));
        ref.setRedirect(true);
        return ref;        
    }
}