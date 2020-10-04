import { LightningElement } from 'lwc';
import FlowComponentMixin from 'c/flowComponentMixin';

import ResourcesLoader from 'c/resourcesLoader';
import globalStyles from '@salesforce/resourceUrl/gM87_css';

import {canFieldBeSaved, areLightningInputsValid} from 'c/inputs';
import { createErrorToast } from 'c/toastDialogs';

const validFieldNames = [
    'firstName', 'lastName', 'userName', 'email'
];

export default class CommunityUserCreation extends FlowComponentMixin(LightningElement) {

    get firstName() {
        return this._firstName;
    }

    get lastName() {
        return this._lastName;
    }

    get userName() {
        return this._userName;
    }

    get email() {
        return this._email;
    }  

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    backToPreviousStep(event) {
        this.dispatchRevertEvent();
    }

    saveCommunityUser(event) {       
        return this._validateFormData();
        this.dispatchEvaluationEvent();
    }

    handleFieldUpdate(event) { 
        canFieldBeSaved(validFieldNames,event)
        .then(canBeSaved => {
            if(!canBeSaved){
                throw new Error(event.target.dataset.fieldName + 'can not be saved.');                
            }
            this['_'+event.target.dataset.fieldName] = event.target.value;
            return event;
        })
        .catch(() => this.dispatchEvent(createErrorToast('Something went wrong with field update.')));       
    }

    _validateFormData(){        
        const inputsValid = areLightningInputsValid(this._selectAllLightningInputs());        
        console.log(inputsValid);
    }

    _selectAllLightningInputs(){
        return Array.from(this.template.querySelectorAll('lightning-input[data-field-name]'));
    }
}