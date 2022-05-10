import { LightningElement,track } from 'lwc';

export default class DispatchCreateEventExampleParent extends LightningElement {
    
    @track optionResult;
    displayCityOptionsHandler(event){
        alert(event.detail.value);
       this.optionResult = event.detail.values;
    }
}