import { LightningElement,track,api, wire } from 'lwc';
import { createRecord,getRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import FIRST_NAME from '@salesforce/schema/Applicant__c.First_Name__c';
import Driving_License from '@salesforce/schema/Applicant__c.isDrivingLicense__c';
import PHONE_FIELD from '@salesforce/schema/Applicant__c.Phone__c';
import STATE_FIELD from '@salesforce/schema/Applicant__c.State__c';
import {getPickistValues} from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
const fields = ['Applicant__c.First_Name__c','Applicant__c.isDrivingLicense__c','Applicant__c.phone__c','Applicant__c.state__c'];

export default class ApplicantCreation extends LightningElement {
  
    @track firstName;
    @track drivingLicense;
    @track phone;
    @track state;
    @track recorddId;

    @api recordId;

    @track fieldOptions =[
        {label:'Andhra Pradesh',value:'Andhra Pradesh'},
        {label:'Uttar Pradesh',value: 'Uttar Pradesh'}
    ]; 

  /**  @wire(getRecord,{recordId:'$recordId',fields:fields})
    appRecords;

    @wire(getObjectInfo,{objectApiName:'Applicant__c'})
    applicantMetaData;

    @wire(getPickistValues,{
        recordTypeId: '$applicantMetaData.data.defaultRecordTypeId',
        fieldApiName : STATE_FIELD
    })
    statePicklist; */ 

  
    
    handleFirstName(event){
        this.firstName = event.target.value;
    }

    handleDrivingLicense(event){
        this.drivingLicense = event.target.checked;
    }

    handlePhone(event){
        this.phone = event.target.value;
    }

   handleState(event){
        this.state = event.target.value;
    }  

    createApplicant(){
        const fields ={'First_Name__c':this.firstName,'isDrivingLicense__c':this.drivingLicense,'Phone__c':this.phone,'State__c':this.state,'Application__c':this.recordId};
        const recordInput = {apiName:'Applicant__c',fields};

        createRecord(recordInput).then(response=>{
            this.recorddId = response.id;
            const successMsg = new ShowToastEvent({
                 title :'Record created successfully',
                 message : 'Record created '+this.recordId,
                 variant : 'Success'
            
            });
            this.dispatchEvent(successMsg);
        }).catch(error=>{
            console.log(error.body.message);
        });
    }

}