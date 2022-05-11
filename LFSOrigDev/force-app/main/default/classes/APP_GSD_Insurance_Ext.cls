/* @Description: Apex controller for APP_GSD_Insurance.page
 * @Author : Russell Cadapan
 * @Date : 02-JUN-2016
 * @History:
   =========================================================================================================
        02-JUN-2016 : Created - Russell Cadapan
   =========================================================================================================
*/
global class APP_GSD_Insurance_Ext extends APP_GSD_BaseController{

  
    
    // application record to be updated after calculation
    private static Application__c thisApplication;
    
    // variable to determin which bundle has been selected from the page
    public String bundleSelected    {get;set;}
    
    // Adding variables to hide Interest rate and Monthly Repayment - Suneel 07/02/2018
    public List<Loan_Purpose__c> UpsellLps {get;set;}
    public String loanPurposeUpsell {get;set;}
    public Boolean isLPUpsell {get;set;} 
    public List<Application__c> application {get;set;}
        
    public APP_GSD_Insurance_Ext(){
        isLPUpsell = true;
         // Hiding Interest Rate and Monthly Repayments bubbles in Upsell page – Added By Suneel - 07/02/2018
         //Get Application Id
        Id appId = ApexPages.currentPage().getParameters().get('id');
        UpsellLps = [Select Application__c,Value__c from Loan_Purpose__c where Application__c = : appId];
        application = [Select Brand_Country__c,Channel__c from Application__c where Id = : appId];
        for(Application__c appBrand : application){
        if(appBrand.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){
            /**Show the interest rate and Min. monthly repayment bubbles for all risk grades.
           Also do not show the Rate and Min. monthly repayment bubbles for Brokers. */
            if(appBrand.Channel__c == 'Broker')
                {
                        isLPUpsell = false;
                        break;
                }      
        }
        }
        //End
   } 
      
    /*  Description: Wrapper class Insurance Products
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
    */
    global class InsuranceProductWrapper{
        // insurance product name
        global String insuranceProductName;
        
        // insurance product description
        global String insuranceProductDescription;
        
        // insurance product description
        global String insuranceProductDisplayName;
        
        // insurance product salesforce Id (GEProduct__c)
        global String insuranceProductId;
        
        global String insuranceProductVersionId;
        
        // InsuranceProductWrapper class constructor
        global InsuranceProductWrapper(String insuranceProductName, String insuranceProductDescription, String insuranceProductId, String insuranceProductVersionId, String insuranceProductDisplayName){
            this.insuranceProductName = insuranceProductName;
            this.insuranceProductDescription = insuranceProductDescription;
            this.insuranceProductId = insuranceProductId;
            this.insuranceProductVersionId = insuranceProductVersionId;
            this.insuranceProductDisplayName = insuranceProductDisplayName;
        }
    }
    
    /*  Description: Wrapper class Insurance Bundles
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
    */
    global class InsuranceBundleWrapper{
        
        // list of insurance products (InsuranceProductWrapper) that will be in a bundle 
        global List<InsuranceProductWrapper> insuranceProductWrapplerList;
        
        // bundle name
        global String insuranceBundleName;
                
        // bundle insurance repayments        
        global Decimal insuranceRepayments;
        
        // bundle insurance premium
        global Decimal insurancePremium;
        
        // bundle insurance premium
        global Decimal insuranceInterestPremium;
        
        // boolean indicator is bundle contains life insurance for applicant 1
        private Boolean isLifeSingle;
        
        // boolean indicator is bundle contains Disability insurance for applicant 1
        private Boolean isDisSingle;
        
        // boolean indicator is bundle contains IUI insurance for applicant 1
        private Boolean isIUISingle;
        
        // boolean indicator is bundle contains life insurance for applicant 2
        private Boolean isLifeJoint;
        
        // boolean indicator is bundle contains Disability insurance for applicant 2
        private Boolean isDisJoint;
        
        // boolean indicator is bundle contains IUI insurance for applicant 2
        private Boolean isIUIJoint;
        
        private Long appLastModifiedTimeStamp;

        // InsuranceBundleWrapper class constructor
        global InsuranceBundleWrapper(String insuranceBundleName,
                                        Boolean isLifeSingle, Boolean isDisSingle, Boolean isIUISingle,
                                        Decimal insurancePremium, Decimal insuranceRepayments, Decimal insuranceInterestPremium, Long appLastModifiedTimeStamp){
            this.insuranceProductWrapplerList = new List<InsuranceProductWrapper>();
            this.insuranceBundleName = insuranceBundleName;
            this.isLifeSingle = isLifeSingle;
            this.isDisSingle = isDisSingle;
            this.isIUISingle = isIUISingle;
            this.isLifeJoint = false;
            this.isDisJoint = false;
            this.isIUIJoint = false;
            this.insurancePremium = insurancePremium;
            this.insuranceRepayments = insuranceRepayments;
            this.insuranceInterestPremium = insuranceInterestPremium;
            this.appLastModifiedTimeStamp = appLastModifiedTimeStamp;
        }
    }
    
    /*  Description: Wrapper class Insurance Bundles
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
    */
    global class InsuranceResultWrapper{
        // boolean indicator whether the saving of application is successful or not
        global Boolean isSuccessful;

        // result message, more essential to error handling as to display alert message to the customer
        global String resultMessage;

        // boolean indicator whether to alert the message to the user or not
        global Boolean displayMessage;

        // wrapper constructor
        global InsuranceResultWrapper(Boolean isSuccessful, String resultMessage, Boolean displayMessage){
            this.isSuccessful = isSuccessful;
            this.resultMessage = resultMessage;
            this.displayMessage = displayMessage;
        }
    }

    // list of bundle wrapper
    global static List<InsuranceBundleWrapper> insuranceBundleList;
    
    /*  Description: Remote action to create bundles depending on the Customer's eligibility
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: String applicationId
     *  Return: List<InsuranceBundleWrapper>
    */
    @RemoteAction
    global static List<InsuranceBundleWrapper> retrieveBundles(Id applicationId, Decimal newLoanAmount, String newLoanTerm){
        
        insuranceBundleList = new List<InsuranceBundleWrapper>();
        
        // query application
        // thisApplication = getApplication(applicationId);
        thisApplication = APP_GSD_BaseController.recalculateApplication(applicationId, newLoanAmount, newLoanTerm);
        
        // query insurance products based from application's brand
        List<GEProduct__c> brandInsuranceProducts = new List<GEProduct__c>();
        
        if(thisApplication != null){
            brandInsuranceProducts = [SELECT Id,
                                            Name,
                                            Description__c,
                                            (SELECT Id FROM Product_Versions__r)
                                        FROM GEProduct__c
                                        WHERE Brands__c =: thisApplication.Brand_Lookup__c
                                        AND Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE_INSURANCE
                                        ORDER BY Insurance_Type_Num__c ASC];
        }
        
        // create insurance product wrapper for each insurance product retrieved
        List<InsuranceProductWrapper> insuranceProductsList = new List<InsuranceProductWrapper>();
        
        Map<String, String> insuranceProductsDescription = thisApplication.Brand_Country__c == GEN_OriginationsConstants.AU_REGION ? insuranceProductsDescriptionAU : insuranceProductsDescriptionNZ;
        Map<String, String> insuranceProductsDisplayName = thisApplication.Brand_Country__c == GEN_OriginationsConstants.AU_REGION ? insuranceProductsDisplayNameAU : insuranceProductsDisplayNameNZ;
        
        if(!brandInsuranceProducts.isEmpty()){
            for(GEProduct__c gep: brandInsuranceProducts){
                insuranceProductsList.add(new InsuranceProductWrapper(gep.Name, insuranceProductsDescription.get(gep.Name), gep.Id, gep.Product_Versions__r[0].Id, insuranceProductsDisplayName.get(gep.Name)));
            }
        }
        
        // create insurance bundles based from application's insurance eligibility
        // if insurance eligibility flag is either 0 or 1 = not eligible
        // if insurance eligibility flag is 2, eligible for BASIC COVER ( DIS + IUI)
        // if insurance eligibility flag is 3, eligible for BASIC COVER ( DIS + IUI ) and FULL COVER (LIFE + DIS + IUI)
        
        Decimal applicationInsuranceEligibilityFlag = thisApplication.Insurance_Eligibility_Flag_Applicant_1__c;
        
        if(applicationInsuranceEligibilityFlag == 3){
        
         //Adding the Bundle Matrix condition for AU by Suneel - NFLPI
         if(thisApplication.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){
            // calculate insurancePremium for Basic Bundle
            /** Updated by Suneel 09/03/2018, As per NFLPI phase 1, 
            1. Stopping life cover and IUI, basic cover is only disability. 
            2. Earlier basic cover was IUI + disability. 
            3. Hence passing "false" as a third value within calculation function below so only Disability prem is calculated. Life and IUI are not calculated.
            **/
          Decimal basicBundleInsurancePremium = calculateInsurancePremium(thisApplication, false, true, false);
               // create basic cover bundle          
              /** Updated by Suneel 09/03/2018, As per NFLPI phase 1, 
                1. Stopping life cover and IUI, basic cover is only disability. 
                2. Earlier basic cover was IUI + disability. 
                3. Hence passing "false" as a fourth value within basic cover bundle below.
                **/
                
          InsuranceBundleWrapper insuranceBasicBundle = new InsuranceBundleWrapper(Label.Basic_Bundle_Name, false, true, false,
                                                                                        basicBundleInsurancePremium,
                                                                                        calculateInsuranceRepayments(thisApplication, basicBundleInsurancePremium),
                                                                                        calculateInsuranceInterest(thisApplication, basicBundleInsurancePremium),
                                                                                        thisApplication.LastModifiedDate.getTime());  
            for(InsuranceProductWrapper ipw: insuranceProductsList){
                if(ipw.insuranceProductName != GEN_OriginationsConstants.LIFE_INSURANCE && ipw.insuranceProductName != GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                    insuranceBasicBundle.insuranceProductWrapplerList.add(ipw);
                }
            }
            
            // calculate insurancePremium for Full Bundle
             /** Updated by Suneel 09/03/2018, As per NFLPI phase 1, 
            1. Stopping life cover, full cover is only disability and IUI. 
            2. Earlier full cover was LI + IUI + disability. 
            3. Hence added "LI" to the ignored list from new Life cover. Life was already excluded as part of if statement.
            **/
            Decimal fullBundleInsurancePremium = calculateInsurancePremium(thisApplication, false, true, true);
            // create full cover bundle
            /** Updated by Suneel 09/03/2018, As per NFLPI phase 1, 
                1. Stopping life cover, full cover is only disability and IUI. 
                2. Earlier basic cover was LI + IUI + disability. 
                3. Hence passing "false" as a second variable from new full cover.
                **/
              InsuranceBundleWrapper insuranceFullBundle = new InsuranceBundleWrapper(Label.Full_Bundle_Name, false, true, true,
                                                                                        fullBundleInsurancePremium,
                                                                                        calculateInsuranceRepayments(thisApplication, fullBundleInsurancePremium),
                                                                                        calculateInsuranceInterest(thisApplication, fullBundleInsurancePremium),
                                                                                        thisApplication.LastModifiedDate.getTime());
                                                                                        
            for(InsuranceProductWrapper ipw: insuranceProductsList){
            if(ipw.insuranceProductName != GEN_OriginationsConstants.LIFE_INSURANCE){
                insuranceFullBundle.insuranceProductWrapplerList.add(ipw); }
            }
            
            // add the bundles to the list for return
            insuranceBundleList.add(insuranceBasicBundle);
            insuranceBundleList.add(insuranceFullBundle);
            }
            //Adding the Bundle Matrix condition for NZ by Suneel - NFLPI
           if(thisApplication.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
            
               // calculate insurancePremium for Basic Bundle
            Decimal basicBundleInsurancePremium = calculateInsurancePremium(thisApplication, false, true, true);
            
            // create basic cover bundle
            InsuranceBundleWrapper insuranceBasicBundle = new InsuranceBundleWrapper(Label.Basic_Bundle_Name, false, true, true,
                                                                                        basicBundleInsurancePremium,
                                                                                        calculateInsuranceRepayments(thisApplication, basicBundleInsurancePremium),
                                                                                        calculateInsuranceInterest(thisApplication, basicBundleInsurancePremium),
                                                                                        thisApplication.LastModifiedDate.getTime());
            for(InsuranceProductWrapper ipw: insuranceProductsList){
                if(ipw.insuranceProductName != GEN_OriginationsConstants.LIFE_INSURANCE){
                    insuranceBasicBundle.insuranceProductWrapplerList.add(ipw);
                }
            }
            
            // calculate insurancePremium for Full Bundle
            Decimal fullBundleInsurancePremium = calculateInsurancePremium(thisApplication, true, true, true);
            
            // create full cover bundle
            InsuranceBundleWrapper insuranceFullBundle = new InsuranceBundleWrapper(Label.Full_Bundle_Name, true, true, true,
                                                                                        fullBundleInsurancePremium,
                                                                                        calculateInsuranceRepayments(thisApplication, fullBundleInsurancePremium),
                                                                                        calculateInsuranceInterest(thisApplication, fullBundleInsurancePremium),
                                                                                        thisApplication.LastModifiedDate.getTime());
            for(InsuranceProductWrapper ipw: insuranceProductsList){
                insuranceFullBundle.insuranceProductWrapplerList.add(ipw);
            }
            
            // add the bundles to the list for return
            insuranceBundleList.add(insuranceBasicBundle);
            insuranceBundleList.add(insuranceFullBundle);
            }
        }
        
        // create no cover bundle
        InsuranceBundleWrapper insuranceNoCoverBundle = new InsuranceBundleWrapper('No Cover', false, false, false,
                                                                                    0,
                                                                                    calculateInsuranceRepayments(thisApplication, 0),
                                                                                    calculateInsuranceInterest(thisApplication, 0),
                                                                                    thisApplication.LastModifiedDate.getTime());
        
        // add the bundle to the list for return
        insuranceBundleList.add(insuranceNoCoverBundle);
                                                                                        
        return insuranceBundleList;
    }
    
    /*  Description: Method to create insurance product items and save the application
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: String bundleName
     *  Return: PageReference
    */
    @RemoteAction
    global static InsuranceResultWrapper createAndSaveInsurance(Id applicationId, 
                                                 InsuranceBundleWrapper selectedBundleWrapper, 
                                                 Decimal newLoanAmount, 
                                                 String newLoanTerm, 
                                                 Boolean isNewLoanPurpose, 
                                                 String loanPurposeValue, 
                                                 String otherLoanPurpose){
        
        // boolean indicator if saving of application and insertion of product items is successful
        Boolean isSuccessful = false;
        
        // result message
        String resultMessage = '';

        // InsuranceResultWrapper
        InsuranceResultWrapper resultWrapper;

        // selected bundle wrapper from the page
        InsuranceBundleWrapper ibw = selectedBundleWrapper;
        
        //MLASALA 17-OCT-16 Added variable to replicate loan amount without DML
        RUL_PromoEngine.upsellAmount = newLoanAmount;
            
        // Recalculate application based on values from upsell
        thisApplication = APP_GSD_BaseController.recalculateApplication(applicationId, newLoanAmount, newLoanTerm);
        
        // if the customer's application instance is out dated (for minimal scenario), prompt the user that the application has been updated at the back end and refresh the page and let the page control do the redirection
        if(thisApplication.Staff_Hide__c){
            isSuccessful = true;
            resultMessage = 'Your application has been updated. Please contact us.';
            resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, true);
            return resultWrapper;
        }
        
        
        // create master list of debug logs to be inserted
        List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();
        
        //Retrieve existing loan purpose
        Loan_Purpose__c loanPurpose = [SELECT Loan_Amount__c, 
                                              ONR__c, 
                                              Value__c 
                                       FROM   Loan_Purpose__c 
                                       WHERE  Application__c =: applicationId 
                                       ORDER BY CreatedDate ASC LIMIT 1];
                                       
        List<Loan_Purpose__c> loanPurposeList = new List<Loan_Purpose__c>();
        
        if(loanPurpose != null){

            if(isNewLoanPurpose && 
               loanPurposeValue != loanPurpose.Value__c){
                
                //Create new loan purpose
                Loan_Purpose__c loanPurposeInsert = new Loan_Purpose__c();
                
                loanPurposeInsert.Application__c = applicationId;
                loanPurposeInsert.ONR__c = loanPurpose.ONR__c;
                loanPurposeInsert.Loan_Amount__c = Math.max(loanPurpose.Loan_Amount__c, newLoanAmount) - Math.min(loanPurpose.Loan_Amount__c, newLoanAmount) ;
                loanPurposeInsert.Value__c = loanPurposeValue;
                
                if(loanPurposeValue == 'Other'){
                    loanPurposeInsert.Other_Loan_Purpose__c = otherLoanPurpose;
                }
                
                loanPurposeList.add(loanPurposeInsert);
                
            } else {
                
                //Update existing loan purpose
                loanPurpose.Loan_Amount__c = newLoanAmount;
                
                loanPurposeList.add(loanPurpose);
            }
        }
        
        //Upsert loan purpose
        try{
            upsert loanPurposeList;
        } catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_Insurance_Ext', 'Loan_Purpose__c', 'Class', String.valueOf(applicationId));  
            resultMessage = 'An internal error has occured.';
            resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, true);
        }
        
        //Create offer history
        debugLogList.add(Util.createInsuranceActivity(applicationId, 
                                                      'Upsell', 
                                                      null, 
                                                      UserInfo.getName(), 
                                                      thisApplication.Initial_Requested_Amount__c, 
                                                      thisApplication.Total_Loan_Amount__c));
        //----------------------UPSELL----------------------//
            
        Applicant__c applicant = [SELECT Id FROM Applicant__c WHERE Application__c =: applicationId AND Is_Primary_Applicant__c = true LIMIT 1];
        
        // calculated application instance
        thisApplication = calculateInsurance(thisApplication, calculateInsurancePremium(thisApplication, ibw.isLifeSingle, ibw.isDisSingle, ibw.isIUISingle));
            
        // list of product items to be inserted
        List<Product_Item__c> insuranceProductItems = new List<Product_Item__c>();
        
        if(ibw.insuranceBundleName != 'No Cover'){
            // iterate through the bundle and create product item for each insurance product included in the bundle
            for(InsuranceProductWrapper ipw: ibw.insuranceProductWrapplerList){
                
                // initialize product item record
                Product_Item__c insuranceProductItem = new Product_Item__c();
                insuranceProductItem.Name = ipw.insuranceProductName;
                insuranceProductItem.Product_Version__c = ipw.insuranceProductVersionId;
                insuranceProductItem.Application__c = thisApplication.Id;
                insuranceProductItem.Ins_Term__c = thisApplication.Loan_Term_Months__c;              
                insuranceProductItem.Policy_Num__c = 0;
                insuranceProductItem.Unique_Identifier__c = thisApplication.Id + '' + ipw.insuranceProductVersionId;
                
                if(applicant != null){
                    insuranceProductItem.Applicant1__c=applicant.Id;
                }
                // perform insurance calculator for NZ
                if(thisApplication.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
                    // send the boolean indicators as parameter to tbe calculator
                    RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
                    rulNZ.calculateInsurnaceNZ(thisApplication, ibw.isLifeSingle, ibw.isDisSingle, ibw.isIUISingle, ibw.isLifeJoint, ibw.isDisJoint, ibw.isIUIJoint);
                    
                    // product item figures and amount calculations for Life Insurance
                    if(ipw.insuranceProductName == GEN_OriginationsConstants.LIFE_INSURANCE){
                        insuranceProductItem.Fixed_Premium_Amount__c = rulNZ.lifeTotal;
                        insuranceProductItem.Insurance_GST__c = 0;
                        insuranceProductItem.Insurance_Stamp_Duty__c = 0;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = 0;
                    }
                    // product item figures and amount calculations for Disability Insurance
                    else if(ipw.insuranceProductName == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                        insuranceProductItem.Fixed_Premium_Amount__c = rulNZ.disabilityTotalWithGST;
                        insuranceProductItem.Insurance_GST__c = rulNZ.disabilityGSTPremiumRounded;
                        insuranceProductItem.Insurance_Stamp_Duty__c = 0;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = 0;
                    }
                    // product item figures and amount calculations for Involutary Unemployment Insurance
                    else if(ipw.insuranceProductName == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                        insuranceProductItem.Fixed_Premium_Amount__c = rulNZ.iuiTotalWithGST;
                        insuranceProductItem.Insurance_GST__c = rulNZ.iuiGSTPremiumRounded;
                        insuranceProductItem.Insurance_Stamp_Duty__c = 0;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = 0;
                    }
                }
                
                // or perform insurance calculator for AU
                else{
                    System.debug('!@#AU CALCULATOR: ' + insuranceProductItems);
                    // send the boolean indicators as parameter to tbe calculator
                    RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
                    
                    // product item figures and amount calculations for Life Insurance
                    if(ipw.insuranceProductName == GEN_OriginationsConstants.LIFE_INSURANCE){
                        Decimal idividualLifeSingle = rul.getIndividualPremium(thisApplication, ibw.isLifeSingle, ibw.isDisSingle, ibw.isIUISingle, ibw.isLifeJoint, ibw.isDisJoint, ibw.isIUIJoint);
                        insuranceProductItem.Fixed_Premium_Amount__c = rul.singleLifeInsurancePremium;
                        insuranceProductItem.Insurance_GST__c = 0;
                        insuranceProductItem.Insurance_Stamp_Duty__c = rul.lifeStampDuty;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = rul.singleLifeSdRounded;
                    }
                    // product item figures and amount calculations for Disability Insurance
                    else if(ipw.insuranceProductName == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                        Decimal idividualDisabilitySingle = rul.getIndividualPremium(thisApplication, ibw.isLifeSingle, ibw.isDisSingle, ibw.isIUISingle, ibw.isLifeJoint, ibw.isDisJoint, ibw.isIUIJoint);
                        insuranceProductItem.Fixed_Premium_Amount__c = rul.singleDisabInsurancePremium;
                        insuranceProductItem.Insurance_GST__c = rul.singleDisabGstAmount;
                        insuranceProductItem.Insurance_Stamp_Duty__c = rul.disabilityStampDuty;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = rul.singleDisabSdRounded;
                    }
                    // product item figures and amount calculations for Involutary Unemployment Insurance
                    else if(ipw.insuranceProductName == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                        Decimal idividualIUISingle = rul.getIndividualPremium(thisApplication, ibw.isLifeSingle, ibw.isDisSingle, ibw.isIUISingle, ibw.isLifeJoint, ibw.isDisJoint, ibw.isIUIJoint);
                        insuranceProductItem.Fixed_Premium_Amount__c = rul.singleIuiInsurancePremium;
                        insuranceProductItem.Insurance_GST__c = rul.singleIuiGstAmount;
                        insuranceProductItem.Insurance_Stamp_Duty__c = rul.iuiStampDuty;
                        insuranceProductItem.Insurance_Stamp_Duty_Amount__c = rul.singleIuiSdRounded;
                    }
                }
                
                // add the product item to the list for insert
                insuranceProductItems.add(insuranceProductItem);
            }
        }
        
        if(!insuranceProductItems.isEmpty()){
            // insert all insurance product items from the bundle selected
            try{
                insert insuranceProductItems;
            }
            // record exception when dml fails
            catch(Exception e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_Insurance_Ext', 'Product_Item__c', 'Class', thisApplication.Id);  
                resultMessage = 'An internal error has occured.';
                resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, true);
            }
        }
        
        // to track insurance history, create debug log for each product item inserted
        try{
            
            // initialized total insurance premium added
            Decimal totalInsurancePremiumAdd = 0;
            
            // iterate through the product items stored in a list
            for(Product_Item__c pi: insuranceProductItems){

                // initialize insurace premium for each product item
                Decimal insurancePremium = 0;

                // set the fixed premium amount for each product item
                Decimal fixedPremiumAmount = (pi.Fixed_Premium_Amount__c != null && pi.Fixed_Premium_Amount__c != 0) ? pi.Fixed_Premium_Amount__c : 0;

                // sum up the total premium and the fixed premium amount
                insurancePremium = totalInsurancePremiumAdd + fixedPremiumAmount;
                
                // set the values to the Util.class to create debug log record and directly add it to the master debug log list
                debugLogList.add(Util.createInsuranceActivity(thisApplication.Id, 
                                                              'Add', 
                                                              pi.Name.removeEnd('Insurance'), 
                                                              UserInfo.getName(), 
                                                              totalInsurancePremiumAdd, 
                                                              insurancePremium));

                totalInsurancePremiumAdd += fixedPremiumAmount;
            }

            if(!debugLogList.isEmpty()){
                insert debugLogList;
            }
        }
        
        // record exception when dml fails
        catch(Exception e){
            ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', thisApplication.Id);
            resultMessage = 'An internal error has occured.';
            resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, true);
        }
            
        // after inserting potential product items and history, update the application pre-computated before this method has been executed
        try{
            thisApplication.Customer_Confirmed_Online_Offer__c = true;
            
            //MLASALA 17-OCT-16 Promo messages
            if(thisApplication.Promo_Online_Message__c != null){
                thisApplication.Promo_Online_Message__c = null;
            }
            
            update thisApplication;
            isSuccessful = true;
            resultMessage = 'Offers updated successfully.';
            resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, false);
        }
        // record exception when dml fails
        catch(Exception e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_Insurance_Ext', 'Application__c', 'Class', String.valueOf(thisApplication.Id)); 
            resultMessage = 'An internal error has occured.';
            resultWrapper = new InsuranceResultWrapper(isSuccessful, resultMessage, true);
        }
        
        return resultWrapper;
    }

    /*  Description: Method to get the terms and conditions insurance live asset from the current brand
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: 
     *  Return: String
    */
    public String insuranceTermsAndCondition{
        get{
            return [SELECT URL_PDS_FSG__c FROM Brand__c WHERE Site__c =: Site.getName() LIMIT 1].URL_PDS_FSG__c;
        }
        set;
    }
    
    /*  Description: Method to calculate Insurance Premium for a bundle
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: Application__c application, Boolean isLifeSingle, Boolean isDisSingle, Boolean isIUISIngle
     *  Return: Decimal
    */
     @testvisible
    private static Decimal calculateInsurancePremium(Application__c application, Boolean isLifeSingle, Boolean isDisSingle, Boolean isIUISingle){
        
        // Set each individual boolean indicator of a bundle for each insurance product included *FOR SINGLE APPLICATIONS ONLY - JOINTS ARE DEFAULTED TO FALSE
        // Reusing RUL_InsurancePremiumCalculator class, same logic applied with Sales UI
        RUL_InsurancePremiumCalculator.RUL_InsuranceSelection ruleSelection = new RUL_InsurancePremiumCalculator.RUL_InsuranceSelection();
        ruleSelection.lifePremiumSingle = isLifeSingle;
        ruleSelection.disabilityPremiumSingle = isDisSingle;
        ruleSelection.iUIPremiumSingle = isIUISingle;
        ruleSelection.lifePremiumJoint = false;
        ruleSelection.disabilityPremiumJoint = false;
        ruleSelection.iUIPremiumJoint = false;
        ruleSelection.inputTotalLoanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
        
        // Set each decimal variables with values from the Application record
        Decimal establishmentFee = application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        Decimal SearchFee = application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        Decimal RegistrationFee = application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        
        
        // Send the variables to the RUL_InsurancePremiumCalculator
        ruleSelection.inputFees =   establishmentFee + SearchFee + RegistrationFee + brokerFee;
        ruleSelection.inputLoanTerm = application.Loan_Term_Months__c != null ? application.Loan_Term_Months__c : 0;
        
        // Set repayments and monthly service fee
        Decimal repayments = application.Offered_Repayments__c != null ? application.Offered_Repayments__c : 0;
        Decimal monthlyServiceFee = application.Offered_Monthly_Loan_Service_Fee__c != null ? application.Offered_Monthly_Loan_Service_Fee__c : 0;
        
        // Send the variables to the RUL_InsurancePremiumCalculator
        ruleSelection.inputEMI =  repayments;
        ruleSelection.inputAPR = application.Offered_Interest_Rate__c != null ? application.Offered_Interest_Rate__c : 0;
        ruleSelection.inputState = application.State__c;
        ruleSelection.lastModDate = application.LastModifiedDate;

        Decimal premium = 0;
        
        // Trigger the calculation depending on brand
        if(application.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){
            
          RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
          premium = rul.calculateInsurancePremiums(ruleSelection);
          
        }
        else if(application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
            
          RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
          rulNZ.calculateInsurnaceNZ(application, 
                                     ruleSelection.lifePremiumSingle,
                                     ruleSelection.disabilityPremiumSingle,
                                     ruleSelection.iUIPremiumSingle,
                                     ruleSelection.lifePremiumJoint,
                                     ruleSelection.disabilityPremiumJoint,
                                     ruleSelection.iUIPremiumJoint);

          premium = rulNZ.totalInsurancePremium;
          
        }
        
        // Return the output of calculation
        return premium;
    }
    
    /*  Description: Method to calculate Minimum monthly repayments for a bundle
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: Application__c application, Decimal insurancePremium
     *  Return: Decimal
    */
    private static Decimal calculateInsuranceRepayments(Application__c application, Decimal insurancePremium){
        Application__c applicationOnHand = calculateInsurance(application, insurancePremium);
        return applicationOnHand.EMI_with_Service_Fee__c;              
    }
    
    /*  Description: Method to calculate Insurance interest for a bundle
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: Application__c application, Decimal insurancePremium
     *  Return: Decimal
    */
    private static Decimal calculateInsuranceInterest(Application__c application, Decimal insurancePremium){
        Application__c applicationOnHand = calculateInsurance(application, insurancePremium);
        return applicationOnHand.Total_Insurance_Interest_Amount_Payable__c;            
    }
    
    /*  Description: Method to calculate Insurance interest for a bundle
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: Application__c application, Decimal insurancePremium
     *  Return: Application__c
    */
    private static Application__c calculateInsurance(Application__c application, Decimal insurancePremium){
        
        application.Total_Insurance_Premium__c = insurancePremium;
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        RUL_InsurancePremiumCalculator ruleSelection = new RUL_InsurancePremiumCalculator();
        
        application.Total_Insurance_Interest_Amount_Payable__c = ruleSelection.computeTotalAmountInsurancePayable(application);
        application.Total_Loan_Interest_Amount_Payable__c = ruleSelection.computeTotalInterestAmountPayable(application);  
        application.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(application);
        application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(application);
        application.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(application);
        
        return application;
    }
    /*  Description: Method to retrieve application including all relevant fields for Upsell and Cross-sell
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: Id appId
     *  Return: Application__c
    */
    @testvisible
    private static Application__c getApplication(String appId){
        return GEN_RecordRetrievalUtility.retrieveApplication(appId);
    }

    /*  Description: Map of Insurance Product Name and its description, stored in a custom label, used for response page content for AU
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: 
     *  Return: Map<String,String>
    */
    private static Map<String,String> insuranceProductsDescriptionAU{
        get{
            Map<String, String> insuranceDescMap = new Map<String, String>();
            insuranceDescMap.put(GEN_OriginationsConstants.DISABILITY_INSURANCE, Label.Insurance_Disability_Description);
            insuranceDescMap.put(GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE, Label.Insurance_Unemployment_Description);
             /** Updated by Suneel 09/03/2018, As per NFLPI phase 1,            
            1. Made comment in the line number 707 to the AU Label ,earlier it was showing in the Matrix table 
            **/            
            //insuranceDescMap.put(GEN_OriginationsConstants.LIFE_INSURANCE, Label.Insurance_Life_Description);
            return insuranceDescMap;
        }
        set;
    }
    /*  Description: Map of Insurance Product Name and its description, stored in a custom label, used for response page content for NZ
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: 
     *  Return: Map<String,String>
    */
    @testvisible
    private static Map<String,String> insuranceProductsDescriptionNZ{
        get{
            Map<String, String> insuranceDescMap = new Map<String, String>();
            insuranceDescMap.put(GEN_OriginationsConstants.DISABILITY_INSURANCE, Label.Insurance_Disability_Description_NZ);
            insuranceDescMap.put(GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE, Label.Insurance_Unemployment_Description_NZ);
            insuranceDescMap.put(GEN_OriginationsConstants.LIFE_INSURANCE, Label.Insurance_Life_Description_NZ);
            return insuranceDescMap;
        }
        set;
    }
    /*  Description: Map of Insurance Product Name and Page Display Name, stored in a custom label, used for response page content for AU
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: 
     *  Return: Map<String,String>
    */
    private static Map<String,String> insuranceProductsDisplayNameAU{
        get{
            Map<String, String> insuranceDescMap = new Map<String, String>();
            insuranceDescMap.put(GEN_OriginationsConstants.DISABILITY_INSURANCE, Label.APP_GSD_Insurance_Disability_Display_Name_AU);
            insuranceDescMap.put(GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE, Label.APP_GSD_Insurance_IUI_Display_Name_AU);
            /** Updated by Suneel 09/03/2018, As per NFLPI phase 1,            
            1. Made comment in the line number 741 to the AU Label ,earlier it was showing in the Matrix table 
            **/
             //insuranceDescMap.put(GEN_OriginationsConstants.LIFE_INSURANCE, Label.APP_GSD_Insurance_Life_Display_Name_AU);
            return insuranceDescMap;
        }
        set;
    }
    /*  Description: Map of Insurance Product Name and Page Display Name, stored in a custom label, used for response page content for NZ
     *  Author: Russell Cadapan
     *  Date Created: 02-JUN-2016
     *  Input: 
     *  Return: Map<String,String>
    */
    @testvisible
    private static Map<String,String> insuranceProductsDisplayNameNZ{
        get{
            Map<String, String> insuranceDescMap = new Map<String, String>();
            insuranceDescMap.put(GEN_OriginationsConstants.DISABILITY_INSURANCE, Label.APP_GSD_Insurance_DIsability_Display_Name_NZ);
            insuranceDescMap.put(GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE, Label.APP_GSD_Insurance_IUI_Display_Name_NZ);
            insuranceDescMap.put(GEN_OriginationsConstants.LIFE_INSURANCE, Label.APP_GSD_Insurance_Life_Display_Name_NZ);
            return insuranceDescMap;
        }
        set;
    }
}