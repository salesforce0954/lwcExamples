public with Sharing Class AccountOpenerTrainingCls{

    public Account_Opener_Training__c acOpTr {get; set;}
    public Boolean showGOSection{get; set;}
    public Boolean showGEMSection{get; set;}
    public String cardVal {get; set;}
    
    public List<SelectOption> getgoQ1() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$25','$25')); 
        options.add(new SelectOption('$35','$35')); 
        options.add(new SelectOption('$59','$59'));
        return options;         
    }

    public List<SelectOption> getgoQ2() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('21.74%','21.74%')); 
        options.add(new SelectOption('22.99%','22.99%')); 
        options.add(new SelectOption('29.49%','29.49%'));
        return options;         
    }    

    public List<SelectOption> getgoQ3() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('29.49%','29.49%'));
        options.add(new SelectOption('21.74%','21.74%')); 
        options.add(new SelectOption('22.99%','22.99%')); 
        return options;         
    }
        
    public List<SelectOption> getgoQ4() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('outstanding balance only','outstanding balance only'));
        options.add(new SelectOption('original purchase price only','original purchase price only')); 
        return options;         
    }    

    public List<SelectOption> getgoQ5() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$99','$99'));
        options.add(new SelectOption('$25','$25')); 
        options.add(new SelectOption('$0','$0')); 
        return options;         
    }                

    public List<SelectOption> getgoQ6() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$2.95','$2.95'));
        options.add(new SelectOption('$4.95','$4.95')); 
        options.add(new SelectOption('$5.95','$5.95')); 
        return options;         
    }    
    
    public List<SelectOption> getgoQ7() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Refer to the key information sheet','Refer to the key information sheet'));
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        options.add(new SelectOption('Call GE to confirm amount','Call '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' to confirm amount'));
        options.add(new SelectOption('Tell the customer you are not sure and contact your GE account manager','Tell the customer you are not sure and contact your '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' account manager')); 
        options.add(new SelectOption('all of the above','all of the above')); 
        return options;         
    }    
    public List<SelectOption> getgoQ8() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process','Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process')); 
        options.add(new SelectOption('No','No')); 
        return options;         
    }      
        
    public List<SelectOption> getgemQ1(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$0','$0')); 
        options.add(new SelectOption('$25','$25')); 
        options.add(new SelectOption('$50','$50'));
        return options;      
    }

    public List<SelectOption> getgemQ2(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('True','True')); 
        options.add(new SelectOption('False','False')); 
        return options;      
    }
       
    public List<SelectOption> getgemQ3(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('outstanding balance only','outstanding balance only')); 
        options.add(new SelectOption('original Purchase price only','original Purchase price only')); 
        return options;      
    }
 
     public List<SelectOption> getgemQ4(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$99','$99')); 
        options.add(new SelectOption('$59','$59')); 
        options.add(new SelectOption('$69','$69')); 
        return options;      
    }   

     public List<SelectOption> getgemQ5(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('$0','$0')); 
        options.add(new SelectOption('$3.95','$3.95')); 
        options.add(new SelectOption('$4.95','$4.95')); 
        return options;      
    }   
 
     public List<SelectOption> getgemQ6(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Refer to the key information sheet','Refer to the key information sheet')); 
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        options.add(new SelectOption('Call GE to confirm amount, Tell customer You are not sure and contact your GE account manager','Call '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' to confirm amount, Tell customer You are not sure and contact your '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' account manager')); 
        options.add(new SelectOption('all of the above','all of the above')); 
        return options;      
    }

     public List<SelectOption> getgemQ7(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process','Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process')); 
        options.add(new SelectOption('No','No')); 
        return options;      
    }   
    
                        
    public AccountOpenerTrainingCls(ApexPages.StandardController controller) {
        
        SalesforceUrl__c urlParam = SalesforceUrl__c.getOrgDefaults();
        String browserURL = ApexPages.currentPage().getParameters().get(urlParam.Account_Opener_Training_Param__c); 
        String ownerId = [Select ownerId from Account where id=:browserURL Limit 1].ownerId;
        System.debug('browserURL1==>'+browserURL);
        this.acOpTr = new Account_Opener_Training__c();
        this.acOpTr.Account__c = browserURL;
        this.acOpTr.Account_Manager__c = ownerId;
        this.showGOSection = false;
        this.showGEMSection = false;
    }

    public void showHideGoGemSection(){
        
        if(cardVal.equals('GO')){
            this.showGOSection = true;
            this.showGEMSection = false;
        }else if(cardVal.equals('GEM')){
            this.showGOSection = false;
            this.showGEMSection = true;
        }else{
            this.showGOSection = false;
            this.showGEMSection = false;        
        }
    }

    public PageReference save(){
        
        System.debug('Checking==>'+this.acOpTr);
        List<Account_Opener_Training__c> tempAcOpTr = new List<Account_Opener_Training__c>();
        
        if(this.showGOSection){
            if( isNullEmptyCheck(this.acOpTr.Go_Q1__c) || isNullEmptyCheck(this.acOpTr.Go_Q2__c) || isNullEmptyCheck(this.acOpTr.Go_Q3__c)
                || isNullEmptyCheck(this.acOpTr.GO_Q4__c) || isNullEmptyCheck(this.acOpTr.GO_Q5__c) ||
                isNullEmptyCheck(this.acOpTr.GO_Q6__c) || isNullEmptyCheck(this.acOpTr.GO_Q7__c)
                || isNullEmptyCheck(this.acOpTr.GO_Q8__c)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:Please Complete all questions in Step 2.');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                    
        }else if(this.showGEMSection){
            if(isNullEmptyCheck(this.acOpTr.GEM_Q1__c) || isNullEmptyCheck(this.acOpTr.GEM_Q2__c) || isNullEmptyCheck(this.acOpTr.GEM_Q3__c) 
                || isNullEmptyCheck(this.acOpTr.GEM_Q4__c) || isNullEmptyCheck(this.acOpTr.GEM_Q5__c) ||
                isNullEmptyCheck(this.acOpTr.GEM_Q6__c) && isNullEmptyCheck(this.acOpTr.GEM_Q7__c)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:Please Complete all questions in Step 2.');
                    ApexPages.addMessage(myMsg);
                    return null;                
                }
        }
        
        try{
        if(this.showGOSection){
            if((this.acOpTr.Go_Q1__c=='$25' && this.acOpTr.Go_Q2__c=='21.74%' && this.acOpTr.Go_Q3__c=='29.49%' 
                && this.acOpTr.GO_Q4__c=='outstanding balance only' && this.acOpTr.GO_Q5__c=='$0' &&
                this.acOpTr.GO_Q6__c=='$4.95' && this.acOpTr.GO_Q7__c == 'all of the above'
                && this.acOpTr.GO_Q8__c == 'Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application process')){
                    this.acOpTr.Name = [Select Name from Account where id =: this.acOpTr.Account__c].Name +'  ' + this.acOpTr.Card__c;
                    this.acOpTr.Status__c='Passed';
                    tempAcOpTr.add(this.acOpTr);
                }else{
                    this.acOpTr.Name = [Select Name from Account where id =: this.acOpTr.Account__c].Name + '  ' +  this.acOpTr.Card__c;                
                    this.acOpTr.Status__c='Failed';
                    tempAcOpTr.add(this.acOpTr);                
                }
        }else if(this.showGEMSection){
            if(this.acOpTr.GEM_Q1__c=='$0' && this.acOpTr.GEM_Q2__c=='True' && this.acOpTr.GEM_Q3__c=='outstanding balance only' 
                && this.acOpTr.GEM_Q4__c=='$99' && this.acOpTr.GEM_Q5__c=='$0' &&
                this.acOpTr.GEM_Q6__c=='all of the above' && this.acOpTr.GEM_Q7__c=='Yes, but only if the customer nominates their credit limit to be the same as their purchase price during the application Process'){
                    this.acOpTr.Name = [Select Name from Account where id =: this.acOpTr.Account__c].Name + '  ' +  this.acOpTr.Card__c;
                    this.acOpTr.Status__c='Passed';
                    tempAcOpTr.add(this.acOpTr);
                }else{
                    this.acOpTr.Name = [Select Name from Account where id =: this.acOpTr.Account__c].Name + '  ' +  this.acOpTr.Card__c;
                    this.acOpTr.Status__c='Failed';
                    tempAcOpTr.add(this.acOpTr);                
                }        
        }
        }Catch(Exception e){System.debug(e.getMessage());}
        
        insert(tempAcOpTr);

        String url = SalesforceUrl__c.getInstance().Link__c;
        
        PageReference acctPage = new PageReference(url + '/' +this.acOpTr.Account__c);
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    private Boolean isNullEmptyCheck(String var){
         
         if(var!=null && var!=''){
             return false;        
         }else return true;  
    
    }
    
    public PageReference Cancel(){

        String url = SalesforceUrl__c.getInstance().Link__c;
        PageReference acctPage = new PageReference(url + '/' +this.acOpTr.Account__c);
        acctPage.setRedirect(true);
        return acctPage;    
    }

}