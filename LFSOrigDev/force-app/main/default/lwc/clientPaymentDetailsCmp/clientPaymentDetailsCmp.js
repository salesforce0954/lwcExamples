import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import loadClientPaymentDetailsData from '@salesforce/apex/ClientPaymentDetailsController.loadClientPaymentDetailsData';
import insertDirectDebit from '@salesforce/apex/ClientPaymentDetailsController.insertDirectDebit';
import insertDirectCredit from '@salesforce/apex/ClientPaymentDetailsController.insertDirectCredit';

export default class ClientPaymentDetailsCmp extends NavigationMixin(LightningElement) {
    @track showSpinner = true;
    @track finishLoad = false;
    @track applicationId;
    @track fullName;
    @track loanNumber;
    @track applicationStatus;
    @track paymentDetailPicklistValue = 'Direct debit';
    @track dcLoanAmount;
    @track showDirectDebit = true;
    @track showDirectCredit = true;
    @track directDebitObj = {
        accountName: '',
        bsb: '',
        accountNumber: '',
        frequencyOfDirectDebit: '',
        preferredStartDate: ''
    };
    @track directCreditObj = {
        accountName: '',
        bsb: '',
        accountNumber: '',
        bankName: '',
        branchLocation: ''            
    };
    @track options = [
        { label: 'Direct Debit', value: 'Direct debit' },
        { label: 'Direct Credit', value: 'Direct credit' },
    ];    
    @track listBSB=[];
    @track directDebitExist = false;
    @track directCreditExist = false;
    @track debitFrequencyValue = '';
    @track frequencyPicklist=[];
    @track sameAccountToggle=false;
    @track param = {};
    @track hasAnotherCredit=false;

    connectedCallback() {
        this.fullName='';
        this.loanNumber='';
        this.applicationStatus='';
        this.applicationId = '';

        this.param = JSON.parse(sessionStorage.getItem('CPD_applicationDetail'));
        if(this.param != null) {
            this.fullName = this.param.fullName;
            this.loanNumber = this.param.loanNumber;
            this.applicationStatus = this.param.statusForDisplay;
            this.applicationId = this.param.applicationId;
        }
        loadClientPaymentDetailsData({
            applicationId: this.applicationId
        }).then(result => {
            if(result.hasOwnProperty('directDebit')) {
                this.directDebitExist = true;
                this.directDebitObj.accountName = result.directDebit.Account_Holders__c;
                this.directDebitObj.bsb = result.directDebit.BSB_Number__c;
                this.directDebitObj.accountNumber = result.directDebit.Account_Number__c;
                this.directDebitObj.bankName = result.directDebit.Bank_Name__c;
                this.directDebitObj.branchLocation = result.directDebit.Branch_Location__c;
                this.directDebitObj.frequencyOfDirectDebit = result.directDebit.Frequency__c;
                this.directDebitObj.preferredStartDate = result.directDebit.Commencement_Date__c;
                //this.directDebitObj.repaymentLevel = result.directDebit.Repayment_Level__c;
                /*if(result.directDebit.hasOwnProperty("Specify_Higher_Amount__c")) {
                    this.directDebitObj.higherPaymentAmount = result.directDebit.Specify_Higher_Amount__c;
                    this.minimumRepayment = true;
                } else {
                    this.minimumRepayment = false;
                }*/

                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.ddExist = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));                
            } 

            if(result.hasOwnProperty('directCredit')) {
                this.directCreditExist = true;
                this.directCreditObj.accountName = result.directCredit.Payee__c;
                this.directCreditObj.bsb = result.directCredit.BSB__c;
                this.directCreditObj.accountNumber = result.directCredit.Bank_Acc_No__c;
                this.directCreditObj.bankName = result.directCredit.Fin_Institution__c;
                this.directCreditObj.branchLocation = result.directCredit.Branch__c;

                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.dcExist = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));                  
            }            

            for(let freq in result.mapFrequencyPicklist) {
                this.frequencyPicklist.push({
                    label: freq,
                    value: result.mapFrequencyPicklist[freq]
                });
            }
            let frequencyReorder = [this.frequencyPicklist[1], this.frequencyPicklist[2], this.frequencyPicklist[0]];
            this.frequencyPicklist = frequencyReorder;            

            //filter bsb
            this.listBSB = result.listBSB.filter((bsb) => {
                return bsb.Name.length == 6;
            }).map(function(bsb) {
                return bsb.Name;
            }); 

            if(result.otherDebit) {
                this.options.splice(0,1);

                this.paymentDetailPicklistValue = 'Direct credit';
                this.showDirectCredit = true;
                this.showDirectDebit = false;

                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.hasAnotherDebit = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));
            } else {
                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.hasAnotherDebit = false;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));
            }

            if(result.otherCredit) {
                this.options.splice(1,1);
                if(result.otherDebit) {
                    this.options.splice(0,1);
                    this.paymentDetailPicklistValue = '-';
                }

                this.showDirectCredit = false;
                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.hasAnotherCredit = true;
                this.hasAnotherCredit = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));                
            } else {
                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.hasAnotherCredit = false;
                this.hasAnotherCredit = false;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));   
            }
            this.dcLoanAmount = result.loanAmount;
            this.showSpinner = false;
            this.finishLoad = true;
        }).catch(error => {
            this.showSpinner = false;
            console.error(error);
        });  
    }

    handlePaymentDetailsPicklist(event) {
        this.paymentDetailPicklistValue = event.detail.value;
        if(this.paymentDetailPicklistValue === "Direct debit") {
            this.showDirectDebit = true;
            this.showDirectCredit = false;
        } else {
            this.showDirectDebit = false;
            this.showDirectCredit = true;
        }
    }  

    handleDirectDebitFields(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;

        switch(fieldName) {
            case 'directDebitAccountName':
                this.directDebitObj.accountName = fieldValue;
                break;
            case 'directDebitBSB':                
                this.directDebitObj.bsb = fieldValue;
                break;
            case 'directDebitAccountNumber':
                this.directDebitObj.accountNumber = fieldValue;
                break;
            case 'directDebitBankName':
                this.directDebitObj.bankName = fieldValue;
                break;
            case 'directDebitBranchLocation':
                this.directDebitObj.branchLocation = fieldValue;
                break;  
            default:
                break;
        }
    } 
    
    handleDirectCreditFields(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;

        switch(fieldName) {
            case 'directCreditAccountName':
                this.directCreditObj.accountName = fieldValue;
                break;
            case 'directCreditBSB':             
                this.directCreditObj.bsb = fieldValue;
                break;
            case 'directCreditAccountNumber':
                this.directCreditObj.accountNumber = fieldValue;
                break;
            case 'directCreditBankName':
                this.directCreditObj.bankName = fieldValue;
                break;   
            case 'directCreditBranchLocation':
                this.directCreditObj.branchLocation = fieldValue;
                break;                                                                            
            default:
                break;
        }

        if(this.sameAccountToggle) {
            this.directDebitObj.accountName = this.directCreditObj.accountName;
            this.directDebitObj.bsb = this.directCreditObj.bsb;
            this.directDebitObj.accountNumber = this.directCreditObj.accountNumber;
            this.directDebitObj.bankName = this.directCreditObj.bankName;
            this.directDebitObj.branchLocation = this.directCreditObj.branchLocation;        
        }        
    }     
    
    handleFrequenceChange(event) {
        let value = event.detail.value;
        this.directDebitObj.frequencyOfDirectDebit = value;
        this.setPrefferedStartDate();
    }

    handleDirectDebitToggle(event) {
        this.sameAccountToggle = event.target.checked;
        if(event.target.checked) {
            this.directDebitObj.accountName = this.directCreditObj.accountName;
            this.directDebitObj.bsb = this.directCreditObj.bsb;
            this.directDebitObj.accountNumber = this.directCreditObj.accountNumber;
            this.directDebitObj.bankName = this.directCreditObj.bankName;
            this.directDebitObj.branchLocation = this.directCreditObj.branchLocation;
        } else {
            this.directDebitObj.accountName = '';
            this.directDebitObj.bsb = '';
            this.directDebitObj.accountNumber = '';
            this.directDebitObj.bankName = '';
            this.directDebitObj.branchLocation = '';            
        }
    }

    handleSaveDirectDebit(event) {
        //validate the input
        if(this.validateDirectDebitBeforeSave()) {
            this.showSpinner = true;
            insertDirectDebit({
                applicationId: this.applicationId,
                accountName: this.directDebitObj.accountName,
                bsb: this.directDebitObj.bsb,
                accountNumber: this.directDebitObj.accountNumber,
                bankName: this.directDebitObj.bankName,
                branchLocation: this.directDebitObj.branchLocation,
                frequencyOfDirectDebit: this.directDebitObj.frequencyOfDirectDebit,
                preferredStartDate: this.directDebitObj.preferredStartDate          
            }).then(result => {
                this.directDebitExist = true;
                this.directDebitObj.accountName = result.directDebit.Account_Holders__c;
                this.directDebitObj.bsb = result.directDebit.BSB_Number__c;
                this.directDebitObj.accountNumber = result.directDebit.Account_Number__c;
                this.directDebitObj.bankName = result.directDebit.Bank_Name__c;
                this.directDebitObj.branchLocation = result.directDebit.Branch_Location__c;                  
                this.directDebitObj.frequencyOfDirectDebit = result.directDebit.Frequency__c;
                this.directDebitObj.preferredStartDate = result.directDebit.Commencement_Date__c;
                this.showSuccessNotification("Direct Debit details submitted successfully");

                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.ddExist = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));

                this.showSpinner = false;
            }).catch(error => {
                this.showSpinner = false;
                this.showErrorNotification("Direct Debit details could not be submitted due to a system error. Please try again.");
                console.error(error);
            });              
        }
    }

    validateDirectDebitBeforeSave() {
        let directDebitBSBText = this.template.querySelector('.dd-bsb');
        directDebitBSBText.setCustomValidity("");
        directDebitBSBText.reportValidity();            

        const directDebitFieldsCorrect = [...this.template.querySelectorAll('.dd-lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);   
        
        //validate list bsb
        const isValidBSB = this.listBSB.includes(this.directDebitObj.bsb);
        if(!isValidBSB && directDebitFieldsCorrect) {
            directDebitBSBText.setCustomValidity("Please check BSB is correct");
            directDebitBSBText.reportValidity();
        }

        return directDebitFieldsCorrect && isValidBSB;
    }

    handleSaveDirectCredit(event) {
        //validate the input
        if(this.validateDirectCreditBeforeSave()) {
            this.showSpinner = true;
            insertDirectCredit({
                applicationId: this.applicationId,
                accountName: this.directCreditObj.accountName,
                bsb: this.directCreditObj.bsb,
                accountNumber: this.directCreditObj.accountNumber,
                bankName: this.directCreditObj.bankName,
                branchLocation: this.directCreditObj.branchLocation,                
            }).then(result => {
                this.directCreditExist = true;
                this.directCreditObj.accountName = result.directCredit.Payee__c;
                this.directCreditObj.bsb = result.directCredit.BSB__c;
                this.directCreditObj.accountNumber = result.directCredit.Bank_Acc_No__c;
                this.directCreditObj.bankName = result.directCredit.Fin_Institution__c;
                this.directCreditObj.branchLocation = result.directCredit.Branch__c;
                this.showSuccessNotification("Direct Credit details submitted successfully");

                let adDetail = JSON.parse(sessionStorage.getItem("AD_details"));
                adDetail.dcExist = true;
                sessionStorage.setItem('AD_details', JSON.stringify(adDetail));

                this.showSpinner = false;
            }).catch(error => {
                this.showSpinner = false;
                this.showErrorNotification("Direct Credit details could not be submitted due to a system error. Please try again.");
                console.error(error);
            });              
        }
    }

    validateDirectCreditBeforeSave() {
        let directCreditBSBText = this.template.querySelector('.dc-bsb');
        directCreditBSBText.setCustomValidity("");
        directCreditBSBText.reportValidity();             

        const directCreditFieldsCorrect = [...this.template.querySelectorAll('.dc-lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);   
        
        //validate list bsb
        const isValidBSB = this.listBSB.includes(this.directCreditObj.bsb);
        if(!isValidBSB && directCreditFieldsCorrect) {
            directCreditBSBText.setCustomValidity("Please check BSB is correct");
            directCreditBSBText.reportValidity();
        }

        return directCreditFieldsCorrect && isValidBSB;
    } 

    setPrefferedStartDate() {
        this.repaymentFrequencySelected = true;
        let d = new Date();
        if(this.directDebitObj.frequencyOfDirectDebit === "Weekly") {
            let res = d.setDate(d.getDate() + 7);
            let weekly = new Date(res);
            let weeklydate = ("0" + weekly.getDate()).slice(-2) + '/' + ("0" + (weekly.getMonth() + 1)).slice(-2) + '/' + (+ weekly.getFullYear());
            this.directDebitObj.preferredStartDate = weeklydate;
        } else if(this.directDebitObj.frequencyOfDirectDebit === "Fortnightly") {
            let resFornightly = d.setDate(d.getDate() + 14);
            let Fornightly = new Date(resFornightly);
            let Fornightlydate = ("0" + Fornightly.getDate()).slice(-2) + '/' + ("0" + (Fornightly.getMonth() + 1)).slice(-2) + '/' + (+ Fornightly.getFullYear());
            this.directDebitObj.preferredStartDate = Fornightlydate;
        } else if(this.directDebitObj.frequencyOfDirectDebit === "Monthly"){
            let resMonthly = d.setDate(d.getDate() + 30);
            let Monthly = new Date(resMonthly);
            let Monthlydate = ("0" + Monthly.getDate()).slice(-2) + '/' + ("0" + (Monthly.getMonth() + 1)).slice(-2) + '/' + (+ Monthly.getFullYear());
            this.directDebitObj.preferredStartDate = Monthlydate;
        } else {
            let resMonthly = d.setDate(d.getDate() + 30);
            let Monthly = new Date(resMonthly);            
            let Monthlydate = ("0" + Monthly.getDate()).slice(-2) + '/' + ("0" + (Monthly.getMonth() + 1)).slice(-2) + '/' + (+ Monthly.getFullYear());
            this.directDebitObj.preferredStartDate = Monthlydate;
        } 
    }

    handleNumberOnly(event) {      
        // Only ASCII character in that range allowed
        let ASCIICode = (event.which) ? event.which : event.keyCode
        if (ASCIICode > 31 && (ASCIICode < 48 || ASCIICode > 57)) {
            event.preventDefault();
        }
        return true;
    }

    handleAlphaNumeric (e) {  // Accept only alpha numerics, no special characters 
        let regex = new RegExp("^[a-zA-Z0-9 ]+$");
        let str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
    
        e.preventDefault();
        return false;
    }

    handleSkip(event) {
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

    showSuccessNotification(sucMessage) {
        const evt = new ShowToastEvent({
            title: "Success",
            message: sucMessage,
            variant: "success",
        });
        this.dispatchEvent(evt);
    }     

    showErrorNotification(errMessage) {
        const evt = new ShowToastEvent({
            title: "Error",
            message: errMessage,
            variant: "error",
        });
        this.dispatchEvent(evt);
    } 
}