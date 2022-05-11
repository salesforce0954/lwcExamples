/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Class to handle BranchSetup Page
*/

public with sharing class BranchSetupController {
    // Variable Declaration
    public Id districtId{get; set;}
    public List<BranchWrapper>branchWrapperList {get; set;} 
    public Boolean selectAllBranch {get; set;}   
    //public Boolean isSelectAll{get; set;}
    public Id recTypeBL = getBranchType('Branch Leads');
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description Branch Wrapper Class, contains boolean IsSelected and Branch record 
    * @param 
    */
    public class BranchWrapper{
        Public Boolean IsSelected{get; set;}
        Public Branch__c branchVar{get; set;}
    }// End BranchWrapper Class
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description Constractor Method
    * @param 
    */
    public BranchSetupController(){
        // Variable Declaration
        branchWrapperList = new List<BranchWrapper>();
        branchWrapperList.clear();
        Set<Id> BranchIDs = new Set<Id>();
        selectAllBranch = false;
        
        // Query Branch Assignments for Current User
        List<Branch_Assignment__c> branchList = new List<Branch_Assignment__c>([Select Branch__c from 
                                                                                Branch_Assignment__c WHERE 
                                                                                User__c =: UserInfo.getUserId() 
                                                                                and RecordTypeId = :recTypeBL 
                                                                                ORDER BY Branch__c]);
        
        // Put Branch Assignment
        for(Branch_Assignment__c BA: branchList){
            BranchIDs.add(BA.Branch__c);
        }// End For
        
        // Query branch names based on User branch Assignments
        List<Branch__c> branchDisplay = [Select Id,Name from Branch__c WHERE Id in: BranchIDs ORDER BY Name];
        
        //isSelectAll = true;
        
        for(Branch__c branchVar:branchDisplay){
            BranchWrapper bwVar = new BranchWrapper();
            bwVar.IsSelected = true;
            bwVar.branchVar = branchVar;
            //if(bwVar.IsSelected == false || bwVar.IsSelected == null){    
            //    isSelectAll = false;
            //}
            branchWrapperList.add(bwVar);
        }// End For  
        
        // Populate Select All Value
        //setupCheckAll();
    }// End Constractor Method
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description 
    * @param 
    */
    public void setBranchList(){
            
        // Query Branch for currently selected district
        List<Branch__c> branchList = [Select Id, Name, District__c from Branch__c where District__c = :districtId ORDER BY Name];
        
        // Put Branch Assignment record ids in a map
        Set<Id>branchIdSet = new Set<Id>();
        Map<Id,Branch_Assignment__c> baMap = new Map<Id,Branch_Assignment__c>();
        
        for(Branch__c branchVar: branchList){
            branchIdSet.add(branchVar.Id);
        }// End If

        List<Branch_Assignment__c> baList = [Select Id, Branch__c from Branch_Assignment__c where Branch__c In :branchIdSet and User__c = :Userinfo.getUserId() and RecordTypeId = :recTypeBL ORDER BY Branch__c];
        
        for(Branch_Assignment__c baVar: baList){
            baMap.put(baVar.Branch__c,baVar);
        }// End If
        
        branchWrapperList = new List<BranchWrapper>();
        
        //isSelectAll = true;
        
        for(Branch__c branchVar:branchList){
            BranchWrapper bwVar = new BranchWrapper();
            
            if(baMap.get(branchVar.Id)!=null){
                bwVar.IsSelected = true;
            }// End If
            
            bwVar.branchVar = branchVar;
            //if(bwVar.IsSelected == false || bwVar.IsSelected == null){    
            //    isSelectAll = false;
            //}
            branchWrapperList.add(bwVar);
        }// End For
        
        // Set select all check box value
        //setupCheckAll();
    }// End setBranchList Method
    
            
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description 
    * @param 
    */
    public List<SelectOption> getDistricts() {

        
        // Variable Declaration
        List<SelectOption> districtOptions = new List<SelectOption>();
        List<District__c> districtList = [Select Name,Id from District__c ORDER BY NAME ASC];
        
        districtOptions.add(new SelectOption('',''));       
                
        // Put district values in an option list
        for(District__c districtVar: districtList){
            districtOptions.add(new SelectOption(districtVar.Id,districtVar.Name));     
        }// End For
        
        return districtOptions;
    }// End getDistrict Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description Method to perform branch Assignment save
    * @param 
    */
    public PageReference saveBranchAssignment(){
        // Variable Declaration
        List<Branch__c> branchList = new List<Branch__c> ();
        Set<Id>branchIdSet = new Set<Id>();
        List<Branch_Assignment__c> baToDeleteList = new List<Branch_Assignment__c>();
            
        // Select all branches if selectAllBranch is true
        if(selectAllBranch == true){
            List<Branch__c>allbranchList = [Select Id from Branch__c];  
            for(Branch__c bVar:allBranchList){
                branchIdSet.add(bVar.Id);
            }// End For
            // Call Save branch method to perform branch assignment delete(Unselected Branch) and create(Selected Branch)
            saveBranch(baToDeleteList,branchIdSet);
        }else{  
            
            for(BranchWrapper bwVar: branchWrapperList){
                // Get Branches that are selected
                if(bwVar.IsSelected == true){
                    // Get selected branch record then put in a list
                    branchList.add(bwVar.branchVar);
                    // Get branch record Id then put in a set
                    branchIdSet.add(bwVar.branchVar.Id);
                }// End If
            }// End For
                
            // Condition for no district selected but there are existing branch assignments
            if(districtId == null && branchWrapperList != null){
                // Query branch assignments where
                // User is equal to current user
                // Branch is not selected
                // RecordType is Branch Leads
                baToDeleteList = new List<Branch_Assignment__c>([Select Id from Branch_Assignment__c where 
                                                                 Branch__c Not IN :branchIdSet 
                                                                 and User__c = :Userinfo.getUserId() 
                                                                 and RecordTypeId = :recTypeBL]);
                // Call Save branch method to perform branch assignment delete(Unselected Branch) and create(Selected Branch)
                saveBranch(baToDeleteList,branchIdSet);
            }// End If
            
            // Condition for distirct selected   
            if(districtId != null){
                // Query branch assignments where
                // User is equal to current user
                // Branch is not selected
                // District is selected
                // Recordtype is Branch Leads
                baToDeleteList = new List<Branch_Assignment__c>([Select Id from Branch_Assignment__c where 
                                                                 Branch__c Not IN :branchIdSet 
                                                                 and User__c = :Userinfo.getUserId() 
                                                                 and Branch__r.District__c = :districtId 
                                                                 and RecordTypeId = :recTypeBL]);
                // Call Save branch method to perform branch assignment delete(Unselected Branch) and create(Selected Branch)
                saveBranch(baToDeleteList, branchIdSet);
            }// End If
        }// End If        
       return null;
    }//End saveBranchAssignment Method
    
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas/GEHC
    * @date Original: 13 Feb 2013
    * @description saveBranch method added, saveBranchAssignment edited, contractor added
    * @param 
    */
    public void saveBranch(List<Branch_Assignment__c> baDeleteList, Set<Id> branchIdSet){
            // Remove all Branch Assignment records that are not 
            // selected by the current PFR for the current district
            if(baDeleteList.size()>0){
                Delete baDeleteList;
            }// End If
            
            //hard delete all recently deleted branches
            if(baDeleteList.size()>0) {
                Database.emptyRecycleBin(baDeleteList);
            }
            
            // Determine Branch Assignment records that is already created for the selected branches
            List<Branch_Assignment__c>selectedBranchList = [Select Id, Branch__c from Branch_Assignment__c where Branch__c IN :branchIdSet and User__c = :Userinfo.getUserId() and RecordTypeId = :recTypeBL];
            
            // Remove branch ids if a corresponding branch assignment record is already created for it
            for(Branch_Assignment__c baVar:selectedBranchList){
                branchIdSet.remove(baVar.Branch__c);
            }// End For
            
            // Instantiate empty Branch Assignment List to hold new Branch Assignment records
            List<Branch_Assignment__c> baCreateList = new List<Branch_Assignment__c>();
            
            for(Id idVar:branchIdSet){
                Branch_Assignment__c baVar = new Branch_Assignment__c(User__c = UserInfo.getUserId(), Branch__c = idVar, RecordTypeId = recTypeBL);
                baCreateList.add(baVar);
            }// End For
            
            // Create new branch assignments
            insert baCreateList;
    }// End saveBranch Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 26 Feb 2013
    * @description Method to dynamically retrieve branch assignment recordtype
    * @param 
    */
    public Id getBranchType(string recStr){
         // Use describe to get Call Back recordtype for task object
         Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Branch_Assignment__c;
         Map<String,Schema.RecordTypeInfo> BARecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
         return BARecordTypeInfo.get(recStr).getRecordTypeId();
    }// End getRecordType Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 12 March 2013
    * @description method to perform select all check/uncheck logic
    * @param 
    */
    /*
    public void setupCheckAll(){
        system.debug('Has Set:' + branchWrapperList.size());
        isSelectAll = true;
        if(branchWrapperList.size()>0){
            system.debug('has Size:' + branchWrapperList.size());
            for(BranchWrapper branchWrapVar: branchWrapperList){
                system.debug('Loop Value:' + branchWrapVar.IsSelected);
                if(branchWrapVar.IsSelected == false || branchWrapVar.IsSelected == null){                  
                    isSelectAll = false;
                }// End If
            }// End For
        }else{
            isSelectAll = false;    
        }// End Else
    }// End setupCheckAll Method
    */
}// End BranchSetupController Class