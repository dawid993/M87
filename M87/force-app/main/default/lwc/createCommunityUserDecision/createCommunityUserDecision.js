import { LightningElement, api } from 'lwc';
import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';

export default class CreateCommunityUserDecision extends LightningElement {
    _navigationContext = {};

    options = [
        { label: 'Yes', value: "YES" },
        { label: 'No', value: "NO" }
    ];

    value = 'NO';

    @api
    set navigationContext(value) {
        this._navigationContext = value;
    }

    get navigationContext() {
        return this._navigationContext;
    }

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    handleChange(event) {
        const value = event.detail.value;
        this.value = value;
    }

    saveChoice(event) {
        this.dispatchEvent(new CustomEvent('evaluation', {
            detail: {
                stepData: this.value
            }
        }));
    }

    backToPreviousStep(event){                
        this.dispatchEvent(new CustomEvent('revertstep'));
    }
}