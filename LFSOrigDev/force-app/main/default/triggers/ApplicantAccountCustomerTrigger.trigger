trigger ApplicantAccountCustomerTrigger on Applicant_Account_Customer__c (after insert) {
	ApplicantAccountCustomerTriggerHandler atrigHand = new ApplicantAccountCustomerTriggerHandler();
	if(trigger.isAfter && trigger.isInsert){
		atrigHand.updateSelectedICBS(Trigger.new);
	}
}