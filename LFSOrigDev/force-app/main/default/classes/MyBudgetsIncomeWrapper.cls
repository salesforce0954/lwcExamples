/* @Description: Wrapper class for Income
 * @Author: Mike Lasala
 * @Date Created: JAN-30-2013
 * @History:
   =====================================================================
     01-30-14: Created - Mike
     10-31-14: Added new fields and validation rules for DBHZL-34  - Tony Xu  
     04-10-15: Comment-out the validation that reference to PRS - DYU     
   =====================================================================
 */

//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================
/*  Description: Wrapper class for the income object
 *  Author: Fel Saliba
 *  Date Created: OCT-01-2013
 */
public class MyBudgetsIncomeWrapper{
    public Income__c income                 {get;set;}
    public Boolean incomeSourceValid        {get;set;}
    public Boolean amountValid              {get;set;}
    public Boolean intervalValid            {get;set;}
    public Boolean occupationValid          {get;set;}
    public Boolean companyNameValid         {get;set;}
    public Boolean contactNumberValid       {get;set;}
    public Boolean employmentYearValid      {get;set;}
    public Boolean employmentMonthValid     {get;set;}
    public String contactNumberCheckStr     {get;set;}
    public String errorEmpName              {get;set;}
    public Applicant__c applicant           {get;set;}
    public Integer rowCount                 {get;set;}
    
    //Added by Tony Xu for DBHZL-34
    public Boolean industryValid			{get;set;}
    public Boolean benefitTypeValid			{get;set;}	
    public String country					{get;set;}	
    public String phoneNumberCheckStrPortal	{get;set;}    //This is for message to be displayed on the customer portal if phone number is not valid
        
    /*  Description: Wrapper constructor, creates new income, refreshes validations
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public MyBudgetsIncomeWrapper (Applicant__c applicant, Boolean isCust, String country){ //Added country - Tony Xu
        this.income  = new Income__c(Applicant__c = applicant.Id);
        this.incomeSourceValid = true;
        this.amountValid = true;
        this.intervalValid = true;
        this.occupationValid = true;
        this.companyNameValid = true;
        this.contactNumberValid = true;
        this.employmentYearValid = true;
        this.employmentMonthValid = true;
        this.contactNumberCheckStr = '';
        this.errorEmpName = '';
        this.applicant = applicant;
        
        //Added by Tony Xu For DBHZL-34
        this.industryValid = true;
        this.benefitTypeValid = true; 
        this.country = country;
        
    }
    
    public MyBudgetsIncomeWrapper (Income__c oldIncome, Applicant__c applicant, Boolean isCust, String country){ //Added country - Tony Xu
        this.income  = oldIncome;
        this.incomeSourceValid = true;
        this.amountValid = true;
        this.intervalValid = true;
        this.occupationValid = true;
        this.companyNameValid = true;
        this.contactNumberValid = true;
        this.employmentYearValid = true;
        this.employmentMonthValid = true;
        this.contactNumberCheckStr = '';
        this.errorEmpName = '';
        this.applicant = applicant;
        
        //Added by Tony Xu For DBHZL-34
        this.industryValid = true; 
        this.benefitTypeValid = true;
        this.country = country;
    }
    
    /*  Description: Validates all income fields in the wrapper
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateIncome() {
        Boolean validationresult = true;
        
        this.incomeSourceValid = true;
        this.amountValid = true;
        this.intervalValid = true;
        this.occupationValid = true;
        this.companyNameValid = true;
        this.contactNumberValid = true;
        this.employmentYearValid = true;
        this.employmentMonthValid = true;
        this.contactNumberCheckStr = '';
        this.errorEmpName = '';
        
        //Added by Tony Xu For DBHZL-34
        this.industryValid = true;
        this.benefitTypeValid = true;
        
        if(income.Income_Source__c==null || income.Income_Source__c=='None') {
            this.incomeSourceValid = false; //1
            validationresult = false;
        }            
        if(income.Income_Amount__c==null || income.Income_Amount__c==0 || income.Income_Amount__c < 0) {
            this.amountValid = false; //2
            validationresult = false;
        }
        if(income.Income_Interval__c==null || income.Income_Interval__c == 'None') {
            this.intervalValid = false; //3
            validationresult = false;
        }         
        if(income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_PARTTIME ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_CONTRACT ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_TEMPORARY ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_SEASONAL ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_OTHER_SOURCE ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_WORKCOVER ||
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_NET_SALARY || //DBHZL34
           income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED_NZ	){ //DBHZL34   

            if(income.Occupation__c==null || income.Occupation__c == 'None') {
                this.occupationValid = false; //4
                validationresult = false;
            } 

			//Added by Tony Xu for DBHZL34
            if(country == 'NZ' && (income.Industry__c == null || income.Industry__c == 'None' || income.Industry__c == '')){
            	this.industryValid = false;
            	validationresult = false;
            }
            
            if(income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED && income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED_NZ){
                if(income.Emp_Bus_Name__c==null || income.Emp_Bus_Name__c=='') {
                    this.errorEmpName = 'Error: Please enter your employer name';
                    this.companyNameValid = false; //5
                    validationresult = false;
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                }
                /*else if((income.Emp_Bus_Name__c!=null || income.Emp_Bus_Name__c!='') && income.Emp_Bus_Name__c=='ERR1'){
                    this.errorEmpName = 'Error: Your employer name must be less 30 than characters.';
                    this.companyNameValid = false;
                    validationresult = false;
                }*/
                else{
                    if(APP_CommonExt.validateEmployerName(income.Emp_Bus_Name__c) == false){
                    this.errorEmpName = 'Error: Your employer name contains invalid characters.';
                    this.companyNameValid = false;
                    validationresult = false;
                    }
                }
                
                
                if(country == 'AU'){
                
	                if(income.Emp_Bus_Contact_No__c==null || income.Emp_Bus_Contact_No__c=='' || income.Emp_Bus_Contact_No__c.length() == 1) {
	                    this.contactNumberValid = false; //6
	                    this.contactNumberCheckStr = 'Error: Please enter a 10-digit landline phone number including area code or mobile phone number starting with 04.'; 
	                    this.phoneNumberCheckStrPortal = 'Error: Please enter a 10-digit landline phone number including area code or mobile phone number starting with 04.'; 
	                    validationresult = false;
                    } 
                    //Updated by DYU 04-10-15 - comment-out the PRS validation
                    /*else if((income.Emp_Bus_Contact_No__c!=null || income.Emp_Bus_Contact_No__c!='') && income.Emp_Bus_Contact_No__c=='ERR1'){
	                    this.contactNumberCheckStr = 'Error: Your employer contact number must be less 41 than characters.';
	                    this.phoneNumberCheckStrPortal = 'Error: Your employer contact number must be less 41 than characters.';
	                    this.contactNumberValid = false;
	                    validationresult = false;
	                }
                    else if((income.Emp_Bus_Contact_No__c!=null || income.Emp_Bus_Contact_No__c!='') && income.Emp_Bus_Contact_No__c=='ERR4'){
	                    this.contactNumberCheckStr = 'Error: Please enter a valid employer contact number.';
	                    this.phoneNumberCheckStrPortal = 'Error: Please enter a valid employer contact number.';
	                    this.contactNumberValid = false;
	                    validationresult = false;
			        }*/ 
                    else if(((String)(income.Emp_Bus_Contact_No__c)).Contains(' ')){
                            this.contactNumberCheckStr = 'Error: Employee Business Contact Should Not Contain Spaces';  //Added This logic by prakash for PMIHM-729
                            this.contactNumberValid = false;
                            validationresult = false;
	                }
                }else if(country == 'NZ'){ //Added by Tony Xu for DBHZL34
                	//NZ Employer Contact Phone Number is Optional
                	if(income.Emp_Bus_Contact_No__c != null && income.Emp_Bus_Contact_No__c != ''){
	                	//NZ phone number rules, Mobile: 02 + followed by an additional 7-9 digits, Work/home: 2 area digit code (03, 04, 07 or 09 only) followed by an additional 7 digits
	                	if(income.Employer_Business_Contact_No_Area_Code__c == '02'){
	                		
	                		if (income.Employer_Business_Contact_No_WS__c.length() < 7 ||income.Employer_Business_Contact_No_WS__c.length()>9){
	                			this.contactNumberValid = false;
	                			this.contactNumberCheckStr = 'Error: Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
	                			this.phoneNumberCheckStrPortal = 'Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02 ';
	                			validationresult = false;
	                		}
	                		
	                	}else{
	                		
	                		if(income.Employer_Business_Contact_No_Area_Code__c == '03' || income.Employer_Business_Contact_No_Area_Code__c == '04' || income.Employer_Business_Contact_No_Area_Code__c == '06' ||		//Modified by TXU
	                				 income.Employer_Business_Contact_No_Area_Code__c == '07' || income.Employer_Business_Contact_No_Area_Code__c == '09'){
	                			if(income.Employer_Business_Contact_No_WS__c.length() != 7){
	                				this.contactNumberValid = false;
	                				this.contactNumberCheckStr = 'Error: Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
	                				this.phoneNumberCheckStrPortal = 'Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
	                				validationresult = false;
	                			}
	                		
	                		}
	                		/*  // commented by akash as it is causing issues
	                		else{
	                			this.contactNumberValid = false;
	                			this.contactNumberCheckStr = 'Error: Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
	                			this.phoneNumberCheckStrPortal = 'Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
	                			validationresult = false;
	                		}
	                		*/
	                	}
	                	//Updated by DYU 04-10-15 - comment-out the PRS validation               	
	                	/*if((income.Emp_Bus_Contact_No__c!=null || income.Emp_Bus_Contact_No__c!='') && income.Emp_Bus_Contact_No__c=='ERR1'){
		                   this.contactNumberValid = false;
		                    this.contactNumberCheckStr = 'Error: Your employer contact number must be less than 41  characters.';
		                    this.phoneNumberCheckStrPortal = 'Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
		                    this.contactNumberValid = false;
		                    validationresult = false;
		                } else if((income.Emp_Bus_Contact_No__c!=null || income.Emp_Bus_Contact_No__c!='') && income.Emp_Bus_Contact_No__c=='ERR4'){
		                    this.contactNumberValid = false;
		                    this.contactNumberCheckStr = 'Error: Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
		                    this.phoneNumberCheckStrPortal = 'Please enter a 9-digit landline phone number including area code or mobile phone number starting with 02';
		                    this.contactNumberValid = false;
		                    validationresult = false;
		                }*/
	                }
                } 
            }
            
           if(income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_WORKCOVER){
                if((income.Years_With_Employer__c==null || income.Years_With_Employer__c==00) && (income.Months_With_Employer__c==null || income.Months_With_Employer__c==00)){
                    this.employmentYearValid = false;
                    this.employmentMonthValid = false;
                    validationresult = false;
                } else{
                    if(income.Months_With_Employer__c > 11){
                        this.employmentMonthValid = false;
                        validationresult = false;
                    }
                }
            }
        }
        
        //Added by Tony Xu for DBHZL34 to Validate the Government Benefit Type is provided when income source is Government Benefit
        if(income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_GOVERNMENT_BENEFIT 
        	&& (income.Government_Benefit_Type__c == '' || income.Government_Benefit_Type__c == 'None' || income.Government_Benefit_Type__c == null)
        	&& UserInfo.getUserType() == 'Guest'){	//Modified by Tony Xu 25/11/2014
            	this.benefitTypeValid = false;
            	validationResult = false;            	
        } 
        
        return validationresult;
    }
    
    /*  Description: Computes total income based on income interval
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public void computeTotalIncome() {
        Decimal incomeAmount = 0;
        incomeAmount = income.Income_Amount__c;
        
        if(this.income.Income_Source__c == GEN_OriginationsConstants.INCOME_SOURCE_RENTAL_INCOME){
            incomeAmount = incomeAmount * 0.8;
        }

        if(this.income.Income_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
           this.income.Total_Income__c = (incomeAmount * 52) / 12;
        } else if (income.Income_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
           this.income.Total_Income__c = (incomeAmount * 26) / 12;
        } else if (income.Income_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
           this.income.Total_Income__c = incomeAmount;
        } else if (income.Income_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
           this.income.Total_Income__c = incomeAmount / 12;
        }
    }
        
    /*  Description: Check income source to clear the value of unwanted fields
     *  Author: Fel Saliba
     *  Date Created: OCT-21-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public void clearFields(){
        if(income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_PARTTIME &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_CONTRACT &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_TEMPORARY &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_SEASONAL &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_OTHER_SOURCE &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_WORKCOVER &&
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_NET_SALARY && //DBHZL34
           income.Income_Source__c != GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED_NZ	//DBHZL34
		){  
           
            
                this.income.Occupation__c  = null;
                this.income.Emp_Bus_Name__c = null;
                this.income.Emp_Bus_Contact_No__c = null;
                this.income.Years_With_Employer__c = null;
                this.income.Months_With_Employer__c = null;
                this.income.Industry__c = null;
                this.income.Prev_Emp_Bus_Name__c = null;
        }else{
        	if(income.Income_Source__c !=  GEN_OriginationsConstants.INCOME_SOURCE_GOVERNMENT_BENEFIT){ //DBHZL 34
        		this.income.Government_Benefit_Type__c = null;
        	}
        }
    }


     /*  Description: On change of Income Source from Governemnt Benefit to Other Source need to clear the Benefit Type picklist so the warning message go off
     *  Author: Tony Xu	
     *  Date Created: NOV-03-2014
     *  Input Parameters: None
     *  Return: N/A
     */
     
     public void removeGovernmentBenefitType(){
     	if(this.income.Income_Source__c != 'Government Benefit'){
     		this.income.Government_Benefit_Type__c = null;
     	}
     }
        
    
}