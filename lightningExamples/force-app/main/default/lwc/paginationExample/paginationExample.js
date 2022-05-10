import { LightningElement, wire,track} from 'lwc';
import getAccounts from '@salesforce/apex/getRecordDataController.getAccounts';
const columns =[
    {label:'Account Name',fieldName:'Name'},
    { label: 'Id', fieldName: 'Id'}
];
export default class GetDataDisplayData extends LightningElement {
     //Method 2
     
     @track recordSize = 50;
     @track items =[];
     @track page = 1;
     @track totalPage = 0;
     @track totalRecountCount = 0;
     @track data = [];
     @track startingRecord = 1;
     @track endingRecord = 0;
     @track columns;
     
     @track accountList;
     @wire (getAccounts) wiredAccounts({data,error}){
          if (data) {
            this.items = data;
            this.totalRecountCount = data.length; //here it is 23
            this.totalPage = Math.ceil(this.totalRecountCount / this.recordSize); //here it is 5
            
            //initial data to be displayed ----------->
            //slice will take 0th element and ends with 5, but it doesn't include 5th element
            //so 0 to 4th rows will be displayed in the table
            this.data = this.items.slice(0,this.recordSize); 
            console.log('Tot rec per page '+this.data);
            this.endingRecord = this.pageSize;
            
            this.columns = columns;

            this.error = undefined;
          } else if (error) {
          console.log(error);
          }
     }

     handlePreviousButton(event){
        /**console.log('Previous');
         console.log(this.accountList.length);
         console.log(Math.ceil(this.accountList.length / this.recordSize));
         this.totalPage = Math.ceil(this.accountList.length / this.recordSize);
         console.log(this.items);
         this.visibleRecords = this.items.slice(0,this.recordSize);
         console.log('Visible '+this.visible);
         
         if(this.page > 1){
             this.page = this.page - 1;
             console.log(this.page);

         }  */ 
     }

     handleNextButton(event){
         console.log('Next');
        
     }
}