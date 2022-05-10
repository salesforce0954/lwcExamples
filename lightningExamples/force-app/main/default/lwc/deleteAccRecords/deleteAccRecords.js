import { LightningElement,wire,api,track } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import fetchRecords from '@salesforce/apex/fetchAccountRecords.fetchRecords';

export default class deleteAccRecords extends LightningElement {

    @wire(fetchRecords)
    accounts;

    @api selectRecord;

    handleChange(event){
      this.selectRecord = event.target.value;
      console.log('selected id '+this.selectRecord);
    }

    handleDelete(){
      
       deleteRecord(this.selectRecord).then(response=>{
         return refreshApex(this.accounts);
       }).catch(error=>{
        this.error=error;
        console.log('unable to delete the record due to'+JSON.stringify(this.error));
       })

    }
}