/*
 * @Description: Handler for Applicant Trigger
 * @Author: Afreen Khan
 * @Date Created: June 14, 2016
 * @History:
 * =====================================================================
 *     Afreen - June 14, 2016: Created
       
 * =====================================================================
 */
public  class ApplicantTriggerHandler {
    
    /*
     * @Description: Populate street type code for third party applications on insert/update
     * @Author: Adrian Recio
     * @Date Created: August 11, 2016
     */
     public static void populateThirdPartyST(List<Applicant__c> applicantList){
    
        List<Third_Party_Street_Type__mdt> sTCodeList = [select Street_Type_Code__c, DeveloperName from Third_Party_Street_Type__mdt];
        Map<String, string> sTCodeMap = new Map<String, String>();

        for(Third_Party_Street_Type__mdt stCodeVar : sTCodeList){
            sTCodeMap.put(stCodeVar.DeveloperName,stCodeVar.Street_Type_Code__c );
        }
        
        for(Applicant__c appliVar: applicantList){
             if(appliVar.Street_Type_Pos__c!=null){ 
                String posCode = sTCodeMap.get(appliVar.Street_Type_Pos__c.replace(' ','_'));
                appliVar.Pos__c = posCode;
             }else{
                appliVar.Pos__c = null; 
             }
             if(appliVar.Street_Type_Res__c!=null){
                String resCode = sTCodeMap.get(appliVar.Street_Type_Res__c.replace(' ','_'));
                appliVar.Res__c = resCode;
             }else{
                appliVar.Res__c = null;
             }
             if(appliVar.Street_Type_Pre__c!=null){
                String preCode = sTCodeMap.get(appliVar.Street_Type_Pre__c.replace(' ','_'));
                appliVar.Pre__c = preCode; 
             }else{
                appliVar.Pre__c = null;  
             }
        } 
     }

    /*
     * @Description: Method to Filter out the duplicate applicant
     * @Author: Afreen Khan
     * @Date Created: June 15, 2016
     */
    public static void checkExternalApplicantEmail(List<Applicant__c> applicantList){

        system.debug('Condition1');

        Set<string> parentAppSet = new Set<string>();       // Set of parent application Ids

        // Pull parent application details
        for(Applicant__c appVar: applicantList){
            if(appVar.Application__c!=null){
                parentAppSet.add(appVar.Application__c);
            }
        }

        system.debug('Condition2');

        Map<Id, Application__c> parentAppMap = new Map<Id,Application__c>([Select Id, Channel__c, X3rd_Party_Application_Source__c, 
                                                                            Final_Approved_Date__c, Response_Code__c 
                                                                           from Application__c where Id In :parentAppSet]);

        system.debug('Condition3');

        Set<string> emailDupCheckSet = new Set<string>();   // Main pool of duplicate emails for current list of applicant records being inserted
        Set<string> emailFailCheckSet = new Set<string>();  // Main pool of identified duplicate email for current list of applicant records being inserted
        Boolean IsExternalExist = false; 

        // Validate that there are no duplicates in the current batch
      
        for(Applicant__c appVar: applicantList){
            Boolean IsExternalApp = isExternalApp(parentAppMap.get(appVar.Application__c));
            system.debug('Condition4');
            if(IsExternalApp && appVar.Email_Address__c!=null){ 
                system.debug('Condition5');
                IsExternalExist = true;
                if(emailDupCheckSet.contains(appVar.Email_Address__c)){
                    system.debug('Condition6');
                    appVar.Email_Address__c.addError('Email already exists.');
                    emailFailCheckSet.add(appVar.Email_Address__c);
                }else{
                    system.debug('Condition7');
                    emailDupCheckSet.add(appVar.Email_Address__c);
                }
            }
        }
    	
        system.debug('IsExternalExist:' + IsExternalExist);

        // Check that at least one external application exist
        if(IsExternalExist==true){
           
            Boolean buildFind = false;
            string serachTerm = '';

            for(string emailVar: emailDupCheckSet){
                if(emailFailCheckSet.contains(emailVar)==false){
                    if(buildFind == false){
                        serachTerm = emailVar;
                        buildFind = true;
                    }else{
                         serachTerm = serachTerm + ' OR ' + emailVar;
                    }
                }
            }
            
            // Pull existing applicant email duplicates and build applicant map where key is the email
            String searchQuery = 'FIND \'' + serachTerm + '\' IN EMAIL FIELDS RETURNING Applicant__c(Application__c, Email_Address__c)';
            system.debug('Search String:' + searchQuery);

            List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
            Map<Id, Applicant__c> existingApplicants =  new Map<Id, Applicant__c>(((List<Applicant__c>)ListOfListOfSObjects[0]));
            system.debug('Search Result:' + existingApplicants);

            Set<String> appExistParentId = new Set<String>();

            Map<string, applicant__c>existingApplicantsMap = new Map<string, applicant__c>();

            for(Applicant__c appVar: existingApplicants.values()){
                existingApplicantsMap.put(appVar.Email_Address__c,appVar);
                appExistParentId.add(appVar.Application__c);
            }

            Map<String, Application__c> existingApplicationMap = new Map<String, Application__c>([Select Id, Response_Code__c, Final_Approved_Date__c 
                                                                                       from Application__c where Id In :appExistParentId]);

            // Compare applicant list with matching application duplicate list
            for(Applicant__c appVar: applicantList){
				Boolean IsExternal = isExternalApp(parentAppMap.get(appVar.Application__c));
                
                system.debug('External Check:' + IsExternal);
                system.debug('Email Fail Check:' + emailFailCheckSet.contains(appVar.Email_Address__c));
                
                if( IsExternal && 
                    emailFailCheckSet.contains(appVar.Email_Address__c) == false){
                    
                    Applicant__c applicantVar = existingApplicantsMap.get(appVar.Email_Address__c);
                        
                    system.debug('Applicant duplicate value:' + applicantVar);
                        
                    if(applicantVar!=null){
                        Application__c pAppliVar = existingApplicationMap.get(applicantVar.Application__c);

                        system.debug('Application duplicate value:' + pAppliVar);
                        
                        if(pAppliVar!=null){
                            if(pAppliVar.Response_Code__c == 'FIA'){
                                Date finalApprovedDate = pAppliVar.Final_Approved_Date__c;
                                Date dueDate = Date.today();
                                Integer daysBetween = finalApprovedDate.daysBetween(dueDate);

                                if (daysBetween <= 7) {
                                    appVar.Email_Address__c.addError('Email already exists.');
                                } 
                            }else if(pAppliVar.Response_Code__c != 'FFID' && 
                                pAppliVar.Response_Code__c != 'Abandoned' &&
                                pAppliVar.Response_Code__c != 'FIA' &&
                                pAppliVar.Response_Code__c != 'FIC' &&
                                pAppliVar.Response_Code__c != 'FID'){
                                appVar.Email_Address__c.addError('Email already exists.');
                            }
                        }
                    }
                }

            }
			
        }
    }
    
    /*
     * @Description: Identifies the external app
     * @Author: Afreen Khan
     * @Date Created: June 14, 2016
     */
    
    public static Boolean isExternalApp(Application__c application){
        if(application.Channel__c == '3rd Party Application'){
            return true;
        }
        return false;
    }
}