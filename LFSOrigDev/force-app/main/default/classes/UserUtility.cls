/*
 * @Description: User utility apex class
 * @Author: Jade Serrano
 * @Date Created: 17-MAR-2014
 * @History:
 *  =====================================================================
 *      Jade - 17-MAR-2014: Created
 *      Adrian - 20-MAR-2014: Added pageName, nextPage and getUserRedirectURL methods.
 *                            Updated createCommunity
 *  =====================================================================
 */
public without sharing class UserUtility {
    
    // veda URL parameter - Added By RCADAPAN for TQLQW-489
    public static String appVedaEmail;
    
    //from app_register "Save Application"
    public String registerPassword{get;set;}
    public String registerEmail{get;set;}
    public String registerDateOfBirth{get;set;}
    
    String applicationId;
    String brand;
    String password;    
    
    String existingUserId;
    String existingUsername;
    
    // Added by RCADAPAN for TQLQW-489
    // New controller constructor that will accept parameters to set static variables within the class
    public UserUtility( String vedaEmail) {
        appVedaEmail = vedaEmail;
    }
    
    public UserUtility() {
        
    }

    public PageReference createCommunityUser(Application__c application, Applicant__c applicant){

        Savepoint sp;
        PageReference ref;
        User u = new User();

        try{
            
            //generate temporary random password
            password = generateRandomPassword();
            
            //check if password is from app_register/"Ssve Application"
            if(registerPassword!=null){
                password = registerPassword;
            }

            if(UserInfo.getUserType()=='Guest'){//unauthenticated

                if(application!=null && applicant!=null){

                    applicationId = String.valueOf(application.Id);
                    brand = application.Brand_String__c;
                    
                    //populate user fields
                    //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                    u.Username = applicationId+''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;
                    u.CommunityNickname = 'cus' + applicationId;
                    u.AppId__c = applicationId;
                    u.Password_Reset_Attempts__c = 0;
                    u.Valid_Password_Reset_Timestamp__c =  datetime.now();
                    u.Password_Reset_Timestamp__c =  datetime.now();                    
                    
                    if(brand!=null){
                        u.Brand__c = brand;
                    }

                    if(applicant.Email_Address__c!=null){
                        u.Email = applicationId+''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX; // June-07-2016- Afreen- Put the dummy email address to make createPersonAccountPortalUser() work;
                        u.email__c = applicant.Email_Address__c;
                    }else{
                        //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                        u.Email = applicationId+''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;
                    }
                    if(applicant.First_Name__c!=null){
                        u.FirstName = (applicant.First_Name__c).left(1);
                        u.First_Name__c = applicant.First_Name__c;
                    }else{
                        u.FirstName = applicationId;
                    }
                    if(applicant.Last_Name__c!=null){
                        u.LastName = (applicant.Last_Name__c).left(1);
                        u.Last_Name__c = applicant.Last_Name__c;
                    }else{
                        u.LastName = applicationId;
                    }
                    if(applicant.Date_of_Birth__c!=null){
                        u.Date_Of_Birth__c = applicant.Date_of_Birth__c;
                    }else{
                        u.Date_Of_Birth__c = '00-00-00';
                    }
                    if(applicant.Title__c != null){
                        u.Title = applicant.Title__c;
                    }
                    
                    //create save point for rollback
                    sp = Database.setSavepoint();

                    //check if the the email has an existing user
                    if(!hasExistingUser(applicant)){

                        system.debug('User Val:' + u );
                        system.debug('Admin Id Val:' + String.valueOf(Site.getAdminId()) );
                        system.debug('Password Val:' + password );

                        //create user and related person account
                        Id userId;
                        try{
                            userId = Site.createPersonAccountPortalUser(u, String.valueOf(Site.getAdminId()), password);
                            System.debug('deb2: '+userId);
                        }catch (exception e){
                            system.debug('User Val:' + e.getMessage() );
                        } 

                        System.debug('!@#userId: '+userId);
                        //check if user is created
                        if(userId!=null || Test.isRunningTest()){

                            //update AppId__c of the created user
                            updateAppId(userId, applicationId, brand);

                            //populate Application__c.Applicant1__c with the created person account related to the created user
                            User user = [SELECT contactId FROM User WHERE Id =: userId];
                            Id accountId = [SELECT id FROM Account WHERE PersonContactId =: User.contactId].Id;
                            Contact contact = [SELECT Title FROM Contact WHERE Id =: User.contactId];

                            contact.Salutation = u.Title;

                            application.Applicant1__c = accountId;
                            application.OwnerId = userId;

                            update application;

                            //relate the Applicant__c.Account the created person account
                            applicant.Account__c = accountId;

                            update applicant;

                        }

                        //login the created user on the background
                        //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                        ref = Site.login(applicationId+''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX, password, getUserRedirectURL(application.Id));
                        System.debug('!@#ref1: '+ref);

                    }else{

                        //check if the the email has an existing user
                        if(existingUserId!=null){

                            application.OwnerId = existingUserId;
                            update application;

                            ref = Site.login(existingUsername, password, getUserRedirectURL(application.Id));
                            System.debug('!@#ref2: '+ref);

                        }

                        

                    }                   
                    
                }
                
            }else{//authenticated

                if(application!=null && applicant!=null){

                    //update user fields if the applicant is updated
                    if(applicant.First_Name__c != null && applicant.Last_Name__c != null && applicant.Email_Address__c != null && applicant.Date_of_Birth__c != null && applicant.Title__c != null){
                        updateUserFromApplicant(applicant);
                    }
                    
                    //update the applicant field from app_register/"Save Application"
                    if(registerPassword != null){

                        updateApplicantFromRegister(applicant);
                        setPassword(UserInfo.getUserId(), registerPassword, registerEmail, registerDateOfBirth);

                    }

                    ref = nextPage(application.Id);
                    System.debug('!@#ref3: '+ref);
                    ref.setRedirect(true);

                }

            }

            return ref;

        }catch(Exception e){

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'createCommunityUser()', 'UserUtility', 'Class', String.valueOf(application.Id));
            
            if(sp!=null) {
                Database.rollback(sp);
            }

            return null;

        }

    }

    //generate random password
    public String generateRandomPassword(){

        Integer length = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String password = key.substring(0,length);

        return password;

    }

    //check for existing user based from email address
    public Boolean hasExistingUser(Applicant__c applicant){
        Savepoint sp;

        Boolean hasExistingUser = true;
        List<User> user = new List<User>();

        //Create a SOSL call to check for email address
        List<Applicant__c> lst_Applicant = new List<Applicant__c>();
        Set<String> set_emailAddres = new Set<String>();
        Set<Id> usrAccountSet = new Set<Id>();
        
        if(applicant!=null){ // Added by adrian recion: applicant email and last name check 25/8/2016
            if(applicant.Email_Address__c!=null && applicant.Last_Name__c!=null){
                String searchQuery = 'FIND \'' + applicant.Email_Address__c + 
                                     '\' IN EMAIL FIELDS RETURNING Applicant__c(Account__c, Application__c,Email_Address__c,Is_Primary_Applicant__c)';
                List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
                System.debug('Deb1: '+String.valueOf(ListOfListOfSObjects));
                lst_Applicant = ((List<Applicant__c>)ListOfListOfSObjects[0]);
                
                for(Integer i=0; i<lst_Applicant.size(); i++){
                    if(applicant.Account__c == lst_Applicant[i].Account__c){
                        if(lst_Applicant[i].Is_Primary_Applicant__c){
                            set_emailAddres.add(lst_Applicant[i].Application__c +'@ge.com'); 
                        }else{
                            set_emailAddres.add(lst_Applicant[i].Application__c +'_applicant2'+'@ge.com');  
                        }
                        usrAccountSet.add(lst_Applicant[i].Account__c);
                    }
                }
                
                system.debug('User Create Email Match:' + set_emailAddres);
                system.debug('User Create Account Match:' + usrAccountSet);

                user = [SELECT Id,
                              Username,
                              AppId__c,
                              Brand__c,
                              Email,
                              FirstName,
                              LastName,
                              Date_Of_Birth__c,
                              Title,
                              First_Name__c,
                              Last_Name__c,
                              email__c
                      FROM    User
                      WHERE   Email =: set_emailAddres
                      AND     AccountId IN :usrAccountSet 
                      AND     IsActive = true LIMIT 1];
            }
        }

        if(!user.isEmpty()){

            System.setPassword(user.get(0).Id, password);
            existingUserId = user.get(0).Id;
            existingUsername = user.get(0).Username;
            user.get(0).AppId__c = applicationId;
            user.get(0).Brand__c = brand;
            user.get(0).First_Name__c = applicant.First_Name__c;
            user.get(0).Last_Name__c = applicant.Last_Name__c;
            user.get(0).email__c = applicant.Email_Address__c;
            user.get(0).Email = applicant.Is_Primary_Applicant__c?applicant.Application__c+'@ge.com':applicant.Application__c+'_applicant2'+'@ge.com';
            if(applicant.First_Name__c!=null){ // Null Check adedd by Adrian Recio - 24/8/2016
                user.get(0).FirstName = (applicant.First_Name__c).left(1);
            }
            if(applicant.Last_Name__c!=null){ // Null Check adedd by Adrian Recio - 24/8/2016
                user.get(0).LastName = (applicant.Last_Name__c).left(1);
            }
            user.get(0).Date_Of_Birth__c = applicant.Date_of_Birth__c;
            user.get(0).Title = applicant.Title__c;

            try{
                update user;
            }catch(Exception e){

                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'hasExistingUser()', 'UserUtility', 'Class' , String.valueOf(applicationId));

                if(sp!=null) {
                    Database.rollback(sp);
                }
            }

        }else{
            hasExistingUser = false;
        }

        return hasExistingUser;
    }

    //update applicant from register fields
    public void updateApplicantFromRegister(Applicant__c applicant){

        Savepoint sp = Database.setSavepoint();

        try{            

            Boolean updateApplicantFromRegister = false;

            if(applicant!=null){

                if(registerEmail!=null){

                    applicant.Email_Address__c = registerEmail;
                    updateApplicantFromRegister = true;

                }
                if(registerDateOfBirth!=null){

                    applicant.Date_of_Birth__c = registerDateOfBirth;
                    updateApplicantFromRegister = true;

                }
                if(updateApplicantFromRegister){
                    update applicant;
                }

            }

        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'updateApplicantFromRegister()', 'UserUtility', 'Class' , applicant.Application__c);

        }

    }

    //update user from applicant fields
    public void updateUserFromApplicant(Applicant__c applicant){

        Savepoint sp = Database.setSavepoint();

        try{

            Boolean updateUserFromApplicant = false;

            List<User> user = [SELECT Id,
                                      Email,
                                      FirstName,
                                      LastName,
                                      Date_Of_Birth__c,
                                      Title
                               FROM   User
                               WHERE  Id =: UserInfo.getUserId()
                               AND    IsActive = true LIMIT 1];

            if(!user.isEmpty()){

                if(applicant!=null){

                    if(applicant.First_Name__c!=null && applicant.Last_Name__c!=null && applicant.Email_Address__c!=null && applicant.Date_of_Birth__c!=null){
                        
                        user.get(0).Email = applicant.Is_Primary_Applicant__c?applicant.Application__c+'@ge.com':applicant.Application__c+'_applicant2'+'@ge.com';
                        if(applicant.First_Name__c!=null){ // Null Check adedd by Adrian Recio - 24/8/2016
                            user.get(0).FirstName = (applicant.First_Name__c).left(1);
                        }
                        if(applicant.Last_Name__c!=null){ // Null Check adedd by Adrian Recio - 24/8/2016
                            user.get(0).LastName = (applicant.Last_Name__c).left(1);
                        }
                        user.get(0).Date_Of_Birth__c = applicant.Date_of_Birth__c;
                        user.get(0).First_Name__c = applicant.First_Name__c;
                        user.get(0).Last_Name__c = applicant.Last_Name__c;
                        user.get(0).Email__c = applicant.Email_Address__c;
                        user.get(0).Title = applicant.Title__c;

                        System.debug('!@#user.get(0): '+user.get(0));
                        update user;

                    }

                }

            }

        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'updateUserFromApplicant()', 'UserUtility', 'Class' , applicant.Application__c);

        }

    }
    
    /*  Description: Method to determine url redirect for site user
     *  Author: Adrian Recio
     *  Date Created: 21/3/2014
     *  Input Parameters: Id
     *  Return: string
     */
    public String getUserRedirectURL(Id appId){
        
        pageReference conditionalPageRef = UserUtility.nextPage(appId);
        string redirectURL;
        
        if(conditionalPageRef == null){
            redirectURL = '/APP_Main?id=' + appId;
        }else{
            redirectURL = conditionalPageRef.getUrl().remove('/apex');
        }
        
        System.debug('login redirect url:' + redirectURL);
        
        return redirectURL;

    }
    
    /*  Description: Method to determine next page on the application process based on current page.
     *  Author: Adrian Recio
     *  Date Created: 20/3/2014
     *  Input Parameters: Id
     *  Return: Pagereference
     */
    public static PageReference nextPage(Id applicationId){

        string pageName = '';
        pageReference pgRef = null;
        Boolean validateMain = UserUtility.checkApplicationStatus(applicationId);
        
        System.debug('Main Boolean:' + validateMain);
        
        if(UserUtility.pageName()!=null){
            pageName = UserUtility.pageName().toLowerCase();
        }
        
        // *** Vf pages for each application process ***
        // personal details - app_jointpersonaldeails
        // income - app_jointincome
        // expenses - app_jointexpenses
        // assets - app_jointassets
        // debts - app_jointdebtandliabilities
        
        // *** Flow of page redirect ***
        // if personal details redirect to income
        // if income redirect to expenses
        // if expenses redirect to assets
        // if assets redirect to debts
        // if debts redirect to app main
        
        System.debug('Page Name:' + pageName);
        System.debug('!@#pgRef: '+pgRef);
        
        if(validateMain == true){
            pgRef = Page.app_main;
        }else if(pageName == 'app_register'){
            pgRef = Page.app_main;
        }else if(pageName == 'app_jointpersonaldetails'){
            pgRef = Page.app_jointincome;
        }else if(pageName == 'app_jointincome'){
            pgRef = Page.app_jointexpenses;
        }else if(pageName == 'app_jointexpenses'){
            pgRef = Page.app_jointassets;
        }else if(pageName == 'app_jointassets'){
            pgRef = Page.app_jointdebtandliabilities;
        }else if(pageName == 'app_jointdebtandliabilities'){
            pgRef = Page.app_main;
        }else if(pageName == 'app_eligibility'){
            pgRef = Page.app_jointpersonaldetails;
        }
        
        //Jun-02-2016 Added for society one - Afreen
        // 08-02-2016 Modified by Russell to redirect the user to submitwait page after the submit call out 
        if(validateMain == true && pageName == 'app_societyone_wait'){
            pgRef = Page.app_submitwait;
            pgRef.getParameters().put('Id',applicationId);
            
          
        }
        
        System.debug('!@#pgRef: '+pgRef);
        Application__c app= [select Product_SubType__c from Application__c where Id =: applicationId] ;        
        // Put application parameter if pagereference is not null
        if(pgRef!=null){
            pgRef.setRedirect(true);            
            pgRef.getParameters().put('Id',applicationId);
            System.debug('UU FORM VALUE '+ApexPages.currentPage().getParameters().get('form'));
            System.debug('BSL FORM VALUE '+app.Product_SubType__c);
            if(app.Product_SubType__c == 'Better Start PL'){
                
            pgRef.getParameters().put('subType','betterStart');}
            /*if(ApexPages.currentPage().getParameters().get('form') == 'broker'){
            pgRef.getParameters().put('form','broker');
            }*/
            // Added by RCADAPAN for TQLQW-489 - pass the veda address parameter as part of the personal details page URL
            if(appVedaEmail != null){
                pgRef.getParameters().put('email',appVedaEmail); 
            }
        }else{
            System.debug('Page not valid in flow.');
        }
        
        

        return pgRef;

    }
    
    /*  Description: pull current page name
     *  Author: Adrian Recio
     *  Date Created: 20/3/2014
     *  Input Parameters: None
     *  Return: string 
     */
    public static String pageName(){

        String pageName = ApexPages.currentPage().getUrl();
        System.debug('url:' + pageName);
        if(pageName!=null){
            
            List<string> pageNameList = pageName.trim().split('apex/');
            if(pageNameList.size()>0){
                System.debug('init concat 1:' + pageNameList[1]);
                List<string> pageNameParamSplit = pageNameList[1].split('\\?');
                if(pageNameParamSplit.size()>0){
                    System.debug('index 1' + pageNameParamSplit[0]);
                    pageName = pageNameParamSplit[0];
                }
            }
        }
        
        System.debug('pageName method:' + pageName);
        return pageName;

    }
    /*  Description: Search applicant object for encrypted email address field and return set of emails
     *  Author: Fahad Akhtar
     *  Date Created: 3/3/2016
     *  Input Parameters: email Address
     *  Return: Set<String)
     */
    public static set<String> searchEmailAddresses(String email){
        
        //Create a SOSL call to check for email address
        List<Applicant__c> lst_Applicant = new List<Applicant__c>();
        Set<String> set_emailAddres = new Set<String>();
        String searchQuery = 'FIND \'' + email + '\' IN EMAIL FIELDS RETURNING Applicant__c(Application__c,Email_Address__c,Is_Primary_Applicant__c)';
        List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
        lst_Applicant = ((List<Applicant__c>)ListOfListOfSObjects[0]);
        
        for(Integer i=0; i<lst_Applicant.size(); i++){
            if(lst_Applicant[i].Is_Primary_Applicant__c){
                set_emailAddres.add(lst_Applicant[i].Application__c +'@ge.com');                
            }else{
                set_emailAddres.add(lst_Applicant[i].Application__c +'_applicant2'+'@ge.com');              
            }
        }
        return set_emailAddres;         
    }   
    /*  Description: Method to check if application steps is complete
     *  Author: Adrian Recio
     *  Date Created: 24/3/2014
     *  Input Parameters: None
     *  Return: string
     */
    public static Boolean checkApplicationStatus(Id applicationId){
        // Pull applicant details
        List<Applicant__c> applicantList = APP_CommonVariables.retrieveApplicants(applicationId);
        personalDetailsWrapper pDWrapCls = new personalDetailsWrapper();
       
        Boolean redirectToAppMain = false;
       
        if(applicantList.size()!=0){
            
            // Instantiate main variables
            List<Income__c>     incomeList   = applicantList.get(0).Incomes__r;
            List<Asset__c>      assetList    = applicantList.get(0).Assets__r;
            List<Expense__c>    expenseList  = applicantList.get(0).Expenses__r;
            List<Liability__c>  debtList     = applicantList.get(0).Liabilities__r;
            Boolean personalDetailComplete1 = false;
            Boolean incomeComplete1 = false;
            Boolean incomeComplete2 = false;
            Boolean assetComplete1 = false;
            Boolean debtComplete1 = false;

            // Verify that the minimum required field is filled up in applicant
            if(applicantList.get(0).First_Name__c!=null && 
               applicantList.get(0).Last_Name__c!=null){
                personalDetailComplete1 = true;
            }
            
            //Added to backlog 06/23 mlasala
            //if(applicantList.get(0).Income_Exempt__c == true)
            //  incomeComplete1 = true;
            //else 
            if(incomeList.size()>0){
                incomeComplete1 = true;
            }

            // Verify that asset condition is satisfied (applicant is exempted or at least 1 asset is created)
            if(applicantList.get(0).Asset_Exempt__c == true){
                assetComplete1 = true;
            }else if(assetList.size()>0){
                assetComplete1 = true;
            }
            
            // Verify that debt condition is satisfied (applicant is exempted or at least 1 debt is created)
            if(applicantList.get(0).Debts_Exempt__c == true){
                debtComplete1 = true;
            //else if(debtList.size()>0 && debtList[0].Total_Debts__c!=0)
            }else if(debtList.size() > 0 && (debtList.get(0).Financier_Name__c != null || debtList.get(0).Financier_List__c != null)){
                if(applicantList.get(0).Total_Debts__c!=0){
                    debtComplete1 = true;
                } else {
                    for(Liability__c d: debtList){
                        if(d.Acknowledge_Payout__c){
                            debtComplete1 = true;
                        }
                    }
                }
            }

            System.debug('!@#debtList: '+debtList);

            System.debug('income count:' + incomeList.size());
            System.debug('expense count:' + expenseList.size());
            
            System.debug('personal details complete:' + personalDetailComplete1);
            System.debug('asset complete:' + assetComplete1);
            System.debug('debt complete:' + debtComplete1);
            

            // check that all required values for applicant is complete
            if(incomeComplete1 && expenseList.size()>0 && personalDetailComplete1 && assetComplete1 && debtComplete1){
               
                // check that applicant 2 has at least 1 income and expense
                if(applicantList.size()>1){
                    List<Income__c>     incomeList2   = applicantList.get(1).Incomes__r;
                    List<Expense__c>    expenseList2  = applicantList.get(1).Expenses__r;
                    Boolean personalDetailComplete2 = false;
            
                    if(applicantList.get(1).First_Name__c!=null && 
                       applicantList.get(1).Last_Name__c!=null){
                        personalDetailComplete2 = true;
                    }

                    //Added to backlog 06/23 mlasala
                    //if(applicantList.get(1).Income_Exempt__c == true)
                    //  incomeComplete2 = true;
                    //else 
                    if(incomeList2.size()>0){
                        incomeComplete2 = true;
                    }

                    if(incomeComplete2 && expenseList2.size()>0 && personalDetailComplete2 ){
                        redirectToAppMain = true;
                    }
                }else{
                    redirectToAppMain = true;
                }
            }
        }
        
        System.debug('Redirect App Main:' + redirectToAppMain);
        return redirectToAppMain;
    }

    //set password(save application)
    //send email(save application)
    @future
    public static void setPassword(String userId, String password, String email, String dob){

        Savepoint sp = Database.setSavepoint();
        String applicationId;
        
        try{

            List<User> user = [SELECT IsRegistered__c, 
                                      Email, 
                                      Date_Of_Birth__c, 
                                      AppId__c, 
                                      Brand__c,
                                      ContactId 
                               FROM   User 
                               WHERE  Id =: userId LIMIT 1];            

            user.get(0).IsRegistered__c = true;
            //user.get(0).Email = email;
            user.get(0).Date_Of_Birth__c = dob;

            applicationId = user.get(0).AppId__c;

            //p - start
            //query org wide email address
            //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: user.get(0).Brand__c LIMIT 1];

            //quey brand specific template
            //List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Customer__c FROM Brand__c WHERE Name =: user.get(0).Brand__c LIMIT 1];

            List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Customer__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: user.get(0).Brand__c LIMIT 1];

            string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

            if(sDsiplayName == null || sDsiplayName == '' ) {
                sDsiplayName = user.get(0).Brand__c;
            }

            List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];


            //p - end

            //query the actual template
            EmailTemplate savedApplicationTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Save_Retrieve_Customer__c LIMIT 1];         

            //update user information
            update user;

            //change password of user
            System.setPassword(userId, password);

            //construct the email and send
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            mail.setTargetObjectId(user.get(0).ContactId);
            mail.setTemplateId(savedApplicationTemplate.Id);
            mail.setSaveAsActivity(false);
            mail.setWhatId(brandTemplate.get(0).Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setPassword()', 'UserUtility', 'Class' , applicationId);

        }

    }

    //update AppId of user from applicationId
    //update Brand of user from application brand
    @future
    public static void updateAppId(String userId, String applicationId, String brand){

        Savepoint sp = Database.setSavepoint();

        try{            

            User user = [SELECT Id, AppId__c FROM User WHERE Id =: userId];
            user.AppId__c = applicationId;
            user.Brand__c = brand;

            update user;

        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'updateAppId()', 'UserUtility', 'Class' , applicationId);

        }

    }

}