import { LightningElement,track,api,wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import TOTAL_EXPENSE from '@salesforce/schema/Expenses__c.Total_Expense__c'
import APPLICANT from '@salesforce/schema/Expenses__c.Applicant__c'
import EXPENSE_OBJECT from '@salesforce/schema/Expenses__c'
import { NavigationMixin } from 'lightning/navigation';


export default class ExpensesPLForm extends NavigationMixin(LightningElement) {

    @track totalExpense;
    @track expenseId;
    @track applicantId;
    @track totalExpenseValue;
    @track applicationId;
    
    handleTotalExpense(event){
        this.totalExpense = event.target.value;
    }

    renderedCallback(){
        console.log('applicant expense value rendered '+localStorage.getItem('applicantId'));
        if(localStorage.getItem('applicantId') !== null){
            console.log('applicant expense value '+localStorage.getItem('applicantId'));


            this.applicantId = localStorage.getItem('applicantId');
        }
    }
    connectedCallback(){

        this.applicationId = localStorage.getItem('application_id');
       // if(localStorage.getItem('applicantId') !== undefined ||
           // localStorage.getItem('applicantId') !== 'undefined') {
            console.log('applicant expense value '+localStorage.getItem('applicantId'));
            if(localStorage.getItem('applicantId') !== null){
                console.log('applicant expense value '+localStorage.getItem('applicantId'));


                this.applicantId = localStorage.getItem('applicantId');
            }
 //this.totalExpenseValue = localStorage.getItem('total_expense');
        if(localStorage.getItem('expense_id') !== undefined ||
            localStorage.getItem('expense_id') !== 'undefined') {
                console.log(localStorage.getItem('expense_id'));
               console.log(111);
                this.expenseId = localStorage.getItem('expense_id');
            } 
    }

    submitExpense(){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleSuccess(event){
        this.expenseId = event.detail.id;
        console.log('Expense Id '+this.expenseId);
        localStorage.setItem('expense_id',this.expenseId);
        console.log('Applicant Id'+this.applicantId);
        localStorage.setItem('applicant_id',this.applicantId);
        localStorage.setItem('application_id',this.applicationId);

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/incomedetails'
            },
        });
       
    }

    handleSubmit(event){  
      localStorage.setItem('total_expense',this.totalExpense);
    }
    
    goBack(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/personaldetails'
            },
        });
    }
}