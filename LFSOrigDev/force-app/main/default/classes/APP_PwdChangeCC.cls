/* @Description: Controller for Password Change
 * @Author: Mike Lasala
 * @Date Created: OCT-17-2013
 * @History:
   =====================================================================
       10-17-13: Created - Mike
       01-08-15: Updated for DBHZL237 - Tony Xu
   =====================================================================
 */ 
public with sharing class APP_PwdChangeCC{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public String newPassword           {get;set;}//New password
    public String confirmNewPassword    {get;set;}//Identical password checker

    public Boolean isSuccess            {get;set;}//Password change indicator
    public Boolean customer             {get;set;}
    
    public User currentUser;//Current user attempting to change password
    
    /**2015-01-08 DBHZL237 Tony Xu START**/
    public String birthDate         {get;set;}
    public String birthMonth        {get;set;}
    public String birthYear         {get;set;}
    public String dob               {get;set;}
    /**END**/
    
    public APP_PwdChangeCC(){
                
    }
    
    /*  Description: Checks if token parameter has a corresponding user
     *  Author: Mike Lasala
     *  Date Created: OCT-17-2013
     *  Input: None
     *  Return: void
     */
    public void tokenCheck(){

        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: profileId].Name;
        System.debug('!@#profileName: '+profileName);
		

        if(profileName == 'B1 Customer Community Login' || profileName == 'B1 Applicant2 Community Login' || profileName == 'A1 Customer Community Login' || profileName == 'A1 Applicant 2 Community Login'){
            customer = true;
        }else if(profileName == 'System Administrator'){
            customer = true;
        }else{
            customer = false;
        }

        //get token from url
        String token = ApexPages.currentPage().getParameters().get('token');
       	String encodedToken = EncodingUtil.urlEncode(token, 'UTF-8');
        System.debug('!@#encodedToken: '+encodedToken.length()+' '+token.length());

        //Retrieve user data
        List<User> userList = [SELECT   Id, 
                                        Valid_Password_Reset_Timestamp__c,
                                        Username, 
                                        AppId__c,
                                        Date_of_Birth__c	//DBHZL237 Tony Xu, The Birthday is needed for Password Change to validate user
                               FROM     User 
                               WHERE    Password_Reset_Token__c =: encodedToken];

        
        if(!userList.isEmpty()){

            isSuccess = true;
            currentUser = userList.get(0);  //assign to public variable
            Decimal passwordResetValidity = Password_Reset__c.getInstance().Validity_Period__c; //Retrieve validity duration from password reset custom settings            
            Integer minutes = Integer.valueOf((datetime.now().getTime() - currentUser.Valid_Password_Reset_Timestamp__c.getTime())/(1000*60));    //compute difference of password reset timestamp and current time
            System.debug('!@#passwordResetValidity: '+passwordResetValidity);
            System.debug('!@#minutes: '+minutes);

            if(Integer.valueOf(passwordResetValidity) < minutes){

                //Validity period exceeded: display error and log exception
                isSuccess = false;
                Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.PWDCHANGE_VALIDITY_MESSAGE);
            }
        }else{

            //Token does not match any user: display error and log exception
            Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.PWDCHANGE_UNAVAILABLE_MESSAGE);

        }

    }
    
    /*  Description: Validates and sets new password
     *  Author: Mike Lasala
     *  Date Created: OCT-17-2013
     *  Input: None
     *  Return: void
     *	Update: 2015-01-08 Updated By Tony Xu for DBHZL237, Added birthday validation prior to password change
     */ 
    public PageReference confirmPassword(){
    	
    	system.debug('!@Customer Date of Birth:  '+currentUser.Date_Of_Birth__c);
    	system.debug('!@User input dob:  '+dob);
	                           
    	if(validation()){
    		
    		if(currentUSer.Date_of_Birth__c == dob){
		
		        if(newPassword != ''|| confirmNewPassword != ''){
		
		            if(newPassword == confirmNewPassword){
		
		                try {
		
		                    currentUser.IsRegistered__c = true;
		                    
		                    update currentUser;
		                    
		                    System.setPassword(currentUser.id, newPassword);

	                        
		                    /**DBHZL237 try to directly login to the site without go to login page again START**/
		                    //PageReference pageRef = Page.APP_Login;
                            PageReference pageRef;
		                    pageRef = Site.login(currentUser.Username, newPassword, '/APP_Main?id='+currentUser.AppId__c);
		                    /**END**/
		             
		                   
		                    pageRef.setRedirect(true);
		
		                    return pageRef;
		
		                }catch(Exception e){
		
		                    //Retrieve password reset exception log record type
		                    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.ExceptionLog__c;
		                    Map<String,Schema.RecordTypeInfo> exLogRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
		                    String recTypeId = exLogRecordTypeInfo.get(GEN_OriginationsConstants.EXLOG_RECORDTYPE_NAME).getRecordTypeId();
		                    
		                    //Createt exception log and display error
		                    ErrorHandlerException.passwordResetException(e.getStackTraceString()+': '+e.getMessage(), 'Reset Password', 'User', 'APP_PwdChange', recTypeId);
		                    Util.addMessage(ApexPages.Severity.Error, e.getMessage());
		
		                    return null;
		
		                }
		                
		            }else{
		
		                //Display error when password fields are not identical
		                Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.PWDCHANGE_MISMATCH_MESSAGE);
		
		                return null;
		
		            }
		
		        }else{
		
		            //Display error when password fields are not populated
		            Util.addMessage(ApexPages.Severity.Error, GEN_OriginationsConstants.PWDCHANGE_NULL_MESSAGE);
		
		            return null;
		
		        }
	    	}else{
	    		Util.addMessage(ApexPages.Severity.Error, 'Incorrect Date of Birth');
	    		
	    		return null;
	    	}
    	}else{
    		return null;
    	}
    }
    
    /**2015-01-08 DBHZL237 Tony Xu START**/
    //validations
    public Boolean validation(){

        System.debug('!@#dob: '+dob);

        Boolean flag = true;

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
            /*
            if((Math.mod(year,400)) == 0){
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
            }
            */

            // Condition replacement for code scan
            if(!((Math.mod(year,400)) == 0 ) && !((Math.mod(year,4)) == 0)){
                    //not leap year
                    Util.addMessage(ApexPages.Severity.ERROR, 'This is not a leap year');
                    flag = false;
            }

        }

        return flag;

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
    
    /**END**/

}