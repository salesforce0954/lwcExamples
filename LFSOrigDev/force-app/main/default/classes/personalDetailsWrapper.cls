//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================

/*  Description: Wrapper class for the Applicant object
 *  Author: Mike Lasala
 *  Date Created: JAN-13-2014
 * @History:
   ==================================================================================
       12-09-2014: Modified code for DBHZL-142 Phone number validation fix - Devendra
       01-12-2015: Updated code for Defect #144 & # 145 - Devendra 
       01-21-2015: Updated code for Defect #230 - Devendra 
       11-2-2015 : Update code for DBHZL-81 - Keerthan
       04-10-2015: Comment-out the validation that reference to PRS - DYU
       04-13-2015: Updated Defect 894 - Uncomment validation on expiry dates for both 
       personal and secondary identification - DYU
       04-15-2015: Updated - Update pattern in validateStreet to handle prs values
       05-21-2015: Updated Defect 1069 - Updated vlaidaiton for previous residential address for nz 
       only if stay is less than 2 years
        18/03/2019 - Adding Confirm Email Changes Sprint 1
   ==================================================================================
 */
public class personalDetailsWrapper {
    public Applicant__c applicant {
        get;
        set;
    }

    //check if record is accessed from SUI or CUI
    public Boolean isStaffUi {
        get;
        set;
    }

    public String disableDrvcAst {
        get;
        set;
    }
    public String maleSelected {
        get;
        set;
    }
    public String femaleSelected {
        get;
        set;
    }
    public String PostalFlag {
        get;
        set;
    }
    public String birthYear {
        get;
        set;
    }
    public String birthMonth {
        get;
        set;
    }
    public String birthDate {
        get;
        set;
    }
    public String issueYear {
        get;
        set;
    }
    public String issueMonth {
        get;
        set;
    }
    public String issueDate {
        get;
        set;
    }
    public String issueYearSec {
        get;
        set;
    }
    public String issueMonthSec {
        get;
        set;
    }
    public String issueDateSec {
        get;
        set;
    }
    public String expiryYear {
        get;
        set;
    }
    public String expiryMonth {
        get;
        set;
    }
    public String expiryDate {
        get;
        set;
    }
    public String expiryYearSec {
        get;
        set;
    }
    public String expiryMonthSec {
        get;
        set;
    }
    public String expiryDateSec {
        get;
        set;
    }
    public String NoOfDeps {
        get;
        set;
    }
    public String applicationCountry {
        get;
        set;
    }
    public String TempDrivLicence                   {get;set;}

    //Rendering variables
    public Boolean errorTitle {
        get;
        set;
    }
    public Boolean errorFName {
        get;
        set;
    }
    public Boolean errorMName {
        get;
        set;
    }
    public Boolean errorLName {
        get;
        set;
    }
    public Boolean errorGender {
        get;
        set;
    }
    public Boolean errorDateOfBirth {
        get;
        set;
    }
    public Boolean errorRelStat {
        get;
        set;
    }
    public Boolean errorNoOfDeps {
        get;
        set;
    }
    public Boolean errorLicense {
        get;
        set;
    }
    public Boolean errorResStat {
        get;
        set;
    }
    public Boolean errorPrefContactMethod {
        get;
        set;
    }
    public Boolean errorUnitNum {
        get;
        set;
    }
    public Boolean errorStreetNum {
        get;
        set;
    }
    public Boolean errorStreetName {
        get;
        set;
    }
    public Boolean errorStreetType {
        get;
        set;
    }
    public Boolean errorSuburb {
        get;
        set;
    }
    public Boolean errorCity {
        get;
        set;
    }
    public Boolean errorPostcode {
        get;
        set;
    }
    public Boolean errorState {
        get;
        set;
    }
    public Boolean errorCountry {
        get;
        set;
    }
    public Boolean errorProperty {
        get;
        set;
    }
    public Boolean errorTimeAtAddress {
        get;
        set;
    }
    public Boolean errorHome {
        get;
        set;
    }
    public Boolean errorMobile {
        get;
        set;
    }
    public Boolean errorWork {
        get;
        set;
    }
    public Boolean errorEmail {
        get;
        set;
    }
    public Boolean errorPostalUnitNo {
        get;
        set;
    }
    public Boolean errorPostalPostcode {
        get;
        set;
    }
    public Boolean errorPostalStreetNo {
        get;
        set;
    }
    public Boolean errorPostalStreet {
        get;
        set;
    }
    public Boolean errorPostalStreetType {
        get;
        set;
    }
    public Boolean errorPostalCountry {
        get;
        set;
    }
    public Boolean errorPostalState {
        get;
        set;
    }
    public Boolean errorPostalSuburb {
        get;
        set;
    }
    public Boolean errorPostalCity {
        get;
        set;
    }
    public Boolean errorPreviousPostcode {
        get;
        set;
    }
    public Boolean errorPreviousStreet {
        get;
        set;
    }
    public Boolean errorPreviousStreetType {
        get;
        set;
    }
    public Boolean errorPreviousUnitNo {
        get;
        set;
    }
    public Boolean errorPreviousSuburb {
        get;
        set;
    }
    public Boolean errorPreviousCity {
        get;
        set;
    }
    public Boolean errorPreviousStreetNo {
        get;
        set;
    }
    public Boolean errorPreviousState {
        get;
        set;
    }
    public Boolean errorPreviousCountry {
        get;
        set;
    }
    public Boolean errorPreviousProperty {
        get;
        set;
    }
    public Boolean errorTimePrevAtAddress {
        get;
        set;
    }
    public Boolean disableEmail {
        get;
        set;
    }
    public Boolean disableDOB {
        get;
        set;
    }
    public Boolean errorPostalAddress {
        get;
        set;
    }
    public Boolean errorPostalFlag {
        get;
        set;
    }
    public Boolean errorServiceType {
        get;
        set;
    }
    public Boolean errorServiceId {
        get;
        set;
    }
    public Boolean errorCustomerIdType {
        get;
        set;
    }
    public Boolean errorIdType {
        get;
        set;
    }
    public Boolean errorVersion {
        get;
        set;
    }
    public Boolean errorNZResidencyNumber {
        get;
        set;
    }
    public Boolean errorIssuedate {
        get;
        set;
    }
    public Boolean errorExpirydate {
        get;
        set;
    }
    public Boolean errorIssuingcountry {
        get;
        set;
    }
    public Boolean errorOtherdocument {
        get;
        set;
    }
    //DBHZL-81 -BEGIN
    public Boolean errorSecIDExpiryDate {
        get;
        set;
    }
    public Boolean errorSecIDNumber {
        get;
        set;
    }
    //DBHZL-81 -END

    //Error messages
    public String errorTimePrevAtAddressMsg {
        get;
        set;
    }
    public String errorPostalPostcodeMsg {
        get;
        set;
    }
    public String errorPreviousPostcodeMsg {
        get;
        set;
    }
    public String errorPreviousStreetMsg {
        get;
        set;
    }
    public String errorPreviousStreetTypeMsg {
        get;
        set;
    }
    public String errorPreviousUnitNoMsg {
        get;
        set;
    }
    public String errorPreviousSuburbMsg {
        get;
        set;
    }
    public String errorPreviousCityMsg {
        get;
        set;
    }
    public String errorPreviousStreetNoMsg {
        get;
        set;
    }
    public String errorPreviousStateMsg {
        get;
        set;
    }
    public String errorPreviousCountryMsg {
        get;
        set;
    }
    public String errorPreviousPropertyMsg {
        get;
        set;
    }
    public String errorTimeAtAddressMsg {
        get;
        set;
    }
    public String errorHomeMsg {
        get;
        set;
    }
    public String errorMobileMsg {
        get;
        set;
    }
    public String errorWorkMsg {
        get;
        set;
    }
    public String errorEmailMsg {
        get;
        set;
    }
    public String errorTitleMsg {
        get;
        set;
    }
    public String errorFNameMsg {
        get;
        set;
    }
    public String errorMNameMsg {
        get;
        set;
    }
    public String errorLNameMsg {
        get;
        set;
    }
    public String errorGenderMsg {
        get;
        set;
    }
    public String errorDateOfBirthMsg {
        get;
        set;
    }
    public String errorRelStatMsg {
        get;
        set;
    }
    public String errorNoOfDepsMsg {
        get;
        set;
    }
    public String errorLicenseMsg {
        get;
        set;
    }
    public String errorResStatMsg {
        get;
        set;
    }
    public String errorPrefContactMethodMsg {
        get;
        set;
    }
    public String errorUnitNumMsg {
        get;
        set;
    }
    public String errorStreetNumMsg {
        get;
        set;
    }
    public String errorStreetNameMsg {
        get;
        set;
    }
    public String errorStreetTypeMsg {
        get;
        set;
    }
    public String errorSuburbMsg {
        get;
        set;
    }
    public String errorCityMsg {
        get;
        set;
    }
    public String errorPostcodeMsg {
        get;
        set;
    }
    public String errorStateMsg {
        get;
        set;
    }
    public String errorCountryMsg {
        get;
        set;
    }
    public String errorPropertyMsg {
        get;
        set;
    }
    public String errorPostalAddressMsg {
        get;
        set;
    }
    public String errorPostalUnitNoMsg {
        get;
        set;
    }
    public String errorPostalStreetNoMsg {
        get;
        set;
    }
    public String errorPostalStreetTypeMsg {
        get;
        set;
    }
    public String errorPostalStreetMsg {
        get;
        set;
    }
    public String errorPostalSuburbMsg {
        get;
        set;
    }
    public String errorPostalCityMsg {
        get;
        set;
    }
    public String errorPostalCountryMsg {
        get;
        set;
    }
    public String errorPostalStateMsg {
        get;
        set;
    }
    public String errorPostalFlagMsg {
        get;
        set;
    }
    public String errorServiceIdMsg {
        get;
        set;
    }
    public String errorServiceTypeMsg {
        get;
        set;
    }
    public String errorCustomerIdTypeMsg {
        get;
        set;
    }
    public String errorCustomerIdNumberMsg {
        get;
        set;
    }
    public String errorVersionMsg {
        get;
        set;
    }
    public String errorNZResidencyNumberMsg {
        get;
        set;
    }
    public String errorIssuedateMsg {
        get;
        set;
    }
    public String errorExpirydateMsg {
        get;
        set;
    }
    public String errorIssuingcountryMsg {
        get;
        set;
    }
    public String applicationCountryMsg {
        get;
        set;
    }
    public String errorOtherdocumentMsg {
        get;
        set;
    }
    //DBHZL-81 -BEGIN
    public String errorSecIDExpiryDateMsg {
        get;
        set;
    }
    public String errorSecIDNumberMsg {
        get;
        set;
    }
     /***  Email confirmation changes
    public String confirmEmailAddress{
        get;
        set;
    }  ****/
    public Boolean errorConfirmEmail{
        get;
        set;
    }
    public String errorConfirmEmailMsg{
        get;
        set;
    }   
    //DBHZL-81 -END

    /*  Description: Wrapper constructor. creates new applicant, refreshes validations
     *  Author: Mike Lasala
     *  Date Created: JAN-13-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    public personalDetailsWrapper() {
        this.applicant = new Applicant__c();

        isStaffUi = false;

        this.disableDrvcAst = '';
        this.maleSelected = '';
        this.femaleSelected = '';
        this.PostalFlag = '';
        this.birthYear = '';
        this.birthMonth = '';
        this.birthDate = '';
        this.issueYear = '';
        this.issueMonth = '';
        this.issueDate = '';
        this.expiryYear = '';
        this.expiryMonth = '';
        this.expiryDate = '';

        this.errorPostalFlag = false;
        this.disableEmail = false;
        this.disableDOB = false;
        this.errorTitle = false;
        this.errorFName = false;
        this.errorMName = false;
        this.errorLName = false;
        this.errorGender = false;
        this.errorDateOfBirth = false;
        this.errorRelStat = false;
        this.errorNoOfDeps = false;
        this.errorLicense = false;
        this.errorResStat = false;
        this.errorPrefContactMethod = false;
        this.errorUnitNum = false;
        this.errorStreetNum = false;
        this.errorStreetName = false;
        this.errorStreetType = false;
        this.errorSuburb = false;
        this.errorCity = false;
        this.errorPostcode = false;
        this.errorState = false;
        this.errorCountry = false;
        this.errorTimeAtAddress = false;
        this.errorHome = false;
        this.errorMobile = false;
        this.errorWork = false;
        this.errorEmail = false;
        this.errorPostalPostcode = false;
        this.errorPreviousPostcode = false;
        this.errorPreviousStreet = false;
        this.errorPreviousStreetType = false;
        this.errorPreviousUnitNo = false;
        this.errorPreviousSuburb = false;
        this.errorPreviousCity = false;
        this.errorPreviousStreetNo = false;
        this.errorPreviousState = false;
        this.errorPreviousCountry = false;
        this.errorPreviousProperty = false;
        this.errorTimePrevAtAddress = false;
        this.errorPostalAddress = false;
        this.errorPostalUnitNo = false;
        this.errorPostalStreetNo = false;
        this.errorPostalStreet = false;
        this.errorPostalState = false;
        this.errorPostalSuburb = false;
        this.errorPostalCity = false;
        this.errorPostalCountry = false;
        this.errorServiceType = false;
        this.errorServiceId = false;
        this.errorCustomerIdType = false;
        this.errorIdType = false;
        this.errorVersion = false;
        this.errorNZResidencyNumber = false;
        this.errorIssuedate = false;
        this.errorExpirydate = false;
        this.errorIssuingcountry = false;
        this.errorOtherdocument = false;
        //DBHZL-81 -BEGIN
        this.errorSecIDExpiryDate = false;
        this.errorSecIDNumber = false;
        //DBHZL-81 -END

        this.errorPostalFlagMsg = '';
        this.errorTimePrevAtAddressMsg = '';
        this.errorPostalPostcodeMsg = '';
        this.errorPreviousPostcodeMsg = '';
        this.errorPreviousStreetMsg = '';
        this.errorPreviousStreetTypeMsg = '';
        this.errorPreviousUnitNoMsg = '';
        this.errorPreviousSuburbMsg = '';
        this.errorPreviousCityMsg = '';
        this.errorPreviousStreetNoMsg = '';
        this.errorPreviousStateMsg = '';
        this.errorPreviousCountryMsg = '';
        this.errorPreviousPropertyMsg = '';
        this.errorTimeAtAddressMsg = '';
        this.errorHomeMsg = '';
        this.errorMobileMsg = '';
        this.errorWorkMsg = '';
        this.errorEmailMsg = '';
        this.errorTitleMsg = '';
        this.errorFNameMsg = '';
        this.errorMNameMsg = '';
        this.errorLNameMsg = '';
        this.errorGenderMsg = '';
        this.errorDateOfBirthMsg = '';
        this.errorRelStatMsg = '';
        this.errorNoOfDepsMsg = '';
        this.errorLicenseMsg = '';
        this.errorResStatMsg = '';
        this.errorPrefContactMethodMsg = '';
        this.errorUnitNumMsg = '';
        this.errorStreetNumMsg = '';
        this.errorStreetNameMsg = '';
        this.errorStreetTypeMsg = '';
        this.errorSuburbMsg = '';
        this.errorCityMsg = '';
        this.errorPostcodeMsg = '';
        this.errorStateMsg = '';
        this.errorCountryMsg = '';
        this.errorPropertyMsg = '';
        this.errorPostalAddressMsg = '';
        this.errorPostalUnitNoMsg = '';
        this.errorPostalStreetNoMsg = '';
        this.errorPostalStreetMsg = '';
        this.errorPostalStatemsg = '';
        this.errorPostalSuburbMsg = '';
        this.errorPostalCityMsg = '';
        this.errorPostalCountrymsg = '';
        this.errorServiceTypeMsg = '';
        this.errorServiceIdMsg = '';
        this.errorCustomerIdTypeMsg = '';
        this.errorCustomerIdNumberMsg = '';
        this.errorVersionMsg = '';
        this.errorNZResidencyNumberMsg = '';
        this.errorIssuedateMsg = '';
        this.errorExpirydateMsg = '';
        this.errorIssuingcountryMsg = '';
        this.errorOtherdocumentMsg = '';
        //DBHZL-81 -BEGIN
        this.errorSecIDExpiryDateMsg = '';
        this.errorSecIDNumberMsg = '';
        //DBHZL-81 -END
        ////Email confirmation change
      /***  this.confirmEmailAddress='';***/
        this.errorConfirmEmail=false;
        this.errorConfirmEmailMsg=''; 
    }

    /*  Description: Validates all Applicant fields in the wrapper
     *  Author: Mike Lasala
     *  Date Created: JAN-13-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateApplicant(Applicant__c apl, personalDetailsWrapper applicantWrapper) {
        this.errorTitle = false;
        this.errorFName = false;
        this.errorMName = false;
        this.errorLName = false;
        this.errorGender = false;
        this.errorDateOfBirth = false;
        this.errorRelStat = false;
        this.errorNoOfDeps = false;
        this.errorLicense = false;
        this.errorResStat = false;
        this.errorPrefContactMethod = false;
        this.errorUnitNum = false;
        this.errorStreetNum = false;
        this.errorStreetName = false;
        this.errorStreetType = false;
        this.errorSuburb = false;
        this.errorCity = false;
        this.errorPostcode = false;
        this.errorState = false;
        this.errorCountry = false;
        this.errorProperty = false;
        this.errorTimeAtAddress = false;
        this.errorHome = false;
        this.errorMobile = false;
        this.errorWork = false;
        this.errorEmail = false;
        this.errorPostalPostcode = false;
        this.errorPreviousPostcode = false;
        this.errorPreviousStreet = false;
        this.errorPreviousStreetType = false;
        this.errorPreviousUnitNo = false;
        this.errorPreviousSuburb = false;
        this.errorPreviousCity = false;
        this.errorPreviousStreetNo = false;
        this.errorPreviousState = false;
        this.errorPreviousCountry = false;
        this.errorPreviousProperty = false;
        this.errorTimePrevAtAddress = false;
        this.errorPostalAddress = false;
        this.errorPostalState = false;
        this.errorPostalCountry = false;
        this.errorPostalStreet = false;
        this.errorPostalStreetNo = false;
        this.errorPostalStreetType = false;
        this.errorPostalSuburb = false;
        this.errorPostalCity = false;
        this.errorPostalFlag = false;
        this.errorServiceType = false;
        this.errorServiceId = false;
        this.errorCustomerIdType = false;
        this.errorIdType = false;
        this.errorVersion = false;
        this.errorNZResidencyNumber = false;
        this.errorIssuedate = false;
        this.errorExpirydate = false;
        this.errorIssuingcountry = false;
        this.errorSecIDExpiryDate = false;
        this.errorSecIDNumber = false;

        this.errorPostalFlagMsg = '';
        this.errorTimePrevAtAddressMsg = '';
        this.errorPostalPostcodeMsg = '';
        this.errorPreviousPostcodeMsg = '';
        this.errorPreviousStreetMsg = '';
        this.errorPreviousStreetTypeMsg = '';
        this.errorPreviousUnitNoMsg = '';
        this.errorPreviousSuburbMsg = '';
        this.errorPreviousCityMsg = '';
        this.errorPreviousStreetNoMsg = '';
        this.errorPreviousStateMsg = '';
        this.errorPreviousCountryMsg = '';
        this.errorPreviousPropertyMsg = '';
        this.errorTimeAtAddressMsg = '';
        this.errorHomeMsg = '';
        this.errorMobileMsg = '';
        this.errorWorkMsg = '';
        this.errorEmailMsg = '';
        this.errorTitleMsg = '';
        this.errorFNameMsg = '';
        this.errorLNameMsg = '';
        this.errorGenderMsg = '';
        this.errorDateOfBirthMsg = '';
        this.errorRelStatMsg = '';
        this.errorNoOfDepsMsg = '';
        this.errorLicenseMsg = '';
        this.errorResStatMsg = '';
        this.errorPrefContactMethodMsg = '';
        this.errorUnitNumMsg = '';
        this.errorStreetNumMsg = '';
        this.errorStreetNameMsg = '';
        this.errorStreetTypeMsg = '';
        this.errorSuburbMsg = '';
        this.errorCityMsg = '';
        this.errorPostcodeMsg = '';
        this.errorStateMsg = '';
        this.errorCountryMsg = '';
        this.errorPostalStreetTypeMsg = '';
        this.errorPostalAddressMsg = '';
        this.errorPostalStateMsg = '';
        this.errorPostalSuburbMsg = '';
        this.errorPostalCityMsg = '';
        this.errorServiceTypeMSG = '';
        this.errorServiceIdMsg = '';
        this.errorCustomerIdTypeMsg = '';
        this.errorCustomerIdNumberMsg = '';
        this.errorVersionMsg = '';
        this.errorNZResidencyNumberMsg = '';
        this.errorIssuedateMsg = '';
        this.errorExpirydateMsg = '';
        this.errorIssuingcountryMsg = '';
        this.errorSecIDExpiryDateMsg = '';
        this.errorSecIDNumberMsg = '';
        /***Email confirmation change
        this.confirmEmailAddress=''; ***/
        this.errorConfirmEmail=false;
        this.errorConfirmEmailMsg=''; 

        Boolean validationResult = true;
     System.debug('***Applicant:' + applicant);
        if (applicant.Title__c == 'Select') {
            this.errorTitle = true;
            this.errorTitleMsg = 'Error: Please select your title.';
            validationResult = false;
        }
        System.debug('***Validationresult:' + validationResult);
        if (applicant.First_Name__c == null || applicant.First_Name__c == '') {
            this.errorFName = true;
            this.errorFNameMsg = 'Error: Please enter your first name.';
            validationResult = false;
        } 
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*else {
            if (applicant.First_Name__c == 'ERR2') {
                this.errorFName = true;
                this.errorFNameMsg = 'Error: Your first name must be more than one character.';
                validationResult = false;
            } else if (applicant.First_Name__c == 'ERR1') {
                this.errorFName = true;
                this.errorFNameMsg = 'Error: Your first name must be less than 16 characters.';
                validationResult = false;
            }
        }*/
        System.debug('***Validationresult:' + validationResult);
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*if ((applicant.Middle_Name__c != null || applicant.Middle_Name__c != '') && applicant.Middle_Name__c == 'ERR1') {
            this.errorMName = true;
            this.errorMNameMsg = 'Error: Your middle name must be less than 16 characters.';
            validationResult = false;
        }*/
        System.debug('***Validationresult:' + validationResult);
        if (applicant.Last_Name__c == null || applicant.Last_Name__c == '') {
            this.errorLName = true;
            this.errorLNameMsg = 'Error: Please enter your last name.';
            validationResult = false;
        } 
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*else {
            if (applicant.Last_Name__c.length() <= 1) {
                this.errorLName = true;
                this.errorLNameMsg = 'Error: Your last name must be more than one character.';
                validationResult = false;
            } else if (applicant.Last_Name__c == 'ERR1') {
                this.errorLName = true;
                this.errorLNameMsg = 'Error: Your last name must be less than 21 characters.';
                validationResult = false;
            }
        }*/
System.debug('***Validationresult:' + validationResult);
        if (applicant.Gender__c == null || applicant.Gender__c == '') {
            this.errorGender = true;
            this.errorGenderMsg = 'Error: Please select your gender.';
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*if ((applicant.Date_of_Birth__c != null || applicant.Date_of_Birth__c != '') && applicant.Date_of_Birth__c == 'ERR8') {
            this.errorDateOfBirth = true;
            this.errorDateOfBirthMsg = 'Error: The date of birth you?ve entered appears to be incorrect.';
            validationResult = false;
        } else if ((applicant.Date_of_Birth__c != null || applicant.Date_of_Birth__c != '') && applicant.Date_of_Birth__c == 'ERR6') {
            this.errorDateOfBirth = true;
            this.errorDateOfBirthMsg = 'Error: You must be at least 18 years of age to apply.';
            validationResult = false;
        } else if ((applicant.Date_of_Birth__c != null || applicant.Date_of_Birth__c != '') && applicant.Date_of_Birth__c == 'ERR7') {
            this.errorDateOfBirth = true;
            this.errorDateOfBirthMsg = 'Error: You must be less than 110 years of age to apply.';
            validationResult = false;
        } else {

        }*/
System.debug('***Validationresult:' + validationResult);
        if (applicationCountry == GEN_OriginationsConstants.NZ_REGION) {

            if (issueMonth != 'Select' || issueDate != 'Select' || (issueYear != '' && issueYear != null)) {
                if (issueMonth == 'Select' || issueDate == 'Select' || issueYear == '' || issueYear == null) {
                    this.errorIssuedate = true;
                    this.errorIssuedateMsg = 'Error: Please complete issue date.';
                    validationResult = false;
                }
            }
        }

   System.debug('***Validationresult:' + validationResult);
        if (!isStaffUi && (this.PostalFlag == null || this.PostalFlag == '')) {
            System.debug('###inPostalFlag');
            this.errorPostalFlagMsg = 'Error: Please choose Yes or No.';
            this.errorPostalFlag = true;
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (birthMonth == 'Select' || birthDate == 'Select' || (birthYear == '' || birthYear == null)) {
            this.errorDateOfBirth = true;
            this.errorDateOfBirthMsg = 'Error: Please enter your date of birth.';
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (applicant.Rel_Status__c == 'Please select') {
            this.errorRelStat = true;
            this.errorRelStatMsg = 'Error: Please select your relationship status.';
            validationResult = false;
        }
    System.debug('***Validationresult:' + validationResult);    
        if (applicant.Is_Primary_Applicant__c) {
            if (this.NoOfDeps == null || this.NoOfDeps == '') {
                this.errorNoOfDeps = true;
                this.errorNoOfDepsMsg = 'Error: Please enter the number of dependents.';
                validationResult = false;
            } else {
                if (APP_CommonExt.validatePhone('Regular', String.valueOf(this.NoOfDeps)) == false) {
                    this.errorNoOfDeps = true;
                    this.errorNoOfDepsMsg = 'Error: Invalid number.';
                    validationResult = false;
                } else {
                    applicant.No_Of_Deps__c = Integer.valueOf(NoOfDeps);
                }
            }
        }
        // Added this logic by Prakash for PMIHM-729
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*if(applicant.Drivers_Lic_No__c != null || !String.IsBlank(applicant.Drivers_Lic_No__c))
        {
            TempDrivLicence  = applicant.Drivers_Lic_No__c;
            if(TempDrivLicence.CONTAINS(' ') || applicant.Drivers_Lic_No__c == 'ERR1')
            {
            this.errorLicense = true;
            this.errorLicenseMsg = 'Error: Driving License Should Not Contain Spaces.';
            validationResult = false;
            }
              
        }*/
        System.debug('***Validationresult:' + validationResult);
        if (applicant.Drivers_Lic_Flg__c == false && applicationCountry != GEN_OriginationsConstants.NZ_REGION) {
            if (applicant.Drivers_Lic_No__c == null || applicant.Drivers_Lic_No__c == '') {
                this.errorLicense = true;
                this.errorLicenseMsg = 'Error: If you have an Australian driver' + '\'' + 's licence, please enter number here.';
                validationResult = false;
            } 
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if (applicant.Drivers_Lic_No__c == 'ERR1') {
                this.errorLicense = true;
                this.errorLicenseMsg = 'Error: Your Australian driver' + '\'' + 's licence must be less than 11 characters.';
                validationResult = false;
            } else {

            }*/
        }
        System.debug('***Validationresult:' + validationResult);
        if (applicant.Res_Status__c == 'Please select') {
            this.errorResStat = true;
            this.errorResStatMsg = 'Error: Please select residential status.';
            validationResult = false;
        }
        System.debug('***Validationresult:' + validationResult);
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*if ((applicant.Residential_Property_Name__c != null || applicant.Residential_Property_Name__c != '') && applicant.Residential_Property_Name__c == 'ERR1') {
            this.errorProperty = true;
            this.errorPropertyMsg = 'Error: Your property name must be less than 21 characters.';
            validationResult = false;
        }
        System.debug('***Validationresult:' + validationResult);
        if ((applicant.Unit_No_Res__c != null || applicant.Unit_No_Res__c != '') && applicant.Unit_No_Res__c == 'ERR1') {
            this.errorUnitNum = true;
            this.errorUnitNumMsg = 'Error: Your unit number must be less than 5 characters.';
            validationResult = false;
        }*/
        System.debug('***Validationresult:' + validationResult);
        if (applicant.Street_No_Res__c == null || applicant.Street_No_Res__c == '') {
            this.errorStreetNum = true;
            this.errorStreetNumMsg = 'Error: Please enter street number.';
            validationResult = false;
        } 
        //Updated by DYU 04-10-15 - comment-out the PRS validation
        /*else if (applicant.Street_No_Res__c == 'ERR1') {
            this.errorStreetNum = true;
            this.errorStreetNumMsg = 'Error: Your street number must be less than 7 characters.';
            validationResult = false;
        }*/
System.debug('***Validationresult:' + validationResult);
        if (applicationCountry == 'AU') {
            if (applicant.Street_Res__c == null || applicant.Street_Res__c == '') {
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Please enter street name.';
                validationResult = false;
            } 
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if (applicant.Street_Res__c == 'ERR1') {
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Your street name must be less than 16 characters.';
                validationResult = false;
            } else if (applicant.Street_Res__c == 'ERR10') {
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Numbers are not permitted in Street.';
                validationResult = false;
            }*/
            if (applicant.Suburb_Res__c == null || applicant.Suburb_Res__c == '') {
                this.errorSuburb = true;
                this.errorSuburbMsg = 'Error: Please enter suburb.';
                validationResult = false;
            }
        }
System.debug('***Validationresult:' + validationResult);
        if (applicationCountry == 'NZ') {
            if (applicant.Street_Res__c == null || applicant.Street_Res__c == '') {
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Please enter street name.';
                validationResult = false;
            }else if (validateStreet(applicant.Street_Res__c) == false) {
                system.debug('======Street Res====' + applicant.Street_Res__c);
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Only letter, numbers, hyphens, ampersand and apostrophes are permitted in street.';
                validationResult = false;
            }
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if (applicant.Street_Res__c == 'ERR1') {
                this.errorStreetName = true;
                this.errorStreetNameMsg = 'Error: Your street name must be less than 16 characters.';
                validationResult = false;
            }*/
        }
System.debug('***Validationresult:' + validationResult);
        if (applicant.Street_Type_Res__c == null || applicant.Street_Type_Res__c == '') {
            this.errorStreetType = true;
            this.errorStreetTypeMsg = 'Error: Please select street type.';
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (applicant.Suburb_Res__c != null && applicant.Suburb_Res__c != '' && validateSuburb(applicant.Suburb_Res__c, applicationCountry) == false) {
            this.errorSuburb = true;
            if (applicationCountry == 'AU')
                this.errorSuburbMsg = 'Error: Numbers are not permitted in suburb.';
            if (applicationCountry == 'NZ')
                this.errorSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (applicationCountry == 'NZ') {
            if (applicant.City_Res__c == null || applicant.City_Res__c == '') {
                this.errorCity = true;
                this.errorCityMsg = 'Error: Please enter town.';
                validationResult = false;
            } else if (validateCity(applicant.City_Res__c) == false) {
                this.errorCity = true;
                this.errorCityMsg = 'Error: Only letters, hyphens are permitted in city.';
                validationResult = false;
            } else if (applicant.City_Res__c.length() > 22) {
                system.debug('error city length: ' + applicant.City_Res__c.length());
                this.errorCity = true;
                this.errorCityMsg = 'Error: Your city must be less than 22 characters.';
                validationResult = false;
            }
        }
System.debug('***Validationresult:' + validationResult);        
        if (applicant.Postcode_Res__c == null || applicant.Postcode_Res__c == '') {
            this.errorPostcode = true;
            this.errorPostcodeMsg = 'Error: Please enter postal code.';
            validationResult = false;
        } else {
            if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Res__c))) {
                this.errorPostcode = true;
                this.errorPostcodeMsg = 'Error: Invalid postal code.';
                validationResult = false;
            }
        }
System.debug('***Validationresult:' + validationResult);        
        if (applicant.Country_Res__c == null || applicant.Country_Res__c == '') {
            this.errorCountry = true;
            this.errorCountryMsg = 'Error: Please select country.';
            validationResult = false;
        } else {
            if (applicationCountry == 'AU') {
                if (String.valueOf(applicant.Country_Res__c).toLowerCase().trim().equals('australia')) {
                    if (applicant.State_Res__c == null || applicant.State_Res__c == '') {
                        this.errorState = true;
                        this.errorStateMsg = 'Error: Please select state for Australia.';
                        validationResult = false;
                    }
                }
            }
        }
System.debug('***Validationresult:' + validationResult);
        // 12-09-2014: Modified code for DBHZL-142 Phone number validation fix - Devendra              
        if ((applicant.Mobile__c == null || applicant.Mobile__c == '') &&
            (applicant.Home__c == null || applicant.Home__c == '')) {
            this.errorMobile = true;
            this.errorHome = true;
            this.errorWork = true;
            validationResult = false;
            if (applicationCountry == 'NZ') {
                this.errorMobileMsg = 'Error: Please enter a 9-11 digit mobile phone number starting with 02.';
                this.errorHomeMsg = 'Error: Please enter a 9-digit landline phone number including area code.';
                if (applicant.Work__c != NULL && applicant.Work__c != '') {
                    if (applicant.Work__c.length() < 9 || !(applicant.Work__c.startsWith('02') || applicant.Work__c.startsWith('03') || applicant.Work__c.startsWith('04') || applicant.Work__c.startsWith('06') || applicant.Work__c.startsWith('07') || applicant.Work__c.startsWith('09'))) {
                        this.errorWorkMsg = 'Error: Please enter a 9-11 digit landline/mobile phone number';
                        validationResult = false;
                        this.errorWork = true;
                    }
                } else {
                    this.errorWork = false;
                }
            } else {
                if (applicant.Work__c != NULL && applicant.Work__c != '') {
                    validationResult = true;
                }
                this.errorMobileMsg = 'Error: Please enter a 10-digit mobile phone number starting with 04.';
                this.errorHomeMsg = 'Error: Please enter a 10-digit landline phone number including area code.';
                this.errorWorkMsg = 'Error: Please enter a 10-digit landline phone number including area code.';
            }

        } 
        /*else {
        
            if (applicationCountry == 'NZ') {
                if (applicant.Mobile__c != NULL && applicant.Mobile__c != '') {
                    if (applicant.Mobile__c.length() < 9 || !applicant.Mobile__c.startsWith('02')) {
                        this.errorMobileMsg = 'Error: Please enter a 9-11 digit mobile phone number starting with 02.';
                        validationResult = false;
                        this.errorMobile = true;
                    }
                }

                if (applicant.Home__c != NULL && applicant.Home__c != '') {
                    if (applicant.Home__c.length() < 9 || !(applicant.Home__c.startsWith('02') || applicant.Home__c.startsWith('03') || applicant.Home__c.startsWith('04') || applicant.Home__c.startsWith('06') || applicant.Home__c.startsWith('07') || applicant.Home__c.startsWith('09'))) {
                        this.errorHomeMsg = 'Error: Please enter a 9-digit landline phone number including area code.';
                        validationResult = false;
                        this.errorHome = true;
                    }
                }

                if (applicant.Work__c != NULL && applicant.Work__c != '') {
                    if (applicant.Work__c.length() < 9 || !(applicant.Work__c.startsWith('02') || applicant.Work__c.startsWith('03') || applicant.Work__c.startsWith('04') || applicant.Work__c.startsWith('06') || applicant.Work__c.startsWith('07') || applicant.Work__c.startsWith('09'))) {
                        this.errorWorkMsg = 'Error: Please enter a 9-11 digit landline/mobile phone number';
                        validationResult = false;
                        this.errorWork = true;
                    }
                }

            }
            */

            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*if (applicant.Mobile__c == 'ERR4') {
                this.errorMobile = true;
                this.errorMobileMsg = 'Error: Please enter a 10-digit mobile phone number starting with 04.';
                validationResult = false;
            } else if (applicant.Mobile__c == 'ERR1') {
                this.errorMobile = true;
                this.errorMobileMsg = 'Error: Your mobile phone number must be less than 11 characters.';
                validationResult = false;
            } else {

            }
            if (applicant.Home__c == 'ERR4') {
                this.errorHome = true;
                this.errorHomeMsg = 'Error: Please enter a 10-digit landline phone number including area code.';
                validationResult = false;
            } else if (applicant.Home__c == 'ERR1') {
                this.errorHome = true;
                this.errorHomeMsg = 'Error: Your landline phone number must be less than 11 characters.';
                validationResult = false;
            } else {

            }
            if (applicant.Work__c == 'ERR4') {
                this.errorWork = true;
                this.errorWorkMsg = 'Error: Please enter a 10-digit work phone number including area code.';
                validationResult = false;
            } else if (applicant.Work__c == 'ERR1') {
                this.errorWork = true;
                this.errorWorkMsg = 'Error: Your work phone number must be less than 11 characters.';
                validationResult = false;
            } else {

            }
        } */
System.debug('***Validationresult:' + validationResult);
        if (!isStaffUi && applicant.Is_Primary_Applicant__c && (applicant.Email_Address__c == null || applicant.Email_Address__c == '')) {
            this.errorEmail = true;
            this.errorEmailMsg = 'Error: Please enter your e-mail address.';
            validationResult = false;
        } else {
            if (applicant.Email_Address__c != null && applicant.Email_Address__c != '') {
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*if (applicant.Email_Address__c == 'ERR5') {
                    this.errorEmail = true;
                    this.errorEmailMsg = 'Error: Please enter a valid e-mail address.';
                    validationResult = false;
                } else if (applicant.Email_Address__c == 'ERR1') {
                    this.errorEmail = true;
                    this.errorEmailMsg = 'Error: Your email address must be less than 41 characters.';
                    validationResult = false;
                } else {*/
                    List < String > flagMessage = APP_CommonExt.isEmailAvailable(applicant);
                    if (flagMessage.size() > 0) {
                        System.debug('!@#flagMessage: ' + flagMessage[0]);
                        if (flagMessage[0] == 'false' && disableEmail == false) {
                            this.errorEmail = true;
                            this.errorEmailMsg = flagMessage[1];
                            validationResult = false;
                        }
                    }
                //}
            }
        }
       // Check Email and Confirm Email address 
         /***   if (applicant.Email_Address__c != null && applicant.Email_Address__c != '') {
                if(applicant.Email_Address__c != applicant.ConfirmEmailAddress__c){
                    this.errorConfirmEmail = true;
                    this.errorConfirmEmailMsg = 'Error: Email addresses do not match - please review and confirm your email address.';
                    validationResult = false;
                } 
            } ***/
        
        
        
System.debug('***Validationresult:' + validationResult);      
        if ((applicant.Years_At_Addr__c == '0' || applicant.Years_At_Addr__c == '00' || applicant.Years_At_Addr__c == '') && (applicant.Months_At_Addr__c == '0' || applicant.Months_At_Addr__c == '00' || applicant.Months_At_Addr__c == ''  )) { //Mar-18-2016- Afreen Khan - Userstroy 131 changing Picklist to free txt _______ May-05-2016 Afreen - changing months picklist to freetext
            this.errorTimeAtAddress = true;
            this.errorTimeAtAddressMsg = 'Error: Please select the time at current residential address.';
            validationResult = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (isStaffUi) {

            //05.14.15 Mike Lasala: Code Scan fix
            if ((Util.nullCheck(applicant.Residential_Property_Name__c) &&
                    applicant.Residential_Property_Name__c == applicant.Postal_Property_Name__c) &&
                (Util.nullCheck(applicant.Unit_No_Res__c) &&
                    applicant.Unit_No_Res__c == applicant.Unit_No_Pos__c) &&
                (Util.nullCheck(applicant.Street_No_Res__c) &&
                    applicant.Street_No_Res__c == applicant.Street_No_Pos__c) &&
                (Util.nullCheck(applicant.Street_Res__c) &&
                    applicant.Street_Res__c == applicant.Street_Pos__c) &&
                (Util.nullCheck(applicant.Street_Type_Res__c) &&
                    applicant.Street_Type_Res__c == applicant.Street_Type_Pos__c) &&
                (Util.nullCheck(applicant.Suburb_Res__c) &&
                    applicant.Suburb_Res__c == applicant.Suburb_Pos__c) &&
                (Util.nullCheck(applicant.Postcode_Res__c) &&
                    applicant.Postcode_Res__c == applicant.Postcode_Pos__c) &&
                (Util.nullCheck(applicant.Country_Res__c) &&
                    applicant.Country_Res__c == applicant.Country_Pos__c) &&
                (Util.nullCheck(applicant.State_Res__c) &&
                    applicant.State_Res__c == applicant.State_Pos__c)) {
                this.PostalFlag = 'Yes';
            } else {
                this.PostalFlag = 'No';
            }
        }
System.debug('***Validationresult:' + validationResult);
        if (applicant.Postcode_Pos__c != null && applicant.Postcode_Pos__c != '') {
            if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pos__c))) {
                this.errorPostalPostcode = true;
                this.errorPostalPostcodeMsg = 'Error: Invalid Postal Postcode.';
                validationResult = false;
            }
        }
        system.debug('application country: ' + applicationCountry);
System.debug('***Validationresult:' + validationResult);
        if (this.PostalFlag == 'No') {
            applicant.Postal_Addr_Flg__c = true;

        } else {
            applicant.Postal_Addr_Flg__c = false;
        }
System.debug('***Validationresult:' + validationResult);
        if (applicationCountry == 'AU') {
            if (applicant.PO_Box__c == true) {
                if (applicant.Suburb_Pos__c == null ||
                    applicant.Suburb_Pos__c == '' ||
                    applicant.Postcode_Pos__c == null ||
                    applicant.Postcode_Pos__c == '' ||
                    applicant.Country_Pos__c == '' ||
                    applicant.Country_Pos__c == null ||
                    applicant.Postal_Property_Name__c == null ||
                    applicant.Postal_Property_Name__c == '') {
                    this.errorPostalAddress = true;
                    this.errorPostalAddressMsg = 'Error: Please provide PO Box.';
                    validationResult = false;
                } else {
                    if (applicant.Country_Pos__c == 'Australia' && (applicant.State_Pos__c == '' || applicant.State_Pos__c == null)) {
                        this.errorPostalAddress = true;
                        this.errorPostalAddressMsg = 'Error: Please provide state for Australia.';
                        validationResult = false;
                    }
                }
                //if(this.PostalFlag == 'No'){
                //    applicant.Postal_Addr_Flg__c = true;

                //}else{
                //    applicant.Postal_Addr_Flg__c = false; 
                //}
    System.debug('***Validationresult:' + validationResult);            
            } else {
                if (this.PostalFlag == 'No') {
                    System.debug('in here no');
                    applicant.Postal_Addr_Flg__c = true;
                    if (applicant.Street_Pos__c == null ||
                        applicant.Street_Pos__c == '' ||
                        applicant.Street_No_Pos__c == null ||
                        applicant.Street_No_Pos__c == '' ||
                        applicant.Street_Type_Pos__c == null ||
                        applicant.Street_Type_Pos__c == '' ||
                        applicant.Suburb_Pos__c == null ||
                        applicant.Suburb_Pos__c == '' ||
                        applicant.Postcode_Pos__c == null ||
                        applicant.Postcode_Pos__c == '' ||
                        applicant.Country_Pos__c == '' ||
                        applicant.Country_Pos__c == null ||
                        (String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia') && applicant.State_Pos__c == '')) {

                        this.errorPostalAddress = true;
                        this.errorPostalAddressMsg = 'Error: Please provide postal address';
                        validationResult = false;
                        if (applicant.Street_Pos__c == null) {
                            this.errorPostalStreet = true;
                            this.errorPostalStreetMsg = 'Error: Please enter postal street.';
                            validationResult = false;
                        }
                        if (applicant.Street_No_Pos__c == null) {
                            this.errorPostalStreetNo = true;
                            this.errorPostalStreetNoMsg = 'Error: Please enter postal street number.';
                            validationResult = false;
                        }
                        if (applicant.Country_Pos__c == null) {
                            this.errorPostalCountry = true;
                            this.errorPostalCountryMsg = 'Error: Please enter postal country.';
                            validationResult = false;
                        } else {
                            if (String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia')) {
                                if (applicant.State_Pos__c == null || applicant.State_Pos__c == '') {
                                    this.errorPostalState = true;
                                    this.errorPostalStateMsg = 'Error: Please select postal state for Australia.';
                                    validationResult = false;
                                }
                            }
                        }
                        if (applicant.Street_Type_Pos__c == null) {
                            this.errorPostalStreetType = true;
                            this.errorPostalStreetTypeMsg = 'Error: Please select postal street type.';
                            validationResult = false;
                        }
                        if (applicant.Suburb_Pos__c == null || applicant.Suburb_Pos__c == '') {
                            this.errorPostalSuburb = true;
                            this.errorPostalSuburbMsg = 'Error: Please enter postal suburb.';
                            validationResult = false;
                        } else if (validateSuburb(applicant.Suburb_Pos__c, applicationCountry) == false) {
                            system.debug('suburb error:');
                            this.errorPostalSuburb = true;
                            if (applicationCountry == 'AU')
                                this.errorPostalSuburbMsg = 'Error: Numbers are not permitted in suburb.';
                            if (applicationCountry == 'NZ')
                                this.errorPostalSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
                            validationResult = false;
                        }
                        if (applicationCountry == 'NZ') {
                            if (applicant.City_Pos__c == null || applicant.City_Pos__c == '') {
                                this.errorPostalCity = true;
                                this.errorPostalCityMsg = 'Error: Please enter postal town.';
                                validationResult = false;
                            } else if (validateCity(applicant.City_Pos__c) == false) {
                                this.errorPostalCity = true;
                                this.errorPostalCityMsg = 'Error: Only letters, hyphens are permitted in city.';
                                validationResult = false;
                            }
                        }
                        if (applicant.Postcode_Pos__c == null || applicant.Postcode_Pos__c == '') {
                            this.errorPostalPostcode = true;
                            this.errorPostalPostcodeMsg = 'Error: Please enter postal postcode.';
                            validationResult = false;
                        } else {
                            if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pos__c))) {
                                this.errorPostalPostcode = true;
                                this.errorPostalPostcodeMsg = 'Error: Invalid postal postcode.';
                                validationResult = false;
                            }
                        }

                        if (util.nullCheck(applicant.Service_Delivery_Type__c)) {
                            this.errorServiceType = true;
                            this.errorServiceTypeMsg = 'Error: Please enter service type.';
                            validationResult = false;
                        } else {
                            if (applicant.Service_Delivery_Id__c == null || applicant.Service_Delivery_Id__c == '') {
                                this.errorServiceId = true;

                                String errMessage = '';
                                if (applicant.Service_Delivery_Type__c == 'Country Mail Box')
                                    errMessage = 'Error: Please enter CMB number.';
                                if (applicant.Service_Delivery_Type__c == 'Response Bag')
                                    errMessage = 'Error: Please enter response bag number.';
                                if (applicant.Service_Delivery_Type__c == 'Private Bag')
                                    errMessage = 'Error: Please enter priavate bag number.';
                                if (applicant.Service_Delivery_Type__c == 'Counter Delivery')
                                    errMessage = 'Error: Please enter counter delivery number';
                                if (applicant.Service_Delivery_Type__c == 'PO Box')
                                    errMessage = 'Error: Please enter PO Box number.';
                                this.errorServiceIdMsg = errMessage;
                                validationResult = false;
                            }
                        }
                    } else {
                        //Updated by DYU 04-10-15 - comment-out the PRS validation
                        /*if ((applicant.Unit_No_Pos__c != null || applicant.Unit_No_Pos__c != '') && applicant.Unit_No_Pos__c == 'ERR1') {
                            this.errorPostalUnitNo = true;
                            this.errorPostalUnitNoMsg = 'Error: Your unit number must be less than 5 characters.';
                            validationResult = false;
                        }
                        if (applicant.Street_No_Pos__c == 'ERR1') {
                            this.errorPostalStreetNo = true;
                            this.errorPostalStreetNoMsg = 'Error: Your street number must be less than 7 characters.';
                            validationResult = false;
                        }
                        if (applicant.Street_Pos__c == 'ERR1') {
                            this.errorPostalStreet = true;
                            this.errorPostalStreetMsg = 'Error: Your street name must be less than 16 characters.';
                            validationResult = false;
                        } else if (applicant.Street_Pos__c == 'ERR10') {
                            this.errorPostalAddress = true;
                            this.errorPostalAddressMsg = 'Error: Numbers are not permitted in street.';
                            validationResult = false;
                        }*/
                        system.debug('suburb val: ' + validateSuburb(applicant.Suburb_Pos__c, applicationCountry));
                        if (validateSuburb(applicant.Suburb_Pos__c, applicationCountry) == false) {
                            system.debug('Suburb error1:');
                            this.errorPostalSuburb = true;
                            if (applicationCountry == 'AU')
                                this.errorPostalSuburbMsg = 'Error: Numbers are not permitted in suburb.';
                            if (applicationCountry == 'NZ')
                                this.errorPostalSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
                            validationResult = false;
                        }

                        if (applicationCountry == 'NZ') {
                            if (validateCity(applicant.City_Pos__c) == false) {
                                this.errorPostalCity = true;
                                this.errorPostalCityMsg = 'Error: Only letters and hyphens are permitted in city.';
                                validationResult = false;
                            }
                        }
                        if (String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia')) {
                            if (applicant.State_Pos__c == null || applicant.State_Pos__c == '') {
                                System.debug('###inhere');
                                this.errorPostalState = true;
                                this.errorPostalStateMsg = 'Error: Please select postal state for Australia.';
                                validationResult = false;
                            }
                        }
                        //Updated by DYU 04-10-15 - comment-out the PRS validation
                        /*if ((applicant.Postal_Property_Name__c != null || applicant.Postal_Property_Name__c != '') && applicant.Postal_Property_Name__c == 'ERR1') {
                            this.errorPostalAddress = true;
                            this.errorPostalAddressMsg = 'Error: Your property name must be less than 21 characters.';
                            validationResult = false;
                        }*/ //comment out ends here for this specific block

                        /*if(!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pos__c))){
                            this.errorPostalPostcode = true;
                            this.errorPostalPostcodeMsg = 'Error: Invalid postal postcode.';
                            validationResult = false;
                        }*/
                    }
                } else if (this.PostalFlag == 'Yes') {
                    applicant.Postal_Addr_Flg__c = false;
                    System.debug('in here yes');
                    if (applicant.Country_Pos__c != null && String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia')) {
                        if (applicant.State_Pos__c == null || applicant.State_Pos__c == '') {
                            this.errorPostalState = true;
                            this.errorPostalStateMsg = 'Error: Please select postal state for Australia.';
                            validationResult = false;
                        }
                    }
                    if (applicant.Postcode_Pos__c == null || applicant.Postcode_Pos__c == '') {
                        this.errorPostalPostcode = true;
                        this.errorPostalPostcodeMsg = 'Error: Please enter postal postcode.';
                        validationResult = false;
                    }
                }
System.debug('***Validationresult:' + validationResult + '-->'+applicant.State_Pos__c);             
            }
        }
        //If country is NZ
        if (applicationCountry == 'NZ') {
            system.debug('application country2: ' + applicationCountry);
            if (applicant.Service_Delivery_Type__c != 'Residential' && applicant.Service_Delivery_Type__c != null && applicant.Service_Delivery_Type__c != '') {
                system.debug('first condition:');
                if (applicant.Country_Pos__c == null) {
                    this.errorPostalCountry = true;
                    this.errorPostalCountryMsg = 'Error: Please enter postal country.';
                    validationResult = false;
                } else {
                    if (String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia')) {
                        if (applicant.State_Pos__c == null || applicant.State_Pos__c == '') {
                            this.errorPostalState = true;
                            this.errorPostalStateMsg = 'Error: Please select postal state for Australia.';
                            validationResult = false;
                        }
                    }
                }
                // Community Mailbox and PO Box (Postal Suburb Empty Validation) removed by Adrian Recio
                if (applicant.Service_Delivery_Type__c == 'PO Box' ||
                    applicant.Service_Delivery_Type__c == 'Counter Delivery' ||
                    applicant.Service_Delivery_Type__c == 'Community Mail Box') {
                    if ((applicant.Suburb_Pos__c == null || applicant.Suburb_Pos__c == '') && 
                        applicant.Service_Delivery_Type__c != 'Community Mail Box' &&
                        applicant.Service_Delivery_Type__c != 'PO Box' ) {
                        this.errorPostalSuburb = true;
                        string errMessage = '';
                        if (applicant.Service_Delivery_Type__c == 'Counter Delivery')
                            errMessage = 'Error: Please enter post shop/post centre number.';
                        /*
                        if (applicant.Service_Delivery_Type__c == 'PO Box')
                            errMessage = 'Error: Please enter box lobby number.';
                        */
                        /*
                        if (applicant.Service_Delivery_Type__c == 'Community Mail Box')
                            errMessage = 'Error: Please enter rural delivery number.';
                        */
                        this.errorPostalSuburbMsg = errMessage;
                        validationResult = false;
                    } else if (applicant.Suburb_Pos__c != null && applicant.Suburb_Pos__c != '') {
                        if (validateSuburb(applicant.Suburb_Pos__c, applicationCountry) == false) {
                            system.debug('suburb error:');
                            this.errorPostalSuburb = true;
                            String errMessage = '';
                            if (applicant.Service_Delivery_Type__c == 'Counter Delivery')
                                errMessage = 'Error: Only letters, numbers and hyphens are permitted in post shop/post centre number.';
                            if (applicant.Service_Delivery_Type__c == 'PO Box')
                                errMessage = 'Error: Only letters, numbers and hyphens are permitted in box lobby number.';
                            if (applicant.Service_Delivery_Type__c == 'Community Mail Box')
                                errMessage = 'Error: Only letters, numbers and hyphens are permitted in rural delivery number.';
                            this.errorPostalSuburbMsg = errMessage;
                            validationResult = false;
                        }
                    }
                }

                if (applicant.City_Pos__c == null || applicant.City_Pos__c == '') {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Please enter postal town.';
                    validationResult = false;
                } else if (validateCity(applicant.City_Pos__c) == false) {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Only letters, hyphens are permitted in city.';
                    validationResult = false;
                } else if (applicant.City_Pos__c.length() > 22) {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Your city must be less than 22 characters.';
                    validationResult = false;
                }

                if (applicant.Postcode_Pos__c == null || applicant.Postcode_Pos__c == '') {
                    this.errorPostalPostcode = true;
                    this.errorPostalPostcodeMsg = 'Error: Please enter postal postcode.';
                    validationResult = false;
                } else {
                    if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pos__c))) {
                        this.errorPostalPostcode = true;
                        this.errorPostalPostcodeMsg = 'Error: Invalid postal postcode.';
                        validationResult = false;
                    }
                }

                if (applicant.Service_Delivery_Type__c == null || applicant.Service_Delivery_Type__c == '') {
                    this.errorServiceType = true;
                    this.errorServiceTypeMsg = 'Error: Please enter service type.';
                    validationResult = false;
                } else {
                    if (applicant.Service_Delivery_Id__c == null || applicant.Service_Delivery_Id__c == '') {
                        this.errorServiceId = true;
                        String errMessage = '';
                        if (applicant.Service_Delivery_Type__c == 'Community Mail Box')
                            errMessage = 'Error: Please enter CMB number.';
                        if (applicant.Service_Delivery_Type__c == 'Response Bag')
                            errMessage = 'Error: Please enter response bag number.';
                        if (applicant.Service_Delivery_Type__c == 'Private Bag')
                            errMessage = 'Error: Please enter private bag number.';
                        if (applicant.Service_Delivery_Type__c == 'Counter Delivery')
                            errMessage = 'Error: Please enter counter delivery number.';
                        if (applicant.Service_Delivery_Type__c == 'PO Box')
                            errMessage = 'Error: Please enter PO Box number.';
                        this.errorServiceIdMsg = errMessage;
                        validationResult = false;
                    }
                }

            } else {

                if (applicant.Street_Pos__c == null) {
                    this.errorPostalStreet = true;
                    this.errorPostalStreetMsg = 'Error: Please enter postal street name.';
                    validationResult = false;
                } else if (validateStreet(applicant.Street_Pos__c) == false) {
                    this.errorPostalStreet = true;
                    this.errorPostalStreetMsg = 'Error: Only letter, numbers, hyphens, ampersand and apostrophes are permitted in street.';
                    validationResult = false;
                } 
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*else if (applicant.Street_Pos__c == 'ERR1') {
                    this.errorPostalStreet = true;
                    this.errorPostalStreetMsg = 'Error: Your street name must be less than 16 characters.';
                    validationResult = false;
                }*/

                if (applicant.Street_No_Pos__c == null) {
                    this.errorPostalStreetNo = true;
                    this.errorPostalStreetNoMsg = 'Error: Please enter postal street number.';
                    validationResult = false;
                }

                if (applicant.Street_Type_Pos__c == null) {
                    this.errorPostalStreetType = true;
                    this.errorPostalStreetTypeMsg = 'Error: Please select postal street type.';
                    validationResult = false;
                }

                if (applicant.Country_Pos__c == null) {
                    this.errorPostalCountry = true;
                    this.errorPostalCountryMsg = 'Error: Please enter postal country.';
                    validationResult = false;
                } else {
                    if (String.valueOf(applicant.Country_Pos__c).toLowerCase().trim().equals('australia')) {
                        if (applicant.State_Pos__c == null || applicant.State_Pos__c == '') {
                            this.errorPostalState = true;
                            this.errorPostalStateMsg = 'Error: Please select postal state for Australia.';
                            validationResult = false;
                        }
                    }
                }

                /*if(applicant.Suburb_Pos__c == null || applicant.Suburb_Pos__c == ''){
                    this.errorPostalSuburb = true;
                    this.errorPostalSuburbMsg = 'Error: Please enter postal suburb.';
                    validationResult = false;
                }else*/
                if (applicant.Suburb_Pos__c != null && applicant.Suburb_Pos__c != '' && validateSuburb(applicant.Suburb_Pos__c, applicationCountry) == false) {
                    system.debug('suburb error NZ:');
                    this.errorPostalSuburb = true;
                    this.errorPostalSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
                    validationResult = false;
                }

                if (applicant.City_Pos__c == null || applicant.City_Pos__c == '') {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Please enter postal town.';
                    validationResult = false;
                } else if (validateCity(applicant.City_Pos__c) == false) {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Only letters, hyphens are permitted in city.';
                    validationResult = false;
                } else if (applicant.City_Pos__c.length() > 22) {
                    this.errorPostalCity = true;
                    this.errorPostalCityMsg = 'Error: Your city must be less than 22 characters.';
                    validationResult = false;
                }

                if (applicant.Postcode_Pos__c == null || applicant.Postcode_Pos__c == '') {
                    this.errorPostalPostcode = true;
                    this.errorPostalPostcodeMsg = 'Error: Please enter postal postcode.';
                    validationResult = false;
                } else {
                    if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pos__c))) {
                        this.errorPostalPostcode = true;
                        this.errorPostalPostcodeMsg = 'Error: Invalid postal postcode.';
                        validationResult = false;
                    }
                }

                if (applicant.Service_Delivery_Type__c == null || applicant.Service_Delivery_Type__c == '') {
                    this.errorServiceType = true;
                    this.errorServiceTypeMsg = 'Error: Please enter service type.';
                    validationResult = false;
                }

            }
        }

        
        if (applicationCountry == 'AU' && (((applicant.Years_At_Addr__c != null && applicant.Years_At_Addr__c != '') && Integer.valueOf(applicant.Years_At_Addr__c) < 3)) || (applicant.Years_At_Addr__c == '' && applicant.Months_At_Addr__c != '')) { // Mar-18-2016- Afreen Khan - Userstory 131 changing Picklist to free txt, UPDATED by Russell Cadapan for year at address validation @ 26/04/2016        
            
            // May-05-2016- Afreen Khan - Fix Pack 2 error message for free text months field-->   
            if(Integer.valueOf(applicant.Months_At_Addr__c) > 11 && !this.errorTimeAtAddress){
                this.errorTimeAtAddress = true;
                this.errorTimeAtAddressMsg = 'Error: Please enter a number between 0 to 11 in months field.';
                validationResult = false;
            }
            //if ((this.applicant.Years_At_Prev_Addr__c == '0' || this.applicant.Years_At_Prev_Addr__c == '00') && this.applicant.Months_At_Prev_Addr__c == '0' ) {// Mar-18-2016- Afreen Khan - Updated condition for Userstory 131 changing Picklist to free txt-->   
            if((this.applicant.Years_At_Prev_Addr__c == '0' || this.applicant.Years_At_Prev_Addr__c == '00' || this.applicant.Years_At_Prev_Addr__c == '') && (this.applicant.Months_At_Prev_Addr__c == '0' || this.applicant.Months_At_Prev_Addr__c == '00' || this.applicant.Months_At_Prev_Addr__c == ''  )){ // May-05-2016- Afreen Khan - Updated condition for Userstory 131 changing Picklist to free txt-->   
                this.errorTimePrevAtAddress = true;
                this.errorTimePrevAtAddressMsg = 'Error: Please select the time at previous residential address.';
                validationResult = false;
            }
             // May-05-2016- Afreen Khan - Fix Pack 2 error message for free text months field-->  
            if(String.isNotBlank(this.applicant.Months_At_Prev_Addr__c) && Integer.valueOf(this.applicant.Months_At_Prev_Addr__c ) > 11){
                this.errorTimePrevAtAddress = true;
                this.errorTimePrevAtAddressMsg = 'Error: Please enter a number between 0 to 11 in months field.';
                validationResult = false;
            }
    System.debug('***Validationresult:' + validationResult);        
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*if ((applicant.Unit_No_Pre__c != null || applicant.Unit_No_Pre__c != '') && applicant.Unit_No_Pre__c == 'ERR1') {
                this.errorPreviousUnitNo = true;
                this.errorPreviousUnitNoMsg = 'Error: Your unit number must be less than 5 characters.';
                validationResult = false;
            }*/
    System.debug('***Validationresult:' + validationResult);        
            if (applicant.Postcode_Pre__c == null || applicant.Postcode_Pre__c == '') {
                this.errorPreviousPostcode = true;
                this.errorPreviousPostcodeMsg = 'Error: Please enter previous postcode.';
                validationResult = false;
            } else {
                if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pre__c))) {
                    this.errorPreviousPostcode = true;
                    this.errorPreviousPostcodeMsg = 'Error: Invalid previous postcode.';
                    validationResult = false;
                }
            }
    System.debug('***Validationresult:' + validationResult);        
            if (applicant.Street_No_Pre__c == null || applicant.Street_No_Pre__c == '') {
                this.errorPreviousStreetNo = true;
                this.errorPreviousStreetNoMsg = 'Error: Please enter previous street number.';
                validationResult = false;
            } 
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if (applicant.Street_No_Pre__c == 'ERR1') {
                this.errorPreviousStreetNo = true;
                this.errorPreviousStreetNoMsg = 'Error: Your street number must be less than 7 characters.';
                validationResult = false;
            }*/
        System.debug('***Validationresult:' + validationResult);    
            if (applicationCountry == 'AU') {
                if (applicant.Street_Pre__c == null || applicant.Street_Pre__c == '') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Please enter previous street Name.';
                    validationResult = false;
                } 
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*else if (applicant.Street_Pre__c == 'ERR1') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Your street name must be less than 16 characters.';
                    validationResult = false;
                } else if (applicant.Street_Pre__c == 'ERR10') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Numbers are not permitted.';
                    validationResult = false;
                }*/
                if (applicant.Suburb_Pre__c == null || applicant.Suburb_Pre__c == '') {
                    this.errorPreviousSuburb = true;
                    this.errorPreviousSuburbMsg = 'Error: Please enter previous suburb.';
                    validationResult = false;
                }
            }
        System.debug('***Validationresult:' + validationResult);    
            if (applicationCountry == 'NZ') {
                if (applicant.Street_Pre__c == null || applicant.Street_Pre__c == '') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Please enter previous street name.';
                    validationResult = false;
                } else if (validateStreet(applicant.Street_Pre__c) == false) {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Only letter, numbers, hyphens, ampersand and apostrophes are permitted in street.';
                    validationResult = false;
                } 
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*else if (applicant.Street_Pre__c == 'ERR1') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Your street name must be less than 16 characters.';
                    validationResult = false;
                }*/
            }

            if (applicant.Street_Type_Pre__c == null || applicant.Street_Type_Pre__c == '') {
                this.errorPreviousStreetType = true;
                this.errorPreviousStreetTypeMsg = 'Error: Please enter previous street type.';
                validationResult = false;
            }
        System.debug('***Validationresult:' + validationResult);    
            if (applicant.Suburb_Pre__c != null && applicant.Suburb_Pre__c != '' && validateSuburb(applicant.Suburb_Pre__c, applicationCountry) == false) {
                this.errorPreviousSuburb = true;
                if (applicationCountry == 'AU')
                    this.errorPreviousSuburbMsg = 'Error: Numbers are not permitted in suburb.';
                if (applicationCountry == 'NZ')
                    this.errorPreviousSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
                validationResult = false;
            }
        System.debug('***Validationresult:' + validationResult);
            if (applicationCountry == 'NZ') {
                if (applicant.City_Pre__c == null || applicant.City_Pre__c == '') {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Please enter previous town.';
                    validationResult = false;
                } else if (validateCity(applicant.City_Pre__c) == false) {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Only letters and hyphens are permitted in city.';
                    validationResult = false;
                } else if (applicant.City_Pre__c.length() > 22) {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Your city must be less than 22 characters.';
                    validationResult = false;
                }
            }
        System.debug('***Validationresult:' + validationResult);    
            if (applicant.Country_Pre__c == null || applicant.Country_Pre__c == '') {
                this.errorPreviousCountry = true;
                this.errorPreviousCountryMsg = 'Error: Please enter previous country.';
                validationResult = false;
            } else {
                if (String.valueOf(applicant.Country_Pre__c).toLowerCase().trim().equals('australia')) {
                    if (applicant.State_Pre__c == null || applicant.State_Pre__c == '') {
                        this.errorPreviousState = true;
                        this.errorPreviousStateMsg = 'Error: Please select previous state for Australia.';
                        validationResult = false;
                    }
                }
            }
        System.debug('***Validationresult:' + validationResult);    
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*if ((applicant.Previous_Property_Name__c != null || applicant.Previous_Property_Name__c != '') && applicant.Previous_Property_Name__c == 'ERR1') {
                this.errorPreviousProperty = true;
                this.errorPreviousPropertyMsg = 'Error: Your property name must be less than 21 characters.';
                validationResult = false;
            }*/
        }
        //Added by DYU 05-21-2015 defect 1069 previous validation address for NZ must be less than 2 years
        else if (applicationCountry == 'NZ' && (((applicant.Years_At_Addr__c != null && applicant.Years_At_Addr__c != '') && Integer.valueOf(applicant.Years_At_Addr__c) < 2)) || (applicant.Years_At_Addr__c == '' && applicant.Months_At_Addr__c != '') ) {// Mar-17-2016- Afreen Khan - Userstory 131 changing Picklist to free txt-->     May-05-2016 - Afreen Update for changing month picklist to Free text  
            
            // May-05-2016- Afreen Khan - Fix Pack 2 error message for free text months field-->   
            if(Integer.valueOf(applicant.Months_At_Addr__c) > 11 && !this.errorTimeAtAddress){
                this.errorTimeAtAddress = true;
                this.errorTimeAtAddressMsg = 'Error: Please enter a number between 0 to 11 in months field.';
                validationResult = false;
            }
    
            if ((this.applicant.Years_At_Prev_Addr__c == '0' || this.applicant.Years_At_Prev_Addr__c == '00' || this.applicant.Years_At_Prev_Addr__c == '') && (this.applicant.Months_At_Prev_Addr__c == '0' || this.applicant.Months_At_Prev_Addr__c == '00' || this.applicant.Months_At_Prev_Addr__c == '')) {// // Mar-18-2016- Afreen Khan - Updated condition for Userstory 131 changing Picklist to free txt-->    May-05-2016 - Afreen Update for changing month picklist to Free text  
                this.errorTimePrevAtAddress = true;
                this.errorTimePrevAtAddressMsg = 'Error: Please select the time at previous residential address.';
                validationResult = false;
            }
            
             // May-05-2016- Afreen Khan - Fix Pack 2 error message for free text months field-->  
            if(String.isNotBlank(this.applicant.Months_At_Prev_Addr__c) && Integer.valueOf(this.applicant.Months_At_Prev_Addr__c ) > 11){
                this.errorTimePrevAtAddress = true;
                this.errorTimePrevAtAddressMsg = 'Error: Please enter a number between 0 to 11 in months field.';
                validationResult = false;
            }
            
            System.debug('***Validationresult:' + validationResult);        
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*if ((applicant.Unit_No_Pre__c != null || applicant.Unit_No_Pre__c != '') && applicant.Unit_No_Pre__c == 'ERR1') {
                this.errorPreviousUnitNo = true;
                this.errorPreviousUnitNoMsg = 'Error: Your unit number must be less than 5 characters.';
                validationResult = false;
            }*/
            System.debug('***Validationresult:' + validationResult);        
            if (applicant.Postcode_Pre__c == null || applicant.Postcode_Pre__c == '') {
                this.errorPreviousPostcode = true;
                this.errorPreviousPostcodeMsg = 'Error: Please enter previous postcode.';
                validationResult = false;
            } else {
                if (!APP_CommonExt.isPostcodeValid(String.valueOf(applicant.Postcode_Pre__c))) {
                    this.errorPreviousPostcode = true;
                    this.errorPreviousPostcodeMsg = 'Error: Invalid previous postcode.';
                    validationResult = false;
                }
            }
            System.debug('***Validationresult:' + validationResult);        
            if (applicant.Street_No_Pre__c == null || applicant.Street_No_Pre__c == '') {
                this.errorPreviousStreetNo = true;
                this.errorPreviousStreetNoMsg = 'Error: Please enter previous street number.';
                validationResult = false;
            } 
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if (applicant.Street_No_Pre__c == 'ERR1') {
                this.errorPreviousStreetNo = true;
                this.errorPreviousStreetNoMsg = 'Error: Your street number must be less than 7 characters.';
                validationResult = false;
            }*/
            System.debug('***Validationresult:' + validationResult);    
            if (applicationCountry == 'AU') {
                if (applicant.Street_Pre__c == null || applicant.Street_Pre__c == '') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Please enter previous street Name.';
                    validationResult = false;
                } 
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*else if (applicant.Street_Pre__c == 'ERR1') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Your street name must be less than 16 characters.';
                    validationResult = false;
                } else if (applicant.Street_Pre__c == 'ERR10') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Numbers are not permitted.';
                    validationResult = false;
                }*/
                if (applicant.Suburb_Pre__c == null || applicant.Suburb_Pre__c == '') {
                    this.errorPreviousSuburb = true;
                    this.errorPreviousSuburbMsg = 'Error: Please enter previous suburb.';
                    validationResult = false;
                }
            }
            System.debug('***Validationresult:' + validationResult);    
            if (applicationCountry == 'NZ') {
                if (applicant.Street_Pre__c == null || applicant.Street_Pre__c == '') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Please enter previous street name.';
                    validationResult = false;
                } else if (validateStreet(applicant.Street_Pre__c) == false) {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Only letter, numbers, hyphens, ampersand and apostrophes are permitted in street.';
                    validationResult = false;
                } 
                //Updated by DYU 04-10-15 - comment-out the PRS validation
                /*else if (applicant.Street_Pre__c == 'ERR1') {
                    this.errorPreviousStreet = true;
                    this.errorPreviousStreetMsg = 'Error: Your street name must be less than 16 characters.';
                    validationResult = false;
                }*/
            }

            if (applicant.Street_Type_Pre__c == null || applicant.Street_Type_Pre__c == '') {
                this.errorPreviousStreetType = true;
                this.errorPreviousStreetTypeMsg = 'Error: Please enter previous street type.';
                validationResult = false;
            }
            System.debug('***Validationresult:' + validationResult);    
            if (applicant.Suburb_Pre__c != null && applicant.Suburb_Pre__c != '' && validateSuburb(applicant.Suburb_Pre__c, applicationCountry) == false) {
                this.errorPreviousSuburb = true;
                if (applicationCountry == 'AU')
                    this.errorPreviousSuburbMsg = 'Error: Numbers are not permitted in suburb.';
                if (applicationCountry == 'NZ')
                    this.errorPreviousSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
                validationResult = false;
            }
            System.debug('***Validationresult:' + validationResult);
            if (applicationCountry == 'NZ') {
                if (applicant.City_Pre__c == null || applicant.City_Pre__c == '') {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Please enter previous town.';
                    validationResult = false;
                } else if (validateCity(applicant.City_Pre__c) == false) {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Only letters and hyphens are permitted in city.';
                    validationResult = false;
                } else if (applicant.City_Pre__c.length() > 22) {
                    this.errorPreviousCity = true;
                    this.errorPreviousCityMsg = 'Error: Your city must be less than 22 characters.';
                    validationResult = false;
                }
            }
            System.debug('***Validationresult:' + validationResult);    
            if (applicant.Country_Pre__c == null || applicant.Country_Pre__c == '') {
                this.errorPreviousCountry = true;
                this.errorPreviousCountryMsg = 'Error: Please enter previous country.';
                validationResult = false;
            } else {
                if (String.valueOf(applicant.Country_Pre__c).toLowerCase().trim().equals('australia')) {
                    if (applicant.State_Pre__c == null || applicant.State_Pre__c == '') {
                        this.errorPreviousState = true;
                        this.errorPreviousStateMsg = 'Error: Please select previous state for Australia.';
                        validationResult = false;
                    }
                }
            }
            System.debug('***Validationresult:' + validationResult);    
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*if ((applicant.Previous_Property_Name__c != null || applicant.Previous_Property_Name__c != '') && applicant.Previous_Property_Name__c == 'ERR1') {
                this.errorPreviousProperty = true;
                this.errorPreviousPropertyMsg = 'Error: Your property name must be less than 21 characters.';
                validationResult = false;
            }*/
        } else {
            applicant.Suburb_Pre__c = null;
            applicant.Street_Type_Pre__c = null;
            applicant.Street_Pre__c = null;
            applicant.Postcode_Pre__c = null;
            applicant.Unit_No_Pre__c = null;
            applicant.Street_No_Pre__c = null;
            if (applicationCountry == 'AU')
                applicant.State_Pre__c = null;
            applicant.Country_Pre__c = null;
            applicant.Previous_Property_Name__c = null;
            if (applicationCountry == 'NZ') {
                applicant.City_Pre__c = null;
            }
        }
System.debug('***Validationresult:' + validationResult);

        /** Added by Keerthan : DBHZL-81   - START**/
        //Updated by DYU 04-13-15: Defect 894: Uncomment validation on expiry dates for both 
        //personal and secondary identification
        if (applicationCountry == 'NZ' && 
            applicant.Customer_ID_Type__c != null){
                
            date issueDate;
            date expiryDate;
            issueDate = null;
            expiryDate = null;
            if (applicantwrapper.expiryYear != null && applicantwrapper.expiryYear != '' &&
                applicantwrapper.expiryMonth != null && applicantwrapper.expiryMonth != '' && applicantwrapper.expiryMonth != 'Select' &&
                applicantwrapper.expiryDate != null && applicantwrapper.expiryDate != '' && applicantwrapper.expiryDate != 'Select')
                expiryDate = date.newinstance(
                    Util.stringToInteger(applicantwrapper.expiryYear),
                    Util.stringToInteger(applicantwrapper.expiryMonth),
                    Util.stringToInteger(applicantwrapper.expiryDate)
                );
            if (applicantwrapper.issueYear != null && applicantwrapper.issueYear != '' &&
                applicantwrapper.issueMonth != null && applicantwrapper.issueMonth != '' && applicantwrapper.issueMonth != 'Select' &&
                applicantwrapper.issueDate != null && applicantwrapper.issueDate != '' && applicantwrapper.issueDate != 'Select')
                issueDate = date.newinstance(
                    Util.stringToInteger(applicantwrapper.issueYear),
                    Util.stringToInteger(applicantwrapper.issueMonth),
                    Util.stringToInteger(applicantwrapper.issueDate)
                );


            System.debug('Applicant Expiry Date :' + applicant.Expiry_Date__c);
            if(applicant.Customer_ID_Type__c != GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_BIRTH_CERTIFICATE && 
               applicant.Customer_ID_Type__c != GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_CERTIFICATE_OF_CITIZENSHIP){
            if (expiryDate == NULL) {
                this.errorExpirydate = true;
                this.errorExpirydateMsg = 'Error: Please enter expiry date.';
                validationResult = false;

            }
            else if (expiryDate <= Date.Today()) {
                this.errorExpirydate = true;
                this.errorExpirydateMsg = 'Error: The identification must expire after today.';
                validationResult = false;
            }
            }
            /*if ((applicant.Customer_ID_Type__c == 'NZ Birth Certificate' || applicant.Customer_ID_Type__c == 'NZ Certificate of Citizenship') && (applicant.Sec_ID_Expiry_Date__c == NULL)) {
                this.errorSecIDExpiryDate = true;
                this.errorSecIDExpiryDateMsg = 'Error: Please enter expiry date.';
                validationResult = false;

            }*/ 
            if ((applicant.Customer_ID_Type__c == 'NZ Birth Certificate' || applicant.Customer_ID_Type__c == 'NZ Certificate of Citizenship') && (applicant.Sec_ID_Expiry_Date__c != NULL && applicant.Sec_ID_Expiry_Date__c <= Date.Today())) {
                this.errorSecIDExpiryDate = true;
                this.errorSecIDExpiryDateMsg = 'Error: The secondary identification must expire after today.';
                validationResult = false;
            }
            /*System.debug('***applicant.ID_No__c:' + applicant.ID_No__c);
            if ((applicant.ID_No__c == NULL || applicant.ID_No__c == '') && (applicant.Customer_ID_Type__c == 'NZ Birth Certificate' || applicant.Customer_ID_Type__c == 'NZ Certificate of Citizenship')) {
                this.errorSecIDNumber = true;
                this.errorSecIDNumberMsg = 'Error: Please enter Id Number';
                validationResult = false;
            }*/

        }
        
        /** Added by Keerthan : DBHZL-81 ** -END**/
        System.debug('***Validationresult:' + validationResult);
        return validationResult;
    }

    public void executePOBox() {
        if (applicant.PO_Box__c == true) {
            applicant.Unit_No_Pos__c = null;
            applicant.Street_No_Pos__c = null;
            applicant.Street_Pos__c = null;
            applicant.Street_Type_Pos__c = null;
        }
    }

    //updated pattern to handle new zealand addresses
    public static Boolean validateSuburb(string name, String country) {
        Boolean flag = false;
        if (util.nullCheck(name)) {
            String patternName = '';
            if (country == 'AU')
                patternName = '([/^([^0-9]*)$/]+)';
            if (country == 'NZ')
                patternName = '([a-zA-Z0-9_\\- ]+)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateCity(string name) {
        Boolean flag = true;
        if (util.nullCheck(name)) {
            String patternName = '([a-zA-Z_\\- ]+)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateStreet(string name) {
        Boolean flag = true;
        if(Site.getName() != NULL && Site.getName() != '') {
          return flag;
        }
        if (util.nullCheck(name)) {
            //updated by DYU 04-15-2015 - Update pattern to include "_" for matching
            //String patternName = '([a-zA-Z0-9\\-&\' ]+)';
            String patternName = '([a-zA-Z0-9_\\-&\' ]+)';
            Pattern namePattern = Pattern.compile(patternName);

            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
            
        }
        return flag;
    }
}