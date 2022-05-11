/**
 * @Description: Webservice Class for Accept Offer
 * @Author: Dan Crisologo
 * @Date Created: DEC-18-2013
 * @History:
   =====================================================================
       12-18-13: Created. - Dan
       01-21-14: This is now the WS for generate document service
   =====================================================================
 */ 
public with sharing class WS_GenerateDocument extends WS_WebserviceCommons{

    public WS_GenerateDocument (Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Calls a webservice that invokes accept offer integration service
    *  Author: Dan Crisologo
    *  Date Created: 12-18-13
    *  Input Parameters: Application
    *  Return: string - webservice response   
    */
    public IS_WebserviceResponseDTO generateDocumentRequest(IS_ApplicationDTO appDTO, String channel){       
                                        
        IS_WebserviceResponseDTO wsrDTO;
        GenerateDocumentGeComOriginations.ServiceContext serviceContextParam;
        GenerateDocumentGeComOriginations.GenerateDocumentInputType generateDocumentInput;
        GenerateDocumentGeComOriginations.PLDocManagementPort gdgco;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;

        try{              
            //***** Set-up Service Context *****
            serviceContextParam = createPLDOCServiceContext(channel);

            //***** Set-up Document Input *****
            generateDocumentInput = new GenerateDocumentGeComOriginations.GenerateDocumentInputType();
            generateDocumentInput.sfApplicationId = appDTO.app.Id;
            generateDocumentInput.applicationId = appDTO.app.UID__c;
            
            //TODO: Ankur to confirm the values of property names and values
            //***** Set-up Document Meta-Data *****//
            //String bdate = (appDTO.applicant.Date_Of_Birth__c).replace('-', '/');
            String bdate = appDTO.applicant.Date_of_Birth_WS__c;
            System.debug('bdate---->'+bdate);
            
            Map<String,String> docMetaDataTypeMap = new Map<String,String>();
            docMetaDataTypeMap.put('accountNumber','');
            docMetaDataTypeMap.put('applicationNumber',appDTO.app.UID__c);
            docMetaDataTypeMap.put('firstName',appDTO.applicant.First_Name__c);
            docMetaDataTypeMap.put('lastName',appDTO.applicant.Last_Name__c);
            docMetaDataTypeMap.put('channel','Generated');
            docMetaDataTypeMap.put('documentId','');
            docMetaDataTypeMap.put('customerType','');
            docMetaDataTypeMap.put('productType',appDTO.app.Brand_String__c);
            docMetaDataTypeMap.put('dateofBirth',bdate);

            generateDocumentInput.documentMetadata = WS_WebServiceHelper.generateDocumentMetadataType(docMetaDataTypeMap);

            //***** Set-up Documents Type *****//
            List<GenerateDocumentGeComOriginations.ContractDocType> contractDocList = new List<GenerateDocumentGeComOriginations.ContractDocType>();
            List<GenerateDocumentGeComOriginations.oAndRType> oAndRList = new List<GenerateDocumentGeComOriginations.oAndRType>();
            List<GenerateDocumentGeComOriginations.lpiType> lpiList = new List<GenerateDocumentGeComOriginations.lpiType>();
            List<GenerateDocumentGeComOriginations.directDebitType> directDebitList = new List<GenerateDocumentGeComOriginations.directDebitType>();
            List<GenerateDocumentGeComOriginations.privacyNoticeType> privacyNoticeList = new List<GenerateDocumentGeComOriginations.privacyNoticeType>();
            List<GenerateDocumentGeComOriginations.accountClosureType> accountClosureList = new List<GenerateDocumentGeComOriginations.accountClosureType>();
            List<GenerateDocumentGeComOriginations.accountLimitReductionType> limitReductionList = new List<GenerateDocumentGeComOriginations.accountLimitReductionType>();
            List<GenerateDocumentGeComOriginations.payoutStatementType> payoutStatementList = new List<GenerateDocumentGeComOriginations.payoutStatementType>();
            List<GenerateDocumentGeComOriginations.interestFreeRebateType> interestFreeRebateList = new List<GenerateDocumentGeComOriginations.interestFreeRebateType>();
            List<GenerateDocumentGeComOriginations.disbursementAuthorityType> disbursementList = new List<GenerateDocumentGeComOriginations.disbursementAuthorityType>();
            List<GenerateDocumentGeComOriginations.signUpLetterNZType> signUpLetterList = new List<GenerateDocumentGeComOriginations.signUpLetterNZType>();

            //iterate through the related documents, create wsdl mapping for present documents
            for(Related_Document__c rd: appDTO.acceptanceDocuments) {
               
                //Add new contract if rd type = contract
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_CONTRACT) {
                    GenerateDocumentGeComOriginations.ContractDocType cdt = new GenerateDocumentGeComOriginations.ContractDocType();
                    cdt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                        cdt.contractTemplateData = WS_WebServiceHelper.generateContractType(appDTO);
                    contractDocList.add(cdt);
                }
                
                //Add new contract if rd type = onr
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_ONR) {
                    GenerateDocumentGeComOriginations.oAndRType oart = new GenerateDocumentGeComOriginations.oAndRType();
                    oart.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    oart.OandRTemplateData = WS_WebServiceHelper.createONRDocument(rd, appDTO);
                    oAndRList.add(oart);
                }
        
                //Query required lpi records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_LPI) {
                    GenerateDocumentGeComOriginations.lpiType lpit = new GenerateDocumentGeComOriginations.lpiType();
                    lpit.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    lpit.lpiTemplateData = WS_WebServiceHelper.generateLoanProtectionInsurance(appDTO);
                    lpiList.add(lpit);
                }
        
                //Query required direct debit records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT || rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT_NZ) {
                    GenerateDocumentGeComOriginations.directDebitType ddt = new GenerateDocumentGeComOriginations.directDebitType();
                    ddt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    ddt.directDebitTemplateData = WS_WebServiceHelper.generateDirectDebitRequest(appDTO);
                    directDebitList.add(ddt);
                }
        
                //Query required privacy records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_PRIVACY) {
                    GenerateDocumentGeComOriginations.privacyNoticeType pnt = new GenerateDocumentGeComOriginations.privacyNoticeType();
                    pnt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    pnt.privacyNoticeTypeData = WS_WebServiceHelper.generatePrivacyNotice(appDTO);
                    privacyNoticeList.add(pnt);
                }
        
                //Query required account closure records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_CLOSURE_AUTH) {
                    GenerateDocumentGeComOriginations.accountClosureType act = new GenerateDocumentGeComOriginations.accountClosureType();
                    act.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    act.accountClosureTemplateData = WS_WebServiceHelper.createAccountClosureDocument(rd, appDTO);
                    accountClosureList.add(act);
                }

                //Query required limit reduction records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_REDUCTION_AUTH) {
                    GenerateDocumentGeComOriginations.accountLimitReductionType alrt = new GenerateDocumentGeComOriginations.accountLimitReductionType();
                    alrt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    alrt.accountLimitReductionTemplateData = WS_WebServiceHelper.createAccountLimitReduction(rd, appDTO);
                    limitReductionList.add(alrt);
                }
        
                //Query required payout statement records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_PAYOUT_STATEMENT) {
                    GenerateDocumentGeComOriginations.payoutStatementType pst = new GenerateDocumentGeComOriginations.payoutStatementType();
                    pst.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    pst.payoutStatementTemplateData = WS_WebServiceHelper.createPayoutStatement(rd, appDTO);
                    payoutStatementList.add(pst);
                }
        
                //Query required IF Rebate records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_IFREBATE) {
                    GenerateDocumentGeComOriginations.interestFreeRebateType ifrt = new GenerateDocumentGeComOriginations.interestFreeRebateType();
                    ifrt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    ifrt.interestFreeRebateData = WS_WebServiceHelper.generateInterestFreeRebate(rd, appDTO);
                    interestFreeRebateList.add(ifrt);
                }
                
                //Query required Disbursement authority records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_DISBURSEMENT_AUTH) {
                    GenerateDocumentGeComOriginations.disbursementAuthorityType dat = new GenerateDocumentGeComOriginations.disbursementAuthorityType();
                    dat.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    dat.disbursementAuthorityData = WS_WebServiceHelper.generateDisbursementAuthority(rd, appDTO);
                   disbursementList.add(dat);
                }
                
                //Query required signUpLetterNZData records
                if(rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_NZ_SIGNUP_LETTER || rd.Type__c == GEN_OriginationsConstants.DOCUMENT_TYPE_GEMONEY_NZ_SIGNUP_LETTER) {
                    GenerateDocumentGeComOriginations.signUpLetterNZType slt= new GenerateDocumentGeComOriginations.signUpLetterNZType();
                    slt.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                    slt.signUpLetterNZData = WS_WebServiceHelper.generatesignUpLetterNZ(rd, appDTO);
                    signUpLetterList.add(slt);
                }
                
            }
            
            generateDocumentInput.documents = WS_WebServiceHelper.generateDocumentsType(contractDocList,
                                                                                        oAndRList,
                                                                                        lpiList,
                                                                                        directDebitList,
                                                                                        privacyNoticeList,
                                                                                        accountClosureList,
                                                                                        limitReductionList,
                                                                                        payoutStatementList,
                                                                                        interestFreeRebateList,
                                                                                        disbursementList,
                                                                                        signUpLetterList);
            
             //***** Invoke Submit Application Service *****
            gdgco = setupPLDocManagementPort();
            callAttempted = true;
            callTime = System.currentTimeMillis();
            GenerateDocumentGeComOriginations.generateDocumentResponse_element wsResponse = gdgco.generateDocument(serviceContextParam, generateDocumentInput);
            callSuccessful = true;
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.serviceResponse.messageCode, wsResponse.serviceResponse.messageDescription);

        } catch(CalloutException ce){ 
            System.debug('Callout Exception Occured: ' + ce.getMessage() + '- -' + ce.getStackTraceString());
            if(ce.getMessage().indexOf('Read timed out')!=-1) { //timeout exception - not able to receive a response within a specified time
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_SFTIMEOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
            } else { //other callout exception. Parse exception, invalid endpoint, etc
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_CALLOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
            }
        } catch(Exception e){ 
            System.debug('General Exception Occured: ' + e.getMessage() + '- -' + e.getStackTraceString());
            wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, 
                                                  e.getMessage() + ':' + e.getStackTraceString());
        }  finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, appDTO.app.id, gdgco.endpoint_x, gdgco.clientCertName_x, channel, gdgco.timeout_x, callTime);
            }
        }    
             
        return wsrDTO;
    }

}