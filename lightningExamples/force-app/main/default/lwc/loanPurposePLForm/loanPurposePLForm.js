import { LightningElement,track,api,wire } from 'lwc';
import LOAN_AMOUNT from '@salesforce/schema/Loan_purpose__c.Loan_amount__c'
import LOAN_NAME from '@salesforce/schema/Loan_purpose__c.Loan_Name__c'
import APPLICATION from '@salesforce/schema/Loan_purpose__c.Application__c'
import LOAN_PURPOSE_OBJECT from '@salesforce/schema/Loan_purpose__c'
import { NavigationMixin } from 'lightning/navigation';
export default class LoanPurposePLForm extends NavigationMixin(LightningElement) {

 /*   @track loanAmount;
    

    handleLoanAmount(event){
      this.loanAmount = event.target.value;
    } */
    @api applicationId;
    @track options=[
        {label:'Car purchase',value:'Car purchase'},
        {label:'Auto purchase',value:'Auto purchase'},
        {label:'car improvements',value:'car improvements'},
        {label:'house purchase',value:'house purchase'}       
    ];

    @track fields = {};

    @api handleSubmit() {
        console.log('Entered 2');
        this.fields.Application__c = 'a0K7F00001w09TYUAY';
        console.log('App id '+this.fields.Application__c)
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }

    handleLoanAmount(event) {
        this.fields.Loan_amount__c = event.target.value;
        console.log('Loan amount '+this.fields.Loan_amount__c);
    }

    handleLoanName(event){
        this.fields.Loan_Name__c = event.target.value;
        console.log('Loan name '+this.fields.Loan_Name__c);
    }

    
    handleSucess(event) {
        const loanPurposeId = event.detail.id;
        console.log('loan purpose id '+loanPurposeId);
        const selectEvent = new CustomEvent('loanpurpose', {
            detail: loanPurposeId
        });
        this.dispatchEvent(selectEvent);
    }
}