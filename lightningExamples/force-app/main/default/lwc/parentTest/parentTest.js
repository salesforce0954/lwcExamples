import { LightningElement,api} from 'lwc';

export default class ParentTest extends LightningElement {
 @api firstName;
 @api
 getFirstName(param){
     this.firstName = param;
 }

}