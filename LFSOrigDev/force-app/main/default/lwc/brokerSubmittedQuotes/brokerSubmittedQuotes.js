import {
    LightningElement,
    track,
    wire
} from 'lwc';
import getQuotes from '@salesforce/apex/BrokerSubmittedEntities.getQuotes';
import getBrokerId from '@salesforce/apex/BrokerSubmittedEntities.getBrokerId';
import getBrokerRecordForPrint from '@salesforce/apex/BrokerSubmittedEntities.getBrokerRecordForPrint';
import getStatusAndEncryptedQuote from '@salesforce/apex/BrokerSubmittedEntities.getStatusAndEncryptedQuote';
import getConvertedToAppNotes from '@salesforce/apex/BrokerSubmittedEntities.getConvertedToAppNotes';
import generateQuotePrintablePage from '@salesforce/apex/BrokerSubmittedEntities.generateQuotePrintablePage';
import createNote from '@salesforce/apex/BrokerSubmittedEntities.createNote';
import { NavigationMixin } from 'lightning/navigation';
import BP_LBL_Quotes_Amount_Disclaimer from '@salesforce/label/c.BP_LBL_Quotes_Amount_Disclaimer';
import BP_LBL_BASE_URL from '@salesforce/label/c.BP_LBL_BASE_URL';



import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';


const quoteColumns = [{
    label: 'Reference',
    fieldName: 'Name',
    hideDefaultActions: true
},
{
    label: 'First Name',
    fieldName: 'First_Name__c',
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Last Name',
    fieldName: 'Last_Name__c',
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Mobile Number',
    fieldName: 'Mobile_Number__c',
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Email',
    fieldName: 'Email_ID__c',
    sortable: true,
    hideDefaultActions: true
},
{
    label: 'Status',
    fieldName: 'Quote_Stage__c',
    sortable: true,
    hideDefaultActions: true
},
{
    type: "button", typeAttributes: {
        label: 'View quote',
        name: 'View',
        title: 'View',
        disabled: false,
        value: 'view',
        iconPosition: 'left'
    }
}
];

const notesColumns = [{
    label: 'Description', fieldName: 'Body'
}
];
export default class BrokerSubmittedQuotes extends NavigationMixin(LightningElement) {

    brokerId;
    disclaimer = BP_LBL_Quotes_Amount_Disclaimer;
    brokerDetails;
    columns;
    notesColumns;
    @track data = [];
    error;
    quotes;
    @track selectedQuoteId;
    @track quoteStatus;
    @track emailId;
    @track mobileNumber;
    @track pageNumber = 1;
    @track pageSize = 10;
    @track isLastPage = false;
    @track resultSize = 0;
    @track hasPageChanged;
    @track numberOfRecords = 0;
    @track showModal = false;
    @track showLogoutModal = false;
    @track recordId;
    @track encryptedURL;
    @track showConvertToApp = false;
    @track currentRecordBrokerId;
    @track currentRecordBrokerName;
    @track brokerValidatedEmailId;
    @track quoteNotes = [];
    @track showNotes = false;
    @track notesFound = false;
    @track showDeclineSection = false;
    @track showVerifyDOBModal = false;
    @track day;
    @track month;
    @track year;
    firstName;
    lastName;
    dateOfBirth;
    quoteEmailId;
    quoteMobileNumber;
    quoteReference;
    loanAmount;
    loanPurpose;
    loanTerm;
    interestRateOffered;
    securedRateOffered;
    quoteStage;
    quoteExpiresOn;
    quoteDeclinedOn;
    productType;
    isBetterStart = false;
    showAppForm = false;
    showSpinner = false;
    showCancelQuoteCmp = false;

    @wire(getBrokerId)
    handleResponse(response) {
        this.columns = quoteColumns;
        if (response.data) {
            this.showSpinner = true;
            this.getBrokerQuotes();
        }
    }

    // @wire(getQuotes, {
    //     pageSize: this.pageSize,
    //     pageNumber: this.pageNumber,
    //     emailId: this.emailId,
    //     mobileNumber: this.mobileNumber
    // })
    // processQuotes({ data, error }) {
    //     console.log('INSIDE NEWX ', data);
    //     if (data) {
    //         console.log(data);
    //         this.data = data;
    //         this.numberOfRecords = this.data.length;
    //         this.resultSize = this.data.length;
    //         this.showSpinner = false;
    //         if (this.data.length < this.pageSize) {
    //             this.isLastPage = true;
    //         } else {
    //             this.isLastPage = false;
    //         }
    //     } else if (error) {
    //         console.error(error);
    //         this.error = error;
    //         this.showSpinner = false;
    //     }
    // }

    getBrokerQuotes() {
        getQuotes({
            pageSize: this.pageSize,
            pageNumber: this.pageNumber,
            emailId: this.emailId,
            mobileNumber: this.mobileNumber
        })
            .then(result => {

                this.data = result;
                this.numberOfRecords = this.data.length;
                this.resultSize = this.data.length;
                this.showSpinner = false;
                if (this.data.length < this.pageSize) {
                    this.isLastPage = true;
                } else {
                    this.isLastPage = false;
                }

            })
            .catch(error => {
                this.error = error;
                this.showSpinner = false;
            })
    }

    getSelectedQuote(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedQuoteId = selectedRows[0].Id;
        this.quoteStatus = selectedRows[0].Quote_Stage__c;
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

    handleEmailId(event) {
        this.emailId = event.target.value;
    }

    handleMobileNumber(event) {
        this.mobileNumber = event.target.value;
    }

    handleQuoteSearch(event) {
        this.getBrokerQuotes();
    }

    handleDayChange(event) {
        this.day = event.target.value
    }

    handleMonthChange(event) {
        this.month = event.target.value;
    }

    handleYearChange(event) {
        this.year = event.target.value;
    }


    handlePrev() {
        //Setting current page number
        let pageNumber = this.pageNumber;
        this.pageNumber = pageNumber - 1;
        //Setting pageChange variable to true
        this.hasPageChanged = true;
        this.showConvertToApp = false;
        this.showSendDeclineEmail = false;
        this.getBrokerQuotes();
    }

    handleNext() {
        //get current page number
        let pageNumber = this.pageNumber;
        //Setting current page number
        this.pageNumber = pageNumber + 1;
        //Setting pageChange variable to true
        this.hasPageChanged = true;
        this.showConvertToApp = false;
        this.showSendDeclineEmail = false;
        this.getBrokerQuotes();
    }

    get recordCount() {
        return (
            (this.pageNumber - 1) * this.pageSize +
            " to " +
            ((this.pageNumber - 1) * this.pageSize + this.resultSize)
        );
    }

    get disablePrev() {
        return this.pageNumber === 1 ? true : false;
    }

    get quotesFound() {
        if (this.numberOfRecords === 0)
            return false;
        else
            return true;
    }

    handlePrintQuote() {
        this.showModal = false;
        this.showVerifyDOBModal = true;

    }

    get dayoptions() {
        return [
            { label: "1", value: "01" },
            { label: "2", value: "02" },
            { label: "3", value: "03" },
            { label: "4", value: "04" },
            { label: "5", value: "05" },
            { label: "6", value: "06" },
            { label: "7", value: "07" },
            { label: "8", value: "08" },
            { label: "9", value: "09" },
            { label: "10", value: "10" },
            { label: "11", value: "11" },
            { label: "12", value: "12" },
            { label: "13", value: "13" },
            { label: "14", value: "14" },
            { label: "15", value: "15" },
            { label: "16", value: "16" },
            { label: "17", value: "17" },
            { label: "18", value: "18" },
            { label: "19", value: "19" },
            { label: "20", value: "20" },
            { label: "21", value: "21" },
            { label: "22", value: "22" },
            { label: "23", value: "23" },
            { label: "24", value: "24" },
            { label: "25", value: "25" },
            { label: "26", value: "26" },
            { label: "27", value: "27" },
            { label: "28", value: "28" },
            { label: "29", value: "29" },
            { label: "30", value: "30" },
            { label: "31", value: "31" },
        ];
    }


    get monthoptions() {
        return [
            { label: "Jan", value: "01" },
            { label: "Feb", value: "02" },
            { label: "Mar", value: "03" },
            { label: "Apr", value: "04" },
            { label: "May", value: "05" },
            { label: "Jun", value: "06" },
            { label: "Jul", value: "07" },
            { label: "Aug", value: "08" },
            { label: "Sep", value: "09" },
            { label: "Oct", value: "10" },
            { label: "Nov", value: "11" },
            { label: "Dec", value: "12" },
        ];
    }

    verifyDOBQuotePrint(event) {
        let user_dateOfBirth = event.detail.userDateOfBirth;
        getBrokerRecordForPrint({
            quoteId: this.recordId,
            user_dateOfBirth: user_dateOfBirth
        })
            .then(result => {
                if (result === 'NOT_FOUND') {
                    this.showToast('Error', 'Quote record is not available for print. Please try after sometime.', 'error');
                } else if (result === 'DOB_NOT_VALID') {
                    this.showToast('Error', 'Date of birth is incorrect. Please try again.', 'error');
                } else if (result === 'MAX_ATTEMPTS_REACHED') {
                    this.showToast('Error', "You’ve reached the maximum number of attempts to verify your identity. Please call us on 1800 035 902 so we can assist you with your quote.", 'error');
                } else if (result === 'INVALID_DATE_OF_BIRTH') {
                    this.showToast('Error', "Invalid Date of birth. Please try again.", 'error');
                } else {
                    //DEV LINK
                    /*window.open(BP_LBL_BASE_URL + result + '/p?retURL=/' + result, '_blank');
                    this.showVerifyDOBModal = false;
                    this.day = undefined;
                    this.month = undefined;
                    this.year = undefined;*/
                    this.handleDownloadCopyOfQuote();
                }

            })
            .catch(error => {
                this.error = error;
            })
    }

    handleApplicationConvert() {
        //Create a Note against the Quote (to log that the current user clicked on Conver to App)
        createNote({
            quoteId: this.recordId
        })
            .then(result => {
                let currentUrl = window.location.href;
                //let applicationFormUrl = BP_LBL_BASE_URL + 's/applicationform';
                if (currentUrl !== undefined && currentUrl !== null) {
                    if (currentUrl.includes('quotes')) {
                        currentUrl = currentUrl.replace('quotes', 'applicationform');
                    } else {
                        currentUrl = currentUrl + 'applicationform';
                    }
                }
                let applicationFormUrl = currentUrl;
                localStorage.setItem('eqi', this.recordId);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: applicationFormUrl
                    },
                });
            })
            .catch(error => {
                this.error = error;
                this.showToast('Error', 'An error was encountered. Please try after sometime.', 'error');
            })



        //Commented the below to enable LWC Component navigation
        //this.showModal = false;
        //this.showLogoutModal = true;
    }


    handleRowAction(event) {

        this.recordId = event.detail.row.Id;
        //Check the status of the recordId
        getStatusAndEncryptedQuote({
            quoteId: this.recordId
        })
            .then(result => {
                if (Object.keys(result).length === 0 && result.constructor === Object) {
                    this.showToast('Error', 'An error was encountered. Please try after sometime.', 'error');
                } else {
                    this.currentRecordBrokerId = result.brokerId;
                    this.currentRecordBrokerName = result.brokerName;
                    this.brokerValidatedEmailId = result.emailIdOnQuote;
                    this.firstName = result.firstName;
                    this.lastName = result.lastName;
                    this.dateOfBirth = result.dateOfBirth;
                    this.quoteEmailId = result.emailId;
                    this.quoteMobileNumber = result.mobileNumber;
                    this.quoteReference = result.quoteReference;
                    this.loanAmount = '$' + result.loanAmount;
                    this.loanPurpose = result.loanPurpose;
                    this.loanTerm = result.loanTerm;
                    this.interestRateOffered = result.interestRateOffered;
                    this.securedRateOffered = result.securedRateOffered;
                    this.quoteStage = result.quoteStage;
                    this.quoteExpiresOn = result.quoteExpiresOn;
                    this.quoteDeclinedOn = result.quoteDeclinedOn;
                    this.productType = result.productType;
                    if(this.productType == 'Better Start') {
                        this.isBetterStart = true;
                    } else {
                        this.isBetterStart = false;
                    }
                    //this.encryptedQuoteId = result.encryptedQuoteId;
                    this.openModal();
                    if (result.quoteStage === 'Quote Offered') {
                        this.showConvertToApp = true;
                    } else if (result.quoteStage === 'Converted to Application') {
                        this.showNotes = true;
                        this.notesColumns = notesColumns;
                        this.showConvertToApp = false;
                        getConvertedToAppNotes({
                            quoteId: this.recordId
                        })
                            .then(notesResult => {
                                this.quoteNotes = notesResult;
                                let quoteNotesSize = this.quoteNotes.length;
                                if (quoteNotesSize > 0) {
                                    this.notesFound = true;
                                } else {
                                    this.notesFound = false;
                                }
                            })
                            .catch(error => {
                                this.error = error;
                            })
                    } else if (result.quoteStage === 'Declined') {
                        this.showDeclineSection = true;
                        this.showConvertToApp = false;
                    }
                    else {
                        this.showConvertToApp = false;
                    }
                }
            })
            .catch(error => {
                this.error = error;
            })
    }

    autoDownloadFile(blob, quoteNumber) {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = quoteNumber;

        const clickHandler = () => {
            setTimeout(() => {
                URL.revokeObjectURL(url);
                this.removeEventListener('click', clickHandler);
            }, 150);
        };
        a.click();
    }

    handleDownloadCopyOfQuote() {
        generateQuotePrintablePage({recordId: this.recordId})
        .then(result => {
            if (result != '') {
                let contentType = 'application/pdf';
                let sliceSize = 512;
                let byteCharacters = atob(result);
                let byteArrays = [];
                for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                    let slice = byteCharacters.slice(offset, offset + sliceSize);
                    let byteNumbers = new Array(slice.length);
                    for (let i = 0; i < slice.length; i++) {
                        byteNumbers[i] = slice.charCodeAt(i);
                    }
                    let byteArray = new Uint8Array(byteNumbers);
                    byteArrays.push(byteArray);
                }

                let blob = new Blob(byteArrays, { type: contentType });
                //window.location = blobUrl;
                this.autoDownloadFile(blob, this.quoteReference);
                this.showVerifyDOBModal = false;
            }            
        })
        .catch((error) => {
            this.error = error;
            console.log(error);
        });
    }

    openModal() {
        // to open modal window set 'showModal' tarck value as true
        this.showModal = true;
    }

    closeModal() {
        // to close modal window set 'showModal' tarck value as false
        this.quoteNotes = [];
        this.showNotes = false;
        this.showModal = false;
        this.notesFound = false;
        this.showDeclineSection = false;
        this.showConvertToApp = false;
    }

    closeLogoutModal() {
        this.showLogoutModal = false;
        this.showModal = true;
    }

    get recordId() {
        return this.recordId;
    }

    closeVerifyDOBModal() {
        this.showVerifyDOBModal = false;
        this.showModal = false;
    }

    handleQuoteCancel() {
        this.showModal = false;
        this.showCancelQuoteCmp = true;
    }

    //hide the Quote Cancel Modal
    handleQuoteCmpClose() {
        this.showModal = false;
        this.showCancelQuoteCmp = false;
        this.getBrokerQuotes();
    }






    /**Custom labels for fields*/
    label = {
        BP_LBL_Quotes_Amount_Disclaimer
    }


}