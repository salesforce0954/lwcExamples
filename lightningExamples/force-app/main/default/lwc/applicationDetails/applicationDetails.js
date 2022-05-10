import { LightningElement,track } from 'lwc';
import getApplicationDetails from '@salesforce/apex/PL_ApplicationDetails.getApplicationInfo'
import getApplicantDetails from '@salesforce/apex/PL_ApplicationDetails.getApplicantInfo'
import getIncomeDetails from '@salesforce/apex/PL_ApplicationDetails.getIncomeInfo'

import sendApplicationInformation from '@salesforce/apex/PL_ApplicationDetails.sendPLAppsInformation'
import sendPLAppsApplicantInformation from '@salesforce/apex/PL_ApplicationDetails.sendPLAppsApplicantInformation'
import sendEmailToApplicant from '@salesforce/apex/PL_ApplicationDetails.sendEmailToApplicant'
import handleErrorLogs from '@salesforce/apex/PL_ApplicationDetails.handleErrorLogs'
import updateExternalID from '@salesforce/apex/PL_ApplicationDetails.updateExternalID'

import { NavigationMixin } from 'lightning/navigation';
export default class ApplicationDetails extends NavigationMixin(LightningElement) {

    @track applicationId;
    @track applicantId;
    @track incomeId;
    @track expenseId;
    @track applicationDetails={}
    @track applicantList = []
    @track incomeIds;
    @track incomeList = []
    @track applicantArray = []
    @track isApplicantLength = false;
    @track applicantValues = []
    @track applicationOrg2Id;

    @track incomeArray = []
       connectedCallback(){

           this.applicationId = localStorage.getItem('application_id');
          this.applicantId = localStorage.getItem('applicant_ids');
          //if(this.applicantArray.length > 0){
          this.applicantArray = this.applicantId.split(',');
          console.log('Applicant array values '+this.applicantArray);
         //}
          if(this.applicantArray.length > 0){
            this.isApplicantLength = true;
            console.log(1);
          }else{
              this.isApplicantLength = false;
              console.log(2);
          }

           this.incomeId = localStorage.getItem('income_id');
           this.expenseId = localStorage.getItem('expense_id');
           this.incomeIds = localStorage.getItem('income_ids');
           this.incomeList = this.incomeIds.split(',');

           console.log('Application Id '+this.incomeList);

          
           
           getApplicationDetails({appId:this.applicationId}).then(result=>{
            console.log('Result => '+JSON.stringify(result));
            console.log('Applicant Type '+result.Applicant_Type__c);
           this.applicationDetails ={
            Applicant_Type__c : result.Applicant_Type__c,
            is_Applicant_Eligible__c : result.is_Applicant_Eligible__c,
            Id : result.Id,
        }
        console.log('Application Type after '+this.applicationDetails.Applicant_Type__c);
    }).catch(error=>{
        console.log('Error '+JSON.stringify(error));
    })

    if(this.applicantArray.length > 0){
        console.log(3);
        getApplicantDetails({applicantList:this.applicantArray}).then(response=>{
            console.log(4);
            console.log('Applicant result '+JSON.stringify(response))
            response.forEach(element=>{
              this.applicantValues.push({
                  Id:element.Id,
                  Application__c:element.Application__c,
                  First_Name__c:element.First_Name__c,
                  Last_Name__c:element.Last_Name__c,
                  isPrimayApplicant__c:element.isPrimayApplicant__c,
                  Phone__c:element.Phone__c,
                  State__c:element.State__c,
                  isDrivingLicense__c:element.isDrivingLicense__c,
                  Address__c:element.Address__c,
              })
            })
        }).catch(error=>{
            console.log('Error '+JSON.stringify(error))
        })
    }
    

    getIncomeDetails({incomeList:this.incomeList}).then(result=>{
        console.log('HIIIIIIIIIIIIIII');
        console.log('Income Ids '+JSON.stringify(result));

        result.forEach(element=>{
            this.incomeArray.push({
                Id:element.Id,
                Applicant__c:element.Applicant__c,
                Employment_Type__c:element.Employment_Type__c,
                Total_Income_Amount__c:element.Total_Income_Amount__c,
                name:element.Name,
            })
        })
    }).catch(error=>{
        console.log('Error '+JSON.stringify(error))
    })
   


           

       }

       submitApplication(){
        //sending Application values to the external organization
        sendApplicationInformation({applicantType:this.applicationDetails.Applicant_Type__c,isApplicantEligible:this.applicationDetails.is_Applicant_Eligible__c}).then(response=>{
            console.log('Application Details from Org1 '+response)
            this.applicationOrg2Id = response;
            const applicationId = this.applicationOrg2Id.slice(1,-1);

     //checking if application id is not null
      if(applicationId !== null){
          console.log('Applicant information '+this.applicantValues[0].First_Name__c);
          console.log('Application Id '+applicationId);
           //update external id of application org2 object into application field
          updateExternalID({applicationId:this.applicationId,externalId:applicationId}).then(response=>{
              console.log('External Id updated '+response)
          }).catch(error=>{
               console.log('Error '+error.body.message)
          })
        //Sending Joint Applicant values to the external organization
        if(this.applicantValues.length > 1){
            console.log('Joint Applicant to Org2')
            this.applicantValues.forEach(element=>{
                sendPLAppsApplicantInformation({applicationDetails:applicationId,firstName:element.First_Name__c,lastName:element.Last_Name__c}).then(result=>{
                    console.log('Applicant Details from Org1 '+result)
                }).catch(error=>{
                    handleErrorLogs({description:error.body.message,id:this.applicationId}).then(response=>{
                        console.log('Response of Integration to Third party 1 '+response);
                        console.log('Error of Org1 '+JSON.stringify(error))
                    })
                   //console.log('Error '+JSON.stringify(error))
                })
            })
           
        }else{
            //sending single Applicant values to the external organization
            console.log('Single Applicant to Org2')
            sendPLAppsApplicantInformation({applicationDetails:applicationId,firstName:this.applicantValues[0].First_Name__c,lastName:this.applicantValues[0].Last_Name__c}).then(result=>{
                console.log('Applicant Details from Org1 '+result)
            }).catch(error=>{
                handleErrorLogs({description:error.body.message,id:this.applicationId}).then(response=>{
                    console.log('Response of Integration to Third party 1 '+response);
                    console.log('Error of Org1 '+JSON.stringify(error))
                })
               //console.log('Error '+JSON.stringify(error))
            })

          }
        }
           //send email to the applicant email id after full submission
            sendEmailToApplicant({applicantIdList:this.applicantArray}).then(response=>{
             console.log('Email Sent '+response);
            }).catch(error=>{
                handleErrorLogs({description:error.body.message,id:this.applicationId}).then(response=>{
                    console.log('Response of Integration to Third party 1 '+response);
                    console.log('Error of Org1 '+JSON.stringify(error))
                })       
                console.log('Error '+JSON.stringify(error))
            })
        }).catch(error=>{
            console.log('Error '+JSON.stringify(error))
            
        })
        
        
       }

    previous(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://suneel54-developer-edition.ap5.force.com/hdfc/s/incomedetails'
            },
        });
    }
}