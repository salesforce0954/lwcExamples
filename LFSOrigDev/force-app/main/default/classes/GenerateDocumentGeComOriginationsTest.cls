@IsTest
private with Sharing class GenerateDocumentGeComOriginationsTest{

   private static testMethod void coverWsdlClasses(){
    Test.startTest();  
      new GenerateDocumentGeComOriginations.interestFreeRebateDetails();
      new GenerateDocumentGeComOriginations.interestFreeRebateDetailsList();
      new GenerateDocumentGeComOriginations.loanProtectionInsuranceInformation();
      new GenerateDocumentGeComOriginations.LoanPurpose();
      new GenerateDocumentGeComOriginations.DisbursementDetailsCollection();
      new GenerateDocumentGeComOriginations.repaymentDetails();
      
      new GenerateDocumentGeComOriginations.LoanPurposeCollection();
      new GenerateDocumentGeComOriginations.directDebitRequest();
      new GenerateDocumentGeComOriginations.signUpLetterNZ();
      new GenerateDocumentGeComOriginations.disbursementAuthorityInformation();
      new GenerateDocumentGeComOriginations.accountClosure();
      new GenerateDocumentGeComOriginations.GEDirectType();
      
      new GenerateDocumentGeComOriginations.contractType();
      new GenerateDocumentGeComOriginations.disbursementAuthority();
      new GenerateDocumentGeComOriginations.InsuranceDetails();
      new GenerateDocumentGeComOriginations.OnRInformation();
      new GenerateDocumentGeComOriginations.DisbursementDetails();
      new GenerateDocumentGeComOriginations.loanProtectionInsurance();
      
      new GenerateDocumentGeComOriginations.bankAccountDetails();
      new GenerateDocumentGeComOriginations.applicationExtract();
      new GenerateDocumentGeComOriginations.payoutStatement();
      new GenerateDocumentGeComOriginations.financialInstitutionDetails();
      new GenerateDocumentGeComOriginations.accountLimitReduction();
      new GenerateDocumentGeComOriginations.Contract();
      
      new GenerateDocumentGeComOriginations.privacyNotice();
      new GenerateDocumentGeComOriginations.payoutStatementDetails();
      new GenerateDocumentGeComOriginations.MortgageDetailsCollection();
      new GenerateDocumentGeComOriginations.interestFreeRebate();
      new GenerateDocumentGeComOriginations.objectiveAndRequirements();
      new GenerateDocumentGeComOriginations.MortgageDetails();
      
      new GenerateDocumentGeComOriginations.directDebitInformation();
      new GenerateDocumentGeComOriginations.BrokerCommissionDetails();
      new GenerateDocumentGeComOriginations.AssetDetailsList();
      new GenerateDocumentGeComOriginations.DebtDetailsList();
      new GenerateDocumentGeComOriginations.ExpenseDetails();
      new GenerateDocumentGeComOriginations.AssetDetails();
      
      new GenerateDocumentGeComOriginations.PersonalReferencesList();
      new GenerateDocumentGeComOriginations.ApplicationMetadata();
      new GenerateDocumentGeComOriginations.PersonalReferences();
      new GenerateDocumentGeComOriginations.EligibilityDetails();
      new GenerateDocumentGeComOriginations.ResidentialHistory();
      new GenerateDocumentGeComOriginations.IncomeDetails();
      
      new GenerateDocumentGeComOriginations.AppInsuranceDetails();
      new GenerateDocumentGeComOriginations.LoanDetails();
      new GenerateDocumentGeComOriginations.DepartmentCollection();
      new GenerateDocumentGeComOriginations.InsuranceDetailsList();
      new GenerateDocumentGeComOriginations.CommunicationDetails();
      new GenerateDocumentGeComOriginations.BrokerDetails();
      
      new GenerateDocumentGeComOriginations.Address();
      new GenerateDocumentGeComOriginations.DebtDetails();
      new GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmit();
      new GenerateDocumentGeComOriginations.Department();
      new GenerateDocumentGeComOriginations.IncomeDetailsList();
      new GenerateDocumentGeComOriginations.LoanPurposeApplicationSubmitList();
      
      new GenerateDocumentGeComOriginations.ContactList();
      new GenerateDocumentGeComOriginations.accountClosureSignUp();
      new GenerateDocumentGeComOriginations.proofofPayment();
      new GenerateDocumentGeComOriginations.settlementStatement();
      new GenerateDocumentGeComOriginations.accountLimitReductionSignUp();
      new GenerateDocumentGeComOriginations.ContactName();
      
      new GenerateDocumentGeComOriginations.Contact();
      new GenerateDocumentGeComOriginations.creditReference();
      new GenerateDocumentGeComOriginations.BusinessContext();
      new GenerateDocumentGeComOriginations.Exception_x();
      new GenerateDocumentGeComOriginations.ExceptionCollection();
      new GenerateDocumentGeComOriginations.ConsumerContext();
      
      new GenerateDocumentGeComOriginations.ServiceContext();
      new GenerateDocumentGeComOriginations.serviceFault_element();
      new GenerateDocumentGeComOriginations.generateDocumentRequest_element();
      new GenerateDocumentGeComOriginations.generateDocumentResponse_element();
      new GenerateDocumentGeComOriginations.signUpLetterNZType();
      new GenerateDocumentGeComOriginations.oAndRType();
      
      new GenerateDocumentGeComOriginations.accountLimitReductionType();
      new GenerateDocumentGeComOriginations.DocumentClassProperty();
      new GenerateDocumentGeComOriginations.checkHealthDataType();
      new GenerateDocumentGeComOriginations.checkHealthRequest_element();
      new GenerateDocumentGeComOriginations.checkHealthResponse_element();
      new GenerateDocumentGeComOriginations.documentsType();
      
      new GenerateDocumentGeComOriginations.privacyNoticeType();
      new GenerateDocumentGeComOriginations.DocumentMetadataProperty();
      new GenerateDocumentGeComOriginations.DocumentGroupInfoType();
      new GenerateDocumentGeComOriginations.interestFreeRebateType();
      new GenerateDocumentGeComOriginations.applicationResponseType();
      new GenerateDocumentGeComOriginations.lpiType();
      
      new GenerateDocumentGeComOriginations.disbursementAuthorityType();
      new GenerateDocumentGeComOriginations.GenerateDocumentInputType();
      new GenerateDocumentGeComOriginations.DocumentMetadataType();
      new GenerateDocumentGeComOriginations.DocumentClassPropertyList();
      new GenerateDocumentGeComOriginations.directDebitType();
      new GenerateDocumentGeComOriginations.DocumentClassType();
      
      new GenerateDocumentGeComOriginations.contractDocType();
      new GenerateDocumentGeComOriginations.accountClosureType();
      new GenerateDocumentGeComOriginations.ConfigurationType();
      new GenerateDocumentGeComOriginations.documentCommonAttrType();
      new GenerateDocumentGeComOriginations.applicationExtractType();
      new GenerateDocumentGeComOriginations.payoutStatementType();
      
      new GenerateDocumentGeComOriginations.DocumentMetadataPropertyList();
      new GenerateDocumentGeComOriginations.PLDocManagementPort();
    Test.stopTest();
   }
   private static testMethod void coverWsdlMethods(){
     System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
     Test.startTest();    
      GenerateDocumentGeComOriginations.PLDocManagementPort pldocport = new GenerateDocumentGeComOriginations.PLDocManagementPort();
      pldocport.generateDocument(null,null);
      pldocport.checkHealth(null,null);
     Test.stopTest();

   }
   public class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            
            
        }
        
    }
   }