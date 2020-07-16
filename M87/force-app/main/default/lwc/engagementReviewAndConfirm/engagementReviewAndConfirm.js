import { LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';

export default class EngagementReviewAndConfirm extends FlowComponentMixin(LightningElement){
    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    backToPreviousStep(event){
        this.dispatchRevertEvent();
    }
}