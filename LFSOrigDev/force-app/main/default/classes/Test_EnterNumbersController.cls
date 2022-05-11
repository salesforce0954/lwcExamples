@isTest
public class Test_EnterNumbersController{
    static TestMethod void testAccountValidation(){
        Test.startTest();
        List<Account> accs = TestingUtils.CreateAccount(5);
        accs[0].Phone = '61234567891';
        accs[0].Fax= '61234567891';
        accs[0].BillingCountry = 'NZL';
        insert accs;
        
        Test.setCurrentPage(Page.EnterPhoneNumbers);        
        ApexPages.currentPage().getParameters().put('id',accs[0].id);
        
        EnterNumbersController controller = new EnterNumbersController();
        
        system.assertequals(true,controller.getIsValidationApplicable());
        system.assertequals(null,controller.save());
       
        system.assertequals('61234567891',[SELECT Phone,id from Account where id=:accs[0].id].Phone);
        system.assertequals('61234567891',[SELECT Fax,id from Account where id=:accs[0].id].Fax);
        
       Test.stopTest();
    }
    static TestMethod void testContactValidation(){
        Test.startTest();
        List<Contact> cons = TestingUtils.createContacts(5);
        cons[0].Phone = '61234567898';
        cons[0].Fax= '+61234567898';
        cons[0].MobilePhone= '0123456789';
        cons[0].OtherPhone= '13007123456';
        cons[0].AssistantPhone= '18005123456';
        cons[0].MailingCountry = 'NZL';
        insert cons;
        
        Test.setCurrentPage(Page.EnterPhoneNumbers);        
        ApexPages.currentPage().getParameters().put('id',cons[0].id);
        
        EnterNumbersController controller = new EnterNumbersController();
        
        system.assertequals(true,controller.getIsValidationApplicable());
        system.assertequals(null,controller.save());
        
        //system.assertequals('61234567892',[SELECT Phone,id from Contact where id=:cons[0].id].Phone);
        //system.assertequals('+61234567892',[SELECT Fax,id from Contact where id=:cons[0].id].Fax);
        //system.assertequals('0123456782',[SELECT MobilePhone,id from Contact where id=:cons[0].id].MobilePhone);
       // system.assertequals('13007123452',[SELECT OtherPhone,id from Contact where id=:cons[0].id].OtherPhone);
       // system.assertequals('18005123452',[SELECT AssistantPhone,id from Contact where id=:cons[0].id].AssistantPhone);
        
       Test.stopTest();
    }
    static TestMethod void testValidationNegativeOne(){
        Test.startTest();
           
        List<Account> accs = TestingUtils.CreateAccount(2);
        insert accs;
        
        Test.setCurrentPage(Page.EnterPhoneNumbers);        
        ApexPages.currentPage().getParameters().put('id',accs[0].id);
        
        //EnterNumbersController controller = new EnterNumbersController();
        //delete accs[0];
        //system.assertequals(null,controller.save());
 
       Test.stopTest();
    }
    static TestMethod void testValidationNegativeTwo(){
        Test.startTest();
        Profile prf = [Select id from profile where name='~ Consumer (Accreditation AUS)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User usr = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,prf.Id,role1.Id);
        insert usr;
        
        Test.setCurrentPage(Page.EnterPhoneNumbers);        
        ApexPages.currentPage().getParameters().put('id',usr.id);
        
        EnterNumbersController controller = new EnterNumbersController();
        system.assertequals(false,controller.getIsValidationApplicable());
        
       Test.stopTest();
    }
}