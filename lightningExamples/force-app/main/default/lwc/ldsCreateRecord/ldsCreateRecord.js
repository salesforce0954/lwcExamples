import { LightningElement,track,wire } from 'lwc';
import { createRecord,getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';
const fieldArray = [NAME_FIELD,PHONE_FIELD,WEBSITE_FIELD];
export default class LdsCreateRecord extends LightningElement {

@track accountName;
@track accountPhone;
@track accountWebsite;
@track recordId;

@wire(getRecord,{recordId:'$recordId',fields:fieldArray})
accounts;

accountNameChangeHandler(event){
    this.accountName = event.target.value;
}

accountPhoneChangeHandler(event){
    this.accountPhone = event.target.value;
}

accountWebsiteChangeHandler(event){
    this.accountWebsite = event.target.value;
}

createAccountRecord(){
    const fields = {'Name':this.accountName,'Phone':this.accountPhone,'Website':this.accountWebsite};
    const recordInput = {apiName:'Account',fields};

    createRecord(recordInput).then(response=>{
        console.log('Successfully Record created '+response.id);
        this.recordId = response.id;
    }).catch(error=>{
        console.error('Error found'+error.body.message);
    });
}

get retAccountName(){
    if(this.accounts.data){
    return this.accounts.data.fields.Name.value;
    }
    return undefined;
}

get retAccountPhone(){
    if(this.accounts.data){
    return this.accounts.data.fields.Phone.value;
    }
    return undefined;
}

get retAccountURL(){
    if(this.accounts.data){
    return this.accounts.data.fields.Website.value;
    }
    return undefined;
}

}