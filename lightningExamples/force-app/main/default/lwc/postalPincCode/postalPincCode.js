import { LightningElement,api,wire,track } from 'lwc';
import postalPinCode from '@salesforce/apex/postalPinCodeLightning.Pincode'

export default class PostalPincCode extends LightningElement {

 @track branchName;
 @track result;
 @track postalDetailsResult = [];
 @track postalDetails = [];
 
 handleBranchName(event){
   this.branchName = event.target.value;
 }
 
 getBranchDetails(){
     console.log(1)
     console.log('Branch Name '+this.branchName)
     this.postalDetails = [];
     this.postalDetailsResult = [];
      postalPinCode({postOfficeBranchName:this.branchName}).then(response=>{
          this.result = response;
          response.forEach(element=>{
              this.postalDetailsResult.push({
                  Message:element.Message,
                  Status:element.Status,

              })
              console.log('Message '+element.Message)
              element.PostOffice.forEach(element=>{
                  console.log('Name '+element.Name)
                  this.postalDetails.push({
                    Name :element.Name,
                    Description:element.Description,
                    BranchType:element.BranchType,
                    Pincode:element.Pincode,
                    DeliveryStatus:element.DeliveryStatus,
                    Circle:element.Circle,
                    District:element.District,
                    Division:element.Division,
                    Region:element.Region,
                    State:element.State,
                    Country:element.Country,
                  })
              })
          })
      }).catch(error=>{
          console.log('Error '+JSON.stringify(error))
      })
  }

}