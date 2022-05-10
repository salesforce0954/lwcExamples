import { LightningElement,api,wire,track } from 'lwc';
import getCars from '@salesforce/apex/CarSearchResultController.getCars'

export default class CarSearchResultController extends LightningElement {

    @api carTypeId;
    @track carData;
    @wire(getCars,{carTypeId:'$carTypeId'})
    carResult({data,error}){
        if(data){
            this.carData = data;
        console.log('Result '+JSON.stringify(data));
      }else{
          console.log('Error '+JSON.stringify(error));
      }
}


}