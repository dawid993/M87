import searchForUsernameOrEmail from '@salesforce/apex/CommunityUserCreationController.searchForUsernameOrEmail';


export default class UserCreationValidator {

    validate(formInputs) {
        return new Promise((resolve, reject) => {
            const validationResults = formInputs.map(currentInput => this._createValidationResult(
                currentInput.dataset.fieldName,
                currentInput.checkValidity()
            ));

            const [emailInputResult, userNameInputResult] = this._findEmailAndUsernameInputs(validationResults);

            if (emailInputResult.isFieldValid || userNameInputResult.isFieldValid) {
                const apexPromise = searchForUsernameOrEmail(this._getInputParam(formInputs))
                    .then(result => {
                        emailInputResult.isApexValidationFailed = !result.success || result.detailedResult.emailCount > 0;
                        userNameInputResult.isApexValidationFailed = !result.success || result.detailedResult.usernameCount > 0;
                        return validationResults;
                    });
                    
                resolve(apexPromise);
            }

            resolve(validationResults);
        });
    }

    _findEmailAndUsernameInputs(validationResults) {
        return [
            validationResults.find(result => result.inputName === 'email'),
            validationResults.find(result => result.inputName === 'userName')
        ];
    }
    
    _createValidationResult(inputName, isFieldValid, isApexValidationFailed = false) {
        return {
            inputName,
            isFieldValid,
            isApexValidationFailed
        }
    }

    _getInputParam(inputs) {
        const email = inputs.find(input => input.dataset.fieldName === 'email');
        const username = inputs.find(input => input.dataset.fieldName === 'userName');

        return { 'username': username.value, 'email': email.value };
    }
}