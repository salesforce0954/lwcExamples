import { LightningElement,track } from 'lwc';

export default class ParentChildP extends LightningElement {

    @track firstName = 'Suneel Desiraju';

    handleName(){
       // this.firstName = 'Suneel Desiraju';
       const fullName = this.firstName;
       this.template.querySelector('c-parent-child-c').handleFullName(fullName);
    }

    handleButtonClick(event){

        alert('Child Parent event called');
    }
}