import { api, LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import save from '@salesforce/apex/EngagementReviewAndConfirmController.saveLead';

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
        this._reviewData = value;        
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
        this.reviewData = this.reviewData ? this.reviewData : {};
        this._leadDetails = this.reviewData[LEAD_DETAILS_STEP.id] ? this.reviewData[LEAD_DETAILS_STEP.id] : {};
        this._communityUserDetail = this.reviewData[COMMUNITY_USER_STEP.id] ? this.reviewData[COMMUNITY_USER_STEP.id] : {};
    }

    backToPreviousStep(event){
        this.dispatchRevertEvent();
    }

    saveApplication(event){        
        let createObjFunction = this._createLeadDescription();
        createObjFunction = createObjFunction((this._reviewData[LEAD_DETAILS_STEP.id]));
        createObjFunction = createObjFunction(this._reviewData[COMMUNITY_USER_STEP.id]);
        
        const manualFileUpload = this.template.querySelector(MANUAL_FILE_UPLOAD_SELECTOR);
        let savePromise = manualFileUpload.isFileLoaded() ? manualFileUpload.getFileAsBase64() : Promise.resolve();

        savePromise
        .then(result =>  save({
            leadDTO : createObjFunction(result)
        }))
        .catch(err => console.log(err.name +' '+err.message));
    }

    _createLeadDescription(){
        return leadDescription => communityUserDescription => fileBase64 => {
            const requestObj = {};
            requestObj['leadDetails'] = leadDescription;
            requestObj['communityUserDetails'] = communityUserDescription;
            requestObj['fileAsBase64Blob'] = fileBase64;

            return requestObj;
        }
    }
}