/* @Description: Controller for Page APP_SocietyOne_Wait.page
    *  @Author 	   : Afreen
    *  @Date       : Jun-21-2016
    *  @History	   :
    =========================================================================================================
        Jun-21-2016 : Created - Afreen Khan
    =========================================================================================================
	*/
@isTest
public class App_SocietyOne_ErrorExt_Test {
	private static final String EXTRENAL_APP_ID = 'XAppId';
    private static final String ERROR_CODE = 'ERR_001';
    
    public static testmethod void errorMessageTest(){
        Test.startTest();
        
        PageReference pageRef = Page.App_SocietyOne_SysError;
    	Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('externalappId', EXTRENAL_APP_ID);
		
        //Access the page without any error code
        App_SocietyOne_ErrorExt ext = new App_SocietyOne_ErrorExt();
        
        ApexPages.currentPage().getParameters().put('err', ERROR_CODE);
		
        //Access the page with valid error
		App_SocietyOne_ErrorExt ext1 = new App_SocietyOne_ErrorExt();
        
        ApexPages.currentPage().getParameters().put('err', 'Random');
        
        //Access the page with invalid error code
        App_SocietyOne_ErrorExt ext2 = new App_SocietyOne_ErrorExt();
        
        Test.stopTest();
    }
}