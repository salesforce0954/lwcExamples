/*
Author: Michael Lasala Cloud Sherpas
Created Date: 26 Feb 2013 
Description: WorkLocationSetup Page Controller
*/

public with sharing class WorkLocationSetupController {
    //Class Variable Declaration
    public static Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Branch_Assignment__c;
    public static Map<String,Schema.RecordTypeInfo> BranchAssignmentRecordType = cfrSchema.getRecordTypeInfosByName();
    public static Id locationRecordTypeId = BranchAssignmentRecordType.get('Working Location').getRecordTypeId();
    public Id districtId {get; set;}
    public Id locationId {get; set;}
    public List<Branch__c> locationList = new List<Branch__c>();
    public List<Branch_Assignment__c> currentAssignment = new List<Branch_Assignment__c>();
    
    /**
	* @author Original: Michael Lasala Cloud Sherpas
	* @date Original: 26 Feb 2013
	* @description Class Constractor
	* @param 
	*/
    public WorkLocationSetupController(){
    	//Check if an existing working location(Branch Assignment records 
    	// with recordtype of Working Location) is set by the pfr
        currentAssignment = new List<Branch_Assignment__c>([SELECT Id, Branch__c, Branch__r.District__c 
        													FROM Branch_Assignment__c 
        													WHERE Branch__c!=null
        													AND Branch__r.District__c!=null
        													AND User__c =: UserInfo.getUserId() 
        													AND RecordTypeId =: locationRecordTypeId 
        													Order by CreatedDate DESC]);
        
        system.debug('Has Assignment:' + currentAssignment);
        //If a working location exist, populate values for display	  
        if(!currentAssignment.isEmpty()){
        	districtId = currentAssignment[0].Branch__r.District__c;
        	setLocationList();
        	locationId = currentAssignment[0].Branch__c;
        }//End if
    }// End Constractor
    
    /**
	* @author Original: Michael Lasala Cloud Sherpas
	* @date Original: 26 Feb 2013
	* @description District Getter Method
	* @param 
	*/
    public List<SelectOption> getDistricts() {
        List<SelectOption> districtOptions = new List<SelectOption>();
        
        districtOptions.add(new SelectOption('',''));
        for(District__c districtList: [SELECT Id, Name FROM District__c]){
            districtOptions.add(new SelectOption(districtList.Id, districtList.Name));
        }//End for
        
        return districtOptions;
    }// End getDistrict Method
    
    /**
	* @author Original: Michael Lasala Cloud Sherpas
	* @date Original: 26 Feb 2013
	* @description Location Getter Method
	* @param 
	*/
    public List<SelectOption> getLocations() {
    	// Variable Declaration
        List<SelectOption> locationOptions = new List<SelectOption>();
        locationOptions.add(new SelectOption('',''));
        
        for(Branch__c locVar: locationList){
            locationOptions.add(new SelectOption(locVar.Id, locVar.Name));
        }//End for
        
        return locationOptions;
    }// End getLocation Method
    
    /**
	* @author Original: Michael Lasala Cloud Sherpas
	* @date Original: 26 Feb 2013
	* @description Method to query Branches related on selected District
	* @param 
	*/
    public void setLocationList(){
    	// Variable Declaration
        locationList = new List<Branch__c>();
        
        List<Branch__c> branchList = [Select Id, Name, District__c 
        							  from Branch__c 
        							  where District__c = :districtId ORDER BY Name];
        							  
        for(Branch__c branchVar: branchList){
            locationList.add(branchVar);
        }//End for
    }// End setLocationList Method
    
    /**
	* @author Original: Michael Lasala Cloud Sherpas
	* @date Original: 26 Feb 2013
	* @description Method to perform save of new working location
	* @param 
	*/
    public PageReference saveLocationAssignment(){
    	// Variable Declaration
    	Id currentBranchId;
    	
    	// If there is current working location, 
    	// delete it if it's not the same with the location specified by the pfr
    	if(currentAssignment.size()>0){
    		system.debug('Current Location:' + currentAssignment[0].Id);
    		currentBranchId = currentAssignment[0].Branch__c;
    		system.debug('Current Branch Value:' + currentAssignment[0].Branch__c);
    		system.debug('Currently Selected Location:' + locationId);
    		if(currentAssignment[0].Branch__c!=locationId && locationId != null){    		
	    			// Delete existing work location
	    			Delete currentAssignment;
    		}// End If 
    	}// End If
    	
    	// Create new working location if it's not equal to the 
    	// existing working location or there's no working location setup for the current pfr
    	if(currentBranchId!=locationId && locationId != null){
	    	// Create new work location
			Branch_Assignment__c baVar = new Branch_Assignment__c(User__c = UserInfo.getUserId(), 
			            										  Branch__c = locationId, 
			            										  RecordTypeId = locationRecordTypeId);
			insert baVar;
			currentAssignment.clear();
			currentAssignment.add(baVar);
			system.debug('New Location:' + baVar.Id); 
		}//End if  
		    
        return null;
    }// End  saveLocationAssignment Method
}//End WorkLocationSetupController