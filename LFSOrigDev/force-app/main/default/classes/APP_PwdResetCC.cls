public with sharing class APP_PwdResetCC{


    public String emailAddress      {get;set;}
    public String birthDate         {get;set;}
    public String birthMonth        {get;set;}
    public String birthYear         {get;set;}
    public String dob               {get;set;}
    public String statusMessage     {get;set;}
    
    public Boolean fieldState       {get;set;}
    public Boolean customer         {get;set;}
    
    User currentUser;

    @TestVisible String siteName = Site.getName();

    Id customerProfileId;

    public APP_PwdResetCC(){

        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: profileId].Name;
        System.debug('!@#profileName: '+profileName);

        if(profileName == 'B1 Customer Community Login' || profileName == 'B1 Applicant 2 Customer Community Login' || profileName == 'A1 Customer Community Login' || profileName == 'A1 Applicant 2 Customer Community Login'){ 
            customer = true;
        }else if(profileName == 'System Administrator'){
            customer = true;
        }else{
            customer = false;
        }
        
        statusMessage = 'Please check your email for further instructions';

    }

    //reset password button
    public void resetPassword(){

        //validation
        System.debug('!@#validation(): '+validation());
        if(validation()){
            system.debug('$$$: '+emailAddress);
            Savepoint sp = Database.setSavepoint();

            try{
                
                /**Added by Tony Xu to allow password reset for both AU and NZ sites START**/
                List<Profile> profileList = [SELECT Id, Name
                                             FROM Profile 
                                             WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1
                                             OR Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2
                                             OR Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1
                                             OR Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2];
                                             
                Map<String, ID> profileMap = new Map<String, ID>();
                        
                for(Profile p : profileList){
                    profileMap.put(p.Name, p.ID);
                }    
                
                /**END**/
                
                List<Brand__c> currentBrand = [SELECT Id,
                                                     Name
                                              FROM   Brand__c
                                              WHERE  Site__c =: siteName];
                
                List<User> userList = new List<User>();
                Boolean passResetExceed = false;
                // Throw error if no matching brand for current site
                if(currentBrand.isEmpty()){
                	Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.BRAND_NULL_SITE);
                    fieldState = true;
                // Query user if brand is properly connected to site
                }else{
                    userList = [SELECT Id,
                                Email,
                                Date_of_Birth__c,
                                ProfileId,
                                PRS_RECORD_ID__c,
                                UserName,
                                Brand__c,
                                ContactId,
                                Password_Reset_DOB__c,
                                Password_Reset_Timestamp__c,
                                Valid_Password_Reset_Timestamp__c,
                                Password_Reset_Attempts__c
                                FROM   User
                                WHERE  Email =: UserUtility.searchEmailAddresses(emailAddress)
                                AND    IsActive = true
                                AND    (Brand__c = :currentBrand.get(0).Name OR Brand__c = null)
                                AND    (ProfileId =: siteName == GEN_OriginationsConstants.GEMONEY_AU_SITENAME || 
                                        siteNAme == GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME ? 
                                        profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1) : 
                                        profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1) 
                                        OR
                                        ProfileId =: siteName == GEN_OriginationsConstants.GEMONEY_AU_SITENAME || 
                                        siteNAme == GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME ? 
                                        profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2) : 
                                        profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2)) 
                                		ORDER BY CreatedDate DESC];
                }
                
                System.debug('###emailAddress: '+emailAddress);
                System.debug('###dob: '+dob);
                System.debug('###customerProfileId: '+customerProfileId);
                System.debug('!@#currentBrand: '+currentBrand);
                
                if(userList.isEmpty()){
                    Util.addMessage(ApexPages.Severity.Error, 'User does not exist');
                    fieldState = true;
                }else{ 
                    
                    // Filter by DOB here as can not do in SOQL due to encrypted field
                    User matchedUser;
                   	User nullMatchUser;
                    for(User u : userList){
                        if(u.Date_of_Birth__c != null && u.Date_of_Birth__c.equals(dob) && u.Brand__c == null){
                            nullMatchUser = u;
                        }else if(u.Date_of_Birth__c != null && u.Date_of_Birth__c.equals(dob) && u.Brand__c != null){
                            matchedUser = u;
                            break;
                        }
                    }
                    system.debug('Matched User:' + matchedUser);
                    system.debug('Matched Null User:' + nullMatchUser);
                    
                    // Condition for matching users with null brand assignment
                    // If there is a match and no matching user with brand throw error
                    if(nullMatchUser!=null && matchedUser==null){
                        Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.USER_NULL_BRAND);
                        fieldState = true;
                    }else if(matchedUser != null){//valid
                        currentUser = matchedUser;
                        //check if user is locked
                        Boolean locked = updateUser(currentUser, true);
                        System.debug('!@#locked: '+locked);
                        if(!locked){
                            //send password reset email
                            UserTriggerHandler userTriggerHandler = new UserTriggerHandler();
                            userTriggerHandler.sendEmail(currentUser);
                            fieldState = true;
                        }else{
                            passResetExceed = true;
                        }
                    }else{//invalid
                        System.debug('!@#userList2: '+ userList);
                        currentUser = userList.get(0);
                        Boolean locked = updateUser(currentUser, false);
                        System.debug('!@#locked: '+locked);
                        
                        if(locked){
                            passResetExceed = true;
                        }else{
                            Util.addMessage(ApexPages.Severity.ERROR, 'Incorrect email or date of birth');
                        }
                    }
                    
                    if(passResetExceed){
                        Util.addMessage(ApexPages.Severity.ERROR, GEN_OriginationsConstants.PWDRESET_EXCEEDED_MESSAGE);
                        fieldState = true;
                    }
                }          
            }catch(Exception e){

                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
                
                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'resetPassword()', 'APP_PwdResetCC', 'Class', null);                
                
                if(sp != null) {
                    Database.rollback(sp);
                }

            }

        }

    }

    //update user password reset details
    public Boolean updateUser(User user, Boolean valid){

        Boolean flag = false;

        System.debug('!@#valid: '+valid);

        if(!valid){//invalid

            Integer days = Integer.valueOf((datetime.now().getTime() - user.Password_Reset_Timestamp__c.getTime())/(1000*60*60*24));
            System.debug('!@#days: '+days);

            System.debug('!@#user.Password_Reset_Attempts__c: '+user.Password_Reset_Attempts__c);

            if(user.Password_Reset_Attempts__c == 0){

                user.Password_Reset_Attempts__c = 1;
                user.Password_Reset_Timestamp__c =  datetime.now();

            }else{

                if(user.Password_Reset_Attempts__c < 5){

                    System.debug('!@#user.Password_Reset_Attempts__c < 5');
                    user.Password_Reset_Attempts__c += 1;
                    user.Password_Reset_Timestamp__c =  datetime.now();
                }
                
                if(user.Password_Reset_Attempts__c == 5 && days < 1){

                    System.debug('!@#user.Password_Reset_Attempts__c == 5 && days < 1');
                    flag = true;

                }else if(user.Password_Reset_Attempts__c == 5 && days >= 1){
                    
                    System.debug('!@#user.Password_Reset_Attempts__c == 5 && days > 1');
                    user.Password_Reset_Attempts__c = 1;
                    user.Password_Reset_Timestamp__c =  datetime.now();

                }

            }

        }else{//valid
            
            Integer days = Integer.valueOf((datetime.now().getTime() - user.Valid_Password_Reset_Timestamp__c.getTime())/(1000*60*60*24));
            System.debug('!@#days: '+days);

            System.debug('!@#user.Password_Reset_Attempts__c: '+user.Password_Reset_Attempts__c);

            if(user.Password_Reset_Attempts__c == 0){

                user.Valid_Password_Reset_Timestamp__c =  datetime.now();

            }else{

                if(user.Password_Reset_Attempts__c < 5){

                    System.debug('!@#user.Password_Reset_Attempts__c < 5');
                    user.Valid_Password_Reset_Timestamp__c =  datetime.now();
                }

                if(user.Password_Reset_Attempts__c == 5 && days < 1){

                    System.debug('!@#user.Password_Reset_Attempts__c == 5 && days < 1');
                    flag = true;

                }else if(user.Password_Reset_Attempts__c == 5 && days >= 1){

                    System.debug('!@#user.Password_Reset_Attempts__c == 5 && days > 1');
                    user.Password_Reset_Attempts__c = 0;
                    user.Valid_Password_Reset_Timestamp__c =  datetime.now();

                }

            }           

        }

        user.Password_Reset_Token__c = generateToken(10);

        update user;

        return flag;

    }

    //validations
    public Boolean validation(){

        System.debug('!@#emailAddress: '+emailAddress);
        System.debug('!@#dob: '+dob);

        Boolean flag = true;

        if(emailAddress == null || emailAddress == ''){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter an email');
            flag = false;

        }

        if(birthDate == null || birthDate == '' || birthDate == 'Select'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please select birth date.');
            flag = false; 

        }

        if(birthMonth == null || birthMonth == '' || birthMonth == 'Select'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please select birth month.');
            flag = false;

        }

        if(birthYear == null || birthYear == ''){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter birth year.');
            flag = false;

        }

        if(birthMonth == '2' && birthDate == '29'){

            Integer year = Integer.valueOf(birthYear);
            
            // Code Scan Fix: Adrian Recio - Empty Condition
            /*if((Math.mod(year,400)) == 0){
                //leap year
            }else if((Math.mod(year,100)) == 0){

                //not leap year
                Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                flag = false;

            }else if((Math.mod(year,4)) == 0){
                //leap year
            }else{
                //not leap year
                Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                flag = false;
            }*/

            // Condition replacement for code scan
            if(!((Math.mod(year,400)) == 0 ) && !((Math.mod(year,4)) == 0)){
                    //not leap year
                    Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                    flag = false;
            }

        }

        return flag;

    }

    //password change token
    public String generateToken(Integer length){

        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String token = key.substring(0,length);

        return token;

    }

    //set dates
    public void setDate(){
        getDateOptions();
    }

    //set days
    public List<SelectOption> getDateOptions(){

        List<SelectOption> options = new List<SelectOption>();
        Integer dateNum = 31;

        options.add(new SelectOption('', 'Select'));

        if(Util.nullCheck(birthMonth)){     //05.14.15 Mike Lasala: Code Scan fix

            if(birthMonth== '02'){
                dateNum = 29;
            }
            if(birthMonth == '01' || birthMonth == '03' || birthMonth == '05' || birthMonth == '07' || birthMonth == '08' || birthMonth == '10' || birthMonth == '12' ){
                dateNum = 31;
            }
            if(birthMonth == '04' || birthMonth == '06' || birthMonth == '09' || birthMonth == '11'){
                dateNum = 30;
            }

        }

        for(Integer i = 1; i <= dateNum; i ++){

            String tempI = '';

            if(i<10){
                tempI = '0'+i;
            } else {
                tempI = String.valueOf(i);
            }

            options.add(new SelectOption(String.valueOf(tempI), String.valueOf(i)));

        }

        return options;

    }    

    //set months
    public List<SelectOption> getmonthOptions() {

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('', 'Select'));
        options.add(new SelectOption('01', 'January'));
        options.add(new SelectOption('02', 'February'));
        options.add(new SelectOption('03', 'March'));
        options.add(new SelectOption('04', 'April'));
        options.add(new SelectOption('05', 'May'));
        options.add(new SelectOption('06', 'June'));
        options.add(new SelectOption('07', 'July'));
        options.add(new SelectOption('08', 'August'));
        options.add(new SelectOption('09', 'September'));
        options.add(new SelectOption('10', 'October'));
        options.add(new SelectOption('11', 'November'));
        options.add(new SelectOption('12', 'December'));

        return options;

    }
    
        /*  Description: Redirect to  timeoutPage
     *  Author: Sandeep Gali
     *  Date Created: 22-July-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference timeOut(){

        PageReference pageRef = Page.APP_Timeout;
        pageRef.setRedirect(true);

        return pageRef;

    }
    

}