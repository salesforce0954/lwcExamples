/* @Description: Class for the Credit References section on the APP Main page.
 * @Author: Mike Lasala
 * @Date Created: DEC-18-2013
 * @History:
   =====================================================================
       12-18-13: Created - Mike
   =====================================================================
 */ 
public with sharing class APP_CreditReferences_EXT_INT{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    transient public List<Credit_Ref_Check__c> creditRefList  {get;set;}  //Credit reference records
    public Id applicationId;

    /*  Description: Main Controller class used for all initializations
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public APP_CreditReferences_EXT_INT(ApexPages.StandardController applicationController) {
        applicationId = applicationController.getRecord().Id;
        creditRefList();
    }

    /* Description: Populates a List of from the Credit Ref object. For display in SCC Credit Ref Tab.
    *  Author: Mike Lasala
    *  Date Created: DEC-18-2013
    *  Input Parameters:
    *  Return:
    */
    public void creditRefList(){     
        creditRefList = new List<Credit_Ref_Check__c>();
        creditRefList = [SELECT     Id, 
                                    Name, 
                                    Company__c, 
                                    Contract_Account_No__c, 
                                    Name_on_Contract__c, 
                                    Open_Date__c, 
                                    End_Date__c, 
                                    Contract_Term__c,
                                    Opening_Balance__c, 
                                    Current_Balance__c, 
                                    Repayments__c, 
                                    Interest_Rate__c, 
                                    Account_Conduct__c 
                         FROM       Credit_Ref_Check__c 
                         WHERE      Application__c =: applicationId
                         ORDER BY   CreatedDate DESC];    
    }
}