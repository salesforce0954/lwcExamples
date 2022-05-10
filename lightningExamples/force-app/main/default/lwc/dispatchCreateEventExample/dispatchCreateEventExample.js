import { LightningElement,track } from 'lwc';

export default class DispatchCreateEventExample extends LightningElement {

    @track selectedValue = [{label:'Select',value:''}];
    @track options =[
{
    label:'Hyd',
    value:'Hyderabad'
},
{
    label:'Mum',
    value:'Mumbai'
},
{
    label:'Kol',
    value:'Kolkata'
}
    ]

    comboboxHandler(event){
        const displayOptions = new CustomEvent('displaycityoptions',{detail:this.options});
        this.dispatchEvent(displayOptions);
    }
}