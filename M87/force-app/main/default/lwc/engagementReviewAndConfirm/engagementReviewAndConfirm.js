import { LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import save  from '@salesforce/apex/EngagementLeadFlowControllre.save';

const MANUAL_FILE_UPLOAD_SELECTOR = 'c-manual-file-upload';

export default class EngagementReviewAndConfirm extends FlowComponentMixin(LightningElement){
    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    backToPreviousStep(event){
        this.dispatchRevertEvent();
    }

    saveApplication(event){        
        const manualFileUpload = this.template.querySelector(MANUAL_FILE_UPLOAD_SELECTOR);       
        manualFileUpload.getFileAsBase64()
        .then(result =>  save({fileAsBase64Blob : result}))
        .catch(err => console.log(err.name +' '+err.message));
      
    }
}