/*
 * @Description: Sales ui left side bar
 * @Author: Jade Serrano Cloud Sherpas
 * @Date Created: 12-NOV-2013
 * @History:
   =====================================================================
       Jade Serrano - 12-NOV-2013: Created
       Mike Lasala  - 02-DEC-2013: Added Available_Capacity__c
       Mike Lasala  - 04-DEC-2013: Added minor touch ups
       Davey Yu     - 29-MAY-2015: Display queue name if not assigned to specific user yet
   =====================================================================
 */
public with sharing class APP_LeftSideBarExt {

    public Application__c application{get;set;}
    public List<Loan_Purpose__c> loanList{get;set;}
    public List<String> insuranceList{get;set;}
    public String interestRate{get;set;}
    public String term{get;set;}
    public String loanAmount{get;set;}
    public String creditScore{get;set;}
    public String riskGrade{get;set;}
    public String monthlyRepayment{get;set;}
    public String maxLimitUnsec{get;set;}
    public String maxLimitSec{get;set;}
    public String maxMonthlyCapacity{get;set;}
    public String availableCapacity{get;set;}
    public String owner{get;set;}
    public String branch{get;set;}
    public String settlementDate{get;set;}
    public String applicationStatus{get;set;}
    public String workflowStatus{get;set;}
    public Double remainingCapacity{get;set;}
    public String applicant1Name{get; set;}
    public String applicant2Name{get; set;}
    public Boolean isDirty{get; set;}
    public String totColValue{get;set;}
    public Integer loanAmt{get;set;}
    public Integer maxSecured{get;set;}
    public Integer maxUnSecured{get;set;}
    public Integer maxApprovedAmt{get; set;}
    public Boolean isLimit {get;set;}
    public Boolean isSecured {get;set;}
    public Decimal collateralUnsecured {get;set;}
    public String isOverToday {get;set;}
    public String disbursementStatus {get;set;}
    public Boolean isManagerApproved {get;set;}
    public APP_LeftSideBarExt(ApexPages.StandardController applicationController){
    
        application = (Application__c)applicationController.getRecord();
        refreshList();
        
    }
    
    //refresh all data
    public void refreshList(){
        
        loanAmt = 0;
        remainingCapacity = 0;
        maxSecured = 0;
        maxUnSecured = 0;
        maxApprovedAmt = 0;
        collateralUnsecured = 0;
        try{
        application = [Select Id,
                              Offered_Interest_Rate__c,
                              Loan_Term__c,
                              Total_Loan_Amount__c,
                              EMI_with_Service_Fee__c,
                              (Select Credit_Score__c, Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Max_Monthly_Capacity__c From Application_Responses__r),
                              OwnerId,
                              Risk_Grade__c,
                              Sales_Agent__c,
                              Status__c,
                              Workflow_Status__c,
                              Available_Capacity__c,
                              Application_Type__c,
                              Loan_Term_Years__c,
                              Credit_Score__c,
                              Max_Capacity_Secured__c,
                              Max_Capacity_Unsecured__c,
                              Max_Monthly_Capacity__c,
                              Max_Approved_Amount__c,
                              Out_Of_Sync__c,
                              Total_Collateral_Value__c,
                              Branch__r.Name,
                              Settlement_Date__c,
                              Is_Secured__c,
                              Is_Manager_Approved__c,
                              Higher_Approval_Consent__c,
                              Refinance_Disbursement_Days_Lapsed__c,
                              Campaign_ID__c,
                              brand_country__c,
                              Upsell_Eligibility__c,     //MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
                              Promo_ID__c                //Vasu: added for TQLQW-487 - Promo engine change
                       From   Application__c
                       Where  Id =: application.Id];
        System.debug('Promo_ID__c: '+application.Promo_ID__c);
        system.debug('@@application.Id: '+application.Id);
        system.debug('@@application--> '+application);
        
        List<Applicant__c> applicants = [SELECT   First_Name__c,
                                            Last_Name__c,
                                            Is_Primary_Applicant__c
                                     FROM   Applicant__c 
                                     WHERE  Application__c =: application.Id
                                     ORDER BY  CreatedDate];
        
        //Added by Fel Saliba 27/2/2014 - Check if Application is secured or not secured        
        isSecured = false;
        if(application.Is_Secured__c){
            isSecured = true;
        }

        for(Applicant__c a: applicants){
            if(application.Application_Type__c == 'Joint' && a.Is_Primary_Applicant__c == false){           
                if(Util.nullCheck(a.First_Name__c)){    //05.14.15 Mike Lasala: Code Scan fix
                    applicant2Name = checkNull(a.First_Name__c) + ' ' + checkNull(a.Last_Name__c);
                }
            } else {
                applicant1Name = checkNull(a.First_Name__c)+' '+checkNull(a.Last_Name__c);            
            }
        }
                
        loanList = [SELECT Value__c,
                           Loan_Amount__c
                    FROM   Loan_Purpose__c
                    WHERE  Application__c =: application.Id];
                    
        //Max Approved Amount
        //interestRate
        if(application.Max_Approved_Amount__c!=null){
            maxApprovedAmt = Integer.valueOf(application.Max_Approved_Amount__c);
            collateralUnsecured = maxApprovedAmt;
        }else if(application.Total_Collateral_Value__c != null && 
                 application.Max_Capacity_Unsecured__c != null && 
                 application.Max_Capacity_Secured__c != null){

            collateralUnsecured = application.Total_Collateral_Value__c + application.Max_Capacity_Unsecured__c;
            maxApprovedAmt = Integer.valueOf(collateralUnsecured);
        }else{
            maxApprovedAmt = 0;
        }

        //interestRate
        if(application.Offered_Interest_Rate__c!=null){
            interestRate = String.valueOf((application.Offered_Interest_Rate__c).setScale(2));
        }else{
            interestRate = '';
        }

        //term
        if(application.Loan_Term__c != null){
            term = application.Loan_Term__c;
        }else{
            term = '';
        }

        //loanAmount
        if(application.Total_Loan_Amount__c!=null){
            loanAmount = currency(String.valueOf(application.Total_Loan_Amount__c));
            loanAmt = Integer.valueOf(application.Total_Loan_Amount__c);
        }else{
            loanAmount = '';
            loanAmt = 0;
        }

        //Total Collateral Value
        if(application.Total_Collateral_Value__c != null){
            totColValue = String.valueOf(application.Total_Collateral_Value__c);
        }
        else{
            totColValue = null;
        }

        //***********************************************************************************
        //creditScore   
        if(application.Credit_Score__c!=null && application.Credit_Score__c!=''){
            creditScore = String.valueOf(application.Credit_Score__c);
        }else{
            creditScore = '';
        }
        //riskgrade   
        if(application.Risk_Grade__c!=null && application.Risk_Grade__c!=''){
            riskGrade = String.valueOf(application.Risk_Grade__c);
        }else{
            riskGrade = '';
        }

        //maxLimitUnsec 
        if(application.Max_Capacity_Unsecured__c!=null){
            maxLimitUnsec = currency(String.valueOf(application.Max_Capacity_Unsecured__c));
            maxUnSecured = Integer.valueOf(application.Max_Capacity_Unsecured__c);
        }else{
            maxLimitUnsec = '';
            maxUnSecured = 0;
        }

        //maxLimitSec   
        if(application.Max_Capacity_Secured__c!=null){
            maxLimitSec = currency(String.valueOf(application.Max_Capacity_Secured__c));
            maxSecured = Integer.valueOf(application.Max_Capacity_Secured__c);
        }else{
            maxLimitSec = '';
            maxSecured = 0;
        }

        //maxMonthlyCapacity    
        if(application.Max_Monthly_Capacity__c!=null){
            maxMonthlyCapacity = currency(String.valueOf(application.Max_Monthly_Capacity__c));
        }else{
            maxMonthlyCapacity = '';
        }
        //***********************************************************************************

        //monthlyRepayment
        if(application.EMI_with_Service_Fee__c!=null){
            monthlyRepayment = currency(String.valueOf(application.EMI_with_Service_Fee__c));
        }else{
            monthlyRepayment = '';
        }

        //availableCapacity

        if(application.OwnerId !=null){
            List<User> ownerUserList = [Select Id, Name From User Where Id =: application.OwnerId];
            if(ownerUserList.size()>0){
                owner = ownerUserList[0].Name;
            }else{
                //Updated by DYU 05-29-2015 - Display queue name if nto assigned to a specifi user yet
                List<Group> queueName = [SELECT id, Name FROM Group Where Id =: application.OwnerId and Type = 'Queue'];
                if(queueName.size() > 0)
                    owner = queueName[0].Name;
                else
                    owner = '';
            }
        }else{
            owner = '';
        }

        if(application.Branch__r.Name!=null){
            branch = String.valueOf(application.Branch__r.Name);
        }else{
            branch = '';
        }
        
        if(application.Settlement_Date__c != null){
            
            String settlementDay = String.valueOf(application.Settlement_Date__c.Day());
            String settlementMonth = String.valueOf(application.Settlement_Date__c.Month());
            String settlementYear = String.valueOf(application.Settlement_Date__c.Year());
            settlementdate = settlementDay + '/' + settlementMonth + '/' + settlementYear;
            isOverToday = '';
            if(application.Settlement_Date__c < Date.Today()){
                isOverToday = 'sblDate';
            }
            
        }else{
            settlementdate = '';
        }
        
        if(application.Status__c!=null){
            applicationStatus = String.valueOf(application.Status__c);
        }else{
            applicationStatus = '';
        }

        if(application.Workflow_Status__c!=null){
            workflowStatus = String.valueOf(application.Workflow_Status__c);
        }else{
            workflowStatus = '';
        }

        if(application.Available_Capacity__c!=null){
            //remainingCapacity = Double.valueOf(application.Available_Capacity__c);
            remainingCapacity = Double.valueOf(application.Max_Monthly_Capacity__c - application.EMI_with_Service_Fee__c);
        } else {
            remainingCapacity = 0; 
        }
        
        //set the dirty incator when application details have changed
        isDirty = Application.Out_Of_Sync__c;
        
        insuranceList = new List<String>();
        Integer i = 0;
        List<Product_Item__c> productItems = [SELECT    Product_Version__r.Product_Name__c 
                                              FROM      Product_Item__c 
                                              WHERE     Application__c =: application.Id
                                              AND       Product_Version__r.Type__c = 'Insurance'];
        if(!productItems.isEmpty()){
            for(Product_Item__c p: productItems){
                i++;
                if(i == productItems.size()){
                    insuranceList.add(String.valueOf(p.Product_Version__r.Product_Name__c));
                } else {
                    insuranceList.add(String.valueOf(p.Product_Version__r.Product_Name__c)+', ');
                }
            }
        }

        isLimit = false;
        if(loanAmt > maxSecured){
            isLimit = true;
        }
        if((maxApprovedAmt >= application.Max_Capacity_Unsecured__c) && (maxApprovedAmt <= application.Max_Capacity_Secured__c)){
            isLimit = true;
        }
        
        isManagerApproved = application.Is_Manager_Approved__c;
        
        if(application.Refinance_Disbursement_Days_Lapsed__c !=null){
            disbursementStatus = String.valueOf(application.Refinance_Disbursement_Days_Lapsed__c);
        }else{
            disbursementStatus = '';
        }        
          
        }catch(Exception e){
            system.debug('###error: ' + e.getMessage());
            system.debug('###error: ' + e.getLineNumber());
            system.debug('###error: ' + e.getStackTraceString());
        }             
    }

    public static String currency(String i) {
        String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
        return s.substring(0,s.length()-1);
    }
    
    /* Description: Returns empty string if value is null
    *  Author: Mike Lasala
    *  Input Parameters: String
    *  Return: String
    */
    private String checkNull(String input) {
        return input == null ? '' : input;
    }
}