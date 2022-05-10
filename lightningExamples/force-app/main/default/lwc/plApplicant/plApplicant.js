import { LightningElement,track,api } from 'lwc';

export default class PlApplicant extends LightningElement {

   @track fields={};
   @api applicationId;

   @api
   handleSubmitApplicant(){
       this.fields.Application__c = this.applicationId;
       this.template.querySelector('lightning-record-edit-form').submit(this.fields);
   }
    
   handleFirstName(event){
       this.fields.First_Name__c = event.target.value;
    }

    handleLicense(event){
        this.fields.isDrivingLicense__c = event.target.value;
    }

    handlePhone(event){
        this.fields.Phone__c = event.target.value;
    }

    handleState(event){
        this.fields.State__c = event.target.value;
    }

    handleSuccess(event){
        console.log('Applicant information');
        const applicantId = event.detail.id;

        const applicantRec = new CustomEvent('applicantrelated',{detail:applicantId});

        this.dispatchEvent(applicantRec);
    
    }


}