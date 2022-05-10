import { LightningElement,track } from 'lwc';

export default class CarFinalResult extends LightningElement {

   @track carId;
   handleCarTypeSelect(event){
        console.log('Entered car final ')
     this.carId = event.detail;
    }
}