import { LightningElement,api,track } from 'lwc';
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c';
import FIRST_NAME_FIELD from '@salesforce/schema/Applicant__c.First_Name__c';
import PHONE_FIELD from '@salesforce/schema/Applicant__c.Phone__c';
import STATE_FIELD from '@salesforce/schema/Applicant__c.State__c';
import DRIVER_LICENSE_FIELD from '@salesforce/schema/Applicant__c.isDrivingLicense__c';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

/**
 * Creates Account records.
 */
export default class AccountCreator extends LightningElement {

    accountObject = APPLICANT_OBJECT;
    myFields = [FIRST_NAME_FIELD, PHONE_FIELD,STATE_FIELD,DRIVER_LICENSE_FIELD];
    @api recordId;

    handleAccountCreated(event) {
        const evt = new ShowToastEvent({
            title: 'Account created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
        this.recordId = event.detail.id;
    }
}