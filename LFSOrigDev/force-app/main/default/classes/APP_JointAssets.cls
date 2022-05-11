/* @Description: Controller for Joint Asset component
 * @Author: Mike Lasala
 * @Date Created: JAN-29-2014
 * @History:
   =====================================================================
       01-29-14: Created - Mike
   =====================================================================
 */ 
public with sharing class APP_JointAssets extends APP_CommonExt{  	
  	public APP_JointAssets(){
        
    }
    
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Get Asset Category picklist values
     *  Author: Mike Lasala
     *  Date Created: OCT-02-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getAssetCategory() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Please Select'));
        Schema.DescribeFieldResult fieldResult = Asset__c.Asset_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    /*  Description: Get Ownership Status picklist values
     *  Author: Mike Lasala
     *  Date Created: OCT-02-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getOwnershipStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Please Select'));
        Schema.DescribeFieldResult fieldResult = Asset__c.Ownership_Status__c.getDescribe();
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
        Schema.DescribeFieldResult fieldResult = Asset__c.Applicable_Party__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    //Added by vijay
    
    Public string country{get{
    	return country=[select country__c from user where id=:userinfo.getUserId()].country__c;
    }set;}    
}