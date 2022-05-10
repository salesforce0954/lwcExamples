import { LightningElement } from 'lwc';
import { registerListener,unregisterAllListeners } from './pubsub';

export default class LwcComponentB extends LightningElement {

    showFromComponentA;
    connectedCallback(){
        registerListener('CarSelectEvent',this.onCarChangeHandler,this);
    }

    disconnectedCallBack(){
        unregisterAllListeners(this);
    }

    onCarChangeHandler(payload){

           this.showFromComponentA = payload;
    }
}