import { LightningElement,wire,api,track } from 'lwc';
import FIRST_NAME_FIELD from '@salesforce/schema/Applicant__c.First_Name__c';
import Driving_LICENSE_FIELD from '@salesforce/schema/Applicant__c.isDrivingLicense__c';
import PHONE_FIELD from '@salesforce/schema/Applicant__c.Phone__c';
import STATE_FIELD from '@salesforce/schema/Applicant__c.State__c';
import getApplicantData from '@salesforce/apex/Application_Information.getApplicantData';
import { getFieldValue } from 'lightning/uiRecordApi';
import {createRecord,getRecord} from 'lightning/uiRecordApi';
const fieldArray = [FIRST_NAME_FIELD,PHONE_FIELD,STATE_FIELD];
export default class ApplicantInformation extends LightningElement {
 
     
    @track recordId;
    @wire(getRecord,{recordId:'$recordId',fields:fieldArray})
    applicantData;

    @track firstName;
    @track phoneValue;
    @track stateValue;

    handleFirstNameValue(event){
       this.firstName = event.target.value;
    }
    
    handlePhoneNameValue(event){
      this.phoneValue = event.target.value;
    }

    handleStateNameValue(event){
      this.stateValue = event.target.value;
    }

    createApplicant(){
        const fields = {};
        fields[FIRST_NAME_FIELD.fieldApiName] = this.firstName;
        fields[PHONE_FIELD.fieldApiName] = this.phoneValue;
        fields[STATE_FIELD.fieldApiName] = this.stateValue;
        const recordInput = {apiName:'Applicant__c',fields};
        

        createRecord(recordInput).then(response=>{
            console.log('Applicant has been created '+response.id);
            this.recordId = response.id;
         }).catch(error=>{
             console.error('Error in creating account '+error.body.message);
     
      });

    }

    get retFirstName(){
     return getFieldValue(this.applicantData.data,FIRST_NAME_FIELD);
    }

    get retPhoneValue(){
        return getFieldValue(this.applicantData.data,PHONE_FIELD);
    }

    get retStateValue(){
        return getFieldValue(this.applicantData.data,STATE_FIELD);
    }

}