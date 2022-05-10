import { LightningElement,track,wire,api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

export default class ApplicationForm extends LightningElement {

    

    @track isApplicantEligible;
   // @track recordId;
    @track fields={};

    handleAppEligible(event){
    this.fields.is_Applicant_Eligible__c = event.target.checked;
    }

    handleSuccess(event){
        
    }

    @api handleSubmit() {
        console.log('Submitting Application');
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
        
    }

    createApplication(){
         console.log(1);
      /** const fields = {'is_Applicant_Eligible__c':this.isApplicantEligible};
        const recordInput = {apiName:'Application__c',fields};

        createRecord(recordInput).then(response=>{
            this.recordId = response.id;
            console.log(this.recordId);
        }).catch(error=>{
            console.error('Error in creating account '+error.body.message);
        });  */ 

        const recordId = this.recordId;
        const result = new CustomEvent('applicationrecord',{detail:recordId});
        this.dispatchEvent(result);


    }
}