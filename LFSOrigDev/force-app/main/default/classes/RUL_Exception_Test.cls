@isTest
private class RUL_Exception_Test {
    
    @isTest static void test_method_one() {
        RUL_ErrorBaseException r1 = new RUL_ErrorBaseException();
        RUL_ErrorDataException r2 = new RUL_ErrorDataException();
        RUL_ErrorLogicException r3 = new RUL_ErrorLogicException();
    }
    
}