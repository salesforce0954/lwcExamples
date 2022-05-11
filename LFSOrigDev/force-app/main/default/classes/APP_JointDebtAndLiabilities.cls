/* @Description: Controller for Joint Debts and Liabilities component
 * @Author: Mike Lasala
 * @Date Created: JAN-30-2014
 * @History:
   =====================================================================
       01-30-14: Created - Mike 
   =====================================================================
 */ 
public with sharing class APP_JointDebtAndLiabilities extends APP_CommonExt{
    
    public MyBudgetsDebtWrapper debtWrapper     {get;set;}
    
    public APP_JointDebtAndLiabilities (){
  
    }

    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Get Debt Category picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getDebtCategory() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Liability__c.Debt_Category__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    /*  Description: Get Consolidated debt picklist values
     *  Author: Russell Cadapan
     *  Date Created: NOV-27-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getConsolidatedDebtCategory() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Liability__c.Consolidate_Debt_Reduce_Limit__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    
    /*  Description: Get Car Personal Interval picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getCarPersonalInterval() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Liability__c.Car_Personal_Repay_Int__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    
    /*  Description: Get Other Repay Interval picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getOtherRepayInterval() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Liability__c.Other_Repay_Int__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }   
    /*  Description: Get Mortgage Repayment Inteval picklist values
     *  Author: Russell Cadapan
     *  Date Created: FEB-08-2014
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getMortgageRepayInterval() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Liability__c.Mortgage_Repayment_Interval__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    } 

    /*  Description: Get Applicable Party picklist values
     *  Author: Mac Domingo
     *  Date Created: MAR-11-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getApplicablePartyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Liability__c.Applicable_Party__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
   
    /*  Description: Set Overdraft Interest Rate
     *  Author: Mike Lasala
     *  Date Created: DEC-15-2014
     *  Input Parameters: None
     *  Return: Void
     */
    public void setAPR(){
        if(debtWrapper.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT && 
           (debtWrapper.debt.Overdraft_APR__c == null)){
            debtWrapper.debt.Overdraft_APR__c = 0;//updated as per defect  1161
        } else {
            debtWrapper.debt.Overdraft_APR__c = 0;
        }
    }
    
    Public List<Selectoption> getSelectPersonalHirePurchase(){
           List <SelectOption> options = new List <SelectOption>();
            options.add(new selectOption('', 'Select'));
            options.add(new selectOption('Gem', 'Gem'));
            options.add(new selectOption('Kiwibank', 'Kiwibank'));
            options.add(new selectOption('ANZ', 'ANZ'));
            options.add(new selectOption('ASB', 'ASB'));
            options.add(new selectOption('BNZ', 'BNZ'));
            options.add(new selectOption('Westpac', 'Westpac'));
            options.add(new selectOption('Finance Now', 'Finance Now'));
            options.add(new selectOption('Harmoney', 'Harmoney'));
            options.add(new selectOption('Other', 'Other'));
            
            return options;
    }
    
    Public List<Selectoption> getSelectCarLoan(){
          List <SelectOption> options = new List <SelectOption>();
            options.add(new selectOption('', 'Select'));
            options.add(new selectOption('UDC', 'UDC'));
            options.add(new selectOption('Heartland Bank', 'Heartland Bank'));
            options.add(new selectOption('Finance Now', 'Finance Now'));
            options.add(new selectOption('Avanti Finance', 'Avanti Finance'));
            options.add(new selectOption('Oxford Finance', 'Oxford Finance'));
            options.add(new selectOption('Other', 'Other'));           
            return options;
    }
    
    public List<SelectOption> getSelectCreditStoreCharge(){
       List <SelectOption> options = new List <SelectOption>();
            options.add(new selectOption('', 'Select'));
            options.add(new selectOption('Gem', 'Gem'));
            options.add(new selectOption('CreditLine', 'CreditLine'));
            options.add(new selectOption('Kiwibank', 'Kiwibank'));
            options.add(new selectOption('ANZ', 'ANZ'));
            options.add(new selectOption('ASB', 'ASB'));
            options.add(new selectOption('BNZ', 'BNZ')); 
             options.add(new selectOption('Westpac', 'Westpac'));
            options.add(new selectOption('Flexi Card', 'Flexi Card'));
            options.add(new selectOption('AMEX', 'AMEX')); 
             options.add(new selectOption('Other', 'Other')); 
            return options;
    }
    
    public List<SelectOption> getSelectOverdraft(){
     List <SelectOption> options = new List <SelectOption>();
            options.add(new selectOption('', 'Select'));
            options.add(new selectOption('Kiwibank', 'Kiwibank'));
            options.add(new selectOption('ANZ', 'ANZ'));
            options.add(new selectOption('ASB', 'ASB'));
            options.add(new selectOption('BNZ', 'BNZ'));
            options.add(new selectOption('Westpac', 'Westpac'));
            options.add(new selectOption('Other', 'Other')); 
            return options;
    }
    
    public List<SelectOption> getSelectDebtCategory(){
     List <SelectOption> options = new List <SelectOption>();
            options.add(new selectOption('', 'Select'));
            options.add(new selectOption('Personal loan', 'Personal loan'));
            options.add(new selectOption('Car loan', 'Car loan'));
            options.add(new selectOption('Hire purchase', 'Hire purchase'));
            options.add(new selectOption('Credit card', 'Credit card'));
            options.add(new selectOption('Store card', 'Store card'));
            options.add(new selectOption('Charge card', 'Charge card'));
            options.add(new selectOption('Overdraft', 'Overdraft'));
            options.add(new selectOption('Other', 'Other')); 
            return options;
    }
}