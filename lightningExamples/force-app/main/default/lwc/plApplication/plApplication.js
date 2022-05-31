import { LightningElement,track,api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import {NavigationMixin} from 'lightning/navigation'
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class PlApplication extends NavigationMixin(LightningElement) {

    @track isEligible;
    @track fields ={};

    @track objectInformation;
    connectedCallback(){
        console.log('Object '+this.objectInformation);
    }
    
   @wire(getObjectInfo,{objectApiName:'Application__c'})
   objectInfo({data,error}){
       if(data){
           this.objectInformation= data;
           console.log('Test '+JSON.stringify(this.objectInformation));
       }
   }
    @api
    handleSubmit(){
         this.template.querySelector('lightning-record-edit-form').submit(this.fields);        
    }
    handleSuccess(event){
          console.log('onSuccess '+event.detail.id);
          const recordId = event.detail.id;
        /**  const evt = new ShowToastEvent({
            title: "Success",
            message: "This is sample success message",
            variant: "success",
        });  */

        const evt = new CustomEvent('loandetails',{detail:recordId});

        this.dispatchEvent(evt);
    }

  /**  handleNavigation(){
         this[NavigationMixin.Navigate]({
             type:'Standard__component',
             attributes:{
                 componentName:'c__simpleCalculator'
             }
         });
    }  */

    handleEligible(event){
         this.fields.is_Applicant_Eligible__c= event.target;
    }

    validateApplication(){
        console.log(1);
        let isValid = false;
        
         const isEligible = this.template.querySelector('.isEligible');
         const isEligibleValue = isEligible.value;

         if(!isEligibleValue){
             isEligible.setCustomValidity('Please select the Eligibility');
             isEligible.reportValidity();
             isValid = false;
         }else{
            isEligible.setCustomValidity('');
            isEligible.reportValidity();
            isValid = true;
         }
         return isValid;
    }
}