/*
    General purpose util class
    Created By: Abul Basar on 4/14/2014
*/

public class Utils{

    /*
        This method checks whether configuration has been set to disable a functionality (a whole function or a code block). 
        Two custom settings drive the functionality as described below
            Override_User__c: which is a hierarchy type custom settins.
            Override_Function__c: which is a list type custom settings.
        A functionality can be disabled either at the functionality level by using Override_Function__c, 
        or by user level setting using Override_User__c.     
       
        @param function_name: friendly name of the function. 
            The value may present a true function, name of a trigger, code-block etc.
        
        @return 
            true: the function is allowed to execute
            false: the function is not allowed to execute
    */    
        
    public static Boolean is_enabled(String function_name){
        if(function_name == null){
            throw new CustomException('Funnction_name argument to is_enabled cannot be null');
        }
        
        log('Name of the function: ' + function_name);
        boolean user_level_disable = Override_User__c.getInstance(UserInfo.getUserId()).Disable_Triggers__c;
        boolean function_level_disable = Override_Function__c.getAll().containsKey(function_name)
                                    && Override_Function__c.getInstance(function_name).Disable__c;
        log('User level disable: ' + user_level_disable);       
        log('Function level disable: ' + function_level_disable); 
        boolean enabled = !(user_level_disable || function_level_disable);   
        log('Is enabled: ' + enabled);
        return enabled;
    }
    
    /* 
        This method will show and return the apex profiles - the indicator of execution performance
    */
    public static String get_apex_profile(){
        List<String> governer_limits = new List<String>();
        governer_limits.add('Number of aggregate queries: '+ Limits.getAggregateQueries()+ ' out of '+ Limits.getLimitAggregateQueries());
        governer_limits.add('Number of SOQL queries: '+ Limits.getQueries()+ ' out of '+ Limits.getLimitQueries());
        governer_limits.add('Number of SOSL queries: '+ Limits.getSoslQueries()+ ' out of '+ Limits.getLimitSoslQueries());
        governer_limits.add('Number of Query rows: '+ Limits.getQueryRows()+ ' out of '+ Limits.getLimitQueryRows());
        governer_limits.add('Number of DML statements: '+ Limits.getDMLStatements()+ ' out of '+ Limits.getLimitDMLStatements());
        governer_limits.add('Heap size: '+ Limits.getHeapSize()+ ' out of '+ Limits.getLimitHeapSize());
        governer_limits.add('Number of DML rows: '+ Limits.getDMLRows()+ ' out of '+ Limits.getLimitDMLRows());
        governer_limits.add('Number of email invocations: '+ Limits.getEmailInvocations()+ ' out of '+ Limits.getLimitEmailInvocations());
        governer_limits.add('Number of field describes: '+ Limits.getFieldsDescribes()+ ' out of '+ Limits.getLimitFieldsDescribes());
        governer_limits.add('Number of child relationships describes: '+ Limits.getChildRelationshipsDescribes()+ ' out of '+ Limits.getLimitChildRelationshipsDescribes());
        governer_limits.add('Number of picklist describes: '+ Limits.getPicklistDescribes()+ ' out of '+ Limits.getLimitPicklistDescribes());
        governer_limits.add('Number of code statements: '+ Limits.getScriptStatements()+ ' out of '+ Limits.getLimitScriptStatements());
        governer_limits.add('CPU utilization: '+ Limits.getCpuTime()+ ' out of '+ Limits.getLimitCpuTime());
        String joined = String.join(governer_limits, '\n');
        log('Apex profiles:\n\n' + joined);
        return joined;
    }

    public static void log(Object obj){ 
        System.debug(LoggingLevel.INFO, obj);
    }
	
	public static String getErrors(Database.SaveResult sr){
        String[] errors = new String[0];
        for(Database.Error err : sr.getErrors()) {
            errors.add(err.getStatusCode() + ': ' + err.getMessage());
        }    
        return String.join(errors, '\n');
    }  	

	public static integer getGlobalLimits(String Key){
		
		integer gLimit=2000;
		
		try{
			String thisLimit = General_Properties__c.getAll().get(key).Value__c;
			gLimit=Integer.valueof(thisLimit.trim());
		}
		catch(Exception e){
			gLimit=2000;
		}
		return gLimit;
	}
      // For Upsert Operation
    public static String getErrors(Database.UpsertResult sr){
        String[] errors = new String[0];
        for(Database.Error err : sr.getErrors()) {
            errors.add(err.getStatusCode() + ': ' + err.getMessage());
        }    
        return String.join(errors, '\n');
    }
     //for delete operation
    public static String getErrors(Database.DeleteResult sr){
        String[] errors = new String[0];
        for(Database.Error err : sr.getErrors()) {
            errors.add(err.getStatusCode() + ': ' + err.getMessage());
        }    
        return String.join(errors, '\n');
    }       
}