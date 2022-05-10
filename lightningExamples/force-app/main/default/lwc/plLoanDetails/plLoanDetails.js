import { api, LightningElement,track } from 'lwc';

export default class PlLoanDetails extends LightningElement {

    @track loanAmount;
    @track fields ={};
    @api applicationId;

    @api
    handleSubmit(){
        this.fields.Application__c = this.applicationId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }
    handleLoanAmount(event){
                this.fields.Loan_amount__c = event.target.value;
    }

    handleLoanName(event){
        this.fields.Loan_Name__c = event.target.value;
        
    }
}