import { LightningElement,track,wire,api} from 'lwc';
import FIRST_NAME from '@salesforce/schema/Applicant__c.First_Name__c'
import LAST_NAME from '@salesforce/schema/Applicant__c.Last_Name__c'
import DRIVING_LICENSE from '@salesforce/schema/Applicant__c.isDrivingLicense__c'
import PHONE from '@salesforce/schema/Applicant__c.Phone__c'
import STATE from '@salesforce/schema/Applicant__c.State__c'
import ADDRESS from '@salesforce/schema/Applicant__c.Address__c'
import APPLICATION from '@salesforce/schema/Applicant__c.Application__c'
import APPLICANT_OBJECT from '@salesforce/schema/Applicant__c'
import APPLICANT_ID from '@salesforce/schema/Applicant__c.Id'
import { createRecord,updateRecord,getRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';
import createApplicantForJoint from '@salesforce/apex/incomeCreation.insertApplicantForJoint'
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';



export default class ReRenderDemo extends NavigationMixin(LightningElement) {
   
    @api recordId;
    @track firstName;
    @track lastName;
    @track state;
    @track phone;
    @track gender;
    @track address;
    @track drivingLicense;
    @api applicationId;
    @track storeCheckbox;
    @track checkboxValue;
    @track fnSession;
    @track lnSession;
    @track addrSession;
    @track mobSession;
    @track lcSession;
    @track stSession;
    @track isApplicantJoint = false;

    @track applicationValue = '';
    @api applicantId = '';

    
    @track fieldApplicant;
   
    @track applicantJoint = [];
    @track applicantIds = [];

    
    /*@wire(getRecord, { recordId: '$applicantId', fields: [APPLICANT_ID] })
    applntId({error,data}){
        console.log(error);
        if(data){
          this.fieldApplicant = data.id;  
          console.log('applicant id value '+this.fieldApplicant);
        }else if(error){
            console.log(error);
        }
    }*/

   handleFirstName(event){
      this.firstName = event.target.value;
   }
   handleLastName(event){
     this.lastName = event.target.value;
   }
   handleAddress(event){
    this.address = event.target.value;
   }
   handleMobilePhone(event){
    this.phone = event.target.value;
   }
   handleLicense(event){
   this.drivingLicense = event.target.checked;
   }
 
   handleState(event){
   this.state = event.target.value;
   }

  

  
   connectedCallback(){
       
       //this.handleSuccess();
            
           
           console.log('Triggerec ccb');
           if(localStorage.getItem('eqi') !== null){
            this.applicationValue = localStorage.getItem('eqi'); 
           }
            console.log('Application value '+this.applicationValue);
            
           const applicantType = localStorage.getItem('applicant_type');

           if(applicantType === 'Joint'){
            this.isApplicantJoint = true;
           }else{
            this.isApplicantJoint = false;
           }
            console.log('Applicant Type '+applicantType);
            console.log('applicant joint size '+this.applicantJoint.length);
           
            if(applicantType === 'Joint'){
                createApplicantForJoint({applicationId:this.applicationValue,applicantType:applicantType}).then(response=>{
                    console.log('Applicant Joint Created in Server '+JSON.stringify(response));
                    
                    response.forEach(item=>{
                      this.applicantJoint.push({
                          isPrimayApplicant__c : item.isPrimayApplicant__c,
                          Id :item.Id,
                          Application__c : item.Application__c,
                          First_Name__c : item.First_Name__c,
                          Last_Name__c : item.Last_Name__c,
                          Address__c : item.Address__c,
                          Phone__c:item.Phone__c,
                          State__c:item.State__c,
                      })
                    })
              }).catch(error=>{
                  console.log(error.body.message);
              })
            } 
           
           
           
            if(localStorage.getItem('applicantId') !== undefined ||
            localStorage.getItem('applicantId') !== 'undefined') {
                console.log(localStorage.getItem('applicantId'));


                this.applicantId = localStorage.getItem('applicantId');
            }

            //console.log('ApplicantID '+this.fieldApplicant[0]);
           // this.appId = sessionStorage.getItem('applicantid');
            //this.applicantId='a0J7F00000gIElM';
            //console.log('APPlicant ID '+this.appId);
            if( sessionStorage.getItem('fnsession') !== 'undefined') {
                console.log('session '+sessionStorage.getItem('fnsession'));
                this.fnSession = sessionStorage.getItem('fnsession');
                console.log(1);
                }else{
                    sessionStorage.setItem('fnsession',this.firstName);
                    console.log(2);
                }
                if(sessionStorage.getItem('lnsession') !== 'undefined') {
                this.lnSession = sessionStorage.getItem('lnsession');
                }else{
                  sessionStorage.setItem('lnsession',this.lastName);
                }
                if(sessionStorage.getItem('addrsession') !== 'undefined') {
                this.addrSession = sessionStorage.getItem('addrsession');
                }else{
                    sessionStorage.setItem('addrSession',this.address);
                }
                if(
                sessionStorage.getItem('mobsession') !== 'undefined') {
                this.mobSession = sessionStorage.getItem('mobsession');
                }else{
                    sessionStorage.setItem('mobSession',this.phone);
                }
                if(sessionStorage.getItem('lcsession') !== undefined ||
                sessionStorage.getItem('lcsession') !== 'undefined') {
                this.lcSession = sessionStorage.getItem('lcsession');
                }else{
                    sessionStorage.setItem('lcSession',this.his.drivingLicense);
                }
                if(sessionStorage.getItem('stsession') !== 'undefined') {
                this.stSession = sessionStorage.getItem('stsession');
                }else{
                    sessionStorage.setItem('stsession',this.state);
                } 
   }

   handleSubmitButtonClick(){      
    console.log('expense')

    if(this.applicantJoint.length > 0){
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            element.submit();      
        });  
    }
    //this.template.querySelector('lightning-record-edit-form').submit();
    //this.template.querySelectorAll('lightning-record-edit-form').forEach((form) => {form.submit()});


   }

   handleSuccess(event){
    this.applicantId = event.detail.id;
    this.applicantIds.push(this.applicantId);
    console.log('Applicant ids '+this.applicantIds);

    console.log('Entered Submit '+this.applicantId);
    localStorage.setItem('applicantId', this.applicantId);
    //sessionStorgae.setItem('applicantid',this.applicantId);

    localStorage.setItem('application_id',this.applicationValue);
    localStorage.setItem('applicant_ids',this.applicantIds);

    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/expensedetails'
        },
    });

   }
   handleSubmit(event){   
       
             //this.fieldApplicant = event.detail.fields;

             sessionStorage.setItem('fnsession',this.firstName);             
             sessionStorage.setItem('lnsession',this.lastName);
             sessionStorage.setItem('addrsession',this.address);
             sessionStorage.setItem('mobsession',this.phone);
             sessionStorage.setItem('lcsession',this.drivingLicense);
             sessionStorage.setItem('stsession',this.state);

           

            
        }

        handleError(event){
            var errorMessage = event.detail;
         console.log( "errorMessage : " +JSON.stringify(errorMessage));
        }

    goBack(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/plapplication'
            },
        });
    }
}