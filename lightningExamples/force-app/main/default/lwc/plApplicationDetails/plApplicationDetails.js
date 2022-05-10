import { LightningElement,track } from 'lwc';
import getApplicationDetails from '@salesforce/apex/PL_ApplicationDetails.getApplicationInfo'
import getApplicantDetails from '@salesforce/apex/PL_ApplicationDetails.getApplicantInfo'
import { NavigationMixin } from 'lightning/navigation';

export default class PlApplicationDetails extends NavigationMixin(LightningElement){

    @track applicationId;
       connectedCallback(){
           this.applicationId = localStorage.getItem('application_id');
       }

}