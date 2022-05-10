import { LightningElement,track,wire} from 'lwc';
import { createRecord,getRecord,getFieldValue } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import FIRST_NAME_FIELD from '@salesforce/schema/Applicant__c.First_Name__c';
import PHONE_FIELD from '@salesforce/schema/Applicant__c.Phone__c';
import LICENSE_FIELD from '@salesforce/schema/Applicant__c.isDrivingLicense__c'
const fields =[FIRST_NAME_FIELD,PHONE_FIELD,LICENSE_FIELD];
export default class InsertApplicant extends LightningElement {

    @track firstName;
    @track phone;
    @track isDrivingLicense;
    @track recordId;
    
    @wire(getRecord,{recordId:'$recordId',fields})
    applicants;

firstNameHandler(event){
    this.firstName = event.target.value;
}

phoneHandler(event){
    this.phone = event.target.value;
}
checkboxHandler(event){
    this.isDrivingLicense=event.target.checked;
}


createApplicant(){
    console.log('App Validation '+this.validateApplication());
  if(this.validateApplication()){
   const fields = {'First_Name__c':this.firstName,'Phone__c':this.phone,'isDrivingLicense__c':this.isDrivingLicense};
   //const fields = {FIRST_NAME_FIELD:this.firstName,PHONE_FIELD:this.phone,LICENSE_FIELD:this.isDrivingLicense};
   const recordInput = {apiName:'Applicant__c',fields};
   createRecord(recordInput).then(response=>{
        this.recordId = response.id;
       /**  const toastEvent = new ShowToastEvent({
            title: 'Applicant loaded',
            message : response.id + 'Applicant inserted successfully',
            variant : 'success',
        }) */
        const toastEvent = new ShowToastEvent({
            title:'Success!',
            message:response.id +'Account created successfully',
            variant:'success'
          });
          this.dispatchEvent(toastEvent);
   }).catch(error=>{
        console.error('Sorry record not inserted '+error.body.message);
   })

  }


}

validateApplication(){
   let isValid = false;
   const vFirstName = this.template.querySelector('.validateFirstName');
   const vPhone = this.template.querySelector('.validatePhone');
   const vDriverLicense = this.template.querySelector('.validateDriverLicense');

   const vFirstNameValue = vFirstName.value;
   const vPhoneValue = vPhone.value;
   const vDriverLicenseValue = vDriverLicense.checked;

     if(!vFirstNameValue){
    vFirstName.setCustomValidity('Please enter the first name');
    vFirstName.reportValidity();
    isValid = false;
   }else{
    vFirstName.setCustomValidity('');
    vFirstName.reportValidity();
    isValid = true;
   }
   

   if(!vPhoneValue){
    vPhone.setCustomValidity('Please enter the phone number');
    vPhone.reportValidity();
    isValid = false;
   }else{
    vPhone.setCustomValidity('');
    vPhone.reportValidity();
    isValid = true;
   } 

   if(vDriverLicenseValue == false){
    vDriverLicense.setCustomValidity('Please enter the driving license');
    vDriverLicense.reportValidity();
    isValid = false;
   }else{
    vDriverLicense.setCustomValidity('');
    vDriverLicense.reportValidity();
    isValid = true;
   } 
  
   
   return isValid;
 
}

isInputValid() {
    let isValid = false;
    let inputFields = this.template.querySelectorAll('lightning-input-field');
    inputFields.forEach(inputField => {
        if(!inputField.checkValidity()) {
            inputField.reportValidity();
            isValid = false;
        }
        //this.contact[inputField.name] = inputField.value;
    });
    return isValid;
}

get getFirstName(){
     if(this.applicants.data){
       return  getFieldValue(this.applicants.data,FIRST_NAME_FIELD);
     }
}
get getPhone(){
    if(this.applicants.data){
        console.log('Phone');
        return  getFieldValue(this.applicants.data,PHONE_FIELD);
      }
}

get getLicense(){
    if(this.applicants.data){
        console.log('License');
        return  getFieldValue(this.applicants.data.checked,LICENSE_FIELD);
      }
}

}