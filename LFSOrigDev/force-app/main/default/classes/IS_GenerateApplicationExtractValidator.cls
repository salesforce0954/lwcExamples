/**
 * @Description: Validator class for generate app extract service
 * @Author: Dan Crisologo
 * @Date Created: MAR-17-2014
 * @History:
   =====================================================================
       03-17-13: Created.
   =====================================================================
 */ 
public with sharing class IS_GenerateApplicationExtractValidator extends IS_AbstractCommonValidator implements IS_IValidator{

  public IS_GenerateApplicationExtractValidator() {
  
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

    //perform validations here
    
    return validationErrors; 
  }
}