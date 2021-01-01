import { api, LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';
import ResourcesLoader from 'c/resourcesLoader';
import gm87_style from '@salesforce/resourceUrl/gM87_css';
import gm87_style_popups from '@salesforce/resourceUrl/gM87_css';
import save from '@salesforce/apex/EngagementReviewAndConfirmController.saveLead';
import { createErrorToast } from 'c/toastDialogs';

const MANUAL_FILE_UPLOAD_SELECTOR = 'c-manual-file-upload';
const APPLICATION_DONE_EVENT_NAME = 'application_done_public';

import {
    LEAD_DETAILS_STEP,
    COMMUNITY_USER_STEP,
} from 'c/stepsDescriptors';

const LEAD_DETAILS_ID = LEAD_DETAILS_STEP.id;
const COMMUNITY_USER_ID = COMMUNITY_USER_STEP.id;

export default class EngagementReviewAndConfirm extends FlowComponentMixin(LightningElement) {

    _reviewData;

    _leadDetails;

    _communityUserDetail;

    _confirmDialogVisible;

    @api
    set reviewData(value) {
        this._reviewData = value;
    }

    get reviewData() {
        return this._reviewData;
    }

    get leadDetails() {
        return this._leadDetails;
    }

    get communityUserDetails() {
        return this._communityUserDetail;
    }

    get showConfirmDialog() {
        return this._confirmDialogVisible;
    }

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [gm87_style, gm87_style_popups]);
    }

    connectedCallback() {
        this.reviewData = this.reviewData ? this.reviewData : {};
        this._leadDetails = this.reviewData[LEAD_DETAILS_ID] ? this.reviewData[LEAD_DETAILS_ID] : {};
        this._communityUserDetail = this.reviewData[COMMUNITY_USER_ID] ? this.reviewData[COMMUNITY_USER_ID] : {};

    }

    backToPreviousStep() {
        this.dispatchRevertEvent();
    }

    makeConfirmDialogVisible() {
        this._confirmDialogVisible = true;
    }

    makeConfirmDialogInvisible() {
        this._confirmDialogVisible = false;
    }

    saveApplication() {
        let createLeadPartial = this._createLeadDescription(
            this._reviewData[LEAD_DETAILS_STEP.id],
            this._reviewData[COMMUNITY_USER_STEP.id]
        );        

        const manualFileUpload = this.template.querySelector(MANUAL_FILE_UPLOAD_SELECTOR);
        let manualFileUploadPromise = manualFileUpload.isFileLoaded() ? 
            manualFileUpload.getFileAsBase64() : Promise.resolve();

        manualFileUploadPromise
            .then(result => save({
                leadDTO: createLeadPartial(result)
            }))
            .then(result => {
                if (result.success) {
                    this._fireApplicationDoneEvent();
                } else {
                    this.dispatchEvent(createErrorToast('Error', 'Cannot perform save action.'));
                }
            })
            .catch(err => console.log(err.name + ' ' + err.message));
    }

    _fireApplicationDoneEvent() {
        this.dispatchEvent(
            new CustomEvent(APPLICATION_DONE_EVENT_NAME, {
                bubbles: true,
                composed: true
            })
        );
    }

    _createLeadDescription(leadDescription, communityUserDescription) {
        return fileBase64 => {
            const requestObj = {};
            requestObj['leadDetails'] = leadDescription;
            requestObj['communityUserDetails'] = communityUserDescription;
            requestObj['fileAsBase64Blob'] = fileBase64;

            return requestObj;
        }        
    }
}