/**
* @author Original: Andre Calimlim Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

global class OppIterable implements Iterator<Opportunity>{ 
   List<Opportunity> opps {get; set;} 
   Integer i {get; set;} 
   public OppIterable(){ 
       opps = [SELECT id, Live_Propensity_Score__c, Propensity_Score__c FROM Opportunity]; 
       i = 0; 
   }   
   global boolean hasNext(){ 
       if(i >= opps.size()) 
           return false; 
       else
           return true; 
   }    
   global Opportunity next(){ 
       if(i == 8){ i++; return null;} 
       i=i+1; 
       return opps[i-1]; 
   } 
}