/* @Description: Controller for Loan Purpose component
 * @Author: Mike Lasala
 * @Date Created: JAN-31-2014
 * @History:
   =====================================================================
       01-31-14: Created - Mike
       11-25-14: Added code to display loan purpose as per region
   =====================================================================
 */ 
public with sharing class APP_LoanPurpose extends APP_CommonExt{
    
    //Added by vijay.
    public string Region{get;set;}
    public string typeOfProd {get;set;}
    public APP_LoanPurpose(){
         
    }
    
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Title Field Picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-22-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> loanPurposeOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            List<Meta_ONR__c> metaONR = new List<Meta_ONR__c>();
            if(typeOfProd != GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)
                            metaONR = [SELECT    Value__c,region__c 
                                         FROM      Meta_ONR__c 
                                         WHERE     ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                                          AND      Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                                         ORDER BY  Value__c ASC];
            
            options.add(new SelectOption('', 'Please Select'));
            if(typeOfProd == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)
                options.add(new SelectOption(GEN_OriginationsConstants.ONR_CAR_PURCHASE, GEN_OriginationsConstants.ONR_CAR_PURCHASE));
            String other = '';
            for(Meta_ONR__c mONR: metaONR){
                if(mONR.value__c == 'Other'){
                    other = mONR.value__c;    
                }else{
                    //Added by vijay 24/11/2014
                    if(Region.equals(system.label.NZ_Site_Name) && (mONR.region__c.contains('NZ')||mONR.region__c.contains('Both') )){
                        options.add(new SelectOption(mONR.value__c,mONR.value__c));
                    }else{
                        //Added by vijay..
                        if(!Region.equals(system.label.NZ_Site_Name) && (mONR.region__c.contains('AU') ||mONR.region__c.contains('Both'))){
                            options.add(new SelectOption(mONR.value__c,mONR.value__c));
                        }
                    }
                }
            }
            if(other!= '')
                options.add(new SelectOption(other,other));
            return options;
        }
    set; 
    }
    
    /*  Description: Title Field Picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-22-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> loanPurposeOptionsMain { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            //Below condition added by suneel better start
             if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' && site.getName()=='latitude'){                
                 options.add(new SelectOption('Debt consolidation','Debt consolidation'));
             }else if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' && site.getName()=='kiwibank'){                      
                 options.add(new SelectOption('Consolidation','Consolidation'));
             }
            List<Meta_ONR__c> metaONR = [SELECT    Value__c,region__c 
                                         FROM      Meta_ONR__c 
                                         WHERE     ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                                          AND      Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                                          AND      Value__c !=:  GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE
                                          AND      Value__c != 'Beat Your Rate; Switch Now'
                                         ORDER BY  Value__c ASC];
            
           options.add(new SelectOption('Please Select', 'Please Select'));
            String other = '';
            for(Meta_ONR__c mONR: metaONR){
                if(mONR.value__c == 'Other'){
                    other = mONR.value__c;    
                }else{
                    
                    //Added by vijay 24/11/2014
                   if(Region.equals(system.label.NZ_Site_Name) && (mONR.region__c.contains('NZ')||mONR.region__c.contains('Both') )){
                       options.add(new SelectOption(mONR.value__c,mONR.value__c));
                    }else{
                        //Added by vijay..
                       if(!Region.equals(system.label.NZ_Site_Name) && (mONR.region__c.contains('AU') ||mONR.region__c.contains('Both'))){
                            options.add(new SelectOption(mONR.value__c,mONR.value__c));
                        }
                    }
                }
            }
            options.add(new SelectOption(other,other));
            return options;
        }
    set; 
    }
    
    //Added by Suneel - Save and Switch 1% pa
    public List<SelectOption> loanPurposeOptionsForGem {
     get {
            List<SelectOption> options = new List<SelectOption>();
            //Below condition added by suneel better start
             if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' && site.getName()=='Gem'){
                 options.add(new SelectOption('Consolidation','Consolidation'));
             }            
            List<Meta_ONR__c> metaONR = [SELECT    Value__c,region__c 
                                         FROM      Meta_ONR__c 
                                         WHERE     ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                                          AND      Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                                          AND      Value__c !=:  GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE
                                          AND      Value__c != 'Beat Your Rate; Switch Now'                                          
                                         ORDER BY  Value__c ASC];
            
            options.add(new SelectOption('Please Select', 'Please Select'));
            String other = '';
            for(Meta_ONR__c mONR: metaONR){
                if(mONR.value__c == 'Other'){
                    other = mONR.value__c;    
                }else{
                    //Added by vijay 24/11/2014
                   if(Region.equals(system.label.NZ_Site_Name) && mONR.region__c.contains('Gem') || (mONR.region__c.contains('NZ')||mONR.region__c.contains('Both') )){
                       options.add(new SelectOption(mONR.value__c,mONR.value__c));
                    }
                }
            }
            options.add(new SelectOption(other,other));
            return options;
        }
    set; 
    }
    
      /* Decription: Better Start */
    public void getLoanPurposeOnProduct(){
       }
  
    /* End */

}