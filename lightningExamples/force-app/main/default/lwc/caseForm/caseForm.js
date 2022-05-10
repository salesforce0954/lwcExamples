import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CaseForm extends NavigationMixin(LightningElement) {
    @api contactId;
    @api accountId;
    @track fields ={};

    @api handleSubmitt(){
        this.fields.ContactId = this.contactId;
        this.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }

    handleSubjectChange(event){
     this.fields.Subject =event.target.value;
    }
    handleDescriptionChange(event){
        this.fields.Description =event.target.value;
    }
    handleOriginChange(event){
    this.fields.Origin =event.target.value;
    }

    handleSucess (){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
        const evt = new ShowToastEvent({
            message: "Account,Contact & Case has been created sucessfully",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }

}