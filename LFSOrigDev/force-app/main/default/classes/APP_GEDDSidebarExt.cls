/* @Description: Controller for GEDDSidebar component
 * @Author: Russel Cadapan
 * @Date Created: FEB-12-2014
 * @History:
   =====================================================================
       02-12-14: Created - Russel
       03-20-14: Refactored - Mike
   =====================================================================
 */ 
public class APP_GEDDSidebarExt extends APP_CommonExt{
    //Public Properties 
    public String responseCodeControlType       {get;set;}  //apex:attribute on component
    public String personalDetailsButtonClass    {get;set;}  //personal details button styleclass
    public String incomeButtonClass             {get;set;}  //income button styleclass
    public String assetButtonClass              {get;set;}  //asset button styleclass
    public String expenseButtonClass            {get;set;}  //expense button styleclass
    public String debtButtonClass               {get;set;}  //debt button styleclass
    public String applicationId                 {get;set;}  //application id
    public String activeTile                    {get;set;}  //active page indicator for post submit
    public Integer areasLeft                    {get;set;}  //dynamic number of areas left to complete
    public String acceptanceChannel             {get;set;}  //application acceptane channel
    public String navigationPage                {get;set;}
    public String BrandString                   {get;set;}
    public String productSubType                {get;set;}  
    public Boolean appStatus                    {get;set;}
    public Boolean isSoftQuoteApp               {get;set;}
    public PageReference pageRef;
    public APP_GEDDSidebarExt(){
        super();

        //Get Application Id
        applicationId = ApexPages.currentPage().getParameters().get('id');
        isSoftQuoteApp= false;
        areasLeft = 0;

        if(applicationId != null){
            appStatus = UserUtility.checkApplicationStatus(applicationId);

            //Get application acceptance channel 
            Application__c app = [SELECT    Acceptance_Channel__c,Brand_String__c , Channel__c, Product_SubType__c
                                  FROM      Application__c 
                                  WHERE     Id =: applicationId LIMIT 1];
            BrandString = app.Brand_String__c;

            /**Better Start Fix for Save & Retrieve */
            productSubType = app.Product_SubType__c;
           
                                  
            if(app.Acceptance_Channel__c != null){
                acceptanceChannel = app.Acceptance_Channel__c;
            }
            else {
                acceptanceChannel = '';
            }

            if(app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){  //Afreen- 28/04/2016 : User story 271 - To identify whether the channel is broker or not
                isBrokerChannel = true;
            }
            // Softquote Changes Start: Check the Applications linked with Softquote
            
            for (Quote__c quoteApp : [SELECT Id,Application__c, Quote_Stage__c 
                                  FROM Quote__c 
                                  where 
                                  Quote_Stage__c ='Quote Offered' AND
                                  Application__c =: applicationId LIMIT 1]){
                                  
              if(quoteApp != null &&  quoteApp.Application__c != null){
                 isSoftQuoteApp=true;
                 }              
                                  
            }
                             
             // Softquote Changes End: Check the Applications linked with Softquote/
            //Get related Applicants
            List<Applicant__c> applicantList = APP_CommonVariables.retrieveApplicants(applicationId);

            if(!applicantList.isEmpty()){
                //Get related budget records
                List<Income__c>     incomeList   = applicantList.get(0).Incomes__r;
                List<Asset__c>      assetList    = applicantList.get(0).Assets__r;
                List<Expense__c>    expenseList  = applicantList.get(0).Expenses__r;
                List<Liability__c>  debtList     = applicantList.get(0).Liabilities__r;

                //Identify complete/incomplete and set navigation tile CSS
                //Count number of areas remaining
                if(applicantList.get(0).Asset_Exempt__c){
                    assetButtonClass        = setButtonClass(applicantList.get(0).Asset_Exempt__c);
                    areasLeft               = countAreas(areasLeft, applicantList.get(0).Asset_Exempt__c);
                } else {
                    assetButtonClass        = setButtonClass(assetList.size());
                    areasLeft               = countAreas(areasLeft, assetList.size());
                }
                
                if(applicantList.get(0).Debts_Exempt__c){
                    debtButtonClass         = setButtonClass(applicantList.get(0).Debts_Exempt__c);
                    areasLeft               = countAreas(areasLeft, applicantList.get(0).Debts_Exempt__c);
                } else {
                    //RCADAPAN: 04/15/2014 - Indication that the Debt record dynamically inserted via Asset page is completed
                    if(debtList.size() > 0 && (debtList.get(0).Financier_Name__c != null || debtList.get(0).Financier_List__c != null)){
                        debtButtonClass     = GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE;
                        areasLeft               = countAreas(areasLeft, debtList.size());
                    }else{
                        debtButtonClass         = GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE;
                        areasLeft               = countAreas(areasLeft, 0);
                    }
                }

                if(applicantList.size()>1){
                    personalDetailsButtonClass  = setButtonClass(applicantList.get(0).First_Name__c != null && applicantList.get(0).Last_Name__c != null &&
                                                                 applicantList.get(1).First_Name__c != null && applicantList.get(1).Last_Name__c != null);

                    List<Income__c>     incomeList2   = applicantList.get(1).Incomes__r;
                    expenseList  = applicantList.get(0).Expenses__r;

                    incomeButtonClass   = setButtonClass(incomeList.size(), incomeList2.size());
                    //expenseButtonClass  = setButtonClass(expenseList.size(), expenseList2.size());
                    expenseButtonClass          = setExpenseButtonClass(expenseList.size(),expenseList);
                    
                    areasLeft = countAreas(areasLeft, (applicantList.get(0).First_Name__c != null && applicantList.get(0).Last_Name__c != null &&
                                                      applicantList.get(1).First_Name__c != null && applicantList.get(1).Last_Name__c != null));
                    
                    areasLeft           = countAreas(areasLeft, incomeList.size(), incomeList2.size());
                    //areasLeft           = countAreas(areasLeft, expenseList2.size(), expenseList2.size());
                    areasLeft = countAreas(areasLeft, expenseList.size());
                } else {
                    personalDetailsButtonClass  = setButtonClass(applicantList.get(0).First_Name__c != null && applicantList.get(0).Last_Name__c != null);
                    incomeButtonClass           = setButtonClass(incomeList.size());
                    expenseButtonClass          = setExpenseButtonClass(expenseList.size(),expenseList);

                    areasLeft = countAreas(areasLeft, applicantList.get(0).First_Name__c != null && applicantList.get(0).Last_Name__c != null);
                    areasLeft = countAreas(areasLeft, incomeList.size());
                    areasLeft = countAreas(areasLeft, expenseList.size());
                }

                //Identify active page and set navigation tile CSS
                if(getActiveTile(GEN_OriginationsConstants.PAGE_PERSONAL)){
                    personalDetailsButtonClass = GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_INCOME1)){
                    incomeButtonClass = GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_ASSET)){
                    assetButtonClass = GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_EXPENSE)){
                    expenseButtonClass = GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_DEBTS)){
                    debtButtonClass = GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_CUIFILEUPLOAD)){
                    activeTile = GEN_OriginationsConstants.TILE_UPLOAD;
                }
                else if(getActiveTile(GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE)){
                    activeTile = GEN_OriginationsConstants.TILE_CONTRACT;
                }
                else {
                    activeTile = '';
                }
            }
        }
    }

    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    
    /*  Description: Redirect to File Upload page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToUpload(){
        pageRef = Page.APP_CustomerUIFileUpload;
        pageRef.getParameters().put('id', applicationId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Download page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToDownload(){
        pageRef = Page.APP_Download;
        pageRef.getParameters().put('id', applicationId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to View Contract page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToContract(){
        pageRef = Page.APP_ContractAcceptance;
        pageRef.getParameters().put('id', applicationId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToEligibility(){
        pageRef = Page.APP_Eligibility;
        pageRef.getParameters().put('id', applicationId);
        if(isBrokerChannel){
            pageRef.getParameters().put('form', 'broker');
        }
        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToPersonal(){
        pageRef = Page.APP_JointPersonalDetails;
        pageRef.getParameters().put('id', applicationId);

        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }

        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToIncome(){
        pageRef = Page.App_JointIncome;
        pageRef.getParameters().put('id', applicationId);

        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }

        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToExpense(){
        pageRef = Page.App_JointExpenses;
        pageRef.getParameters().put('id', applicationId);

        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }


        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToAsset(){
        pageRef = Page.App_JointAssets;
        pageRef.getParameters().put('id', applicationId);

        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Redirect to Income page
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToDebt(){
        pageRef = Page.App_JointDebtAndLiabilities;
        pageRef.getParameters().put('id', applicationId);

        /**Better Start Fix for Save & Retrieve*/
        if(productSubType == 'Better Start PL'){
            pageRef.getParameters().put('subType','betterStart');
        }

        pageRef.setRedirect(true);
        return pageRef;
    }

    /*  Description: Set expense button style class
     *  Author: Arshad
     *  Input Parameters: Integer
     *  Return: String
     */ 
    public String setExpenseButtonClass(Integer listSize, List<Expense__c> expList){
        if(listSize>0 && expList[0].Food_Groc_Entert__c != null){
            return GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE;
        } else {
            return GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE;
        }
    }

    
    /*  Description: Set button style class
     *  Author: Mike Lasala
     *  Input Parameters: Integer
     *  Return: String
     */ 
    public String setButtonClass(Integer listSize){
        if(listSize>0){
            return GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE;
        } else {
            return GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE;
        }
    }

    /*  Description: Set button style class on 2 lists count (joint)
     *  Author: Mike Lasala
     *  Input Parameters: Integer
     *  Return: String
     */ 
    public String setButtonClass(Integer listSize, Integer list2Size){
        if(listSize > 0 && list2Size > 0){
            return GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE;
        } else {
            return GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE;
        }
    }

    /*  Description: Set button style class
     *  Author: Mike Lasala
     *  Input Parameters: Boolean
     *  Return: String
     */ 
    public String setButtonClass(Boolean bool){
        if(bool){
            return GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE;
        } else {
            return GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE;
        }
    }

    /*  Description: Count areas left on list count
     *  Author: Mike Lasala
     *  Input Parameters: Integer
     *  Return: Integer
     */ 
    public Integer countAreas(Integer areas, Integer listSize){
        if(listSize == 0){
            areas = areas + 1;
        }
        return areas;
    }

    /*  Description: Count areas left on 2 lists count (joint)
     *  Author: Mike Lasala
     *  Input Parameters: Integer
     *  Return: Integer
     */ 
    public Integer countAreas(Integer areas, Integer listSize, Integer list2Size){
        if(listSize == 0 || list2Size == 0){
            areas = areas + 1;
        }
        return areas;
    }

    /*  Description: Count areas left on boolean
     *  Author: Mike Lasala
     *  Input Parameters: Boolean
     *  Return: Integer
     */ 
    public Integer countAreas(Integer areas, Boolean bool){
        if(!bool){
            areas = areas + 1;
        }
        return areas;
    }

    /*  Description: Set boolean if current page is active
     *  Author: Mike Lasala
     *  Input Parameters: String
     *  Return: Boolean
     */
    public Boolean getActiveTile(String pageName){
        Boolean isActive = false;
        
        if(String.valueOf(apexPages.currentPage()).toLowerCase().contains(pageName.toLowerCase())){
            isActive = true;
        }
        return isActive;
    }
}