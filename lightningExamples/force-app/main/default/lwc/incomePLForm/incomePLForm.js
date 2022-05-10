import { LightningElement,track } from 'lwc';
import saveIncomes from '@salesforce/apex/incomeCreation.createIncomes'
import retIncomes from '@salesforce/apex/incomeCreation.retrieveIncomes'
import { updateRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';

export default class IncomePLForm extends NavigationMixin(LightningElement) {
  @track employmentType;
  @track incomeAmount;
  @track incomeId;
  @track applicantId;
  @track applicationId;
  @track incomeIdStorage;
  @track keyIndex = 0;
  @track itemList;
  @track incomeIdArray = [];
  @track incomeArray =[];
  @track incomeResult = [];
  @track finalIncomeValues = [
  ];

@track incomeDBValues =[];
@track isIncomeLength = false;
  @track incomeIds=[];
  itemList = [
      {id : 0}
  ];
 @track message;
  connectedCallback(){
      this.applicationId = localStorage.getItem('application_id');
      this.applicantId = localStorage.getItem('applicant_id');
      this.incomeIdStorage = localStorage.getItem('income_id');
      console.log('rrrs '+this.incomeIdStorage);
    this.incomeIds = localStorage.getItem('income_ids');
    if(this.incomeIds !== null){
        this.incomeDBValues = this.incomeIds.split(',');
        
        if(this.incomeDBValues.length > 0){
            this.isIncomeLength = true;
          }else{
            this.isIncomeLength = false;
          }
          retIncomes({incomeids:this.incomeDBValues}).then(result=>{
            console.log('Result Income Ids '+JSON.stringify(result));
           
            result.forEach(item=>{
                this.finalIncomeValues.push({
                    Employment_Type__c:item.Employment_Type__c,
                    Applicant__c:item.Applicant__c,
                    Total_Income_Amount__c:item.Total_Income_Amount__c,
                    Id:item.Id,
                })
    
            })
        }).catch(error=>{
            console.log('Error '+error.body.message);
        }); 
    }
  
      
  }

  addIncome(){ 
    let currentLength = this.incomeArray.length;
    console.log('Length 1 '+this.incomeArray.length);     
         this.keyIndex + 1;

         if(this.finalIncomeValues.length > 0){
            this.finalIncomeValues.push({
                Employment_Type__c:'',
                Applicant__c:this.applicantId,
                Total_Income_Amount__c:'',
                Id:'',
            })
        }else{
            this.incomeArray.push({          
                Applicant__c : this.applicantId,
                Employment_Type__c :'',
                Total_Income_Amount__c : '',
            });
        }


       
  }

  changeHandler(event){
      console.log('Change Handler ');
      if(event.target.name === 'incomeId'){
        this.incomeArray[event.target.accessKey].Id = event.target.value;
        console.log('Income ID'+ this.incomeArray[event.target.accessKey].Applicant__c);

      }else
      if(event.target.name === 'applicantValue'){
        this.incomeArray[event.target.accessKey].Applicant__c = event.target.value;
        console.log('EmploymentType value '+ this.incomeArray[event.target.accessKey].Applicant__c);
     }else
      if(event.target.name === 'employmentType'){
         this.incomeArray[event.target.accessKey].Employment_Type__c = event.target.value;
         console.log('EmploymentType value '+ this.incomeArray[event.target.accessKey].Employment_Type__c);
      }else if(event.target.name === 'totalIncome'){
        this.incomeArray[event.target.accessKey].Total_Income_Amount__c = event.target.value;
        console.log('total income value '+ this.incomeArray[event.target.accessKey].Total_Income_Amount__c);

    }
  }


  handleSuccess(event){
      this.incomeId = event.detail.id;
      this.incomeIdArray.push(this.incomeId);
      console.log('IncomeIDArray '+JSON.stringify(this.incomeIdArray));
      console.log('IncomeID '+this.incomeId);
      localStorage.setItem('income_id',this.incomeId);
      localStorage.setItem('income_ids',this.incomeIdArray);
      localStorage.setItem('application_id', this.applicationId);
      localStorage.setItem('applicant_id',this.applicantId);

      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/applicationdetails'
        },
    });

  }

  submitIncome(){
   
    
    if(this.finalIncomeValues.length > 0){
        console.log('FinalIncomeValueLength '+this.finalIncomeValues.length);
        
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            element.submit();      
        });   
        
       
    }else{


        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
           
        });
        console.log('isVal '+isVal);
       if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();      
            });
        } 
    
        
    }
  /* console.log(JSON.stringify(this.incomeArray));
    saveIncomes({incomeList:this.incomeArray}).then(result=>{
        console.log('Result '+JSON.stringify(result));
        
        
        this.incomeArray.forEach(function(item){
           console.log('EmploymentType '+item.Employment_Type__c);
           
        })
        
    }).catch(error=>{
        console.log('Error '+error.body.message);
    }); */

  } 

  deleteRow(event){
      if(this.incomeArray.length >=1){
          this.incomeArray.splice(event.target.accessKey,1);
          this.keyIndex - 1;
      }

      if(this.finalIncomeValues.length >= 1){
        this.finalIncomeValues.splice(event.target.accessKey,1);
        this.keyIndex - 1;
      }
  }

  goBack(){
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/expensedetails'
        },
    });
}
}