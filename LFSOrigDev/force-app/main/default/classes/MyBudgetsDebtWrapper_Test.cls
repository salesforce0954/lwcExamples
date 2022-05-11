@isTest
public class MyBudgetsDebtWrapper_Test{
  

   static testMethod void methodOne(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        testProduct.Product_Name__c = 'Latitude Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Product_SubType__c = 'Better Start PL';
        testApplication.Offered_Interest_Rate_Orig__c = 13.99;
        testApplication.Loan_Term_Months__c = 24;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Acceptance_Channel__c= 'Internet';
        testApplication.Offered_Interest_Rate__c = 13.99;
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Previous_App_No__c = 'new';
        testApplication.Promo_ID__c = 'old loan';
        testApplication.Initial_Submit_Date__c = System.Today();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '0212345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '0212345678';
            testApplicant.Country_Pos__c = 'New Zealand';
            testApplicant.Country_Res__c = 'New Zealand';
            testApplicant.Country_Pre__c = 'New Zealand';
            testApplicant.State_Res__c = 'PARRAMATTA';
            testApplicant.State_Pos__c = 'PARRAMATTA';
            testApplicant.State_Pre__c = 'PARRAMATTA';
            testApplicant.City_Pos__c = 'TEST';
            testApplicant.City_Pre__c = 'VIC';
           insert testApplicant;
           
         Liability__c testDebt = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
            testDebt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            insert testDebt;
            
        Liability__c testDebt2 = TestDataBuilder.createLoanLiability(testApplicant.Id);
        testDebt2.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        testDebt2.Financier_List__c = 'Gem';
        testDebt2.Type_of_Credit_Card__c = 'Others';
        testDebt2.Acknowledge_Payout__c = true;
        insert testDebt2;
        
        Liability__c testDebt3 = TestDataBuilder.createLoanLiability(testApplicant.Id);
        testDebt3.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testDebt3;
        
        Liability__c testDebt4 = TestDataBuilder.createOtherLiability(testApplicant.Id);
        testDebt4.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        insert testDebt4;

        Liability__c testDebt5 = TestDataBuilder.createOtherLiability(testApplicant.Id);
        testDebt5.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testDebt5;

        Liability__c testDebt6 = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt6.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
        insert testDebt6;

        Liability__c testDebt7 = TestDataBuilder.createCardLiability(testApplicant.Id);
        testDebt7.Financier_List__c = 'Gem';
        testDebt7.Type_of_Credit_Card__c = 'Others';
        insert testDebt7;

        Liability__c testDebt8 = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt8.Overdraft_APR__c = null;
        testDebt8.Consolidate_Debt_Reduce_Limit__c = 'Please Select';
        testDebt8.Reduced_Credit_Limit__c = 333;
        insert testDebt8;

        Liability__c testDebt9 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        testDebt9.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        testDebt9.Acknowledge_Payout__c = true;
        testDebt9.Mortgage_Repayment_Amt__c = 100;
        insert testDebt9;

        Liability__c testDebt10 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        testDebt10.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        testDebt10.Acknowledge_Payout__c = true;
        testDebt10.Mortgage_Repayment_Amt__c = 100;
        insert testDebt10;
                
        Liability__c testDebt11 = new Liability__c();
        testDebt11.Applicant__c = testApplicant.Id;
        testDebt11.Debt_Category__c = 'Charge card';
        testDebt11.Financier_List__c = 'Gem';
        testDebt11.Credit_Limit_Amt__c = 100;
        testDebt11.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt11;
        
        Liability__c testDebt12 = TestDataBuilder.createCardLiability(testApplicant.Id);
        testDebt12.Financier_List__c = 'CreditLine';
        testDebt12.Type_of_Credit_Card__c = 'Others';
        testDebt12.Credit_Limit_Amt__c = 500;
        testDebt12.Card_Overdraft_Bal_Amt__c = 350;
        testDebt12.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';
        insert testDebt12; 
        
        Liability__c testDebt13 = new Liability__c();
        testDebt13.Applicant__c = testApplicant.Id;
        testDebt13.Debt_Category__c = 'Charge card';
        testDebt13.Financier_List__c = 'Creditline';
        testDebt13.Credit_Limit_Amt__c = 100;
        testDebt13.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt13;
        
         Liability__c testDebt14 = new Liability__c();
        testDebt14.Applicant__c = testApplicant.Id;
        testDebt14.Debt_Category__c = 'Credit card';
        testDebt14.Financier_List__c = 'Kiwibank';
        testDebt14.Type_of_Credit_Card__c = 'Others';
        testDebt14.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';
        testDebt14.Credit_Limit_Amt__c = 100;
        testDebt14.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt14;
        
        Liability__c testDebt15 = new Liability__c();
        testDebt15.Applicant__c = testApplicant.Id;
        testDebt15.Debt_Category__c = 'Credit card';
        testDebt15.Financier_List__c = 'ASB';
        testDebt15.Credit_Limit_Amt__c = 100;
        testDebt15.Card_Overdraft_Bal_Amt__c = 50;
        testDebt15.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';               
        insert testDebt15;
        
        Liability__c testDebt16 = new Liability__c();
        testDebt16.Applicant__c = testApplicant.Id;
        testDebt16.Debt_Category__c = 'Store card';
        testDebt16.Financier_List__c = 'Kiwibank';
        testDebt16.Credit_Limit_Amt__c = 100;
        testDebt16.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt16;
 
          Liability__c testDebt17 = new Liability__c();
        testDebt17.Applicant__c = testApplicant.Id;
        testDebt17.Debt_Category__c = 'Credit card';
        testDebt17.Financier_List__c = 'Gem';
        testDebt17.Type_of_Credit_Card__c = 'Others';
        testDebt17.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';
        testDebt17.Credit_Limit_Amt__c = 100;
        testDebt17.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt17;
        
        Liability__c testDebt18 = new Liability__c();
        testDebt18.Applicant__c = testApplicant.Id;
        testDebt18.Debt_Category__c = 'Store card';
        testDebt18.Financier_List__c = 'Gem';
        testDebt18.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';        
        testDebt18.Credit_Limit_Amt__c = 100;
        testDebt18.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt18;
        
         Liability__c testDebt19 = new Liability__c();
        testDebt19.Applicant__c = testApplicant.Id;
        testDebt19.Debt_Category__c = 'Store card';
        testDebt19.Financier_List__c = 'Creditline';
        testDebt19.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';        
        testDebt19.Credit_Limit_Amt__c = 100;
        testDebt19.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt19;

        Liability__c testDebt20 = new Liability__c();
        testDebt20.Applicant__c = testApplicant.Id;
        testDebt20.Debt_Category__c = 'Store card';
        testDebt20.Financier_List__c = 'Kiwibank';
        testDebt20.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';        
        testDebt20.Credit_Limit_Amt__c = 100;
        testDebt20.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt20;

         Liability__c testDebt21 = new Liability__c();
        testDebt21.Applicant__c = testApplicant.Id;
        testDebt21.Debt_Category__c = 'Store card';
        testDebt21.Financier_List__c = 'ANZ';
        testDebt21.Consolidate_Debt_Reduce_Limit__c = 'Reduce the credit limit';        
        testDebt21.Credit_Limit_Amt__c = 100;
        testDebt21.Card_Overdraft_Bal_Amt__c = 50;
        insert testDebt21;
        
         Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            MyBudgetsDebtWrapper m1 = new MyBudgetsDebtWrapper(testApplicant);
            MyBudgetsDebtWrapper m2 = new MyBudgetsDebtWrapper(testDebt2);
            MyBudgetsDebtWrapper m3 = new MyBudgetsDebtWrapper(testDebt3);
            MyBudgetsDebtWrapper m4 = new MyBudgetsDebtWrapper(testDebt4);
            MyBudgetsDebtWrapper m5 = new MyBudgetsDebtWrapper(testDebt5);
            MyBudgetsDebtWrapper m6 = new MyBudgetsDebtWrapper(testDebt6);
            MyBudgetsDebtWrapper m7 = new MyBudgetsDebtWrapper(testDebt7);
            MyBudgetsDebtWrapper m8 = new MyBudgetsDebtWrapper(testDebt8);
            MyBudgetsDebtWrapper m9 = new MyBudgetsDebtWrapper(testDebt9);
            MyBudgetsDebtWrapper m10 = new MyBudgetsDebtWrapper(testDebt10);
            MyBudgetsDebtWrapper m11 = new MyBudgetsDebtWrapper(testDebt11);
            MyBudgetsDebtWrapper m12 = new MyBudgetsDebtWrapper(testDebt12);
            MyBudgetsDebtWrapper m13 = new MyBudgetsDebtWrapper(testDebt13);
            MyBudgetsDebtWrapper m14 = new MyBudgetsDebtWrapper(testDebt14);
            MyBudgetsDebtWrapper m15 = new MyBudgetsDebtWrapper(testDebt15);
            MyBudgetsDebtWrapper m16 = new MyBudgetsDebtWrapper(testDebt16);
            MyBudgetsDebtWrapper m17 = new MyBudgetsDebtWrapper(testDebt17);
            MyBudgetsDebtWrapper m18 = new MyBudgetsDebtWrapper(testDebt18);
            MyBudgetsDebtWrapper m19 = new MyBudgetsDebtWrapper(testDebt19);
            MyBudgetsDebtWrapper m20 = new MyBudgetsDebtWrapper(testDebt20);
            MyBudgetsDebtWrapper m21 = new MyBudgetsDebtWrapper(testDebt21);
            
            
            m1.rowCount =0;
            m1.isJoint = true;
            
                m1.clearDebtFields();
                m2.clearDebtFields();
                m3.clearDebtFields();
                m4.clearDebtFields();
                m5.clearDebtFields();
                m6.clearDebtFields();
                m7.clearDebtFields();
                m8.clearDebtFields();
                m9.clearDebtFields();
                m10.clearDebtFields();
                m1.validateDebt(true,'VIC');
                m2.validateDebt(true,'VIC');
                m3.validateDebt(true,'VIC');
                m4.validateDebt(true,'VIC');
                m5.validateDebt(true,'VIC');
                m6.validateDebt(true,'VIC');
                m7.validateDebt(true,'VIC');
                m8.validateDebt(true,'VIC');
                m9.validateDebt(true,'VIC');
                m1.getDebtAmount('Australia');
                m2.getDebtAmount('Australia');
                m3.getDebtAmount('Australia');
                m4.getDebtAmount('Australia');
                m5.getDebtAmount('Australia');
                m6.getDebtAmount('Australia');
                m7.getDebtAmount('Australia');
                m8.getDebtAmount('Australia');
                m9.getDebtAmount('Australia');
                m1.getAUDebtAmount();
                m2.getAUDebtAmount();
                m3.getAUDebtAmount();
                m4.getAUDebtAmount();
                m5.getAUDebtAmount();
                m6.getAUDebtAmount();
                m7.getAUDebtAmount();
                m8.getAUDebtAmount();
                m9.getAUDebtAmount();
                m1.getNZDebtAmount();
                m2.getNZDebtAmount();
                m3.getNZDebtAmount();
                m4.getNZDebtAmount();
                m5.getNZDebtAmount();
                m6.getNZDebtAmount();
                m7.getNZDebtAmount();
                m8.getNZDebtAmount();
                m9.getNZDebtAmount();
                m11.getNZDebtAmount();
                m12.getNZDebtAmount();
                m13.getNZDebtAmount();
                m14.getNZDebtAmount();
                m15.getNZDebtAmount();
                m16.getNZDebtAmount();
                m11.getDebtTotalAmount('NZ');
                m12.getDebtTotalAmount('NZ');
                m13.getDebtTotalAmount('NZ');
                m14.getDebtTotalAmount('NZ');
                m15.getDebtTotalAmount('NZ');
                m16.getDebtTotalAmount('NZ');                
                m17.getDebtTotalAmount('NZ');
                m18.getDebtTotalAmount('NZ');
                m19.getDebtTotalAmount('NZ');
                m20.getDebtTotalAmount('NZ');
                m21.getDebtTotalAmount('NZ');
                m17.getDebtTotalAmount('AU');
                m1.getDebtTotalAmount('Australia');
                m2.getDebtTotalAmount('Australia');
                m3.getDebtTotalAmount('Australia');
                m4.getDebtTotalAmount('Australia');
                m5.getDebtTotalAmount('Australia');
                m6.getDebtTotalAmount('Australia');
                m7.getDebtTotalAmount('Australia');
                m8.getDebtTotalAmount('Australia');
                m9.getDebtTotalAmount('Australia');
         Test.StopTest();
   }
   static testMethod void methodTwo(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        testProduct.Product_Name__c = 'Latitude Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Product_SubType__c = 'Better Start PL';
        testApplication.Offered_Interest_Rate_Orig__c = 13.99;
        testApplication.Loan_Term_Months__c = 24;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Acceptance_Channel__c= 'Internet';
        testApplication.Offered_Interest_Rate__c = 13.99;
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Previous_App_No__c = 'new';
        testApplication.Promo_ID__c = 'old loan';
        testApplication.Initial_Submit_Date__c = System.Today();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '0212345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '0212345678';
            testApplicant.Country_Pos__c = 'New Zealand';
            testApplicant.Country_Res__c = 'New Zealand';
            testApplicant.Country_Pre__c = 'New Zealand';
            testApplicant.State_Res__c = 'PARRAMATTA';
            testApplicant.State_Pos__c = 'PARRAMATTA';
            testApplicant.State_Pre__c = 'PARRAMATTA';
            testApplicant.City_Pos__c = 'TEST';
            testApplicant.City_Pre__c = 'VIC';
           insert testApplicant;
           
           Liability__c lb1 = new Liability__c();
               lb1.Debt_Category__c = 'Charge Card';
               lb1.Applicant__c = testApplicant.Id;
               lb1.Card_Overdraft_Bal_Amt__c = 1000;
               lb1.Credit_Limit_Amt__c = 1500;
               insert lb1;

           Liability__c lb2 = new Liability__c();
               lb2.Debt_Category__c = 'Charge Card';
               lb2.Applicant__c = testApplicant.Id;
               lb2.Card_Overdraft_Bal_Amt__c = 1500;
               lb2.Credit_Limit_Amt__c = 1000;
               insert lb2;

           Liability__c lb3 = new Liability__c();
               lb3.Debt_Category__c = 'Mortgage';
               lb3.Applicant__c = testApplicant.Id;
               lb3.Mortgage_Bal_Amt__c= 0;
               lb3.Mortgage_Borrowed_Amt__c = 0;
               lb3.Mortgage_Repayment_Amt__c = 0;
               lb3.Mortgage_Repayment_Interval__c = 'None';
               insert lb3;
               
           Liability__c lb4 = new Liability__c();
               lb4.Debt_Category__c = 'Personal loan';
               lb4.Applicant__c = testApplicant.Id;
               lb4.Car_Personal_Bal_Amt__c = 0;
               lb4.Car_Personal_Repay_Amt__c = 0;
               lb4.Car_Personal_Borrowed_Amt__c = 0;
               lb4.Car_Personal_Repay_Int__c = 'None';
               insert lb4;

           Liability__c lb5 = new Liability__c();
               lb5.Debt_Category__c = 'Other';
               lb5.Applicant__c = testApplicant.Id;
               lb5.Type_of_Debt__c = null;
               lb5.Other_Borrowed_Amt__c = null;
               lb5.Other_Repay_Amt__c = 0;
               lb5.Other_Repay_Int__c = 'None';
               insert lb5;

           Liability__c lb6 = new Liability__c();
               lb6.Debt_Category__c = 'Credit card';
               lb6.Applicant__c = testApplicant.Id;
               lb6.Consolidate_Debt_Reduce_Limit__c = 'Consolidate the debt';
               lb6.Credit_Limit_Amt__c = 0;
               lb6.Card_Overdraft_Bal_Amt__c = null;
               insert lb6;

                              
        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            MyBudgetsDebtWrapper m1 = new MyBudgetsDebtWrapper(testApplicant);
            MyBudgetsDebtWrapper m2 = new MyBudgetsDebtWrapper(lb1);                           
            MyBudgetsDebtWrapper m3 = new MyBudgetsDebtWrapper(lb2);
            MyBudgetsDebtWrapper m4 = new MyBudgetsDebtWrapper(lb3);                                       
            MyBudgetsDebtWrapper m5 = new MyBudgetsDebtWrapper(lb4);                                       
            MyBudgetsDebtWrapper m6 = new MyBudgetsDebtWrapper(lb5);                                       
            MyBudgetsDebtWrapper m7 = new MyBudgetsDebtWrapper(lb6);                                       
            m2.getAUDebtAmount();
            m3.getAUDebtAmount();
            m4.validateDebt(true,'VIC');
            m5.validateDebt(true,'VIC');
            m6.validateDebt(true,'NZ');
            m7.validateDebt(true,'NZ');

        Test.StopTest();
  }   
}