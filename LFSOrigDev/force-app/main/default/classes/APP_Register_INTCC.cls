/*
 * @Description: Sales ui register user controller
 * @Author: Jade Serrano
 * @Date Created:
 * @History:
 *              APR-02-2014 (Mat) : Refactoring of Admin Settings custom settings 
                2015-01-08 Tony Xu: Modified code for DBHZL237 to allow create user for Applicant 2
   =====================================================================

   =====================================================================
 */
public class APP_Register_INTCC extends APP_CommonExt{

    public String email{get;set;}
    public String dob{get;set;}

    public Boolean disableCreateUser{get;set;}
    public Boolean hideCreateUser{get;set;}

    String CUSTOMER_PROFILE = 'Customer Community Login';

    String firstName;
    String lastName;

    List<User> user2 = new List<User>();
   
    /**DBHZL237 Tony Xu START**/
    transient public Boolean isJoint {get;set;}
    public String email2{get;set;}
    public String dob2{get;set;}
    String firstName2;
    String lastName2;
    public Boolean disableCreateUser2{get;set;}
    public Boolean hideCreateUser2{get;set;} 
    List<User> user2_2 = new List<User>();      
    /**END**/

    public APP_Register_INTCC(ApexPages.StandardController controller){

        super(controller);

        System.debug('!@#this.application: '+this.application);
        System.debug('!@#this.applicant: '+this.applicant);

        Id roleId = UserInfo.getUserRoleId();    
        disableCreateUser = false;
        disableCreateUser2 = false;
        hideCreateUser = false;
        hideCreateUser2 = false;
        isJoint = isJoint(); //DBHZL237 Tony Xu
        system.debug('*************ISJOINT'+isJoint);
        //role validation
        if(roleId==null){

            Util.addMessage(ApexPages.Severity.WARNING, 'Your user does not have a role. You cannot create a user.');
            disableCreateUser = true;

        }
        
        /**Comment out by Tony Xu to create both applicant 
        List<User> user = [SELECT Id,
                                  FirstName,
                                  LastName,
                                  Email
                           FROM   User
                           WHERE  AppId__c LIKE: '%'+this.application.Id+'%'
                           AND    IsRegistered__c = true LIMIT 1];

        user2 = [SELECT Id,
                        Brand__c,
                        ContactId
                 FROM   User
                 WHERE  AppId__c LIKE: '%'+this.application.Id+'%' LIMIT 1];
         **/
         
        /**Added by Tony Xu for DBHZL237 to be able to create an user for Applicant 2 START**/
        List<User> user = [SELECT Id,
                                  FirstName,
                                  LastName,
                                  Email,
                                  First_Name__c,
                                  Last_Name__c,
                                  email__c
                           FROM   User
                           WHERE  AppId__c LIKE: '%'+this.application.Id+'%'
                           AND    IsRegistered__c = true
                           AND    profile.name = : this.application.Brand_Country__c == 'AU' ? GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1];

        user2 = [SELECT Id,
                        Brand__c,
                        ContactId
                 FROM   User
                 WHERE  profile.name = : this.application.Brand_Country__c == 'AU' ? GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1               
                 AND    AppId__c LIKE: '%'+this.application.Id+'%' LIMIT 1];
                 
        List<User> user_2 = [SELECT Id,
                                        FirstName,
                                        LastName,
                                        Email,
                                        First_Name__c,
                                        Last_Name__c,
                                        email__c
                           FROM   User
                           WHERE  AppId__c LIKE: '%'+this.application.Id+'%'
                           AND    IsRegistered__c = true
                           AND    profile.name = : this.application.Brand_Country__c == 'AU' ? GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2 : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2];

        user2_2 = [SELECT Id,
                        Brand__c,
                        ContactId
                 FROM   User
                 WHERE  profile.name = : this.application.Brand_Country__c == 'AU' ? GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2 : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2    
                 AND    AppId__c LIKE: '%'+this.application.Id+'%' LIMIT 1];         

        //created user1 validation
        if(user.isEmpty()){
            hideCreateUser = true;
        }else{
            Util.addMessage(ApexPages.Severity.INFO, 'Applicant 1 User has already been created.');             
        }

        //personal details validation
        if(this.applicant.First_Name__c!=null){
            firstName = this.applicant.First_Name__c;
        }else{

            Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant does not have a firstname. You cannot create a user.');
            disableCreateUser = true;

        }

        if(this.applicant.Last_Name__c!=null){
            lastName = this.applicant.Last_Name__c;
        }else{

            Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant does not have a lastname. You cannot create a user.');
            disableCreateUser = true;

        }

        if(this.applicant.Email_Address__c!=null){
            email = this.applicant.Email_Address__c;
        }else{

            Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant does not have an email. You cannot create a user.');
            disableCreateUser = true;

        }                

        if(this.applicant.Date_Of_Birth__c!=null){
            dob = this.applicant.Date_Of_Birth__c;
        }else{

            Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant does not have a date of birth. You cannot create a user.');
            disableCreateUser = true;

        }
             
        /**DBHZL237 Tony Xu Added validation for Applicant 2 in Joint Application START**/
        if(isJoint){
            system.debug('===============JOINT APPLICATION===============');
            //created user2 validation
            if(user_2.isEmpty()){
                hideCreateUser2 = true;
            }else{
                Util.addMessage(ApexPages.Severity.INFO, 'Applicant 2 User has already been created.'); 
            }
            
            
            if(this.applicant2.First_Name__c!=null){
                firstName2 = this.applicant2.First_Name__c;
            }else{
    
                Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant 2 does not have a firstname. You cannot create a user.');
                disableCreateUser2 = true;
    
            }
    
            if(this.applicant2.Last_Name__c!=null){
                lastName2 = this.applicant2.Last_Name__c;
            }else{
    
                Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant 2 does not have a lastname. You cannot create a user.');
                disableCreateUser2 = true;
    
            }
    
            if(this.applicant2.Email_Address__c!=null){
                email2 = this.applicant2.Email_Address__c;
            }else{
    
                Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant 2 does not have an email. You cannot create a user.');
                disableCreateUser2 = true;
    
            }                
    
            if(this.applicant2.Date_Of_Birth__c!=null){
                dob2 = this.applicant2.Date_Of_Birth__c;
            }else{
    
                Util.addMessage(ApexPages.Severity.ERROR, 'Your applicant 2 does not have a date of birth. You cannot create a user.');
                disableCreateUser2 = true;
    
            }
            
        }
        /**END**/
    }

    //create user button
    public PageReference createUser(){
        
        Savepoint sp = Database.setSavepoint();
        
        try{
             
            if(!disableCreateUser && user2.size() == 0){

                System.debug('!@#user2.size()==0');
                
                //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                String username = this.application.Id+''+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;
                
                //Id profileId = [SELECT Id,Name FROM Profile WHERE Name LIKE: '%'+CUSTOMER_PROFILE Limit 1].Id;
                //Changed by Tony Xu to be able to create user for both AU and NZ
                Id profileId;
                
                if(this.application.Brand_Country__c != null){
                    if(this.application.Brand_Country__c == 'AU'){
                        profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 Limit 1].Id;
                    }else{
                        if(this.application.Brand_Country__c == 'NZ'){
                            profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1 Limit 1].Id;
                        }
                    }                     
                }else{
                    profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 Limit 1].Id;
                }

                Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;

                //create person account
                Account p = new Account();
                p.FirstName = firstName;
                p.LastName = lastName;
                p.PersonEmail = this.applicant.Email_Address__c;
                p.Date_of_Birth__pc = dob;
                p.RecordTypeId = personAccountRecordTypeId;
                
                
                //insert person account
                insert p;

                //create user
                User u = new User();
                u.Username = username;
                u.Email = username;
                u.FirstName = firstName.left(1);    
                u.LastName = lastName.left(1);
                u.First_Name__c = firstName;
                u.Last_Name__c = lastName;
                u.Email__c = this.applicant.Email_Address__c;
                u.CommunityNickname = 'cust' + String.valueOf(this.application.Id).toLowerCase();
                u.AppId__c = String.valueOf(this.application.Id);
                u.Brand__c = this.application.Brand_String__c;
                u.Date_Of_Birth__c = dob;
                u.ProfileId = profileId;
                u.Alias = String.valueOf(this.application.Id).substring(0,4);
                u.TimeZoneSidKey = 'GMT';
                u.LocaleSidKey = 'en_US';
                u.EmailEncodingKey = 'ISO-8859-1';
                u.LanguageLocaleKey = 'en_US';
                u.Password_Reset_Token__c = generateToken(10);
                system.debug('==========Password Regen Token========'+u.Password_Reset_Token__c);
                u.Password_Reset_Attempts__c = 0;
                u.Valid_Password_Reset_Timestamp__c =  datetime.now();
                u.Password_Reset_Timestamp__c =  datetime.now();
                if(this.applicant.Title__c != null){
                    u.Title = this.applicant.Title__c;
                }
                
                //populate contact in user using created person account
                Contact c = [SELECT Id FROM Contact WHERE AccountId =: p.Id];
                Id contactId = c.Id;                
                u.ContactId = contactId;
                
                //Need to populate Contact with Password reset Token so the token can be sent with the initial email
                c.Password_Reset_Token__c = u.Password_Reset_Token__c;
                c.Application_UID__c      = this.application.UID__c; // Mar-23-2016 Afreen- Added to include the application number in the create user email template.
                //Update Contact
                update c;             
                
                //create user
                insert u;

                //created user validation
                if(u.Id!=null){

                    //relate application to created person account
                    this.application.Applicant1__c = p.Id;
                    update application;

                }

                //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: u.Brand__c LIMIT 1];

                //quey brand specific template
                List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Sales__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];
                //List<Brand__c> brandTemplate = [SELECT Id, Template_Password_Reset__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];
                //query the actual template
                EmailTemplate createUserTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Save_Retrieve_Sales__c LIMIT 1];
                System.debug('***createUserTemplate:'+createUserTemplate);

                string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

                if(sDsiplayName == null || sDsiplayName == '' ) {
                    sDsiplayName = u.Brand__c;
                }

                List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];


                //send email template
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setTargetObjectId(u.ContactId);
                mail.setTemplateId(createUserTemplate.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(brandTemplate.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                //update personal details
                this.applicant.Account__c = p.Id;
                this.applicant.Email_Address__c = this.applicant.Email_Address__c;
                this.applicant.Date_of_Birth__c = dob;

                update this.applicant;                 

                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('Id',this.application.Id);
                pageRef.setRedirect(true);

                return pageRef;

            }else if(!disableCreateUser && user2.size() > 0){

                System.debug('!@#user2.size()>0');

                user2.get(0).Password_Reset_Token__c = generateToken(10);
                user2.get(0).Valid_Password_Reset_Timestamp__c =  datetime.now();

                update user2;

                //p - start

                //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: user2.get(0).Brand__c LIMIT 1];

                //quey brand specific template
                //List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Sales__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];
                List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Sales__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];


                string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

                if(sDsiplayName == null || sDsiplayName == '' ) {
                    sDsiplayName = user2.get(0).Brand__c;
                }

                List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];

                //p - end


                //query the actual template
                EmailTemplate createUserTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Save_Retrieve_Sales__c LIMIT 1];
                                                          
                //send email template
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setTargetObjectId(user2.get(0).ContactId);
                mail.setTemplateId(createUserTemplate.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(brandTemplate.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                 

                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('Id',this.application.Id);
                pageRef.setRedirect(true);

                return pageRef;

            }

        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'createUser()', 'APP_Register_INTCC', 'Class' , this.application.Id);

        }

        return null;

    }
    
    /**Added by Tony Xu for DBHZL237 for creation of applicant 2's user START**/
    //create user2 button
    public PageReference createUser2(){

        Savepoint sp = Database.setSavepoint();

        try{

            if(!disableCreateUser2 && user2_2.size() == 0){

                System.debug('!@#user2_2.size()==0');
                
                //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                String username = this.application.Id+'_applicant2'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX;

                //Id profileId = [SELECT Id,Name FROM Profile WHERE Name LIKE: '%'+CUSTOMER_PROFILE Limit 1].Id;
                Id profileId;
                System.debug('***this.application.Brand_Country__c:'+this.application.Brand_Country__c);
                if(this.application.Brand_Country__c != null){
                    if(this.application.Brand_Country__c == 'AU'){
                        profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2 Limit 1].Id;
                    }else{
                        if(this.application.Brand_Country__c == 'NZ'){
                            profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2 Limit 1].Id;
                        }
                    }
                }else{
                    profileId = [SELECT Id,Name FROM Profile WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2 Limit 1].Id;
                }
                
                Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;

                //create person account
                Account p = new Account();
                p.FirstName = firstName2;
                p.LastName = lastName2;
                p.PersonEmail = this.applicant2.Email_Address__c;
                p.Date_of_Birth__pc = dob2;
                p.RecordTypeId = personAccountRecordTypeId;

                //insert person account
                insert p;

                //create user
                User u = new User();
                u.Username = username;
                u.Email = username;
                u.FirstName = firstName2.left(1);    
                u.LastName = lastName2.left(1);
                u.First_Name__c = firstName2;
                u.Last_Name__c = lastName2;
                u.Email__c = this.applicant2.Email_Address__c;
                u.CommunityNickname = 'cust2' + String.valueOf(this.application.Id).toLowerCase();
                u.AppId__c = String.valueOf(this.application.Id);
                u.Brand__c = this.application.Brand_String__c;
                u.Date_Of_Birth__c = dob2;
                u.ProfileId = profileId;
                u.Alias = String.valueOf(this.application.Id).substring(0,4);
                u.TimeZoneSidKey = 'GMT';
                u.LocaleSidKey = 'en_US';
                u.EmailEncodingKey = 'ISO-8859-1';
                u.LanguageLocaleKey = 'en_US';
                u.Password_Reset_Token__c = generateToken(10);
                u.Password_Reset_Attempts__c = 0;
                u.Valid_Password_Reset_Timestamp__c =  datetime.now();
                u.Password_Reset_Timestamp__c =  datetime.now();
                if(this.applicant2.Title__c != null){
                    u.Title = this.applicant.Title__c;
                }

                //populate contact in user using created person account
                Contact c = [SELECT Id FROM Contact WHERE AccountId =: p.Id];
                Id contactId = c.Id;                
                u.ContactId = contactId;
                
                //Need to populate Contact with Password reset Token so the token can be sent with the initial email
                c.Password_Reset_Token__c = u.Password_Reset_Token__c;
                c.Application_UID__c      = this.application.UID__c; // Mar-23-2016 Afreen- Added to include the application number in the create user email template.
                //Update Contact
                update c;    
                
                //create user
                insert u;

                //created user validation
                if(u.Id!=null){

                    //relate application to created person account
                    this.application.Applicant2__c = p.Id;
                    update application;

                }
                
                system.debug('!@#$brand:'+u.Brand__c);
                
                //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: u.Brand__c LIMIT 1]; //May- 04-2016- Commented this line by Afreen for user story 305
                
                //system.debug('!@#$owea:'+owea);

                 List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Sales__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];
                 //List<Brand__c> brandTemplate = [SELECT Id, Template_Password_Reset__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];
                //query the actual template
                 EmailTemplate createUserTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Save_Retrieve_Sales__c LIMIT 1];
                 //EmailTemplate createUserTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Password_Reset__c LIMIT 1];

                // Afreen - User story 305
                string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

                if(sDsiplayName == null || sDsiplayName == '' ) {
                    sDsiplayName = u.Brand__c;
                }

                List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];
                                                          
                //send email template
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setTargetObjectId(u.ContactId);
                mail.setTemplateId(createUserTemplate.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(brandTemplate.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                //update personal details
                //this.applicant.Account__c = p.Id; // Updated by Adrian Recio. Corrected the account assignment for applicant 2. This is BAU error that exist since NZ implementation.
                this.applicant2.Account__c = p.Id; // Added mapping of Account for applicant 2. Important in identifying the right applicant record based on account. 
                this.applicant2.Email_Address__c = this.applicant2.Email_Address__c;
                this.applicant2.Date_of_Birth__c = dob2;

                update this.applicant2;                 

                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('Id',this.application.Id);
                pageRef.setRedirect(true);

                return pageRef;

            }else if(!disableCreateUser && user2_2.size() > 0){

                System.debug('!@#user2.size()>0');

                user2_2.get(0).Password_Reset_Token__c = generateToken(10);
                user2_2.get(0).Valid_Password_Reset_Timestamp__c =  datetime.now();

                update user2_2;
                
                //List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: user2_2.get(0).Brand__c LIMIT 1];  //Commented the line by Afreen - User story 305

                //quey brand specific template
                List<Brand__c> brandTemplate = [SELECT Id, Template_Save_Retrieve_Sales__c, OrgWide_Email_Address__c FROM Brand__c WHERE Name =: this.application.Brand_String__c LIMIT 1];

                //query the actual template
                EmailTemplate createUserTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: brandTemplate.get(0).Template_Save_Retrieve_Sales__c LIMIT 1];

                 // Afreen - Added for User story 305 
                string sDsiplayName =  brandTemplate.get(0).OrgWide_Email_Address__c;

                if(sDsiplayName == null || sDsiplayName == '' ) {
                    sDsiplayName =  user2_2.get(0).Brand__c;
                }

                List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName =: sDsiplayName LIMIT 1];
                                                          
                //send email template
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                mail.setTargetObjectId(user2_2.get(0).ContactId);
                mail.setTemplateId(createUserTemplate.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(brandTemplate.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                 

                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('Id',this.application.Id);
                pageRef.setRedirect(true);

                return pageRef;

            }

        }catch(Exception e){

            if(sp!=null) {
                Database.rollback(sp);
            }

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'createUser2()', 'APP_Register_INTCC', 'Class' , this.application.Id);

        }

        return null;

    }    
    /**END**/   

    //cancel button
    public PageReference cancel(){   

        PageReference pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('Id',this.application.Id);
        pageRef.setRedirect(true);

        return pageRef;    

    }

    //generate token
    public String generateToken(Integer length){

        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String token = key.substring(0,length);

        return token;

    }

}