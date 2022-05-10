import { LightningElement,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import {NavigationMixin} from 'lightning/navigation'
export default class PlApplication extends NavigationMixin(LightningElement) {

    @track isEligible;
    @track fields ={};

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
}