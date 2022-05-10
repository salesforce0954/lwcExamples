import { LightningElement,track } from 'lwc';

export default class ParentTestContainer extends LightningElement {

    @track myName;

    getName(){
        this.myName = 'Suneel Desiraju';
        this.template.querySelector('c-parent-test').getFirstName(this.myName);
    }
    

}