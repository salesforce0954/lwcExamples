import { LightningElement, track } from 'lwc';

export default class ParentContainer extends LightningElement {
    
    @track recordId;
    handleapplicationrecord(event){
        console.log('Entered');
      this.recordId = event.detail;
      console.log('Record id'+event.detail);
      console.log('Record id 1'+event.detail.id);
      console.log('record id 2'+event.detail.recordId);
    }
}