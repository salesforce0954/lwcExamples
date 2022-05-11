/* @Description: Base Controller being used across all the extensions developed under GSD project 
 * @Author : Afreen Khan
 * @Date : 22-01-2016
 * @History:
   =========================================================================================================
        JAN-01-2016 : Created - Afreen
        JUNE-15-2016 : Updated - Adrian - Added Green Id DNB Outcome field in applicant query in queryApplicationRecord method.
   =========================================================================================================
*/

global with sharing virtual class APP_GSD_BaseController {
    
    // Constructor to allow init, and class extension with standard controller
    public APP_GSD_BaseController(ApexPages.StandardController appController){
        
    }
    
    // Constructor to allow init, and class extension without standard controller
    public APP_GSD_BaseController(){
        
    }
    
    public APP_GSD_BaseController getThis(){
        return this;
    }

    /*  Description: method to validate whether the application is simple or complex. Simple = StraightThrough
     *  Author: Russell Cadapan
     *  Date Created: JAN-22-2016
     *  Input: Application__c
     *  Return: Boolean
    */
    public static Boolean isApplicationStraightThrough(Application__c appRecord){
        Boolean flag = false;

        String appChannel = appRecord.Channel__c;
        String appStatus = appRecord.Status__c;
        String appBrandCountry = appRecord.Brand_Country__c;
        String appTypeOfProduct = appRecord.Type_of_Product__c;
        String appType = appRecord.Application_Type__c;
        String appBrandString = appRecord.Brand_String__c;
        Decimal appInterestRate = appRecord.Offered_Interest_Rate__c;
        
        List<Disbursement__c> appDisbursements = appRecord.Disbursements__r;
        
        // check if the application is not declined, not an auto-loan and disbursement is not greater than 1 and Channel is not a Broker and not a Joint Application.
        if(appStatus != GEN_OriginationsConstants.APP_RESPONSE_CODE_DECLINED
            && appTypeOfProduct != GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN
            && appDisbursements.size() < 2
            && appChannel != GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER
            && appType != GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){

            List<Loan_Purpose__c> appLoanPurpose = appRecord.Loan_Purpose__r;
            System.debug('Loan Purposessss ****  ' + appLoanPurpose);
            // check each loan purpose if straight and neither debt consolidation nor re-finance for both region.
            for(Loan_Purpose__c lp: appLoanPurpose){
                String loanPurposeValue = String.valueOf(lp.Value__c).toLowerCase();
                if(appBrandCountry == GEN_OriginationsConstants.AU_REGION){
                   // if(GEN_OriginationsConstants.AU_STRAIGHT_LOAN_PURPOSE.contains(loanPurposeValue) && !GEN_OriginationsConstants.AU_COMPLEX_LOAN_PURPOSES.contains(loanPurposeValue)){
                    if(
                    (GEN_OriginationsConstants.AU_STRAIGHT_LOAN_PURPOSE.contains(loanPurposeValue) && !GEN_OriginationsConstants.AU_COMPLEX_LOAN_PURPOSES.contains(loanPurposeValue)) || 
                    (appLoanPurpose.size() > 1 && GEN_OriginationsConstants.AU_COMPLEX_LOAN_PURPOSE_DEBT_CONSOLIDATION.contains(loanPurposeValue))
                    ){
                        flag = true;
                        System.debug('***** Loop Entered ****');
                    }
                    else{
                        flag = false;
                        break;
                    }
                }
                else if(appBrandCountry == GEN_OriginationsConstants.NZ_REGION){
                    if(GEN_OriginationsConstants.NZ_STRAIGHT_LOAN_PURPOSE.contains(loanPurposeValue) && !GEN_OriginationsConstants.NZ_COMPLEX_LOAN_PURPOSES.contains(loanPurposeValue)){
                        flag = true;
                    }
                    else{
                        flag = false;
                        break;
                    }
                }
            }
            // check for Kiwibank if Interest Rate exceeds Bar rate. If true, application will not be eligible for straight-through processing.
            if(appBrandString == GEN_OriginationsConstants.BRAND_NAME_KIWI){
                if(appInterestRate != null && appInterestRate > GEN_OriginationsConstants.KIWIBANK_BAR_RATE_LIMIT){
                    flag = false;
                }
            }
        }
        return flag;
    }
    
    /*  Description: Get Brand name based on site
     *  Author: Mike Lasala
     *  Date Created: 03-FEB-2016
     *  Input: None
     *  Return: String (Brand name)
    */
    public static String getBrandNameOfSite(){
        Brand__c brand = [SELECT Name FROM Brand__c WHERE Site__c = : Site.getName() LIMIT 1];
        if(brand.Name != null){
            return brand.Name;
        } else {
            return '';
        }
    }    
    
     /*  Description: Get timeout duration from custom settings
     *  Author: Mike Lasala
     *  Date Created: 04-FEB-2016
     *  Input: None
     *  Return: Integer (Timeout duration)
    */
    public static Integer timeout(){
        return Integer.valueOf(Admin_Settings__c.getValues('Timeout').Value__c);
    }
    
    /*  Description: Identify if loan details should be displayed using risk grade comparison to custom setting values
     *  Author: Russell Cadapan
     *  Date Created: 16-MAR-2016
     *  Inputs: Application record
     *  Return: Boolean
    */
    //BEGIN MLASALA: 06-APR-2016 DEFECT 486 FIX
    public static Boolean displayLoanDetailsViaRiskGrade(Application__c app){
        Boolean flag = true;
        String riskGrade = app.Credit_Score__c;
        
        Set<String> validResponseCodesSet = new Set<String>();
        
        //Add Pre/Post Bureau Referred response codes for both AU/NZ
        validResponseCodesSet.add(GEN_OriginationsConstants.PRE_BUREAU_RESPONSE_CODE);
        validResponseCodesSet.add(GEN_OriginationsConstants.POST_BUREAU_RESPONSE_CODE);
        validResponseCodesSet.add(GEN_OriginationsConstants.FRAUD_WATCHLIST_RESPONSE_CDDE);
        validResponseCodesSet.add(GEN_OriginationsConstants.CPU_RESPONSE_CODE);
        validResponseCodesSet.add(GEN_OriginationsConstants.SALES_RESPONSE_CODE);
        
        // validate if the application's channel is Broker. If true, do not display the loan summary details - TQLQW - 510
        if(app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
            flag = false;
        }
        else{
            //Validate if Application response code is valid for the display risk grade logic
            if(!validResponseCodesSet.contains(app.Response_Code__c)){
                
                //set of String of acceptable risk grades for the loan details to be displayed
                Set<String> acceptableRiskGradesSet = new Set<String>();
                
                //get all the risk grades based from brands stored in the custom setting
                //MLASALA 05-MAY-2016: Added null checking for Aussie. Loan details will never be displayed for Aussie, hence the blank custom setting.
                if(Response_Pages_Risk_Grades__c.getValues(app.Brand_String__c).Value__c != null){
                    for(String s: String.valueOf(Response_Pages_Risk_Grades__c.getValues(app.Brand_String__c).Value__c).split(';')){
                        acceptableRiskGradesSet.add(s);
                    }
                }
                
                //if the application risk grade is not on the list, do not show the loan details
                if(!acceptableRiskGradesSet.contains(riskGrade)){
                    flag = false;
                }
        
                //if the brand is Kiwibank, validate if the offered interest rate is below or equals zero when the risk grade is any of the following: E, FS, RQ, TD. If true, do not show the loan details.
                if(app.Brand_String__c == GEN_OriginationsConstants.BRAND_NAME_KIWI){
                    if(app.Offered_Interest_Rate__c <= 0 && (riskGrade == 'E' || riskGrade == 'FS' || riskGrade == 'RW' || riskGrade == 'TD')){
                        flag = false;
                    }
                }
            }
        }
        //END MLASALA: 06-APR-2016 DEFECT 486 FIX
        return flag;
    }
    
    /*  Description: Wrapper class of Application and details
     *  Author: Russell Cadapan
     *  Date Created: JAN-25-2016
    */
    global class ApplicationWrapper{
        global Application__c application   {get;set;}
        global Boolean isStraightThrough    {get;set;}
        global String brandName             {get;set;}      //Added by MLASALA 03-FEB-2016
        global Integer timeout              {get;set;}      //Added by MLASALA 04-FEB-2016
        global Boolean displayLoanDetails   {get;set;}      //Added by RCADAPAN 16-MAR-2016 for TQLQW-132
        
        global ApplicationWrapper(Application__c application, Boolean isStraightThrough, String brandName, Integer timeout, Boolean displayLoanDetails){
            this.application = application;
            this.isStraightThrough = isStraightThrough;
            this.brandName = brandName;                     //Added by MLASALA 03-FEB-2016
            this.timeout = timeout;                         //Added by MLASALA 04-FEB-2016
            this.displayLoanDetails = displayLoanDetails;   //Added by RCADAPAN 16-MAR-2016 for TQLQW-132
        }
    }

    /*  Description: Method to query application record
     *  Author: Russell Cadapan
     *  Date Created: JAN-25-2016
     *  Input:  Id applicationId
     *  Return: Application__c
    */
    @RemoteAction
    global static Application__c queryApplicationRecord(Id applicationId){
        Application__c applicationRecord = [SELECT Id,
                                        Name,
                                        Application_Type__c,
                                        Total_Loan_Amount__c,
                                        Offered_Interest_Rate__c,
                                        EMI_with_Service_Fee__c,
                                        Loan_Term__c,
                                        Brand_String__c,
                                        Brand_Country__c,
                                        Brand_Lookup__r.Site__c,
                                        Status__c,
                                        Channel__c,
                                        Debit_Count__c,
                                        Disbursement_Count__c,
                                        Payment_Frequency__c,
                                        Loan_Term_Years__c,
                                        Type_of_Product__c,
                                        Brand_Lookup__c,
                                        Response_Code__c,                       //Added by MLASALA 01-FEB-2016
                                        Generated_Doc_Confirm_Sent__c,          //Added by MLASALA 01-FEB-2016 
                                        UID__c,                                 //Added by MLASALA 09-FEB-2016 
                                        Credit_Score__c,                        //Added by DYU 17-02-2016
                                        Brand_Lookup__r.LPE_Phone_Number__c,    //Added by MLASALA 29-FEB-2016
                                        Max_Monthly_Capacity__c,                //Added by MLASALA 01-MAR-2016
                                        Acceptance_Channel__c,                  //Added by MLASALA 07-MAR-2016
                                        Customer_Confirmed_Online_Offer__c,         //Added by MLASALA 16-JUN-2016
                                        Staff_Hide__c,                              //Added by MLASALA 16-JUN-2016
                                        Online_Self_serve_Upsell_Eligibility__c,    //Added by MLASALA 16-JUN-2016
                                        Online_Self_serve_Insurance_Eligibility__c, //Added by MLASALA 16-JUN-2016
                                        Initial_Requested_Amount__c,                //Added by MLASALA 06-JUL-2016
                                        Total_Insurance_Premium__c,                 //Added by MLASALA 15-JUL-2016
                                        Total_Loan_Amount_with_Insurance__c,        //Added by MLASALA 15-JUL-2016
                                        Promo_Online_Message__c,                    //Added by MLASALA 05-OCT-2016 TQLQW-524
                                        Brand_Lookup__r.File_Upload_Product__c,     //Added by RCADAPAN 19-OCT-2016 TQLQW 534
                                        (SELECT Id, Value__c FROM Loan_Purpose__r),
                                        (SELECT Id, Response_Code__c, First_Name__c, Last_Name__c, Email_Address__c, GreenId_DB_Outcome__c, Is_e_POI_eligible__c FROM Applicant__r ORDER BY Is_Primary_Applicant__c DESC), // Added Email_Address__c by Russell Cadapan for Fix Pack 1 @ 28/04/2016 // Added Green Id DB Outcome Field by ARecio 6/15/2016
                                        (SELECT Id, Application__c, Account_Holders__c, BSB_Number__c, Account_Number__c, Bank_Name__c, Branch_Location__c, Frequency__c, Repayment_Level__c, Specify_Higher_Amount__c , Commencement_Date__c, Bank_Number__c, Branch_Number__c, Account_Number_NZ__c, Suffix_Number__c FROM Debits__r),
                                        (SELECT Id, Loan_Purpose__c, Application__c, Payee__c, Amount__c, BSB__c, Bank_Acc_No__c, Fin_Institution__c, Branch__c, Bank_Number__c, Account_Holders__c, Branch_Number__c, Bank_Acc_No_NZ__c, Suffix_Number__c, Bank_Name__c, Branch_Name__c, Account_Name__c, Reference__c FROM Disbursements__r),
                                        (SELECT Id FROM Requested_Documents__r WHERE Status__c =: GEN_OriginationsConstants.REQUESTED_DOCUMENT_STATUS_REQUESTED AND Category__c != null AND Document_Type__c != null AND Number_Required__c != null),    //Added by MLASALA 02-FEB-2016 
                                        (SELECT Product_Version__r.Product_Name__c FROM Product_Items__r WHERE Product_Version__r.Type__c = 'Insurance' ORDER BY Product_Version__r.GEProduct__r.Insurance_Type_Num__c DESC)    //Added by MLASALA 27-JUN-2016 
                                FROM Application__c
                                WHERE Id =: applicationId];
        return applicationRecord;
    }

    /*  Description: Remote action to retrieve Application record and boolean indicator of the loan's complexity
     *  Author: Russell Cadapan
     *  Date Created: JAN-22-2016
     *  Input: Application Id
     *  Return: ApplicationWrapper
    */
    @RemoteAction
    global static ApplicationWrapper retrieveApplication(Id appId){
        // retrieve application record via record Id
        Application__c applicationRecord = queryApplicationRecord(appId);
        // put application and boolean indicator in a wrapper
        ApplicationWrapper appWrap = new ApplicationWrapper(applicationRecord, 
                                                            isApplicationStraightThrough(applicationRecord), 
                                                            getBrandNameOfSite(),   //Added by MLASALA 03-FEB-2016
                                                            timeout(),              //Added by MLASALA 04-FEB-2016
                                                            displayLoanDetailsViaRiskGrade(applicationRecord));     //Modified by MLASALA: 06-APR-2016 DEFECT 486 FIX

        return appWrap;
    }

    /*  Description: Remote action to retrieve response page controls stored in a custom meta data
     *  Author: Russell Cadapan
     *  Date Created: JAN-25-2016
     *  Input:  (String) applicantResponseCode - Response code for each applicant if joint.
     *          (String) brandCountry - Country from which the product has been processed.
     *  Return: ResponsePageMeta__mdt
    */
    @RemoteAction
    global static ResponsePageMeta__mdt retrieveResponseMeta(String applicantResponseCode, String brandCountry){
        ResponsePageMeta__mdt responseMeta;
        responseMeta = [SELECT Id,
                                AML__c,
                                Country__c,
                                Response_Title__c,
                                POA__c,
                                POI__c,
                                Response_Code__c,
                                Response_Message__c, 
                                Loan_Details__c,         //Added by MLASALA 09-FEB-2016 
                                Broker_Message__c,       //Added by MLASALA 29-FEB-2016 
                                Status_Tracker__c        //Added by MLASALA 01-MAR-2016 
                            FROM ResponsePageMeta__mdt
                            WHERE Response_Code__c =: applicantResponseCode
                            AND Country__c =: brandCountry
                            LIMIT 1];
        return responseMeta;
    }

    public String brandLatitude{
        get{
            return GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
        }
        set;
    }

    public String brandAussie{
        get{
            return GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        }
        set;
    }

    public String brandGEM{
        get{
            return GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        }
        set;
    }

    public String brandKiwi{
        get{
            return GEN_OriginationsConstants.BRAND_NAME_KIWI;
        }
        set;
    }
    
    /*  Description: Method to query application record for upsell only
     *  Author: Mike Lasala
     *  Date Created: 01-JUN-2016
     *  Input:  Id applicationId
     *  Return: Application__c
     */
    @RemoteAction
    global static Application__c retrieveApplicationUpsell(Id applicationId){
        Application__c application = [SELECT        Brand_Lookup__r.Country__c, 
                                                    Brand_Lookup__r.URL_PDS_FSG__c, 
                                                    EMI_with_Service_Fee__c, 
                                                    Loan_Term__c, 
                                                    Offered_Interest_Rate__c, 
                                                    Total_Loan_Amount__c, 
                                                    Max_Offer_Amount__c, 
                                                    Initial_Requested_Amount__c, 
                                                    Online_Self_serve_Upsell_Eligibility__c, 
                                                    Online_Self_serve_Insurance_Eligibility__c, 
                                                    Offered_Establishment_Fee__c,
                                                    Response_Code__c,
                                                    Promo_Online_Message__c     //Added by MLASALA 17-OCT-16
                                      FROM          Application__c
                                      WHERE Id =:   applicationId];
        return application;
    }
    
    /*  Description: Method to recalculate interest and minimum monthly repayments
     *  Author: Mike Lasala
     *  Date Created: 03-JUN-2016
     *  Input:  Application id,
     *          Adjusted loan amonut
     *          Adjusted loan term
     *  Return: Application__c
    */
    @RemoteAction
    global static Application__c recalculateApplication(Id applicationId, Decimal newLoanAmount, String newLoanTerm){
        
        Application__c application;
            
        //Retrieve application
        List<Id> appId = new List<Id>();
        appId.add(applicationId);
        List<Application__c> applicationList = RUL_Engine.getAllApplication(appId);
        
        if(!applicationList.isEmpty()){
           
            //Assign new values updated by user
            applicationList.get(0).Total_Loan_Amount__c = newLoanAmount;
            applicationList.get(0).Loan_Term__c = newLoanTerm;
            applicationList.get(0).Loan_Term_Months__c = Decimal.valueOf(newLoanTerm.split(' ', 2)[0])*(newLoanTerm.ToLowerCase().contains('months')?1:12);
            
            //MLASALA 17-OCT-16 Added variable to replicate loan amount without DML
            RUL_PromoEngine.upsellAmount = newLoanAmount;
            
            //Run pricing engine get correct interest rate before calculating the rest
            applicationList = RUL_Engine.runPricingEngine(applicationList);
            application = applicationList.get(0);
            
            OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
            offerCalculator.getProdutctItems(application);
            
            //MLASALA 17-OCT-16 Recalcualte establishment fee is promo est fee is null
            if(application.Offered_Establishment_Fee__c == 0.00 || 
               application.Offered_Establishment_Fee__c == null){
               application.Offered_Establishment_Fee__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);
            }
            
            //Recalulate MMP, Offered Repayments and set Out of Sync flag
            application.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(application);
            application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(application);
            application.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(application);
            application.Out_Of_Sync__c = true;
        }
        return application;
    }
    
    /*  Description: Method to update loan amount and term and redirect to insurance page
     *  Author: Mike Lasala
     *  Date Created: 17-JUN-2016
     *  Input: Application Id
               New Loan Amount
               New Loan Term
        Return: String
     */
    @RemoteAction
    global static Boolean goToInsurance(Id applicationId){
        //Retrieve application
        Application__c application = [SELECT    Customer_Confirmed_Online_Offer__c, 
                                                Online_Self_serve_Insurance_Eligibility__c, 
                                                Staff_Hide__c
                                      FROM      Application__c 
                                      WHERE     Id =: applicationId 
                                      LIMIT 1];
        
        //Validate if application is eligible for insurance
        if(!application.Customer_Confirmed_Online_Offer__c && 
           !application.Staff_Hide__c && 
           application.Online_Self_serve_Insurance_Eligibility__c){
            
            return true;   
        } else {
            return false;
        }
    }
}