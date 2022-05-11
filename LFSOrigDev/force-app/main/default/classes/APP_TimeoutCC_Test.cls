@isTest
private class APP_TimeoutCC_Test {
	
	@isTest static void Timeout_Test() {
		Test.StartTest();
        	APP_TimeoutCC timeout = new APP_TimeoutCC();
        	timeout.showError();
        Test.StopTest();

        Boolean isError;
		List<Apexpages.Message> msgs = ApexPages.getMessages(); 
	    for(Apexpages.Message msg:msgs){
	        if(msg.getDetail().contains('For security reasons your session has timed out')){
	            isError = true;
	        }
	    }
	    
	    system.assert(isError);
	}
}