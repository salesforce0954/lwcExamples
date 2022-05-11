/*
Author: Fel Saliba
Created Date: 02-11-2014
Description: Represents Confirm Contract Received data validation error performed before a web service callout is made
*/
public with sharing class IS_ConfirmContractReceivedValidator extends IS_AbstractCommonValidator implements IS_IValidator{

  public IS_ConfirmContractReceivedValidator() {
  
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

    //NO VALIDATION SHOULD BE REQUIRED FOR THIS BACKGROUND WEB SERVICE CALL

    //THERE IS NO HANDLING OF THESE ERRORS
    
    return validationErrors; 
  }
}