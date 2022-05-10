import { LightningElement, track, api } from 'lwc';

export default class AccountForm extends LightningElement {

    @track fields = {};

    @api handleSubmitt() {
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }

    handleNameChange(event) {
        this.fields.Name = event.target.value;
    }

    handleSucess(event) {
        const accountId = event.detail.id;
        console.log('Account Id :'+accountId);
        const selectEvent = new CustomEvent('accountid', {
            detail: accountId
        });
        this.dispatchEvent(selectEvent);
    } 

    handleLoad(event){
        console.log('Type '+event.type);
        console.log('Detail '+event.detail);
    }

    handleSubmit(event){
        console.log('Submit '+event.type);
        console.log('Submit detail '+event.detail);
    }
}