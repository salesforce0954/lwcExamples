@isTest

public class GEN_RecordRetrievalUtility_Test{
 
    static testMethod void coverGenRecRetMethods(){
 
       Application__c testApplication = TestDataBuilder.createApplication();
       insert testApplication;

      GEN_RecordRetrievalUtility.retrieveWorkflow(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveApplicationDebit(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveApplicationONR(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveIncomeSortedByAmount(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveApplicationRelatedDocuments(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveAssetList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveIncomeList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveApplicantCLVList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveExpenseList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveDebtList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveCollateralList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveDisbursementsList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveAMLList(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveAMLListPostSubmit(testApplication.Id);
      GEN_RecordRetrievalUtility.retrieveLoanPurposeList(testApplication.Id);
      //GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(),'Application__c', null);
      GEN_RecordRetrievalUtility.retrieveApplication(testApplication.Id);
    }

}