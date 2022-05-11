/*
Author: Tony Xu
Created Date: 2015-03-02
Description: Represents generate payoff figure validation error performed before a web service callout is made DBHZL386
*/

public with sharing class IS_GeneratePayoffFigureValidator extends IS_AbstractCommonValidator implements IS_IValidator{
	
	public IS_GeneratePayoffFigureValidator(){
		
	}
	
	public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
		List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

	    //perform validations here
	
	    return validationErrors; 
	}
	
	

}