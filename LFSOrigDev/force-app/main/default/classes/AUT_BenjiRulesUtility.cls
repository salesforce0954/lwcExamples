/* @Description: Benji Rule(Auto Loan Rules) for NZ Auto loan products
 * @Author: Fahad Akhtar
 * @Created: 12-5-2014
 * @History:
   =====================================================================
       12-18-14: Refactored - Fahad Akhtar
   =====================================================================
 */
public class AUT_BenjiRulesUtility{
    /* Create a map of brand and Products to get */
    public map<id,GEProduct__c> map_product{
        get{
            if(map_product == null){
                map_product = new map<id,GEProduct__c>();
                for(GEProduct__c product : [SELECT 
                                                    id,
                                                    Brands__c,
                                                    Security_Ratio__c,
                                                    Security_Value__c,
                                                    Age_of_Car__c,
                                                    Auto_Loan_Risk_Grade__c 
                                            FROM 
                                                    GEProduct__c 
                                            WHERE 
                                                    Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN
                                            AND
                                                    Brands__r.Country__c =: GEN_OriginationsConstants.NZ_REGION
                    ]){
                    System.debug('*** Product Data *** ' + product);
                    map_product.put(product.Brands__c,product);
                }
            }
            return map_product;
        }
        set;
    }
    /* 
    *  Description: Run all Auto loan rules against the criteria and return empty if all results are pass and a message if fails.
    *  Author: Fahad Akhtar
    *  Input Parameters: List of Applications
    *  Return: String
    */          
    //public void benjiRulesValidation(List<Application__c> lst_app) {
    public List<IS_ValidationError> benjiRulesValidation(List<Application__c> lst_app) {
        map<id,Application_Response__c> map_appResponse = new map<id,Application_Response__c>();

        map<id,Application__c> map_applicaiton = new map<id,Application__c>([
                                                        SELECT
                                                                id,
                                                                Credit_Score__c,
                                                                Last_Webservice_Operation_Invoked__c,
                                                                Initial_Submit_Date__c,
                                                                (
                                                                    SELECT 
                                                                        id,
                                                                        Value__c,
                                                                        Loan_Amount__c
                                                                    FROM 
                                                                        Loan_Purpose__r),
                                                                (
                                                                    SELECT 
                                                                            id,
                                                                            Collateral_Val__c,
                                                                            Collateral_Year__c 
                                                                    FROM 
                                                                            Collaterals__r 
                                                                    WHERE 
                                                                            recordtypeid =:Util.getObjectRecordTypeId(Collateral__c.SObjectType,GEN_OriginationsConstants.COLLATERAL_MOTOR_VEHICLE_RECORD_TYPE))
                                                        FROM 
                                                                Application__c
                                                        WHERE
                                                                id=: lst_app
                                                        ]);

        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

        //Run Auto loan for all applications
        for(Application__c app : lst_app){

            System.debug('*** Security and Value  ' + map_applicaiton.get(app.id).Collaterals__r);
            System.debug('*** Brand Lookup  ' + app.Brand_Lookup__c);
            System.debug('*** product Map  ' + map_product);                            
            System.debug('*** Security Ratio  ' + map_product.get(app.Brand_Lookup__c).Security_Ratio__c);
            System.Debug('App product type ' + app.Type_of_Product__c + 'Auto Loan Constant ' + GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN);  
            
            app.Benji_Rule_Results__c = ''; 
            
            if(app.Type_of_Product__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN){

                System.Debug('Size of Loan list'+  map_applicaiton.get(app.id).Loan_Purpose__r.size() + 'and size of loan purpose is ' + map_applicaiton.get(app.id).Collaterals__r.size());
                
                //RULE: LOAN PURPOSE SIZE
                if(map_applicaiton.get(app.id).Loan_Purpose__r.size() == 0 || map_applicaiton.get(app.id).Loan_Purpose__r.size() != 1 || map_applicaiton.get(app.id).Loan_Purpose__r[0].Value__c != GEN_OriginationsConstants.ONR_CAR_PURCHASE){

                    app.Benji_Rule_Results__c = GEN_OriginationsConstants.AUTO_RULE_FAIL_CAR_PURCHASE;
                    validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_CAR_PURCHASE));

                    System.Debug('Size of Security List' + map_applicaiton.get(app.id).Collaterals__r.size());
                }
                    
                //RULE: RISK GRADE
                if(Util.nullCheck(app.Credit_Score__c) && Util.nullCheck(map_product.get(app.Brand_Lookup__c).Auto_Loan_Risk_Grade__c)){
                    System.debug('Credit Score ' + app.Credit_Score__c);
                    System.debug('Benji Rules Results ' + map_product.get(app.Brand_Lookup__c).Auto_Loan_Risk_Grade__c);
                    System.debug('Result of Equation ' + map_product.get(app.Brand_Lookup__c).Auto_Loan_Risk_Grade__c.contains(app.Credit_Score__c));

                    List<String> riskGradeList = new List<String>();

                    riskGradeList = map_product.get(app.Brand_Lookup__c).Auto_Loan_Risk_Grade__c.split(';');
                    System.debug('$$$ riskGradeList: '+riskGradeList);

                    if(!riskGradeList.isEmpty()){
                        for(String s: riskGradeList){
                            if(app.Credit_Score__c == s){
                                app.Benji_Rule_Results__c = (app.Benji_Rule_Results__c == ''?app.Benji_Rule_Results__c:app.Benji_Rule_Results__c+'<br/>') + GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_RISK_GRADE;
                                validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_RISK_GRADE));
                                break;
                            }
                        }
                    }
                }

                if(map_applicaiton.get(app.id).Collaterals__r.size() == 1){
                    
                    System.debug('Size of loan purpose ' + map_applicaiton.get(app.id).Loan_Purpose__r.size());
                    System.debug('LVF Ration ' + map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Val__c/map_applicaiton.get(app.id).Loan_Purpose__r[0].Loan_Amount__c);
                    System.debug('LVR Ratio value ' + map_product.get(app.Brand_Lookup__c).Security_Ratio__c);
                    System.debug('Collateral Value ' + map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Val__c);
                    System.debug('Collateral Value ' + map_product.get(app.Brand_Lookup__c).Security_Value__c);
                    System.debug('map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c != null' + map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c != null);
                    System.debug('app.Loan_Term_Years__c' + app.Loan_Term_Years__c);
                    System.debug('map_product.get(app.Brand_Lookup__c).Age_of_Car__c' + map_product.get(app.Brand_Lookup__c).Age_of_Car__c);

                    //RULE: AGE
                    if(!Util.nullCheck(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c)){

                        validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_NO_AGE_OF_CAR));

                    }
                    // START - UPDATED - TQLQW-95 by RCADAPAN @ -09-MAR_2016
                    else if(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c != null && (app.Initial_Submit_Date__c.Year() - (Integer.ValueOf(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c)) > map_product.get(app.Brand_Lookup__c).Age_of_Car__c)){
                        System.debug('$$$: '+map_applicaiton.get(app.id).Last_Webservice_Operation_Invoked__c+', '+ (app.Initial_Submit_Date__c.Year() - (Integer.ValueOf(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c)) + '>'  + map_product.get(app.Brand_Lookup__c).Age_of_Car__c));
                        System.debug('Collateral_Year__c' + Integer.ValueOf(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Year__c));
                        
                        //app.Benji_Rule_Results__c = (app.Benji_Rule_Results__c == ''?app.Benji_Rule_Results__c:app.Benji_Rule_Results__c+'<br/>') + GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_AGE_OF_CAR;                       
                        validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_AGE_OF_CAR));
                    }
                    // END TQLQW-95

                    //RULE: SECURITY RATIO
                    if(map_applicaiton.get(app.id).Loan_Purpose__r.size() != 0 && (map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Val__c/map_applicaiton.get(app.id).Loan_Purpose__r[0].Loan_Amount__c) <= map_product.get(app.Brand_Lookup__c).Security_Ratio__c) {                       
                        
                        System.debug('Security Ratio Failed');
                        validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_RATIO));
                    }

                    //RULE: COLLATERAL VALUE < SECURITY VALUE
                    if(map_applicaiton.get(app.id).Collaterals__r[0].Collateral_Val__c <= map_product.get(app.Brand_Lookup__c).Security_Value__c){
                        
                        validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY_VALUE));
                    }

                } else {

                    if(map_applicaiton.get(app.id).Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT){
                        app.Benji_Rule_Results__c = (app.Benji_Rule_Results__c ==''?app.Benji_Rule_Results__c:app.Benji_Rule_Results__c+'<br/>') + GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY;
                    }
                    validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY));
                }
            } else {

                if(map_applicaiton.get(app.id).Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT){
                    app.Benji_Rule_Results__c = (app.Benji_Rule_Results__c ==''?app.Benji_Rule_Results__c:app.Benji_Rule_Results__c+'<br/>') + GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY;
                }
                validationErrors.add(new IS_ValidationError('', GEN_OriginationsConstants.AUTO_RULE_FAIL_SECURITY));

            }
        }
        update lst_app;

        return validationErrors;
    }
}