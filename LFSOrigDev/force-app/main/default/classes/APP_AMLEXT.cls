/* @Description: Controller for AML (Staff UI)
 * @Author: Fel Saliba
 * @Date Created: DEC-16-2013
 * @History:
   =====================================================================
       DEC-16-2013: Created - Fel
       JAN-09-2014: Added update of Has AML field on Applicant - Mike
       FEB-10-2014: Added perspecsys validation - Mike
       FEB-14-2014: Added Issue Date must be less than or equal to today's date validation - Jade
       23-SEPT-2015: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */ 
public class APP_AMLEXT extends APP_CommonExt {
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public MyBudgetsAMLWrapper aml1 {get;set;}
    public MyBudgetsAMLWrapper aml2 {get;set;}
    public MyBudgetsAMLWrapper aml3 {get;set;}

    public Boolean errorVerificationMethod {get;set;}
    public Boolean errorVerificationType {get;set;}
    
    public String errorVerificationMethodMsg {get;set;}
    public String errorVerificationTypeMsg {get;set;}

    public String appId;
    public Applicant__c applicnt {get;set;}
    public Boolean isAml2Exposed {get;set;}
    public String country {get;set;}
    
    public List<AML__c> amlOld;
    public List<AML__c> upsertAML;
    public List<AML__c> deleteAML;

    //NZ applicable variables
    public Boolean isNZ {get;set;}
    public Boolean poaOnly {get;set;}
    public MyBudgetsAMLWrapper poa {get;set;}

    public Boolean isOutstanding {get;set;}
    public Boolean isValid {get;set;}      //MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT 
    
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Constructor used for all initializations
     *  Author: Fel Saliba
     *  Date Created: DEC-16-2013
     *  Input: None
     *  Return: void
     */
   
    public APP_AMLEXT(ApexPages.StandardController applicationController) {
        super(applicationController);
        
        isOutstanding = isSystemReasonCode(GEN_OriginationsConstants.STRING_AML);

        isNZ = false;
        poaOnly = false;
        
        if(brand.Country__c == GEN_OriginationsConstants.NZ_REGION){
            isNZ = true;
            country = GEN_OriginationsConstants.AML_COUNTRY_NZ;
        } else {
            country = GEN_OriginationsConstants.AML_COUNTRY_AU;
        }

        appId = ApexPages.CurrentPage().getParameters().get('aid');
        
        if(this.applicant.Id == appId){
            applicnt = this.applicant;
        } else if(this.applicantList.size()>1 && this.applicant2.Id == appId){
            applicnt = this.applicant2;
        }
        
        upsertAML = new List<AML__c>();
        deleteAML = new List<AML__c>();
        Integer preSubmitRecordCounter = 0;
        Integer postSubmitRecordCounter = 0;

        //get old AML records
        amlOld = new List<AML__c>();
        amlOld = GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.AML__c.FieldSets.AML_Commons.getFields(), 'AML__c', 'Id_Sequence_No__c != null AND Applicant__c', appId);

        if(isNZ){
            //Identify whether Full AML or POA
            if(applicnt.Verification_Method__c == GEN_OriginationsConstants.POA){
                poaOnly = true;
            }
            
            try{
                //Retrieve POA AML record
                AML__c existingPOA = [SELECT    Id, POA_Type__c, POA_Reference_Number__c, POA_Issue_Date__c, 
                                                ID_Issue_Date__c, ID_Issuer__c, PRS_RECORD_ID__c
                                      FROM      AML__c 
                                      WHERE     Applicant__c =: appId
                                      AND       POA_Type__c != null LIMIT 1];

                //Assign record to wrapper if it exists
                if(existingPOA != null){
                    poa = new MyBudgetsAMLWrapper(existingPOA);
                }
            } catch(QueryException e){
                //Instantiate new wrapper for POA if it doesn't exist yet
                poa = new MyBudgetsAMLWrapper(applicnt);
            }
        }
           
        //check if old AML record exists
        if(!amlOld.isEmpty()){
            
            for(AML__c a: amlOld){

                if(isNZ){

                    if(a.Id_Sequence_No__c == 0){
                        
                        preSubmitRecordCounter++;
                        
                        if(a.Identification__c != GEN_OriginationsConstants.AML_IDENTIFICATION_TYPE_SUPERGOLD){
                            aml1 = new MyBudgetsAMLWrapper(a);
                        } else {
                            aml2 = new MyBudgetsAMLWrapper(a);
                        }
                    }

                } else {
                    
                    postSubmitRecordCounter++;
                    
                    if(a.Id_Sequence_No__c == 1){
                        aml1 = new MyBudgetsAMLWrapper(a);
                    }

                    if(a.Id_Sequence_No__c == 2){
                        aml2 = new MyBudgetsAMLWrapper(a);
                    }

                    if(a.Id_Sequence_No__c == 3){
                        aml3 = new MyBudgetsAMLWrapper(a);
                    }
                }
            }

            if(preSubmitRecordCounter == 1){
                aml2 = new MyBudgetsAMLWrapper(applicnt);
                aml2.aml.Id_Sequence_No__c = 0;
            }

            if(postSubmitRecordCounter == 1){
                aml2 = new MyBudgetsAMLWrapper(applicnt);
                aml2.aml.Id_Sequence_No__c = 2;
                aml2.aml.Identification__c = 'Please Select';

                aml3 = new MyBudgetsAMLWrapper(applicnt);
                aml3.aml.Id_Sequence_No__c = 3;
                aml3.aml.Identification__c = 'Please Select';
            }
            else if(postSubmitRecordCounter == 2){
                isAml2Exposed = true;
                
                aml3 = new MyBudgetsAMLWrapper(applicnt);
                aml3.aml.Id_Sequence_No__c = 3;
                aml3.aml.Identification__c = 'Please Select';
            }

        }
        else{

            aml1 = new MyBudgetsAMLWrapper(applicnt);
            aml1.aml.Id_Sequence_No__c = 1;
            aml1.aml.Identification__c = 'Please Select';

            aml2 = new MyBudgetsAMLWrapper(applicnt);
            aml2.aml.Id_Sequence_No__c = 2;
            aml2.aml.Identification__c = 'Please Select';

            aml3 = new MyBudgetsAMLWrapper(applicnt);
            aml3.aml.Id_Sequence_No__c = 3;
            aml3.aml.Identification__c = 'Please Select';
        }
    }
    
    /*------------------------------------------------------------
     Author: Michael Lasala
     Company: Cloud Sherpas
     Description: Identify whether verification is Full AML or Proof of Address only
     Inputs: None
     Returns: Void
     History
     11/27/14       Michael Lasala      Created
     ------------------------------------------------------------*/
    public void isPOA(){
        if(applicnt.Verification_Method__c == GEN_OriginationsConstants.POA){
            poaOnly = true;
        } else {
            poaOnly = false;
        }
    }
        
    /* Description: Method for saving/updating AML
     *  Author: Fel Saliba
     *  Date Created: NOV-17-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference saveAML(){
        PageReference pageRef = dmlRecords(false);
        return pageRef;
    }

    /* Description: Method for verifying AML
     *  Author: Fel Saliba
     *  Date Created: NOV-20-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference verifyAML(){
        if(applicnt.Has_AML__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'AML is already satisfied'));
            return null;
        } else {
            PageReference pageRef = dmlRecords(true);
            return pageRef;
        }
    }
    
    /* Description: Method for verifying POA
     *  Author: Mike Lasala
     *  Date Created: APR-28-2015
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference verifyPOA(){
        if(applicnt.Has_POA__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'POA is already satisfied'));
            return null;
        } else {
            PageReference pageRef = dmlRecords(true);
            return pageRef;
        }
    }

    /* Description: Method for redirecting to the main page when cancel is click
     *  Author: Fel Saliba
     *  Date Created: April-29-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference cancel(){
        PageReference pageRef = redirectToMainPage();
        return pageRef;
    }
    
    /* Description: Method for validating AML prior saving
     *  Author: Fel Saliba
     *  Date Created: NOV-17-2013
     *  Input Parameters: None
     *  Return: Boolean
     */
    public boolean validateAML(){
        Boolean validateOk = true;
        Boolean option3 = false;
        Boolean option2 = false;
        
        errorVerificationType = false;
        errorVerificationMethod = false;

        errorVerificationTypeMsg =  '';
        errorVerificationMethodMsg = '';
        
        if(isNZ){

            if(applicnt.Verification_Method__c == null || applicnt.Verification_Method__c == ''){
                errorVerificationType = true;
                errorVerificationTypeMsg = 'Please select Verification Type.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select Verification Type.'));
                return false;
            }
        }

        if(aml1.aml.AML_Pos_Verified_Type__c == null || aml1.aml.AML_Pos_Verified_Type__c == 'Please Select'){
            errorVerificationMethod = true;
            errorVerificationMethodMsg = 'Please select Verification Method.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select Verification Method.'));
            validateOk = false;
        }

        if(!poaOnly){

            if(aml1.aml.ID_1__c == 'Please Select' || aml1.aml.ID_1__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Type for Primary Identification.'));
                validateOk = false;
            } else {
                aml1.aml.Identification__c = aml1.aml.ID_1__c;
                aml1.aml.Verified_Flag__c = true;

                List<String> aml1Messages = aml1.validateStaffAML(this.application.Brand_Lookup__r.Country__c, aml1.aml);

                //Check Primary AML
                if(!aml1Messages.isEmpty()){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please correct your data for Primary Identification.'));
                    validateOk = false;

                    for(String s: aml1Messages){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, s));
                    }
                }
            }
            
            //Check if Secondary and Tertiary AML from Primary AML
            if(aml1.aml.Identification__c == 'Birth Certificate'){
                option2 = true;
                option3 = true;
            }else{
                option2 = false;
                option3 = false;
            }
            
            if(aml1.aml.Identification__c == 'NZ Certificate of Citizenship' ||
               aml1.aml.Identification__c == 'NZ Birth Certificate'){
                option2 = true;
            }

            //Check Secondary AML if exists
            if(option2 || isAml2Exposed){
                if(aml2.aml.ID_2__c == 'Please Select' || aml2.aml.ID_2__c == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Type for Secondary Identification.'));
                    validateOk = false;
                } else {
                    aml2.aml.Identification__c = aml2.aml.ID_2__c;
                    aml2.aml.Verified_Flag__c = true;

                    if(aml2.aml.ID_2__c != 'Please Select' || aml2.aml.ID_2__c != null || aml2.aml.ID_2__c != ''){
                        
                        List<String> aml2Messages = aml2.validateStaffAML(this.application.Brand_Lookup__r.Country__c, aml2.aml);

                        //Check Primary AML
                        if(!aml2Messages.isEmpty()){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please correct your data for Secondary Identification.'));
                            validateOk = false;

                            for(String s: aml2Messages){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, s));
                            }
                        }
                    }
                }
            }

            //Check Tertiary AML if exists
            if(option3){
                if(aml3.aml.ID_3__c == 'Please Select' || aml3.aml.ID_3__c == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Type for Tertiary Identification.'));
                    validateOk = false;
                } else {
                    aml3.aml.Identification__c = aml3.aml.ID_3__c;
                    aml3.aml.Verified_Flag__c = true;

                    List<String> aml3Messages = aml3.validateStaffAML(this.application.Brand_Lookup__r.Country__c, aml3.aml);

                    //Check Primary AML
                    if(!aml3Messages.isEmpty()){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please correct your data for Tertiary Identification.'));
                        validateOk = false;

                        for(String s: aml3Messages){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, s));
                        }
                    }
                }
            }
        } 

        if(isNZ){

            List<String> poaMessages = poa.validatePOA(poa.aml);
            if(!poaMessages.isEmpty()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please correct your data for Proof of Address.'));
                validateOk = false;

                for(String s: poaMessages){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, s));
                }
            } else {
                poa.aml.POA_Provided_Flag__c = true;
            }
        }
        
        if(validateOk){
            if(!poaOnly){
                if(aml1.aml.Identification__c != 'Please Select' || aml1.aml.Identification__c != null){
                    upsertAML.add(aml1.aml);
                }

                if(option2 || isAml2Exposed){
                    upsertAML.add(aml2.aml);
                }else{
                    if(aml2 != null && aml2.aml.id != null){
                        deleteAML.add(aml2.aml);
                    }
                }

                if(option3){
                    upsertAML.add(aml3.aml);
                }else{
                    if(aml3 != null  && aml3.aml.id != null){
                        deleteAML.add(aml3.aml);
                    }
                }
            } else {
                aml1.aml.Verified_Flag__c = true;
                upsertAML.add(aml1.aml);

                //if(aml1.aml.Identification__c == 'NZ Certificate of Citizenship' ||
                //   aml1.aml.Identification__c == 'NZ Birth Certificate'){
                    
                //    aml2.aml.Verified_Flag__c = true;
                //    upsertAML.add(aml2.aml);    
                //}
            }
            
            if(isNZ){
                upsertAML.add(poa.aml);

                if(!poaOnly){
                    amlToApplicant();
                }
            }
            
            return true;
            
        }else{
            upsertAML = new List<AML__c>();
            deleteAML = new List<AML__c>();
            return false;
        }
    }

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: DML method for AML, Applicant and Application
    Inputs: Boolean, String
    Returns: void
    History
    12/11/14       Michael Lasala      Created
    2015-09-17     Tony Xu             Modified the method to do the sync call rather than @future callout
    ------------------------------------------------------------*/
    public PageReference dmlRecords(Boolean isWebservice){

        //System.debug('$$$ isManualReasonCode: '+isManualReasonCode('AML'));

        if(validateAML()){
            try{
                if(!deleteAML.isEmpty()){
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(AML__c.SObjectType.getDescribe().isDeletable()){
                        delete deleteAML;
                    }
                    */
                    delete deleteAML;
                }

                if(!upsertAML.isEmpty()){
                    
                    String staffSSO = [SELECT   SSO_Number__c
                                       FROM     User 
                                       WHERE    Id = :UserInfo.getUserId()].SSO_Number__c;
                    
                    
                    for(AML__c aml:upsertAML){
                        aml.Staff_ID_SSO__c = staffSSO;
                        aml.Staff_ID_Sighted_By__c = UserInfo.getName();
                        aml.Date_Verified__c = Date.today();
                        aml.AML_Pos_Verified_Type__c = aml1.aml.AML_Pos_Verified_Type__c;
                    }                
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(AML__c.SObjectType.getDescribe().isCreateable()) {
                        upsert upsertAML;
                    //}
                }
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_AMLEXT', 'AML__c', 'Class', String.valueOf(application.Id));    
            }

            try {
                update applicnt;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_AMLEXT', 'Applicant__c', 'Class', String.valueOf(application.Id));
            }

            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_AMLEXT', 'Application__c', 'Class', String.valueOf(application.Id));
            }
            
            //Boolean flag to identify whether validation passed
            isValid = true;      //MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT 
            
            if(!isWebservice){
                PageReference pageRef = redirectToMainPage();
                return pageRef;
            }else{
                return null;
            }
            
        } else {

            //Boolean flag to identify whether validation passed
            isValid = false;     //MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT 
            return null;
        }
    }
    
    /** Description: Method to perform sync call to verify AML Service
     *  Author: Tony Xu
     *  Date Created: 2015-09-17
     *  Input Parameters: NA
     *  Return: NA
     */
    public PageReference verifyAMLCallout(){
        //BEGIN MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT 
        try{
            IS_VerifyAML.VerifyAMLRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
            //return null;   
        }
        
        //PageReference pageRef = redirectToMainPage();
        //return pageRef;
        return null;
        //END MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT 
    }    

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: PageReference to main page
    Inputs: None
    Returns: PageReference
    History
    12/11/14       Michael Lasala      Created
    ------------------------------------------------------------*/
    public PageReference redirectToMainPage(){
        //redirect back to the main page.
        PageReference pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('id', String.valueOf(application.Id));
        pageRef.setRedirect(true);
        return pageRef;
    }

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Map AML fields to Applicant record
    Inputs: None
    Returns: Void
    History
    04/27/15       Michael Lasala      Created
    ------------------------------------------------------------*/
    public void amlToApplicant(){
        
        applicnt.NZ_Residency_Number__c = null;
        applicnt.Version__c = null;

        if(aml1.aml.ID_1__c == GEN_OriginationsConstants.CUSTOMERTYPEID_OVERSEAS_PASSPORT){
            applicnt.NZ_Residency_Number__c = aml1.aml.NZ_Residency_Number__c;
        }

        if(aml1.aml.ID_1__c == GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE){
            applicnt.Version__c = aml1.aml.Version__c;
        }

        applicnt.ID_Number__c = aml1.aml.ID_No__c;
        applicnt.Customer_ID_Type__c = aml1.aml.ID_1__c;
        applicnt.Issuing_Country__c = aml1.aml.Issue_Country__c;
        applicnt.Issue_Date__c = aml1.aml.ID_Issue_Date__c;
        applicnt.Expiry_Date__c = aml1.aml.ID_Expiry_Date__c;
        //applicnt.Sec_ID_Issuer__c = aml1.aml.ID_Issuer__c;

        if(aml1.aml.ID_1__c == 'NZ Certificate of Citizenship' ||
           aml1.aml.ID_1__c == 'NZ Birth Certificate'){

            applicnt.ID_No__c = aml2.aml.ID_No__c;
            applicnt.ID_1__c = aml2.aml.ID_2__c;
            applicnt.Sec_ID_Issue_Country__c = aml2.aml.Issue_Country__c;
            applicnt.Sec_ID_Issue_Date__c = aml2.aml.ID_Issue_Date__c;
            applicnt.Sec_ID_Expiry_Date__c = aml2.aml.ID_Expiry_Date__c;
            applicnt.Sec_ID_Issuer__c = aml2.aml.ID_Issuer__c;
        
        } else {

            applicnt.ID_No__c = null;
            applicnt.ID_1__c = null;
            applicnt.Sec_ID_Issue_Country__c = null;
            applicnt.Sec_ID_Issue_Date__c = null;
            applicnt.Sec_ID_Expiry_Date__c = null;
            applicnt.Sec_ID_Issuer__c = null;

        }
    }
}