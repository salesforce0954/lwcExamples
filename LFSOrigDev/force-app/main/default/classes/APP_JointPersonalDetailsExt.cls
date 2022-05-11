/*
 * @Description: Extension Controller for GE 'About Me' VF Page
 * @Author: Russell Cadapan
 * @Date Created: OCT-01-2013
 * @History:
   =====================================================================
        OCT-01-2013 (Russell): Created.
        OCT-10-2013 (Mike): Added variable for UI parameter and condition to redirect to Sales UI
        OCT-10-2013 (Mike): Added variable and method for Timeout redirection
        NOV-25-2013 (Mike): Updated code to latest
        DEC-03-2013 (Mike): Added EIDV
        JAN-17-2014 (Mike): Refactored to cater single and joint application
        APR-02-2014 (Mat) : Refactoring of Admin Settings custom settings 
        APR-23-2015 (Davey): Defect 1112 - AU PL regression testing. 
        Update the visibility of suburb field in previous residential address  
   =====================================================================
 */
public class APP_JointPersonalDetailsExt extends APP_CommonExt{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public personalDetailsWrapper applicantWrapper      {get;set;}
    public personalDetailsWrapper applicant2Wrapper     {get;set;}    
    public String webServer                             {get;set;}
    public String webServerWebService                   {get;set;}
    public String URLKey                                {get;set;}
    public String redirectTo                            {get;set;}
    public String buttonStyle                           {get;set;}
    transient public Boolean isCompleted                {get;set;}
    transient public Boolean isJoint                    {get;set;}
    
    //TXU for NZ DataTool
    public String NZEndPoint                            {get;set;}
    public String NZRequestKey                          {get;set;}
    
    public List<personalDetailsWrapper> applicantWrapperList = new List<personalDetailsWrapper>();
        
    public Boolean applicantValidationResults;
    public List<AML__c> amlList;
    
     public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}

    //Soft Quote Changes 2020
    public Boolean isSoftQuoteEnabled {get;set;}
    public Boolean isSoftQuoteAddress {get;set;}
    public Boolean isBrokerQuote {get;set;}
    public Boolean preResidentialReq {get;set;}
    public Boolean isSoftQuoteNZIDFlag {get;set;}
    
    //Class constructor
    public APP_JointPersonalDetailsExt(ApexPages.standardController sc){     
        super(sc);

        //Soft Quote changes 2020 For Pre-populating fields: START
        Id applicationId = (Id) ApexPages.currentPage().getParameters().get('Id');
        isSoftQuoteEnabled = SoftQuoteUtil.checkIfSoftQuoteEnabled(applicationId);
        isSoftQuoteAddress = false;
        isBrokerQuote = false;
        preResidentialReq = false;
        isSoftQuoteNZIDFlag =false;
        List<Quote__c> quoteList = new List<Quote__c>();
        if(isSoftQuoteEnabled){
                 quoteList = [SELECT First_Name__c,Title__c,Middle_Name__c,Date_Of_Birth__c,Last_Name__c,
                                    Drivers_Lic_Flag__c,Region__c,Gender__c,Broker_ID__c,Years_at_Residential_Address__c,
                                    Driver_s_Licence_Number__c,Driver_s_License_Expiry_Date__c,Driver_s_License_Version__c                                    
                                    FROM Quote__c
                                     WHERE Application__c =:  applicationId];
                                     System.debug('quoteList: '+quoteList);
                                     System.debug('applicantList: '+applicantList);
        if(quoteList.size() == 1){
            isSoftQuoteAddress = true;    
            if(quoteList[0].Broker_ID__c != null){
                isBrokerQuote = true;
            }
            if(quoteList[0].Years_at_Residential_Address__c != null && quoteList[0].Region__c=='NZ' && quoteList[0].Years_at_Residential_Address__c < 2){
                preResidentialReq = true;
            }else if(quoteList[0].Years_at_Residential_Address__c != null && quoteList[0].Region__c=='AU' && quoteList[0].Years_at_Residential_Address__c < 3){
                 preResidentialReq = true;
            }  
            //Added to Check NZ quotes has DL, expiry date and version number
            if(quoteList[0].Driver_s_Licence_Number__c != null && quoteList[0].Region__c=='NZ' && quoteList[0].Driver_s_License_Expiry_Date__c != null
                     && quoteList[0].Driver_s_License_Version__c != null){
                isSoftQuoteNZIDFlag = true;
            }
            applicantWrapperList = new List<personalDetailsWrapper>();
            personalDetailsWrapper pdw = new personalDetailsWrapper();
            for(appLicant__c a: applicantList){          
            
             pdw.applicant =a;   
             system.debug('quote DOB '+quoteList[0].Date_Of_Birth__c);
              if(String.valueOf(quoteList[0].Date_Of_Birth__c) != ''){
                        pdw.disableDOB = true;
                                         
                }
                       
             pdw.applicationCountry = quoteList[0].Region__c;
             pdw.maleSelected = 'Male';
             pdw.femaleSelected = 'Female';
             applicantWrapperList.add(pdw);
                        
              if(quoteList[0].Gender__c == 'Female'){
                    pdw.femaleSelected = 'FemaleSelected btn-activec';
                    pdw.maleSelected = 'Male';
                } else if(quoteList[0].Gender__c == 'Male'){
                    pdw.maleSelected = 'MaleSelected btn-activec';
                    pdw.femaleSelected = 'Female';
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

              if(quoteList[0].Drivers_Lic_Flag__c == true){
                    pdw.disableDrvcAst = 'hidden';
                }
               checkDriversLicense();
               
            }
            
          applicantWrapper = pdw;
         }
    
       
        System.debug('check the applicant wrapper'+applicantWrapper );
    }
        //Soft Quote changes 2020: END

        
        webServer = Datatools__c.getValues('Datatools').Endpoint__c;
        webServerWebService = Datatools__c.getValues('Datatools').Endpoint_json_ws__c;
        
        NZEndPoint = Datatools__c.getValues('Datatools').NZ_Endpoint__c;
        NZRequestKey = Datatools__c.getValues('Datatools').NZ_Request_Key__c;

        //Retrieve URL Key from Brand (only used for Customer UI)
        Brand__c brand = [SELECT Name,Country__c, URL_Key__c FROM Brand__c WHERE Id =: application.Brand_Lookup__c LIMIT 1];
        URLKey = brand.URL_Key__c;
        if(brand.Name == GEN_OriginationsConstants.BRAND_NAME_AUSSIE){            
            buttonStyle = 'btn-activec';
        } else {
            buttonStyle = 'btn-normalc';
        }
        isCompleted = false;
        


        if(!applicantList.isEmpty()){
            applicantWrapperList = new List<personalDetailsWrapper>();
            
            for(Applicant__c a: this.applicantList){
                personalDetailsWrapper pdw = new personalDetailsWrapper();
                pdw.applicant = a;
                pdw.applicationCountry = brand.Country__c;//populating new attribute added to personaldetailswrapper class 
                pdw.maleSelected = 'Male';
                pdw.femaleSelected = 'Female';
                applicantWrapperList.add(pdw);
            }
            
            for(personalDetailsWrapper pdw: applicantWrapperList){
                //Set default values for Applicant/s                
                if(pdw.applicant.Gender__c == 'Female'){
                    pdw.femaleSelected = 'FemaleSelected btn-activec';
                    pdw.maleSelected = 'Male';
                } else if(pdw.applicant.Gender__c == 'Male'){
                    pdw.maleSelected = 'MaleSelected btn-activec';
                    pdw.femaleSelected = 'Female';
                }

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
                
               
                if(pdw.applicant.Email_Address__c != null  ){
                    //if soft quote application then set disableEmail to false else true. Ticket Number: LM-2084
                   /* if(quoteList.size() == 1){
                        pdw.disableEmail = false;
                    }else{
                    	pdw.disableEmail = true;    
                    }*/
                    pdw.disableEmail = true;
                    
                } else {
                    pdw.disableEmail = false;
                }
                
                               
                pdw.PostalFlag = null;
                
                if(pdw.applicant.First_Name__c != null && pdw.applicant.last_Name__c != null && pdw.applicant.Email_Address__c != null ){
                    pdw.PostalFlag = 'Yes';
                    if(pdw.applicant.Postal_Addr_Flg__c == true){
                        pdw.PostalFlag = 'No';
                    }
                }
            }
            
            checkDriversLicense();
            
            applicantWrapper = applicantWrapperList.get(0);
            isCompleted = false;
            if(applicantList[0].First_Name__c != null && applicantList[0].last_Name__c != null){
                isCompleted = true;

            }
            if(applicantList.size()>1){
                applicant2Wrapper = applicantWrapperList.get(1);
                applicant2Wrapper.NoOfDeps = String.valueOf(applicantWrapperList.get(1).applicant.No_Of_Deps__c);
                isCompleted = false;
                if(applicantList[1].First_Name__c != null && applicantList[1].last_Name__c != null){
                    isCompleted = true;
                }
            }
            isJoint = isJoint();
        }
        initializeLoanPurposes();
        
        // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
        isBSOfferActive = false;
        isBSOfferNZActive = false;
        bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        System.debug('isBSOfferActive' +isBSOfferActive);
        isBSOfferNZActive = bsoffer.BetterStartNZActive__c;   
        //End
    }
    
    /*  Description: Timeout getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getTimeOut(){
      return AS_TIMEOUT;
    }
    
    /*  Description: Warning getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getWarning(){
      return AS_WARNING;
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
        
        this.applicantList.clear();

        for(personalDetailsWrapper pdw: applicantWrapperList){
            
            this.applicantList.add(pdw.applicant);
            system.debug('$$$: '+pdw.applicant.Country_Res__c);
            System.debug('!@#pdw: ' + pdw);
            if(pdw.applicationCountry == GEN_OriginationsConstants.AU_REGION){
                pdw.applicant.Country_Res__c = 'Australia';
                pdw.applicant.Country_Pos__c = 'Australia';
                if((((pdw.applicant.Years_At_Addr__c != null && pdw.applicant.Years_At_Addr__c != '') && Integer.valueOf(pdw.applicant.Years_At_Addr__c) < 3)) || (pdw.applicant.Years_At_Addr__c == '' && pdw.applicant.Months_At_Addr__c != '')){
                    pdw.applicant.Country_Pre__c = 'Australia';
                }
                
            }
            else{
                pdw.applicant.Country_Res__c = 'New Zealand';
                pdw.applicant.Country_Pos__c = 'New Zealand';
                if((((pdw.applicant.Years_At_Addr__c != null && pdw.applicant.Years_At_Addr__c != '') && Integer.valueOf(pdw.applicant.Years_At_Addr__c) < 2)) || (pdw.applicant.Years_At_Addr__c == '' && pdw.applicant.Months_At_Addr__c != '') ){
                    pdw.applicant.Country_Pre__c = 'New Zealand';
                }
            }
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

        if(applicantValidationResults){
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
                if(applicantWrapperList[1].issueYear != null&& applicantWrapperList[1].issueDate != 'Select' &&
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

            if(brand.country__c == GEN_OriginationsConstants.NZ_REGION){
                amlList = createAML(applicantWrapperList);
            }

            if(!amlList.isEmpty()){
                Integer i = 0;
                for(AML__c a: amlList){
                    MyBudgetsAMLWrapper amlWrapper = new MyBudgetsAMLWrapper(a);
                    applicantValidationResults = amlWrapper.validatePreSubmitAML(false, a, applicantWrapperList.get(i));

                    if(!applicantValidationResults){
                        break;
                    }
                    
                    if(a.Identification__c != GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_BIRTH_CERTIFICATE && 
                       a.Identification__c != GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_CERTIFICATE_OF_CITIZENSHIP){
                    i++;
                    }
                }
            }
        }

        if(applicantValidationResults){
            applicantWrapper.applicant.is_Primary_Applicant__c = true;
        } else {
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return applicantValidationResults;
    }

    /*  Description: Redirect to APP_Register page
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference register(){

        PageReference pageRef = Page.APP_Register;
        pageRef.getParameters().put('Id',this.application.Id);
        pageRef.setRedirect(true);

        return pageRef;

    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }

    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-17-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        // Check application status before any updates and redirect
        List<Application__c>applicationVar = [Select Id, Status__c from Application__c where Id = :application.Id];
        
        // Validate that application is not yet submitted
        if(applicationVar.size()>0){
            if(applicationIsSubmitted(applicationVar[0])){
                Util.addMessage(ApexPages.Severity.ERROR, 'Sorry this application has already been submitted and the application details are not editable.');
                return null;
            }
        }

        amlList = new List<AML__c>();

        applicantValidationResults = true;
        if(redirectTo == 'Save'){
            validateApplicant();
        }else if(redirectTo == 'Timeout'){
            this.loanValidationResults = true;
        }
        
        PageReference ref;
        system.debug('validate applicant results: '+applicantValidationResults+' ,'+this.loanValidationResults);

        if(applicantValidationResults && this.loanValidationResults){
            try {
                
                if(!amlList.isEmpty()){
                    upsert amlList;

                    applicantList[0].AML__c = amlList[0].id;
                    
                    if(applicantList.size() > 1){
                        if(amlList.size() > 1 && 
                           applicantList.get(0).Customer_ID_Type__c != 'NZ Birth Certificate' && 
                           applicantList.get(0).Customer_ID_Type__c != 'NZ Certificate of Citizenship'){
                        applicantList[1].AML__c = amlList[1].id;
                        }
                        if(amlList.size() > 2 && 
                           (applicantList.get(0).Customer_ID_Type__c == 'NZ Birth Certificate' || 
                            applicantList.get(0).Customer_ID_Type__c == 'NZ Certificate of Citizenship')){
                            applicantList[1].AML__c = amlList[2].id;
                        }
                    }
                }

                update applicantList;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointPersonalDetailsExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));    
            }
            
            SavePoint sp = Database.setSavePoint();
            
            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointPersonalDetailsExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }

            if(redirectTo == 'Save'){
                UserUtility userUtility = new UserUtility();
                ref = userUtility.createCommunityUser(this.application, applicantWrapper.applicant);
                
            } else if(redirectTo == 'Timeout'){
                ref = Page.APP_Timeout;
            }          
            
            ref.setRedirect(true);
            return ref;
        } else {
            return null;
        }
    }

    /* Description: Method to call the class that handles the delete of Applicant 2.
     *  Author: Fel Saliba
     *  Date Created: JAN-30-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference deleteApplicant(){        
        IS_ApplicationDTO applicationDTO  = new IS_ApplicationDTO();
        applicationDTO.app = this.application;
        applicationDTO.applicant = applicant;
        applicationDTO.applicant2 = applicant2;
        
        APP_RemoveSecondApplicant removeApplicant = new APP_RemoveSecondApplicant();
        removeApplicant.deleteApplicantRecord(applicationDTO);      

        PageReference ref;
        ref = Page.APP_JointPersonalDetails;
        ref.getParameters().put('id', String.valueOf(this.application.Id));
        ref.setRedirect(true);
        return ref;                   
    }

    private String quoteId = '';

    public void setQuoteId(String qId) {
        System.debug('QID IN APEX: '+qId);
        quoteId = qId;
    }
            
    public String getQuoteId() {
        System.debug('QID IN GET APEX: '+quoteId);
        return quoteId;
    }

    public PageReference methodOne() {
        return null;
    }
}