@isTest
public class App_POIVerification_Test{

static testMethod void testSaveSingleJoint(){
List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        //Response_Code_Control__c resp = testDataBuilder.createResponseCodeControlPA();
        //insert resp;
        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'PA';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = testDataBuilder.createBrand();
        insert testBrand;

        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.id;
        appVar.EVerifier_Alert_Applicant_1__c = 'cessationDate;unevenZero;';  
        appVar.EVerifier_Alert_Applicant_2__c = 'UnevenZero;cessationDate;';    
        insert appVar;             
        
        List<Applicant__c> aplist = new List<Applicant__c>();
    
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        
        Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
          
         aplist.add(appliVar);
         aplist.add(appliVar1);
         insert aplist;       
           
        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
        
        test.startTest();
            App_POIVerification appPerRefExtCC = new App_POIVerification(standardCon);
            appPerRefExtCC.saveSingle();
            List<SelectOption> actualValues = appPerRefExtCC.getAlertTypeOne();
            appPerRefExtCC.saveJoint();
          Verify_POI_Check__c vpc = new Verify_POI_Check__c();
           vpc.Applicant__c = appliVar.id;
           vpc.Application__c = appVar.id;
           vpc.Alert_Type_One__c = 'Verified';
           vpc.Alert_Type_Two__c = 'Verified';
           vpc.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC.vpc1 = vpc;
           
          Verify_POI_Check__c vpcc = new Verify_POI_Check__c();
           vpcc.Applicant__c = appliVar.id;
           vpcc.Application__c = appVar.id;
           vpcc.Alert_Type_One__c = 'Verified';
           vpcc.Alert_Type_Two__c = 'Verified';
           vpcc.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC.vpc2 = vpcc;
        test.stopTest();  
  }
  
 static testMethod void testSaveJoint(){
   Application__c application = TestDataBuilder.createApplication();//create application
    application.Channel__c = 'Broker';
    application.Response_Code__c = 'PC';
    application.EVerifier_Alert_Applicant_1__c = 'cessationdate;unevenzero;dummy;';
    application.EVerifier_Alert_Applicant_2__c = 'UnevenZero;cessationDate;dummy;';    

      insert application;
      
      
      List<Applicant__c> aplist1 = new List<Applicant__c>();
    
        // Create Applicant
        Applicant__c appliVarr = testDataBuilder.createApplicant(null, application.Id);
        
        Applicant__c appliVarr1 = testDataBuilder.createApplicant(null, application.Id);
          
         aplist1.add(appliVarr);
         aplist1.add(appliVarr1);
         insert aplist1;  
      
      
   ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
   App_POIVerification ap = new App_POIVerification(standardController );
   //ap.sizeA1 = 1;
   //ap.sizeA2 =2;
   ap.getAlertTypeOne();
   ap.saveSingle();
   ap.saveJoint();
   
   test.startTest();
            App_POIVerification appPerRefExtCC1 = new App_POIVerification(standardController);
            appPerRefExtCC1.saveSingle();
            List<SelectOption> actualValues1 = appPerRefExtCC1.getAlertTypeOne();
            appPerRefExtCC1.saveJoint();
          Verify_POI_Check__c vpc1 = new Verify_POI_Check__c();
           vpc1.Applicant__c = appliVarr.id;
           vpc1.Application__c = application.id;
           vpc1.Alert_Type_One__c = 'Verified';
           vpc1.Alert_Type_Two__c = 'Verified';
           vpc1.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC1.vpc1 = vpc1;
           
          Verify_POI_Check__c vpcc1 = new Verify_POI_Check__c();
           vpcc1.Applicant__c = appliVarr.id;
           vpcc1.Application__c = application.id;
           vpcc1.Alert_Type_One__c = 'Verified';
           vpcc1.Alert_Type_Two__c = 'Verified';
           vpcc1.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC1.vpc2 = vpcc1;
        test.stopTest();  
  
   
  }
  
   static testMethod void testCoverAppSize(){
   
   Brand__c testBrand1 = testDataBuilder.createBrand();
        insert testBrand1;
   // Create Test Application
        Application__c appVar1 = testDataBuilder.createApplication();
        appVar1.Brand_Lookup__c = testBrand1.id;
        appVar1.EVerifier_Alert_Applicant_1__c = 'cessationDate';  
        appVar1.EVerifier_Alert_Applicant_2__c = 'UnevenZero';    
        insert appVar1;             
        
        List<Applicant__c> aplist = new List<Applicant__c>();
    
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(null, appVar1.Id);
        
        Applicant__c appliVar1 = testDataBuilder.createApplicant(null, appVar1.Id);
          
         aplist.add(appliVar);
         aplist.add(appliVar1);
         insert aplist;       
           
        // Create Data Tools
        Datatools__c dataTVar = TestDataBuilder.createDatatools();
        insert dataTVar;
        
        // Test Constructor
        ApexPages.standardController standardCon = new ApexPages.standardController(appVar1);
        
        test.startTest();
            App_POIVerification appPerRefExtCC = new App_POIVerification(standardCon);
            appPerRefExtCC.saveSingle();
            List<SelectOption> actualValues = appPerRefExtCC.getAlertTypeOne();
            appPerRefExtCC.saveJoint();
          Verify_POI_Check__c vpc = new Verify_POI_Check__c();
           vpc.Applicant__c = appliVar.id;
           vpc.Application__c = appVar1.id;
           vpc.Alert_Type_One__c = 'Verified';
           vpc.Alert_Type_Two__c = 'Verified';
           vpc.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC.vpc1 = vpc;
           
          Verify_POI_Check__c vpcc = new Verify_POI_Check__c();
           vpcc.Applicant__c = appliVar.id;
           vpcc.Application__c = appVar1.id;
           vpcc.Alert_Type_One__c = 'Verified';
           vpcc.Alert_Type_Two__c = 'Verified';
           vpcc.Alert_Type_Three__c = 'Verified';
           appPerRefExtCC.vpc2 = vpcc;
        test.stopTest();  
   
   }

}