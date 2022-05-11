import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuoteDetails from '@salesforce/apex/ApplicationFormController.getQuoteDetails';
import getBetterStartOfferConfig from '@salesforce/apex/ApplicationFormController.getBetterStartOfferConfig';
import getLatitudeBrandRecord from '@salesforce/apex/ApplicationFormController.getLatitudeBrandRecord';
import applicationSubmit from '@salesforce/apex/PersonalLoanAppSubmit.applicationSubmit';
import { NavigationMixin } from 'lightning/navigation';
import BP_LBL_Picklist_Error from '@salesforce/label/c.BP_LBL_Picklist_Error';
import BP_LBL_Navigation_Error from '@salesforce/label/c.BP_LBL_Navigation_Error';
import BP_LBL_Navigation_Next_Error from '@salesforce/label/c.BP_LBL_Navigation_Next_Error';
import BP_LBL_About_Joint_Error from '@salesforce/label/c.BP_LBL_About_Joint_Error';
import BP_LBL_Employment_Joint_Error from '@salesforce/label/c.BP_LBL_Employment_Joint_Error';
import BP_LBL_Expense_Joint_Error from '@salesforce/label/c.BP_LBL_Expense_Joint_Error';
import { loadStyle } from 'lightning/platformResourceLoader';
import customCSS from '@salesforce/resourceUrl/PLApplicationFromStaticCSS';





export default class PlApplicationForm extends NavigationMixin(LightningElement) {

    steps = [
        { label: 'Loan Details', value: 'step-1' },
        { label: 'About', value: 'step-2' },
        { label: 'Employment', value: 'step-3' },
        { label: 'Expenses', value: 'step-4' },
        { label: 'Assets', value: 'step-5' },
        { label: 'Debts', value: 'step-6' },
        { label: 'Review', value: 'step-7' },
    ];

    currentStep = 'step-1';
    //Primary Applicant Object to be received with data from child components (Joint applicant later)
    @track primaryApplicantDetails = {
        loanDetails: {},
        personalDetails: {},
        personalDetailsJoint: {},
        employmentDetails: {},
        employmentDetailsJoint: {},
        expenseDetails: {},
        expenseDetailsJoint: {},
        assetDetails: {},
        debtDetails: {},
        betterStartOfferConfig: {},
        latitudeBrandRecord: {}
    };


    @track completedSteps = [];
    @track originalProductType;
    @track inputChanged = false;
    parameters = {};
    currentPageReference = null;
    urlStateParameters = null;
    quoteId;
    dataPrepopulatedOnLoad = false;
    showPath = true;
    showSpinner = false;
    showSubmitInProgressMsg = false;
    showAppSubmitInfo = false;
    showSuccessMessage = false;
    showErrorMessage = false;
    latitudeUid;
    quoteName;
    previousStep = null;
    applicant1Name = null;
    applicant2Name = null;
    showErrorIndicatorPrimary = false;
    hasRendered = false;


    @wire(getBetterStartOfferConfig)
    handleBetterStartOfferConfig({ data, error }) {
        if (data) {
            this.primaryApplicantDetails.betterStartOfferConfig = data;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getLatitudeBrandRecord)
    handleLatitudeBrandRecord({ data, error }) {
        if (data) {
            this.primaryApplicantDetails.latitudeBrandRecord = data;
        } else {
            console.log(error);
        }
    }

    connectedCallback() {
        //get the quote id from the browser storage
        this.quoteId = localStorage.getItem('eqi');
        if (!this.dataPrepopulatedOnLoad) {
            this.dataPrepopulatedOnLoad = true;
            getQuoteDetails({
                quoteId: this.quoteId
            }).then(result => {

                if (result !== null && result.Quote_Stage__c === 'Converted to Application') {
                    this.quoteName = result.Name;
                    this.latitudeUid = result.UID__c;
                    return;
                }
                this.prePopulateAppForm(result);
                //localStorage.removeItem('eqi');
            }).catch(error => {
                console.error(error);
                this.showToast('Error', BP_LBL_Picklist_Error, 'error', 'pester');
            })
        }
        window.addEventListener('beforeunload', this.beforeUnloadHandler);
    }

    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.beforeUnloadHandler);
        //this.inputChanged = false;
    }

    renderedCallback() {
        if (!this.hasRendered) {
            this.hasRendered = true;
            //Load custom css
            Promise.all([
                loadStyle(this, customCSS)
            ]);
        }
    }


    //Function to show prompt to user prior navigating away and has already made interation on page
    beforeUnloadHandler = (ev) => {
        if (this.inputChanged || this.currentStep != 'step-1') {
            ev.preventDefault();
            ev.returnValue = false;
        }
    }

    handleInputChanged(event) {
        this.inputChanged = event.detail;
    }

    handleStepNavigation(event) {

        let stepNavigatingTo = event.target.value;
        if (!this.completedSteps.includes(stepNavigatingTo)) {
            this.showToast('Error', BP_LBL_Navigation_Next_Error, 'error', 'pester');
        } else {
            let isValid = false;
            let validStepName = null;
            if (this.isStep1) {
                isValid = this.validateCurrentStep('step-1');
                if (isValid) {
                    validStepName = 'step-1';
                }
            } else if (this.isStep2) {
                isValid = this.validateCurrentStep('step-2');
                if (isValid) {
                    validStepName = 'step-2';
                }
            } else if (this.isStep3) {
                isValid = this.validateCurrentStep('step-3');
                if (isValid) {
                    validStepName = 'step-3';
                }
            } else if (this.isStep4) {
                isValid = this.validateCurrentStep('step-4');
                if (isValid) {
                    validStepName = 'step-4';
                }
            } else if (this.isStep5) {
                isValid = this.validateCurrentStep('step-5');
                if (isValid) {
                    validStepName = 'step-5';
                }
            } else if (this.isStep6) {
                isValid = this.validateCurrentStep('step-6');
                if (isValid) {
                    validStepName = 'step-6';
                }
            } else if (this.isStep7) {
                isValid = true;
            }
            //If valid, update & navigate
            if (isValid) {
                this.updateCurrentStepValues(validStepName);
                this.currentStep = event.target.value;
            } else {
                this.showToast('Error', BP_LBL_Navigation_Error, 'error', 'pester');
            }
        }

    }

    validateCurrentStep(currentActiveStep) {


        if (currentActiveStep === 'step-1') {
            //Loan Details
            return this.template.querySelector('c-loan-app-consent').handleValidationOnNext();
        } else if (currentActiveStep === 'step-2') {
            //Personal Details
            let applicant1 = this.template.querySelector('c-loan-personal-details').handleValidationOnNext();

            let applicant2 = null;

            if (this.isJointApplication) {
                applicant2 = this.template.querySelector('c-loan-personal-details-joint').handleValidationOnNext();

            }
            if (applicant2 !== null) {

                return (applicant1 && applicant2);
            } else {

                return applicant1;
            }
        } else if (currentActiveStep === 'step-3') {
            //Employment Details
            let applicant1 = this.template.querySelector('c-loan-employment-details').handleValidationOnNext();
            let applicant2 = null;
            if (this.isJointApplication) {
                applicant2 = this.template.querySelector('c-loan-employment-details-joint').handleValidationOnNext();
            }
            if (applicant2 !== null) {
                return (applicant1 && applicant2);
            } else {
                return applicant1;
            }
        } else if (currentActiveStep === 'step-4') {
            //Expense Details
            return this.template.querySelector('c-loan-expense-details').handleValidationOnNext();
            //let applicant2 = null;
            // if (this.isJointApplication) {
            //     applicant2 = this.template.querySelector('c-loan-expense-details-joint').handleValidationOnNext();
            // }
            // if (applicant2 !== null) {
            //     return (applicant1 && applicant2);
            // } else {
            //     return applicant1;
            // }
        } else if (currentActiveStep === 'step-5') {
            //Asset Details
            return this.template.querySelector('c-loan-asset-details').handleValidationOnNext();
        } else if (currentActiveStep === 'step-6') {
            //Debt Details
            return this.template.querySelector('c-loan-debt-details').handleValidationOnNext();
        } else if (currentActiveStep === 'step-7') {
            return true;
        }

    }

    updateCurrentStepValues(validStepName) {

        if (validStepName === 'step-1') {
            //Loan Details
            this.template.querySelector('c-loan-app-consent').getUpdatedDetails();
        } else if (validStepName === 'step-2') {
            //Personal Details
            this.template.querySelector('c-loan-personal-details').getUpdatedDetails();
            if (this.isJointApplication) {
                this.template.querySelector('c-loan-personal-details-joint').getUpdatedDetails();
            }

        } else if (validStepName === 'step-3') {
            //Employment Details
            this.template.querySelector('c-loan-employment-details').getUpdatedDetails();
            if (this.isJointApplication) {
                this.template.querySelector('c-loan-employment-details-joint').getUpdatedDetails();
            }
        } else if (validStepName === 'step-4') {
            //Expense Details
            this.template.querySelector('c-loan-expense-details').getUpdatedDetails();
            // if (this.isJointApplication) {
            //     this.template.querySelector('c-loan-expense-details-joint').getUpdatedDetails();
            // }
        } else if (validStepName === 'step-5') {
            //Asset Details
            this.template.querySelector('c-loan-asset-details').getUpdatedDetails();
        } else if (validStepName === 'step-6') {
            //Debt Details
            this.template.querySelector('c-loan-debt-details').getUpdatedDetails();
        }
    }

    get isStep1() {
        return this.currentStep === 'step-1';
    }

    get isStep2() {
        return this.currentStep === 'step-2';
    }

    get isStep3() {
        return this.currentStep === 'step-3';
    }

    get isStep4() {
        return this.currentStep === 'step-4';
    }

    get isStep5() {
        return this.currentStep === 'step-5';
    }

    get isStep6() {
        return this.currentStep === 'step-6';
    }

    get isStep7() {
        return this.currentStep === 'step-7';
    }

    get primaryApplicantInfo() {
        return this.primaryApplicantDetails;
    }

    get loanDetailsObj() {
        return this.primaryApplicantDetails.loanDetails;
    }
    //Primary Applicant Personal Details
    get personalDetailsObj() {
        return this.primaryApplicantDetails.personalDetails;
    }
    //Joint Applicant Personal Details
    get personalDetailsJointObj() {
        return this.primaryApplicantDetails.personalDetailsJoint;
    }
    //Primary Applicant Employment Details
    get employmentDetailsObj() {
        return this.primaryApplicantDetails.employmentDetails;
    }
    //Joint Applicant Employment Details
    get employmentDetailsJointObj() {
        return this.primaryApplicantDetails.employmentDetailsJoint;
    }
    //Primary Applicant Expense Details
    get expenseDetailsObj() {
        return this.primaryApplicantDetails.expenseDetails;
    }
    //Joint Applicant Expense Details
    get expenseDetailsJointObj() {
        return this.primaryApplicantDetails.expenseDetailsJoint;
    }

    get assetDetailsObj() {
        return this.primaryApplicantDetails.assetDetails;
    }

    get debtDetailsObj() {
        return this.primaryApplicantDetails.debtDetails;
    }

    get primaryApplicantDetailsObj() {
        return this.primaryApplicantDetails;
    }

    get isJointApplication() {
        if (this.primaryApplicantDetails.loanDetails !== undefined) {
            if (this.primaryApplicantDetails.loanDetails.Applicants === '2') {
                return true;
            } else {
                return false;
            }
        }
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

    handleLoanDetailsInfo(event) {

        this.currentStep = event.detail.nextStep;
        this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        let loanDetObj = event.detail.loanDetails;
        this.primaryApplicantDetails.loanDetails = loanDetObj;

        //Set Applicant details
        if ('Applicant1Name' in loanDetObj) {
            this.applicant1Name = loanDetObj.Applicant1Name;
        }
        if ('Applicant2Name' in loanDetObj) {
            this.applicant2Name = loanDetObj.Applicant2Name;
            this.primaryApplicantDetails.personalDetailsJoint.FirstName = loanDetObj.Applicant2Name;
            this.primaryApplicantDetails.personalDetailsJoint.IsPostalAddSameAsRes = true;

        }

    }

    //Primary Applicant Personal Information
    handlePersonalDetailsInfo(event) {
        this.showErrorIndicatorPrimary = false;
        if (!this.isJointApplication) {
            this.currentStep = event.detail.nextStep;
            this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        }
        this.primaryApplicantDetails.personalDetails = event.detail.personalDetails;

    }

    //Joint Applicant Personal Information
    handlePersonalDetailsJointInfo(event) {
        //Check if Primary Applicant Tab does not have any errors
        if (this.template.querySelector('c-loan-personal-details').handleValidationOnNext()) {
            this.currentStep = event.detail.nextStep;
            this.completedSteps = [...this.completedSteps, event.detail.completedStep];
            this.primaryApplicantDetails.personalDetailsJoint = event.detail.personalDetailsJoint;
            this.showErrorIndicatorPrimary = false;
        } else {
            this.showErrorIndicatorPrimary = true;
            //This is needed if the user scrolls down during page load and you want to make sure the page is scrolled to the top once it's fully loaded. This has Cross-browser support.
            window.scrollTo(0, 0);
            this.showToast('Error', BP_LBL_About_Joint_Error, 'error', 'pester');
        }

    }

    handlePrevNavigation(event) {
        this.currentStep = event.detail.prevStep;
        this.showErrorIndicatorPrimary = false;
    }

    //Primary Applicant Employment Information
    handleEmploymentDetailsInfo(event) {
        if (!this.isJointApplication) {
            this.currentStep = event.detail.nextStep;
            this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        }
        this.primaryApplicantDetails.employmentDetails = event.detail.employmentDetails;
    }

    //Joint Applicant Employment Information
    handleEmploymentDetailsJointInfo(event) {
        //Check if Primary Applicant Tab does not have any errors
        if (this.template.querySelector('c-loan-employment-details').handleValidationOnNext()) {
            this.currentStep = event.detail.nextStep;
            this.completedSteps = [...this.completedSteps, event.detail.completedStep];
            this.primaryApplicantDetails.employmentDetailsJoint = event.detail.employmentDetailsJoint;
            this.showErrorIndicatorPrimary = false;
        } else {

            this.showErrorIndicatorPrimary = true;

            //This is needed if the user scrolls down during page load and you want to make sure the page is scrolled to the top once it's fully loaded. This has Cross-browser support.
            window.scrollTo(0, 0);
            this.showToast('Error', BP_LBL_Employment_Joint_Error, 'error', 'pester');
        }


    }

    //Primary Applicant Expense Information
    handleExpenseDetailsInfo(event) {
        // if (!this.isJointApplication) {
        //     this.currentStep = event.detail.nextStep;
        //     this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        // }
        // this.primaryApplicantDetails.expenseDetails = event.detail.expenseDetails;
        this.currentStep = event.detail.nextStep;
        this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        this.primaryApplicantDetails.expenseDetails = event.detail.expenseDetails;
    }

    //Joint Applicant Expense Information
    handleExpenseDetailsJointInfo(event) {
        //Check if Primary Applicant Tab does not have any errors
        if (this.template.querySelector('c-loan-expense-details').handleValidationOnNext()) {
            this.currentStep = event.detail.nextStep;
            this.completedSteps = [...this.completedSteps, event.detail.completedStep];
            this.primaryApplicantDetails.expenseDetailsJoint = event.detail.expenseDetailsJoint;
            this.showErrorIndicatorPrimary = false;

        } else {
            this.showErrorIndicatorPrimary = true;
            //This is needed if the user scrolls down during page load and you want to make sure the page is scrolled to the top once it's fully loaded. This has Cross-browser support.
            window.scrollTo(0, 0);
            this.showToast('Error', BP_LBL_Expense_Joint_Error, 'error', 'pester');
        }

    }

    handleAssetDetailsInfo(event) {
        this.currentStep = event.detail.nextStep;
        this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        this.primaryApplicantDetails.assetDetails = event.detail.assetDetails;
        receiveConsent({
            data: JSON.stringify(this.primaryApplicantDetails)
        }).then(result => {

        }).catch(error => {

        })
    }

    handleDebtDetailsInfo(event) {
        this.currentStep = event.detail.nextStep;
        this.completedSteps = [...this.completedSteps, event.detail.completedStep];
        //Add Step-7 to the completed steps along with step-6
        let step7 = 'step-7';
        this.completedSteps = [...this.completedSteps, step7];
        this.primaryApplicantDetails.debtDetails = event.detail.debtDetails;
        receiveConsent({
            data: JSON.stringify(this.primaryApplicantDetails)
        }).then(result => {

        }).catch(error => {

        })

    }

    prePopulateAppForm(data) {

        if (data !== null) {
            this.primaryApplicantDetails.loanDetails.LoanTerm = data.Loan_Term__c;
            this.primaryApplicantDetails.loanDetails.LoanAmountQuote = data.Loan_Amount__c;
            this.primaryApplicantDetails.loanDetails.LoanPurposeQuote = data.Loan_Purpose__c;
            this.primaryApplicantDetails.loanDetails.Applicants = '1';
            this.primaryApplicantDetails.loanDetails.Applicant1Name = data.First_Name__c;
            if ((data.hasOwnProperty('Sub_Type__c') && data.Sub_Type__c != 'Better Start') || !data.hasOwnProperty('Sub_Type__c')) {
                this.primaryApplicantDetails.loanDetails.ProductType = 'Standard PL';
            } else {
                this.primaryApplicantDetails.loanDetails.ProductType = 'Better Start PL';
            }
            this.originalProductType = this.primaryApplicantDetails.loanDetails.ProductType;

            if (data.Other_Loan_Purpose__c !== undefined) {
                this.primaryApplicantDetails.loanDetails.OtherLoanPurposeQuote = data.Other_Loan_Purpose__c;
            }

            this.prePopulatePersonalDetails(data);

            //Set Employment Details from Quote
            this.primaryApplicantDetails.employmentDetails.IncomeQuote = data.Income_Source__c;
            this.primaryApplicantDetails.employmentDetails.OccupationQuote = data.Occupation__c;
            this.primaryApplicantDetails.employmentDetails.EmploymentYearsQuote = data.Years_at_Current_Employment__c;
            this.primaryApplicantDetails.employmentDetails.EmploymentMonthsQuote = data.Months_at_Current_Employment__c;

            //Residential Status
            this.primaryApplicantDetails.expenseDetails.ResidentialStatus = data.Residential_Status__c;


        }

    }

    prePopulatePersonalDetails(data) {
        //Personal Details Fields
        this.primaryApplicantDetails.personalDetails.LatitudeUid = data.UID__c;
        this.primaryApplicantDetails.personalDetails.Title = data.Title__c;
        this.primaryApplicantDetails.personalDetails.FirstName = data.First_Name__c;
        if (this.isJointApplication) {
            this.primaryApplicantDetails.personalDetailsJoint.FirstName = this.applicant2Name;
        }
        this.primaryApplicantDetails.personalDetails.MiddleName = data.Middle_Name__c;
        this.primaryApplicantDetails.personalDetails.LastName = data.Last_Name__c;
        this.primaryApplicantDetails.personalDetails.Gender = data.Gender__c;
        if (data.Date_of_Birth__c) {
            let quoteDOB = data.Date_of_Birth__c;
            let dobArray = quoteDOB.split('/');
            let dobDay = dobArray[0];
            let dobMonth = dobArray[1];
            let dobYear = dobArray[2];
            this.primaryApplicantDetails.personalDetails.dobDay = dobDay;
            this.primaryApplicantDetails.personalDetails.dobMonth = dobMonth;
            this.primaryApplicantDetails.personalDetails.dobYear = dobYear;
            this.primaryApplicantDetails.personalDetails.DateOfBirth = quoteDOB;
        }
        if (data.Driver_s_Licence_Number__c) {
            this.primaryApplicantDetails.personalDetails.DLNumber = data.Driver_s_Licence_Number__c;
        } else {
            this.primaryApplicantDetails.personalDetails.NoDL = true;
        }
        //Current Residential Address Details
        this.primaryApplicantDetails.personalDetails.ResidentialUnitNumber = data.Residential_Unit_Number__c;
        this.primaryApplicantDetails.personalDetails.ResidentialStreetNumber = data.Residential_Street_Number__c;
        this.primaryApplicantDetails.personalDetails.ResidentialStreet = data.Residential_Street_Name__c;
        this.primaryApplicantDetails.personalDetails.ResidentialStreetType = data.Residential_Street_type_abbreviated_code__c;
        this.primaryApplicantDetails.personalDetails.ResidentialSuburb = data.Residential_Suburb__c;
        this.primaryApplicantDetails.personalDetails.ResidentialState = data.Residential_State__c;
        this.primaryApplicantDetails.personalDetails.ResidentialPostcode = data.Residential_Postcode__c;
        this.primaryApplicantDetails.personalDetails.ResidentialCountry = data.Residential_Country__c;
        this.primaryApplicantDetails.personalDetails.ResidentialPropName = data.Property_Name__c;
        this.primaryApplicantDetails.personalDetails.ResidentialYears = data.Years_at_Residential_Address__c;
        this.primaryApplicantDetails.personalDetails.ResidentialMonths = data.Months_at_Residential_Address__c;
        this.primaryApplicantDetails.personalDetails.IsPostalAddSameAsRes = true;

        //Previous Residential Address Details
        if (Number(this.primaryApplicantDetails.personalDetails.ResidentialYears) < 3) {
            this.primaryApplicantDetails.personalDetails.PrevUnitNumber = data.Previous_Unit_Number__c;
            this.primaryApplicantDetails.personalDetails.PrevStreetNumber = data.Previous_Street_Number__c;
            this.primaryApplicantDetails.personalDetails.PrevStreet = data.Previous_Street_Name__c;
            this.primaryApplicantDetails.personalDetails.PrevStreetType = data.Previous_ResStreet_type_abbreviated_code__c;
            this.primaryApplicantDetails.personalDetails.PrevSuburb = data.Previous_Suburb__c;
            this.primaryApplicantDetails.personalDetails.PrevState = data.Previous_State__c;
            this.primaryApplicantDetails.personalDetails.PrevPostcode = data.Previous_Postcode__c;
            this.primaryApplicantDetails.personalDetails.PrevCountry = data.Previous_Country__c;
            this.primaryApplicantDetails.personalDetails.PrevProperty = data.Previous_Property_Name__c;
        }
        this.primaryApplicantDetails.personalDetails.Email = data.Email_ID__c;
        this.primaryApplicantDetails.personalDetails.MobileNumber = data.Mobile_Number__c;
        this.primaryApplicantDetails.personalDetails.BrokerFees = data.Brokerage_Fee__c;
        this.primaryApplicantDetails.personalDetails.QuoteId = this.quoteId;

        this.primaryApplicantDetails.expenseDetails.FoodFrequency = 'Month';
        this.primaryApplicantDetails.expenseDetails.InsuranceFrequency = 'Month';
        this.primaryApplicantDetails.expenseDetails.UtilitiesFrequency = 'Month';
        this.primaryApplicantDetails.expenseDetails.TransportFrequency = 'Month';
        this.primaryApplicantDetails.expenseDetails.EducationFrequency = 'Month';
        this.primaryApplicantDetails.expenseDetails.PersonalFrequency = 'Month';

    }

    handleAppSubmit() {
        this.showPath = false;
        this.showSpinner = true;
        this.currentStep = null;
        this.showSubmitInProgressMsg = true;
        this.showAppSubmitInfo = true;

        //Pass data to the server
        applicationSubmit({
            primaryApplicantDetailsObj: JSON.stringify(this.primaryApplicantDetailsObj)
        })
            .then(result => {
                //show fake spinner for another 50 seconds: allows time for the application to be submitted to DP via futurehandler
                setTimeout(() => {
                    this.showSpinner = false;
                    this.showSubmitInProgressMsg = false;
                    this.showSuccessMessage = true;
                    this.latitudeUid = result;
                }, 50000);
            }).catch(error => {
                console.error(error);
                this.showSpinner = false;
                this.showSubmitInProgressMsg = false;
                this.showErrorMessage = true;
            })

    }

    _setOnPopStateHandler() {
        window.onpopstate = (ev) => {
            // get the state for the history entry the user is going to be on
            const state = ev.state;
        };
    }

    handleGotoJointPersonal() {
        this.showErrorIndicatorPrimary = false;
        this.template.querySelector('lightning-tabset').activeTabValue = this.applicant2Name;
    }

    handleGotoJointEmployment() {
        this.showErrorIndicatorPrimary = false;
        this.template.querySelector('lightning-tabset').activeTabValue = this.applicant2Name;
    }

    handleGotoJointExpense() {
        this.showErrorIndicatorPrimary = false;
        this.template.querySelector('lightning-tabset').activeTabValue = this.applicant2Name;
    }

    handleAllApplications() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'applications__c',
            },
        });
    }

    /**Custom labels for fields*/
    label = {

    }

}