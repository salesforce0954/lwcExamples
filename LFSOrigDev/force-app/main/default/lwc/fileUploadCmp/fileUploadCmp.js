import { LightningElement, track, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUploadEndPoint from '@salesforce/apex/FileUploadController.getUploadEndPoint';
import insertRelatedDocument from '@salesforce/apex/FileUploadController.insertRelatedDocument';
import deleteRelatedDocument from '@salesforce/apex/FileUploadController.deleteRelatedDocument';
import {loadStyle} from 'lightning/platformResourceLoader';
import customCSS from '@salesforce/resourceUrl/FileUploadStaticCss';

export default class FileUploadCmp extends LightningElement {
    @track files = [];
    @track buttonUploadDisabled = false;
    @track uploadUrl = '';
    @track error = '';
    @track fileNotEmpty = false;
    @track fileErrorText = '';
    @track fileErrorHasValue = false;
    @track hasRendered = false;
    @track inProgressFiles = [];

    @api applicationid;
    @api applicantid;
    @api type;
    @api category;
    @api isbrokerinvoice = false;

    hasFConn;       // has failed connection
    hasDown;        // Server down flag
    hasRetry;       // Retry flag
    hasCorrupt;     // Corrupt file flag
    hasSupport;     // File not supported flag
    hasBig;         // File big flag    

    acceptedFileType = ['jpg','jpeg','png','tif','tiff','pdf','doc','docx','gif'];

    /*fillPercent = 15/100;
    @track arcX = Math.cos(2 * Math.PI * Number(this.fillPercent));
    @track arcY = Math.sin(2 * Math.PI * Number(this.fillPercent));
    @track isLong = this.fillPercent > (50/100)?1:0;
    @track d = `M 1 0 A 1 1 0 ${this.isLong} 1 ${this.arcX} ${this.arcY} L 0 0`*/

    renderedCallback() {
        if(!this.hasRendered) {
            this.hasRendered = true;
            //Load custom css
            Promise.all([
                loadStyle(this, customCSS)
            ]); 
        }
    }

    @wire(getUploadEndPoint) retrieveUploadEndpoint({ error, data }) {
        if (data) {
            this.uploadUrl = data;
            this.error = undefined;
        } else if (error) {
            console.log(error);
            this.error = error.body.message;

            //for debugging purpose
            //this.showErrorNotification();            
        }
    };

    connectedCallback() {
        /*console.log(2 * Math.PI * Number(this.fillPercent));
        console.log(this.arcX);
        console.log(this.arcY);*/
    }

    handleFileChange(event) {
        const lfiles = event.target.files;
        this.putAttachmentIntoFiles(lfiles);
    }

    putAttachmentIntoFiles(listFile) {
        this.fileErrorText = '';
        this.fileErrorHasValue = false;
        for(let f of listFile) {
            let duplicate = false;
            for(let lf of this.files) {
                if(f.name === lf.file.name && lf.inQueue === true) {
                    duplicate = true;
                    break;
                }
            }
     
            if(!duplicate) {
                let fileWrapper = {
                    showRemove: false
                };
                //console.log(f.type);
                fileWrapper.file = new File([f], f.name, { type: f.type });
                //fileWrapper.file = f;
                fileWrapper.d = `M 1 0 A 1 1 0 0 1 0 0 L 0 0`;
                let validation = this.fileValidationCheck(fileWrapper); 
                if(validation === true) {
                    fileWrapper.rateSuccess = Math.floor(Math.random() * 10);
                    fileWrapper.inQueue = true;
                    fileWrapper.inProgress = false;
                    this.files.push(fileWrapper);
                } else {
                    this.fileErrorHasValue = true;
                    //this.fileErrorText += fileWrapper.errorText + ' - ('+fileWrapper.file.name+')\r\n';
                    this.showErrorNotification(fileWrapper.errorText + ' - ('+fileWrapper.file.name+')\r\n', true);
                }
            }     
        }
        this.inProgressFiles = this.files.filter((q) => {
            return q.inProgress === false;
        });
        this.handleUploadProcess(); 
        this.checkFileLength();    
    }

    fileValidationCheck(fileWrapper) {
        let fSize = fileWrapper.file.size;
        let fileSizeInMB = Math.round((fSize / 1024));
        
        //check file size
        if(fileSizeInMB > 10120) {
            fileWrapper.errorText = "Please upload a file that is 10MB or less";
            return false;
        }
        if(!this.acceptedFileType.includes(this.fileExtensionRegex(fileWrapper.file.name))) {
            fileWrapper.errorText = "File type not supported. Accepted file types: "+this.acceptedFileType.join(',');
            return false;
        }
        return true;
    }

    fileExtensionRegex(fileName) {
        return fileName.split('.').pop().toLowerCase();
    }

    handleRemoveAttachment(event) {
        let index = event.target.dataset.keyindex;
        this.files.splice(index,1);
        this.checkFileLength();
    }

    sleep(ms) {
        return new Promise(resolve => {
            setTimeout(()=>{resolve('')},ms);
        });
    }

    async handleUploadProcess(event) {
        await this.sleep(1000);
        //console.log(this.applicantid);
        let mainContext = this;

        let currFile = this.inProgressFiles[0];
        currFile.inProgress =  true;
        currFile.percent = 0;

        /*let applicantId = null;
        if(this.isbrokerinvoice === "false") {
            applicantId = mainContext.applicantid;
        }*/
        let applicantId = mainContext.applicantid;

        insertRelatedDocument({
            title:currFile.file.name,
            applicationId:mainContext.applicationid,
            applicantId: applicantId,
            mockEnabled:false
        })
        .then((result) => {
            currFile.relatedDocumentId = result.recordIdSaved;
            let urlVar = mainContext.uploadUrl; 
            let file = currFile.file;
            //console.log(file.name);
            let xhr = new XMLHttpRequest();                                      
            let connHandler = function(){                    
                if(this.status==200){
                    currFile.success = true;
                    currFile.inQueue = false;
                    currFile.showRemove = false;
                    mainContext.showSuccessNotification("File(s) successfully uploaded");  
                    //mainContext.showSuccessNotification("File successfuly uploaded ("+currFile.file.name+")");                        
                    //console.log(xhr.responseText);
                }else if(this.status==0){
                    mainContext.hasFConn = true;
                    //console.log('fail');
                    deleteRelatedDocument({
                        delRelId: result.recordIdSaved
                    })
                    .then((result) => {
                        //console.log('file deleted');
                        currFile.error = true;
                        currFile.inQueue = false;
                        currFile.showRemove = true;
                        //mainContext.showErrorNotification("File failed to upload. Please try again.");                      
                    })
                    .catch((error) => {
                        console.log(error);
                    });
                }else{
                    //console.log('fail2');
                    deleteRelatedDocument({
                        delRelId: result.recordIdSaved
                    })
                    .then((result) => {
                        //console.log('file deleted');
                        currFile.error = true;
                        currFile.inQueue = false;
                        currFile.showRemove = true;
                        //mainContext.showErrorNotification("File failed to upload. Please try again.");                      
                    })
                    .catch((error) => {
                        console.log(error);
                    });
                    
                    // Set at least one retry flag
                    if(this.status==209){
                        mainContext.hasRetry = true;
                    }

                    // Set at least one corrupt
                    if(this.status==222 ){
                        mainContext.hasCorrupt = true;
                    } 

                    // Set at least one file too big
                    if(this.status==220 ){
                        mainContext.hasBig = true;
                    } 

                    // Set at least one file not supported
                    if(this.status==221 ){
                        mainContext.hasSupport = true;
                    } 
                    
                    // Server not available
                    if(this.status==503 ){
                        mainContext.hasDown = true;
                    } 
                }

                let failAddMsg = '';
                // Assign right message depending on response code
                if(mainContext.hasFConn){
                    //failAddMsg = 'Server connection currently unavailable.';
                    //failAddMsg = 'Unfortunately a system error has occurred. We are unable to process your document upload at this time. We 
                    //apologise for any inconvenience caused.';
                    failAddMsg = 'File could not be uploaded due to a system error. Please try again.';
                } else if(mainContext.hasDown){
                    //failAddMsg = 'File upload server currently unavailable.';
                    failAddMsg = 'File could not be uploaded due to a system error. Please try again.';
                }else if(mainContext.hasRetry){
                    //failAddMsg = 'Upload fail. Please try again later.';
                    failAddMsg = 'File could not be uploaded due to a system error. Please try again.';
                }else if(mainContext.hasCorrupt){
                    failAddMsg = 'File could not be uploaded because your document is corrupted. Please use another document.';
                }else if(mainContext.hasBig){
                    failAddMsg = 'Please upload a file that is 10MB or less';
                }else if(mainContext.hasSupport){
                    failAddMsg = 'File could not be uploaded because your document type is not supported. Please use another document.';
                }
                if(failAddMsg != '') {
                    mainContext.showErrorNotification(failAddMsg, true);
                }

                mainContext.inProgressFiles.splice(0,1);
                if(mainContext.inProgressFiles.length > 0) {
                    mainContext.handleUploadProcess()
                }                
            }// End on load method

            // Assign success function
            xhr.onload = connHandler;
            // Assign error function  
            xhr.onerror = connHandler;

            //xhr.onprogress = uploadProgress;

            xhr.upload.addEventListener("progress", e => {
                //if (e.lengthComputable) {
                    //console.log(e.loaded);
                    //console.log(e.total);                        
                    let ratio = Math.floor((e.loaded / e.total));
                    //console.log(ratio);
                    let arcX = Math.cos(2 * Math.PI * Number(ratio));
                    let arcY = Math.sin(2 * Math.PI * Number(ratio));
                    //console.log(arcX);
                    //console.log(arcY);
                    let isLong = ratio > (50/100)?1:0;
                    //console.log(isLong);                        
                    currFile.d = `M 1 0 A 1 1 0 ${isLong} 1 ${arcX} ${arcY} L 0 0`;
                    //console.log(currFile.d);
                //}
            });
           
            //console.log(file);
            xhr.open('post', urlVar, true);
            
            var formData = new FormData();
        
            /*console.log("firstName:" + result.applicantFirstName);
            console.log("lastName:" + result.applicantLastName); 
            console.log("appNum:" + result.applicationUniqueID); 
            console.log("timestamp:" + result.getDateStamp);
            console.log("product:" + result.productId); 
            console.log("sfDocId:" + result.recordIdSaved);*/

            formData.append("firstName", result.applicantFirstName);
            formData.append("lastName", result.applicantLastName); 
            formData.append("appNum", result.applicationUniqueID);
            formData.append("product", result.productId);  
            formData.append("timestamp", result.getDateStamp);
            formData.append("sfDocId", result.recordIdSaved);  
            formData.append("file", file);
            
            try{
                xhr.send(formData);  
            }catch(e){
                currFile.error = true;
                currFile.inQueue = false;                
                currFile.showRemove = true;
                mainContext.showErrorNotification("File failed to upload. Please try again.", true);
                console.log(error);
                mainContext.inProgressFiles.splice(0,1);
                if(mainContext.inProgressFiles.length > 0) {
                    mainContext.handleUploadProcess()
                }
            }                
        });         
    }

    checkFileLength() {
        this.fileNotEmpty = this.files.length > 0?true:false;
    }

    showErrorNotification(errMessage, isSticky) {
        let mode = 'dismissible';
        if(isSticky) {
            mode = 'sticky'
        }

        const evt = new ShowToastEvent({
            title: "Error",
            message: errMessage,
            variant: "error",
            mode: mode
        });
        this.dispatchEvent(evt);
    } 
    
    showSuccessNotification(succMessage) {
        const evt = new ShowToastEvent({
            title: "File Uploaded",
            message: succMessage,
            variant: "success",
        });
        this.dispatchEvent(evt);
    }     
}