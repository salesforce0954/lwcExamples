import { LightningElement, wire, api } from 'lwc';
import REASON_NOT_PROCEEDING from '@salesforce/schema/Quote__c.Broker_reason_for_not_proceeding__c';
import CLIENT_FINANCE_NEED from '@salesforce/schema/Quote__c.Client_finance_need__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import cancelQuote from '@salesforce/apex/QuoteActionsManager.cancelQuote';
import BP_LBL_Cancel_Quote_Disclaimer from '@salesforce/label/c.BP_LBL_Cancel_Quote_Disclaimer';
import BP_LBL_Cancel_Quote_Q1 from '@salesforce/label/c.BP_LBL_Cancel_Quote_Q1';
import BP_LBL_Cancel_Quote_Q2 from '@salesforce/label/c.BP_LBL_Cancel_Quote_Q2';
import BP_LBL_Quote_Cancel_Success from '@salesforce/label/c.BP_LBL_Quote_Cancel_Success';
import BP_LBL_Quote_Cancel_Error from '@salesforce/label/c.BP_LBL_Quote_Cancel_Error';
import BP_LBL_Picklist_Error from '@salesforce/label/c.BP_LBL_Picklist_Error';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




export default class CancelQuote extends LightningElement {

    auQuoteRecordTypeId;
    mainReasonOptions;
    clientFinanceOptions;
    disclaimer = BP_LBL_Cancel_Quote_Disclaimer;
    primaryReason;
    primaryReasonOther;
    clientFinance;
    clientFinanceOther;
    showOtherReason;
    showOtherFinance;
    quoteCancelDetails = {};
    showSpinner = false;
    showClientFinanceQ = true;
    @api quoteId;
    qId;

    connectedCallback() {
        // this.qId = this.quoteId;

    }


    //FETCH Record Type Id for AU from Quote Object
    @wire(getObjectInfo, { objectApiName: QUOTE_OBJECT })
    handleResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {
                if (value.name === 'AU') {
                    this.auQuoteRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auQuoteRecordTypeId', fieldApiName: REASON_NOT_PROCEEDING })
    handleReasonValues({ error, data }) {
        if (data) {
            this.mainReasonOptions = data.values
        } else if (error) {
            console.error(error);
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auQuoteRecordTypeId', fieldApiName: CLIENT_FINANCE_NEED })
    handleFinanceValues({ error, data }) {
        if (data) {
            this.clientFinanceOptions = data.values
        } else if (error) {
            console.error(error);
            this.genericErrorLoadingForm();
        }
    }



    genericErrorLoadingForm() {
        this.showToast('Error', BP_LBL_Picklist_Error, 'error', 'pester');
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

    handleFormChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;

        if (fieldName === 'cancelQuestion1') {
            if (fieldValue === 'Other') {
                this.showOtherReason = true;
            } else {
                this.showOtherReason = false;
            }
            if (fieldValue === 'Client could not be contacted') {
                this.showClientFinanceQ = false;
            } else {
                this.showClientFinanceQ = true;
            }
            this.quoteCancelDetails.PrimaryReason = fieldValue;
            this.quoteCancelDetails.QuoteId = this.quoteId;
        } else if (fieldName === 'otherReason') {
            this.quoteCancelDetails.PrimaryReasonOther = fieldValue;
        } else if (fieldName === 'cancelQuestion2') {
            if (fieldValue === 'Other') {
                this.showOtherFinance = true;
            } else {
                this.showOtherFinance = false;
            }
            this.quoteCancelDetails.ClientFinance = fieldValue;
        } else if (fieldName === 'otherFinance') {
            this.quoteCancelDetails.ClientFinanceOther = fieldValue;
        }
    }



    handleCancelQuoteConfirm() {
        const inputFieldsCorrect = [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        const inputRadioGroup = [...this.template.querySelectorAll('lightning-radio-group')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        if (inputFieldsCorrect && inputRadioGroup) {
            this.showSpinner = true;

            cancelQuote({
                quoteCancelDetails: JSON.stringify(this.quoteCancelDetails)
            }).then(result => {
                this.showToast('Success', BP_LBL_Quote_Cancel_Success, 'success');
                this.dispatchEvent(new CustomEvent('quoteclose'));
            }).catch(error => {
                this.error = error;
                console.error(error);
                this.showSpinner = false;
                this.dispatchEvent(new CustomEvent('quoteclose'));
                this.showToast('Error', BP_LBL_Quote_Cancel_Error, 'error');
            })
        }

    }

    handleCancelQuoteClose() {
        this.dispatchEvent(new CustomEvent('quoteclose'));
    }


    /**Custom labels for fields*/
    label = {
        BP_LBL_Cancel_Quote_Q1,
        BP_LBL_Cancel_Quote_Q2
    }
}