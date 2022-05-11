import { track, wire, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getApplicationCopy from '@salesforce/apex/BrokerSubmittedEntities.getAppCopyDocument';
import getApplicationStatus from '@salesforce/apex/BrokerSubmittedEntities.getApplicationStatus';
import loadClientPaymentDetailsData from '@salesforce/apex/ClientPaymentDetailsController.loadClientPaymentDetailsData';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

const listOfActions = [
    { label: 'Upload documents', name: 'upload_documents', value: 'upload_documents', iconName: 'action:upload', order:1},    
    { label: 'Set up payment details', name: 'client_payment_details', value: 'client_payment_details', iconName: 'utility:money', order:2},      
    { label: 'Upload Broker invoice', name: 'broker_invoice', value: 'broker_invoice', iconName: 'action:add_file', order:3},                                                              
    { label: 'Download copy of application', name: 'download_copy_of_app', value: 'download_copy_of_app', iconName: 'action:download', order:4},
    { label: 'Download copy of contract', name: 'download_copy_of_contract', value: 'download_copy_of_contract', iconName: 'action:download', order:5}
];

export default class ApplicationDetailsCmp extends NavigationMixin(LightningElement) {
    @track currentDetail;
    @track actions;
    @track subActions;
    @track subActionsExist = false;
    @track loaded = false;
    @track showSpinner = true;
    @track showVerifyDOBModal = false;
    @track dobModalHeading= '';
    @track day;
    @track month;
    @track year;    
    @track devMode = false;
    @track isSmallerDevice = false;
    @track isUploadDocuments = false;
    @track statusDescription = '';
    documentName;

    connectedCallback() {
        this.showSpinner = true;
        this.currentDetail = JSON.parse(sessionStorage.getItem("AD_details"));

        getApplicationStatus({
            applicationId: this.currentDetail.applicationId
        }).then(status => {
            this.currentDetail.applicationStatus = status[0];
            this.currentDetail.statusForDisplay = status[1];
            this.currentDetail.statusDescription = status[2];
            if(this.currentDetail.statusForDisplay == 'Upload documents') {
                this.isUploadDocuments = true;
            } else {
                this.isUploadDocuments = false;
            }            
            loadClientPaymentDetailsData({
                applicationId: this.currentDetail.applicationId
            }).then(result => {
                let hasDD = result.hasOwnProperty('directDebit');
                let hasDC = result.hasOwnProperty('directCredit');
                if(hasDD == true) {
                    this.currentDetail.ddExist = true;
                } else {
                    this.currentDetail.ddExist = false;
                }
                if(hasDC) {
                    this.currentDetail.dcExist = true;
                } else {
                    this.currentDetail.dcExist = false;
                }
                if(result.otherDebit) {
                    this.currentDetail.hasAnotherDebit = true;
                } else {
                    this.currentDetail.hasAnotherDebit = false;
                }
                if(result.otherCredit) {
                    this.currentDetail.hasAnotherCredit = true;
                } else {
                    this.currentDetail.hasAnotherCredit = false;
                }
                
                this.actions = this.defineListOfActions(this.currentDetail.applicationStatus);

                if(FORM_FACTOR === 'Small') {
                    this.isSmallerDevice = true;
                }
                /*if(this.actions.length > 3) {
                    this.subActions = this.actions.slice(2,this.actions.length);
                    this.subActionsExist = true;
                    this.actions = this.actions.slice(0,2);
                }*/
                this.loaded = true;
                this.showSpinner = false;            
            }).catch(error => {
                this.loaded = true;
                this.showSpinner = false;
                console.error(error);
            });

        }).catch(error => {
            console.error(error);
        });
    }

    defineListOfActions(status) {
        if(this.devMode) {
            return listOfActions;
        }

        let rowActions = [];
        status = status.toLowerCase();
        switch(status) {
            case "ID required".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "client_payment_details" ||
                    element.name === "broker_invoice" ||
                    element.name === "upload_documents";
                });
                break;
            case "Proof of Income required".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "client_payment_details" ||
                    element.name === "broker_invoice" ||
                    element.name === "upload_documents";
                });
                break;
            case "ID & Proof of Income required".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "client_payment_details" ||
                    element.name === "broker_invoice" ||
                    element.name === "upload_documents";
                });
                break;
            case "Referred".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "upload_documents";
                });
                break;
            case "Contract Accepted".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app"
                });
                break;
            case "Conditionally Approved".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "broker_invoice" ||
                    element.name === "client_payment_details"
                });
                break; 
            case "Pending contract acceptance".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app"
                });
                break;                 
            case "Account created".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app" ||
                    element.name === "download_copy_of_contract";
                });
                break;                
            case "Cancelled".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app"
                });
                break;   
            case "Declined".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app"
                });
                break; 
            case "Awaiting Response".toLowerCase():
                rowActions = listOfActions.filter((element) => {
                    return element.name === "download_copy_of_app"
                });
                break;                                                                                               
            default:
                rowActions=[];
                break;
        }     
        
        //check if joint application or is only debt consolitaion and the action has dd/dc
        if(this.currentDetail.isOnlyDebtConsolidation || this.currentDetail.isJointApplication || 
            (this.currentDetail.hasAnotherDebit && this.currentDetail.hasAnotherCredit) || 
            (this.currentDetail.ddExist && this.currentDetail.dcExist) ||
            (this.currentDetail.ddExist && this.currentDetail.hasAnotherCredit) ||
            (this.currentDetail.dcExist && this.currentDetail.hasAnotherDebit)) {
            let index = rowActions.findIndex((elem) => {
                return elem.name === 'client_payment_details';
            })
            if(index >= 0) {
                rowActions.splice(index,1);
            }
        }

        return rowActions;
    }    

    handleButtonNavigation(event) {
        let actionName = event.currentTarget.dataset.act;
        switch (actionName) {
            case 'upload_documents':
                this.handleUploadDocuments();
                break;
            case 'download_copy_of_app':
                this.handleAppCopyDownload();
                this.dobModalHeading = 'Download Copy of Application';
                break;
            case 'broker_invoice':
                this.handleBrokerInvoice();
                break;
            case 'client_payment_details':
                this.handleClientPaymentDetails();
                break;
            case 'download_copy_of_contract':
                this.handleAppContractDownload();
                this.dobModalHeading = 'Download Copy of Contract';
                break;
            default:
                break;
        }        
    }

    handleUploadDocuments() {
        //console.log('enter');
        //let applicationFormUrl = BP_LBL_BASE_URL + 's/uploaddocuments';
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/uploaddocuments');        
        sessionStorage.setItem('UD_applicationId', this.currentDetail.applicationId);
        sessionStorage.setItem('UD_status', this.currentDetail.applicationStatus);
        sessionStorage.setItem('UD_statusForDisplay', this.currentDetail.statusForDisplay);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });
    }

    handleBrokerInvoice() {
        //let applicationFormUrl = BP_LBL_BASE_URL + 's/brokerinvoice';
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/brokerinvoice');           
        sessionStorage.setItem('BI_applicationDetail', JSON.stringify(this.currentDetail));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });
    }

    handleClientPaymentDetails() {
        //let applicationFormUrl = BP_LBL_BASE_URL + 's/clientpaymentdetails';
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/clientpaymentdetails');           
        sessionStorage.setItem('CPD_applicationDetail', JSON.stringify(this.currentDetail));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });
    }    

    handleAppCopyDownload() {
        this.showVerifyDOBModal = true;
    }    

    handleAppContractDownload() {
        this.showVerifyDOBModal = true;
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
            applicationId: this.currentDetail.applicationId,
            user_dateOfBirth: userDateOfBirth,
            documentName: this.documentName,
            entityName: this.currentDetail.applicationName
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
                        var uId = this.currentDetail.loanNumber;
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

    handleBack(event) {
        //let applicationFormUrl = BP_LBL_BASE_URL + 's/applications';
        let applicationFormUrl = window.location.href;
        applicationFormUrl = applicationFormUrl.replace(/\/[^\/]*$/, '/applications');             
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: applicationFormUrl
            },
        });
    }    

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
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

    get selectedAppId() {
        return this.currentDetail.applicationId;
    }    
}