import { LightningElement,track,wire,api } from 'lwc';
import { createRecord, getFieldValue } from 'lightning/uiRecordApi';
import APPLICANT_ELIGIBLE from '@salesforce/schema/Application__c.is_Applicant_Eligible__c'
import APPLICANT_OBJECT from '@salesforce/schema/Application__c'
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import USER_COUNTRY from '@salesforce/schema/User.Country'



export default class ApplicationPLForm extends NavigationMixin(LightningElement) {

    @track isApplicantEligible = false;
    @track isAppEligible = false;
    @track sessionValue;
    @api applicationId;
    @track applicantType;
    @track auRecordType;
    @track nzRecordType;
    @track cityValues;
    @track userCountry;

    
    
    @track objectInformation;
    connectedCallback(){
        console.log('Object '+this.objectInformation);
    }
    
   @wire(getObjectInfo,{objectApiName:'Application__c'})
   objectInfo({data,error}){
       if(data){
           this.objectInformation= data;
           for (const [key, value] of Object.entries(this.objectInformation.recordTypeInfos)) {
            console.log(`${key}: ${value.name}`);
            if(value.name == 'AU'){
                console.log(1);
               this.auRecordType = value.recordTypeId;
            }else if(value.name == 'NZ'){
                console.log(2);
                this.nzRecordType = value.recordTypdId;
            }
            
          }
       }
   }

   @wire(getPicklistValues, { recordTypeId: '$nzRecordType', fieldApiName: 'City__c' })
   handleTitleValues({ error, data }) {
       if (data) {
           this.cityValues = data.values
       } else if (error) {
           console.log(JSON.stringify(error));
       }
   }

    handleApplicantEligible(event){
        this.isApplicantEligible = event.target.value;
        console.log('Checked '+this.isApplicantEligible);
               
    }
    
    handleApplicantType(event){
        this.applicantType = event.target.value;
    }

    connectedCallback(){
      /*  if(sessionStorage.getItem('test_Item') !== null || 
        sessionStorage.getItem('test_Item') !== 'null' ||
        sessionStorage.getItem('test_Item') !== undefined ||
        sessionStorage.getItem('test_Item') !== 'undefined') */
        
      /*  if(sessionStorage.getItem('test_Item') !== undefined){
            console.log('isEligible '+sessionStorage.getItem('test_Item'));
                this.isApplicantEligible = JSON.parse(sessionStorage.getItem('test_Item'));
            console.log('isEligible 1 '+this.isApplicantEligible);
        }else{
            sessionStorage.setItem('test_Item',this.isApplicantEligible);

        } */

        if(localStorage.getItem('eqi') !== undefined ||
            localStorage.getItem('eqi') !== 'undefined') {
                console.log(localStorage.getItem('eqi'));


                this.applicationId = localStorage.getItem('eqi');
            }
    }
    
   
    
  /*  createApplication(){
          
        const fields = {};
        fields[APPLICANT_ELIGIBLE.fieldApiName] = !!this.isApplicantEligible
;
        const recordInput = {apiName:APPLICANT_OBJECT.objectApiName,fields};

        createRecord(recordInput).then(response=>{
           this.applicationId = response.id;
           console.log('Application Id '+this.applicationId);

           let currentUrl = window.location.href;
          // console.log('currentUrl '+currentUrl);
           //let applicationFormUrl = BP_LBL_BASE_URL + 's/applicationform';
          if (currentUrl !== undefined && currentUrl !== null) {
               if (currentUrl.includes('plapplication')) {
                   currentUrl = currentUrl.replace('plapplication', 'personaldetails');
                   console.log('first condition');
                } else {
                   currentUrl = currentUrl + 'personaldetails';
                   console.log('second condition');
               }
           } 
           //let applicationFormUrl = window.location.href;
           let applicationFormUrl = currentUrl;

           // applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, 'personaldetails');
           //applicationFormUrl = 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/personaldetails';
           
           //console.log('currentUrl After '+applicationFormUrl);
           localStorage.setItem('eqi', this.applicationId);
           //console.log('Session $$ '+this.sessionValue);
           sessionStorage.setItem('test_Item',this.isApplicantEligible); 
           
           this[NavigationMixin.Navigate]({
               type: 'standard__webPage',
               attributes: {
                   url: applicationFormUrl
               },
           });





        }).catch(error=>{
            console.log('Error '+error.body.message);
        })
    

    } */


    handleSubmitButtonClick(){      
        console.log('Application')
        this.template.querySelector('lightning-record-edit-form').submit();
    
       }
    
       handleSuccess(event){
        this.applicationId = event.detail.id;
        console.log('Entered Submit '+this.applicationId);
        localStorage.setItem('eqi', this.applicationId);
        localStorage.setItem('applicant_type',this.applicantType);


        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/personaldetails'
            },
        });

          
       }
       handleSubmit(event){   
       
               // sessionStorage.setItem('test_Item',this.isApplicantEligible);
                
    
                
            }
    
           
            handleError(event){
                var errorMessage = event.detail;
                console.log( "errorMessage : " +JSON.stringify(errorMessage));
            }

}