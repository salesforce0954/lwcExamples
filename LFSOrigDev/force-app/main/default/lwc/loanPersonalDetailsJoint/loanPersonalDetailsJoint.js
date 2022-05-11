import { LightningElement, wire, api, track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getStreetTypeValues from '@salesforce/apex/PersonalDetailsController.getStreetTypeValues';
import TITLE_FIELD from '@salesforce/schema/Applicant__c.Title__c';
import GENDER_FIELD from '@salesforce/schema/Applicant__c.Gender__c';
import RELATIONSHIP_STATUS_FIELD from '@salesforce/schema/Applicant__c.Rel_Status__c';
import { getDayValues } from './personalDetailsJointUtility';
import { getMonthValues } from './personalDetailsJointUtility';
import { getStateValues } from './personalDetailsJointUtility';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BP_LBL_Picklist_Error from '@salesforce/label/c.BP_LBL_Picklist_Error';




export default class LoanPersonalDetailsJoint extends LightningElement {

    connectedCallback() {
        this.copyPersonalDetailsJointObj = { ...this.personalDetailsJointObj };
        //Set Residential Address Local field values
        this.resUnitNumber_local = this.personalDetailsJointObj.ResidentialUnitNumber;
        this.resStreetNumber_local = this.personalDetailsJointObj.ResidentialStreetNumber;
        this.resStreet_local = this.personalDetailsJointObj.ResidentialStreet;
        this.resStreetType_local = this.personalDetailsJointObj.ResidentialStreetType;
        this.resSuburb_local = this.personalDetailsJointObj.ResidentialSuburb;
        this.resState_local = this.personalDetailsJointObj.ResidentialState;
        this.resPostcode_local = this.personalDetailsJointObj.ResidentialPostcode;
        this.resPropName_local = this.personalDetailsJointObj.ResidentialPropName;

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
    //Used to show & hide previous address search
    streetTypeOptions = [];
    emailAddressValue;
    addressListFound = false;
    @track personalDetails;

    @api personalDetailsJointObj;
    @api personalDetailsObj;
    @api isJointApplication;
    @api inputMode;
    @track copyPersonalDetailsJointObj;
    showTitleWarning = false;

    resUnitNumber_local;
    resStreetNumber_local;
    resStreet_local;
    resStreetType_local;
    resSuburb_local;
    resState_local;
    resPostcode_local;
    resPropName_local;


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
        if (this.copyPersonalDetailsJointObj.NoDL) {
            return false;
        } else {
            return true;
        }
    }

    get showPreviousAddressSearch() {
        if (this.copyPersonalDetailsJointObj.ResidentialYears < 3) {
            return true;
        } else {
            return false;
        }
    }

    get showPostalAddressSearch() {
        if (this.copyPersonalDetailsJointObj.IsPostalAddSameAsRes !== undefined &&
            this.copyPersonalDetailsJointObj.IsPostalAddSameAsRes) {
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

    //Capture all the details entered on the Personal details form
    handlePersonalDetailsChange(event) {

        let fieldName = event.target.name;
        let fieldValue = event.target.value;


        if (fieldName === 'title') {
            this.copyPersonalDetailsJointObj.Title = fieldValue;
            this.showTitleWarning = true;
        } else if (fieldName === 'firstName') {
            this.copyPersonalDetailsJointObj.FirstName = fieldValue;
        } else if (fieldName === 'middleName') {
            this.copyPersonalDetailsJointObj.MiddleName = fieldValue;
        } else if (fieldName === 'lastName') {
            this.copyPersonalDetailsJointObj.LastName = fieldValue;
        } else if (fieldName === 'gender') {
            this.copyPersonalDetailsJointObj.Gender = fieldValue;
        } else if (fieldName === 'dayOfBirth') {
            this.copyPersonalDetailsJointObj.dobDay = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'monthOfBirth') {
            this.copyPersonalDetailsJointObj.dobMonth = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'yearOfBirth') {
            this.copyPersonalDetailsJointObj.dobYear = fieldValue;
            this.checkIfAgeValid();
        } else if (fieldName === 'relationshipStatus') {
            this.copyPersonalDetailsJointObj.RelationshipStatus = fieldValue
        } else if (fieldName === 'numberOfDependants') {
            this.copyPersonalDetailsJointObj.Dependents = fieldValue;
        } else if (fieldName === 'dlNumber') {
            this.copyPersonalDetailsJointObj.DLNumber = fieldValue;
        } else if (fieldName === 'dontHaveDl') {
            if (event.target.checked) {
                this.copyPersonalDetailsJointObj.NoDL = true;
            } else {
                this.copyPersonalDetailsJointObj.NoDL = false;
            }
        } else if (fieldName === 'residentialAddress') {
            this.copyPersonalDetailsJointObj.ResidentialAddress = fieldValue;
        }
        else if (fieldName === 'resUnitNumber') {
            this.copyPersonalDetailsJointObj.ResidentialUnitNumber = fieldValue;
            this.resUnitNumber_local = fieldValue;
        } else if (fieldName === 'resStreetNumber') {
            this.copyPersonalDetailsJointObj.ResidentialStreetNumber = fieldValue;
            this.resStreetNumber_local = fieldValue;
        } else if (fieldName === 'resStreet') {
            this.copyPersonalDetailsJointObj.ResidentialStreet = fieldValue;
            this.resStreet_local = fieldValue;
        } else if (fieldName === 'resStreetType') {
            this.copyPersonalDetailsJointObj.ResidentialStreetType = fieldValue;
            this.resStreetType_local = fieldValue;
        } else if (fieldName === 'resSuburb') {
            this.copyPersonalDetailsJointObj.ResidentialSuburb = fieldValue;
            this.resSuburb_local = fieldValue;
        } else if (fieldName === 'resState') {
            this.copyPersonalDetailsJointObj.ResidentialState = fieldValue;
            this.resState_local = fieldValue;
        } else if (fieldName === 'resPostcode') {
            this.copyPersonalDetailsJointObj.ResidentialPostcode = fieldValue;
            this.resPostcode_local = fieldValue;
        } else if (fieldName === 'resPropertyName') {
            this.copyPersonalDetailsJointObj.ResidentialPropName = fieldValue;
            this.resPropName_local = fieldValue;
        } else if (fieldName === 'resYears') {
            this.copyPersonalDetailsJointObj.ResidentialYears = fieldValue;
        } else if (fieldName === 'resMonths') {
            this.copyPersonalDetailsJointObj.ResidentialMonths = fieldValue;
        } else if (fieldName === 'prevResAddress') {
            this.copyPersonalDetailsJointObj.PreviousAddress = fieldValue;
        } else if (fieldName === 'prevUnitNumber') {
            this.copyPersonalDetailsJointObj.PrevUnitNumber = fieldValue;
        } else if (fieldName === 'prevStreetNumber') {
            this.copyPersonalDetailsJointObj.PrevStreetNumber = fieldValue;
        } else if (fieldName === 'prevStreet') {
            this.copyPersonalDetailsJointObj.PrevStreet = fieldValue;
        } else if (fieldName === 'prevStreetType') {
            this.copyPersonalDetailsJointObj.PrevStreetType = fieldValue;
        } else if (fieldName === 'prevSuburb') {
            this.copyPersonalDetailsJointObj.PrevSuburb = fieldValue;
        } else if (fieldName === 'prevState') {
            this.copyPersonalDetailsJointObj.PrevState = fieldValue;
        } else if (fieldName === 'prevPostcode') {
            this.copyPersonalDetailsJointObj.PrevPostcode = fieldValue;
        } else if (fieldName === 'prevProperty') {
            this.copyPersonalDetailsJointObj.PrevProperty = fieldValue;
        } else if (fieldName === 'prevYears') {
            this.copyPersonalDetailsJointObj.PrevYears = fieldValue;
        } else if (fieldName === 'prevMonths') {
            this.copyPersonalDetailsJointObj.PrevMonths = fieldValue;
        } else if (fieldName === 'isPostalSameRes') {
            this.copyPersonalDetailsJointObj.IsPostalAddSameAsRes = event.target.checked;
        } else if (fieldName === 'posAddress') {
            this.copyPersonalDetailsJointObj.PostalAddress = fieldValue;
        } else if (fieldName === 'posUnitNumber') {
            this.copyPersonalDetailsJointObj.PosUnitNumber = fieldValue;
        } else if (fieldName === 'posStreetNumber') {
            this.copyPersonalDetailsJointObj.PosStreetNumber = fieldValue;
        } else if (fieldName === 'posStreet') {
            this.copyPersonalDetailsJointObj.PosStreet = fieldValue;
        } else if (fieldName === 'posStreetType') {
            this.copyPersonalDetailsJointObj.PosStreetType = fieldValue;
        } else if (fieldName === 'posSuburb') {
            this.copyPersonalDetailsJointObj.PosSuburb = fieldValue;
        } else if (fieldName === 'posState') {
            this.copyPersonalDetailsJointObj.PosState = fieldValue;
        } else if (fieldName === 'posPostcode') {
            this.copyPersonalDetailsJointObj.PosPostcode = fieldValue;
        } else if (fieldName === 'posPropertyName') {
            this.copyPersonalDetailsJointObj.PosPropertyName = fieldValue;
        } else if (fieldName === 'emailAddress') {
            this.copyPersonalDetailsJointObj.Email = fieldValue;
        } else if (fieldName === 'mobileNumber') {
            this.copyPersonalDetailsJointObj.MobileNumber = fieldValue;
        } else if (fieldName === 'workNumber') {
            this.copyPersonalDetailsJointObj.WorkNumber = fieldValue;
        } else if (fieldName === 'homeNumber') {
            this.copyPersonalDetailsJointObj.HomeNumber = fieldValue;
        }

        //TODO : concatenate date of birth fields
        //this.primaryApplicantDetails.personalDetails = personalDetailsObj;


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
        let emailProvided = this.copyPersonalDetailsJointObj.Email;

        if (event.target.value !== emailProvided) {


            let confirmEmailTextbox = this.template.querySelector('.confirmEmail');
            confirmEmailTextbox.setCustomValidity("Email addresses do not match - please review and confirm your email address");
            confirmEmailTextbox.reportValidity();
        } else {
            let confirmEmailTextbox = this.template.querySelector('.confirmEmail');
            confirmEmailTextbox.setCustomValidity("");
            confirmEmailTextbox.reportValidity();
            //Set Confirm Email value in Object
            this.copyPersonalDetailsJointObj.ConfirmEmail = event.target.value;
        }
    }

    checkIfAgeValid() {
        let day = this.copyPersonalDetailsJointObj.dobDay;
        let month = this.copyPersonalDetailsJointObj.dobMonth;
        let year = this.copyPersonalDetailsJointObj.dobYear;
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
        return (inputFieldsCorrect && inputPicklistCorrect && isDobValid);
    }

    handlePersonalDetailsNext() {
        if (this.handleValidationOnNext()) {
            //Form DOB
            let dobDay = this.copyPersonalDetailsJointObj.dobDay;
            let dobMonth = this.copyPersonalDetailsJointObj.dobMonth;
            let dobYear = this.copyPersonalDetailsJointObj.dobYear;
            if (dobDay !== null && dobMonth !== null && dobYear !== null) {
                this.copyPersonalDetailsJointObj.DateOfBirth = dobDay + '/' + dobMonth + '/' + dobYear;
            }
            //Check if postal address same as residential value present, if yes, ignore, else set it to true.
            if (!('IsPostalAddSameAsRes' in this.copyPersonalDetailsJointObj)) {
                this.copyPersonalDetailsJointObj.IsPostalAddSameAsRes = true;;
            }

            this.firePersonalDetailsNotifyEvent();
        }
    }

    firePersonalDetailsNotifyEvent() {

        //this.dispatchEvent(new CustomEvent('notifystepinfo', { detail: this.primaryApplicantDetails }));
        this.dispatchEvent(new CustomEvent('personaldetailsjointinfo', {
            detail: {
                completedStep: 'step-2',
                nextStep: 'step-3',
                personalDetailsJoint: this.copyPersonalDetailsJointObj
            }
        }));
    }

    searchAddress(event) {
        this.addressListFound = true;
    }

    validateDOBFields() {
        let dob_MonthCheck = false;
        let dob_YearCheck = false;
        if (this.copyPersonalDetailsJointObj.dobMonth === undefined || this.copyPersonalDetailsJointObj.dobMonth === null ||
            this.copyPersonalDetailsJointObj.dobMonth === '') {
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

        if (this.copyPersonalDetailsJointObj.dobYear === undefined || this.copyPersonalDetailsJointObj.dobYear === null ||
            this.copyPersonalDetailsJointObj.dobYear === '') {
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

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

    handleCopyResAddress() {

        //Set details in local variables
        this.resUnitNumber_local = this.personalDetailsObj.ResidentialUnitNumber;
        this.resStreetNumber_local = this.personalDetailsObj.ResidentialStreetNumber;
        this.resStreet_local = this.personalDetailsObj.ResidentialStreet;
        this.resStreetType_local = this.personalDetailsObj.ResidentialStreetType;
        this.resSuburb_local = this.personalDetailsObj.ResidentialSuburb;
        this.resState_local = this.personalDetailsObj.ResidentialState;
        this.resPostcode_local = this.personalDetailsObj.ResidentialPostcode;
        this.resPropName_local = this.personalDetailsObj.ResidentialPropName;
        //Set details in the main object
        this.copyPersonalDetailsJointObj.ResidentialUnitNumber = this.personalDetailsObj.ResidentialUnitNumber;
        this.copyPersonalDetailsJointObj.ResidentialStreetNumber = this.personalDetailsObj.ResidentialStreetNumber;
        this.copyPersonalDetailsJointObj.ResidentialStreet = this.personalDetailsObj.ResidentialStreet;
        this.copyPersonalDetailsJointObj.ResidentialStreetType = this.personalDetailsObj.ResidentialStreetType;
        this.copyPersonalDetailsJointObj.ResidentialSuburb = this.personalDetailsObj.ResidentialSuburb;
        this.copyPersonalDetailsJointObj.ResidentialState = this.personalDetailsObj.ResidentialState;
        this.copyPersonalDetailsJointObj.ResidentialPostcode = this.personalDetailsObj.ResidentialPostcode;
        this.copyPersonalDetailsJointObj.ResidentialPropName = this.personalDetailsObj.ResidentialPropName;
    }


}