import { LightningElement, wire,track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import FIRST_NAME_FIELD from '@salesforce/schema/Applicant__c.First_Name__c';
import Driving_LICENSE_FIELD from '@salesforce/schema/Applicant__c.isDrivingLicense__c';
import PHONE_FIELD from '@salesforce/schema/Applicant__c.Phone__c';
import STATE_FIELD from '@salesforce/schema/Applicant__c.State__c';
const fields = ['Applicant__c.First_Name__c','Applicant__c.isDrivingLicense__c','Applicant__c.phone__c','Applicant__c.state__c'];
export default class ApplicantRecords extends LightningElement {

    @track recId;
   @wire(getRecord,{recordId:'$recId',fields:fields})
   appRecords;

}