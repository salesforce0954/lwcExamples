/* @Description: Extension class for the POI Response Page
 * @Author : Davey Yu
 * @Date : 02-FEB-2016
 * @History:
   =========================================================================================================
        02-FEB-2016 : Created - Davey
   =========================================================================================================
 */
global class APP_GSD_POI_Response_Ext extends APP_GSD_BaseController {

//Changes Start as part of ODDS-12370 NZ Epoi implementation
    public boolean ePOI_Eligible_NZ{get;set;}
    public boolean ePOI_Eligible_NZ_Secondary{get;set;}
 // Added as part of LM-2216 (Remove Proviso option for cusotmers already verified income )
    public boolean ePOI_ShowHide {get;set;}
    
    public APP_GSD_POI_Response_Ext()
        {
             ePOI_Eligible_NZ = false;
             ePOI_Eligible_NZ_Secondary = false;
             ePOI_ShowHide = false;
        string appId = ApexPages.currentpage().getParameters().get('id');
        if( string.isNotBlank(appId) )
        {
            for( Income__c income : [ SELECT Applicant__c,Applicant__r.Is_Primary_Applicant__c,
                                     Applicant__r.Primary_Employment_Status__c,
                                     Income_Source__c 
                                     FROM 
                                     Income__c 
                                     Where 
                                     Applicant__r.Application__c=: appId
                                     AND 
                                     Applicant__r.RecordType.name='NZ'] )
            {
               if(income.Applicant__r.Is_Primary_Applicant__c == true && ePOI_Eligible_NZ== false){
               
                    if ( (income.Applicant__r.Primary_Employment_Status__c == 'Full Time' || income.Applicant__r.Primary_Employment_Status__c == 'Part Time'
                        || income.Applicant__r.Primary_Employment_Status__c == 'Casual' || income.Applicant__r.Primary_Employment_Status__c == 'Seasonal' || 
                            income.Applicant__r.Primary_Employment_Status__c == 'Temporary')
                       &&(income.Income_Source__c=='Net Salary/Wages')
                       )
                    {
                        ePOI_Eligible_NZ = true;
                    }
                    
                   else
                   if( (income.Applicant__r.Primary_Employment_Status__c == 'Full Time' || income.Applicant__r.Primary_Employment_Status__c == 'Part Time'
                      || income.Applicant__r.Primary_Employment_Status__c == 'Other')
                       &&(income.Income_Source__c=='Rental Income')
                       )
                    {
                        ePOI_Eligible_NZ = true;
                    }
                    else{
                         ePOI_Eligible_NZ = false;
                    }
               }
               else 
               if(income.Applicant__r.Is_Primary_Applicant__c == false && ePOI_Eligible_NZ_Secondary == false) {
                    if ( (income.Applicant__r.Primary_Employment_Status__c == 'Full Time' || income.Applicant__r.Primary_Employment_Status__c == 'Part Time'
                        || income.Applicant__r.Primary_Employment_Status__c == 'Casual' || income.Applicant__r.Primary_Employment_Status__c == 'Seasonal' || 
                            income.Applicant__r.Primary_Employment_Status__c == 'Temporary')
                       &&(income.Income_Source__c=='Net Salary/Wages')
                       )
                    {
                        ePOI_Eligible_NZ_Secondary = true;
                    }
                    
                   else
                   if( (income.Applicant__r.Primary_Employment_Status__c == 'Full Time' || income.Applicant__r.Primary_Employment_Status__c == 'Part Time'
                      || income.Applicant__r.Primary_Employment_Status__c == 'Other')
                       &&(income.Income_Source__c=='Rental Income')
                       )
                    {
                        ePOI_Eligible_NZ_Secondary = true;
                    }
                    else{
                         ePOI_Eligible_NZ_Secondary = false;
                    }  
               
                }     
             }
             //Changes End as part of ODDS-12370 NZ Epoi implementation
             
             // Start: Added as part of LM-2216  (Remove Proviso option for cusotmers already verified income )
             //Check the Applications for Income capacities 
             for (List<Income_Capacity__c> incCap: [SELECT Income__c, Income__r.Applicant__c,Income__r.Applicant__r.Application__c, Name,
                                                  Id, Is_e_POI__c,Method_of_Verification__c,Taxable_Income__c,Annualised_Net_Income__c,
                                                  Frequency_of_Payment__c 
                                                  FROM
                                                  Income_Capacity__c 
                                                  WHERE
                                                  Income__r.Applicant__r.Application__c=:appId
                                                  AND
                                                  Method_of_Verification__c <>''
                                                  AND
                                                  Frequency_of_Payment__c <> '']){
                      if(incCap.size() > 0){
                           ePOI_ShowHide = true;
                      }
                     
             
             }
             // End: Added as part of LM-2216  (Remove Proviso option for cusotmers already verified income )
           }            
        }
    
    
    // Added by RCADAPAN for TQLQW-534 - ePOI
    global String ePOIEndpoint{
        get{
            return Admin_Settings__c.getValues(GEN_OriginationsConstants.ADMIN_SETTING_EPOI_ENDPOINT).Value__c;
        }
        set;
    }
    
    // Added by RCADAPAN for TQLQW-534 - ePOI
    global Boolean hideShowEPOI{
        get{
            return Profile_Control__c.getInstance(UserInfo.getProfileId()).ePOI__c;
        }
        set;
    }
    /*  Description: Generate List for Proof of Income Documents Per Applicant
                     Per Income Source
     *  Author: Davey Yu
     *  Date Created: 09-FEB-2016
     *  Input: brandCountry - Application Brand Country AU/NZ
     *  Input: incomes - List of Incomes of the Application
     *  Return: poiWrapperList - List of POI Documents per Applicant per Income Source
    */
    @RemoteAction
    global static List<poiWrapper> queryPOIDocuments(String brandCountry, List<Income__c> incomes, String creditScore){
        List<poiWrapper> poiWrapperList = new List<poiWrapper>();
        List<Meta_Document__c> poiDocs  = new List<Meta_Document__c>();
        Map<String, String> docsMap     = new Map<String, String>();
        
        
        //Retrieved Meta Data Documents for POI PL Category
        poiDocs = [SELECT Category__c, Description__c, Document_Type__c
            FROM Meta_Document__c WHERE Category__c =: GEN_OriginationsConstants.POI_PL_CATEGORY AND RecordType.Name =: brandCountry];
        system.debug('poi docs size: '+poiDocs.size());
        //check meta documents if it has values
        if(poiDocs.size() > 0){
            
            //Store meta documents on a map to retrieved the document description per document type
            for(Meta_Document__c md: poiDocs){
                docsMap.put(md.Document_Type__c.trim(), md.Description__c);
            }
            
            //check income source size and generate the poiwrapper list
            if(incomes.size() > 0){
                for(Income__c income: incomes){
                    if(brandCountry == 'AU'){
                        //My permanent - full time job, My permanent - part time job, My Casual/Temporary Job
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_FT || 
                            income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_PT ||
                            income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_CA){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYSLIP, docsMap.get(GEN_OriginationsConstants.POI_PL_PAYSLIP), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYG_SUMMARY, docsMap.get(GEN_OriginationsConstants.POI_PL_PAYG_SUMMARY), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //My contracting job, My Seasonal job
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_CN || 
                            income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_SJ){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYSLIP, docsMap.get(GEN_OriginationsConstants.POI_PL_PAYSLIP), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYG_SUMMARY, docsMap.get(GEN_OriginationsConstants.POI_PL_PAYG_SUMMARY), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_TAX_RETURN, docsMap.get(GEN_OriginationsConstants.POI_PL_TAX_RETURN), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //My self-employed business
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_SE){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_TAX_RETURN, docsMap.get(GEN_OriginationsConstants.POI_PL_TAX_RETURN), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PROFIT_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_PROFIT_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            
                        }

                        //My workers compensation
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_WC){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_FUND_MANAGER_WORKERS, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_FUND_MANAGER_WORKERS), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_RETURN_TO_WORK_PLAN, docsMap.get(GEN_OriginationsConstants.POI_PL_RETURN_TO_WORK_PLAN), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //My rental property
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_RE){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_CURRENT_LEASE_AGREEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_CURRENT_LEASE_AGREEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_TAX_RETURN, docsMap.get(GEN_OriginationsConstants.POI_PL_TAX_RETURN), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_REAL_ESTATE, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_REAL_ESTATE), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_RENTAL_RECEIPTS, docsMap.get(GEN_OriginationsConstants.POI_PL_RENTAL_RECEIPTS), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_REAL_ESTATE_CONFIRMATION, docsMap.get(GEN_OriginationsConstants.POI_PL_REAL_ESTATE_CONFIRMATION), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_CURRENT_LEASE_AGREEMENT_PRIVATE, docsMap.get(GEN_OriginationsConstants.POI_PL_CURRENT_LEASE_AGREEMENT_PRIVATE), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_EXPIRED_LEASE_AGREEMENTS, docsMap.get(GEN_OriginationsConstants.POI_PL_EXPIRED_LEASE_AGREEMENTS), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_TAX_RETURN_PRIVATE, docsMap.get(GEN_OriginationsConstants.POI_PL_TAX_RETURN_PRIVATE), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            
                        }

                        //My other sources of income
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_OT){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_SUPERANNUATION_STATEMENT+' (Gurantee Annuity)', docsMap.get(GEN_OriginationsConstants.POI_PL_SUPERANNUATION_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_FUND_MANAGER+' (Gurantee Annuity)', docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_FUND_MANAGER), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT+' (Gurantee & Non-Guarantee Annuity)', docsMap.get(GEN_OriginationsConstants.POI_PL_NOTICE_OF_ASSESSMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_TAX_RETURN, docsMap.get(GEN_OriginationsConstants.POI_PL_TAX_RETURN), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENTS, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //My child support
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_CS){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_MAINTENANCE_DOCUMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_MAINTENANCE_DOCUMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENTS, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENTS), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //My Pension
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_PE){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_CENTRELINK_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_CENTRELINK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_CENTRELINK_ONLINE, docsMap.get(GEN_OriginationsConstants.POI_PL_CENTRELINK_ONLINE), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_VETERANS_AFFAIRS, docsMap.get(GEN_OriginationsConstants.POI_PL_VETERANS_AFFAIRS), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }
                    }

                    if(brandCountry == 'NZ'){
                        //Net/Salary Wages
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_NE){ 
                            if(creditScore == 'D' || creditScore == 'E'){
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYSLIP+' <b>OR</b>', docsMap.get(GEN_OriginationsConstants.POI_PL_PAYSLIP), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_IRD_SUMMARY+' <b>AND</b>', docsMap.get(GEN_OriginationsConstants.POI_PL_IRD_SUMMARY), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_DESC_NZ, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_NZ), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            }else{
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYSLIP+' <b>OR</b>', docsMap.get(GEN_OriginationsConstants.POI_PL_PAYSLIP), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_IRD_SUMMARY+' <b>OR</b>', docsMap.get(GEN_OriginationsConstants.POI_PL_IRD_SUMMARY), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                                poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_DESC_NZ, docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_NZ), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            }
                        }

                        //Other
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_OT){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_PAYSLIP +' (must show a minimum of 3 months of the year to date income) <b>OR</b>', docsMap.get(GEN_OriginationsConstants.POI_PL_PAYSLIP), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_DESC_NZ + ' (A bank statement will be mandatory for seasonal, casual or temporary work)', docsMap.get(GEN_OriginationsConstants.POI_PL_BANK_STATEMENT_NZ), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //Self Employed
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_SE){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_SE_IRD_SUMMARY_DESC, docsMap.get(GEN_OriginationsConstants.POI_PL_IRD_SUMMARY), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_FINANCIAL_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_FINANCIAL_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //Government Benefit
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_GB){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_ACC_BENEFIT_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_ACC_BENEFIT_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER_NZ, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_EMPLOYER), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT_NZ, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_ACCOUNTANT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_LETTER_FROM_WINZ_IRD, docsMap.get(GEN_OriginationsConstants.POI_PL_LETTER_FROM_WINZ_IRD), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                        }

                        //Rental Income
                        if(income.Income_Source_Code__c == GEN_OriginationsConstants.POI_PL_INCOME_RE){ 
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_RENTAL_LEASE_DESC_NZ, docsMap.get(GEN_OriginationsConstants.POI_PL_RENTAL_LEASE), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_2_BANK_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_2_BANK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            poiWrapperList.add(new poiWrapper(GEN_OriginationsConstants.POI_PL_60_BANK_STATEMENT, docsMap.get(GEN_OriginationsConstants.POI_PL_60_BANK_STATEMENT), income.Applicant__r.Is_Primary_Applicant__c, income.Income_Source_Code__c));
                            
                        }
                    }
                }
            }
        }
        
        return poiWrapperList;
     }

    /*  Description: Query List of Income Per Applicant
     *  Author: Davey Yu
     *  Date Created: 09-FEB-2016
     *  Input:  applicandIds - List of Applicant IDs with Comma Delimited
     *  Return: Incomes - List of Incomes on the Application
    */
     @RemoteAction
     global static List<Income__c> queryIncomeSource(String applicantIds){
            List<Income__c> incomes = new List<Income__c>();
            List<String> appIdSet = new List<String>();
            String[] appIds = applicantIds.split(',');
            Map<String, String> poiMap = new Map<String, String>();

            for(Integer i = 0; i < appIds.size(); i++){
                appIdSet.add(appIds[i]);
            }
            List<Income__c> incomeList = new List<Income__c>();

            incomeList = [SELECT Income_Source__c, Income_Source_Code__c, Applicant__c, Applicant__r.First_Name__c 
                        , Applicant__r.Is_Primary_Applicant__c FROM Income__c WHERE Applicant__c IN : appIdSet];
            
            for(Income__c i: incomeList){
                //validate if income source is already existing to avoid duplicates in the display
                if(poiMap.get(i.Income_Source_Code__c+i.Applicant__r.Id) == null){
                    incomes.add(i);
                }
                poiMap.put(i.Income_Source_Code__c+i.Applicant__r.Id, i.Income_Source_Code__c);
            }
            return incomes;
    }

    /*  Description: Wrapper Class for POI Documents
     *  Author: Davey Yu
     *  Date Created: 09-FEB-2016
     *  Input:  poiType - POI Document Type
     *  Input:  poiDesc - POI Document Description
     *  Input:  source - Applicant Income Source
     *  Input:  primary - Is Applicant Primary
     *  Input:  scode - Applicant Income Source Code
     *  Return: None
    */
    global class poiWrapper{
        global String poiType {get;set;}
        global String poiDesc {get;set;}
        global Boolean primary {get;set;}
        global String scode {get;set;}
        global poiWrapper(String poiType, String poiDesc, Boolean primary, String scode){
            this.poiType = poiType;
            this.poiDesc = poiDesc;
            this.primary = primary;
            this.scode = scode;
        }
     }
     
   // Added brand paramter into the function as part of ODS-12373  
    @RemoteAction
    global static String generateRelatedDocuments(String latitudeId, String fName, String lName, String applicantId, String product, string applicationId, string brand){
   
         String ePOI_URL;
      
         String ePOIEndpoint = Admin_Settings__c.getValues(GEN_OriginationsConstants.ADMIN_SETTING_EPOI_ENDPOINT).Value__c;
         String ePOIEndpointNZ = Admin_Settings__c.getValues(GEN_OriginationsConstants.ADMIN_SETTING_EPOI_ENDPOINT_NZ).Value__c;
         
         Related_Document__c ePOIdocument = new Related_Document__c();
         ePOIdocument.Application__c = applicationId;
         ePOIdocument.Applicant__c = applicantId;
         ePOIdocument.Document_Category__c = 'POI';
         ePOIdocument.Type__c = 'ePOI Statement';
         ePOIDocument.Status__c = GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_SENT;
         ePOIDocument.Product__c = product;
         
          try{
             insert ePOIDocument;
             // ODDS-12373: Code changes start as part of NZ eopi 
             if(brand =='Latitude') {
                ePOI_URL = ePOIEndpoint+'LTTD-'+ latitudeId + '_' + fName + '_' + lName + '_' + ePOIDocument.Id;
             }
             else if(brand =='GEM'){
                ePOI_URL = ePOIEndpointNZ+'GMNZ-'+ latitudeId + '_' + fName + '_' + lName + '_' + ePOIDocument.Id;
             }
             else if(brand =='Kiwibank'){
                ePOI_URL = ePOIEndpointNZ+'LTKW-'+ latitudeId + '_' + fName + '_' + lName + '_' + ePOIDocument.Id;
             }
            // ODDS-12373: Code changes end as part of NZ eopi 
         }
         catch(Exception e){
             ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_POI_Response_Ext', 'Related_Document__c', 'Class', applicationId);
         }
         
         return ePOI_URL;
     }  
}