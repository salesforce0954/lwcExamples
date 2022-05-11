/**
 * Test methods for StringUtil class.
 */
@IsTest
private class TestStringUtil {
    /**
     * Test the joinList method.
     */
    testmethod static void testJoinList() {
        test.startTest();
        System.assertEquals('', StringUtil.joinList('', null));
        
        List<String> values = new List<String> { 'a', 'b', 'c' };
        System.assertEquals('a,b,c', StringUtil.joinList(',', values));
        test.stopTest();
        utils.get_apex_profile();
    }
    
    /**
     * Test the isNull method with various combinations of null and non-null string values and
     * ensure that a null string is never returned.
     */
    testmethod static void testIsNull() {
        test.startTest();
        System.assertEquals('', StringUtil.isNull(null));
        System.assertEquals('', StringUtil.isNull(null, null));
        System.assertEquals('Test', StringUtil.isNull('Test'));
        System.assertEquals('Test', StringUtil.isNull(null, 'Test'));
        System.assertEquals('', StringUtil.isNull('', 'Test'));
        test.stopTest();
        utils.get_apex_profile();
    }
    /**
     * Test StatNum method with various combinations values and
     * ensure that respective values returned.
     */
    testmethod static void testStatNum() {
        test.startTest();
        System.assertEquals(0,StringUtil.statNum('Review Started'));
        System.assertEquals(1,StringUtil.statNum('Lodged with Credit'));
        System.assertEquals(2,StringUtil.statNum('Accepted by Credit'));
        System.assertEquals(3,StringUtil.statNum('Approved'));
        System.assertEquals(4,StringUtil.statNum('Declined'));
        System.assertEquals(5,StringUtil.statNum('Letter of Offer Issued'));
        System.assertEquals(6,StringUtil.statNum('Request Received by Docs Team'));
        System.assertEquals(7,StringUtil.statNum('Docs Issued'));
        System.assertEquals(8,StringUtil.statNum('Docs Returned'));
        System.assertEquals(9,StringUtil.statNum('Funded/Operational'));
        System.assertEquals(10,StringUtil.statNum('Lost')); 
        test.stopTest();
        utils.get_apex_profile();
    }        
}