import { LightningElement,track } from 'lwc';


export default class ChildParentSearch extends LightningElement {

    @track numberOfRecords;

    handleNumberOfRecords(event){
        this.numberOfRecords = event.target.value;
    }

    retrieveApplicantRecords(){
        console.log('STEP 1'+this.numberOfRecords);
        const triggerInput = new CustomEvent("getapplicantrecords",{detail:this.numberOfRecords});
        this.dispatchEvent(triggerInput);
    }
    
}