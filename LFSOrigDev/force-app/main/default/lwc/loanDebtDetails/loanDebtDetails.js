import { LightningElement, wire, track, api } from 'lwc';
import LIABILITY_OBJECT from '@salesforce/schema/Liability__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DEBT_CATEGORY_FIELD from '@salesforce/schema/Liability__c.Debt_Category__c';
import REPAYMENT_INTERVAL_FIELD from '@salesforce/schema/Liability__c.Mortgage_Repayment_Interval__c';
import BP_LBL_No_Debts from '@salesforce/label/c.BP_LBL_No_Debts';
import BP_LBL_Debt_Information from '@salesforce/label/c.BP_LBL_Debt_Information';
import BP_LBL_No_Debt_Single from '@salesforce/label/c.BP_LBL_No_Debt_Single';
import BP_LBL_No_Debt_Joint from '@salesforce/label/c.BP_LBL_No_Debt_Joint';
import BP_LBL_No_Debt_Error_Single from '@salesforce/label/c.BP_LBL_No_Debt_Error_Single';
import BP_LBL_No_Debt_Error_Joint from '@salesforce/label/c.BP_LBL_No_Debt_Error_Joint';




export default class LoanDebtDetails extends LightningElement {

    auDebtRecordTypeId;
    @track debtDetailsList = [];
    debtCategoryOptions;
    repaymentIntervalOptions;
    repaymentLabel = 'Repayment amount';
    showMortgageLoanForm = false;
    showCardsForm = false;
    showOverdraftForm = false;
    showOtherForm = false;
    showAddDebtForm = false;
    debtObj = {};
    //denotes if its new or edit
    mode;
    maxDebtsAdded = false;
    @api debtDetailsObj;
    @api isJointApplication;
    @track copyDebtDetailsObj;
    @api inputMode;
    debtInformation;
    noDebtsMsg;
    noDebtErrorMsg;


    connectedCallback() {
        this.copyDebtDetailsObj = { ...this.debtDetailsObj };
        if (this.copyDebtDetailsObj.DebtInfo !== undefined && this.copyDebtDetailsObj.DebtInfo.length > 0) {
            this.debtDetailsList = [...this.copyDebtDetailsObj.DebtInfo];
        }
        if (this.isJointApplication) {
            this.noDebtsMsg = BP_LBL_No_Debt_Joint;
            this.noDebtErrorMsg = BP_LBL_No_Debt_Error_Joint;
        } else {
            this.noDebtsMsg = BP_LBL_No_Debt_Single;
            this.noDebtErrorMsg = BP_LBL_No_Debt_Error_Single;
        }

    }

    @wire(getObjectInfo, { objectApiName: LIABILITY_OBJECT })
    handleResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {
                if (value.name === 'AU') {
                    this.auDebtRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auDebtRecordTypeId', fieldApiName: DEBT_CATEGORY_FIELD })
    handleDebtCategoryValues({ error, data }) {
        if (data) {
            this.debtCategoryOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$auDebtRecordTypeId', fieldApiName: REPAYMENT_INTERVAL_FIELD })
    handleRepaymentIntervalValues({ error, data }) {
        if (data) {
            this.repaymentIntervalOptions = data.values
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

    get tableHasData() {
        return this.debtDetailsList.length > 0 ? true : false;
    }

    get showAddDebtButton() {
        if (this.copyDebtDetailsObj.NoDebts) {
            return false;
        } else {
            return true;
        }
    }

    handleDebtEdit(event) {
        this.mode = 'edit';
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.debtDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.debtObj = { ...this.debtDetailsList[indexOfObject] };
        let debtType = this.debtObj.DebtType;

        if (debtType === 'Mortgage' || debtType === 'Personal loan' || debtType === 'Car loan'
            || debtType === 'Hire purchase') {
            this.showMortgageLoanForm = true;
            this.showCardsForm = false;
            this.showOverdraftForm = false;
            this.showOtherForm = false;
            if (debtType === 'Mortgage') {
                this.repaymentLabel = "Applicant's share of the repayment amount";
            } else {
                this.repaymentLabel = 'Repayment amount';
            }
        } else if (debtType === 'Credit card' || debtType === 'Store card' || debtType === 'Charge card') {
            this.showMortgageLoanForm = false;
            this.showCardsForm = true;
            this.showOverdraftForm = false;
            this.showOtherForm = false;
        } else if (debtType === 'Overdraft') {
            this.showOverdraftForm = true;
            this.showMortgageLoanForm = false;
            this.showCardsForm = false;
            this.showOtherForm = false;
        } else if (debtType === 'Other') {
            this.showOtherForm = true;
            this.showMortgageLoanForm = false;
            this.showCardsForm = false;
            this.showOverdraftForm = false;
        } else {
            this.showMortgageLoanForm = false;
            this.showCardsForm = false;
            this.showOverdraftForm = false;
            this.showOtherForm = false;
        }
        this.showAddDebtForm = true;
    }

    handleDebtDelete(event) {
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.debtDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.debtDetailsList.splice(indexOfObject, 1);
        if (this.debtDetailsList.length === 10) {
            this.maxDebtsAdded = true;
        } else {
            this.maxDebtsAdded = false;
        }
    }

    handleAddDebtCancel() {
        this.showAddDebtForm = false;
    }

    handleAddDebtSave() {

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
                this.debtDetailsList = [...this.debtDetailsList, this.debtObj];
                this.debtObj = {};
                this.showAddDebtForm = false;
            } else if (this.mode === 'edit') {
                let index = this.debtObj.id;
                let indexInArray = this.debtDetailsList.map(function (currentItem) {
                    return currentItem.id
                }).indexOf(Number(index));
                if (indexInArray !== -1) {
                    this.debtDetailsList[indexInArray] = this.debtObj;
                    this.debtObj = {};
                    this.showAddDebtForm = false;
                    this.mode = null;
                }
            }
        }

        if (this.debtDetailsList.length === 10) {
            this.maxDebtsAdded = true;
            this.showToast('info', "You can add upto 10 Debts", 'info', 'dismissable');
        } else {
            this.maxDebtsAdded = false;
        }

    }

    handleAddDebt() {
        this.debtObj = {};
        this.mode = 'new';
        this.showAddDebtForm = true;
        this.showMortgageLoanForm = false;
        this.showCardsForm = false;
        this.showOverdraftForm = false;
        this.showOtherForm = false;
    }

    @api handleValidationOnNext() {

        const checkbox = this.template.querySelector('.dont-have-debts');
        //Case where 'Dont have assets' checkbox is not checked & no asset information is added.
        if (!checkbox.checked && !this.debtDetailsList.length > 0) {
            this.showToast('Error', this.noDebtErrorMsg, 'error', 'pester');
            return;
        }
        return true;
    }

    handleDebtDetailsNext() {
        if (this.handleValidationOnNext()) {
            this.copyDebtDetailsObj.DebtInfo = this.debtDetailsList;
            this.fireDebtDetailsNotifyEvent();
        }

    }

    fireDebtDetailsNotifyEvent() {
        this.dispatchEvent(new CustomEvent('debtdetailsinfo', {
            detail: {
                completedStep: 'step-6',
                nextStep: 'step-7',
                debtDetails: this.copyDebtDetailsObj
            }
        }));
    }

    handleDebtDetailsPrev() {
        this.dispatchEvent(new CustomEvent('debtdetailsprev', {
            detail: {
                prevStep: 'step-5'
            }
        }));
    }

    handleDebtDetailsChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;
        let debtDetailsListLen = this.debtDetailsList.length;
        if (fieldName === 'debttype') {
            if (fieldValue === 'Mortgage' || fieldValue === 'Personal loan' || fieldValue === 'Car loan'
                || fieldValue === 'Hire purchase') {
                this.showMortgageLoanForm = true;
                this.showCardsForm = false;
                this.showOverdraftForm = false;
                this.showOtherForm = false;
                if (fieldValue === 'Mortgage') {
                    this.repaymentLabel = 'My share of the repayment amount';
                } else {
                    this.repaymentLabel = 'Repayment Amount';
                }
            } else if (fieldValue === 'Credit card' || fieldValue === 'Store card' || fieldValue === 'Charge card') {
                this.showMortgageLoanForm = false;
                this.showCardsForm = true;
                this.showOverdraftForm = false;
                this.showOtherForm = false;
            } else if (fieldValue === 'Overdraft') {
                this.showOverdraftForm = true;
                this.showMortgageLoanForm = false;
                this.showCardsForm = false;
                this.showOtherForm = false;
            } else if (fieldValue === 'Other') {
                this.showOtherForm = true;
                this.showMortgageLoanForm = false;
                this.showCardsForm = false;
                this.showOverdraftForm = false;
            } else {
                this.showMortgageLoanForm = false;
                this.showCardsForm = false;
                this.showOverdraftForm = false;
                this.showOtherForm = false;
            }
            this.debtObj.DebtType = fieldValue;
            //Set the id only during create and not when editing
            if (this.mode === 'new') {
                let entryId = debtDetailsListLen + 1;
                //get all the Ids of objects in the list
                let debtIdArray = this.debtDetailsList.map(currentItem => {
                    return currentItem.id;
                });
                if (debtIdArray.includes(entryId)) {
                    let maxId = Math.max(...debtIdArray);
                    entryId = maxId + 1;
                }
                this.debtObj.id = entryId;
            }
            this.copyDebtDetailsObj.NoDebts = false;
            this.debtObj.PayOutNConsolidate = false;
        } else if (fieldName === 'financialInstitution') {
            this.debtObj.FinInstitution = fieldValue;
        } else if (fieldName === 'repaymentAmount') {
            this.debtObj.RepaymentAmount = fieldValue;
        } else if (fieldName === 'repaymentInterval') {
            this.debtObj.RepaymentInterval = fieldValue;
        } else if (fieldName === 'amountBorrowed') {
            this.debtObj.AmountBorrowed = fieldValue;
        } else if (fieldName === 'balanceRemaining') {
            this.debtObj.BalanceRemaining = fieldValue;
        } else if (fieldName === 'wantToPayOutNConsolidate') {
            this.debtObj.PayOutNConsolidate = event.target.checked;
        } else if (fieldName === 'cardLimit') {
            this.debtObj.CardLimit = fieldValue;
        } else if (fieldName === 'interestRate') {
            this.debtObj.InterestRate = fieldValue;
        } else if (fieldName === 'dontHaveDebts') {
            if (event.target.checked) {
                //indicates no debts checked
                this.copyDebtDetailsObj.NoDebts = true;
            } else {
                this.copyDebtDetailsObj.NoDebts = false;
            }

        }
    }

    @api getUpdatedDetails() {

        this.handleDebtDetailsNext();
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
        BP_LBL_No_Debts,
        BP_LBL_Debt_Information
    }

}