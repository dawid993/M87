import { api, LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import save  from '@salesforce/apex/EngagementLeadFlowControllre.save';

const MANUAL_FILE_UPLOAD_SELECTOR = 'c-manual-file-upload';

import {
    LEAD_DETAILS_STEP,    
    COMMUNITY_USER_STEP, 
} from 'c/stepsDescriptors';

export default class EngagementReviewAndConfirm extends FlowComponentMixin(LightningElement){

    _reviewData;

    _leadDetails;

    _communityUserDetail;

    @api
    set reviewData(value){
        console.log(LEAD_DETAILS_STEP)
        this._reviewData = value;
        console.log(JSON.stringify(this._reviewData));
    }

    get reviewData(){
        return this._reviewData;
    }

    get leadDetails(){
        return this._leadDetails;
    }

    get communityUserDetails(){
        return this._communityUserDetail;
    }

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    connectedCallback(){
        this._leadDetails = this.reviewData[LEAD_DETAILS_STEP.id];
        this._communityUserDetail = this.reviewData[COMMUNITY_USER_STEP.id];
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