import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import EXPENSE_OBJECT from '@salesforce/schema/Expense__c';
import RESIDENTIAL_STATUS_FIELD from '@salesforce/schema/Applicant__c.Res_Status__c';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';
import FOOD_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Food_Groc_Interval__c';
import INSURANCE_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Insurance_Expense_Interval__c';
import UTILITIES_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Utilities_Expense_Interval__c';
import TRANSPORT_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Transport_Expense_Interval__c';
import EDUCATION_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Education_and_child_Expense_Interval__c';
import PERSONAL_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Personal_Other_Expense_Interval__c';
import LIVING_EXPENSE_INTERVAL_FIELD from '@salesforce/schema/Expense__c.Living_Exp_Int__c';

export default class LoanExpenseDetails extends LightningElement {

    auApplicantRecordTypeId;
    residentialStatusOptions;
    expenseFrequencyOptions;
    @api expenseDetailsObj;
    @api isJointApplication;
    @api inputMode;
    @track copyExpenseDetailsObj
    showRentBoardFields = false;
    showLandlordField = false;
    foodIntervalOptions;
    insuranceIntervalOptions;
    utilitiesIntervalOptions;
    transportIntervalOptions;
    educationIntervalOptions;
    personalIntervalOptions;
    totalMonthlyExpenses;
    expensesMoreThan30K = false;
    showErrorMessage = false;

    connectedCallback() {
        this.copyExpenseDetailsObj = { ...this.expenseDetailsObj };
        this.calculateTotalMonthlyExpense();
        if (this.copyExpenseDetailsObj.ResidentialStatus !== undefined) {
            let resStatus = this.copyExpenseDetailsObj.ResidentialStatus;
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
        window.scrollTo(0, 0);
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


    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: FOOD_INTERVAL_FIELD })
    handleFoodIntervalValues({ error, data }) {
        if (data) {
            this.foodIntervalOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: INSURANCE_INTERVAL_FIELD })
    handleInsuranceIntervalValues({ error, data }) {
        if (data) {
            this.insuranceIntervalOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: UTILITIES_INTERVAL_FIELD })
    handleUtilitiesIntervalValues({ error, data }) {
        if (data) {
            this.utilitiesIntervalOptions = data.values;
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: TRANSPORT_INTERVAL_FIELD })
    handleTransportIntervalValues({ error, data }) {
        if (data) {
            this.transportIntervalOptions = data.values;
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: EDUCATION_INTERVAL_FIELD })
    handleEducationIntervalValues({ error, data }) {
        if (data) {
            this.educationIntervalOptions = data.values;
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: PERSONAL_INTERVAL_FIELD })
    handlePersonalIntervalValues({ error, data }) {
        if (data) {
            this.personalIntervalOptions = data.values;
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$expenseMetadata.data.defaultRecordTypeId', fieldApiName: LIVING_EXPENSE_INTERVAL_FIELD })
    handlFrequencyValues({ error, data }) {
        if (data) {


            this.expenseFrequencyOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    genericErrorLoadingForm() {
        this.showToast('Error', 'Error Loading Application Form. Please try after sometime.', 'error', 'sticky');
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

    handleShowWarning(event) {
        let fieldName = event.target.name;
        let warningFieldName = '.' + fieldName + '_warning';

        if(this.template.querySelector(warningFieldName).style.display == "none") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }      
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
            this.copyExpenseDetailsObj.ResidentialStatus = fieldValue;

            if(this.template.querySelector('.residentialStatus_warning').style.display == "") {
                $(this.template.querySelector('.residentialStatus_warning')).slideToggle("fast");
            }             
        } else if (fieldName === 'payAllExpenses') {
            this.copyExpenseDetailsObj.DoYouPayAllExpenses = fieldValue;
        } else if (fieldName === 'food') {
            this.copyExpenseDetailsObj.FoodExpense = fieldValue;
        } else if (fieldName === 'foodFrequency') {
            this.copyExpenseDetailsObj.FoodFrequency = fieldValue;
        } else if (fieldName === 'insurance') {
            this.copyExpenseDetailsObj.InsuranceExpense = fieldValue;
        } else if (fieldName === 'insuranceFrequency') {
            this.copyExpenseDetailsObj.InsuranceFrequency = fieldValue;
        } else if (fieldName === 'utilities') {
            this.copyExpenseDetailsObj.UtilitiesExpense = fieldValue;
        } else if (fieldName === 'utilitiesFrequency') {
            this.copyExpenseDetailsObj.UtilitiesFrequency = fieldValue;
        } else if (fieldName === 'transport') {
            this.copyExpenseDetailsObj.TransportExpense = fieldValue;
        } else if (fieldName === 'transportFrequency') {
            this.copyExpenseDetailsObj.TransportFrequency = fieldValue;
        } else if (fieldName === 'education') {
            this.copyExpenseDetailsObj.EducationExpense = fieldValue;
        } else if (fieldName === 'educationFrequency') {
            this.copyExpenseDetailsObj.EducationFrequency = fieldValue;
        } else if (fieldName === 'personal') {
            this.copyExpenseDetailsObj.PersonalExpense = fieldValue;
        } else if (fieldName === 'personalFrequency') {
            this.copyExpenseDetailsObj.PersonalFrequency = fieldValue;
        } else if (fieldName === 'rentBoardPayments') {
            this.copyExpenseDetailsObj.RentBoardPayments = fieldValue;
        } else if (fieldName === 'paymentFrequency') {
            this.copyExpenseDetailsObj.PaymentFrequency = fieldValue;
        } else if (fieldName === 'landlordName') {
            this.copyExpenseDetailsObj.LandlordName = fieldValue;
        }
        this.calculateTotalMonthlyExpense();
        this.showExpenseErrorMessage();
    }

    calculateTotalMonthlyExpense() {
        let totalMonthlyExpenses_local = 0.0;
        let monthlyExpense = 0.0;
        if (this.copyExpenseDetailsObj.FoodExpense !== null && !isNaN(this.copyExpenseDetailsObj.FoodExpense) && this.copyExpenseDetailsObj.FoodFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.FoodExpense, this.copyExpenseDetailsObj.FoodFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }
        if (this.copyExpenseDetailsObj.InsuranceExpense !== null && !isNaN(this.copyExpenseDetailsObj.InsuranceExpense) && this.copyExpenseDetailsObj.InsuranceFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.InsuranceExpense, this.copyExpenseDetailsObj.InsuranceFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }
        if (this.copyExpenseDetailsObj.UtilitiesExpense !== null && !isNaN(this.copyExpenseDetailsObj.UtilitiesExpense) && this.copyExpenseDetailsObj.UtilitiesFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.UtilitiesExpense, this.copyExpenseDetailsObj.UtilitiesFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }
        if (this.copyExpenseDetailsObj.TransportExpense !== null && !isNaN(this.copyExpenseDetailsObj.TransportExpense) && this.copyExpenseDetailsObj.TransportFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.TransportExpense, this.copyExpenseDetailsObj.TransportFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }
        if (this.copyExpenseDetailsObj.EducationExpense !== null && !isNaN(this.copyExpenseDetailsObj.EducationExpense) && this.copyExpenseDetailsObj.EducationFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.EducationExpense, this.copyExpenseDetailsObj.EducationFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }
        if (this.copyExpenseDetailsObj.PersonalExpense !== null && !isNaN(this.copyExpenseDetailsObj.PersonalExpense) && this.copyExpenseDetailsObj.PersonalFrequency !== null) {
            monthlyExpense = this.calculateMonthlyExpense(this.copyExpenseDetailsObj.PersonalExpense, this.copyExpenseDetailsObj.PersonalFrequency);
            totalMonthlyExpenses_local += Number(monthlyExpense);
        }

        this.totalMonthlyExpenses = totalMonthlyExpenses_local;
        //Check if more than 30K
        if (this.totalMonthlyExpenses > 30000) {
            this.expensesMoreThan30K = true;
        } else {
            this.expensesMoreThan30K = false;
        }


    }

    calculateMonthlyExpense(expense, frequency) {
        let monthlyExpense = 0;
        if (expense !== null && frequency !== null) {
            if (frequency === 'Month') {
                monthlyExpense = expense;
            } else if (frequency === 'Week') {
                monthlyExpense = expense * (52 / 12);
            } else if (frequency === 'Fortnight') {
                monthlyExpense = expense * (26 / 12);
            } else if (frequency === 'Quarter') {
                monthlyExpense = expense / 3;
            } else if (frequency === 'Year') {
                monthlyExpense = expense / 12;
            }
        }
        return Math.round(monthlyExpense);
    }

    showExpenseErrorMessage() {

        if (this.copyExpenseDetailsObj.FoodExpense === undefined && this.copyExpenseDetailsObj.InsuranceExpense === undefined &&
            this.copyExpenseDetailsObj.TransportExpense === undefined && this.copyExpenseDetailsObj.UtilitiesExpense === undefined &&
            this.copyExpenseDetailsObj.EducationExpense === undefined && this.copyExpenseDetailsObj.PersonalExpense === undefined) {

            this.showErrorMessage = false;
        } else {
            if (this.totalMonthlyExpenses === 0) {

                this.showErrorMessage = true;
            } else {

                this.showErrorMessage = false;
            }
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
        if (this.handleValidationOnNext() && !this.showErrorMessage) {
            this.fireExpenseDetailsNotifyEvent();
        }
    }

    fireExpenseDetailsNotifyEvent() {
        this.dispatchEvent(new CustomEvent('expensedetailsinfo', {
            detail: {
                completedStep: 'step-4',
                nextStep: 'step-5',
                expenseDetails: this.copyExpenseDetailsObj
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

    handleGoToJointApplicant() {
        if (this.handleValidationOnNext()) {
            this.fireExpenseDetailsNotifyEvent();
            //navigate to next tab
            this.dispatchEvent(new CustomEvent('navigatejointexpense'));
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