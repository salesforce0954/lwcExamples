import { LightningElement,wire,track } from 'lwc';
import getAllApplicants from '@salesforce/apex/applicantInformation.getAllApplicants';


export default class WireExample extends LightningElement {

    @track nameSearch;
    @track applicantList;

    get applicantResponse(){
        if(this.applicantList){
            return true;
        }
        return false;
    }

    handleSearchName(event){
        this.nameSearch = event.target.value;
    }

    retrieveRecords(){
        getAllApplicants({searchName:this.nameSearch}).then(response=>{
            this.applicantList = response;
       }).catch(error=>{
           console.error(error.body.message);
       })
    }
   
    
}