import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getApplicationDetail from '@salesforce/apex/UploadDocumentsController.getApplicationDetail';
import BP_LBL_BASE_URL from '@salesforce/label/c.BP_LBL_BASE_URL';
import BP_LBL_POI_PFT_Payslip from '@salesforce/label/c.BP_LBL_POI_PFT_Payslip';
import BP_LBL_POI_PFT_BankStatement from '@salesforce/label/c.BP_LBL_POI_PFT_BankStatement';
import BP_LBL_POI_SelfEmployed_IndividualTaxReturn from '@salesforce/label/c.BP_LBL_POI_SelfEmployed_IndividualTaxReturn';
import BP_LBL_POI_SelfEmployed_NoticeOfAssessment from '@salesforce/label/c.BP_LBL_POI_SelfEmployed_NoticeOfAssessment';
import BP_LBL_POI_SelfEmployed_LetterFromAccountant from '@salesforce/label/c.BP_LBL_POI_SelfEmployed_LetterFromAccountant';
import BP_LBL_POI_SelfEmployed_BankStatement from '@salesforce/label/c.BP_LBL_POI_SelfEmployed_BankStatement';
import BP_LBL_POI_CTSC_Payslip from '@salesforce/label/c.BP_LBL_POI_CTSC_Payslip';
import BP_LBL_POI_CTSC_BankStatement from '@salesforce/label/c.BP_LBL_POI_CTSC_BankStatement';
import BP_LBL_POI_CTSC_LetterFromEmployer from '@salesforce/label/c.BP_LBL_POI_CTSC_LetterFromEmployer';
import BP_LBL_POI_RentalIncome from '@salesforce/label/c.BP_LBL_POI_RentalIncome';
import BP_LBL_POI_CIP_CentrelinkDepartment from '@salesforce/label/c.BP_LBL_POI_CIP_CentrelinkDepartment';
import BP_LBL_POI_CIP_BankStatement from '@salesforce/label/c.BP_LBL_POI_CIP_BankStatement';
import BP_LBL_POI_CSI_LegalDocumentation from '@salesforce/label/c.BP_LBL_POI_CSI_LegalDocumentation';
import BP_LBL_POI_CSI_BankStatement from '@salesforce/label/c.BP_LBL_POI_CSI_BankStatement';
import BP_LBL_POI_WorkersCompensation_LetterFromFundManager from '@salesforce/label/c.BP_LBL_POI_WorkersCompensation_LetterFromFundManager';
import BP_LBL_POI_WorkersCompensation_ReturnToWorkPlan from '@salesforce/label/c.BP_LBL_POI_WorkersCompensation_ReturnToWorkPlan';

export default class UploadDocumentsCmp extends NavigationMixin(LightningElement) {
    @track applicationId;
    @track applicationStatus;
    @track statusForDisplay;
    @track applicationDetail;
    @track primaryApplicant;
    @track applicants;
    @track mapApplicantIncome;
    @track showSpinner = false;
    @track loadDone = false; 
    @track jointApplication = false;
    @track hasDebtConsolidation = false;
    @track showRichTextModal = false;
    @track modalRichTextTitle;
    @track modalRichTextContent;
    @track poiSectionNeeded = false;
    @track docIdSectionNeeded = false;
    @track securedLendNeeded = false;
    @track isReferredStatus = false;
    devMode = false;

    poiList = [
        {
            name: 'permanent_or_parttime',
            title: 'Permanent Full-time/Part-time Employment',
            content: [
                {
                    title: "Payslip",
                    content: BP_LBL_POI_PFT_Payslip
                },
                {
                    title: "Bank Statement",
                    content: BP_LBL_POI_PFT_BankStatement
                }
            ]
        },
        {
            name: 'self_employed',
            title: 'Self-Employed',
            content: [
                {
                    title: "Individual Tax Return",
                    content: BP_LBL_POI_SelfEmployed_IndividualTaxReturn
                },
                {
                    title: "Notice of Assessment",
                    content: BP_LBL_POI_SelfEmployed_NoticeOfAssessment
                },
                {
                    title: "Letter from Accountant",
                    content: BP_LBL_POI_SelfEmployed_LetterFromAccountant
                },
                {
                    title: "Bank Statement",
                    content: BP_LBL_POI_SelfEmployed_BankStatement
                }                                
            ]
        },  
        {
            name: 'casual_temporary_seasonal_contractors',
            title: 'Casual / Temporary / Seasonal / Contractors',
            content: [
                {
                    title: "Payslip",
                    content: BP_LBL_POI_CTSC_Payslip
                },
                {
                    title: "Bank Statement",
                    content: BP_LBL_POI_CTSC_BankStatement
                },
                {
                    title: "Letter from Employer",
                    content: BP_LBL_POI_CTSC_LetterFromEmployer
                }                             
            ]
        },      
        {
            name: 'rental_income',
            title: 'Rental Income',
            content: 
                {
                    title: "Rental Income",
                    content: BP_LBL_POI_RentalIncome
                }                            
        },  
        {
            name: 'centrelink_income_pension',
            title: 'Centrelink Income / Pension',
            content: [
                {
                    title: "Centrelink/Department of Human Service Statement",
                    content: BP_LBL_POI_CIP_CentrelinkDepartment
                },
                {
                    title: "Bank Statement",
                    content: BP_LBL_POI_CIP_BankStatement
                }                         
            ]
        }, 
        {
            name: 'child_support_income',
            title: 'Child Support Income',
            content: [
                {
                    title: "Legal documentation and / or Child Support Agency Documents",
                    content: BP_LBL_POI_CSI_LegalDocumentation
                },
                {
                    title: "Bank Statement",
                    content: BP_LBL_POI_CSI_BankStatement
                }                           
            ]
        }, 
        {
            name: 'workers_compensation',
            title: 'Workers Compensation',
            content: [
                {
                    title: "Letter From Fund Manager / Insurer",
                    content: BP_LBL_POI_WorkersCompensation_LetterFromFundManager
                },
                {
                    title: "Return to Work Plan",
                    content: BP_LBL_POI_WorkersCompensation_ReturnToWorkPlan
                }                           
            ]
        }                                                    
    ];

    
    //start methods to get poi based on employment status
    isPermanentOrParttime() {
        return this.poiList.find(element => element.name === 'permanent_or_parttime'); 
    }

    isSelfEmployed() {
        return this.poiList.find(element => element.name === 'self_employed');
    } 
    
    isCasualTemporarySeasonalContractors() {
        return this.poiList.find(element => element.name === 'casual_temporary_seasonal_contractors');
    }
    
    isRentalIncome() {
        return this.poiList.find(element => element.name === 'rental_income');
    } 
    
    isCentrelinkIncomePension() {
        return this.poiList.find(element => element.name === 'centrelink_income_pension');
    } 
    
    isChildSupportIncome() {
        return this.poiList.find(element => element.name === 'child_support_income');
    }   
    
    isWorkersCompensation() {
        return this.poiList.find(element => element.name === 'workers_compensation');
    }    
    //end methods to get poi based on employment status

    connectedCallback() {
        this.applicationId = sessionStorage.getItem("UD_applicationId");
        this.applicationStatus = sessionStorage.getItem("UD_status");
        this.statusForDisplay = sessionStorage.getItem("UD_statusForDisplay");
        this.showSpinner = true;
        getApplicationDetail({
            applicationId: this.applicationId
        }).then(result => {
            this.showSpinner = false;
            this.applicationDetail = {
                applicationId: result.application.Id,
                loanNumber: result.application.UID__c,
            };
            this.applicationDetail.applicants = result.applicants;
            if(this.applicationDetail.applicants.length > 1) {
                this.jointApplication = true;
            }

            for(let applicant of this.applicationDetail.applicants) {
                applicant.fullName = applicant.First_Name__c + ' ' + applicant.Last_Name__c;
                if(applicant.Is_Primary_Applicant__c) {
                    applicant.iconName = "standard:opportunity_contact_role";
                } else {
                    applicant.iconName = "standard:people";
                }
            }

            this.primaryApplicant = Object.assign({}, this.applicationDetail.applicants.find(element => element.Is_Primary_Applicant__c));
            this.mapApplicantIncome = result.mapApplicantIncome;
            this.determineApplicantsProofOfIncome();

            if(!this.devMode) {
                if(this.applicationStatus.toLowerCase() === "ID & Proof of Income required".toLowerCase()) {
                    this.poiSectionNeeded = true;
                    this.docIdSectionNeeded = true;
                    if(result.isDebtConsolidation) {
                        this.hasDebtConsolidation = true;
                    }             
                    this.securedLendNeeded = true;       
                } else if(this.applicationStatus.toLowerCase() === "Proof of Income required".toLowerCase()) {
                    this.poiSectionNeeded = true;
                    if(result.isDebtConsolidation) {
                        this.hasDebtConsolidation = true;
                    }            
                    this.securedLendNeeded = true;        
                } else if(this.applicationStatus.toLowerCase() === "ID required".toLowerCase()) {
                    this.docIdSectionNeeded = true;
                }
            } else {
                this.docIdSectionNeeded = true;
                this.poiSectionNeeded = true;
            }

            //check if application status is referred or not
            if(this.applicationStatus.toLowerCase() == 'referred') {
                this.isReferredStatus = true;
            }

            this.loadDone = true;
        }).catch(error => {
            this.showSpinner = false;
            console.error(error);
            //this.showToast('Error', BP_LBL_Picklist_Error, 'error', 'pester');
        });                
    }

    determineApplicantsProofOfIncome() {
        for(let applicant of this.applicationDetail.applicants) {
            let listPOITemp = [];
            for(let income of this.mapApplicantIncome[applicant.Id]) {
                let po = {};
                po.sourceOfIncome = '';
                po.plainTitle = '';
                po.content = [];
                switch (income.Income_Source__c) {
                    case "My permanent - full time job":
                        po.sourceOfIncome = "<b>"+this.isPermanentOrParttime().title+"</b> (one of the following)";
                        po.plainTitle = this.isPermanentOrParttime().title;
                        po.content = this.isPermanentOrParttime().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My permanent - part time job":
                        po.sourceOfIncome = "<b>"+this.isPermanentOrParttime().title+"</b> (one of the following)";
                        po.plainTitle = this.isPermanentOrParttime().title;
                        po.content = this.isPermanentOrParttime().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My casual/temporary job":
                        po.sourceOfIncome = "<b>"+this.isCasualTemporarySeasonalContractors().title+"</b> (one of the following)";
                        po.plainTitle = this.isCasualTemporarySeasonalContractors().title;
                        po.content = this.isCasualTemporarySeasonalContractors().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My contracting job":
                        po.sourceOfIncome = "<b>"+this.isCasualTemporarySeasonalContractors().title+"</b> (one of the following)";
                        po.plainTitle = this.isCasualTemporarySeasonalContractors().title;
                        po.content = this.isCasualTemporarySeasonalContractors().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My seasonal job":
                        po.sourceOfIncome = "<b>"+this.isCasualTemporarySeasonalContractors().title+"</b> (one of the following)";
                        po.plainTitle = this.isCasualTemporarySeasonalContractors().title;
                        po.content = this.isCasualTemporarySeasonalContractors().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My self-employed business":
                        po.sourceOfIncome = "<b>"+this.isSelfEmployed().title+"</b> (one of the following + bank statement)";
                        po.plainTitle = this.isSelfEmployed().title;
                        po.content = this.isSelfEmployed().content;
                        po.subContent1 = this.isSelfEmployed().content.slice(0,3);
                        po.subContent2 = this.isSelfEmployed().content.slice(3);
                        po.needModal = true;
                        po.isSelfEmployed = true;
                        break;
                    case "My pension":
                        po.sourceOfIncome = "<b>"+this.isCentrelinkIncomePension().title+"</b> (one of the following)";
                        po.plainTitle = this.isCentrelinkIncomePension().title;
                        po.content = this.isCentrelinkIncomePension().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My workers compensation":
                        po.sourceOfIncome = "<b>"+this.isWorkersCompensation().title+"</b> (one of the following)";
                        po.plainTitle = this.isWorkersCompensation().title;
                        po.content = this.isWorkersCompensation().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My rental property":
                        po.sourceOfIncome = "<b>"+this.isRentalIncome().title+"</b> (one of the following)";
                        po.plainTitle = this.isRentalIncome().title;
                        po.content = this.isRentalIncome().content.content;
                        po.needModal = false;
                        po.isSelfEmployed = false;
                        break;
                    case "My child support":
                        po.sourceOfIncome = "<b>"+this.isChildSupportIncome().title+"</b> (both of following)";
                        po.plainTitle = this.isChildSupportIncome().title;
                        po.content = this.isChildSupportIncome().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    case "My other source of income":
                        po.sourceOfIncome = "<b>"+this.isCasualTemporarySeasonalContractors().title+"</b> (one of the following)";
                        po.plainTitle = this.isCasualTemporarySeasonalContractors().title;
                        po.content = this.isCasualTemporarySeasonalContractors().content;
                        po.needModal = true;
                        po.isSelfEmployed = false;
                        break;
                    default:
                        break;
                }
                listPOITemp.push(po);
            }
            applicant.listOfPOI = this.checkListOfPOIDuplicate(listPOITemp);
        }

    }

    checkListOfPOIDuplicate(arrPOI) {
        // initialize a Set object
        const uniqueValuesSet = new Set();

        const filteredArr = arrPOI.filter((obj) => {
            // check if name property value is already in the set
            const isPresentInSet = uniqueValuesSet.has(obj.plainTitle);

            // add name property value to Set
            uniqueValuesSet.add(obj.plainTitle);

            // return the negated value of
            // isPresentInSet variable
            return !isPresentInSet;
        });

        return filteredArr;
    }

    handleShowModal(event) {
        let titleheader = event.currentTarget.dataset.titleheader;
        let soi = event.currentTarget.dataset.plaintitle;
        let content = this.poiList.find(elem1 => elem1.title === soi).content.find(elem2 => elem2.title === titleheader).content;
        this.modalRichTextTitle = titleheader;
        this.modalRichTextContent = content;
        this.showRichTextModal = true;
    }

    closeRichTextModal(event) {
        this.showRichTextModal = false;
    }

    finishToApplications(event) {
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