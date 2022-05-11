public with sharing class SmsManager {
    
    /**
     * Name: sendMessage
     * Description: Send a message to a specific mobile number. Returns the Message Id after the message has been queued for delivery.
     */
    public static String sendMessage(String mobileNumber, String message, String sourceNumber){
        System.debug('message: '+message);
        String messageId='';
        String endPoint = Admin_Settings__c.getValues('MessageMedia_Endpoint').Value__c;
        String token = Admin_Settings__c.getValues('MessageMedia_Token').Value__c;
        System.debug('endPoint: '+endPoint);
        System.debug('token: '+token);
        String b64String =  EncodingUtil.base64Encode(Blob.valueOf(token));
        String authorizationHeader = 'Basic ' + b64String;
        String reqBody = '{"messages": [{"content":'+ '"'+message+'","destination_number":'+'"'+mobileNumber+'","delivery_report": true,"format": "SMS","source_number":'+'"'+sourceNumber+'","source_number_type":"ALPHANUMERIC","metadata": {"Product": "PL"}}]}';
        System.debug('reqBody: '+reqBody);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(reqBody);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('response code: '+response.getStatusCode());
        System.debug('response body: '+response.getBody());
        if(response.getStatusCode() == 202){
             //get the message Id
             JSONParser parser = JSON.createParser(response.getBody());
             while (parser.nextToken() != null) {
                 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                 (parser.getText() == 'message_id')){
                     parser.nextToken();
                     messageId = parser.getText();                     
                 }
             }
        }else{
            messageId = GEN_OriginationsConstants.ERROR_STATUS;
        }
        system.debug('Message ID $$$ '+messageId);
        return messageId;
    }

    /**
     * Name: sendBulkMessage
     * Description: Send a bulk message to a list of numbers. Returns collection of Message Id after the message has been queued for delivery.
     */    
    public static String sendBulkMessage(List<BulkSMSWrapper> listBSW){
        String endPoint = Admin_Settings__c.getValues('MessageMedia_Endpoint').Value__c;
        String token = Admin_Settings__c.getValues('MessageMedia_Token').Value__c;

        System.debug('Size: '+listBSW.size());
        String b64String =  EncodingUtil.base64Encode(Blob.valueOf(token));
        String authorizationHeader = 'Basic ' + b64String;
        String reqBody = '{"messages": '+JSON.serialize(listBSW)+'}';
        System.debug('reqBody: '+reqBody);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(reqBody);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('response code: '+response.getStatusCode());
        System.debug('response body: '+response.getBody());
        String messageId = '';
        if(response.getStatusCode() == 202){
             //get the message Id
             JSONParser parser = JSON.createParser(response.getBody());
             while (parser.nextToken() != null) {
                 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                 (parser.getText() == 'message_id')){
                     parser.nextToken();
                     messageId = parser.getText();                     
                 }
             }
        }else{
            messageId = GEN_OriginationsConstants.ERROR_STATUS;
        }
        system.debug('Message ID $$$ '+messageId);
        return messageId;
    } 

    /**
     * Name: validateSentMessage
     * Description: Check if the message has been delivered to the intended mobile number. 
     */
    public static Boolean validateSentMessage(String messageId){
        Boolean isMessageDelivered = false;
        String endPoint = Admin_Settings__c.getValues('MessageMedia_Endpoint').Value__c+'/'+messageId;
        String token = Admin_Settings__c.getValues('MessageMedia_Token').Value__c;
        String b64String =  EncodingUtil.base64Encode(Blob.valueOf(token));
        String authorizationHeader = 'Basic ' + b64String;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('RESPONSE STATUS VALIDATION: '+response.getStatusCode());
        if(response.getStatusCode() == 200){
            //check if the status is delivered
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'status')){
                    parser.nextToken();
                    System.debug('VALIDATION STATUS: '+parser.getText());
                    if(parser.getText().equalsIgnoreCase('Delivered') || parser.getText().equalsIgnoreCase('Processed') || parser.getText().equalsIgnoreCase('Enroute')){
                        isMessageDelivered = true;
                    }
                }
            }
            
        }
        return isMessageDelivered;
    }

    public class BulkSMSWrapper {
        public String content {get;set;}
        public String destination_number {get;set;}
        private Boolean delivery_report; 
        private String format;
        public String source_number{get;set;}
        private String source_number_type;
        private SMSMetadataWrapper metadata;

        public BulkSMSWrapper() {
            this.delivery_report = true;
            this.format = 'SMS';
            this.source_number_type = 'ALPHANUMERIC';
            this.metadata = new SMSMetadataWrapper();
            this.metadata.Product = 'PL';
        }
    }

    public class SMSMetadataWrapper {
        public String Product{get;set;}
    }
}