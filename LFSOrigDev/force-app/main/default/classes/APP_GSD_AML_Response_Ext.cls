/* @Description: Extension class for the AML Response Page
 * @Author : 
 * @Date : 02-FEB-2016
 * @History:
   =========================================================================================================
   		02-FEB-2016 : Created - Davey
   =========================================================================================================
 */
global class APP_GSD_AML_Response_Ext extends APP_GSD_BaseController{
    private static final String IDV_FORM = ' Personal Loan ID Verification Form';
    
	/*  Description: Query downloadable AML files
     *  Author: Russell Cadapan
     *  Date Created: 02-FEB-2016
     *  Input:  brandSite - the brand country site
     *  Return: Document
    */
	@RemoteAction
	global static List<AMLDocumentWrapper> queryAMLFiles(String brandSite){
	    
	    List<AMLDocumentWrapper> AMLDocuments = new List<AMLDocumentWrapper>();
	    
	    List<String> fileNames = new List<String>();
        List<Document> documentList = new List<Document>();
        
        String documentName = '';
        
        // Setting up site URL based from the brandSite
        //BEGIN MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
	    String urlSite = Site.getBaseSecureUrl();
	    
        if(brandSite == GEN_OriginationsConstants.GEMONEY_AU_SITENAME){
            documentName = GEN_OriginationsConstants.BRAND_NAME_GEMONEY + ' ' + IDV_FORM;
            fileNames.add(GEN_OriginationsConstants.AUSSIE_IDV);
        }
        else if(brandSite == GEN_OriginationsConstants.GEMONEY_NZ_SITENAME){
            documentName = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ + ' ' + IDV_FORM;
            fileNames.add(GEN_OriginationsConstants.GE_MONEY_IDV);
        }
        else if(brandSite == GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME){
            documentName = GEN_OriginationsConstants.BRAND_Display_NAME_AUSSIE + ' ' + IDV_FORM;
            fileNames.add(GEN_OriginationsConstants.AUSSIE_IDV);
        }
        else if(brandSite == GEN_OriginationsConstants.KIWI_BANK_SITENAME){
            documentName = GEN_OriginationsConstants.BRAND_NAME_KIWI + ' ' + IDV_FORM;
            fileNames.add(GEN_OriginationsConstants.KIWIBANK_IDV);
        }
        //END MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        
        // query Document Id and Name
        if(!fileNames.isEmpty()){
            documentList = [SELECT Id FROM Document WHERE DeveloperName IN: fileNames];
        }
        
        // set the query results into a wrapper and save it in a list for return
        if(!documentList.isEmpty()){
            for(Document d: documentList){
                AMLDocuments.add(new AMLDocumentWrapper(urlSite + '/servlet/servlet.FileDownload?file=' + d.Id, documentName));
            }
        }
        
        return AMLDocuments;
	}
	/*  Description: AML Document Wrapper
     *  Author: Russell Cadapan
     *  Date Created: 02-FEB-2016
     *  Input:  None
     *  Return: None
    */
	global class AMLDocumentWrapper{
	    global String documentURL  {get;set;}
	    global String documentName {get;set;}
	    global AMLDocumentWrapper(String documentURL, String documentName){
	        this.documentURL = documentURL;
	        this.documentName = documentName;
	    }
	}
	/*  Description: Query Brand Content of AML Documents based on Brand
     *  Author: Davey Yu
     *  Date Created: 08-FEB-2016
     *  Input:  region - Brand Id
     *  Return: Brand Content
    */
	@RemoteAction
	global static List<Brand_Content__c> queryAMLDocuments(Id brandId){
	 	return [SELECT Name, Brand__c, Output_HTML__c FROM Brand_Content__c WHERE Brand__c =: brandId];
	 }
}