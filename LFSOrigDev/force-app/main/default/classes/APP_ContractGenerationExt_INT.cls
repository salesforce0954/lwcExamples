public class APP_ContractGenerationExt_INT {

	transient public Integer pfrCount {get;set;}
    transient public Integer bmCount {get;set;}
    public Application__c application {get;set;}

    public APP_ContractGenerationExt_INT(ApexPages.StandardController applicationController) {
        this.application = (Application__c)applicationController.getRecord();
        refreshApplication();

        queryComplianceCheck(this.application.Id);
	}

	/* 
    *  Description: Refresh application when status has changed
    *  Author: Michael Lasala
    *  Input Parameters: None
    *  Return: Void
    */
    public void refreshApplication () {
        this.application = [SELECT  Id, 
                                    Collateral_Count__c, 
                                    POI_Count__c, 
                                    AML_Count__c, 
                                    Disbursement_Count__c, 
                                    Credit_File_Check_Count__c, 
                                    Personal_Reference_Check_Count__c 
                            FROM    Application__c
                            WHERE   Id = :application.Id];

        queryComplianceCheck(this.application.Id);
    }

    public void queryComplianceCheck(String appId){
        pfrCount = 0;
        bmCount = 0;
        List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
        complianceList = [SELECT     Id, PFR_Check__c, BM_Check__c
                          FROM       Compliance_Check__c 
                          WHERE      Application__c =: appId
                          AND        (Pre_Contract_Indicator__c = true OR Pre_Settlement_Indicator__c = true)];
        
        if(!complianceList.isEmpty()){
            for(Compliance_Check__c c: complianceList){
                if(c.PFR_Check__c != null){
                    pfrCount++;
                }
                if(c.BM_Check__c != null){
                    bmCount++;
                }
            }
        }
    }
}