/*
 * @Description: APP_Collateral_INT controller
 * @Author: Jade Serrano
 * @Date Created: 07-Feb-2014
 * @History:
 *  =====================================================================
 *      Jade - 07-Feb-2014: Created
        Mac  - 12-Feb-2014: Updated. Added Secured and Unsecured Loan selection.
 *  =====================================================================
 */
public class APP_CollateralCC_INT{
    
    transient public List<Collateral__c> collateralList{get;set;}
    transient public String currentApplicationName    {get;set;}
    transient public String keyPrefix                 {get;set;}
    transient public String objectId                  {get;set;}
    transient public String applicationFieldId        {get;set;}    
    transient public Boolean newButtonControl         {get;set;}

    public Application__c application {get;set;}
    public String currentApplicationId;

    public APP_CollateralCC_INT(ApexPages.StandardController controller){

        application = [SELECT   Id, 
                                Name, 
                                Response_Code__c
                       FROM     Application__c 
                       WHERE    Id =: controller.getRecord().Id];

        currentApplicationId = this.application.Id;
        //currentApplicationName = this.application.Name;

        //get object id from custom setting
        objectId = Object_Definition__c.getInstance('Collateral').Object_id__c;
        applicationFieldId = Object_Definition__c.getInstance('Collateral').Application__c;

        //get object prefix
        Schema.DescribeSObjectResult r = Collateral__c.sObjectType.getDescribe();
        keyPrefix = r.getKeyPrefix();

        collateralList = new List<Collateral__c>();
        collateralList = getCollateral();

        newButtonControl = buttonControl();

    }

    //refresh button
    public void refresh() {
      collateralList = getCollateral();
    }

    //get fieldsets
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Collateral__c.FieldSets.Collateral_Commons.getFields();
    }

    //get collaterals
    private List<Collateral__c> getCollateral() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }

        query += 'CreatedDate FROM Collateral__c WHERE Application__c =: currentApplicationId';

        return Database.query(query);

    }

    //collateral button rendering
    public Boolean buttonControl(){

        Boolean ret;

        List<Response_Code_Control__c> responseCodeControlList = new List<Response_Code_Control__c>();
        responseCodeControlList = [Select Id From Response_Code_Control__c Where Name =: this.application.Response_Code__c];

        if(responseCodeControlList.size()>0){

        Boolean newResponseCodeControl = Response_Code_Control__c.getInstance(this.application.Response_Code__c).New_Edit_Collateral__c;
        Boolean newProfileControl = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_Edit_Collateral__c;

        if(newResponseCodeControl && newProfileControl){
            ret = false;
        }else{
            ret = true;
        }

        return ret;

        }else{

          Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
          return ret;

        }
    }

    //get collateral total value
    public String getTotalCollateralValue(){

        String totalAmount; 

        List<Application__c> applicationList = [Select Total_Collateral_Value__c from Application__c where Id = :this.application.Id LIMIT 1];

        if(applicationList.size() > 0){

            if(applicationList[0].Total_Collateral_Value__c != null){
                totalAmount = String.valueOf(applicationList[0].Total_Collateral_Value__c);
            }
            
        }

        return totalAmount;

    }
}