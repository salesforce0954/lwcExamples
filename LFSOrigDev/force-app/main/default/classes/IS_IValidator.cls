/*
Author: Andrew Manetakis (Cloud Sherpas)
Created Date: Dec 18, 2013
Description: Interface for the validators that should be implemented for each web service operation 
*/
public interface IS_IValidator {
	List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO);
}