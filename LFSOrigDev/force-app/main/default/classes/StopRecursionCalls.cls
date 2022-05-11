/*
*   This class will be used to handle recursive calls within triggers from happenning.
*   The class will have a single entry point - getStatus(String key).
*   The class will hold all methods which have been called during a transaction.
*   On first entry, it will create a placeholder in the map, and will return true everytime this status is checked 
*   during the transaction.
*/
public without sharing class StopRecursionCalls {
    
    private static Map<String,boolean> blnAlreadyDone = new Map<String,boolean>(); 
    
    public static boolean getStatus(String key){ 
    
        if(!blnAlreadyDone.containsKey(key)){
            blnAlreadyDone.put(key,true);
            return false;
        }
        else{
            return blnAlreadyDone.get(key);
        }
    }
}