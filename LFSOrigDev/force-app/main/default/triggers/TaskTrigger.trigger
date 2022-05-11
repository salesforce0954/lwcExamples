/* 
    @author:Sridhara Vijayappa, on 2014/04/03   
    
    This Trigger will handle all Triggerevents related to tasks.             
    See the respective context variables calling class for more details on each trigger evnt   
                                        
    @Revision History                                               
    ----------------

*/

trigger TaskTrigger on Task bulk (after insert, after update, before insert, before update){
    public static boolean isAfterInsertExecuted = false;
    public static boolean isBeforeInsertExecuted = false;
    public static boolean isAfterUpdateExecuted = false;
    public static boolean isBeforeUpdateExecuted = false;
    public static boolean isAfterDeleteExecuted = false;
    public static boolean isRunBeforeUpdateOnce = false;

    
    Disable_Trigger__c profileCustomSetting = Disable_Trigger__c.getInstance(UserInfo.getUserId());
    //if(profileCustomSetting.Donot_Run_Trigger__c){
   
    if(trigger.isBefore && Trigger.isInsert){
        //accreditations       
    }

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        //accreditations    
        ActivityDates.putTBusinessUnit(Trigger.new);        
    }

    if(Trigger.isAfter){

       if(Trigger.isInsert){
            //leads process
            TaskTriggerHandler trig = new TaskTriggerHandler();
            trig.updateCallScore(Trigger.new, 7);
            trig.updateCallScore(Trigger.new, 30);
            
        }//End If

        ActivityDates.SortTask(Trigger.new);

        if(Trigger.isUpdate){
            isAfterUpdateExecuted= true;
        }
    }
    //}
}//End of TaskTrigger