import { LightningElement,api } from 'lwc';

export default class ParentChildC extends LightningElement {

  @api firstName;

  @api
  handleFullName(fullName){
      alert('My full Name is '+fullName);
  }
  

  handleChildEvent(){
      const text = new CustomEvent('clickbutton');
      this.dispatchEvent(text);
  }
}