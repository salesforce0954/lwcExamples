@isTest
private class CustomExceptionTest{
   
   public static testMethod void testOpportunityTest8(){
       CustomException customeExceptionINstance = new CustomException();
       customeExceptionInstance.demoMethod(); 
        String msg = 'throwing a custom exception';
        try{
            throw new CustomException(msg);
        }catch(CustomException ex){
            System.assertequals(msg, ex.getMessage());
        }
        utils.get_apex_profile();
    }
}