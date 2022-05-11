/*
 * @History:
   =====================================================================
       12-13-13: Updated Defect 1025 - Update save method to update out of synch when a new
       personal reference workflow is added - DYU
       2015-05-28: TXU - Refined Datatool
   =====================================================================
 */ 
public class App_Personal_Reference_Ext extends APP_CommonExt  {
    
  public Personal_Reference_Check__c personalReference{get;set;}
  public String addressSearch{get;set;}
  public String brandCountry {get;set;}
  public String webServer  {get;set;}
  public String URLKey                                {get;set;}
  public String webServerWebService                   {get;set;}
  
  //TXU for NZ DataTool
  public String NZEndPoint                            {get;set;}
  public String NZRequestKey                          {get;set;}
  
  Application__c app;
  public App_Personal_Reference_Ext(ApexPages.StandardController controller) {
    brandCountry = Profile_Country__c.getInstance().NZ__c ? 'NZ':'AU';
    webServer = Datatools__c.getValues('Datatools').Endpoint__c;
    webServerWebService = Datatools__c.getValues('Datatools').Endpoint_json_ws__c;
    URLKey = Datatools__c.getValues('Datatools').URL_Key__c;
    
    //NZ Data tool details
    NZEndPoint = Datatools__c.getValues('Datatools').NZ_Endpoint__c;
    NZRequestKey = Datatools__c.getValues('Datatools').NZ_Request_Key__c;
    
    app = (Application__c)controller.getRecord();
    personalReference = new Personal_Reference_Check__c();
    personalReference.Application__c = app.Id;
    system.debug('personal reference: '+personalReference.Application__c);
  }
  
  public List < SelectOption > getStreetTypeOptionsInt() {
            
            
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
            List < Street_Type_Setting__c > streetTypeSetting = [SELECT Value_Abbreviated__c, Value_Abbreviated_NZ__c, Value__c, Region__c FROM Street_Type_Setting__C ORDER BY Value__c]; //changed by Tony Xu, NZ street type abbreviation different with AU street type abbreviation
            for (Street_Type_Setting__c sts: streetTypeSetting) {
            	    system.debug('sts region: '+sts.Region__c);
                  if(sts.Region__c.trim() == 'Both' && brandCountry == 'NZ') {
            	      options.add(new SelectOption(sts.Value_Abbreviated_NZ__c, sts.Value__c));
            	      continue;
            	    }
            	    
            	    if(sts.Region__c.trim() == 'Both' && brandCountry == 'AU') {
            	       options.add(new SelectOption(sts.Value_Abbreviated__c, sts.Value__c));
            	      continue;
            	    }
            	    
                  if (sts.Region__c.trim() == 'NZ') {
                        options.add(new SelectOption(sts.Value_Abbreviated_NZ__c, sts.Value__c));
                        continue;
                  }
                  if (sts.Region__c.trim() == 'AU') {
                        options.add(new SelectOption(sts.Value_Abbreviated__c, sts.Value__c));
                        continue;
                  }
            }
            return options;

        }
   
    public List < SelectOption > getCountryOptsInt() {
        system.debug('brand country : ' + brandCountry);
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', 'Please Select'));
        if (brandCountry == 'NZ') {
            options.add(new SelectOption('New Zealand', 'New Zealand'));
        } else {
            options.add(new SelectOption('Australia', 'Australia'));
        }
        return options;


    }     
    
     public List < SelectOption > stateOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('', 'Please Select'));
                List < State_Setting__c > StateSetting = [SELECT Value__c FROM State_Setting__c ORDER BY Value__c];

                for (State_Setting__c st: StateSetting) {
                    options.add(new SelectOption(st.Value__c, st.Value__c));
                }
                return options;
            }
            set;
        }
    
    public PageReference save() {
      system.debug('brandCountry: '+brandCountry+' '+personalReference.Name__c+' '+personalReference.Street_Number__c);
      if(brandCountry == 'NZ' && (String.isBlank(personalReference.Name__c) || String.isBlank(personalReference.Street_Number__c) || String.isBlank(personalReference.Street_Name__c) 
                                  || String.isBlank(personalReference.Street_Type__c) || String.isBlank(personalReference.Town_City__c) || String.isBlank(personalReference.Postcode__c)
                                  || String.isBlank(personalReference.Country__c) || String.isBlank(personalReference.Phone_Number__c) || String.isBlank(personalReference.Relationship__c))) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter all required fields'); 
        ApexPages.addMessage(myMsg);
        return NULL;
      }
      else if(brandCountry == 'AU' && (String.isBlank(personalReference.Name__c) || String.isBlank(personalReference.Street_Number__c) || String.isBlank(personalReference.Street_Name__c) 
                                  || String.isBlank(personalReference.Street_Type__c) || String.isBlank(personalReference.Suburb__c)|| String.isBlank(personalReference.State__c) || String.isBlank(personalReference.Postcode__c)
                                  || String.isBlank(personalReference.Country__c) || String.isBlank(personalReference.Phone_Number__c) || String.isBlank(personalReference.Relationship__c))) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter all required fields'); 
        ApexPages.addMessage(myMsg);
        return NULL;
      }
      system.debug('test: '+validateAddress());
      if(!validateAddress()) {
        return NULL;
      }
      Set<String> stLocalCodes = new Set<String>{'02','03','04','06','07','09'};
      if(brandCountry == 'NZ') {
      	list<RecordType> recTy=[select id from recordtype where sobjecttype='Personal_Reference_Check__c' and name=:brandCountry];
      	 personalReference.recordtypeid=recTy[0].id;
         if(!stLocalCodes.contains(personalReference.Phone_Number__c.substring(0,2))) {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter a 9-digit landline phone number with the area code(e.g. 03, 04, 06, 07, 09) or a mobile number starting with 02.'); 
           ApexPages.addMessage(myMsg);
           return NULL;  
         }
         else if(personalReference.Phone_Number__c.substring(0,2) == '02') {
         
           if (personalReference.Phone_Number__c.length() < 9 || personalReference.Phone_Number__c.length() >11) {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter a 9-11 digit mobile phone number starting with 02.'); 
             ApexPages.addMessage(myMsg);
             return NULL;
           } 
         }
         else if(personalReference.Phone_Number__c.length() != 9)  {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a 9-digit landline phone number with the area code(e.g. 03, 04, 06, 07, 09)'); 
           ApexPages.addMessage(myMsg);
           return NULL;  
         } 
         
      }
      try {
        insert personalReference;
        
        //
        FeedItem post = new FeedItem();
    		post.ParentId = app.Id;
    		//post.ContentDescription = 'fsdfsdf';
    		post.type = 'LinkPost';
    		post.LinkUrl = '/'+personalReference.Id ; 
    		post.Title = [Select Name from Personal_Reference_Check__c Where Id =: personalReference.Id].Name + ' created';
    		insert post;
        
        personalReference = new Personal_Reference_Check__c(); 
        personalReference.Application__c = app.Id;
        addressSearch = '';
      }
      catch(DMLException de) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,de.getDMLMessage(0)); 
           ApexPages.addMessage(myMsg);
           return NULL;  
      }
      //Added by DYU Defect 1055 - Update Dirty Flag when new personal reference workflow is added
      Savepoint sp = Database.setSavepoint();
       try {
          system.debug('test personal reference: '+app);
            updateAndSetApplicationOutOfSync(this.app);
        } catch(DMLException e){
            setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_Personal_Reference_Ext', 'Application__c', 'Class', String.valueOf(this.app.Id));
        }
      return NULL;
    }
    
    
    public List < SelectOption > relationshipOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('', 'Please Select'));
                 Schema.DescribeFieldResult fieldResult =
 Personal_Reference_Check__c.Relationship__c.getDescribe();
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
   for( Schema.PicklistEntry f : ple)
   {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
   }    
   list<String> addNZRelation = new list<String>{'Work Colleague','Employer','Landlord','Solicitor','Doctor','Accountant','In-Law '}; 
   if(brandCountry == 'NZ') {
   for( String str : addNZRelation)
   {
      options.add(new SelectOption(str, str));
   }
   }
   return options;
            }
            set;
        }
    
   
   public Boolean validateAddress() {
   	 String applicationCountry =  brandCountry;
   	 if ((personalReference.Property_Name__c != null) && personalReference.Property_Name__c.length()>20) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Your property name must be less than 21 characters.'); 
           ApexPages.addMessage(myMsg);
           return false; 
        }
        if ((personalReference.Unit_number__c != null) && personalReference.Unit_number__c.length()>4) {
        	 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Your unit number must be less than 5 characters.'); 
           ApexPages.addMessage(myMsg);
           return false;
          
        }
       if (personalReference.Street_Number__c!=null && personalReference.Street_Number__c.length()>6) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Your street number must be less than 7 characters.'); 
           ApexPages.addMessage(myMsg);
           return false;
        }
        if (applicationCountry == 'AU') {
           if (personalReference.Street_Name__c.length()>15) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Your street name must be less than 16 characters.'); 
              ApexPages.addMessage(myMsg);
              return false;
            } 
            /*else if (personalReference.Street_Name__c != NULL && !personalReference.Street_Name__c.isAlpha()) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter only alpha characters.'); 
                ApexPages.addMessage(myMsg);
                return false;
            }
            */
           
        }
        if (applicationCountry == 'NZ') {
           if (validateStreet(personalReference.Street_Name__c) == false) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Only letter, numbers, hyphens, ampersand and apostrophes are permitted in street.'); 
                ApexPages.addMessage(myMsg);
                return false;
            } /**else if (personalReference.Street_Name__c != null && personalReference.Street_Name__c.Length() > 15 ) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Your street name must be less than 16 characters.'); 
                ApexPages.addMessage(myMsg);
                return false;
            }**/
        }
       system.debug('validate country: '+validateSuburb(personalReference.Suburb__c, applicationCountry));
        if (personalReference.Suburb__c != null && personalReference.Suburb__c != '' && validateSuburb(personalReference.Suburb__c, applicationCountry) == false) {
            if (applicationCountry == 'AU')
                {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Numbers are not permitted in suburb.'); 
                  ApexPages.addMessage(myMsg);
                  return false;
                }
            if (applicationCountry == 'NZ')
             {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Only letters, numbers and hyphens are permitted in suburb.'); 
                ApexPages.addMessage(myMsg);
               return false;
             }
        }
        if (applicationCountry == 'NZ') {
            if (validateCity(personalReference.Town_City__c) == false) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Only letters, hyphens are permitted in city.'); 
                ApexPages.addMessage(myMsg);
                return false;
            } else if (personalReference.Town_City__c.length() > 22) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Your city must be less than 22 characters.'); 
                ApexPages.addMessage(myMsg);
                return false;
            }
            
        }
        
            if (!APP_CommonExt.isPostcodeValid(String.valueOf(personalReference.Postcode__c))) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid postal code.'); 
                ApexPages.addMessage(myMsg);
                return false;
            }
     return true;
   }
   
   
    //updated pattern to handle new zealand addresses
    public static Boolean validateSuburb(string name, String country) {
        Boolean flag = false;
        if (Util.nullCheck(name)) {     //05.14.15 Mike Lasala: Code Scan fix
            String patternName = '';
            if (country == 'AU')
                patternName = '([/^([^0-9]*)$/]+)';
            if (country == 'NZ')
                patternName = '([a-zA-Z0-9_\\- ]+)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateCity(string name) {
        Boolean flag = true;
        if (Util.nullCheck(name)) {     //05.14.15 Mike Lasala: Code Scan fix
            String patternName = '([a-zA-Z_\\- ]+)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateStreet(string name) {
        Boolean flag = true;
        if (Util.nullCheck(name)) {     //05.14.15 Mike Lasala: Code Scan fix
            String patternName = '([a-zA-Z0-9\\-&\' ]+)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }
}