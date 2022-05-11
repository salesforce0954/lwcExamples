/* @Description: Controller for Joint Application Assets (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: NOV-19-2013
 * @History:
   =====================================================================
       11-19-13: Created - Mike
       12-02-13: Applied single list of Assets - Mike
       12-03-13: Added GCO-489
	   01-14-14: Refactored to cater single and joint application - Mike
   =====================================================================
 */ 
public class APP_JointAssetsExt_INT extends APP_CommonExt {

    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<MyBudgetsAssetWrapper> assetAddList {get;set;}  //Asset record list
    public Integer assetListSize                    {get;set;}  //Asset record list size
    public Decimal totalAssets                      {get;set;}  //Total asset value
    public String Mode                              {get;set;}  //Identifier whether coming from edit application or edit asset
    public String redirectTo                        {get;set;}  //Pagereference identifier
    public Integer selectedRow                      {get;set;}  //Specific row/record to be deleted
    public Boolean isJoint                          {get;set;}  //Single/Joint identifier

    public List<Asset__c> assetListToDel = new List<Asset__c>();    //Asset record list for deletion
    public Boolean assetValidationResults;                          //Validation flag
    
    /*  Description: Main Controller class used for all initializations
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: None
     *  Return: void
     */
    public APP_JointAssetsExt_INT(ApexPages.StandardController applicationController) { 
        super(applicationController);
		string id=applicationController.getId();
		application__c app=[select Bank_Accounts_Held__c from application__c where id=:id];
		if(app.Bank_Accounts_Held__c!=null){
			bankAccountHeld=app.Bank_Accounts_Held__c;
		}else{
			bankAccountHeld='';
		}
		//To identify if back and next buttons should be displayed
        Mode = ApexPages.currentPage().getParameters().get('mode');
        
        isJoint = isJoint();
		totalAssets = 0;
		
        List<Asset__c> oldAsset = new List<Asset__c>();
        
        AssetDeposit = GEN_OriginationsConstants.ASSET_CATEGORY_DEPOSITS;
        AssetKiwiSaver = GEN_OriginationsConstants.ASSET_CATEGORY_KIWISAVER;
        
        //Retrieve asset records of applicant/s
        oldAsset = retrieveAssetList(this.applicant.Id);
        if(this.applicantList.size() > 1){
            oldAsset.addAll(retrieveAssetList(this.applicant2.Id));
        }

		if(!oldAsset.isEmpty()){
            //Set data to Asset wrapper
			assetAddList = new List<MyBudgetsAssetWrapper>();
            for(Asset__c a: oldAsset){
                MyBudgetsAssetWrapper mbaw = new MyBudgetsAssetWrapper(a);
                mbaw.isJoint = isJoint;
                assetAddList.add(mbaw);                
                if(a.Total_Assets__c != null){
                    totalAssets += a.Total_Assets__c;
                }
            }
			
			refreshCount();
            assetListSize = oldAsset.size();
        } else {
            //Instantiate new wrapper records
            assetAddList = new List<MyBudgetsAssetWrapper>();
            assetListSize = 0;
            addAsset();
        }
        this.assetValidationResults = true;
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Add new Asset record
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addAsset(){
        MyBudgetsAssetWrapper mbaw = new MyBudgetsAssetWrapper(this.applicant);
        mbaw.isJoint = isJoint;
        assetAddList.add(mbaw);
        assetListSize++;
		refreshCount();
    }
        
    /*  Description: Remove selected Asset record
     *  Author: Mike Lasala
     *  Date Created: DEC-11-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void removethisAsset(){
		if(!assetAddList.isEmpty()){
			for(MyBudgetsAssetWrapper ass: assetAddList){
				//MLASALA 02/05/14: Id is being set to null for creation of records to work. 
		    	//If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
		    	//Cause is still unknown
				if(String.valueOf(ass.asset.Id) != ''){
					if(selectedRow == ass.rowCount && ass.asset.Id != null){
						assetListToDel.add(assetAddList.get(selectedRow).asset);
						break;
					}	
				}
			}
			
			assetAddList.remove(selectedRow);
			assetListSize--;
			getTotalAsset();
			if(assetListSize==0){
				addAsset();
			}
			refreshCount();
		}
    }
    
	/*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: void
     */
	public void refreshCount(){
    	Integer i = 0;
    	for(MyBudgetsAssetWrapper ass: assetAddList){
    		ass.rowCount = i;
    		i++;
    	}
    }
	
	/*  Description: Computes total Assets
     *  Author: Mike Lasala
     *  Date Created: OCT-02-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void getTotalAsset() {
        totalAssets = 0;
        for(MyBudgetsAssetWrapper assetWrap: this.assetAddList) {
            if(assetWrap.asset.Asset_Value__c != null){
                totalAssets = totalAssets + assetWrap.asset.Asset_Value__c;
            }
        }
    }
    
    /*  Description: Validate assets records to upsert
     *  Author: Dan Crisologo
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: Boolean
     */
    public boolean validateFields() {
    	system.debug('check val'+bankAccountHeld);
    	if((bankAccountHeld=='' || bankAccountHeld==null)&& brand.country__c=='NZ'){
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a value :Bank Accounts Held');
			ApexPages.addMessage(myMsg);
			this.assetValidationResults=false;
			system.debug('check val'+this.assetValidationResults);
    	}else{
        this.assetValidationResults = true;
        totalAssets = 0;
		Decimal applicantTotalAssets = 0;
        List<MyBudgetsAssetWrapper> tempList = new List<MyBudgetsAssetWrapper>();
        
        for(MyBudgetsAssetWrapper assetWrap: assetAddList){
            if(assetWrap.asset.Asset_Category__c!='None' && assetWrap.asset.Asset_Category__c!=null){ 

                if(assetWrap.validateAsset()) {
                    totalAssets = totalAssets + assetWrap.asset.Asset_Value__c;
                    assetWrap.clearAssetFields();
                    tempList.add(assetWrap);
                } else {
                    this.assetValidationResults = false;
                }
            }
        }
        //insert all incomes if results are valid
        if(this.assetValidationResults) {
            List<Asset__c> assetsList = new List<Asset__c>();
            List<Liability__c> debtToInsert = new List<Liability__c>();
            //Decimal applicantTotalAssets = 0;
            
            for(MyBudgetsAssetWrapper mbaw: tempList){
            	if(mbaw.asset.Asset_Value__c!=null){
                	mbaw.setTotalAsset(mbaw.asset.Asset_Value__c);  //Set individual total asset value
                	applicantTotalAssets = applicantTotalAssets + mbaw.asset.Total_Assets__c;   //Compute and set overall total asset value
            	}
                //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
		    	//If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
		    	//Cause is still unknown
                if(String.valueOf(mbaw.asset.Id) == ''){
                	mbaw.asset.Id = null;
                }

                //Create debt if assets is car/house
                if(!mbaw.asset.debt_Created__c && mbaw.asset.Ownership_Status__c==GEN_OriginationsConstants.ASSET_OWNERSHIP_OWE &&
                    (mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR || 
                     mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_HOUSE)){
                    
					Liability__c d = new Liability__c();
                    d.Applicant__c = this.applicant.Id;
                    d.Total_Debts__c = 0;
                    if(mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_CAR){
                        d.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN;
                    }
                    else if(mbaw.asset.Asset_Category__c == GEN_OriginationsConstants.ASSET_CATEGORY_HOUSE){
                        d.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE;
                    }
					mbaw.asset.debt_Created__c = true;
                    debtToInsert.add(d);
                }
                assetsList.add(mbaw.asset);
            }
            
            try{
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Asset__c.SObjectType.getDescribe().isCreateable()) {
                    upsert assetsList;
                //}
            }
            catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointAssestsExt', 'Assets__c', 'Class', String.valueOf(this.application.Id));    
            }
            
            SavePoint sp = Database.setSavePoint();
            
            try{				
                updateAndSetApplicationOutOfSync(this.application);
            } 
			catch(DMLException e){
				setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointAssestsExt', 'Application__c', 'Class', String.valueOf(this.application.Id));
			}
			
            try{
				this.applicant.Total_Assets__c = applicantTotalAssets;
				
				update this.applicant;
            } 
			catch(DMLException e){
				setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointAssestsExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));    
            }
            
            if(!debtToInsert.isEmpty()) {
                try{
                    insert debtToInsert;
                }
                 catch(DMLException e){
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointAssestsExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));    
                }
            }
            
            if(!assetListToDel.isEmpty()){
                try{
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Asset__c.sObjectType.getDescribe().isDeletable()){
                       delete assetListToDel; 
                   }
                   */
                   delete assetListToDel; 
                }
                catch(DMLException e){
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointAssestsExt', 'Assets__c', 'Class', String.valueOf(this.application.Id));    
                }
            }
		}
    	}
		return this.assetValidationResults;
    }
    
	/*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
    	this.assetValidationResults = true;
    	
    	if(redirectTo == 'Save' || redirectTo == 'Next'){
    		validateFields();
    	}
    	
    	PageReference ref;
    	if(this.assetValidationResults){
    		if(redirectTo == 'Back'){
    			ref = Page.APP_JointIncome_INT;
    		} else if(redirectTo == 'Next'){
    			ref = Page.APP_JointExpenses_INT;
    		} else if(redirectTo == 'Save' || redirectTo == 'Cancel'){
    			ref = Page.APP_ApplicationMain_INT;
    		}
    		
    		ref.getParameters().put('id', this.application.Id);
	        ref.setRedirect(true);			
	        return ref;
    	} else {
    		return null;
    	}
    }
    
    /*  Description: Get Bank account held picklist values
     *  Author: Vijay
     *  Date Created: FEB-10-2015
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getbankAccountHeldOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Application__c.Bank_Accounts_Held__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }   
}