/* @Description: Bank,Branch and Account number validation helper class
 * @Author: Vijaya Kumar
 * @Date Created: DEC-17-2014
 * @History:
   =====================================================================
       12-17-14: Created - Vijay
   =====================================================================
 */

public with sharing class bankAcctValidationHelperClass {
	
	public static string branchNum;
	public static string bankNum;
	public static string acctNumber;
	public static string suffixNumber;
	public static string objectName;
	public static Disbursement__c disObj;
	public static Debit__c debitObj;
	
	/*  Description: Accept records from trigger for validation
     *  Author: Vijaya kumar
     *  Date Created: DEC-17-2014
     */  
	
	public static void validateAcct(list<Sobject> payeeList,string objectName1){
        		objectName=objectName1;
        map<string,Bank__c> bankMap=new map<string,Bank__c>();
        map<string,list<bank_branch__c>> rangelist=new map<string,list<bank_branch__c>>();
        map<string,algorithm__c> algorithmMap=algorithm__c.getAll();
        string algorithmValue;
        for(bank__c b:[Select b.Name, b.Algorithm__c, (Select Max_Range__c, Min_Range__c From Branch_Ranges__r) From Bank__c b]){
        	bankMap.put(b.name,b);
        	rangelist.put(b.name,b.Branch_Ranges__r);
        }
        for(Sobject p:payeeList){
            if(objectName.equalsIgnoreCase('Disbursement'))
                disObj=(Disbursement__c)p;
            else
                debitObj=(Debit__c)p;
            
            // Added by Adrian Recio
            // Description: Part of 5/5/2016 Fix Pack to 
            // append trailing zeroes to if certain max length is not reached.
            // Trailing zeroes added before any validations.
            if(objectName.equalsIgnoreCase('Disbursement')){
                disObj.Bank_Number__c = trailZeroVal(disObj.Bank_Number__c,2);
                disObj.Branch_Number__c = trailZeroVal(disObj.Branch_Number__c,4);
                disObj.Bank_Acc_No_NZ__c = trailZeroVal(disObj.Bank_Acc_No_NZ__c,7);
                disObj.Suffix_Number__c = trailZeroVal(disObj.Suffix_Number__c,3);
            }else{ 
                debitObj.Bank_Number__c = trailZeroVal(debitObj.Bank_Number__c,2);
                debitObj.Branch_Number__c = trailZeroVal(debitObj.Branch_Number__c,4);
                debitObj.Account_Number_NZ__c = trailZeroVal(debitObj.Account_Number_NZ__c,7);
                debitObj.Suffix_Number__c = trailZeroVal(debitObj.Suffix_Number__c,3);
            }
            
            bankNum='';
            algorithmValue='';
            if((objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Number__c:debitObj.Bank_Number__c).length()==1){
                bankNum='0'+(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Number__c:debitObj.Bank_Number__c); 
            }else{
                bankNum=(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Number__c:debitObj.Bank_Number__c);
            }
            if(objectName.equalsIgnoreCase('Disbursement'))
            	disObj.Bank_Number__c=bankNum;
            else
            	debitObj.Bank_Number__c=bankNum;
            
            if(!isAlphaNumeric(objectName.equalsIgnoreCase('Disbursement')?disObj.Account_Name__c:debitObj.Account_Holders__c)){
               if(objectName.equalsIgnoreCase('Disbursement')){
                   if(disObj.Account_Name__c!=null)disObj.Account_Name__c.addError('Account Name should be alphanumeric');
               }/*else{    
                    debitObj.Account_Holders__c.addError('Account Name should be alphanumeric');
                } */
            }
            
            if(!isAlphaNumeric(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Name__c:debitObj.Bank_Name__c)  && (objectName.equalsIgnoreCase('Disbursement')? String.IsNotEmpty(disObj.Bank_Name__c) : String.isNotEmpty(debitObj.Bank_Name__c))){  //Defect 480 Fix-  Afreen : Adding Condition to check for Null
               if(objectName.equalsIgnoreCase('Disbursement')){
                   if(disObj.Account_Name__c!=null)disObj.Bank_Name__c.addError('Bank Name should be alphanumeric'); 
               }else{    
                    debitObj.Bank_Name__c.addError('Bank Name should be alphanumeric');
                } 
            }
            
           if(debitObj!=null && debitObj.Commencement_Date__c!=null && debitObj.Commencement_Date__c< date.today())debitObj.Commencement_Date__c.addError('Commencement Date must be greater or equal to today');
            
            
            if(!rangelist.containsKey(bankNum)){
            	if(objectName.equalsIgnoreCase('Disbursement'))
                    disObj.Bank_Number__c.addError('Bank Number is invalid');
                else    
                    debitObj.Bank_Number__c.addError('Bank Number is invalid');	
            }
            
            if(validateBranch(rangelist.get(bankNum),p)){
                if(objectName.equalsIgnoreCase('Disbursement'))
                    disObj.Branch_Number__c.addError('Branch number is invalid');
                else    
                    debitObj.Branch_Number__c.addError('Branch number is invalid');
            }
            
            
            
          //  if(!bankMap.isEmpty()){
	        	//if(!checkLength(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c)){        
	         //       if(bankMap.containsKey(bankNum) && (bankMap.get(bankNum).Algorithm__c.contains('A')||bankMap.get(bankNum).Algorithm__c.contains('B'))){
	         //           if(isNumber(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c)){
		        //            if(integer.valueof((objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c))<00990000){
		        //                algorithmValue='A';
		        //            }else{
		        //                algorithmValue='B';
		        //            }
	         //           }else{
	         //           	if(objectName.equalsIgnoreCase('Disbursement'))
	         //               	disObj.Bank_Acc_No__c.addError('Account number is invalid');
	         //           	else    
	         //               	debitObj.Account_Number__c.addError('Account number is invalid');   
	         //           }
	         //       }else if(bankMap.containskey(bankNum)) {
	         //           algorithmValue= bankMap.get(bankNum).Algorithm__c;
	         //       }
                
	        	//}else{
	        	//	if(objectName.equalsIgnoreCase('Disbursement'))
		        //    	disObj.Bank_Acc_No__c.addError('Account number is more than 8 characters');
		        //    else    
		        //    	debitObj.Account_Number__c.addError('Account number is more than 8 characters');
	        		
	        	//}    
          //  }
          //  if(!algorithmMap.isEmpty() && algorithmMap.containsKey(algorithmValue)){
	        	//if(!checkLength(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c)){
	         //       if(isNumber(objectName.equalsIgnoreCase('Disbursement')?disObj.Suffix_Number__c:debitObj.Suffix_Number__c)){
		        //        if(!validateAcctNumber(algorithmMap.get(algorithmValue),p)){
		        //            if(objectName.equalsIgnoreCase('Disbursement'))
		        //                disObj.Bank_Acc_No__c.addError('Account number is invalid');
		        //            else    
		        //                debitObj.Account_Number__c.addError('Account number is invalid');   
		        //        }
	         //       }else{
	         //       	if(objectName.equalsIgnoreCase('Disbursement'))
	         //           	disObj.Suffix_Number__c.addError('Suffix number is invalid');
	         //       	else    
	         //           	debitObj.Suffix_Number__c.addError('Suffix number is invalid'); 
	         //       }
	        	//}else{
	        	//	if(objectName.equalsIgnoreCase('Disbursement'))
		        //    	disObj.Bank_Acc_No__c.addError('Account number is more than 8 characters');
		        //    else    
		        //    	debitObj.Account_Number__c.addError('Account number is more than 8 characters');
	        	//}
          //  }
            
        }  
        
    }
    
    /*  Description: Add Trailing Zeroes
     *  Author: Adrian Recio
     *  Date Created: 5/5/2016
     */
    public static string trailZeroVal(String strVal,Integer maxSize){
        if(strVal!=null){
            if(maxSize>strVal.length()){
                string appendStr = '';
                integer countAdd = 0;
                
                countAdd = maxSize - strVal.length();
                
                for(integer i = 0; i < countAdd; i++) {
                    appendStr = appendStr + '0';
                }
                return appendStr + strVal;
            }else{
                return strVal;
            }
        }
        
        return strVal;
    }
    
    /*  Description: Validate Branch for given bank
     *  Author: Vijaya kumar
     *  Date Created: DEC-17-2014
     */
        
    private static boolean validateBranch(list<bank_branch__c> ranges,Sobject p){
        boolean isInValid=false;
        if(isNumber(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c)){
	        if(ranges!=null){
	            for(integer i=0;i<ranges.size();i++){
	               
		                if(ranges[i].Min_Range__c<=integer.valueof(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c)&& integer.valueof(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c)<=ranges[i].Max_Range__c){
		                    isInValid=false;        
		                    break;
		                }else{
		                    if(i==(ranges.size()-1)){
		                        isInValid=true;
		                    }
		                }
	                
	            }
	        }
        }else{
        	isInValid=true;
        }
        
        return isInValid;
    }
    
    /*  Description: Validate number for given text
     *  Author: Devendra
     *  Date Created: FEB-09-2015
     */
    private static boolean isNumber(string value){
    	if(value!=null){
	    	Pattern isnumbers = Pattern.Compile('^[0-9]+$');
			Matcher valueMatch = isnumbers.matcher(value);
			if(valueMatch.Matches()){
			    return true;
			}
    	}
		return false;
    }
    
    /*private static boolean checkLength(string value){
    	if(value!=null){
	    	if(value.length()>8)
	    		return true;
    	}
		return false;
    }*/
    
    /*  Description: Validate number for given text
     *  Author: Devendra
     *  Date Created: FEB-09-2015
     */
    private static boolean isAlphaNumeric(string value){
    	if(value!=null ){
	    	Pattern isnumbers = Pattern.Compile('^[a-z0-9A-Z]+(?: [a-z0-9A-Z][a-z0-9A-Z]+)*$');
			Matcher valueMatch = isnumbers.matcher(value);
			if(valueMatch.Matches()){
			    return true;
			}
    	}
		return false;
    }
    
    /*  Description: Validate Account number for given bank
     *  Author: Vijaya kumar
     *  Date Created: DEC-17-2014
     */
    
    /*private static boolean validateAcctNumber(Algorithm__c algorithm,Sobject p){
        branchNum='';
        acctNumber='';
        suffixNumber='';
        integer weightageSum=0;
        
        if((objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c).length()<4){
            for(integer i=0;i<4-(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c).length();i++){
                branchNum+='0'; 
            }
            branchNum+=(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c);  
        }else{
            branchNum=(objectName.equalsIgnoreCase('Disbursement')?disObj.Branch_Number__c:debitObj.Branch_Number__c);   
        }
        //if((objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c).length()<8){
        //    for(integer i=0;i<8-(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c).length();i++){
        //        acctNumber+='0';    
        //    }
        //    acctNumber+=(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c);
            
        //}else{
        //    acctNumber=(objectName.equalsIgnoreCase('Disbursement')?disObj.Bank_Acc_No__c:debitObj.Account_Number__c);
            
        //}
        if((objectName.equalsIgnoreCase('Disbursement')?disObj.Suffix_Number__c:debitObj.Suffix_Number__c).length()<4){
            for(integer i=0;i<4-(objectName.equalsIgnoreCase('Disbursement')?disObj.Suffix_Number__c:debitObj.Suffix_Number__c).length();i++){
                suffixNumber+='0';  
            }
            suffixNumber+=(objectName.equalsIgnoreCase('Disbursement')?disObj.Suffix_Number__c:debitObj.Suffix_Number__c);
        }else{
            suffixNumber=(objectName.equalsIgnoreCase('Disbursement')?disObj.Suffix_Number__c:debitObj.Suffix_Number__c);
        }
        
                
        list<string> bankId=algorithm.Bank__c.Split(' ');
        for(integer i=0;i<bankId.size();i++){
            if(algorithm.Name!='G' || algorithm.Name!='E'){
            	weightageSum+=integer.valueof(bankId[i])*integer.valueof(bankNum.substring(i,i+1)); 
            }else{
            	integer sumval;
            	string multiVal=string.valueof(integer.valueof(bankId[i])*integer.valueof(bankNum.substring(i,i+1)));
            	do{
            		sumval=0;
            		for(integer j=0;j<multiVal.length();j++){
            			sumval+=integer.valueof(multiVal.substring(j,j+1));		
            		}
            		multiVal=string.valueof(sumval);
            	}while(multiVal.length()>1);
            	weightageSum+=sumval;
            }
        }
        
        list<string> Branches=algorithm.Branch__c.Split(' ');
        for(integer i=0;i<Branches.size();i++){
             
            if(algorithm.Name!='G' && algorithm.Name!='E'){
            	weightageSum+=integer.valueof(Branches[i])*integer.valueof(branchNum.substring(i,i+1)); 
            }else{
            	integer sumval;
            	string multiVal=string.valueof(integer.valueof(Branches[i])*integer.valueof(branchNum.substring(i,i+1)));
            	do{
            		sumval=0;
            		for(integer j=0;j<multiVal.length();j++){
            			sumval+=integer.valueof(multiVal.substring(j,j+1));		
            		}
            		multiVal=string.valueof(sumval);
            		system.debug('testttt'+multiVal);
            	}while(multiVal.length()>1);
            	weightageSum+=sumval;
            }
        }
        
        list<string> acctBase=algorithm.Account_Base__c.Split(' ');
        for(integer i=0;i<acctBase.size();i++){
                
          	if(algorithm.Name!='G' && algorithm.Name!='E'){
            	weightageSum+=integer.valueof(acctBase[i])*integer.valueof(acctNumber.substring(i,i+1)); 
            }else{
            	integer sumval;
            	string multiVal=string.valueof(integer.valueof(acctBase[i])*integer.valueof(acctNumber.substring(i,i+1)));
            	do{
            		sumval=0;
            		for(integer j=0;j<multiVal.length();j++){
            			sumval+=integer.valueof(multiVal.substring(j,j+1));		
            		}
            		multiVal=string.valueof(sumval);
            		system.debug('testttt'+multiVal);
            	}while(multiVal.length()>1);
            	weightageSum+=sumval;
            }  
        }
        
        list<string> Suffix=algorithm.Suffix__c.Split(' ');
        for(integer i=0;i<Suffix.size();i++){
               
            if(algorithm.Name!='G' && algorithm.Name!='E'){
            	weightageSum+=integer.valueof(Suffix[i])*integer.valueof(suffixNumber.substring(i,i+1));  
            }else{
            	integer sumval;
            	string multiVal=string.valueof(integer.valueof(Suffix[i])*integer.valueof(suffixNumber.substring(i,i+1)));
            	do{
            		sumval=0;
            		for(integer j=0;j<multiVal.length();j++){
            			sumval+=integer.valueof(multiVal.substring(j,j+1));		
            		}
            		multiVal=string.valueof(sumval);
            		system.debug('testttt'+multiVal);
            	}while(multiVal.length()>1);
            	weightageSum+=sumval;
            }
        }
        if(objectName.equalsIgnoreCase('Disbursement')){
            (disObj.Suffix_Number__c=suffixNumber);
            (disObj.Branch_Number__c=branchNum);
            //(disObj.Bank_Acc_No__c=acctNumber);
            (disObj.Bank_Acc_No_NZ__c=acctNumber);
        }else{
            (debitObj.Suffix_Number__c=suffixNumber);
            (debitObj.Branch_Number__c=branchNum);
            //(debitObj.Account_Number__c=acctNumber);
            (debitObj.Account_Number_NZ__c=acctNumber);
        }
        
        long remanider=math.mod(weightageSum,integer.valueof(algorithm.Modulo__c));
        
        if(remanider==0){
            return true;
        }else{
            return false;
        }
        
        return null;
    }*/
       
}