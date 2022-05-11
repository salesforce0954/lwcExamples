/* @Description: Controller for Joint Income component
 * @Author: Mike Lasala
 * @Date Created: JAN-30-2014
 * @History:
 =====================================================================
       01-30-14: Created - Mike
       11-03-14: Modified Code for DBHZL-34 - Tony xu
 =====================================================================
 */ 
public with sharing class APP_JointIncome extends APP_CommonExt{

    public APP_JointIncome(){
      system.debug('!@#UserInfo.getUserType(): '+UserInfo.getUserType());
    }
    
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Get Income Source picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getIncomeSource() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Income__c.Income_Source__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
        options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    
    /*  Description: Get Income Interval picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getIncomeInterval() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Income__c.Income_Interval__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    
    /*  Description: Get Occupation picklist values
     *  Author: Fel Saliba
     *  Date Created: OCT-03-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getOccupation() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','Please Select'));
      Schema.DescribeFieldResult fieldResult = Income__c.Occupation__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
}