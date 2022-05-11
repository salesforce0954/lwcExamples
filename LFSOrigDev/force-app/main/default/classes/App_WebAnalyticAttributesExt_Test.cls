@isTest
public class App_WebAnalyticAttributesExt_Test {

    static testMethod void methodOne(){
           Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
    App_WebAnalyticAttributesExt controller = new App_WebAnalyticAttributesExt();
    Test.StartTest();  
        controller.currentPage = 'subtype';
        controller.brokerPage = 'form';
        controller.omnitureURL = 'test';
        controller.pageController = new APP_CommonExt();
    Test.StopTest();
  }
 
}