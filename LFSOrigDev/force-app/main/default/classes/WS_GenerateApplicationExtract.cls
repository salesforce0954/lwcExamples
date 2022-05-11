/**
 * @Description: Webservice Class for Application Extract service
 * @Author: Dan Crisologo
 * @Date Created: MAR-17-2014
 * @History:
   =====================================================================
       03-17-14: Created. - Dan
   =====================================================================
 */ 
public with sharing class WS_GenerateApplicationExtract extends WS_WebserviceCommons{

    public WS_GenerateApplicationExtract (Boolean mockEnable) {
        super(mockEnable);
    } 

    /**  Description: Calls a webservice that invokes accept offer integration service
    *  Author: Dan Crisologo
    *  Date Created: 12-18-13
    *  Input Parameters: Application
    *  Return: string - webservice response   
    */
    public IS_WebserviceResponseDTO generateApplicationExtractRequest(IS_ApplicationDTO appDTO, String channel){       
                                        
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

            //***** Set-up Document Meta-Data *****//
            Map<String,String> docMetaDataTypeMap = new Map<String,String>();
            docMetaDataTypeMap.put('applicationNumber',appDTO.app.UID__c);
            docMetaDataTypeMap.put('channel','Generated');

            generateDocumentInput.documentMetadata = WS_WebServiceHelper.generateDocumentMetadataType(docMetaDataTypeMap);

            //***** Set-up Documents Type *****//
            List<GenerateDocumentGeComOriginations.ApplicationExtractType> appExtractDocList = new List<GenerateDocumentGeComOriginations.ApplicationExtractType>();

            for(Related_Document__c rd: appDTO.acceptanceDocuments) {
                GenerateDocumentGeComOriginations.ApplicationExtractType aet = new GenerateDocumentGeComOriginations.ApplicationExtractType();
                aet.documentCommonAttr = WS_WebServiceHelper.generateDocumentCommonAttrType(rd);
                aet.applicationExtractData = WS_WebServiceHelper.createApplicationExtract(appDTO);
                system.debug('*****DEBUG*********');
                system.debug('*****DEBUG***debt***'+appDTO.debtList);
                system.debug(aet.applicationExtractData);
                appExtractDocList.add(aet);
                break; //break the loop since we are only expecting one app extract in the list
            }

            GenerateDocumentGeComOriginations.DocumentsType documentsType = new GenerateDocumentGeComOriginations.DocumentsType();
            documentsType.applicationExtract = appExtractDocList;
            generateDocumentInput.documents = documentsType;
            
             //***** Invoke Submit Application Service *****
            gdgco = setupPLDocManagementPort();
            GenerateDocumentGeComOriginations.generateDocumentResponse_element wsResponse;

            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                GenerateDocumentGeComOriginations.ApplicationResponseType mockedCode = new GenerateDocumentGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                mockedCode.messageDescription = '';
                GenerateDocumentGeComOriginations.generateDocumentResponse_element mockedResponse = new GenerateDocumentGeComOriginations.generateDocumentResponse_element();
                mockedResponse.serviceResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = gdgco.generateDocument(serviceContextParam, generateDocumentInput);
                callSuccessful = true;
            }

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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, appDTO.app.id, gdgco.endpoint_x, gdgco.clientCertName_x, channel, gdgco.timeout_x, callTime);
            }
        }   
        return wsrDTO;
    }

}