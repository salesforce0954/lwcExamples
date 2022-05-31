import { LightningElement,wire,api,track } from 'lwc';
import fetchApplication from '@salesforce/apex/retrieveApplicationInformation.getApplication'

export default class MapExample extends LightningElement {
   
    @api recordId;
   //@track res;
    @track mapArray =[];
   /**@wire(fetchApplication,{id:this.recordId})
   wiredResult({data,error}){
        if(data){
            this.res = data;
            console.log('Data of Map '+this.res);
           for(var key in this.res){
                this.mapArray.push({value:res[key],key:key})
            }
            console.log('MAP ARRAY '+JSON.stringify(this.mapArray)); 
            
        }
    } */

   connectedCallback(){
        fetchApplication({id:this.recordId}).then(response=>{
            if(response){
                var res = response;
                for(var key in res){
                    this.mapArray.push({value:res[key],key:key})
                }
            }
        })
    } 
}