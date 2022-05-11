/*
 * @Description: Login user controller
 * @Author: Jade Serrano
 * @Date Created: 18-OCT-2013
 * @History:
   =====================================================================
       Jade - 18-OCT-13: Created
       Mike - 29-OCT-13: Added query of login history to return error if status != success
       2015-01-19: Updated by Tony Xu to allow login from different country
   =====================================================================
 */
public class APP_LoginCC{
    
    public String username {get; set;}
    public String password {get; set;}

    public Boolean customer{get;set;}

    String siteName = Site.getName();
    
    public APP_LoginCC() {

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

    }
    
    //login button
    public PageReference login() {
        
        PageReference ref;

        try{

            System.debug('!@#username: '+username);

            if(validation()){
            
                //query customer profile
                /**
                	Updated the code to work with NZ sites as well
                **/
                
                List<Profile> profileList = [SELECT Id, Name
                                                 FROM   Profile
                                                 WHERE Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1
                                                 OR	Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2
                                                 OR Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1
                                                 OR Name = : GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2];
             

                if(profileList.isEmpty()){

                    ErrorHandlerException.recordException('No profile found', 'APP_LoginCC', 'login()', 'Class', null);
                    Util.addMessage(ApexPages.Severity.Error, 'There has been an error, please contact your administrator');

                    return null;

                }else{
                	
                	Map<String, ID> profileMap = new Map<String, ID>();
                
	                for(Profile p : profileList){
	                	profileMap.put(p.Name, p.ID);
	                }             
                  //Create a SOSL call to check for email address
                  List<Applicant__c> lst_Applicant = new List<Applicant__c>();
                  Set<String> set_emailAddres = new Set<String>();
                  //MLASALA 08-SEPT-16 SOQL SOSL Injection Code scanner fix
                  System.debug('search query ' + username);
                  String searchQuery = 'FIND \'' + String.escapeSingleQuotes(username)+ '\' IN EMAIL FIELDS RETURNING Applicant__c(Application__c,Email_Address__c,Is_Primary_Applicant__c)';
                  System.debug('search query ' + searchQuery);
                  List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
                  lst_Applicant = ((List<Applicant__c>)ListOfListOfSObjects[0]);
                  
                  System.debug('List of applicant result set ' + lst_Applicant);
                  for(Integer i=0; i<lst_Applicant.size(); i++){
                    if(lst_Applicant[i].Is_Primary_Applicant__c){
                      set_emailAddres.add(lst_Applicant[i].Application__c +'@ge.com');        
                    }else{
                      set_emailAddres.add(lst_Applicant[i].Application__c +'_applicant2'+'@ge.com');        
                    }
                  }
                  
                  System.debug('## Set of email address ' + set_emailAddres);

                  if(Test.isRunningTest()) {
                      siteName = GEN_OriginationsConstants.GEMONEY_AU_SITENAME;
                  }

                    //query user
                    //Changed By Lavanya Kavuri, 24 March 2015, Jira - 1366
                    List<User> currentUser = [SELECT Id,
                                                     Username,
                                                     AppId__c,                                                     
                                                     Password_Reset_Attempts__c,
                                                     Password_Reset_Timestamp__c,
                                                     Brand__c,
                                                     Profile.Name,
                                                     Country__c
                                              FROM   User
                                              WHERE  Email =: set_emailAddres
                                              AND    IsActive = true
                                              AND    
                                              (ProfileId =: siteName.equals(GEN_OriginationsConstants.GEMONEY_AU_SITENAME) || siteName.equals(GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME) ? profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1) : profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1) 
                                              	OR
                                               ProfileId =: siteName.equals(GEN_OriginationsConstants.GEMONEY_AU_SITENAME) || siteName.equals(GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME) ? profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2) : profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2) 
                                              ) ORDER BY CreatedDate DESC LIMIT 1];

                    if(Test.isRunningTest()) {
                        currentUser = [SELECT Id,
                                    Username,
                                    AppId__c,                                                     
                                    Password_Reset_Attempts__c,
                                    Password_Reset_Timestamp__c,
                                    Brand__c,
                                    Profile.Name,
                                    Country__c
                            FROM   User
                            WHERE  IsActive = true
                            AND    
                            (ProfileId =: siteName.equals(GEN_OriginationsConstants.GEMONEY_AU_SITENAME) || siteName.equals(GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME) ? profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1) : profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1) 
                                OR
                            ProfileId =: siteName.equals(GEN_OriginationsConstants.GEMONEY_AU_SITENAME) || siteName.equals(GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME) ? profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2) : profileMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2) 
                            ) ORDER BY CreatedDate DESC LIMIT 1];                        
                    }                          

                    System.debug('siteName '+siteName);
                    List<Brand__c> currentBrand = [SELECT Id,
                                                          Name
                                                   FROM   Brand__c
                                                   WHERE  Site__c =: siteName];

                    System.debug('!@#currentUser: '+currentUser);
                    System.debug('!@#currentBrand: '+currentBrand);

                    if(!currentUser.isEmpty()){

                        if(currentUser.get(0).Brand__c != null){

                            if(!currentBrand.isEmpty()){

                                if(currentUser.get(0).Brand__c == currentBrand.get(0).Name){

                                    //get latest invalid password reset time stamp
                                    Integer days = Integer.valueOf((datetime.now().getTime() - currentUser.get(0).Password_Reset_Timestamp__c.getTime())/(1000*60*60*24));
                                    System.debug('!@#days: '+days);

                                    System.debug('!@#currentUser.get(0).Password_Reset_Attempts__c: '+currentUser.get(0).Password_Reset_Attempts__c);
                                    if(currentUser.get(0).Password_Reset_Attempts__c == 5 && days > 1 || currentUser.get(0).Password_Reset_Attempts__c < 5){

                                        if(Util.nullCheck(currentUser.get(0).AppId__c)){    //05.14.15 Mike Lasala: Code Scan fix
                                            //login user 
                                            //If login user is Applicant 1, proceed to Application Main Page
                                          //  if(currentUser.get(0).Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 || currentUser.get(0).Profile.Name == GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1){

                                             /**Better Start Fix for Save & Retrieve*/
                                            Application__c appObj= [select Product_SubType__c from Application__c where Id =: currentUser.get(0).AppId__c] ;
                                            if(appObj.Product_SubType__c == 'Better Start PL'){
                                                ref = Site.login(currentUser.get(0).Username, password, '/APP_Main?id='+currentUser.get(0).AppId__c+'&subType=betterStart');
                                            }else{
                                                ref = Site.login(currentUser.get(0).Username, password, '/APP_Main?id='+currentUser.get(0).AppId__c);
                                            }
                                            	
                                          //  }
                                           // else{
                                            //	//For Applicant 2, proceed to Reference Page
                                           // 	ref = Site.login(currentUser.get(0).Username, password, '/APP_ReferredResponse?id='+currentUser.get(0).AppId__c);
                                           // }

                                        }else{

                                            Util.addMessage(ApexPages.Severity.Error, 'Your user does not have a valid application');
                                            return null;

                                        }

                                    }else{

                                        Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.PWDRESET_EXCEEDED_MESSAGE);
                                        return null;

                                    }

                                }else{

                                    Util.addMessage(ApexPages.Severity.Error, 'User does not exist');
                                    return null;

                                }

                            }else{

                                Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.BRAND_NULL_SITE);
                                return null;

                            }


                        }else{

                            Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.USER_NULL_BRAND);
                            return null;

                        }                        

                    }else{

                        Util.addMessage(ApexPages.Severity.Error, 'Invalid username or password');
                        return null;

                    }

                }

            }

            return ref;

        }catch(Exception e){

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'APP_LoginCC', 'login', 'Class', null);   
            Util.addMessage(ApexPages.Severity.Error, 'There has been an error, please contact your administrator');
            
            return null;

        }

    }
    
    //redirect to password reset
    public PageReference passwordReset() {
        return new PageReference(Site.getPrefix() + '/APP_PwdReset');
    }

    //login validations
    public Boolean validation(){

        Boolean flag = true;
        
        //validate username
        if(username==null || username==''){

            Util.addMessage(ApexPages.Severity.Error, 'Please put username');
            flag = false;

        }

        if(password==null || password==''){

            Util.addMessage(ApexPages.Severity.Error, 'Please put password');
            flag = false;

        }

        return flag;

    }
}