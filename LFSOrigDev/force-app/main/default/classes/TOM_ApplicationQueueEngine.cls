/**
    Author: Tony Xu
    Created Date: 2016-02-26
    Description: For the target operating model assigning application to queue and carry out corresponding
                 actions.
    Version: 2016-02-26 Created  -  Tony Xu
**/



public class TOM_ApplicationQueueEngine {
    
    public Map<ID, User> owners;
    public List<Applicant__c> applicants;
    public Final ID AU_INBOUND_QUEUE_ID;
    public Final ID AU_LPE_QUEUE_ID;
    public Final ID AU_DECLINE_QUEUE_ID;
    
    public TOM_ApplicationQueueEngine(){
        AU_INBOUND_QUEUE_ID = [SELECT id FROM Group WHERE name = 'AU Inbound Queue'].ID;
        AU_LPE_QUEUE_ID = [SELECT id FROM Group WHERE name = 'AU LPE Queue'].ID;
        AU_DECLINE_QUEUE_ID = [SELECT id FROM Group WHERE name = 'AU Decline Queue'].ID;
    }
    
    /*  Description: Start the queueing engine
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    public void startProcess(List<Application__c> apps){
        //Getting owner details of all application passed in. Avoid query in for loop
        Set<ID> ownerIds = New Set<ID>();
        for(Application__c app : apps){
            ownerIds.add(app.OwnerId);
        }
        system.debug('!@#$ownerIDs:'+ownerIds);

        owners = New Map<ID, User>([Select u.id, u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId From User u
                                WHERE u.id in : ownerIds]);
        
        applicants = [Select id, Application__r.id, Response_Code__c from Applicant__c Where Application__c in : apps];
        system.debug('!@#$Applicants:'+applicants);
        system.debug('!@#$Owners:'+owners);
        //IF the application was updated multiple times, this process will be triggered multiple times
        //The second time it triggers if owner already changed to queue, querying the user table will 
        //result in a null value returned and thrown exception.
        if(owners.size()>0){
            for(Application__c app : apps){
                if(!GEN_OriginationsConstants.SERVER_RESPONSE_CODE.contains(app.Response_Code__c)){
                if(GEN_OriginationsConstants.PRE_BUREAU_RESPONSE_CODE.contains(app.Response_Code__c)){
                    assignToInboundQueue(app);
                }else if(GEN_OriginationsConstants.POST_BUREAU_RESPONSE_CODE.contains(app.Response_Code__c)){
                    assignToInboundQueue(app);
                }else if(GEN_OriginationsConstants.FRAUD_WATCHLIST_RESPONSE_CDDE.contains(app.Response_Code__c)){
                    system.debug('!@#$HERE');
                        //checkConditionalApprove(app);
                    assignToInboundQueue(app);
                }else if(GEN_OriginationsConstants.CPU_RESPONSE_CODE.contains(app.Response_Code__c)){
                        //checkConditionalApprove(app);
                    assignToInboundQueue(app);   
                }else if(GEN_OriginationsConstants.SALES_RESPONSE_CODE.contains(app.Response_Code__c)){
                        //checkConditionalApprove(app);
                    assignToInboundQueue(app);   
                }else if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(app.Response_Code__c)){
                     /* Commented the below line by Suneel 28/07/2017 to route all the application to AU Inbound Queue */
                    //assignToLPEQueue(app);                   
                      assignToInboundQueue(app); 
                }else if(GEN_OriginationsConstants.DECLINE_RESPONSE_CODE.contains(app.Response_Code__c)){
                    assignToDeclineQueue(app);                                     
                }else{
                    //Default assign to Inbound Queue
                    assignToInboundQueue(app);
                }
            }
            } 
        }
    }
    
    /*  Description: Assign Pre-Bureau and Post-Bureau apps to queue if it is not owned by staff yet
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    private void assignToInboundQueue(Application__c app){
        system.debug('!@#$ownerId2:'+app.OwnerId);
        system.debug('!@#$owners2:'+owners);
        //IF the application belongs to an staff user, do not assign to queue
        if(owners.get(app.OwnerId).Profile.Name == 'Customer Community Login' ||
           owners.get(app.OwnerId).Profile.Name == 'A1 Customer Community Login' ||
           owners.get(app.OwnerId).Profile.Name == 'A10 Latitude Broker Community Login'
          ){
            app.OwnerId = AU_INBOUND_QUEUE_ID;
        }
    }
    
    /*  Description: Checks applicant response code to figure out whether application is in conditional 
     *               approve stage. When conditional approved, update Application__c.Conditional_Approved__c
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    /**Since Activate is passing conditional approve flag in Application level, this is now done by Workflow
    private void checkConditionalApprove(Application__c app){
        system.debug('!@#$app:'+app);
        List<Applicant__c> aList = getApplicants(app);        
        if(aList.size()>0){
            if(app.Application_Type__c == 'Single' && aList[0].Response_Code__c != null && aList[0].Response_Code__c != ''){
                system.debug('!@#$alist2:'+aList);
                system.debug('!@#$responsecode:'+aList[0].Response_Code__C);
                if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[0].Response_Code__c)){
                    system.debug('!@#$Conditional Approved');
                    app.Conditional_Approved__c = true;                    
                }
            }else if(app.Application_Type__c == 'Joint' && aList.size() > 1 && aList[0].Response_Code__c != '' && aList[0].Response_Code__c != null &&
                          aList[1].Response_Code__c != '' && aList[1].Response_Code__c != null){
                    if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[0].Response_Code__c) &&
                       GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[1].Response_Code__c)){
                         app.Conditional_Approved__c = true;
                       }    
            }
        }
    }
    **/
    
    /*  Description: For Application that got conditional approved straight away after submission in both Application
     *               and Applicant level, assign straight to LPE queue
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    @testvisible
    private void assignToLPEQueue(Application__c app){       
        //IF the application belongs to an staff user, do not assign to queue
        if(owners.get(app.OwnerId).Profile.Name == 'Customer Community Login' ||
           owners.get(app.OwnerId).Profile.Name == 'A1 Customer Community Login'){
              /** This is changed due to Activate is sending back response code in both Application and Applicant level.
               * Because applicant response code is sent after application response code, keep doing below will result in null exception          
              List<Applicant__c> aList = getApplicants(app); 
              if(app.Application_Type__c == 'Single'){
                    if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[0].Response_Code__c))
                        app.Conditional_Approved__c = true;
                        app.Straight_Through_to_LPE__c = true;
                        app.OwnerId = AU_LPE_QUEUE_ID;
              }else if(app.Application_Type__c == 'Joint' && aList.size() > 1){
                    if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[0].Response_Code__c) &&
                        GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(aList[1].Response_Code__c))
                        app.Conditional_Approved__c = true;
                        app.Straight_Through_to_LPE__c = true;
                        app.OwnerId = AU_LPE_QUEUE_ID;
              }
            **/
               app.Conditional_Approved__c = true;
               app.Straight_Through_to_LPE__c = true;
               app.OwnerId = AU_LPE_QUEUE_ID;
         }      
    }
    
    /*  Description: For Application that declined, send to decline queue
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    @testvisible
    private void assignToDeclineQueue(Application__c app){
        if(owners.get(app.OwnerId).Profile.Name == 'Customer Community Login' ||
           owners.get(app.OwnerId).Profile.Name == 'A1 Customer Community Login'){
               app.OwnerId = AU_DECLINE_QUEUE_ID;
           }
    }
   
    /*  Description: Get Applicant records relate to application
     *  Author: Tony Xu
     *  Date Created: 2016-02-26
     *  Input: app - Application that gets updated in response code
     *  Return: VOID
    */
    @testvisible
    private List<Applicant__c> getApplicants(Application__c app){
        List<Applicant__c> aList = new List<Applicant__c>();
        system.debug('!@#$GETAPPLICANT:'+app);
        system.debug('!@#$Applicants2:'+applicants);
        for(Applicant__c applicant: applicants){
            system.debug('!@#$applicant in applicants:'+applicant.Application__r.Id + '   '+ app.Id);
            if(applicant.Application__r.Id == app.Id){
                aList.add(applicant);
            }
        }
        system.debug('!@#$aList'+aList);
        return aList;
    }
    

}