/**
 * @Description: Controller class for GEDDScripts
 * @Author: Fel Saliba
 * @Date Created: JULY-14-2013
 * @History:
   =====================================================================
       14-07-14: Created. - Fel
   =====================================================================
 */
global class ScriptsController{
    
    //variable declaration.
    public String omnitureSource {get; set;}
    public String vfName    {get; set;}
    
    /*  Description: Class Constructor
     *  Author: Fel Saliba
     *  Date Created: July-14-2014
     */  
    public ScriptsController(){
        omnitureSource = Admin_Settings__c.getInstance(GEN_OriginationsConstants.ADMIN_SETTINGS_OMNITURE).Value__c;
        
        String pageName = ApexPages.CurrentPage().getUrl();     
        pageName = pageName.replaceFirst('/apex/','');          
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
                                                               
        string[] pageNameExtra = pageName.split('%3F',0);       
                                                                
        pageName = pageNameExtra[0];                            
                                                                
        vfName = pageName;
    }   
}