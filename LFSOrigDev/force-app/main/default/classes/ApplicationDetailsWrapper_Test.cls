/*
* @Description: Test class for ApplicationDetailsWrapper 
    =====================================================================

 */

@isTest
public class ApplicationDetailsWrapper_Test {
     private static testMethod void testlist(){
       ApplicationDetailsWrapper.AppListView app = new ApplicationDetailsWrapper.AppListView ();
       string fname = app.firstName;
       string lname =app.lastName;
       string apId = app.applicationId;
       string brokerid = app.brokerId;
       string appName = app.applicationName;
       decimal loanamt= app.loanAmount;
       string loanTerm=app.loanTerm;
       string loanNo =app.loanNumber;
    
    }
 }