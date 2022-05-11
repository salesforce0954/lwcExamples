/*
 * @Description: Controller for APP_Timeout
 * @Author: Mike Lasala
 * @Date Created: OCT-10-2013
 * @History:
   =====================================================================
       10-10-13: Created - Mike
   =====================================================================
 */
public with sharing class APP_TimeoutCC{
    
    public APP_TimeoutCC(){
    
    }
    
    /*  Description: Display timeout error
     *  Author: Mike Lasala
     *  Date Created: OCT-10-2013
     *  Input Parameters: None
     *  Return: Void
     */
    public void showError(){
        Util.addMessage(ApexPages.Severity.Error, 'For security reasons your session has timed out.');
    }
}