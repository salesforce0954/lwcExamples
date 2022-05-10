import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class PlIncome extends NavigationMixin(LightningElement) {

@track fields={}
@track index = 0;

 @api applicantId;
 
 keyIndex = 0;
    @track itemList = [
        {
            id: 0
        }
    ];


  @api
  handleSubmitIncome(){
      console.log('Key Index '+this.keyIndex);
      this.fields.Applicant__c = this.applicantId;
      console.log('Applicant id version 2 '+this.fields.applicant__c);
      this.template.querySelector('lightning-record-edit-form').submit(this.fields);  
  }

   handleEmployment(event){
    this.fields.Employment_Type__c = event.target.value;
   }

   handleIncome(event){
       this.fields.Total_Income_Amount__c = event.target.value;
   }

   handleSuccess(event){
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
    attributes:{
        recordId:this.applicantId,
        objectApiName:'Applicant__c',
        actionName : 'View'
    }

});
const evt = new ShowToastEvent({
    message: "Application,Applicant,Loan purpose & Income created successfully",
    variant: "success",
});
this.dispatchEvent(evt);
   }

   addIncome(){
      ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        console.log('New Item'  +newItem);
        this.itemList = this.itemList.concat(newItem);  
       
   }
}