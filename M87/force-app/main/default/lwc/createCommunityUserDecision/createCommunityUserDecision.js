import { LightningElement, api } from 'lwc';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import FlowComponentMixin from 'c/flowComponentMixin';

export default class CreateCommunityUserDecision extends FlowComponentMixin(LightningElement) {   

    options = [
        { label: 'Yes', value: "YES" },
        { label: 'No', value: "NO" }
    ];

    value = 'NO';
   
    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    handleChange(event) {
        const value = event.detail.value; 
        this.value = value;
    }

    saveChoice(event) {       
        this.dispatchEvaluationEvent(this.value == 'YES');
    }

    backToPreviousStep(event){                
        this.dispatchEvent(new CustomEvent('revertstep'));
    }
}