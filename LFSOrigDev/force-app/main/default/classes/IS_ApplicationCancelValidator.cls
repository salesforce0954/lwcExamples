/*
Author: Dan Crisologo
Created Date: 01-14-14
Description: Represents Application Cancel data validation error performed before a web service callout is made
*/
public with sharing class IS_ApplicationCancelValidator extends IS_AbstractCommonValidator implements IS_IValidator{

  public IS_ApplicationCancelValidator() {
  }

  public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
    List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

    //perform validations here

    return validationErrors; 
  }
}