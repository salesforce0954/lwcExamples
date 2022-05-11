/*
 * @Description: Controller for DashboardAutoRefreshComponent
 * @Author: Marvin David
 * @Date Created: SEPT-07-2015
 * @History:
   =====================================================================
       07-09-15: Created - Marvin
   =====================================================================
 */ 

public with sharing class DashboardAutoRefreshController {

	public Boolean needsRefresh {get; set;}
	public Boolean canRefresh {get; set;}
	public Id dbIdent {get; set;}
  
	public DashboardAutoRefreshController(){
		needsRefresh=true;
		setup();
	}
  
	public void setup(){
		Map<String, String> headers=ApexPages.currentPage().getHeaders();
		String referrer=headers.get('Referer');

		if (null==referrer){
			canRefresh=false;
		} else{
			Integer lastSlashPos=referrer.lastIndexOf('/');
			lastSlashPos++;
			Integer paramPos=referrer.indexOf('?', lastSlashPos);
   
			String result='';
   			if (-1!=paramPos){
				result=referrer.substring(lastSlashPos, paramPos);
			} else{
				result=referrer.substring(lastSlashPos);
			}
    
			try{
				dbIdent=result;
				canRefresh=true;
			} catch (Exception e){
				canRefresh=false; 
			}
		}
 	}
  
	public PageReference refreshDashboard(){
		needsRefresh=false;
		String refUrlStr='/dash/dashboardRefresh.apexp?id='+dbIdent;
		Boolean refreshed=false;
		Integer idx=0;
		while ((!refreshed) && (idx<10)){
    		PageReference pr=new PageReference(refUrlStr);
    		Blob body = !Test.isRunningTest() ? pr.getContent() : Blob.ValueOf('dummy text');
    		String bodyStr=body.toString();
    		refreshed=(-1!=bodyStr.indexOf('Last refreshed'));
    		idx++;
   		}
      
	return null;
	}
}