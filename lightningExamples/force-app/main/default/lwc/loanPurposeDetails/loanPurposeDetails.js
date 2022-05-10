import { LightningElement,api,track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

export default class LoanPurposeDetails extends LightningElement {

    @api recordId;
    @track loanPurpose;
    @track loanAmount;
    @track loanPurposeId;
    @track applicationId;

    handleLoanPurpose(event){
        this.loanPurpose= event.target.value;
    }

    handleLoanAmount(event){
        this.loanAmount = event.target.value;
    }

    handleAppication(event){
        this.applicationId = this.recordId;
    }

    createLoanPurpose(){
        
        const fields ={'Loan_amount__c':this.loanAmount,'Application__c':this.recordId };
        const recordInput = {apiName:'Loan_purpose__c',fields};
        console.log('Fields' + fields.Application__c);
        createRecord(recordInput).then(response=>{
            this.loanPurposeId = response.id;
        }).catch(error=>{
            console.error(error.body.message);
        });

    }
}