/* @Description: Controller for APP_Main_PostSubmit (Customer UI)
 * @Author: Mike Lasala
 * @Date Created: MAR-18-2014
 * @History:
   =====================================================================
       03-18-14: Created - Mike
       2015-05-28: TXU - Changed Document Link
   =====================================================================
 */ 
public class APP_Main_PostSubmitExt extends APP_CommonExt{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<Requested_Document__c> requestedDocumentsList   {get;set;}  //Requested documents records
    public List<Related_Document__c>   relatedDoccumentlist     {get;set;}  //Related document records
    public String responseCodeControlType                       {get;set;}  //Value retrieved from Response Code Control custom settings
    public String redirectTo                                    {get;set;}  //Pagereference identifier
    public Brand__c brand                                       {get;set;}  //Variable used for display of brand display name and contact number
    public String applicationId                 				{get;set;}  //application id
    public boolean hasLifeInsurance								{get;set;}
    public boolean hasDisabilityInsurance						{get;set;}
    public boolean hadDocuments									{get;set;}	
    
    public string GETnCurl{get;set;}
    public string KiwiTnCurl{get;set;}
    public string Disclouserurl{get;set;}
    public string repaymentURL{get;set;}
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================
    /*  Description: Main Controller class used for all initializations of common variables
     *  Author: Mike Lasala
     *  Input: None
     *  Return: void
     */
    public APP_Main_PostSubmitExt (ApexPages.StandardController applicationController) { 
        super(applicationController);
		applicationId = this.application.Id;
        commonAuthorizationRequired();
        hasLifeInsurance=false;
        hadDocuments=false;
        hasDisabilityInsurance=false;
        List<Product_Item__c> prodItemList=[select id,Product_Version__r.Product_Name__c from Product_Item__c where Application__c=:this.application.id];
        if(prodItemList!= null){
            if(prodItemList.size()>0){
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c.equals(GEN_OriginationsConstants.LIFE_INSURANCE))hasLifeInsurance = true;
                    if(prod.Product_Version__r.Product_Name__c.equals(GEN_OriginationsConstants.DISABILITY_INSURANCE))hasDisabilityInsurance=true;
                }
            }
        }
        
        map<string,id>docIdmap=new map<string,id>();
        
        for(document d:[select id,DeveloperName from document where DeveloperName IN:GEN_OriginationsConstants.DOCUMENTNAMES]){
        	if(GEN_OriginationsConstants.DOCUMENTNAMES.contains(d.DeveloperName)){
        		docIdmap.put(d.DeveloperName,d.id);
        	}
        }
        
        //Changed document URL
        brand = [SELECT ID, URL_Terms_Conditions__c, URL_PDS_FSG__c, URL_Disclosure_Statement__c, Brand_Display_Name__c, Contact_Number__c FROM Brand__c WHERE Id = :this.application.Brand_Lookup__c LIMIT 1];
        
        if(brand != null){
        	GETnCurl = brand.URL_Terms_Conditions__c;
        	KiwiTnCurl = brand.URL_Terms_Conditions__c;
        	Disclouserurl = brand.URL_Disclosure_Statement__c;
        	repaymentURL = brand.URL_PDS_FSG__c;
        }
        
        /**        
        if(docIdmap.containsKey('GE_terms_and_conditions'))
        	GETnCurl='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('GE_terms_and_conditions')?docIdmap.get('GE_terms_and_conditions'):'');
        
        if(docIdmap.containsKey('Kiwibank_terms_and_conditions'))
        	KiwiTnCurl='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Kiwibank_terms_and_conditions')?docIdmap.get('Kiwibank_terms_and_conditions'):'');
        
        if(docIdmap.containsKey('Disclosure_Statement'))
        	Disclouserurl='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Disclosure_Statement')?docIdmap.get('Disclosure_Statement'):'');
        
        if(docIdmap.containsKey('Repayment_protection_brochure'))
        	repaymentURL='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Repayment_protection_brochure')?docIdmap.get('Repayment_protection_brochure'):'');
        **/
        
        relatedDoccumentlist = new List<Related_Document__c>();
		
		isApplicant1 = true;
		
        if(this.application.Response_Code__c != null){
            //Get Type from Response Code Control custom settings
            try {
                responseCodeControlType = Response_Code_Control__c.getValues(this.application.Response_Code__c).Type__c;
            } catch(Exception e){
                responseCodeControlType = '';
            }

            //Identify if there are requested documents
            requestedDocumentsList = [SELECT    Id,Status__c  
                                      FROM      Requested_Document__c 
                                      WHERE     Application__c =: this.application.Id];
        
System.debug('$$$ requestedDocumentsList: '+requestedDocumentsList);
             if(requestedDocumentsList.size()>0){
	             for(Requested_Document__c rd:requestedDocumentsList){
	             	if(rd.Status__c!=null && !rd.Status__c.equals('Complete')){
	             		hadDocuments=true;
	             		break;
	             	}
	             }
             }
            
            /* try{                 
                APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
                contract.applicationId = application.Id;
                relatedDoccumentlist = contract.getRelDocList(); 
                }
                catch(System.QueryException q)
                {relatedDoccumentlist = new List<Related_Document__c>();}
          
            */
            
        }
        else {
            requestedDocumentsList = new List<Requested_Document__c>();
        }
    }

    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    
    /*  Description: Redirect method
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */      
    public PageReference pageRedirect(){
        PageReference pageRef;
        if(redirectTo == 'logout'){
            //pageRef = new PageReference('/logoutPage');
            pageRef = Page.APP_Logout;
        }
        else if(redirectTo == 'timeout'){
            //pageRef = new PageReference('/customer/APP_Timeout');
            pageRef = Page.APP_Timeout;
        }
        else {
            return null;
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }

    /* Description: Method that performs redirect to customer ui main page if application steps is not yet complete
     * Author: Adrian Recio
     * Date Created: 4-APR-2014
     * Parameter: None
     * Return: PageReference
     */
    public pageReference validateApplicationStatus(){
        PageReference pgRef;
        Boolean isPrimary = false;

        if(application.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){
            List<Applicant__c> primaryApplicant = [SELECT   Id,
                                                            Email_Address__c 
                                                   FROM     Applicant__c 
                                                   WHERE    Application__c =: application.Id 
                                                   AND      Is_Primary_Applicant__c = true];
            
            List<User> uList = [SELECT ID, Email__c, AppId__c FROM User WHERE Email =: UserInfo.getUserEmail()];

            // Filtering done here rather than in SOQL as cannot filter by encrypted field
            for(Applicant__c app : primaryApplicant){
                
                //if(UserInfo.getUserEmail().equals(app.Email_Address__c)){
                //TXU - Contract Acceptance Issue fix. The user default email is not the actual email, which has been
                //moved to Email__c for encryption
                for(User u : uList){                 
                    if(u.Email__c.equals(app.Email_Address__c) && u.appId__c == application.Id){
                        isPrimary = true;
                        break;
                    }
                }
                //}
            }
        }

        if(application.Status__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
            pgRef = Page.APP_Main;
        } else if(application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_ACCEPTED || 
                  application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PENDING_FIA || 
                  (application.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT && 
                    (isPrimary && 
                     application.Is_Accepted_Primary__c && 
                     application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2) ||
                    (!isPrimary && 
                     application.Is_Accepted_Secondary__c && 
                     application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1))){

            pgRef = Page.APP_Complete;
        } else {
            return null;
        }

        pgRef.getParameters().put('Id',application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 06-MAY-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }

    /*  Description: Timeout getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getTimeOut(){
      return AS_TIMEOUT;
    }
    
    /*  Description: Warning getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */ 
    public integer getWarning(){
      return AS_WARNING;
    }
    
    Public Boolean isApplicant1{get;set;}
    
     public PageReference validateApplicantAccess() {

       List<User> currentUser = [SELECT Id,
                                                     Username,
                                                     AppId__c,                                                     
                                                     Password_Reset_Attempts__c,
                                                     Password_Reset_Timestamp__c,
                                                     Brand__c,
                                                     Profile.Name,
                                                     Country__c
                                              FROM   User
                                              WHERE Id = : UserInfo.getUserId() LIMIT 1];

      if(!currentUser.isEmpty()){      
        if(currentUser.get(0).AppId__c != null || currentUser.get(0).AppId__c != ''){
           //login user 
           //If login user is Applicant 1, proceed to Application Main Page
           if(currentUser.get(0).Profile.Name != GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1 && currentUser.get(0).Profile.Name != GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1){
             isApplicant1 = false;
           }
        }   
      }
      return NULL;
    }
    
    /*  Description: Redirect to File Upload page
     *  Author: Devendra
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference goToUpload(){
        PageReference pageRef = Page.APP_CustomerUIFileUpload;
        pageRef.getParameters().put('id', applicationId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    

}