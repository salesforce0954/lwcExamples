/**
 * @Description: Core Search and Match class that fires search service
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
global without sharing class  APP_Wizard_SearchAndMatch {

public static String topicNameAC = 'appCLVCreate';
public static String topicNameAA = 'appAccCreate';

public static Id appSearch1Id{get; set;}
public static Id appSearch2Id{get; set;}

public static Id genesisRTId;
public static Id visionRTId;
public static Id icbsRTId;

/**
 * @Description: Class constructor
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
	global APP_Wizard_SearchAndMatch() {
		
	}

  public static void setMockRecordtypeId(){
    APP_Wizard_SearchAndMatch.genesisRTId = Schema.SObjectType.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
    APP_Wizard_SearchAndMatch.visionRTId = Schema.SObjectType.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
    APP_Wizard_SearchAndMatch.icbsRTId = Schema.SObjectType.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
    system.debug('genesis recordtypeId:' + APP_Wizard_SearchAndMatch.genesisRTId);
    system.debug('vision recordtypeId:' + APP_Wizard_SearchAndMatch.visionRTId);
    system.debug('icbs recordtypeId:' + APP_Wizard_SearchAndMatch.icbsRTId);
  }


/**
 * @Description: Core method that creates streaming topic used for search and match
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
public static void addAccountTopic() {
        // Initialize applicant account recordtype Ids
        //setMockRecordtypeId();

        // Mock Search Initialization
        /*
        List<Applicant_Search__c> testAppSearch = new List<Applicant_Search__c>();
        Applicant_Search__c asVar1 = new Applicant_Search__C();
        Applicant_Search__c asVar2 = new Applicant_Search__C();
        testAppSearch.add(asVar1);
        testAppSearch.add(asVar2);
        insert testAppSearch;
        

        APP_Wizard_SearchAndMatch.appSearch1Id = testAppSearch[0].Id;
        APP_Wizard_SearchAndMatch.appSearch2Id = testAppSearch[1].Id;
        */

        string appCLVTopicName = APP_Wizard_SearchAndMatch.topicNameAC;
        string appAccTopicName = APP_Wizard_SearchAndMatch.topicNameAA;
        
        system.debug('CLV Topic Name:' + appCLVTopicName);
        system.debug('Account Topic Name:' + appAccTopicName);

        List<PushTopic> currentPT = [Select Id, Name From PushTopic Where Name = :appCLVTopicName or Name = :appAccTopicName ];

        system.debug('Current Push Topics:' + currentPT);

        Map<String,PushTopic> mapByType = new Map<String,PushTopic>();
        List<PushTopic> upsertTopicList = new List<PushTopic>();
                    
        for(PushTopic ptVar: currentPT){
            if(ptVar.Name == appCLVTopicName || ptVar.Name == appAccTopicName){
                mapByType.put(ptVar.Name,ptVar);
            }
        }
        system.debug('Key Set Present CLV:' + mapByType.keySet().contains(appCLVTopicName));

        if (!mapByType.keySet().contains(appCLVTopicName)) {
          PushTopic newTopicAC = new PushTopic();
          newTopicAC.Name = appCLVTopicName;
          newTopicAC.Query = 'SELECT Id, Middle_Name__c, Title__c, Drivers_License__c, Message_Code__c, User_Match_Flag__c,  Match_Score__c, Match_Grade__c, Applicant_Search__c, Name, First_Name__c, Surname__c, Date_of_Birth__c, Street_Address__c, Suburb__c, State__c, Post_Code__c, CLV__c, Mobile__c FROM Applicant_CLV__c';
          newTopicAC.ApiVersion = 27.0;
          newTopicAC.NotifyForFields = 'All';
            newTopicAC.NotifyForOperationCreate = true;
            newTopicAC.NotifyForOperationUpdate = false;
            upsertTopicList.add(newTopicAC);
        }else{
            PushTopic newTopicAC = mapByType.get(appCLVTopicName);
          newTopicAC.Name = appCLVTopicName;
          newTopicAC.Query = 'SELECT Id, Middle_Name__c, Title__c, Drivers_License__c, Message_Code__c, User_Match_Flag__c, Match_Score__c, Match_Grade__c, Applicant_Search__c, Name, First_Name__c, Surname__c, Date_of_Birth__c, Street_Address__c, Suburb__c, State__c, Post_Code__c, CLV__c, Mobile__c FROM Applicant_CLV__c';
          newTopicAC.ApiVersion = 27.0;
          newTopicAC.NotifyForFields = 'All';
            newTopicAC.NotifyForOperationCreate = true;
            newTopicAC.NotifyForOperationUpdate = false;
          upsertTopicList.add(newTopicAC);
        }
        
        system.debug('Key Set Present Account:' + mapByType.keySet().contains(appAccTopicName));

        if(!mapByType.keySet().contains(appAccTopicName)){
          PushTopic newTopicAA = new PushTopic();            
            newTopicAA.Name = appAccTopicName;
          newTopicAA.Query = 'SELECT Product_Type__c, Match_Count__c, Message_Code_Host__c, Retrieved_Payoff_Amount__c, RPQ_Interest_Rate__c, RPQ_Principal_Amount__c, RPQ_Interest_Due__c, RPQ_Late_Fees_Due__c, RPQ_Penalty_Interest_Due__c,' +
                        'RPQ_Fees_or_Charges_Due__c, RPQ_Charge_Off_Amount__c, RPQ_Insurance_Rebate__c, RPQ_Early_Termination_Fee__c,Retrieve_Payoff_Response__c,' + 
                        'Opening_Balance__c, Current_Balance__c, Next_Payment_Amount_Due__c, Amount_Financed__c, Closed_Date__c, ' +
                        'Maximum_Credit_Limit__c, Installment_Amount__c, RecordTypeId, Id, Name, Applicant_CLV__c, Account_Number__c, ' + 
                        'Selected_ICBS_Customer_Number__c, Account_Open_Date__c, Account_Type__c,Credit_Limit_Borrowed_Amount__c, ' + 
                        'Account_Balance__c,Host_System_Identifier__c, CLV_Match_Indicator__c,Account_Status__c FROM Applicant_Account__c';
          newTopicAA.ApiVersion = 27.0;
          newTopicAA.NotifyForFields = 'All';
            newTopicAA.NotifyForOperationCreate = true;
            newTopicAA.NotifyForOperationUpdate = false;
          upsertTopicList.add(newTopicAA);
        }else{
            PushTopic newTopicAA = mapByType.get(appAccTopicName);           
            newTopicAA.Name = appAccTopicName;
          newTopicAA.Query = 'SELECT Product_Type__c, Match_Count__c, Message_Code_Host__c, Retrieved_Payoff_Amount__c, RPQ_Interest_Rate__c, RPQ_Principal_Amount__c, RPQ_Interest_Due__c, RPQ_Late_Fees_Due__c, RPQ_Penalty_Interest_Due__c,' +
                        'RPQ_Fees_or_Charges_Due__c, RPQ_Charge_Off_Amount__c, RPQ_Insurance_Rebate__c, RPQ_Early_Termination_Fee__c,Retrieve_Payoff_Response__c,' + 
                        'Opening_Balance__c, Current_Balance__c, Next_Payment_Amount_Due__c, Amount_Financed__c, Closed_Date__c, ' +
                        'Maximum_Credit_Limit__c, Installment_Amount__c, RecordTypeId, Id, Name, Applicant_CLV__c, Account_Number__c, ' + 
                        'Selected_ICBS_Customer_Number__c, Account_Open_Date__c, Account_Type__c,Credit_Limit_Borrowed_Amount__c, ' + 
                        'Account_Balance__c,Host_System_Identifier__c, CLV_Match_Indicator__c,Account_Status__c FROM Applicant_Account__c';
          newTopicAA.ApiVersion = 27.0;
          newTopicAA.NotifyForFields = 'All';
            newTopicAA.NotifyForOperationCreate = true;
            newTopicAA.NotifyForOperationUpdate = false;
          upsertTopicList.add(newTopicAA);
        }

        system.debug('Push Topic List:' + upsertTopicList);

        if(upsertTopicList.size()>0){
          upsert upsertTopicList; 
        }
    }
/**
 * @Description: Core method that pulls involve party/ folder for search and match accounts
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
  @RemoteAction
  global static List<Applicant_Account_Involved_Party__c> queryFolder(List<String> appAccountIdList){
  	List<Applicant_Account_Involved_Party__c> aaInvolvePartyList = [Select Id, Applicant_Account__c, Full_Name__c, Relationship_Type__c, Customer_Identifier__c, SolicitFlag__c from 
                                                                      Applicant_Account_Involved_Party__c where Applicant_Account__c IN :appAccountIdList];
      return aaInvolvePartyList;
  }
 
/**
 * @Description: Core method that creates Applicant search record for search and match
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */   
  @RemoteAction
  global static Id searchApp(Applicant_Search__c asVar){
      APP_Wizard_SearchAndMatch.addAccountTopic();
     	   system.debug('accNumber:' + asVar.Account_Number__c);
         system.debug('country:' + asVar.Country__c);
         system.debug('dBWS:' + asVar.Date_of_Birth_WS__c);
         system.debug('dB:' + asVar.Date_of_Birth__c);
         system.debug('dL:' + asVar.Drivers_License__c);
         system.debug('fName:' + asVar.First_Name__c);
         system.debug('lName:' + asVar.Last_Name__c);
         system.debug('mPhone:' + asVar.Mobile_Phone__c);
         system.debug('pCode:' + asVar.Post_Code__c);
         system.debug('ppCode:' + asVar.Previous_Postcode__c);
         system.debug('sso:' + asVar.SSO__c);
         system.debug('status:' + asVar.Status__c);
         system.debug('user:' + asVar.User__c);
	
      if(Applicant_Search__c.SObjectType.getDescribe().isCreateable()){
          asVar.Country__c = [SELECT Country__c FROM User WHERE ID = : UserInfo.getUserId()].Country__c;	//DBHZL28
          insert asVar; 
      }
		  
      system.debug('App Search Id:' + asVar.Id);
  	return asVar.Id;
  }

  /*  Description: Fire webservice call to search for clv based on search criteria
   *  Author: Adrian Recio
   *  Date Created: 
   *  Input Parameters: asId
   *  Return: None
   */
  @RemoteAction
  global static void fireSearch(string asId){  
   IS_CustomerSearch.customerSearchService(asId, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, true);             
  }
  
/**
 * @Description: Core method that mocks search and match result
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
	@RemoteAction
  global static void mockSearch(Integer appliCount, 
                              Boolean errNoCLV, Boolean errFailCLV, 
                              Boolean errNoAcc, Boolean errFailAcc,
                              Boolean errTimeout, string appS1, string appS2){  
        setMockRecordtypeId();  
    		if(appliCount==1 && errTimeout==false){
                 
                Applicant_CLV__c aCLV1;
                Applicant_CLV__c aCLV2;
                Applicant_CLV__c aCLV3;
                Applicant_CLV__c aCLV4;
                Applicant_CLV__c aCLV5;
                Applicant_CLV__c aCLVFail;
                
                List<Applicant_CLV__c>aclList = new List<Applicant_CLV__c>();
                
                if(errNoCLV==false && errFailCLV==false){
                    // CLV 4000
                    aCLV1 = new Applicant_CLV__c(Drivers_License__c='1011', Match_Score__c='50', Match_Grade__c='Suspect', First_Name__c='JohnY', Surname__c='Smith',
                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', Title__c = 'Mr', Middle_Name__c = 'Jones',
                                                 CLV__c='4000',Mobile__c='00232323', Applicant_Search__c=appS1, Message_Code__c='0000');
    
                    // CLV 2000											 
                    aCLV2 = new Applicant_CLV__c(Drivers_License__c='1012', Match_Score__c='90', Match_Grade__c='Match', First_Name__c='JohnX', Surname__c='Smith',
                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', Title__c = 'Mr', Middle_Name__c = 'Jones',
                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS1, Message_Code__c='0000');
                    aCLV3 = new Applicant_CLV__c(Drivers_License__c='1013', Match_Score__c='99', Match_Grade__c='Match', First_Name__c='John', Surname__c='Smith',
                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', Title__c = 'Mr', Middle_Name__c = 'Jones',
                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS1, Message_Code__c='0000');
                    
                    aCLV4 = new Applicant_CLV__c(Drivers_License__c='1014', Match_Score__c='99', Match_Grade__c='Match', First_Name__c='John2', Surname__c='Smith',
                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', Title__c = 'Mr', Middle_Name__c = 'Jones',
                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS1, Message_Code__c='0000');
                    
                   
                    aCLV5 = new Applicant_CLV__c(Drivers_License__c='1015', Match_Score__c='55', Match_Grade__c='Suspect', First_Name__c='John3', Surname__c='Smith',
                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', Title__c = 'Mr', Middle_Name__c = 'Jones',
                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS1, Message_Code__c='0000');
                    
                    aclList.add(aCLV1);
                    aclList.add(aCLV2);
                    
                    aclList.add(aCLV4);
                    aclList.add(aCLV5);
                    
                    aclList.add(aCLV3);
                }else if(errNoCLV==true || errFailCLV==true){
                    aCLVFail = new Applicant_CLV__c(Drivers_License__c='1015', Match_Score__c='55', Match_Grade__c='Suspect', First_Name__c='John3', Surname__c='Smith',
                                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', 
                                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS1);
                    if(errNoCLV==true){				
                    	aCLVFail.Message_Code__c='9999';
                    }
                    
                    if(errFailCLV==true){				
                    	aCLVFail.Message_Code__c='ERCS01';
                    }
                    
                	aclList.add(aCLVFail);
                }
                
                insert aclList;
                
                List<Applicant_Account__c>aaList = new List<Applicant_Account__c>();
                Applicant_Account__c aaVar;
                Applicant_Account__c aaVar1;
                Applicant_Account__c icbs1;
                Applicant_Account__c icbs2;
                Applicant_Account__c icbs3;     
                Applicant_Account__c accFailed;
                
                if(errNoCLV==false && errFailCLV==false && errNoAcc==false && errFailAcc==false){
                    // Genesis
                    aaVar = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                     Retrieve_Payoff_Response__c = true,
                                                     Applicant_CLV__c = aCLV3.Id, 
                                                     RecordTypeId = APP_Wizard_SearchAndMatch.genesisRTId,
                                                     Current_Balance__c = '10000', 
                                                     Account_Number__c='4', 
                                                     Selected_ICBS_Customer_Number__c='1212',
                                                     Account_Open_Date__c=date.today(),
                                                     Account_Type__c='Genesis',
                                                     Credit_Limit_Borrowed_Amount__c='1000',
                                                     Opening_Balance__c = '2000',
                                                     Installment_Amount__c = 500,
                                                     Amount_Financed__c = 999,
                                                     Next_Payment_Amount_Due__c = 600,
                                                     Account_Balance__c='101',
                                                     Host_System_Identifier__c='Genesis',
                                                     CLV_Match_Indicator__c='123',
                                                     Account_Status__c='Open',
                                                     Retrieved_Payoff_Amount__c=1000,
                                                     RPQ_Charge_Off_Amount__c=1,
                                                     RPQ_Early_Termination_Fee__c=1,
                                                     RPQ_Fees_or_Charges_Due__c=1,
                                                     RPQ_Insurance_Rebate__c=1,
                                                     RPQ_Interest_Due__c=1,
                                                     RPQ_Interest_Rate__c=1,
                                                     RPQ_Late_Fees_Due__c=1,
                                                     RPQ_Penalty_Interest_Due__c=1,
                                                     RPQ_Principal_Amount__c=1,
                                                     Message_Code_Host__c = '0000',
                                                     Match_Count__c = 5);
                    
                    // Vision
                    aaVar1 = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                      Retrieve_Payoff_Response__c = true,
                                                      Applicant_CLV__c = aCLV3.Id, 
                                                      Closed_Date__c = null,
                                                      RecordTypeId = APP_Wizard_SearchAndMatch.visionRTId,
                                                      Current_Balance__c = '10000',
                                                      Maximum_Credit_Limit__c = '1000',
                                                      Account_Number__c='5', 
                                                      Selected_ICBS_Customer_Number__c='1212',
                                                      Account_Open_Date__c=date.today(),
                                                      Account_Type__c='Vision',
                                                      Credit_Limit_Borrowed_Amount__c='1000',
                                                      Opening_Balance__c = '2000',
                                                      Installment_Amount__c = 500,
                                                      Amount_Financed__c = 999,
                                                      Next_Payment_Amount_Due__c = 600,
                                                      Account_Balance__c='1500',
                                                      Host_System_Identifier__c='Vision',
                                                      CLV_Match_Indicator__c='123',
                                                      Account_Status__c='Open',
                                                      Retrieved_Payoff_Amount__c=2000,
                                                      RPQ_Charge_Off_Amount__c=2,
                                                      RPQ_Early_Termination_Fee__c=2,
                                                      RPQ_Fees_or_Charges_Due__c=2,
                                                      RPQ_Insurance_Rebate__c=2,
                                                      RPQ_Interest_Due__c=2,
                                                      RPQ_Interest_Rate__c=2,
                                                      RPQ_Late_Fees_Due__c=2,
                                                      RPQ_Penalty_Interest_Due__c=2,
                                                      RPQ_Principal_Amount__c=2,
                                                      Message_Code_Host__c = '0000',
                                                      Match_Count__c = 5);
                    
                    // ICBS 1
                    icbs1 = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                     Retrieve_Payoff_Response__c = true,
                                                     Applicant_CLV__c = aCLV1.Id, 
                                                     Current_Balance__c = '10000',
                                                     RecordTypeId = APP_Wizard_SearchAndMatch.icbsRTId,
                                                     Account_Number__c='6', 
                                                     Selected_ICBS_Customer_Number__c='1212',
                                                     Account_Open_Date__c=date.today()-3,
                                                     Account_Type__c='ICBS',
                                                     Credit_Limit_Borrowed_Amount__c='1000',
                                                     Opening_Balance__c = '2000',
                                                     Installment_Amount__c = 500,
                                                     Amount_Financed__c = 999,
                                                     Next_Payment_Amount_Due__c = 600,
                                                     Account_Balance__c='3000',
                                                     Host_System_Identifier__c='ICBS',
                                                     CLV_Match_Indicator__c='123',
                                                     Account_Status__c='Open',
                                                     Retrieved_Payoff_Amount__c=3500,
                                                     RPQ_Charge_Off_Amount__c=3,
                                                     RPQ_Early_Termination_Fee__c=3,
                                                     RPQ_Fees_or_Charges_Due__c=3,
                                                     RPQ_Insurance_Rebate__c=3,
                                                     RPQ_Interest_Due__c=3,
                                                     RPQ_Interest_Rate__c=3,
                                                     RPQ_Late_Fees_Due__c=3,
                                                     RPQ_Penalty_Interest_Due__c=3,
                                                     RPQ_Principal_Amount__c=300,
                                                     Message_Code_Host__c = '0000',
                                                     Match_Count__c = 5);
                    
                    // ICBS 2
                    icbs2 = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                     Retrieve_Payoff_Response__c = true,
                                                     Applicant_CLV__c = aCLV1.Id, 
                                                     Current_Balance__c = '10000',
                                                     RecordTypeId = APP_Wizard_SearchAndMatch.icbsRTId,
                                                     Account_Number__c='7', 
                                                     Selected_ICBS_Customer_Number__c='1212',
                                                     Account_Open_Date__c=date.today()-1,
                                                     Account_Type__c='ICBS',
                                                     Credit_Limit_Borrowed_Amount__c='1000',
                                                     Opening_Balance__c = '2000',
                                                     Installment_Amount__c = 500,
                                                     Amount_Financed__c = 999,
                                                     Next_Payment_Amount_Due__c = 600,
                                                     Account_Balance__c='3000',
                                                     Host_System_Identifier__c='ICBS',
                                                     CLV_Match_Indicator__c='123',
                                                     Account_Status__c='Open',
                                                     Retrieved_Payoff_Amount__c=3501,
                                                     RPQ_Charge_Off_Amount__c=3,
                                                     RPQ_Early_Termination_Fee__c=3,
                                                     RPQ_Fees_or_Charges_Due__c=3,
                                                     RPQ_Insurance_Rebate__c=3,
                                                     RPQ_Interest_Due__c=3,
                                                     RPQ_Interest_Rate__c=3,
                                                     RPQ_Late_Fees_Due__c=3,
                                                     RPQ_Penalty_Interest_Due__c=3,
                                                     RPQ_Principal_Amount__c=400,
                                                     Message_Code_Host__c = '0000',
                                                     Match_Count__c = 5);
                    
                     // ICBS 3
                     icbs3 = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                      Retrieve_Payoff_Response__c = true,
                                                      Applicant_CLV__c = aCLV1.Id, 
                                                      Current_Balance__c = '10000',
                                                      RecordTypeId = APP_Wizard_SearchAndMatch.icbsRTId,
                                                      Account_Number__c='8', 
                                                      Selected_ICBS_Customer_Number__c='1212',
                                                      Account_Open_Date__c=date.today()-1,
                                                      Account_Type__c='ICBS',
                                                      Credit_Limit_Borrowed_Amount__c='1000',
                                                      Opening_Balance__c = '2000',
                                                      Installment_Amount__c = 500,
                                                      Amount_Financed__c = 999,
                                                      Next_Payment_Amount_Due__c = 600,
                                                      Account_Balance__c='3000',
                                                      Host_System_Identifier__c='ICBS',
                                                      CLV_Match_Indicator__c='123',
                                                      Account_Status__c='Open',
                                                      Retrieved_Payoff_Amount__c=3502,
                                                      RPQ_Charge_Off_Amount__c=3,
                                                      RPQ_Early_Termination_Fee__c=3,
                                                      RPQ_Fees_or_Charges_Due__c=3,
                                                      RPQ_Insurance_Rebate__c=3,
                                                      RPQ_Interest_Due__c=3,
                                                      RPQ_Interest_Rate__c=3,
                                                      RPQ_Late_Fees_Due__c=3,
                                                      RPQ_Penalty_Interest_Due__c=3,
                                                      RPQ_Principal_Amount__c=500,
                                                      Message_Code_Host__c = '0000',
                                                      Match_Count__c = 5);
                    
                        
                        aaList.add(aaVar);
                        aaList.add(aaVar1);
                        aaList.add(icbs1);
                        aaList.add(icbs2);
                        aaList.add(icbs3); 
                    }else if(errNoAcc==true || errFailAcc==true){
                       // Genesis
                    	accFailed = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                             Retrieve_Payoff_Response__c = true,
                                                             Applicant_CLV__c = aCLV3.Id, 
                                                             RecordTypeId = APP_Wizard_SearchAndMatch.genesisRTId,
                                                             Current_Balance__c = '10000', 
                                                             Account_Number__c='4', 
                                                             Selected_ICBS_Customer_Number__c='1212',
                                                             Account_Open_Date__c=date.today(),
                                                             Account_Type__c='Genesis',
                                                             Credit_Limit_Borrowed_Amount__c='1000',
                                                             Opening_Balance__c = '2000',
                                                             Installment_Amount__c = 500,
                                                             Amount_Financed__c = 999,
                                                             Next_Payment_Amount_Due__c = 600,
                                                             Account_Balance__c='101',
                                                             Host_System_Identifier__c='Genesis',
                                                             CLV_Match_Indicator__c='123',
                                                             Account_Status__c='Open',
                                                             Retrieved_Payoff_Amount__c=1000,
                                                             RPQ_Charge_Off_Amount__c=1,
                                                             RPQ_Early_Termination_Fee__c=1,
                                                             RPQ_Fees_or_Charges_Due__c=1,
                                                             RPQ_Insurance_Rebate__c=1,
                                                             RPQ_Interest_Due__c=1,
                                                             RPQ_Interest_Rate__c=1,
                                                             RPQ_Late_Fees_Due__c=1,
                                                             RPQ_Penalty_Interest_Due__c=1,
                                                             RPQ_Principal_Amount__c=1,
                                                             Match_Count__c = 1);
                        if(errNoAcc==true){
                            accFailed.Message_Code_Host__c = '9999';
                            
                        }
                        if(errFailAcc==true){
                            accFailed.Message_Code_Host__c = 'ERCS01';
                        }
                        aaList.add(accFailed); 
                    }
                
                    insert aaList;
                	
                	if(errNoCLV==false && errFailCLV==false && errNoAcc==false && errFailAcc==false){
                        List<Applicant_Account_Involved_Party__c>aaInvolvePartyList = new List<Applicant_Account_Involved_Party__c>();
                        
                        Applicant_Account_Involved_Party__c aaI1 = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John1 Smith', 
                                                                                                          Relationship_Type__c='TST', 
                                                                                                          Customer_Identifier__c = '1112', 
                                                                                                          SolicitFlag__c=true);
                        aaI1.Applicant_Account__c = icbs1.Id;
                        aaInvolvePartyList.add(aaI1);
                        
                        Applicant_Account_Involved_Party__c aaI2 = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John2 Smith', 
                                                                                                           Relationship_Type__c='TST', 
                                                                                                           Customer_Identifier__c = '1314', 
                                                                                                           SolicitFlag__c=true);
                        aaI2.Applicant_Account__c = icbs2.Id;
                        aaInvolvePartyList.add(aaI2);
                        
                        Applicant_Account_Involved_Party__c aaI3 = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John3 Smith', 
                                                                                                           Relationship_Type__c='TST', 
                                                                                                           Customer_Identifier__c = '1516', 
                                                                                                           SolicitFlag__c=true);
                        aaI3.Applicant_Account__c = icbs3.Id;
                        aaInvolvePartyList.add(aaI3);
                        
                        // Pass Step 2
                         Applicant_Account_Involved_Party__c aaI4 = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John3 Smith', 
                                                                                                           Relationship_Type__c='TST', 
                                                                                                           Customer_Identifier__c = '1517', 
                                                                                                           SolicitFlag__c=true);
                        aaI4.Applicant_Account__c = icbs3.Id;
                        aaInvolvePartyList.add(aaI4);
                       
                        insert aaInvolvePartyList;
    				}
            }else if(appliCount==2&& errTimeout==false){
                // Applicant 2
                Applicant_CLV__c aCLV4;
                Applicant_CLV__c aCLV5;
                Applicant_CLV__c aCLV6;
                Applicant_CLV__c aCLV7;
                Applicant_CLV__c aCLV8;
                Applicant_CLV__c aCLV9;
                Applicant_CLV__c aCLVFail;
                List<Applicant_CLV__c>aclList2 = new List<Applicant_CLV__c>();
                
                if(errNoCLV==false && errFailCLV==false){
                    aCLV4 = new Applicant_CLV__c(Drivers_License__c='1011', Match_Score__c='90', Match_Grade__c='Match', First_Name__c='Laura', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4009',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');
                    
                    
                    aCLV5 = new Applicant_CLV__c(Drivers_License__c='1012', Match_Score__c='60', Match_Grade__c='Suspect', First_Name__c='LauraY', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4011',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');
                    
                    aCLV6 = new Applicant_CLV__c(Drivers_License__c='1013', Match_Score__c='50', Match_Grade__c='Suspect', First_Name__c='LauraX', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4010',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');
                    
                    aCLV7 = new Applicant_CLV__c(Drivers_License__c='1014', Match_Score__c='50', Match_Grade__c='Suspect', First_Name__c='Laura1', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4010',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');
                    
                    aCLV8 = new Applicant_CLV__c(Drivers_License__c='1015', Match_Score__c='50', Match_Grade__c='Suspect', First_Name__c='Laura2', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4010',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');
                    
                    aCLV9 = new Applicant_CLV__c(Drivers_License__c='1011', Match_Score__c='90', Match_Grade__c='Match', First_Name__c='Laura3', Surname__c='Smith',
                                                 Street_Address__c='54 B.Morada Ave.', Date_of_Birth__c='14/12/1989', 
                                                 Suburb__c='Lipa',State__c='Batangas', Post_Code__c='3000', Title__c = 'Ms', Middle_Name__c = 'Jones',
                                                 CLV__c='4009',Mobile__c='00232323', Applicant_Search__c=appS2, Message_Code__c='0000');

                    
                    aclList2.add(aCLV4);
                    aclList2.add(aCLV5);
                	aclList2.add(aCLV7);
                	aclList2.add(aCLV8);
                    aclList2.add(aCLV6);
                	aclList2.add(aCLV9); 
               }else if(errNoCLV==true || errFailCLV==true){
                    aCLVFail = new Applicant_CLV__c(Drivers_License__c='1015', Match_Score__c='55', Match_Grade__c='Suspect', First_Name__c='John3', Surname__c='Smith',
                                                                 Street_Address__c='620 Collins St.', Date_of_Birth__c='14/12/1989', 
                                                                 Suburb__c='Melbourne',State__c='Victoria', Post_Code__c='3000', 
                                                                 CLV__c='2000',Mobile__c='00232323', Applicant_Search__c=appS2);
                    if(errNoCLV==true){				
                    	aCLVFail.Message_Code__c='9999';
                    }
                    
                    if(errFailCLV==true){				
                    	aCLVFail.Message_Code__c='ERCS01';
                    }
                    
                	aclList2.add(aCLVFail);
                }
                
                insert aclList2;
                
                List<Applicant_Account__c>aaList2 = new List<Applicant_Account__c>();
                Applicant_Account__c aaVarMain;
                Applicant_Account__c aaVar1One;
                Applicant_Account__c aaVar2Two;
                Applicant_Account__c aaVar3Three;
                Applicant_Account__c accFailed;
                
                if(errNoCLV==false && errFailCLV==false && errNoAcc==false && errFailAcc==false){
                    // Genesis
                    aaVarMain = new Applicant_Account__c(Retrieve_Payoff_Response__c = true,
                                                         Applicant_CLV__c = aCLV4.Id, 
                                                         RecordTypeId = APP_Wizard_SearchAndMatch.genesisRTId,
                                                         Current_Balance__c = '20000', 
                                                         Account_Number__c='1', 
                                                         Selected_ICBS_Customer_Number__c='1212',
                                                         Account_Open_Date__c=date.today(),
                                                         Account_Type__c='Genesis',
                                                         Credit_Limit_Borrowed_Amount__c='1000',
                                                         Opening_Balance__c = '2000',
                                                         Installment_Amount__c = 500,
                                                         Amount_Financed__c = 999,
                                                         Next_Payment_Amount_Due__c = 600,
                                                         Account_Balance__c='1500',
                                                         Host_System_Identifier__c='Genesis',
                                                         CLV_Match_Indicator__c='123',
                                                         Account_Status__c='Open',
                                                         Retrieved_Payoff_Amount__c=1500,
                                                         RPQ_Charge_Off_Amount__c=1,
                                                         RPQ_Early_Termination_Fee__c=1,
                                                         RPQ_Fees_or_Charges_Due__c=1,
                                                         RPQ_Insurance_Rebate__c=1,
                                                         RPQ_Interest_Due__c=1,
                                                         RPQ_Interest_Rate__c=1,
                                                         RPQ_Late_Fees_Due__c=1,
                                                         RPQ_Penalty_Interest_Due__c=1,
                                                         RPQ_Principal_Amount__c=1,
                                                         Message_Code_Host__c = '0000',
                                                         Match_Count__c = 4);
                    
                    // Vision
                    aaVar1One = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                         Retrieve_Payoff_Response__c = true,
                                                         Applicant_CLV__c = aCLV5.Id, 
                                                         Closed_Date__c = null,
                                                         RecordTypeId = APP_Wizard_SearchAndMatch.visionRTId,
                                                         Current_Balance__c = '20000',
                                                         Maximum_Credit_Limit__c = '1000',
                                                         Account_Number__c='2', 
                                                         Selected_ICBS_Customer_Number__c='1212',
                                                         Account_Open_Date__c=date.today(),
                                                         Account_Type__c='Vision',
                                                         Credit_Limit_Borrowed_Amount__c='1000',
                                                         Opening_Balance__c = '2000',
                                                         Installment_Amount__c = 500,
                                                         Amount_Financed__c = 999,
                                                         Next_Payment_Amount_Due__c = 600,
                                                         Account_Balance__c='3000',
                                                         Host_System_Identifier__c='Vision',
                                                         CLV_Match_Indicator__c='123',
                                                         Account_Status__c='Open',
                                                         Retrieved_Payoff_Amount__c=3000,
                                                         RPQ_Charge_Off_Amount__c=2,
                                                         RPQ_Early_Termination_Fee__c=2,
                                                         RPQ_Fees_or_Charges_Due__c=2,
                                                         RPQ_Insurance_Rebate__c=2,
                                                         RPQ_Interest_Due__c=2,
                                                         RPQ_Interest_Rate__c=2,
                                                         RPQ_Late_Fees_Due__c=2,
                                                         RPQ_Penalty_Interest_Due__c=2,
                                                         RPQ_Principal_Amount__c=2,
                                                         Message_Code_Host__c = '0000',
                                                         Match_Count__c = 4);
                    
                    // ICBS
                    aaVar2Two = new Applicant_Account__c(Retrieve_Payoff_Response__c = true,
                                                         Applicant_CLV__c = aCLV5.Id, 
                                                         Current_Balance__c = '20000',
                                                         RecordTypeId = APP_Wizard_SearchAndMatch.icbsRTId,
                                                         Account_Number__c='6', 
                                                         Selected_ICBS_Customer_Number__c='1212',
                                                         Account_Open_Date__c=date.today(),
                                                         Account_Type__c='ICBS',
                                                         Credit_Limit_Borrowed_Amount__c='1000',
                                                         Opening_Balance__c = '2000',
                                                         Installment_Amount__c = 500,
                                                         Amount_Financed__c = 999,
                                                         Next_Payment_Amount_Due__c = 600,
                                                         Account_Balance__c='2300',
                                                         Host_System_Identifier__c='ICBS',
                                                         CLV_Match_Indicator__c='123',
                                                         Account_Status__c='Open',
                                                         Retrieved_Payoff_Amount__c=2300,
                                                         RPQ_Charge_Off_Amount__c=3,
                                                         RPQ_Early_Termination_Fee__c=3,
                                                         RPQ_Fees_or_Charges_Due__c=3,
                                                         RPQ_Insurance_Rebate__c=3,
                                                         RPQ_Interest_Due__c=3,
                                                         RPQ_Interest_Rate__c=3,
                                                         RPQ_Late_Fees_Due__c=3,
                                                         RPQ_Penalty_Interest_Due__c=3,
                                                         RPQ_Principal_Amount__c=3,
                                                         Message_Code_Host__c = '0000',
                                                         Match_Count__c = 4);
                	// ICBS
                    aaVar3Three = new Applicant_Account__c(Retrieve_Payoff_Response__c = true,
                                                           Applicant_CLV__c = aCLV5.Id, 
                                                           Current_Balance__c = '20000',
                                                           RecordTypeId = APP_Wizard_SearchAndMatch.icbsRTId,
                                                           Account_Number__c='7', 
                                                           Selected_ICBS_Customer_Number__c='1212',
                                                           Account_Open_Date__c=date.today(),
                                                           Account_Type__c='ICBS',
                                                           Credit_Limit_Borrowed_Amount__c='1000',
                                                           Opening_Balance__c = '2000',
                                                           Installment_Amount__c = 500,
                                                           Amount_Financed__c = 999,
                                                           Next_Payment_Amount_Due__c = 600,
                                                           Account_Balance__c='2300',
                                                           Host_System_Identifier__c='ICBS',
                                                           CLV_Match_Indicator__c='123',
                                                           Account_Status__c='Open',
                                                           Retrieved_Payoff_Amount__c=2300,
                                                           RPQ_Charge_Off_Amount__c=3,
                                                           RPQ_Early_Termination_Fee__c=3,
                                                           RPQ_Fees_or_Charges_Due__c=3,
                                                           RPQ_Insurance_Rebate__c=3,
                                                           RPQ_Interest_Due__c=3,
                                                           RPQ_Interest_Rate__c=3,
                                                           RPQ_Late_Fees_Due__c=3,
                                                           RPQ_Penalty_Interest_Due__c=3,
                                                           RPQ_Principal_Amount__c=3,
                                                           Message_Code_Host__c = '0000',
                                                           Match_Count__c = 4);
                                                                          
                    
                    aaList2.add(aaVarMain);
                    aaList2.add(aaVar1One);
                    aaList2.add(aaVar2Two);
                	aaList2.add(aaVar3Three);
                }else if(errNoAcc==true || errFailAcc==true){
                    // Genesis
                    accFailed = new Applicant_Account__c(Product_Type__c='testvisiontype',
                                                         Retrieve_Payoff_Response__c = true,
                                                         Applicant_CLV__c = aCLV4.Id, 
                                                         RecordTypeId = APP_Wizard_SearchAndMatch.genesisRTId,
                                                         Current_Balance__c = '10000', 
                                                         Account_Number__c='4', 
                                                         Selected_ICBS_Customer_Number__c='1212',
                                                         Account_Open_Date__c=date.today(),
                                                         Account_Type__c='Genesis',
                                                         Credit_Limit_Borrowed_Amount__c='1000',
                                                         Opening_Balance__c = '2000',
                                                         Installment_Amount__c = 500,
                                                         Amount_Financed__c = 999,
                                                         Next_Payment_Amount_Due__c = 600,
                                                         Account_Balance__c='101',
                                                         Host_System_Identifier__c='Genesis',
                                                         CLV_Match_Indicator__c='123',
                                                         Account_Status__c='Open',
                                                         Retrieved_Payoff_Amount__c=1000,
                                                         RPQ_Charge_Off_Amount__c=1,
                                                         RPQ_Early_Termination_Fee__c=1,
                                                         RPQ_Fees_or_Charges_Due__c=1,
                                                         RPQ_Insurance_Rebate__c=1,
                                                         RPQ_Interest_Due__c=1,
                                                         RPQ_Interest_Rate__c=1,
                                                         RPQ_Late_Fees_Due__c=1,
                                                         RPQ_Penalty_Interest_Due__c=1,
                                                         RPQ_Principal_Amount__c=1,
                                                         Match_Count__c = 1);
                    if(errNoAcc==true){
                        accFailed.Message_Code_Host__c = '9999';
                        
                    }
                    if(errFailAcc==true){
                        accFailed.Message_Code_Host__c = 'ERCS01';
                    }
                    aaList2.add(accFailed); 
                }
                
                insert aaList2;
                
                if(errNoCLV==false && errFailCLV==false && errNoAcc==false && errFailAcc==false){
                	List<Applicant_Account_Involved_Party__c>aaInvolvePartyList2 = new List<Applicant_Account_Involved_Party__c>();
                
                    Applicant_Account_Involved_Party__c aaITwo = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John1 Smith', 
                                                                                                   Relationship_Type__c='TS1', 
                                                                                                   Customer_Identifier__c = '1516', 
                                                                                                   SolicitFlag__c=true);
                    aaITwo.Applicant_Account__c = aaVar2Two.Id;
                    aaInvolvePartyList2.add(aaITwo);
                    
                    Applicant_Account_Involved_Party__c aaI1Two = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John2 Smith', 
                                                                                                   Relationship_Type__c='TS2', 
                                                                                                   Customer_Identifier__c = '1517', 
                                                                                                   SolicitFlag__c=false);
                    aaI1Two.Applicant_Account__c = aaVar2Two.Id;
                    aaInvolvePartyList2.add(aaI1Two);
                    
                    Applicant_Account_Involved_Party__c aaI2Two = new Applicant_Account_Involved_Party__c(Full_Name__c = 'John3 Smith', 
                                                                                                   Relationship_Type__c='TS3', 
                                                                                                   Customer_Identifier__c = '1518', 
                                                                                                   SolicitFlag__c=true);
                    aaI2Two.Applicant_Account__c = aaVar2Two.Id;
                    aaInvolvePartyList2.add(aaI2Two);
                    
                    insert aaInvolvePartyList2;
                }
            }
    }
    
    
   
}