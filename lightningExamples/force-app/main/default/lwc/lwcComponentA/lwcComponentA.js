import { LightningElement,wire } from 'lwc';
import {currentPageReference} from 'lightning/navigation';
import { fireEvent } from './pubsub';

export default class LwcComponentA extends LightningElement {

    @wire(currentPageReference) pageRef;
    
    carOptions = [
      {label:'BMW',value:'BMW'},
      {label:'Benz',value:'Benz'},
      {label:'Audi',value:'Audi'},
    ];
    selectedCar = '';

    

    carOptionHandler(event){
        fireEvent(this.pageRef,'CarSelectEvent',event.target.value);
    }
}