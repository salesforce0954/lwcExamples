public class queueableEx implements queueable {
  public void execute(queueableContext qc){
     system.debug('Test Queueable');
     futureExample.getCarServicing();
     futureExample.getCarServicingOne();
     system.debug('is Future '+system.isFuture());
  }
}