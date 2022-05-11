import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import EXPENSE_OBJECT from '@salesforce/schema/Expense__c';
import RESIDENTIAL_STATUS_FIELD from '@salesforce/schema/Applicant__c.Res_Status__c';
import LIVING_EXPENSE_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Living_Exp_Int__c';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';

export default class LoanExpenseDetailsJoint extends LightningElement {

    auApplicantRecordTypeId;
    residentialStatusOptions;
    expenseFrequencyOptions;
    @api expenseDetailsJointObj;
    @api isJointApplication;
    @api inputMode;
    @track copyExpenseDetailsJointObj
    showRentBoardFields = false;
    showLandlordField = false;

    connectedCallback() {
        this.copyExpenseDetailsJointObj = { ...this.expenseDetailsJointObj };

        if (this.copyExpenseDetailsJointObj.ResidentialStatus !== undefined) {
            let resStatus = this.copyExpenseDetailsJointObj.ResidentialStatus;
            if (resStatus === 'Renting') {
                this.showRentBoardFields = true;
                this.showLandlordField = true;
            } else if (resStatus === 'Boarding with Parents' || resStatus === 'Boarding Other') {
                this.showRentBoardFields = true;
                this.showLandlordField = false;
            } else {
                this.showRentBoardFields = false;
                this.showLandlordField = false;
            }
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

    @wire(getPicklistValues, { recordTypeId: '$auApplicantRecordTypeId', fieldApiName: RESIDENTIAL_STATUS_FIELD })
    handlResidentialStatusValues({ error, data }) {
        if (data) {
            this.residentialStatusOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }
    // to get the default record type id, if you dont' have any recordtypes then it will get master

    @wire(getObjectInfo, { objectApiName: EXPENSE_OBJECT })
    expenseMetadata;


    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: LIVING_EXPENSE_INTERVAL_FIELD })
    handlFrequencyValues({ error, data }) {
        if (data) {


            this.expenseFrequencyOptions = data.values
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

    get payAllExpenseValues() {
        return [
            { label: 'Yes, I pay all the expenses', value: 'true' },
            { label: 'No, others contribute to expenses', value: 'false' }
        ];
    }

    handleExpenseDetailsChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;

        if (fieldName === 'residentialStatus') {
            if (fieldValue === 'Renting') {
                this.showRentBoardFields = true;
                this.showLandlordField = true;
            } else if (fieldValue === 'Boarding with Parents' || fieldValue === 'Boarding Other') {
                this.showRentBoardFields = true;
                this.showLandlordField = false;
            } else {
                this.showRentBoardFields = false;
                this.showLandlordField = false;
            }
            this.copyExpenseDetailsJointObj.ResidentialStatus = fieldValue;
        } else if (fieldName === 'payAllExpenses') {
            this.copyExpenseDetailsJointObj.DoYouPayAllExpenses = fieldValue;
        } else if (fieldName === 'livingExpenses') {
            this.copyExpenseDetailsJointObj.LivingExpenses = fieldValue;
        } else if (fieldName === 'expenseFrequency') {
            this.copyExpenseDetailsJointObj.LivingExpensesFreq = fieldValue;
        } else if (fieldName === 'rentBoardPayments') {
            this.copyExpenseDetailsJointObj.RentBoardPayments = fieldValue;
        } else if (fieldName === 'paymentFrequency') {
            this.copyExpenseDetailsJointObj.PaymentFrequency = fieldValue;
        } else if (fieldName === 'landlordName') {
            this.copyExpenseDetailsJointObj.LandlordName = fieldValue;
        }
    }

    @api handleValidationOnNext() {

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

        return (inputFieldsCorrect && inputPicklistCorrect);
    }

    handleExpenseDetailsNext() {

        if (this.handleValidationOnNext()) {
            this.fireExpenseDetailsNotifyEvent();
        }
    }

    fireExpenseDetailsNotifyEvent() {
        this.dispatchEvent(new CustomEvent('expensedetailsjointinfo', {
            detail: {
                completedStep: 'step-4',
                nextStep: 'step-5',
                expenseDetailsJoint: this.copyExpenseDetailsJointObj
            }
        }));
    }

    handleExpenseDetailsPrev() {
        this.dispatchEvent(new CustomEvent('expensedetailsprev', {
            detail: {
                prevStep: 'step-3'
            }
        }));
    }

    @api getUpdatedDetails() {
        this.handleExpenseDetailsNext();
    }

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

}