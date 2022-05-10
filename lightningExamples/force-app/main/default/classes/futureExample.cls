public class futureExample{

  @future
  public static void getCarServicing(){
    system.debug('Test one');
    //id jobId = system.enqueuejob(new queueableEx());
    //system.debug('Job id '+jobId);
  }
  @future
  public static void getCarServicingOne(){
    system.debug('Test two');
    //id jobId = system.enqueuejob(new queueableEx());
    //system.debug('Job id '+jobId);
         system.debug('is Future 1 '+system.isFuture());

  }
}