import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VerifyDateOfBirth extends LightningElement {

    @api modalHeading;
    @api applicationId;
    day;
    month;
    year;

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
            { label: "Jan (01)", value: "01" },
            { label: "Feb (02)", value: "02" },
            { label: "Mar (03)", value: "03" },
            { label: "Apr (04)", value: "04" },
            { label: "May (05)", value: "05" },
            { label: "Jun (06)", value: "06" },
            { label: "Jul (07)", value: "07" },
            { label: "Aug (08)", value: "08" },
            { label: "Sep (09)", value: "09" },
            { label: "Oct (10)", value: "10" },
            { label: "Nov (11)", value: "11" },
            { label: "Dec (12)", value: "12" },
        ];
    }

    handleDOBChange(event) {

        let fieldName = event.target.name;
        let fieldValue = event.target.value;
        if (fieldName === 'dobday') {
            this.day = fieldValue;
        } else if (fieldName === 'dobmonth') {
            this.month = fieldValue;
        } else if (fieldName === 'dobyear') {
            this.year = fieldValue;
        }
    }


    handleCloseModal() {
        this.dispatchEvent(new CustomEvent('modalclose'));
    }

    handleVerifyDOB() {
        //Capture DOB and pass it back to the calling component
        if (this.day === undefined || this.month === undefined || this.year === undefined) {
            this.showToast('Error', 'Please enter a valid date of birth.', 'error', 'pester');
            return;
        }
        let userDateOfBirth = this.day + '/' + this.month + '/' + this.year;
        this.dispatchEvent(new CustomEvent('verifydob', {
            detail: {
                userDateOfBirth: userDateOfBirth
            }
        }));



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


}