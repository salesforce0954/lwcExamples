import { LightningElement,track } from 'lwc';
import { NavigationMixin} from 'lightning/navigation';


export default class PlApplicationContainer extends NavigationMixin(LightningElement) {

    @track currentStep;
    @track applicationId;
    @track applicantId;

    goToStepTwo(){
         this.currentStep = '2';
         this.template.querySelector('div.stepOne').classList.add('slds-hide');
         this.template.querySelector('div.stepTwo').classList.remove('slds-hide');

    }

    goBacktoStepOne(){
        this.currentStep = '1';
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template.querySelector('div.stepOne').classList.remove('slds-hide');
    }
    goBacktoStepTwo(){
        this.currentStep = '2';
        this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template.querySelector('div.stepFour').classList.add('slds-hide');
    }

    goBacktoStepThree(){
        this.currentStep = '3';
        this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template.querySelector('div.stepFour').classList.add('slds-hide');

    }

    goToStepThree(){
        console.log('Entered');
        this.currentStep = '3';
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template.querySelector('div.stepThree').classList.remove('slds-hide');
        this.template.querySelector('div.stepFour').classList.add('slds-hide');

    }

    goToStepFour(){
        this.currentStep = '4';
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template.querySelector('div.stepFour').classList.remove('slds-hide');
    }
    handleLoanDetails(event){
        this.applicationId = event.detail;
        console.log('Application id '+this.applicationId);
        this.template.querySelector('c-pl-loan-details').applicationId= this.applicationId;
        this.template.querySelector('c-pl-loan-details').handleSubmit();

        this.template.querySelector('c-pl-applicant').applicationId= this.applicationId;
        this.template.querySelector('c-pl-applicant').handleSubmitApplicant();


        console.log(1);
    }

    handleIncomeDetails(event){
        console.log('Application information version 2');
      this.applicantId = event.detail;
      console.log('Applicant id '+this.applicantId);
      this.template.querySelector('c-pl-income').applicantId = this.applicantId;
      this.template.querySelector('c-pl-income').handleSubmitIncome();
    }

     handleSave(){
        this.template.querySelector('c-pl-application').handleSubmit();
        this.template.querySelector('c-pl-applicant').handleSubmitApplicant();
        
           
    } 


}