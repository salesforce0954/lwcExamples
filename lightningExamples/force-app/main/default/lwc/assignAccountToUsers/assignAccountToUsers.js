import { LightningElement,wire,api,track } from 'lwc';
import fetchAccounts from '@salesforce/apex/assignAccountToUsers.fetchAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex'
import { deleteRecord } from 'lightning/uiRecordApi';

export default class AssignAccountToUsers extends LightningElement {

@wire(fetchAccounts)
accountList;

@track currentRecordId;

selectAccRecords(event){
   
 if(event.target.checked == true){
    this.currentRecordId = event.target.value;
 }else{
     alert('Please select the checkbox');
 }
  
  console.log('Record Id' + this.currentRecordId);
}

getContactName(){
    console.log(1);
    console.log('recordId '+this.currentRecordId);
    const conName = new CustomEvent('contactname',{detail:this.currentRecordId});
    this.dispatchEvent(conName);
}

deleteAccount(){
    
    deleteRecord(this.currentRecordId).then(response=>{
        refreshApex(this.accountList);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record deleted',
                variant: 'success'
            })
        );  
    }).catch(error=>{
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error deleting record',
                message: error.body.message,
                variant: 'error'
            })
        );
    })
       
}
}