import { LightningElement,track,wire } from 'lwc';
import getContactName from '@salesforce/apex/assignAccountToUsers.getContactName'
import { deleteRecord } from 'lightning/uiRecordApi';

export default class GetContactName extends LightningElement {
   @track recordId;
   @track conList;
   @track conArray=[];
   @track conValue;

   handleConValue(event){
       this.conValue = event.target.value;
   }
    getContactName(event){
     console.log(2);
      this.recordId = event.detail;
      console.log('Record id of account is '+this.recordId);
    
    
    }
    @wire(getContactName,{accId:'$recordId'})
    contactList({error,data}){
        if(data){
           this.conList = data;
          // this.conArray.push(this.conList);
          let i;
          for(i=0;i<=data.length;i++){
              console.log('Length :'+data.length);
            this.conArray = [{label:this.conList[i].LastName,value:this.conList[i].Id}]
            console.log('Id value '+this.conList[i].Id);
          }
          
        
           console.log('Contact name '+JSON.stringify(this.conList));
        }else if(error){
            console.log(error.body.message);
        }
    }


}