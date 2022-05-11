import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import getApplications from '@salesforce/apex/BrokerSubmittedEntities.getApplications';
import getBrokerId from '@salesforce/apex/BrokerSubmittedEntities.getBrokerId';
import getApplicationCopy from '@salesforce/apex/BrokerSubmittedEntities.getAppCopyDocument';
import { NavigationMixin } from 'lightning/navigation';
import BP_LBL_BASE_URL from '@salesforce/label/c.BP_LBL_BASE_URL';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

const applicationColumns = [{
    label: 'Loan Number',
    fieldName: 'loanNumber',
    initialWidth: 180,
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Name',
    fieldName: 'fullName',
    initialWidth: 230,
    sortable: true,
    hideDefaultActions: true,
},
{
    label: 'Loan Amount',
    fieldName: 'loanAmount',
    type: 'currency',
    initialWidth: 170,
    cellAttributes: { alignment: 'left' },
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Loan Term',
    fieldName: 'loanTerm',
    initialWidth: 180,
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Application Type',
    fieldName: 'applicationType',
    initialWidth: 150,
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Application Status',
    type: 'textWithTooltip',
    initialWidth: 170,
    typeAttributes: {
        status: {fieldName: 'statusForDisplay'},
        description: {fieldName: 'statusDescription'},
        currentRecord: {fieldName: 'currentRecord'}
    },
    fieldName: 'statusForDisplay',
    sortable: true,
    hideDefaultActions: true
},
{
    initialWidth: 180,
    type: "button", typeAttributes: {
        label: 'View application',
        name: 'View',
        title: 'View',
        disabled: false,
        value: 'view',
        iconPosition: 'left'
    }    
}];


const listOfActions = [
    { label: 'View application details', name: 'show_details', value: 'show_details', iconName: 'action:preview', order:1 },
    { label: 'Upload documents', name: 'upload_documents', value: 'upload_documents', iconName: 'action:upload', order:2},    
    { label: 'Set up payment details', name: 'client_payment_details', value: 'client_payment_details', iconName: 'utility:money', order:3 },      
    { label: 'Upload broker invoice', name: 'broker_invoice', value: 'broker_invoice', iconName: 'action:add_file', order:4 },                                                              
    { label: 'Download copy of application', name: 'download_copy_of_app', value: 'download_copy_of_app', iconName: 'action:download', order:5 },
    { label: 'Download copy of contract', name: 'download_copy_of_contract', value: 'download_copy_of_contract', iconName: 'action:download', order:6}
];

export default class BrokerSubmittedApplications extends NavigationMixin(LightningElement) {

    brokerId;
    brokerDetails;
    columns;
    actions;
    @track data = [];
    @track error;
    @track applicationId;
    @track loanNumber;
    @track numberOfRecords = 0;
    @track isLastPage = false;
    @track hasPageChanged;
    @track loanNumber;
    @track pageNumber = 1;
    @track pageSize = 10;
    @track resultSize = 0;
    @track applicantName;
    @track showVerifyDOBModal = false;
    @track day;
    @track month;
    @track year;
    @track statusReffered = false;
    @track showDetailModal = false;
    @track showUploadDocumentsModal = false;
    @track currentRowDetail;
    showSpinner = false;
    fromDetailModal = false;
    dobModalHeading;
    documentName;
    devMode = false;


    @wire(getBrokerId)
    handleResponse(response) {
        this.columns = applicationColumns;
        this.actions = listOfActions;
        if (response.data) {
            this.showSpinner = true;
            this.getBrokerApplications();
        }
    }

    getBrokerApplications() {
        getApplications({
            loanNumber: this.loanNumber,
            applicantName: this.applicantName
        })
            .then(result => {
                //logic for row actions
                for(let row of result) {
                    let currRow = {
                        applicationId: row.applicationId,
                        loanNumber: row.loanNumber,
                        applicationName: row.applicationName,
                        applicationType: row.applicationType,
                        applicationStatus: row.status,
                        statusForDisplay: row.statusForDisplay,
                        statusDescription: row.statusDescription,
                        loanAmount: row.loanAmount,
                        loanTerm: row.loanTerm,
                        loanPurpose: row.loanPurpose,
                        firstName: row.firstName,
                        lastName: row.lastName,
                        fullName: row.firstName + ' ' + row.lastName,
                        brokerName: row.brokerName,
                        email: row.email,
                        mobile: row.mobile,
                        hasAnotherDebit: row.hasAnotherDebit,
                        hasAnotherCredit: row.hasAnotherCredit,
                        ddExist: row.ddExist,
                        dcExist: row.dcExist,
                        isOnlyDebtConsolidation: row.isOnlyDebtConsolidation,
                        offeredInterestRate: row.offeredInterestRate / 100,
                        isJointApplication: false                        
                    }
                    row.currentRecord = currRow;
                }
                this.data = result;
                this.showSpinner = false;
                this.numberOfRecords = this.data.length;
            })
            .catch(error => {
                console.log(error);
                this.showSpinner = false;
                this.error = error;
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.statusReffered = false;
        this.applicationId = row.applicationId;
        this.currentRowDetail = {
            applicationId: this.applicationId,
            loanNumber: row.loanNumber,
            applicationName: row.applicationName,
            applicationType: row.applicationType,
            applicationStatus: row.status,
            statusForDisplay: row.statusForDisplay,
            statusDescription: row.statusDescription,
            loanAmount: row.loanAmount,
            loanTerm: row.loanTerm,
            loanPurpose: row.loanPurpose,
            firstName: row.firstName,
            lastName: row.lastName,
            fullName: row.firstName + ' ' + row.lastName,
            brokerName: row.brokerName,
            email: row.email,
            mobile: row.mobile,
            hasAnotherDebit: row.hasAnotherDebit,
            hasAnotherCredit: row.hasAnotherCredit,
            ddExist: row.ddExist,
            dcExist: row.dcExist,
            isOnlyDebtConsolidation: row.isOnlyDebtConsolidation,
            offeredInterestRate: row.offeredInterestRate / 100,
            isJointApplication: false
        };

        if(row.hasOwnProperty("secondaryApplicant")) {
            this.currentRowDetail.secondaryApplicant = row.secondaryApplicant;
            this.currentRowDetail.isJointApplication = true;
        }

        this.currentRowDetail.primaryApplicantId = row.applicantId;
        
        if (row.status === "Referred") {
            this.statusReffered = true;
        }
        switch (actionName) {
            case 'View':
                this.handleOpenApplicationDetails();
                break; 
            default:
                break;
        }
    }

    openDetails(rowParam) {
        this.fromDetailModal = true;
        this.showDetailModal = true;
    }

    getSelectedApp(event) {
        const selectedRows = event.detail.selectedRows;
        //console.log('selectedRows Id : ', selectedRows[0].Id);
        this.applicationId = selectedRows[0].applicationId;
        this.loanNumber = selectedRows[0].loanNumber;
    }

    handleOpenApplicationDetails() {
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/applicationdetails');

        //let applicationFormUrl = BP_LBL_BASE_URL + 's/applicationdetails';
        sessionStorage.setItem('AD_details', JSON.stringify(this.currentRowDetail));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });        
    }

    handleAppCopyDownload() {
        this.showDetailModal = false;
        if (typeof this.applicationId === 'undefined' || this.applicationId === '') {
            this.showToast('Error', 'Please select a record.', 'error');
            return;
        }
        this.showVerifyDOBModal = true;
    }

    handleAppContractDownload() {
        this.showDetailModal = false;
        this.showVerifyDOBModal = true;
    }

    closeDetailModal() {
        this.fromDetailModal = false;
        this.applicationId = '';
        this.showDetailModal = false;
    }

    closeVerifyDOBModal() {
        this.showVerifyDOBModal = false;
        if (this.fromDetailModal) {
            this.showDetailModal = true;
        }
    }

    verifyDOBAppCopyDownload() {

        // if (this.day === undefined || this.month === undefined || this.year === undefined) {
        //     this.showToast('Error', 'Please enter a date of birth.', 'error');
        //     return;
        // }
        // let user_dateOfBirth = this.day + '/' + this.month + '/' + this.year;
        // getApplicationCopy({
        //     applicationId: this.applicationId,
        //     user_dateOfBirth: user_dateOfBirth
        // })
        //     .then(result => {

        //         if (result === 'NOT_FOUND') {
        //             this.showToast('Error', 'Copy of Application is currently not available for download.', 'error');
        //         } else if (result === 'DOB_NOT_VALID') {
        //             this.showToast('Error', 'Date of birth is incorrect. Please try again.', 'error');
        //         } else if (result === 'MAX_ATTEMPTS_REACHED') {
        //             this.showToast('Error', "You’ve reached the maximum number of attempts to verify your identity. Please call us on 1800 035 902 so we can assist you with your application.", 'error');
        //         } else if (result === 'INVALID_DATE_OF_BIRTH') {
        //             this.showToast('Error', "Invalid Date of birth. Please try again.", 'error');
        //         } else {
        //             var b64Data = result;
        //             if (b64Data != '') {
        //                 var contentType = 'application/pdf';
        //                 var sliceSize = 512;
        //                 var byteCharacters = atob(b64Data);
        //                 var byteArrays = [];
        //                 for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
        //                     var slice = byteCharacters.slice(offset, offset + sliceSize);
        //                     var byteNumbers = new Array(slice.length);
        //                     for (var i = 0; i < slice.length; i++) {
        //                         byteNumbers[i] = slice.charCodeAt(i);
        //                     }
        //                     var byteArray = new Uint8Array(byteNumbers);
        //                     byteArrays.push(byteArray);
        //                 }

        //                 var blob = new Blob(byteArrays, { type: contentType });
        //                 var blobUrl = URL.createObjectURL(blob);
        //                 var uId = this.loanNumber;
        //                 //window.location = blobUrl;
        //                 this.autoDownloadFile(blob, uId);
        //                 this.showVerifyDOBModal = false;
        //                 this.day = undefined;
        //                 this.month = undefined;
        //                 this.year = undefined;

        //             }
        //         }

        //     })
        //     .catch(error => {
        //         this.error = error;
        //     })

    }

    /* Generic event for showing a toast message
       on the page.
    */
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    get applicationsFound() {
        if (this.numberOfRecords === 0)
            return false;
        else
            return true;
    }

    autoDownloadFile(blob, uId) {

        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        if (typeof uId === 'undefined' && this.documentName === 'Copy of Application') {
            a.download = this.documentName;
        } else if (typeof uId === 'undefined' && this.documentName === 'Copy of Contract') {
            a.download = this.documentName;
        } else {
            a.download = uId + '_' + this.documentName;
        }

        const clickHandler = () => {
            setTimeout(() => {
                URL.revokeObjectURL(url);
                this.removeEventListener('click', clickHandler);
            }, 150);
        };
        a.click();
    }

    get disablePrev() {
        return this.pageNumber === 1 ? true : false;
    }

    handlePrev() {
        //Setting current page number
        let pageNumber = this.pageNumber;
        this.pageNumber = pageNumber - 1;
        //Setting pageChange variable to true
        this.hasPageChanged = true;
        this.applicationId = undefined;
        this.loanNumber = undefined;
        this.getBrokerApplications();
    }

    handleNext() {
        //get current page number
        let pageNumber = this.pageNumber;
        //Setting current page number
        this.pageNumber = pageNumber + 1;
        //Setting pageChange variable to true
        this.hasPageChanged = true;
        this.applicationId = undefined;
        this.loanNumber = undefined;
        this.getBrokerApplications();
    }

    handleLoanNumber(event) {
        this.loanNumber = event.target.value;
    }

    handleApplicantName(event) {
        this.applicantName = event.target.value;
    }

    handleApplicationSearch(event) {
        this.getBrokerApplications();
    }

    handleCloseVerifyDOB() {
        this.showVerifyDOBModal = false;
    }

    handleVerifyDob(event) {
        let userDateOfBirth = event.detail.userDateOfBirth;

        if (this.dobModalHeading !== undefined && this.dobModalHeading.includes('Application')) {
            this.documentName = 'Copy of Application';
        } else if (this.dobModalHeading !== undefined && this.dobModalHeading.includes('Contract')) {
            this.documentName = 'Copy of Contract';
        }
        getApplicationCopy({
            applicationId: this.applicationId,
            user_dateOfBirth: userDateOfBirth,
            documentName: this.documentName,
            entityName: this.currentRowDetail.applicationName
        })
            .then(result => {

                if (result === 'NOT_FOUND') {
                    this.showToast('Error', this.documentName + ' is currently not available for download.', 'error');
                    this.showVerifyDOBModal = false;
                } else if (result === 'DOB_NOT_VALID') {
                    this.showToast('Error', 'Date of birth is incorrect. Please try again.', 'error');
                } else if (result === 'MAX_ATTEMPTS_REACHED') {
                    this.showToast('Error', "You’ve reached the maximum number of attempts to verify your identity. Please call us on 1800 035 902 so we can assist you with your application.", 'error');
                    this.showVerifyDOBModal = false;
                } else if (result === 'INVALID_DATE_OF_BIRTH') {
                    this.showToast('Error', "Invalid Date of birth. Please try again.", 'error');
                } else {
                    var b64Data = result;
                    if (b64Data != '') {
                        var contentType = 'application/pdf';
                        var sliceSize = 512;
                        var byteCharacters = atob(b64Data);
                        var byteArrays = [];
                        for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                            var slice = byteCharacters.slice(offset, offset + sliceSize);
                            var byteNumbers = new Array(slice.length);
                            for (var i = 0; i < slice.length; i++) {
                                byteNumbers[i] = slice.charCodeAt(i);
                            }
                            var byteArray = new Uint8Array(byteNumbers);
                            byteArrays.push(byteArray);
                        }

                        var blob = new Blob(byteArrays, { type: contentType });
                        var blobUrl = URL.createObjectURL(blob);
                        var uId = this.currentRowDetail.loanNumber;
                        //window.location = blobUrl;
                        this.autoDownloadFile(blob, uId);
                        this.showVerifyDOBModal = false;
                        this.day = undefined;
                        this.month = undefined;
                        this.year = undefined;

                    }
                }

            })
            .catch(error => {
                this.error = error;
            })
    }

    get selectedAppId() {
        return this.applicationId;
    }

}