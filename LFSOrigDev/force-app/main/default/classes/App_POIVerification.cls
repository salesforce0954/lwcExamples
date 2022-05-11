public class App_POIVerification extends APP_CommonExt{
 
 Application__c app;
 public List<Applicant__c> appList{get;set;}
 public List<Verify_POI_Check__c> vpc {get;set;}
 public integer sizeA1 {get;set;}
 public integer sizeA2 {get;set;}
 public Application__c applicationList {get;set;}
 public Verify_POI_Check__c vpc1;
 public Verify_POI_Check__c vpc2;
 
 
 public App_POIVerification(ApexPages.StandardController controller){
   vpc = new List<Verify_POI_Check__c>();
   app = (Application__c)controller.getRecord();
   //appFields = [select Credit_Score__c,Total_Net_Debt_Amount__c from Application__c where id =: app.id ];
  // vpc.Application__c = app.id;
  
  try{
        applicationList= [select isPOIVerified__c,EVerifier_Alert_Applicant_1__c,EVerifier_Alert_Applicant_2__c from Application__c where id =:app.id];
        appList = [select isPOIVerified__c,isAlertVerified__c,application__r.EVerifier_Alert_Applicant_1__c,application__r.EVerifier_Alert_Applicant_2__c from Applicant__c where Application__c =:app.id];
       vpc1 = new Verify_POI_Check__c();  
       vpc1.applicant__c = appList[0].id;
       vpc1.application__c  = app.id;
       if(appList.size()>1){
       vpc2 = new Verify_POI_Check__c();  
       vpc2.applicant__c = appList[1].id;
       vpc2.application__c = app.id;
       }
       
       vpc.add(vpc1);
       if(appList.size()>1){
       vpc.add(vpc2);
       }
   }catch(Exception e){}
   for(Applicant__c applicant : appList){
   
   if(applicant.Application__r.EVerifier_Alert_Applicant_1__c != null){
    string[] resDec;
    string b = applicant.Application__r.EVerifier_Alert_Applicant_1__c;
    resDec = b.split(';');
    system.debug(resDec);
    system.debug('Res Dec'+resDec.size());
    sizeA1 = resDec.size();     
    }
     if(applicant.Application__r.EVerifier_Alert_Applicant_2__c != null){
    string[] resDecA2;
    string b1 = applicant.Application__r.EVerifier_Alert_Applicant_2__c;
    resDecA2 = b1.split(';');
    system.debug(resDecA2);
    system.debug('Res Dec'+resDecA2.size());
    sizeA2 = resDecA2.size();
    }   
    
   }       
   
 }
 
 public List < SelectOption > getAlertTypeOne() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', 'Please Select'));
        options.add(new SelectOption('Validated','Validated'));
        options.add(new SelectOption('Not Validated','Not Validated'));
        return options;
    }     
 

 public PageReference saveSingle() {

      try {
        //upsert vpc[0]; 
        insert vpc[0];  
             
      
        //
         FeedItem post = new FeedItem();
        post.ParentId = app.Id;
        post.type = 'LinkPost';
        post.LinkUrl = '/'+vpc[0].Id; 
        post.Title = [Select name,Comments__c from Verify_POI_Check__c Where id =: vpc[0].Id].Name + ' Applicant 1 created';
        insert post;        
       
          
               
       // addressSearch = '';
      }
      
      catch(DMLException de) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,de.getDMLMessage(0)); 
           ApexPages.addMessage(myMsg);
           return NULL;  
      }
     catch(Exception e1) {
         Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e1.getMessage()));
       return NULL;
     }
      
      try{
      //Single
         for(Applicant__c applicant : appList){
      if(applicant.Application__r.EVerifier_Alert_Applicant_1__c != null){
        if(sizeA1!=null && sizeA1 <2){
          if(vpc[0].Alert_Type_One__c == 'Validated'){
             appList[0].isPOIVerified__c = true;
             appList[0].isAlertVerified__c = false;
          }else{
             appList[0].isPOIVerified__c = false;
             appList[0].isAlertVerified__c = true;
          }
      
        }else if(sizeA1!=null && sizeA1 >1 && sizeA1 <3){
            if(vpc[0].Alert_Type_One__c == 'Validated' && vpc[0].Alert_Type_Two__c == 'Validated'){
              appList[0].isPOIVerified__c = true;
              appList[0].isAlertVerified__c = false;
            }else{
            appList[0].isPOIVerified__c = false;
            appList[0].isAlertVerified__c = true;
            }
        } else if(sizeA1!=null && sizeA1 > 2){
           if(vpc[0].Alert_Type_One__c == 'Validated' && vpc[0].Alert_Type_Two__c == 'Validated' && vpc[0].Alert_Type_Three__c == 'Validated'){
              appList[0].isPOIVerified__c = true;
            appList[0].isAlertVerified__c = false;
            }else{
            appList[0].isPOIVerified__c = false;
            appList[0].isAlertVerified__c = true;
            }
        }
        }
        }
       
        //DML Operation
        update appList;
        }catch(Exception e){
        }
            
      return NULL;
    }
    
    
    //Insert Verify POI Check for Applicant 2
     public PageReference saveJoint() {

      try {
        //upsert vpc[1];   
        insert vpc[1];     
      
        //
        FeedItem post = new FeedItem();
        post.ParentId = app.Id;
        post.type = 'LinkPost';
        post.LinkUrl = '/'+vpc[1].Id; 
        post.Title = [Select name,Comments__c from Verify_POI_Check__c Where id =: vpc[1].Id].Name + ' Applicant 2 created';
        insert post; 
       // vpc = new Verify_POI_Check__c();         
       // addressSearch = '';
      }
    
     catch(DMLException de) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,de.getDMLMessage(0)); 
           ApexPages.addMessage(myMsg);
           return NULL;  
      }
      catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e.getMessage()));
            return NULL;
        } 
       
      
      try{
      
       //Joint
              if(appList.size() >1){
                     
        
        //Applicant 2
                        for(Applicant__c applicant : appList){
               if(applicant.Application__r.EVerifier_Alert_Applicant_2__c != null){
                if(sizeA2!=null && sizeA2 <2){
                  if(vpc[1].Alert_Type_One__c == 'Validated'){
                     appList[1].isPOIVerified__c = true;
                     appList[1].isAlertVerified__c = false;
                  }else{
                  appList[1].isPOIVerified__c = false;
                  appList[1].isAlertVerified__c = true;
                  }
              
                }else if(sizeA2!=null && sizeA2 >1 && sizeA2 <3){
                    if(vpc[1].Alert_Type_One__c == 'Validated' && vpc[1].Alert_Type_Two__c == 'Validated'){
                      appList[1].isPOIVerified__c = true;
                      appList[1].isAlertVerified__c = false;
                    }else{
                    appList[1].isPOIVerified__c = false;
                    appList[1].isAlertVerified__c = true;
                    }
                } else if(sizeA2!=null && sizeA2 > 2){
                   if(vpc[1].Alert_Type_One__c == 'Validated' && vpc[1].Alert_Type_Two__c == 'Validated' && vpc[1].Alert_Type_Three__c == 'Validated'){
                      appList[1].isPOIVerified__c = true;
                      appList[1].isAlertVerified__c = false;
                    }else{
                    appList[1].isPOIVerified__c = false;
                    appList[1].isAlertVerified__c = true;
                    }
                }
                }
                }
        }
        //DML Operation
        update appList;
        }catch(Exception e){
        }
        
      
     return NULL;
    }
    
    }