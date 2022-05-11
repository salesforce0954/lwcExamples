/*
 * @Description: Extension Controller for GE 'About Me' VF Page (Joint Application Staff UI)
 * @Author: Mike Lasala
 * @Date Created: NOV-18-2013
 * @History:
   =====================================================================
        NOV-18-2013 (Mike): Created.
        DEC-03-2013 (Mike): Added EIDV
        JAN-13-2014 (Mike): Refactor to cater single and joint applications
        JAN-13-2014 (Mike): Changed approach to wrapper class
        FEB-14-2014 (Jade): Added validation. driver's licence cannot be the same for applicant 1 & applicant 2.     
        AUG-13-2015 (Mike): BACK ISSUE
   =====================================================================
 */ 
public with sharing class APP_JointPersonalDetailsExt_INT extends APP_CommonExt{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================    
    public personalDetailsWrapper applicantWrapper      {get;set;}
    public personalDetailsWrapper applicant2Wrapper     {get;set;}
    public String webServer                             {get;set;}
    public String webServerWebService                   {get;set;}
    public String URLKey                                {get;set;}
    public String mode                                  {get;set;}
    public String redirectTo                            {get;set;}
    
    //TXU For NZ Data Tool Custom Settings
    public string NZEndpoint                            {get;set;}
    public string NZRequestKey                          {get;set;}
       
    public List<personalDetailsWrapper> applicantWrapperList = new List<personalDetailsWrapper>();
    public Boolean applicantValidationResults;
    public Boolean amlValidationResults;
    
    //Class constructor
    public APP_JointPersonalDetailsExt_INT(ApexPages.standardController sc){
        
        super(sc);
        
        webServer = Datatools__c.getValues('Datatools').Endpoint__c;
        webServerWebService = Datatools__c.getValues('Datatools').Endpoint_json_ws__c;
        URLKey = Datatools__c.getValues('Datatools').URL_Key__c;
        NZEndpoint = Datatools__c.getValues('Datatools').NZ_Endpoint__c;
        NZRequestKey = Datatools__c.getValues('Datatools').NZ_Request_Key__c;        
        Mode = ApexPages.currentPage().getParameters().get('Mode');

        if(!applicantList.isEmpty()){
            applicantWrapperList = new List<personalDetailsWrapper>();
            
            for(Applicant__c a: this.applicantList){
                personalDetailsWrapper pdw = new personalDetailsWrapper();
                pdw.applicant = a;
                pdw.applicationCountry = brand.country__c;//populating new attribute added to personaldetailswrapper class 
                pdw.isStaffUi = true;
                applicantWrapperList.add(pdw);
            }
            
            for(personalDetailsWrapper pdw: applicantWrapperList){
                //Set default values for Applicant/s
                pdw.NoOfDeps = String.valueOf(pdw.applicant.No_Of_Deps__c);
              
                if(pdw.applicant.Date_Of_Birth__c != null){
                    
                    if(String.valueOf(pdw.applicant.Date_Of_Birth__c) != ''){
                        pdw.disableDOB = true;
                    }
                }
                
                if(pdw.applicant.Issue_Date__c != null){
                    pdw.issueYear = Util.integerToString(pdw.applicant.Issue_Date__c.year());
                    pdw.issueMonth = pdw.applicant.Issue_Date__c.month() < 10 ?'0'+Util.integerToString(pdw.applicant.Issue_Date__c.month()) : Util.integerToString(pdw.applicant.Issue_Date__c.month());
                    pdw.issueDate =  pdw.applicant.Issue_Date__c.day() < 10 ? '0' + Util.integerToString(pdw.applicant.Issue_Date__c.day()):Util.integerToString(pdw.applicant.Issue_Date__c.day()); 
                }
                
                if(pdw.applicant.Expiry_Date__c != null){
                    pdw.expiryYear = Util.integerToString(pdw.applicant.Expiry_Date__c.year());
                    pdw.expiryMonth = pdw.applicant.Expiry_Date__c.month() < 10?'0'+Util.integerToString(pdw.applicant.Expiry_Date__c.month()):Util.integerToString(pdw.applicant.Expiry_Date__c.month());
                    pdw.expiryDate = pdw.applicant.Expiry_Date__c.day() < 10?'0'+Util.integerToString(pdw.applicant.Expiry_Date__c.day()):Util.integerToString(pdw.applicant.Expiry_Date__c.day());
                }

                if(pdw.applicant.Drivers_Lic_Flg__c == true){
                    pdw.disableDrvcAst = 'hidden';
                }
                
                if(pdw.applicant.Email_Address__c != null){
                    pdw.disableEmail = true;
                } else {
                    pdw.disableEmail = false;
                }
                                    
                pdw.PostalFlag = null;                    
                if(pdw.applicant.First_Name__c != null && pdw.applicant.last_Name__c != null){
                    pdw.PostalFlag = 'Yes';
                    if(pdw.applicant.Postal_Addr_Flg__c == true){
                        pdw.PostalFlag = 'No';
                    }
                }
            }
            
            checkDriversLicense();
            
            applicantWrapper = applicantWrapperList.get(0);
            
            if(applicantList.size()>1){
                applicant2Wrapper = applicantWrapperList.get(1);
                if(applicantWrapperList.get(1).applicant.Email_Address__c != null){
                    applicant2Wrapper.disableEmail = true;
                }
                else{
                    applicant2Wrapper.disableEmail = false;
                }
                applicant2Wrapper.NoOfDeps = String.valueOf(applicantWrapperList.get(1).applicant.No_Of_Deps__c);
                
            }
        }
    }
    
    /*  Description: Enables/disables Driver's License No field
     *  Author: Mike Lasala
     *  Date Created: JAN-13-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    public void checkDriversLicense(){
        for(personalDetailsWrapper pdw: applicantWrapperList){
            if(pdw.applicant.Drivers_Lic_Flg__c == true){
                pdw.applicant.Drivers_Lic_No__c = '';
                pdw.disableDrvcAst = 'hidden';
            } else {
                pdw.disableDrvcAst = 'visible';
            }
        }
    }
    
    /*
     * @Description: void method to validate and capture Applicant field from the Page
     * @Author: Russell Cadapan
     * @Date Created: OCT-01-2013
     */    
    public Boolean validateApplicant(){

        String errorMessage = '';
        applicantValidationResults = true;

        this.applicantList.clear();

        for(personalDetailsWrapper pdw: applicantWrapperList){
            
            this.applicantList.add(pdw.applicant);
          
            
            if(!pdw.validateApplicant(pdw.applicant,pdw)) {
                applicantValidationResults = false;
                
                if(this.applicantList.size()>1){
                    if(pdw.applicant == this.applicant){
                        errorMessage = '1 tab'; 
                    } else if(pdw.applicant == this.applicant2){
                        if(errorMessage != ''){
                            errorMessage = '1 and 2 tabs';  
                        } else {
                            errorMessage = '2 tab';
                        } 
                    }   
                }
            }else{
                pdw.executePOBox();
            } 
        }
     
        if(applicantList.size()>1){
            if((applicantWrapper.applicant.Drivers_Lic_No__c != '' && applicantWrapper.applicant.Drivers_Lic_No__c != null) && 
               (applicant2Wrapper.applicant.Drivers_Lic_No__c != '' && applicantWrapper.applicant.Drivers_Lic_No__c != null) &&  
               brand.country__c != GEN_OriginationsConstants.NZ_REGION){
                
                if(applicantWrapper.applicant.Drivers_Lic_No__c == applicant2Wrapper.applicant.Drivers_Lic_No__c){
                    Util.addMessage(ApexPages.Severity.ERROR, 'Driver\'s license cannot be the same for Applicant 1 & Applicant 2');
                    applicantValidationResults = false;
                }
            }
        }
        
        if(applicantWrapperList[0].issueYear != null && applicantWrapperList[0].issueYear != '' && applicantWrapperList[0].issueDate != 'Select' &&
           applicantWrapperList[0].issueMonth != null && applicantWrapperList[0].issueMonth != '' && applicantWrapperList[0].issueMonth != 'Select' &&
           applicantWrapperList[0].issueDate != null && applicantWrapperList[0].issueDate != ''){
           
           applicantList[0].Issue_Date__c = date.newinstance(
                                                            Util.stringToInteger(applicantWrapperList[0].issueYear),
                                                            Util.stringToInteger(applicantWrapperList[0].issueMonth),
                                                            Util.stringToInteger(applicantWrapperList[0].issueDate)
                                                          );
        }

        if(applicantWrapperList[0].expiryYear != null && applicantWrapperList[0].expiryYear != '' && applicantWrapperList[0].expiryDate != 'Select' &&
           applicantWrapperList[0].expiryMonth != null && applicantWrapperList[0].expiryMonth != '' && applicantWrapperList[0].expiryMonth != 'Select' &&
           applicantWrapperList[0].expiryDate != null && applicantWrapperList[0].expiryDate != ''){
            
            applicantList[0].Expiry_Date__c = date.newinstance(
                                                            Util.stringToInteger(applicantWrapperList[0].expiryYear),
                                                            Util.stringToInteger(applicantWrapperList[0].expiryMonth),
                                                            Util.stringToInteger(applicantWrapperList[0].expiryDate)
                                                          );
        }

        if(applicantWrapperList.size() > 1){
            if(applicantWrapperList[1].issueYear != null && applicantWrapperList[1].issueYear != '' && applicantWrapperList[1].issueDate != 'Select' &&
               applicantWrapperList[1].issueMonth != null && applicantWrapperList[1].issueMonth != '' && applicantWrapperList[1].issueMonth != 'Select' &&
               applicantWrapperList[1].issueDate != null && applicantWrapperList[1].issueDate != ''){
                
                applicantList[1].Issue_Date__c = date.newinstance(
                                                                Util.stringToInteger(applicantWrapperList[1].issueYear),
                                                                Util.stringToInteger(applicantWrapperList[1].issueMonth),
                                                                Util.stringToInteger(applicantWrapperList[1].issueDate)
                                                              );
            }

            if(applicantWrapperList[1].expiryYear != null && applicantWrapperList[1].expiryYear != '' && applicantWrapperList[1].expiryDate != 'Select' &&
               applicantWrapperList[1].expiryMonth != null && applicantWrapperList[1].expiryMonth != '' && applicantWrapperList[1].expiryMonth != 'Select' &&
               applicantWrapperList[1].expiryDate != null && applicantWrapperList[1].expiryDate != ''){
                
                applicantList[1].Expiry_Date__c = date.newinstance(
                                                                Util.stringToInteger(applicantWrapperList[1].expiryYear),
                                                                Util.stringToInteger(applicantWrapperList[1].expiryMonth),
                                                                Util.stringToInteger(applicantWrapperList[1].expiryDate)
                                                              );
            }
        }
       
        amlValidationResults = true;
        List<AML__c> lst_aml = new List<AML__c>();
    
        if(brand.country__c == GEN_OriginationsConstants.NZ_REGION){
             
            lst_aml = createAML(applicantWrapperList);
        }

        if(!lst_aml.isEmpty()){
            Integer i = 0;

            for(AML__c a: lst_aml){
                MyBudgetsAMLWrapper amlWrapper = new MyBudgetsAMLWrapper(a);
                amlValidationResults = amlWrapper.validatePreSubmitAML(true, a, applicantWrapperList.get(i));

                if(!amlValidationResults){
                    break;
                }
              //  i++;
            }
        }
        
        if(applicantValidationResults && amlValidationResults){           
            applicantWrapper.applicant.is_Primary_Applicant__c = true;
            try {
                
                //Modified by FSaliba DBHZL-188 - User for Applicant 2 should be updated as well (if exists) 
                List<User> usersToUpdate = new List<User>();               
                Map<String,User> userMap = new Map<String,User>();
                for(User u :[Select Id, FirstName, LastName, Email, Title, Profile.Name,First_Name__c,Last_Name__c,email__c
                                  From   User
                                  Where  AppId__c LIKE: '%'+this.application.Id+'%']){
                
                    if(u.Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1
                       || u.Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1){
                       
                        userMap.put('Primary',u);
                    }
                    else if(u.Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2
                            || u.Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2){
                        userMap.put('Secondary',u);
                    }
                }
                
                if(userMap.size()>0){
                    for(Applicant__c a: applicantList){
                        if(a.is_Primary_Applicant__c){
                               
                            //there should always be a primary user
                            User u = userMap.get('Primary');
                            if(a.First_Name__c != null && a.First_Name__c != ''){
                                u.First_Name__c = a.First_Name__c;
                                u.FirstName = a.First_Name__c.left(1);
                            }
                            if(a.Last_Name__c != null && a.Last_Name__c != ''){
                                u.Last_Name__c = a.Last_Name__c;
                                u.LastName = a.Last_Name__c.left(1);
                            }
                            //Fahad Akhtar: removed user email address and added a custom email address to update
                            if(a.Email_Address__c != null && a.Email_Address__c != ''){
                                //u.Email = a.Email_Address__c;
                                u.email__c =  a.Email_Address__c;
                            }
                            if(a.Date_of_Birth__c != null && a.Date_of_Birth__c != ''){
                                u.Date_of_Birth__c = a.Date_of_Birth__c;
                            }
                            if(a.Title__c != null && a.Title__c != ''){
                                u.Title = a.Title__c;
                            }
                            usersToUpdate.add(u);
                       }
                       else{
                           //check if user for applicant 2 exists
                           if(userMap.size() == 2){
                                User u = userMap.get('Secondary');
                                if(a.First_Name__c != null && a.First_Name__c != ''){
                                    u.First_Name__c = a.First_Name__c;
                                    u.FirstName = a.First_Name__c.left(1);
                                }
                                if(a.Last_Name__c != null && a.Last_Name__c != ''){
                                    u.Last_Name__c = a.Last_Name__c;
                                    u.LastName = a.Last_Name__c.left(1);
                                }
                                //Fahad Akhtar: removed application as email address will never be updated now.
                                if(a.Email_Address__c != null && a.Email_Address__c != ''){
                                    //u.Email = a.Email_Address__c;
                                    u.email__c =  a.Email_Address__c;
                                }
                                if(a.Date_of_Birth__c != null && a.Date_of_Birth__c != ''){
                                    u.Date_of_Birth__c = a.Date_of_Birth__c;
                                }
                                if(a.Title__c != null && a.Title__c != ''){
                                    u.Title = a.Title__c;
                                }
                                usersToUpdate.add(u);
                            }
                        }
                    }
                }

                if(!lst_aml.isEmpty()){
                    upsert lst_aml;
                    
                    applicantList[0].AML__c = lst_aml[0].id;
                    //DBHZL-81 -- Assign the value for sec applicant with proper AMl
                    if(applicantList.size() > 1){
                        if(lst_aml.size() > 1 && 
                           applicantList.get(0).Customer_ID_Type__c != 'NZ Birth Certificate' && 
                           applicantList.get(0).Customer_ID_Type__c != 'NZ Certificate of Citizenship'){
                            applicantList[1].AML__c = lst_aml[1].id;
                        }
                        if(lst_aml.size() > 2 && 
                           (applicantList.get(0).Customer_ID_Type__c == 'NZ Birth Certificate' || 
                            applicantList.get(0).Customer_ID_Type__c == 'NZ Certificate of Citizenship')){
                        applicantList[1].AML__c = lst_aml[2].id;
                        }
                    }
                }
                
                update applicantList;
                
                if(usersToUpdate.size()>0){
                    update usersToUpdate;
                }
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointPersonalDetailsExt_INT', 'Applicant__c', 'Class', String.valueOf(this.application.Id));    
            }
            
            SavePoint sp = Database.setSavePoint();
            
            try {
                Application__c app = retrieveApplication(this.application.id); //requery the newest application modified by a workflow
                updateAndSetApplicationOutOfSync(app);
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointPersonalDetailsExt_INT', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }
        } else {
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return applicantValidationResults;
    }
        
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        applicantValidationResults = true;
        amlValidationResults = true; //Added by Tony Xu to fix Null Pointer issue when click "Cancel"
        
        if(redirectTo == 'Save' || redirectTo == 'Next'){
            validateApplicant();
        }

        PageReference ref;
        if(applicantValidationResults && amlValidationResults){
            if(redirectTo == 'Back'){
                ref = Page.APP_LoanPurpose_INT;

                //BEGIN 13-AUG-15 BACK ISSUE - MIKE
                ref.getParameters().put('country', this.application.Brand_Country__c);
                //END 13-AUG-15 BACK ISSUE - MIKE

            } else if(redirectTo == 'Next'){
                ref = Page.APP_JointIncome_INT;
            } else if(redirectTo == 'Save' || redirectTo == 'Cancel'){
                ref = Page.APP_ApplicationMain_INT;
            }
            
            ref.getParameters().put('id', this.application.Id);
            ref.setRedirect(true);
            return ref;
        } else {
            return null;
        }
    }
}