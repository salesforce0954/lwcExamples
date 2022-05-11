public with sharing class APP_PreDocCheckListExt_INT extends APP_CommonExt{
	
	public APP_PreDocCheckListExt_INT(ApexPages.StandardController applicationController){
		super(applicationController);
	}
	
	
	public pagereference savePreference(){
		try{
			if(this.application.Id != null){
				update this.application;
			}
		}catch(Exception e){
			 System.debug('###error: ' + e.getMessage());
		}
		return null;
	}

}