import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import BP_LBL_BASE_URL from '@salesforce/label/c.BP_LBL_BASE_URL';

export default class BrokerInvoiceCmp extends NavigationMixin(LightningElement) {
    @track showSpinner = true;
    @track finishLoad = false;
    @track fullName;
    @track loanNumber;
    @track applicationStatus;
    @track applicationId;
    @track applicantId;

    connectedCallback() {
        this.fullName='';
        this.loanNumber='';
        this.applicationStatus='';

        let param = JSON.parse(sessionStorage.getItem('BI_applicationDetail'));
        if(param != null) {
            this.fullName = param.fullName;
            this.loanNumber = param.loanNumber;
            this.applicationStatus = param.statusForDisplay;
            this.applicationId = param.applicationId;
            this.applicantId = param.primaryApplicantId;
        }
        this.finishLoad = true;
        this.showSpinner = false;
    }

    handleFinish(event) {
        //let applicationFormUrl = BP_LBL_BASE_URL + 's/applicationdetails';
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/applicationdetails');           
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });
    }    
}