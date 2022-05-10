import { LightningElement,api,track } from 'lwc';

export default class MultiPageForm extends LightningElement {
    @api recordId;
    @track currentStep;
    @track accountId;
    @track contactId;
    isloading = false;

    goBackToStepOne() {
        this.currentStep = '1';
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepOne')
            .classList.remove('slds-hide');
    }

    goToStepTwo() {
        this.currentStep = '2';
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }
    goBackToStepTwo() {
        this.currentStep = '2';
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }
    goToStepThree() {
        this.currentStep = '3';
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    }
    
    /*Method to create new Account */
    handleSave(){
        this.isloading = true;
        this.template.querySelector(".acntForm").handleSubmitt();
    }
 
    /*Method to create new Contact */
    contactCreation(event){
        this.accountId = event.detail; 
        console.log('AccountID'+this.accountId);
        this.template.querySelector(".contactForm").accountId = this.accountId ;
        this.template.querySelector(".contactForm").handleSubmitt();
    }
    
    /*Method to create new Case */
    caseCreation(event){
        this.contactId = event.detail;
        this.template.querySelector(".caseForm").contactId = this.contactId ;
        this.template.querySelector(".caseForm").accountId = this.accountId ;
        this.template.querySelector(".caseForm").handleSubmitt();
        this.isloading = false;
    }
}