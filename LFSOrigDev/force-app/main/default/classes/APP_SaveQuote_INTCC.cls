public with sharing class APP_SaveQuote_INTCC{

    @testvisible 
    public transient String saveQuoteReasonStr{get;set;}
    public String quoteComment{get;set;}
    Public Application__c app {get; set;}
    Public boolean errorFlag {get;set;}
    public Id applicationId;

   public APP_SaveQuote_INTCC(){
        try{            
          
            errorFlag =false;
            applicationId = ApexPages.currentPage().getParameters().get('id');
            app = [select Id, save_quote_comments__c,sub_Status__c
                   from
                  Application__c 
                  where 
                  Id =: applicationId];
                  
                                
            if (app.sub_Status__c <> null){
                 saveQuoteReasonStr = app.sub_Status__c;
             }
            
            if (app.save_quote_comments__c <> null){
                quoteComment = app.save_quote_comments__c;
             }
          
        }catch(Exception e){            
            //exception log
            system.debug('**EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'APP_SaveQuote_INTCC()', 'APP_SaveQuote_INTCC', 'Class', String.valueOf(applicationId));
            Util.addMessage(ApexPages.Severity.ERROR, 'There has been an error, please notify your administrator');
        }
  
    }
    
     
   public List<SelectOption> saveReason{              
       get{
            List<SelectOption> options = new List<SelectOption>(); 
            options.add(new SelectOption('null', 'Please select'));
          system.debug('Checking$$$ '+app.sub_Status__c);            
            if(app.sub_Status__c == null){
                
               options.add(new SelectOption('1. Not Interested', '1. Not Interested'));
                options.add(new SelectOption('2. More time requested', '2. More time requested'));
               }
               else{
               options.add(new SelectOption('3.Followed up – more time requested', '3.Followed up – more time requested'));
                options.add(new SelectOption('4. Not Interested - to close', '4. Not Interested - to close'));               
               }
            return options;
        }
        set;   
   }
   
    public PageReference cancel(){    
        PageReference pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('Id',applicationId);
        pageRef.setRedirect(true);
        return pageRef;        
    }
    
    
     public PageReference save(){ 
     
         Application__c application;
         try{
                 application = [select Id, save_quote_comments__c,Response_Code__c,sub_Status__c 
                                from 
                                Application__c 
                                where 
                                Id =: applicationId];
                
                Boolean saveTask = true;
                
                if(saveQuoteReasonStr=='null' || saveQuoteReasonStr==''){

                    Util.addMessage(ApexPages.Severity.ERROR, 'Please choose a save quote reason');
                    saveTask = false;
                    errorFlag = true;
                    
                }
                if(quoteComment=='' || quoteComment==null){

                    Util.addMessage(ApexPages.Severity.ERROR, 'Please enter comment');
                    saveTask = false;
                    errorFlag = true;
                    
                }
                if(saveTask){
                   
                    application.save_quote_comments__c=quoteComment;
                    application.sub_Status__c = saveQuoteReasonStr;
                    application.Out_Of_Sync__c= true;
                   
                    update application;
                    
                        if (application.sub_Status__c== '4. Not Interested - to close' && application.Response_Code__c!='New'){
                             
                                    PageReference pageRef = Page.APP_CancelApplication_INT;
                                    pageRef.getParameters().put('id', String.valueOf(applicationId));
                                    pageRef.setRedirect(true);
                                    return pageRef;
                
                            }
                                                                    
                   }
                   return null;
                    
              } 
             catch(Exception e) {
                 system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
                ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'save()', 'APP_SaveQuote_INTCC', 'Class', String.valueOf(applicationId));
                Util.addMessage(ApexPages.Severity.ERROR, 'There has been an error, please notify your administrator');
             }
        return null;
    }
     
     
     public pagereference CallUpdatebService(){
             
             Application__c application;
             application = [select Id,sub_Status__c from Application__c where Id=: applicationId]; 
        
        if(application.sub_Status__c <> null && application.sub_Status__c <> '4. Not Interested - to close'){
              
                     List<IS_ValidationError> validationErrors = IS_ApplicationUpdate.applicationUpdateRequest(applicationId,Util.getUser().Mock_Enable__c,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                     if(validationErrors.size()>0) {
                         
                          for(IS_ValidationError i: validationErrors){
                            Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
                            
                           }
                                        
                         return null;
                      }
                      else{
                        PageReference pageRef = Page.APP_ApplicationMain_INT;
                        pageRef.getParameters().put('Id',applicationId);
                        pageRef.setRedirect(true);
                        return pageRef;
                       
                      }              
                 
               }
               else 
                 {
                     return null;
                 }
     
     }
 
     public pagereference clearProp(){ 
         saveQuoteReasonStr =null;
          errorFlag =false;
         return null;
    }
 }