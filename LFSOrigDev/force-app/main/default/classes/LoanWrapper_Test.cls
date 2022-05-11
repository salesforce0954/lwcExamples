@isTest
private class LoanWrapper_Test {
	
	@isTest static void test_method_one() {
		Application__c app = TestDataBuilder.createApplication();	
		insert app;	
		String RecTypeId= [select Id from RecordType where (Name='General') and (SobjectType='ONR__c')].Id;
		ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, RecTypeId);		
		insert onr;
		Loan_Purpose__c lpurp = TestDataBuilder.createLoanPurpose2(app.Id, onr.Id);		
		Test.startTest();		
		insert lpurp;
		LoanWrapper lwrap = new LoanWrapper();
		lwrap.loan = lpurp;
		lwrap.loanPurNotValid = false;
        lwrap.loanPurposeNotValid = false;
        lwrap.amtNotValid = false;
        lwrap.validateLoan();        
        Test.stopTest();
        Loan_Purpose__c lp = [Select Id, Value__c, Loan_Amount__c from Loan_Purpose__c where Id = : lpurp.Id];        
        System.assert(lp.Value__c ==  'Other');
        System.assert(lp.Loan_Amount__c ==  null);
	}

	@isTest static void test_method_two() {
		Application__c app = TestDataBuilder.createApplication();
		insert app;
		String RecTypeId= [select Id from RecordType where (Name='General') and (SobjectType='ONR__c')].Id;
		ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, RecTypeId);		
		insert onr;		
		Test.startTest();
		Loan_Purpose__c lp = new Loan_Purpose__c();
		LoanWrapper lwrap = new LoanWrapper();
		lwrap.loan = lp;
		lwrap.loanPurNotValid = false;
        lwrap.loanPurposeNotValid = false;
        lwrap.amtNotValid = false;
        lwrap.validateLoan();        
        Test.stopTest();
        System.assertEquals(lp.Id, lwrap.loan.Id);
	}

	@isTest static void test_method_three() {
		Application__c app = TestDataBuilder.createApplication();
		insert app;
		String RecTypeId= [select Id from RecordType where (Name='General') and (SobjectType='ONR__c')].Id;
		ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, RecTypeId);		
		insert onr;		
		Loan_Purpose__c lp = new Loan_Purpose__c();
		lp.Application__c = app.Id;
		lp.ONR__c = onr.Id;
		insert lp;
		Test.startTest();
		LoanWrapper lwrap = new LoanWrapper();
		lwrap.setLoanApplicationAndONR(lp.Application__c, lp.ONR__c);
        Test.stopTest();
        Loan_Purpose__c lpr = [Select Id, Application__c, ONR__c, Value__c, Loan_Amount__c from Loan_Purpose__c where Id = : lp.Id];
        System.assert(lpr.Application__c == lp.Application__c);
        System.assert(lpr.ONR__c ==  lp.ONR__c);
	}	
}