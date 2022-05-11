public virtual class App_SendSmsTemplate {

     public Application__c app {get;set;}
     public List<Applicant__c> appList{get;set;}
     public Outbound_SMS_Communication__c OSC {get;set;}
     public Application__c application {get;set;}
     Public string selectedApplicant {get;set;}
     public string selectedEmpType {get;set;}
     public string selectedTemplate {get;set;}
     public string content {get;set;}
     public string ownerName {get;set;}
     public string selectedOwner {get;set;}
     
     public string selectDocumentType {get;set;}
     public string documentType {get;set;}
     
     public string additionalDocType {get;set;}
     public string selectedAdditionalDocType {get;set;}
     
     public string emailId {get;set;}
     public string agentMailId {get;set;}
     
     public Boolean deliveryCheck;
     
     public string selectedFrequency {get;set;}
     public string frequency {get;set;}
     
     public string debitedDate {get;set;}
     public String dayValue {get;set;}
     
     public string billerCode {get;set;}
     
     public string refNumber {get;set;}
     public string defaultRef {get;set;}
     
     public string mobileNumber {get;set;}
     
     public string templateSelected {get;set;}
          //public string templateValues {get;set;}

     

 
 public List<String> toEmailAddress =  new List<String>();
 public List<Applicant__c> applicants = new List<Applicant__c>();

   //Constructor
   public App_SendSmsTemplate(ApexPages.StandardController controller){
    app = (Application__c)controller.getRecord();
        try{
                 application = [select id,Application_Type__c,Contract_Account_Number__c,Generated_Doc_Confirm_Sent__c,Brand_Country__c,Response_Code__c,status__c,Brand_String__c from Application__c where id =:app.id];
                 appList = [select id,Name,First_Name__c,Primary_Employment_Status__c,application__r.Brand_String__c,application__r.Contract_Account_Number__c,application__r.Status__c,Application__r.Application_Type__c,Mobile__c,Email_Address__c from Applicant__c where Application__c =: app.id];
            
                 //Object SMS Communication creation
                 
                 OSC = new Outbound_SMS_Communication__c();
                 OSC.Application__c = application.id;
                                                    
                 OSC.Mobile_Number__c = appList[0].Mobile__c;     
                 OSC.Email_Address__c = appList[0].Email_Address__c;
                 OSC.Applicant_First_Name__c = appList[0].First_Name__c;
             
                 if(appList.size() > 1){
                     OSC.Mobile_Number_Applicant_2__c = appList[1].Mobile__c;
                     OSC.Email_Address_Applicant_2__c= appList[1].Email_Address__c;
                     OSC.Applicant_2_First_Name__c = appList[1].First_Name__c;
                 }
    
            }
            catch(Exception e){
                system.debug('Exception '+e);
               }
   }
   
       
       public void insertOSC(){
         OSC.Applicant_Name__c = selectedApplicant;   
         OSC.Template__c =  selectedTemplate;
         OSC.Employment_Type__c = selectedEmpType;
         OSC.Message_Delivered__c = deliveryCheck;
         OSC.Template_Review__c = content;
         OSC.Mobile_Number__c = mobileNumber;
         OSC.Frequency__c = frequency;
         if(templateSelected == 'BPAY' || templateSelected == 'Loan Settled Without DD'){
          OSC.Biller_Code__c = '172023';
          OSC.Reference_number__c = defaultRef + application.Contract_Account_Number__c + refNumber;
         }else{
          OSC.Biller_Code__c = '';
          OSC.Reference_number__c = '';
         }
         if(templateSelected == 'Loan Settled With DD'){
           OSC.DD_date__c = Date.parse(debitedDate);
         }else{
          OSC.DD_date__c = null;
         }
         if(templateSelected == 'Loan Settled Without DD'){
           OSC.Day__c = dayValue;
         }else{
          OSC.Day__c = '';
         }
         upsert OSC;
       }
   
     
   
       Public List<Selectoption> getselectedApplicants(){
                 List <SelectOption > options = new List < SelectOption > ();
                 options.add(new selectOption('', '- None -'));
                for(Applicant__c applicant :[select id,Name,First_Name__c from Applicant__c where Application__c =: app.id]){
                 // options.add(new selectoption(applicant.name,applicant.First_Name__c));
                 options.add(new selectoption(applicant.First_Name__c,applicant.First_Name__c));
                }
                system.debug('Selected Applicant $$$'+ selectedApplicant );
                return options;
       }
            
 
 
       Public List<Selectoption> getSelectEmploymentType(){
          system.debug(' Employment Type AU');
            List<Income__c> incListA1;
            List<Income__c> incListA2;
    
            List <SelectOption > options = new List < SelectOption > ();
            options.add(new selectOption('', '- None -'));
            
            if(appList.size() > 1){
                incListA1 = [select Income_Source__c,Income_Source_Code__c from Income__c where Applicant__c =:appList[0].id];
         
                //Applicant 1
                if(selectedApplicant == appList[0].First_Name__c){
                     for(Income__c inc : incListA1){
                     options.add(new selectoption(inc.Income_Source__c,inc.Income_Source__c));
                     }
                 }
                 
                   incListA2 = [select Income_Source__c,Income_Source_Code__c from Income__c where Applicant__c =:appList[1].id];
         
                 //Applicant 2
                  if(selectedApplicant == appList[1].First_Name__c){
                     for(Income__c inc : incListA2){
                     options.add(new selectoption(inc.Income_Source__c,inc.Income_Source__c));
                     }
                  }  
      }else{
                 incListA1 = [select Income_Source__c,Income_Source_Code__c from Income__c where Applicant__c =:appList[0].id];
             
                     //Applicant 1
                    if(selectedApplicant == appList[0].First_Name__c){
                         for(Income__c inc : incListA1){
                         options.add(new selectoption(inc.Income_Source__c,inc.Income_Source__c));
                         }
                     }
         }
       
            return options;
      }
      
      Public List<Selectoption> getTemplateValues(){
     List <SelectOption> options = new List <SelectOption>();
     options.add(new selectOption('', '- None -'));
     if(application.Status__c == 'Accepted' && application.Brand_Country__c == 'AU'){
                 for (Settled_Templates_AU__c accTemp : Settled_Templates_AU__c.getAll().values()){
                    options.add(new SelectOption(accTemp.Settled_Templates_AU__c,accTemp.Settled_Templates_AU__c));
                  }

                 }    
     if(application.Status__c == 'Closed' && application.Brand_Country__c == 'AU'){
                 for (Closed_Application_Templates__c closedTemp: Closed_Application_Templates__c.getAll().values()){
                    options.add(new SelectOption(closedTemp.Closed_Application_Templates__c,closedTemp.Closed_Application_Templates__c));
                  }
                 }
                 
      if(application.Brand_Country__c == 'AU' && application.Status__c != 'Accepted' && application.Status__c != 'Closed' && application.Response_Code__c != 'PCO'){
                     for (SMS_Templates__c smsTemp : SMS_Templates__c.getAll().values()){
                      options.add(new SelectOption(smsTemp.Full_and_Part_Time__c,smsTemp.Full_and_Part_Time__c));
                     }
                 }
       if(application.Response_Code__c == 'PCO' && application.Generated_Doc_Confirm_Sent__c == false && application.Brand_Country__c == 'AU'){
                 for (SMS_Templates__c smsTemp : SMS_Templates__c.getAll().values()){
                      options.add(new SelectOption(smsTemp.Full_and_Part_Time__c,smsTemp.Full_and_Part_Time__c));
                     }
                 }
       if(application.Response_Code__c == 'PCO' && application.Generated_Doc_Confirm_Sent__c == true && application.Brand_Country__c == 'AU'){
                 for (PCA_Templates__c pcaTemp: PCA_Templates__c.getAll().values()){
                    options.add(new SelectOption(pcaTemp.PCA_Templates__c,pcaTemp.PCA_Templates__c));
                  } 
                 }
                 
                 
                 //Populate NZ Templates 
         if(application.Brand_Country__c == 'NZ'){
             for (Full_Part_Time_NZ__c fpt: Full_Part_Time_NZ__c.getAll().values()){
                  options.add(new SelectOption(fpt.Full_Part_Time_NZ__c,fpt.Full_Part_Time_NZ__c));
             }
         }
                  return options;
    }
            
       public List<SelectOption> getSelectFrequencyAU(){
        List <SelectOption > options = new List < SelectOption > ();
            options.add(new selectOption('', '- None -'));
            options.add(new selectOption('Weekly', 'Weekly'));
            options.add(new selectOption('Monthly', 'Monthly'));
            options.add(new selectOption('Quarterly', 'Quarterly'));
            options.add(new selectOption('Fortnightly', 'Fortnightly'));
            options.add(new selectOption('Yearly', 'Yearly'));
            return options;
            
       } 
       Public List<Selectoption> getSelectEmploymentTypeNZ(){
       system.debug('Enter NZ');
       List <SelectOption > options = new List < SelectOption > ();
            options.add(new selectOption('', '- None -'));
            
            if(selectedApplicant == appList[0].First_Name__c){
                           system.debug('Enter Applicant one');
                           system.debug('Primary Employment Status '+appList[0].Primary_Employment_Status__c);
                  options.add(new selectoption(appList[0].Primary_Employment_Status__c,appList[0].Primary_Employment_Status__c));
               }
               if(appList.size() > 1){
                if(selectedApplicant == appList[1].First_Name__c){
                           system.debug('Enter Applicant Two');
                           system.debug('Primary Employment Status Two'+appList[1].Primary_Employment_Status__c);
                  options.add(new selectoption(appList[1].Primary_Employment_Status__c,appList[1].Primary_Employment_Status__c));
               }
               }
         
       
       return options;
       }      
       
              Public List<Selectoption> getDocumentTypes(){
              List <SelectOption > options = new List < SelectOption > ();
              options.add(new selectOption('', '- None -'));
              if(selectedEmpType == 'My permanent - full time job' || selectedEmpType == 'My permanent - part time job' || selectedEmpType == 'My casual/temporary job')
             {           
                for (Full_Part_Casual_Document_Types__c fpcdt: Full_Part_Casual_Document_Types__c.getAll().values()){
                  options.add(new SelectOption(fpcdt.Value__c,fpcdt.Value__c));
                 }
            
             }else if(selectedEmpType == 'My contracting job')
                {
                      for (Contracting_Document_Types__c cdt: Contracting_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(cdt.Value__c,cdt.Value__c));
                     } 
                }else if(selectedEmpType == 'My self-employed business')
                {     
                     for (Self_Employed_Document_Types__c sedt: Self_Employed_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(sedt.Value__c,sedt.Value__c));
                     } 
                       
                }else if(selectedEmpType == 'My rental property')
                    {
                       for (Rental_Document_Types__c rdt: Rental_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(rdt.Value__c,rdt.Value__c));
                     } 

                    }else if(selectedEmpType == 'My workers compensation'){
                       for (Workers_Compensation_Document_Types__c wcdt: Workers_Compensation_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(wcdt.Value__c,wcdt.Value__c));
                     } 
                       
                    }
                    
                    if(selectedEmpType == 'Full Time' || selectedEmpType == 'Part Time'){
                       for (Full_Part_NZ_Document_Types__c fpndt: Full_Part_NZ_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(fpndt.Value__c,fpndt.Value__c));
                       } 
                       
                    }else if(selectedEmpType == 'Self Employed'){
                       for (Self_Employed_NZ_Document_Types__c sendt: Self_Employed_NZ_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(sendt.Value__c,sendt.Value__c));
                       } 
                      
                    }else 
         if(selectedEmpType == 'Casual' || selectedEmpType == 'Seasonal' || selectedEmpType == 'Temporary'){
                     for (Seasonal_Document_Types__c sdt: Seasonal_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(sdt.Value__c,sdt.Value__c));
                       }                 
         }else if(selectedEmpType == 'Other'){
                     for (Other_Document_Types__c odt: Other_Document_Types__c.getAll().values()){
                          options.add(new SelectOption(odt.Value__c,odt.Value__c));
                       }        
         }else if(selectedEmpType == 'Contract'){
                    for (Contract_NZ_Doc_Types__c cdt: Contract_NZ_Doc_Types__c.getAll().values()){
                          options.add(new SelectOption(cdt.Value__c,cdt.Value__c));
                       }
         }
           
             
              return options;
              }
              
    
    
    
    
    
   
            
     Public List<Selectoption> getSelectTemplate(){
            List <SelectOption > options = new List < SelectOption > ();
            if(application.Brand_Country__c == 'NZ'){
            options.add(new selectOption('', '- None -'));
            }
       
             system.debug('Selected Template  %%$$ '+selectedTemplate);
             system.debug('Template Selected  %%$$ '+templateSelected);
        //Populate AU Templates
        if((selectedEmpType == 'My permanent - full time job' || selectedEmpType == 'My permanent - part time job' ||
           selectedEmpType == 'My contracting job'||  selectedEmpType == 'My self-employed business'||
            selectedEmpType == 'My rental property' || selectedEmpType == 'My casual/temporary job' ||
            selectedEmpType == 'My workers compensation' || selectedApplicant != null) && application.Brand_Country__c == 'AU')
        {       
                 if(application.Status__c != 'Accepted' && application.Status__c != 'Closed' && application.Response_Code__c != 'PCO'){
                     /** for (SMS_Templates__c smsTemp : SMS_Templates__c.getAll().values()){
                      options.add(new SelectOption(smsTemp.Full_and_Part_Time__c,smsTemp.Full_and_Part_Time__c));
                     } */
                     options.add(new SelectOption(templateSelected,templateSelected ));
                 }
                 if(application.Status__c == 'Accepted'){
                /** for (Settled_Templates_AU__c accTemp : Settled_Templates_AU__c.getAll().values()){
                    options.add(new SelectOption(accTemp.Settled_Templates_AU__c,accTemp.Settled_Templates_AU__c));
                  } */
                  options.add(new SelectOption(templateSelected,templateSelected ));
                  
                 }
                 if(application.Status__c == 'Closed'){
                 for (Closed_Application_Templates__c closedTemp: Closed_Application_Templates__c.getAll().values()){
                    options.add(new SelectOption(closedTemp.Closed_Application_Templates__c,closedTemp.Closed_Application_Templates__c));
                  }
                 }
                 if(application.Response_Code__c == 'PCO' && application.Generated_Doc_Confirm_Sent__c == false){
                /** for (PCA_Templates__c pcaTemp: PCA_Templates__c.getAll().values()){
                    options.add(new SelectOption(pcaTemp.PCA_Templates__c,pcaTemp.PCA_Templates__c));
                  } */
                  options.add(new SelectOption(templateSelected,templateSelected ));
                 }
                  if(application.Response_Code__c == 'PCO' && application.Generated_Doc_Confirm_Sent__c == true){
                 for (PCA_Templates__c pcaTemp: PCA_Templates__c.getAll().values()){
                    options.add(new SelectOption(pcaTemp.PCA_Templates__c,pcaTemp.PCA_Templates__c));
                  } 
                 }
        }
      
         //Populate NZ Templates 
         if(selectedEmpType == 'Full Time' || selectedEmpType == 'Part Time' ||
         selectedEmpType == 'Casual' || selectedEmpType == 'Seasonal' || selectedEmpType == 'Temporary' ||
         selectedEmpType == 'Self Employed' || selectedEmpType == 'Other' || selectedEmpType == 'Contract'){
             for (Full_Part_Time_NZ__c fpt: Full_Part_Time_NZ__c.getAll().values()){
                  options.add(new SelectOption(fpt.Full_Part_Time_NZ__c,fpt.Full_Part_Time_NZ__c));
             }
         }
            return options;
       }
     
     Public pageReference getSelectTemplateReview(){
        
        agentMailId = emailId;
        billerCode = '172023';
        defaultRef = '0000000';
     
        selectedOwner = ownerName;
        documentType = selectDocumentType;
        frequency = selectedFrequency;
        
        selectedAdditionalDocType = additionalDocType;
        string adt;
        
        if(selectedAdditionalDocType != null){
        selectedAdditionalDocType = selectedAdditionalDocType.replace(',','\n');
        }
        
            String messageHi = '[Hi]';
            String customerName = '[CustomerName]';
            String lineBreak = 'Break';
            String agentName = '[agentName]';       
            String docType = '[documentType]';
            String additionalDoc = '[additionalDoc]'; 
            String additionalDoc1 = '[additionalDoc1]';   
            String hyphen = '[hyphen]';
            String repHyphen;
            String lineBreak1 = '\n';
            String lineBreak2 = 'n';
            String brand ='[brand]';
            String email = '[EmailId]';
            
          
            String comma = '[comma]';
            String freq = '[frequency]';
            String ddDate = '[ddDate]';
            String ddDay = '[ddDay]';
            
            String biller_code = '[billerCode]';
            String ref_number = '[refNumber]';
            
            String mobile_number = '[mobile]';
            
 
            Brand__c brandVar = [SELECT Id,Name
                             FROM   Brand__c 
                             WHERE  Site__c = :application.Brand_String__c LIMIT 1];
          
          List<Brand_Content__c> bCon;
          
          if(application.Brand_String__c == 'Latitude'){
          
           bCon = [SELECT name,Output_HTML__c 
                                 FROM   Brand_Content__c 
                                 WHERE  Brand__c =: brandVar.id AND Name =:templateSelected]; 
           }else if(application.Brand_String__c == 'Gem' || application.Brand_String__c == 'Kiwibank'){
           
           bCon = [SELECT name,Output_HTML__c 
                                 FROM   Brand_Content__c 
                                 WHERE  Brand__c =: brandVar.id AND Name =:selectedTemplate]; 
           }                      
                                 
        if(selectedApplicant == appList[0].First_Name__c && application.Application_Type__c == 'Single'){
           //content = 'Hi' +appList[0].First_Name__c;
           content = 'Hi';
         }else if(application.Application_Type__c == 'Joint'){
             if(selectedApplicant == appList[0].First_Name__c){
               //content = 'Hi ' +appList[0].First_Name__c;
               content = 'Hi';
             }else{
               //content = 'Hi ' +appList[1].First_Name__c;
               content = 'Hi';
             }
         }
         
         
        
      
        
       for(Brand_Content__c bc: bCon){
           
         
           if(templateSelected == bc.name && application.Brand_String__c == 'Latitude'){                
             content += bc.Output_HTML__c; 
             //content += selectedTime;
             //content += 'Regards '+selectedOwner;
           }else if(selectedTemplate == bc.name && (application.Brand_String__c == 'Gem' || application.Brand_String__c == 'Kiwibank')){                
             content += bc.Output_HTML__c; 
             //content += selectedTime;
             //content += 'Regards '+selectedOwner;
           }
        }
      
       if(selectedApplicant == appList[0].First_Name__c){  
       if(agentMailId != null && (application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank' || application.Brand_String__c == 'Latitude')){ 
        content = content.replace(email,agentMailId);
        }
        content = content.replace(customerName,appList[0].First_Name__c); 
        content = content.replace(brand,application.Brand_String__c);
        content = content.replace(comma,',');
        
        if(frequency != null){
        content = content.replace(freq,frequency); 
        }
        if(debitedDate != null){
        content = content.replace(ddDate,debitedDate);
        }
        if(dayValue != null){
        content = content.replace(ddDay,dayValue);
        }
        if(billerCode != null){
        content = content.replace(biller_code,billerCode);
        }
        if(refNumber != null){
        content = content.replace(ref_number,defaultRef + application.Contract_Account_Number__c + refNumber);
        }
        if(mobileNumber != null){
        content = content.replace(mobile_number,mobileNumber);
        }
       
        
       
        if(documentType != '[]' && application.Status__c != 'Accepted' && application.Status__c != 'Closed'){
            string removeOpenBracket = string.valueOf(documentType).replace('[','');
            documentType= removeOpenBracket.replace(']','');
            documentType = documentType.replace(',',lineBreak1+ '-');
            //content = content.replace(docType,documentType);  
            content = content.replace(docType,'- '+documentType+ '\n');  
            system.debug('Content entered app1 '+content);          
        }else{
            content = content.replace(docType,'');  
            system.debug('Content else app 1'+content);         
        }       
       
        //content = content.replace(additionalDoc,selectedAdditionalDocType); 
       /** if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){ 
        content = content.replace(hyphen,'- '); 
        } */
        if(selectedAdditionalDocType == ''){
           repHyphen = '';
           content = content.replace(hyphen,repHyphen); 
       }else{
           repHyphen = hyphen;
           content = content.replace(repHyphen,'- ');
       } 
       if(selectedAdditionalDocType != null){
         adt = selectedAdditionalDocType.replace(';',lineBreak1 + '- ');
        content = content.replace(additionalDoc,adt +'\n');  
       }
        }
        /**else{
        content = content.replace(customerName,appList[1].First_Name__c);
        }   */
        if(appList.size() > 1){
        if(selectedApplicant == appList[1].First_Name__c){
              if(agentMailId != null  && (application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank' || application.Brand_String__c == 'Latitude')){ 
             content = content.replace(email,agentMailId);
             }
             content = content.replace(customerName,appList[1].First_Name__c); 
             content = content.replace(brand,application.Brand_String__c);
             content = content.replace(comma,',');  
             
             if(frequency != null){
        content = content.replace(freq,frequency); 
        }
        if(debitedDate != null){
        content = content.replace(ddDate,debitedDate);
        }
        if(dayValue != null){
        content = content.replace(ddDay,dayValue);
        }
        if(billerCode != null){
        content = content.replace(biller_code,billerCode);
        }
        if(refNumber != null){
        content = content.replace(ref_number,defaultRef + application.Contract_Account_Number__c + refNumber);
        }
        if(mobileNumber != null){
        content = content.replace(mobile_number,mobileNumber);
        }
        
        
              if(documentType != '[]' && application.Status__c != 'Accepted' && application.Status__c != 'Closed'){
                string removeOpenBracket = string.valueOf(documentType).replace('[','');
                documentType= removeOpenBracket.replace(']','');
                documentType = documentType.replace(',', lineBreak1+ '-');
                //content = content.replace(docType,documentType);   
                content = content.replace(docType,'- '+documentType+ '\n');  
                system.debug('Content entered app2 '+content);               
         }else{
                content = content.replace(docType,'');
              }   
         /**   if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){ 
            content = content.replace(hyphen,'- '); 
            }  */
            if(selectedAdditionalDocType == ''){
               repHyphen = '';
               content = content.replace(hyphen,repHyphen); 
           }else{
               repHyphen = hyphen;
               content = content.replace(repHyphen,'- ');
           } 
            if(selectedAdditionalDocType != null){
             adt = selectedAdditionalDocType.replace(';',lineBreak1 + '- ');
             content = content.replace(additionalDoc,adt +'\n');  
           }
        }
      }  
         
       
        content = content.replace(messageHi,'');
        if(selectedOwner !=null){
        content = content.replace(agentName,selectedOwner);
        }
        
            
        content  =  content.replace('\\[' + lineBreak + ']','\n');  
                          
      return null;
     }
    
            public pageReference save(){
            
                      try{   
                      
                      system.debug('agentMailId  $$'+agentMailId);
                      system.debug('selectedApplicant $$'+selectedApplicant);
                      system.debug('selectedApplicant **'+appList[0].First_Name__c);
                      system.debug('selectedAdditionalDocType $$'+selectedAdditionalDocType);
                      system.debug('documentType $$ ' +documentType);
                      system.debug('selectedTemplate $$'+selectedTemplate );
                      system.debug('selectedOwner $$'+selectedOwner);
                      
                     /** List<String> listofmultipicklisValues= String.valueOf(documentType).split(',');
                      system.debug(listofmultipicklisValues);
                      
                      for(String lmp: listofmultipicklisValues){
                        system.debug('- '+lmp);
                      } */
                      
                      

                       string countryCode = '+61';
                       string getContent;
                       String getMessageId;
                       //Boolean deliveryCheck;
                       
                       if(selectedApplicant == appList[0].First_Name__c){
                               string s1 = appList[0].Mobile__c;
                               String s2 = s1.substringAfter('0');
                                String s3;
                               if(application.Brand_String__c == 'Latitude'){
                               s3 ='+61'+s2; 
                               }else if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){
                               s3 ='+64'+s2;
                               }  
                               if(selectedTemplate != null){
                              getContent = App_SMSContent.getSMSContent(selectedTemplate,appList,selectedApplicant,selectedOwner,documentType,selectedAdditionalDocType,agentMailId,frequency,debitedDate,dayValue,billerCode,refNumber,mobileNumber);
                              }
                               if(application.Brand_String__c == 'Latitude'){                              
                                   
                                 if((templateSelected == 'Loan Settled With DD' && frequency != null && debitedDate != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'TM Remediation' && mobileNumber != '' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Loan Settled Without DD' && dayValue != '' && selectedApplicant != null && selectedTemplate != null && refNumber != '') ||
                                   (templateSelected == 'BPAY' && selectedOwner != '' && refNumber != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'No Response Application is Closed' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   ((templateSelected == 'Missing Documents Request' || templateSelected == 'Document Request') && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'No Response – Will Close in 48 Hours' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Unable to Contact Customer' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null ) ||
                                   (templateSelected == 'Team Email SMS' && agentMailId != '' && mobileNumber != '' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Accepting Contracts' && selectedApplicant != null && selectedTemplate != null) ){                           
                                        
                                            getMessageId = SmsManager.sendMessage(s3,getContent,'Latitude'); 
                                            deliveryCheck = SmsManager.validateSentMessage(getMessageId);
                                            if(deliveryCheck == true){
                                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Message Delivered Successfully'));  
                                               insertOSC();
                                            }else{
                                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered.Please enter the valid Input in "Additional Required Document"'));
                                            }
                                        }

                                       else{
                                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please complete all the required fields.'));
                                       }
                                       } else if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){
                               
                                      if(selectedApplicant != null && selectedEmpType != null && selectedTemplate != null && (agentMailId != '')){                           

                                        getMessageId = SmsManager.sendMessage(s3,getContent,'Latitude'); 
                                        deliveryCheck = SmsManager.validateSentMessage(getMessageId);
                                        if(deliveryCheck == true){
                                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Message Delivered Successfully'));  
                                           insertOSC();
                                        }else{
                                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered.Please enter the valid Input in "Additional Required Document"'));
                                        }
                                       }else{
                                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered'));
                                       } 
                              }                          
                          }
                     
                      if(appList.size() > 1){
                          if(selectedApplicant == appList[1].First_Name__c){
                               string s1 = appList[1].Mobile__c;
                               String s2 = s1.substringAfter('0');
                               String s3;
                               if(application.Brand_String__c == 'Latitude'){
                               s3 ='+61'+s2; 
                               }else if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){
                               s3 ='+64'+s2;
                               }
                               
                        if(selectedTemplate != null){
                          getContent = App_SMSContent.getSMSContent(selectedTemplate,appList,selectedApplicant,selectedOwner,documentType,selectedAdditionalDocType,agentMailId,frequency,debitedDate,dayValue,billerCode,refNumber,mobileNumber);                              
                          }  
                                                         if(application.Brand_String__c == 'Latitude'){                              
                                   
                                 if((templateSelected == 'Loan Settled With DD' && frequency != null && debitedDate != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'TM Remediation' && mobileNumber != '' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Loan Settled Without DD' && dayValue != '' && selectedApplicant != null && selectedTemplate != null && refNumber != '') ||
                                   (templateSelected == 'BPAY'  && selectedOwner != '' && refNumber != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'No Response Application is Closed' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   ((templateSelected == 'Missing Documents Request' || templateSelected == 'Document Request') && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'No Response – Will Close in 48 Hours' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Unable to Contact Customer' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null ) ||
                                   (templateSelected == 'Team Email SMS' && agentMailId != '' && mobileNumber != '' && selectedOwner != '' && selectedApplicant != null && selectedTemplate != null) ||
                                   (templateSelected == 'Accepting Contracts' && selectedApplicant != null && selectedTemplate != null)){                           
                                        
                                            getMessageId = SmsManager.sendMessage(s3,getContent,'Latitude'); 
                                            deliveryCheck = SmsManager.validateSentMessage(getMessageId);
                                            if(deliveryCheck == true){
                                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Message Delivered Successfully'));  
                                               insertOSC();
                                            }else{
                                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered.Please enter the valid Input in "Additional Required Document"'));
                                            }
                                        }

                                       else{
                                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please complete all the required fields.'));
                                       }
                                       } else if(application.Brand_String__c == 'GEM' || application.Brand_String__c == 'Kiwibank'){                      
                                   if(selectedApplicant != null && selectedEmpType != null  && selectedTemplate != null && (agentMailId != '')){
                              
                                        getMessageId = SmsManager.sendMessage(s3,getContent,'Latitude'); 
                                        deliveryCheck = SmsManager.validateSentMessage(getMessageId);
                                        system.debug('Delivery Check $$'+ deliveryCheck);
                                        if(deliveryCheck == true){
                                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Message Delivered Successfully'));
                                           insertOSC();  
                                        }else{
                                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered.Please enter the valid Input in "Additional Required Document"'));
                                        }
                                       }else{
                                          //insertOSC();
                                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Message Not Delivered'));
                                       }  
                               }              
                          }
                      }
                      
                      if(deliveryCheck == true){
                        FeedItem post = new FeedItem();
                        post.ParentId = app.Id;
                        post.type = 'LinkPost';
                        post.LinkUrl = '/'+OSC.Id;                        
                        post.Title = [Select name from Outbound_SMS_Communication__c Where id =: OSC.Id].Name + ' Created and the SMS Template is SMS - '+OSC.Template__c;
                        
                        if(appList.size() > 1){
                          if(OSC.Applicant_Name__c == appList[1].First_Name__c){
                             post.Title = [Select name from Outbound_SMS_Communication__c Where id =: OSC.Id].Name + ' Created and the SMS Template is SMS - '+OSC.Template__c;
                           }else if(OSC.Applicant_Name__c == appList[0].First_Name__c){
                            post.Title = [Select name from Outbound_SMS_Communication__c Where id =: OSC.Id].Name + ' Created and the SMS Template is SMS - '+OSC.Template__c;
                           }
                      } 
                     
                        insert post; 
                       } 
                     }catch(Exception e){
                       System.debug('Exception' +e);
                     }
                      return null;
            }
             public pageReference refresh(){
             return null;
             }
            
}