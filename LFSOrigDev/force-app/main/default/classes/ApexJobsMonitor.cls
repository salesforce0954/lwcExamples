public class ApexJobsMonitor implements schedulable {

public void execute(SchedulableContext sc)
{
List<Asyncapexjob> aj = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,NumberOfErrors,ParentJobId,Status,TotalJobItems,ApexClass.Name FROM AsyncApexJob where status='Queued'];
if(Test.isRunningTest())
aj = [SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,NumberOfErrors,ParentJobId,Status,TotalJobItems,ApexClass.Name FROM AsyncApexJob limit 5];
string str='';
for(AsyncApexJob a : aj)
{
    datetime dt = a.createdDate;
    //System.debug('ccccc '+ dt);
    datetime st = system.now();
    long at = st.getTime();
    long d = dt.getTime();
    long ValInMMSec = at-d;
    Long valInSec = ValInMMSec/1000;
    Long valInMin = valInSec/60;
    System.debug('sssss ' +valInMin);
    if(valInMin>5 || Test.isRunningTest())
    {
        //system.debug('Should be monit' + t);
        if(str=='')
            str='<table border="1"><tr><b><td>Class Name</td><td>Job Id</td><td>Minutes</td></b></tr><tr><td>'
            +a.apexclass.name+
            '</td><td>'+a.Id+'</td><td>'+valInMin+'</td></tr>';
        else
        str=str+'<tr><td>'+a.apexclass.name+'</td><td>'+a.Id+'</td><td>'+valInMin+'</td></tr>';
              
    }
   /* System.debug('ccccc '+ dt.minute());
    System.debug('iii '+ at);*/
    
}
if(str!=''){
    str =str+'</table>';
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] to = new String[]{'capanzitsn.rds@ge.com'};
        mail.setToAddresses(to); 
         mail.setSubject(' Salesforce Future Jobs Running Slow');
                string bodyText = label.ScheduleJobQueueLabel;
                bodyText = bodyText.replace('--tableData--',str);
                //bodyText=  bodyText.replace('--Job Id--',str);
        mail.setHtmlBody(bodytext);
         messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    
}

}  

}