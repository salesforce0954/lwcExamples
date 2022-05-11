/* @Description: Expired promo scheduler
 * @Author: Mike Lasala
 * @Date Created: 10-OCT-2016
 */
 global class ScheduleExpiredPromoBatch implements schedulable{
    
    global void execute(SchedulableContext sc){
        ExpiredPromoBatch e = new ExpiredPromoBatch();
        database.executebatch(e);
    }
}