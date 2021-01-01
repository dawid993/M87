import globalStyles from '@salesforce/resourceUrl/gM87_css';

import FlowComponentMixin from 'c/flowComponentMixin';

import {
    resetLightningInputsErrorsMessages
} from 'c/inputs';

import ResourcesLoader from 'c/resourcesLoader';

import { createErrorToast } from 'c/toastDialogs';

import { api, LightningElement } from 'lwc';

import UserCreationValidator from './UserCreationValidator';

import {
    findFirstName,
    findLastName,
    findUserName,
    findEmail
} from './findInputFunctions';

function validationReducer(acc, current) {
    if (!current.isFormValid) {
        this._selectLightningField(current.inputName).showHelpMessageIfInvalid();
    }
    if (current.isApexValidationFailed) {
        if (current.inputName === 'email') {
            this._showEmailInvalid();
        } else if (current.inputName === 'userName') {
            this._showUsernameInvalid();
        }
    }

    return acc && current.isFieldValid && !current.isApexValidationFailed;
}

export default class CommunityUserCreation extends FlowComponentMixin(LightningElement) {

    _stepData;

    constructor() {
        super();
        ResourcesLoader.loadStyles(this, [globalStyles]);
    }

    @api
    set stepData(value) {
        if (value) {
            this._stepData = value;
        }
    }

    get stepData() {
        const allFields = this._selectAllLightningInputs();
        return {
            'firstName': allFields.find(findFirstName).value,
            'lastName': allFields.find(findLastName).value,
            'userName': allFields.find(findUserName).value,
            'email': allFields.find(findEmail).value
        };
    }

    renderedCallback() {
        if (this._stepData) {
            const allFields = this._selectAllLightningInputs();
            allFields.find(findFirstName).value = this._stepData.firstName;
            allFields.find(findLastName).value = this._stepData.lastName;
            allFields.find(findUserName).value = this._stepData.userName;
            allFields.find(findEmail).value = this._stepData.email;
        }
    }

    backToPreviousStep() {
        this.dispatchRevertEvent();
    }

    submitUser() {
        const inputs = this._selectAllLightningInputs();
        resetLightningInputsErrorsMessages(inputs);
        new UserCreationValidator()
            .validate(this._selectAllLightningInputs())
            .then(results => results.reduce(validationReducer.bind(this), true))
            .then(this._redirectIfValid.bind(this))
            .catch(this._showErrorToast.bind(this));
    }

    _showUsernameInvalid() {
        const usernameInput = this.template.querySelector('[data-field-name ="userName"]');
        usernameInput.setCustomValidity('This username is unavailable.');
        usernameInput.showHelpMessageIfInvalid();
    }

    _showEmailInvalid() {
        const emailInput = this.template.querySelector('[data-field-name="email"]');
        emailInput.setCustomValidity('This email is unavailable.');
        emailInput.showHelpMessageIfInvalid();
    }

    _redirectIfValid(isValid) {
        if (isValid) {
            this.dispatchEvaluationEvent(this.stepData);
        }
    }

    _selectLightningField(name) {
        return this.template.querySelector('lightning-input[data-field-name="' + name + '"]');
    }

    _selectAllLightningInputs() {
        return Array.from(this.template.querySelectorAll('lightning-input[data-field-name]'));
    }

    _showErrorToast(message) {
        this.dispatchEvent(createErrorToast(message));
    }
}