/*
 * @Description: Test class for DashboardAutoRefreshController
 * @Author: Marvin David
 * @Date Created: SEPT-07-2015
 * @History:
 * =====================================================================
 *     07-09-15: Created - Marvin
 * =====================================================================
 */

@isTest(SeeAllData=true)
private class DashboardAutoRefreshControllerTest {
	
	static testMethod void test_dashboardAutoRefresh() {
		Dashboard db = [SELECT Id FROM Dashboard LIMIT 1];

        PageReference ParentPage = new PageReference('/' + db.Id);

        PageReference pageRef = Page.DashboardAutoRefreshComponent;
        pageRef.GetHeaders().put('Referer','/'+ db.Id);
        //Set the current Page
        Test.setCurrentPageReference(pageRef);
        DashboardAutoRefreshController dbController = new DashboardAutoRefreshController();

		Test.startTest();
			dbController.refreshDashboard();

			Map<String, String> headers=ApexPages.currentPage().getHeaders();
			String referrer=headers.get('Referer');
		
			System.assertEquals(referrer, ParentPage.getUrl());
		Test.stopTest();
	}
}