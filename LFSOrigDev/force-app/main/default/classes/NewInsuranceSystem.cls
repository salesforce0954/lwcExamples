global class NewInsuranceSystem implements Database.Batchable<SObject>, Database.Stateful {
    
      global list<Lead_Generation__c> successfulLeads = new list<Lead_Generation__c>();
      global list<Lead_Generation__c> failedLeads = new list<Lead_Generation__c>();
      global List<String> errorMessages = new List<String>();
      global String query;
      global String failedDML;
      global String errorText;
      global Set<Id> failureIdsSet;

    
    global Database.QueryLocator start(Database.BatchableContext BC){
       String CountryRes = 'Australia';
       String appStatus = 'Accepted';
       
       Set<String> empTypes = new Set<String>();
       empTypes.add('Casual / Temporary');
       empTypes.add('Casual');
       empTypes.add('Retired');
       empTypes.add('Home Duties');
       empTypes.add('Disability Pension');
       empTypes.add('Workcover / Workers Compensation');
       empTypes.add('Unemployed');
       empTypes.add('Other Pension e.g. Carer\'s Pension');
      try{
          query = 'select (select First_Name__c,Last_Name__c,Unit_No_Res__c,Street_No_Res__c,Street_Res__c,Street_Type_Res__c,Suburb_Res__c,State_Res__c,Postcode_Res__c,Country_Res__c,Gender_Code__c,Date_of_Birth__c,Applicant_Age__c,No_of_Deps__c,Email_Address__c,Mobile__c,Home__c,Work__c,Primary_Employment_Status_Code__c from Applicant__r), (select Loan_Purpose_Value_Code__c from Loan_Purpose__r),Contract_Account_Number__c,Application_Type__c,Total_Loan_Amount__c,Total_Loan_Amount_with_Insurance__c,Loan_Term_Months__c,EMI_with_Service_Fee__c,Final_Approved_Date__c,Final_Approval_Datetime__c from Application__c where id in (select Application__c from Applicant__c where Country_Res__c =:CountryRes and Application__r.Final_Approved_Date__c = yesterday and Application__r.Status__c = :appStatus and (Applicant_Age__c >=18 and Applicant_Age__c <66) and (Application__r.Total_Loan_Amount_with_Insurance__c >0 and Application__r.Total_Loan_Amount_with_Insurance__c <100000) and (Application__r.EMI_with_Service_Fee__c >0 and Application__r.EMI_with_Service_Fee__c <2000) and Primary_Employment_Status__c NOT IN: empTypes)';
      }
       catch(Exception e1){
              errorText = e1.getMessage();
              System.debug('Error Text One : ++++++++++++++++' + errorText);
       }
          return Database.getQueryLocator(query);   
      }   
      
    global void execute(Database.BatchableContext bc, List<Application__c> scope) {   
        List<Lead_Generation__c> leadsList = new List<Lead_Generation__c>();
          Lead_Generation__c lge = new Lead_Generation__c();
        try {
        for(Application__c app : scope){     
            if(app.Application_Type__c == 'Single'){                 
           
                    for(Applicant__c applicant : app.Applicant__r){
                        lge.Applicant_1_First_Name__c = applicant.First_Name__c;
                        lge.Applicant_1_Last_Name__c =  applicant.Last_Name__c;
                        lge.Applicant_1_Unit_Number__c  = applicant.Unit_No_Res__c; 
                        lge.Applicant_1_Street_Number__c    = applicant.Street_No_Res__c; 
                        lge.Applicant_1_Street_Name__c  = applicant.Street_Res__c; 
                        lge.Applicant_1_Street_Type__c  = applicant.Street_Type_Res__c.touppercase(); 
                        lge.Applicant_1_Suburb__c   = applicant.Suburb_Res__c;   
                        lge.Applicant_1_State__c    = applicant.State_Res__c; 
                        lge.Applicant_1_Postcode__c = applicant.Postcode_Res__c; 
                        lge.Applicant_1_Country__c  = applicant.Country_Res__c.touppercase(); 
                        lge.Applicant_1_Gender__c   = applicant.Gender_Code__c; 
                        lge.Applicant_1_Date_of_Birth__c    = APP_AccountDataExt.formatCLVDateToSF(applicant.Date_of_Birth__c, 'SF');  
                        lge.Applicant_1_Dependents__c   = applicant.No_of_Deps__c; 
                        lge.Applicant_1_Email_Address__c    = applicant.Email_Address__c; 
                        lge.Applicant_1_Mobile__c   = applicant.Mobile__c;
                        lge.Applicant_1_Home__c = applicant.Home__c;
                        lge.Applicant_1_Work__c = applicant.Work__c;                       
                        lge.Applicant_1_Primary_Employement_Type__c = applicant.Primary_Employment_Status_Code__c;                                                                                                                                                        
                    }
           }else if(app.Application_Type__c == 'Joint'){
                   for(List<Applicant__c> applicant : app.Applicant__r){
                        lge.Applicant_1_First_Name__c     = applicant[0].First_Name__c;
                        lge.Applicant_1_Last_Name__c      =  applicant[0].Last_Name__c;
                        lge.Applicant_1_Unit_Number__c    = applicant[0].Unit_No_Res__c; 
                        lge.Applicant_1_Street_Number__c  = applicant[0].Street_No_Res__c; 
                        lge.Applicant_1_Street_Name__c  = applicant[0].Street_Res__c; 
                        lge.Applicant_1_Street_Type__c  = applicant[0].Street_Type_Res__c.touppercase(); 
                        lge.Applicant_1_Suburb__c   = applicant[0].Suburb_Res__c;   
                        lge.Applicant_1_State__c    = applicant[0].State_Res__c; 
                        lge.Applicant_1_Postcode__c = applicant[0].Postcode_Res__c; 
                        lge.Applicant_1_Country__c  = applicant[0].Country_Res__c.touppercase(); 
                        lge.Applicant_1_Gender__c   = applicant[0].Gender_Code__c; 
                        lge.Applicant_1_Date_of_Birth__c    = APP_AccountDataExt.formatCLVDateToSF(applicant[0].Date_of_Birth__c, 'SF');  
                        lge.Applicant_1_Dependents__c   = applicant[0].No_of_Deps__c; 
                        lge.Applicant_1_Email_Address__c    = applicant[0].Email_Address__c; 
                        lge.Applicant_1_Mobile__c   = applicant[0].Mobile__c;
                        lge.Applicant_1_Home__c = applicant[0].Home__c;
                        lge.Applicant_1_Work__c = applicant[0].Work__c;
                        lge.Applicant_1_Primary_Employement_Type__c = applicant[0].Primary_Employment_Status_Code__c;

                        lge.Applicant_2_First_Name__c = applicant[1].First_Name__c;
                        lge.Applicant_2_Last_Name__c =  applicant[1].Last_Name__c;
                        lge.Applicant_2_Unit_Number__c  = applicant[1].Unit_No_Res__c; 
                        lge.Applicant_2_Street_Number__c    = applicant[1].Street_No_Res__c; 
                        lge.Applicant_2_Street_Name__c  = applicant[1].Street_Res__c; 
                        lge.Applicant_2_Street_Type__c  = applicant[1].Street_Type_Res__c.touppercase(); 
                        lge.Applicant_2_Suburb__c   = applicant[1].Suburb_Res__c;   
                        lge.Applicant_2_State__c    = applicant[1].State_Res__c; 
                        lge.Applicant_2_Postcode__c = applicant[1].Postcode_Res__c; 
                        lge.Applicant_2_Country__c  = applicant[1].Country_Res__c.touppercase(); 
                        lge.Applicant_2_Gender__c   = applicant[1].Gender_Code__c; 
                        lge.Applicant_2_Date_of_Birth__c    = APP_AccountDataExt.formatCLVDateToSF(applicant[1].Date_of_Birth__c, 'SF');  
                        lge.Applicant_2_Dependents__c   = applicant[1].No_of_Deps__c; 
                        lge.Applicant_2_Email_Address__c    = applicant[1].Email_Address__c; 
                        lge.Applicant_2_Mobile__c   = applicant[1].Mobile__c;
                        lge.Applicant_2_Home__c = applicant[1].Home__c;
                        lge.Applicant_2_Work__c = applicant[1].Work__c;
                        lge.Applicant_2_Primary_Employement_Type__c = applicant[1].Primary_Employment_Status_Code__c;   
                  }                                                                   
           }               
                        Decimal loanAmount = app.Total_Loan_Amount_with_Insurance__c;
                        String x = String.valueOf(loanAmount).remove('.');
                        lge.Loan_Amount__c = Decimal.valueOf(x);
                        lge.Loan_Type__c = (app.Application_Type__c).touppercase();
                        lge.Loan_Term__c = app.Loan_Term_Months__c;
                        lge.Loan_Account_Number__c = app.Contract_Account_Number__c;
                        lge.Loan_Settlement_Date__c = app.Final_Approval_Datetime__c;
                        lge.Loan_Settled_Date__c = app.Final_Approved_Date__c;
                        //lge.Loan_Settled_Date__c = System.today();
                        Decimal emi = app.EMI_with_Service_Fee__c;
                        String y = String.valueOf(emi).remove('.');
                        lge.Monthly_Repayment__c = Decimal.valueOf(y);
                        for(Loan_Purpose__c lp : app.Loan_Purpose__r){                     
                            for(integer i=0;i<app.Loan_Purpose__r.size();i++){
                            if(app.Loan_Purpose__r.size() == 1){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c ;
                            }else if(app.Loan_Purpose__r.size() == 2){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 3){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 4){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 5){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 6){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[5].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 7){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[5].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[6].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 8){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[5].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[6].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[7].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 9){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[5].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[6].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[7].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[8].Loan_Purpose_Value_Code__c;
                            }else if(app.Loan_Purpose__r.size() == 10){
                                lge.Loan_Purpose__c = app.Loan_Purpose__r[0].Loan_Purpose_Value_Code__c + ';'+app.Loan_Purpose__r[1].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[2].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[3].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[4].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[5].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[6].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[7].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[8].Loan_Purpose_Value_Code__c+ ';'+app.Loan_Purpose__r[9].Loan_Purpose_Value_Code__c;
                            }
                        }               
                        System.debug('Result++'+lge.Loan_Purpose__c);
                    }
                        leadsList.add(lge);
      }
                        Database.SaveResult[] insertResults  = Database.insert(leadsList,false);
                        for(Integer i=0;i<insertResults.size();i++){
                            if (insertResults.get(i).isSuccess()){
                                successfulLeads.add(leadsList.get(i));
                            }else if (!insertResults.get(i).isSuccess()){
                                // DML operation failed
                                Database.Error error = insertResults.get(i).getErrors().get(0);
                                failedDML = error.getMessage() + error.getFields();
                                //failedDML = error.getMessage();
                                failedLeads.add(leadsList.get(i));//failed record from the list
                            }
                        }
          }catch(Exception e2){
              errorText = e2.getMessage();
              System.debug('Error Text Two : ++++++++++++++++' + errorText);
          }                                                          
                                                          
   }
   
    global void finish(Database.batchablecontext bc) {
   }
}