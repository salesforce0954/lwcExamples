import { LightningElement, api } from 'lwc';

export default class LoanApplicationReview extends LightningElement {

    @api primaryApplicantDetailsObj;
    primaryApplicantName;
    jointApplicantName;

    connectedCallback() {

        this.primaryApplicantName = this.primaryApplicantDetailsObj.personalDetails.FirstName + ' ' + this.primaryApplicantDetailsObj.personalDetails.LastName;
        if (this.primaryApplicantDetailsObj.personalDetailsJoint !== undefined && this.primaryApplicantDetailsObj.personalDetailsJoint.FirstName !== null) {
            this.jointApplicantName = this.primaryApplicantDetailsObj.personalDetailsJoint.FirstName + ' ' + this.primaryApplicantDetailsObj.personalDetailsJoint.LastName;
        }

    }

    hanldeApplicationSubmit() {

        this.dispatchEvent(new CustomEvent('submitapplication'));
    }

    handleReviewDetailsPrev(event) {
        this.dispatchEvent(new CustomEvent('reviewdetailsprev', {
            detail: {
                prevStep: 'step-6'
            }
        }));
    }

    get loanDetailsObj() {
        return this.primaryApplicantDetailsObj.loanDetails;
    }

    get personalDetailsObj() {
        return this.primaryApplicantDetailsObj.personalDetails;
    }

    get personalDetailsJointObj() {
        return this.primaryApplicantDetailsObj.personalDetailsJoint;
    }

    get loanDetailsObj() {
        return this.primaryApplicantDetailsObj.loanDetails;
    }

    get employmentDetailsObj() {
        return this.primaryApplicantDetailsObj.employmentDetails;
    }

    get employmentDetailsObj() {
        return this.primaryApplicantDetailsObj.employmentDetails;
    }

    get employmentDetailsJointObj() {
        return this.primaryApplicantDetailsObj.employmentDetailsJoint;
    }

    get expenseDetailsObj() {
        return this.primaryApplicantDetailsObj.expenseDetails;
    }

    get expenseDetailsJointObj() {
        return this.primaryApplicantDetailsObj.expenseDetailsJoint;
    }

    get assetDetailsObj() {
        return this.primaryApplicantDetailsObj.assetDetails;
    }

    get debtDetailsObj() {
        return this.primaryApplicantDetailsObj.debtDetails;
    }

    get isJointApplication() {
        if (this.primaryApplicantDetailsObj.loanDetails !== undefined && this.primaryApplicantDetailsObj.loanDetails.Applicants !== undefined &&
            this.primaryApplicantDetailsObj.loanDetails.Applicants === '2') {
            return true;
        } else {
            return false;
        }
    }



}