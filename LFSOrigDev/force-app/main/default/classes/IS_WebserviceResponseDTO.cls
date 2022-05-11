/*
Author: Dan Crisologo
Created Date: MAR-21-2014
Description: Wrapper to allow return for webservice response data
*/
public class IS_WebserviceResponseDTO {

    public String messageCode {get; set;}
    public String messageDescription {get; set;}

    public IS_WebserviceResponseDTO() {

    }
    
    public IS_WebserviceResponseDTO(String messageCode, String messageDescription) {
        this.messageCode = messageCode;
        this.messageDescription = messageDescription;
    }

}