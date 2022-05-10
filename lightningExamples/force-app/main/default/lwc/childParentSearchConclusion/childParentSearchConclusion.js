import { LightningElement,track } from 'lwc';
import getAllApplicants from '@salesforce/apex/applicantInformation.getAllApplicants';
import { NavigationMixin } from 'lightning/navigation';

export default class ChildParentSearchConclusion extends NavigationMixin(LightningElement) {
   
    @track applicants;

    handleGetApplicantRecords(event){
        console.log('Event information '+event.detail);
        getAllApplicants({numberOfRecords :event.detail}).then(response=>{
            console.log('STEP 2');
            console.log('Response '+event.detail);
           this.applicants = response;
          
        }).catch(error=>{
             console.log('Error '+error.body.message);
        })
    }

    newApplicant(){
        console.log('Step 4');
       this[NavigationMixin.Navigate]({
           type:'standard__objectPage',
           attributes:{
               objectApiName:'Applicant__c',
               actionName:'new',
           },
       });
    }

    navigateToApplicant(){
       console.log('Applicant Id '+this.applicants);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.applicants.id,
                    objectApiName: 'Applicant__c',
                    actionName: 'view'
                },
            });
        
    }

}