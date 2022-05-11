/**
 * @Description: Controller class for clientPaymentDetails Lightning Web Component
 * @Author: William Putra - VISEO Asia PTE Ltd
 * @Date Created: 30/07/2021
 * @History:
   =====================================================================
       30-07-21: Created - William Putra
   =====================================================================
 */

public with sharing class ClientPaymentDetailsController {
    @AuraEnabled
    public static ClientPaymentDetailsWrapper loadClientPaymentDetailsData(String applicationId){
        try {
            ClientPaymentDetailsWrapper cdw = new ClientPaymentDetailsWrapper();
            Map<String, Schema.RecordTypeInfo> mapDebitRecordType = getMapDebitRecordTypeByDeveloperName();
            String ddRecordTypeId = mapDebitRecordType.get('Direct_Debit').getRecordTypeId();       
            
            Map<String, Schema.RecordTypeInfo> mapCreditRecordType = getMapDisbursementRecordTypeByDeveloperName();
            String dcRecordTypeId = mapCreditRecordType.get('Direct_Credit').getRecordTypeId();            

            //Direct Debit
            List<Debit__c> directDebit = [SELECT ID, Account_Holders__c, BSB_Number__c, Account_Number__c, Frequency__c, Commencement_Date__c, Bank_Name__c, Branch_Location__c
                                    FROM Debit__c
                                    WHERE Application__c = :applicationId AND RecordTypeId = :ddRecordTypeId
                                    LIMIT 1];
            cdw.directDebit = null;
            if(directDebit.size() > 0) {
                cdw.directDebit = directDebit[0];
            }

            //Direct Credit
            List<Disbursement__c> directCredit = [SELECT ID, Payee__c, BSB__c, Bank_Acc_No__c, Fin_Institution__c, Branch__c
                                            FROM Disbursement__c
                                            WHERE Application__c = :applicationId AND RecordTypeId = :dcRecordTypeId
                                            LIMIT 1];
            cdw.directCredit = null;
            if(directCredit.size() > 0) {
                cdw.directCredit = directCredit[0];
            }     
            
            //Other debit
            List<Debit__c> othDebit = [SELECT ID from Debit__c WHERE Application__c =: applicationId AND RecordType.Name != 'Direct Debit'];
            cdw.otherDebit = false;
            if(othDebit.size() > 0) {
                cdw.otherDebit = true;
            }

            //Other credit
            List<Disbursement__c> othCredit = [SELECT ID from Disbursement__c WHERE Application__c =: applicationId AND RecordType.Name != 'Direct Credit' AND RecordType.Name != 'Broker Fee EFT'];
            cdw.otherCredit = false;
            if(othCredit.size() > 0) {
                cdw.otherCredit = true;
            }

            //Loan Amount
            Application__c application = [SELECT ID, Total_Loan_Amount__c, EMI_with_Service_Fee__c  FROM Application__c WHERE ID = :applicationId LIMIT 1];
            cdw.loanAmount = application.Total_Loan_Amount__c;

            //get frequency picklist
            Schema.SObjectType s = Schema.getGlobalDescribe().get('Debit__c') ;
            Schema.DescribeSObjectResult r = s.getDescribe() ;
            Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
            Schema.DescribeFieldResult fieldResult = fields.get('Frequency__c').getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                cdw.mapFrequencyPicklist.put(pickListVal.getLabel(),pickListVal.getValue());
                System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            }                          

            //get list of BSB that has 6 digit
            cdw.listBSB = [SELECT Name from BSB__c];

            return cdw;
        } catch (Exception e) {
            System.debug('DEBUG ERROR '+e.getMessage() +' '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ClientPaymentDetailsWrapper insertDirectDebit(String applicationId, 
                                                                String accountName,
                                                                String bsb,
                                                                String accountNumber,
                                                                String bankName,
                                                                String branchLocation,
                                                                String frequencyOfDirectDebit,
                                                                String preferredStartDate){
        try {
            System.debug(applicationId);
            //get record type
            Map<String, Schema.RecordTypeInfo> mapDebitRecordType = getMapDebitRecordTypeByDeveloperName();
            String recordTypeId = mapDebitRecordType.get('Direct_Debit').getRecordTypeId();

            List<String> dateSplit = preferredStartDate.split('/');

            Application__c application = [SELECT ID, EMI_with_Service_Fee__c FROM Application__c WHERE ID = :applicationId]; 

            Debit__c directDebit = new Debit__c();
            directDebit.Account_Holders__c = accountName;
            directDebit.BSB_Number__c = bsb;
            directDebit.Account_Number__c = accountNumber;
            directDebit.Bank_Name__c = bankName;
            directDebit.Branch_Location__c = branchLocation;
            directDebit.Frequency__c = frequencyOfDirectDebit;
            directDebit.Commencement_Date__c = Date.newInstance(Integer.valueOf(dateSplit[2]), Integer.valueOf(dateSplit[1]), Integer.valueOf(dateSplit[0]));
            directDebit.RecordTypeId = recordTypeId;
            directDebit.Application__c = applicationId;
            directDebit.Repayment_Level__c = 'Minimum';
            System.debug(directDebit.Frequency__c);
            System.debug(application.EMI_with_Service_Fee__c);
            System.debug(directDebit.Specify_Higher_Amount__c);          
            insert directDebit; 

            ClientPaymentDetailsWrapper cdw = new ClientPaymentDetailsWrapper();
            cdw.directDebit = directDebit;
            return cdw;
        } catch (Exception e) {
            System.debug('DEBUG ERROR '+e.getMessage() +' '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ClientPaymentDetailsWrapper insertDirectCredit(Id applicationId, 
                                                                String accountName,
                                                                String bsb,
                                                                String accountNumber,
                                                                String bankName,
                                                                String branchLocation){
        try {
            //get record type
            Map<String, Schema.RecordTypeInfo> mapCreditRecordType = getMapDisbursementRecordTypeByDeveloperName();
            String recordTypeId = mapCreditRecordType.get('Direct_Credit').getRecordTypeId();

            Application__c application = [SELECT ID, Total_Loan_Amount__c  FROM Application__c WHERE ID = :applicationId LIMIT 1];            
            
            Disbursement__c directCredit = new Disbursement__c();
            directCredit.Account_Holders__c = accountName;
            directCredit.Payee__c = accountName;
            directCredit.Amount__c = application.Total_Loan_Amount__c;
            directCredit.BSB__c = bsb;
            directCredit.Bank_Acc_No__c = accountNumber;
            directCredit.Fin_Institution__c = bankName;
            directCredit.Branch__c = branchLocation;
            directCredit.RecordTypeId = recordTypeId;
            directCredit.Application__c = applicationId;
            insert directCredit; 

            ClientPaymentDetailsWrapper cdw = new ClientPaymentDetailsWrapper();
            cdw.directCredit = directCredit;
            return cdw;            
        } catch (Exception e) {
            System.debug('DEBUG ERROR '+e.getMessage() +' '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }    

    private static Map<String, Schema.RecordTypeInfo> getMapDebitRecordTypeByDeveloperName() {
        Schema.DescribeSObjectResult R = Debit__c.SObjectType.getDescribe();
        return R.getRecordTypeInfosByDeveloperName();     
    }  

    private static Map<String, Schema.RecordTypeInfo> getMapDisbursementRecordTypeByDeveloperName() {
        Schema.DescribeSObjectResult R = Disbursement__c.SObjectType.getDescribe();
        return R.getRecordTypeInfosByDeveloperName();     
    }      

    public class ClientPaymentDetailsWrapper {
        @AuraEnabled public Debit__c directDebit {get;set;}
        @AuraEnabled public Disbursement__c directCredit {get;set;}
        @AuraEnabled public Map<String, String> mapFrequencyPicklist{get;set;}
        @AuraEnabled public Boolean otherDebit{get; set;}
        @AuraEnabled public Boolean otherCredit{get; set;}        
        @AuraEnabled public List<BSB__c> listBSB{get;set;}
        @AuraEnabled public Decimal loanAmount{get;set;}
        
        public ClientPaymentDetailsWrapper() {
            mapFrequencyPicklist = new Map<String, String>();
            listBSB = new List<BSB__c>();
        }
    }
}