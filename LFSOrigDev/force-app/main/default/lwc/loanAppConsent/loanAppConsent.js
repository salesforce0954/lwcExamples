import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import jQuery from '@salesforce/resourceUrl/jquery36';
import BP_LBL_Loan_Amount from '@salesforce/label/c.BP_LBL_Loan_Amount';
import BP_LBL_Loan_Details_Section from '@salesforce/label/c.BP_LBL_Loan_Details_Section';
import BP_LBL_Loan_Purpose from '@salesforce/label/c.BP_LBL_Loan_Purpose';
import BP_LBL_Total_Loan_Amount from '@salesforce/label/c.BP_LBL_Total_Loan_Amount';
import BP_LBL_Number_Of_Applicants from '@salesforce/label/c.BP_LBL_Number_Of_Applicants';
import BP_LBL_Applicant_1 from '@salesforce/label/c.BP_LBL_Applicant_1';
import BP_LBL_Applicant_2 from '@salesforce/label/c.BP_LBL_Applicant_2';
import BP_LBL_Privacy_Credit_Reporting from '@salesforce/label/c.BP_LBL_Privacy_Credit_Reporting';
import BP_LBL_Privacy_21T from '@salesforce/label/c.BP_LBL_Privacy_21T';
import BP_LBL_Privacy_21T_Agrees from '@salesforce/label/c.BP_LBL_Privacy_21T_Agrees';
import BP_LBL_Other_Loan_Purpose from '@salesforce/label/c.BP_LBL_Other_Loan_Purpose';
import BP_LBL_Loan_Term from '@salesforce/label/c.BP_LBL_Loan_Term';
import BP_LBL_Info_Change_Warning from '@salesforce/label/c.BP_LBL_Info_Change_Warning';
import BP_LBL_Add_Loan_Purpose_Button from '@salesforce/label/c.BP_LBL_Add_Loan_Purpose_Button';
import BP_LBL_Getting_Started_Section from '@salesforce/label/c.BP_LBL_Getting_Started_Section';
import BP_LBL_Privacy_21T_Content1 from '@salesforce/label/c.BP_LBL_Privacy_21T_Content1';
import BP_LBL_Privacy_21T_Content2 from '@salesforce/label/c.BP_LBL_Privacy_21T_Content2';
import BP_LBL_Privacy_21T_Header from '@salesforce/label/c.BP_LBL_Privacy_21T_Header';
import BP_LBL_Product_Disclosure_Heading from '@salesforce/label/c.BP_LBL_Product_Disclosure_Heading';
import BP_LBL_Product_Disclosure from '@salesforce/label/c.BP_LBL_Product_Disclosure';
import BP_LBL_Product_Disclosure_Agrees from '@salesforce/label/c.BP_LBL_Product_Disclosure_Agrees';
import BP_LBL_Product_Disclosure_Header from '@salesforce/label/c.BP_LBL_Product_Disclosure_Header';
import BP_LBL_Product_Disclosure_Content from '@salesforce/label/c.BP_LBL_Product_Disclosure_Content';
import BP_LBL_E_Communication from '@salesforce/label/c.BP_LBL_E_Communication';
import BP_LBL_E_Communication_Clickable from '@salesforce/label/c.BP_LBL_E_Communication_Clickable';
import BP_LBL_E_Communication_Agrees from '@salesforce/label/c.BP_LBL_E_Communication_Agrees';
import BP_LBL_E_Communication_Header from '@salesforce/label/c.BP_LBL_E_Communication_Header';
import BP_LBL_E_Communication_Content from '@salesforce/label/c.BP_LBL_E_Communication_Content';
import BP_LBL_E_POI from '@salesforce/label/c.BP_LBL_E_POI';
import BP_LBL_E_POI_Clickable from '@salesforce/label/c.BP_LBL_E_POI_Clickable';
import BP_LBL_E_POI_Agrees from '@salesforce/label/c.BP_LBL_E_POI_Agrees';
import BP_LBL_E_POI_Header from '@salesforce/label/c.BP_LBL_E_POI_Header';
import BP_LBL_E_POI_Content from '@salesforce/label/c.BP_LBL_E_POI_Content';
import BP_LBL_EIDV from '@salesforce/label/c.BP_LBL_EIDV';
import BP_LBL_EIDV_Clickable from '@salesforce/label/c.BP_LBL_EIDV_Clickable';
import BP_LBL_EIDV_Agrees from '@salesforce/label/c.BP_LBL_EIDV_Agrees';
import BP_LBL_EIDV_Header from '@salesforce/label/c.BP_LBL_EIDV_Header';
import BP_LBL_EIDV_Content from '@salesforce/label/c.BP_LBL_EIDV_Content';
import BP_LBL_HAS from '@salesforce/label/c.BP_LBL_HAS';
import BP_LBL_HAS_Agrees from '@salesforce/label/c.BP_LBL_HAS_Agrees';
import BP_LBL_HAS_Clickable from '@salesforce/label/c.BP_LBL_HAS_Clickable';
import BP_LBL_HAS_Content from '@salesforce/label/c.BP_LBL_HAS_Content';
import BP_LBL_HAS_Header from '@salesforce/label/c.BP_LBL_HAS_Header';
import BP_LBL_Product_Type_Decap from '@salesforce/label/c.BP_LBL_Product_Type_Decap';
import APPLICATION_OBJECT from '@salesforce/schema/Application__c';
import PRODUCT_TYPE_STATUS_FIELD from '@salesforce/schema/Application__c.Product_SubType__c';


export default class LoanAppConsent extends LightningElement {

    defaultApplicantValue = '1';

    @api loanDetailsObj; //Input received from parent (immutable)
    @api betterStartConfig;
    @api latitudeBrandRecord;
    @api selectedLoanTermValues;
    @api isBetterStartActive=false;
    @track copyLoanDetailsObj; //copy created to mutate data and send it back to parent
    @api inputMode;
    @api originalProductType;


    //Array of objects to store Loan Amount and Loan Purpose entries (max of 10)
    //[{id:1,loanAmount: 3000,loanPurpose: "Debt Consolidation"},{id=2,loanAmount: 5000,loanPurpose: "Travel"}]
    @track loanAmountPurposeArray = [];
    maxPurposesAdded = false;
    privacyConsentContent = '';
    @track loanDetails = [];
    privacyConsent = false;
    productDisclosure = false;
    eCommunication = false;
    eIncome = false;
    eIdentification = false;
    maxLimit = false;
    showOtherPurpose = false;
    consentContent = null;
    consentHeader = null;
    showConsentModal = false;
    showPrivacyContent = false;
    isJQueryLibLoaded = false;
    auApplicationRecordTypeId;
    betterStartConfigSet=false;
    latitudeBrandRecordConfigSet=false;
    isProductTypeSet = false;
    @track productTypeOptions=[];
    @track loanTerm=[];
    @track loanTermBetterStart=[];
    @track productType=null;
    @track loanTermValues=[];
    @track primaryLoanAmountMinAmount = 4000;
    @track primaryLoanAmountMessage = 'Your preferred loan amount must be at least $4000.';

    connectedCallback() {
        this.copyLoanDetailsObj = { ...this.loanDetailsObj };
        if (this.copyLoanDetailsObj.LoanInfo !== undefined && this.copyLoanDetailsObj.LoanInfo.length > 0) {
            this.loanAmountPurposeArray = [...this.loanDetailsObj.LoanInfo];
        }
    }

    renderedCallback() {
        if(this.inputMode != 'review' &&
           typeof(this.latitudeBrandRecord.Loan_Term__c) != "undefined" && 
           typeof(this.latitudeBrandRecord.Loan_Term_Better_Start__c) != "undefined" && 
           this.latitudeBrandRecordConfigSet === false &&
           this.loanDetailsObj.ProductType != null &&
           typeof(this.betterStartConfig.BetterStartAUActive__c) != "undefined" &&
           this.betterStartConfigSet === false) {
            //Beter start config
            this.betterStartConfigSet = true;
            if(this.betterStartConfig.BetterStartAUActive__c && this.originalProductType == 'Better Start PL') {
                this.isBetterStartActive = this.betterStartConfig.BetterStartAUActive__c;
            }

            //Latitude brand config
            this.latitudeBrandRecordConfigSet = true;
            this.loanTerm = this.latitudeBrandRecord.Loan_Term__c.split(';').sort().map((elem)=>{
                return {
                    label: elem,
                    value: elem
                }
            });
            this.loanTermBetterStart = this.latitudeBrandRecord.Loan_Term_Better_Start__c.split(';').sort().map((elem)=>{
                return {
                    label:elem,
                    value:elem
                }
            });

            //set loan term options
            if(this.loanDetailsObj.ProductType != 'Better Start PL') {
                this.loanTermValues = this.loanTerm;
                this.primaryLoanAmountMinAmount = 4000;
                this.primaryLoanAmountMessage = 'Your preferred loan amount must be at least $4000.';
            } else {
                this.loanTermValues = this.loanTermBetterStart;
                this.primaryLoanAmountMinAmount = 20000;
                this.primaryLoanAmountMessage = 'Loan amount must be at least $20,000 for a Better Start Personal Loan.';                
            }
        } else if(this.inputMode == 'review') {
            this.loanTermValues = this.selectedLoanTermValues;
        }

        //Load JQuery Library only once
        if (this.isJQueryLibLoaded) {
            return;
        } else {
            Promise.all([
                loadScript(this, jQuery)
            ]).then(() => {
                this.isJQueryLibLoaded = true;
            }).catch(error => {
                this.genericErrorLoadingForm();
            });
        }
    }

    //FETCH Record Type Id for AU from Applicant Object
    @wire(getObjectInfo, { objectApiName: APPLICATION_OBJECT })
    handleResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {
                if (value.name === 'AU') {
                    this.auApplicationRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auApplicationRecordTypeId', fieldApiName: PRODUCT_TYPE_STATUS_FIELD })
    handleProductTypeValues({ error, data }) {
        if (data) {
            this.productTypeOptions = data.values.map((elem) =>{
                return {
                    label: elem.label,
                    value: elem.value,
                };
            });
        } else if (error) {
            console.log(error);
            this.genericErrorLoadingForm();
        }
    }

    handleShowPrivacyPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_Privacy_21T_Header;
        this.consentContent = BP_LBL_Privacy_21T_Content1 + BP_LBL_Privacy_21T_Content2;
    }

    handleShowProductDisPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_Product_Disclosure_Header;
        this.consentContent = BP_LBL_Product_Disclosure_Content;
    }

    handleShowECommunicationPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_E_Communication_Header;
        this.consentContent = BP_LBL_E_Communication_Content;
    }

    handleShowEPOIPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_E_POI_Header;
        this.consentContent = BP_LBL_E_POI_Content;
    }

    handleShowEIDVPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_EIDV_Header
        this.consentContent = BP_LBL_EIDV_Content;
    }

    handleShowHASPopover() {
        this.showConsentModal = true;
        this.consentHeader = BP_LBL_HAS_Header;
        this.consentContent = BP_LBL_HAS_Content;
    }



    handleConsentModalClose() {
        this.showConsentModal = false;
        this.consentHeader = null;
        this.consentContent = null;
    }

    get applicantOptions() {
        return [
            { label: 'One applicant', value: '1' },
            { label: 'Two applicants', value: '2' }
        ];
    }


    /*get loanTermValues() {
        if(this.productType == 'Standard PL') {
            return this.loanTerm;
        } else {
            return this.loanTermBetterStart;
        }
    }*/

    get loanPurposeValues() {
        return [
            { label: 'Car purchase', value: 'Car purchase' },
            { label: 'Car repairs', value: 'Car repairs' },
            { label: 'Debt consolidation', value: 'Debt consolidation' },
            { label: 'Educational expenses', value: 'Educational expenses' },
            { label: 'Home improvements', value: 'Home improvements' },
            { label: 'Household furnishings', value: 'Household furnishings' },
            { label: 'Medical / Dental', value: 'Medical / Dental' },
            { label: 'Other vehicle purchase', value: 'Other vehicle purchase' },
            { label: 'Small debts', value: 'Small debts' },
            { label: 'Travel', value: 'Travel' },
            { label: 'Other', value: 'Other' }
        ];
    }

    get totalLoanAmount() {
        return this.calculateTotalLoanAmount();

    }

    calculateTotalLoanAmount() {
        let totalLoanAmountInArray = this.loanAmountPurposeArray.reduce(function (total, currentItem) {
            return total + currentItem.loanAmount;
        }, 0);
        if (this.copyLoanDetailsObj.LoanAmountQuote !== undefined && (this.copyLoanDetailsObj.LoanAmountQuote !== this.loanDetailsObj.LoanAmountQuote)) {
            return Number(this.copyLoanDetailsObj.LoanAmountQuote) + totalLoanAmountInArray;
        } else {
            return Number(this.loanDetailsObj.LoanAmountQuote) + totalLoanAmountInArray;
        }

    }

    get showQuoteOtherPurpose() {
        if (this.loanDetailsObj.LoanPurposeQuote === 'Other' || this.copyLoanDetailsObj.LoanPurposeQuote === 'Other') {
            return true;
        } else {
            return false;
        }
    }

    get showJointAppTextboxes() {
        if (this.copyLoanDetailsObj.Applicants === '2' || this.loanDetailsObj.Applicants === '2') {
            return true;
        } else {
            return false;
        }
    }

    handleAddLoanPurpose() {
        //send event to parent to notify that page has been modified
        this.setInputChanged();

        //Get Length of the array
        let currentLength = this.loanAmountPurposeArray.length;

        if (currentLength === 9) {
            this.maxPurposesAdded = true;
            return;
        } else {
            this.maxPurposesAdded = false;
        }
        if (currentLength === 0) {
            this.loanAmountPurposeArray.push({ id: 1, loanAmount: 0, loanPurpose: "" })
        } else {
            //Get the current id value of the object in the array
            let currentId = this.loanAmountPurposeArray[currentLength - 1].id
            //Increment the id by 1 & add a new object to the array
            this.loanAmountPurposeArray = [...this.loanAmountPurposeArray, { id: currentId + 1, loanAmount: 0, loanPurpose: "" }];
            currentLength = this.loanAmountPurposeArray.length;
            if (currentLength === 9) {
                this.maxPurposesAdded = true;
                return;
            } else {
                this.maxPurposesAdded = false;
            }
        }

    }

    handleLoanPurposeDelete(event) {
        //Get the name of the button to identify which button was clicked. 
        //Buttons are named with the Id of objects in loanAmountPurposeArray, then identify the index of the buttonIndex and then splice to remove element

        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.loanAmountPurposeArray.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.loanAmountPurposeArray.splice(indexOfObject, 1);

        let currentLength = this.loanAmountPurposeArray.length;

        if (currentLength < 9) {
            this.maxPurposesAdded = false;
        }

        //send event to parent to notify that page has been modified
        this.setInputChanged();
    }

    handleLoanAppDetailsChange(event) {
        //send event to parent to notify that page has been modified
        this.setInputChanged();

        let textBoxIndex;
        let comboBoxIndex;
        let loanAmt;
        let loanPurp;
        let otherLoanPurpVal;
        let otherLoanTextBoxIndex; 

        if (event.target.name === 'loanAmount') {
            textBoxIndex = event.target.dataset.name;
            loanAmt = event.target.value;
            let index = this.loanAmountPurposeArray.length;
            let indexOfObjectInArray = this.loanAmountPurposeArray.map(function (currentItem) {
                return currentItem.id
            }).indexOf(Number(textBoxIndex));
            //-1 indicates that id is not present in array
            if (indexOfObjectInArray === -1) {
                this.loanAmountPurposeArray.splice(index, 0, { id: Number(textBoxIndex), loanAmount: Number(loanAmt) });
            } else {
                //replace the loanAmount 
                this.loanAmountPurposeArray[indexOfObjectInArray].loanAmount = Number(loanAmt);
            }
        } else if (event.target.name === 'loanPurpose') {
            comboBoxIndex = event.target.dataset.name;

            loanPurp = event.target.value;
            if (loanPurp === 'Other') {
                this.setOtherPurposeInput(comboBoxIndex, true)
            } else {
                this.setOtherPurposeInput(comboBoxIndex, false)
            }
            //Get the object in the array with the Id matching comboBoxIndex
            let indexOfObjectInArray = this.loanAmountPurposeArray.map(function (currentItem) {
                return currentItem.id
            }).indexOf(Number(comboBoxIndex));
            this.loanAmountPurposeArray[indexOfObjectInArray].loanPurpose = loanPurp;

        } else if (event.target.name === 'loanAmountQuote') {
            this.copyLoanDetailsObj.LoanAmountQuote = event.target.value;
        } else if (event.target.name === 'loanPurposeQuote') {
            this.copyLoanDetailsObj.LoanPurposeQuote = event.target.value;
        } else if (event.target.name === 'otherLoanPurposeQuote') {
            this.copyLoanDetailsObj.OtherLoanPurposeQuote = event.target.value;
        } else if (event.target.name === 'otherLoanPurpose') {
            otherLoanTextBoxIndex = event.target.dataset.name;
            otherLoanPurpVal = event.target.value;
            //Get the object in the array with the Id matching comboBoxIndex
            let indexOfObjectInArray = this.loanAmountPurposeArray.map(function (currentItem) {
                return currentItem.id
            }).indexOf(Number(otherLoanTextBoxIndex));
            this.loanAmountPurposeArray[indexOfObjectInArray].otherLoanPurpose = otherLoanPurpVal;
        }

        //remove warning
        let fieldName = event.target.name;
        let warningFieldName = '.' + fieldName + '_warning';
        if(this.template.querySelector(warningFieldName) != null && this.template.querySelector(warningFieldName).style.display == "") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }
    }

    setInputChanged() {
        const inputChanged = new CustomEvent("inputchanged", {
            detail: true
          });
      
          // Dispatches the event.
          this.dispatchEvent(inputChanged);        
    }

    /* Generic event for showing a toast message
       on the page.
    */
    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }

    @api handleValidationOnNext() {
        //clear better start validation
        let productTypePicklist = this.template.querySelector('.pla-productType');
        if(productTypePicklist != null) {
            productTypePicklist.setCustomValidity("");
            productTypePicklist.reportValidity();   
        } 

        //handle loan term validation
        let loanTermPicklist = this.template.querySelector('.pla-loanterm');
        loanTermPicklist.setCustomValidity("");
        loanTermPicklist.reportValidity();            
        if((loanTermPicklist.value != this.copyLoanDetailsObj.LoanTerm) && this.copyLoanDetailsObj.LoanTerm=='') {
            loanTermPicklist.setCustomValidity("Please select loan term.");
            loanTermPicklist.reportValidity();
        }        


        const inputFieldsCorrect = [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        //Validate if all the required fields have values and then fire an event to notify the parent 
        //component of a change in the step
        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        //if better start pl, validate loan amount and loan purpose
        let loanPurposeAmountValid = true;
        let productType = this.loanDetailsObj.ProductType;
        if('ProductType' in this.copyLoanDetailsObj) {
            productType = this.copyLoanDetailsObj.ProductType;
        }
        let loanAmount = this.loanDetailsObj.LoanAmountQuote;
        if('LoanAmountQuote' in this.copyLoanDetailsObj) {
            loanAmount = this.copyLoanDetailsObj.LoanAmountQuote;
        } 
        let loanPurpose = this.loanDetailsObj.LoanPurposeQuote.toLowerCase();
        if('LoanPurposeQuote' in this.copyLoanDetailsObj) {
            loanPurpose = this.copyLoanDetailsObj.LoanPurposeQuote.toLowerCase();
        }

        if(productType == 'Better Start PL') {
            let loanPurposeAmountCounter = 0;
            if(loanAmount >= 20000 && loanPurpose == 'debt consolidation') {
                loanPurposeAmountCounter++;
            }

            if(this.loanAmountPurposeArray.length > 0) {
                let filteredLoanAmountPurposeArray = this.loanAmountPurposeArray.filter((elem) => {
                    return elem.loanAmount >= 20000 && elem.loanPurpose.toLowerCase() == 'debt consolidation';
                });
                if(filteredLoanAmountPurposeArray.length > 0) {
                    loanPurposeAmountCounter++;
                }
             }
   
             if(loanPurposeAmountCounter == 0) {
                loanPurposeAmountValid = false;
                productTypePicklist.setCustomValidity("A Better Start Personal Loan must be for Debt Consolidation for $20,000 or more. If your client requires a standard Debt Consolidation loan, please update the Product Type to 'Standard PL'");
                productTypePicklist.reportValidity();                  
             }
        }

        if(!inputFieldsCorrect || !inputPicklistCorrect || !loanPurposeAmountValid) {
            window.scrollTo(0, 0);
        }

        return (inputFieldsCorrect && inputPicklistCorrect && loanPurposeAmountValid)
    }

    handleConsentNext() {

        if (this.handleValidationOnNext()) {
            //Add Loan Amount(s) & Loan Purpose(s) values to the object
            //let loanDetailsObj = this.primaryApplicantDetails.loanDetails;

            if (!('Applicants' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.Applicants = '1';
            }
            if (!('OtherLoanPurposeQuote' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.OtherLoanPurposeQuote = this.loanDetailsObj.OtherLoanPurposeQuote;
            }
            if(!('ProductType' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.ProductType = this.loanDetailsObj.ProductType;
            }
            if(!('LoanTerm' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.LoanTerm = this.loanDetailsObj.LoanTerm;                
            }
            this.copyLoanDetailsObj.SelectedLoanTermValues = this.loanTermValues;
            this.copyLoanDetailsObj.IsBetterStartActive = this.isBetterStartActive;            
            //Check if joint Application & if Applicant1Name has not been set in the object. 
            if (this.copyLoanDetailsObj.Applicants === '2' && !('Applicant1Name' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.Applicant1Name = this.loanDetailsObj.Applicant1Name;
            }
            this.copyLoanDetailsObj.LoanInfo = this.loanAmountPurposeArray;
            this.fireStepNotifyEvent();
        }
    }

    handleLoanDetailsChange(event) {
        //send event to parent to notify that page has been modified
        this.setInputChanged();
        
        let fieldName = event.target.name;
        let fieldValue = event.target.value;

        if (fieldName === 'loanterm') {
            this.copyLoanDetailsObj.LoanTerm = fieldValue;
            //Set Default applicants as 1
            this.copyLoanDetailsObj.Applicants = '1';
        } else if (fieldName === 'applicant1') {
            this.copyLoanDetailsObj.Applicant1Name = fieldValue;
        } else if (fieldName === 'applicant2') {
            this.copyLoanDetailsObj.Applicant2Name = fieldValue;
        } else if (fieldName === 'privacy') {
            this.copyLoanDetailsObj.PrivacyConsent = event.target.checked;
            //Check if other non mandatory consents are in the object. If not add them and set it as false, else ignore
            if (!('EIncome' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.EIncome = false;
            }
            if (!('EIdentification' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.EIdentification = false;
            }
            if (!('MaxLimit' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.MaxLimit = false;
            }
            /**Workaround added as the copyLoanDetailsObj does not have loanDetailsObj contents in connectedcallback, Check why is this happening: START */
            if (!('LoanAmountQuote' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.LoanAmountQuote = this.loanDetailsObj.LoanAmountQuote;
            }
            if (!('LoanPurposeQuote' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.LoanPurposeQuote = this.loanDetailsObj.LoanPurposeQuote;
            }
            if (!('LoanTerm' in this.copyLoanDetailsObj)) {
                this.copyLoanDetailsObj.LoanTerm = this.loanDetailsObj.LoanTerm;
            }
            /**Workaround added as the copyLoanDetailsObj does not have loanDetailsObj contents in connectedcallback, Check why is this happening: END */
        } else if (fieldName === 'productDisclosure') {
            this.copyLoanDetailsObj.ProductDisclosure = event.target.checked;
        } else if (fieldName === 'eCommunication') {
            this.copyLoanDetailsObj.ECommunication = event.target.checked;
        } else if (fieldName === 'eIncome') {
            this.copyLoanDetailsObj.EIncome = event.target.checked;
        } else if (fieldName === 'eIdentification') {
            this.copyLoanDetailsObj.EIdentification = event.target.checked;
        } else if (fieldName === 'maxLimit') {
            this.copyLoanDetailsObj.MaxLimit = event.target.checked;
        } else if (fieldName === 'producttype') {
            this.copyLoanDetailsObj.ProductType = fieldValue;
        }

        //remove warning
        let warningFieldName = '.' + fieldName + '_warning';
        if(this.template.querySelector(warningFieldName) != null && this.template.querySelector(warningFieldName).style.display == "") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }    
    }

    fireStepNotifyEvent() {
        this.dispatchEvent(new CustomEvent('notifystepinfo', {
            detail: {
                completedStep: 'step-1',
                nextStep: 'step-2',
                loanDetails: this.copyLoanDetailsObj
            }
        }));

    }

    @api getUpdatedDetails() {
        this.handleConsentNext();
    }

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

    setOtherPurposeInput(comboBoxIndex, value) {
        this.loanAmountPurposeArray = this.loanAmountPurposeArray.map(function (currentItem) {
            return Number(comboBoxIndex) === currentItem.id ? { ...currentItem, isOtherPurpose: value } : { ...currentItem }
        })
    }

    handleProductTypeChange(event) {
        event.target.setCustomValidity("");
        event.target.reportValidity();  

        /*let productTypePicklist = this.template.querySelector('.pla-productType');
        if(productTypePicklist != null) {
            productTypePicklist.setCustomValidity("");
            productTypePicklist.reportValidity();   
        }*/ 

        this.handleShowWarning(event);
        if(event.target.value == 'Better Start PL') {
            this.loanTermValues = this.loanTermBetterStart;
            this.primaryLoanAmountMinAmount = 20000;
            this.primaryLoanAmountMessage = 'Loan amount must be at least $20,000 for a Better Start Personal Loan.';              
        } else {
            this.loanTermValues = this.loanTerm;
            this.primaryLoanAmountMinAmount = 4000;
            this.primaryLoanAmountMessage = 'Your preferred loan amount must be at least $4000.';
        }
    }

    handleShowWarning(event) {
        let fieldName = event.target.name;
        let warningFieldName = '.' + fieldName + '_warning';
        let fieldValue = event.target.value;

        if(this.template.querySelector(warningFieldName).style.display == "none") {
            $(this.template.querySelector(warningFieldName)).slideToggle("fast");
        }

        if (fieldName === 'applicants') {
            this.copyLoanDetailsObj.Applicants = fieldValue;
        }        

        if(event.target.name === 'producttype') {
            this.copyLoanDetailsObj.LoanTerm = '';
        }        

        //send event to parent to notify that page has been modified
        this.setInputChanged();
    }

    genericErrorLoadingForm() {
        this.showToast('Error', 'Error Loading Application Form. Please try after sometime.', 'error', 'pester');
    }

    /**Custom labels for fields*/
    label = {
        BP_LBL_Loan_Amount,
        BP_LBL_Loan_Details_Section,
        BP_LBL_Loan_Purpose,
        BP_LBL_Other_Loan_Purpose,
        BP_LBL_Total_Loan_Amount,
        BP_LBL_Number_Of_Applicants,
        BP_LBL_Applicant_1,
        BP_LBL_Applicant_2,
        BP_LBL_Privacy_Credit_Reporting,
        BP_LBL_Privacy_21T,
        BP_LBL_Privacy_21T_Agrees,
        BP_LBL_Loan_Term,
        BP_LBL_Info_Change_Warning,
        BP_LBL_Product_Type_Decap,
        BP_LBL_Getting_Started_Section,
        BP_LBL_Privacy_21T_Content1,
        BP_LBL_Privacy_21T_Content2,
        BP_LBL_Product_Disclosure_Heading,
        BP_LBL_Product_Disclosure,
        BP_LBL_Product_Disclosure_Agrees,
        BP_LBL_Product_Disclosure_Header,
        BP_LBL_Product_Disclosure_Content,
        BP_LBL_E_Communication,
        BP_LBL_E_Communication_Clickable,
        BP_LBL_E_Communication_Agrees,
        BP_LBL_E_Communication_Header,
        BP_LBL_E_Communication_Content,
        BP_LBL_E_POI,
        BP_LBL_E_POI_Clickable,
        BP_LBL_E_POI_Agrees,
        BP_LBL_E_POI_Header,
        BP_LBL_E_POI_Content,
        BP_LBL_EIDV,
        BP_LBL_EIDV_Clickable,
        BP_LBL_EIDV_Agrees,
        BP_LBL_EIDV_Header,
        BP_LBL_EIDV_Content,
        BP_LBL_HAS_Header,
        BP_LBL_HAS_Content,
        BP_LBL_HAS_Clickable,
        BP_LBL_HAS_Agrees,
        BP_LBL_HAS,
        BP_LBL_Add_Loan_Purpose_Button
    }

}