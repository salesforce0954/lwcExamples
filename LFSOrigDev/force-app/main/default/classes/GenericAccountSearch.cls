global with Sharing class GenericAccountSearch{

    static Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
    public String searchNameText{get;set;}
    public boolean listSize{get;set;}
    public String recordType {get;set;}
    public String recTypeContainer{get;set;}
    public String url{get;set;}
    public String bookingIdLabel{get;private set;}
    public String profileName{get;set;}
    public static String abnGUID = '484c89cc-4bfb-4e27-9e7f-80a58a3ed062';
    public static String b64NZKey = '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'; 
    public String ABN {get;set;}
    public String Name {get;set;}
    public String Phone {get;set;}
    public String accountNameValue{get;set;}
    public String abnValue{get;set;}
    public String nzCoValue{get;set;}
    public String phoneValue{get;set;}
    public String stateValue{get;set;}
    public String pCodeValue{get;set;}
    public String cityValue{get;set;}
    public String compIdenValue{get;set;}
    public String recordTypeName {get;set;}
    //Changes to suit Perspecsys
    public Account acc{get;set;}
    
    //Prashant: 28092011:: Handle Server Error when webservice server response is having error code from below list
    private static Set<Integer> setResErrCode = new Set<Integer>{100, 101, 102, 103, 122, 400, 401, 402, 
                                                            403, 404, 405, 406, 407, 408, 409, 410, 
                                                            411,412, 413, 414, 415, 416, 417, 418, 
                                                            422, 423, 424, 425, 426, 444, 449, 450, 
                                                            499, 500, 501, 502, 503, 504 , 505, 506, 
                                                            507, 509, 510, 598, 599};
    // Render Edit Page
    public Boolean showEditor {get;set;}

    public String getAPACTitle(){
    
        String retVal='Search first for an Account';
        
        /*
        //changing the title based on profile name  
        if(profileName == 'CDF Asia'){
            retVal = 'Search first for a CDF Account';
        }
        else if(profileName != null && profileName.contains('ICDF')){
            retVal = 'Search first for a ICDF Account';
        }
        else if(profileName != null && profileName.contains('IHFS')){
            retVal = 'Search first for a IHFS Account';
        }
        else if(profileName != null && profileName.contains('SEA')){
            retVal = 'Search first for a SEA Account';
        }
        else if(profileName != null && profileName.contains('Hyundai')){
            retVal = 'Search first for a Hyundai Account';
        }
        else if(profileName != null && profileName.contains('NPL')){
            retVal = 'Search first for a NPL Account';
        }
        else if(profileName != null && profileName.contains('Equity')){
            retVal = 'Search first for a Equity Account';
        }
        else if(profileName != null && profileName.contains('Japan')){
            retVal = 'Search first for a Japan Account';
        }
        else if(profileName != null && (profileName.contains('CAG') || profileName.contains('ICorpAcc'))){
            retVal = 'Search first for an India CAG Account/Partner';
        }
        else if(profileName != null && (profileName.contains('Capital Markets') || profileName.contains('ABR CM'))){
            retVal = 'Search first for a Capital Markets Investor';
        }
        else if(profileName != null && (profileName.contains('Structured Finance') || profileName.contains('ABR CF'))){
            retVal = 'Search first for a Structured Finance Account';
        }
        else if(profileName != null && (profileName.contains('China') || profileName.contains('ABR CH'))){
            retVal = 'Search first for a China Account';
        }
        else if(profileName != null && (profileName.contains('India') || profileName.contains('IAL'))){
            retVal = 'Search first for an Indian Account';
        }
        */
        return retVal;
    }
        
    public String getABNLabel(){
     
        String lab = 'ABN';   
        /*
        if(profileName != null && (profileName.contains('India'))){
        
            lab = 'Company Identifier';
        }*/
        if(profileName != null && (profileName.contains('NZ'))){
        
            lab = 'NZ Co No';
        }
        return lab;
    }
        
    public String getPhoneLabel(){        
        String lab = 'Phone';
        return lab;
    } 
    
    public String getcreateAccountAPACLabel(){
        
        String retLabel='Create New Account';
        if(profileName != null){ 
            if(profileName.contains('Consumer')){
                 retLabel='Create New Account';
            }
            /*
            if(profileName.contains('CDF Asia')){
                 retLabel='Create New Account for CDF Asia';
            }
            else if(profileName.contains('ICDF')){
                 retLabel='Create New Account for ICDF';
            }
            else if(profileName.contains('IHFS')){
                 retLabel='Create New Account for IHFS';
            }
            else if(profileName.contains('SEA')){
                 retLabel='Create New Account for SEA';
            }
            else if(profileName.contains('Hyundai')){
                 retLabel='Create New Account for Hyundai';
            }
            else if(profileName.contains('NPL')){
                 retLabel='Create New Account for NPL';
            }
            else if(profileName.contains('Equity')){
                 retLabel='Create New Account for Equity';
            }
            else if(profileName.contains('Japan')){
                 retLabel='Create New Account for Japan';
            }
            else if(profileName.contains('CAG')|| profileName.contains('ICorpAcc')){
                 retLabel='Create New Account for India CAG';
            } 
            else if(profileName.contains('Capital Markets') || profileName.contains('ABR CM')){
                 retLabel='Create New Account for Capital Markets';
            }
            else if(profileName.contains('Structured Finance') || profileName.contains('ABR SF')){
                 retLabel='Create New Account for Structured Finance';
            }
            else if(profileName.contains('China') || profileName.contains('ABR CH')){
                 retLabel='Create New Account for China';
            }
            else if(profileName.contains('India') || profileName.contains('IAL')){
                if(profileName.contains('Fleet')){
                    retLabel='Create New Account for India Fleet';
                }
                else{
                    retLabel='Create New Account for India';
                }
            }
            */
            else{
                 retLabel='Create New Account for AUS & NZ Mini';
            }
        }
        return retLabel;
    }
    
    //public boolean getShowABNINP(){
        
    //     /*Not Showing State field for Consumer, CDF Asia, ICDF ,IHFS, SEA, Hyundi, NPL, Equity, Japan, CAG, NPL, ICorpAcc,Capital Markets,ABR CM,Structured Finance
    //    ABR SF,China, ABR CH, India, IAL, NZ 
    //    */
    //    if(profileName != null && (profileName.contains('Consumer') || profileName.contains('CDF Asia') || profileName.contains('ICDF') || profileName.contains('IHFS')
    //                                || profileName.contains('SEA') || profileName.contains('Hyundai') || profileName.contains('NPL') || profileName.contains('Equity')
    //                                || profileName.contains('Japan') || profileName.contains('CAG')|| profileName.contains('ICorpAcc') 
    //                                || profileName.contains('Capital Markets') || profileName.contains('ABR CM') || profileName.contains('Structured Finance') 
    //                                || profileName.contains('ABR SF') || profileName.contains('China') || profileName.contains('ABR CH')
    //                                || profileName.contains('India') || profileName.contains('IAL') || profileName.contains('NZ'))){
    //        return false;
    //    }
    //    return true;
    //}
    
    //public boolean getShowNZCoINP(){
        
    //     /*Not Showing State field for Consumer, CDF Asia, ICDF ,IHFS, SEA, Hyundi, NPL, Equity, Japan, CAG, NPL, ICorpAcc,Capital Markets,ABR CM,Structured Finance
    //    ABR SF,China, ABR CH, India, IAL, NZ 
    //    */
    //    if(profileName != null && (profileName.contains('Consumer') || profileName.contains('CDF Asia') || profileName.contains('ICDF') || profileName.contains('IHFS')
    //                                || profileName.contains('SEA') || profileName.contains('Hyundai') || profileName.contains('NPL') || profileName.contains('Equity')
    //                                || profileName.contains('Japan') || profileName.contains('CAG')|| profileName.contains('ICorpAcc') 
    //                                || profileName.contains('Capital Markets') || profileName.contains('ABR CM') || profileName.contains('Structured Finance') 
    //                                || profileName.contains('ABR SF') || profileName.contains('China') || profileName.contains('ABR CH')
    //                                || profileName.contains('India') || profileName.contains('IAL'))){
    //        return false;
    //    }
        
    //    return true;
    //}
    
    //public boolean getShowCompIdenINP(){
        
         
    //    //Showing State field for Consumer, CDF Asia, ICDF , 
    //    if(profileName != null && ( profileName.contains('India') || profileName.contains('IAL'))) {
            
    //        return true;
    //    }           
         
    //    return false;
    //}
    
    public boolean getShowCityINP(){
        
         
        //Not Showing State field for Consumer, CDF Asia, ICDF , 
        if(profileName != null && ( profileName.contains('CAG') || profileName.contains('Capital Markets') 
                                    || profileName.contains('ABR CM')
                                    )){
            return false;
        }

        return true;
    }
    
    
    //This boolean method used to show State field based on Profile
    public boolean getShowStateINP(){
        
        /*Not Showing State field for Consumer, CDF Asia, ICDF ,IHFS, SEA, Hyundi, NPL, Equity, Japan,NPL,Capital Markets,ABR CM,Structured Finance
        ABR SF,China, ABR CH, India, IAL, NZ 
        */
        
        
        //Not Showing State field for Consumer, CDF Asia, ICDF , 
        if(profileName != null && (profileName.contains('Consumer') || profileName.contains('CDF Asia') || profileName.contains('ICDF') || profileName.contains('IHFS')
                                    || profileName.contains('SEA') || profileName.contains('Hyundai') || profileName.contains('NPL') || profileName.contains('Equity')
                                    || profileName.contains('Japan') 
                                    || profileName.contains('Capital Markets') || profileName.contains('ABR CM') || profileName.contains('Structured Finance') 
                                    || profileName.contains('ABR SF') || profileName.contains('China') || profileName.contains('ABR CH')
                                    || profileName.contains('India') || profileName.contains('IAL') || profileName.contains('NZ'))){
            return false;
        }

        return true;
    }
    
    //This boolean method used to show Pincode field based on Profile
    public boolean getShowPCodeINP(){
        
        /*Not Showing State field for Consumer, CDF Asia, ICDF ,IHFS, SEA, Hyundi, NPL, Equity, Japan, CAG, NPL, ICorpAcc,Capital Markets,ABR CM,Structured Finance
        ABR SF,China, ABR CH, India, IAL, NZ 
        */
        if(profileName != null && (profileName.contains('Consumer') || profileName.contains('CDF Asia') || profileName.contains('ICDF') || profileName.contains('IHFS')
                                    || profileName.contains('SEA') || profileName.contains('Hyundai') || profileName.contains('NPL') || profileName.contains('Equity')
                                    || profileName.contains('Japan') || profileName.contains('CAG')|| profileName.contains('ICorpAcc') 
                                    || profileName.contains('Capital Markets') || profileName.contains('ABR CM') || profileName.contains('Structured Finance') 
                                    || profileName.contains('ABR SF') || profileName.contains('China') || profileName.contains('ABR CH')
                                    || profileName.contains('India') || profileName.contains('IAL') || profileName.contains('NZ'))){
            return false;
        }

        return true;
    }
    
    //this method show the ABN No Search field based on profile    
    public boolean getRenderABN(){
    
        // no need for CDF ASIA, ICDF , IHFS, SEA, Hyundai, NPL, Equity, Japan, CAG , ICorpAcc, Capital Markets,ABR CM , Structured Finance , ABR CF  to search ABN number 
        if(profileName != null && (profileName.Contains('CDF Asia') || profileName.contains('ICDF') || (profileName.contains('IHFS')) || (profileName.contains('SEA'))
                                            || (profileName.contains('Hyundai')) || (profileName.contains('NPL')) || (profileName.contains('Equity'))
                                            || (profileName.contains('Japan')) || (profileName.contains('~ Marketing Profile')) || (profileName.contains('CAG')) 
                                            || (profileName.contains('ICorpAcc')) || (profileName.contains('Capital Markets')) || (profileName.contains('ABR CM'))
                                            || (profileName.contains('Structured Finance')) || (profileName.contains('ABR SF')) || (profileName.contains('China')) 
                                            || (profileName.contains('ABR CH')) || (profileName.contains('IAL')) || (profileName.contains('ABR A&NZ')))){
            return false;
        }
        
        return true;
    }
    //this method show the Phone No Search field based on profile     
    public boolean getRenderPhone(){
        
        ////no need for CDF ASIA
        //if(profileName == 'CDF Asia'){
        //    return false;
        //}
        
        // no need for ICDF , IHFS, SEA, Hyundai, NPL, Equity, Japan , ICorpAcc to search Phone number
        //else 
        if(profileName != null && (profileName.contains('ICDF') || (profileName.contains('IHFS')) || (profileName.contains('SEA'))
                                            || (profileName.contains('Hyundai')) || (profileName.contains('NPL'))||(profileName.contains('Equity')) 
                                            || (profileName.contains('Japan')) || (profileName.contains('ICorpAcc')) || (profileName.contains('ABR CM'))
                                            || (profileName.contains('ABR SF')) || (profileName.contains('ABR CH')) || (profileName.contains('IAL'))
                                            || (profileName.contains('ABR A&NZ')))){
            return false;
        }
        
        return true;
    }
        
     public String getCreateNewAPACLabel(){
     
        String createLab = 'Create new Account';
        
        //CDF Asia Button 
        //if(profileName.Contains('CDF Asia')) {
        
        //    if(recordTypeName=='Dealer'){
        //        createLab  = 'Create New Dealer';
                
        //    }else if(recordTypeName=='Manufacturer'){
            
        //        createLab  = 'Create New Manufacturer';
        //    }
        //}
        
         //Consumer Business Button
        if(profileName.Contains('Consumer')) {
        
            if(recordTypeName =='Cards Aus'){
                createLab  = 'Create Cards Aus Account';
                
            }else if(recordTypeName=='Cards NZ'){
                createLab  = 'Create Cards NZ Account';
            }
            
            else if(recordTypeName =='Broker AU (Aussie)'){
                createLab  = 'Create Broker AU (Aussie) Account';
                
            }else if(recordTypeName=='Broker AU (Motor/PL)'){
                createLab  = 'Create Broker AU (Motor/PL) Account';
            } 
        }
        
        ////ICDF Button 
        //if(profileName.Contains('ICDF')) {
        
        //    if(recordTypeName=='ICDF Account'){
        //        createLab  = 'Create ICDF Account';
                
        //    }else if(recordTypeName=='ICDF Partner'){
        //        createLab  = 'Create ICDF Partner';
        //    }
        //}
        //// IHFS Button
        //if(profileName.Contains('IHFS')) {
        
        //    if(recordTypeName=='IHFS Account'){
        //        createLab  = 'Create IHFS Account';
                
        //    }else if(recordTypeName=='IHFS Partner'){
        //        createLab  = 'Create IHFS Partner';
        //    }
        //}
        
        //// SEA Button 
        //if(profileName.Contains('IHFS')) {
        
        //    if(recordTypeName=='SEA Account'){
        //        createLab  = 'Create SEA Account';
                
        //    }else if(recordTypeName=='SEA Partner'){
        //        createLab  = 'Create SEA Partner';
        //    }
        //}
        
        //// Hyundai Button
        //if(profileName.Contains('Hyundai')) {
        
        //    if(recordTypeName=='Hyundai Account'){
        //        createLab  = 'Create Hyundai Account';
                
        //    }else if(recordTypeName=='Hyundai Partner'){
        //        createLab  = 'Create Hyundai Partner';
        //    }
        //}
        
        //// NPL Button
        //if(profileName.Contains('NPL')) {
        
        //    if(recordTypeName=='NPL Account'){
        //        createLab  = 'Create NPL Account';
                
        //    }else if(recordTypeName=='NPL Partner'){
        //        createLab  = 'Create NPL Partner';
        //    }
        //}
        
        //// Equity Button 
        //if(profileName.Contains('Equity')) {
        
        //    if(recordTypeName=='Equity Account'){
        //        createLab  = 'Create Equity Account';
                
        //    }else if(recordTypeName=='Equity Partner'){
        //        createLab  = 'Create Equity Partner';
        //    }
        //}
        
        //// Japan Button 
        //if(profileName.Contains('Japan')) {
        
        //    if(recordTypeName=='Japan Account'){
        //        createLab  = 'Create Japan Account';
                
        //    }else if(recordTypeName=='Japan Partner'){
        //        createLab  = 'Create Japan Partner';
        //    }
        //}
        
        //// CAG Button 
        //if(profileName.Contains('CAG') || profileName.Contains('ICorpAcc')) {
        
        //    if(recordTypeName=='CAG Account'){
        //        createLab  = 'Create India CAG Account';
                
        //    }else if(recordTypeName=='CAG Partner'){
        //        createLab  = 'Create India CAG Partner';
        //    }
        //}
        
        //// Capital Market Button
        //if(profileName.Contains('Capital Markets') || profileName.Contains('ABR CM')) {
        
        //    if(recordTypeName=='Capital Markets Investor'){
        //        createLab  = 'Create Capital Markets Investor';
                
        //    }else if(recordTypeName=='Capital Markets Account'){
        //        createLab  = 'Create Capital Markets Account';
        //    }
        //}
        
        //// Structured Finance Button
        //if(profileName.Contains('Structured Finance') || profileName.Contains('ABR SF')) {
        
        //    if(recordTypeName=='Structured Finance Account'){
        //        createLab  = 'Create Structured Finance Account';
                
        //    }else if(recordTypeName=='Structured Finance Partner'){
        //        createLab  = 'Create Structured Finance Partner';
        //    }
        //}
        
        //// China Buttons
        //if(profileName.Contains('China') || profileName.Contains('ABR CH')) {
        
        //    if(recordTypeName=='China Account'){
        //        createLab  = 'Create New China Account';
                
        //    }else if(recordTypeName=='China Partner'){
        //        createLab  = 'Create New China Partner';
        //    }
        //}
        
        //// India Buttons
        //if(profileName.Contains('India') || profileName.Contains('IAL')) {
        
        //    if(recordTypeName=='India Account'){
        //        createLab  = 'Create New India Account';
                
        //    }else if(recordTypeName=='India Partner'){
        //        createLab  = 'Create New India Partner';
        //    }
        //}
        
        // AUS and NZ Buttons
        if(profileName.Contains('AUS') || profileName.Contains('NZ')) {
        
            if(recordTypeName=='Account'){
                createLab  = 'Create New Account';
                
            }else if(recordTypeName=='Partner'){
                createLab  = 'Create New Partner';
            }
        }
        
        //// AUS and NZ Buttons
        //if(profileName.Contains('AUS') || profileName.Contains('NZ')) {
        
        //    if(recordTypeName=='Account'){
        //        createLab  = 'Create New Account';
                
        //    }else if(recordTypeName=='Partner'){
        //        createLab  = 'Create New Partner';
        //    }
        //}

        return createLab ;
    }
    
    // Redirect non Consumer pages based on recordtype  to the standard page layout
    public PageReference redirect(){
 
        PageReference pageRef;

        for (RecordType r : [SELECT DeveloperName FROM RecordType WHERE Id = :recTypeContainer AND SobjectType = 'Account']) {
            if(r.DeveloperName == 'Cards_Aus' || r.DeveloperName == 'Cards_NZ' || r.DeveloperName == 'Broker_AU_Aussie' || r.DeveloperName == 'Broker_AU_Motor_PL'){
                pageRef = null; //Consumer pages stay on the GenericAccountSearch VF page
            }   else{
                pageRef = new PageReference('/001/e?retURL=/001&RecordType='+recTypeContainer+'&ent=Account&nooverride=1');
            }
        }
        return pageRef;
    }    
        
    
    public GenericAccountSearch(ApexPages.StandardController controller){
 
        recTypeContainer = ApexPages.currentPage().getParameters().get('RecordType');
        
        acc =  (Account) controller.getRecord();
        // If Record Type is set as Default
        if (recTypeContainer == null){
            // Using Describe method to get the Account RecordType
            Schema.DescribeSObjectResult describeAccount = Schema.SObjectType.Account;
            List<Schema.RecordTypeInfo> rtInfos = describeAccount.getRecordTypeInfos();
            for(Schema.RecordTypeInfo rtInfo : rtInfos){
            //gettng the correct Deafault Record Type by using the isAvailable Method
                if(rtInfo.getName() != 'Master' && rtInfo.isAvailable()){ 
                    //This would execute only once
                    ApexPages.currentPage().getParameters().put('RecordType', rtInfo.getRecordTypeId());
                    recTypeContainer = rtInfo.getRecordTypeId();
                }
            }
        }
        
        Id profileId=userinfo.getProfileId();
        String pName = '';
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(String.isBlank(recTypeContainer))        
            pName=profileName;
        else
            pName=rtMap.get(recTypeContainer).Name;
        
        //if(pName.contains('CFB')){
        //    recordType = 'CFB';
        //    bookingIdLabel = 'Booking Id';
        //}
        //else if(pName.contains('WCS')){
        //    recordType = 'WCS';
        //    bookingIdLabel = 'Booking System Id';
        //}
        recordTypeName = rtMap.get(recTypeContainer).Name;         
    }

    public List<SelectOption> getAccountStatusValues(){
         List<SelectOption> AccountStatusValues= new List<SelectOption>();               
         AccountStatusValues.add(new SelectOption('','--None--'));
         AccountStatusValues.add(new SelectOption('Inactive','Inactive'));
         AccountStatusValues.add(new SelectOption('Prospect','Prospect'));
         AccountStatusValues.add(new SelectOption('Portfolio Live','Portfolio Live'));         
         return AccountStatusValues; 
     }

    ////redirect to create new record if record is not found in search results
    //public PageReference createNewEMEA() {
        
    //    String retURLContainer = ApexPages.currentPage().getParameters().get('retURL');
    //    String createNewUrlStr = '/001/e?retURL='+retURLContainer+'&RecordType='+recTypeContainer+'&acc2=';
    //    createNewUrlStr = createNewUrlStr +searchNameText+'&ent=Account&nooverride=1';
    //    pageReference newAccountPage = new pageReference(createNewUrlStr);
    //    newAccountPage.setRedirect(true);
    //    return newAccountPage;
    //}
       /*
    * Method name: nzCallout
    * Purpose: Webservice Callout Service for NZ Co No. Search.
    * WSDL Not able to be imported into APEX because of it's specific format so SOAP calls need to be created manually
    */
    @RemoteAction 
    global static List<Result> nzCallout(String srch, String srchType){

        HttpRequest req = new HttpRequest();
        req.setCompressed(false);
        req.setMethod('POST');
        req.setEndpoint('http://ws.business.govt.nz/med-services/services/CompanySearchService.svc');
        req.setHeader('SOAPAction', 'performPublicNameSearch');
        req.setClientCertificate(b64NZKey,'gecap10');
        req.setBody(nzSrchReq(srch, srchType));
        req.setTimeout(60000);
        Http http = new Http();
        HTTPResponse res = http.send(req);
       
        utils.log('---#res.getStatus#---> ' + res.getStatus() + ' ---#res.getStatusCode#---> ' 
                    + res.getStatusCode() + '\n\nNZ RESPONSE ==== '+res.getBody());
        // Send to Parser
        if(!setResErrCode.contains(res.getStatusCode())){//27092011: Shree Prashant: Check whether site is available
            return readNZCallout(res.getXmlStreamReader());
        }
        return null;
    }//End Func nzCallout
    
      /*
    * Method name: readNZCallout
    * Purpose: Webservice Callout Service for ABN Search
    * Soap service was found to be unreliable in testing so used HTTP GET service
    */
    @RemoteAction
    global static List<Result> abnCallout(String srch, String srchType){
        HttpRequest req = new HttpRequest();
        if(srchType == 'ABN'){
            req.setEndpoint('http://abr.business.gov.au/abrxmlsearchRpc/ABRXMLSearch.asmx/ABRSearchByABN?searchString='+srch+
                                '&includeHistoricalDetails=N&authenticationGuid='+abnGUID);
        }
        if(srchType == 'Name'){
            req.setEndpoint('http://abr.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx/ABRSearchByNameAdvancedSimpleProtocol?name='+srch+
                            '&postcode=&legalName=Y&tradingName=Y&NSW=&SA=&ACT=&VIC=&WA=&NT=&QLD=&TAS=&searchWidth=&minimumScore=90&maxSearchResults='+
                            '&authenticationGuid='+abnGUID);
        }
        req.setMethod('GET');
        req.setTimeout(60000);
        Http http = new Http();
        HTTPResponse res = http.send(req);

        Utils.log('---#res.getStatus#---> ' + res.getStatus() + ' ---#res.getStatusCode#---> ' + 
                    res.getStatusCode() + '\n\nAU RESPONSE ==== '+res.getBody());
        // Send to Parser
        if(!setResErrCode.contains(res.getStatusCode())){//27092011: Shree Prashant: Check whether site is available
            return readABNCallout(res.getXmlStreamReader());
        }
        return null;
    }//End Func abnCallout

    
    public static String nzSrchReq(String srch, String srchType){
        XmlStreamWriter w = new XmlStreamWriter();
        
        w.writeStartDocument('UTF-8', '1.0');
        w.writeStartElement('soapenv', 'Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
        w.writeNamespace('soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
        w.writeNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');
        w.writeNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        w.writeStartElement('soapenv', 'Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        
        if(srchType == 'Name'){
            w.writeStartElement('ns1', 'performPublicNameSearch', 'http://schemas.xmlsoap.org/soap/envelope/');
            w.writeAttribute(null, null, 'soapenv:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeAttribute(null, null, 'xmlns:ns1', 'MED:CompaniesSearchServices');
            w.writeStartElement(null, 'name', null);
            w.writeAttribute(null, null, 'xsi:type', 'xsd:string');
            w.writeCharacters(srch);
            w.writeEndElement();
            w.writeEmptyElement(null, 'resultsPerPage', null);
            w.writeAttribute(null, null, 'href', '#id0');
            w.writeEndElement();
            w.writeStartElement(null, 'multiRef', null);
            w.writeAttribute(null, null, 'id', 'id0');
            w.writeAttribute(null, null, 'soapenc:root', '0');
            w.writeAttribute(null, null, 'soapenv:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeAttribute(null, null, 'xsi:type', 'xsd:integer');
            w.writeAttribute(null, null, 'xmlns:soapenc', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeCharacters('1000');
        }else{
            w.writeStartElement('ns1', 'performPublicNumberSearch', 'http://schemas.xmlsoap.org/soap/envelope/');
            w.writeAttribute(null, null, 'soapenv:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeAttribute(null, null, 'xmlns:ns1', 'MED:CompaniesSearchServices');
            w.writeEmptyElement(null, 'companyNumber', null);
            w.writeAttribute(null, null, 'href', '#id0');
            w.writeEmptyElement(null, 'resultsPerPage', null);
            w.writeAttribute(null, null, 'href', '#id1');
            w.writeEndElement();
            w.writeStartElement(null, 'multiRef', null);
            w.writeAttribute(null, null, 'id', 'id0');
            w.writeAttribute(null, null, 'soapenc:root', '0');
            w.writeAttribute(null, null, 'soapenv:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeAttribute(null, null, 'xsi:type', 'xsd:int');
            w.writeAttribute(null, null, 'xmlns:soapenc', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeCharacters(srch);
            w.writeEndElement();
            w.writeStartElement(null, 'multiRef', null);
            w.writeAttribute(null, null, 'id', 'id1');
            w.writeAttribute(null, null, 'soapenc:root', '0');
            w.writeAttribute(null, null, 'soapenv:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeAttribute(null, null, 'xsi:type', 'xsd:integer');
            w.writeAttribute(null, null, 'xmlns:soapenc', 'http://schemas.xmlsoap.org/soap/encoding/');
            w.writeCharacters('100');
        } 
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();    
        w.writeEndDocument();      
        
        String xmlOutput = w.getXmlString();
        w.close();
        Utils.log('NZ REQUEST ==== '+xmlOutput);
        return xmlOutput;
    }//End Func nzSrchReq
      /*
    * Method name: readNZCallout
    * Purpose:This method is used to create XML Parser to resolve results
    */
    
    public static List<Result> readNZCallout(XmlStreamReader body){
        String name_tmp = '';
        String abn_tmp = '';
        String status_tmp = '';
        List<Result> results = new List<Result>();        
        while(body.hasNext()){
            if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'companyName'){
                // we skip because of XML Format
                // <companyName xsi:type="xsd:string">XXXX XXXX</companyName><companyNumber xsi:type="xsd:integer">xxxxxx</companyNumber>
                body.next();
                if(body.getEventType() == XmlTag.CHARACTERS){
                    name_tmp = body.getText();
                }
            }
            else if(body.getEventType() == XMLTag.START_ELEMENT && body.getLocalName() == 'companyNumber'){
                // we skip because of XML Format
                body.next();
                if(body.getEventType() == XmlTag.CHARACTERS){
                    abn_tmp = body.getText();
                }
                // Add to results list
                if(name_tmp.contains('STRUCK OFF')){
                    status_tmp = 'Struck Off';
                }else{
                    status_tmp = 'Registered';
                }
                results.add(new Result(null, false, name_tmp, '', status_tmp, abn_tmp, '', '', '',null,false));//Shree Prshant: 02072011
            }else{
                body.next();
            }   
        }
        return results;
    }//End Func readNZCallout
    
    // Results Wrapper (use wrapper incase > 1000 results) to be safe
    global class Result{
        public String  Id {get;set;}
        public Boolean existing {get;set;}
        public String  Name {get;set;}
        public String  LegalName {get;set;}
        public String  Status {get;set;}
        public String  ABN {get;set;}
        public String  Phone {get;set;}
        public String  Postcode {get;set;}
        public String  State {get;set;}
        public String  CompanyIdentifier { get; set; } //For India Business : Prashant-02072011
        public Boolean IndiaBusiness {get; set;} //For India Business : Prashant-02072011

        // Construct a wrapper element to hold results
        global Result(String cId, Boolean cExisting, String cName, String cLegalName, 
                        String cStatus, String cABN, String cPhone, String cPost, String cState, 
                        String cCompIdentifier, Boolean cIndiaBusiness){
            Id       = cId;
            existing = cExisting;
            Name     = cName;
            LegalName= cLegalName;
            Status   = cStatus;
            ABN      = cABN;
            Phone    = cPhone;
            Postcode = cPost;
            State    = cState;
            CompanyIdentifier = cCompIdentifier; //For India Business : Prashant-02072011
            IndiaBusiness     = cIndiaBusiness; //For India Business : Prashant-02072011
        }
    }//End Wrapper Class Result
    
      /*
    * Method name: readABNCallout
    * Purpose: XML Parser to resolve results
    */
    public static List<Result> readABNCallout(XmlStreamReader body){ 
        String abn_tmp = '';
        String status_tmp = '';
        String name_tmp = '';
        String legalname_tmp = '';
        String post_tmp = '';
        String state_tmp = '';
        List<Result> results = new List<Result>();
        while(body.hasNext()){
            /* if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'exception'){
                body.next();
                body.next();
                body.next();
                showErr = true;             
            }
            else */
            if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'ABN'){
                //  we skip because of the XML format
                // <ABN><identifierValue>XX XXX XXX XXX</identifierValue></ABN>...
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    abn_tmp = body.getText();
                }
                body.next();
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    status_tmp = body.getText();
                }
            }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'entityStatus'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    status_tmp = body.getText();
                }
            }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'mainName'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    name_tmp = body.getText();
                }
          }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'otherTradingName'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    name_tmp = body.getText();
                }
          }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'mainTradingName'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    name_tmp = body.getText();
                }
          }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() == 'legalName'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    name_tmp = body.getText();
                }
          }else if(body.getEventType() == XmlTag.START_ELEMENT && body.getLocalName() 
                                        == 'mainBusinessPhysicalAddress'){
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){state_tmp = body.getText();}
                //  we skip because of the XML format
                body.next();
                body.next();
                body.next();
                body.next();
                // Make sure we have a character value and not an empty XML tag
                if(body.getEventType() == XmlTag.CHARACTERS){
                    post_tmp = body.getText();
                }
                // Add to results list.
                results.add(new Result(null, false, name_tmp, legalname_tmp, status_tmp, 
                                        abn_tmp, '', post_tmp, state_tmp,null,false));//Shree Prshant: 02072011
          }else{
                body.next();
          }
        }//End While
        return results;     
    }//End Func readABNCallout
    
    /*
    * Method name: Save
    * Purpose: To save account object
    */
    
    public PageReference save(){
        //Account a = new Account();
        try{    
           /* a.Name = accountNameValue;
            if(getShowABNINP()){
                a.ABN__c = abnValue;
            }
            if(getShowNZCoINP()){
                a.NZ_Company_Incorporation_Number__c= nzCoValue;
            }
            a.Phone = phoneValue;
            if(getShowCompIdenINP()){
                a.Company_Identifier__c = compIdenValue;
            }
            if(getShowCityINP()){
                a.BillingCity = cityValue;
            }
            if(getShowStateINP()){
                a.BillingState = stateValue;
            }
            if(getShowPCodeINP()){
                a.BillingPostalCode = pCodeValue;
            }*/
            if(profileName.contains('Structured Finance')){ //Ashutosh: 1/9/2012
                User u = [Select Country from User where id =: UserInfo.getUserId()];
                acc.BillingCountry = u.Country;
            }
            acc.RecordTypeId=recTypeContainer;
            insert acc; 
            if(acc.Id != null){// redirects to new Account
                PageReference p = new PageReference('/' + acc.Id + '/e?retURL=%2F' + acc.Id);
                p.setRedirect(true);
                return p;
            }
        }catch(DmlException ex){ 
            ApexPages.addMessages(ex); 
        }
        return null;
    }//End Func save()
}