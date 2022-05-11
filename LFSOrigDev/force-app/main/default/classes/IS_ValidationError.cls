/*
Author: Andrew Manetakis (Cloud Sherpas)
Created Date: Dec 18, 2013
Description: Represents a data validation error performed before a web service callout is made
*/
global with sharing class IS_ValidationError {
    global String functionName;
    global String errorDescription;
    global IS_ValidationError(String functionName, String errorDescription) {
        this.functionName = functionName;
        this.errorDescription = errorDescription;
    }
}