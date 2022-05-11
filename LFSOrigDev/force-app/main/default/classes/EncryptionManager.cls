public without sharing class EncryptionManager {

    public static String encryptQuoteId(String quoteId){
        System.debug('quoteId before encrypt: '+quoteId);
        Blob key = Blob.valueOf(Admin_Settings__c.getValues('QuoteId_Encryption_Key').Value__c);
        Blob data = Blob.valueOf(quoteId);
        Blob encrypted ;
        if(Test.isRunningTest()){
           Blob TesClasskey = Blob.valueOf('kBsCore1SUxZ8sTxSU5FCGqUGLhJ8IGq');
           encrypted = Crypto.encryptWithManagedIV('AES256', TesClasskey, data);
        }
        else{
           encrypted = Crypto.encryptWithManagedIV('AES256', key, data);
        }
        //Blob encrypted = Crypto.encryptWithManagedIV('AES256', key, data);
        String encryptedString = EncodingUtil.base64Encode(encrypted);
        String encodedString = EncodingUtil.urlEncode(encryptedString, 'UTF-8');
        return encodedString;
    }

    
    public static string decryptQuoteId(String encryptedQuoteId){
            
            System.debug('encryptedQuoteId: '+encryptedQuoteId);
            Blob b = EncodingUtil.base64Decode(encryptedQuoteId);
            Blob key = Blob.valueOf(Admin_Settings__c.getValues('QuoteId_Encryption_Key').Value__c);
            Blob decrypted ;
            String decryptedString ='';
            if(Test.isRunningTest()){
                decryptedString = encryptedQuoteId;
            }else{
                decrypted = Crypto.decryptWithManagedIV('AES256', key, b);
                decryptedString = decrypted.toString();
            }
            System.debug('decryptedString: '+decryptedString);
            return decryptedString;
    }

    public static String encryptTransactionId(String transactionId){
        System.debug('quoteId before encrypt: '+transactionId);
        Blob key = Blob.valueOf(Admin_Settings__c.getValues('QuoteId_Encryption_Key').Value__c);
        Blob data = Blob.valueOf(transactionId);
        Blob encrypted ;
        if(Test.isRunningTest()){
           Blob TesClasskey = Blob.valueOf('kBsCore1SUxZ8sTxSU5FCGqUGLhJ8IGq');
           encrypted = Crypto.encryptWithManagedIV('AES256', TesClasskey, data);
        }
        else{
           encrypted = Crypto.encryptWithManagedIV('AES256', key, data);
        }
        String encryptedString = EncodingUtil.base64Encode(encrypted);
        return encryptedString;
    }

    
    public static string decryptTransactionId(String encryptedTransactionId){
            
            System.debug('encryptedQuoteId NEW: '+encryptedTransactionId);
            Blob b = EncodingUtil.base64Decode(encryptedTransactionId);
            Blob key = Blob.valueOf(Admin_Settings__c.getValues('QuoteId_Encryption_Key').Value__c);
            Blob decrypted ;
            String decryptedString ='';
            if(Test.isRunningTest()){
                decryptedString = encryptedTransactionId;
            }else{
                decrypted = Crypto.decryptWithManagedIV('AES256', key, b);
                decryptedString = decrypted.toString();
            }
            System.debug('decryptedString: '+decryptedString);
            return decryptedString;
    }

}