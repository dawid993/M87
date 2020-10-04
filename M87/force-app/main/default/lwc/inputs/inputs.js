import { Either } from 'c/jsFunctional';

function checkIfFieldIsValid(validFieldNames, fieldName) {
    return validFieldNames.some(currentName => currentName === fieldName);
}

function isEventValid(event){
    return event && event.target && event.target.dataset && event.target.dataset.fieldName;
}

function canFieldBeSaved(validFieldNames = [], event) {   
    return Either((resolve, reject) => isEventValid(event) ? resolve(event) : reject('Change field event is invalid.'))
        .then(event => checkIfFieldIsValid(validFieldNames, event.target.dataset.fieldName));
}

function reduceLightningInputs(accumulator, currentField) {
    return accumulator && currentField.checkValidity();
}

function areLightningInputsValid(inputs = []) {
    return inputs.reduce(reduceLightningInputs,true);
}

export { canFieldBeSaved, areLightningInputsValid };