import { LightningElement,track,api,wire } from 'lwc';
import getCarTypes from '@salesforce/apex/CarSearchFormController.getCarTypes';

export default class CarTypeController extends LightningElement {

    @api recordId;
    @track cartypes = [];

    connectedCallback(){
        getCarTypes({}).then(response=>{
              console.log('Response '+JSON.stringify(response))
              this.cartypes = [{label:'All Types',value:''}]
              response.forEach(element=>{
                  const cartype ={};                 
                  cartype.label=element.Name;
                  cartype.value=element.Id;                  
                 this.cartypes.push(cartype);
              } )
              console.log('Car Types '+JSON.stringify(this.cartypes));

        }).catch(error=>{
            console.log('Error '+JSON.stringify(error));
        })
    }

    handleCarTypeChange(event){
        const carTypeId = event.detail.value;
        console.log('Car Type Id '+carTypeId);
        const eventInfo = new CustomEvent('cartypeselect',{detail:carTypeId});
        this.dispatchEvent(eventInfo);
    }

}