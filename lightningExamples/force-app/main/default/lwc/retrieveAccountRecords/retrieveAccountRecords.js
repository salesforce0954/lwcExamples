import { LightningElement,wire,track} from 'lwc';
import getAccounts from '@salesforce/apex/retrieveAccountRecords.getAccounts'


export default class RetrieveAccountRecords extends LightningElement {
   
    @track lstAccounts;
    @track showAccounts = false;

   /**  @wire(getAccounts) accountData ({data,error}){
           if(data){
            this.lstAccounts = data;

           }else if(error){
            this.lstAccounts = error;
           }
    } */

    accountRetrieval(){
        console.log(1);
        getAccounts().then(result => {
            this.lstaccounts = result;
            this.error = undefined;
            console.log('Result '+JSON.stringify(this.lstaccounts));
        }).catch(error => {
            this.error = error;
            this.lstaccounts = undefined;
            console.log('Error '+error.body.message);
        });
    }

}