public class App_SMSContent extends App_SendSmsTemplate{
         
         public boolean fullAndPartTime {get;set;}
         
         public App_SMSContent(ApexPages.standardController sc){     
                super(sc);
        }
         
         public static string getSMSContent(string template,List<Applicant__c> appList,string applicant,string ownerName,string documentType,string additionalDocumentType,string agentMailAddress,string interval,string debitDate,string debitDay,string billrCode,string referenceNum,string mobNumber){
            String htmlBody = '';
            Brand__c brandVar;
            string siteName;
            string repHyphen;
            
            billrCode = '172023';
            String defaultReferenceNum = '0000000';
            
            String messageHi = '[Hi]';
            String customerName = '[CustomerName]';
            String lineBreak = '[Break]'; 
            String lineBreak1 = 'n';            
            String agentName = '[agentName]';          
            String comma = '[comma]';
            String docType = '[documentType]';
            String additionalDoc = '[additionalDoc]'; 
            String hyphen = '[hyphen]'; 
            String email = '[EmailId]'; 
            List<Brand_Content__c> bCon;
            String brand ='[brand]';
            
            String freq = '[frequency]';
            String ddDate = '[ddDate]';
            String ddDay = '[ddDay]';
            
            String biller_code = '[billerCode]';
            String ref_number = '[refNumber]';
            
            String mobile_number = '[mobile]';
            
            String status;
            String contractNumber;
            
            
            for(Applicant__c app: appList){
               siteName = app.application__r.Brand_String__c;
               status = app.application__r.Status__c;
               contractNumber = app.application__r.Contract_Account_Number__c;
               
               }            
         
           system.debug('Site Name $$' + siteName);
           brandVar = [SELECT Id,Name
                             FROM   Brand__c 
                             WHERE  Site__c = :siteName  LIMIT 1];
               system.debug('Brand Name'+brandVar.name);  
               
         bCon = [SELECT name,Output_HTML__c 
                                 FROM   Brand_Content__c 
                                 WHERE  Brand__c =: brandVar.id AND Name =:template]; 
         
            
                      
            system.debug('Applicant Selected  $$' + applicant);
            system.debug('Template Selected $$' + template);
    
       for(Brand_Content__c bc: bCon){     
           if(template == bc.name){                
              htmlBody = String.valueOf(bc.Output_HTML__c);                        
           }
           
        }                 if(applicant == appList[0].First_Name__c){  
                             system.debug('Site Name $$ '+siteName);
                             if(siteName != null){
                             htmlBody = htmlBody.replace(brand,siteName);
                             }
                             if(siteName == 'GEM' || siteName == 'Kiwibank' || siteName == 'Latitude'){
                             htmlBody = htmlBody.replace(email,agentMailAddress);
                             }
                             htmlBody = htmlBody.replace(customerName,appList[0].First_Name__c); 
                            
                             htmlBody =  htmlBody.replace(comma,',');     
                             htmlBody =  htmlBody.replace(lineBreak,'n');
                             string adt;                         
                             htmlBody =  htmlBody.replace(messageHi,'Hi');
                             htmlBody  = htmlBody.replace(agentName,ownerName);
                             system.debug('Document Type 1 $ '+documentType);
                             system.debug('Status $$ '+status);
                             if(documentType != '[]' && status!='Accepted' && status!='Closed') {                                 
                                  documentType = documentType.replace('\n','\\' + lineBreak1);
                                 //htmlBody  = htmlBody.replace(docType,documentType);
                                 htmlBody  = htmlBody.replace(docType,'- '+documentType+ '\\' + lineBreak1);
                             }else{
                                 htmlBody= htmlBody.replace(docType,'');    
                                  system.debug('SMS Content app 1 else '+htmlBody);   
                             }
                             if(additionalDocumentType == ''){
                               htmlBody  = htmlBody.replace(hyphen,' ');
                               }else{
                               htmlBody  = htmlBody.replace(hyphen,'- ');
                               }                        
                        
                            if(additionalDocumentType != null){
                             adt = additionalDocumentType.replace(';','\\' + lineBreak1 + '- ');
                             htmlBody  = htmlBody.replace(additionalDoc,adt + '\\' + lineBreak1);
                             }
                             
                             if(interval != null){
                                htmlBody = htmlBody.replace(freq,interval); 
                                }
                                if(debitDate != null){
                                htmlBody = htmlBody.replace(ddDate,debitDate);
                                }
                                if(debitDay != null){
                                htmlBody = htmlBody.replace(ddDay,debitDay);
                                }
                                if(billrCode != null){
                                htmlBody = htmlBody.replace(biller_code,billrCode);
                                }
                                if(referenceNum != null){
                                htmlBody = htmlBody.replace(ref_number,defaultReferenceNum + contractNumber + referenceNum);
                                }
                                if(mobNumber != null){
                                htmlBody = htmlBody.replace(mobile_number,mobNumber);
                                }
                         }
                         
                         if(appList.size() > 1){
                                     if(applicant == appList[1].First_Name__c){  
                                     system.debug('Site Name $$ '+siteName);
                                 if(siteName!= null){
                                 htmlBody = htmlBody.replace(brand,siteName);
                                 }
                                  if(siteName == 'GEM' || siteName == 'Kiwibank' || siteName == 'Latitude'){
                                 htmlBody = htmlBody.replace(email,agentMailAddress);
                                 }
                                 htmlBody = htmlBody.replace(customerName,appList[1].First_Name__c); 
                                
                                 htmlBody =  htmlBody.replace(comma,',');     
                                 htmlBody =  htmlBody.replace(lineBreak,'n');
                                 string adt;                         
                                 htmlBody =  htmlBody.replace(messageHi,'Hi');
                                 htmlBody  = htmlBody.replace(agentName,ownerName);
                                 
                                 if(documentType != '[]' && status!='Accepted' && status!='Closed'){
                                 documentType = documentType.replace('\n','\\' + lineBreak1);                                
                                 //htmlBody  = htmlBody.replace(docType,documentType);
                                 htmlBody  = htmlBody.replace(docType,'- '+documentType+ '\\' + lineBreak1);
                                 }else{
                                 htmlBody= htmlBody.replace(docType,'');    
                                  system.debug('SMS Content app 2 else '+htmlBody);   
                                 }
                                 if(additionalDocumentType == ''){
                                   htmlBody  = htmlBody.replace(hyphen,' ');
                                   }else{
                                   htmlBody  = htmlBody.replace(hyphen,'- ');
                                   }                        
                            
                                if(additionalDocumentType != null){
                                 adt = additionalDocumentType.replace(';','\\' + lineBreak1 + '- ');
                                 htmlBody  = htmlBody.replace(additionalDoc,adt + '\\' + lineBreak1);
                                 }
                                 
                                 if(interval != null){
                                htmlBody = htmlBody.replace(freq,interval); 
                                }
                                if(debitDate != null){
                                htmlBody = htmlBody.replace(ddDate,debitDate);
                                }
                                if(debitDay != null){
                                htmlBody = htmlBody.replace(ddDay,debitDay);
                                }
                                if(billrCode != null){
                                htmlBody = htmlBody.replace(biller_code,billrCode);
                                }
                                if(referenceNum != null){
                                htmlBody = htmlBody.replace(ref_number,defaultReferenceNum + contractNumber + referenceNum);
                                }
                                if(mobNumber != null){
                                htmlBody = htmlBody.replace(mobile_number,mobNumber);
                                }
                                
                             }
                         }
                       
            return htmlBody;
        
       }
 }