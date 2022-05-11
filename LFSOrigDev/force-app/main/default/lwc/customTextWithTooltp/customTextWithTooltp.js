import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomTextWithTooltp extends NavigationMixin(LightningElement) {
    @api status;
    @api statusDescription;
    @api currentRecord;
    @track isUploadDocuments = false;

    connectedCallback() {
        if(this.status == 'Upload documents') {
            this.isUploadDocuments = true;
        } else {
            this.isUploadDocuments = false;
        }
    }

    handleUploadDocNav(event) {
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/uploaddocuments');        
        sessionStorage.setItem('UD_applicationId', this.currentRecord.applicationId);
        sessionStorage.setItem('UD_status', this.currentRecord.applicationStatus);
        sessionStorage.setItem('UD_statusForDisplay', this.currentRecord.statusForDisplay);
        sessionStorage.setItem('AD_details', JSON.stringify(this.currentRecord));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        }); 
    }
}