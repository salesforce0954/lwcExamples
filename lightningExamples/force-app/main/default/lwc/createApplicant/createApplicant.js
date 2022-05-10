import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class CreateApplicant extends LightningElement {


    handleLoad(event){
        console.log('Type of Event '+event.type);
        console.log('Detail Event '+event.detail);
    }


    handleSubmit(event){
        console.log('Submit Type of Event '+event.type);
        console.log('Submit Detail Event '+event.detail);
    }

    handleSuccess(event){
        console.log('Success Type of Event '+event.type);
        console.log('Success Detail Event '+event.detail);
        const toastMessage = new ShowToastEvent({
            title:'Successfully Loaded',
            message : 'successfully saved',
            variant : 'Success'

        });
        this.dispatchEvent(toastMessage);
    }
}