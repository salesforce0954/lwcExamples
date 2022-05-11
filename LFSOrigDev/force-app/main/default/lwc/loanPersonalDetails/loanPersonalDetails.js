import { LightningElement, wire, api, track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getStreetTypeValues from '@salesforce/apex/PersonalDetailsController.getStreetTypeValues';
import TITLE_FIELD from '@salesforce/schema/Applicant__c.Title__c';
import GENDER_FIELD from '@salesforce/schema/Applicant__c.Gender__c';
import RELATIONSHIP_STATUS_FIELD from '@salesforce/schema/Applicant__c.Rel_Status__c';
import { getDayValues } from './personalDetailsUtility';
import { getMonthValues } from './personalDetailsUtility';
import { getStateValues } from './personalDetailsUtility';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BP_LBL_Picklist_Error from '@salesforce/label/c.BP_LBL_Picklist_Error';





export default class LoanPersonalDetails extends LightningElement {

    connectedCallback() {

        this.copyPersonalDetailsObj = { ...this.personalDetailsObj };
        //This is needed if the user scrolls down during page load and you want to make sure the page is scrolled to the top once it's fully loaded. This has Cross-browser support.
        window.scrollTo(0, 0);
    }



    auApplicantRecordTypeId;
    titleOptions;
    genderOptions;
    relationshipStatusOptions;
    showResAddressDetails = false;
    showPrevAddressDetails = false;
    showPostalAddressDetails = false;
    streetTypeOptions = [];
    emailAddressValue;
    addressListFound = false;
    @track personalDetails;

    @api personalDetailsObj;
    @api isJointApplication;
    @api inputMode;
    @track copyPersonalDetailsObj;
    showTitleWarning = false;




    get stateOptions() {
        return getStateValues();
    }

    get dayoptions() {
        return getDayValues();
    }

    get monthoptions() {
        return getMonthValues();
    }

    get showDLTextbox() {
        if (this.copyPersonalDetailsObj.NoDL) {
            return false;
        } else {
            return true;
        }
    }

    get showPreviousAddressSearch() {
        if (this.copyPersonalDetailsObj.ResidentialYears < 3) {
            return true;
        } else {
            return false;
        }
    }

    get showPostalAddressSearch() {
        if (this.copyPersonalDetailsObj.IsPostalAddSameAsRes !== undefined &&
            this.copyPersonalDetailsObj.IsPostalAddSameAsRes) {
            return false;
        } else {
            return true;
        }
    }

    //FETCH Record Type Id for AU from Applicant Object
    @wire(getObjectInfo, { objectApiName: APPLICANT_OBJECT })
    handleResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {
                if (value.name === 'AU') {
                    this.auApplicantRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    // FETCH PICKLIST VALUES : START

    @wire(getPicklistValues, { recordTypeId: '$auApplicantRecordTypeId', fieldApiName: TITLE_FIELD })
    handleTitleValues({ error, data }) {
        if (data) {
            this.titleOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auApplicantRecordTypeId', fieldApiName: GENDER_FIELD })
    handleGenderValues({ error, data }) {
        if (data) {
            this.genderOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auApplicantRecordTypeId', fieldApiName: RELATIONSHIP_STATUS_FIELD })
    handleRelationshipValues({ error, data }) {
        if (data) {
            this.relationshipStatusOptions = data.values
            this.fetchStreetTypeValues();
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }



    // FETCH PICKLIST VALUES : END

    /* Generic event for showing a toast message
       on the page.
    */
    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }

    genericErrorLoadingForm() {
        this.showToast('Error', BP_LBL_Picklist_Error, 'error', 'pester');
    }

    //Handle when a click is registered on 'Enter Manually' for Res, Prev & Postal address
    handleManualAddressClick(event) {
        let fieldName = event.target.name;
        if (fieldName === 'resAddressManualEntry') {
            this.showResAddressDetails = !this.showResAddressDetails;
        } else if (fieldName === 'prevAddressManualEntry') {
            this.showPrevAddressDetails = !this.showPrevAddressDetails;
        } else if (fieldName === 'postAddressManualEntry') {
            this.showPostalAddressDetails = !this.showPostalAddressDetails;
        }

    }

    handleShowWarning(event) {
        let fieldName = event.target.name;
        let warningFieldName = '.' + fieldName + '_warning';

        if(this.template.querySelector(warningFieldName).style.display == "none") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }

        if (fieldName === 'dontHaveDl') {       
            if (event.target.checked) {
                this.copyPersonalDetailsObj.NoDL = true;
            } else {
                this.copyPersonalDetailsObj.NoDL = false;
            }
        }
    }

    //Capture all the details entered on the Personal details form
    handlePersonalDetailsChange(event) {

        let fieldName = event.target.name;
        let fieldValue = event.target.value;


        if (fieldName === 'title') {
            this.copyPersonalDetailsObj.Title = fieldValue;
            this.showTitleWarning = true;
        } else if (fieldName === 'firstName') {
            this.copyPersonalDetailsObj.FirstName = fieldValue;
        } else if (fieldName === 'middleName') {
            this.copyPersonalDetailsObj.MiddleName = fieldValue;
        } else if (fieldName === 'lastName') {
            this.copyPersonalDetailsObj.LastName = fieldValue;
        } else if (fieldName === 'gender') {
            this.copyPersonalDetailsObj.Gender = fieldValue;
        } else if (fieldName === 'dayOfBirth') {
            this.copyPersonalDetailsObj.dobDay = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'monthOfBirth') {
            this.copyPersonalDetailsObj.dobMonth = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'yearOfBirth') {
            this.copyPersonalDetailsObj.dobYear = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'relationshipStatus') {
            this.copyPersonalDetailsObj.RelationshipStatus = fieldValue
        } else if (fieldName === 'numberOfDependants') {
            this.copyPersonalDetailsObj.Dependents = fieldValue;
        } else if (fieldName === 'dlNumber') {
            this.copyPersonalDetailsObj.DLNumber = fieldValue;
        } else if (fieldName === 'residentialAddress') {
            this.copyPersonalDetailsObj.ResidentialAddress = fieldValue;
        }
        else if (fieldName === 'resUnitNumber') {
            this.copyPersonalDetailsObj.ResidentialUnitNumber = fieldValue;
        } else if (fieldName === 'resStreetNumber') {
            this.copyPersonalDetailsObj.ResidentialStreetNumber = fieldValue;
        } else if (fieldName === 'resStreet') {
            this.copyPersonalDetailsObj.ResidentialStreet = fieldValue;
        } else if (fieldName === 'resStreetType') {
            this.copyPersonalDetailsObj.ResidentialStreetType = fieldValue;
        } else if (fieldName === 'resSuburb') {
            this.copyPersonalDetailsObj.ResidentialSuburb = fieldValue;
        } else if (fieldName === 'resState') {
            this.copyPersonalDetailsObj.ResidentialState = fieldValue;
        } else if (fieldName === 'resPostcode') {
            this.copyPersonalDetailsObj.ResidentialPostcode = fieldValue;
        } else if (fieldName === 'resPropertyName') {
            this.copyPersonalDetailsObj.ResidentialPropName = fieldValue;
        } else if (fieldName === 'resYears') {
            this.copyPersonalDetailsObj.ResidentialYears = fieldValue;
        } else if (fieldName === 'resMonths') {
            this.copyPersonalDetailsObj.ResidentialMonths = fieldValue;
        } else if (fieldName === 'prevResAddress') {
            this.copyPersonalDetailsObj.PreviousAddress = fieldValue;
        } else if (fieldName === 'prevUnitNumber') {
            this.copyPersonalDetailsObj.PrevUnitNumber = fieldValue;
        } else if (fieldName === 'prevStreetNumber') {
            this.copyPersonalDetailsObj.PrevStreetNumber = fieldValue;
        } else if (fieldName === 'prevStreet') {
            this.copyPersonalDetailsObj.PrevStreet = fieldValue;
        } else if (fieldName === 'prevStreetType') {
            this.copyPersonalDetailsObj.PrevStreetType = fieldValue;
        } else if (fieldName === 'prevSuburb') {
            this.copyPersonalDetailsObj.PrevSuburb = fieldValue;
        } else if (fieldName === 'prevState') {
            this.copyPersonalDetailsObj.PrevState = fieldValue;
        } else if (fieldName === 'prevPostcode') {
            this.copyPersonalDetailsObj.PrevPostcode = fieldValue;
        } else if (fieldName === 'prevProperty') {
            this.copyPersonalDetailsObj.PrevProperty = fieldValue;
        } else if (fieldName === 'prevYears') {
            this.copyPersonalDetailsObj.PrevYears = fieldValue;
        } else if (fieldName === 'prevMonths') {
            this.copyPersonalDetailsObj.PrevMonths = fieldValue;
        } else if (fieldName === 'isPostalSameRes') {
            this.copyPersonalDetailsObj.IsPostalAddSameAsRes = event.target.checked;
        } else if (fieldName === 'posAddress') {
            this.copyPersonalDetailsObj.PostalAddress = fieldValue;
        } else if (fieldName === 'posUnitNumber') {
            this.copyPersonalDetailsObj.PosUnitNumber = fieldValue;
        } else if (fieldName === 'posStreetNumber') {
            this.copyPersonalDetailsObj.PosStreetNumber = fieldValue;
        } else if (fieldName === 'posStreet') {
            this.copyPersonalDetailsObj.PosStreet = fieldValue;
        } else if (fieldName === 'posStreetType') {
            this.copyPersonalDetailsObj.PosStreetType = fieldValue;
        } else if (fieldName === 'posSuburb') {
            this.copyPersonalDetailsObj.PosSuburb = fieldValue;
        } else if (fieldName === 'posState') {
            this.copyPersonalDetailsObj.PosState = fieldValue;
        } else if (fieldName === 'posPostcode') {
            this.copyPersonalDetailsObj.PosPostcode = fieldValue;
        } else if (fieldName === 'posPropertyName') {
            this.copyPersonalDetailsObj.PosPropertyName = fieldValue;
        } else if (fieldName === 'emailAddress') {
            this.copyPersonalDetailsObj.Email = fieldValue;
        } else if (fieldName === 'mobileNumber') {
            this.copyPersonalDetailsObj.MobileNumber = fieldValue;
        } else if (fieldName === 'workNumber') {
            this.copyPersonalDetailsObj.WorkNumber = fieldValue;
        } else if (fieldName === 'homeNumber') {
            this.copyPersonalDetailsObj.HomeNumber = fieldValue;
        }

        //TODO : concatenate date of birth fields
        //this.primaryApplicantDetails.personalDetails = personalDetailsObj;

        //remove warning
        let warningFieldName = '.' + fieldName + '_warning';
        if(this.template.querySelector(warningFieldName) != null && this.template.querySelector(warningFieldName).style.display == "") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }
    }

    fetchStreetTypeValues() {
        getStreetTypeValues()
            .then(result => {
                this.streetTypeOptions = result;
            })
            .catch(error => {
                this.genericErrorLoadingForm();
            })
    }

    handleConfirmEmailChange(event) {
        let emailProvided = this.copyPersonalDetailsObj.Email;
        if (event.target.value !== emailProvided) {
            let confirmEmailTextbox = this.template.querySelector('.confirmEmail');
            confirmEmailTextbox.setCustomValidity("Email addresses do not match - please review and confirm your email address");
            confirmEmailTextbox.reportValidity();
        } else {
            let confirmEmailTextbox = this.template.querySelector('.confirmEmail');
            confirmEmailTextbox.setCustomValidity("");
            confirmEmailTextbox.reportValidity();
            //Set Confirm Email value in Object
            this.copyPersonalDetailsObj.ConfirmEmail = event.target.value;
        }
    }

    checkIfAgeValid() {
        let day = this.copyPersonalDetailsObj.dobDay;
        let month = this.copyPersonalDetailsObj.dobMonth;
        let year = this.copyPersonalDetailsObj.dobYear;
        let yearOfBirthTextbox = this.template.querySelector('.yobirth');
        if (day !== undefined && month !== undefined && year !== undefined) {
            //check if date is valid e.g 31st June is INVALID
            if (this.checkIfDateValid(Number(year), Number(month) - 1, Number(day))) {

                var birthDate = new Date(Number(year), Number(month) - 1, Number(day));
                var today = new Date();
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();

                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
            } else {
                return false;
            }
        }
        if (age >= 18) {
            yearOfBirthTextbox.setCustomValidity("");
            yearOfBirthTextbox.reportValidity();
            return true;
        } else {
            yearOfBirthTextbox.setCustomValidity("Applicant must be over 18 years old.");
            yearOfBirthTextbox.reportValidity();
            return false;
        }

    }

    checkIfDateValid(year, month, day) {
        let yearOfBirthTextbox = this.template.querySelector('.yobirth');
        let d = new Date(year, month, day);
        if (d.getFullYear() == year && d.getMonth() == month && d.getDate() == day) {
            yearOfBirthTextbox.setCustomValidity("");
            yearOfBirthTextbox.reportValidity();
            return true;
        } else {
            yearOfBirthTextbox.setCustomValidity("Invalid date entered.");
            yearOfBirthTextbox.reportValidity();
            return false;
        }
    }

    @api handleValidationOnNext() {

        const inputFieldsCorrect = [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        //Validate if all the required fields have values and then fire an event to notify the parent 
        //component of a change in the step

        const isDobValid = this.validateDOBFields();

        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        return (inputFieldsCorrect && inputPicklistCorrect && isDobValid)
    }

    handlePersonalDetailsNext() {
        if (this.handleValidationOnNext()) {
            //Form DOB
            let dobDay = this.copyPersonalDetailsObj.dobDay;
            let dobMonth = this.copyPersonalDetailsObj.dobMonth;
            let dobYear = this.copyPersonalDetailsObj.dobYear;
            if (dobDay !== null && dobMonth !== null && dobYear !== null) {
                this.copyPersonalDetailsObj.DateOfBirth = dobDay + '/' + dobMonth + '/' + dobYear;
            }
            //Check if postal address same as residential value present, if yes, ignore, else set it to true.
            if (!('IsPostalAddSameAsRes' in this.copyPersonalDetailsObj)) {
                this.copyPersonalDetailsObj.IsPostalAddSameAsRes = true;;
            }
            this.firePersonalDetailsNotifyEvent();
        }

    }

    firePersonalDetailsNotifyEvent() {

        //this.dispatchEvent(new CustomEvent('notifystepinfo', { detail: this.primaryApplicantDetails }));
        this.dispatchEvent(new CustomEvent('personaldetailsinfo', {
            detail: {
                completedStep: 'step-2',
                nextStep: 'step-3',
                personalDetails: this.copyPersonalDetailsObj
            }
        }));
    }

    validateDOBFields() {
        let dob_MonthCheck = false;
        let dob_YearCheck = false;
        if (this.copyPersonalDetailsObj.dobMonth === undefined || this.copyPersonalDetailsObj.dobMonth === null ||
            this.copyPersonalDetailsObj.dobMonth === '') {
            let monthCombobox = this.template.querySelector('.mobirth');
            monthCombobox.setCustomValidity("Please complete this field");
            monthCombobox.reportValidity();
            dob_MonthCheck = false;
            window.scrollTo(0, 0);
        } else {
            let monthCombobox = this.template.querySelector('.mobirth');
            monthCombobox.setCustomValidity("");
            monthCombobox.reportValidity();
            dob_MonthCheck = true;
        }

        if (this.copyPersonalDetailsObj.dobYear === undefined || this.copyPersonalDetailsObj.dobYear === null ||
            this.copyPersonalDetailsObj.dobYear === '') {
            let yearTextbox = this.template.querySelector('.yobirth');
            yearTextbox.setCustomValidity("Please complete this field");
            yearTextbox.reportValidity();
            dob_YearCheck = false;
            window.scrollTo(0, 0);
        } else {
            let yearTextbox = this.template.querySelector('.yobirth');
            yearTextbox.setCustomValidity("");
            yearTextbox.reportValidity();
            dob_YearCheck = true;
        }

        return (dob_MonthCheck && dob_YearCheck && this.checkIfAgeValid());

    }

    searchAddress(event) {
        this.addressListFound = true;
    }

    handlePersonalDetailsPrev() {
        this.dispatchEvent(new CustomEvent('personaldetailsprev', {
            detail: {
                prevStep: 'step-1'
            }
        }));
    }

    //Prevents paste of data in the Confirm Email textbox
    handleConfirmEmailPaste(event) {
        event.preventDefault();
    }

    @api getUpdatedDetails() {

        this.handlePersonalDetailsNext();
    }

    handleGoToJointApplicant() {
        //Before navigating to the next tab, validate all the details on the current tab
        if (this.handleValidationOnNext()) {
            //Form DOB
            let dobDay = this.copyPersonalDetailsObj.dobDay;
            let dobMonth = this.copyPersonalDetailsObj.dobMonth;
            let dobYear = this.copyPersonalDetailsObj.dobYear;
            if (dobDay !== null && dobMonth !== null && dobYear !== null) {
                this.copyPersonalDetailsObj.DateOfBirth = dobDay + '/' + dobMonth + '/' + dobYear;
            }
            //Check if postal address same as residential value present, if yes, ignore, else set it to true.
            if (!('IsPostalAddSameAsRes' in this.copyPersonalDetailsObj)) {
                this.copyPersonalDetailsObj.IsPostalAddSameAsRes = true;;
            }
            this.firePersonalDetailsNotifyEvent();
            //navigate to next tab
            this.dispatchEvent(new CustomEvent('navigatejointdetails'));
        }

    }

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

}