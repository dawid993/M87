import searchForUsernameOrEmail from '@salesforce/apex/CommunityUserCreationController.searchForUsernameOrEmail';
import globalStyles from '@salesforce/resourceUrl/gM87_css';
import FlowComponentMixin from 'c/flowComponentMixin';
import {
    areLightningInputsValid, canFieldBeSaved,
    resetLightningInputsErrorsMessages, showErrorMessagesForLightningInputs
} from 'c/inputs';
import ResourcesLoader from 'c/resourcesLoader';
import { createErrorToast } from 'c/toastDialogs';
import { LightningElement } from 'lwc';


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

    submitUser(event) {
        const inputs = this._selectAllLightningInputs();
        resetLightningInputsErrorsMessages(inputs);
        this._validateUserSubmission(inputs, this._userName, this._email)
            .then(this._mapResponses(inputs))
            .then(this._validateResponses.bind(this))
            .then(this._redirectIfSubmissionValid.bind(this))
            .catch(this._showErrorToast.bind(this, 'Cannot submit form.'));
    }

    _validateUserSubmission(formInputs, username, email) {
        return Promise.all([
            this._getFormDataCheckPromise(formInputs),
            this._getUserDataCheckPromise(username, email),
        ]);
    }

    _mapResponses(inputs) {
        return (responses) => {
            if (!responses[1].success) {
                throw new Error('Cannot submit form.');
            }

            return [
                this._createCheck(responses[0], showErrorMessagesForLightningInputs.bind(null, inputs)),

                this._createCheck(
                    responses[1].detailedResult.usernameCount === 0,
                    this._showUsernameInvalid.bind(this)
                ),

                this._createCheck(
                    responses[1].detailedResult.emailCount === 0,
                    this._showEmailInvalid.bind(this)
                ),
            ];
        }
    }

    _createCheck(isValid, callback) {
        return {
            isValid: isValid,
            callbackWhenInvalid: callback
        }
    }

    _validateResponses(responses) {
        return responses.reduce(
            (acc, currentCheck) => {
                const result = currentCheck.isValid;
                if (!result) {
                    currentCheck.callbackWhenInvalid();
                }

                return acc && result;
            },
            true
        );
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

    _getUserDataCheckPromise(username = '', email = '') {
        return searchForUsernameOrEmail({ 'username': username, 'email': email });
    }

    _getFormDataCheckPromise(formInputs = []) {
        return areLightningInputsValid(formInputs);
    }

    _redirectIfSubmissionValid(isValid) {
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

    _selectAllLightningInputs() {
        return Array.from(this.template.querySelectorAll('lightning-input[data-field-name]'));
    }

    _showErrorToast(message) {
        this.dispatchEvent(createErrorToast(message));
    }
}