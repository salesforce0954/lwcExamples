/*
 * @Description: Populates all the attributes for WebAnalytic
 * @Author: Afreen Khan
 * @Date Created: Sept-26-2016
 */ 
public with sharing class App_WebAnalyticAttributesExt {

    public String productSubType { get; set; }

    public String currentPage { get; set; }
    public String brokerPage { get; set; }
    
    public App_WebAnalyticAttributesExt(){
    /*
     * @Description: Populates the Product Subtype for WebAnalytic
     * @Author: Suneel Desiraju
     * @Date Created: 16 Feb 2020
     */ 
    currentPage = ApexPages.currentPage().getParameters().get('Id');
    List<Application__c> application = [select Product_SubType__c  from Application__c where id =: currentPage];    
    for(Application__c app: application){
    if(app.Product_SubType__c == 'Better Start PL'){
      productSubType = 'Better Start PL';
    }else{
      productSubType = 'Standard PL';
    }     
    }
    /* End */
    brokerPage = ApexPages.currentPage().getParameters().get('form');
    }

    public APP_CommonExt pageController{get; set;}
    public String omnitureURL {get;set;}
    
    public void App_WebAnalyticAttributesExt(){
        omnitureURL = Admin_Settings__c.getValues('Omniture Source').Value__c;
    }
}