import { LightningElement, wire, track, api } from 'lwc';
import ASSET_OBJECT from '@salesforce/schema/Asset__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ASSET_TYPE_FIELD from '@salesforce/schema/Asset__c.Asset_Category__c';
import ASSET_OWNERSHIP_FIELD from '@salesforce/schema/Asset__c.Ownership_Status__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BP_LBL_Asset_Info_Single from '@salesforce/label/c.BP_LBL_Asset_Info_Single';
import BP_LBL_Asset_Info_Joint from '@salesforce/label/c.BP_LBL_Asset_Info_Joint';
import BP_LBL_No_Asset_Error_Joint from '@salesforce/label/c.BP_LBL_No_Asset_Error_Joint';
import BP_LBL_No_Asset_Error_Single from '@salesforce/label/c.BP_LBL_No_Asset_Error_Single';
import BP_LBL_No_Asset_Joint from '@salesforce/label/c.BP_LBL_No_Asset_Joint';
import BP_LBL_No_Asset_Single from '@salesforce/label/c.BP_LBL_No_Asset_Single';
import BP_LBL_No_Assets from '@salesforce/label/c.BP_LBL_No_Assets';


export default class LoanAssetDetails extends LightningElement {

    auAssetRecordTypeId;
    assetTypeOptions;
    assetOwnershipOptions;
    @track assetDetailsList = [];
    showAddAssetForm = false;
    @api assetDetailsObj;
    @api inputMode;
    @api isJointApplication;
    @track copyAssetDetailsObj;
    //denotes if its new or edit
    mode;
    assetObj = {};
    showCarFields = false;
    // a maximum of 10 assets can be added
    maxAssetsAdded = false
    assetInformation;
    noAssetsMsg;
    noAssetErrorMsg;
    variablesSet = false;

    connectedCallback() {
        this.copyAssetDetailsObj = { ...this.assetDetailsObj };
        if (this.copyAssetDetailsObj.AssetInfo !== undefined && this.copyAssetDetailsObj.AssetInfo.length > 0) {
            this.assetDetailsList = [...this.copyAssetDetailsObj.AssetInfo];
        }
        if (!this.variablesSet) {
            if (this.isJointApplication) {
                this.assetInformation = BP_LBL_Asset_Info_Joint;
                this.noAssetsMsg = BP_LBL_No_Asset_Joint;
                this.noAssetErrorMsg = BP_LBL_No_Asset_Error_Joint;
            } else {
                this.assetInformation = BP_LBL_Asset_Info_Single;
                this.noAssetsMsg = BP_LBL_No_Asset_Single;
                this.noAssetErrorMsg = BP_LBL_No_Asset_Error_Single;
            }
            this.variablesSet = true;
        }
    }


    @wire(getObjectInfo, { objectApiName: ASSET_OBJECT })
    handleResponse({ data, error }) {
        if (data) {
            for (const [key, value] of Object.entries(data.recordTypeInfos)) {
                if (value.name === 'AU') {
                    this.auAssetRecordTypeId = value.recordTypeId;
                    break;
                }
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auAssetRecordTypeId', fieldApiName: ASSET_TYPE_FIELD })
    handleAssetTypeValues({ error, data }) {
        if (data) {
            this.assetTypeOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$auAssetRecordTypeId', fieldApiName: ASSET_OWNERSHIP_FIELD })
    handleAssetOwnershipValues({ error, data }) {
        if (data) {
            this.assetOwnershipOptions = data.values
        } else if (error) {
            this.genericErrorLoadingForm();
        }
    }

    genericErrorLoadingForm() {
        this.showToast('Error', 'Error Loading Application Form. Please try after sometime.', 'error', 'pester');
    }

    /* Generic event for showing a toast message
      on the page.
   */
    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }

    get tableHasData() {
        return this.assetDetailsList.length > 0 ? true : false;
    }

    handleAddAsset() {
        this.assetObj = {};
        this.mode = 'new';
        this.showAddAssetForm = true;
    }

    handleAddAssetCancel() {
        this.showAddAssetForm = false;
    }

    handleAssetDetailsChange(event) {
        let fieldName = event.target.name;
        let fieldValue = event.target.value;
        let assetDetailsListLen = this.assetDetailsList.length;

        if (fieldName === 'assettype') {
            if (fieldValue === 'Car') {
                this.showCarFields = true;
            } else {
                this.showCarFields = false;
            }
            this.assetObj.AssetType = fieldValue;
            //Set the id only during create and not when editing
            if (this.mode === 'new') {
                let entryId = assetDetailsListLen + 1;
                //get all the Ids of objects in the list
                let assetIdArray = this.assetDetailsList.map(currentItem => {
                    return currentItem.id;
                });
                if (assetIdArray.includes(entryId)) {
                    let maxId = Math.max(...assetIdArray);
                    entryId = maxId + 1;
                }
                this.assetObj.id = entryId;
            }

            this.copyAssetDetailsObj.NoAssets = false;
        } else if (fieldName === 'assetValue') {
            this.assetObj.AssetValue = fieldValue;
        } else if (fieldName === 'assetOwnership') {
            this.assetObj.AssetOwnership = fieldValue;
        } else if (fieldName === 'vehicleMake') {
            this.assetObj.VehicleMake = fieldValue;
        } else if (fieldName === 'vehicleModel') {
            this.assetObj.VehicleModel = fieldValue;
        } else if (fieldName === 'yearOfManufacture') {
            this.assetObj.YearOfManufacture = fieldValue;
        } else if (fieldName === 'dontHaveAssets') {
            if (event.target.checked) {
                //indicates no assets checked
                this.copyAssetDetailsObj.NoAssets = true;
            } else {
                this.copyAssetDetailsObj.NoAssets = false;
            }
        }
    }

    get showAddAssetButton() {
        if (this.copyAssetDetailsObj.NoAssets) {
            return false;
        } else {
            return true;
        }
    }

    handleAddAssetSave() {
        //Run validations
        const inputFieldsCorrect = [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        //Validate if all the required fields have values and then fire an event to notify the parent 
        //component of a change in the step
        const inputPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        if (inputFieldsCorrect && inputPicklistCorrect) {
            if (this.mode === 'new') {
                this.assetDetailsList = [...this.assetDetailsList, this.assetObj];
                this.assetObj = {};
                this.showAddAssetForm = false;
                this.showCarFields = false;
                this.mode = null;
            } else if (this.mode === 'edit') {
                let index = this.assetObj.id;
                let indexInArray = this.assetDetailsList.map(function (currentItem) {
                    return currentItem.id
                }).indexOf(Number(index));
                if (indexInArray !== -1) {
                    this.assetDetailsList[indexInArray] = this.assetObj;
                    this.assetObj = {};
                    this.showAddAssetForm = false;
                    this.showCarFields = false;
                    this.mode = null;
                }
            }
            if (this.assetDetailsList.length === 10) {
                this.maxAssetsAdded = true;
                this.showToast('info', "You can add upto 10 Assets", 'info', 'dismissable');
            } else {
                this.maxAssetsAdded = false;
            }
        }
    }

    handleAssetEdit(event) {
        this.mode = 'edit';
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.assetDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.assetObj = { ...this.assetDetailsList[indexOfObject] };
        if (this.assetObj.AssetType === 'Car') {
            this.showCarFields = true;
        } else {
            this.showFields = false;
        }
        this.showAddAssetForm = true;
    }

    handleAssetDelete(event) {
        let buttonIndex = event.target.dataset.name;
        let indexOfObject = this.assetDetailsList.map(function (currentItem) {
            return currentItem.id
        }).indexOf(Number(buttonIndex));
        this.assetDetailsList.splice(indexOfObject, 1);
        if (this.assetDetailsList.length === 10) {
            this.maxAssetsAdded = true;
        } else {
            this.maxAssetsAdded = false;
        }
    }

    @api handleValidationOnNext() {

        const checkbox = this.template.querySelector('.dont-have-assets');
        //Case where 'Dont have assets' checkbox is not checked & no asset information is added.
        if (!checkbox.checked && !this.assetDetailsList.length > 0) {
            this.showToast('Error', this.noAssetErrorMsg, 'error', 'pester');
            return;
        }
        return true;
    }

    handleAssetDetailsNext() {
        if (this.handleValidationOnNext()) {
            this.copyAssetDetailsObj.AssetInfo = this.assetDetailsList;
            this.fireAssetDetailsNotifyEvent();
        }

    }

    fireAssetDetailsNotifyEvent() {
        this.dispatchEvent(new CustomEvent('assetdetailsinfo', {
            detail: {
                completedStep: 'step-5',
                nextStep: 'step-6',
                assetDetails: this.copyAssetDetailsObj
            }
        }));
    }

    handleAssetDetailsPrev() {
        this.dispatchEvent(new CustomEvent('assetdetailsprev', {
            detail: {
                prevStep: 'step-4'
            }
        }));
    }

    @api getUpdatedDetails() {

        this.handleAssetDetailsNext();
    }

    get isDisabled() {
        if (this.inputMode !== undefined && this.inputMode !== null && this.inputMode === 'review') {
            return true;
        } else {
            return false;
        }
    }

    /**Custom labels for fields*/
    label = {
        BP_LBL_Asset_Info_Single,
        BP_LBL_Asset_Info_Joint,
        BP_LBL_No_Asset_Single,
        BP_LBL_No_Asset_Joint,
        BP_LBL_No_Asset_Error_Joint,
        BP_LBL_No_Asset_Error_Single,
        BP_LBL_No_Assets
    }


}