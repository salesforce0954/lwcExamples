@isTest
private class CheckABZBankReferredClsTest {
   static testMethod void CheckOnloadtest() {
        List<Account> testAcctList = TestingUtils.CreateAccount(1);
        Integer ctr = 1;
        for(Account a : testAcctList)
        {
          a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
          ctr++;
        }
        insert testAcctList;
        TestingUtils.clear_execution_flags();


        ApexPages.StandardController sc = new ApexPages.standardController(testAcctList[0]);
        test.StartTest();
        CheckABZBankReferredCls accExt = new CheckABZBankReferredCls(sc);
        accExt.CheckOnload();
        test.StopTest();
        System.assertEquals(accExt.acct, testAcctList[0]);
        System.assertNotEquals(accExt.acct, testAcctList[1]);
        system.debug('*******'+accExt.acct);
        system.debug('%%%%%%'+testAcctList[0]);
        utils.get_apex_profile();
    }
}