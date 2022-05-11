/*
Author: Dan Crisologo
Created Date: Dec 19, 2013
Description: Represents customer search data validation error performed before a web service callout is made
*/
public with sharing class IS_CustomerSearchValidator extends IS_AbstractCommonValidator implements IS_IValidator{

  public IS_CustomerSearchValidator() {
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

    //perform validations here

    return validationErrors; 
  }
}