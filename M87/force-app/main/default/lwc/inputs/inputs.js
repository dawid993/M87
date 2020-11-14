import { Either } from 'c/jsFunctional';

function _checkIfFieldIsValid(validFieldNames, fieldName) {
    return validFieldNames.some(currentName => currentName === fieldName);
}

function _isEventValid(event) {
    return event && event.target && event.target.dataset && event.target.dataset.fieldName;
}

function canFieldBeSaved(validFieldNames = [], event) {
    return Either((resolve, reject) =>
        _isEventValid(event) && _checkIfFieldIsValid(validFieldNames, event.target.dataset.fieldName) ?
            resolve(event) : reject('Change field event is invalid.'));
}

function _reduceLightningInputs(accumulator, currentField) {
    return accumulator && currentField.checkValidity();
}

function areLightningInputsValid(inputs = []) {
    return inputs.reduce(_reduceLightningInputs, true);
}

function showErrorMessagesForLightningInputs(inputs = []) {
    inputs.forEach((input) => input.reportValidity());
}

function resetLightningInputsErrorsMessages(inputs = []) {
    inputs.forEach((input) => {
        input.setCustomValidity('');
        input.showHelpMessageIfInvalid();
    });
}

function checkIfAllInputsHaveClassAssigned(inputs = [], className){
    return inputs.reduce((acc, current) =>  acc && current.classList.contains(className),true);
}

function selectElements(component,selector){
    return component.shadowRoot.querySelectorAll(selector);
}

function selectElement(component,selector){
    return component.shadowRoot.querySelector(selector);
}

export {
    areLightningInputsValid,
    canFieldBeSaved,
    checkIfAllInputsHaveClassAssigned,
    resetLightningInputsErrorsMessages,
    selectElement,
    selectElements,    
    showErrorMessagesForLightningInputs   
};