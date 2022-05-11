/*
 * @Description: APP_Register controller
 * @Author: Jade Serrano
 * @Date Created: 18-OCT-2013
 * @History:
   =====================================================================
        Jade - 19-MAR-2014: Refactored
        Mat  - 02-APR-2014: Refactoring of Admin Settings custom settings
        DYU  - 10-APR-2015: Comment-out the validation that reference to PRS - DYU         
   =====================================================================
 */
public class APP_RegisterCC extends APP_CommonExt{

    //perspecsys variables
    public String em{get;set;}
    public String dob{get;set;}

    public String email{get; set;} 
    public String password{get;set;}
    public String confirmPassword{get;set;}
    
    public String birthYear {get;set;}
    public String birthMonth {get;set;}
    public String birthDate {get;set;}
    
    public Boolean validate {get;set;}

    public Applicant__c applicantUser{get;set;}

    public APP_RegisterCC(ApexPages.StandardController controller){
        super(controller);

        applicantUser = new Applicant__c();

        if(this.applicant.Email_Address__c!=null){
            email = this.applicant.Email_Address__c;
            em = this.applicant.Email_Address__c;
        }
        System.debug('!@#email: '+email);

        if(this.applicant.Date_of_Birth__c!=null){
            dob = applicant.Date_of_Birth__c;
        }else{
            dob = '00-00-0000';
        }
        System.debug('!@#dob: '+dob);

    }

    //Update user/applicant data and redirect to app_main
    public PageReference registerUser(){

        PageReference ret;

        //update user information
        UserUtility userUtility = new UserUtility();
        userUtility.registerEmail = em;
        userUtility.registerPassword = password;
        userUtility.registerDateOfBirth = dob;
        ret = userUtility.createCommunityUser(this.application, this.applicant);

        return ret;

    }

    //register validations
    public void validate(){

        System.debug('!@#em: '+em);
        System.debug('!@#dob: '+dob);

        System.debug('!@#email: '+email);
        System.debug('!@#birthDate: '+birthDate);
        System.debug('!@#birthMonth: '+birthMonth);
        System.debug('!@#birthYear: '+birthYear);    

        validate = true;

        //email validations
        if(email==null || email==''){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter an email address.');
            validate = false;

        }else{

            if(!isEmailValid(email)){

                Util.addMessage(ApexPages.Severity.ERROR, 'Please enter a valid email.');
                validate = false;

            }
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if((em!=null && em!='') && em=='ERR5'){

                Util.addMessage(ApexPages.Severity.ERROR, 'Please enter a valid email.');
                validate = false;

            }*/
            else{

                System.debug('!@#em: '+em+' this.applicant.Email_Address__c: '+this.applicant.Email_Address__c);                
                if(em != this.applicant.Email_Address__c){

                    List<String> flagMessage = APP_CommonExt.isEmailAvailable(em);
                    if(flagMessage.size()>0){
                        System.debug('!@#flagMessage: '+flagMessage[0]);
                        
                        if(flagMessage[0] == 'false'){

                            Util.addMessage(ApexPages.Severity.ERROR, flagMessage[1]);
                            validate = false;

                        }

                    }

                }
                
            }

        }

        //validate date of birth
        if(birthDate=='Select'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please select birth date.');
            validate = false;

        }
        if(birthMonth=='Select'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please select birth month.');
            validate = false;

        }
        if(birthYear==null || birthYear==''){

            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter birth year.');
            validate = false;

        }

        //perspecsys validations
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*if((dob != null || dob != '') && dob == 'ERR8'){

            Util.addMessage(ApexPages.Severity.ERROR, 'The date of birth you’ve entered appears to be incorrect.');
            validate = false;

        }else if((dob != null || dob != '') && dob == 'ERR6'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Date of birth must be more than 18 years of age');
            validate = false;

        }else if((dob != null || dob != '') && dob == 'ERR7'){

            Util.addMessage(ApexPages.Severity.ERROR, 'Date of birth must be less than 110 years of age');
            validate = false;

        } */       

        //leap year validations
        if(birthMonth=='2' && birthDate=='29'){
            
            Integer year = Integer.valueOf(birthYear);

            // Code Scan Fix: Adrian Recio - Empty Condition
            /*if((Math.mod(year,400)) == 0){
                //leap year
            }else if((Math.mod(year,100)) == 0){
                //not leap year
                Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                validate = false;
            }else if((Math.mod(year,4)) == 0){
                //leap year
            }else{
                //not leap year
                Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                validate = false;
            }*/

            // Condition replacement for code scan
            if(!((Math.mod(year,400)) == 0 ) && !((Math.mod(year,4)) == 0)){
                    //not leap year
                    Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                    validate = false;
            }
        }

        //password validations
        if(password==null || password==''){
            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter password.');
            validate = false;
        }
        if(confirmPassword==null || password==''){
            Util.addMessage(ApexPages.Severity.ERROR, 'Please enter password.');
            validate = false;
        }
        if(password!=confirmPassword){
            Util.addMessage(ApexPages.Severity.ERROR, 'Password did not match.');
            validate = false;
        }
        if(password.length()<8){
            Util.addMessage(ApexPages.Severity.ERROR, 'Password must be at least 8 characters.');
            validate = false;
        }else{
            if(!validatePassword(password)){
                Util.addMessage(ApexPages.Severity.ERROR, 'Password must contain a letter and a number.');
                validate = false;
            }
        }
    }

    //password policy validation
    public Boolean validatePassword(String password){

        String regex = '^(.{0,}(([a-zA-Z][^a-zA-Z])|([^a-zA-Z][a-zA-Z])).{4,})|(.{1,}(([a-zA-Z][^a-zA-Z])|([^a-zA-Z][a-zA-Z])).{3,})|(.{2,}(([a-zA-Z][^a-zA-Z])|([^a-zA-Z][a-zA-Z])).{2,})|(.{3,}(([a-zA-Z][^a-zA-Z])|([^a-zA-Z][a-zA-Z])).{1,})|(.{4,}(([a-zA-Z][^a-zA-Z])|([^a-zA-Z][a-zA-Z])).{0,})$';
        Pattern MyPattern = Pattern.compile(regex);
        Matcher MyMatcher = MyPattern.matcher(password);
        Boolean result = MyMatcher.matches();

        System.debug('!@#MyPattern: '+MyPattern);
        System.debug('!@#MyMatcher: '+MyMatcher);
        System.debug('!@#result: '+result);

        

        return result;

    }

}