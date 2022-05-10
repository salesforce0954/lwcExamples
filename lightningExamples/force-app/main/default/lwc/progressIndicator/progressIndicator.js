import { LightningElement,track } from 'lwc';

export default class ProgressIndicator extends LightningElement {


@track steps = [{
   label:'About',value:'Step 1'
},
{
    label:'Personal Details Page',value:'Step 2'
}];
}