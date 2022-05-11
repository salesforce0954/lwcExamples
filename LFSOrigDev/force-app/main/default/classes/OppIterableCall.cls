/**
* @author Original: Andre Calimlim Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

global class OppIterableCall implements iterable<Opportunity>{
   global Iterator<Opportunity> Iterator(){
      return new OppIterable();
   }
}