/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013
* @description Class for Exclusion Logic
* @param 
*/

public without sharing class ExclusionLogicController {
   
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to perform lead exclusion logic
    * @param 
    */
    public List<Opportunity> OpportunityExclusion(List<Opportunity> leadExclusionList){
            
           DateTime dateToday = DateTime.newInstanceGmt(System.now().date(), System.now().time()).dateGMT(); 

           // Perform Billing Filter  
           set<Id>personAccIdSet = new set<Id>();
           
           for(Opportunity oppVar: leadExclusionList){
                personAccIdSet.add(oppVar.AccountId);
           }// End For
                      
           // Instantiate list that will contain billing records that satisifies the exclusion
           List<Billing_Vision_Plus__c> billVisionDnsList = new List<Billing_Vision_Plus__c>();
           List<Billing_Genesis__c> billGenesisDnsList = new List<Billing_Genesis__c>();
           List<Billing_ICBS__c> billICBSDnsList = new List<Billing_ICBS__c>();
           
           List<Billing_Genesis__c> billGenDelinquencyList = new List<Billing_Genesis__c>();
           
           List<Billing_Vision_Plus__c> billVisionBCList = new List<Billing_Vision_Plus__c>();
           //List<Billing_Genesis__c> billGenBCList = new List<Billing_Genesis__c>();
           List<Billing_ICBS__c> billIcbsBCList = new List<Billing_ICBS__c>();
                       
            // Query Billing Vision Plus records that satisfies the DNS Exclusion Condition
            billVisionDnsList=[Select Id, Account__c, CreatedDate from Billing_Vision_Plus__c where Account__c In :personAccIdSet 
                                                             and ( CLV_DNS_flag__c='Y' or CLV_DNS_flag__c='y' 
                                                             or DNS_flag__c ='Y'or DNS_flag__c='y')];
                                                             
            // Query Billing Vision Plus records that satisfies the DNS Exclusion Condition
            billGenesisDnsList=[Select Id, Account__c, CreatedDate from Billing_Genesis__c where Account__c In :personAccIdSet 
                                                             and (DNS_flag__c ='Y' or DNS_flag__c='y')];
                                                             
            // Query Billing Vision Plus records that satisfies the DNS Exclusion Condition
            billICBSDnsList=[Select Id, Account__c, CreatedDate from Billing_ICBS__c where Account__c In :personAccIdSet 
                                                             and (DNS_flag__c ='Y' or DNS_flag__c='y')];                                                 
                                                                                                          
            // Query Billing Genesis records that satisfies the Delinquency Exclusion Condition
            billGenDelinquencyList=[Select Id, Account__c, CreatedDate from Billing_Genesis__c where Account__c In : personAccIdSet 
                                                            and Delinquency_arrers_category__c In ('A','a','B','b','C','c','D','d','E','e')];
                                                 
            // Query Billing Vision Plus records that satisfies the Block Code Exclusion
            billVisionBCList=[Select Id, Account__c, CreatedDate from Billing_Vision_Plus__c where Account__c In :personAccIdSet 
                                                             and (Block_code_1__c IN ('A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'F', 'f', 'I', 'i','K', 'k', 'L', 'l', 'M', 'm', 'R', 'r') 
                                                             or Block_code_2__c IN ('A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'F', 'f', 'I', 'i', 'K', 'k', 'L', 'l', 'M', 'm', 'R', 'r')
                                                             or Suspect_Address__c ='Y' or Suspect_Address__c ='y' // Adjusted from not equal to equal
                                                             or Cycle_Due__c > 2)];
            
            // Query Billing Genesis records that satisfies the Block Code Exclusion
            //billGenBCList=[Select Id, Account__c, CreatedDate from Billing_Genesis__c where Account__c In :personAccIdSet 
            //                                           and CreatedDate >= : dateToday-1];
                                                       //and Account_Status_Risk_Category__c Not In ('A','a','P','p','S','s')];
            
            // Query Billing Icbs records that satisfies the Block Code Exclusion
            billIcbsBCList=[Select Id, Account__c, CreatedDate from Billing_ICBS__c where Account__c In :personAccIdSet 
                                                     and (
                                                     //Lavanya Kavuri, 18 March 2015 Commented the below line as a part of Jira: 1188
                                                     //Times_past_due_CY1__c > 0 
                                                     Times_past_due_CY2__c > 3
                                                     or Times_past_due_CY3__c > 2
                                                     or Times_past_due_CY4__c > 0
                                                     or Times_past_due_CY5__c > 0
                                                     or Times_past_due_CY6__c > 0
                                                     /*or Account_Status_Risk_Code__c != null
                                                     or Account_Status_Risk_Code__c In ('A','a')*/
                                                     or Charge_Off_Soldflag__c != null
                                                     or Deceased_Indicator__c != null
                                                     or Charge_Off_S85_Flag__c In ('Y','y'))];
           
            set<String> billVisionDnsSet = new set<String>();
            set<String> billGenDelinquencySet = new set<String>();
            set<String> billBCSet = new set<String>();

            // Put Dns, Delinquency and Block Code Billing record Ids in a set
            
            for(Billing_Vision_Plus__c billVisionVar: billVisionDnsList){
                //if(DateTime.newInstanceGmt(billVisionVar.createddate.date(), billVisionVar.createddate.time())>=dateToday) {
                    billVisionDnsSet.add(billVisionVar.Account__c);
                //}
            }// End For
            
            for(Billing_Genesis__c billGenesisVar: billGenesisDnsList){
                //if(DateTime.newInstanceGmt(billGenesisVar.createddate.date(), billGenesisVar.createddate.time())>=dateToday) {
                    billVisionDnsSet.add(billGenesisVar.Account__c);
                //}
            }// End For
            
            for(Billing_ICBS__c billICBSVar: billICBSDnsList){
                //if(DateTime.newInstanceGmt(billICBSVar.createddate.date(), billICBSVar.createddate.time())>=dateToday) {
                    billVisionDnsSet.add(billICBSVar.Account__c);
                //}
            }// End For
            
            for(Billing_Genesis__c billGenVar: billGenDelinquencyList){
                //if(DateTime.newInstanceGmt(billGenVar.createddate.date(), billGenVar.createddate.time())>=dateToday) {
                    billGenDelinquencySet.add(billGenVar.Account__c);
                //}
            }// End For
            
            for(Billing_Vision_Plus__c billIcbsVar: billVisionBCList){
                //if(DateTime.newInstanceGmt(billIcbsVar.createddate.date(), billIcbsVar.createddate.time())>=dateToday) {
                    billBCSet.add(billIcbsVar.Account__c);
                //}
            }// End For
            
            for(Billing_ICBS__c billIcbsVar: billIcbsBCList){
                //if(DateTime.newInstanceGmt(billIcbsVar.createddate.date(), billIcbsVar.createddate.time())>=dateToday) {
                    billBCSet.add(billIcbsVar.Account__c);
                //}
            }// End For                                               
            
            // Instantiate list for Leads(Opportunities) that is excluded and not excluded
            List<Opportunity> filteredLeadList = new List<Opportunity>();
            List<Opportunity> excludedLeadList = new List<Opportunity>();
            
            // Loop inside the list of opportunties valid for exclusion checking
            // If excluded identify reason and specify exclusion date equal to today's date
            for(Opportunity oppVar: leadExclusionList){
                
                // Instantiate string variables for reason 
                // assignment and Boolean flag for exclusion condition
                Boolean isExcluded = false;
                string pcStr = '';
                string moStr = '';
                string coStr = '';
                string dnsStr = '';
                string deliStr = '';
                string bcStr = '';
                string exCode   = '';
                // Determine Exclusion Reason
                
                //Check if lead has expired
                if(oppVar.CloseDate < system.today()){
                    exCode = ',Lead expired on ' + String.ValueOf(system.today());
                    isExcluded = true;
                }// End If
                
                // Check for Postcode Exclusion
                if(oppVar.PostCode_Exclusion__c == true){
                    pcStr = ',Postcode Exclusion';
                    isExcluded = true;
                }// End If
                
                // Check for Mail Code Exclusion
                if(oppVar.Mail_Code__c == 'MO'){
                    moStr = ',Mail Only Lead';
                    isExcluded = true;
                }// End If
                
                // Check for Control Group Exclusion
                if(oppVar.Mail_Code__c == 'CO'){
                    coStr = ',Control Group';
                    isExcluded = true;
                }// End If
                
                // Check for DNS Exclusion             
                if(billVisionDnsSet.contains(oppVar.AccountId)==true){
                    dnsStr = ',DNS';
                    isExcluded = true;
                }// End If
                
                // Check for Delinquency Exclusion  
                if(billGenDelinquencySet.contains(oppVar.AccountId)==true){
                    deliStr = ',Delinquency';
                    isExcluded = true;
                }// End If
                
                // Check for Block Code Exclusion
                if(billBCSet.contains(oppVar.AccountId)==true){
                    bcStr = ',Block Codes';
                    isExcluded = true;
                }// End If
                
                if(isExcluded){
                    oppVar.Exclusion_Reason__c = (pcStr + moStr + coStr + dnsStr + deliStr + bcStr+exCode).removeStart(',');
                    system.debug('Exclusion Reason Value:' + oppVar.Exclusion_Reason__c);
                    oppVar.Excluded_Date__c = system.today();
                    excludedLeadList.add(oppVar);        
                }else{
                    filteredLeadList.add(oppVar);
                }// End Else
            }// End For
            
            if(excludedLeadList.size()!=0){
                update excludedLeadList;
            }// End if
            
            return filteredLeadList;
    }// End billingExclusion Method
}// End ExclusionLogicController Class