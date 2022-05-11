public virtual class TriggerHandler {

  // static map of handlername, times run() was invoked
  private static Set<String> bypassedHandlers;

  static {
    bypassedHandlers = new Set<String>();
  }

  public TriggerHandler() {

  }

  /***************************************
   * public methods
   ***************************************/

  // main method that will be called during execution
  public void run() {

    if(!validateRun()) return;

    // dispatch to the correct handler method
    if(Trigger.isBefore && Trigger.isInsert) {
      this.beforeInsert();
    //} else if(Trigger.isBefore && Trigger.isUpdate) {
    //  this.beforeUpdate();
    //} else if(Trigger.isBefore && Trigger.isDelete) {
    //  this.beforeDelete();
    } else if(Trigger.isAfter && Trigger.isInsert) {
      this.afterInsert();
    } else if(Trigger.isAfter && Trigger.isUpdate) {
      this.afterUpdate();
    //} else if(Trigger.isAfter && Trigger.isDelete) {
    //  this.afterDelete();
    //} else if(Trigger.isAfter && Trigger.isUndelete) {
    //  this.afterUndelete();
    }

  }


 public static void bypass(String handlerName) {
    TriggerHandler.bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    TriggerHandler.bypassedHandlers.remove(handlerName);
  }

  public static Boolean isBypassed(String handlerName) {
    return TriggerHandler.bypassedHandlers.contains(handlerName);
  }

  public static void clearAllBypasses() {
    TriggerHandler.bypassedHandlers.clear();
  }


  // make sure this trigger should continue to run
  private Boolean validateRun() {
     if(TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }
    return true;
  }

  private String getHandlerName() {
    return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  }

  /***************************************
   * context methods
   ***************************************/

  // context-specific methods for override
  protected virtual void beforeInsert(){}
  //protected virtual void beforeUpdate(){}
  //protected virtual void beforeDelete(){}
  protected virtual void afterInsert(){}
  protected virtual void afterUpdate(){}
  //protected virtual void afterDelete(){}
  //protected virtual void afterUndelete(){}



}