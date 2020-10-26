import globalStyles from '@salesforce/resourceUrl/gM87_css';
import FlowComponentMixin from 'c/flowComponentMixin';
import {
    canFieldBeSaved,
    resetLightningInputsErrorsMessages
} from 'c/inputs';
import ResourcesLoader from 'c/resourcesLoader';
import { createErrorToast } from 'c/toastDialogs';
import { LightningElement } from 'lwc';
import UserCreationValidator from './UserCreationValidator';



const validFieldNames = [
    'firstName', 'lastName', 'userName', 'email'
];

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

    submitUser(event) {
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
            this.dispatchEvaluationEvent({
                'firstName': this._firstName,
                'lastName': this._lastName,
                'username': this._userName,
                'email': this.email
            });
        }
    }

    handleFieldUpdate(event) {
        canFieldBeSaved(validFieldNames, event)
            .then(event => this['_' + event.target.dataset.fieldName] = event.target.value)
            .catch(() => this._showErrorToast(('Something went wrong with field update.')));
    }

    _selectLightningField(name) {
        return this.template.querySelector('lightning-input[data-field-name="' + name + '"]');
    }

    _selectAllLightningInputs() {
        return Array.from(this.template.querySelectorAll('lightning-input[data-field-name]'));
    }

    _showErrorToast(message) {
        console.log(message)
        this.dispatchEvent(createErrorToast(message));
    }
}