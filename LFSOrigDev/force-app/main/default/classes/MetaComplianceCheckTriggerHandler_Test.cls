@isTest
public class MetaComplianceCheckTriggerHandler_Test {

    static testMethod void validateNotNullStartEndDate_Test(){
                
        Meta_Compliance_Check__c testMetaComplianceCheck = TestDataBuilder.createMetaComplianceCheck();
        insert testMetaComplianceCheck;

        Test.StartTest();
        Meta_Compliance_Check__c testMetaComplianceCheckOverlap = TestDataBuilder.createMetaComplianceCheck();
        
        try{
            insert testMetaComplianceCheckOverlap;
        } catch (DmlException e){
            Boolean isError;
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(Apexpages.Message msg:msgs){
                if(msg.getDetail().contains('The start and end dates of the meta compliance check that you are about to insert / update will overlap on an existing record')){
                    isError = true;
                }
            }
            System.assertEquals(true, isError);
        }
        Test.StopTest();
    }

    static testMethod void validateNullEndDate_Test(){
                
        Meta_Compliance_Check__c testMetaComplianceCheck = TestDataBuilder.createMetaComplianceCheck();
        testMetaComplianceCheck.End_Date__c = null;
        insert testMetaComplianceCheck;

        Test.StartTest();
        Meta_Compliance_Check__c testMetaComplianceCheckOverlap = TestDataBuilder.createMetaComplianceCheck();

        try{
            insert testMetaComplianceCheckOverlap;
        } catch (DmlException e){
            Boolean isError;
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(Apexpages.Message msg:msgs){
                if(msg.getDetail().contains('The start date of the meta compliance check that you are about to insert / update will overlap on an existing record with Start Date')){
                    isError = true;
                }
            }
            System.assertEquals(true, isError);
        }
        Test.StopTest();
    }

    static testMethod void validateNullStartDate_Test(){
                
        Meta_Compliance_Check__c testMetaComplianceCheck = TestDataBuilder.createMetaComplianceCheck();
        testMetaComplianceCheck.Start_Date__c = null;
        insert testMetaComplianceCheck;

        Test.StartTest();
        Meta_Compliance_Check__c testMetaComplianceCheckOverlap = TestDataBuilder.createMetaComplianceCheck();
        
        try{
            insert testMetaComplianceCheckOverlap;
        } catch (DmlException e){
            Boolean isError;
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(Apexpages.Message msg:msgs){
                if(msg.getDetail().contains('The end date of the meta compliance check that you are about to insert / update will overlap on an existing record with End Date')){
                    isError = true;
                }
            }
            System.assertEquals(true, isError);
        }
        Test.StopTest();
    }

    static testMethod void validateNullStartEndDate_Test(){
                
        Meta_Compliance_Check__c testMetaComplianceCheck = TestDataBuilder.createMetaComplianceCheck();
        testMetaComplianceCheck.Start_Date__c = null;
        testMetaComplianceCheck.End_Date__c = null;
        insert testMetaComplianceCheck;

        Test.StartTest();
        Meta_Compliance_Check__c testMetaComplianceCheckOverlap = TestDataBuilder.createMetaComplianceCheck();
        
        try{
            insert testMetaComplianceCheckOverlap;
        } catch (DmlException e){
            Boolean isError;
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(Apexpages.Message msg:msgs){
                if(msg.getDetail().contains('You can only have empty start and end dates if there is only one meta compliance check')){
                    isError = true;
                }
            }
            System.assertEquals(true, isError);
        }
        Test.StopTest();
    }
}