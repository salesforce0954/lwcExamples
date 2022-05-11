import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import EMPLOYMENT_STATUS_FIELD from '@salesforce/schema/Applicant__c.Primary_Employment_Status__c';
import INCOME_SOURCE_FIELD from '@salesforce/schema/Income__c.Income_Source__c';
import INCOME_INTERVAL_FIELD from '@salesforce/schema/Income__c.Income_Interval__c';
import OCCUPATION_FIELD from '@salesforce/schema/Income__c.Occupation__c';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';
import INCOME_OBJECT from '@salesforce/schema/Income__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BP_LBL_Employment_Message from '@salesforce/label/c.BP_LBL_Employment_Message';

export default class LoanEmploymentDetailsJoint extends LightningElement {



    auApplicantRecordTypeId;
    auIncomeRecordTypeId;
    employmentStatusOptions;
    incomeFromOptions;
    incomeFrequencyOptions;
    occupationOptions;
    incomeInformation = [];
    showAddIncomeForm = false;
    @api employmentDetailsJointObj;
    @api isJointApplication;
    @api inputMode;
    @track copyEmploymentDetailsJointObj;
    incomeObj = {};
    @track incomeDetailsList = [];
    //hide specific fields for Pension, Child Support, Rental
    showFields = true;
    //denotes if its new or edit
    mode;

    connectedCallback() {
        this.copyEmploymentDetailsJointObj = { ...this.employmentDetailsJointObj };
        if (this.copyEmploymentDetailsJointObj.IncomeInfo !== undefined && this.copyEmploymentDetailsJointObj.IncomeInfo.length > 0) {
            this.incomeDetailsList = [...this.copyEmploymentDetailsJointObj.IncomeInfo];
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

    //FETCH Record Type Id for AU from Income Object
    @wire(getObjectInfo, { objectApiName: INCOME_OBJECT })
    handleIncomeResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {

                if (value.name === 'AU') {
                    this.auIncomeRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auApplicantRecordTypeId', fieldApiName: EMPLOYMENT_STATUS_FIELD })
    handleEmploymentStatusValues({ error, data }) {
        if (data) {
            this.employmentStatusOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$auIncomeRecordTypeId', fieldApiName: INCOME_SOURCE_FIELD })
    handleIncomeFromValues({ error, data }) {
        if (data) {
            this.incomeFromOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$auIncomeRecordTypeId', fieldApiName: INCOME_INTERVAL_FIELD })
    handleIncomeIntervalValues({ error, data }) {
        if (data) {
            this.incomeFrequencyOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$auIncomeRecordTypeId', fieldApiName: OCCUPATION_FIELD })
    handleOccupationValues({ error, data }) {
        if (data) {
            this.occupationOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    genericErrorLoadingForm() {
        this.showToast('Error', 'Error Loading Application Form. Please try after sometime.', 'error', 'pester');
    }

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

    handleAddIncome() {
        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        if (inputPicklistCorrect) {
            this.incomeObj = {};
            this.mode = 'new';
            this.showFields = true;
            this.showAddIncomeForm = true;
            //Pre populate info from quote for the first income that is being added.
            if (this.incomeDetailsList.length === 0) {
                let incomeQuote = this.copyEmploymentDetailsJointObj.IncomeQuote;;
                this.incomeObj.IncomeFrom = incomeQuote;
                if (this.copyEmploymentDetailsJointObj.OccupationQuote !== undefined) {
                    this.incomeObj.Occupation = this.copyEmploymentDetailsJointObj.OccupationQuote;
                }
                this.incomeObj.EmploymentYears = this.copyEmploymentDetailsJointObj.EmploymentYearsQuote;
                this.incomeObj.EmploymentMonths = this.copyEmploymentDetailsJointObj.EmploymentMonthsQuote;
                if (incomeQuote === 'My pension' || incomeQuote === 'My child support' || incomeQuote === 'My rental property') {
                    this.showFields = false;
                } else {
                    this.showFields = true;
                }
            }
        }
    }

    handleAddIncomeCancel() {
        this.showAddIncomeForm = false;
    }

    handleAddIncomeSave() {
        //this.copyEmploymentDetailsJointObj.LoanInfo.push(this.loanObj);

        //Run validations
        const inputFieldsCorrect = [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        //Validate if all the required fields have values and then fire an event to notify the parent 
        //component of a change in the step
        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);



        if (inputFieldsCorrect && inputPicklistCorrect) {
            if (this.mode === 'new') {
                this.incomeDetailsList = [...this.incomeDetailsList, this.incomeObj];
                this.incomeObj = {};
                this.showAddIncomeForm = false;
                this.showFields = true;
                this.mode = null;
            } else if (this.mode === 'edit') {

                let index = this.incomeObj.id;


                let indexInArray = this.incomeDetailsList.map(function (currentItem) {
                    return currentItem.id
                }).indexOf(Number(index));

                if (indexInArray !== -1) {
                    this.incomeDetailsList[indexInArray] = this.incomeObj;

                    this.incomeObj = {};
                    this.showAddIncomeForm = false;
                    this.showFields = true;
                    this.mode = null;
                }
            }
        }

    }

    handleIncomeDetailsChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;
        let icomeDetailsListLen = this.incomeDetailsList.length;

        if (fieldName === 'incomeFrom') {
            if (fieldValue === 'My pension' || fieldValue === 'My child support' || fieldValue === 'My rental property') {
                this.showFields = false;
            } else {
                this.showFields = true;
            }
            this.incomeObj.IncomeFrom = fieldValue;
        } else if (fieldName === 'incomeAmount') {
            this.incomeObj.IncomeAmount = fieldValue;
            //Set the id only during create and not when editing
            if (this.mode === 'new') {
                let entryId = icomeDetailsListLen + 1;
                //get all the Ids of objects in the list
                let incomeIdArray = this.incomeDetailsList.map(currentItem => {
                    return currentItem.id;
                });
                if (incomeIdArray.includes(entryId)) {
                    let maxId = Math.max(...incomeIdArray);
                    entryId = maxId + 1;
                }
                this.incomeObj.id = entryId;
            }
        } else if (fieldName === 'incomeFrequency') {
            this.incomeObj.IncomeFrequency = fieldValue;
        } else if (fieldName === 'occupation') {
            this.incomeObj.Occupation = fieldValue;
        } else if (fieldName === 'employerName') {
            this.incomeObj.EmployerName = fieldValue;
        } else if (fieldName === 'employerContact') {
            this.incomeObj.EmployerContact = fieldValue;
        } else if (fieldName === 'empYears') {
            this.incomeObj.EmploymentYears = fieldValue;
        } else if (fieldName === 'empMonths') {
            this.incomeObj.EmploymentMonths = fieldValue;
        }

    }

    handleIncomeDelete(event) {
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.incomeDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.incomeDetailsList.splice(indexOfObject, 1);

    }

    handleIncomeEdit(event) {
        this.mode = 'edit';
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.incomeDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));

        this.incomeObj = { ...this.incomeDetailsList[indexOfObject] };

        if (this.incomeObj.IncomeFrom === 'My pension' || this.incomeObj.IncomeFrom === 'My child support' || this.incomeObj.IncomeFrom === 'My rental property') {
            this.showFields = false;
        } else {
            this.showFields = true;
        }
        this.showAddIncomeForm = true;

    }

    get tableHasData() {
        return this.incomeDetailsList.length > 0 ? true : false;
    }

    handleEmploymentDetailsChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;
        if (fieldName === 'employmentStatus') {
            this.copyEmploymentDetailsJointObj.EmploymentStatus = fieldValue;
        } else if (fieldName === 'previousEmploymentStatus') {
            this.copyEmploymentDetailsJointObj.PreviousEmploymentStatus = fieldValue;
        } else if (fieldName === 'prevEmpYears') {
            this.copyEmploymentDetailsJointObj.PrevEmploymentYears = fieldValue;
        } else if (fieldName === 'prevEmpMonths') {
            this.copyEmploymentDetailsJointObj.PrevEmploymentMonths = fieldValue;
        }

    }

    @api handleValidationOnNext() {

        let isValid = true;
        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        if (!this.incomeDetailsList.length > 0) {
            this.showToast('Error', "Please use the 'Add Income' button to add atleast one income.", 'error', 'pester');
            isValid = false;
            return;
        }
        return (inputPicklistCorrect && isValid);
    }

    handleEmploymentDetailsNext() {

        if (this.handleValidationOnNext()) {
            this.copyEmploymentDetailsJointObj.IncomeInfo = this.incomeDetailsList;
            this.fireEmploymentDetailsNotifyEvent();

        }
    }

    fireEmploymentDetailsNotifyEvent() {
        this.dispatchEvent(new CustomEvent('employmentdetailsjointinfo', {
            detail: {
                completedStep: 'step-3',
                nextStep: 'step-4',
                employmentDetailsJoint: this.copyEmploymentDetailsJointObj
            }
        }));
    }

    handleEmploymentDetailsPrev() {
        this.dispatchEvent(new CustomEvent('employmentdetailsprev', {
            detail: {
                prevStep: 'step-2'
            }
        }));
    }

    @api getUpdatedDetails() {
        this.handleEmploymentDetailsNext();
    }

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

    /**Custom labels for fields*/
    label = {
        BP_LBL_Employment_Message
    }

}