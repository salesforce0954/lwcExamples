/*
    Author: Dandreb Crisologo (Cloud Sherpas)
    Created Date: April 30, 2014
    Description: Trigger Handler for product version
*/
public class ValidateProductVersionTriggerHandler {

    public static void validateStartEndDate(List<Product_Version__c> prodVersionList, Boolean isInsert) {
        
        try {

            Set<Id> products = new Set<Id>();
            Set<Id> prodVersionID = new Set<Id>();

            //iterate through list
            for(Product_Version__c pv: prodVersionList) {
               products.add(pv.GEProduct__c);
               if(!isInsert) {
                    prodVersionID.add(pv.Id); //add the id to be used as a filter later
                }
            }

            if(!products.isEmpty()) { 
                Map<Id, List<Product_Version__c>> prodVersionCheckMap = new Map<Id, List<Product_Version__c>>(); //key is Product ID
                List<Product_Version__c> prodVersionsToCheck = new List<Product_Version__c>();
                if(isInsert) { 
                    prodVersionsToCheck = [SELECT Start_Date__c, 
                                                  End_Date__c,
                                                  GEProduct__c
                                            FROM  Product_Version__c
                                            WHERE GEProduct__c IN: products];
                } else { //for update, make sure to not include the records to update when querying for records
                    prodVersionsToCheck = [SELECT Start_Date__c, 
                                                  End_Date__c,
                                                  GEProduct__c
                                            FROM  Product_Version__c
                                            WHERE ID NOT IN: prodVersionID
                                             AND  GEProduct__c IN: products];
                }

                //add product versions, grouped by product
                for(Product_Version__c pv: prodVersionsToCheck) {
                    if(prodVersionCheckMap.containsKey(pv.GEProduct__c)) {
                        prodVersionCheckMap.get(pv.GEProduct__c).add(pv);
                    } else {
                        prodVersionCheckMap.put(pv.GEProduct__c, new List<Product_Version__c> {pv});
                    }
                }

                //iterate through to-be-inserted product
                for(Product_Version__c pv: prodVersionList) {
                    //check if a product version already exists in a product. if NOT, we don't need to validate it further since the start and end date CAN be empty.
                    if(prodVersionCheckMap.containsKey(pv.GEProduct__c)) {
                        //iterate through the map, check the Start Date and End Date doesnt overlap. End Date can be empty.
                        for(Product_Version__c pvToCompare: prodVersionCheckMap.get(pv.GEProduct__c)) {

                            if(pv.Start_Date__c!=null && pv.End_Date__c!=null) { //check if start and end dates are overlapping.
                                if(pv.Start_Date__c <= pvToCompare.End_Date__c && pv.End_Date__c >= pvToCompare.End_Date__c ||
                                   pv.Start_Date__c <= pvToCompare.Start_Date__c && pv.End_Date__c >= pvToCompare.Start_Date__c ||
                                   pv.Start_Date__c >= pvToCompare.Start_Date__c && pv.Start_Date__c <= pvToCompare.End_Date__c ||
                                   pv.End_Date__c >= pvToCompare.Start_Date__c && pv.End_Date__c <= pvToCompare.End_Date__c) {
                                    pv.addError('The start and end dates of the product version that you are about to insert / update will overlap on an existing record with Start Date: ' + 
                                        pvToCompare.Start_Date__c + 'and End Date: ' + pvToCompare.End_Date__c);
                                    break; //break out of the inner loop
                                }
                            } else if(pv.Start_Date__c!=null && pv.End_Date__c==null) { //if end date is empty, check that the start date doesn't overlap with an existing record's end date
                                if(pv.Start_date__c <= pvToCompare.End_Date__c) {
                                    pv.addError('The start date of the product version that you are about to insert / update will overlap on an existing record with End Date: ' + pvToCompare.End_Date__c);
                                    break; //break out of the inner loop
                                }
                            } else if(pv.Start_Date__c==null && pv.End_Date__c!=null) {
                                if(pv.End_Date__c >= pvToCompare.Start_date__c) {
                                    pv.addError('The end date of the product version that you are about to insert / update will overlap on an existing record with Start Date: ' + pvToCompare.Start_date__c);
                                    break; //break out of the inner loop
                                }
                            } else if(pv.Start_Date__c==null && pv.End_Date__c==null) {
                                pv.addError('You can only have empty start and end dates if there is only one product version.');
                                break; //break out of the inner loop
                            }
                        }
                    }
                }

            }

        } catch (Exception e) {
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'ValidateProductVersionTriggerHandler', 'Product_Version__c', 'Class');
        }

    }

}