import { LightningElement,wire,api } from 'lwc';
import { createRecord,getRecord} from 'lightning/uiRecordApi';

const fields = ['Applicant__c.First_Name__c','Applicant__c.isDrivingLicense__c','Applicant__c.phone__c','Applicant__c.state__c'];

export default class ApplicantRecord extends LightningElement {

    @api recordId;
    @wire(getRecord,{recordId:'$recordId',fields:fields})
    appRecords;


}