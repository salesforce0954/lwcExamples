/* @Description: Wrapper class for Asset
 * @Author: Mike Lasala
 * @Date Created: JAN-29-2013
 * @History:
   =====================================================================
       01-29-14: Created - Mike
       12-10-14: Added condition for DBHZL-143 - Devendra
   =====================================================================
 */

//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================
/*  Description: Wrapper class for the asset object
 *  Author: Dan Crisologo
 *  Date Created: SEPT-25-2013
 */
public class MyBudgetsAssetWrapper {    
    public Asset__c asset               {get;set;}
    public Boolean categoryValid        {get;set;}
    public Boolean valueValid           {get;set;}
    public Boolean ownershipValid       {get;set;}
    public Boolean vehicleMakeValid     {get;set;}
    public Boolean vehicleModelValid    {get;set;}
    public Boolean vehicleYearValid     {get;set;}
    public Integer rowCount             {get;set;}
    public Boolean isJoint              {get;set;}
    /*  Description: Wrapper constructor, creates new income, refreshes validations
     *  Author: Dan Crisologo
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public MyBudgetsAssetWrapper (Applicant__c applicant){
        this.asset = new Asset__c(Applicant__c = applicant.Id);
        this.categoryValid = true;
        this.valueValid = true;
        this.ownershipValid = true;
        this.vehicleMakeValid = true;
        this.vehicleModelValid = true;
        this.vehicleYearValid = true;
    }
    
    public MyBudgetsAssetWrapper (Asset__c oldAsset){
        this.asset = oldAsset;
        this.categoryValid = true;
        this.valueValid = true;
        this.ownershipValid = true;
        this.vehicleMakeValid = true;
        this.vehicleModelValid = true;
        this.vehicleYearValid = true;
    }
    
    /*  Description: Validates all asset fields in the wrapper
     *  Author: Dan Crisologo
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateAsset() {        
        Boolean validationResult = true;
    
        this.categoryValid = true;
        this.valueValid = true;
        this.ownershipValid = true;
        this.vehicleMakeValid = true;
        this.vehicleModelValid = true;
        this.vehicleYearValid = true;
        
        if(asset.Asset_Category__c=='None' || asset.Asset_Category__c==null ) {
            this.categoryValid = false;
            validationresult = false;
        }            
        if(asset.Asset_Value__c==null || asset.Asset_Value__c==0 || asset.Asset_Value__c < 0) {
            this.valueValid = false;
            validationresult = false;
        }
        if(asset.Ownership_Status__c=='None' || asset.Ownership_Status__c==null ) {
            this.ownershipValid = false;
            validationresult = false;
        }
        if(asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR
		|| asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_MOTOR_VEHICLE) { 
            if(asset.Vehicle_make__c==null || asset.Vehicle_make__c=='') {
                this.vehicleMakeValid = false;
                validationresult = false;
            }                
            if(asset.Vehicle_model__c==null || asset.Vehicle_model__c=='') {
                this.vehicleModelValid = false;
                validationresult = false;
            }                
            if(asset.Vehicle_year__c==null || asset.Vehicle_year__c=='0' || asset.Vehicle_year__c == '') {
                this.vehicleYearValid = false;
                validationresult = false;
            }                
        }
        
        // 12-10-14: Added condition for DBHZL-143
        if(asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_DEPOSITS
          || asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_KIWISAVER) { 
          	if(asset.Ownership_Status__c==GEN_OriginationsConstants.ASSET_OWNERSHIP_NONE || asset.Ownership_Status__c==null || asset.Ownership_Status__c=='') {
	            this.ownershipValid = true;
	            validationresult = true;
	        }
          }
        
        return validationresult;            
    }
    
    /*  Description: Computes total assets based on asset interval
     *  Author: Dan Crisologo
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public void setTotalAsset(Decimal totalAssets) {
        this.asset.Total_Assets__c = totalAssets;
    }
        
    /*  Description: Check assets category to clear the value of unwanted fields
     *  Author: Fel Saliba
     *  Date Created: OCT-21-2013
     *  Input Parameters: None
     *  Return: N/A
     */ 
    public void clearAssetFields(){
        if(this.asset.Asset_Category__c != GEN_OriginationsConstants.ASSET_CATEGORY_CAR &&
           this.asset.Asset_Category__c != GEN_OriginationsConstants.ASSET_CATEGORY_MOTOR_VEHICLE){

            this.asset.Vehicle_make__c = null;
            this.asset.Vehicle_model__c = null;
            this.asset.Vehicle_year__c = null;
        }
    }
}