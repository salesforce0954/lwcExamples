/* @Description: Controller for Joint Expense component
 * @Author: Mike Lasala
 * @Date Created: JAN-29-2014
 * @History:
   =====================================================================
       01-29-14: Created - Mike
   =====================================================================
 */ 
public with sharing class APP_JointExpense extends APP_CommonExt{

    public MyBudgetsExpenseWrapper expenseWrapperComp {get;set;}
    public Boolean isJoint                            {get;set;}
    public string region                              {get;set;}
    public decimal totalMonthlyLivingExpense          {get;set;}
        public Boolean brokerChannel {get;set;}

    public APP_JointExpense(){
         brokerChannel = false;
   
        Id applicationId = (Id) ApexPages.currentPage().getParameters().get('Id');
         Application__c appChannel;
        try{
          appChannel = [select Channel__c from Application__c where id=:applicationId];
        
          if(appChannel.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
          brokerChannel = true;
          }
         }catch(Exception e){}

    }

    public void recomputeTotalExpenseComp(){ 
            //DBHZL-36: Added the condition to call this method for NZ if living expenses and living expesnes internal are not passed
        if((expenseWrapperComp.expense.Living_Exp__c != null && expenseWrapperComp.expense.Living_Exp_Int__c != null && region == GEN_OriginationsConstants.AU_REGION) || 
         (expenseWrapperComp.expense.Rent_Board_Pay_Amt__c != null || expenseWrapperComp.expense.Rent_Board_Pay_Int__c != null || region == GEN_OriginationsConstants.NZ_REGION))             
         {
            Boolean isRent = false;
            if(expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
               expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
               expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
                    isRent = true;
            }
            expenseWrapperComp.computeTotalExpense(isRent, region);
            expenseWrapperComp.totalExpense = expenseWrapperComp.expense.Total_Exp__c;
        } else {
            expenseWrapperComp.totalExpense = 0;
        }
    }
    public string country_NZ{
        get{
            return country_NZ = GEN_OriginationsConstants.NZ_REGION;
        }
        set;
    }
    public void clearFields(){
        if(expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
           expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
           expenseWrapperComp.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
            expenseWrapperComp.clearRentFields();
        }
        recomputeTotalExpenseComp();
    }
    
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Get pay option picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-04-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getPayOption() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('true', GEN_OriginationsConstants.EXPENSE_PAY_OPTION_YES));
        options.add(new SelectOption('false', GEN_OriginationsConstants.EXPENSE_PAY_OPTION_NO));
        return options; 
    }
    
    /*  Description: Get living expense interval picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-04-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getLivingExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Please Select'));
        Schema.DescribeFieldResult fieldResult = Expense__c.Living_Exp_Int__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get food & groceries expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getFoodGrocExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Expense__c.Food_Groc_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get insurance expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getInsuranceExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Insurance_Expense_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get utilities expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getUtilitiesExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Utilities_Expense_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get transport expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getTransportExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Transport_Expense_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get education expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getEducationExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Education_and_child_Expense_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }

    /*  Description: Get personal/other expense interval picklist values
     *  Author: Arshad Mohammed
     *  Date Created: 24-06-2021
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getPersonalExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Personal_Other_Expense_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }


    
    /*  Description: Get expense rent interval picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-04-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getRentExpenseInterval() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Rent_Board_Pay_Int__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    
    public List<SelectOption> getMortgageExpenseInterval(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Mortgage_Rent_Board_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    public List<SelectOption> getSecondaryMortgageInterval(){
      List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Secondary_Mortgage_Rent_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    public List<SelectOption> getPropertyRatesInterval(){
       List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Property_rates_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    public List<SelectOption> getOtherPropertyExpenseInterval(){
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Other_Property_Expenses_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    public List<SelectOption> getAnyNewAdditionalExpenseInterval(){
    
         List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Expense__c.Any_Additional_expenses_Interval__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
}